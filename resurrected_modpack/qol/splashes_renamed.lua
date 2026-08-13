local TR_Manager = require("resurrected_modpack.manager")

local ModName = "Splashes Renamed"
local mod = TR_Manager:RegisterMod(ModName, 1)

function mod:SplashesRenamed()
    if not FiendFolio then return end
        FiendFolio.SplashTexts = {
            Small = {
			"enemies that don't look as isaac-y, but still look pretty good",
            "it's a bug! it's a bug!",
            "uninstall the game",
            "brought to you by the sweaty meta-fetishists"},
            Medium = {
            "the game just got harder!",
            "from the creators of antibirth!",
            "from the creators of repentance!",
            "we put the mental in experimental",
			"beta version begone",
            "edmund smiles upon you",
            "elder gods of the isaac community"},
            Large = {
            ":^)",
            "now with bigger enemies!",
            "antibirth killer",
            "bitcoin mining initialized",
            "<3",
            "300% more gamefeel",
            "the blood moon is rising",
            "don't get hit",
            "also try deliverance!",
            "also try retribution!",
            "also try alphabirth!",
			"also try boss butch!",
            "also try revelations!",
            "also try fall from grace!",
            "also try last judgement!",
            "it came from space",
            "limited edition",
            "the sequel!",
            "modders making mods for fun",
            "fully modelled",
            "look behind you",
            "electric boogalo",
            "happy birthday!",
            "three days are remaining...",
            "now a homestuck mod",
            "now an everything mod",
			"click to learn more.",
            "someone should rework these foes",
            "heaps of unused content",
            "we hate fun!",
            "everything has a price",
            "too many fortunes!",
            "Isaac fact!",
            "powered by repentogon!",
            "more than 500 enemies!",
            "beware of the pipeline"
            }
        }
    FiendFolio:BuildSplashTexts()
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.SplashesRenamed)