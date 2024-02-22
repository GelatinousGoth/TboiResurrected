local mod = require("resurrected_modpack.mod_reference")

local ModName = "Items Renamed"
mod.CurrentModName = ModName
local LockCallbackRecord = false

local items
local trinkets

function mod:InitItemsRenamed()
    -- {itemId, 'name', 'desc'}
    items = {
        {CollectibleType.COLLECTIBLE_ISAACS_HEART, "Veyeral Heart", "Void Rains Upon It"},
        {CollectibleType.COLLECTIBLE_PYRO, "Arson", "99 Bombs"},
        {CollectibleType.COLLECTIBLE_HOT_BOMBS, "Hot Bombs", "Incendiary Blast +5 Bombs"},
        {CollectibleType.COLLECTIBLE_ALMOND_MILK, "Almond Water", "Backroom Beverage"},
        {CollectibleType.COLLECTIBLE_PSY_FLY, "Grey Matter", "Cerebral Discharge"},
    }

    if FiendFolio then
        local ffItems = {
            {FiendFolio.ITEM.COLLECTIBLE.CHIRUMIRU, "Blue Milk", "HP + DMG Up, Perfect Freeze"},
            {FiendFolio.ITEM.COLLECTIBLE.COOL_SUNGLASSES, "Cool Shades", "Gold Rush"},
            {FiendFolio.ITEM.COLLECTIBLE.GLIZZY, "SPAM!", "Hunger Down"},
            {FiendFolio.ITEM.COLLECTIBLE.SMASH_TROPHY, "Fighter's Trophy", "It's The Winner!"},
            {FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN, "Spherical Dice", "-0.1"},
            {FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH, "Packed Lunch", "HP Up + Energy Up!"},
            {FiendFolio.ITEM.COLLECTIBLE.GRIDDLED_CORN, "Hellhound Kibble", "DMG Up + It's all burnt"}
        }
        for _, itemInfo in ipairs(ffItems) do
            table.insert(items, itemInfo)
        end
    end

    trinkets = {
        {TrinketType.TRINKET_NOSE_GOBLIN, "Booger", "Nose Picker"}
    }

    if FiendFolio then
        local ffTrinkets = {
            {FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY, "Overcharged Battery", "Potentially Dangerous"},
            {FiendFolio.ITEM.TRINKET.SWALLOWED_M90, "Replica Gun", "Keep away from children"}
        }
        for _, trinketInfo in ipairs(ffTrinkets) do
            table.insert(trinkets, trinketInfo)
        end
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