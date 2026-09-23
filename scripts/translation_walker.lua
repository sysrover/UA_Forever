local _, addon_table = ...
local walker = addon_table.use("translation_walker")

walker.walk = function (root, visit_region, skip_frame, stats, seen)
    seen = seen or {}
    local function visit(frame, depth)
        if not frame or seen[frame] or depth > 20
            or (skip_frame and skip_frame(frame)) then return end
        seen[frame] = true
        stats.frames = stats.frames + 1
        if frame.GetRegions then
            local ok, regions = pcall(function () return { frame:GetRegions() } end)
            if ok then
                for _, region in ipairs(regions) do visit_region(region) end
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
end
