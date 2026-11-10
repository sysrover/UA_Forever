local _, addon_table = ...
local profiler = addon_table.use("performance_profile")

local current, driver
local MAX_LABELS, MAX_DEPTH, MAX_SLOW_CALLS, MAX_SLOW_INTERVALS = 4096, 128, 64, 32
local frame_counts = {}
local now = function () return _G.debugprofilestop() end

local function secret(value)
    if type(_G.issecretvalue) ~= "function" then return false end
    local ok, result = pcall(_G.issecretvalue, value)
    return not ok or result == true
end

local function public_string(value)
    if not secret(value) and type(value) == "string" then return value end
end

local function public_number(value)
    if not secret(value) and type(value) == "number" then return value end
end

local function context()
    local tooltip = _G.GameTooltip
    if not tooltip then return {} end
    local ok, kind, id = pcall(function ()
        return tooltip.uaForeverKind, tooltip.uaForeverID or tooltip.uaForeverItemID
    end)
    return ok and { kind = public_string(kind), id = public_number(id) } or {}
end

local function retain_slowest(list, entry, limit, field)
    if #list < limit then list[#list + 1] = entry; return end
    local smallest = 1
    for index = 2, #list do
        if list[index][field] < list[smallest][field] then smallest = index end
    end
    if entry[field] > list[smallest][field] then list[smallest] = entry end
end

local function finish(session, frame, ok, ...)
    local finished = now()
    session.depth = session.depth - 1
    if current == session then
        local report, row = session.report, frame.row
        local elapsed = finished - frame.started
        if elapsed < 0 then report.clockResets = report.clockResets + 1; elapsed = 0 end
        local inclusive = math.max(0, elapsed - frame.descendantOverhead)
        local exclusive = math.max(0, elapsed - frame.childrenSpan)
        row.calls = row.calls + 1
        row.totalMs = row.totalMs + inclusive
        row.selfMs = row.selfMs + exclusive
        row.maxMs = math.max(row.maxMs, inclusive)
        row.maxSelfMs = math.max(row.maxSelfMs, exclusive)
        if row.calls == 1 then row.firstMs, row.firstSelfMs = inclusive, exclusive end
        if not ok then row.errors = row.errors + 1 end
        if inclusive > 5 then row.over5ms = row.over5ms + 1 end
        if inclusive > 16 then row.over16ms = row.over16ms + 1 end
        if inclusive > 50 then row.over50ms = row.over50ms + 1 end
        if session.depth == 0 then
            local interval = session.interval
            interval.calls = interval.calls + 1
            interval.totalMs = interval.totalMs + inclusive
            if inclusive > interval.maxMs then
                interval.maxMs, interval.label = inclusive, frame.label
            end
            if inclusive > 5 then
                retain_slowest(report.slowCalls, { label = frame.label,
                    elapsedMs = inclusive, atMs = math.max(0, finished - session.started),
                    context = context(), error = not ok }, MAX_SLOW_CALLS, "elapsedMs")
            end
        end
        local leaving = now()
        local overhead = math.max(0, frame.started - frame.entered)
            + math.max(0, leaving - finished)
        report.instrumentationMs = report.instrumentationMs + overhead
        session.interval.overheadMs = session.interval.overheadMs + overhead
        local parent = session.stack[session.depth]
        if session.depth > 0 and parent then
            parent.childrenSpan = parent.childrenSpan + math.max(0, leaving - frame.entered)
            parent.descendantOverhead = parent.descendantOverhead + overhead + frame.descendantOverhead
        end
    end
    if not ok then error((...), 0) end
    return ...
end

-- Continuations preserve every return value, including trailing nils, without
-- allocating a packed-results table for every instrumented call.
local function call_profiled(label, callback, entered, ...)
    local session = current
    if not session then return callback(...) end
    entered = entered or now()
    if session.depth >= MAX_DEPTH then
        session.report.depthDrops = session.report.depthDrops + 1
        return callback(...)
    end
    local report = session.report
    local row = report.calls[label]
    if not row then
        if report.labelCount >= MAX_LABELS then
            label = "<label-limit>"
            report.labelDrops = report.labelDrops + 1
            row = report.calls[label]
        end
        if not row then
            row = { calls = 0, totalMs = 0, selfMs = 0, maxMs = 0,
                maxSelfMs = 0, errors = 0, over5ms = 0, over16ms = 0, over50ms = 0 }
            report.calls[label] = row
            report.labelCount = report.labelCount + 1
        end
    end
    session.depth = session.depth + 1
    local frame = session.stack[session.depth]
    if not frame then frame = {}; session.stack[session.depth] = frame end
    frame.row, frame.label, frame.entered = row, label, entered
    frame.childrenSpan, frame.descendantOverhead = 0, 0
    frame.started = now()
    return finish(session, frame, pcall(callback, ...))
end

profiler.call = function (label, callback, ...)
    if not current then return callback(...) end
    local entered = now()
    return call_profiled(public_string(label) or "unknown", callback, entered, ...)
end

profiler.wrap = function (label, callback, event_index)
    if type(callback) ~= "function" then return callback end
    label = public_string(label) or "unknown"
    return function (...)
        if not current then return callback(...) end
        local key = label
        if event_index and event_index <= select("#", ...) then
            local event = public_string(select(event_index, ...))
            if event then
                key = label .. ":" .. event:sub(1, 80)
                if event == "ADDON_LOADED" and event_index < select("#", ...) then
                    local addon = public_string(select(event_index + 1, ...))
                    if addon then key = key .. ":" .. addon:sub(1, 80) end
                end
            end
        end
        return call_profiled(key, callback, nil, ...)
    end
end

-- Only addon-created frames use this factory. Shared Blizzard frame methods
-- and other addons' callbacks are never replaced by the collector.
profiler.frame_factory = function (owner)
    return function (...)
        local frame = _G.CreateFrame(...)
        frame_counts[owner] = (frame_counts[owner] or 0) + 1
        local label = "frame:" .. owner .. ":" .. math.min(frame_counts[owner], 512)
        local set_script, hook_script = frame.SetScript, frame.HookScript
        local slots = {}
        if type(set_script) == "function" then
            frame.SetScript = function (self, script, callback)
                local slot = slots[script]
                if not slot or slot.original ~= callback then
                    slot = { original = callback,
                        wrapped = profiler.wrap(label .. ":" .. script, callback,
                            script == "OnEvent" and 2 or nil) }
                    slots[script] = slot
                end
                return set_script(self, script, slot.wrapped)
            end
        end
        if type(hook_script) == "function" then
            frame.HookScript = function (self, script, callback)
                return hook_script(self, script, profiler.wrap(label .. ":hook:" .. script,
                    callback, script == "OnEvent" and 2 or nil))
            end
        end
        return frame
    end
end

local function instrument_modules(session)
    addon_table.each_module(function (name, module)
        if name == "performance_profile" then return end
        session.report.coverage.modules[name] = true
        for key, callback in pairs(module) do
            if type(key) == "string" and type(callback) == "function" then
                local wrapped = profiler.wrap("module:" .. name .. "." .. key, callback)
                session.replacements[#session.replacements + 1] = {
                    module = module, key = key, original = callback, wrapped = wrapped }
                module[key] = wrapped
            end
        end
    end)
    session.report.coverage.exportedFunctions = #session.replacements
end

local function native_snapshot()
    local runtime = addon_table.use("translation_runtime")
    local result = type(runtime.capture_native_profiler) == "function"
        and runtime.capture_native_profiler() or { available = false }
    local api, metrics = _G.C_AddOnProfiler, _G.Enum and _G.Enum.AddOnProfilerMetric
    if api and metrics then
        for _, name in ipairs({ "GetOverallMetric", "GetApplicationMetric" }) do
            if type(api[name]) == "function" then
                local values = {}
                for _, metric in ipairs({ "RecentAverageTime", "PeakTime", "CountTimeOver5Ms",
                    "CountTimeOver10Ms", "CountTimeOver50Ms", "CountTimeOver100Ms" }) do
                    if metrics[metric] ~= nil then
                        local ok, value = pcall(api[name], metrics[metric])
                        if ok then values[metric] = public_number(value) end
                    end
                end
                result[name] = values
            end
        end
    end
    return result
end

local function reset_interval(interval)
    interval.calls, interval.totalMs, interval.maxMs, interval.overheadMs = 0, 0, 0, 0
    interval.label = nil
end

local function sample_frame(_, elapsed)
    local session = current
    if not session then return end
    local started, report, interval = now(), session.report, session.interval
    if session.skipFirstFrame then
        session.skipFirstFrame = nil
        reset_interval(interval)
        return
    end
    elapsed = public_number(elapsed)
    if elapsed then
        local ms, frames = elapsed * 1000, report.frames
        frames.count = frames.count + 1
        frames.totalMs = frames.totalMs + ms
        frames.maxMs = math.max(frames.maxMs, ms)
        if ms > 33 then frames.over33ms = frames.over33ms + 1 end
        if ms > 50 then frames.over50ms = frames.over50ms + 1 end
        local heap, drop
        if started >= (session.nextHeapAt or 0) and type(_G.collectgarbage) == "function" then
            session.nextHeapAt = started + 100
            local ok, value = pcall(_G.collectgarbage, "count")
            heap = ok and public_number(value) or nil
            if heap then
                frames.minHeapKB = math.min(frames.minHeapKB or heap, heap)
                frames.maxHeapKB = math.max(frames.maxHeapKB or heap, heap)
                if frames.lastHeapKB and heap < frames.lastHeapKB then
                    drop = frames.lastHeapKB - heap
                    frames.heapDrops = (frames.heapDrops or 0) + 1
                end
                frames.lastHeapKB = heap
                frames.heapSampleAtMs = math.max(0, started - session.started)
            end
        end
        if ms > 33 or interval.maxMs > 5 then
            retain_slowest(report.slowIntervals, { frameMs = ms, heapKB = frames.lastHeapKB,
                heapSampleAtMs = frames.heapSampleAtMs,
                heapDropKB = drop, callbackMs = interval.totalMs,
                calls = interval.calls, topCall = interval.label, topCallMs = interval.maxMs,
                instrumentationMs = interval.overheadMs, context = context(),
                atMs = math.max(0, started - session.started) }, MAX_SLOW_INTERVALS, "frameMs")
        end
        reset_interval(interval)
    end
    report.collectorMs = report.collectorMs + math.max(0, now() - started)
    local seconds = type(_G.GetTime) == "function" and _G.GetTime() - session.startedSeconds
        or (now() - session.started) / 1000
    if seconds >= session.seconds then profiler.stop("timeout") end
end

profiler.start = function (seconds, on_saved)
    if current then return false, "active" end
    if type(_G.debugprofilestop) ~= "function" or type(_G.CreateFrame) ~= "function"
        or type(addon_table.each_module) ~= "function" then return false, "unavailable" end
    if addon_table.use("translation_runtime").tooltip_profile_active then return false, "active" end
    if type(seconds) ~= "number" or seconds ~= seconds or seconds < 5 or seconds > 120 then
        return false, "duration"
    end
    local setup_started = now()
    local options, utils = addon_table.use("options"), addon_table.use("utils")
    local account = options.account or {}
    local report = { version = 1, patch = "addon-profile-all-shift-layout-2026-11-10", status = "recording",
        requestedSeconds = seconds, build = utils.build_version, buildNumber = utils.build_number,
        calls = {}, labelCount = 0, labelDrops = 0, depthDrops = 0, clockResets = 0,
        instrumentationMs = 0, collectorMs = 0, slowCalls = {}, slowIntervals = {},
        nestedTimesOverlap = true, selfTimeIsAdditive = true,
        frameAttribution = "callbacks between collector ticks; not an exact frame boundary",
        localFunctions = "included in nearest measured caller; not individually enumerated",
        firstCallMeaning = "first completed call in this capture; ADDON_LOADED labels identify module loads",
        heapSamplePeriodMs = 100,
        coverage = { modules = {}, exportedFunctions = 0 },
        frames = { count = 0, totalMs = 0, maxMs = 0, over33ms = 0, over50ms = 0 },
        settings = { enabled = account.enabled, dev = account.dev_mode,
            diagnostics = account.auto_scan_diagnostics, autoscan = account.auto_scan_content,
            fonts = account.override_system_fonts, fojji = account.translate_fojji,
            language = account.tooltip_language_mode }, nativeBefore = native_snapshot() }
    report.integration = { fojjiNamespace = type(_G.FojjiCoreNS) == "table" }
    report.tooltipTypes = {}
    local types = _G.Enum and _G.Enum.TooltipDataType
    for name, value in pairs(types or {}) do
        if public_string(name) and public_number(value) then report.tooltipTypes[value] = name end
    end
    if not driver then
        driver = _G.CreateFrame("Frame")
        driver:Hide()
        driver:SetScript("OnUpdate", sample_frame)
    end
    local session = { report = report, replacements = {}, stack = {}, depth = 0,
        interval = {}, seconds = seconds, on_saved = on_saved, skipFirstFrame = true,
        started = now(), startedSeconds = type(_G.GetTime) == "function" and _G.GetTime() or 0 }
    reset_interval(session.interval)
    instrument_modules(session)
    session.started = now()
    session.startedSeconds = type(_G.GetTime) == "function" and _G.GetTime() or 0
    report.setupMs = math.max(0, session.started - setup_started)
    current, profiler.active = session, true
    driver:Show()
    return true
end

profiler.stop = function (reason)
    local session = current
    if not session then return nil, "inactive" end
    current, profiler.active = nil, false
    if driver then driver:Hide() end
    for index = #session.replacements, 1, -1 do
        local replacement = session.replacements[index]
        if replacement.module[replacement.key] == replacement.wrapped then
            replacement.module[replacement.key] = replacement.original
        end
    end
    local report = session.report
    report.status, report.stopReason = "complete", reason or "manual"
    report.durationMs = type(_G.GetTime) == "function"
        and math.max(0, (_G.GetTime() - session.startedSeconds) * 1000)
        or math.max(0, now() - session.started)
    report.nativeAfter = native_snapshot()
    local ranked = {}
    for label, row in pairs(report.calls) do
        ranked[#ranked + 1] = { label = label, calls = row.calls, selfMs = row.selfMs,
            totalMs = row.totalMs, maxMs = row.maxMs, firstMs = row.firstMs }
    end
    table.sort(ranked, function (left, right) return left.selfMs > right.selfMs end)
    report.topSelf = {}
    for index = 1, math.min(20, #ranked) do report.topSelf[index] = ranked[index] end
    if type(session.on_saved) == "function" then session.on_saved(report) end
    return report
end
