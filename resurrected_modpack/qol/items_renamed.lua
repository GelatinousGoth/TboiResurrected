local TR_Manager = require("resurrected_modpack.manager")

local ModName = "Items Renamed"
local mod = TR_Manager:RegisterMod(ModName, 1)
local LockCallbackRecord = false

local itemConfig = Isaac.GetItemConfig()

local items
local trinkets
local cards
local pills

function mod:InitItemsRenamed()
    -- {itemId, 'name', 'desc'}
    items = {
        {CollectibleType.COLLECTIBLE_ISAACS_HEART, "Veyeral Heart", "Void Rains Upon It"},
        {CollectibleType.COLLECTIBLE_PYRO, "Arson", "99 Bombs"},
        {CollectibleType.COLLECTIBLE_HOT_BOMBS, "Flare Bombs", "Incendiary Blast +5 Bombs"},
        {CollectibleType.COLLECTIBLE_ALMOND_MILK, "Almond Water", "Backroom Beverage"},
        {CollectibleType.COLLECTIBLE_PSY_FLY, "Grey Matter", "Cerebral Discharge"},
		{CollectibleType.COLLECTIBLE_SMALL_ROCK, "Small Rock", "Dmg Up? I can't remember"},
		{CollectibleType.COLLECTIBLE_BRITTLE_BONES, "Vitamin Deficiency", "Brittle Bones..."},
    }

    if FiendFolio then
        local ffItems = {
            {FiendFolio.ITEM.COLLECTIBLE.CHIRUMIRU, "Blue Milk", "HP + DMG Up, Perfect Freeze"},
            {FiendFolio.ITEM.COLLECTIBLE.COOL_SUNGLASSES, "Cool Shades", "Gold Rush"},
            {FiendFolio.ITEM.COLLECTIBLE.GLIZZY, "SPAM!", "Hunger Down"},
            {FiendFolio.ITEM.COLLECTIBLE.SMASH_TROPHY, "Fighter's Trophy", "It's The Winner!"},
            {FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN, "Spherical Dice", "-0.1"},
            {FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH, "Packed Lunch", "HP Up + Energy Up!"},
            {FiendFolio.ITEM.COLLECTIBLE.GRIDDLED_CORN, "Hellhound Kibble", "DMG Up + It's all burnt"},
			{FiendFolio.ITEM.COLLECTIBLE.RANDY_THE_SNAIL, "Immortal Snail", "Unstoppable force"},
			{FiendFolio.ITEM.COLLECTIBLE.GREG_THE_EGG, "Suprise Egg", "A Hutts hatching"},
			{FiendFolio.ITEM.COLLECTIBLE.SMALL_WOOD, "Wooden Plank", "Ouch, I've got a Splinter"},
			{FiendFolio.ITEM.COLLECTIBLE.SMALL_PIPE, "Loose Pipe", "Congratulations on the Pipe!"},
        }
        for _, itemInfo in ipairs(ffItems) do
            table.insert(items, itemInfo)
        end
    end

    trinkets = {
        {TrinketType.TRINKET_NOSE_GOBLIN, "Booger", "Nose Picker"},
		{TrinketType.TRINKET_MOMS_PEARL, "Clam Pearl", "It Emanates Purity"},
		{TrinketType.TRINKET_MYSTERIOUS_PAPER, "Blank Paper", "???"},
		{TrinketType.TRINKET_BROKEN_ANKH, "Shattered Ankh", "Eternal Life?"},
		{TrinketType.TRINKET_BROKEN_PADLOCK, "Faulty Padlock", "Bombs Are Key"},
    }

    if FiendFolio then
        local ffTrinkets = {
            {FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY, "Overcharged Battery", "Potentially Dangerous"},
            {FiendFolio.ITEM.TRINKET.SWALLOWED_M90, "Replica Gun", "Keep Away From Children"},
        }
        for _, trinketInfo in ipairs(ffTrinkets) do
            table.insert(trinkets, trinketInfo)
        end
    end

    -- Cards

    cards = {
        {Card.CARD_QUEEN_OF_HEARTS, "Business Card", "The Pink Vice"},
		{Card.CARD_HUGE_GROWTH, "Vast Growth", "Become Immense!"},
    }

    if FiendFolio then
        local ffCards = {
		    {FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN, "Glass Spherical Dice", "-0.1"},
		    {FiendFolio.ITEM.CARD.HORSE_PUSHPOP, "Glue Stick", "Sticky Situation"},
			{FiendFolio.ITEM.CARD.CARDJITSU_SOCCER, "Sports Card", "SOCCER"},
			{FiendFolio.ITEM.CARD.KING_OF_CLUBS, "Argine", "Queen Regina"},
			{FiendFolio.ITEM.CARD.KING_OF_DIAMONDS, "Gilded Card", "Mint Condition Foil"},
			{FiendFolio.ITEM.CARD.GROTTO_BEAST, "Flooped Creature", "Card Wars!"},
			{FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS, "Jack Of All Trades", "Master Of None"},
        }

        for _, cardInfo in ipairs(ffCards) do
            table.insert(cards, cardInfo)
        end
    end

    for _, cardInfo in ipairs(cards) do
        local cardConfig = itemConfig:GetCard(cardInfo[1])
        cardConfig.Name = cardInfo[2]
        cardConfig.Description = cardInfo[3]
    end

    -- Pills

    pills = {
        {PillEffect.PILLEFFECT_LARGER, "Eat Me!", "One Makes You Larger"},
		{PillEffect.PILLEFFECT_SMALLER, "Drink Me!", "One Makes You Small"},
    }

    if FiendFolio then
        local ffPills = {

        }

        for _, pillInfo in ipairs(ffPills) do
            table.insert(pills, pillInfo)
        end
    end

    for _, pillInfo in ipairs(pills) do
        local pillConfig = itemConfig:GetPillEffect(pillInfo[1])
        pillConfig.Name = pillInfo[2]
    end

    local game = Game()
    if EID then
        -- Adds trinkets defined in trinkets
        for _, trinket in ipairs(trinkets) do
            local EIDdescription = EID:getDescriptionObj(5, 350, trinket[1]).Description
            EID:addTrinket(trinket[1], EIDdescription, trinket[2], "en_us")
        end

        -- Adds items defined in items
        for _, item in ipairs(items) do
            local EIDdescription = EID:getDescriptionObj(5, 100, item[1]).Description
            EID:addCollectible(item[1], EIDdescription, item[2], "en_us")
        end
    end

    if Encyclopedia then
        -- Adds trinkets defined in trinkets
        for _,trinket in ipairs(trinkets) do
            Encyclopedia.UpdateTrinket(trinket[1], {
                Name = trinket[2],
                Description = trinket[3],
            })
        end

        -- Adds items defined in items
        for _, item in ipairs(items) do
            Encyclopedia.UpdateItem(item[1], {
                Name = item[2],
                Description = item[3],
            })
        end
    end

    -- Handle displaying trinket names

    if #trinkets ~= 0 then
        local t_queueLastFrame
        local t_queueNow
        local function DisplayNewTrinketInfo(_, player)
            t_queueNow = player.QueuedItem.Item
            if (t_queueNow ~= nil) then
                for _, trinket in ipairs(trinkets) do
                    if (t_queueNow.ID == trinket[1] and t_queueNow:IsTrinket() and t_queueLastFrame == nil) then
                        game:GetHUD():ShowItemText(trinket[2], trinket[3])
                    end
                end
            end
            t_queueLastFrame = t_queueNow
        end
        mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DisplayNewTrinketInfo, nil, ModName, LockCallbackRecord)
    end

    -- Handle displaying item names

    if #items ~= 0 then
        local i_queueLastFrame
        local i_queueNow
        local function DisplayNewCollectibleInfo(_, player)
            i_queueNow = player.QueuedItem.Item
            if (i_queueNow ~= nil) then
                for _, item in ipairs(items) do
                    if (i_queueNow.ID == item[1] and i_queueNow:IsCollectible() and i_queueLastFrame == nil) then
                        game:GetHUD():ShowItemText(item[2], item[3])
                    end
                end
            end
            i_queueLastFrame = i_queueNow
        end
        mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DisplayNewCollectibleInfo, nil, ModName, LockCallbackRecord)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.InitItemsRenamed)