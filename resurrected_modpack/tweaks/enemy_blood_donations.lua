local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Enemy Blood Donations", 1, true)

local BASE_DONATION_DMG = 25
local DONATION_DMG_PER_FLOOR = 5

local BOSS_DONATION_DMG = 40
local BOSS_DONATION_DMG_PER_FLOOR = 10

local RemoveNextPoof = false
local TimeMachinePrevEnabled = false


----------------------------------------------------------------------------------------------
-- The main idea for this method of faking blood donation machine use
-- was based on this mod https://steamcommunity.com/sharedfiles/filedetails/?id=2654236929
-- It was however a improved so it doesn't cause as many crashes
----------------------------------------------------------------------------------------------

---@param donationMachine Entity
---@param enemy Entity
local function FakeUseMachine(donationMachine, enemy)
    if tmmc then
        TimeMachinePrevEnabled = tmmc.enable[2]
        tmmc.enable[2] = false
    end

    local level = Game():GetLevel()

    local damage = BASE_DONATION_DMG + DONATION_DMG_PER_FLOOR * (level:GetStage()-1)
    if enemy:IsBoss() then
        damage = BOSS_DONATION_DMG + BOSS_DONATION_DMG_PER_FLOOR * (level:GetStage()-1)
    end
    enemy:TakeDamage(damage, 0, EntityRef(donationMachine), 1)

    local player = Isaac.GetPlayer(0)

    RemoveNextPoof = true

    ---@diagnostic disable-next-line: param-type-mismatch
    player:UseCard(Card.CARD_SOUL_FORGOTTEN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

	for _, newPlayer in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
		if newPlayer.FrameCount <= 0 then
			newPlayer = newPlayer:ToPlayer()
			newPlayer.Position = donationMachine.Position
            newPlayer.Velocity = Vector.Zero
			newPlayer.Visible = false
			newPlayer.ControlsEnabled = false
            newPlayer.GridCollisionClass = GridCollisionClass.COLLISION_NONE
			newPlayer:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            newPlayer:ChangePlayerType(PlayerType.PLAYER_THELOST_B)
            newPlayer:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

            newPlayer:GetData().IsFakeDonationPlayer = true
            newPlayer:GetData().UsedMachine = donationMachine
		end
	end
end


---@param donationMachine Entity
local function ExplodeMachine(donationMachine)
    donationMachine:Kill()
    donationMachine:GetSprite():Play("Broken", true)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, donationMachine.Position + Vector(0, 2), Vector.Zero, nil)
    SFXManager():Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS)
end


---@param enemy Entity
local function CanEnemyUseMachine(enemy)
    if not enemy:ToNPC() then return false end
    enemy = enemy:ToNPC()

    if enemy:IsActiveEnemy(false) and enemy:IsVulnerableEnemy() and
    not enemy:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_PERSISTENT) then
        return true
    end

    return false
end


---@param donationMachine Entity
local function CheckIfEnemyNearMachine(donationMachine)
	local enemies = Isaac.FindInRadius(donationMachine.Position, 120, EntityPartition.ENEMY)

	for _, enemy in ipairs(enemies) do
        if CanEnemyUseMachine(enemy) then
            if (math.abs(donationMachine.Position.X - enemy.Position.X) ^ 2 <= (donationMachine.Size*donationMachine.SizeMulti.X + enemy.Size) ^ 2) and
            (math.abs(donationMachine.Position.Y-enemy.Position.Y) ^ 2 <= (donationMachine.Size*donationMachine.SizeMulti.Y + enemy.Size) ^ 2) then
                if enemy:IsBoss() and enemy:GetDropRNG():RandomInt(100) < 30 then
                    donationMachine:GetData().ExplodeMachineAfterPrize = true
                end

                FakeUseMachine(donationMachine, enemy)
                break
            end
        end
	end
end


function mod:OnFrameUpdate()
    for _, donationMachine in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, 2)) do
        if donationMachine:GetSprite():IsPlaying("Idle") and donationMachine:GetData().ExplodeMachineAfterPrize then
            ExplodeMachine(donationMachine)
        elseif donationMachine.FrameCount > 5 and donationMachine:GetSprite():IsPlaying("Idle") then
            CheckIfEnemyNearMachine(donationMachine)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnFrameUpdate)


---@param effect EntityEffect
function mod:OnEffectInit(effect)
    if not RemoveNextPoof then return end

    RemoveNextPoof = false
    effect.Visible = false
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.OnEffectInit, EffectVariant.POOF01)


---@param player EntityPlayer
function mod:OnPlayerUpdate(player)
    if not player:GetData().IsFakeDonationPlayer then return end
    local data = player:GetData()

    player.ControlsEnabled = false
    player.Velocity = Vector.Zero
    player.GridCollisionClass = GridCollisionClass.COLLISION_NONE
    player.Visible = false

    if data.UsedMachine then
        ---@type Entity
        local machine = data.UsedMachine

        if not machine or not machine:Exists() or not machine:GetSprite():IsPlaying("Idle") then
            data.UsedMachine = nil
            data.StoppedSound = 3
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            player:Die()

            if tmmc then
                tmmc.enable[2] = TimeMachinePrevEnabled
            end
        end
    else
        if data.StoppedSound > 0 and SFXManager():IsPlaying(SoundEffect.SOUND_ISAACDIES) then
            data.StoppedSound = data.StoppedSound - 1
            SFXManager():Stop(SoundEffect.SOUND_ISAACDIES)
        end

        player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate)


function mod:OnPlayerDamage(player)
    player = player:ToPlayer()

    if player:GetData().IsFakeDonationPlayer then
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnPlayerDamage, EntityType.ENTITY_PLAYER)


function mod:OnNewRoom()
    for i = 0, Game():GetNumPlayers() - 1, 1 do
        local player = Game():GetPlayer(i)

        if player:GetData().IsFakeDonationPlayer then
            player.Visible = false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)


---@param entity EntityNPC
function mod:OnNPCUpdate(entity)
    local playerTarget = entity:GetPlayerTarget()
    if playerTarget and playerTarget:GetData().IsFakeDonationPlayer then
        local nearestPlayer = nil
        local minDistance = math.maxinteger

        for i = 0, Game():GetNumPlayers(), 1 do
            local player = Game():GetPlayer(i)
            if not player:GetData().IsFakeDonationPlayer then
                local distance = entity.Position:DistanceSquared(player.Position)

                if distance <= minDistance then
                   nearestPlayer = player
                   minDistance = distance
                end
            end
        end

        entity.Target = nearestPlayer
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.OnNPCUpdate)