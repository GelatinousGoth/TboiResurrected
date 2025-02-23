local TR_Manager = require("resurrected_modpack.manager")
local TearBar = TR_Manager:RegisterMod("Low Firerate Chargebar", 1)
local game = Game()

local sprite = Sprite()
sprite:Load("gfx/tear_chargebar.anm2", true)

local BAR_FRAME_COUNT = 100
local BAR_RENDER_POSITION_OFFSET = Vector(0, 14)
local TEAR_THRESHOLD = 1

local function toTearsPerSecond(maxFireDelay)
    return 30 / (maxFireDelay + 1)
end

---@param player EntityPlayer
local function getAnimation(player)
    local tps = toTearsPerSecond(player.MaxFireDelay)
    if tps <= TEAR_THRESHOLD then
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

---@param player EntityPlayer
function TearBar:RenderSprite(player)
    if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
        return
    end

    local data = player:GetData()
    data.TearBarAlpha = data.TearBarAlpha or 0

    local animName = getAnimation(player)
    if animName then
        data.TearBarAlpha = math.min(data.TearBarAlpha + 0.1, 1)
    else
        data.TearBarAlpha = math.max(data.TearBarAlpha - 0.1, 0)
    end

    -- Fire delay isn't accounted for until all rockets and targets for the player have been cleared
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
            sprite:SetFrame(animName or sprite:GetAnimation(), math.floor(math.min((1 - fireDelay / player.MaxFireDelay) * BAR_FRAME_COUNT, BAR_FRAME_COUNT)))
        end
        sprite:Render(Isaac.WorldToScreen(player.Position) + BAR_RENDER_POSITION_OFFSET)
    end
end

TearBar:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, TearBar.RenderSprite, 0)