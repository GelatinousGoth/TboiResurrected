local TR_Manager = require("resurrected_modpack.manager")

local EnemyBloodDonations = TR_Manager:RegisterMod("Enemy Blood Donations", 1, true)

local BASE_DONATION_DMG = 25
local DONATION_DMG_PER_FLOOR = 5

local BOSS_DONATION_DMG = 40
local BOSS_DONATION_DMG_PER_FLOOR = 10

local EXPLODE_CHANCE = 0.125 --12.5%


--- Returns how much damage an enemy should take from donating blood.
---@param isBoss boolean
---@return number
local function GetBloodDonationDamage(isBoss)
    local level = Game():GetLevel()

    if isBoss then
        return BOSS_DONATION_DMG + BOSS_DONATION_DMG_PER_FLOOR * (level:GetStage()-1)
    else
        return BASE_DONATION_DMG + DONATION_DMG_PER_FLOOR * (level:GetStage()-1)
    end
end


---@param slot EntitySlot
function EnemyBloodDonations:SlotUpdate(slot)
    if slot:GetState() ~= 1 then return end

    if slot:GetData().ImprovedExplodeMachine then
        slot:SetState(3)
        slot:GetSprite():Play("Broken", true)

        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, slot.Position + Vector(0, 2), Vector.Zero, nil)
        SFXManager():Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS)

        return
    end

    local enemies = Isaac.FindInCapsule(slot:GetCollisionCapsule(), EntityPartition.ENEMY)
    for _, enemy in ipairs(enemies) do
        if not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() then
            slot:SetState(2)

            slot:GetSprite():Play("Initiate")
            slot:SetTimeout(30)

            if slot:GetDropRNG():RandomFloat() < EXPLODE_CHANCE then
                slot:GetData().ImprovedExplodeMachine = true
            end

            SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS, 0.8)
            enemy:BloodExplode()

            local damage = GetBloodDonationDamage(enemy:IsBoss())
            enemy:TakeDamage(damage, 0, EntityRef(slot), 1)

            break
        end
    end
end
EnemyBloodDonations:AddCallback(
    ModCallbacks.MC_POST_SLOT_UPDATE,
    EnemyBloodDonations.SlotUpdate,
    SlotVariant.BLOOD_DONATION_MACHINE
)