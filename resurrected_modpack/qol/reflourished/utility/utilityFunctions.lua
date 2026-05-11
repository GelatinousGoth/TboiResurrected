local utility = {}


function utility:HUDOffset(x, y, anchor)
    local notches = math.floor(Options.HUDOffset * 10 + 0.5)
    local xoffset = (notches*2)
    local yoffset = ((1/8)*(10*notches+(-1)^notches+7))
    if anchor == 'topleft' then
      xoffset = x+xoffset
      yoffset = y+yoffset
    elseif anchor == 'topright' then
      xoffset = x-xoffset
      yoffset = y+yoffset
    elseif anchor == 'bottomleft' then
      xoffset = x+xoffset
      yoffset = y-yoffset
    elseif anchor == 'bottomright' then
      xoffset = x-xoffset * 0.8
      yoffset = y-notches * 0.6
    else
      error('invalid anchor provided. Must be one of: \'topleft\', \'topright\', \'bottomleft\', \'bottomright\'', 2)
    end
    return math.floor(xoffset + 0.5), math.floor(yoffset + 0.5)
end


function utility:DeepCopy(array)
    local newTable = {}
    for i, value in pairs(array) do
        table.insert(newTable, i, value)
    end
    return newTable
end


function utility:TableHasValue(array, value)
    if not array or #array == 0 then return false end
    for i, thing in pairs(array) do
        if thing == value then
            return true
        end
    end
    return false
end


---@param argumentEntity Entity
---@param radius integer
---@param type EntityType | nil
---@param variant integer | nil
---@param subtype integer | nil
function utility:GetClosestEntityOfTypeInRadius(position, radius, type, variant, subtype)
  local closestDistanceSoFar = math.huge
  local closestEntity

  for _, entity in ipairs(Isaac.FindInRadius(position, radius)) do
    
    if (type == nil or entity.Type == type) and
       (variant == nil or entity.Variant == variant) and
       (subtype == nil or entity.SubType == subtype) then

      local distance = position:DistanceSquared(entity.Position)
      if distance < closestDistanceSoFar then
        closestDistanceSoFar = distance
        closestEntity = entity
      end
    end
  end

  return closestEntity
end

-- Stolen from TSIL lol
--- Checks if a player is the main player, i.e. the one who started the run.
--- Useful because it's the only one whose stats are rendered.
---@param player EntityPlayer
---@return boolean
function utility:IsFirstPlayer(player)
    local mainTwin = player:GetMainTwin()
    local playerIndex = mainTwin:GetPlayerIndex()

    local firstPlayer = Isaac.GetPlayer()
    local firstPlayerIndex = firstPlayer:GetPlayerIndex()

    return playerIndex == firstPlayerIndex
end

function utility:toTearsPerSecond(maxFireDelay)
  return 30 / (maxFireDelay + 1)
end

function utility:toMaxFireDelay(tearsPerSecond)
  return (30 / tearsPerSecond) - 1
end

function utility:addTearMultiplier(player, multiplier)
  local tearsPerSecond = utility:toTearsPerSecond(player.MaxFireDelay)
  tearsPerSecond = tearsPerSecond * multiplier
  player.MaxFireDelay = utility:toMaxFireDelay(tearsPerSecond)
end


function utility:AddTps(player, n)
    return (30/(30/(player.MaxFireDelay+1)+n))-1
end


---@param player EntityPlayer
function utility:isInHallowedAura(player)
    local hallowedAuraNums = 0
    local starAuraNums = 0

    for _, effect in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND)) do
        if(effect.Parent and (effect.Parent.Type == EntityType.ENTITY_POOP or (effect.Parent.Type == EntityType.ENTITY_FAMILIAR and effect.Parent.Variant == FamiliarVariant.DIP))) then
            local scale = ((effect.SpriteScale.X + effect.SpriteScale.Y) * 70 / 2) + player.Size
            if(player.Position:Distance(effect.Position) < scale) then
                hallowedAuraNums = hallowedAuraNums+1
            end
        elseif(effect.Parent and effect.Parent.Type == EntityType.ENTITY_FAMILIAR and effect.Parent.Variant == FamiliarVariant.STAR_OF_BETHLEHEM) then
            local scale = 70 + player.Size
            if(player.Position:Distance(effect.Position) < scale) then
                starAuraNums = starAuraNums + 1
            end
        end
    end

    return {hallowedAuraNums,starAuraNums}
end
---@param player EntityPlayer
function utility:isInHallowedCreep(player)
    local auranum = 0
    for _, effect in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_LIQUID_POOP)) do
        effect = effect:ToEffect()
        local scale = ((effect.SpriteScale.X + effect.SpriteScale.Y) * 36 / 2)
        if effect.State == 64 and player.Position:Distance(effect.Position) <= scale then
            auranum = auranum + 1
        end
    end
    return auranum
end

function utility:getVanillaDamageMultAtPriority(player, priority)
    local mult = 1
    local auraData = utility:isInHallowedAura(player)
    if(priority<=1) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN)) then mult = mult*0.9 end
    end
    if(priority<=4) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not (player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER))) then mult = mult*2 end
        if(player:GetPlayerType()==PlayerType.PLAYER_EVE and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)) then mult = mult*0.75 end
        local playerMults = {
            [PlayerType.PLAYER_MAGDALENE_B] = 0.75,
            [PlayerType.PLAYER_BLUEBABY] = 1.05,
            [PlayerType.PLAYER_KEEPER] = 1.2,
            [PlayerType.PLAYER_CAIN] = 1.2,
            [PlayerType.PLAYER_CAIN_B] = 1.2,
            [PlayerType.PLAYER_EVE_B] = 1.2,
            [PlayerType.PLAYER_JUDAS] = 1.35,
            [PlayerType.PLAYER_AZAZEL] = 1.5,
            [PlayerType.PLAYER_THEFORGOTTEN] = 1.5,
            [PlayerType.PLAYER_AZAZEL_B] = 1.5,
            [PlayerType.PLAYER_THEFORGOTTEN_B] = 1.5,
            [PlayerType.PLAYER_LAZARUS2_B] = 1.5,
            [PlayerType.PLAYER_LAZARUS2] = 1.4,
            [PlayerType.PLAYER_THELOST_B] = 1.3,
            [PlayerType.PLAYER_BLACKJUDAS] = 2,
        }
        mult = mult*(playerMults[player:GetPlayerType()] or 1)
    end
    if(priority<=6) then
        if(player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH)) then mult = mult*4 end
    end
    if(priority<=8) then
        if((player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)>=2 and not player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA))) then mult=mult*1.2 end
        if((player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT))) then mult=mult*2 end
        if((player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART))) then mult=mult*2.3 end
    end
    if(priority<=10) then
        if((player:GetPlayerType()==PlayerType.PLAYER_JUDAS or player:GetPlayerType()==PlayerType.PLAYER_BLACKJUDAS) and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and player:HasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE)) then mult=mult*1.4 end
    end
    if(priority<=12) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) or auraData[1]>0 or auraData[2]>0) then mult=mult*1.2 end
    end
    if(priority<=14) then
        if((player:GetPlayerType()==PlayerType.PLAYER_AZAZEL or player:GetPlayerType()==PlayerType.PLAYER_AZAZEL_B) and player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE)) then mult=mult*0.5 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE)==1 and player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY))) then mult = mult*1.5 end
    end
    if(priority<=16) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)) then mult = mult*0.8 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult=mult*0.3 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) or (player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)) or (player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) and player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR))) then mult=mult*1.5 end
        mult = mult*player:GetD8DamageModifier()*(1+0.125*player:GetDeadEyeCharge())
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA)) then mult = mult*2 end
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) and not player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult=mult*0.2 end
        if(auraData[2]>0) then mult=mult*1.5 end
        local counter = 0
        for _, fam in ipairs(Isaac.FindByType(3, FamiliarVariant.SUCCUBUS)) do
            if(fam.Position:Distance(player.Position)<=97.5) then counter = counter+1 end
        end
        mult = mult*(1.5^counter)
    end
    if(priority<=17) then
        if(player.Damage>3.5) then
            local crownMult = player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN)*0.2
            if(crownMult>0) then
                mult = mult*(1+crownMult)*(player.Damage/(player.Damage+crownMult*3.5))
            end
        end
    end
    return mult
end
function utility:addBasicDamageUp(player, dmg)
    player.Damage = player.Damage+dmg*utility:getVanillaDamageMultAtPriority(player,0)
end

--thank you rat rat rat rat rat rat rat rat!!!!
---@param player EntityPlayer
function utility:getVanillaTearMultiplier(player)
    local mult = 1.0

    if player:HasWeaponType(2) then
        if(player:GetPlayerType() == PlayerType.PLAYER_AZAZEL and not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)) then mult = mult*0.267
        else mult = mult*0.33 end
    end
    if(player:HasWeaponType(5)) then mult = mult*0.4 end
    if(player:HasWeaponType(7)) then mult = mult*0.23 end
    if(player:HasWeaponType(9) and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)) then mult = mult*0.32 end
    if player:HasWeaponType(10) then mult = mult*0.5 end
    if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IPECAC) > 0 then
        if not player:HasWeaponType(2) and
        not player:HasWeaponType(4) and
        not player:HasWeaponType(5) and
        not player:HasWeaponType(6) and
        not player:HasWeaponType(8) and
        not player:HasWeaponType(9) and
        not player:HasWeaponType(10) and
        not player:HasWeaponType(13) and
        not player:HasWeaponType(14) then
            mult = mult/3
        end
    end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)) then mult = mult*4
    elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK)) then mult = mult*5.5 end
    if(player:GetPlayerType() == PlayerType.PLAYER_EVE_B) then mult=mult*0.66 end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA)) then mult = mult*0.66 end
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2)) then mult = mult*0.66 end
    if(not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)) then
        if(player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN)) and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then mult = mult*0.51
        elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)) then mult = mult*0.42
        elseif(player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not player:HasWeaponType(14)) then mult = mult*0.42 end
    end
    if(player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_CHARIOT)) then mult = mult*4 end
    if(player:GetPlayerType() == PlayerType.PLAYER_JUDAS and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BIRTHRIGHT) > 0 and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DECAP_ATTACK)) then mult = mult*3 end
    local epiphora = player:GetEpiphoraCharge()
    if(epiphora>=270) then mult = mult*2
    elseif(epiphora>=180) then mult = mult*(5/3)
    elseif(epiphora>=90) then mult = mult*(4/3) end
    mult = mult*player:GetD8FireDelayModifier()

    local creepdata = utility:isInHallowedCreep(player)
    local auraData = utility:isInHallowedAura(player)
    if(auraData[1]>0 or auraData[2]>0 or creepdata>0) then mult = mult*2.5 end

    return mult
end

function utility:addBasicTearsUp(player, tears)
    player.MaxFireDelay = utility:AddTps(player, tears*utility:getVanillaTearMultiplier(player))
end


local switch_NormalProgression = {
    [LevelStage.STAGE_NULL] = function (_, stageType) return LevelStage.STAGE1_1, stageType end,
    [LevelStage.STAGE1_1] = function (_, stageType) return LevelStage.STAGE1_2, stageType end,
    [LevelStage.STAGE1_2] = function (_, stageType) return LevelStage.STAGE2_1, stageType end,
    [LevelStage.STAGE2_1] = function (_, stageType) return LevelStage.STAGE2_2, stageType end,
    [LevelStage.STAGE2_2] = function (_, stageType) return LevelStage.STAGE3_1, stageType end,
    [LevelStage.STAGE3_1] = function (_, stageType) return LevelStage.STAGE3_2, stageType end,
    [LevelStage.STAGE3_2] = function (_, stageType) return LevelStage.STAGE4_1, stageType end,
    [LevelStage.STAGE4_1] = function (_, stageType) return LevelStage.STAGE4_2, stageType end,
    [LevelStage.STAGE4_2] = function (_, stageType)
        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            return LevelStage.STAGE4_2, stageType --corpse 2 goes back to corpse 2
        end
        return LevelStage.STAGE5, stageType
    end,
    [LevelStage.STAGE4_3] = function (_, stageType) return LevelStage.STAGE5, stageType end,
    [LevelStage.STAGE5] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE6] = function (_, stageType) return LevelStage.STAGE6, stageType end,
    [LevelStage.STAGE7] = function (_, stageType) return LevelStage.STAGE7, stageType end,
    [LevelStage.STAGE8] = function (_, stageType) return LevelStage.STAGE8, stageType end,
    default = function (context, stageType)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL, stageType
    end
}


local switch_BackasswardsProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE6 end,
    [LevelStage.STAGE6] = function () return LevelStage.STAGE5 end,
    [LevelStage.STAGE5] = function () return LevelStage.STAGE4_2 end,
    [LevelStage.STAGE4_2] = function () return LevelStage.STAGE4_1 end,
    [LevelStage.STAGE4_1] = function () return LevelStage.STAGE3_2 end,
    [LevelStage.STAGE3_2] = function () return LevelStage.STAGE3_1 end,
    [LevelStage.STAGE3_1] = function () return LevelStage.STAGE2_2 end,
    [LevelStage.STAGE2_2] = function () return LevelStage.STAGE2_1 end,
    [LevelStage.STAGE2_1] = function () return LevelStage.STAGE1_2 end,
    [LevelStage.STAGE1_2] = function () return LevelStage.STAGE1_1 end,
    [LevelStage.STAGE1_1] = function () return LevelStage.STAGE1_1 end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage")
        return LevelStage.STAGE_NULL
    end
}

local switch_AscentProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE3_2 end,
    [LevelStage.STAGE3_2] = function () --Mausoleum 2
        if Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) then
            return LevelStage.STAGE3_1
        else
            return LevelStage.STAGE3_2
        end
    end,
    [LevelStage.STAGE3_1] = function () return LevelStage.STAGE2_2 end,
    [LevelStage.STAGE2_2] = function () return LevelStage.STAGE2_1 end,
    [LevelStage.STAGE2_1] = function () return LevelStage.STAGE1_2 end,
    [LevelStage.STAGE1_2] = function () return LevelStage.STAGE1_1 end,
    [LevelStage.STAGE1_1] = function () return LevelStage.STAGE8 end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage (Ascent)")
        return LevelStage.STAGE_NULL
    end
}

local switch_GreedStageProgression = {
    [LevelStage.STAGE_NULL] = function () return LevelStage.STAGE1_GREED end,
    [LevelStage.STAGE1_GREED] = function () return LevelStage.STAGE2_GREED end,
    [LevelStage.STAGE2_GREED] = function () return LevelStage.STAGE3_GREED end,
    [LevelStage.STAGE3_GREED] = function () return LevelStage.STAGE4_GREED end,
    [LevelStage.STAGE4_GREED] = function () return LevelStage.STAGE5_GREED end,
    [LevelStage.STAGE5_GREED] = function () return LevelStage.STAGE6_GREED end,
    [LevelStage.STAGE6_GREED] = function () return LevelStage.STAGE7_GREED end,
    [LevelStage.STAGE7_GREED] = function () return LevelStage.STAGE7_GREED end,
    default = function (context)
        context:LogMessage(3, "Wrong Stage (Greed Mode)")
        return LevelStage.STAGE_NULL
    end
}

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_wotl_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return true
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 then
        return persistentData:Unlocked(Achievement.SCARRED_WOMB)
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_repentance_b_available(persistentData, stage)
    if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 then
        return persistentData:Unlocked(Achievement.DROSS)
    elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 then
        return persistentData:Unlocked(Achievement.ASHPIT)
    elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 then
        return persistentData:Unlocked(Achievement.GEHENNA)
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_wotl_available_greed(persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return persistentData:Unlocked(Achievement.CELLAR)
    elseif stage == LevelStage.STAGE2_GREED then
        return persistentData:Unlocked(Achievement.CATACOMBS)
    elseif stage == LevelStage.STAGE3_GREED then
        return persistentData:Unlocked(Achievement.NECROPOLIS)
    elseif stage == LevelStage.STAGE4_GREED then
        return true
    end

    return false
end

---@param persistentData PersistentGameData
---@param stage LevelStage
---@return boolean
local function is_afterbirth_available_greed(persistentData, stage)
    if stage == LevelStage.STAGE1_GREED then
        return persistentData:Unlocked(Achievement.BURNING_BASEMENT)
    elseif stage == LevelStage.STAGE2_GREED then
        return persistentData:Unlocked(Achievement.FLOODED_CAVES)
    elseif stage == LevelStage.STAGE3_GREED then
        return persistentData:Unlocked(Achievement.DANK_DEPTHS)
    elseif stage == LevelStage.STAGE4_GREED then
        return persistentData:Unlocked(Achievement.SCARRED_WOMB)
    end

    return false
end

---@param level Level
function utility:GetNextStage(level)
    local game = Game()
    local stage = level:GetStage()
    local stageType = level:GetStageType()
    local isAltPath = stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B
    local IsBackwardsPath = level:IsAscent() or (game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT) and stage == LevelStage.STAGE3_2 and isAltPath)

    if StageAPI and StageAPI.GetCurrentStage() and StageAPI.GetCurrentStage().StageHPNumber and StageAPI.GetCurrentStage().LevelgenStage  then
        stage = StageAPI.GetCurrentStage().StageHPNumber
        isAltPath = (StageAPI.GetCurrentStage().LevelgenStage.StageType == StageType.STAGETYPE_REPENTANCE 
        or StageAPI.GetCurrentStage().LevelgenStage.StageType == StageType.STAGETYPE_REPENTANCE_B)
    end

    local newStage = LevelStage.STAGE_NULL
    local newStageType = StageType.STAGETYPE_ORIGINAL

    if game:IsGreedMode() then

        local getNextStage = switch_GreedStageProgression[stage] or switch_GreedStageProgression.default
        newStage = getNextStage()
        newStageType = StageType.STAGETYPE_ORIGINAL
    elseif IsBackwardsPath then
        -- Maybe add in code to determing the proper stageType including alt path, but not necessary for now
        local getNextStage = switch_AscentProgression[stage] or switch_AscentProgression.default
        newStage = getNextStage()
        newStageType = stageType
        return newStage, newStageType
    else

        local getNextStage = switch_NormalProgression[stage] or switch_NormalProgression.default
        newStage, newStageType = getNextStage(stageType)

        if game.Challenge == Challenge.CHALLENGE_BACKASSWARDS then
            getNextStage = switch_BackasswardsProgression[stage] or switch_BackasswardsProgression.default
            newStage = getNextStage()
        end
    end

    local curses = level:GetCurses()
    local isFirstChapterFloor = stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE4_1

    if ((curses & LevelCurse.CURSE_OF_LABYRINTH) ~= 0 or game.Challenge == Challenge.CHALLENGE_RED_REDEMPTION) and isFirstChapterFloor then
        newStage = newStage + 1
        if stage == LevelStage.STAGE4_1 then
            newStage = newStage + 1
        end
    end
    if game:IsGreedMode() then
        local seeds = Game():GetSeeds()
        local seed = seeds:GetStageSeed(newStage)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available_greed(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available_greed(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE8 then
        return newStage, newStageType
    end

    local secretPath = game:GetStateFlag(GameStateFlag.STATE_SECRET_PATH) or game:GetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED)

    if level:GetCurrentRoomIndex() == GridRooms.ROOM_SECRET_EXIT_IDX then
        secretPath = true
    end

    if secretPath or ((curses & LevelCurse.CURSE_OF_LABYRINTH) == 0 and (isAltPath and isFirstChapterFloor)) then
        if not isAltPath then -- going from non alt path to alt path
            newStage = math.max(newStage - 1, LevelStage.STAGE1_1)
        end

        local seeds = game:GetSeeds()
        local seed = seeds:GetStageSeed(newStage + 1)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed & 2) == 0 and is_repentance_b_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_REPENTANCE_B
        else
            newStageType = StageType.STAGETYPE_REPENTANCE
        end
    else
        if isAltPath and not IsBackwardsPath then -- moving from alt path to non alt path
            newStage = newStage + 1
        end

        local seeds = game:GetSeeds()
        local seed = seeds:GetStageSeed(newStage)
        local persistentGameData = Isaac.GetPersistentGameData()

        if (seed % 2) == 0 and is_wotl_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_WOTL
        else
            newStageType = StageType.STAGETYPE_ORIGINAL
        end

        if (seed % 3) == 0 and is_afterbirth_available(persistentGameData, newStage) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end

        if seeds:HasSeedEffect(SeedEffect.SEED_G_FUEL) and (newStage == LevelStage.STAGE2_1 or newStage == LevelStage.STAGE2_2) then
            newStageType = StageType.STAGETYPE_AFTERBIRTH
        end
    end

    if newStage < LevelStage.STAGE5 then
        Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)
        return newStage, newStageType
    end

    if newStage == LevelStage.STAGE5 then
        local room = game:GetRoom()
        if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_BLUE_WOOM_IDX then
            return LevelStage.STAGE4_3, StageType.STAGETYPE_ORIGINAL
        end

        if level:GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_THE_VOID_IDX then
            return LevelStage.STAGE7, StageType.STAGETYPE_ORIGINAL
        end

        if stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            return LevelStage.STAGE4_2, StageType.STAGETYPE_REPENTANCE
        end

        newStageType = StageType.STAGETYPE_ORIGINAL
        if (not game:GetStateFlag(GameStateFlag.STATE_HEAVEN_PATH) and game.Challenge ~= Challenge.CHALLENGE_BACKASSWARDS) then
            newStageType = StageType.STAGETYPE_WOTL
        end

        return LevelStage.STAGE5, newStageType
    end

    if newStage == LevelStage.STAGE6 then
        return LevelStage.STAGE6, level:GetStageType()
    end

    return newStage, newStageType
end



IsaacReflourished.Utility = utility