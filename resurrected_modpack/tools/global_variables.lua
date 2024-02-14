local mod = require("resurrected_modpack.mod_reference")

local previousLockCallbackRecord = mod.LockCallbackRecord
mod.LockCallbackRecord = true

mod.Globals = {}

mod.Globals.IsOddRenderFrame = true

local function onRender()
    mod.Globals.IsOddRenderFrame = not mod.Globals.IsOddRenderFrame
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)

mod.LockCallbackRecord = previousLockCallbackRecord