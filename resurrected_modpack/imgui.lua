return function()
	local json = include("json")
	if not ImGui.ElementExists('TRMenu') then

		ImGui.CreateMenu('TRMenu', '\u{f091} TBOI: Rekindled Options')
    end
end