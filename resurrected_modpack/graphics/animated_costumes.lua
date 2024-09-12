local mod = require("resurrected_modpack.mod_reference")
mod.CurrentModName = "Animated Costumes"

local HASMEATVEIN = false
local HASPOLYSPARKLE = false
local HASFOURPOINTFIVEVOLTSPARKS = false
local HASMYSTERIOUSDRIP = false

local MEATVEIN = Isaac.GetCostumeIdByPath("gfx/characters/meatVein.anm2")
local POLYSPARKLE = Isaac.GetCostumeIdByPath("gfx/characters/polySparkle.anm2")
local FOURPOINTFIVEVOLTSPARKS = Isaac.GetCostumeIdByPath("gfx/characters/4point5VoltSparks.anm2")
local MYSTERIOUSDRIP = Isaac.GetCostumeIdByPath("gfx/characters/mysteriousDrip.anm2")

function mod:POST_UPDATE()
local player = Isaac.GetPlayer(0)
	
	if player:HasCollectible(193) then
		if HASMEATVEIN ~= true then
			player:AddNullCostume(MEATVEIN)
			HASMEATVEIN = true
		end

	elseif HASMEATVEIN == true and player:HasCollectible(193) == false then
		player:TryRemoveNullCostume(MEATVEIN)
		HASMEATVEIN = false
	end
	
	if player:HasCollectible(169) then
		if HASPOLYSPARKLE ~= true then
			player:AddNullCostume(POLYSPARKLE)
			HASPOLYSPARKLE = true
		end

	elseif HASPOLYSPARKLE == true and player:HasCollectible(169) == false then
		player:TryRemoveNullCostume(POLYSPARKLE)
		HASPOLYSPARKLE = false
	end
	
	if player:HasCollectible(647) then
		if HASFOURPOINTFIVEVOLTSPARKS ~= true then
			player:AddNullCostume(FOURPOINTFIVEVOLTSPARKS)
			HASFOURPOINTFIVEVOLTSPARKS = true
		end

	elseif HASFOURPOINTFIVEVOLTSPARKS == true and player:HasCollectible(647) == false then
		player:TryRemoveNullCostume(FOURPOINTFIVEVOLTSPARKS)
		HASFOURPOINTFIVEVOLTSPARKS = false
	end
	
	if player:HasCollectible(317) then
		if HASMYSTERIOUSDRIP ~= true then
			player:AddNullCostume(MYSTERIOUSDRIP)
			HASMYSTERIOUSDRIP = true
		end

	elseif HASMYSTERIOUSDRIP == true and player:HasCollectible(317) == false then
		player:TryRemoveNullCostume(MYSTERIOUSDRIP)
		HASMYSTERIOUSDRIP = false
	end
	
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.POST_UPDATE)