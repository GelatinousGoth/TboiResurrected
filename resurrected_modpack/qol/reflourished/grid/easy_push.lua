local function EasyPushEnabler()

local EasyPush = {}
local mod = IsaacReflourished


local function getDir(angle)
    angle = (angle + 360) % 360

    if angle >= 345 or angle < 15 then
        return Vector(-1, 0)                -- From Right
    elseif angle < 75 then
        return Vector(-1, -1):Normalized()  -- From Up-Right
    elseif angle < 105 then
        return Vector(0, -1)                -- From Up
    elseif angle < 165 then
        return Vector(1, -1):Normalized()   -- From Up-Left
    elseif angle < 195 then
        return Vector(1, 0)                 -- From Left
    elseif angle < 255 then
        return Vector(1, 1):Normalized()    -- From Down-Left
    elseif angle < 285 then
        return Vector(0, 1)                 -- From Down
    elseif angle < 345 then
        return Vector(-1, 1):Normalized()   -- From Down-Right
    end

    return Vector(1, 1)
end



function EasyPush:PushObject(player, collider, low)

    if not ((collider.Type == EntityType.ENTITY_MOVABLE_TNT) or (collider.Type == EntityType.ENTITY_PICKUP and collider.Variant == PickupVariant.PICKUP_BOMBCHEST)) then return end
    if not low then return end

    local tnt = collider
    local inputDir = player:GetMovementInput()

    if inputDir:Length() < 0.1 then return end


    local angle = (player.Position - tnt.Position):GetAngleDegrees()
    angle = (angle + 360) % 360

    tnt.Velocity = getDir(angle):Resized(player.Velocity:Length() * 1.65)

    local overlap = (player.Position - tnt.Position):Length() - (player.Size + tnt.Size)

    --print(overlap)
    player.Velocity = player.Velocity + getDir(angle):Resized(math.max(-2, math.min(2, overlap)))

    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, EasyPush.PushObject)

end
return EasyPushEnabler