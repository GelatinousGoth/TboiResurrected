--BUUUUUUURRRRRRRPPPP
--Changes all bosses weight > 1 to be 1
--This mod has to load after the others for this to work though. Which is why it is called zweightfix (z is the last letter of the alphabet...)

local AllowWeight2ForAfterbirth
--AllowWeight2ForAfterbirth = true -- (e.g. Burning Basement, Flooded Caves, Dank Depths, Scarred Womb)

local TR_Manager = require("resurrected_modpack.manager")

---@type ModReference
FFWeightFixMod = TR_Manager:RegisterMod("CustomBossWeightFix", 1)

local alphabet = {"Flash","WOTL","AB","Greed","Rep","RepB"}

local function ReduceBossWeights()
  if not StageAPI then
    return
  end

  for stageType = StageType.STAGETYPE_ORIGINAL, StageType.STAGETYPE_REPENTANCE_B, 1 do
    for stage = LevelStage.STAGE1_1, LevelStage.STAGE7 do
      local floorInfo = StageAPI.GetBaseFloorInfo(stage, stageType, false)
  
      if floorInfo and floorInfo.Bosses and floorInfo.Bosses.Pool then
         for _, poolEntry in ipairs(floorInfo.Bosses.Pool) do
  
          --print("Boss:"..poolEntry.BossID.." Stage:"..alphabet[stageType+1]..stage)
  
            if poolEntry.Weight and poolEntry.Weight > 1 and poolEntry.Weight < 10 then --If the weight is that high the mod devs probably want it guaranteed.
              local set = 1
              if AllowWeight2ForAfterbirth and stageType == StageType.STAGETYPE_AFTERBIRTH and poolEntry.Weight <= 2 then goto continue
              elseif poolEntry.Weight > 2 then set = 2 end
              -- print("Boss:"..poolEntry.BossID.." Stage:"..alphabet[stageType+1]..stage.." set weight to "..set.." (was "..poolEntry.Weight..")")
              poolEntry.Weight = set
            end
            ::continue::
          end
      end
    end
  end
end

FFWeightFixMod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ReduceBossWeights)

-- print("Changed Modded Boss Weight :D")