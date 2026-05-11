function CoopHudFixEnabler()

-- Multiplayer HUD Fix
-- Fixes vanilla Isaac bug where players 2+ lose HUD elements after full game restart
-- Root cause: Controller system not ready during save restoration, causing HUD assignment to fail
-- Author: Phr3d13
local mod = IsaacReflourished
local CoopHudFix = {}
-- Track controller system state
local controllerSystemReady = false
local gameStarted = false
local updateFrameCount = 0
local maxWaitFrames = 60 -- Wait up to 1 second for controllers to stabilize
local lastControllerCheck = 0
local fixComplete = false -- Flag to stop all processing once done

-- Function to check if controller system appears stable
local function isControllerSystemStable()
    local game = Game()
    local validControllers = 0
    
    for i = 0, game:GetNumPlayers() - 1 do
        local player = game:GetPlayer(i)
        if player then
            local controllerIndex = player.ControllerIndex
            
            -- Count players with valid controller assignments
            if controllerIndex >= 0 and controllerIndex ~= 4294967295 then
                validControllers = validControllers + 1
            end
        end
    end
    
    local numPlayers = game:GetNumPlayers()
    
    -- System is stable if all players have valid controllers
    return validControllers == numPlayers and validControllers > 1
end

-- Function to force HUD reassignment when controllers are stable
local function forceHUDReassignment()
    local game = Game()
    local hud = game:GetHUD()
    
    if hud.AssignPlayerHUDs then
        hud:AssignPlayerHUDs()
        return true
    else
        return false
    end
end

-- Reset tracking when a new game starts
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    local game = Game()
    local numPlayers = game:GetNumPlayers()
    
    -- Only activate for multiplayer games
    if numPlayers > 1 then
        controllerSystemReady = false
        gameStarted = true
        updateFrameCount = 0
        lastControllerCheck = 0
        fixComplete = false
        
        -- Try immediate fix since controllers might already be stable at game start
        if isControllerSystemStable() then
            forceHUDReassignment()
            fixComplete = true
        end
    else
        gameStarted = false
        fixComplete = true -- Skip all processing for single player
    end
end)

-- Monitor controller system and apply fix when stable
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    -- Exit early if processing is complete or game hasn't started
    if fixComplete or not gameStarted then
        return
    end
    
    updateFrameCount = updateFrameCount + 1
    
    -- Check every 5 frames initially (much more aggressive), then every 15 frames
    local checkInterval = updateFrameCount < 30 and 5 or 15
    
    -- Only monitor during the critical window after game start
    if updateFrameCount < maxWaitFrames and not controllerSystemReady then
        -- Check controller stability more frequently during critical period
        if updateFrameCount - lastControllerCheck >= checkInterval then
            lastControllerCheck = updateFrameCount
            
            if isControllerSystemStable() then
                controllerSystemReady = true
                
                -- Apply fix immediately
                forceHUDReassignment()
                
                -- Mark processing as complete - stop all future callbacks
                fixComplete = true
            end
        end
    elseif updateFrameCount >= maxWaitFrames and not controllerSystemReady then
        fixComplete = true -- Stop trying
    end
end)

-- Log when players are initialized to track the bug
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    -- This callback exists primarily for debugging purposes during development
    -- Player initialization timing can help understand when controller assignments occur
end)

-- Also try to fix during render (works even when game is paused)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    -- Only run during the critical early period and if not already complete
    if fixComplete or not gameStarted or updateFrameCount > 30 then
        return
    end
    
    -- Check if controllers became stable during pause
    if not controllerSystemReady and isControllerSystemStable() then
        controllerSystemReady = true
        forceHUDReassignment()
        fixComplete = true
    end
end)

-- Provide console command to manually trigger fix and check status
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
    if cmd == "fixhud" then
        fixComplete = false -- Reset so we can try again
        
        if isControllerSystemStable() then
            forceHUDReassignment()
            Isaac.DebugString("Manual HUD fix applied")
        else
            Isaac.DebugString("Controller system not stable - cannot apply fix")
        end
    elseif cmd == "checkhud" then
        local game = Game()
        Isaac.DebugString("HUD Status - Players: " .. game:GetNumPlayers() .. 
                         ", Fix complete: " .. tostring(fixComplete) .. 
                         ", Game started: " .. tostring(gameStarted))
        isControllerSystemStable() -- Check controller status
    end
end)

end
return CoopHudFixEnabler