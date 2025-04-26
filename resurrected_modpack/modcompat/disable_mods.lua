local TR_Manager = require("resurrected_modpack.manager")

---@type ModReference
local mod = RegisterMod("TR Unload Mods", 1)

---@param name string
local function force_disable_mod(name)
    local id = TR_Manager:GetModIdByName(name)
    if not id then
        return
    end

    TR_Manager:ForceDisable(id)
end

local function unload_GODMODE_mods()
    force_disable_mod("Shop Parrot")
end

local function unload_packed_mods()
    if GODMODE then
        unload_GODMODE_mods()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, unload_packed_mods)