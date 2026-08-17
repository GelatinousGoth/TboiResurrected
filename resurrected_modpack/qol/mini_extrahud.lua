-- miniMAPI is optional. When it is unavailable, the vanilla large-map path below is used instead.
local hasMinimapApi, minimapApi = pcall(require, "scripts.minimapapi.init")
local TR_Manager = require("resurrected_modpack.manager")

local MiniExtraHud = TR_Manager:RegisterMod("Mini ExtraHud", 1)
local Config = require("resurrected_modpack.qol.miniextrahud_config")
local registerMcm = require("resurrected_modpack.qol.miniextrahud_mcm")
local game = Game()
local itemConfig = Isaac.GetItemConfig()
local vectorZero = Vector(0, 0)

local HUD_BASE_TOP = 68
local HUD_BOTTOM = 268
local HUD_ICON_BASE_SIZE = 16
local HUD_ICON_GAP = 0
local HUD_BOTTOM_FADE_HEIGHT = 10
local HUD_SCROLL_OFFSET = 0
local HUD_SCROLL_TARGET_OFFSET = 0
local HUD_SCROLL_INPUT_STEP = 3
local HUD_SCROLL_ANIMATION_SPEED = 0.4
local HUD_SCROLL_BOTTOM_PADDING = 10
local ICON_SOURCE_SIZE = 32
local ICON_CONTAINER_PATH = "gfx/ui/miniextrahud_icon.anm2"
local WHITE_PIXEL_CONTAINER_PATH = "gfx/ui/miniextrahud_white_pixel.anm2"
local LOG_FILE_PATH = "miniextrahud_log.txt"
local TWIN_COLUMN_DIVIDER_WIDTH = 1
local TWIN_DIVIDER_SOLID_HEIGHT = 5
local TWIN_DIVIDER_GAP_HEIGHT = 8
local MINIMAP_TOP_GAP = 2
local MINIMAP_SMALL_ROOM_HEIGHT = 7
local MINIMAP_LARGE_ROOM_HEIGHT = 15
local MINIMAP_ROOM_BOTTOM_PADDING = 16
local MINIMAP_FRAME_BOTTOM_BORDER = 2
local VANILLA_MAP_TAP_FRAME_LIMIT = 8
local VANILLA_LARGE_ROOM_HEIGHT = 15
local VANILLA_LARGE_ROOM_BOTTOM_PADDING = 16
local VANILLA_LARGE_MAP_EXTRA_BOTTOM_PADDING = 20
local ITEM_ENTRY_COLLECTIBLE = "collectible"
local ITEM_ENTRY_SWALLOWED_TRINKET = "swallowedTrinket"
local BOOK_OF_VIRTUES_ID = CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES

-- These grid extents match miniMAPI's large-map room-shape layout.
local VANILLA_ROOM_SHAPE_GRID_SIZES = {
    [RoomShape.ROOMSHAPE_1x1] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_IH] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_IV] = Vector(1, 1),
    [RoomShape.ROOMSHAPE_1x2] = Vector(1, 2),
    [RoomShape.ROOMSHAPE_IIV] = Vector(1, 2),
    [RoomShape.ROOMSHAPE_2x1] = Vector(2, 1),
    [RoomShape.ROOMSHAPE_IIH] = Vector(2, 1),
    [RoomShape.ROOMSHAPE_2x2] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LTL] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LTR] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LBL] = Vector(2, 2),
    [RoomShape.ROOMSHAPE_LBR] = Vector(2, 2),
}

local itemList = {}
local ownedItemCounts = {}
local swallowedTrinketCounts = {}
local jacobItemList = {}
local jacobOwnedItemCounts = {}
local jacobSwallowedTrinketCounts = {}
local esauItemList = {}
local esauOwnedItemCounts = {}
local esauSwallowedTrinketCounts = {}
local iconSprites = {}
local whitePixelSprite = nil
local vanillaMapHeldFrames = 0
local vanillaMapIsLockedLarge = false
local wasLoggingEnabled = false

local function getConfigValue(key)
    if type(ModConfigMenu) == "table" and type(ModConfigMenu.Config) == "table" then
        local mcmConfig = ModConfigMenu.Config[MiniExtraHud.Name]
        if mcmConfig and mcmConfig[key] ~= nil then
            return mcmConfig[key]
        end
    end

    return Config[key]
end

local function writeLog(message)
    if getConfigValue("LoggingEnabled") ~= true then
        return
    end

    local line = string.format("[MiniExtraHud][frame=%d] %s\n", Isaac.GetFrameCount(), message)
    Isaac.DebugString(line)

    if not io or not io.open then
        return
    end

    local opened, file = pcall(io.open, LOG_FILE_PATH, "a")
    if opened and file then
        local written = pcall(function()
            file:write(line)
            file:close()
        end)
        if not written then
            pcall(function()
                file:close()
            end)
        end
    end
end

local function resetLog(startMessage)
    if getConfigValue("LoggingEnabled") ~= true then
        return
    end

    if io and io.open then
        local opened, file = pcall(io.open, LOG_FILE_PATH, "w")
        if opened and file then
            local written = pcall(function()
                file:write("[MiniExtraHud] log started\n")
                file:close()
            end)
            if not written then
                pcall(function()
                    file:close()
                end)
            end
        end
    end

    writeLog(startMessage)
end

local function hasMomsBox(player)
    local activeSlots = {
        ActiveSlot.SLOT_PRIMARY,
        ActiveSlot.SLOT_SECONDARY,
        ActiveSlot.SLOT_POCKET,
        ActiveSlot.SLOT_POCKET2,
    }

    for _, slot in ipairs(activeSlots) do
        if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_MOMS_BOX then
            return true
        end
    end

    return false
end

local function getIconSize()
    return HUD_ICON_BASE_SIZE * getConfigValue("IconScale")
end

local function getIconOpacity()
    return getConfigValue("IconOpacity")
end

local function getUpdateInterval()
    return getConfigValue("UpdateInterval")
end

local function getRowHeight()
    return getIconSize() + HUD_ICON_GAP
end

local function getMinimapApiBottom()
    if minimapApi:GetConfig("Disable") or minimapApi.Disable or not minimapApi:IsHUDVisible() then
        return nil
    end

    local displayMode = minimapApi:GetConfig("DisplayMode")
    if displayMode == 4 then
        return nil
    end

    local screenTopRight = minimapApi:GetScreenTopRight()
    if displayMode == 2 and not minimapApi:IsLarge() and minimapApi.GlobalScaleX >= 1 then
        local frameTop = screenTopRight.Y + minimapApi:GetConfig("PositionY") - 10
        return frameTop + minimapApi:GetConfig("MapFrameHeight") + MINIMAP_FRAME_BOTTOM_BORDER
    end

    local roomHeight = minimapApi:IsLarge() and MINIMAP_LARGE_ROOM_HEIGHT or MINIMAP_SMALL_ROOM_HEIGHT
    local mapBottom = nil
    local level = minimapApi:GetLevel()
    if not level then
        return nil
    end

    for _, room in ipairs(level) do
        if room.RenderOffset and room:IsVisible() then
            local roomGridSize = minimapApi:GetRoomShapeGridSize(room.Shape)
            local roomBottom = room.RenderOffset.Y + roomGridSize.Y * roomHeight + MINIMAP_ROOM_BOTTOM_PADDING
            mapBottom = mapBottom and math.max(mapBottom, roomBottom) or roomBottom
        end
    end

    return mapBottom
end

local function updateVanillaLargeMapState()
    if game:IsPaused() then
        return
    end

    local player = game:GetPlayer(0)
    local mapPressed = Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex)

    if mapPressed then
        vanillaMapHeldFrames = vanillaMapHeldFrames + 1
    elseif vanillaMapHeldFrames > 0 then
        if vanillaMapHeldFrames <= VANILLA_MAP_TAP_FRAME_LIMIT then
            vanillaMapIsLockedLarge = not vanillaMapIsLockedLarge
        end

        vanillaMapHeldFrames = 0
    end
end

local function isVanillaLargeMapVisible()
    return vanillaMapIsLockedLarge or vanillaMapHeldFrames > 0
end

local function getVanillaLargeMapBottom()
    -- While paused, the stored map state remains in effect; only input updates are paused.
    if not isVanillaLargeMapVisible() then
        return nil
    end

    local rooms = game:GetLevel():GetRooms()
    local highestGridBottom = nil
    local topmostGridY = nil

    for roomIndex = 0, rooms.Size do
        local descriptor = rooms:Get(roomIndex)
        if descriptor and descriptor.Data and descriptor.DisplayFlags > 0 then
            -- GridIndex is documented as the top-left cell, which is required for L-shaped rooms.
            local gridY = math.floor(descriptor.GridIndex / 13)
            local gridSize = VANILLA_ROOM_SHAPE_GRID_SIZES[descriptor.Data.Shape]
            if gridSize then
                topmostGridY = topmostGridY and math.min(topmostGridY, gridY) or gridY
                local gridBottom = gridY + gridSize.Y
                highestGridBottom = highestGridBottom and math.max(highestGridBottom, gridBottom) or gridBottom
            end
        end
    end

    if not topmostGridY or not highestGridBottom then
        return nil
    end

    -- The vanilla enlarged map is top-aligned like miniMAPI's unbounded large map.
    return (highestGridBottom - topmostGridY) * VANILLA_LARGE_ROOM_HEIGHT
        + VANILLA_LARGE_ROOM_BOTTOM_PADDING + VANILLA_LARGE_MAP_EXTRA_BOTTOM_PADDING
end

local function getMapBottom()
    if hasMinimapApi then
        return getMinimapApiBottom()
    end

    return getVanillaLargeMapBottom()
end

local function getHudTop()
    local mapBottom = getMapBottom()
    if mapBottom then
        return math.max(HUD_BASE_TOP, mapBottom + MINIMAP_TOP_GAP)
    end

    return HUD_BASE_TOP
end

local function getTwinPlayers()
    local mainPlayer = game:GetPlayer(0):GetMainTwin()
    if mainPlayer:GetPlayerType() ~= PlayerType.PLAYER_JACOB then
        return nil, nil
    end

    return mainPlayer, mainPlayer:GetOtherTwin()
end

local function getDisplayEntries(sourceList)
    local displayEntries = {}
    local combinedEntries = {}

    for sourceIndex = #sourceList, 1, -1 do
        local entry = sourceList[sourceIndex]
        local shouldCombine = (entry.type == ITEM_ENTRY_SWALLOWED_TRINKET and getConfigValue("CombineTrinkets") == true)
            or (entry.type == ITEM_ENTRY_COLLECTIBLE and getConfigValue("CombineCollectibles") == true)

        if shouldCombine then
            local key = entry.type .. ":" .. entry.id
            local displayEntry = combinedEntries[key]
            if displayEntry then
                displayEntry.count = displayEntry.count + 1
            else
                displayEntry = {
                    entry = entry,
                    count = 1,
                    showCount = true,
                }
                combinedEntries[key] = displayEntry
                table.insert(displayEntries, displayEntry)
            end
        else
            table.insert(displayEntries, {
                entry = entry,
                count = 1,
                showCount = false,
            })
        end
    end

    return displayEntries
end

local function getDisplayedRowCount()
    local jacobPlayer, esauPlayer = getTwinPlayers()
    if jacobPlayer and esauPlayer then
        return math.max(#getDisplayEntries(jacobItemList), #getDisplayEntries(esauItemList))
    end

    return math.ceil(#getDisplayEntries(itemList) / 2)
end

local function getMaximumScrollOffset(hudTop)
    local rowCount = getDisplayedRowCount()
    if rowCount == 0 then
        return 0
    end

    local listBottomAtTop = hudTop + (rowCount - 1) * getRowHeight() + getIconSize()
    return math.max(0, listBottomAtTop - (HUD_BOTTOM + HUD_SCROLL_BOTTOM_PADDING))
end

local function clampScrollTarget(hudTop)
    local maximumScrollOffset = getMaximumScrollOffset(hudTop)
    HUD_SCROLL_TARGET_OFFSET = math.max(0, math.min(HUD_SCROLL_TARGET_OFFSET, maximumScrollOffset))
end

local function updateScrollInput(hudTop)
    local maximumScrollOffset = getMaximumScrollOffset(hudTop)

    local scrollUpKey = getConfigValue("ScrollUpKey")
    local scrollDownKey = getConfigValue("ScrollDownKey")
    local scrollHomeKey = getConfigValue("ScrollHomeKey")
    local scrollEndKey = getConfigValue("ScrollEndKey")

    if scrollUpKey >= 0 and Input.IsButtonPressed(scrollUpKey, 0) then
        HUD_SCROLL_TARGET_OFFSET = HUD_SCROLL_TARGET_OFFSET - HUD_SCROLL_INPUT_STEP
    end

    if scrollDownKey >= 0 and Input.IsButtonPressed(scrollDownKey, 0) then
        HUD_SCROLL_TARGET_OFFSET = HUD_SCROLL_TARGET_OFFSET + HUD_SCROLL_INPUT_STEP
    end

    if scrollHomeKey >= 0 and Input.IsButtonTriggered(scrollHomeKey, 0) then
        HUD_SCROLL_TARGET_OFFSET = 0
    end

    if scrollEndKey >= 0 and Input.IsButtonTriggered(scrollEndKey, 0) then
        HUD_SCROLL_TARGET_OFFSET = maximumScrollOffset
    end

    clampScrollTarget(hudTop)
end

local function updateScrollAnimation(hudTop)
    clampScrollTarget(hudTop)
    local maximumScrollOffset = getMaximumScrollOffset(hudTop)
    HUD_SCROLL_OFFSET = math.max(0, math.min(HUD_SCROLL_OFFSET, maximumScrollOffset))
    HUD_SCROLL_OFFSET = HUD_SCROLL_OFFSET + (HUD_SCROLL_TARGET_OFFSET - HUD_SCROLL_OFFSET) * HUD_SCROLL_ANIMATION_SPEED
    if math.abs(HUD_SCROLL_TARGET_OFFSET - HUD_SCROLL_OFFSET) < 0.01 then
        HUD_SCROLL_OFFSET = HUD_SCROLL_TARGET_OFFSET
    end
end

local function getScreenSize()
    local room = game:GetRoom()
    local origin = room:WorldToScreenPosition(vectorZero) - room:GetRenderScrollOffset() - game.ScreenShakeOffset
    local roomOriginX = origin.X + 60 * 26 / 40
    local roomOriginY = origin.Y + 140 * 26 / 40

    return Vector(roomOriginX * 2 + 13 * 26, roomOriginY * 2 + 7 * 26)
end

local function removeOldestItemFromList(targetList, entryType, itemId, amount)
    local removed = 0
    local index = 1

    while index <= #targetList and removed < amount do
        local entry = targetList[index]
        if entry.type == entryType and entry.id == itemId then
            table.remove(targetList, index)
            removed = removed + 1
        else
            index = index + 1
        end
    end
end

local function updateItemCount(player, itemListForPlayer, ownedCountsForPlayer, listName, itemId, item)
    -- Book of Virtues is a special active/passive hybrid. Its active-slot copy is included in
    -- GetCollectibleNum, so it must not be treated as a normal passive HUD entry.
    if itemId == BOOK_OF_VIRTUES_ID then
        item = nil
    end

    if item and item.Type == ItemType.ITEM_PASSIVE then
        local currentCount = player:GetCollectibleNum(itemId, true)
        local previousCount = ownedCountsForPlayer[itemId] or 0

        if currentCount > previousCount then
            for _ = 1, currentCount - previousCount do
                table.insert(itemListForPlayer, { type = ITEM_ENTRY_COLLECTIBLE, id = itemId })
            end
        elseif currentCount < previousCount then
            removeOldestItemFromList(itemListForPlayer, ITEM_ENTRY_COLLECTIBLE, itemId, previousCount - currentCount)
        end

        if currentCount ~= previousCount then
            writeLog(string.format("ITEM_COUNT_CHANGED list=%s itemId=%d previous=%d current=%d",
                listName, itemId, previousCount, currentCount))
        end

        ownedCountsForPlayer[itemId] = currentCount
    elseif ownedCountsForPlayer[itemId] and ownedCountsForPlayer[itemId] > 0 then
        removeOldestItemFromList(itemListForPlayer, ITEM_ENTRY_COLLECTIBLE, itemId, ownedCountsForPlayer[itemId])
        ownedCountsForPlayer[itemId] = 0
    end
end

local function getHeldTrinketMultiplier(player, trinketId)
    local heldMultiplier = 0
    local goldenFlag = TrinketType.TRINKET_GOLDEN_FLAG
    local trinketIdMask = TrinketType.TRINKET_ID_MASK

    for trinketSlot = 0, 1 do
        local heldTrinketId = player:GetTrinket(trinketSlot)
        if (heldTrinketId & trinketIdMask) == trinketId then
            if (heldTrinketId & goldenFlag) ~= 0 then
                heldMultiplier = heldMultiplier + 2
            else
                heldMultiplier = heldMultiplier + 1
            end
        end
    end

    return heldMultiplier
end

local function getSwallowedTrinketMultiplier(player, trinketId, playerHasMomsBox)
    local totalMultiplier = player:GetTrinketMultiplier(trinketId)
    local heldMultiplier = getHeldTrinketMultiplier(player, trinketId)
    local momsBoxMultiplier = playerHasMomsBox and 1 or 0

    return math.max(0, totalMultiplier - heldMultiplier - momsBoxMultiplier)
end

local function updateSwallowedTrinketCount(player, itemListForPlayer, swallowedCountsForPlayer,
        listName, trinketId, playerHasMomsBox)
    local currentCount = getSwallowedTrinketMultiplier(player, trinketId, playerHasMomsBox)
    local previousCount = swallowedCountsForPlayer[trinketId] or 0

    if currentCount > previousCount then
        for _ = 1, currentCount - previousCount do
            table.insert(itemListForPlayer, {
                type = ITEM_ENTRY_SWALLOWED_TRINKET,
                id = trinketId,
            })
        end
    elseif currentCount < previousCount then
        removeOldestItemFromList(itemListForPlayer, ITEM_ENTRY_SWALLOWED_TRINKET, trinketId,
            previousCount - currentCount)
    end

    if currentCount ~= previousCount then
        writeLog(string.format("SWALLOWED_TRINKET_COUNT_CHANGED list=%s trinketId=%d previous=%d current=%d",
            listName, trinketId, previousCount, currentCount))
    end

    swallowedCountsForPlayer[trinketId] = currentCount
end

local function updatePlayerItemList(player, itemListForPlayer, ownedCountsForPlayer,
        swallowedCountsForPlayer, listName)
    local collectibleCount = itemConfig:GetCollectibles().Size
    local trinketCount = itemConfig:GetTrinkets().Size
    local playerHasMomsBox = hasMomsBox(player)

    for itemId = 1, collectibleCount - 1 do
        updateItemCount(player, itemListForPlayer, ownedCountsForPlayer, listName, itemId, itemConfig:GetCollectible(itemId))
    end

    for trinketId = 1, trinketCount - 1 do
        if itemConfig:GetTrinket(trinketId) then
            updateSwallowedTrinketCount(player, itemListForPlayer, swallowedCountsForPlayer,
                listName, trinketId, playerHasMomsBox)
        end
    end
end

local function updateItemList()
    local jacobPlayer, esauPlayer = getTwinPlayers()
    if jacobPlayer and esauPlayer then
        updatePlayerItemList(jacobPlayer, jacobItemList, jacobOwnedItemCounts,
            jacobSwallowedTrinketCounts, "jacob")
        updatePlayerItemList(esauPlayer, esauItemList, esauOwnedItemCounts,
            esauSwallowedTrinketCounts, "esau")
        return
    end

    updatePlayerItemList(game:GetPlayer(0), itemList, ownedItemCounts, swallowedTrinketCounts, "default")
end

local function getIconSprite(entry)
    local spriteKey = entry.type .. ":" .. entry.id
    local iconSprite = iconSprites[spriteKey]
    if iconSprite then
        return iconSprite
    end

    local item = nil
    if entry.type == ITEM_ENTRY_COLLECTIBLE then
        item = itemConfig:GetCollectible(entry.id)
    elseif entry.type == ITEM_ENTRY_SWALLOWED_TRINKET then
        item = itemConfig:GetTrinket(entry.id)
    end

    if not item then
        return nil
    end

    iconSprite = Sprite()
    iconSprite:Load(ICON_CONTAINER_PATH, false)
    iconSprite:ReplaceSpritesheet(0, item.GfxFileName)
    iconSprite:LoadGraphics()
    iconSprite:Play("Icon", true)
    iconSprites[spriteKey] = iconSprite

    return iconSprite
end

local function getWhitePixelSprite()
    if whitePixelSprite then
        return whitePixelSprite
    end

    whitePixelSprite = Sprite()
    whitePixelSprite:Load(WHITE_PIXEL_CONTAINER_PATH, true)
    whitePixelSprite:Play("Pixel", true)
    return whitePixelSprite
end

local function renderIconSection(iconSprite, position, sectionTop, sectionBottom, opacity)
    local iconSize = getIconSize()
    local iconScale = iconSize / ICON_SOURCE_SIZE
    local iconBottom = position.Y + iconSize
    local topClamp = (sectionTop - position.Y) / iconScale
    local bottomClamp = (iconBottom - sectionBottom) / iconScale

    iconSprite.Scale = Vector(iconScale, iconScale)
    iconSprite.Color = Color(1, 1, 1, opacity, 0, 0, 0)
    iconSprite:Render(position, Vector(0, topClamp), Vector(0, bottomClamp))
end

local function renderItemIcon(entry, position, hudTop)
    local iconSprite = getIconSprite(entry)
    if not iconSprite then
        return
    end

    local iconBottom = position.Y + getIconSize()
    local visibleTop = math.max(hudTop, position.Y)
    local visibleBottom = math.min(HUD_BOTTOM, iconBottom)
    if visibleTop >= visibleBottom then
        return
    end

    local fadeTop = HUD_BOTTOM - HUD_BOTTOM_FADE_HEIGHT
    local solidBottom = math.min(visibleBottom, fadeTop)
    if visibleTop < solidBottom then
        renderIconSection(iconSprite, position, visibleTop, solidBottom, getIconOpacity())
    end

    -- Each one-pixel section is rendered independently so opacity decreases toward the lower bound.
    for fadePixel = 0, HUD_BOTTOM_FADE_HEIGHT - 1 do
        local sectionTop = math.max(visibleTop, fadeTop + fadePixel)
        local sectionBottom = math.min(visibleBottom, fadeTop + fadePixel + 1)

        if sectionTop < sectionBottom then
            local opacity = getIconOpacity() * (HUD_BOTTOM - sectionBottom) / HUD_BOTTOM_FADE_HEIGHT
            renderIconSection(iconSprite, position, sectionTop, sectionBottom, opacity)
        end
    end
end

local function renderItemCount(displayEntry, position, hudTop)
    if not displayEntry.showCount then
        return
    end

    local iconSize = getIconSize()
    local text = tostring(displayEntry.count)
    local textScale = iconSize / ICON_SOURCE_SIZE
    local textWidth = Isaac.GetTextWidth(text) * textScale
    local textHeight = 8 * textScale
    local textX = position.X + iconSize - textWidth - 2
    local textY = position.Y + iconSize - textHeight - 2

    if textY < hudTop or textY + textHeight > HUD_BOTTOM then
        return
    end

    Isaac.RenderScaledText(text, textX, textY, textScale, textScale,
        1, 1, 1, getIconOpacity())
end

local function renderTwinItemColumns(hudTop, screenSize, iconSize)
    local rightColumnX = screenSize.X - getConfigValue("RightMargin") - iconSize
    local dividerX = rightColumnX - TWIN_COLUMN_DIVIDER_WIDTH
    local leftColumnX = dividerX - iconSize
    local rowHeight = getRowHeight()
    local jacobDisplayEntries = getDisplayEntries(jacobItemList)
    local esauDisplayEntries = getDisplayEntries(esauItemList)

    for displayIndex, displayEntry in ipairs(jacobDisplayEntries) do
        local y = hudTop - HUD_SCROLL_OFFSET + (displayIndex - 1) * rowHeight
        local position = Vector(leftColumnX, y)
        renderItemIcon(displayEntry.entry, position, hudTop)
        renderItemCount(displayEntry, position, hudTop)
    end

    for displayIndex, displayEntry in ipairs(esauDisplayEntries) do
        local y = hudTop - HUD_SCROLL_OFFSET + (displayIndex - 1) * rowHeight
        local position = Vector(rightColumnX, y)
        renderItemIcon(displayEntry.entry, position, hudTop)
        renderItemCount(displayEntry, position, hudTop)
    end

    local bottomItemCount = math.max(#jacobDisplayEntries, #esauDisplayEntries)
    if bottomItemCount == 0 then
        return
    end

    local dividerBottom = math.min(HUD_BOTTOM, hudTop - HUD_SCROLL_OFFSET
        + (bottomItemCount - 1) * rowHeight + iconSize)
    local dividerSprite = getWhitePixelSprite()
    dividerSprite.Color = Color(1, 1, 1, getIconOpacity(), 0, 0, 0)
    local dividerY = hudTop

    while dividerY < dividerBottom do
        local segmentHeight = math.min(TWIN_DIVIDER_SOLID_HEIGHT, dividerBottom - dividerY)
        dividerSprite.Scale = Vector(TWIN_COLUMN_DIVIDER_WIDTH, segmentHeight)
        dividerSprite:Render(Vector(dividerX, dividerY))
        dividerY = dividerY + TWIN_DIVIDER_SOLID_HEIGHT + TWIN_DIVIDER_GAP_HEIGHT
    end
end

local function renderHud()
    if not hasMinimapApi then
        updateVanillaLargeMapState()
    end

    if not game:GetHUD():IsVisible() or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
        return
    end

    local hudTop = getHudTop()
    if hudTop >= HUD_BOTTOM then
        return
    end

    updateScrollInput(hudTop)
    updateScrollAnimation(hudTop)

    local screenSize = getScreenSize()
    local iconSize = getIconSize()
    local jacobPlayer, esauPlayer = getTwinPlayers()
    if jacobPlayer and esauPlayer then
        renderTwinItemColumns(hudTop, screenSize, iconSize)
        return
    end

    local rightColumnX = screenSize.X - getConfigValue("RightMargin") - iconSize
    local leftColumnX = rightColumnX - HUD_ICON_GAP - iconSize
    local rowHeight = getRowHeight()
    local displayEntries = getDisplayEntries(itemList)

    for displayIndex, displayEntry in ipairs(displayEntries) do
        local column = (displayIndex - 1) % 2
        local row = math.floor((displayIndex - 1) / 2)
        local x = column == 0 and leftColumnX or rightColumnX
        -- The content origin tracks viewport-top changes so later scrolling retains its table position.
        local y = hudTop - HUD_SCROLL_OFFSET + row * rowHeight

        local position = Vector(x, y)
        renderItemIcon(displayEntry.entry, position, hudTop)
        renderItemCount(displayEntry, position, hudTop)
    end
end

local function onPostUpdate()
    local loggingEnabled = getConfigValue("LoggingEnabled") == true
    if loggingEnabled and not wasLoggingEnabled then
        resetLog("LOGGING_ENABLED")
    end
    wasLoggingEnabled = loggingEnabled

    if game:GetFrameCount() % getUpdateInterval() == 0 then
        updateItemList()
    end
end

MiniExtraHud:AddCallback(ModCallbacks.MC_POST_UPDATE, onPostUpdate)
MiniExtraHud:AddCallback(ModCallbacks.MC_POST_RENDER, renderHud)
MiniExtraHud:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    itemList = {}
    ownedItemCounts = {}
    swallowedTrinketCounts = {}
    jacobItemList = {}
    jacobOwnedItemCounts = {}
    jacobSwallowedTrinketCounts = {}
    esauItemList = {}
    esauOwnedItemCounts = {}
    esauSwallowedTrinketCounts = {}
    registerMcm(MiniExtraHud.Name, Config)
    local loggingEnabled = getConfigValue("LoggingEnabled") == true
    if loggingEnabled then
        resetLog(string.format("GAME_STARTED continued=%s", tostring(isContinued)))
    end
    wasLoggingEnabled = loggingEnabled
end)
