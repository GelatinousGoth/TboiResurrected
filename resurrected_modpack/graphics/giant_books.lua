local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("More Giantbook Animations", 1)

local COLLECTIBLE_TO_GIANTBOOK = {
    [CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = Isaac.GetGiantBookIdByName("How to Jump"),
    [CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS] = Isaac.GetGiantBookIdByName("Book of Secrets"),
    [CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = Isaac.GetGiantBookIdByName("Book of Sins"),
    [CollectibleType.COLLECTIBLE_TELEPATHY_BOOK] = Isaac.GetGiantBookIdByName("Telepathy"),
    [CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = Isaac.GetGiantBookIdByName("Book of Shadows"),
    [CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = Isaac.GetGiantBookIdByName("Book of Dead"),
    [CollectibleType.COLLECTIBLE_LEMEGETON] = Isaac.GetGiantBookIdByName("Lemegeton"),
}

local tracker = {}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function (_, id, _, player, flags)
    if not COLLECTIBLE_TO_GIANTBOOK[id]
    or flags & UseFlag.USE_NOHUD ~= 0
    or tracker[id] then return end
    tracker[id] = true
    ItemOverlay.Show(COLLECTIBLE_TO_GIANTBOOK[id], nil, player)
    SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    tracker = {}
end)
