local TR_Manager = require("resurrected_modpack.manager")
VoidedItems = TR_Manager:RegisterMod("Voided Items", 1)

local json = require("json")
local void = CollectibleType.COLLECTIBLE_VOID
local itemConfig = Isaac.GetItemConfig()
VoidedItems.itemSprites = {}
VoidedItems.onetime_use = {}
VoidedItems.PlayerTypesWithOffset = {
  [PlayerType.PLAYER_ISAAC_B] = true,
  [PlayerType.PLAYER_BLUEBABY_B] = true
}

--Dear mod developer!
--Please use this function when adding a single-use active item to your mod.
function VoidedItems:AddOnetimeUse(item)
    VoidedItems.onetime_use[item] = true
end
--Example: VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_CONTRABAND)

VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_BLUE_BOX)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_DIPLOPIA)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_PLAN_C)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_MAMA_MEGA)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_EDENS_SOUL)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_MYSTERY_GIFT)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_DAMOCLES)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_ALABASTER_BOX)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_GENESIS)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE)
VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_R_KEY)

VoidedItems:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_)
if ARACHNAMOD then
    VoidedItems:AddOnetimeUse(Isaac.GetItemIdByName("Best Bud Ball"))
    VoidedItems:AddOnetimeUse(Isaac.GetItemIdByName("Testament"))
end
if EclipsedMod then
    VoidedItems:AddOnetimeUse(EclipsedMod.enums.Items.FloppyDisk)
    VoidedItems:AddOnetimeUse(EclipsedMod.enums.Items.VHSCassette)
end
if Epiphany then
    VoidedItems.PlayerTypesWithOffset[Epiphany.PlayerType.ISAAC] = true
    VoidedItems:AddOnetimeUse(Epiphany.Item.FIRST_PAGE.ID)
    VoidedItems:AddOnetimeUse(Epiphany.Item.SURPRISE_BOX.ID)
end
if FiendFolio then
    VoidedItems:AddOnetimeUse(CollectibleType.COLLECTIBLE_CONTRABAND)
    VoidedItems:AddOnetimeUse(FiendFolio.ITEM.COLLECTIBLE.WRONG_WARP)
    VoidedItems:AddOnetimeUse(FiendFolio.ITEM.COLLECTIBLE.RAT_POISON)
    VoidedItems:AddOnetimeUse(FiendFolio.ITEM.COLLECTIBLE.ERRORS_CRAZY_SLOTS)
end
if LibraryExpanded then
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.CERTIFICATE)
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.BLANK_BOOK.ID0)
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.BLANK_BOOK.ID1)
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.BLANK_BOOK.ID2)
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.BLANK_BOOK.ID3)
    VoidedItems:AddOnetimeUse(LibraryExpanded.Item.BLANK_BOOK.ID4)
end
if Retribution then
    VoidedItems:AddOnetimeUse(Retribution.ITEMS.SCULPTING_CLAY)
    VoidedItems:AddOnetimeUse(Retribution.ITEMS.PUMPKIN_MASK)
    VoidedItems:AddOnetimeUse(Retribution.ITEMS.SHATTERED_DICE)
    VoidedItems:AddOnetimeUse(Retribution.ITEMS.BOTTLED_FAIRY)
    VoidedItems:AddOnetimeUse(Retribution.ITEMS.NEVERLASTING_PILL)
end
if RepentancePlusMod then
    VoidedItems:AddOnetimeUse(RepentancePlusMod.CustomCollectibles.BIRTH_CERTIFICATE)
end
if Sheriff then VoidedItems:AddOnetimeUse(Sheriff.Items.MOAB.ID) end
if SacredDreams then
    VoidedItems.PlayerTypesWithOffset[SDMod.PlayerType.PLAYER_GUARD] = true
end
end)

----I was forced to add a scheduler. Fuck you!
DelayedFuncs = {}
local function RunUpdates(tab)
  	for i = #tab, 1, -1 do
    		local f = tab[i]
    		f.Delay = f.Delay - 1
    		if f.Delay <= 0 then
      			f.Func()
      			table.remove(tab, i)
    		end
  	end
end
function VoidedItems:ScheduleForUpdate(foo, delay, callback, noCancelOnNewRoom)
  	callback = callback or ModCallbacks.MC_POST_UPDATE
  	if not DelayedFuncs[callback] then
    		DelayedFuncs[callback] = {}
    		VoidedItems:AddCallback(callback, function()
    		    RunUpdates(DelayedFuncs[callback])
    		end)
  	end
  	table.insert(DelayedFuncs[callback], { Func = foo, Delay = delay or 0, NoCancel = noCancelOnNewRoom })
end
VoidedItems:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, function()
  	for callback, tab in pairs(DelayedFuncs) do
    		for i = #tab, 1, -1 do
      			local f = tab[i]
      			if not f.NoCancel then
                table.remove(tab, i)
      			end
    		end
  	end
end)

-- Item tracking
function VoidedItems:TryAddToVoidedItems(player, item)
    local itemConfigItem = itemConfig:GetCollectible(item)
    if itemConfigItem and itemConfigItem.Type == ItemType.ITEM_ACTIVE then
        local d = player:GetData()
        d.VoidedItems = d.VoidedItems or {}
        table.insert(d.VoidedItems, item)
    end
end

local abyss = false
local TryToVoid = {}
VoidedItems:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, _, player, useflags)
    if useflags & UseFlag.USE_VOID > 0 then
        if VoidedItems.onetime_use[item] then
            local d = player:GetData()
            local items = d.VoidedItems
            if player:HasCollectible(void) and items then
                for key, vitem in ipairs(items) do
                    if vitem==item then table.remove(d.VoidedItems, key) end
                end
            end
        end
        if item==706 then abyss = true end
        -- What's problem with you, Abyss?? Why you just can't be like every another item, destroying pedestals immediately? "Noooo i will wait 3 frames and there will be NO indication that those items are doomed and Void can't suck them"
    end
end)

VoidedItems:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, _, _, player)
    if player.QueuedItem.Item then
        VoidedItems:TryAddToVoidedItems(player, player.QueuedItem.Item.ID)
    end
    
    local options = {}
    for _, pickup in pairs(Isaac.FindByType(5, PickupVariant.PICKUP_COLLECTIBLE)) do
        pickup = pickup:ToPickup()
        if not pickup:IsShopItem() then
            if not options[pickup.OptionsPickupIndex] then
                table.insert(TryToVoid, EntityRef(pickup))
            end
            if pickup.OptionsPickupIndex ~= 0 then
                options[pickup.OptionsPickupIndex] = true
            end
        end
    end
end, void)

VoidedItems:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player)
    if abyss then abyss = false
    else
        for _, pickup in pairs(TryToVoid) do
            pickup = pickup.Entity
            if pickup:Exists() then VoidedItems:TryAddToVoidedItems(player, pickup.SubType) end
        end
        TryToVoid = {}
    end
end, void)

-- Saving
-- I absolutely hate this shit, by the way.
VoidedItems:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, hasSave)
    if not hasSave then
        VoidedItems.itemSprites = {}
    elseif VoidedItems:HasData() then
        local data = json.decode(Isaac.LoadModData(VoidedItems))
        for i=0, 4 do
            local p = Isaac.GetPlayer(i)
            p:GetData().VoidedItems = data[i+1]
        end
    end
end)

VoidedItems:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_)
    VoidedItems.SaveData(VoidedItems, json.encode(
    {Isaac.GetPlayer(0):GetData().VoidedItems or {},
    Isaac.GetPlayer(1):GetData().VoidedItems or {},
    Isaac.GetPlayer(2):GetData().VoidedItems or {},
    Isaac.GetPlayer(3):GetData().VoidedItems or {},
    Isaac.GetPlayer(4):GetData().VoidedItems or {}}))
end)

-- Code below is just some rendering shit. Messy and unreadable. Mostly stolen from Sanio, the legend behind Hello Kitty and Connor, UFC legend.
local function GetScreenBottomRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 16, -hudOffset * 6)
	return Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + offset
end

local function GetScreenBottomLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 22, -hudOffset * 6)
	return Vector(0, Isaac.GetScreenHeight()) + offset
end

local function GetScreenTopRight()
	local hudOffset = Options.HUDOffset
	local offset = Vector(-hudOffset * 24, hudOffset * 12)
	return Vector(Isaac.GetScreenWidth(), 0) + offset
end

local function GetScreenTopLeft()
	local hudOffset = Options.HUDOffset
	local offset = Vector(hudOffset * 20, hudOffset * 12)
	return offset
end

local function GetAllMainPlayers()
	local mainPlayers = {}
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		-- Make sure this player isn't the non-main twin, or an item-related spawned-in player like strawman.
		if player and player:Exists() and GetPtrHash(player:GetMainTwin()) == GetPtrHash(player)
				and (not player.Parent or player.Parent.Type ~= EntityType.ENTITY_PLAYER) then
			table.insert(mainPlayers, player)
		end
	end
	return mainPlayers
end

local IndexedPlayers = {
	[1] = {PlayerPtr = nil,
		ScreenPos = function(player, slot)
			if player:GetPlayerType() ~= PlayerType.PLAYER_JACOB and (slot == ActiveSlot.SLOT_POCKET or slot == ActiveSlot.SLOT_POCKET2) then
				return GetScreenBottomRight()
			end
			if VoidedItems.PlayerTypesWithOffset[player:GetPlayerType()] then
			  return GetScreenTopLeft()+Vector(0,24)
			end
			return GetScreenTopLeft()
		end,
		Offset = Vector(4, 0),
		PocketOffset = Vector(-36, -30),
		YMultiplier = 1
	},
	[2] = {PlayerPtr = nil,
		ScreenPos = function() return GetScreenTopRight() end,
		Offset = Vector(-155, 0),
		YMultiplier = 1
	},
	[3] = {PlayerPtr = nil,
		ScreenPos = function() return GetScreenBottomLeft() end,
		Offset = Vector(14, -39),
		YMultiplier = -1
	},
	[4] = {PlayerPtr = nil,
		ScreenPos = function() return GetScreenBottomRight() end,
		Offset = Vector(-163, -39),
		YMultiplier = -1
	},
	-- (Player 1's Esau)
	[5] = {PlayerPtr = nil,
		ScreenPos = function() return GetScreenBottomRight() end,
		Offset = Vector(-22, -16),
		YMultiplier = -1
	},
}

local function GetIndexedPlayer(i)
	if not IndexedPlayers[i] then return end
	local player = IndexedPlayers[i].PlayerPtr and IndexedPlayers[i].PlayerPtr.Ref and IndexedPlayers[i].PlayerPtr.Ref:ToPlayer()
	if not player or not player:Exists() then
		IndexedPlayers[i].PlayerPtr = nil
		return nil
	end
	return player
end

local function GetChargebarOffset(player, slot)
	if GetPtrHash(player:GetMainTwin()) ~= GetPtrHash(player) then
		return (slot == ActiveSlot.SLOT_SECONDARY) and Vector(38, 17) or Vector(0, 17)
	end
	return (slot == ActiveSlot.SLOT_SECONDARY) and Vector(-2, 17) or Vector(34, 17)
end

local function AddActivePlayers(i, player)

	IndexedPlayers[i].PlayerPtr = EntityPtr(player)
	
	if i == 1 and player:GetOtherTwin()
			and player:GetOtherTwin():GetPlayerType() == PlayerType.PLAYER_ESAU
			and not GetIndexedPlayer(5) then
		IndexedPlayers[5].PlayerPtr = EntityPtr(player:GetOtherTwin())
	end
end

-- If the number of players changes, or a player "transforms" into another (Bazarus/EsauJr) then
-- we should remap the player's hud slots just in case.
local function ShouldRefreshPlayers(players)
	if #players ~= numHUDPlayers or (Game():GetFrameCount() == 0 and GetIndexedPlayer(1)) then
		return true
	end

	for i=1, 5 do
		local actualPlayer = players[i]
		local indexedPlayer = GetIndexedPlayer(i)

		-- Checking for stuff like Bazarus or Esau Jr turning a player into another, seperate player.
		if actualPlayer and indexedPlayer and actualPlayer.InitSeed ~= indexedPlayer.InitSeed then
			return true
		end
	end
end

function VoidedItems:UpdatePlayers()
	local players = GetAllMainPlayers()

	if ShouldRefreshPlayers(players) then
		numHUDPlayers = #players
		for i = 1, 5 do
			IndexedPlayers[i].PlayerPtr = nil
		end
	end

	for i = 1, 4 do
		if players[i] and not GetIndexedPlayer(i) then
			AddActivePlayers(i, players[i])
		end
	end
end

local function TryGenerateSprite(item)
    if not VoidedItems.itemSprites[item] then
        local itemConfigItem = itemConfig:GetCollectible(item)
        local itemSprite = Sprite()
        itemSprite:Load("voided_item.anm2", false)
        itemSprite:Play("Idle")
        local gfxname = itemConfigItem.GfxFileName
        if gfxname=="" then gfxname="gfx/items/collectibles/collectibles_721_tmtrainer.png" end
        itemSprite:ReplaceSpritesheet(0, gfxname)
        itemSprite:ReplaceSpritesheet(1, gfxname)
        itemSprite:LoadGraphics()
        itemSprite.Color = Color(1,1,1,0.6)
        itemSprite.Scale = Vector(0.5,0.5)
        VoidedItems.itemSprites[item] = itemSprite
    end
end

-- 5Head
-- I don't give a shit at this point ok
local DIV_VOID_ID = Isaac.GetItemIdByName('[DIVIDED VOID]Tech ID')+1
local divoid = false
if DIV_VOID_ID>0 then
    void = DIV_VOID_ID
    divoid = true
    function VoidedItems:RenderItems()
        for i = 1, #IndexedPlayers do
        		local playerInfo = IndexedPlayers[i]
        		local player = GetIndexedPlayer(i)
            if player then
            local d = player:GetData()
            local items
            if d.DIV_VOID_data and d.DIV_VOID_data.VoidedItems then items = d.DIV_VOID_data.VoidedItems end
            if player:HasCollectible(void) then
                local renderpos = (IndexedPlayers[i].ScreenPos(player, 0) + IndexedPlayers[i].Offset)
                local xm = i==5 and -1 or 1
                local ym = IndexedPlayers[i].YMultiplier
                local xoffs = 0
                local yoffs = 0
                for item, _ in pairs(items) do
                    item = tonumber(item)
                    TryGenerateSprite(item)
                    local sprite = VoidedItems.itemSprites[item]
                    sprite:Render(renderpos+Vector((34+xoffs)*xm, (33+yoffs)*ym))
                    xoffs = xoffs + 12
                    if xoffs>12*6 then
                        xoffs = 0
                        yoffs = yoffs + 12
                    end
                end
            end
            end
        end
    end
else
    function VoidedItems:RenderItems()
        for i = 1, #IndexedPlayers do
        		local playerInfo = IndexedPlayers[i]
        		local player = GetIndexedPlayer(i)
            if player then
            local items = REPENTOGON and player:GetVoidedCollectiblesList() or player:GetData().VoidedItems
            if player:HasCollectible(void) and items then
                local renderpos = (IndexedPlayers[i].ScreenPos(player, 0) + IndexedPlayers[i].Offset)
                local xm = i==5 and -1 or 1
                local ym = IndexedPlayers[i].YMultiplier
                local xoffs = 0
                local yoffs = 0
                for key, item in ipairs(items) do
                    TryGenerateSprite(item)
                    local sprite = VoidedItems.itemSprites[item]
                    sprite:Render(renderpos+Vector((34+xoffs)*xm, (33+yoffs)*ym))
                    xoffs = xoffs + 12
                    if xoffs>12*6 then
                        xoffs = 0
                        yoffs = yoffs + 12
                    end
                end
            end
            end
        end
    end
end

if REPENTOGON then
    VoidedItems:AddCallback(ModCallbacks.MC_POST_RENDER, function(_) VoidedItems:UpdatePlayers() end)
    VoidedItems:AddCallback(ModCallbacks.MC_HUD_RENDER, function(_) if Game():GetHUD():IsVisible() then VoidedItems:RenderItems() end end)
else include("resurrected_modpack.qol.voided_items.rendering") end

--i hate eid =)
if EID then
    VoidedItems:AddCallback(ModCallbacks.MC_POST_RENDER, function(_)
        local player = Isaac.GetPlayer()
        if player and player:HasCollectible(void) then
            local items = player:GetData().VoidedItems
            if items and #items==0 then items = false end
            --Bruh fuck divided void
            if player:HasCollectible(void) and items then
                EID:addTextPosModifier("Voided Items Menu", Vector(0, 8+math.ceil(#items/7)*12 ))
            end
        else
            EID:removeTextPosModifier("Voided Items Menu")
        end
    end)
end