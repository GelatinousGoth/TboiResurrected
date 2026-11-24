--[[ Utils ]]--
local mod = EnhancementChamber
local game = Game()

-- Loggin system
---@param msg string
function EnhancementChamber:Log(msg)
    ---@type string
    local prefix = "[" .. self.Name .. "] "

    Isaac.DebugString(prefix .. msg)
    print(prefix .. msg)
end

-- Sets RNG
mod.RNG = RNG()
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
	mod.RNG:SetSeed(game:GetSeeds():GetStartSeed(), 35)
end)

---@param cfg string
---@return boolean?
function EnhancementChamber:HasConfig(cfg)
    return self.Config[cfg].bool
end

-- Gets vulnerable player
---@param pos Vector
---@return EntityPlayer?
function mod:GetNearestVulnerablePlayer(pos)
    local nearestPlayer = nil
    local nearestDistance = math.huge
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player.SubType ~= 35 and not player:IsDead() then
            local distance = (player.Position - pos):Length()
            if distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end
    return nearestPlayer -- player:HasInvincibility()
end

-- Identifies roomDesc by name
---@param _type RoomType
---@param name string
---@param desc RoomDescriptor?
---@return boolean
function EnhancementChamber:CheckRoom(_type, name, desc)
    local roomDesc = desc or game:GetLevel():GetCurrentRoomDesc()
    if roomDesc.Data.Type == _type and string.find(roomDesc.Data.Name, name) then
        return true
    end
    return false
end

-- Removes grid entities from room center position
---@param radius number
function EnhancementChamber:ClearEffectPos(radius)
    local room = game:GetLevel():GetCurrentRoom()
    for i = 0, room:GetGridSize() - 1 do
        local gridEntity = room:GetGridEntity(i)
        if gridEntity then
            local pos = room:GetCenterPos()
            local distance = pos:Distance(gridEntity.Position)
            if distance < radius then
                room:RemoveGridEntityImmediate(gridEntity:GetGridIndex(), 0, false)
            end
        end
    end
end