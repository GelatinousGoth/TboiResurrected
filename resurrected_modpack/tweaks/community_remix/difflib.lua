return function(parentMod) -- pass mod reference. must have a global savedata array named "saveData".
	-- example
	local game = Game()
	local currsel = 1
	local lastsel = -1
	local menu = 0
	local init = false
	if not DifficultyLibrary then
		DifficultyLibrary = RegisterMod("Difficulty Library", 1)
	end
	local json = include("json")
	local pgd = Isaac.GetPersistentGameData()
	local thisver = 12
	DifficultyLibrary.Loaded = DifficultyLibrary.Loaded or false
	
	DM_Difficulties = DM_Difficulties or {} -- this will stay a global otherwise it will clear itself with new mods

	if (DifficultyManager == nil) or DifficultyManager.Version < thisver then
		
		DifficultyManager = { -- this is the DifficultyManager global. you can use its methods below.
			Version = thisver,
			AddDifficulty = function(nameStr, sprObject, baseDiff) -- give difficulty name, sprite object for rendering, and the base difficulty to run the difficulty on.
				local newInt = #DM_Difficulties + 1
				for i, v in pairs(DM_Difficulties) do
					if v.Name == nameStr then
						newInt = i -- overwrite if possible
					end
				end
				DM_Difficulties[newInt] = {Name = nameStr, Sprite = sprObject, Difficulty = baseDiff}
			end,
			
			GetDifficultyIdByName = function(nameStr) -- this is not generally useful. i need to phase this out at some point
				local ret
				for i, v in pairs(DM_Difficulties) do
					if v.Name == nameStr then
						ret = i
					end
				end
				return ret
			end,
			
			ClearDifficulty = function(nameStr) -- removes difficulty and refreshes table.
				local t = {}
				for i, v in pairs(DM_Difficulties) do
					if v.Name ~= nameStr then
						t[#t + 1] = v
					end
				end
				DM_Difficulties = t
			end,
			
			GetDifficultySelected = function() -- for use on menu only. returns table.
				return DM_Difficulties[currsel]
			end,
			
			ResetLibrary = function()
				--print("[" .. DifficultyLibrary.Name, "v" .. thisver .. "] was erased.")
			end
		}
		
		DifficultyManager.GetDifficulty = function()
			local ret = parentMod.saveData.gameDifficulty
			return ret
		end

		DifficultyManager.GetStoredDifficulty = function()
			local ret = parentMod.saveData.storedGameDifficulty
			return ret
		end
		
		local vanilla_diff_spr = Sprite() -- define a sprite object
		vanilla_diff_spr:Load("gfx/ui/ex/difficulties_vanilla.anm2") -- and load your anm2.
		vanilla_diff_spr:LoadGraphics()

		DifficultyManager.AddDifficulty("Normal", vanilla_diff_spr, 0) -- pass your sprite object in. this is kept here as a failsafe if you luamod in the main menu.

		function DifficultyLibrary.saveslotloadfunction(_, slot)
			pgd = Isaac.GetPersistentGameData()
			--[[
				There are a number of callbacks to allow control of when you add your difficulty.
				I tend to use DIFFLIB_MC_PRE_ADD_AFTERBIRTH_DIFFICULTIES. it makes greed and greedier appear further down the selector.
			]]
			Isaac.RunCallback("DIFFLIB_MC_PRE_ADD_REBIRTH_DIFFICULTIES")
			
			if DifficultyManager.GetDifficultyIdByName("Normal") then -- pictured below is how you create a difficulty. clearing the difficulty is recommended to maintain difficulty order for difficulties that are removed per the request of unlocks.
				DifficultyManager.ClearDifficulty("Normal")
			end
			DifficultyManager.AddDifficulty("Normal", vanilla_diff_spr, 0) -- end here
			
			if DifficultyManager.GetDifficultyIdByName("Hard") then
				DifficultyManager.ClearDifficulty("Hard")
			end
			DifficultyManager.AddDifficulty("Hard", vanilla_diff_spr, 1)
			
			Isaac.RunCallback("DIFFLIB_MC_POST_ADD_REBIRTH_DIFFICULTIES")
			
			
			
			Isaac.RunCallback("DIFFLIB_MC_PRE_ADD_AFTERBIRTH_DIFFICULTIES")
			
			if DifficultyManager.GetDifficultyIdByName("Greed") then
				DifficultyManager.ClearDifficulty("Greed")
			end
			DifficultyManager.AddDifficulty("Greed", vanilla_diff_spr, 2)
			
			if DifficultyManager.GetDifficultyIdByName("Greedier") then -- this is an unlockable difficulty. this appears after greedier is unlocked on the save file.
				DifficultyManager.ClearDifficulty("Greedier")
			end
			if pgd:Unlocked(341) then
				DifficultyManager.AddDifficulty("Greedier", vanilla_diff_spr, 3)
			end -- end here
			
			Isaac.RunCallback("DIFFLIB_MC_POST_ADD_AFTERBIRTH_DIFFICULTIES")
			
			if lastsel == -1 then lastsel = DifficultyManager.GetDifficultyIdByName("Hard") end
			currsel = lastsel
		end

		function DifficultyLibrary.menurenderfunction(_)
			menu = MenuManager.GetActiveMenu()
			local dps = CharacterMenu:GetDifficultyPageSprite()
			if dps:GetFilename() == "gfx/ui/main menu/DifficultyWidget.anm2" or dps:GetFilename() == "gfx/ui/main menu/difficultywidget.anm2" then
				dps:Load("gfx/ui/ex/difficulty_widget.anm2")
				dps:LoadGraphics()
			end
			
			if menu == MainMenuType.CHARACTER then
				if Input.IsActionTriggered(ButtonAction.ACTION_MENUUP, -1) then currsel = currsel - 1 if currsel ~= 0 then Isaac.RunCallback("DIFFLIB_MC_POST_DIFFICULTY_CHANGED") end end
				if Input.IsActionTriggered(ButtonAction.ACTION_MENUDOWN, -1) then currsel = currsel + 1 
				if communityRemix then
					if currsel ~= 8 then 
						Isaac.RunCallback("DIFFLIB_MC_POST_DIFFICULTY_CHANGED")
					end
				elseif currsel ~= 6 then
						Isaac.RunCallback("DIFFLIB_MC_POST_DIFFICULTY_CHANGED")
				end
				end
				lastsel = currsel
			end
			
			if currsel > #DM_Difficulties then currsel = 1 end
			if currsel < 1 then currsel = #DM_Difficulties end
			
			dps:Play("Idle", true)
			
			for i = 1, #DM_Difficulties do
				if CharacterMenu.GetActiveStatus() ~= CharacterMenuStatus.SEED then
					local _vp = i-1
					if _vp <= 0 then _vp = #DM_Difficulties end
					local _vf = i+1
					if _vf > #DM_Difficulties then _vf = 1 end
					
					local vp = DM_Difficulties[_vp]
					local v = DM_Difficulties[i]
					local vf = DM_Difficulties[_vf]
					
					if i == currsel then
						if CharacterMenu.GetDifficulty() ~= v.Difficulty then
							CharacterMenu.SetDifficulty(v.Difficulty)
						end
						
						local basepos = dps:GetNullFrame("diff"):GetPos() + Vector(306, 107)
						local sp = vp.Sprite
						local s = v.Sprite
						local sf = vf.Sprite
						
						if vp.Name ~= v.Name then
							sp:Play(vp.Name, true)
							sp.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
							sp:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, basepos - Vector(-4, 22)), Vector.Zero, Vector.Zero)
						end
						
						s:Play(v.Name, true)
						s.Color = Color(1, 1, 1, 1, 0, 0, 0)
						s:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, basepos), Vector.Zero, Vector.Zero)
						
						if vf.Name ~= v.Name then
							sf:Play(vf.Name, true)
							sf.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
							sf:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, basepos + Vector(-4, 22)), Vector.Zero, Vector.Zero)
						end
					end
				end
			end
		end



		function DifficultyLibrary.post_saveslot_load(_, slot)
			if parentMod then
				if parentMod:HasData() then
					parentMod.saveData = json.decode(parentMod:LoadData())
					parentMod:SaveData(json.encode(parentMod.saveData))
				else
					parentMod.saveData.gameDifficulty = parentMod.saveData.gameDifficulty ~= nil and parentMod.saveData.gameDifficulty or "Undefined" -- these are strings, as difflib uses strings to determine/identify difficulties.
					parentMod.saveData.storedGameDifficulty = parentMod.saveData.storedGameDifficulty ~= nil and parentMod.saveData.storedGameDifficulty or "Undefined"
					parentMod:SaveData(json.encode(parentMod.saveData))
				end
			end
		end



		function DifficultyLibrary.post_player_init(_, player)
			local TotPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)
			if TotPlayers == 0 then
				if game:GetFrameCount() == 0 then
					if menu == MainMenuType.CHARACTER then
						if menu ~= 0 then
							parentMod.saveData.gameDifficulty = DifficultyManager.GetDifficultySelected().Name
							parentMod.saveData.storedGameDifficulty = parentMod.saveData.gameDifficulty
							lastsel = currsel
							menu = 0
						end
					else
						if menu == 3 or menu == 0 then
							parentMod.saveData.gameDifficulty = parentMod.saveData.storedGameDifficulty
							lastsel = currsel
							menu = 0
						else
							local setDifficulty = Isaac.RunCallback("DIFFLIB_MC_GET_CHALLENGE_DIFFICULTY") --  return string. this will only run if the run is a challenge run or otherwise.
							if setDifficulty == nil then setDifficulty = "Undefined" end
							parentMod.saveData.storedGameDifficulty = setDifficulty
							parentMod.saveData.gameDifficulty = parentMod.saveData.storedGameDifficulty
						end
					end
					parentMod.saveData.gameDifficulty = parentMod.saveData.gameDifficulty ~= nil and parentMod.saveData.gameDifficulty or "Undefined" -- these are strings, as difflib uses strings to determine/identify difficulties.
					parentMod.saveData.storedGameDifficulty = parentMod.saveData.storedGameDifficulty ~= nil and parentMod.saveData.storedGameDifficulty or "Undefined"
					if parentMod then
						parentMod:SaveData(json.encode(parentMod.saveData))
					end
				end
			end
		end
		
		

		function DifficultyLibrary.game_exit(_, died)
			parentMod.saveData.storedGameDifficulty = parentMod.saveData.gameDifficulty
			if parentMod then
				parentMod:SaveData(json.encode(parentMod.saveData))
			end
		end



		local vanilla_diff_spr = Sprite() -- define a sprite object
		vanilla_diff_spr:Load("gfx/ui/ex/difficulties_vanilla.anm2") -- and load your anm2.
		vanilla_diff_spr:LoadGraphics()
		
		--[[function DifficultyLibrary.addnormal(_)
			if DifficultyManager.GetDifficultyIdByName("Normal") then -- replace with your difficulty name. Must be the same as the layer name in the anm2.
				DifficultyManager.ClearDifficulty("Normal")
			end
			DifficultyManager.AddDifficulty("Normal", vanilla_diff_spr, 0)
		end
		DifficultyLibrary:RemoveCallback("DIFFLIB_MC_PRE_ADD_REBIRTH_DIFFICULTIES", DifficultyLibrary.addnormal)
		DifficultyLibrary:AddCallback("DIFFLIB_MC_PRE_ADD_REBIRTH_DIFFICULTIES", DifficultyLibrary.addnormal)]]--

	end
	
	DifficultyLibrary:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function(_)
		if thisver == DifficultyManager.Version and not DifficultyLibrary.Loaded then
			DifficultyLibrary.Loaded = true
			DifficultyLibrary:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, DifficultyLibrary.post_player_init)
			DifficultyLibrary:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, -999, DifficultyLibrary.game_exit)
			DifficultyLibrary:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, DifficultyLibrary.post_saveslot_load)
			DifficultyLibrary:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, DifficultyLibrary.menurenderfunction)
			DifficultyLibrary:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, DifficultyLibrary.saveslotloadfunction)
			DifficultyManager.Loaded = true
			print("[" .. DifficultyLibrary.Name, "v" .. DifficultyManager.Version .. "] Successfully loaded.")
		end
	end)
end