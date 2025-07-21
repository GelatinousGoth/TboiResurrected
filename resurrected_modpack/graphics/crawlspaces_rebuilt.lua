local TR_Manager = require("resurrected_modpack.manager")
CrawlspacesRebuilt = TR_Manager:RegisterMod("crawlspaces rebuilt", 1)
local mod = CrawlspacesRebuilt

include("resurrected_modpack.graphics.crawlspaces_rebuilt.decorations")
local json = require("json")
local decorations = mod.decorations

--VARIABLES
--locations, grid related values
local SMALLROOM_HEIGHT = 9
local TILE_ABOVE_BLACKMARKET = 44
local DEFAULT_LADDER_POS = 17
local GIDEON_TOP_EDGE_POS = 3
local GIDEON_DECOR_A = 56
local GIDEON_DECOR_B = 57
local GIDEON_DECOR_ADJACENT = 58
local ROTGUT_TRAPDOOR_POS = 7
local ROTGUT_ABOVE_DOOR_POS = 74
local BLACKMARKET_DOOR_POS = 74
--roots
local DUNGEON_SPRITESHEET_ROOT = "gfx/grid/crawlspaces/dungeon/"
local GIDEON_SPRITESHEET_ROOT = "gfx/grid/crawlspaces/gideon/"
local ROTGUT_SPRITESHEET_ROOT = "gfx/grid/crawlspaces/rotgut/"
local VIGNETTE_SPRITESHEET_PATH = "gfx/grid/crawlspaces/vignettes/vignette.anm2"
local POOPROOT = "gfx/grid/crawlspaces/poopsprites/"
--rng shenanigans
local RECOMMENDED_SHIFT_IDX = 35
local IDLE_ANIMATION_TRIGGER_CHANCE = 0.01 --may want to be lowered or raised as more animations are added.

local DEFAULT_FLOOR_DECOR_CHANCE = 0.2
local DEFAULT_CEILING_DECOR_CHANCE = 0.5
local DEFAULT_BGDECOR_CHANCE = 0.07
--signals an error when returning something expecting a table
local ERROR_TBL = {false}
local _ = nil

local game = Game()
local isaac = Isaac --i hate capital letters!!! i love camelCase!!!!!!
local decorRNG = RNG()
local animRNG = RNG()
local sfx = SFXManager()

local animations = {}
local toRender = {}
local players

local trapdoorOpenAmount = 1
local TRAPDOOR_BRIGHTENING_PER_SECOND = 4.2
local TRAPDOOR_DIMMING_PER_SECOND = 1.3


--mod config menu support
local shaderTypeChoices = {
    "Shader",
    "Legacy Vignette",
    "Disabled"
}
local modConfigSettings = {
    shaderType = shaderTypeChoices[1],
    shaderStrength = 8, --default 0.8

    doGravityOnWalkableTiles = true,

    trapdoorsEnabled = true,
    blackMarketDoorsEnabled = true,
    simpleModeEnabled = false --skips the detail placement steps, lets you play with just the spritesheet changes
}
--shader type will automatically set the values of these when changed
local doShaders = modConfigSettings.shaderType == "Shader"
local doLegacyVignettes = modConfigSettings.shaderType == "Legacy Vignette"
local shaderStrength = 0.8




local function getTableIdx(tbl, val)
    for i,v in ipairs(tbl) do
        if v == val then return i end
    end
end


--if there are config settings saved, load them
function mod:loadConfigSettings()
    if not (mod:HasData() and ModConfigMenu) then return end

    local string = mod:LoadData()
    local cfg = json.decode(string)

    -- don't just set the config settings to the saved data to prevent incomplete save data from setting attributes to nil.
    -- this way, anything not stored in the save data will revert to the default value instead of nil
    for i,v in pairs(cfg) do
        modConfigSettings.i = v
    end

    -- update these
    doShaders = modConfigSettings.shaderType == "Shader"
    doLegacyVignettes = modConfigSettings.shaderType == "Legacy Vignette"
    shaderStrength = modConfigSettings.shaderStrength/10
end


function mod.saveConfigSettings()
    local string = json.encode(modConfigSettings)
    mod:SaveData(string)
end


local function constructModConfigSettings()
    if ModConfigMenu == nil then return end
    --get rid of the old menu (if it exists) and build it from scratch (for luamoda)
    ModConfigMenu.RemoveCategory("Crawlspaces Rebuilt")
    --load saved settings, so luamodding doesn't keep resetting you to default
    mod:loadConfigSettings()

    ModConfigMenu.AddTitle("Crawlspaces Rebuilt", _, "Lighting")

    --shader type selection
    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIdx(shaderTypeChoices, modConfigSettings.shaderType)
            end,
            Minimum = 1,
            Maximum = #shaderTypeChoices,
            Display = function()
                if modConfigSettings.shaderType == nil then return "Lighting Effects :: nil?? uh. this isnt supposed to happen." end
                return "Lighting Effects :: "..modConfigSettings.shaderType
            end,
            OnChange = function(n)
                modConfigSettings.shaderType = shaderTypeChoices[n]
                doShaders = n == 1 --first option enables normal shaders
                doLegacyVignettes = n == 2 --second option enables legacy vignettes
                --third option will just disable both
                mod.saveConfigSettings()
                mod:identifyRoom()
            end,
            Info = {"Note: the legacy vignette is suceptable to jank when playing with wonky resolutions."}
        }
    )

    --shader strength
    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.SCROLL,
            CurrentSetting = function()
                return modConfigSettings.shaderStrength
            end,
            Display = function()
                return "Shader Intensity :: $scroll"..modConfigSettings.shaderStrength
            end,
            OnChange = function(n)
                modConfigSettings.shaderStrength = n
                shaderStrength = n/10

                mod.saveConfigSettings()
            end,
            Info = {"Adjusts the intensity of shaders.", "(only works when shaders are enabled)"}
        }
    )

    ModConfigMenu.AddSpace("Crawlspaces Rebuilt", _)
    ModConfigMenu.AddTitle("Crawlspaces Rebuilt", _, "Compatability")

    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return modConfigSettings.doGravityOnWalkableTiles
            end,
            Display = function()
                return "Better Gravity :: "..(modConfigSettings.doGravityOnWalkableTiles and "Enabled" or "Disabled")
            end,
            OnChange = function(b)
                modConfigSettings.doGravityOnWalkableTiles = b

                mod.saveConfigSettings()
                mod:identifyRoom()
            end,
            Info = {"Makes gravity ALWAYS apply to the player when not touching a ladder.", "Disable to escape softlocks in modded rooms."}
        }
    )

    ModConfigMenu.AddSpace("Crawlspaces Rebuilt", _)
    ModConfigMenu.AddTitle("Crawlspaces Rebuilt", _, "Other")

    --trapdoors
    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return modConfigSettings.trapdoorsEnabled
            end,
            Display = function()
                return "Trapdoors :: "..(modConfigSettings.trapdoorsEnabled and "Enabled" or "Disabled")
            end,
            OnChange = function(b)
                modConfigSettings.trapdoorsEnabled = b

                mod.saveConfigSettings()
                mod:identifyRoom()
            end,
            Info = {"Toggle the trapdoor visible from below."}
        }
    )

    --black market doors
    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return modConfigSettings.blackMarketDoorsEnabled
            end,
            Display = function()
                return "Black Market Doors :: "..(modConfigSettings.blackMarketDoorsEnabled and "Enabled" or "Disabled")
            end,
            OnChange = function(b)
                modConfigSettings.blackMarketDoorsEnabled = b

                mod.saveConfigSettings()
                mod:identifyRoom()
            end,
            Info = {"Toggle the doors leading into black markets."}
        }
    )

    ModConfigMenu.AddSpace("Crawlspaces Rebuilt", _)

    --simple mode
    ModConfigMenu.AddSetting(
        "Crawlspaces Rebuilt",
        _,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return modConfigSettings.simpleModeEnabled
            end,
            Display = function()
                return "Simple Mode :: "..(modConfigSettings.simpleModeEnabled and "Enabled" or "Disabled")
            end,
            OnChange = function(b)
                modConfigSettings.simpleModeEnabled = b

                mod.saveConfigSettings()
            end,
            Info = {"Disables most decorations for a mostly vanilla-like look.", "(enter a new room for this to take effect)"}
        }
    )
end
if REPENTOGON then constructModConfigSettings() end



local function mergeTables(tableA, tableB)
    --cast both inputs to a table
    if type(tableA) ~= "table" then tableA = {tableA} end
    if type(tableB) ~= "table" then tableB = {tableB} end

    local out = {}

    for _,v in pairs(tableA) do
        table.insert(out, v)
    end
    for _,v in pairs(tableB) do
        table.insert(out, v)
    end

    return out
end


--runs whenever butter bean is used, for debug & testing purposes
--callback should be commented out when not in use
function mod:debugTrigger(item, rng, player)
    local room = game:GetRoom()
    local playerGridPos = room:GetClampedGridIndex(player.Position)

    room:SpawnGridEntity(playerGridPos, GridEntityType.GRID_POOP, GridPoopVariant.HOLY)
end


--supply a main table with a list of decoration tables, calculates a chance value for each entry based on their weight values
function mod.weighTable(table)
    local totalWeight = 0

    --calculate the total weight
    for i,v in ipairs(table) do
        totalWeight = totalWeight + v.weight
    end

    --feels off to iterate the table twice but thats just how it goes ig
    for i,v in ipairs(table) do
        v.chance = v.weight/totalWeight
    end

    return table
end

--weigh out all the animation tables
--first iterate through each table
for i,v in pairs(decorations) do
    --then each entry within the table
    for i2,v2 in pairs(v) do
        --weigh the table
        v2 = mod.weighTable(v2)
    end
end


--returns a table containing all players
function mod.getPlayers()
    local playerCount = game:GetNumPlayers()
    local players = {}
    local player

    for i = 0, playerCount-1 do
        player = isaac.GetPlayer(i)
        table.insert(players, player)
    end

    return players
end



--DECORAITON PROCESSING


--supply a decoration object
--if that object has an animCount that is not -1, adds it to the animations table.
function mod.saveAnimationData(decoration)
    if decoration.animCount == -1 then return false end

    table.insert(animations, decoration)
end


--takes a name and removes anything in the animations table assigned the same name.
--iterates backwards so table.remove can be used without skipping over entries
function mod.removeAnimationData(name)
    for i=#animations, 1, -1  do
        local v = animations[i]
        if v.name == name then
            table.remove(animations, i)
        end
    end
end


--checks the top 2 rows of a room for player position which indicates where to display the hatch.
--if no player is found that high, defaults to the usual ladder location in a 1x1 room (happens when exiting a black market or re-entering a run from the menu)
function mod.findHatch(room, player, roomWidth)
    local playerGridPos = room:GetGridIndex(player.Position)

    if playerGridPos < (roomWidth*2)-1 then
        return playerGridPos
    end

    return DEFAULT_LADDER_POS
end


--returns true if the player is in a 2d crawlspace room
function mod.isAnyCrawlspace()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()
    if backdrop == BackdropType.DUNGEON or backdrop == BackdropType.DUNGEON_GIDEON or backdrop == BackdropType.DUNGEON_ROTGUT then return true end

    return false
end


function mod.isItemdungeonCrawlspace()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()
    if backdrop == BackdropType.DUNGEON then return true end

    return false
end


function mod.isNonRotgutCrawlspace()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()
    if backdrop == BackdropType.DUNGEON or backdrop == BackdropType.DUNGEON_GIDEON then return true end

    return false
end


--is this tile the decorative tile in gideon's crawlspace (funny little isaac with wings below the key at the top).
function mod.isGideonDecor(tile)
    if mod.isGideon() and (tile == GIDEON_DECOR_A or tile == GIDEON_DECOR_B) then
        return true
    end

    return false
end


--is the current room gideon's crawlspace?
function mod.isGideon()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()

    if backdrop == BackdropType.DUNGEON_GIDEON then
        return true
    end

    return false
end


--is the current room the rotgut arena where you fight the heart?
--sketchy cause it uses room indexes instead of backdrop types but swageva
function mod.isHeartRoom()
    local level = game:GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local gridRoom = roomDesc.SafeGridIndex

    if gridRoom == GridRooms.ROOM_ROTGUT_DUNGEON2_IDX then
        return true
    end

    return false
end


function mod.isRotgutCrawlspace()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()

    if backdrop == BackdropType.DUNGEON_ROTGUT then
        return true
    end

    return false
end


--checks if a gridentity is a "shallow" ceiling (only 1 block thick) by taking in the entitytype of the tile above it.
--this does NOT need to be its own function but it keeps replaceDungeonSprites looking tidy so idc
function mod.isCeilingShallow(aboveType)
    if aboveType == GridEntityType.GRID_WALL then
        return false
    end

    return true
end


--checks if this tile is in the top row of the room
function mod.isTopRow(tile, roomWidth)
    if tile > roomWidth-1 then
        return false
    end

    return true
end


--return the tileentity below's type, or null grid entity if invalid
function mod.getGridEntTypeBelow(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth)

    --if invalid, set ent to the last tile on the grid
    if ent == nil then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity variant to the left of a given tile, or -1 if invalid
function mod.getGridEntVariantBelow(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth)

    if ent == nil then
        return -1
    end

    return ent:GetVariant()
end


--return the tileentity type to the bottom left of a given tile, or null grid entity if invalid
function mod.getGridEntTypeBottomLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth-1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif (tile+1)%roomWidth == 0 then -- is the tile on the right side of the screen (wrapped around)
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type to the bottom right of a given tile, or null grid entity if invalid
function mod.getGridEntTypeBottomRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth+1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif tile%roomWidth == 0 then --is the tile on the left side of the screen (wrapped around)
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type directly above a given tile, or null grid entity if invalid
function mod.getGridEntTypeAbove(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-roomWidth)

    if ent == nil then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type to the left of a given tile, or null grid entity if invalid
function mod.getGridEntTypeLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif (tile+1)%roomWidth == 0 then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity variant to the left of a given tile, or -1 if invalid
function mod.getGridEntVariantLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-1)

    if ent == nil then
        return -1
    elseif (tile+1)%roomWidth == 0 then
        return -1
    end

    return ent:GetVariant()
end


--returns the tileentity type to the left of a given tile, or null grid entity if invalid
function mod.getGridEntTypeRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif tile%roomWidth == 0 then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity variant to the right of a given tile, or -1 if invalid
function mod.getGridEntVariantRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+1)

    if ent == nil then
        return -1
    elseif tile%roomWidth == 0 then
        return -1
    end

    return ent:GetVariant()
end


function mod.isTileAtRoomEdge(tile, roomWidth)
    return ((tile+1)%roomWidth == 0 or tile%roomWidth == 0)
end


--assumes you're in a regular crawlspace or a gideon one
function mod.getSpriteRoot()
    local spriteRoot = DUNGEON_SPRITESHEET_ROOT

    if not FiendFolio then
        spriteRoot = mod.isGideon() and GIDEON_SPRITESHEET_ROOT or DUNGEON_SPRITESHEET_ROOT
    else
        local suffix = FiendFolio.getCrawlspaceBackdropSuffix()
        if suffix ~= "default" then spriteRoot = "gfx/grid/crawlspaces/fiendfolio_compat/" .. suffix .. "/" end
    end

    return spriteRoot
end


--constructs and returns a new decoration object.
--name is the name of the animation played, although it can be anything so long as the object isn't passed into playDecoration.
--type is a string coresponding to the anm2 file this decoration comes from.
--variantLayers are any layers that should be immediately toggled on loading this or any new animations.
--sprite is the sprite object.
--position is the position.
--animCount is the number of random animations this decoration has. 0 indicates the decoration has animations that don't play randomly, and -1 indicates the decoration has no animations.
function mod.newDecoration(name, type, variantLayers, layersOffByDefault, sprite, position, animCount)
    return {
        name = name,
        type = type or "typeless",
        variantLayers = variantLayers or {},
        layersOffByDefault = layersOffByDefault or {},
        sprite = sprite,
        position = position,
        animCount = animCount or -1}
end


--get a random background column.
--returns an object with name, animCount, sprite and position values
function mod.randomBG(roomDecor, sprite, position, noCeiling, roomHeight, isDecorated)
    --iterate the rng and get a number between 0 and 1 from it
    local bgTable
    if roomDecor ~= nil and roomDecor.bg ~= nil then bgTable = roomDecor.bg else return ERROR_TBL end
    local float = decorRNG:RandomFloat()
    local sum = 0
    local variants = {}
    local layersOff = {}

    --set the modifier(s)
    if roomHeight > SMALLROOM_HEIGHT and bgTable.variantLayers.tallBG ~= nil then
        variants = bgTable.variantLayers.tallBG
    end

    if noCeiling and bgTable.variantLayers.ceiling ~= nil then
        variants = mergeTables(variants, bgTable.variantLayers.ceiling)
    end

    --when trapdoors are disabled, the bg with no ceiling also has its "roof" disabled (assuming there is a roof)
    if noCeiling and (not modConfigSettings.trapdoorsEnabled) and bgTable.variantLayers.hatchToggle then
        variants = mergeTables(variants, bgTable.variantLayers.hatchToggle)
    end

    if isDecorated and bgTable.variantLayers.ceilingDecor ~= nil then
        variants = mergeTables(variants, bgTable.variantLayers.ceilingDecor)
    end

    --get the layers off by default
    if bgTable.layersOffByDefault ~= nil then layersOff = bgTable.layersOffByDefault end

    --iterate through the table until the total chance value is higher than float (should never finish without returning something)
    for i,v in ipairs(bgTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(v.name, "bg", variants, layersOff, sprite, position, v.animCount)
        end
    end

    --there's no way this ever happens but just in case some wierd rounding makes the loop end without returning, return an error
    return ERROR_TBL
end


--get a random background decoration
function mod.randomBGDecor(roomDecor, sprite, position)
    local bgDecorTable
    if roomDecor ~= nil and roomDecor.bgDecor ~= nil then bgDecorTable = roomDecor.bgDecor else return ERROR_TBL end
    local float = decorRNG:RandomFloat()
    local sum = 0

    for i,v in ipairs(bgDecorTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(v.name, "bgDecor", {}, {}, sprite, position, v.animCount)
        end
    end

    return ERROR_TBL
end


--get a random corner animation, concave edges between 2 wall tiles.
function mod.randomCorner(roomDecor, sprite, position, isLeft, isShallow, isBG)
    local cornerTable
    --ensure nothing is wrong with the decoration table provided
    if roomDecor ~= nil and roomDecor.corner ~= nil then cornerTable = roomDecor.corner else return ERROR_TBL end
    local float = decorRNG:RandomFloat()
    local sum = 0
    local side = "right_"
    local variants = {}
    local layersOff = {}

    if isLeft then side = "left_" end

    if isShallow and cornerTable.variantLayers.shallowCeiling ~= nil then
        variants = cornerTable.variantLayers.shallowCeiling
    end
    if isBG and cornerTable.variantLayers.bg ~= nil then
        variants = mergeTables(variants, cornerTable.variantLayers.bg)
    end

    if cornerTable.layersOffByDefault ~= nil then layersOff = cornerTable.layersOffByDefault end

    for i,v in ipairs(cornerTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(side..v.name, "corner", variants, layersOff, sprite, position, v.animCount)
        end
    end

    return ERROR_TBL
end


--get a random edge animation, sharp convex corners of a single wall tile that stick out and need to be smoothed a lil.
function mod.randomEdge(roomDecor, sprite, position, isLeft)
    local edgeTable
    if roomDecor ~= nil and roomDecor.edge ~= nil then edgeTable = roomDecor.edge else return ERROR_TBL end --return false if the decoration table has no edges subtable
    local float = decorRNG:RandomFloat()
    local sum = 0
    local side = "right_"

    if isLeft then side = "left_" end

    --only 1 edge sprite for now, still calculate in full for backwards compatability
    for i,v in ipairs(edgeTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(side..v.name, "edge", {}, {}, sprite, position, v.animCount)
        end
    end

    return ERROR_TBL
end


--get a random ceiling decoration, cobwebs and the sort
function mod.randomCeiling(roomDecor, sprite, position, isShallow)
    local ceilingTable
    if roomDecor ~= nil and roomDecor.ceiling ~= nil then ceilingTable = roomDecor.ceiling else return ERROR_TBL end
    local float = decorRNG:RandomFloat()
    local sum = 0
    local variants = {}
    local layersOff = {}

    if isShallow and ceilingTable.variantLayers and ceilingTable.variantLayers.shallowCeiling ~= nil then
        --have the shallowceiling layers toggled on
        variants = ceilingTable.variantLayers.shallowCeiling
    end

    if ceilingTable.layersOffByDefault ~= nil then layersOff = ceilingTable.layersOffByDefault end

    for i,v in ipairs(ceilingTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(v.name, "ceiling", variants, layersOff, sprite, position, v.animCount)
        end
    end

    return ERROR_TBL
end


--get a random floor decoration, pebbles and the sort
function mod.randomFloor(roomDecor, sprite, position)
    local floorTable
    if roomDecor ~= nil and roomDecor.floor ~= nil then floorTable = roomDecor.floor else return ERROR_TBL end
    local float = decorRNG:RandomFloat()
    local sum = 0

    for i,v in ipairs(floorTable) do
        sum = sum + v.chance
        if float < sum then
            return mod.newDecoration(v.name, "floor", {}, {}, sprite, position, v.animCount)
        end
    end

    return ERROR_TBL
end


--supply a sprite object and a layerID or array of layerIDs/names
--toggles each layer's visibility to the opposite state
--thanks repentogon :D
function mod.toggleSpriteLayers(sprite, layers)
    --if an empty table is provided don't bother
    --also returns if repentogon is disabled as a failsafe, since this is the only place repentogon methods are used
    if REPENTOGON == nil then return end
    if type(layers) ~= "table" then layers = {layers} end

    for _,layerName in pairs(layers) do
        local layerState = sprite:GetLayer(layerName)
        local visibility = layerState:IsVisible()

        layerState:SetVisible(not visibility)
    end
end


--prepares a sprite after it has been played, toggling off layers that shouldn't be present
--accepts the variantLayers for this specific decoration, and the decorations that should start out off by default.
function mod.prepareDecorationLayers(sprite, variants, offByDefault)
    --if no layers are given to change, return
    if ((variants == nil or variants == {}) and (offByDefault == nil or offByDefault == {})) then return end

    --first, turn off the sprites that should be off by default
    mod.toggleSpriteLayers(sprite, offByDefault)

    --then apply variantLayers
    mod.toggleSpriteLayers(sprite, variants)
end


--supply a decoration object and spritesheet root
--attempts to play the decoration's sprite and save its animation data.
--returns true/false based on whether the decoration failed to be found or not
function mod.playDecoration(decoration, spriteRoot)
    --error table means this decoration type doesn't exist in this room
    if decoration ~= ERROR_TBL then
        local sprite = decoration.sprite
        local type = decoration.type
        local variants = decoration.variantLayers
        local layersOff = decoration.layersOffByDefault

        sprite:Load(spriteRoot..type..".anm2", true)
        sprite:Play(decoration.name, true)

        --disable appropriate layers
        mod.prepareDecorationLayers(sprite, variants, layersOff)

        --attempt to save animation data
        mod.saveAnimationData(decoration)
        return true
    end

    return false
end


--handles the playing of the hatch at the start of the room
function mod.playHatch(spriteRoot, room, roomDecor, playerGridPos, hatchGridID, roomWidth)
    local ent = room:GetGridEntity(hatchGridID)
    local belowType = mod.getGridEntTypeBelow(room, hatchGridID, roomWidth)
    local belowVariant = mod.getGridEntVariantBelow(room, hatchGridID, roomWidth)
    local variants = {}
    local layersOff = {}

    if not roomDecor.hatch then return end
    if roomDecor.hatch.layersOffByDefault ~= nil then layersOff = roomDecor.hatch.layersOffByDefault end

    --really sketchy fix, since an error is thrown right here if a crawlspace boots you to an error room
    if ent == nil then return end

    local sprite = ent:GetSprite()
    sprite:Load(spriteRoot.."hatch.anm2", true)

    --starts opened if isaac is in the top 2 rows (likely came from above), otherwise starts closed (when entering from black market)
    if playerGridPos < (room:GetGridWidth()*2)-1 then
        sprite:Play("opened")
    else
        sprite:Play("closed")
    end

    --if there's a floor below, add the floorBelow variant layer tag and disable the associated layers
    --"floor below" also includes a ladder that continues through a floor, which technically has nothing to do with a floor and is purely visual. this has a variant of 30 which is currently my favorite magic number coincidentally
    if belowType == GridEntityType.GRID_WALL or (belowType == GridEntityType.GRID_DECORATION and belowVariant == 30) and roomDecor.hatch.variantLayers ~= nil and roomDecor.hatch.variantLayers.floorBelow ~= nil then
        variants = roomDecor.hatch.variantLayers.floorBelow
    end

    --if trapdoors are toggled off
    if not modConfigSettings.trapdoorsEnabled then
        variants = mergeTables(variants, roomDecor.hatch.variantLayers.toggleHatch)
    end

    --then toggle the layers
    mod.prepareDecorationLayers(sprite, variants, layersOff)

    --animations each have a distinct purpose and should not be handled with the usual random animation choice.
    mod.saveAnimationData(mod.newDecoration("hatch", "hatch", variants, layersOff, sprite, hatchGridID, 0))
end


local function roundPoopState(state)
    -- if the state is a multiple of 250 then it should be valid
    local dif = state%250
    if dif == 0 then
        return state
    else
        return state - dif
    end
end


function mod.playPoop(ent, position, sprite, spriteRoot, ffOverride)
    if ffOverride == nil then ffOverride = false end
    local variant = ent:GetVariant()
    local state = ent.State
    --apparently golden poops use this state as actual health, so ig round it down to the nearest valid one
    state = roundPoopState(state)
    --this name has the poop's state value appended onto it, so when the state changes the name of the animation playing should update accordingly
    local name = "poop_"..state
    local POOP_LAYER = 2

    --fiendfolio seems to have their own (albeit slightly jank) method of replacing poops
    --problem: it completely breaks if the poop isn't completely intact. oops
    --ig i'll fill in the blanks
    if state == 0 and FiendFolio and not ffOverride then return end

    sprite:Load(spriteRoot.."floor.anm2")

    --using the variant of the poop, dynamically replace the spritesheet on the poop layer (2)
    if variant == GridPoopVariant.RED then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."red.png")
        sprite:LoadGraphics()
    elseif variant == GridPoopVariant.CORN then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."corn.png")
        sprite:LoadGraphics()
    elseif variant == GridPoopVariant.GOLDEN then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."gold.png")
        sprite:LoadGraphics()
    elseif variant == GridPoopVariant.RAINBOW then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."rainbow.png")
        sprite:LoadGraphics()
    elseif variant == GridPoopVariant.BLACK then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."black.png")
        sprite:LoadGraphics()
    elseif variant == GridPoopVariant.HOLY then
        sprite:ReplaceSpritesheet(POOP_LAYER, POOPROOT.."holy.png")
        sprite:LoadGraphics()
    --for poop variants unsupported by the mod, obviously don't mess with them or replace anything
    elseif variant ~= GridPoopVariant.NORMAL then
        return
    end

    sprite:Play(name)
    --because this is playing upon entering a room, skip the animation that would normally play when a poop gets destroyed to this state
    sprite:SetFrame(4)

    --save the decoration as just "poop"
    local decoration = mod.newDecoration("poop", "floor", {}, {}, sprite, position, 0)
    mod.saveAnimationData(decoration)
end


--jumps around the grid and replaces sprites as needed, the main function of the mod
local replaced = false
function mod.replaceDungeonSprites(spriteRoot, roomDecor)

    --only run once per room, unsure if this check is necessary or not but it doesn't break anything so it stays
    if replaced then return end

    local room = game:GetRoom()
    local decorSeed = room:GetDecorationSeed()
    local startSeed = game:GetSeeds():GetStartSeed()
    local player = isaac.GetPlayer()

    --getting gridIDs of useful locations
    local roomWidth = room:GetGridWidth()
    local roomHeight = room:GetGridHeight()
    local roomSize = room:GetGridSize()
    local rightGridID = roomWidth - 1
    local hatchGridID =  mod.findHatch(room, player, roomWidth)--show trapdoor sprite at player starting position
    local bgNoCeilingGridID = hatchGridID - roomWidth --render a background wall for the ladder on the tile directly above it
    local playerGridPos = room:GetGridIndex(player.Position)

    local isGideon = mod.isGideon()

    local ent = {}
    local sprite = {}

    --set rng
    decorRNG:SetSeed(decorSeed, RECOMMENDED_SHIFT_IDX)
    animRNG:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)

    --get chances for various decorations to appear
    local floorDecorChance = DEFAULT_FLOOR_DECOR_CHANCE
    local ceilingDecorChance = DEFAULT_CEILING_DECOR_CHANCE
    local bgDecorChance = DEFAULT_BGDECOR_CHANCE
    if roomDecor.decorChances ~= nil then
        floorDecorChance = roomDecor.decorChances.floorDecorChance or DEFAULT_FLOOR_DECOR_CHANCE
        ceilingDecorChance = roomDecor.decorChances.ceilingDecorChance or DEFAULT_CEILING_DECOR_CHANCE
        bgDecorChance = roomDecor.decorChances.bgDecorChance or DEFAULT_BGDECOR_CHANCE
    end

    --start of replacing sprites. most important sprites should be done further down to prevent overriding.
    --this loop handles decorations placed randomly around the grid.
    for i=0,roomSize-1 do
        local float = decorRNG:RandomFloat()
        ent = room:GetGridEntity(i)
        if ent == nil then goto continueRoomLoop end
        sprite = ent:GetSprite()
        local aboveEnt = room:GetGridEntity(i-roomWidth) --hate declaring this just to barely use it but swagever
        if aboveEnt == nil then aboveEnt = room:GetGridEntity(0) end --wierd default to fall back on, hopefully doesnt cause issues
        local isTopRow = mod.isTopRow(i, roomWidth)

        --getting the gridEntType of the surrounding area
        local type = ent:GetType()
        local variant = ent:GetVariant()
        local belowType = mod.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = mod.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = mod.getGridEntTypeBottomRight(room, i, roomWidth)
        local aboveType = mod.getGridEntTypeAbove(room, i, roomWidth)
        local leftType = mod.getGridEntTypeLeft(room, i, roomWidth)
        local rightType = mod.getGridEntTypeRight(room, i, roomWidth)

        local leftVariant = mod.getGridEntVariantLeft(room, i, roomWidth)
        local rightVariant = mod.getGridEntVariantRight(room, i, roomWidth)

        local isLeftCorner = type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY
        local isRightCorner = type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY

        --poops (mostly to account for that one stupid rare crawlspace)
        --TODO: add more of these for different grid objects? perchance
        if type == GridEntityType.GRID_POOP then
            mod.playPoop(ent, i, sprite, spriteRoot)

        --the tile below poops, spikes, other grid entities on the floor requires this workaround to look like a shallow ceiling
        elseif (aboveType == GridEntityType.GRID_POOP or aboveType == GridEntityType.GRID_SPIKES_ONOFF or aboveType == GridEntityType.GRID_SPIKES) and type == GridEntityType.GRID_WALL then
            mod.playDecoration(mod.randomCeiling(roomDecor, sprite, i, true), spriteRoot)

        --spikes, done in a similar manner to poops
        elseif (type == GridEntityType.GRID_SPIKES or type == GridEntityType.GRID_SPIKES_ONOFF) and belowType == GridEntityType.GRID_WALL then
            mod.playDecoration(mod.newDecoration("spikes", "floor", {}, {}, sprite, i, 0), spriteRoot)

        elseif type == GridEntityType.GRID_SPIKES or type == GridEntityType.GRID_SPIKES_ONOFF then
            sprite:ReplaceSpritesheet(0, "gfx/grid/crawlspaces/wall_spikes.png")
            sprite:LoadGraphics()

        --background decorations
        elseif type == GridEntityType.GRID_GRAVITY and float < bgDecorChance and belowType == GridEntityType.GRID_GRAVITY then
            mod.playDecoration(mod.randomBGDecor(roomDecor, sprite, i), spriteRoot)

        --hardcoded special case in gideon's crawlspace to prevent overlapping textures sometimes
        elseif i == GIDEON_DECOR_ADJACENT and isGideon then
            mod.playDecoration(mod.newDecoration("right_web", "corner", {}, {"shallowCeiling"}, sprite, i, -1), spriteRoot)

        --check for corners, if a spot is viable for both then choose one at random. otherwise, do the relevant one
        elseif isLeftCorner and isRightCorner then
            if float < 0.5 then
                local isShallow = mod.isCeilingShallow(aboveType)
                mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, true, isShallow, false), spriteRoot)
            else
                local isShallow = mod.isCeilingShallow(aboveType)
                mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, false, isShallow, false), spriteRoot)
            end

        elseif isLeftCorner then
            local isShallow = mod.isCeilingShallow(aboveType)
            mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, true, isShallow, false), spriteRoot)
        elseif isRightCorner then
            local isShallow = mod.isCeilingShallow(aboveType)
            mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, false, isShallow, false), spriteRoot)

        --then edges (like corners but convex rather than concave), first left then right. i hate the way these are determined
        elseif type == GridEntityType.GRID_WALL and leftType ~= GridEntityType.GRID_WALL and leftVariant ~= 30 and belowType ~= GridEntityType.GRID_WALL and aboveType == GridEntityType.GRID_WALL and i < (roomWidth*(roomHeight-1)-1) then
            mod.playDecoration(mod.randomEdge(roomDecor, sprite, i, true), spriteRoot)
        elseif type == GridEntityType.GRID_WALL and rightType ~= GridEntityType.GRID_WALL and rightVariant ~= 30 and belowType ~= GridEntityType.GRID_WALL and aboveType == GridEntityType.GRID_WALL and i < (roomWidth*(roomHeight-1)-1) then
            mod.playDecoration(mod.randomEdge(roomDecor, sprite, i, false), spriteRoot)

        --then ceiling decor
        elseif type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and mod.isGideonDecor(i) == false and not isTopRow and float < ceilingDecorChance then
            local isShallow = mod.isCeilingShallow(aboveType)
            mod.playDecoration(mod.randomCeiling(roomDecor, sprite, i, isShallow), spriteRoot)

        --then floor decorations
        elseif type == GridEntityType.GRID_GRAVITY and belowType == GridEntityType.GRID_WALL and float < floorDecorChance then
            mod.playDecoration(mod.randomFloor(roomDecor, sprite, i), spriteRoot)

        end

        ::continueRoomLoop::
    end

    --black market door
    ent = room:GetGridEntity(BLACKMARKET_DOOR_POS)
    local type = ent:GetType()
    local belowDoorType = mod.getGridEntTypeBelow(room, BLACKMARKET_DOOR_POS, roomWidth)
    local atRoomEdge = mod.isTileAtRoomEdge(BLACKMARKET_DOOR_POS, roomWidth)
    --only replace if the tile is gravity, the tile below is floor, and the tile is at the very edge of the room, pretty much guranteed signaling a black market door
    if type == GridEntityType.GRID_GRAVITY and belowDoorType == GridEntityType.GRID_WALL and isGideon == false and atRoomEdge then
        sprite = ent:GetSprite()

        sprite:Load(spriteRoot.."hatch.anm2", true)
        sprite:Play("marketdoor", true);
    end
    --if black markets are disabled, immediately 180 and replace that tile with a floor
    if not modConfigSettings.blackMarketDoorsEnabled then
        sprite = ent:GetSprite()

        --load the anm2
        sprite:Load("gfx/grid/tiles_itemdungeon.anm2", true)
        --for ff crawlspaces, replace the gfx
        if FiendFolio and FiendFolio:getCrawlspaceBackdropSuffix() ~= "default" then
            local suffix = FiendFolio:getCrawlspaceBackdropSuffix()
            sprite:ReplaceSpritesheet(0, "gfx/grid/crawlspaces/fiendfolio_compat/" .. suffix .. "/tiles_itemdungeon_" .. suffix .. ".png")
            sprite:LoadGraphics()
        end
        sprite:Play("Floor1", true)
    end

    --handle trapdoor sprite
    mod.playHatch(spriteRoot, room, roomDecor, playerGridPos, hatchGridID, roomWidth)

    --this loop handles background walls, running along the top of the grid
    for i=0,rightGridID-1 do
        ent = room:GetGridEntity(i)
        local belowType = mod.getGridEntTypeBelow(room, i, roomWidth)
        local float = decorRNG:RandomFloat()
        sprite = ent:GetSprite()

        --get a wall without a ceiling on the tile above where the trapdoor spawns
        if i == bgNoCeilingGridID then
            mod.playDecoration(mod.randomBG(roomDecor, sprite, i, true, roomHeight, false), spriteRoot)

        --special case in the gideon crawlspace, hardcoded cause im lazy.
        elseif isGideon and i == GIDEON_TOP_EDGE_POS then
            mod.playDecoration(mod.newDecoration("left_ceilingedge", "bg", {}, {}, sprite, i, -1), spriteRoot)

        --special case for decorated ceilings with air beneath them
        elseif belowType == GridEntityType.GRID_GRAVITY and float < ceilingDecorChance then
            mod.playDecoration(mod.randomBG(roomDecor, sprite, i, false, roomHeight, true), spriteRoot)

        --everywhere else just play random regular backgrounds
        else
            mod.playDecoration(mod.randomBG(roomDecor, sprite, i, false, roomHeight, false), spriteRoot)

        end
    end

    --wall on the far right edge sticks out a little, so render a special squished wall that doesnt stick out over the edge
    ent = room:GetGridEntity(rightGridID)
    sprite = ent:GetSprite()
    local variant = {}
    if roomHeight > SMALLROOM_HEIGHT then variant = roomDecor.bg.variantLayers.tallBG end
    mod.playDecoration(mod.newDecoration("rightwall", "bg", variant, roomDecor.bg.layersOffByDefault, sprite, rightGridID, -1), spriteRoot)

    --sets up the vignette effect
    if doLegacyVignettes then
        local vignette = Sprite()
        vignette:Load(VIGNETTE_SPRITESHEET_PATH, true)
        vignette:Play("dungeon", true)
        mod.saveAnimationData(mod.newDecoration("vignette", "vignette", {}, vignette, 0, 0))
        table.insert(toRender, vignette)
    end

    replaced = true
end


--replaces sprites around the grid as needed, makes some assumptions based on the rotgut arena always remaining the same
function mod.replaceRotgutSprites(spriteRoot)
    local room = game:GetRoom()
    local roomDecor = decorations.rotgut
    local decorSeed = room:GetDecorationSeed()
    local startSeed = game:GetSeeds():GetStartSeed()
    local player = isaac.GetPlayer()

    --getting gridIDs of useful locations
    local roomWidth = room:GetGridWidth()
    local roomHeight = room:GetGridHeight()
    local roomSize = room:GetGridSize()
    local rightGridID = roomWidth - 1

    local isHeartRoom = mod.isHeartRoom()

    local ent = {}
    local sprite = {}

    decorRNG:SetSeed(decorSeed, RECOMMENDED_SHIFT_IDX)
    animRNG:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)

    --get chances for various decorations to appear
    local ceilingDecorChance = roomDecor.ceilingDecorChance or DEFAULT_CEILING_DECOR_CHANCE

    --main loop for replacing tiles
    for i=0, roomSize-1 do
        local float = decorRNG:RandomFloat()
        ent = room:GetGridEntity(i)
        sprite = ent:GetSprite()

        local type = ent:GetType()
        local aboveType = mod.getGridEntTypeAbove(room, i, roomWidth)
        local belowType = mod.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = mod.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = mod.getGridEntTypeBottomRight(room, i, roomWidth)
        local isShallow = mod.isCeilingShallow(aboveType) --call out here since this is used for most checks in the loop
        local isTopRow = mod.isTopRow(i, roomWidth)

        --make the tiles along the side of the screen actually random, since in vanilla they're normally always the same for some damn reason
        if not isTopRow and ((i+1)%roomWidth == 0 or i%roomWidth == 0) and type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_WALL and i ~= ROTGUT_ABOVE_DOOR_POS then
            local int = decorRNG:RandomInt(3)

            sprite:Load(spriteRoot.."tile.anm2", true)
            sprite:Play("tile", true)
            sprite:SetFrame(int)--did things a bit different here, with 3 different frames for each tile in the same animation

        --check for corners, starting with left and then right
        elseif type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and isShallow == false then
            mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, true, false, false), spriteRoot)
        elseif type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and isShallow == false then
            mod.playDecoration(mod.randomCorner(roomDecor, sprite, i, false, false, false), spriteRoot)

        --then ceiling decor
        elseif type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and not isTopRow and  float < ceilingDecorChance then
            mod.playDecoration(mod.randomCeiling(roomDecor, sprite, i, isShallow), spriteRoot)

        end
    end

    --handles the top row, where backgrounds are rendered
    for i=0,rightGridID-1 do
        ent = room:GetGridEntity(i)
        sprite = ent:GetSprite()

        local type = ent:GetType()
        local belowType = mod.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = mod.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = mod.getGridEntTypeBottomRight(room, i, roomWidth)

        --handle the hatch first
        if i == ROTGUT_TRAPDOOR_POS and isHeartRoom == false then
            mod.playDecoration(mod.newDecoration("hatch", "hatch", _, _, sprite, i, 2), spriteRoot)

        elseif (i == ROTGUT_TRAPDOOR_POS+1 or i == ROTGUT_TRAPDOOR_POS-1) and isHeartRoom == false then
            --play an empty animation since the trapdoor already covers this part of the ceiling
            mod.playDecoration(mod.newDecoration("void", "hatch", _, _, sprite), spriteRoot)

        --now corners
        elseif type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY then
            mod.playDecoration(mod.randomCorner(decorations.rotgut, sprite, i, true, false, true), spriteRoot)

        elseif type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and i ~= TILE_ABOVE_BLACKMARKET then
            mod.playDecoration(mod.randomCorner(decorations.rotgut, sprite, i, false, false, true), spriteRoot)

        --finally, plain backgrounds
        else
            mod.playDecoration(mod.randomBG(decorations.rotgut, sprite, i, false, roomHeight), spriteRoot)

        end
    end

    --14 is the edge wall, so render a squished wall that doesnt stick out over the edge
    ent = room:GetGridEntity(rightGridID)
    sprite = ent:GetSprite()
    sprite:Load(spriteRoot.."bg.anm2", true)
    sprite:Play("rightwall", true)

    if doLegacyVignettes then
        local vignette = Sprite()
        vignette:Load(VIGNETTE_SPRITESHEET_PATH, true)
        vignette:Play("rotgut", true)
        mod.saveAnimationData(mod.newDecoration("vignette", "vignette", {}, {}, vignette, 0, 0))
        table.insert(toRender, vignette)
    end
end


--responsible for kickstarting the process of replacing sprites, figuring out what room it is.
function mod:identifyRoom()
    local room = game:GetRoom()
    local backdrop = room:GetBackdropType()

    --clear any lingering variables at the start of each room
    animations = nil
    animations = {}
    toRender = nil
    toRender = {}
    replaced = false
    trapdoorOpenAmount = 1

    --update this value every new room just to keep it up to date, since player counts dont tend to change much within the same room
    players = mod.getPlayers()

    --still check for and replace fiendfolio spritesheets, just don't decorate them
    if modConfigSettings.simpleModeEnabled then
        if FiendFolio and backdrop == BackdropType.DUNGEON then
            local suffix = FiendFolio:getCrawlspaceBackdropSuffix()
            FiendFolio.scheduleForUpdate(function()
                FiendFolio.ReplaceCrawlspaceTileGfx('gfx/grid/crawlspaces/fiendfolio_compat/' .. suffix .. '/tiles_itemdungeon_' .. suffix .. '.png')
            end,
            2, ModCallbacks.MC_INPUT_ACTION, false)
        end

        return
    end

    if backdrop == BackdropType.DUNGEON_ROTGUT then
        mod.replaceRotgutSprites(ROTGUT_SPRITESHEET_ROOT)
        return
    elseif backdrop == BackdropType.DUNGEON_GIDEON then
        mod.replaceDungeonSprites(GIDEON_SPRITESHEET_ROOT, decorations.dungeon)
        return
    elseif backdrop ~= BackdropType.DUNGEON then return end
    --handle regular crawlspaces below
    local decorTable = decorations.dungeon
    local spriteRoot = DUNGEON_SPRITESHEET_ROOT

    --fiend folio uses a different system for timing its sprite replacement
    if FiendFolio then
        --get the type of backdrop this crawlspace has
        local suffix = FiendFolio:getCrawlspaceBackdropSuffix()
        decorTable = decorations[suffix]

        --if the suffix is not default then change the spritesheet root to that variant's details spritesheet
        if suffix ~= "default" then spriteRoot = "gfx/grid/crawlspaces/fiendfolio_compat/" .. suffix .. "/" end

        --this is nabbed straight from the FF code, i don't completely understand how it works internally but it's how they trigger their sprite replacement so it's how i'm gonna do it
        FiendFolio.scheduleForUpdate(function()
            --first call the FF crawlspace tile replace fuction with spritesheets that are compatable with this mod's crawlspace anm2. hopefully i'm not messing with anything by stealing their methods like this :D
            FiendFolio.ReplaceCrawlspaceTileGfx('gfx/grid/crawlspaces/fiendfolio_compat/' .. suffix .. '/tiles_itemdungeon_' .. suffix .. '.png')
            --then call my function to replace sprites
            CrawlspacesRebuilt.replaceDungeonSprites(spriteRoot, decorTable)
        end,
        2, ModCallbacks.MC_INPUT_ACTION, false)
        return
    end

    --call the function to start replacing crawlspaces
    mod.replaceDungeonSprites(spriteRoot, decorTable)
end


--this function updates animations every frame to make them advance, and handles the triggering of random idle animations.
--functions dedicated to conditionally triggering animations should also be called from here
function mod:updateAnimations()

    --don't waste time with any of this if the room isn't a crawlspace
    if not mod.isAnyCrawlspace() then
        return
    end

    for i,decoration in ipairs(animations) do
        local sprite = decoration.sprite
        local name = decoration.name
        local animCount = decoration.animCount
        local position = decoration.position
        local isRotgut = mod.isRotgutCrawlspace()

        local float = animRNG:RandomFloat()

        if not sprite:IsFinished() then
            sprite:Update()
        end

        --formatted to break animations up into the original animation name, constant animation prefix, and then the animation number
        --example: "bgdecor_goob_anim2" divides into 'bgdecor_goob', '_anim' and '2'
        --in order to avoid animations triggering to often, animations should be ~150 frames long at least
        if sprite:IsFinished() and float < IDLE_ANIMATION_TRIGGER_CHANCE and animCount ~= 0 then
            local int = animRNG:RandomInt(animCount)+1
            sprite:Play(name .. "_anim" .. int, true)

        --special case for the hatch
        elseif name == "hatch" and not isRotgut then
            mod.animateHatch(sprite, position)

        --special case for poops
        elseif name == "poop" and not isRotgut then
            mod.animatePoop(sprite, position)

        --special case for spikes
        elseif name == "spikes" and not isRotgut then
            mod.animateSpikes(sprite, position)
        end

        --make sure appropriate sfx are played when the rotgut trapdoor spits you out
        if name == "hatch" and isRotgut then
            mod.playRotgutTrapdoorSFX(sprite)
        end
    end
end


function mod.animateSpikes(sprite, position)
    local room = game:GetRoom()
    local ent = room:GetGridEntity(position):ToSpikes()
    if ent == nil then return end --if the entity wasn't a spike. for some reason.
    local timeout = ent.Timeout
    local state = ent.State

    --indicates the spikes are about to go in/out
    --idk why the spike animation doesn't start at 1 but like. thats cool ig
    if timeout == 5 then
        --this may break on spikes with an incredibly short timeout, but i don't think that ever occurs naturally so idc
        --state 1 means the spike is currently retracted
        if state == 1 then
            sprite:Play("spikes_summon")
        else
            sprite:Play("spikes_unsummon")
        end
    end
end


--for triggering the animations of the hatch,
function mod.animateHatch(sprite, position)
    if players == nil then players = mod.getPlayers() end
    local room = game:GetRoom()
    local roomWidth = room:GetGridWidth()

    --check if any player is in the vicinity that should trigger the opening animation
    local shouldOpen = false
    for i,v in ipairs(players) do
        local playerGridPos = room:GetGridIndex(v.Position)
        --if a player is within the 3 tiles underneath the trapdoor
        if playerGridPos <= position or playerGridPos == position+roomWidth then
            shouldOpen = true
        end
    end

    --only attempt to start an animation if it has finished an animation of the opposite state already
    if shouldOpen and (sprite:IsFinished("closing") or sprite:IsFinished("closed")) then
        sprite:Play("opening", false)
    elseif shouldOpen == false and (sprite:IsFinished("opening") or sprite:IsFinished("opened")) then
        sprite:Play("closing", false)
    end

    --trigger sound effects
    if sprite:IsEventTriggered("close") and modConfigSettings.trapdoorsEnabled then
        sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 0.55, 2, false, 0.85, -0.3)
    elseif sprite:IsEventTriggered("open") and modConfigSettings.trapdoorsEnabled then
        sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.7, 2, false, 0.7, -0.5)
    end

    --dim/brighten that value that gets passed into shaders
    if sprite:IsPlaying("closing") or sprite:IsFinished("closing") or sprite:IsFinished("closed") then
        mod.dimTrapdoorLighting()
    elseif sprite:IsPlaying("opening") or sprite:IsFinished("opening") or sprite:IsFinished("opened") then
        mod.brightenTrapdoorLighting()
    end
    --isaac.ConsoleOutput("trapdoor brightness is "..trapdoorOpenAmount.."\n")
end


-- for shaders
function mod.dimTrapdoorLighting()
    trapdoorOpenAmount = math.max(0, trapdoorOpenAmount - (TRAPDOOR_DIMMING_PER_SECOND/60))
end


function mod.brightenTrapdoorLighting()
    trapdoorOpenAmount = math.min(1, trapdoorOpenAmount + (TRAPDOOR_BRIGHTENING_PER_SECOND/60))
end


--replace poop sprites to fit in with its environment
--poop uses the state values 0, 250, 500, 750 and 1000 to determine how broken it is. 1000 is completely broken
function mod.animatePoop(sprite, position)
    local room = game:GetRoom()
    local ent = room:GetGridEntity(position)
    local state = ent.State
    local name = "poop_" .. state

    --if the sprite is playing or has already played the animation for this state, don't keep playing that animation over and over again
    if sprite:IsPlaying(name) or sprite:IsFinished(name) then
        return
    end

    sprite:Play(name, true)
end


--plays sound effects for the rotgut trapdoor as it spits you out
function mod.playRotgutTrapdoorSFX(sprite)

    --skip over if no animation is playing to trigger sfx
    if sprite:IsFinished() then
        return
    end

    if sprite:IsEventTriggered("close") then
        sfx:Play(SoundEffect.SOUND_MEATHEADSHOOT, 0.7, 2, false, 0.85)
    elseif sprite:IsEventTriggered("spit") then
        sfx:Play(SoundEffect.SOUND_FAT_WIGGLE, 1, 2, false, 0.85)
    end
end


--most sprites here are simply leeching off of an already existing sprite object and don't need manual rendering.
--when rendering vignette and fog, the texture should be 480x272 (game dimensions) and they should be rendered at 240,136 (screen center)
function mod:render()

    --don't waste time with any of this if the room isn't a crawlspace
    if not mod.isAnyCrawlspace() then return end

    --get the screen center position
    --this messes up bigtime in big rooms when playing at a wierd resolution but i cant be arsed to fix that
    local roomCenter = Vector(isaac.GetScreenWidth()/2, isaac.GetScreenHeight()/2)

    for i,v in ipairs(toRender) do
        --if rendering a vignette render at the center of the screen
        if v:GetFilename() == VIGNETTE_SPRITESHEET_PATH then
            v:Render(roomCenter)
        end
    end
end


function mod:applyGravity()

    --don't run this outside of crawlspaces
    if not mod.isAnyCrawlspace() then return end

    local room = game:GetRoom()
    if players == nil then players = mod.getPlayers() end

    --check if the player has the apply gravity flag. and that the current room is a crawlspace.
    for _,player in pairs(players) do
        local flags = player:GetEntityFlags()
        local entUnderFeet = room:GetGridEntityFromPos(player.Position)
        if entUnderFeet == nil then return end
        local type = entUnderFeet:GetType()

        --if the player doesn't have gravity already, and they are NOT standing on a ladder (and gravity settings are enabled)
        if flags & EntityFlag.FLAG_APPLY_GRAVITY ~= EntityFlag.FLAG_APPLY_GRAVITY and type ~= GridEntityType.GRID_DECORATION and modConfigSettings.doGravityOnWalkableTiles then
            --will this get sketchy if players leave the room? i don't think so.
            player:AddEntityFlags(EntityFlag.FLAG_APPLY_GRAVITY)
        end
    end
end


--nitpicky, but since there are a few ways to spawn poops during a room this feels necessary
function mod:postPoopEntitySpawned(ent)
    --i was so damn close to forgetting this check before release oh my god
    if not mod.isAnyCrawlspace() then return end

    if ent:GetType() == GridEntityType.GRID_POOP then
        mod.playPoop(ent, ent:GetGridIndex(), ent:GetSprite(), mod.getSpriteRoot(), true)
    end
end

function mod:itemDungeonVignetteShader()
    local room = game:GetRoom()
    local screenCenter = room:GetCenterPos()
    local time = isaac.GetFrameCount()
    local pos = isaac.WorldToRenderPosition(isaac.GetPlayer().Position) + room:GetRenderScrollOffset()

    --display the crawlspace shader if the current room is a crawlspace and shaders are enabled
    local configStrength = shaderStrength
    --if shaders are disabled, override this to 0
    if (not doShaders) or (not mod.isNonRotgutCrawlspace()) then configStrength = 0 end

    return {
        ModConfigStrength = configStrength,
        ScreenCenter = {screenCenter.X, screenCenter.Y},
        Time = time,
        TrapdoorOpenAmount = trapdoorOpenAmount,
        PlayerPosition = {pos.X, pos.Y},
    }
end

function mod:rotgutDungeonVignetteShader()
    local room = game:GetRoom()
    local time = isaac.GetFrameCount()
    local pos = isaac.WorldToRenderPosition(isaac.GetPlayer().Position) + room:GetRenderScrollOffset()

    local configStrength = shaderStrength

    if (not doShaders) or (not mod.isRotgutCrawlspace()) then configStrength = 0 end

    return {
        ModConfigStrength = configStrength,
        Time = time,
        PlayerPosition = {pos.X, pos.Y}
    }
end

TR_Manager:RegisterShaderFunction(mod, "itemDungeonVignette", mod.itemDungeonVignetteShader)
TR_Manager:RegisterShaderFunction(mod, "rotgutDungeonVignette", mod.rotgutDungeonVignetteShader)

--CALLBACKS

if REPENTOGON then
    mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, mod.identifyRoom)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.updateAnimations)
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.applyGravity) --post render because gravity needs to be applied 60 times per second ig?
    mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.render)
    --mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.debugTrigger, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadConfigSettings)
    mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, mod.postPoopEntitySpawned)
else
    isaac.ConsoleOutput("WARNING: Crawlspaces Rebuilt requires REPENTOGON!!! The mod won't do anything without it so go install it!!! (pretty please)\n")
end