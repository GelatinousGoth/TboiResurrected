local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Void Overlay"

function mod:VOID_OVERLAY()
    if Game():GetLevel():GetStage() == LevelStage.STAGE7 then
        if void_sprite == nil then
        void_sprite = Sprite()
        void_sprite:Load("/gfx/backdrop/voidoverlay.anm2", true)
        end
    void_sprite:Render(Game():GetRoom():GetRenderSurfaceTopLeft(), Vector(0,0), Vector(0,0))
    void_sprite:Play("Stage",false)
    void_sprite:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.VOID_OVERLAY)