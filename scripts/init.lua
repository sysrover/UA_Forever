local _, addon_table = ...

local modules = {}

addon_table.use = function (name)
    if not modules[name] then
        modules[name] = {}
    end
    return modules[name]
end

-- Read-only module inventory for explicitly requested performance captures.
addon_table.each_module = function (callback)
    for name, module in pairs(modules) do callback(name, module) end
end
