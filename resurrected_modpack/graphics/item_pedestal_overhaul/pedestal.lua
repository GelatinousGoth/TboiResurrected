-- Pedestal
local mod = ItemPedestalOverhaul
local game = Game()

local backdropPedestal = {
	[BackdropType.WOMB] = "womb",
	[BackdropType.UTERO] = "utero",
	[BackdropType.SCARRED_WOMB] = "scarred",
	[BackdropType.BLUE_WOMB] = "bluewomb",
	[BackdropType.SHEOL] = "devil",
	[BackdropType.CATHEDRAL] = "angel",
	[BackdropType.DARKROOM] = "darkroom",
	[BackdropType.CHEST] = "treasure",
	[BackdropType.LIBRARY] = "library",
	[BackdropType.SHOP] = "shop",
    [BackdropType.ISAAC] = "bedroom",
	[BackdropType.BARREN] = "barren",
	[BackdropType.SECRET] = "secret",
    [BackdropType.DICE] = "dice",
	[BackdropType.ARCADE] = "arcade",
	[BackdropType.ERROR_ROOM] = "error",
	[BackdropType.GREED_SHOP] = "shop",
	[BackdropType.SACRIFICE] = "sacrifice",
	[BackdropType.CORPSE] = "corpse",
	[BackdropType.PLANETARIUM] = "planetarium",
	[BackdropType.DARK_CLOSET] = "loot"
}

local roomPedestal = {
    [RoomType.ROOM_TREASURE] = "treasure",
    [RoomType.ROOM_BOSS] = "boss",
    [RoomType.ROOM_MINIBOSS] = "boss",
    [RoomType.ROOM_CHALLENGE] = "ambush",
    [RoomType.ROOM_BOSSRUSH] = "ambush"
}

function mod:Pedestal(pickup)
    local sprite = pickup:GetSprite()

    -- Check Pedestal
    if pickup:IsShopItem()
    or pickup:GetSprite():GetOverlayFrame() ~= 0
    or pickup:GetData().ipo_pedestal then
        return
    end

    pickup:GetData().ipo_pedestal = true

    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local baseType = backdropPedestal[room:GetBackdropType()] or ""
    local roomType = roomPedestal[room:GetType()]

    -- Mortis
    if StageAPI and StageAPI.GetCurrentStage() and StageAPI.GetCurrentStage().Name == "Mortis" then
        baseType = "mortis"
    end

    local pedestalType = baseType

    -- Variants
    if roomType then
        local wombLike = {
            womb = true, utero = true, scarred = true, bluewomb = true, corpse = true, mortis = true
        }

        if self.Config.isVariant and roomType ~= "ambush" and wombLike[baseType] then
            pedestalType = baseType .. roomType
        else
            pedestalType = roomType
        end
    end

    -- Vanilla Pedestal
    local enabled = self.Config[baseType] or self.Config[roomType]
    if pedestalType == "" or not enabled then
        return
    end

    -- Pedestal Change
    for i = 4, 5 do
        pickup:GetSprite():ReplaceSpritesheet(i, "gfx/items/slots/" .. pedestalType .. "_pedestal.png")
    end
    sprite:LoadGraphics()
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.Pedestal, PickupVariant.PICKUP_COLLECTIBLE)