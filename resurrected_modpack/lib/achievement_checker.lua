local AchievementChecker = {}

local Mod = require("resurrected_modpack.mod_reference")

local previousLockCallbackRecord = Mod.LockCallbackRecord
Mod.LockCallbackRecord = true

local ACHIEVEMENT_TRACKERS = {}
local TRINKET_PER_ACHIEVEMENT = {}

local function RemoveAchievementTrinkets()
    local itemPool = Game():GetItemPool()

    for trinket, _ in pairs(ACHIEVEMENT_TRACKERS) do
        itemPool:RemoveTrinket(trinket)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
    RemoveAchievementTrinkets()
end)

local antiRecursion

Mod:AddCallback(ModCallbacks.MC_GET_TRINKET, function (_, trinket)
    if ACHIEVEMENT_TRACKERS[trinket] and not antiRecursion then
        antiRecursion = true

        RemoveAchievementTrinkets()

        local itemPool = Game():GetItemPool()
        local new = itemPool:GetTrinket()

        antiRecursion = false

        return new
    end
end)

---@param pickup EntityPickup
local function CheckToReplaceTrinket(pickup)
    if ACHIEVEMENT_TRACKERS[pickup.SubType] then
        local itemPool = Game():GetItemPool()
        local trinket = itemPool:GetTrinket()
        pickup:Morph(pickup.Type, pickup.Variant, trinket, true, false, true)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function (_, pickup)
    CheckToReplaceTrinket(pickup)
end, PickupVariant.PICKUP_TRINKET)

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function (_, pickup)
    CheckToReplaceTrinket(pickup)
end, PickupVariant.PICKUP_TRINKET)


---Adds a trinket tied to an achievement that will be used to check if the achievement is unlocked.
---
---To create a custom trinket tied to an achievement add this in your items.xml:
---```xml
---<trinket name="Unique name" description="" achievement="[id of the achievement]"/>
---```
---@param trinket TrinketType
function AchievementChecker:AddTrackerTrinket(trinket)
    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)
    local achievement = trinketInfo.AchievementID

    if not achievement or achievement <= 1 then
        print("[ACHIEVEMENT TRACKER - ERROR] Trying to register a trinket that isn't tied to an achievement: " .. trinket)
        return
    end

    if trinketInfo.Hidden then
        print("[ACHIEVEMENT TRACKER - ERROR] Trying to register a hidden trinket will never show as available: " .. trinket)
        return
    end

    ACHIEVEMENT_TRACKERS[trinket] = true
    TRINKET_PER_ACHIEVEMENT[trinketInfo.AchievementID] = trinket
end


---Helper function to check if a vanilla achievement is unlocked.
---@param achievement integer
---@return boolean
function AchievementChecker:IsAchievementUnlocked(achievement)
    local trinket = TRINKET_PER_ACHIEVEMENT[achievement]

    if not trinket then
        print("[ACHIEVEMENT TRACKER - WARNING] No trinket associated to achievement: " .. achievement)
    end

    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)

    return trinketInfo:IsAvailable()
end

Mod.LockCallbackRecord = previousLockCallbackRecord

Mod.Lib.AchievementChecker = AchievementChecker

require("resurrected_modpack.tools.tracked_achievements")