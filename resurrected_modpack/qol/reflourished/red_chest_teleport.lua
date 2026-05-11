local function RedChestTeleportEnabler()

local RedChestTeleport = {}
local mod = IsaacReflourished
local enums = mod.Enums


RedChestTeleport.CursedChests = {}

local roomEntities = Isaac.GetRoomEntities()
for _, entity in ipairs(roomEntities) do
    if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_REDCHEST then
        if entity.SubType == ChestSubType.CHEST_OPENED and entity:ToPickup():GetLootList(false):GetEntries()[1]:GetType() == 0 then
            RedChestTeleport.CursedChests[GetPtrHash(entity)] = true
        end
    end
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    RedChestTeleport.CursedChests = {}
end)


-- function mod:onPrePickupGetLootList(pickup, shouldAdvance)
--         if pickup.Variant ~= PickupVariant.PICKUP_REDCHEST then return end


--         local lootList = LootList()
--         lootList:PushEntry(0, 1, 0)
--         return lootList
-- end
-- mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_GET_LOOT_LIST, mod.onPrePickupGetLootList)



-- mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
--     if pickup.Variant ~= PickupVariant.PICKUP_REDCHEST then return end
--     local debugText = tostring(pickup:GetLootList(false):GetEntries()[1]:GetType()) .. " " .. tostring(pickup:GetLootList(false):GetEntries()[1]:GetVariant()) .. " " .. tostring(pickup:GetLootList(false):GetEntries()[1]:GetSubType())
--     Isaac.RenderScaledText(debugText, Isaac.WorldToScreen(pickup.Position).X - 12, Isaac.WorldToScreen(pickup.Position).Y - 24, 0.5, 0.5, 1, 1, 1, 1)
-- end)



---@param pickup EntityPickup
function RedChestTeleport:TriggerOpen(pickup)
    pickup:GetSprite():Play("Open", true)
    pickup.Wait = 30
    RedChestTeleport.CursedChests[GetPtrHash(pickup)] = true
    pickup.Velocity = Vector(0,0)
    pickup.Mass = 200

    for i, player in pairs(PlayerManager.GetPlayers()) do
        if player.Position:Distance(pickup.Position) < 50 then
            player.Velocity = (player.Position - pickup.Position):Resized(4)
            --player:SetMinDamageCooldown(5)
        end
    end

    SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN)
    pickup.SubType = ChestSubType.CHEST_OPENED
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 0, pickup.Position + Vector(0, -13), Vector(0,0), nil)
    poof.SpriteScale = Vector(0.7, 0.7)
    poof.DepthOffset = 20

    local sprite = pickup:GetSprite()
    sprite:Load("gfx/effects/evil_light.anm2", true)

    local level = Game():GetLevel()
    local isAngelRoom = false

    local isInitialized = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data ~= nil

    if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DUALITY) and not isInitialized then
        local randPlayer = PlayerManager.FirstCollectibleOwner(CollectibleType.COLLECTIBLE_DUALITY)
        local rand = randPlayer and randPlayer:GetCollectibleRNG(CollectibleType.COLLECTIBLE_DUALITY):RandomFloat() or 1
        isAngelRoom = rand > 0.5
    else
        level:InitializeDevilAngelRoom(false, false)
        isAngelRoom = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX).Data.Type == RoomType.ROOM_ANGEL
    end


    if isAngelRoom then
        sprite:Play("goodold", true)
        poof.Color = Color(1, 1, 1, 0.8, 1, 1, 1)
    else
        sprite:Play("evilold", true)
        poof.Color = Color(0, 0, 0, 0.8)

        local trappedRedChest = IsaacReflourished:GetSettingsValue("RedChestTeleportTrap") == 2
        if trappedRedChest then
            local suck = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.SUCK_EFFECT.Variant, enums.Effects.SUCK_EFFECT.SubType, pickup.Position + Vector(0, -15), Vector(0,0), pickup)
            suck.Color = Color(0, 0, 0, 1.5)
        end
    end
end


---@param pickup EntityPickup
---@param collider Entity
function RedChestTeleport:TouchRedChest(pickup, collider)
    if pickup.Variant ~= PickupVariant.PICKUP_REDCHEST then return end
    local player = collider:ToPlayer()
    if not player then return end
    local willTP = pickup:GetLootList(false):GetEntries()[1]:GetType() == 0

    if (not REPENTANCE_PLUS) and (pickup.SubType == ChestSubType.CHEST_CLOSED) and willTP then
        RedChestTeleport:TriggerOpen(pickup)
        return
    end
    if RedChestTeleport.CursedChests[GetPtrHash(pickup)] and pickup.Wait <= 0 then
        if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DUALITY) then
            local isAngel = pickup:GetSprite():IsPlaying("goodold")
            local level = Game():GetLevel()
            level:InitializeDevilAngelRoom(isAngel, not isAngel)
            Game():StartRoomTransition(GridRooms.ROOM_DEVIL_IDX, -1, RoomTransitionAnim.PORTAL_TELEPORT, player, -1)
        end
        player:UseCard(Card.CARD_JOKER, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, RedChestTeleport.TouchRedChest)


---@param pickup EntityPickup
function RedChestTeleport:ChestUpdate(pickup)

    local isClosed = pickup.SubType == ChestSubType.CHEST_CLOSED
    local isCursed = RedChestTeleport.CursedChests[GetPtrHash(pickup)]
    local willTP = pickup:GetLootList(false):GetEntries()[1]:GetType() == 0
    if not isCursed and willTP then

        if isClosed and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MAGNETO) then
            local nearestPlayer = Game():GetNearestPlayer(pickup.Position)
            if nearestPlayer:HasCollectible(CollectibleType.COLLECTIBLE_MAGNETO) and nearestPlayer.Position:Distance(pickup.Position) < 100 then
                RedChestTeleport:TriggerOpen(pickup)
            end
        end
    end
end


---@param pickup EntityPickup
function RedChestTeleport:PreOpenChest(pickup, player)
    if pickup.Variant ~= PickupVariant.PICKUP_REDCHEST then return end
    if pickup.SubType ~= ChestSubType.CHEST_CLOSED then return end

    local willTP = pickup:GetLootList(false):GetEntries()[1]:GetType() == 0
    if not willTP then return end

    RedChestTeleport:TriggerOpen(pickup)
    return false

end

if not REPENTANCE_PLUS then
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, RedChestTeleport.ChestUpdate, PickupVariant.PICKUP_REDCHEST)
else
    mod:AddCallback(ModCallbacks.MC_PRE_OPEN_CHEST, RedChestTeleport.PreOpenChest)
end



---@param effect EntityEffect
function RedChestTeleport:ChestSucc(effect)

    if effect.SubType ~= enums.Effects.SUCK_EFFECT.SubType then return end
    local parent = effect.SpawnerEntity
    if not parent then
        effect:Remove()
        return
    end
    effect.Position = parent.Position + Vector(0, -13)
    local frameCount = effect.FrameCount

    for i, player in pairs(PlayerManager.GetPlayers()) do
        local dist       = player.Position:Distance(effect.Position)
        local waitFactor = math.min(1, (frameCount - 6) / 30)  -- scales from 0 to 1 over 30 frames
        local minDist     = 20     -- 0.5 tiles = inescapable zone
        local maxDist     = 200    -- cutoff distance
        local minPull     = 0.05    -- weakest pull far away
        local maxPull     = 2.5    -- strongest pull (inescapable)

        if dist < maxDist then

            local falloffRate = 60     -- controls steepness of exponential falloff

            -- exponential falloff from maxPull at minDist to minPull at maxDist
            local baseStrength = minPull + (maxPull - minPull) * math.exp(-(dist - minDist) / falloffRate)

            -- apply wait factor scaling
            local pullStrength = baseStrength * waitFactor

            -- apply velocity
            local pull = (effect.Position - player.Position):Resized(pullStrength)
            player.Velocity = player.Velocity + pull
        end

    end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, RedChestTeleport.ChestSucc, enums.Effects.SUCK_EFFECT.Variant)


-- ---@param pickup EntityPickup
-- function RedChestTeleport:Animate(pickup)

--     local isCursed = RedChestTeleport.CursedChests[GetPtrHash(pickup)]

--     if isCursed and pickup.FrameCount % 7 == 0 then
--         local speed = math.random() * 6
--         local angle = math.random(240, 300)
--         local velocity = Vector(speed, 0):Rotated(angle)

--         local posOffset = Vector(
--             math.random(-16, 16),
--             math.random(-18, -14)
--         )

--         local smoke = Isaac.Spawn(
--             EntityType.ENTITY_EFFECT,
--             EffectVariant.DARK_BALL_SMOKE_PARTICLE,
--             0,
--             pickup.Position + posOffset,
--             velocity,
--             nil
--         ):ToEffect()
--         if not smoke then return end

--         smoke:GetSprite():Load("gfx/effects/curse_smoke.anm2", true)
--         smoke:GetSprite():Play("Poof", true)
--         smoke.Color = Color(0, 0, 0, 1)


--         smoke:SetTimeout(60)
--         smoke.SpriteScale = Vector(0.5, 0.5)
--         smoke:GetSprite().PlaybackSpeed = 0.4
--         smoke.DepthOffset = 100
--     end
-- end
-- mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, RedChestTeleport.Animate, PickupVariant.PICKUP_REDCHEST)

end
return RedChestTeleportEnabler