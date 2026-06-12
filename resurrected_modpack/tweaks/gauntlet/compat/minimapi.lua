TheGauntlet.Compat.MinimapAPI = {}

TheGauntlet.Compat.MinimapAPI.GAUNTLET_ROOM_MAP_ICON = "TheGauntlet GauntletRoom"

TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_WINTER = "TheGauntlet Ceres Winter"
TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_SPRING = "TheGauntlet Ceres Spring"
TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_SUMMER = "TheGauntlet Ceres Summer"
TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_AUTUMN = "TheGauntlet Ceres Autumn"



local game = Game()

local gauntletMinimapSprite = Sprite("gfx/gauntlet/ui/gauntlet_minimap_icon.anm2", true)
gauntletMinimapSprite:SetFrame("Idle", 0)

local ceresWinterSprite = Sprite("gfx/gauntlet/ui/ceres_season.anm2", true)
ceresWinterSprite:SetFrame("Idle", 0)
local ceresSpringSprite = Sprite("gfx/gauntlet/ui/ceres_season.anm2", true)
ceresSpringSprite:SetFrame("Idle", 1)
local ceresSummerSprite = Sprite("gfx/gauntlet/ui/ceres_season.anm2", true)
ceresSummerSprite:SetFrame("Idle", 2)
local ceresAutumnSprite = Sprite("gfx/gauntlet/ui/ceres_season.anm2", true)
ceresAutumnSprite:SetFrame("Idle", 3)

TheGauntlet:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function ()
    if MinimapAPI == nil then return end

    MinimapAPI:AddIcon(TheGauntlet.Compat.MinimapAPI.GAUNTLET_ROOM_MAP_ICON, gauntletMinimapSprite)


    MinimapAPI:AddMapFlag(TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_WINTER, function ()
        return TheGauntlet.Items.Ceres.GetSeason() == TheGauntlet.Items.Ceres.Season.WINTER
    end, ceresWinterSprite, "Idle", 0)
    MinimapAPI:AddMapFlag(TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_SPRING, function ()
        return TheGauntlet.Items.Ceres.GetSeason() == TheGauntlet.Items.Ceres.Season.SPRING
    end, ceresSpringSprite, "Idle", 1)
    MinimapAPI:AddMapFlag(TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_SUMMER, function ()
        return TheGauntlet.Items.Ceres.GetSeason() == TheGauntlet.Items.Ceres.Season.SUMMER
    end, ceresSummerSprite, "Idle", 2)
    MinimapAPI:AddMapFlag(TheGauntlet.Compat.MinimapAPI.DEMETER_MAP_FLAG_AUTUMN, function ()
        return TheGauntlet.Items.Ceres.GetSeason() == TheGauntlet.Items.Ceres.Season.AUTUMN
    end, ceresAutumnSprite, "Idle", 3)
end)

---@param dimension Dimension
local function UpdateMinimapIcon(dimension)
    local level = MinimapAPI:GetLevel(dimension)
    if level == nil then return end

    for _, room in ipairs(MinimapAPI:GetLevel(dimension)) do
        if room.Descriptor ~= nil and TheGauntlet.GauntletRoom.IsRoomGauntletRoom(room.Descriptor) then
            room.PermanentIcons = { TheGauntlet.Compat.MinimapAPI.GAUNTLET_ROOM_MAP_ICON }
        end
    end
end

--[[
---@param roomIndex integer
---@param roomConfigRoom RoomConfigRoom
---@param dimension Dimension
TheGauntlet:AddCallback(TheGauntlet.Utility.Callbacks.POST_PLACE_GAUNTLET_ROOM, function (_, roomIndex, roomConfigRoom, dimension)
    if MinimapAPI == nil then return end

    local roomDescriptor = game:GetLevel():GetRoomByIdx(roomIndex, dimension)

    MinimapAPI:AddRoom({
        ID = nil,
        Position = MinimapAPI:GridIndexToVector(roomIndex),
        Shape = RoomShape.ROOMSHAPE_1x1,

        PermanentIcons = { TheGauntlet.Compat.MinimapAPI.GAUNTLET_ROOM_MAP_ICON },
        Dimension = dimension,
        Descriptor = roomDescriptor,
        DisplayFlags = roomDescriptor.DisplayFlags,
        Clear = roomDescriptor.Clear,
    })
end)
]]

TheGauntlet:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE, function (_)
    if MinimapAPI == nil then return end

    MinimapAPI:CheckForNewRedRooms(Dimension.NORMAL)
    MinimapAPI:CheckForNewRedRooms(Dimension.MIRROR)
    UpdateMinimapIcon(Dimension.NORMAL)
    UpdateMinimapIcon(Dimension.MIRROR)
end)

---@param isContinued boolean
TheGauntlet:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE, function (_, isContinued)
    if MinimapAPI == nil then return end

    MinimapAPI:CheckForNewRedRooms(Dimension.NORMAL)
    MinimapAPI:CheckForNewRedRooms(Dimension.MIRROR)
    UpdateMinimapIcon(Dimension.NORMAL)
    UpdateMinimapIcon(Dimension.MIRROR)
end)
--[[
TheGauntlet:AddPriorityCallback(ModCallbacks.MC_POST_HUD_RENDER, CallbackPriority.LATE, function (_)
    if MinimapAPI == nil then return end

    UpdateMinimapIcon(Dimension.NORMAL)
    UpdateMinimapIcon(Dimension.MIRROR)
end)]]