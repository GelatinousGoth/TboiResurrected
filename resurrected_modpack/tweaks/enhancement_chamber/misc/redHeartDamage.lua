--[[ Red Heart Damage ]]--
local mod = EnhancementChamber
local game = Game()

local DAMAGEFLAG_MAUSOLEUM_DOOR = 301998208

---@param player EntityPlayer
---@param amount integer
---@param flags integer | DamageFlag
---@param source EntityRef
---@param countdown integer
function EnhancementChamber:RedHeartDamage(player, amount, flags, source, countdown)
    ---@type integer
    local newFlags = flags | DamageFlag.DAMAGE_RED_HEARTS
    player:TakeDamage(amount, newFlags, source, countdown)
end

-- Mausoleum Door: Pre Red Heart Damage
---@param player EntityPlayer
---@param flags DamageFlag
function mod:MausoleumDoorPreDamage(player, _, flags)
    if not self:HasConfig("mausoleumdoor_redheartdamage") then return end -- config
    local room = game:GetLevel():GetCurrentRoom()

    -- Detects mausoleum door
    player:AddTrinketEffect(TrinketType.TRINKET_CROW_HEART, false, 5)

    if room:GetType() == RoomType.ROOM_BOSS
    and flags == DAMAGEFLAG_MAUSOLEUM_DOOR
    and not player:HasTrinket(TrinketType.TRINKET_CROW_HEART) then

        player:GetData().ec_mausoleum_door_check = true
        player:AddSmeltedTrinket(TrinketType.TRINKET_CROW_HEART, false)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, mod.MausoleumDoorPreDamage)

-- Mausoleum Door: Post Red Heart Damage
---@param entity EntityPlayer
function mod:MausoleumDoorPostDamage(entity)
    local player = entity:ToPlayer()
    if player and player:GetData().ec_mausoleum_door_check then
        player:GetData().ec_mausoleum_door_check = nil
        player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_CROW_HEART)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.MausoleumDoorPostDamage, EntityType.ENTITY_PLAYER)