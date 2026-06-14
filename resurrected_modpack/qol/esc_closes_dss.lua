local TR_Manager = require("resurrected_modpack.manager")
EscClosesDSS = TR_Manager:RegisterMod("Esc Closes DSS", 1)

function mod:CloseDSS()
	if DeadSeaScrollsMenu and DeadSeaScrollsMenu:IsOpen() then
		-- Go to the previous page
		DeadSeaScrollsMenu:GetCoreInput().menu.back = true
		DeadSeaScrollsMenu.Menus.Menu:Run()

		-- Close the pause menu and don't play the sound for it
		PauseMenu.SetState(PauseMenuStates.CLOSED)
        SFXManager():Stop(SoundEffect.SOUND_PAPER_IN)
	end
end

if REPENTOGON then
    mod:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, mod.CloseDSS)
else
    print("Bro... you need...... REPENTOGON installed......... to close DSS with ESC............")
end