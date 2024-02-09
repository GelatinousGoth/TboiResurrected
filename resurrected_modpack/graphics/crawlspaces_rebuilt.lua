local mod = require("resurrected_modpack.mod_reference")
mod.CurrentModName = "crawlspaces_rebuilt"

local this = {}

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
local DUNGEON_SPRITESHEET_ROOT = "gfx/content/dungeon_details.anm2"
local GIDEON_SPRITESHEET_ROOT = "gfx/content/gideon_details.anm2"
local ROTGUT_SPRITESHEET_ROOT = "gfx/content/rotgut_details.anm2"
local VIGNETTE_ROOT = "gfx/content/vignette.anm2"
--rng shenanigans
local RECOMMENDED_SHIFT_IDX = 35
local IDLE_ANIMATION_TRIGGER_CHANCE = 0.01 --may want to be lowered or raised as more animations are added.
--random big numbers used to assign certain sprites to a gravity tile.
--hopefully nothing else changes the vardata value of random gravity tiles
local POOP_VARDATA_FLAG = 5801

local game = Game()
local isaac = Isaac --i hate capital letters!!! i love camelCase!!!!!!
local decorRNG = RNG()
local animRNG = RNG()
local sfx = SFXManager()

local animations = {}
local toRender = {}
local spritesheet = ""
local players

--decoration animation type tables
--entries are weighed and assigned an additional chance value on program start
local bgTable = { --shared between rotgut and normal crawlspaces
    {name = "1", weight = 1},
    {name = "2", weight = 1},
    {name = "3", weight = 1},
    {name = "4", weight = 1}
}
local bgDecorTable = {
    {name = "goob", weight = 1},
    {name = "guys", weight = 1},
    {name = "penta", weight = 1},
    {name = "troll", weight = 0.01} --nothing to see here
}
local cornerTable = { --shared between rotgut and normal crawlspaces
    {name = "1", weight = 4},
    {name = "2", weight = 1}
}
local edgeTable = {
    {name = "1", weight = 1}
}
local ceilingTable = {
    {name = "lip1", weight = 4},
    {name = "lip2", weight = 4},
    {name = "web1", weight = 1},
    {name = "web2", weight = 1},
    {name = "web3", weight = 1},
    {name = "web4", weight = 1}
}
local rotCeilingTable = {
    {name = "web1", weight = 1},
    {name = "web2", weight = 1},
    {name = "web3", weight = 1},
    {name = "web4", weight = 1}
}
local floorTable = {
    {name = "pebble1", weight = 1},
    {name = "pebble2", weight = 1},
    {name = "pebble3", weight = 1}
}


--supply a main table with a list of decoration tables, calculates a chance value for each entry based on their weight values
function this.weighTable(table)
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
--weigh out all the tables
bgTable = this.weighTable(bgTable)
bgDecorTable = this.weighTable(bgDecorTable)
cornerTable = this.weighTable(cornerTable)
edgeTable = this.weighTable(edgeTable)
ceilingTable = this.weighTable(ceilingTable)
rotCeilingTable = this.weighTable(rotCeilingTable)
floorTable = this.weighTable(floorTable)


--returns a table containing all players
function this.getPlayers()
    local playerCount = game:GetNumPlayers()
    local players = {}
    local player

    for i = 0, playerCount-1 do
        player = isaac.GetPlayer(i)
        table.insert(players, player)
    end

    return players
end


--renders whatever "debugTxt" is set to every frame on screen
--TODO: comment out callback before release and/or forget about this and nobody will ever know
local debugTxt = ""
function mod:renderDebugTxt()
    isaac.RenderText(debugTxt, 50, 50, 1, 1, 1, 1)
end


--runs whenever butter bean is used, for debug & testing purposes
--callback should be commented out when not in use
function mod:debugTrigger()
    local room = game:GetRoom()
    local player = isaac.GetPlayer()
    local playerGridPos = room:GetGridIndex(player.Position)
    local ent = room:GetGridEntity(playerGridPos)

    debugTxt = tostring(ent:GetVariant())

    ent:Destroy(true)
end



--DECORAITON PROCESSING


--adds a new object to the animations table with .sprite, .name, .animCount and .gridPos values.
--note that name isn't always equal to the name of the animation playing, but rather represents a more general term to reference the table entry by.
--setting animCount to 0 will exempt it from random idle animations, and will require a custom function in updateAnimations to trigger them
function this.saveAnimationData(sprite, name, animCount, gridPos)
    local animData = {}

    animData = {sprite = sprite, name = name, animCount = animCount, position = gridPos}
    table.insert(animations, animData)
end


--takes a name and removes anything in the animations table assigned the same name.
--iterates backwards so table.remove can be used without skipping over entries
function this.removeAnimationData(name)
    for i=#animations, 1, -1  do
        local v = animations[i]
        if v.name == name then
            table.remove(animations, i)
        end
    end
end


--checks the top 2 rows of a room for player position which indicates where to display the hatch.
--if no player is found that high, defaults to the usual ladder location in a 1x1 room (happens when exiting a black market or re-entering a run from the menu)
function this.findHatch(room, player, roomWidth)
    local playerGridPos = room:GetGridIndex(player.Position)

    if playerGridPos < (roomWidth*2)-1 then
        return playerGridPos
    end

    return DEFAULT_LADDER_POS
end


--is this tile the decorative tile in gideon's crawlspace (funny little isaac with wings below the key at the top).
function this.isGideonDecor(tile)
    if this.isGideon() and (tile == GIDEON_DECOR_A or tile == GIDEON_DECOR_B) then
        return true
    end

    return false
end


--is the current room gideon's crawlspace?
function this.isGideon()
    if spritesheet == nil then
        return false
    elseif spritesheet == GIDEON_SPRITESHEET_ROOT then
        return true
    end

    return false
end


--is the current room the rotgut arena where you fight the nutsa- the heart?
function this.isHeartRoom(gridRoom)
    if gridRoom == GridRooms.ROOM_ROTGUT_DUNGEON2_IDX then
        return true
    end

    return false
end


--checks if a gridentity is a "shallow" ceiling (only 1 block thick) by taking in the entitytype of the tile above it.
--this does NOT need to be its own function but it keeps replaceDungeonSprites looking tidy so idc
function this.isCeilingShallow(aboveType)
    if aboveType == GridEntityType.GRID_WALL then
        return false
    end

    return true
end


--checks if this tile is in the top row of the room
function this.isTopRow(tile, roomWidth)
    if tile > roomWidth-1 then
        return false
    end

    return true
end


--return the tileentity below's type, or null grid entity if invalid
function this.getGridEntTypeBelow(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth)

    --if invalid, set ent to the last tile on the grid
    if ent == nil then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type to the bottom left of a given tile, or null grid entity if invalid
function this.getGridEntTypeBottomLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth-1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif (tile+1)%roomWidth == 0 then -- is the tile on the right side of the screen (wrapped around)
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type to the bottom right of a given tile, or null grid entity if invalid
function this.getGridEntTypeBottomRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+roomWidth+1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif tile%roomWidth == 0 then --is the tile on the left side of the screen (wrapped around)
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type directly above a given tile, or null grid entity if invalid
function this.getGridEntTypeAbove(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-roomWidth)

    if ent == nil then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity type to the left of a given tile, or null grid entity if invalid
function this.getGridEntTypeLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif (tile+1)%roomWidth == 0 then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end

--return the tileentity variant to the left of a given tile, or -1 if invalid
function this.getGridEntVariantLeft(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile-1)

    if ent == nil then
        return -1
    elseif (tile+1)%roomWidth == 0 then
        return -1
    end

    return ent:GetVariant()
end


--returns the tileentity type to the left of a given tile, or null grid entity if invalid
function this.getGridEntTypeRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+1)

    if ent == nil then
        return GridEntityType.GRID_NULL
    elseif tile%roomWidth == 0 then
        return GridEntityType.GRID_NULL
    end

    return ent:GetType()
end


--return the tileentity variant to the right of a given tile, or -1 if invalid
function this.getGridEntVariantRight(room, tile, roomWidth)
    local ent = room:GetGridEntity(tile+1)

    if ent == nil then
        return -1
    elseif tile%roomWidth == 0 then
        return -1
    end

    return ent:GetVariant()
end


--get a random background column.
--note the gideon anm2 only has tallbg sprites, so make sure you aren't returning short backgrounds in a gideon room
function this.randomBG(noCeiling, roomHeight)
    --iterate the rng and get a number between 0 and 1 from it
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "bg_"

    if roomHeight > SMALLROOM_HEIGHT then
        root = "tallbg_"
    end

    if noCeiling then
        return root .. "noceiling"
    end

    --iterate through the table until the total chance value is higher than float (should never finish without returning something)
    for i,v in ipairs(bgTable) do
        sum = sum + v.chance
        if float < sum then
            return root .. v.name
        end
    end

    --there's no way this ever happens but just in case some wierd rounding makes the loop end without returning, return a default value
    return root .. "1"
end


--get a random background decoration
function this.randomBGDecor()
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "bgdecor_"

    for i,v in ipairs(bgDecorTable) do
        sum = sum + v.chance
        if float < sum then
            return root .. v.name
        end
    end

    return root .. "goob"
end


--get a random corner animation, concave edges between 2 wall tiles.
--side should be a string, "left" or "right"
function this.randomCorner(side, isShallow, isBG)
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "corner_"

    if isBG then
        root = "bgcorner_"
    elseif isShallow then
        root = "shallowcorner_"
    end

    for i,v in ipairs(cornerTable) do
        sum = sum + v.chance
        if float < sum then
            return root .. side ..  v.name
        end
    end

    return root .. side .. "1"
end


--get a random edge animation, sharp convex corners of a single wall tile that stick out and need to be smoothed a lil.
--side should be the string "right" or "left".
function this.randomEdge(side)
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "edge_"

    --only 1 edge sprite for now, still calculate in full for backwards compatability
    for i,v in ipairs(edgeTable) do
        sum = sum + v.chance
        if float < sum then
            return root .. side .. v.name
        end
    end

    return root .. side .. "1"
end


--get a random ceiling decoration, cobwebs and the sort
function this.randomCeiling(isShallow, isRot)
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "ceiling_"
    local table = ceilingTable

    if isShallow then
        root = "shallowceiling_"
    end

    --workaround since rotgut uses its own table for ceiling decorations
    if isRot then
        table = rotCeilingTable
    end

    for i,v in ipairs(table) do
        sum = sum + v.chance
        if float < sum then
            return root .. v.name
        end
    end

    return root .. "lip1"
end


--get a random floor decoration, pebbles and the sort
function this.randomFloor()
    local float = decorRNG:RandomFloat()
    local sum = 0
    local root = "floor_"

    for i,v in ipairs(floorTable) do
        sum = sum + v.chance
        if float < sum then
            return root .. v.name
        end
    end

    return root .. "pebble1"
end


--jumps around the grid and replaces sprites as needed, the main function of the mod
function this.replaceDungeonSprites(gridRoom)
    local room = game:GetRoom()
    local decorSeed = room:GetDecorationSeed()
    local startSeed = game:GetSeeds():GetStartSeed()
    local player = isaac.GetPlayer()

    --getting gridIDs of useful locations
    local roomWidth = room:GetGridWidth()
    local roomHeight = room:GetGridHeight()
    local roomSize = room:GetGridSize()
    local rightGridID = roomWidth - 1
    local hatchGridID =  this.findHatch(room, player, roomWidth)--show trapdoor sprite at player starting position
    local bgNoCeilingGridID = hatchGridID - roomWidth --render a background wall for the ladder on the tile directly above it
    local playerGridPos = room:GetGridIndex(player.Position)

    local isGideon = this.isGideon()

    local ent
    local sprite
    local name

    --set rng
    decorRNG:SetSeed(decorSeed, RECOMMENDED_SHIFT_IDX)
    animRNG:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)

    --start of replacing sprites. most important sprites should be done further down to prevent overriding.
    --this loop handles decorations placed randomly around the grid.
    for i=0,roomSize-1 do
        local float = decorRNG:RandomFloat()
        ent = room:GetGridEntity(i)
        sprite = ent:GetSprite()
        local aboveEnt = room:GetGridEntity(i-roomWidth) --hate declaring this just to barely use it but swagever
        if aboveEnt == nil then aboveEnt = room:GetGridEntity(0) end --wierd default to fall back on, hopefully doesnt cause issues

        --getting the gridEntType of the surrounding area
        local type = ent:GetType()
        local belowType = this.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = this.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = this.getGridEntTypeBottomRight(room, i, roomWidth)
        local aboveType = this.getGridEntTypeAbove(room, i, roomWidth)
        local leftType = this.getGridEntTypeLeft(room, i, roomWidth)
        local rightType = this.getGridEntTypeRight(room, i, roomWidth)

        local leftVariant = this.getGridEntVariantLeft(room, i, roomWidth)
        local rightVariant = this.getGridEntVariantRight(room, i, roomWidth)

        --poops (mostly to account for that one stupid rare crawlspace)
        if type == GridEntityType.GRID_POOP then
            ent:SetVariant(0) --copout solution so i dont have to add sprites for every poop variant
            --TODO: only really matters if a custom room layout uses special poops which isnt too unlikely, may change in the future
            name = "floor_poop" --this name should have the poop's .State value appended onto it to determine which state of decay its animation should show.

            sprite:Load(spritesheet, true)
            sprite:Play(name .. "_0", true)
            this.saveAnimationData(sprite, name, 0, i)

        --the tile below a poop requires a wierd workaround to ensure it looks like a floor
        --doesn't need this workaround for gravity flagged as broken poops, but this keeps the decoration consistent between different re-entries
        elseif (aboveType == GridEntityType.GRID_POOP or aboveEnt.VarData == POOP_VARDATA_FLAG) and belowType ~= GridEntityType.GRID_WALL and type == GridEntityType.GRID_WALL then
            name = this.randomCeiling(true, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        --ensure that poops which were turned into gravity still show up as poop when you leave and re-enter the room
        elseif ent.VarData == POOP_VARDATA_FLAG and type == GridEntityType.GRID_GRAVITY then
            sprite:Load(spritesheet, true)
            sprite:Play("floor_poop")

        --background decorations
        elseif type == GridEntityType.GRID_GRAVITY and float < 0.07 and belowType == GridEntityType.GRID_GRAVITY then
            name = this.randomBGDecor()

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

            --don't add non-animated sprites to the table
            if name ~= "bgdecor_troll" and name ~= "bgdecor_penta" then
                this.saveAnimationData(sprite, name, 2, i)
            end

        --hardcoded special case in gideon's crawlspace to prevent overlapping textures sometimes
        elseif i == GIDEON_DECOR_ADJACENT and isGideon then
            sprite:Load(spritesheet, true)
            sprite:Play("corner_right2", true)

        --check for corners, starting with left and then right
        elseif type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY then
            local isShallow = this.isCeilingShallow(aboveType)
            name = this.randomCorner("left", isShallow, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)
        elseif type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY then
            local isShallow = this.isCeilingShallow(aboveType)
            name = this.randomCorner("right", isShallow, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        --then edges (like corners but convex rather than concave), first left then right. i hate the way these are determined
        elseif type == GridEntityType.GRID_WALL and leftType ~= GridEntityType.GRID_WALL and leftVariant ~= 30 and belowType ~= GridEntityType.GRID_WALL and aboveType == GridEntityType.GRID_WALL and i < (roomWidth*(roomHeight-1)-1) then
            name = this.randomEdge("left")

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)
        elseif type == GridEntityType.GRID_WALL and rightType ~= GridEntityType.GRID_WALL and rightVariant ~= 30 and belowType ~= GridEntityType.GRID_WALL and aboveType == GridEntityType.GRID_WALL and i < (roomWidth*(roomHeight-1)-1) then
            name = this.randomEdge("right")

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        --then ceiling decor
        elseif type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and this.isGideonDecor(i) == false and float < 0.5 then
            local isShallow = this.isCeilingShallow(aboveType)
            name = this.randomCeiling(isShallow, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        --then floor decorations
        elseif type == GridEntityType.GRID_GRAVITY and belowType == GridEntityType.GRID_WALL and float < 0.2 then
            name = this.randomFloor()

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        end
    end

    --black market door
    ent = room:GetGridEntity(BLACKMARKET_DOOR_POS)
    local type = ent:GetType()
    --only replace if the tile is gravity, signaling a black market door
    if type == GridEntityType.GRID_GRAVITY and isGideon == false then
        sprite = ent:GetSprite()

        sprite:Load(spritesheet, true)
        sprite:Play("door", true);
    end

    --handle trapdoor sprite
    ent = room:GetGridEntity(hatchGridID)
    --really sketchy fix, since an error is thrown right here if a crawlspace boots you to an error room
    if ent == nil then
        return
    end
    sprite = ent:GetSprite()
    sprite:Load(spritesheet, true)

    --starts opened if isaac is in the top 2 rows (likely came from above), otherwise starts closed (when entering from black market)
    if playerGridPos < (roomWidth*2)-1 then
        sprite:Play("hatch")
    else
        sprite:Play("hatch_closed")
    end
    --animations each have a distinct purpose and should not be handled with the usual random animation choice.
    this.saveAnimationData(sprite, "hatch", 0, hatchGridID)

    --this loop handles background walls, running along the top of the grid
    for i=0,rightGridID-1 do
        ent = room:GetGridEntity(i)
        local belowType = this.getGridEntTypeBelow(room, i, roomWidth)
        local float = decorRNG:RandomFloat()
        sprite = ent:GetSprite()
        sprite:Load(spritesheet, true)

        if i == bgNoCeilingGridID then
            sprite:Play(this.randomBG(true, roomHeight), true)
        elseif isGideon and i == GIDEON_TOP_EDGE_POS then
            sprite:Play("tallbgedge_left1") --special case in the gideon crawlspace, hardcoded cause im lazy
        elseif isGideon and belowType == GridEntityType.GRID_GRAVITY and float < 0.6 then
            if float < 0.3 then --another special case for gideon spaces, again hardcoded cause im lazy
                sprite:Play("tallbg_lip1", true)
            else
                sprite:Play("tallbg_lip2", true)
            end
        else
            sprite:Play(this.randomBG(false, roomHeight), true)
        end
    end

    --wall on the far right edge sticks out a little, so render a special squished wall that doesnt stick out over the edge
    --im lazy so this doesnt have a tallbg variant, hopefully that's never needed
    ent = room:GetGridEntity(rightGridID)
    sprite = ent:GetSprite()
    sprite:Load(spritesheet, true)
    sprite:Play("bg_rightwall", true)

    --sets up the vignette effect
    local vignette = Sprite()
    vignette:Load(VIGNETTE_ROOT, true)
    vignette:Play("dungeon", true)
    this.saveAnimationData(vignette, "vignette", 0, 0)
    table.insert(toRender, vignette)
end


--replaces sprites around the grid as needed, makes some assumptions based on the rotgut arena always remaining the same
function this.replaceRotgutSprites(gridRoom)
    local room = game:GetRoom()
    local decorSeed = room:GetDecorationSeed()
    local startSeed = game:GetSeeds():GetStartSeed()
    local player = isaac.GetPlayer()

    --getting gridIDs of useful locations
    local roomWidth = room:GetGridWidth()
    local roomHeight = room:GetGridHeight()
    local roomSize = room:GetGridSize()
    local rightGridID = roomWidth - 1

    local isHeartRoom = this.isHeartRoom(gridRoom)

    local ent
    local sprite
    local name

    decorRNG:SetSeed(decorSeed, RECOMMENDED_SHIFT_IDX)
    animRNG:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)

    --main loop for replacing tiles
    for i=0, roomSize-1 do
        local float = decorRNG:RandomFloat()
        ent = room:GetGridEntity(i)
        sprite = ent:GetSprite()

        local type = ent:GetType()
        local aboveType = this.getGridEntTypeAbove(room, i, roomWidth)
        local belowType = this.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = this.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = this.getGridEntTypeBottomRight(room, i, roomWidth)
        local isShallow = this.isCeilingShallow(aboveType) --call out here since this is used for most checks in the loop
        local isTopRow = this.isTopRow(i, roomWidth)

        --make the tiles along the side of the screen actually random, since in vanilla they're normally always the same for some damn reason
        if not isTopRow and ((i+1)%roomWidth == 0 or i%roomWidth == 0) and type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_WALL and i ~= ROTGUT_ABOVE_DOOR_POS then
            local int = decorRNG:RandomInt(3)

            sprite:Load(spritesheet, true)
            sprite:Play("tile", true)
            sprite:SetFrame(int)--did things a bit different here, with 3 different frames for each tile in the same animation

        --check for corners, starting with left and then right
        elseif type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and isShallow == false then
            name = this.randomCorner("left", false, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)
        elseif type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and isShallow == false then
            name = this.randomCorner("right", false, false)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

        --then ceiling decor
        elseif type == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and not isTopRow and  float < 0.4 then
            name = this.randomCeiling(isShallow, true)

            sprite:Load(spritesheet, true)
            sprite:Play(name, true)

            this.saveAnimationData(sprite, name, 1, i) --TODO: if more than 1 animations get made per ceiling decor change this to reflect that
        end
    end

    --handles the top row, where backgrounds are rendered
    for i=0,rightGridID-1 do
        ent = room:GetGridEntity(i)
        sprite = ent:GetSprite()
        sprite:Load(spritesheet, true)

        local type = ent:GetType()
        local belowType = this.getGridEntTypeBelow(room, i, roomWidth)
        local belowLeftType = this.getGridEntTypeBottomLeft(room, i, roomWidth)
        local belowRightType = this.getGridEntTypeBottomRight(room, i, roomWidth)

        --handle the hatch first
        if i == ROTGUT_TRAPDOOR_POS and isHeartRoom == false then
            sprite:Play("hatch", true)
            this.saveAnimationData(sprite, "hatch", 2, i)

        elseif (i == ROTGUT_TRAPDOOR_POS+1 or i == ROTGUT_TRAPDOOR_POS-1) and isHeartRoom == false then
            --dont render anything here, not sure if i like this way of going about it though

        --now corners
        elseif type == GridEntityType.GRID_WALL and belowLeftType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY then
            name = this.randomCorner("left", false, true)
            sprite:Play(name, true)
        elseif type == GridEntityType.GRID_WALL and belowRightType == GridEntityType.GRID_WALL and belowType == GridEntityType.GRID_GRAVITY and i ~= TILE_ABOVE_BLACKMARKET then
            name = this.randomCorner("right", false, true)
            sprite:Play(name, true)

        else
            name = this.randomBG(false, roomHeight)
            sprite:Play(name, true)
            --if the bg has animations add it to the table.
            if name ~= "bg_1" and name ~= "bg_3" then
                this.saveAnimationData(sprite, name, 2, i)
            end
        end
    end

    --14 is the edge wall, so render a squished wall that doesnt stick out over the edge
    ent = room:GetGridEntity(rightGridID)
    sprite = ent:GetSprite()
    sprite:Load(spritesheet, true)
    sprite:Play("bg_rightwall", true)

    local vignette = Sprite()
    vignette:Load(VIGNETTE_ROOT, true)
    vignette:Play("rotgut", true)
    this.saveAnimationData(vignette, "vignette", 0, 0)
    table.insert(toRender, vignette)
end


--responsible for kickstarting the process of replacing sprites, figuring out what room it is.
function mod:identifyRoom()
    local level = game:GetLevel()
    local room = game:GetRoom()
    local roomDesc = level:GetCurrentRoomDesc()
    local gridRoom = roomDesc.SafeGridIndex

    --clear any lingering variables at the start of each room
    animations = nil
    animations = {}
    toRender = nil
    toRender = {}
    spritesheet = ""

    --update this value every new room just to keep it up to date, since player counts dont tend to change much within the same room
    players = this.getPlayers()

    if gridRoom == GridRooms.ROOM_ROTGUT_DUNGEON1_IDX or gridRoom == GridRooms.ROOM_ROTGUT_DUNGEON2_IDX then
        spritesheet = ROTGUT_SPRITESHEET_ROOT
        this.replaceRotgutSprites(gridRoom)
        return
    elseif gridRoom == GridRooms.ROOM_DUNGEON_IDX then
        spritesheet = DUNGEON_SPRITESHEET_ROOT
    elseif gridRoom == GridRooms.ROOM_GIDEON_DUNGEON_IDX then
        spritesheet = GIDEON_SPRITESHEET_ROOT
    else
        return
    end

    this.replaceDungeonSprites(gridRoom)
end


--this function updates animations every frame to make them advance, and handles the triggering of random idle animations.
--functions dedicated to conditionally triggering animations should also be called from here
function mod:updateAnimations()

    --don't waste time with any of this if the room isn't a crawlspace
    if spritesheet == "" then
        return
    end

    for i,v in ipairs(animations) do
        local sprite = v.sprite
        local name = v.name
        local animCount = v.animCount
        local position = v.position

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
        elseif name == "hatch" and spritesheet ~= ROTGUT_SPRITESHEET_ROOT then
            this.animateHatch(sprite, position)

        --special case for poops
        elseif name == "floor_poop" and spritesheet ~= ROTGUT_SPRITESHEET_ROOT then
            this.animatePoop(sprite, position)
        end

        --make sure appropriate sfx are played when the rotgut trapdoor spits you out
        if name == "hatch" and spritesheet == ROTGUT_SPRITESHEET_ROOT then
            this.playRotgutTrapdoorSFX(sprite)
        end
    end
end


--for triggering the animations of the hatch,
function this.animateHatch(sprite, position)
    if players == nil then players = this.getPlayers() end
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
    if shouldOpen and (sprite:IsFinished("hatch_close") or sprite:IsFinished("hatch_closed")) then
        sprite:Play("hatch_open", false)
    elseif shouldOpen == false and (sprite:IsFinished("hatch_open") or sprite:IsFinished("hatch")) then --"hatch" is the default animation, basically just "hatch_opened"
        sprite:Play("hatch_close", false)
    end

    --trigger sound effects
    if sprite:IsEventTriggered("close") then
        sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 0.55, 2, false, 0.85, -0.3)
    elseif sprite:IsEventTriggered("open") then
        sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.7, 2, false, 0.7, -0.5)
    end
end


--replace poop sprites to fit in with its environment, and applies gravity to broken poop spaces.
--poop uses the state values 0, 250, 500, 750 and 1000 to determine how broken it is. 1000 is completely broken
function this.animatePoop(sprite, position)
    local room = game:GetRoom()
    local ent = room:GetGridEntity(position)
    local state = ent.State
    local name = "floor_poop_" .. state

    --if the sprite is playing or has already played the animation for this state, don't keep playing that animation over and over again
    if sprite:IsPlaying(name) or sprite:IsFinished(name) then
        return
    end

    sprite:Play(name, true)

    --vanilla improvement- if the poop is destroyed apply gravity to the tile where it used to be
    --overwrites the poop gridentity with gravity, so any characteristics of the poop are lost
    --uses vardata flags to signal that the broken poop visual should still be loaded in its previous position after room re-entry
    if state == 1000 then
        local pos = room:GetGridPosition(position)
        --remove any reference to the poop's sprite data before it causes problems
        this.removeAnimationData("floor_poop")
        isaac.GridSpawn(GridEntityType.GRID_GRAVITY, 0, pos, true)
        --i couldn't even hope to understand why but despite the poop seemingly being destroyed already doing this seems to prevent random crashes
        ent:Destroy()
        local grav = room:GetGridEntity(position)
        grav.VarData = POOP_VARDATA_FLAG --flag that this tile used to be poop

        local sprite = grav:GetSprite()
        sprite:Load(spritesheet, true)
        --hardcoded to play the broken poop animation
        sprite:Play("floor_poop_1000", true)
        this.saveAnimationData(sprite, "poop_gravity", 0, position)
    end
end


--plays sound effects for the rotgut trapdoor as it spits you out
function this.playRotgutTrapdoorSFX(sprite)

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
    if spritesheet == "" then return end

    --also update screen center position
    local room = game:GetRoom()
    local roomCenter = isaac.WorldToScreen(room:GetCenterPos())

    for i,v in ipairs(toRender) do
        --if rendering a vignette render at the center of the screen
        if v:GetFilename() == VIGNETTE_ROOT then
            v:Render(roomCenter)
        end
    end
end



--CALLBACKS


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.identifyRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.updateAnimations)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.render)
--mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.renderDebugTxt)
--mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.debugTrigger, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
