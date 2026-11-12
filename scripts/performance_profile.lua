local addon_name, addon_table = ...
local profiler = addon_table.use("performance_profile")

local current, driver
local MAX_LABELS, MAX_DEPTH, MAX_SLOW_CALLS, MAX_SLOW_INTERVALS = 4096, 128, 64, 32
local MAX_INTERVAL_CALLS, MAX_COUNTERS, MAX_WALKS = 12, 128, 128
local instrument_modules
local frame_counts = {}
local capture_listeners, capture_listener_order = {}, {}
local owned_frame_scripts = setmetatable({}, { __mode = "kv" })
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

-- Local hot-path functions opt into instrumentation only for a manual
-- capture. Registering a listener does no sampling or timer work.
profiler.on_capture = function (id, callback)
    id = public_string(id)
    if not id or type(callback) ~= "function" then return false end
    if not capture_listeners[id] then
        if #capture_listener_order >= 32 then return false end
        capture_listener_order[#capture_listener_order + 1] = id
    end
    capture_listeners[id] = callback
    if current then
        local ok = pcall(callback, true)
        if not ok then pcall(callback, false); return false end
    end
    return true
end

local function notify_capture(active)
    local failures = 0
    for _, id in ipairs(capture_listener_order) do
        if not pcall(capture_listeners[id], active) then failures = failures + 1 end
    end
    return failures
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
    if #list < limit then list[#list + 1] = entry; return true, "inserted" end
    local smallest = 1
    for index = 2, #list do
        if list[index][field] < list[smallest][field] then smallest = index end
    end
    if entry[field] > list[smallest][field] then list[smallest] = entry; return true, "replaced" end
    return false, "dropped"
end

-- Charge diagnostic bookkeeping to overhead, including when called inside a
-- measured export. Do not attribute it to the caller's inclusive or self time.
local function diagnostic_overhead(session, started)
    local elapsed = math.max(0, now() - started)
    session.report.instrumentationMs = session.report.instrumentationMs + elapsed
    session.interval.overheadMs = session.interval.overheadMs + elapsed
    local frame = session.stack[session.depth]
    if frame and session.depth > 0 then
        frame.childrenSpan = frame.childrenSpan + elapsed
        frame.descendantOverhead = frame.descendantOverhead + elapsed
    end
end

-- Fixed counter labels are checked at registration, never against UI text.
-- Closures remain inert outside an explicit capture and are not module exports.
profiler.counter = function (label)
    label = public_string(label)
    if not label then return function () end end
    label = label:sub(1, 120)
    return function (amount)
        local session = current
        if not session then return end
        local started = now()
        amount = amount == nil and 1 or public_number(amount)
        if amount and amount == amount and amount >= 0 and amount < math.huge then
            local report, work = session.report, session.interval.work
            if report.work[label] ~= nil or report.counterCount < MAX_COUNTERS then
                if report.work[label] == nil then report.counterCount = report.counterCount + 1 end
                report.work[label] = (report.work[label] or 0) + amount
                work[label] = (work[label] or 0) + amount
            else
                report.counterDrops = report.counterDrops + 1
            end
        end
        diagnostic_overhead(session, started)
    end
end

-- One bookkeeping span for an attempted setter and its pcall outcome. Labels
-- are fixed at registration; callers preserve the complete pcall return tuple.
local function increment_work(session, label)
    local report, work = session.report, session.interval.work
    if report.work[label] ~= nil or report.counterCount < MAX_COUNTERS then
        if report.work[label] == nil then report.counterCount = report.counterCount + 1 end
        report.work[label] = (report.work[label] or 0) + 1
        work[label] = (work[label] or 0) + 1
    else report.counterDrops = report.counterDrops + 1 end
end

profiler.write_counter = function (prefix)
    prefix = public_string(prefix)
    if not prefix then return function () end end
    prefix = prefix:sub(1, 100)
    local attempt, success, failure = prefix .. ".attempt", prefix .. ".success", prefix .. ".failure"
    return function (ok)
        local session = current
        if not session then return end
        local started = now()
        increment_work(session, attempt)
        increment_work(session, ok and success or failure)
        diagnostic_overhead(session, started)
    end
end

local layout_properties = { SetWidth = true, SetHeight = true, SetMaxLines = true,
    SetWordWrap = true, SetNonSpaceWrap = true, ClearAllPoints = true, SetPoint = true }
profiler.record_layout_writes = function (tooltip, counts)
    local session = current
    if not session then return end
    local started, report = now(), session.report
    local ok, name, kind, original = pcall(function ()
        return tooltip:GetName(), tooltip.uaForeverKind, tooltip.uaForeverShowOriginal
    end)
    name, kind = ok and public_string(name), ok and public_string(kind)
    if name and kind and not secret(original) then
        local key = name:sub(1, 80) .. ":" .. kind:sub(1, 40) .. (original and ":original" or ":translated")
        local row = report.layoutWrites[key]
        if not row and report.layoutWriteCount < 64 then
            row = {}; report.layoutWrites[key] = row; report.layoutWriteCount = report.layoutWriteCount + 1
        end
        if row then
            for property in pairs(layout_properties) do
                local count = public_number(counts[property])
                if count and count > 0 and count < math.huge then row[property] = (row[property] or 0) + count end
            end
        end
    end
    diagnostic_overhead(session, started)
end

profiler.begin_span = function ()
    if current then return now(), current.report.instrumentationMs,
        current.report.work["text.write.success"] or 0,
        current.report.work["layout.write.success"] or 0 end
end

profiler.elapsed_span = function (started, overhead)
    if current and started then
        return math.max(0, now() - started - (current.report.instrumentationMs - overhead))
    end
    return 0
end

profiler.record_walk = function (metadata, root, frames, regions, translated, truncated, elapsed, writes_before)
    local session = current
    if not session then return end
    local started, report = now(), session.report
    local id = public_string(metadata.id)
    local ok, name = pcall(function ()
        return type(root.GetName) == "function" and root:GetName() or nil
    end)
    name = ok and public_string(name) or nil
    local key = (id or "unknown"):sub(1, 100) .. ":" .. (name or "<unnamed>"):sub(1, 100)
    local row = report.walks[key]
    if not row and report.walkCount < MAX_WALKS then
        row = { calls = 0, frames = 0, regions = 0, translatedResults = 0, textWrites = 0,
            truncated = 0, totalMs = 0, maxMs = 0 }
        report.walks[key] = row
        report.walkCount = report.walkCount + 1
    end
    if row then
        row.calls = row.calls + 1
        row.frames, row.regions = row.frames + frames, row.regions + regions
        row.translatedResults = row.translatedResults + translated
        row.textWrites = row.textWrites + math.max(0,
            (report.work["text.write.success"] or 0) - (writes_before or 0))
        row.truncated = row.truncated + (truncated and 1 or 0)
        row.totalMs, row.maxMs = row.totalMs + elapsed, math.max(row.maxMs, elapsed)
    else
        report.walkDrops = report.walkDrops + 1
    end
    diagnostic_overhead(session, started)
end

-- Only structural identifiers and fixed branch reasons enter this summary;
-- text, source strings, error messages and pooled owner objects stay out.
profiler.record_layout = function (tooltip, stage, success, reason, elapsed, writes_before)
    local session = current
    if not session then return end
    local started, report = now(), session.report
    stage, reason = public_string(stage), public_string(reason)
    elapsed = public_number(elapsed) or 0
    if stage ~= "measure" and stage ~= "reapply" and stage ~= "build"
        and stage ~= "skip" and stage ~= "defer" then
        diagnostic_overhead(session, started)
        return
    end
    if reason then reason = reason:sub(1, 80) end
    if elapsed ~= elapsed or elapsed < 0 or elapsed == math.huge then elapsed = 0 end
    local ok, name, kind, original = pcall(function ()
        return tooltip:GetName(), tooltip.uaForeverKind, tooltip.uaForeverShowOriginal
    end)
    name, kind = ok and public_string(name), ok and public_string(kind)
    -- Clear/build notifications precede the new data kind and text-mode sync.
    -- Do not attribute a new build to the previous pooled tooltip session.
    if stage == "build" then kind, original = "native-boundary", false end
    if not secret(original) and name and kind then
        local key = name:sub(1, 80) .. ":" .. kind:sub(1, 40)
            .. (stage == "build" and "" or original == true and ":original" or ":translated")
        local row = report.layouts[key]
        if not row and report.layoutCount < 64 then
            row = { stages = {}, reasons = {}, reasonCount = 0 }
            report.layouts[key] = row
            report.layoutCount = report.layoutCount + 1
        end
        if row then
            local sample = row.stages[stage]
            if not sample then
                sample = { calls = 0, success = 0, failure = 0, totalMs = 0, maxMs = 0, setterCalls = 0 }
                row.stages[stage] = sample
            end
            sample.calls = sample.calls + 1
            if not secret(success) then
                if success == true then sample.success = sample.success + 1
                elseif success == false then sample.failure = sample.failure + 1 end
            end
            sample.totalMs, sample.maxMs = sample.totalMs + elapsed, math.max(sample.maxMs, elapsed)
            if writes_before then
                sample.setterCalls = sample.setterCalls + math.max(0,
                    (report.work["layout.write.success"] or 0) - writes_before)
            end
            if reason and (row.reasons[reason] or row.reasonCount < 32) then
                if not row.reasons[reason] then row.reasonCount = row.reasonCount + 1 end
                row.reasons[reason] = (row.reasons[reason] or 0) + 1
            end
        else
            report.layoutDrops = report.layoutDrops + 1
        end
    end
    diagnostic_overhead(session, started)
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
        local interval = session.interval
        local sample = interval.byLabel[frame.label]
        if not sample then
            sample = { label = frame.label, calls = 0, selfMs = 0, totalMs = 0, maxMs = 0 }
            interval.byLabel[frame.label] = sample
        end
        if sample.calls == 0 then interval.touched[#interval.touched + 1] = sample end
        sample.calls = sample.calls + 1
        sample.selfMs, sample.totalMs = sample.selfMs + exclusive, sample.totalMs + inclusive
        sample.maxMs = math.max(sample.maxMs, inclusive)
        interval.totalCalls, interval.selfMs = interval.totalCalls + 1, interval.selfMs + exclusive
        if session.depth == 0 then
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

local function finish_load(session, ...)
    if current == session then
        local started = now()
        instrument_modules(session)
        diagnostic_overhead(session, started)
    end
    return ...
end

-- Continuations preserve every return value, including trailing nils, without
-- allocating a packed-results table for every instrumented call.
local function call_record(session, label)
    local records = session.callRecords
    if not records then records = {}; session.callRecords = records end
    if records[label] then return records[label] end
    local report = session.report
    local row = report.calls[label]
    if not row then
        if report.labelCount >= MAX_LABELS then
            label = "<label-limit>"
            row = report.calls[label]
        end
        if not row then
            row = { calls = 0, totalMs = 0, selfMs = 0, maxMs = 0,
                maxSelfMs = 0, errors = 0, over5ms = 0, over16ms = 0, over50ms = 0 }
            report.calls[label] = row
            report.labelCount = report.labelCount + 1
        end
    end
    local record = records[label] or { row = row, label = label }
    records[label] = record
    return record
end

local function call_profiled(label, callback, entered, record, ...)
    local session = current
    if not session then return callback(...) end
    entered = entered or now()
    if session.depth >= MAX_DEPTH then
        session.report.depthDrops = session.report.depthDrops + 1
        return callback(...)
    end
    record = record or call_record(session, label)
    if record.label == "<label-limit>" then session.report.labelDrops = session.report.labelDrops + 1 end
    local row = record.row
    label = record.label
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
    return call_profiled(public_string(label) or "unknown", callback, entered, nil, ...)
end

profiler.wrap = function (label, callback, event_index)
    if type(callback) ~= "function" then return callback end
    label = public_string(label) or "unknown"
    local bound_token, record
    return function (...)
        if not current then return callback(...) end
        if not event_index then
            local entered = now()
            current.recordToken = current.recordToken or {}
            if bound_token ~= current.recordToken then
                bound_token, record = current.recordToken, call_record(current, label)
            end
            return call_profiled(label, callback, entered, record, ...)
        end
        local key, module_load = label, false
        if event_index and event_index <= select("#", ...) then
            local event = public_string(select(event_index, ...))
            if event then
                key = label .. ":" .. event:sub(1, 80)
                if event == "ADDON_LOADED" and event_index < select("#", ...) then
                    local addon = public_string(select(event_index + 1, ...))
                    if addon then key = key .. ":" .. addon:sub(1, 80) end
                    module_load = true
                end
            end
        end
        if module_load then return finish_load(current, call_profiled(key, callback, nil, nil, ...)) end
        return call_profiled(key, callback, nil, nil, ...)
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
        local script_state = { slots = slots, set_script = set_script }
        owned_frame_scripts[frame] = script_state
        -- The frame's registration methods retain its slots; the inventory
        -- holds neither a frame nor its callback graph alive on its own.
        if type(set_script) == "function" then
            frame.SetScript = function (self, script, callback)
                local slot = script_state.slots[script]
                if slot and slot.wrapped and callback == slot.wrapped then callback = slot.original end
                if not slot or slot.original ~= callback then
                    slot = { original = callback, label = label .. ":" .. script,
                        event_index = script == "OnEvent" and 2 or nil }
                    script_state.slots[script] = slot
                end
                if current and type(callback) == "function" then
                    slot.wrapped = slot.wrapped or profiler.wrap(slot.label, callback, slot.event_index)
                    return set_script(self, script, slot.wrapped)
                end
                return set_script(self, script, callback)
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

profiler.on_capture("owned-frame-scripts", function (active)
    for frame, state in pairs(owned_frame_scripts) do
        for script, slot in pairs(state.slots) do
            if type(slot.original) == "function" then
                local ok, installed = pcall(function () return frame:GetScript(script) end)
                if ok and not secret(installed) then
                    if active and installed == slot.original then
                        slot.wrapped = slot.wrapped or profiler.wrap(slot.label, slot.original, slot.event_index)
                        pcall(state.set_script, frame, script, slot.wrapped)
                    elseif not active and slot.wrapped and installed == slot.wrapped then
                        pcall(state.set_script, frame, script, slot.original)
                    end
                end
            end
        end
    end
end)

instrument_modules = function (session)
    addon_table.each_module(function (name, module)
        if name == "performance_profile" then return end
        session.report.coverage.modules[name] = true
        local slots = session.exportSlots[module]
        if not slots then slots = {}; session.exportSlots[module] = slots end
        for key, callback in pairs(module) do
            if type(key) == "string" and type(callback) == "function" then
                local previous = slots[key]
                if (not previous or callback ~= previous.wrapped) and #session.replacements < MAX_LABELS then
                    -- Keep each version in restoration order: a later replacement
                    -- must restore to itself, never to an obsolete implementation.
                    local wrapped = profiler.wrap("module:" .. name .. "." .. key, callback)
                    local replacement = { module = module, key = key, original = callback, wrapped = wrapped }
                    session.replacements[#session.replacements + 1] = replacement
                    slots[key], module[key] = replacement, wrapped
                end
            end
        end
    end)
    session.report.coverage.exportedFunctions = #session.replacements
    session.report.coverage.exportScans = session.report.coverage.exportScans + 1
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
    interval.totalCalls, interval.selfMs = 0, 0
    interval.byLabel, interval.touched = interval.byLabel or {}, interval.touched or {}
    for index, row in ipairs(interval.touched) do
        row.calls, row.selfMs, row.totalMs, row.maxMs = 0, 0, 0, 0
        interval.touched[index] = nil
    end
    interval.work = interval.work or {}
    for key in pairs(interval.work) do interval.work[key] = nil end
    interval.label = nil
end

local function interval_details(interval, entry)
    local rows = {}
    for _, row in ipairs(interval.touched) do rows[#rows + 1] = row end
    table.sort(rows, function (a, b)
        if a.selfMs == b.selfMs then return a.label < b.label end
        return a.selfMs > b.selfMs
    end)
    entry.topCalls, entry.work = {}, {}
    local covered = 0
    for index = 1, math.min(MAX_INTERVAL_CALLS, #rows) do
        local row = rows[index]
        entry.topCalls[index] = { label = row.label, calls = row.calls,
            selfMs = row.selfMs, totalMs = row.totalMs, maxMs = row.maxMs }
        covered = covered + row.selfMs
    end
    entry.otherSelfMs = math.max(0, interval.selfMs - covered)
    for key, value in pairs(interval.work) do entry.work[key] = value end
end

local function sample_frame(_, elapsed)
    local session = current
    if not session then return end
    local started, report, interval = now(), session.report, session.interval
    if session.skipFirstFrame then
        session.skipFirstFrame = nil
        reset_interval(interval)
        session.intervalStarted = started
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
            local entry = { frameMs = ms, heapKB = frames.lastHeapKB,
                heapSampleAtMs = frames.heapSampleAtMs,
                heapDropKB = drop, callbackMs = interval.totalMs,
                calls = interval.calls, topCall = interval.label, topCallMs = interval.maxMs,
                totalCalls = interval.totalCalls, selfMs = interval.selfMs,
                instrumentationMs = interval.overheadMs, context = context(),
                atMs = math.max(0, started - session.started), frameIndex = frames.count,
                intervalStartMs = math.max(0, (session.intervalStarted or session.started) - session.started),
                intervalEndMs = math.max(0, started - session.started) }
            report.slowIntervalCandidates = report.slowIntervalCandidates + 1
            local retained, disposition = retain_slowest(report.slowIntervals, entry, MAX_SLOW_INTERVALS, "frameMs")
            if disposition == "replaced" then report.slowIntervalsReplaced = report.slowIntervalsReplaced + 1 end
            report.slowIntervalsOmitted = report.slowIntervalCandidates - #report.slowIntervals
            if retained then
                interval_details(interval, entry)
            end
        end
        reset_interval(interval)
        session.intervalStarted = started
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
    local report = { version = 2, patch = "addon-profile-ui-costs-2026-11-12", status = "recording",
        requestedSeconds = seconds, build = utils.build_version, buildNumber = utils.build_number,
        calls = {}, labelCount = 0, labelDrops = 0, depthDrops = 0, clockResets = 0,
        instrumentationMs = 0, collectorMs = 0, slowCalls = {}, slowIntervals = {},
        work = {}, counterCount = 0, counterDrops = 0,
        walks = {}, walkCount = 0, walkDrops = 0,
        layouts = {}, layoutCount = 0, layoutDrops = 0,
        layoutWrites = {}, layoutWriteCount = 0,
        layoutWriteMeaning = "cached replay setter attempts by property, tooltip and text mode",
        slowIntervalCandidates = 0, slowIntervalsOmitted = 0, slowIntervalsReplaced = 0,
        slowIntervalCandidateMeaning = "frameMs > 33 or a measured outer call > 5 ms; retention is bounded",
        nestedTimesOverlap = true, selfTimeIsAdditive = true,
        frameAttribution = "callbacks between collector ticks; not an exact frame boundary",
        contextMeaning = "current GameTooltip metadata; not the cause or owner of the interval",
        intervalTopLimit = MAX_INTERVAL_CALLS,
        walkMeaning = "inclusive walk time; translatedResults includes stable claims, not just writes",
        writeMeaning = "guarded setter calls in translation_runtime and completed tooltip layout; not proof of visible change",
        buildMeaning = "native.item-post counts Item post-calls; layout.build counts boundary notifications, which may repeat",
        exportRefreshPolicy = "start and successful observed ADDON_LOADED handlers; no continuous scan",
        codeIdentity = "addon metadata and profiler patch; no source hash available in game",
        localFunctions = "included in nearest measured caller; not individually enumerated",
        firstCallMeaning = "first completed call in this capture; ADDON_LOADED labels identify module loads",
        heapSamplePeriodMs = 100,
        coverage = { modules = {}, exportedFunctions = 0, exportScans = 0 },
        frames = { count = 0, totalMs = 0, maxMs = 0, over33ms = 0, over50ms = 0 },
        settings = { enabled = account.enabled, dev = account.dev_mode,
            diagnostics = account.auto_scan_diagnostics, autoscan = account.auto_scan_content,
            fonts = account.override_system_fonts, fojji = account.translate_fojji,
            language = account.tooltip_language_mode }, nativeBefore = native_snapshot() }
    local metadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
    if type(metadata) == "function" then
        local ok, value = pcall(metadata, addon_name, "Version")
        if ok then report.addonVersion = public_string(value) end
    end
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
    local session = { report = report, replacements = {}, exportSlots = {}, stack = {}, depth = 0,
        interval = {}, seconds = seconds, on_saved = on_saved, skipFirstFrame = true,
        started = now(), startedSeconds = type(_G.GetTime) == "function" and _G.GetTime() or 0 }
    reset_interval(session.interval)
    if notify_capture(true) > 0 then
        notify_capture(false)
        return false, "unavailable"
    end
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
    local unwrapped, unwrapped_labels = 0, {}
    addon_table.each_module(function (name, module)
        if name == "performance_profile" then return end
        local slots = session.exportSlots[module] or {}
        for key, callback in pairs(module) do
            if type(key) == "string" and type(callback) == "function"
                and (not slots[key] or slots[key].wrapped ~= callback) then
                unwrapped = unwrapped + 1
                if #unwrapped_labels < 64 and public_string(name) and public_string(key) then
                    unwrapped_labels[#unwrapped_labels + 1] = name:sub(1, 80) .. "." .. key:sub(1, 80)
                end
            end
        end
    end)
    session.report.coverage.unwrappedExportsAtStop = unwrapped
    session.report.coverage.unwrappedExports = unwrapped_labels
    for index = #session.replacements, 1, -1 do
        local replacement = session.replacements[index]
        if replacement.module[replacement.key] == replacement.wrapped then
            replacement.module[replacement.key] = replacement.original
        end
    end
    -- Restore exports first, then restore local direct-call functions. A
    -- listener must never mistake a temporary module wrapper for a new owner.
    session.report.captureRestoreErrors = notify_capture(false)
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
