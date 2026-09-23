local _, addon_table = ...

local modules = {}

addon_table.use = function (name)
    if not modules[name] then
        modules[name] = {}
    end
    return modules[name]
end
