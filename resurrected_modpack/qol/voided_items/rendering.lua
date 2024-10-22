-- Pause menu state tracking.
local PAUSE_STATES = {
	UNPAUSED = {
		[ButtonAction.ACTION_PAUSE] = "RESUME",
		[ButtonAction.ACTION_MENUBACK] = "RESUME",
		[Keyboard.KEY_GRAVE_ACCENT] = "IN_CONSOLE",
	},
	UNPAUSING = {},
	OPTIONS = {
		[ButtonAction.ACTION_PAUSE] = "UNPAUSING",
		[ButtonAction.ACTION_MENUBACK] = "UNPAUSING",
		[ButtonAction.ACTION_MENUCONFIRM] = "IN_OPTIONS",
		[ButtonAction.ACTION_MENUDOWN] = "RESUME",
		[ButtonAction.ACTION_MENUUP] = "EXIT",
		[Keyboard.KEY_GRAVE_ACCENT] = "UNPAUSING",
	},
	RESUME = {
		[ButtonAction.ACTION_PAUSE] = "UNPAUSING",
		[ButtonAction.ACTION_MENUBACK] = "UNPAUSING",
		[ButtonAction.ACTION_MENUCONFIRM] = "UNPAUSING",
		[ButtonAction.ACTION_MENUDOWN] = "EXIT",
		[ButtonAction.ACTION_MENUUP] = "OPTIONS",
		[Keyboard.KEY_GRAVE_ACCENT] = "UNPAUSING",
	},
	EXIT = {
		[ButtonAction.ACTION_PAUSE] = "UNPAUSING",
		[ButtonAction.ACTION_MENUBACK] = "UNPAUSING",
		[ButtonAction.ACTION_MENUDOWN] = "OPTIONS",
		[ButtonAction.ACTION_MENUUP] = "RESUME",
		[Keyboard.KEY_GRAVE_ACCENT] = "UNPAUSING",
	},
	IN_OPTIONS = {
		Ignore = ButtonAction.ACTION_PAUSE,
		[ButtonAction.ACTION_MENUBACK] = "OPTIONS",
		[Keyboard.KEY_GRAVE_ACCENT] = "UNPAUSING",
	},
	IN_CONSOLE = {
		[ButtonAction.ACTION_PAUSE] = "IN_CONSOLE",
		[ButtonAction.ACTION_MENUBACK] = "UNPAUSED",
	},
}

local wasPausedLastFrame = false
local currentPauseState = "UNPAUSED"

local function UpdatePauseTrackingState()
	local isPaused = Game():IsPaused()
	local pausedLastFrame = wasPausedLastFrame
	wasPausedLastFrame = isPaused
	
	if not Game():IsPaused() then
		currentPauseState = "UNPAUSED"
		currentAnim = nil
		return
	elseif currentPauseState == "UNPAUSED" and pausedLastFrame then
		return
	end
	
	local cid = Game():GetPlayer(0).ControllerIndex
	
	if PAUSE_STATES[currentPauseState].Ignore and Input.IsActionTriggered(PAUSE_STATES[currentPauseState].Ignore, cid) then
		return
	end
	
	for buttonAction, state in pairs(PAUSE_STATES[currentPauseState]) do
		if type(buttonAction) == "number" and (Input.IsActionTriggered(buttonAction, cid) or Input.IsButtonTriggered(buttonAction, cid)) then
			currentPauseState = state
			return
		end
	end
end

-- Darkens sprite colors to align with pause state, etc.
fadeData = {}
local function UpdateSpriteColor(sprite)
	local target
	if currentPauseState == "UNPAUSED" or currentPauseState == "UNPAUSING" then target = 1.0
	else target = 0.5 end
	
	local speed = 0.1
	if currentPauseState == "UNPAUSING" then speed = 0.03 end
	
	local alreadyUpdated = (fadeData.LastUpdate == Isaac.GetFrameCount())
	local current = fadeData.Value or 1.0
	local new = current
	if not alreadyUpdated and target > current then new = math.min(current + speed, target)
	elseif not alreadyUpdated and target < current then new = math.max(current - speed, target)
	else new = current end
	fadeData.Value = new
	fadeData.LastUpdate = Isaac.GetFrameCount()
	
	sprite.Color = Color(new, new, new, 0.6)
end

VoidedItems:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
    UpdatePauseTrackingState()
    VoidedItems:UpdatePlayers()
    for _, sprite in pairs(VoidedItems.itemSprites) do
        UpdateSpriteColor(sprite)
    end
end)

VoidedItems:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName)
    if shaderName == "PauseScreenCompletionMarks" and Game():GetHUD():IsVisible() then
        VoidedItems:RenderItems()
    end
end)