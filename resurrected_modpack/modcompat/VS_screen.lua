local mod = RegisterMod("TR ModCompat: VS Screen", 1)

---@type table<string, boolean>
local portraits = {
    ["gfx/ui/boss/portrait_102.1_bluebaby.png"] = true
}

local names = {
    ["gfx/ui/boss/bossname_102.1_bluebaby.png"] = true
}

local BOSS_PORTRAIT_LAYER_1 = 4
local BOSS_PORTRAIT_LAYER_2 = 9
local BOSS_NAME_LAYER = 7

local COMPAT_SUFFIX = "_modcompat"

local function get_modcompat_sheet(str)
    local pos = #str - 3
    return string.sub(str, 1, pos - 1) .. COMPAT_SUFFIX .. string.sub(str, pos)
end

local function onRender()
    if not RoomTransition.IsRenderingBossIntro() then
        return
    end

    local sprite = RoomTransition.GetVersusScreenSprite()
    if sprite:GetFrame() ~= 0 or sprite:GetFilename() ~= "gfx/ui/boss/versusscreen.anm2" then
        return
    end

    local replaced = false

    local portraitSheet1 = sprite:GetLayer(BOSS_PORTRAIT_LAYER_1):GetSpritesheetPath():lower()
    if portraits[portraitSheet1] then
        sprite:ReplaceSpritesheet(BOSS_PORTRAIT_LAYER_1, get_modcompat_sheet(portraitSheet1))
        replaced = true
    end

    local nameSheet = sprite:GetLayer(BOSS_NAME_LAYER):GetSpritesheetPath():lower()
    if names[nameSheet] then
        sprite:ReplaceSpritesheet(BOSS_NAME_LAYER, get_modcompat_sheet(nameSheet))
        replaced = true
    end

    local portraitSheet2 = sprite:GetLayer(BOSS_PORTRAIT_LAYER_2):GetSpritesheetPath():lower()
    if portraits[portraitSheet2] then
        sprite:ReplaceSpritesheet(BOSS_PORTRAIT_LAYER_2, get_modcompat_sheet(portraitSheet2))
        replaced = true
    end

    if replaced then
        sprite:LoadGraphics()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)