local _, addon_table = ...
local translation_hooks = addon_table.use("translation_hooks")

local installed = {}
local installed_regions = {}
local bound = {}

local function mark(scope, key, install)
    local keys = installed[scope]
    if not keys then
        keys = {}
        installed[scope] = keys
    end
    if keys[key] then return true end
    if install() then
        keys[key] = true
        return true
    end
    return false
end

translation_hooks.bind = function (scope)
    if bound[scope] then return bound[scope] end
    local hooks = {}

    hooks.once = function (key, install)
        if type(key) ~= "string" or type(install) ~= "function" then return false end
        return mark(scope, key, install)
    end

    hooks.mixin = function (name, method, callback)
        return hooks.region(_G[name], method, callback)
    end

    hooks.region = function (region, method, callback)
        local region_type = type(region)
        if (region_type ~= "table" and region_type ~= "userdata")
            or type(callback) ~= "function" or type(_G.hooksecurefunc) ~= "function" then
            return false
        end
        local ok, method_value = pcall(function () return region[method] end)
        if not ok or type(method_value) ~= "function" then return false end
        local regions = installed_regions[scope]
        if not regions then
            regions = setmetatable({}, { __mode = "k" })
            installed_regions[scope] = regions
        end
        local methods = regions[region]
        if methods and methods[method] then return true end
        if not pcall(_G.hooksecurefunc, region, method, callback) then return false end
        if not methods then
            methods = {}
            regions[region] = methods
        end
        methods[method] = true
        return true
    end

    hooks.region_script = function (frame, script, callback, key)
        local frame_type = type(frame)
        if (frame_type ~= "table" and frame_type ~= "userdata")
            or type(callback) ~= "function" then return false end
        local ok, hook_script = pcall(function () return frame.HookScript end)
        if not ok or type(hook_script) ~= "function" then return false end
        local regions = installed_regions[scope]
        if not regions then
            regions = setmetatable({}, { __mode = "k" })
            installed_regions[scope] = regions
        end
        local methods = regions[frame]
        local hook_key = "script:" .. script .. ":" .. (key or "default")
        if methods and methods[hook_key] then return true end
        if not pcall(hook_script, frame, script, callback) then return false end
        if not methods then
            methods = {}
            regions[frame] = methods
        end
        methods[hook_key] = true
        return true
    end

    hooks.global = function (name, callback)
        if type(_G[name]) ~= "function" or type(callback) ~= "function"
            or type(_G.hooksecurefunc) ~= "function" then return false end
        return mark(scope, name, function ()
            return pcall(_G.hooksecurefunc, name, callback)
        end)
    end

    bound[scope] = hooks
    return hooks
end
