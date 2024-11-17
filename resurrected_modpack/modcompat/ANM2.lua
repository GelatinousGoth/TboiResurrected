local mod = RegisterMod("TR ModCompat: ANM2", 1)

---@class ModCompat_ANM2
---@field anm2 boolean

local COMPAT_SUFFIX = "_modcompat"

---@type table<string, ModCompat_ANM2>
local modCompatANM2s = {}

---@type table<string, boolean>
local validSpritesSheets = {
    ["gfx/bosses/afterbirth/boss_078_bluebaby_hush.png"] = true,
    ["gfx/bosses/afterbirth/theforsaken_black.png"] = true,
    ["gfx/bosses/afterbirth/theforsaken.png"] = true,
    ["gfx/bosses/afterbirth/thestain_grey.png"] = true,
    ["gfx/bosses/afterbirth/thestain.png"] = true,
    ["gfx/bosses/afterbirthplus/boss_sistersvis.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/afterbirth/boss_078_bluebaby_hush.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/afterbirth/theforsaken.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/afterbirth/thestain.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/afterbirthplus/boss_sistersvis.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/boss_035_chad.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/boss_051_gish.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/boss_062_scolex.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/boss_067_triachnid.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/boss_070_ItLives.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/miniboss_09_pride.png"] = true,
    ["gfx/bosses/afterbirthplus/deliriumforms/classic/miniboss_10_superpride.png"] = true,
    ["gfx/bosses/classic/boss_035_chad.png"] = true,
    ["gfx/bosses/classic/boss_051_gish.png"] = true,
    ["gfx/bosses/classic/boss_067_triachnid.png"] = true,
    ["gfx/bosses/classic/boss_070_ItLives.png"] = true,
    ["gfx/bosses/classic/miniboss_09_pride.png"] = true,
    ["gfx/bosses/classic/miniboss_10_superpride.png"] = true,
    ["gfx/bosses/rebirth/megafred.png"] = true
}

local function string_insert(str, insertText, pos)
    local newString = string.sub(str, 1, pos - 1) .. insertText .. string.sub(str, pos)
    return newString
end

---@param sprite Sprite
---@param gfxPath string
local function replace_anm2(sprite, gfxPath)
    local newANM2 = string_insert(gfxPath, COMPAT_SUFFIX, #gfxPath - 4)
    sprite:Load(newANM2, true)
end

---@param spriteSheet string
---@return boolean
local function is_valid_spriteSheet(spriteSheet)
    return validSpritesSheets[spriteSheet]
end

---@param spriteSheet string
---@return string
local function get_delirium_spriteSheet(spriteSheet)
    if string.find(spriteSheet, "bosses/afterbirthplus/deliriumforms") then
        return spriteSheet
    end

    if string.find(spriteSheet, "bosses") == 5 then
        return string.sub(spriteSheet, 1, 4) .. "bosses/afterbirthplus/deliriumforms" .. string.sub(spriteSheet, 11)
    end

    return spriteSheet
end

---@param spriteSheet string
---@return string
local function get_modcompat_sheet(spriteSheet)
    local position = #spriteSheet - 3
    return string.sub(spriteSheet, 1, position - 1) .. COMPAT_SUFFIX .. string.sub(spriteSheet, position)
end

---@param sprite Sprite
---@param layerId integer
---@param isDelirium boolean
local function try_replace_spriteSheet(sprite, layerId, isDelirium)
    local layerState = sprite:GetLayer(layerId)
    if not layerState then
        return
    end

    local spriteSheet = layerState:GetSpritesheetPath():lower()
    if isDelirium then
        spriteSheet = get_delirium_spriteSheet(spriteSheet)
    end

    if not is_valid_spriteSheet(spriteSheet) then
        return
    end

    sprite:ReplaceSpritesheet(layerId, get_modcompat_sheet(spriteSheet), false)
end

---@param sprite Sprite
---@param isDelirium boolean
local function replace_spriteSheets(sprite, isDelirium)
    for i = 0, sprite:GetLayerCount() - 1, 1 do
        try_replace_spriteSheet(sprite, i, isDelirium)
    end
    sprite:LoadGraphics()
end

local function insert_elements(tbl, other)
    for key, value in pairs(other) do
        tbl[key] = value
    end
end

local function has_at_least_one_key(tbl)
    for _, _ in pairs(tbl) do
        return true
    end

    return false
end

---@param entity Entity
---@param isDelirium boolean
---@return boolean
local function replace_graphics(entity, isDelirium)
    local sprite = entity:GetSprite()
    local gfxPath = sprite:GetFilename():lower()
    local replaceData = modCompatANM2s[gfxPath]

    if replaceData then
        if replaceData.anm2 then
            replace_anm2(sprite, gfxPath)
        end
        replace_spriteSheets(sprite, isDelirium)
        return true
    end

    return false
end

---@param _ nil
---@param entity EntityNPC
local function OnNPCInit(_, entity)
    replace_graphics(entity, false)
end

---@param _ nil
---@param delirium EntityDelirium
local function OnDelirium(_, delirium)
    if replace_graphics(delirium, true) then
        local entity = delirium.Child
        while entity do
            replace_graphics(entity, true)
            entity = entity.Child
        end
    end
end

local function OnPostModLoad()
    ---@type table<string, ModCompat_ANM2>
    local reworkedANM2s = {
        ["gfx/028.001_c.h.a.d..anm2"] = {anm2 = true},
        ["gfx/043.001_gish.anm2"] = {anm2 = true},
        ["gfx/078.001_it lives.anm2"] = {anm2 = true},
        ["gfx/101.001_triachnid.anm2"] = {anm2 = true},
        ["gfx/102.001_ (final boss).anm2"] = {anm2 = true},
        ["gfx/102.002_ (alt).anm2"] = {anm2 = true},
        ["gfx/401.000_thestain.anm2"] = {anm2 = true},
        ["gfx/403.000_theforsaken.anm"] = {anm2 = true},

        ["gfx/062.001_scolex.anm2"] = {anm2 = false},
        ["gfx/265.001_sistersvis.anm2"] = {anm2 = false},
        ["gfx/270.000_megafred.anm2"] = {anm2 = false},

        ["gfx/052.000_pride.anm2"] = {anm2 = false},
        ["gfx/052.001_super pride.anm2"] = {anm2 = false}
    }

    if not ReworkedFoes then
        insert_elements(modCompatANM2s, reworkedANM2s)
    end

    if has_at_least_one_key(modCompatANM2s) then
        mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, OnNPCInit)
        mod:AddCallback(DeliriumCallbacks.POST_TRANSFORMATION, OnDelirium)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, OnPostModLoad)