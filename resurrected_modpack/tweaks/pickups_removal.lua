local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Pickups Removal", 1)

local itemConfig = Isaac.GetItemConfig()

local CardsIWantToBlock = {}
local PillsIWantToBlock = {
	[PillEffect.PILLEFFECT_INFESTED_EXCLAMATION] = true
}

local availabilityConditions = {}

local function NotAvailable()
	return false
end

local function TableAppend(tbl, append)
	for _, value in ipairs(append) do
		table.insert(tbl, value)
	end
end

function mod:BlockPill(SelectedPillEffect, PillColor)
	if PillsIWantToBlock[SelectedPillEffect] then
		return PillsIWantToBlock[SelectedPillEffect]
	end
end

mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, mod.BlockPill)

local initialized = false

local function InitRemovedPickupsList()
	local blockedCards_FF = {}

	if not FiendFolio then
		goto END_OF_FF
	end

	blockedCards_FF = {
		FiendFolio.ITEM.CARD.BRICK_SEPERATOR,
		FiendFolio.ITEM.CARD.TOP_HAT,
		FiendFolio.ITEM.CARD.CARDJITSU_AC_3000,
		FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS,
		FiendFolio.ITEM.CARD.JACK_OF_CLUBS,
		FiendFolio.ITEM.CARD.JACK_OF_SPADES,
		FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS,
		FiendFolio.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS,
		FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS,
		FiendFolio.ITEM.CARD.PLAGUE_OF_DECAY,
		FiendFolio.ITEM.CARD.DEFUSE,
		FiendFolio.ITEM.CARD.BOSS_DISC,
		FiendFolio.ITEM.CARD.DEVIL_DISC,
		FiendFolio.ITEM.CARD.ANGEL_DISC,
		FiendFolio.ITEM.CARD.PLANETARIUM_DISC,
		FiendFolio.ITEM.CARD.CHRISTMAS_CRACKER,
		FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS,
		FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS,
		FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS
	}

	PillsIWantToBlock[FiendFolio.ITEM.PILL.SPIDER_UNBOXING] = {Replace = PillEffect.PILLEFFECT_INFESTED_QUESTION}

	::END_OF_FF::

	TableAppend(CardsIWantToBlock, blockedCards_FF)
end

local function BlockCards()
	for _, value in ipairs(CardsIWantToBlock) do
		local cardConfig = itemConfig:GetCard(value)
		availabilityConditions[value] = cardConfig:GetAvailabilityCondition()
		cardConfig:SetAvailabilityCondition(NotAvailable)
	end
end

local function RestoreCards()
	for _, value in ipairs(CardsIWantToBlock) do
		local cardConfig = itemConfig:GetCard(value)
		if (cardConfig:GetAvailabilityCondition() == NotAvailable) and (availabilityConditions[value]) then
			cardConfig:SetAvailabilityCondition(availabilityConditions[value])
		end
	end
end

function mod:Init()
	InitRemovedPickupsList()
	BlockCards()
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.Init)

function mod.post_disable_mod()
	RestoreCards()
end

function mod.post_enable_mod()
	BlockCards()
end