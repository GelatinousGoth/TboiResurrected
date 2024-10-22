local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Reflective Downpour Mirror", 1)

local game = Game()

--[[
    HOW IT WORKS:

    Sprites rendered in MC_PRE_GRID_ENTITY_DOOR_RENDER won't appear behind semi-transparent pixels.
    I make a new door sprite with a 1 opacity background around the door frame.
    Then I render sprites, and since the door frame is the only thing that's fully transparent, it'll crop the sprite correctly.
    I then add the background of the door and the shine afterwards as an EntityEffect.

    THIS IS THE HACKIEST SHIT EVER.
    DO NOT USE THIS TO LEARN ANYTHING.
    THE CODE IS SLOPPY. GO PLAY "THE SHERIFF".
]]

local ONE_TILE = 40
local REFLECTION_RADIUS = ONE_TILE * 1.5

local SHINE_VARIANT = Isaac.GetEntityVariantByName("Downpour Door Shine")

local function reflect(pos, reflectionDirection)
    return pos - 2 * pos:Dot(reflectionDirection) * reflectionDirection
end

local function directionToVector(dir)
    if dir == Direction.LEFT then
        return Vector(1, 0)
    elseif dir == Direction.DOWN then
        return Vector(0, -1)
    elseif dir == Direction.RIGHT then
        return Vector(-1, 0)
    elseif dir == Direction.UP then
        return Vector(0, 1)
    else
        return Vector.Zero
    end
end

local function flipHeadAnimX(dir)
    if dir == Direction.LEFT then
        return "HeadRight"
    elseif dir == Direction.RIGHT then
        return "HeadLeft"
    elseif dir == Direction.UP then
        return "HeadUp"
    elseif dir == Direction.DOWN then
        return "HeadDown"
    end
end

local function getDownpourDoor()
    local room = game:GetRoom()
    for i = DoorSlot.LEFT0, DoorSlot.DOWN1 do
        local door = room:GetDoor(i)
        if door and door.TargetRoomIndex == GridRooms.ROOM_MIRROR_IDX then
            return door
        end
    end
end

local function headLayerNameToPriority(n)
    if n == "head" then
        return 0
    elseif n == "head0" then
        return 1
    elseif n == "head1" then
        return 2
    elseif n == "head2" then
        return 3
    elseif n == "head3" then
        return 4
    elseif n == "head4" then
        return 5
    elseif n == "head5" then
        return 6
    end
end

---@param door GridEntityDoor
function mod:UpdateReflection(door)
    local room = game:GetRoom()
    if room:GetRenderMode() == RenderMode.RENDER_WATER_REFRACT then return end
    if door.TargetRoomIndex ~= GridRooms.ROOM_MIRROR_IDX then return end
    if door:GetSprite():GetAnimation() == "Break" then return end

    for _, ent in ipairs(Isaac.FindInRadius(door.Position, REFLECTION_RADIUS, EntityPartition.BULLET | EntityPartition.EFFECT | EntityPartition.ENEMY | EntityPartition.FAMILIAR | EntityPartition.PICKUP | EntityPartition.PLAYER | EntityPartition.TEAR)) do
        local reflectionDirection = directionToVector(door.Direction)

        -- Don't go in front of mirror
        if reflectionDirection:Dot(door.Position - ent.Position) > 0 then goto continue end
        local clampedPos = room:GetClampedPosition(door.Position, 50)
        local targetPos = Isaac.WorldToScreen(reflect(ent.Position, reflectionDirection) + clampedPos * reflectionDirection)

        local player = ent:ToPlayer()
        if player then

            if player:HasCollectible(CollectibleType.COLLECTIBLE_CHARM_VAMPIRE) then
                goto continue
            end

            player.FlipX = true
            player:RenderGlow(targetPos)
            player:RenderBody(targetPos)

            if not player:IsHeadless() then
                local headSprite = Sprite()
                headSprite.Scale = player.SpriteScale
                headSprite:Load(player:GetSprite():GetFilename(), true)
                headSprite:SetOverlayFrame(flipHeadAnimX(player:GetHeadDirection()), player:GetSprite():GetOverlayFrame())

                local highestPriority = {}

                local headRender = true
                for _, costume in ipairs(player:GetCostumeSpriteDescs()) do
                    for i = 0, costume:GetSprite():GetLayerCount() - 1 do
                        local layerName = costume:GetSprite():GetLayer(i):GetName()
                        if layerName == "head" then
                            headRender = false
                        end

                        local priority = headLayerNameToPriority(layerName)
                        if priority and (not highestPriority[priority] or highestPriority[priority][1] <= costume:GetPriority()) then
                            highestPriority[priority] = {costume:GetPriority(), costume:GetSprite(), i}
                        end
                    end
                end

                if headRender then
                    headSprite:Render(targetPos)
                end

                for i = 0, 6 do
                    local layer = highestPriority[i]
                    if layer then
                        local oldScale = layer[2].Scale
                        local oldAnim, fr = layer[2]:GetAnimation(), layer[2]:GetFrame()
                        layer[2].FlipX = true
                        layer[2].Scale = player.SpriteScale
                        layer[2]:SetFrame(player:GetSprite():GetOverlayAnimation(), headSprite:GetOverlayFrame())
                        layer[2]:RenderLayer(layer[3], targetPos)
                        layer[2]:SetFrame(oldAnim, fr)

                        layer[2].FlipX = false
                        layer[2].Scale = oldScale
                    end
                end
            end

            player:RenderTop(targetPos)
            player.FlipX = false
        else
            local sprite = Sprite()
            local entSprite = ent:GetSprite()
            sprite:Load(entSprite:GetFilename(), false)
            sprite:SetFrame(entSprite:GetAnimation(), entSprite:GetFrame())
            sprite:SetOverlayFrame(entSprite:GetOverlayAnimation(), entSprite:GetOverlayFrame())
            sprite.Rotation = entSprite.Rotation
            sprite.FlipX = not entSprite.FlipX -- mirror reflection
            sprite.FlipY = entSprite.FlipY
            sprite.Scale = entSprite.Scale
            sprite:SetRenderFlags(entSprite:GetRenderFlags())

            sprite.Color = entSprite.Color

            for i = 0, entSprite:GetLayerCount() - 1 do
                local layer = entSprite:GetLayer(i)
                sprite:ReplaceSpritesheet(i, layer:GetSpritesheetPath())
            end

            sprite:LoadGraphics()

            sprite:Render(targetPos)
        end

        ::continue::
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.UpdateReflection)

function mod:AddShine()
    local door = getDownpourDoor()
    if not door then return end

    local background = Isaac.Spawn(EntityType.ENTITY_EFFECT, SHINE_VARIANT, 0, door.Position, Vector.Zero, nil)
    local shine = Isaac.Spawn(EntityType.ENTITY_EFFECT, SHINE_VARIANT, 0, door.Position, Vector.Zero, nil)
    background:GetSprite().Rotation = door:GetSprite().Rotation
    background:GetSprite().Offset = door:GetSprite().Offset
    shine:GetSprite().Rotation = door:GetSprite().Rotation
    shine:GetSprite().Offset = door:GetSprite().Offset

    background:GetSprite():SetFrame("Background", 0)
    shine:GetSprite():SetFrame("Shine", 0)

    background.SortingLayer = SortingLayer.SORTING_DOOR
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AddShine)

function mod:CheckClearShine(shine)
    local door = getDownpourDoor()
    if not door then shine:Remove() return end

    if door:GetSprite():GetAnimation() == "Break" then
        shine:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.CheckClearShine, SHINE_VARIANT)