local ACLspoiler = {}

local requireLink = {}
for i = 1, #ACLbox do -- GRABS ALL REQUIRED GRID DOCS
		requireLink[i] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_"..ACLbox[i])

end

function ACLspoiler:RecheckLinks()

for i = 1, #ACLbox do -- GRABS ALL REQUIRED GRID DOCS
		requireLink[i] = require("resurrected_modpack.graphics.achievement_portraits.acl.ACL_"..ACLbox[i])
end

end

local count = Isaac.GetPersistentGameData()
--DECLARING THE VALUES

--COUNTING THE ENCOUNTERS
ACLspoiler.spoiler = {}

	ACLspoiler.spoiler[1] = {
		Name = " Mom's Heart ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 11
		Splr = " ??????????? ",
		Code = " %?%?%?%?%?%?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[2] = {
		Name = " Mega Satan ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 10
		Splr = " ?????????? ",
		Code = " %?%?%?%?%?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[3] = {
		Name = " The Beast ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 9
		Splr = " ????????? ",
		Code = " %?%?%?%?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[4] = {
		Name = " It Lives! ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 8
		Splr = " ???????! ",
		Code = " %?%?%?%?%?%?%?! ",
		Count = 0
	}
	ACLspoiler.spoiler[5] = {
		Name = " Delirium ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 8
		Splr = " ???????? ",
		Code = " %?%?%?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[6] = {
		Name = " The Lamb ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 7
		Splr = " ??????? ",
		Code = " %?%?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[7] = {
		Name = " Mother ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 6
		Splr = " ?????? ",
		Code = " %?%?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[8] = {
		Name = " Satan ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 5
		Splr = " ????? ",
		Code = " %?%?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[9] = {
		Name = " Hush ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 4
		Splr = " ???? ",
		Code = " %?%?%?%? ",
		Count = 0
	}
	ACLspoiler.spoiler[10] = {
		Name = " Isaac ", --GSTRING, it grabs thing, if it detects this, it checks bestiary check count. 2
		Splr = " ?! ",
		Code = " %?! ",
		Count = 0
	}
	
--CLARIFYING
function ACLspoiler:getData()

ACLspoiler.spoiler[1].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_MOMS_HEART, 0)
ACLspoiler.spoiler[2].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_MEGA_SATAN, 0)
ACLspoiler.spoiler[3].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_MOMS_HEART, 1)
ACLspoiler.spoiler[4].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_BEAST, 0)
ACLspoiler.spoiler[5].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_THE_LAMB, 0)
ACLspoiler.spoiler[6].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_DELIRIUM, 0)
ACLspoiler.spoiler[7].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_MOTHER, 0)
ACLspoiler.spoiler[8].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_SATAN, 0)
ACLspoiler.spoiler[9].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_HUSH, 0)
ACLspoiler.spoiler[10].Count = count:GetBestiaryEncounterCount(EntityType.ENTITY_ISAAC, 0)

end

function ACLspoiler:clearData()

	for i = 1, #ACLspoiler.spoiler do
		ACLspoiler.spoiler[i].Count = 0
	end

end


function ACLspoiler:spoilerCheck(gridID, PortID)

	Isaac.DebugString(PortID)
	Isaac.DebugString(gridID)

	for i = 1, #ACLspoiler.spoiler do
		
		if string.match(requireLink[PortID].grid[gridID].DisplayText, ACLspoiler.spoiler[i].Name) then
			if ACLspoiler.spoiler[i].Count == 0 then
			
			requireLink[PortID].grid[gridID].DisplayText = string.gsub(requireLink[PortID].grid[gridID].DisplayText,ACLspoiler.spoiler[i].Name,ACLspoiler.spoiler[i].Splr)
		
			end
		end
		if string.match(requireLink[PortID].grid[gridID].DisplayText, ACLspoiler.spoiler[i].Code) and ACLspoiler.spoiler[i].Count ~= 0 then
			
			requireLink[PortID].grid[gridID].DisplayText = string.gsub(requireLink[PortID].grid[gridID].DisplayText,ACLspoiler.spoiler[i].Code,ACLspoiler.spoiler[i].Name)
		
		end
		
	end

end





return ACLspoiler