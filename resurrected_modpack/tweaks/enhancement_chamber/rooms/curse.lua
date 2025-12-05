--[[ Curse ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Cursed Door
---@param door GridEntityDoor
function mod:curseDoorRender(door)
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

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
        local player = self.getNearestVulnerablePlayer(door.Position)
        if player then

            local distance = (player.Position - door.Position):Length()
            if door.State == DoorState.STATE_OPEN and distance < 28 and not door:GetSprite():IsPlaying("Attack") then
                if not player:HasTrinket(TrinketType.TRINKET_FLAT_FILE) then door:GetSprite():Play("Attack", true) end
            end

            -- Attack animation
            if door:GetSprite():IsPlaying("Attack") then
                -- Player movement --
                if door:GetSprite():GetFrame() < 8 or door:GetSprite():GetFrame() >= 12 then
                    if door:GetSprite():GetFrame() < 8 then player:GetData().ec_curse_entrance_immunity = true end
                    local pushX = (-1) ^ math.floor(door.Slot / 2) * ((door.Slot + 1) % 2) * -0.85
                    local pushY = (-1) ^ math.floor(door.Slot / 2) * (door.Slot % 2) * -0.85
                    player.Velocity = Vector(pushX, pushY)
                else
                    player.Velocity = Vector.Zero
                end

                -- Attack event
                if door:GetSprite():IsEventTriggered("Attack") then
                    player:GetData().ec_curse_entrance_immunity = nil
                    sound:Play(49, 1, 2, false, 0.25, 0)
                    if not player:HasInstantDeathCurse() then
                        if player:GetPlayerType() ~= PlayerType.PLAYER_THELOST and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B then
                            local redHeartDamage = self.ConfigMisc["redHeartDamage"]
                            if redHeartDamage then
                                self.RedHeartDamage(player, 1, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(nil), 30)
                            else
                                player:TakeDamage(1, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(nil), 30)
                            end
                        end
                    else
                        player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL, EntityRef(nil), 30)
                    end
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
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.curseDoorRender, GridEntityType.GRID_DOOR)

-- Cursed Door Damage Immunity
---@param entity EntityPlayer
function mod:curseTakeDamage(entity)
    -- Curse Door Entrance Immunity
    if entity:GetData().ec_curse_entrance_immunity then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.curseTakeDamage, EntityType.ENTITY_PLAYER)