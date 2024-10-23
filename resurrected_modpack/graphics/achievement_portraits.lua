-- Register the mod in the API
local TR_Manager = require("resurrected_modpack.manager")
ACLadmin = TR_Manager:RegisterMod("Achievement Portraits", 1)
--RANDOM BULLSHIT

IS_ACL_REAL = true --GLOBAL VARIABLE

local f = false
local f2 = false
local f3 = false
local f4 = false
local f5 = true
local boxID = 1 -- DECIDES WHAT BOX IS SELECTED FROM ACL CHECK
local prevBox = boxID
local e = 1
local Left = true
local h = 0
local totalcolumn = 0

local Kindex = 0
local Nindex = 1

local secretFrameCount = 0
local keptPortrait = 1

local requireLink = {}

local cursor = 1
local selectMenu = true
local collectMenu = false
local hideMenu = false

local rowtile = {}
local columntile = {}

local AchievementTotalDelay = {}
local FakeAchDelay = {}

local ACLboxCopy = {}
local requireLinkCopy = {}
local ACLmenuCopy = {}
local AchievementTotalDelayCopy = {}
local FakeAchDelayCopy = {}

local SelectMenuWidth = 5
local SelectMenuThree = 0

local removedID = {}

local ACLtotal = 0


local movePortrait = true

local Portrait = Sprite()
Portrait:Load("gfx/ui/portrait/portrait.anm2", true)
local CursorSprite = Sprite()
CursorSprite:Load("gfx/ui/portrait/tile/arrow.anm2", true)
local CursorSelect = Sprite()
CursorSelect:Load("gfx/ui/select/tileSelect.anm2", true)
CursorSelect:Play("cursor",true)
local PersistentGameData = Isaac.GetPersistentGameData()

local ScreenY = Isaac.GetScreenHeight()
local ScreenYAdjustment = 0
local ScreenX = Isaac.GetScreenWidth()
local ScreenXAdjustment = 0

--RELATED TO FUCKING MATH
local MedianX
local MedianY
local row
local column
local Yodd
local Xodd
local area
local DistanceX
local DistanceY
local spacing
local left
local down
--REQUIRED FILES
local dont = require("resources.scripts.ACL_check")
local dont2 = require("resources.scripts.ACL_select")

	for i = 1, #ACLbox do -- GRABS ALL REQUIRED GRID DOCS
			requireLink[i] = require("resources.scripts.acl.ACL_"..ACLbox[i])
	end

	CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
	CursorSprite:LoadGraphics()

	Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
	Portrait:LoadGraphics()


local ACLspoiler = require("resources.scripts.ACLspoiler")
local text = require("resources.scripts.TextRenderer")
local collections = require("resources.scripts.ACL_collection")

function ACLadmin:KeyorPad()

	if Input.IsActionTriggered(ButtonAction.ACTION_LEFT, Nindex) or 
	Input.IsActionTriggered(ButtonAction.ACTION_UP, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_DOWN, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_BOMB, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_DROP, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_PAUSE, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_MAP, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Nindex) or
	Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, Nindex)
	then

		Kindex = Nindex
		if Nindex == 1 then
		Nindex = 0

		else
		Nindex = 1

		end

	end

end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.KeyorPad)

function ACLadmin:CopyTables(box, link, menu, counter, fakecounter)

   for k,v in pairs(box) do
      ACLboxCopy[k] = v
   end
    for k,v in pairs(link) do
      requireLinkCopy[k] = v
   end
    for k,v in pairs(menu) do
      ACLmenuCopy[k] = v
   end
   for k,v in pairs(counter) do
      AchievementTotalDelayCopy[k] = v
   end
   for k,v in pairs(fakecounter) do
      FakeAchDelayCopy[k] = v
   end


end

function ACLadmin:CheckAgain()
	if MenuManager.GetActiveMenu() == MainMenuType.SAVES and (f4 == true or f == true) then
		f = false
		f2 = false
		f3 = false
		f4 = false
		f5 = true
		secretFrameCount = 0
		selectMenu = true
		cursor = 1
		boxID = 1 
		keptPortrait = 1
		prevBox = 1
		Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
		Portrait:LoadGraphics()
		
		local belay = 0
		local removedCount = #removedID
				 for k,v in pairs(removedID) do
					table.insert(ACLbox, v, ACLboxCopy[v])
					table.insert(requireLink, v, requireLinkCopy[v])
					table.insert(ACLmenu, v, ACLmenuCopy[v])
					table.insert(AchievementTotalDelay, v, AchievementTotalDelayCopy[v])
					table.insert(FakeAchDelay, v, FakeAchDelayCopy[v])
				 end 
				for i = 1, removedCount do
				table.remove(removedID, (i - belay))
				belay = belay + 1
				end
				
				
		for g = 1, #ACLbox do
			for l = 2, #requireLink[g].grid do
			
				requireLink[g].grid[l].Near = false
			
			end
			requireLink[g].Counter = 0
		end
		
--- SAME FUCNTION OF CHECKING SIZE OF SELECT GRID
		ACLadmin:MakeSelectGrid()
		
		ACLspoiler:clearData()
		for i = 1, #ACLmenu do
			ACLmenu[i]:Load("gfx/ui/select/tileSelect.anm2", true)
			ACLmenu[i]:ReplaceSpritesheet(5, "gfx/ui/select/"..ACLbox[i]..".png") --CHANGE THIS LATER
			ACLmenu[i]:LoadGraphics()
			if requireLink[i].Counter == 0 then
			ACLmenu[i]:ReplaceSpritesheet(5, "gfx/ui/select/unknown.png")
			end
			if requireLink[i].Counter - FakeAchDelay[i] == (#requireLink[i].grid - AchievementTotalDelay[i]) then
			ACLmenu[i]:Play("star",true)
			end
		end
	end
end

ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.CheckAgain)


function ACLadmin:Check()
		if ACLtotal == 0 then 
		ACLtotal = #ACLbox
		end
	if MenuManager.GetActiveMenu() == MainMenuType.GAME and f3 == false then
		f4 = true
		secretFrameCount = 0
		for i = 1, #requireLink do
		FakeAchDelay[i] = 0
		AchievementTotalDelay[i] = 0
			if i > 35 and requireLink[i].special == true then
			
				requireLink[i]:SpecialCheck()
				for o = 1, #requireLink[i].grid do
					if requireLink[i].grid[o].Unlocked == true and requireLink[i].grid[o].Enum ~= -1 then
							requireLink[i].Counter = requireLink[i].Counter + 1					
					end
					if requireLink[i].grid[o].Enum == 0 then 
						FakeAchDelay[i] = FakeAchDelay[i] + 1
					end
					if requireLink[i].grid[o].Enum == -1 or requireLink[i].grid[o].Enum == 0 then
						AchievementTotalDelay[i] = AchievementTotalDelay[i] + 1
					end
				end
			else
				for o = 1, #requireLink[i].grid do
					--CHECKING UNLOCKS
					if requireLink[i].grid[o].Enum == 0 or requireLink[i].grid[o].Enum == -1 then
					
						requireLink[i].grid[o].Unlocked = true
					
						AchievementTotalDelay[i] = AchievementTotalDelay[i] + 1
					
						if requireLink[i].grid[o].Enum == 0 then
						FakeAchDelay[i] = FakeAchDelay[i] + 1
						end
					
					elseif requireLink[i].grid[o].Enum ~= nil then
						requireLink[i].grid[o].Unlocked = PersistentGameData:Unlocked(requireLink[i].grid[o].Enum)
						
						Isaac.DebugString(requireLink[i].grid[o].Enum..":"..tostring(requireLink[i].grid[o].Unlocked))
						
					else
						requireLink[i].AchID = Isaac.GetAchievementIdByName(requireLink[i].grid[o].TextName)
						requireLink[i].grid[o].Unlocked = PersistentGameData:Unlocked(requireLink[i].AchID)
						
						Isaac.DebugString(requireLink[i].AchID..":"..tostring(requireLink[i].grid[o].Unlocked))
						
					end
					--CHECK COUNTER FOR EACH GRID
					if requireLink[i].grid[o].Unlocked == true and requireLink[i].grid[o].Enum ~= -1 then
							requireLink[i].Counter = requireLink[i].Counter + 1					
					end
				end
			end
		end
		
		--ADDDDDDD COLLECITONS EHRE
		for i = 1, #ACLcollections do
		
			for k,v in pairs(ACLcollections[i].Portraits) do 
				
				if requireLink[v].Counter == #requireLink[v].grid then
				
				ACLcollections[i].total = ACLcollections[i].total + 1
				
				end
			end
			
			if ACLcollections[i].total == #ACLcollections[i].Portraits then 
				for k,v in pairs(ACLcollections[i].Portraits) do 
				
				requireLink[v].collection = true
				
				end
				ACLcollections[i].Complete = true
			end
			
		end
		
	--LOAD PORTRAITS ICONS
		for i = 1, #ACLmenu do
			ACLmenu[i]:Load("gfx/ui/select/tileSelect.anm2", true)
			ACLmenu[i]:ReplaceSpritesheet(5, "gfx/ui/select/"..ACLbox[i]..".png") --CHANGE THIS LATER
			ACLmenu[i]:LoadGraphics()
			Isaac.DebugString(#ACLmenu)
			if requireLink[i].Counter == 0 then
			ACLmenu[i]:ReplaceSpritesheet(5, "gfx/ui/select/unknown.png")
			end
			if requireLink[i].Counter - FakeAchDelay[i] == (#requireLink[i].grid - AchievementTotalDelay[i]) then
			ACLmenu[i]:Play("star",true)
			end
		end
		
		--CHECK WHICH ACL MENUS ARE HIDDEN AND NOT AND THEN USE 
		--A NEW ARRAY TO PUT THEM IN TO USE THEM IN THE FOLLOWING 
		--LIST OF THINGS
		
		
		ACLadmin:CopyTables(ACLbox,requireLink,ACLmenu,AchievementTotalDelay,FakeAchDelay)
		local delay = 0
				for i = 1, ACLtotal do
				
						if requireLink[i - delay].isHidden == true then 
							
							if requireLink[i - delay].Counter == 0 then 
							
							table.remove(ACLbox, (i - delay))
							table.remove(requireLink, (i - delay))
							table.remove(ACLmenu, (i - delay))
							table.remove(AchievementTotalDelay, (i - delay))
							table.remove(FakeAchDelay, (i - delay))
							
							table.insert(removedID, (i))
							delay = delay + 1
							end
						
						end
				
				end
		--- CHANGE SO IT COULD BE 5 OR 3 DEPENDING ON SCREEN SIZE
		ACLadmin:MakeSelectGrid()

		f3 = true
	end
	if StatsMenu.IsSecretsMenuVisible() then
		if f == false then
				if selectMenu == true then
					for i = 1, #ACLmenu do
						ACLmenu[i]:LoadGraphics()
						ACLmenu[i]:Play("Idle",true)
						if requireLink[i].Counter - FakeAchDelay[i] == (#requireLink[i].grid - AchievementTotalDelay[i]) then
							ACLmenu[i]:Play("star",true)
						end
					end
				end
			ACLspoiler:getData()
				--THING THAT CHANGES
				requireLink[boxID].Counter = 0
				if boxID > 35 - #removedID and requireLink[boxID].special == true then
			
					requireLink[boxID]:SpecialCheck()
					for o = 1, #requireLink[boxID].grid do
						if requireLink[boxID].grid[o].Unlocked == true and requireLink[boxID].grid[o].Enum ~= -1 then
								requireLink[boxID].Counter = requireLink[boxID].Counter + 1					
						end
					
					
						spacing = requireLink[boxID].size * 8

						if requireLink[boxID].dimX % 2 == 1 then
							MedianX = requireLink[boxID].dimX/2 + 0.5
							Xodd = true
						else 
							MedianX = requireLink[boxID].dimX/2
							Xodd = false
						end

						if requireLink[boxID].dimY % 2 == 1 then
						  MedianY = requireLink[boxID].dimY/2 + 0.5
						  Yodd = true
						else 
						  MedianY = requireLink[boxID].dimY/2
						  Yodd = false
						end


						area = requireLink[boxID].dimX * requireLink[boxID].dimY
					  
						-- FIND ROW AND COLUMN
						row = o % requireLink[boxID].dimX
					  
						for a = 1, requireLink[boxID].dimY do

							if o <= (a * requireLink[boxID].dimX) then
							
								column = a
								break
							
							end

						end
						-- ACTUAL PROCEDURE
						if Xodd == true then
						  
							if row == MedianX then
							  
							  DistanceX = 0
							  left = false
							  --IF ITS THE MIDDLE
							elseif row < MedianX and row ~= 0 then
							  
							  DistanceX = MedianX - row
							  left = true
							  --IF ITS ON THE LEFT SIDE
							elseif row > MedianX or row == 0 then
							
								if row == 0 then
									DistanceX = requireLink[boxID].dimX - MedianX
								else
									DistanceX = row - MedianX
								end
								left = false
							  --IF ITS ON THE RIGHT
							end
						  
							if left == true then
							  DistanceX = DistanceX * -1
							end
						  
							requireLink[boxID].grid[o].PosX = (DistanceX * spacing)
						  
						else
							
							DistanceX = 0.5
							
							if row == MedianX then --CHECK IF ITS MIDDLE LEFT
							  left = true
							  
							elseif row == MedianX + 1 then --CHECK IF ITS MIDDLE RIGHT
							  left = false
							  
							elseif row < MedianX and row ~= 0 then --CHECK IF ITS LEFT
							  
							  DistanceX = (MedianX - row) + 0.5
								left = true

							elseif row > MedianX or row == 0 then --CHECK IF ITS RIGHT
							
								if row == 0 then
									  DistanceX = (requireLink[boxID].dimX - MedianX) - 0.5
								else
									  DistanceX = (row - MedianX) - 0.5
								end
								left = false
							end
							  
							if left == true then
							  DistanceX = DistanceX * -1
							end
						  
							requireLink[boxID].grid[o].PosX = (DistanceX * spacing)
							
						end
					  
					  
							if Yodd == true then
								
								--COPYPASTE X
								
								if column == MedianY then
								  
								  DistanceY = 0
								  down = false
								  --IF ITS THE MIDDLE
								elseif column < MedianY and column ~= 0 then
								  
								  DistanceY = MedianY - column
								  down = false
								  --IF ITS ON THE LEFT SIDE
								elseif column > MedianY or column == 0 then
								
									if column == 0 then
										  DistanceY = requireLink[boxID].dimY - MedianY
									else
										  DistanceY = column - MedianY
									end
									down = true
									--IF ITS ON THE RIGHT
								end
							  
								if down ~= true then
								  DistanceY = DistanceY * -1
								end
								
								requireLink[boxID].grid[o].PosY = (DistanceY * spacing)
								
								
							else
								
								DistanceY = 0.5
								
								if column == MedianY then --CHECK IF ITS MIDDLE LEFT
								  down = false
								  
								elseif column == MedianY + 1 then --CHECK IF ITS MIDDLE RIGHT
								  down = true
								  
								elseif column < MedianY and column ~= 0 then --CHECK IF ITS LEFT
								  
								  DistanceY = (MedianY - column) + 0.5
									down = false

								elseif column > MedianY or column == 0 then --CHECK IF ITS RIGHT
								
									if column == 0 then
										DistanceY = (requireLink[boxID].dimY - MedianY) - 0.5
									else
										DistanceY = (column - MedianY) - 0.5
									end
									down = true
								end
								  
								if down ~= true then
								  DistanceY = DistanceY * -1
								end
							  
								requireLink[boxID].grid[o].PosY = (DistanceY * spacing)
								
							end --END OF ODD Y STATEMENT
					
					end
				else
					for o = 1, #requireLink[boxID].grid do
						--CHECKING UNLOCKS
						
						if requireLink[boxID].grid[o].Enum == 0 or requireLink[boxID].grid[o].Enum == -1 then
						
						requireLink[boxID].grid[o].Unlocked = true
							
						elseif requireLink[boxID].grid[o].Enum ~= nil then
							requireLink[boxID].grid[o].Unlocked = PersistentGameData:Unlocked(requireLink[boxID].grid[o].Enum)
							
							Isaac.DebugString(requireLink[boxID].grid[o].Enum..":"..tostring(requireLink[boxID].grid[o].Unlocked))
							
						else
							requireLink[boxID].AchID = Isaac.GetAchievementIdByName(requireLink[boxID].grid[o].TextName)
							requireLink[boxID].grid[o].Unlocked = PersistentGameData:Unlocked(requireLink[boxID].AchID)
							
							Isaac.DebugString(requireLink[boxID].AchID..":"..tostring(requireLink[boxID].grid[o].Unlocked))
							
						end
						--CHECK COUNTER FOR EACH GRID
						if requireLink[boxID].grid[o].Unlocked == true then
								requireLink[boxID].Counter = requireLink[boxID].Counter + 1
						end
					
						--CHECKING DIMENTIONS AND POSITIONS	
						--RIGHT HERE
						spacing = requireLink[boxID].size * 8

						if requireLink[boxID].dimX % 2 == 1 then
							MedianX = requireLink[boxID].dimX/2 + 0.5
							Xodd = true
						else 
							MedianX = requireLink[boxID].dimX/2
							Xodd = false
						end

						if requireLink[boxID].dimY % 2 == 1 then
						  MedianY = requireLink[boxID].dimY/2 + 0.5
						  Yodd = true
						else 
						  MedianY = requireLink[boxID].dimY/2
						  Yodd = false
						end


						area = requireLink[boxID].dimX * requireLink[boxID].dimY
					  
						-- FIND ROW AND COLUMN
						row = o % requireLink[boxID].dimX
					  
						for a = 1, requireLink[boxID].dimY do

							if o <= (a * requireLink[boxID].dimX) then
							
								column = a
								break
							
							end

						end
						-- ACTUAL PROCEDURE
						if Xodd == true then
						  
							if row == MedianX then
							  
							  DistanceX = 0
							  left = false
							  --IF ITS THE MIDDLE
							elseif row < MedianX and row ~= 0 then
							  
							  DistanceX = MedianX - row
							  left = true
							  --IF ITS ON THE LEFT SIDE
							elseif row > MedianX or row == 0 then
							
								if row == 0 then
									DistanceX = requireLink[boxID].dimX - MedianX
								else
									DistanceX = row - MedianX
								end
								left = false
							  --IF ITS ON THE RIGHT
							end
						  
							if left == true then
							  DistanceX = DistanceX * -1
							end
						  
							requireLink[boxID].grid[o].PosX = (DistanceX * spacing)
						  
						else
							
							DistanceX = 0.5
							
							if row == MedianX then --CHECK IF ITS MIDDLE LEFT
							  left = true
							  
							elseif row == MedianX + 1 then --CHECK IF ITS MIDDLE RIGHT
							  left = false
							  
							elseif row < MedianX and row ~= 0 then --CHECK IF ITS LEFT
							  
							  DistanceX = (MedianX - row) + 0.5
								left = true

							elseif row > MedianX or row == 0 then --CHECK IF ITS RIGHT
							
								if row == 0 then
									  DistanceX = (requireLink[boxID].dimX - MedianX) - 0.5
								else
									  DistanceX = (row - MedianX) - 0.5
								end
								left = false
							end
							  
							if left == true then
							  DistanceX = DistanceX * -1
							end
						  
							requireLink[boxID].grid[o].PosX = (DistanceX * spacing)
							
						end
					  
					  
						if Yodd == true then
							
							--COPYPASTE X
							
							if column == MedianY then
							  
							  DistanceY = 0
							  down = false
							  --IF ITS THE MIDDLE
							elseif column < MedianY and column ~= 0 then
							  
							  DistanceY = MedianY - column
							  down = false
							  --IF ITS ON THE LEFT SIDE
							elseif column > MedianY or column == 0 then
							
								if column == 0 then
									  DistanceY = requireLink[boxID].dimY - MedianY
								else
									  DistanceY = column - MedianY
								end
								down = true
								--IF ITS ON THE RIGHT
							end
						  
							if down ~= true then
							  DistanceY = DistanceY * -1
							end
							
							requireLink[boxID].grid[o].PosY = (DistanceY * spacing)
							
							
						else
							
							DistanceY = 0.5
							
							if column == MedianY then --CHECK IF ITS MIDDLE LEFT
							  down = false
							  
							elseif column == MedianY + 1 then --CHECK IF ITS MIDDLE RIGHT
							  down = true
							  
							elseif column < MedianY and column ~= 0 then --CHECK IF ITS LEFT
							  
							  DistanceY = (MedianY - column) + 0.5
								down = false

							elseif column > MedianY or column == 0 then --CHECK IF ITS RIGHT
							
								if column == 0 then
									DistanceY = (requireLink[boxID].dimY - MedianY) - 0.5
								else
									DistanceY = (column - MedianY) - 0.5
								end
								down = true
							end
							  
							if down ~= true then
							  DistanceY = DistanceY * -1
							end
						  
							requireLink[boxID].grid[o].PosY = (DistanceY * spacing)
							
						end --END OF ODD Y STATEMENT
					
					end
				end
				--CHECKING NEAR VALUES
				for g = 1, #requireLink[boxID].grid do
				
				
					if g > requireLink[boxID].dimX then
						if requireLink[boxID].grid[g - requireLink[boxID].dimX].Unlocked == true then
						requireLink[boxID].grid[g].Near = true
						end
					end
					if g <= (#requireLink[boxID].grid - requireLink[boxID].dimX) then
						if requireLink[boxID].grid[g + requireLink[boxID].dimX].Unlocked == true then
						requireLink[boxID].grid[g].Near = true
						end
					end
					if g % requireLink[boxID].dimX ~= 1 then
						if requireLink[boxID].grid[g - 1].Unlocked == true then
						requireLink[boxID].grid[g].Near = true
						end
					end
					if g % requireLink[boxID].dimX ~= 0 then
						if requireLink[boxID].grid[g + 1].Unlocked == true then
						requireLink[boxID].grid[g].Near = true
						end
					end
				
				end
				
				--GET IMAGES FOR SPRITE
				for t = 1, #requireLink[boxID].grid do -- GRABS ALL REQUIRED GRID DOCS
			
					requireLink[boxID].grid[t].Tile:Load("gfx/ui/portrait/tile/tile.anm2", true)
					
					if requireLink[boxID].grid[t].Near == true then
					
					near = "near"
					
					else
					
					near = "far"
					
					end
					if requireLink[boxID].grid[t].Unlocked == true then
					requireLink[boxID].grid[t].Tile:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/tile_empty.png")
					else
					requireLink[boxID].grid[t].Tile:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/tile_"..near.."_"..requireLink[boxID].size..".png")
					end
					requireLink[boxID].grid[t].Tile:LoadGraphics()

				end
			f = true
		end
	end
end

ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.Check)

	function ACLadmin:selectCursor()  -- DECIDES WHERE CURSOR IS PLACED
	
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == true and hideMenu == false then
		
			if Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, Kindex) then
				Portrait:Play("ExitRight",true)
				for i=1, #requireLink[boxID].grid do
					requireLink[boxID].grid[i].Tile:Play("ExitRight")
				end
				if boxID == #ACLbox and #ACLbox % SelectMenuWidth ~= 0 then
				boxID = boxID - ((#ACLbox % SelectMenuWidth))
				elseif boxID % SelectMenuWidth == 0 then
				boxID = boxID - (4 - SelectMenuThree)
				else
				boxID = boxID + 1
				end
				CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
				CursorSprite:LoadGraphics()
				f = false
				keptPortrait = boxID
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_LEFT, Kindex) then
				Portrait:Play("ExitRight",true)
				for i=1, #requireLink[boxID].grid do
					requireLink[boxID].grid[i].Tile:Play("ExitRight")
				end
				if boxID % SelectMenuWidth == 1 then
					if boxID + (4 - SelectMenuThree) > #ACLbox then
					boxID = #ACLbox
					else
					boxID = boxID + (4 - SelectMenuThree)
					end
				else
				boxID = boxID - 1
				end
				ACLspoiler:spoilerCheck(1, boxID)
				CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
				CursorSprite:LoadGraphics()
				f = false
				keptPortrait = boxID
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_DOWN, Kindex) then
				Portrait:Play("ExitRight",true)
				for i=1, #requireLink[boxID].grid do
					requireLink[boxID].grid[i].Tile:Play("ExitRight")
				end
				if boxID > (#ACLbox - (#ACLbox % SelectMenuWidth)) or boxID > (#ACLbox - SelectMenuWidth) or boxID > #ACLbox then
					if boxID % SelectMenuWidth ~= 0 then
						boxID = boxID % SelectMenuWidth
					else 
						boxID = SelectMenuWidth
					end
				movePortrait = true
				--FUCKED UP
					if #ACLmenu % SelectMenuWidth ~= 0 then
						h = #ACLmenu + (SelectMenuWidth - (#ACLmenu % SelectMenuWidth))
					else
						h = #ACLmenu
					end
					totalcolumn = h / SelectMenuWidth

					for i = 1, #ACLmenu do
						if i % SelectMenuWidth == 0 then
						
								rowtile[i] = 2 - SelectMenuThree
							
						else
							rowtile[i] = i % SelectMenuWidth - 3
						end
						for a = 1, totalcolumn do
							if i <= (a * SelectMenuWidth) then
								columntile[i] = a - 2
								break
							end
						end
					end
				--FUCKED UP
				else
				boxID = boxID + SelectMenuWidth
				end
				--CHECK IF MENU MUST PAN OR NOT
				if movePortrait == true and columntile[#ACLbox] ~= 1 and boxID > SelectMenuWidth * 2 then
					for i = 1, #ACLbox do
							columntile[i] = columntile[i] - 1
					end
				end
				
				ACLspoiler:spoilerCheck(1, boxID)
				
				movePortrait = true
				CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
				CursorSprite:LoadGraphics()
				f = false
				keptPortrait = boxID
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_UP, Kindex) then
				Portrait:Play("ExitRight",true)
				for i=1, #requireLink[boxID].grid do
					requireLink[boxID].grid[i].Tile:Play("ExitRight")
				end
				if boxID <= SelectMenuWidth then
					for i=1, SelectMenuWidth do
					
						if (boxID % SelectMenuWidth) == i % SelectMenuWidth and #ACLbox % SelectMenuWidth ~= boxID % SelectMenuWidth and #ACLbox % SelectMenuWidth ~= 0 and boxID % SelectMenuWidth ~= 0 and boxID % SelectMenuWidth > #ACLbox % SelectMenuWidth then
							boxID = #ACLbox - (#ACLbox % SelectMenuWidth) + (boxID % SelectMenuWidth) - SelectMenuWidth
							break
							
						elseif (boxID % SelectMenuWidth) == i % SelectMenuWidth and #ACLbox % SelectMenuWidth ~= boxID % SelectMenuWidth and #ACLbox % SelectMenuWidth ~= 0 then 
							boxID = #ACLbox - (#ACLbox % SelectMenuWidth) + (boxID % SelectMenuWidth)
							break
						
						elseif (boxID % SelectMenuWidth) == i % SelectMenuWidth and #ACLbox % SelectMenuWidth ~= boxID % SelectMenuWidth then
						boxID = #ACLbox + ((boxID % SelectMenuWidth) - SelectMenuWidth)
							break
						end

					end
					if #ACLbox % SelectMenuWidth == boxID % SelectMenuWidth then
						boxID = #ACLbox
					end

				movePortrait = false
				
					for i = 1, #ACLbox do
							columntile[i] = columntile[i] - (columntile[#ACLbox] - 1)
					end
				
				else
				boxID = boxID - SelectMenuWidth
				end
				
				if movePortrait == true and columntile[1] ~= -1 and columntile[boxID] ~= 0  then
					for i = 1, #ACLbox do
							columntile[i] = columntile[i] + 1
					end
				end
				
				ACLspoiler:spoilerCheck(1, boxID)
				
				movePortrait = true
				CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
				CursorSprite:LoadGraphics()
				f = false
				keptPortrait = boxID
			end
			
		end	
	
	end
	ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.selectCursor)

	function ACLadmin:MoveRight()
				if cursor % requireLink[boxID].dimX == 0 then
				cursor = cursor - (requireLink[boxID].dimX - 1)
				else
				cursor = cursor + 1
				end
				if requireLink[boxID].grid[cursor].Enum == 0 or requireLink[boxID].grid[cursor].Enum == -1 then
				ACLadmin:MoveRight()
				end
	end
	function ACLadmin:MoveLeft()
				if cursor % requireLink[boxID].dimX == 1 then
				cursor = cursor + (requireLink[boxID].dimX - 1)
				else
				cursor = cursor - 1
				end
				if requireLink[boxID].grid[cursor].Enum == 0 or requireLink[boxID].grid[cursor].Enum == -1 then
				ACLadmin:MoveLeft()
				end
	end
	function ACLadmin:MoveUp()
				if cursor <= requireLink[boxID].dimX then
				cursor = cursor + (requireLink[boxID].dimX * (requireLink[boxID].dimY - 1))
				else
				cursor = cursor - requireLink[boxID].dimX
				end
				if requireLink[boxID].grid[cursor].Enum == 0 or requireLink[boxID].grid[cursor].Enum == -1 then
				ACLadmin:MoveUp()
				end
	end
	function ACLadmin:MoveDown()
				if cursor > (requireLink[boxID].dimX * (requireLink[boxID].dimY - 1)) then
				cursor = cursor - (requireLink[boxID].dimX * (requireLink[boxID].dimY - 1))
				else
				cursor = cursor + requireLink[boxID].dimX
				end
				if requireLink[boxID].grid[cursor].Enum == 0 or requireLink[boxID].grid[cursor].Enum == -1 then
				ACLadmin:MoveDown()
				end
	end

	function ACLadmin:controlCursor()  -- DECIDES WHERE CURSOR IS PLACED
	
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == false and hideMenu == false then
	
		
		
			if Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, Kindex) then
				ACLadmin:MoveRight()
				ACLspoiler:spoilerCheck(cursor, boxID)
				CursorSprite:Play("Idle", true)
			end
			
			if Input.IsActionTriggered(ButtonAction.ACTION_LEFT, Kindex) then
				ACLadmin:MoveLeft()
				ACLspoiler:spoilerCheck(cursor, boxID)
				CursorSprite:Play("Idle", true)
			end
			
			if Input.IsActionTriggered(ButtonAction.ACTION_DOWN, Kindex) then
				ACLadmin:MoveDown()
				ACLspoiler:spoilerCheck(cursor, boxID)
				CursorSprite:Play("Idle", true)
			end
			
			if Input.IsActionTriggered(ButtonAction.ACTION_UP, Kindex) then
				ACLadmin:MoveUp()
				ACLspoiler:spoilerCheck(cursor, boxID)
				CursorSprite:Play("Idle", true)
			end
			
			if Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, 0) or Input.IsActionTriggered(ButtonAction.ACTION_BOMB, 0) or Input.IsActionTriggered(ButtonAction.ACTION_MENULT, Kindex) or Input.IsActionTriggered(ButtonAction.ACTION_MENURT, Kindex) then
				cursor = 1
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_DROP, Kindex) or Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) then 
			--CHECKING IF COLLECTION IS VIABLE PUT HERE LATER
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_UP, Kindex) or 
			Input.IsActionTriggered(ButtonAction.ACTION_DOWN, Kindex) or 
			Input.IsActionTriggered(ButtonAction.ACTION_LEFT, Kindex) or 
			Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, 0) or 
			Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, 0) or 
			Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, 0) or 
			Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, 0) or 
			Input.IsActionTriggered(ButtonAction.ACTION_RIGHT, Kindex) then
			--[[Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/"..requireLink[boxID].grid[cursor].gfx)
			Portrait:LoadGraphics()]]--
			ACLadmin:ChangePortraitImg()
			end
		end	
	
	end
	ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.controlCursor)

	
	
	
	
--[[00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000]]--	
	
function ACLadmin:Slider() -- USE Q AND E TO SWITCH PORTRAITS, AS IN, SWITCH THE REQUIRED WITH BOXID
	if StatsMenu.IsSecretsMenuVisible() and selectMenu == false and hideMenu == false then

	
		if (Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, 0) or Input.IsActionTriggered(ButtonAction.ACTION_MENULT, Kindex)) and Portrait:IsPlaying() == false then
			if boxID - 1 < 1 then
				boxID = #requireLink
			else
				boxID = boxID - 1
			end
			ACLspoiler:spoilerCheck(1, boxID)
							for i=1, #requireLink[boxID].grid do
								requireLink[boxID].grid[i].Tile:Play("ExitRight")
							
							end
							Portrait:Play("ExitRight",true)
							f = false
							CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
							CursorSprite:LoadGraphics()
							CursorSprite:Play("Idle2", true)
			Left = true
			ACLadmin:ChangePortraitImg()
		elseif (Input.IsActionTriggered(ButtonAction.ACTION_BOMB, 0) or Input.IsActionTriggered(ButtonAction.ACTION_MENURT, Kindex)) and Portrait:IsPlaying() == false then
			if boxID + 1 > #requireLink then
				boxID = 1
			else
				boxID = boxID + 1
			end
			ACLspoiler:spoilerCheck(1, boxID)
							for i=1, #requireLink[boxID].grid do
								requireLink[boxID].grid[i].Tile:Play("ExitLeft")
							
							end
							Portrait:Play("ExitLeft",true)
							f = false
							CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
							CursorSprite:LoadGraphics()
							CursorSprite:Play("Idle2", true)
			Left = false

			ACLadmin:ChangePortraitImg()
		end
	end
	
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.Slider)

--[[00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000]]--



function ACLadmin:RenderFunction()

		ScreenY = Isaac.GetScreenHeight()
		ScreenYAdjustment = math.floor((ScreenY - 290) / 2)
		ScreenX = Isaac.GetScreenWidth()
		ScreenXAdjustment = math.floor((ScreenX - 440) / 2)
		
		if ScreenYAdjustment <= 0 then 
			ScreenYAdjustment = 0
		end
		if ScreenXAdjustment <= 0 then 
			ScreenXAdjustment = 0
		end

		ACLadmin:MakeSelectGrid()

		if (Input.IsActionTriggered(ButtonAction.ACTION_MENUTAB, Kindex)) and hideMenu == false then 
			hideMenu = true
			elseif (Input.IsActionTriggered(ButtonAction.ACTION_MENUTAB, Kindex)) and hideMenu == true then
			hideMenu = false
		end
		
		if (Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, Kindex)) then 
			hideMenu = false
		end
		
		if MenuManager.GetActiveMenu() == MainMenuType.STATS and StatsMenu.IsSecretsMenuVisible() == false then 
			selectMenu = true
			secretFrameCount = 0
			boxID = keptPortrait
			CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
			CursorSprite:LoadGraphics()
		end
		
		if (Input.IsActionTriggered(ButtonAction.ACTION_ITEM, 0) or Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, Kindex)) and StatsMenu.IsSecretsMenuVisible() and secretFrameCount >= 1 and hideMenu == false then
			if selectMenu == true then
			selectMenu = false
			ACLadmin:ChangePortraitImg()
			else
			boxID = keptPortrait
			CursorSprite:ReplaceSpritesheet(3, "gfx/ui/portrait/tile/arrow_"..requireLink[boxID].size..".png")
			CursorSprite:LoadGraphics()
			selectMenu = true
			cursor = 1
			end
		end
		if StatsMenu.IsSecretsMenuVisible() and secretFrameCount < 5 and hideMenu == false then 
			secretFrameCount = secretFrameCount + 1
		end
		
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == true and hideMenu == false then
			if Kindex == 0 then
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/keyboardCtrl-1_small.png")
				else
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/keyboardCtrl-1.png")
				end
			else
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/gamepadCtrl-1_small.png")
				else
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/gamepadCtrl-1.png")
				end
			end
			Portrait:LoadGraphics()
		elseif StatsMenu.IsSecretsMenuVisible() and selectMenu == false and hideMenu == false then
			if Kindex == 0 then
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/keyboardCtrl-2_small.png")
				else
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/keyboardCtrl-2.png")
				end
			else
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/gamepadCtrl-2_small.png")
				else
					Portrait:ReplaceSpritesheet(6, "gfx/ui/achievement/gamepadCtrl-2.png")
				end
			end
			Portrait:LoadGraphics()
		end
		
		ACLadmin:KeyorPad()
		
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == true and hideMenu == false then
		
		Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/EMPTY.png")
		Portrait:LoadGraphics()
		
		end
		if hideMenu == false then
			Portrait:Update()
			Portrait:Render(Vector((0 + ScreenXAdjustment),(-15 + ScreenYAdjustment)))
		end
		
		if StatsMenu.IsSecretsMenuVisible() and hideMenu == false then
			for i = 1, #requireLink[boxID].grid do
				requireLink[boxID].grid[i].Tile:Update()
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					requireLink[boxID].grid[i].Tile:Render(Vector(requireLink[boxID].grid[i].PosX - 67 + ScreenXAdjustment, requireLink[boxID].grid[i].PosY - 40 + ScreenYAdjustment))
				else
					requireLink[boxID].grid[i].Tile:Render(Vector(requireLink[boxID].grid[i].PosX + ScreenXAdjustment, requireLink[boxID].grid[i].PosY - 15 + ScreenYAdjustment))
				end
			end
		end
		
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == false and hideMenu == false then
			CursorSprite:Update()
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					CursorSprite:Render(Vector((requireLink[boxID].grid[cursor].PosX + ScreenXAdjustment - 67),(requireLink[boxID].grid[cursor].PosY - 40 + ScreenYAdjustment)))
				else
					CursorSprite:Render(Vector((requireLink[boxID].grid[cursor].PosX + ScreenXAdjustment),(requireLink[boxID].grid[cursor].PosY - 15 + ScreenYAdjustment)))
				end	
		end
		
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == true and hideMenu == false then
			for i = 1, #ACLmenu do
				if columntile[i] >= -1 and columntile[i] <= 1 then
					ACLmenu[i]:Update()
					if ScreenY <= 252.0 or ScreenX <= 473.0 then 
						ACLmenu[i]:Render(Vector(((rowtile[i] * 48) + ScreenXAdjustment),((columntile[i] * 48) - 32 + ScreenYAdjustment)))
					else
						ACLmenu[i]:Render(Vector(((rowtile[i] * 48) + ScreenXAdjustment),((columntile[i] * 48) - 16 + ScreenYAdjustment)))
					end	
				end
			end
			--RENDER CURSOR HERE
			CursorSelect:Update()
				if ScreenY <= 252.0 or ScreenX <= 473.0 then 
					CursorSelect:Render(Vector(((rowtile[boxID] * 48) + ScreenXAdjustment),((columntile[boxID] * 48) - 32 + ScreenYAdjustment)))
				else
					CursorSelect:Render(Vector(((rowtile[boxID] * 48) + ScreenXAdjustment),((columntile[boxID] * 48) - 16 + ScreenYAdjustment)))
				end	
		end
		
		if StatsMenu.IsSecretsMenuVisible() and selectMenu == false and hideMenu == false then
			text:Render(requireLink[boxID].grid[cursor].DisplayName,
			 requireLink[boxID].grid[cursor].DisplayText,
			  requireLink[boxID].grid[cursor].Unlocked, 
			  requireLink[boxID].grid[cursor].Near,
			  requireLink[boxID].Counter,
			  requireLink[boxID].Pname, false)
			  
			 text:RenderCounters(requireLink[boxID].size, 
			 requireLink[boxID].grid[requireLink[boxID].dimX].PosX,
			 requireLink[boxID].grid[#requireLink[boxID].grid].PosX,
			 requireLink[boxID].Counter - FakeAchDelay[boxID],
			 #requireLink[boxID].grid - AchievementTotalDelay[boxID],
			 boxID,
			 #ACLbox)
		elseif StatsMenu.IsSecretsMenuVisible() and selectMenu == true and hideMenu == false then
						text:Render(requireLink[boxID].Pname,
			 requireLink[boxID].Description,
			  requireLink[boxID].grid[cursor].Unlocked, 
			  requireLink[boxID].grid[cursor].Near,
			  requireLink[boxID].Counter,
			  requireLink[boxID].Pname, true)
			  
			 text:RenderCounters(requireLink[boxID].size, 
			 requireLink[boxID].grid[requireLink[boxID].dimX].PosX,
			 requireLink[boxID].grid[#requireLink[boxID].grid].PosX,
			 requireLink[boxID].Counter - FakeAchDelay[boxID],
			 #requireLink[boxID].grid - AchievementTotalDelay[boxID],
			 boxID,
			 #ACLbox)
		end
end
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.RenderFunction)

	local hasPlayed = false

function ACLadmin:enterSecrets()

	if StatsMenu.IsSecretsMenuVisible() and hasPlayed == false and hideMenu == false then
		for i = 1, 1 do
			Portrait:Play("EnterRight",true)
			hasPlayed = true
					for u=1, #requireLink[boxID].grid do
							requireLink[boxID].grid[u].Tile:Play("EnterRight")
					end
			ACLadmin:ChangePortraitImg()
			CursorSprite:Play("Idle", true)
		end
		
	elseif StatsMenu.IsSecretsMenuVisible() ~= true and hasPlayed == true and hideMenu == false then
		hasPlayed = false
		Portrait:Play("ExitFor",true)
					for u=1, #requireLink[boxID].grid do
							requireLink[boxID].grid[u].Tile:Play("ExitRight")
										
					end
		CursorSprite:Play("Idle2", true)
	end
	
	if StatsMenu.IsSecretsMenuVisible() and hasPlayed == true and idle == false and hideMenu == false then
		if Portrait:IsFinished("EnterRight") then
			Portrait:Play("Idle",true)
			idle = true
					for u=1, #requireLink[boxID].grid do
							requireLink[boxID].grid[u].Tile:Play("Idle", true)
										
					end
		end
	end
end	
ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.enterSecrets)

	function ACLadmin:showPortrait() -- USE Q AND E TO SWITCH PORTRAITS, AS IN, SWITCH THE REQUIRED WITH BOXID
	-- USE CHECK FUNCTION HERE TO CHECK WHICH SECRETS ARE UNLOCKED IN THE BRAND NEW PORTRAIT
		if StatsMenu.IsSecretsMenuVisible() and hideMenu == false then
		
			if boxID ~= prevBox then
		
				
				if Portrait:IsFinished() then
					if Left == true then
								for i=1, #requireLink[boxID].grid do
									requireLink[boxID].grid[i].Tile:Play("EnterLeft")
								
								end
					Portrait:Play("EnterLeft",true)

					else
								for i=1, #requireLink[boxID].grid do
									requireLink[boxID].grid[i].Tile:Play("EnterRight")
								
								end
					Portrait:Play("EnterRight",true)
					end
					CursorSprite:Play("Idle", true)
				end
				if Portrait:IsFinished("EnterLeft") or Portrait:IsFinished("EnterRight") then
					Portrait:Play("Idle",true)
								for i=1, #requireLink[boxID].grid do
									requireLink[boxID].grid[i].Tile:Play("Idle", true)
								
								end
					CursorSprite:Play("Idle", true)
				end
			end
		end
		if prevBox ~= boxID then
			if Portrait:IsPlaying("EnterLeft") or Portrait:IsPlaying("EnterRight") and hideMenu == false then
				Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
				Portrait:LoadGraphics()
				ACLadmin:ChangePortraitImg()
				if selectMenu == true then
					for i = 1, #ACLmenu do
						ACLmenu[i]:LoadGraphics()
						ACLmenu[i]:Play("Idle",true)
						if (requireLink[i].Counter - FakeAchDelay[i]) == (#requireLink[i].grid - AchievementTotalDelay[i]) then
							ACLmenu[i]:Play("star",true)
						end
					end
				end
				
				
				prevBox = boxID
			end
		end
	--USES RENDER CALLBACK, WHEN Q AND E SWITCH THE PORTRAIT NEED, THE IMAGE CHANGE
	end
	ACLadmin:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, ACLadmin.showPortrait)


function ACLadmin:ChangePortraitImg()

	if selectMenu == true and hideMenu == false then
	
		Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/EMPTY.png")

	elseif requireLink[boxID].grid[cursor].Unlocked == false and hideMenu == false then
	
	Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/achievement_locked.png")
	
	elseif hideMenu == false then

	Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/"..requireLink[boxID].grid[cursor].gfx)
		
	end
	if hideMenu == false then
		Portrait:LoadGraphics()
	end
	
end


function ACLadmin:MakeSelectGrid()

		if ScreenX <= 473.0 and SelectMenuWidth == 5 and f5 == false and hideMenu == false then 
		Portrait:Load("gfx/ui/portrait/portrait_small.anm2", true)
		Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
		Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/EMPTY.png")
		SelectMenuWidth = 3
		SelectMenuThree = 2
		f5 = true
		boxID = 5
		selectMenu = true
		end
		
		if ScreenY <= 252.0 and SelectMenuWidth == 5 and f5 == false and hideMenu == false then 
		Portrait:Load("gfx/ui/portrait/portrait_small.anm2", true)
		Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
		Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/EMPTY.png")
		SelectMenuWidth = 3
		SelectMenuThree = 2
		f5 = true
		boxID = 5
		selectMenu = true
		end
		
		if ScreenX > 473.0 and ScreenY > 252.0 and SelectMenuWidth == 3 and f5 == false and hideMenu == false then 
		Portrait:Load("gfx/ui/portrait/portrait.anm2", true)
		Portrait:ReplaceSpritesheet(0, "gfx/ui/portrait/"..requireLink[boxID].portrait..".png")
		Portrait:ReplaceSpritesheet(3, "gfx/ui/achievement/EMPTY.png")
		SelectMenuWidth = 5
		SelectMenuThree = 0
		f5 = true
		boxID = 8
		selectMenu = true
		end
		
		
	if f5 == true and hideMenu == false then
		if #ACLmenu % SelectMenuWidth ~= 0 then
			h = #ACLmenu + (SelectMenuWidth - (#ACLmenu % SelectMenuWidth))
		else
			h = #ACLmenu
		end
		totalcolumn = h / SelectMenuWidth

		for i = 1, #ACLmenu do
			if i % SelectMenuWidth == 0 then
			
					rowtile[i] = 2 - SelectMenuThree
				
			else
				rowtile[i] = i % SelectMenuWidth - 3
			end
			for a = 1, totalcolumn do
				if i <= (a * SelectMenuWidth) then
					columntile[i] = a - 2
					break
				end
			end
		end
		f5 = false
	end
end

function ACLadmin:AddNewPortrait(title, linkName)

requireLink[#requireLink + 1] = linkName
table.insert(ACLbox, title)
table.insert(ACLmenu, 1)
ACLmenu[#ACLmenu] = Sprite()

ACLspoiler.RecheckLinks()

end

function ACLadmin:AddNewCollection(titlearr)
local arr = {}	

for k2,v2 in pairs(titlearr) do

	for k,v in pairs(ACLbox) do
	
		if ACLbox[k] == titlearr[k2] then 
			table.insert(arr, k)
		end
			
	end
	
end

ACLcollections[#ACLcollections + 1] = {
Portraits = arr,
total = 0,
Complete = false
}

end


function ACLadmin:printSelectWidth()
print(SelectMenuWidth)
print(SelectMenuThree)
end