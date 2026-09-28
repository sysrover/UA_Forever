local _, addon_table = ...
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")

local pending = {}
local scoped_pending = setmetatable({}, { __mode = "k" })
local scalar_scopes = {}
scheduler.MAX_RETRIES = 3

local function scope_bucket(surface, create)
    if surface == nil then return nil end
    local kind = type(surface)
    local buckets = (kind == "table" or kind == "userdata")
        and scoped_pending or scalar_scopes
    local key = buckets == scoped_pending and surface
        or kind .. ":" .. tostring(surface)
    local bucket = buckets[key]
    if not bucket and create then
        bucket = setmetatable({}, { __mode = "k" })
        buckets[key] = bucket
    end
    return bucket
end

local function cancel_handle(request)
    local handle = request.handle
    request.handle = nil
    if handle and type(handle.Cancel) == "function" then
        pcall(handle.Cancel, handle)
        runtime.metric("timers_cancelled", request.surface, request.generation)
    end
end

local function instance_requests(surface, instance, create)
    local bucket = scope_bucket(surface, create)
    if not bucket or instance == nil then return nil end
    local requests = bucket[instance]
    if not requests and create then
        requests = {}
        bucket[instance] = requests
    end
    return requests, bucket
end

local function detach(request, keep_timer)
    if pending[request.id] == request then pending[request.id] = nil end
    local requests, bucket
    if request.instance ~= nil then
        requests, bucket = instance_requests(request.surface,
            request.instance, false)
    end
    if requests and requests[request.task_kind] == request then
        requests[request.task_kind] = nil
        if next(requests) == nil then bucket[request.instance] = nil end
    end
    if not keep_timer then cancel_handle(request) end
end

local function attach(request)
    local previous = pending[request.id]
    if previous and previous ~= request then detach(previous) end
    pending[request.id] = request
    local requests = request.instance ~= nil
        and instance_requests(request.surface, request.instance, true) or nil
    if requests then
        previous = requests[request.task_kind]
        if previous and previous ~= request then detach(previous) end
        requests[request.task_kind] = request
    end
end

local function current(request)
    if pending[request.id] ~= request then return false end
    local requests = request.instance ~= nil
        and instance_requests(request.surface, request.instance, false) or nil
    return not requests or requests[request.task_kind] == request
end

scheduler.cancel = function (id)
    local request = pending[id]
    if request then detach(request) end
end

scheduler.cancel_instance = function (surface, instance, task_kind)
    local requests = instance_requests(surface, instance, false)
    if not requests then return false end
    local snapshot = {}
    if task_kind then
        if requests[task_kind] then snapshot[1] = requests[task_kind] end
    else
        for _, request in pairs(requests) do snapshot[#snapshot + 1] = request end
    end
    for _, request in ipairs(snapshot) do detach(request) end
    return #snapshot > 0
end

scheduler.cancel_surface = function (surface, task_kind)
    local bucket = scope_bucket(surface, false)
    if not bucket then return 0 end
    local snapshot, seen = {}, {}
    for _, requests in pairs(bucket) do
        for kind, request in pairs(requests) do
            if (not task_kind or kind == task_kind) and not seen[request] then
                seen[request] = true
                snapshot[#snapshot + 1] = request
            end
        end
    end
    for _, request in ipairs(snapshot) do detach(request) end
    return #snapshot
end

scheduler.request = function (id, generation, callback, delay, owner_surface)
    local spec
    if type(id) == "table" and generation == nil then
        spec = id
        id = spec.id
        generation = spec.generation
        callback = spec.callback
        delay = spec.delay
        owner_surface = spec.surface
    end
    if not id or type(callback) ~= "function" then return end
    local instance = spec and spec.instance
    local task_kind = spec and (spec.task_kind or spec.kind) or "default"
    local retries = spec and tonumber(spec.max_retries) or 0
    retries = math.max(0, math.min(math.floor(retries or 0), scheduler.MAX_RETRIES))
    local request = pending[id]
    if spec and owner_surface ~= nil and instance ~= nil then
        local requests = instance_requests(owner_surface, instance, false)
        request = requests and requests[task_kind] or request
    end
    if request then
        if request.generation == generation
            and request.surface == owner_surface
            and request.instance == instance
            and request.task_kind == task_kind then
            if request.id ~= id then
                if pending[request.id] == request then pending[request.id] = nil end
                request.id = id
                pending[id] = request
            end
            request.callback = callback
            request.max_retries = retries
            request.retry_delay = spec and spec.retry_delay or delay or 0
            return
        end
        detach(request)
    end
    request = { generation = generation, callback = callback,
        surface = owner_surface, instance = instance, id = id,
        task_kind = task_kind,
        max_retries = retries, retry_delay = spec and spec.retry_delay or delay or 0,
        attempt = 0 }
    attach(request)
    local function schedule(run, wait)
        runtime.metric("timers_created", request.surface, request.generation)
        if C_Timer and type(C_Timer.NewTimer) == "function" then
            local ok, handle = pcall(C_Timer.NewTimer, wait or 0, run)
            if ok then request.handle = handle return end
        end
        if C_Timer and type(C_Timer.After) == "function" then
            C_Timer.After(wait or 0, run)
        else
            run()
        end
    end
    local function run()
        request.handle = nil
        if not current(request) then
            runtime.metric("timers_dropped", request.surface, request.generation)
            return
        end
        local registry = addon_table.use("translation_registry")
        local surface = registry.get and registry.get(id)
        if surface and request.generation
            and surface.generation ~= request.generation then
            detach(request)
            runtime.metric("timers_dropped", request.surface, request.generation)
            return
        end
        if request.surface and request.generation
            and runtime.generation(request.surface) ~= request.generation then
            detach(request)
            runtime.metric("timers_dropped", request.surface, request.generation)
            return
        end
        detach(request, true)
        request.attempt = request.attempt + 1
        runtime.metric("timers_executed", request.surface, request.generation)
        local started = type(_G.debugprofilestop) == "function"
            and _G.debugprofilestop() or nil
        local retry = request.callback(request.attempt) == false
        if started then
            local finished = _G.debugprofilestop()
            if type(finished) == "number" then
                runtime.metric_duration("callback_ms", request.surface,
                    request.generation, math.max(0, finished - started))
            end
        end
        if retry and request.attempt <= request.max_retries
            and pending[request.id] == nil then
            attach(request)
            schedule(run, request.retry_delay)
        end
    end
    schedule(run, delay or 0)
end
