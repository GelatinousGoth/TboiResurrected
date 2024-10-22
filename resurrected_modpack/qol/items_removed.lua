local TR_Manager = require("resurrected_modpack.manager")

local ModName = "Items Removed"
local mod = TR_Manager:RegisterMod(ModName, 1)

local CardsIWantToBlock = {}
local PillsIWantToBlock = {
[34] = 38
}


function mod:BlockCard(RNG, Card, IncludePlayingCards, IncludeRunes, OnlyRunes)
    if CardsIWantToBlock[Card] then
        return CardsIWantToBlock[Card]
    end
end

function mod:BlockPill(SelectedPillEffect, PillColor)
    if PillsIWantToBlock[SelectedPillEffect] then
        return PillsIWantToBlock[SelectedPillEffect]
    end
end

mod:AddCallback(ModCallbacks.MC_GET_CARD, mod.BlockCard)
mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, mod.BlockPill)

local initialized = false

function mod:InitItemsRemoved()
if initialized then
return
end

initialized = true

if not FiendFolio then
goto END_OF_FF
end

CardsIWantToBlock[FiendFolio.ITEM.CARD.BRICK_SEPERATOR] = FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS
CardsIWantToBlock[FiendFolio.ITEM.CARD.TOP_HAT] = 43
CardsIWantToBlock[FiendFolio.ITEM.CARD.CARDJITSU_AC_3000] = 79
CardsIWantToBlock[FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS] = 48
CardsIWantToBlock[FiendFolio.ITEM.CARD.JACK_OF_CLUBS] = 80
CardsIWantToBlock[FiendFolio.ITEM.CARD.JACK_OF_SPADES] = 45
CardsIWantToBlock[FiendFolio.ITEM.CARD.JACK_OF_HEARTS] = 47
CardsIWantToBlock[FiendFolio.ITEM.CARD.QUEEN_OF_DIAMONDS] = FiendFolio.ITEM.CARD.SKIP_CARD
CardsIWantToBlock[FiendFolio.ITEM.CARD.QUEEN_OF_CLUBS] = FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS
CardsIWantToBlock[FiendFolio.ITEM.CARD.QUEEN_OF_SPADES] = 46
CardsIWantToBlock[FiendFolio.ITEM.CARD.KING_OF_SPADES] = 31
CardsIWantToBlock[FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS] = 50
CardsIWantToBlock[FiendFolio.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS] = 51
CardsIWantToBlock[FiendFolio.ITEM.CARD.PLAGUE_OF_DECAY] = FiendFolio.ITEM.CARD.POT_OF_GREED
CardsIWantToBlock[FiendFolio.ITEM.CARD.DEFUSE] = 44
CardsIWantToBlock[FiendFolio.ITEM.CARD.BOSS_DISC] = FiendFolio.ITEM.CARD.TREASURE_DISC
CardsIWantToBlock[FiendFolio.ITEM.CARD.DEVIL_DISC] = FiendFolio.ITEM.CARD.SHOP_DISC
CardsIWantToBlock[FiendFolio.ITEM.CARD.ANGEL_DISC] = FiendFolio.ITEM.CARD.SECRET_DISC
CardsIWantToBlock[FiendFolio.ITEM.CARD.PLANETARIUM_DISC] = FiendFolio.ITEM.CARD.BROKEN_DISC
CardsIWantToBlock[FiendFolio.ITEM.CARD.CHRISTMAS_CRACKER] = FiendFolio.ITEM.CARD.GIFT_CARD
CardsIWantToBlock[FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS] = FiendFolio.ITEM.CARD.MISPRINTED_JOKER
CardsIWantToBlock[FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS] = FiendFolio.ITEM.CARD.CALLING_CARD
CardsIWantToBlock[FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS] = FiendFolio.ITEM.CARD.IMPLOSION

PillsIWantToBlock[FiendFolio.ITEM.PILL.SPIDER_UNBOXING] = 35

::END_OF_FF::
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.InitItemsRemoved)