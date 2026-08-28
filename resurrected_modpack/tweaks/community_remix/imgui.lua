return function()
	local json = include("json")
	if not ImGui.ElementExists('TRCremixMenu') then

		ImGui.CreateMenu('TRCremixMenu', '\u{f091} TBOI: Rekindled Options')
		do -- cosmetic
		
		ImGui.AddElement('TRCremixMenu', 'remixMenuCosmetic', ImGuiElement.MenuItem, '\u{f5d1} Community Remix Options')
		ImGui.CreateWindow('remixWindowCosmetic', 'Community Remix Options')
		ImGui.LinkWindowToElement('remixWindowCosmetic', 'remixMenuCosmetic')

		ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Text, "\n")
		ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Separator)
		do -- tear sfx
			local id = 'remixMenuCosmeticTearSFX'

			ImGui.AddCombobox('remixWindowCosmetic', id, 'Tear Sounds', function(i, v)
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.tear_sounds = i
					sd.cfg.tear_sounds = sd.cfg.tear_sounds or i
					TRCommunityRemix:SaveData(json.encode(sd))
				end
			end, {"Rebirth", "Remix", "Flash"}, 1, true)

			ImGui.AddCallback(id, ImGuiCallback.Render, function()
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.tear_sounds = sd.cfg.tear_sounds or 0
					ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.tear_sounds)
				end
			end)
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Separator)
		end

		do -- gamefeel gfx
			local id = 'remixMenuCosmeticGameFeelGFX'
			ImGui.AddCheckbox('remixWindowCosmetic', id, 'Stun GFX', nil, false)
			ImGui.AddCallback(id, ImGuiCallback.Render, function()
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.gamefeel = sd.cfg.gamefeel or true
					ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.gamefeel)
				end
			end)
			ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.gamefeel = v
					sd.cfg.gamefeel = sd.cfg.gamefeel or v
					TRCommunityRemix:SaveData(json.encode(sd))
				end
			end)
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.TextWrapped, "A stun effect is applied to enemies less powerful than you when you hit them.")
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Separator)
		end

		do -- main menu gfx
			local id = 'remixMenuCosmeticMainMenuGFX'
			ImGui.AddCheckbox('remixWindowCosmetic', id, 'Main Menu GFX', nil, false)
			ImGui.AddCallback(id, ImGuiCallback.Render, function()
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.mainmenugfx = sd.cfg.mainmenugfx or true
					ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.mainmenugfx)
				end
			end)
			ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.mainmenugfx = v
					sd.cfg.mainmenugfx = sd.cfg.mainmenugfx or v
					TRCommunityRemix:SaveData(json.encode(sd))
				end
			end)
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.TextWrapped, "Extra main menu graphic details.")
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Separator)
		end

		do
			local id = 'remixMenuCosmeticMainMenuHandPos'
			ImGui.AddSliderInteger('remixWindowCosmetic', id, 'Main Menu Hand Position', nil, 0, -100, 100)
			ImGui.AddCallback(id, ImGuiCallback.Render, function (v) -- Function ran whenever the slider is changed.
				local sd = TRCommunityRemix.GetSaveData()
        		if sd.cfg then
					sd.cfg.mainmenuhandpos = sd.cfg.mainmenuhandpos or 0
					ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.mainmenuhandpos)
				end
    		end)
			ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
				local sd = TRCommunityRemix.GetSaveData()
				if sd.cfg then
					sd.cfg.mainmenuhandpos = v
					sd.cfg.mainmenuhandpos = sd.cfg.mainmenuhandpos or v
					TRCommunityRemix:SaveData(json.encode(sd))
				end
			end)
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.TextWrapped, "Position of Isaac's hand in the main menu.")
			ImGui.AddElement('remixWindowCosmetic', '', ImGuiElement.Separator)
		end

		end
    end
end