local TR_Manager = require("resurrected_modpack.manager")

local ModName = "Splashes Renamed"
local mod = TR_Manager:RegisterMod(ModName, 1)

function mod:SplashesRenamed()
    if not FiendFolio then return end
        FiendFolio.SplashTexts = {
            Small = {
            "brought to you by the sweaty meta-fetishists"},
            Medium = {
            "the game just got harder!",
            "from the creators of antibirth!",
            "from the creators of repentance!",
            "we put the mental in experimental",
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
            "beware of the pipeline"
            }
        }
    FiendFolio:BuildSplashTexts()
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.SplashesRenamed)