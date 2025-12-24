local cba = CutBossesAttacks

ImGui.CreateMenu("CutBossesAttacks", "\u{f043} CBA")
ImGui.AddElement("CutBossesAttacks", "CBASettingsButton", ImGuiElement.MenuItem, "\u{f085} Settings")
ImGui.CreateWindow("CBASettingsWindow", "Settings")
ImGui.LinkWindowToElement("CBASettingsWindow", "CBASettingsButton")
ImGui.AddTabBar("CBASettingsWindow", "CBASettingsTabBar")
ImGui.AddTab("CBASettingsTabBar", "CBASettingsGeneralTab", "General")

local function AddBoolSetting(setting, category, name, info)
	local id = "CBASettings" .. setting
	local tab = "General"
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "", ImGuiElement.Separator)
	ImGui.AddCheckbox("CBASettings" .. tab .. "Tab", id, "", nil, true)
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "", ImGuiElement.SameLine)
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "CBASettings" .. setting .. "Text", ImGuiElement.TextWrapped, name)
	ImGui.SetHelpmarker("CBASettings" .. setting .. "Text", info)
	ImGui.AddCallback(id, ImGuiCallback.Render, function()
		ImGui.UpdateData(id, ImGuiData.Value, cba.Save.Config[category][setting])
	end)
	ImGui.AddCallback(id, ImGuiCallback.Edited, function(value)
		 cba.Save.Config[category][setting] = value
	end)
end

local function AddNumSetting(setting, category, minv, maxv, name, info)
	local id = "CBASettings" .. setting
	local tab = "General"
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "", ImGuiElement.Separator)
	ImGui.AddSliderInteger("CBASettings" .. tab .. "Tab", id, "", nil, cba.Save.Config[category][setting], minv, maxv)
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "", ImGuiElement.SameLine)
	ImGui.AddElement("CBASettings" .. tab .. "Tab", "CBASettings" .. setting .. "Text", ImGuiElement.TextWrapped, name)
	ImGui.SetHelpmarker("CBASettings" .. setting .. "Text", info)
	ImGui.AddCallback(id, ImGuiCallback.Render, function()
		ImGui.UpdateData(id, ImGuiData.Value, cba.Save.Config[category][setting])
	end)
	ImGui.AddCallback(id, ImGuiCallback.Edited, function(value)
		 cba.Save.Config[category][setting] = value
	end)
end

ImGui.AddButton("CBASettingsGeneralTab", "CBAResetSettingsButton", "Reset Settings",
    function()
        for k, v in pairs(cba.Save.DefaultConfig) do
			for k2, v2 in pairs(cba.Save.DefaultConfig[k]) do
				cba.Save.Config[k][k2] = cba.Save.DefaultConfig[k][k2]
			end
		end
end, false)

ImGui.AddElement("CBASettingsGeneralTab", "", ImGuiElement.SeparatorText, "Siren")
AddBoolSetting("SirenRestore", "General", "Siren Restore", "Adds unused attack to Siren")
AddBoolSetting("NotesAttack", "Siren", "Note Attack", "If true, then unused Note Attack will replace Scream and Summon attacks")
AddNumSetting("NotesChance", "Siren", 0, 100, "Note Attack Chance", "Chance of replacing Scream and Summon attacks")
AddBoolSetting("ScreamAttack", "Siren", "Scream Attack Overwrite", "Restores old Scream attack pattern from Antibirth")
ImGui.AddElement("CBASettingsGeneralTab", "", ImGuiElement.SeparatorText, "Mausoleum Mom")
AddBoolSetting("MomRestore", "General", "Mom Restore", "Changes behaivor of Mausoleum Mom")
AddNumSetting("ArmEyeChance", "Mom", 0, 100, "Arm Attack Chance (Eye)", "Chance of Arm attack to replace Brimstone Eye attack")
AddNumSetting("ArmSpawnChance", "Mom", 0, 100, "Arm Attack Chance (Summon)", "Chance of Arm attack to replace Summoning attack(Not recommended to increase this value to more than 20)")
ImGui.AddElement("CBASettingsGeneralTab", "", ImGuiElement.SeparatorText, "Mega Satan 2'nd Phase")
AddBoolSetting("MegaSatanRestore", "General", "Mega Satan 2 Hands Restore", "Readds Mega Satan's hands in 2'nd phase and adds new attacks to them")
AddNumSetting("AttackChance", "MS2", 0, 100, "Hand Attack Chance", "Chance of Mega Satan's hand to attack in 2'nd phase")
AddNumSetting("HandsHP", "MS2", 500, 1000, "Hands HP", "Defines what number of HP will Mega Satan 2'nd phase hands have")

--Debugging--

ImGui.AddElement("CutBossesAttacks", "CBADebuggingButton", ImGuiElement.MenuItem, "\u{f552} Debugging")
ImGui.CreateWindow("CBADebuggingWindow", "Debugging")
ImGui.LinkWindowToElement("CBADebuggingWindow", "CBADebuggingButton")

ImGui.AddButton("CBADebuggingWindow", "CBADebuggingToWitnessButton", "TP to Witness",
    function()
        Isaac.ExecuteCommand("stage 8c")
		if Game():GetDebugFlags() & DebugFlag.INFINITE_HP == 0 then
			Isaac.ExecuteCommand("debug 3")
		end
		Isaac.ExecuteCommand("g c118")
		Isaac.ExecuteCommand("g soy milk")
		Isaac.GetPlayer().Damage = 1000
		Isaac.GetPlayer():UseCard(Card.CARD_EMPEROR)
		ImGui.Hide()
end, false)

ImGui.AddButton("CBADebuggingWindow", "CBADebuggingToMortisWitnessButton", "TP to Mortis Witness",
    function()
		if LastJudgement and StageAPI then
			Isaac.ExecuteCommand("cstage Mortis 2")
			if Game():GetDebugFlags() & DebugFlag.INFINITE_HP == 0 then
				Isaac.ExecuteCommand("debug 3")
			end
			Isaac.ExecuteCommand("g c118")
			Isaac.ExecuteCommand("g soy milk")
			Isaac.GetPlayer().Damage = 1000
			Isaac.GetPlayer():UseCard(Card.CARD_EMPEROR)
			ImGui.Hide()
		else
			ImGui.PushNotification("YOU STUPID", ImGuiNotificationType.ERROR)
			SFXManager():Play(SoundEffect.SOUND_FART_MEGA)
		end
end, false)

ImGui.AddButton("CBADebuggingWindow", "CBADebuggingToDogmaButton", "TP to Dogma",
    function()
        Isaac.ExecuteCommand("stage 13a")
		if Game():GetDebugFlags() & DebugFlag.INFINITE_HP == 0 then
			Isaac.ExecuteCommand("debug 3")
		end
		Isaac.ExecuteCommand("g c118")
		Isaac.ExecuteCommand("g soy milk")
		Isaac.GetPlayer().Damage = 1000
		Game():ChangeRoom(109, 0)
		ImGui.Hide()
end, false)

ImGui.AddButton("CBADebuggingWindow", "CBADebuggingToMegaSatanButton", "TP to Mega Satan",
    function()
        Isaac.ExecuteCommand("stage 11")
		if Game():GetDebugFlags() & DebugFlag.INFINITE_HP == 0 then
			Isaac.ExecuteCommand("debug 3")
		end
		Isaac.ExecuteCommand("g c118")
		Isaac.ExecuteCommand("g soy milk")
		Game():ChangeRoom(-7, 0)
		Isaac.GetPlayer().Damage = 1000
		ImGui.Hide()
end, false)

ImGui.AddButton("CBADebuggingWindow", "CBADebuggingToSirenButton", "TP to Siren",
    function()
        Isaac.ExecuteCommand("stage 5c")
		if Game():GetDebugFlags() & DebugFlag.INFINITE_HP == 0 then
			Isaac.ExecuteCommand("debug 3")
		end
		Isaac.ExecuteCommand("g c118")
		Isaac.ExecuteCommand("g soy milk")
		Isaac.ExecuteCommand("goto s.boss.5370")
		Isaac.GetPlayer().Damage = 1000
		ImGui.Hide()
end, false)