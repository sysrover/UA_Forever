local _, addon_table = ...
local walker = addon_table.use("translation_walker")
local auto_scan = addon_table.use("auto_scan")
local profiler = addon_table.use("performance_profile")
local count_frames = profiler.counter and profiler.counter("walk.frames") or function () end
local count_regions = profiler.counter and profiler.counter("walk.regions") or function () end

local function valid_metadata(metadata)
    if type(metadata) ~= "table" then return false end
    for _, key in ipairs({ "id", "surface", "owner", "reason" }) do
        if type(metadata[key]) ~= "string" or metadata[key] == "" then
            return false
        end
    end
    return true
end

walker.walk = function (metadata, root, visit_region, skip_frame, stats, seen)
    if not valid_metadata(metadata) then
        return nil, "WALKER_METADATA_REQUIRED"
    end
    local started, overhead, writes_before
    if profiler.active then started, overhead, writes_before = profiler.begin_span() end
    local previous_frames, previous_translated = stats.frames, stats.translated or 0
    local region_count = 0
    local walk_truncated = false
    if type(auto_scan.record_compatibility_fallback) == "function" then
        auto_scan.record_compatibility_fallback(metadata.reason,
            metadata.surface .. ":" .. metadata.owner .. ":" .. metadata.id)
    end
    local max_nodes = tonumber(metadata.max_nodes) or 1000
    max_nodes = math.max(1, math.min(math.floor(max_nodes), 5000))
    seen = seen or {}
    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 20
            or (skip_frame and skip_frame(frame)) then return end
        if stats.frames >= max_nodes then
            stats.truncated = true
            walk_truncated = true
            return
        end
        seen[frame] = true
        stats.frames = stats.frames + 1
        if frame.GetRegions then
            local ok, regions = pcall(function () return { frame:GetRegions() } end)
            if ok then
                for _, region in ipairs(regions) do
                    if started then region_count = region_count + 1 end
                    visit_region(region)
                end
            end
        end
        if frame.GetChildren then
            local ok, children = pcall(function () return { frame:GetChildren() } end)
            if ok then
                for _, child in ipairs(children) do
                    local shown_ok, shown = pcall(child.IsShown, child)
                    if shown_ok and shown then visit(child, depth + 1) end
                end
            end
        end
    end
    visit(root, 1)
    if started then
        local frames = stats.frames - previous_frames
        local elapsed = profiler.elapsed_span(started, overhead)
        count_frames(frames)
        count_regions(region_count)
        profiler.record_walk(metadata, root, frames, region_count,
            (stats.translated or 0) - previous_translated, walk_truncated, elapsed, writes_before)
    end
    return stats
end
