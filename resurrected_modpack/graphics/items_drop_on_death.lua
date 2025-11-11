local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Items Drop On Death", 1)
local game = Game()
local floatingItemsByPlayer = {}
local shouldRender = false
local itemCounter = 0
local itemSprite = Sprite()
itemSprite:Load("gfx/005.100_collectible.anm2", true)

local shadowSprite = Sprite()
shadowSprite:Load("gfx/shadow.anm2", true)
shadowSprite:Play("Idle", true)

local SCATTER_RANGE_MIN = 5
local SCATTER_RANGE_MAX = 9
local SCATTER_RANDOM_FACTOR = 0.5
local INITIAL_VZ_MIN = 10
local INITIAL_VZ_MAX = 12
local GRAVITY = 0.8
local AIR_DRAG = 0.92
local GROUND_DRAG = 0.96
local ITEM_LIFETIME = 300

local function getPlayerCollectibles(player)
    local items = {}
    local itemConfig = Isaac.GetItemConfig()
    for id = 1, 9999 do
        local config = itemConfig:GetCollectible(id)
        if config and config.ID and player:HasCollectible(config.ID) then
            table.insert(items, config.ID)
        end
    end
    return items
end

local function createFloatingItem(args)
    itemCounter = itemCounter + 1
    local uid = itemCounter
    local roomSeed = game:GetLevel():GetCurrentRoomDesc().SpawnSeed or 0
    local uniqueOffset = (uid * 97 + (args.id or 0) * 13 + roomSeed) % 360
    return {
        id = args.id or 0,
        pos = args.pos or Vector(0, 0),
        vel = args.vel or Vector(0, 0),
        z = args.z or 0,
        vz = args.vz or 0,
        frame = 0,
        sprite = args.sprite,
        type = args.type or "unknown",
        airDistance = Vector(0, 0),
        landed = false,
        uid = uid,
        uniqueOffset = uniqueOffset
    }
end

function mod:scatterItems(player)
    local id = player.Index
    floatingItemsByPlayer[id] = {}

    -- Collectibles
    local collectibles = getPlayerCollectibles(player)
    for _, cid in ipairs(collectibles) do
        local angle = math.random() * (2 * math.pi)
        local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                          (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
        local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
        local velocity = Vector.FromAngle(math.deg(angle)) * speed
        local config = Isaac.GetItemConfig():GetCollectible(cid)
        local sprite = Sprite()
        if config and config.GfxFileName then
            sprite:Load("gfx/005.100_collectible.anm2", true)
            local replaceIndex = 0
            if string.find(config.GfxFileName, "collectibles") then
                replaceIndex = 1
            end
            local success = pcall(function()
                sprite:ReplaceSpritesheet(replaceIndex, config.GfxFileName)
                sprite:LoadGraphics()
            end)
            if not success or not sprite:IsLoaded() then
                sprite:Load("gfx/005.100_collectible.anm2", true)
            end
        else
            sprite:Load("gfx/005.100_collectible.anm2", true)
        end
        sprite:SetFrame("Idle", 0)
        sprite:Stop()

        table.insert(floatingItemsByPlayer[id], createFloatingItem({
            id = cid,
            pos = player.Position,
            vel = velocity,
            vz = vz,
            sprite = sprite,
            type = "collectible"
        }))
    end

    -- Bombs
    local bombCount = player:GetNumBombs()
    local hasGoldBomb = player:HasGoldenBomb()

    if bombCount > 0 then
        local doubleBombs = 0
        local singleBombs = 0
        if not hasGoldBomb then
            local i = 1
            while i <= bombCount do
                if i < bombCount and math.random() < 0.4 then
                    doubleBombs = doubleBombs + 1
                    i = i + 2
                else
                    singleBombs = singleBombs + 1
                    i = i + 1
                end
            end
        else
            singleBombs = bombCount
        end

        local function spawnBombs(count, anm2, typeName)
            for i = 1, count do
                local angle = math.random() * (2 * math.pi)
                local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                                  (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
                local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
                local velocity = Vector.FromAngle(math.deg(angle)) * speed
                local sprite = Sprite()
                sprite:Load(anm2, true)
                sprite:Play("Idle", true)
                table.insert(floatingItemsByPlayer[id], createFloatingItem({
                    id = 0,
                    pos = player.Position,
                    vel = velocity,
                    vz = vz,
                    sprite = sprite,
                    type = typeName
                }))
            end
        end

        if hasGoldBomb then
            spawnBombs(singleBombs, "gfx/005.043_golden bomb.anm2", "gold_bomb")
        else
            spawnBombs(doubleBombs, "gfx/005.042_double bomb.anm2", "double_bomb")
            spawnBombs(singleBombs, "gfx/004.000_bomb.anm2", "bomb")
        end
    end

    -- Keys
    local keyCount = player:GetNumKeys()
    local hasGoldKey = player:HasGoldenKey()

    if keyCount > 0 then
        local keyrings = 0
        local singleKeys = 0
        if not hasGoldKey then
            local i = 1
            while i <= keyCount do
                if i < keyCount and math.random() < 0.4 then
                    keyrings = keyrings + 1
                    i = i + 2
                else
                    singleKeys = singleKeys + 1
                    i = i + 1
                end
            end
        else
            singleKeys = keyCount
        end

        local function spawnKeys(count, anm2, typeName)
            for i = 1, count do
                local angle = math.random() * (2 * math.pi)
                local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                                  (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
                local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
                local velocity = Vector.FromAngle(math.deg(angle)) * speed
                local sprite = Sprite()
                sprite:Load(anm2, true)
                sprite:Play("Idle", true)
                table.insert(floatingItemsByPlayer[id], createFloatingItem({
                    id = 0,
                    pos = player.Position,
                    vel = velocity,
                    vz = vz,
                    sprite = sprite,
                    type = typeName
                }))
            end
        end

        if hasGoldKey then
            spawnKeys(singleKeys, "gfx/005.032_golden key.anm2", "gold_key")
        else
            spawnKeys(keyrings, "gfx/005.033_keyring.anm2", "keyring")
            spawnKeys(singleKeys, "gfx/005.031_key.anm2", "key")
        end
    end

    -- Coins
    local coinCount = player:GetNumCoins()
    if coinCount > 0 then
        local dimes = math.floor(coinCount / 10)
        local remaining = coinCount % 10
        local nickels = math.floor(remaining / 5)
        local pennies = remaining % 5

        local function spawnCoin(anm2Path, count, typeName)
            for i = 1, count do
                local angle = math.random() * (2 * math.pi)
                local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                                  (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
                local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
                local velocity = Vector.FromAngle(math.deg(angle)) * speed
                local sprite = Sprite()
                sprite:Load(anm2Path, true)
                sprite:Play("Idle", true)
                table.insert(floatingItemsByPlayer[id], createFloatingItem({
                    id = 0,
                    pos = player.Position,
                    vel = velocity,
                    vz = vz,
                    sprite = sprite,
                    type = typeName
                }))
            end
        end

        local convertedNickels = 0
        local keptDimes = 0
        for i = 1, dimes do
            if math.random() < 0.1 then
                convertedNickels = convertedNickels + 2
            else
                keptDimes = keptDimes + 1
            end
        end

        nickels = nickels + convertedNickels
        dimes = keptDimes

        spawnCoin("gfx/005.023_dime.anm2", dimes, "dime")
        spawnCoin("gfx/005.022_nickel.anm2", nickels, "nickel")

        local doublePennies = 0
        local singlePennies = 0
        local i = 1
        while i <= pennies do
            if i < pennies and math.random() < 0.4 then
                doublePennies = doublePennies + 1
                i = i + 2
            else
                singlePennies = singlePennies + 1
                i = i + 1
            end
        end

        spawnCoin("gfx/005.024_double penny.anm2", doublePennies, "double_penny")
        spawnCoin("gfx/005.021_penny.anm2", singlePennies, "penny")
    end

    local cardSpriteById = {
        -- Tarot cards (IDs 1-22)
        [1] = "gfx/005.301_tarot card.anm2",
        [2] = "gfx/005.301_tarot card.anm2",
        [3] = "gfx/005.301_tarot card.anm2",
        [4] = "gfx/005.301_tarot card.anm2",
        [5] = "gfx/005.301_tarot card.anm2",
        [6] = "gfx/005.301_tarot card.anm2",
        [7] = "gfx/005.301_tarot card.anm2",
        [8] = "gfx/005.301_tarot card.anm2",
        [9] = "gfx/005.301_tarot card.anm2",
        [10] = "gfx/005.301_tarot card.anm2",
        [11] = "gfx/005.301_tarot card.anm2",
        [12] = "gfx/005.301_tarot card.anm2",
        [13] = "gfx/005.301_tarot card.anm2",
        [14] = "gfx/005.301_tarot card.anm2",
        [15] = "gfx/005.301_tarot card.anm2",
        [16] = "gfx/005.301_tarot card.anm2",
        [17] = "gfx/005.301_tarot card.anm2",
        [18] = "gfx/005.301_tarot card.anm2",
        [19] = "gfx/005.301_tarot card.anm2",
        [20] = "gfx/005.301_tarot card.anm2",
        [21] = "gfx/005.301_tarot card.anm2",
        [22] = "gfx/005.301_tarot card.anm2",

        -- Reversed cards (IDs 56-77)
        [56] = "gfx/005.300.14_reverse tarot card.anm2",
        [57] = "gfx/005.300.14_reverse tarot card.anm2",
        [58] = "gfx/005.300.14_reverse tarot card.anm2",
        [59] = "gfx/005.300.14_reverse tarot card.anm2",
        [60] = "gfx/005.300.14_reverse tarot card.anm2",
        [61] = "gfx/005.300.14_reverse tarot card.anm2",
        [62] = "gfx/005.300.14_reverse tarot card.anm2",
        [63] = "gfx/005.300.14_reverse tarot card.anm2",
        [64] = "gfx/005.300.14_reverse tarot card.anm2",
        [65] = "gfx/005.300.14_reverse tarot card.anm2",
        [66] = "gfx/005.300.14_reverse tarot card.anm2",
        [67] = "gfx/005.300.14_reverse tarot card.anm2",
        [68] = "gfx/005.300.14_reverse tarot card.anm2",
        [69] = "gfx/005.300.14_reverse tarot card.anm2",
        [70] = "gfx/005.300.14_reverse tarot card.anm2",
        [71] = "gfx/005.300.14_reverse tarot card.anm2",
        [72] = "gfx/005.300.14_reverse tarot card.anm2",
        [73] = "gfx/005.300.14_reverse tarot card.anm2",
        [74] = "gfx/005.300.14_reverse tarot card.anm2",
        [75] = "gfx/005.300.14_reverse tarot card.anm2",
        [76] = "gfx/005.300.14_reverse tarot card.anm2",
        [77] = "gfx/005.300.14_reverse tarot card.anm2",

        -- Suit cards
        [23] = "gfx/005.302_suit card.anm2",
        [24] = "gfx/005.302_suit card.anm2",
        [25] = "gfx/005.302_suit card.anm2",
        [26] = "gfx/005.302_suit card.anm2",
        [27] = "gfx/005.302_suit card.anm2",
        [28] = "gfx/005.302_suit card.anm2",
        [29] = "gfx/005.302_suit card.anm2",
        [30] = "gfx/005.302_suit card.anm2",
        [31] = "gfx/005.302_suit card.anm2",
        [46] = "gfx/005.302_suit card.anm2",
        [48] = "gfx/005.302_suit card.anm2",
        [79] = "gfx/005.302_suit card.anm2",

        -- Magic cards
        [42] = "gfx/005.308_magic card.anm2",
        [52] = "gfx/005.308_magic card.anm2",
        [53] = "gfx/005.308_magic card.anm2",
        [54] = "gfx/005.308_magic card.anm2",

        -- Credit card
        [43] = "gfx/005.310_credit card.anm2",

        -- Card against humanity
        [45] = "gfx/005.309_card against humanity.anm2",

        -- Chance card
        [47] = "gfx/005.312_chance card.anm2",

        -- Holy card
        [51] = "gfx/005.311_holy card.anm2",

        -- Uno card
        [80] = "gfx/005.300.17_unus card.anm2"
    }

    -- Runes
    local runeSpriteById = {
        [32] = "gfx/005.303_rune1.anm2",
        [33] = "gfx/005.303_rune1.anm2",
        [34] = "gfx/005.303_rune1.anm2",
        [35] = "gfx/005.303_rune1.anm2",
        [36] = "gfx/005.304_rune2.anm2",
        [37] = "gfx/005.304_rune2.anm2",
        [38] = "gfx/005.304_rune2.anm2",
        [39] = "gfx/005.304_rune2.anm2",
        [40] = "gfx/005.304_rune2.anm2",
        [41] = "gfx/005.307_blackrune.anm2",
        [55] = "gfx/005.313_rune shard.anm2"
    }

    -- Souls
    local soulSpriteById = {
        [81] = "gfx/005.300.18_soul of isaac.anm2",
        [82] = "gfx/005.300.19_soul of magdalene.anm2",
        [83] = "gfx/005.300.20_soul of cain.anm2",
        [84] = "gfx/005.300.21_soul of judas.anm2",
        [85] = "gfx/005.300.22_soul of blue baby.anm2",
        [86] = "gfx/005.300.23_soul of eve.anm2",
        [87] = "gfx/005.300.24_soul of samson.anm2",
        [88] = "gfx/005.300.25_soul of azazel.anm2",
        [89] = "gfx/005.300.26_soul of lazarus.anm2",
        [90] = "gfx/005.300.27_soul of eden.anm2",
        [91] = "gfx/005.300.28_soul of the lost.anm2",
        [92] = "gfx/005.300.29_soul of lilith.anm2",
        [93] = "gfx/005.300.30_soul of the keeper.anm2",
        [94] = "gfx/005.300.31_soul of apollyon.anm2",
        [95] = "gfx/005.300.32_soul of the forgotten.anm2",
        [96] = "gfx/005.300.33_soul of bethany.anm2",
        [97] = "gfx/005.300.34_soul of jacob.anm2"
    }

    -- Other
    local otherSpriteById = {
        [49] = "gfx/005.306_diceshard.anm2",
        [50] = "gfx/005.305_emergencycontact.anm2",
        [78] = "gfx/005.300.15_cracked key.anm2"
    }

    for slot = 0, 3 do
        local card = player:GetCard(slot)
        if card and card > 0 then
            local spritePath = cardSpriteById[card] or runeSpriteById[card] or soulSpriteById[card] or
                                   otherSpriteById[card] or "gfx/005.302_suit card.anm2"
            local angle = math.random() * (2 * math.pi)
            local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                              (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
            local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
            local velocity = Vector.FromAngle(math.deg(angle)) * speed
            local sprite = Sprite()
            sprite:Load(spritePath, true)
            sprite:Play("Idle", true)
            table.insert(floatingItemsByPlayer[id], createFloatingItem({
                id = card,
                pos = player.Position,
                vel = velocity,
                vz = vz,
                sprite = sprite,
                type = "card"
            }))
        end
    end

    local pillSpriteById = {
        [1] = "gfx/005.071_pill blue-blue.anm2",
        [2] = "gfx/005.072_pill white-blue.anm2",
        [3] = "gfx/005.073_pill orange-orange.anm2",
        [4] = "gfx/005.074_pill white-white.anm2",
        [5] = "gfx/005.075_pill dots-red.anm2",
        [6] = "gfx/005.076_pill pink-red.anm2",
        [7] = "gfx/005.077_pill blue-cadetblue.anm2",
        [8] = "gfx/005.078_pill yellow-orange.anm2",
        [9] = "gfx/005.079_pill dots-white.anm2",
        [10] = "gfx/005.080_pill white-azure.anm2",
        [11] = "gfx/005.081_pill black-yellow.anm2",
        [12] = "gfx/005.082_pill white-black.anm2",
        [13] = "gfx/005.083_pill white-yellow.anm2",
        [14] = "gfx/005.084_pill gold-gold.anm2"
    }

    local horsePillSpriteById = {
        [2049] = "gfx/005.071_horse pill blue-blue.anm2",
        [2050] = "gfx/005.072_horse pill white-blue.anm2",
        [2051] = "gfx/005.073_horse pill orange-orange.anm2",
        [2052] = "gfx/005.074_horse pill white-white.anm2",
        [2053] = "gfx/005.075_horse pill dots-red.anm2",
        [2054] = "gfx/005.076_horse pill pink-red.anm2",
        [2055] = "gfx/005.077_horse pill blue-cadetblue.anm2",
        [2056] = "gfx/005.078_horse pill yellow-orange.anm2",
        [2057] = "gfx/005.079_horse pill dots-white.anm2",
        [2058] = "gfx/005.080_horse pill white-azure.anm2",
        [2059] = "gfx/005.081_horse pill black-yellow.anm2",
        [2060] = "gfx/005.082_horse pill white-black.anm2",
        [2061] = "gfx/005.083_horse pill white-yellow.anm2",
        [2062] = "gfx/005.084_horse pill gold-gold.anm2"
    }

    for slot = 0, 3 do
        local pill = player:GetPill(slot)
        if pill and pill > 0 then
            local spritePath = pillSpriteById[pill] or horsePillSpriteById[pill]

            if not spritePath then
                spritePath = "gfx/005.071_pill blue-blue.anm2"
            end

            local angle = math.random() * (2 * math.pi)
            local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                              (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
            local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
            local velocity = Vector.FromAngle(math.deg(angle)) * speed
            local sprite = Sprite()
            sprite:Load(spritePath, true)
            sprite:Play("Idle", true)

            if sprite:GetAnimation() == "Idle" and not horsePillSpriteById[pill] then
                pcall(function()
                    sprite:SetFrame("Idle", pill - 1)
                end)
            end

            table.insert(floatingItemsByPlayer[id], createFloatingItem({
                id = pill,
                pos = player.Position,
                vel = velocity,
                vz = vz,
                sprite = sprite,
                type = "pill"
            }))
        end
    end

    -- Trinkets
    for slot = 0, 1 do
        local trinket = player:GetTrinket(slot)
        if trinket > 0 then
            local angle = math.random() * (2 * math.pi)
            local speed = (math.random() * (SCATTER_RANGE_MAX - SCATTER_RANGE_MIN) + SCATTER_RANGE_MIN) *
                              (math.random() * SCATTER_RANDOM_FACTOR + 0.7)
            local vz = math.random() * (INITIAL_VZ_MAX - INITIAL_VZ_MIN) + INITIAL_VZ_MIN
            local velocity = Vector.FromAngle(math.deg(angle)) * speed
            local config = Isaac.GetItemConfig():GetTrinket(trinket)
            local sprite = Sprite()
            if config and config.GfxFileName then
                sprite:Load("gfx/005.350_trinket.anm2", true)
                sprite:ReplaceSpritesheet(0, config.GfxFileName)
                sprite:LoadGraphics()
                sprite:Play("Idle", true)
            else
                sprite:Load("gfx/005.350_trinket.anm2", true)
                sprite:Play("Idle", true)
            end
            table.insert(floatingItemsByPlayer[id], createFloatingItem({
                id = trinket,
                pos = player.Position,
                vel = velocity,
                vz = vz,
                sprite = sprite,
                type = "trinket"
            }))
        end
    end
end

function mod:onRender()
    if not shouldRender then
        return
    end

    local renderData = {}
    for _, items in pairs(floatingItemsByPlayer) do
        for _, item in ipairs(items) do
            local room = Game():GetRoom()
            local vel = item.vel
            if not room:IsPositionInRoom(item.pos, 0) then
                local roomCenter = room:GetCenterPos()
                item.vel = (roomCenter - item.pos):Normalized() * 5
            else
                if not room:IsPositionInRoom(item.pos + Vector(vel.X, 0), 0) then
                    vel = Vector(0, vel.Y)
                end
                if not room:IsPositionInRoom(item.pos + Vector(0, vel.Y), 0) then
                    vel = Vector(vel.X, 0)
                end
                item.vel = vel
            end

            if item.frame < 60 or (item.landed and item.vel:Length() > 0.1) then
                if item.z > 0 or item.vz ~= 0 then
                    item.pos = item.pos + item.vel
                    item.airDistance = item.airDistance + item.vel
                    item.vel = item.vel * AIR_DRAG
                    item.z = item.z + item.vz
                    item.vz = (item.vz - GRAVITY) * 0.93

                    if item.z < 0 then
                        item.z = 0
                    end
                    if item.z == 0 and item.vz == 0 and not item.landed then
                        item.vel = item.airDistance * 1.5
                        item.landed = true
                    end
                else
                    item.pos = item.pos + item.vel
                    item.vel = item.vel * GROUND_DRAG
                    if item.vel:Length() < 0.1 then
                        item.vel = Vector(0, 0)
                    end
                end
            end

            item.frame = item.frame + 1
            if item.frame >= 270 then
                item.fade = 1 - math.min((item.frame - 270) / 30, 1)
            else
                item.fade = 1
            end
            if item.frame > ITEM_LIFETIME then
                item.remove = true
            end

            local screenPos = game:GetRoom():WorldToScreenPosition(item.pos)
            local renderPos = Vector(screenPos.X, screenPos.Y - item.z)
            if item.type == "collectible" then
                renderPos = Vector(renderPos.X, renderPos.Y + 10)
            end
            table.insert(renderData, {
                item = item,
                screenPos = screenPos,
                renderPos = renderPos
            })
        end
    end

    for pid, items in pairs(floatingItemsByPlayer) do
        for i = #items, 1, -1 do
            if items[i].remove then
                table.remove(items, i)
            end
        end
    end

    table.sort(renderData, function(a, b)
        return a.renderPos.Y < b.renderPos.Y
    end)

    local entityYPositions = {}
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerScreenPos = game:GetRoom():WorldToScreenPosition(player.Position)
        table.insert(entityYPositions, playerScreenPos.Y)
    end
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) then
            local enemyScreenPos = game:GetRoom():WorldToScreenPosition(entity.Position)
            table.insert(entityYPositions, enemyScreenPos.Y)
        end
    end

    local behind, infront = {}, {}
    for _, data in ipairs(renderData) do
        local itemY = data.renderPos.Y
        local isBehind = false
        for _, entY in ipairs(entityYPositions) do
            if entY > itemY then
                isBehind = true
                break
            end
        end
        if isBehind then
            table.insert(behind, data)
        else
            table.insert(infront, data)
        end
    end

    local function renderShadow(item, screenPos)
        local shadowAlpha = 0.28 * (item.fade or 1)
        local shadowScale = 0.7 + 0.5 * (1 - math.min(item.z / 32, 1))
        local shadowPos = Vector(screenPos.X, screenPos.Y - item.z + 4)
        local scale = 0.125
        shadowSprite.Scale = Vector(shadowScale * scale, shadowScale * 0.5 * scale)
        shadowSprite.Color = Color(1, 1, 1, shadowAlpha, 0, 0, 0)
        shadowSprite:Render(shadowPos, Vector(0, 0), Vector(0, 0))
        shadowSprite.Scale = Vector(1, 1)
        shadowSprite.Color = Color(1, 1, 1, 1)
    end

    local function updateItemSprite(item) -- Resprites
        if item.type == "collectible" then
            local config = Isaac.GetItemConfig():GetCollectible(item.id)
            if config and config.GfxFileName then
                if item.lastGfx ~= config.GfxFileName then
                    item.sprite:ReplaceSpritesheet(0, config.GfxFileName)
                    item.sprite:LoadGraphics()
                    item.lastGfx = config.GfxFileName
                end
            end
        elseif item.type == "trinket" then
            local config = Isaac.GetItemConfig():GetTrinket(item.id)
            if config and config.GfxFileName then
                if item.lastGfx ~= config.GfxFileName then
                    item.sprite:ReplaceSpritesheet(0, config.GfxFileName)
                    item.sprite:LoadGraphics()
                    item.lastGfx = config.GfxFileName
                end
            end
        else
            if item.lastAnm2 ~= item.sprite:GetFilename() then
                local filename = item.sprite:GetFilename()
                item.sprite:Load(filename, true)
                item.sprite:Play("Idle", true)
                item.lastAnm2 = filename
            end
        end
    end

    local function renderItem(item, renderPos)
        if not item.sprite then
            return
        end
        updateItemSprite(item)
        local frameCount = game:GetFrameCount()
        local uniqueOffset = item.uniqueOffset or 0
        local angle = (frameCount * 4 + uniqueOffset) % 360
        local scaleX = math.cos(math.rad(angle))
        local offset = math.sin(math.rad(angle * 2)) * 2
        item.sprite.Scale = Vector(math.abs(scaleX), 1)
        item.sprite.Offset = Vector(0, offset)
        item.sprite.FlipX = scaleX < 0
        item.sprite.Rotation = 0
        pcall(function()
            item.sprite:Update()
        end)
        if item.sprite:IsLoaded() then
            local color = Color(1, 1, 1, item.fade or 1, 0, 0, 0)
            item.sprite.Color = color
            pcall(function()
                item.sprite:Render(renderPos, Vector(0, 0), Vector(0, 0))
            end)
            item.sprite.Color = Color(1, 1, 1, 1, 0, 0, 0)
        end
    end

    for _, data in ipairs(behind) do
        renderShadow(data.item, data.screenPos)
    end
    for _, data in ipairs(behind) do
        renderItem(data.item, data.renderPos)
    end
    for _, data in ipairs(infront) do
        renderShadow(data.item, data.screenPos)
    end
    for _, data in ipairs(infront) do
        renderItem(data.item, data.renderPos)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)

local lastAliveState = {}

function mod:onPlayerUpdate(player)
    local id = player.Index
    local isDead = player:IsDead()

    if not lastAliveState[id] then
        lastAliveState[id] = not isDead
    end

    if not isDead and not lastAliveState[id] then
        lastAliveState[id] = true
    elseif isDead and lastAliveState[id] then
        lastAliveState[id] = false
        shouldRender = false
        mod:scatterItems(player)
        shouldRender = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate)

function mod:onNewRoom()
    shouldRender = false
    floatingItemsByPlayer = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)