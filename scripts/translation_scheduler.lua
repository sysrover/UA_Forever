local _, addon_table = ...
local scheduler = addon_table.use("translation_scheduler")
local runtime = addon_table.use("translation_runtime")

local pending = {}

scheduler.cancel = function (id)
    pending[id] = nil
end

scheduler.request = function (id, generation, callback, delay, owner_surface)
    if not id or type(callback) ~= "function" then return end
    local request = pending[id]
    if request then
        request.callback = callback
        request.generation = generation
        request.owner_surface = owner_surface
        return
    end
    request = { generation = generation, callback = callback,
        owner_surface = owner_surface }
    pending[id] = request
    local function run()
        if pending[id] ~= request then return end
        pending[id] = nil
        local registry = addon_table.use("translation_registry")
        local surface = registry.get and registry.get(id)
        if surface and request.generation
            and surface.generation ~= request.generation then return end
        if request.owner_surface and request.generation
            and runtime.generation(request.owner_surface) ~= request.generation then
            return
        end
        request.callback()
    end
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(delay or 0, run)
    else
        run()
    end
end
