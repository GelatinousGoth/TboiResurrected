GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER, {Body = "gfx_gello_costumes/Body/wirehanger.png"}, {Body = 1})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_COMMON_COLD, {Body = "gfx_gello_costumes/Body/commoncold.png"}, {Body = 1})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_SPOON_BENDER, {Body = "gfx_gello_costumes/Body/spoonbender.png", Extra1 = "gfx_gello_costumes/Extra1/spoonbender_eye.png"}, {Body = 1, Extra1 = 1})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID, {Glow = "gfx_gello_costumes/Glow/mysteriousliquid.png"}, {Glow = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_BALL_OF_TAR, {Body = "gfx_gello_costumes/Body/balloftar.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_MIDAS_TOUCH, {Body = "gfx_gello_costumes/Body/midastouch.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_PACT, {Body = "gfx_gello_costumes/Body/thepact.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_TERRA, {Body = "gfx_gello_costumes/Body/terra.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_TECH_X, {Body = "gfx/familiar/umbilical_baby/techx.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_STEVEN, {Body = "gfx_gello_costumes/Body/steven.png"}, {Body = 50})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_SMB_SUPER_FAN, {Body = "gfx_gello_costumes/Body/smbsuperfan.png", Extra2 = "gfx_gello_costumes/Extra2/smbsuperfan_ears.png"}, {Body = 50, Extra2 = 1})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE, {Body = "gfx_gello_costumes/Body/compoundfracture.png"}, {Body = 100})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_ANTI_GRAVITY, {Body = "gfx_gello_costumes/Body/antigravity.png"}, {Body = 100})

---@param player EntityPlayer
GelloCostumes.Rgon:AddCostume(function(player)
    return player:HasPlayerForm(PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES) -- Lord of The Flies
end, {Body = "gfx_gello_costumes/Body/lordoftheflies.png"}, {Body = 100})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_TECHNOLOGY, {Body = "gfx_gello_costumes/Body/technology.png", Extra2 = "gfx_gello_costumes/Extra2/technology_ant.png"}, {Body = 100, Extra2 = 1})

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_BRIMSTONE, {Body = "gfx/familiar/umbilical_baby/brimstone.png", Extra2 = "gfx/familiar/umbilical_baby/brimstone_horns.png"}, {Body = 100, Extra2 = 1})

---@param player EntityPlayer
GelloCostumes.Rgon:AddCostume(function(player)
    return player:HasPlayerForm(PlayerForm.PLAYERFORM_GUPPY) -- Guppy
end, {Body = "gfx_gello_costumes/Body/guppy.png", Extra2 = "gfx_gello_costumes/Extra2/guppy_ears.png"}, {Body = 100, Extra2 = 1})

---@param player EntityPlayer
GelloCostumes.Rgon:AddCostume(function(player)
    return player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) -- Conjoined
end, {Extra2 = "gfx_gello_costumes/Extra2/conjoined.png", Body = "gfx_gello_costumes/Body/conjoined.png"}, {Extra2 = 100, Body = 100})


local usedDelirious = false
GelloCostumes:AddCallback(ModCallbacks.MC_USE_ITEM, function() usedDelirious = true end, CollectibleType.COLLECTIBLE_DELIRIOUS)
GelloCostumes:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function() usedDelirious = false end)

GelloCostumes.Rgon:AddCostume(function()
    return usedDelirious -- Delirious
end, {Body = "gfx_gello_costumes/Body/delirious.png"}, {Body = 101})


---@param sprite Sprite
GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_DOGMA, {Body = "gfx_gello_costumes/Body/dogma.png"}, {Body = 101}, function(sprite) sprite:SetRenderFlags(AnimRenderFlags.STATIC) end)

GelloCostumes.Rgon:AddItemCostume(CollectibleType.COLLECTIBLE_DR_FETUS, {Extra2 = "gfx/familiar/umbilical_baby/drfetus.png"}, {Extra2 = 100})