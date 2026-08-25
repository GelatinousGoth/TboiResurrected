return function()
	local json = include("json")
	if not ImGui.ElementExists('remixMenu') then
		print("imgui menu exists")
		ImGui.CreateMenu('remixMenu', '\u{f5d1} Community Remix Options')
		do -- cosmetic
		
		ImGui.AddElement('remixMenu', 'remixMenuCosmetic', ImGuiElement.MenuItem, '\u{f7d9} Cosmetic')
		ImGui.CreateWindow('remixWindowCosmetic', 'Cosmetic')
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

		end
    end
end