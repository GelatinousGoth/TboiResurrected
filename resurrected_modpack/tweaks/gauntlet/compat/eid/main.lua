if EID == nil then return end



local eidIcons = Sprite()
eidIcons:Load("gfx/gauntlet/ui/eid_inline_icons.anm2", true)

EID:addIcon("GauntletGauntletRoomStat",         "GauntletRoom", 0, 14, 14, 0, -1, eidIcons)
EID:addIcon("GauntletGauntletRoomMap",          "GauntletRoom", 1, 9, 9, 0, 3, eidIcons)
EID:addIcon("GauntletGauntletRoomStatSmall",    "GauntletRoom", 2, 9, 9, 0, 1, eidIcons)
EID:addIcon("GauntletGauntletRoomPool",         "GauntletRoom", 3, 9, 9, 0, 0, eidIcons)

EID:addIcon("GauntletCeresWinter", "Ceres", 0, 9, 9, 0, 0, eidIcons)
EID:addIcon("GauntletCeresSpring", "Ceres", 1, 7, 9, 0, 0, eidIcons)
EID:addIcon("GauntletCeresSummer", "Ceres", 2, 9, 9, 0, 0, eidIcons)
EID:addIcon("GauntletCeresAutumn", "Ceres", 3, 7, 9, 0, 0, eidIcons)

EID:addIcon("GauntletHadesStatusEffect",    "StatusEffects", 0, 9, 9, 0, 0, eidIcons)
EID:addIcon("GauntletJunoStatusEffect",     "StatusEffects", 1, 8, 8, 0, 0, eidIcons)



EID:setModIndicatorName("The Gauntlet")
EID:setModIndicatorIcon("GauntletGauntletRoomStat")



EID.MarkupSizeMap["{{GauntletGauntletRoomStat}}"] = "{{GauntletGauntletRoomStatSmall}}"
EID.StatPickupBulletpointBlacklist["{{GauntletGauntletRoomStat}}"] = true
EID.StatPickupBulletpointBlacklist["{{GauntletGauntletRoomStatSmall}}"] = true