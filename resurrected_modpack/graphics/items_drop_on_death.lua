local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Items Drop On Death", 1)
local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Items Drop On Death", 1)
local game = Game()
local floatingItemsByPlayer = {}
local shouldRender = false
local itemCounter = 0

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
local DEFAULT_ITEM_LIFETIME = 120
local ITEM_ANIMATION_UPDATE_INTERVAL = 2

local willReviveNext = {}

function mod:TrueDeath(player, willRevive)
    local alivePlayers = 0
    for i = 0, Game():GetNumPlayers() - 1 do
        local other = Isaac.GetPlayer(i)
        if other ~= player and not other:IsDead() then
            alivePlayers = alivePlayers + 1
        end
    end
    if willRevive or alivePlayers > 0 then
        return DEFAULT_ITEM_LIFETIME - 95
    end
    return DEFAULT_ITEM_LIFETIME
end

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
        uniqueOffset = uniqueOffset,
        lifetime = args.lifetime or DEFAULT_ITEM_LIFETIME
    }
end

function mod:scatterItems(player, willRevive)
    local id = player.Index
    floatingItemsByPlayer[id] = {}
    local itemLifetime = mod:TrueDeath(player, willRevive)

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
            type = "collectible",
            lifetime = itemLifetime
        }))
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
                type = "trinket",
                lifetime = itemLifetime
            }))
        end
    end
end

function mod:onRender()
    if not shouldRender then
        return
    end

    local renderData = {}
    local isPaused = game:IsPaused()
    for _, items in pairs(floatingItemsByPlayer) do
        for _, item in ipairs(items) do
            local room = Game():GetRoom()
            local vel = item.vel
            if not isPaused then
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
                local lifetime = item.lifetime or DEFAULT_ITEM_LIFETIME
                if item.frame >= (lifetime - 30) then
                    item.fade = 1 - math.min((item.frame - (lifetime - 30)) / 30, 1)
                else
                    item.fade = 1
                end
                if item.frame > lifetime then
                    item.remove = true
                end
            else
                item.fade = item.fade or 1
            end
            local screenPos = game:GetRoom():WorldToScreenPosition(item.pos)
            local renderPos = Vector(screenPos.X, screenPos.Y - item.z)

            if item.type == "collectible" then
                renderPos = Vector(renderPos.X, renderPos.Y + 10)
            end

            if game:GetRoom():IsMirrorWorld() then
                local screenW = Isaac.GetScreenWidth()
                screenPos = Vector(screenW - screenPos.X, screenPos.Y)
                renderPos = Vector(screenW - renderPos.X, renderPos.Y)
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
        local heightFactor = math.max(0, math.min(1, (item.z or 0) / 32))
        local shadowScale = 0.55 + 0.45 * (1 - heightFactor)
        local shadowOpacity = shadowAlpha * (0.4 + 0.6 * (1 - heightFactor))
        local shadowPos = Vector(screenPos.X, screenPos.Y + 4)
        local scale = 0.125
        shadowSprite.Scale = Vector(shadowScale * scale, shadowScale * 0.5 * scale)
        shadowSprite.Color = Color(1, 1, 1, shadowOpacity, 0, 0, 0)
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
        local scaleX = 1
        local offset = math.sin(math.rad(angle * 2)) * 2
        item.sprite.Scale = Vector(math.abs(scaleX), 1)
        item.sprite.Offset = Vector(0, offset)
        item.sprite.FlipX = scaleX
        item.sprite.Rotation = 0
        if not isPaused and frameCount % ITEM_ANIMATION_UPDATE_INTERVAL == 0 then
            pcall(function()
                item.sprite:Update()
            end)
        end
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

local usedSould_Forgotten = false
local usedSould_JandE = false
local lastAliveState = {}
function mod:OnUseCard(cardID)
    if cardID == Card.CARD_SOUL_FORGOTTEN then
        usedSould_Forgotten = true
    end
    if cardID == Card.CARD_SOUL_JACOB then
        usedSould_JandE = true
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnUseCard)

local function CheckforStrawMan()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_STRAW_MAN) then
            return true
        end
    end
    return false
end

function mod:onPlayerUpdate(player)
    local id = player.Index
    local isDead = player:IsDead()
    if (player.Type == 1 and player.Variant == 1 and player.SubType == 59)                                                         -- found soul
        or (player.Type == 1 and player.Variant == 0 and player.SubType == PlayerType.PLAYER_KEEPER and CheckforStrawMan())        -- keeper strawman
        or (player.Type == 1 and player.Variant == 0 and player.SubType == PlayerType.PLAYER_THEFORGOTTEN and usedSould_Forgotten) -- Forgotten soul
        or (player.Type == 1 and player.Variant == 0 and player.SubType == PlayerType.PLAYER_ESAU and usedSould_JandE)             -- Esau soul
    then
        return
    end

    if lastAliveState[id] == nil then
        lastAliveState[id] = not isDead
    end
    if not isDead then
        willReviveNext[id] = player:WillPlayerRevive()
    end

    if not isDead and not lastAliveState[id] then
        lastAliveState[id] = true
    elseif isDead and lastAliveState[id] then
        lastAliveState[id] = false
        shouldRender = false
        mod:scatterItems(player, willReviveNext[id])
        shouldRender = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate)

function mod:onNewRoom()
    shouldRender = false
    floatingItemsByPlayer = {}
    usedSould_Forgotten = false
    usedSould_JandE = false
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)