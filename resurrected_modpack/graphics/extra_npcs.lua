local TR_Manager = require("resurrected_modpack.manager")
local ENShopkeeps = TR_Manager:RegisterMod("Extra NPCs", 1)

local ENShopkeepsDebug = false

local shopkeepRarities = {}
local shopkeepVariants = {}
local secretShopkeepVariants = {}

local revRarities = {}
shopkeepRarities["count"] = 0
shopkeepRarities["totalWeights"] = 0

local debugIterator = 0		--Minus 1 is off, 0 or higher is on. If on, it will iterate through all shopkeep variants one after the other

function ENShopkeeps:AddShopkeepRarity(name, weight)
	shopkeepRarities[name] = weight
	shopkeepRarities["totalWeights"] = shopkeepRarities["totalWeights"] + weight
	
	local rarityID = #revRarities + 1
	revRarities[rarityID] = name
	
	shopkeepVariants[name] = {}
	secretShopkeepVariants[name] = {}
end
function ENShopkeeps:AddShopkeepToPool(animFile, animName, animFileSpec, animNameSpec, rarity, secret)
	local shopkeepData = { animFile, animName, animFileSpec, animNameSpec }
	
	if (secret == true) then
		local shopkeepID = #secretShopkeepVariants[rarity] + 1
		secretShopkeepVariants[rarity][shopkeepID] = shopkeepData
	else
		local shopkeepID = #shopkeepVariants[rarity] + 1
		shopkeepVariants[rarity][shopkeepID] = shopkeepData
	end
end


ENShopkeeps:AddShopkeepRarity("Common", 70)
ENShopkeeps:AddShopkeepRarity("Uncommon", 26)
ENShopkeeps:AddShopkeepRarity("Rare", 4)

ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 1", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 1", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 2", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 2", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 3", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 3", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 4", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 4", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 5", "", "", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 6", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 6", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 7", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 7", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 8", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 8", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 9", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 9", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 10", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 10", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 11", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 11", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 12", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 12", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Common 13", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Common 13", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 14", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 14", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 15", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 15", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 16", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 16", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 17", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 17", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 18", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 18", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 19", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 19", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 20", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 20", "Common", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Common 21", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Common 21", "Common", false)

ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 1", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 1", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 2", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 2", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 3", "", "", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 4", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 4", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 5", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 5", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 6", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 6", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 10", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 10", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 11", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 11", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Uncommon 12", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Uncommon 12", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 13", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 13", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 14", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 14", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 15", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 15", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 16", "", "", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 17", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 17", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 18", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 18", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 19", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 19", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 20", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 20", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 21", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 21", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 22", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 22", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 23", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 23", "Uncommon", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Uncommon 24", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Uncommon 24", "Uncommon", false)

ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 1", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 1", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 2", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 2", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 3", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 3", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 4", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 4", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 5", "", "", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 6", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 6", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 7", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 7", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 8", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 8", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Rare 9", "gfx/rare shopkeeps/sitting_buddies.anm2", "Nickel Rare 9", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 10", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 10", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 11", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 11", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 12", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 12", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 13", "", "", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 14", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 14", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 15", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 15", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Rare 16", "gfx/rare shopkeeps/sitting_buddies_pt2.anm2", "Nickel Rare 16", "Rare", false)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/sitting_buddies.anm2", "Hey Lois", "", "", "Rare", false)




ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 1", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 1", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 2", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 2", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 3", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 3", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 4", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 4", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 5", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 5", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 6", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 6", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 7", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 7", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 8", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 8", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 9", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 9", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 10", "", "", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 11", "", "", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 12", "", "", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 13", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 13", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 14", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 14", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Common 15", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Common 15", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 16", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 16", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 17", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 17", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 18", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 18", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 19", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 19", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 20", "", "", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 21", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 21", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 22", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 22", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 23", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 23", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 24", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 24", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 25", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 25", "Common", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Common 26", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Common 26", "Common", true)

ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 1", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 1", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 2", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 2", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 3", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 3", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 4", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 4", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 5", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 5", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 6", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 6", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Uncommon 7", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Uncommon 7", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Uncommon 8", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Uncommon 8", "Uncommon", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Uncommon 9", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Uncommon 9", "Uncommon", true)

ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Rare 1", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Rare 1", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Rare 2", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Rare 2", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Rare 3", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Rare 3", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Rare 4", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Rare 4", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies.anm2", "Rare 5", "gfx/rare shopkeeps/hanging_buddies.anm2", "Nickel Rare 5", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 6", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Rare 6", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 7", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Rare 7", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "We Are The Same", "", "", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 8", "", "", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 9", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Rare 9", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 10", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Rare 10", "Rare", true)
ENShopkeeps:AddShopkeepToPool("gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Rare 11", "gfx/rare shopkeeps/hanging_buddies_pt2.anm2", "Nickel Rare 11", "Rare", true)


if (ENShopkeepsDebug) then
	print("number of rarities: " .. #revRarities)
	print("number of commons: " .. #shopkeepVariants["Common"])
	print("number of uncommons: " .. #shopkeepVariants["Uncommon"])
	print("number of rares: " .. #shopkeepVariants["Rare"])
	print("number of secret commons: " .. #secretShopkeepVariants["Common"])
	print("number of secret uncommons: " .. #secretShopkeepVariants["Uncommon"])
	print("number of secret rares: " .. #secretShopkeepVariants["Rare"])
end


function ENShopkeeps:ShopkeeperUpdate(npc)
	if (npc.State == NpcState.STATE_IDLE and npc.I1 == 0) then
		if (npc.Variant == 0 or npc.Variant == 3 or
			npc.Variant == 1 or npc.Variant == 4) then
			
			ENShopkeeps:RandomiseShopkeep(npc)
			npc.I1 = 1
		end
	end
end
function ENShopkeeps:RandomiseShopkeep(npc)
	local sprite = npc:GetSprite()
	local secret = false
	if (npc.Variant == 1 or npc.Variant == 4) then 		secret = true 		end	
	local special = false
	if (npc.Variant == 3 or npc.Variant == 4) then		special = true		end
	
	
	math.randomseed(npc.InitSeed)
	local shopkeepRNG = math.random(0, shopkeepRarities["totalWeights"] * 100)
	if (ENShopkeepsDebug) then Isaac.ConsoleOutput("rng: " .. (shopkeepRNG / 100.0)) end
	
	for i = 1, #revRarities do
		local rarityName = revRarities[i]
		local rarityWeight = shopkeepRarities[rarityName] * 100
		
		if (shopkeepRNG < rarityWeight) then		
			if (ENShopkeepsDebug) then print(" ... " .. rarityName) end
			
			local rarityVariants
			if (secret) then 
				rarityVariants = secretShopkeepVariants[rarityName]
			else
				rarityVariants = shopkeepVariants[rarityName]
			end
			
			ENShopkeeps:RandomiseShopkeepVarient(npc, sprite, secret, special, rarityVariants)
			
			break;
		else
			shopkeepRNG = shopkeepRNG - rarityWeight
		end
	end
end
function ENShopkeeps:RandomiseShopkeepVarient(npc, sprite, secret, special , rarityVariants)

	local shopkeepVariantRNG = math.random(1, #rarityVariants) --+ 1
	local shopkeepData = rarityVariants[shopkeepVariantRNG]
	npc.SubType = shopkeepVariantRNG
	
	if (ENShopkeepsDebug) then Isaac.ConsoleOutput("subtype: " .. shopkeepVariantRNG) end
	
	if (shopkeepData == nil) then 
		print("ShopkeepData is nil for some reason")
	else
		if (special) then
			if (shopkeepData[3] == "") then 
				if (ENShopkeepsDebug) then print("Shopkeep lacks a nickel varient, rerolling...") end
				ENShopkeeps:RandomiseShopkeepVarient(npc, sprite, secret, special, rarityVariants)
			else
				sprite:Load(shopkeepData[3], true)
				sprite:Play(shopkeepData[4], true)
			end
		else
			sprite:Load(shopkeepData[1], true)
			sprite:Play(shopkeepData[2], true)
		end
	end
end

ENShopkeeps:AddCallback( ModCallbacks.MC_NPC_UPDATE, ENShopkeeps.ShopkeeperUpdate, 17);
