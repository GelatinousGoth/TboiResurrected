local function ExcitedTimerEnabler()

local ExcitedTimer = {}
local mod = IsaacReflourished

local excitedEffect = Isaac.GetNullItemIdByName("RF I'm Excited")
local excitedCooldown = 30*30*3  --30 Seconds
local anyPlayerHasExcited = false
local playerTimers = {}
local fadeAlpha = {}

---@param player EntityPlayer
function ExcitedTimer:UsePill(effect, player, flags, color)

    if color & PillColor.PILL_GIANT_FLAG ~= 0 then
    end

    -- local currentTimer = playerTimers[GetPtrHash(player)]
    -- if currentTimer and currentTimer > 0 then return end

    playerTimers[GetPtrHash(player)] = excitedCooldown
    anyPlayerHasExcited = true
end
mod:AddCallback(ModCallbacks.MC_USE_PILL, ExcitedTimer.UsePill, PillEffect.PILLEFFECT_IM_EXCITED)

function ExcitedTimer:NewGame(isContinued)
    anyPlayerHasExcited = false
    playerTimers = {}
    fadeAlpha = {}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ExcitedTimer.NewGame, PillEffect.PILLEFFECT_IM_EXCITED)


function ExcitedTimer:Countdown(player)
    if not anyPlayerHasExcited then return end
    local cooldown = playerTimers[GetPtrHash(player)]
    if not cooldown then return end


    if cooldown <= 0 then
        playerTimers[GetPtrHash(player)] = nil
        local playersHaveExcited = false
        for _, player in pairs(PlayerManager.GetPlayers()) do
            if playerTimers[GetPtrHash(player)] and playerTimers[GetPtrHash(player)] > 0 then
                playersHaveExcited = true
            end
        end
        if not playersHaveExcited then anyPlayerHasExcited = false end
        return
    end

    playerTimers[GetPtrHash(player)] = math.max(0, cooldown - 1)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ExcitedTimer.Countdown)


local font = Font()
font:Load("font/pftempestasevencondensed.fnt")
local timer = Sprite()
timer:Load("gfx/excited pill timer.anm2",true)
timer:SetFrame("Default", 0)
--timer.Scale = Vector(0.8, 0.8)
function ExcitedTimer:RenderIcon()
	if not Game():GetHUD():IsVisible() then return end
    if not anyPlayerHasExcited then return end
    if RoomTransition.GetTransitionMode() ~= 0 then return end

    for _, player in pairs(PlayerManager.GetPlayers()) do
        if playerTimers[GetPtrHash(player)] then
            ExcitedTimer:RenderPlayer(player)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_HUD_RENDER, ExcitedTimer.RenderIcon)


---@param player EntityPlayer
function ExcitedTimer:RenderPlayer(player)
    local index = GetPtrHash(player)
    local cooldown = playerTimers[index]
    local seconds = math.ceil((cooldown / 30 % 30))
    local show = Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) or seconds <= 9 or seconds > 26
    if Minimap.GetState() == 2 then show = true end
    fadeAlpha[index] = fadeAlpha[index] or 0

    local showSeconds = IsaacReflourished:GetSettingsValue("ExcitedTimerShowSeconds") == 2
    local displayPos = IsaacReflourished:GetSettingsValue("ExcitedTimerDisplayPos")

    local fadeSpeed = 0.1  -- smaller = slower fade
    if show then
        fadeAlpha[index] = math.min(0.7, fadeAlpha[index] + fadeSpeed)
    else
        fadeAlpha[index] = math.max(0, fadeAlpha[index] - fadeSpeed)
    end
    if fadeAlpha[index] <= 0 then return end

    local alpha = fadeAlpha[index]
    local pos = Isaac.WorldToScreen(player.Position) + Vector(-1, -41)
    if displayPos and displayPos == 2 then
        pos = pos + Vector(-13, 45)
    end
    local timerFrame = 15 - math.floor(seconds / 2)

    if Game():GetRoom():IsMirrorWorld() then
        local midPos = Isaac.GetScreenWidth() / 2
        local diff = midPos - pos.X
        pos = Vector(midPos + diff, pos.Y) + Vector(-2, -2)
    end

    timer:SetFrame("Default", timerFrame)
    timer.Color = Color(1, 1, 1, alpha)  -- set icon transparency
    timer:Render(pos)

    local color = KColor(1, 1, 1, alpha * 0.8)  -- slightly lower alpha for text
    if showSeconds then
        font:DrawStringScaled(tostring(seconds), pos.X + 5, pos.Y + 2, 0.75, 0.75, color, 0, false)
    end
end

function ExcitedTimer:CleanTable(player)
    local index = GetPtrHash(player)
    playerTimers[index] = nil
    fadeAlpha[index] = nil

end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, ExcitedTimer.CleanTable, EntityType.ENTITY_PLAYER)

end
return ExcitedTimerEnabler