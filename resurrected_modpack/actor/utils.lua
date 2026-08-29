---@class Actor.Utils
local Module = {}

---@param name string
local function GetIdentity(name)
    local variant = Isaac.GetEntityVariantByName(name)
    if variant == -1 then
        error(string.format("no entity with name \"%s\" exists.", name) , 2)
    end

    return Isaac.GetEntityTypeByName(name),
        variant,
        Isaac.GetEntitySubTypeByName(name)
end

--#region Module

Module.GetIdentity = GetIdentity

--#endregion

return Module