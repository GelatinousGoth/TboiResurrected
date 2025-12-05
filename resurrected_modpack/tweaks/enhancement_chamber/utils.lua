--[[ Utils ]]--
local mod = EnhancementChamber
local game = Game()

-- Loggin system
---@param msg string
function mod:Log(msg)
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

-- Gets vulnerable player
---@param pos Vector
---@return EntityPlayer | nil
function mod.getNearestVulnerablePlayer(pos)
    local nearestPlayer = nil
    local nearestDistance = math.huge
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player.SubType ~= 35 and not player:HasInvincibility() and not player:IsDead() then
            local distance = (player.Position - pos):Length()
            if distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end
    return nearestPlayer
end

-- Identifies roomDesc by name
---@param type RoomType
---@param name string
---@param desc RoomDescriptor
function mod.checkRoom(type, name, desc)
    local roomDesc = desc or game:GetLevel():GetCurrentRoomDesc()
    if roomDesc.Data.Type == type and string.find(roomDesc.Data.Name, name) then
        return true
    end
    return false
end

-- Removes grid entities from room center position
---@param radius number
function mod.clearEffectPos(radius)
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

-- Item rerolls when changing item pool
---@param pool ItemPoolType
---@return nil
function mod.itemReroll(pool)
    local player = Isaac.GetPlayer(0)
    local room = game:GetLevel():GetCurrentRoom()
    room:SetItemPool(pool)
    if room:IsFirstVisit() then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false, -1)
        local effects = Isaac.FindByType(1000, 15)
        for i = 1, #effects do effects[i]:Remove() end
    end
end