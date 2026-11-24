--[[ Curse ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Cursed Door
---@param door GridEntityDoor
function mod:CurseDoorBite(door)
    local room = game:GetRoom()

    -- Curse Door sprite
    if (door:GetSprite():GetFilename() == "gfx/grid/Door_04_SelfSacrificeRoomDoor.anm2") and door.State == DoorState.STATE_OPEN then
        door:GetSprite():Load("gfx/curse_door.anm2", true)
        if room:GetFrameCount() == 0 then
            door:GetSprite():Play("Opened", true)
        else
            door:GetSprite():Play("Open", true)
        end
    end

    -- Curse Door attack animation
    if door:GetSprite():GetFilename() == "gfx/curse_door.anm2" then
        -- Fly damage
        if not self:HasConfig("curse_flydamage") and room:GetType() ~= RoomType.ROOM_CURSE then return end

        ---@type EntityPlayer
        local player = self:GetNearestVulnerablePlayer(door.Position)
        if player then

            local distance = (player.Position - door.Position):Length()
            if door.State == DoorState.STATE_OPEN and distance < 28 and not door:GetSprite():IsPlaying("Attack") then
                if not player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then door:GetSprite():Play("Attack", true) end
            end

            -- Attack animation
            if door:GetSprite():IsPlaying("Attack") then
                -- Player movement
                if door:GetSprite():GetFrame() < 8 or door:GetSprite():GetFrame() >= 12 then
                    local pushX = (-1) ^ math.floor(door.Slot / 2) * ((door.Slot + 1) % 2) * -0.85
                    local pushY = (-1) ^ math.floor(door.Slot / 2) * (door.Slot % 2) * -0.85
                    player.Velocity = Vector(pushX, pushY)
                else
                    player.Velocity = Vector.Zero
                end

                -- Attack event
                if door:GetSprite():IsEventTriggered("Attack") then
                    sound:Play(49, 1, 2, false, 0.25, 0)
                    player:TakeDamage(1, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(nil), 30)
                end
            end

            -- Flat file synergy
            if player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then
                door:GetSprite():ReplaceSpritesheet(3, "gfx/grid/curse_door_nospike.png")
                door:GetSprite():LoadGraphics()
            end
        end
        -- Finished attack
        if door:GetSprite():IsFinished("Attack") then door:GetSprite():Play("opened", true) end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.CurseDoorBite, GridEntityType.GRID_DOOR)

-- Takes damage from curse door
---@param entity Entity
function mod:CurseDoorPlayerDamage(entity, amount, flags, source, countdown)
    if not self:HasConfig("curse_redheartdamage") then return end -- config

    local player = entity:ToPlayer()
    if not player then return end
    if flags & DamageFlag.DAMAGE_CURSED_DOOR == 0 then return end

    local newFlags = flags & ~DamageFlag.DAMAGE_CURSED_DOOR

    if not player:HasInstantDeathCurse() then
        self:RedHeartDamage(player, amount, newFlags, source, countdown)
    else
        player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL, EntityRef(nil), 30)
    end

    return false
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CurseDoorPlayerDamage, EntityType.ENTITY_PLAYER)