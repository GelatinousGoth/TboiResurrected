local function LTSkipEnabler()

local mod = IsaacReflourished
local LTSkip = {}


mod:AddCallback(ModCallbacks.MC_POST_NIGHTMARE_SCENE_RENDER, function()
    local player = Isaac.GetPlayer()
    if not player then return end
    if not (Input.IsButtonTriggered(9, player.ControllerIndex) or --Left trigger
    Input.IsButtonTriggered(8, player.ControllerIndex)) then return end --Left Bumper
    --if not Input.IsActionPressed(ButtonAction.ACTION_BOMB, player.ControllerIndex) then return end
    -- print("bomb")

    local sprite = NightmareScene.GetBubbleSprite()

    if sprite and sprite:IsPlaying() then
        sprite:Stop()
    end

end)

mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRANSITION_UPDATE, function()
    if not RoomTransition.IsRenderingBossIntro() then return end
    local player = Isaac.GetPlayer()
    if not player then return end
    if not (Input.IsButtonTriggered(9, player.ControllerIndex) or --Left trigger
    Input.IsButtonTriggered(8, player.ControllerIndex)) then return end --Left Bumper
    --if not Input.IsActionPressed(ButtonAction.ACTION_BOMB, player.ControllerIndex) then return end

    local sprite = RoomTransition.GetVersusScreenSprite()
    if sprite and sprite:IsPlaying() then
        sprite:Stop()
    end


end)

end
return LTSkipEnabler