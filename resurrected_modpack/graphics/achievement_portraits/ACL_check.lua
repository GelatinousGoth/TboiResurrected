local ACL_check = {}

ACL_check.Check = false
ACLbox = {}

-- LIST OF EPIPHANY PORTRAITS

local EPI = {}
EPI[1] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_1_tarIsaac")
EPI[2] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_2_tarMaggy")
EPI[3] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_3_tarCain")
EPI[4] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_4_tarJudas")
EPI[5] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_5_tarBlueB")
EPI[6] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_7_tarSamson")
EPI[7] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_10_tarEden")
EPI[8] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_11_tarLost")
EPI[9] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_13_tarKeepr")
EPI[10] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_EPI_Z_misc")


-- CHARACTERS (255)
	-- REBIRTH
ACLbox[1] = "1_isaac"
ACLbox[2] = "2_magdalene"
ACLbox[3] = "3_cain"
ACLbox[4] = "4_judas"
ACLbox[5] = "5_bluebaby"
ACLbox[6] = "6_eve"
ACLbox[7] = "7_samson"
ACLbox[8] = "8_azazel"
ACLbox[9] = "9_lazarus"
ACLbox[10] = "10_eden"
ACLbox[11] = "11_lost"
	--AFTERBIRTH
ACLbox[12] = "12_lilith"
ACLbox[13] = "13_keeper"
	--AFTERBIRTH +
ACLbox[14] = "14_apollyon"
ACLbox[15] = "15_forgotten"
	--REPENTANCE
ACLbox[16] = "16_bethany"
ACLbox[17] = "17_jacob"

-- GAMEPLAY (?)
	-- CHALLENGES (81) 
ACLbox[18] = "18_challenges" -- Contains what's needed to unlock challenges, contains 36 trophies	(CHALLENGES I) (secret 336 is left)
ACLbox[19] = "19_challenges2" -- Contains the original 20 challenges, 20 trophies 					(CHALLENGES II)
ACLbox[20] = "20_challenges3" -- Contains the 25 dlc challenges									 	(CHALLENGES III)
	-- BOSSES (55)
ACLbox[21] = "21_bosses" -- 25 boss related secrets 			(MY FEARS I)
ACLbox[22] = "22_bosses2" -- 30 other boss related secrets	(MY FEARS II)
	--ITEMS (57) 
ACLbox[23] = "23_item" -- 15 secrets related to having certain items in a run, obtaining them certain amount of times, etc
ACLbox[24] = "34_item2" -- 12 secrets related to having certain items in a run, obtaining them certain amount of times, etc
ACLbox[25] = "24_donate" -- 30 secrets related to donating or using the different machines that spend hearts or coins
	-- EXPLORATION (44)
ACLbox[26] = "25_chapter" -- 20 Achievements related to chapters and stages	(UNDER THE FLOOR BOARDS)
ACLbox[27] = "26_play" -- 24 Achievements related to random stuff			(THINGS I DID)


-- TAINTED CHARACTERS (136) [532/637]
ACLbox[28] = "27_taintedREC" --24	(THE TAINTED I) isaac, keeper, cain ///////////////////
ACLbox[29] = "28_taintedBLD" --16	(THE TAINTED II) eve and Maggy ////////////////////////

ACLbox[30] = "29_taintedCRS" --24	(THE TAINTED III) Lilith, Azazel and judas ////////////

ACLbox[31] = "30_taintedCHN" --16	(THE TAINTED IV) Jacob and samson /////////////////////
ACLbox[32] = "31_taintedCCL" --16	(THE TAINTED V) Eden and Apollyon /////////////////////

ACLbox[33] = "32_taintedHLY" --16 	(THE TAINTED VI) Bethany and Lazarus 
ACLbox[34] = "33_taintedHID" --24	(THE TAINTED VII) Lost, ???, Forgotten ////////////////
-- GODHOOD (9)
ACLbox[35] = "35_god" -- 9 Achievements related to 100% (I AM...)

function ACL_check:ModCompat()

		-- ACL_check.Check = true
		
		-- if Epiphany then
			-- table.insert(ACLbox, "EPI_1_tarIsaac")
			-- ACLadmin:RequireQueue(EPI[1])
			-- table.insert(ACLbox, "EPI_2_tarMaggy")
			-- ACLadmin:RequireQueue(EPI[2])
			-- table.insert(ACLbox, "EPI_3_tarCain")
			-- ACLadmin:RequireQueue(EPI[3])
			-- table.insert(ACLbox, "EPI_4_tarJudas")
			-- ACLadmin:RequireQueue(EPI[4])
			-- table.insert(ACLbox, "EPI_5_tarBlueB")
			-- ACLadmin:RequireQueue(EPI[5])
			-- table.insert(ACLbox, "EPI_7_tarSamson")
			-- ACLadmin:RequireQueue(EPI[6])
			-- table.insert(ACLbox, "EPI_10_tarEden")
			-- ACLadmin:RequireQueue(EPI[7])
			-- table.insert(ACLbox, "EPI_11_tarLost")
			-- ACLadmin:RequireQueue(EPI[8])
			-- table.insert(ACLbox, "EPI_13_tarKeepr")
			-- ACLadmin:RequireQueue(EPI[9])
			-- table.insert(ACLbox, "EPI_Z_misc")
			-- ACLadmin:RequireQueue(EPI[10])
		-- end	

end
ACLadmin:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ACL_check.ModCompat)

return ACL_check