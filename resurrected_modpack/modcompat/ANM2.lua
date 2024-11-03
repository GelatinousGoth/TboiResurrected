local mod = RegisterMod("TR ModCompat: ANM2", 1)

---@class ModCompat_ANM2
---@field anm2 boolean
---@field layers integer[]

local COMPAT_SUFFIX = "_modcompat"

---@type table<string, ModCompat_ANM2>
local modCompatANM2s = {}

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

---@param sprite Sprite
---@param layerId integer
local function replace_spriteSheet(sprite, layerId)
    local layerState = sprite:GetLayer(layerId)
    if not layerState then
        return
    end

    local spriteSheet = layerState:GetSpritesheetPath()
    spriteSheet = string_insert(spriteSheet, COMPAT_SUFFIX, #spriteSheet - 3)
    sprite:ReplaceSpritesheet(layerId, spriteSheet, false)
end

---@param sprite Sprite
---@param replaceData ModCompat_ANM2
local function replace_spriteSheets(sprite, replaceData)
    for _, layer in ipairs(replaceData.layers) do
        replace_spriteSheet(sprite, layer)
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

---@param entity EntityNPC
local function onNPCInit(_, entity)
    local sprite = entity:GetSprite()
    local gfxPath = sprite:GetFilename():lower()
    local replaceData = modCompatANM2s[gfxPath]

    if replaceData then
        if replaceData.anm2 then
            replace_anm2(sprite, gfxPath)
        end
        replace_spriteSheets(sprite, replaceData)
    end
end

local function onPostModLoad()
    ---@type table<string, ModCompat_ANM2>
    local reworkedANM2s = {
        ["gfx/028.001_c.h.a.d..anm2"] = {anm2 = true, layers = {0}},
        ["gfx/043.001_gish.anm2"] = {anm2 = true, layers = {0}},
        ["gfx/078.001_it lives.anm2"] = {anm2 = true, layers = {0}},
        ["gfx/101.001_triachnid.anm2"] = {anm2 = true, layers = {0}},
        ["gfx/102.001_ (final boss).anm2"] = {anm2 = true, layers = {0}},
        ["gfx/102.002_ (alt).anm2"] = {anm2 = true, layers = {0}},
        ["gfx/401.000_thestain.anm2"] = {anm2 = true, layers = {0}},
        ["gfx/403.000_theforsaken.anm"] = {anm2 = true, layers = {0}},

        ["gfx/062.001_scolex.anm2"] = {anm2 = false, layers = {0}},
        ["gfx/102.000_isaac (final boss)"] = {anm2 = false, layers = {0}},
        ["gfx/265.001_sistersvis.anm2"] = {anm2 = false, layers = {0}},
        ["gfx/266.000_mega gurdy.anm2"] = {anm2 = false, layers = {0}},
        ["gfx/270.000_megafred.anm2"] = {anm2 = false, layers = {0}},

        ["gfx/052.000_pride.anm2"] = {anm2 = false, layers = {0}},
        ["gfx/052.001_super pride.anm2"] = {anm2 = false, layers = {0}}
    }

    if not ReworkedFoes then
        insert_elements(modCompatANM2s, reworkedANM2s)
    end

    if has_at_least_one_key(modCompatANM2s) then
        mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, onNPCInit)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, onPostModLoad)