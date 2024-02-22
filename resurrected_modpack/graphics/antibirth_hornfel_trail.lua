local mod = require("resurrected_modpack.mod_reference")
mod.CurrentModName = "Antibirth Hornfel Trail"

-- some code from epiphany, except i was the one who wrote that code so it's fine lol

local TRAIL_SHADOWS = 8
local TRAIL_TRANSPARENCY = 0.3

local function legalAnimation(anim)
    return anim == "ChargeDown"
    or anim == "ChargeLeft"
    or anim == "ChargeRight"
    or anim == "ChargeUp"
end

---@param hornfel EntityNPC
function mod:RenderHornfelTrail(hornfel)
    local sprite = hornfel:GetSprite()
    local data = hornfel:GetData()
    local trailPoints = data.HornfelTrailPoints
    if not trailPoints then
        data.HornfelTrailPoints = {}
        trailPoints = data.HornfelTrailPoints
    end

    if legalAnimation(sprite:GetAnimation()) and hornfel.Visible then
        -- enable trail

        for i = 1, TRAIL_SHADOWS do
            local point = trailPoints[i]
            if not point then
                break
            end

            for _, minecart in ipairs(Isaac.FindByType(EntityType.ENTITY_MINECART)) do
                if minecart.Type == EntityType.ENTITY_MINECART and minecart.Position:Distance(hornfel.Position) < 1 then
                    -- do the trail for you, too
                    local dummySprite = Sprite()
                    local minecartSprite = minecart:GetSprite()
                    dummySprite:Load(minecartSprite:GetFilename(), true)
                    dummySprite:SetFrame(minecartSprite:GetAnimation(), minecartSprite:GetFrame())
                    dummySprite.Color = Color(1, 1, 1, TRAIL_TRANSPARENCY)

                    dummySprite:Render(Isaac.WorldToScreen(point))
                    break
                end
            end

            local dummySprite = Sprite()
            dummySprite:Load(sprite:GetFilename(), true)
            dummySprite:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
            dummySprite.Color = Color(1, 1, 1, TRAIL_TRANSPARENCY)

            dummySprite:Render(Isaac.WorldToScreen(point))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.RenderHornfelTrail, EntityType.ENTITY_HORNFEL)

---@param hornfel EntityNPC
function mod:UpdateHornfelTrail(hornfel)
    local sprite = hornfel:GetSprite()
    local data = hornfel:GetData()
    local trailPoints = data.HornfelTrailPoints
    if not trailPoints then
        data.HornfelTrailPoints = {}
        trailPoints = data.HornfelTrailPoints
    end

    if legalAnimation(sprite:GetAnimation()) then
        table.insert(trailPoints, 1, hornfel.Position)
    end

    -- Clear old enough trails points
    if #trailPoints > TRAIL_SHADOWS then
        for i = 9, #trailPoints do
            trailPoints[i] = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UpdateHornfelTrail, EntityType.ENTITY_HORNFEL)