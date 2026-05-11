local function PermaWhiteFireplaceEnabler()

local mod = IsaacReflourished
mod.PermaWhiteFire = {}
local PermaWhiteFire = mod.PermaWhiteFire

local WHITE_FIREPLACE_EFFECT = Isaac.GetNullItemIdByName("RF White Fireplace Effect")

local wasInMirrorDimension = false


---@param Collider Entity
mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, function(_, NPC, Collider)
    -- 4: white fireplace
    if NPC.Variant ~= 4 then return end

    local player = Collider:ToPlayer()
    if not player then return end

    local effects = player:GetEffects()
    if effects:HasNullEffect(WHITE_FIREPLACE_EFFECT) then return end
    if not effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then return end

    effects:AddNullEffect(WHITE_FIREPLACE_EFFECT, true, 1)
    if Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE) then
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
    end

end, EntityType.ENTITY_FIREPLACE)


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)

    local dimension = Game():GetLevel():GetDimension()
    if wasInMirrorDimension and (dimension ~= Dimension.MIRROR) then
        wasInMirrorDimension = false
        for i, player in pairs(PlayerManager.GetPlayers()) do
            local effects = player:GetEffects()
            if effects:HasNullEffect(WHITE_FIREPLACE_EFFECT) then
                effects:RemoveNullEffect(WHITE_FIREPLACE_EFFECT, -1)
                if effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
                    effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE, -1)
                end
            end
        end
    end
    if dimension == Dimension.MIRROR then
        wasInMirrorDimension = true
    end

    for i, player in pairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()
        if effects:HasNullEffect(WHITE_FIREPLACE_EFFECT) and not effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
            effects:AddNullEffect(NullItemID.ID_LOST_CURSE, true, 1)
        end
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()

    for i, player in pairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()

        if effects:HasNullEffect(WHITE_FIREPLACE_EFFECT) then
            effects:RemoveNullEffect(WHITE_FIREPLACE_EFFECT)
            if effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
                effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE, -1)
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                and Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE)  then
                    effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()

    local level = Game():GetLevel()
    local room = level:GetCurrentRoomDesc()
    if room.Data.Type ~= RoomType.ROOM_BOSS then return end
    local dimension = Game():GetLevel():GetDimension()
    if dimension == Dimension.MIRROR then return end

    local RevertOnBossKill = IsaacReflourished:GetSettingsValue("WhiteFireRemoveOnBoss") == 2
    if not RevertOnBossKill then return end

    for i, player in pairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()

        if effects:HasNullEffect(WHITE_FIREPLACE_EFFECT) then
            effects:RemoveNullEffect(WHITE_FIREPLACE_EFFECT)
            if effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
                effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE, -1)
                if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                and Isaac.GetPersistentGameData():Unlocked(Achievement.LOST_HOLDS_HOLY_MANTLE)  then
                    effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
                end
            end
            local poof = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.POOF01,
                0,
                player.Position,
                Vector.Zero,
                nil
            )
            poof.Color = Color(1, 1, 1, 0.8, 0.7, 0.7, 0.7)
        end
    end

end)

end
return PermaWhiteFireplaceEnabler