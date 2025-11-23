local TR_Manager = require("resurrected_modpack.manager")
LowFirerateChargeBar = TR_Manager:RegisterMod("Low Firerate Chargebar", 1)

local playerData = {}

local game = Game()

local sprite = Sprite()
sprite:Load("gfx/lfrc_chargebar.anm2", true)

local BAR_FRAME_COUNT = 100
local DEFAULT_RENDER_OFFSET = Vector(0, 14)
local TEAR_THRESHOLD = 1

local function toTearsPerSecond(maxFireDelay)
    return 30 / (maxFireDelay + 1)
end

---@param player EntityPlayer
local function getAnimation(player)
    local tps = toTearsPerSecond(player.MaxFireDelay)
    if tps <= TEAR_THRESHOLD and player:CanShoot() then
        if player:HasWeaponType(WeaponType.WEAPON_TEARS) then
            return "ChargingTear"
        elseif player:HasWeaponType(WeaponType.WEAPON_LASER) then
            return "ChargingLaser"
        elseif player:HasWeaponType(WeaponType.WEAPON_BOMBS) then
            return "ChargingBomb"
        elseif player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
            return "ChargingRocket"
        end
    end
end

local function getPlayerData(playerType)
    if playerData[playerType] == nil then
        playerData[playerType] = {
            Blacklisted = false,
            Offset = DEFAULT_RENDER_OFFSET,
        }
    end

    return playerData[playerType]
end

-- Blacklists a player type from having the low fire rate chargebar.
-- Useful for if your character has a chargebar down there.
function LowFirerateChargeBar:SetBlacklisted(playerType, bool)
    local data = getPlayerData(playerType)
    data.Blacklisted = bool or false
    playerData[playerType] = data
end

-- Checks if the blacklist is enabled, and if the given player is blacklisted.
function LowFirerateChargeBar:GetBlacklisted(playerType)
    local data = getPlayerData(playerType)
    return data.Blacklisted
end

-- Sets the chargebar render offset for the player.
-- Set `offset` to `nil` to reset it back to default.
function LowFirerateChargeBar:SetPlayerOffset(playerType, offset)
    local data = getPlayerData(playerType)
    data.Offset = offset or DEFAULT_RENDER_OFFSET
    playerData[playerType] = data
end

-- Gets the chargebar render offset for the player.
function LowFirerateChargeBar:GetPlayerOffset(playerType)
    local data = getPlayerData(playerType)
    return data.Offset
end

---@param player EntityPlayer
function LowFirerateChargeBar:RenderSprite(player)
    if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
        return
    end

    local playerType = player:GetPlayerType()
    local data = player:GetData()
    data.TearBarAlpha = data.TearBarAlpha or 0

    local animName = getAnimation(player)
    if animName and not LowFirerateChargeBar:GetBlacklisted(playerType) then
        data.TearBarAlpha = math.min(data.TearBarAlpha + 0.1, 1)
    else
        data.TearBarAlpha = math.max(data.TearBarAlpha - 0.1, 0)
    end

    -- Fire delay isn't accounted for until all rockets and targets for the player have been cleared.
    local fireDelay = player.FireDelay
    if player:HasWeaponType(WeaponType.WEAPON_ROCKETS) then
        if Isaac.CountEntities(player, EntityType.ENTITY_EFFECT, EffectVariant.ROCKET) > 0
        or Isaac.CountEntities(player, EntityType.ENTITY_EFFECT, EffectVariant.TARGET) > 0 then
            fireDelay = player.MaxFireDelay
        end
    end

    if data.TearBarAlpha > 0 then
        sprite.Color = Color(1, 1, 1, data.TearBarAlpha)

        if not game:IsPaused() then
            local frame = math.floor(math.min((1 - fireDelay / player.MaxFireDelay) * BAR_FRAME_COUNT, BAR_FRAME_COUNT))
            sprite:SetFrame(animName or sprite:GetAnimation(), frame)
        end

        local barRenderOffset = LowFirerateChargeBar:GetPlayerOffset(playerType)
        sprite:Render(Isaac.WorldToScreen(player.Position) + barRenderOffset)
    end
end
LowFirerateChargeBar:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, LowFirerateChargeBar.RenderSprite, 0)