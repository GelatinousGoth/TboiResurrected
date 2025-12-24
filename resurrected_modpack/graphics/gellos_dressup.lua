
local TR_Manager = require("resurrected_modpack.manager")
GelloCostumes = TR_Manager:RegisterMod("Gello's Dressup!", 1)
GelloCostumes.Rgon = {}

GelloCostumes.Rgon.Costumes = {
    Other = {},
    Items = {}
}
---@param condition function
---@param costumes table
---@param priorities table
---@param specialEffects? function
function GelloCostumes.Rgon:AddCostume(condition, costumes, priorities, specialEffects)
    local config = {
        Condition = condition,
        ---@type table
        Costumes = {
            ["Glow"] = costumes.Glow or nil,
            ["Body"] = costumes.Body or nil,
            ["Extra1"] = costumes.Extra1 or nil,
            ["Extra2"] = costumes.Extra2 or nil,
        },
        Priorities = {
            ["Glow"] = priorities.Glow or -1,
            ["Body"] = priorities.Body or -1,
            ["Extra1"] = priorities.Extra1 or -1,
            ["Extra2"] = priorities.Extra2 or -1,
        },
        SpecialEffects = specialEffects or nil
    }
    config.TryApplyCostumes = function(currentCostumes)
        for layer, _ in pairs(currentCostumes.Costumes) do
            if config.Priorities[layer] > currentCostumes.Priorities[layer] then
                currentCostumes.Costumes[layer] = config.Costumes[layer]
                currentCostumes.Priorities[layer] = config.Priorities[layer]
            end
        end
        return currentCostumes
    end
    table.insert(GelloCostumes.Rgon.Costumes.Other, config)
end
---@param id CollectibleType
---@param costumes table
---@param priorities table
---@param specialEffects? function
function GelloCostumes.Rgon:AddItemCostume(id, costumes, priorities, specialEffects)
    local config = {
        Item = id,
        ---@type table
        Costumes = {
            ["Glow"] = costumes.Glow or nil,
            ["Body"] = costumes.Body or nil,
            ["Extra1"] = costumes.Extra1 or nil,
            ["Extra2"] = costumes.Extra2 or nil,
        },
        Priorities = {
            ["Glow"] = priorities.Glow or -1,
            ["Body"] = priorities.Body or -1,
            ["Extra1"] = priorities.Extra1 or -1,
            ["Extra2"] = priorities.Extra2 or -1,
        },
        SpecialEffects = specialEffects or nil
    }
    GelloCostumes.Rgon.Costumes.Items[id] = config
end

local nameToLayerIDs = {
    ["Body"] = {
        0, 1
    },
    ["Extra1"] = {
        3
    },
    ["Extra2"] = {
        4
    }
}

---@param sprite Sprite
---@param costumes table
---@param specialEffects? function
function GelloCostumes.Rgon:ApplyGelloCostumes(sprite, costumes, specialEffects)
    sprite:Load("gfx_gello_costumes/gello.anm2", false)

    for layerName, ids in pairs(nameToLayerIDs) do
        for _, layerId in ipairs(ids) do
            sprite:ReplaceSpritesheet(layerId, costumes[layerName])
        end
    end

    if specialEffects then
        specialEffects(sprite)
    end

    sprite:LoadGraphics()
end



---@return table
function GelloCostumes.Rgon:CreateEmptyCostumeTable()
    return {
        Priorities = {
            ["Glow"] = 0,
            ["Body"] = 0,
            ["Extra1"] = 0,
            ["Extra2"] = 0,
        },
        Costumes = {
            ["Glow"] = "gfx/familiar/umbilical_baby/null.png",
            ["Body"] = "gfx/familiar/umbilical_baby/base.png",
            ["Extra1"] = "gfx/familiar/umbilical_baby/null.png",
            ["Extra2"] = "gfx/familiar/umbilical_baby/null.png",
        },
        SpecialEffects = nil
    }
end

---@param entity Entity
---@return EntityPlayer | nil
local function tryFindPlayerSpawner(entity)
    while entity ~= nil do
        if entity:ToPlayer() then
            return entity:ToPlayer()
        else
            entity = entity.SpawnerEntity
        end
    end

    return nil
end

---@param fam EntityFamiliar
---@return table
local function getCostumes(fam)
    local costumes = GelloCostumes.Rgon:CreateEmptyCostumeTable()

    local player = tryFindPlayerSpawner(fam)
    if player then
        local history = player:GetHistory():GetCollectiblesHistory()
        
        for i = 1, #history do
            local item = history[i]

            if not item:IsTrinket() then
                local config = GelloCostumes.Rgon.Costumes.Items[item:GetItemID()]
                if config then
                    
                    for layer, costume in pairs(config.Costumes) do
                        if costumes.Priorities[layer] <= config.Priorities[layer] then
                            costumes.Costumes[layer] = costume
                            costumes.Priorities[layer] = config.Priorities[layer]
                        end
                    end

                    if config.SpecialEffects then
                        costumes.SpecialEffects = config.SpecialEffects
                    end
                end
            end

            i = i - 1
        end

        for _, config in ipairs(GelloCostumes.Rgon.Costumes.Other) do
            if config.Condition(player) == true then
                costumes = config.TryApplyCostumes(costumes)
                if config.SpecialEffects then
                    costumes.SpecialEffects = config.SpecialEffects
                end
            end
        end
    end

    return costumes
end

local glowHelper = {
    Id = Isaac.GetEntityTypeByName("Gello Costumes Glow Helper"),
    Variant = Isaac.GetEntityVariantByName("Gello Costumes Glow Helper"),
    ---@diagnostic disable-next-line
    SubType = Isaac.GetEntitySubTypeByName("Gello Costumes Glow Helper")
}

---@param fam EntityFamiliar
---@param costumes table
---@param glowHelper table
---@return Entity
local function createGlow(fam, costumes, glowHelper)
    local eff = Game():Spawn(glowHelper.Id, glowHelper.Variant, fam.Position, Vector.Zero, fam, glowHelper.SubType, fam.InitSeed)
    eff:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
    local effSprite = eff:GetSprite()
    effSprite:ReplaceSpritesheet(0, costumes.Costumes["Glow"])
    effSprite:LoadGraphics()
    effSprite:Play("Idle", true)
    eff.DepthOffset = fam.DepthOffset - 10
    fam:GetData().GelloCostumes_Glow = EntityRef(eff)
    eff:SetColor(Color(1, 1, 1, 0), 10, 1, true, true)
    return eff
end

---@param fam EntityFamiliar
GelloCostumes:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    if fam.SubType ~= 0 or fam.FrameCount ~= 0 then return end

    local player = tryFindPlayerSpawner(fam)

    if not player then return end

    local costumes = getCostumes(fam)
    GelloCostumes.Rgon:ApplyGelloCostumes(fam:GetSprite(), costumes.Costumes, costumes.SpecialEffects)
    createGlow(fam, costumes, glowHelper)

end, FamiliarVariant.UMBILICAL_BABY)

---@param fam EntityFamiliar
GelloCostumes:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, fam)
    if fam.SubType ~= 0 then return end
    ::GlowDoesNotExist::
    ---@type EntityRef | nil
    local eff = fam:GetData().GelloCostumes_Glow
    if not eff or (eff and eff.Entity and not eff.Entity:Exists()) then
        createGlow(fam, getCostumes(fam), glowHelper)
        goto GlowDoesNotExist
    end
    ---@diagnostic disable-next-line
    eff = eff.Entity
    if not eff then return end

    eff.Position = fam.Position + fam.Velocity/2

end, FamiliarVariant.UMBILICAL_BABY)

---@param eff EntityEffect
GelloCostumes:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, eff)
    if eff.SubType ~= glowHelper.SubType then return end
    if not eff.SpawnerEntity then eff:Remove() return end
end, glowHelper.Variant)

include("resurrected_modpack.graphics.gellos_dressup.repentogon.costumes")