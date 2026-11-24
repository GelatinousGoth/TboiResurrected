--[[ Dice ]]--
local mod = EnhancementChamber
local game = Game()
local sound = SFXManager()

-- Dice restarts floor with new seed
---@param player EntityPlayer
function mod:DiceNewLevel(player)
    if not self:HasConfig("dice_restart") then return end

    local level = game:GetLevel()
    if not (self.Data.diceRestart and self.Data.diceRestart == "transition") then return end

    local sprite = player:GetSprite()
    if not (sprite:IsPlaying("Trapdoor") or sprite:IsPlaying("LightTravel")) then
        return
    end

    self.Data.diceRestart = "start"

    local seeds = game:GetSeeds()
    seeds:ForgetStageSeed(level:GetStage())
    game:StartStageTransition(true, 0, player)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.DiceNewLevel)

-- Spawns a dice subtype to replace 5-pip in order to prevent restarting floor instantly
---@param effect EntityNPC
function mod:DiceAvoidRestart(effect)
    if not self:HasConfig("dice_restart") then return end -- config
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()

    if effect.SubType ~= 4 then return end -- 5-pip

    local subtype = 10

    -- Prevents 5-pip appearing in a restarted floor
    if (self.Data.diceRestart and self.Data.diceRestart == "disable") then
        local diceList = {0, 1, 2, 3, 5}
        local rng = 1 + effect.InitSeed % 5
        subtype = diceList[rng]
    end

    effect:Remove()

    local dice = Isaac.Spawn(1000, 76, subtype, room:GetCenterPos(), Vector.Zero, nil)
    if dice.SubType == 10 then dice:GetSprite():SetFrame("5", 0) end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.DiceAvoidRestart, EffectVariant.DICE_FLOOR)

-- Dice Animation
---@param effect EntityEffect
function mod:DiceAnimation(effect)
    if effect:GetData().ec_dice_check then return end

    local level = game:GetLevel()
    local sprite = effect:GetSprite()

    -- Dice ID
    local diceID = effect.SubType + 1
    if effect.SubType == 10 then diceID = 5 end -- 5-pip

    -- Animation
    if not self.Data.diceTriggered then
        local player = game:GetNearestPlayer(effect.Position)

        local distance = (player.Position - effect.Position):Length()
        if distance < 75 then
            effect:GetData().ec_dice_check = true
            self.Data.diceTriggered = true

            sound:Play(SoundEffect.SOUND_GROUND_TREMOR, 1, 2, false, 0.75, 0)
            sound:Play(Isaac.GetSoundIdByName("Dice"), 1, 2, false, 1, 0)

            -- Curse check
            if self:HasConfig("dice_clearcurses") and level:GetCurses() > 0 then
                sound:Play(SoundEffect.SOUND_DEATH_CARD, 1, 2, false, 1, 0)
                level:RemoveCurses(level:GetCurses())
            end

            if MinimapAPI then self:RoomIconUpdate() end -- Minimap icon

            -- Vanilla dice sprite
            if effect.SubType < 100 then
                if diceID == 5 then self.Data.diceRestart = "transition" end -- 5-pip check
                sprite:Load("gfx/dice_triggered.anm2", true)
                sprite:LoadGraphics()
                sprite:Play(tostring(diceID), true)
            end
        end
    elseif effect.SubType < 100 then -- Dice triggered
        effect:GetData().ec_dice_check = true
        sprite:Load("gfx/dice_triggered.anm2", true)
        sprite:LoadGraphics()
        sprite:SetFrame(tostring(diceID), 30)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.DiceAnimation, EffectVariant.DICE_FLOOR)

-- Resets dice variables
function mod:DiceReset()
    if not self:HasConfig("dice_restart") then return end -- config

    self.Data.diceTriggered = false

    if not self.Data.diceRestart then return end

    if self.Data.diceRestart == "start" then self.Data.diceRestart = "disable" return end
    if self.Data.diceRestart == "disable" then self.Data.diceRestart = nil return end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.DiceReset)