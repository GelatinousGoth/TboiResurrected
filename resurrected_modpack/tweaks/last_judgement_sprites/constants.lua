local mod = LastJudgementSprites
local game = Game()

function mod:GetEnt(name, sub)
	return {ID = Isaac.GetEntityTypeByName(name), Var = Isaac.GetEntityVariantByName(name), Sub = Isaac.GetEntitySubTypeByName(name)}
end

mod.ENT = {
    CageVis = mod:GetEnt("Cage Vis"),
}

mod.Colors = {}
mod.Colors.DankBlack = Color(0.5,0.5,0.5,1)
    mod.Colors.DankBlack:SetColorize(1,1,1,1)
mod.Colors.CageProj = Color(1,1,1)
    mod.Colors.CageProj:SetColorize(0.8,1,0.85,1)
mod.Colors.CageCreep = Color(1,1,1)
    mod.Colors.CageCreep:SetColorize(2.75,3,2.25,1)
mod.Colors.CageSplat = Color(0.04,0.3,0.04,1,0.4,0.4,0.3)