--[[ Grave ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()
local music = MusicManager()

-- Gravestones --
---@param entity EntityEffect
function mod:gravePostSlot(entity)

    -- Removes gravestones if necessary
    if not self.ConfigSpecial["grave"] then
        entity:Remove()
        return
    end

    -- Spawn gravestone
    if entity:GetData().ec_gravestone_spawn == nil then
        entity:GetData().ec_gravestone_spawn = true
        local spriteVar = entity.InitSeed % 6
        entity:GetSprite():SetFrame("Idle", spriteVar % 3)
        if spriteVar > 2 then entity:GetSprite().FlipX = true end
        -- Flag check
        ---@type integer
        local altarFlags = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS
        if entity:GetEntityFlags() ~= altarFlags then
            entity:ClearEntityFlags(entity:GetEntityFlags())
            entity:AddEntityFlags(altarFlags)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        end
    end

    -- Mechanic
    if entity.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        entity:Remove()

        -- Despawns default loot
		for _, ent in pairs(Isaac.GetRoomEntities()) do
			if (ent.Type == 4 or ent.Type == 5) and ent:GetSprite():IsPlaying("Appear") then
				local distance = entity.Position:Distance(ent.Position)
				if distance < 25 then ent:Remove() end
			end
		end

        -- Custom loot
        local chance = entity:GetDropRNG():RandomInt(20)
        local velocity = Vector.FromAngle(math.random(360)):Resized(math.random()*2 + 3)
        if chance < 3 then -- Bony
            Isaac.Spawn(227, 0, 0, entity.Position, Vector.Zero, entity)
        elseif chance < 5 then -- Lil Haunt
            Isaac.Spawn(260, 10, 0, entity.Position, Vector.Zero, entity)
        elseif chance < 7 then -- Card
            Isaac.Spawn(5, 300, 0, entity.Position, velocity, entity)
        elseif chance < 9 then -- Trinket
            Isaac.Spawn(5, 350, 0, entity.Position, velocity, entity)
        elseif chance < 10 then -- Bone heart
            local boneHeartUnlock = Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS)
            local heartSubtype = 11
            if not boneHeartUnlock then heartSubtype = 0 end
            Isaac.Spawn(5, 10, heartSubtype, entity.Position, velocity, entity)
        end
        sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 1, 0)
        local dust = Isaac.Spawn(1000, 59, 0, entity.Position, Vector.Zero, entity)
        dust:ToEffect():SetTimeout(30)
        dust:ToEffect():Update()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.gravePostSlot, 90)

-- Grave Dirt
---@param effect EntityEffect
function mod:graveDirt(effect)
    local level = game:GetLevel()

    -- Start dirt patch
    if effect:GetSprite():IsFinished("Idle") and not effect:GetData().ec_dirt_dug then
        effect:GetData().ec_dirt_dug = true
    end

    -- Drop old chest
    if effect:GetSprite():IsFinished("DugUp") and effect:GetData().ec_dirt_dug then
        effect:GetData().ec_dirt_dug = false
        ---@type EntityPickup
        local pickup = Isaac.FindByType(5)
        for i = 1, #pickup do
            if not pickup.FrameCount then
                local distance = effect.Position:Distance(pickup[i].Position)
                if distance < 30 then
                    pickup[i]:ToPickup():Morph(5, 55, 0) -- Old Chest
                end
                break
            end
        end
    end

    -- Death music
    if effect.FrameCount > 0
    and level:GetStage() == LevelStage.STAGE6
    and self.checkRoom(RoomType.ROOM_DEFAULT, "Grave")
    and music:GetCurrentMusicID() ~= Music.MUSIC_GAME_OVER then
        music:Play(Music.MUSIC_GAME_OVER, Options.MusicVolume)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.graveDirt, EffectVariant.DIRT_PATCH)