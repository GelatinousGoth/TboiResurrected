local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Cracked Key on Devil Warp", 1, true)

---@param lootList LootList
---@return boolean
local function LootList_is_deal_warp(lootList)
    local entries = lootList:GetEntries()
    for i = 1, #entries, 1 do
        local entry = entries[i]
        local entry_isDealWarp = entry:GetType() == 0 and entry:GetVariant() == 1
        if entry_isDealWarp then
            return true
        end
    end

    return false
end

---@return boolean
local function Warp_is_devil()
    local game = Game()
    local level = game:GetLevel()

    local devilRNG = level:GetDevilAngelRoomRNG()
    local devilRNG_copySeed = devilRNG:GetSeed()
    local devilRNG_copyShiftIdx = devilRNG:GetShiftIdx()
    local krampusSpawned_copy = game:GetStateFlag(GameStateFlag.STATE_KRAMPUS_SPAWNED)

    level:InitializeDevilAngelRoom(false, false)
    local dealRoom = level:GetRoomByIdx(GridRooms.ROOM_DEVIL_IDX, -1).Data
    local isDevil = dealRoom and dealRoom.Type == RoomType.ROOM_DEVIL

    devilRNG:SetSeed(devilRNG_copySeed, devilRNG_copyShiftIdx)
    game:SetStateFlag(GameStateFlag.STATE_KRAMPUS_SPAWNED, krampusSpawned_copy)

    return isDevil
end

---@param pickup EntityPickup
---@param lootList LootList
---@param shouldAdvance boolean
---@param rng RNG
local function GetLootList(_, pickup, lootList, shouldAdvance, rng)
    local chest_isRedChest = pickup.Variant == PickupVariant.PICKUP_REDCHEST
    if not chest_isRedChest then
        return
    end

    if not shouldAdvance then
        return
    end

    if LootList_is_deal_warp(lootList) and Warp_is_devil() then
        -- do not create side effects so as to avoid modifying the results compared to non advanced seeds.
        lootList:PushEntry(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, rng:GetSeed())
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_GET_LOOT_LIST, GetLootList)