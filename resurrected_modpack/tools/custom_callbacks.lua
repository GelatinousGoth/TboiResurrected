local mod = require("resurrected_modpack.mod_reference")

mod.LockCallbackRecord = true

if not REPENTOGON then
    ModCallbacks.MC_POST_MODS_LOADED = ModCallbacks.MC_POST_MODS_LOADED or {}

    local removePostModLoad = false

    local function PostModLoad()
        if removePostModLoad then
            return
        end
        removePostModLoad = true
        Isaac.RunCallback(ModCallbacks.MC_POST_MODS_LOADED)
    end

    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PostModLoad)
end

mod.LockCallbackRecord = false