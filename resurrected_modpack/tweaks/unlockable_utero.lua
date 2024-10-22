local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Unlockable Utero", 1)

if REPENTOGON then

    Achievement.UTERO = Isaac.GetAchievementIdByName("The Utero")

    function mod:preLevelSelect(level, type)
        if level == LevelStage.STAGE4_1 or level == LevelStage.STAGE4_2 then
            if type == StageType.STAGETYPE_WOTL then
                if not Isaac.GetPersistentGameData():Unlocked(Achievement.UTERO) then
                    print("Unlockable Utero: Utero replaced")
                    return { level, StageType.STAGETYPE_ORIGINAL }
                end
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, mod.preLevelSelect)

    function mod:CheckUteroUnlock()
        local persistentGameData = Isaac.GetPersistentGameData()
        if persistentGameData:Unlocked(Achievement.WOMB) and
            persistentGameData:IsBossKilled(BossType.BLASTOCYST) and
            persistentGameData:IsBossKilled(BossType.LOKII) and
            persistentGameData:IsBossKilled(BossType.MEGA_GURDY) and
            persistentGameData:IsBossKilled(BossType.MR_FRED) and
            persistentGameData:IsBossKilled(BossType.SCOLEX) then

            persistentGameData:TryUnlock(Achievement.UTERO)
        end
    end
    mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.CheckUteroUnlock)

    function mod:postSaveSlotLoad(_, _, slot)
        if slot ~= 0 then
            mod:CheckUteroUnlock()
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, mod.CheckUteroUnlock)

else
    print("Unlockable Utero requires REPENTOGON installed to function!")
end