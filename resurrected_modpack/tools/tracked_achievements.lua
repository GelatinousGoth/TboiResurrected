local mod = require("resurrected_modpack.mod_reference")

local trackedAchievements = {
    [Achievement.RED_KEY] = Isaac.GetTrinketIdByName("##RESURRECTED_RED_KEY_ACHIEVEMENT_TRACKER"),
    [Achievement.WOODEN_CHEST] = Isaac.GetTrinketIdByName("##RESURRECTED_WOODEN_CHEST_ACHIEVEMENT_TRACKER")
}

local itemConfig = Isaac.GetItemConfig()
for achievementId, trinketId in pairs(trackedAchievements) do
    local trinketInfo = itemConfig:GetTrinket(trinketId)
    if achievementId ~= trinketInfo.AchievementID then
        print("[ACHIEVEMENT TRACKER - ERROR] trinket " .. trinketInfo.Name .. " is not tied to the correct achievement: " .. achievementId)
        goto continue
    end

    mod.Lib.AchievementChecker:AddTrackerTrinket(trinketId)

    ::continue::
end