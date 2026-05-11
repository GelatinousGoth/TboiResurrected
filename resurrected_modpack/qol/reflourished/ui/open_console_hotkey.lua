local function OpenConsoleHotkeyEnabler()

local mod = IsaacReflourished
mod.OpenConsole = {}

-- ---@param entity Entity
-- mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)

--     if not player then return end


-- end)


mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, inputHook, buttonAction)
    --if buttonAction ~= 13 then return end
    local player = entity and entity:ToPlayer()
    if not player then return end
    
    -- if Input.IsButtonTriggered(13, player.ControllerIndex) then
    --     print("right stick pressed")
    -- end

    -- if Input.IsButtonPressed(15, player.ControllerIndex) then
    --     print("start pressed")
    -- end

    -- --Right stick
    -- if Input.IsButtonTriggered(13, player.ControllerIndex) and ImGui:IsVisible() then
    --     ImGui:Hide()
    --     --PauseMenu.SetState(PauseMenuStates.CLOSED)
    -- end

    --Select and right stick
    if not ImGui:IsVisible() and Input.IsButtonPressed(14, player.ControllerIndex) and Input.IsButtonTriggered(13, player.ControllerIndex) then
        --PauseMenu.SetState(PauseMenuStates.OPEN)
        ImGui:Show()

    end


end, InputHook.IS_ACTION_TRIGGERED)

end
return OpenConsoleHotkeyEnabler