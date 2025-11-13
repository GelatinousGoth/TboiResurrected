--[[ Utils ]]--
local mod = EnhancementChamber
local game = Game()

-- Persistant Data --
local json = require("json")

-- Save Data
function mod:saveAll()
    local jsonData = json.encode({
        data = mod.Data,
        special = mod.ConfigSpecial,
        misc = mod.ConfigMisc,
    })
    mod:SaveData(jsonData)
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveAll)

-- Load Data
function mod:loadAll(isContinued)
    if not mod:HasData() then
        -- Initializes with default values
        for k, v in pairs(mod.DefaultData) do
            mod.Data[k] = v
        end
        return
    end

    local loaded = json.decode(mod:LoadData())

    -- Avoids getting data from last run
    if isContinued and loaded.data then
        for k, v in pairs(mod.DefaultData) do
            if loaded.data[k] ~= nil then
                mod.Data[k] = loaded.data[k]
            else
                mod.Data[k] = v
            end
        end
    else
        -- Restarts if not continue
        for k, v in pairs(mod.DefaultData) do
            mod.Data[k] = v
        end
    end

    -- Persistant configuration
    if loaded.special then
        for k in pairs(mod.ConfigSpecial) do
            if loaded.special[k] ~= nil then
                mod.ConfigSpecial[k] = loaded.special[k]
            end
        end
    end

    -- Miscellaneous
    if loaded.misc then
        for k in pairs(mod.ConfigMisc) do
            if loaded.misc[k] ~= nil then
                mod.ConfigMisc[k] = loaded.misc[k]
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadAll)

-- Sets RNG --
mod.RNG = RNG()
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
	mod.RNG:SetSeed(game:GetSeeds():GetStartSeed(), 35)
end)

-- Gets vulnerable player --
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

-- identifies roomDesc by name
function mod.checkRoom(type, name, desc)
    local roomDesc = desc or game:GetLevel():GetCurrentRoomDesc()
    if roomDesc.Data.Type == type and string.find(roomDesc.Data.Name, name) then
        return true
    end
    return false
end

-- Removes grid entities from room center position
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

-- Item reroll when changing item pool
function mod.itemReroll(pool)
    local player = Isaac.GetPlayer(0)
    local room = game:GetLevel():GetCurrentRoom()
    room:SetItemPool(pool)
    if room:IsFirstVisit() then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false, -1, 0)
        local effects = Isaac.FindByType(1000, 15, -1)
        for i = 1, #effects do effects[i]:Remove() end
    end
end