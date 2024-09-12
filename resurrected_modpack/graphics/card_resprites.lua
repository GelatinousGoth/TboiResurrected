local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Card Resprite"
mod.LockCallbackRecord = true

local itemConfig = Isaac.GetItemConfig()

local BusinessCardBack = Isaac.GetEntitySubTypeByName("BusinessCardBack")
local SportsCardBack = Isaac.GetEntitySubTypeByName("SportsCardBack")
local FloopedCreatureCardBack = Isaac.GetEntitySubTypeByName("FloopedCreatureCardBack")
local GoldCardBack = Isaac.GetEntitySubTypeByName("GoldCardBack")

---@type table<integer, string>
local cardFronts = {}
---@type table<integer, integer>
local cardBacks = {}

local animationNames = {} --Internal Use Only, do not edit

function mod:InitCardResprites()
    cardBacks[Card.CARD_QUEEN_OF_HEARTS] = BusinessCardBack

    if FiendFolio then
cardBacks[FiendFolio.ITEM.CARD.CARDJITSU_SOCCER] = SportsCardBack
cardBacks[FiendFolio.ITEM.CARD.GROTTO_BEAST] = FloopedCreatureCardBack
cardBacks[FiendFolio.ITEM.CARD.KING_OF_DIAMONDS] = GoldCardBack

    cardFronts[FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.THREE_OF_HEARTS] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.THREE_OF_SPADES] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.THREE_OF_DIAMONDS] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.THREE_OF_CLUBS] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.MISPRINTED_JOKER] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.CARDJITSU_SOCCER] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.HORSE_PUSHPOP] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.KING_OF_DIAMONDS] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.GROTTO_BEAST] = "gfx/alt_fiend_folio_cards.png"
cardFronts[FiendFolio.ITEM.CARD.KING_OF_CLUBS] = "gfx/alt_fiend_folio_cards.png"
end

    for card, cardBack in pairs(cardBacks) do
        itemConfig:GetCard(card).PickupSubtype = cardBack
    end

    for card, cardFront in pairs(cardFronts) do
local cardConfig = itemConfig:GetCard(card)
        cardConfig.ModdedCardFront:ReplaceSpritesheet(0, cardFront, true)
animationNames[cardConfig.HudAnim] = card
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.InitCardResprites)

function mod:UpdateHeldSprite(player)
local heldSprite = player:GetHeldSprite()
local overlayAnimationData = heldSprite:GetOverlayAnimationData()

if overlayAnimationData then
local heldCard = animationNames[overlayAnimationData:GetName()]
if heldCard then -- Unfortunately the held card is not a moving animation hence there is no way to check if the animation is on it's first frame or not
heldSprite:ReplaceSpritesheet(0, cardFronts[heldCard], true)
end
end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.UpdateHeldSprite)

mod.LockCallbackRecord = false