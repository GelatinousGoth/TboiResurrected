local mod = require("resurrected_modpack.manager").ModRef

local temp_additionalSprites = {
    "gfx/bosses/rebirth/angel.png",
    "gfx/bosses/rebirth/angel2.png",
    "gfx/bosses/rebirth/angelblack.png",
    "gfx/bosses/rebirth/angel2black.png",
}

local s_spriteSheetMap = {}

for i = 1, #temp_additionalSprites, 1 do
    local spriteSheet = temp_additionalSprites[i]
    assert(string.find(spriteSheet, "bosses") == 5, string.format("\"%s\" is not a valid delirium source spritesheet", spriteSheet))

    local deliriumSpriteSheet = string.sub(spriteSheet, 1, 4) .. "bosses/afterbirthplus/deliriumforms" .. string.sub(spriteSheet, 11)
    s_spriteSheetMap[spriteSheet] = deliriumSpriteSheet
end

---@param delirium EntityDelirium
local function TryDeliriumReplaceSpriteSheet(_, delirium)
    local sprite = delirium:GetSprite()
    local layers = sprite:GetAllLayers()
    local replaced = false

    for i = 1, #layers, 1 do
        local layer = layers[i]
        local spriteSheet = layer:GetSpritesheetPath()

        local deliriumSpriteSheet = s_spriteSheetMap[spriteSheet]
        if not deliriumSpriteSheet then
            goto continue
        end

        sprite:ReplaceSpritesheet(i - 1, deliriumSpriteSheet)
        replaced = true
        ::continue::
    end

    if replaced then
        sprite:LoadGraphics()
    end
end

mod:AddCallback(DeliriumCallbacks.POST_TRANSFORMATION, TryDeliriumReplaceSpriteSheet)