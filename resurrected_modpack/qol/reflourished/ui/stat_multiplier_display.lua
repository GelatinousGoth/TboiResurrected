function StatMultiplierDisplayEnabler()

local StatMult = {}
local mod = IsaacReflourished
local enums = mod.Enums
local utility = mod.Utility


local playersDamageMult = {}
local playersTearsMult = {}

local oldStats = {}
local statsChanged = {}

local statSlideOffset = {}
local statAlpha = {}

local pendingMultiplierUpdate = {}

local function Lerp(a, b, t)
    return a + (b - a) * t
end


mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinue)
    if not isContinue then
        oldStats = {}
        statsChanged = {}
        statSlideOffset = {}
        statAlpha = {}
        playersDamageMult = {}
        playersTearsMult = {}
    end
end)

local statPos = {
    SPEED = 1,
    TEARS = 2,
    DAMAGE = 3,
    RANGE = 4,
    SHOTSPEED = 5,
    LUCK = 6,
    DEVIL = 7,
    ANGEL = 8,
    PLANETARIUM = 9
}

local posStat = {
    [1] = "SPEED",
    [2] = "TEARS",
    [3] = "DAMAGE",
    [4] = "RANGE",
    [5] = "SHOTSPEED",
    [6] = "LUCK",
    [7] = "DEVIL",
    [8] = "ANGEL",
    [9] = "PLANETARIUM"
}


local StatsFont = Font()
StatsFont:Load("font/luaminioutlined.fnt")
---@param mult number
---@param pos Vector
local function RenderStat(mult, pos, alpha)
    local value = string.format("x%.2f", mult)
    pos = pos + (Options.HUDOffset * Vector(20, 12))
    pos = pos + Game().ScreenShakeOffset

    StatsFont:DrawString(
        value,
        pos.X,
        pos.Y,
        KColor(1, 1, 1, alpha),
        0,
        true
    )
end



--timer.Scale = Vector(0.8, 0.8)
function StatMult:PlayerUpdate(player)
    if player.Parent then return end
    if Input.IsActionTriggered(ButtonAction.ACTION_MAP, player.ControllerIndex) then
        local stats = StatMult:GetStatMultipliers(player)
        playersDamageMult[player:GetPlayerIndex()] = stats.DamageMult
        playersTearsMult[player:GetPlayerIndex()] = stats.TearsMult
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, StatMult.PlayerUpdate)


--timer.Scale = Vector(0.8, 0.8)
function StatMult:RenderIcon()
	if not Game():GetHUD():IsVisible() then return end
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local roomConfigRoom = roomDesc.Data
    if roomConfigRoom.StageID == 35 and Game():GetRoom():GetType() == RoomType.ROOM_DUNGEON then return end --check if fighting beast
    if not Options.FoundHUD then return end


    for _, player in pairs(PlayerManager.GetPlayers()) do
        local alpha = statAlpha[player:GetPlayerIndex()] or 0
        if alpha > 0.01 then
            StatMult:RenderPlayer(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_RENDER, StatMult.RenderIcon)


---@param player EntityPlayer
function StatMult:RenderPlayer(player)
    local index = player:GetPlayerIndex()
    local damageMult = playersDamageMult[index]
    local tearsMult = playersTearsMult[index]
    local alpha = statAlpha[index] or 1

    local showDamageMult = IsaacReflourished:GetSettingsValue("StatMultShowDamage") == 2
    local showTearsMult = IsaacReflourished:GetSettingsValue("StatMultShowTears") == 2
    if showDamageMult and damageMult then
        RenderStat(damageMult, StatMult:GetStatRenderPos(player, statPos.DAMAGE), 0.55 * alpha)
    end
    if showTearsMult and tearsMult then
        RenderStat(tearsMult, StatMult:GetStatRenderPos(player, statPos.TEARS), 0.55 * alpha)
    end
end

local function customKeeperTearMult(player)

    local keeperMultEnabled = IsaacReflourished.SaveManager.GetDeadSeaScrollsSave().Toggles.MultishotKeepersFixEnabled == 2
    if not keeperMultEnabled then return 1 end
    if not (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) then return 1 end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then return 1 end

    local mult = 1
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER then
            mult = mult / 0.51
        else
            mult = mult / 0.42
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then
        mult = mult/0.51
    end
    return mult
end

local ignoreOffset = false
local evalRockBottom = false
local rSpeed = 0
local rTears = 0
local rDamage = 0
local rRange = 0
local rShotSpeed = 0
local rLuck = 0

---@param player EntityPlayer
function StatMult:GetStatMultipliers(player)

    local statMultCalcMethod = IsaacReflourished:GetSettingsValue("StatMultCalcMethod")
    if statMultCalcMethod == 2 then
        local tearsMult = utility:getVanillaTearMultiplier(player)
        tearsMult = tearsMult * (customKeeperTearMult(player) or 1)
        return {
            DamageMult = utility:getVanillaDamageMultAtPriority(player, 0),
            TearsMult = tearsMult
        }
    end


    if FiendFolio and player:HasTrinket(FiendFolio.ITEM.ROCK.TOP_ROCK) then
        return {DamageMult = 1, TearsMult = 1}
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_LIBRA) then return {DamageMult = 1, TearsMult = 1} end

    rSpeed = player.MoveSpeed
    rTears = player.MaxFireDelay
    rDamage = player.Damage
    rRange = player.TearRange
    rShotSpeed = player.ShotSpeed
    rLuck = player.Luck

    local hasRock = player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
    if hasRock then
        player:BlockCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
    end
    local hasBoulder = MattPack and player:HasCollectible(MattPack.Items.BoulderBottom)
    if hasBoulder then
        player:BlockCollectible(MattPack.Items.BoulderBottom)
    end

    local damage = player.Damage
    local HUGE_GROWTH_DAMAGE_UP = 7

    local tears = utility:toTearsPerSecond(player.MaxFireDelay)
    local ANTIGRAV_TEARS_UP = 1

    ignoreOffset = true
    player:GetEffects():AddNullEffect(NullItemID.ID_HUGE_GROWTH, false)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    local newDamage = player.Damage
    player:GetEffects():RemoveNullEffect(NullItemID.ID_HUGE_GROWTH)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)

    player:AddNullItemEffect(NullItemID.ID_LUNA, false)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    local newTears = utility:toTearsPerSecond(player.MaxFireDelay)
    player:GetEffects():RemoveNullEffect(NullItemID.ID_LUNA)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    ignoreOffset = false

    local damageDiff = (newDamage - damage)
    local damageMult = damageDiff/HUGE_GROWTH_DAMAGE_UP

    local tearsDiff = (newTears - tears)
    local tearsMult = tearsDiff/ANTIGRAV_TEARS_UP

    if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        damageMult = damageMult * 4
    end

    local hasMultiShot = player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or
    player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or
    player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) and not hasMultiShot then
        damageMult = damageMult * 2
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN) then
        damageMult = damageMult * 0.9
    end

    if(player:GetPlayerType()==PlayerType.PLAYER_EVE and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON)) then damageMult = damageMult*0.75 end
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
    damageMult = damageMult*(playerMults[player:GetPlayerType()] or 1)

    if hasRock then
        player:UnblockCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
        evalRockBottom = true
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        evalRockBottom = false
    end
    if hasBoulder then
        player:UnblockCollectible(MattPack.Items.BoulderBottom)
        evalRockBottom = true
        player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
        evalRockBottom = false
    end

    return {DamageMult = damageMult, TearsMult = tearsMult}

end

--Decrease timer controlling x position offset for stat change display
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local index = player:GetPlayerIndex()

    oldStats[index] = oldStats[index] or {DAMAGE = player.Damage, TEARS = player.MaxFireDelay}
    statsChanged[index] = statsChanged[index] or {DAMAGE = 0, TEARS = 0}
    statSlideOffset[index] = statSlideOffset[index] or {DAMAGE = 0, TEARS = 0}
    statAlpha[index] = statAlpha[index] or 0

    statsChanged[index].DAMAGE = math.max(0, (statsChanged[index].DAMAGE or 0) - 1)
    statsChanged[index].TEARS = math.max(0, (statsChanged[index].TEARS or 0) - 1)

    local targetDamageOffset = (statsChanged[index].DAMAGE > 0) and 35 or 0
    local targetTearsOffset = (statsChanged[index].TEARS > 0) and 35 or 0

    local slideSpeed = 0.25
    statSlideOffset[index].DAMAGE = Lerp(statSlideOffset[index].DAMAGE, targetDamageOffset, slideSpeed)
    statSlideOffset[index].TEARS = Lerp(statSlideOffset[index].TEARS, targetTearsOffset, slideSpeed)

    local fadeSpeed = 0.20
    local mapHeld = Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex)
    if mapHeld then
        statAlpha[index] = math.min(1, statAlpha[index] + fadeSpeed)
    else
        statAlpha[index] = math.max(0, statAlpha[index] - fadeSpeed)
    end

    if pendingMultiplierUpdate[index] and pendingMultiplierUpdate[index] == true then
        if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) then
            local stats = StatMult:GetStatMultipliers(player)
            playersDamageMult[player:GetPlayerIndex()] = stats.DamageMult
            playersTearsMult[player:GetPlayerIndex()] = stats.TearsMult
        end
        pendingMultiplierUpdate[player] = false
    end
end)


function StatMult:EvaluateCache(player, flag)
    local index = player:GetPlayerIndex()

    if not ignoreOffset and oldStats[index] then
        if oldStats[index].DAMAGE and flag == CacheFlag.CACHE_DAMAGE then
            oldStats[index].DAMAGE = oldStats[index].DAMAGE or player.Damage
            if player.Damage ~= oldStats[index].DAMAGE then
                statsChanged[index].DAMAGE = 4.5 * 30
                oldStats[index].DAMAGE = player.Damage
                pendingMultiplierUpdate[index] = true
            end
        end

        if oldStats[index].TEARS and flag == CacheFlag.CACHE_FIREDELAY then
            oldStats[index].TEARS = oldStats[index].TEARS or player.MaxFireDelay
            if player.MaxFireDelay ~= oldStats[index].TEARS then
                statsChanged[index].TEARS = 4.5 * 30
                oldStats[index].TEARS = player.MaxFireDelay
                pendingMultiplierUpdate[index] = true
            end
        end
    end

    if not evalRockBottom then return end
    if rSpeed and flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = rSpeed
    end

    if rTears and flag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = rTears
    end

    if rDamage and flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = rDamage
    end

    if rRange and flag == CacheFlag.CACHE_RANGE then
        player.TearRange = rRange
    end

    if rShotSpeed and flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = rShotSpeed
    end

    if rLuck and flag == CacheFlag.CACHE_LUCK then
        player.Luck = rLuck
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, math.huge, StatMult.EvaluateCache)


---@param player EntityPlayer
---@param stat integer
---@return Vector
function StatMult:GetStatRenderPos(player, stat)

    local baseXPos = 40
    local baseYPos = 88
    if REPENTANCE_PLUS then
        baseYPos = 90
    end
    local alpha = 0.5

    if PlayerManager.IsCoopPlay() and
    not (Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB
    or Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_ESAU) then
        if utility:IsFirstPlayer(player) then
            baseYPos = baseYPos - 4
        else
            baseYPos = baseYPos + 4
        end
    end

    if Game().Challenge == Challenge.CHALLENGE_NULL
    and Game().Difficulty == Difficulty.DIFFICULTY_NORMAL
    and not Game():AchievementUnlocksDisallowed() then
        --If there are no symbols (Hard mode, greed, achievements disabled, etc..) move the ui up
        baseYPos = baseYPos - 16.5
    end

    if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY) then
        --If the player is playing bethany, account for the soul charge
        baseYPos = baseYPos + 10
    end

    if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY_B) then
        --If the player is playing T.bethany, account for the red health charge
        baseYPos = baseYPos + 10
    end

    if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) and PlayerManager.IsCoopPlay() then
        --If there is a t.blue baby and playing coop poop is separate from bombs
        baseYPos = baseYPos + 10
    end

    if (Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB
    or Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_ESAU) then
        --If the main player is jacob and esau lower it a bit
        baseYPos = baseYPos + 16
    end

    -- if duration <= STAT_COUNTER_MOVEMENT_DURATION then
    --     local percent = duration / STAT_COUNTER_MOVEMENT_DURATION
    --     local movementPercent = TSIL.Utils.Easings.EaseOutSine(percent)

    --     local XOffset = TSIL.Utils.Math.Lerp(20, 0, movementPercent)
    --     baseXPos = baseXPos - XOffset

    --     alpha = TSIL.Utils.Math.Lerp(0, 0.5, percent)
    -- end

    -- if STAT_COUNTER_DURATION - duration <= STAT_COUNTER_FADING_DURATION then
    --     local percent = (STAT_COUNTER_DURATION - duration) / STAT_COUNTER_FADING_DURATION

    --     alpha = TSIL.Utils.Math.Lerp(0, 0.5, percent)
    -- end

    local statChange = posStat[stat]
    local index = player:GetPlayerIndex()

    if statSlideOffset[index] and statSlideOffset[index][statChange] then
        baseXPos = baseXPos + statSlideOffset[index][statChange]
    end

    for i = 1, 9, 1 do

        if i == stat then return Vector(baseXPos, baseYPos) end

            if PlayerManager.IsCoopPlay() and
            not (Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB
                or Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_ESAU) then
            baseYPos = baseYPos + 14
        else
            if i == 1 and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
                baseYPos = baseYPos + 8
            elseif i == 1 and player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                baseYPos = baseYPos + 16
            elseif (player:GetPlayerType() == PlayerType.PLAYER_JACOB
                or player:GetPlayerType() == PlayerType.PLAYER_ESAU) then
                baseYPos = baseYPos + 14
            else
                baseYPos = baseYPos + 12
            end
        end
    end
    return Vector(baseXPos, baseYPos)
end

end
return StatMultiplierDisplayEnabler