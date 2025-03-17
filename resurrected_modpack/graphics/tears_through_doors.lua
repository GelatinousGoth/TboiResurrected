local TR_Manager = require("resurrected_modpack.manager")
local tearMod = TR_Manager:RegisterMod("Tears Through Doors", 1)

function tearMod:OnTearUpdate(tear)
    -- Only affect player tears
    if tear.Parent and tear.Parent.Type == EntityType.ENTITY_PLAYER then
        local room = Game():GetRoom()
        local tearPos = tear.Position
        
        -- Check all doors (0-7 slots)
        for i = 0, 7 do
            local door = room:GetDoor(i)
            if door and door:IsOpen() then
                local doorPos = door.Position
                local distanceToDoor = tearPos:Distance(doorPos)
                
                -- If tear is close to an open door
                if distanceToDoor < 17 then -- Wider range to catch it earlier
                    -- Prevent despawn and keep visible
                    tear.Height = 100 -- Slightly higher to stay in view
                    tear.CollisionDamage = tear.CollisionDamage -- Preserve damage
                    
                    -- Nudge tear past the door more aggressively
                    local direction = tear.Velocity:Normalized()
                    local nudgeDistance = 200 -- Bigger push to skip despawn zone
                    tear.Position = tearPos + (direction * nudgeDistance)
                    tear.Velocity = tear.Velocity -- Maintain momentum
                    
                    -- Force update to keep it alive
                    tear:Update()
                end
            end
        end
    end
end

-- Register the callback
tearMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, tearMod.OnTearUpdate)

print("TearsThroughDoors mod loaded (v4)!")