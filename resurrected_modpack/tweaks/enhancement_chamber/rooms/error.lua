--[[ Error ]]--
local mod = EnhancementChamber
local game = Game()
local music = MusicManager()

-- Error Jingle
function mod:ErrorJingle(room)
    if not self:HasConfig("error_jingle") then return end -- config
    if room:GetType() ~= RoomType.ROOM_ERROR then return end

    local jingleChance = math.random(3)
    local getJingle = Isaac.GetMusicIdByName("Error Room Entry (jingle) " .. tostring(jingleChance))
    music:PlayJingle(getJingle, 150)
end
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, mod.ErrorJingle)

-- Error Item Pool
---@param seed integer
---@return integer?
function mod:ErrorItemPool(_, _, seed)
    if not self:HasConfig("error_itempool") then return end -- config

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_ERROR then return end

    local glitchUnlock = Isaac.GetPersistentGameData():Unlocked(Achievement.TMTRAINER)
    if not glitchUnlock then return end

    return ProceduralItemManager.CreateProceduralItem(seed, 0)
end
mod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, mod.ErrorItemPool)