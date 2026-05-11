local function SpikesDealChanceEnabler()

local SpikesDealChance = {}
local mod = IsaacReflourished
local enums = mod.Enums

local SpikeVariants = {
    [GridEntityType.GRID_SPIKES] = true,
    [GridEntityType.GRID_SPIKES_ONOFF] = true,
    [GridEntityType.GRID_PIT] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
}

---@param player EntityPlayer
function SpikesDealChance:TakeDamage(player, damage, damageFlags, source, invuln)
    if damageFlags & DamageFlag.DAMAGE_NO_PENALTIES > 0 then return end
    local isSpikeDamage = damageFlags & DamageFlag.DAMAGE_SPIKES > 0
    
    if MilkshakeVol2 and player:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Medicated Bandage")) then
        damage = 1
    end
    if not (source.Type == 0 and SpikeVariants[source.Variant] and isSpikeDamage) then return end

    local allowHostileRooms = IsaacReflourished:GetSettingsValue("SelfSpikesHostileRooms") == 2
    if not (allowHostileRooms or Game():GetRoom():IsClear()) then return end

    return {DamageFlags = damageFlags | DamageFlag.DAMAGE_NO_PENALTIES,
            Damage = damage}

end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SpikesDealChance.TakeDamage, EntityType.ENTITY_PLAYER)

end
return SpikesDealChanceEnabler