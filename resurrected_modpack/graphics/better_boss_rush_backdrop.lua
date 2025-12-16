local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Better Boss Rush Backdrop", 1)

local game = Game()
local backdropRNG = RNG()
backdropRNG:SetSeed(Random(), 3)
local api = {}

function api.Random(min, max, rng)
    rng = rng or backdropRNG
    if min ~= nil and max ~= nil then
        return math.floor(rng:RandomFloat() * (max - min + 1) + min)
    elseif min ~= nil then
        return math.floor(rng:RandomFloat() * (min + 1))
    end
    return rng:RandomFloat()
end

local function changeBackdrop(backdrop)
    backdropRNG:SetSeed(Game():GetRoom():GetDecorationSeed(), 0)
    local backdropVariant = backdrop
    for i = 1, 2 do
        local npc = Isaac.Spawn(EntityType.ENTITY_EFFECT, 82, 0, Vector(0, 0), Vector(0, 0), nil)
        local sprite = npc:GetSprite()
        sprite:Load("gfx/backdrop/custom/backdrop.anm2", true)
        for num=0, 15 do
            local wall_to_use = backdropVariant.WALLS[api.Random(1, #backdropVariant.WALLS)]
            sprite:ReplaceSpritesheet(num, wall_to_use)
        end
        local nfloor_to_use = backdropVariant.NFLOORS[api.Random(1, #backdropVariant.NFLOORS)]
        local lfloor_to_use = backdropVariant.LFLOORS[api.Random(1, #backdropVariant.LFLOORS)]
        local corner_to_use = backdropVariant.CORNERS[api.Random(1, #backdropVariant.CORNERS)]
        sprite:ReplaceSpritesheet(16, nfloor_to_use)
        sprite:ReplaceSpritesheet(17, nfloor_to_use)
        sprite:ReplaceSpritesheet(18, lfloor_to_use)
        sprite:ReplaceSpritesheet(19, lfloor_to_use)
        sprite:ReplaceSpritesheet(20, lfloor_to_use)
        sprite:ReplaceSpritesheet(21, lfloor_to_use)
        sprite:ReplaceSpritesheet(22, lfloor_to_use)
        sprite:ReplaceSpritesheet(23, corner_to_use)
        npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(260,0)
        if Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x1 then sprite:Play("1x1_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IH then sprite:Play("IH_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IV then
            sprite:Play("IV_room", true)
            npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(113,0)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_1x2 then sprite:Play("1x2_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IIV then
            sprite:Play("IIV_room", true)
            npc.Position = Game():GetRoom():GetTopLeftPos()+Vector(113,0)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x1 then sprite:Play("2x1_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_IIH then sprite:Play("IIH_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then sprite:Play("2x2_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LTL then sprite:Play("LTL_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LTR then sprite:Play("LTR_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LBL then sprite:Play("LBL_room", true)
        elseif Game():GetRoom():GetRoomShape() == RoomShape.ROOMSHAPE_LBR then sprite:Play("LBR_room", true) end
        sprite:LoadGraphics()
        if i == 1 then
        npc:ToEffect():AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
        end
    end
end

local arena = {
    NFLOORS = {"gfx/backdrop/custom/arena_nfloor.png"},
    LFLOORS = {"gfx/backdrop/custom/arena_lfloor.png"},
    CORNERS = {"gfx/backdrop/custom/null.png"},
    WALLS = {
        "gfx/backdrop/custom/arena_1.png",
        "gfx/backdrop/custom/arena_2.png",
        "gfx/backdrop/custom/arena_3.png",
        "gfx/backdrop/custom/arena_4.png",
        "gfx/backdrop/custom/arena_5.png",
        "gfx/backdrop/custom/arena_6.png"
    }
}

if StageAPI then
    local arenaBackdrop = StageAPI.BackdropHelper({
        NFloors = {"nfloor"},
        LFloors = {"lfloor"},
        Walls = {"1", "2", "3", "4", "5", "6"}
    }, "gfx/backdrop/custom/arena_", ".png")

    arena = StageAPI.RoomGfx(arenaBackdrop, nil)

    function changeBackdrop(backdrop)
        StageAPI.ChangeRoomGfx(backdrop)
    end
end

function mod:MC_POST_NEW_ROOM()
	-- boss rush backdrop change code
	if Game():GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
	    changeBackdrop(arena)
	end
end

local DEFAULT_BOSS_RUSH_GRID = "gfx/grid/rocks_sheol.png"
local BOSS_RUSH_GRID_PATH = "gfx/grid/rocks_sheol.png"

local function SpriteReplace(_, layerID, pngFileName)
    if pngFileName == DEFAULT_BOSS_RUSH_GRID and Game():GetRoom():GetType() == RoomType.ROOM_BOSSRUSH then
        return {layerID, BOSS_RUSH_GRID_PATH}
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.MC_POST_NEW_ROOM)
mod:AddCallback(ModCallbacks.MC_PRE_REPLACE_SPRITESHEET, SpriteReplace)