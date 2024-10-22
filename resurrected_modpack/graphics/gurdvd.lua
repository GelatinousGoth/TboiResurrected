local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Gurdvd", 1)

local game = Game()
local getAngleDiv = function(a,b)
    local r1,r2
    if a > b then
        r1,r2 = a-b, b-a+360
    else
        r1,r2 = b-a, a-b+360
    end
    return r1>r2 and r2 or r1
end

local colorname = {" Red"," Yellow", " Green", " Blue"}

---@param ent EntityNPC
local function testcolor(_,ent)
    if ent.State == 8 then
        local data = ent:GetData()
        local preangle = ent.Velocity:GetAngleDegrees()
        data.Mod5361_MoveAngle = data.Mod5361_MoveAngle or ent.Velocity:GetAngleDegrees()
        if getAngleDiv(data.Mod5361_MoveAngle, preangle) > 10 then
            data.Mod5361_AnimNum = data.Mod5361_AnimNum or 1
            data.Mod5361_AnimNum = (data.Mod5361_AnimNum % #colorname) + 1
            data.Mod5361_AnimName = "Slide"..colorname[data.Mod5361_AnimNum]
    
        end
        data.Mod5361_MoveAngle = preangle
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, testcolor, EntityType.ENTITY_GURDY_JR)

local function rendertestcolor(_, ent, oofset)
    if ent.State == 8 then
        local data = ent:GetData()
        local spr = ent:GetSprite()
        if data.Mod5361_AnimName and spr:GetAnimation() == "Slide" then
            if game:GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
                oofset = Vector(0,0)
            end
            local spr = ent:GetSprite()
            local preanim = spr:GetAnimation()
            spr:SetAnimation(data.Mod5361_AnimName, false)
            spr:Render(Isaac.WorldToScreen(ent.Position + ent.PositionOffset) + oofset)
            spr:SetAnimation(preanim, false)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, rendertestcolor, EntityType.ENTITY_GURDY_JR)