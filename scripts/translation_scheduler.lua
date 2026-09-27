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
        bucket = {}
        buckets[key] = bucket
    end
    return bucket
end

local function detach(request)
    if pending[request.id] == request then pending[request.id] = nil end
    local bucket = request.instance ~= nil and scope_bucket(request.surface, false) or nil
    if bucket and bucket[request.instance] == request then
        bucket[request.instance] = nil
    end
end

local function attach(request)
    local previous = pending[request.id]
    if previous and previous ~= request then detach(previous) end
    pending[request.id] = request
    local bucket = request.instance ~= nil and scope_bucket(request.surface, true) or nil
    if bucket then
        previous = bucket[request.instance]
        if previous and previous ~= request then detach(previous) end
        bucket[request.instance] = request
    end
end

local function current(request)
    if pending[request.id] ~= request then return false end
    local bucket = request.instance ~= nil and scope_bucket(request.surface, false) or nil
    return not bucket or bucket[request.instance] == request
end

scheduler.cancel = function (id)
    local request = pending[id]
    if request then detach(request) end
end

scheduler.cancel_instance = function (surface, instance)
    local bucket = scope_bucket(surface, false)
    local request = bucket and bucket[instance]
    if request then detach(request) return true end
    return false
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
    local retries = spec and tonumber(spec.max_retries) or 0
    retries = math.max(0, math.min(math.floor(retries or 0), scheduler.MAX_RETRIES))
    local request = pending[id]
    if spec and owner_surface ~= nil and instance ~= nil then
        local bucket = scope_bucket(owner_surface, false)
        request = bucket and bucket[instance] or request
    end
    if request then
        if request.generation == generation
            and request.surface == owner_surface
            and request.instance == instance then
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
        max_retries = retries, retry_delay = spec and spec.retry_delay or delay or 0,
        attempt = 0 }
    attach(request)
    local function run()
        if not current(request) then return end
        local registry = addon_table.use("translation_registry")
        local surface = registry.get and registry.get(id)
        if surface and request.generation
            and surface.generation ~= request.generation then
            detach(request)
            return
        end
        if request.surface and request.generation
            and runtime.generation(request.surface) ~= request.generation then
            detach(request)
            return
        end
        detach(request)
        request.attempt = request.attempt + 1
        local retry = request.callback(request.attempt) == false
        if retry and request.attempt <= request.max_retries
            and pending[request.id] == nil then
            attach(request)
            if C_Timer and type(C_Timer.After) == "function" then
                C_Timer.After(request.retry_delay, run)
            else
                run()
            end
        end
    end
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(delay or 0, run)
    else
        run()
    end
end
