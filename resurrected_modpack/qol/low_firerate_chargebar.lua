local TR_Manager = require("resurrected_modpack.manager")
local TearBar = TR_Manager:RegisterMod("Low Firerate Chargebar", 1)

local sprite = Sprite()
sprite:Load("gfx/tear_chargebar.anm2", true)

local BAR_FRAME_COUNT = 100
local BAR_RENDER_POSITION_OFFSET = Vector(0, 14)
local TEAR_THRESHOLD = 1

local function toTearsPerSecond(maxFireDelay)
    return 30 / (maxFireDelay + 1)
end

---@param player EntityPlayer
function TearBar:RenderSprite(player)
    local data = player:GetData()
    data.TearBarAlpha = data.TearBarAlpha or 0
    local tps = toTearsPerSecond(player.MaxFireDelay)
    if player:HasWeaponType(WeaponType.WEAPON_TEARS) and tps <= TEAR_THRESHOLD then
        data.TearBarAlpha = math.min(data.TearBarAlpha + 0.1, 1)
    else
        data.TearBarAlpha = math.max(data.TearBarAlpha - 0.1, 0)
    end

    if data.TearBarAlpha > 0 then
        sprite.Color = Color(1, 1, 1, data.TearBarAlpha)
        sprite:SetFrame("Charging", math.floor(math.min((1 - player.FireDelay / player.MaxFireDelay) * BAR_FRAME_COUNT, BAR_FRAME_COUNT)))
        sprite:Render(Isaac.WorldToScreen(player.Position) + BAR_RENDER_POSITION_OFFSET)
    end
end

TearBar:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, TearBar.RenderSprite, 0)