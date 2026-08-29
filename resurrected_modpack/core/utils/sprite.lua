--#region Dependencies



--#endregion

---@param originalSprite Sprite
---@param targetSprite Sprite
local function CopySprite(originalSprite, targetSprite)
    --copy sprite txt info
    targetSprite:Load(originalSprite:GetFilename(), true)
    targetSprite:SetFrame(originalSprite:GetAnimation(), originalSprite:GetFrame())

    if #originalSprite:GetOverlayAnimation() > 0 then
        targetSprite:SetOverlayFrame(originalSprite:GetOverlayAnimation(), originalSprite:GetOverlayFrame())
    end

    --copy original sprite properties
    targetSprite.Color = originalSprite.Color
    targetSprite.FlipX = originalSprite.FlipX
    targetSprite.FlipY = originalSprite.FlipY
    targetSprite.Offset = originalSprite.Offset
    targetSprite.PlaybackSpeed = originalSprite.PlaybackSpeed
    targetSprite.Rotation = originalSprite.Rotation
    targetSprite.Scale = originalSprite.Scale

    for i = 0, originalSprite:GetLayerCount() do
        ---@type LayerState?, LayerState
        local originalLayer, targetLayer = originalSprite:GetLayer(i), targetSprite:GetLayer(i)

        if originalLayer then
            targetSprite:ReplaceSpritesheet(i, originalLayer:GetSpritesheetPath())
            targetLayer:SetCropOffset(originalLayer:GetCropOffset())
            targetLayer:SetRenderFlags(originalLayer:GetRenderFlags())
        end
    end


    targetSprite:SetRenderFlags(originalSprite:GetRenderFlags())
    targetSprite:LoadGraphics()
end

---@class Utils.Sprite
local Module = {}

--#region Module

Module.CopySprite = CopySprite

--#endregion

return Module