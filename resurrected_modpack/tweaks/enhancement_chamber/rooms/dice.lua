--[[ Dice ]]--
local mod = EnhancementChamber
local hasMinimap = mod.HasMinimap
local data = mod.Data
local config = mod.ConfigSpecial
local game = Game()
local sound = SFXManager()

-- Dice Variables --
function mod:dicePostLevel()
    if not config["dice"] then return end
    data.diceTriggered = false
    data.diceRestart = false
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.dicePostLevel)

-- Dice Animation --
function mod:diceEffectUpdate(effect)
    if not config["dice"] then return end
    local level = game:GetLevel()
    if effect:GetData().dice_check == nil then
        -- Dice ID --
        local diceID = effect.SubType + 1
        if effect.SubType == 10 then -- 5-pip
            diceID = 5
            effect:GetSprite():SetFrame(tostring(diceID), 0)
        end
        -- Animation --
        if not data.diceTriggered then
            local player = game:GetNearestPlayer(effect.Position)
            local distance = (player.Position - effect.Position):Length()
            if distance < 75 then
                effect:GetData().dice_check = true
                data.diceTriggered = true
                sound:Play(SoundEffect.SOUND_GROUND_TREMOR, 1, 2, false, 0.75, 0)
                sound:Play(Isaac.GetSoundIdByName("Dice"), 1, 2, false, 1, 0)
                -- Curse check --
                if level:GetCurses() > 0 then
                    sound:Play(SoundEffect.SOUND_DEATH_CARD, 1, 2, false, 1, 0)
                    level:RemoveCurses(level:GetCurses())
                end
                if hasMinimap then mod.roomIconUpdate() end -- Minimap icon
                -- Vanilla dice sprite
                if effect.SubType < 100 then
                    if diceID == 5 then data.diceRestart = true end -- 5-pip check
                    effect:GetSprite():Load("gfx/dice_triggered.anm2", true)
                    effect:GetSprite():LoadGraphics()
                    effect:GetSprite():Play(tostring(diceID), true)
                end
            end
        elseif effect.SubType < 100 then -- Dice triggered
            effect:GetData().dice_check = true
            effect:GetSprite():Load("gfx/dice_triggered.anm2", true)
            effect:GetSprite():LoadGraphics()
            effect:GetSprite():SetFrame(tostring(diceID), 30)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.diceEffectUpdate, EffectVariant.DICE_FLOOR)