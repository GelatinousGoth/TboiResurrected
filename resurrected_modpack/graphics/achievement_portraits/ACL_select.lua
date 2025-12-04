local ACL_select = {}

ACL_select.Check = false 
ACLmenu = {}

-- CHARACTERS (255)
	-- REBIRTH
ACLmenu[1] = Sprite()

ACLmenu[2] = Sprite()

ACLmenu[3] = Sprite()

ACLmenu[4] = Sprite()
 
ACLmenu[5] = Sprite()
 
ACLmenu[6] = Sprite()

ACLmenu[7] = Sprite()

ACLmenu[8] = Sprite()

ACLmenu[9] = Sprite()

ACLmenu[10] = Sprite()

ACLmenu[11] = Sprite()

ACLmenu[12] = Sprite()

ACLmenu[13] = Sprite()

ACLmenu[14] = Sprite()

ACLmenu[15] = Sprite()

ACLmenu[16] = Sprite()

ACLmenu[17] = Sprite()

ACLmenu[18] = Sprite()

ACLmenu[19] = Sprite()

ACLmenu[20] = Sprite()

ACLmenu[21] = Sprite()

ACLmenu[22] = Sprite()

ACLmenu[23] = Sprite()

ACLmenu[24] = Sprite()

ACLmenu[25] = Sprite()

ACLmenu[26] = Sprite()

ACLmenu[27] = Sprite()

ACLmenu[28] = Sprite()

ACLmenu[29] = Sprite()

ACLmenu[30] = Sprite()

ACLmenu[31] = Sprite()

ACLmenu[32] = Sprite()

ACLmenu[33] = Sprite()

ACLmenu[34] = Sprite()

ACLmenu[35] = Sprite()

function ACL_select:ModCompat()

		ACL_select.Check = true

		-- if Epiphany then
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
			
			-- table.insert(ACLmenu, 1)
			-- ACLmenu[#ACLmenu] = Sprite()
		-- end
		
		

end
ACLadmin:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ACL_select.ModCompat)

return ACL_select