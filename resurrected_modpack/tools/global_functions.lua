local mod = require("resurrected_modpack.mod_reference")

mod.Functions = {}

function mod.Functions.GetScreenSize()
    if REPENTANCE then
        return Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    end

    -- ab+ / based off of code from kilburn
    local room = Game():GetRoom()
    local pos = room:WorldToScreenPosition(Vector(0,0)) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset

    local rx = pos.X + 60 * 26 / 40
    local ry = pos.Y + 140 * (26 / 40)

    return Vector(rx * 2 + 13 * 26, ry * 2 + 7 * 26)
end

function mod.Functions.GetStageAPIBossId()
    if not StageAPI then
        return nil
    end
    local currentRoom = StageAPI.GetCurrentRoom()
    if not currentRoom then
        return nil
    end
    return currentRoom.PersistentData.BossID
end

if REPENTOGON then
    function mod.Functions.IsAchievementUnlocked(AchievementId)
        return Isaac.GetPersistentGameData():Unlocked(AchievementId)
    end
else
    function mod.Functions.IsAchievementUnlocked(AchievementId)
        return mod.Lib.AchievementChecker:IsAchievementUnlocked(AchievementId)
    end
end

function mod.Functions.IsDebugModeActive(mode)
    local cmd = "debug " .. mode

    local result = Isaac.ExecuteCommand(cmd)
    Isaac.ExecuteCommand(cmd)

    return result == "Disabled debug flag."
end
