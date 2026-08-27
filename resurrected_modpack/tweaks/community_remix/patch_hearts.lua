--[[##########################################################################
#################################### DATA ####################################
##########################################################################]]--

local TR_Manager = require("resurrected_modpack.manager")

PATCH_GLOBAL = TR_Manager:RegisterMod("Patched Hearts", 1)
PATCH_GLOBAL.VARIANT = Isaac.GetEntityVariantByName("Patched heart")
PATCH_GLOBAL.SUBTYPE = 3320
PATCH_GLOBAL.SPAWN_SFX = Isaac.GetSoundIdByName("PATCHED_HEART_SPAWN")
PATCH_GLOBAL.HEAL_SFX = Isaac.GetSoundIdByName("PATCHED_HEART_HEAL")

local diffLib = require("resurrected_modpack.tweaks.community_remix.difflib")(TRCommunityRemix)


--[[##########################################################################
################################# HEART LOGIC ################################
##########################################################################]]--

local function collect(pickup, player)
    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pickup.Touched = true
    pickup.Velocity = Vector(0,0)

    local sprite = pickup:GetSprite()
    sprite:RemoveOverlay()
    sprite:Play("Collect", true)
    pickup:Die()
    pickup:Update()

    for i=1, (pickup.SubType == 3321 and 2 or 1) do
        if player:GetBrokenHearts() > 0 then
            player:AddBrokenHearts(-1)
            if i==1 then SFXManager():Play(PATCH_GLOBAL.HEAL_SFX, 1, 0) end
        else
            player:AddHearts(1)
            if i==1 then SFXManager():Play(185, 1, 0) end
        end
    end
end

local function OnPickup(_, pickup, collider, low)
    if collider.Type == EntityType.ENTITY_PLAYER and (pickup.SubType == 3320 or pickup.SubType == 3321) then
        local player = collider:ToPlayer()

        if pickup:IsShopItem() then
            pickup.Friction = 100
            pickup.Velocity = Vector(0,0)

            if (player:CanPickRedHearts() or player:GetBrokenHearts() > 0) and player:GetNumCoins() >= pickup.Price then
                player:AddCoins(-pickup.Price)
                pickup.Price = 0

                pickup = pickup:ToPickup()
                pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                pickup.Touched = true

                collect(pickup, player)
            end

            return true
        elseif player:CanPickRedHearts() or player:GetBrokenHearts() > 0 then
            collect(pickup:ToPickup(), player)

            return true
        end
    end

    return nil
end

PATCH_GLOBAL:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, OnPickup, PATCH_GLOBAL.VARIANT)

local function OnUpdate(_, pickup)
    if (pickup.SubType == 3320 or pickup.SubType == 3321) then
        local sprite = pickup:GetSprite()

        if not sprite:IsPlaying("Idle") then
            pickup.Velocity = Vector(0,0)
        end

        if sprite:IsEventTriggered("DropSound") then
            SFXManager():Play(PATCH_GLOBAL.SPAWN_SFX, 1, 0)
        end
    end
end

PATCH_GLOBAL:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, OnUpdate, PATCH_GLOBAL.VARIANT)

--[[##########################################################################
############################### SPAWNING LOGIC ###############################
##########################################################################]]--

local tintedRockDestroyed = false
local tintedRockPos = {}

---@param rock GridEntityRock
function PATCH_GLOBAL:TintedDestroy(rock)
    tintedRockDestroyed = true
    table.insert(tintedRockPos, rock.Position)
end
PATCH_GLOBAL:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, PATCH_GLOBAL.TintedDestroy, GridEntityType.GRID_ROCKT)

---@param pickup EntityPickup
function PATCH_GLOBAL:TintedSpawn(pickup)
    if
        DifficultyManager.GetDifficulty() ~= "Insane" or
        pickup.SubType ~= HeartSubType.HEART_SOUL or
        not tintedRockDestroyed or
        pickup.FrameCount ~= 1 -- Heart spawns before rock is destroyed
    then return end
    local isInRange = false
    -- Unlikely scenario in which another soul heart drops at the exact same time
    for _, pos in ipairs(tintedRockPos) do
        if pickup.Position:Distance(pos) < 10 then
            isInRange = true
            break
        end
    end
    if not isInRange then return end
    pickup:Morph(EntityType.ENTITY_PICKUP, PATCH_GLOBAL.VARIANT, PATCH_GLOBAL.SUBTYPE)
end
PATCH_GLOBAL:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PATCH_GLOBAL.TintedSpawn, PickupVariant.PICKUP_HEART)

function PATCH_GLOBAL:TintedCount()
    if tintedRockDestroyed == true then
        Isaac.CreateTimer(function ()
            tintedRockDestroyed = false
            tintedRockPos = {}
        end, 1, 1, true)
    end
end
PATCH_GLOBAL:AddCallback(ModCallbacks.MC_POST_UPDATE, PATCH_GLOBAL.TintedCount)


--[[##########################################################################
################################## MINIMAPI ##################################
##########################################################################]]--
if MinimapAPI then
    local icons = Sprite()
    icons:Load("gfx/ui/patched_hearts_minimapi_icons.anm2", true)
    MinimapAPI:AddIcon("PatchedHeart", icons, "PatchedHeart", 0)
    MinimapAPI:AddPickup("PatchedHeart", "PatchedHeart", 5, PATCH_GLOBAL.VARIANT, 3320,  nil, "hearts", 10650)
end
