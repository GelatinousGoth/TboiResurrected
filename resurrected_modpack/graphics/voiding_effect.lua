if DIVIDED_VOID then return end

local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Voiding Effect", 1)
---local REPENTOGON = false

mod.effectAnm2Path = "gfx/DV_voided items.anm2"
mod.PredestralAnm2Path = "gfx/005.100_collectible.anm2"
mod.effectAnm2Anim = "пьедистал"
mod.ItemeffectAnm2Anim = "g1"
mod.ItemeffectRGONAnm2Anim = "gRGON"
mod.EffectVariant = EffectVariant.BATTERY
mod.PurpleColor = Color(0.216, 0.216, 0.216,1, 60/255, 45/255, 70/255)
mod.BlackColor = Color(0,0,0, 1)
mod.AbussColor = Color(0.3,0,0,1, 0.5, 0, 0)

mod.SuckSoundID = Isaac.GetSoundIdByName("appearsmoke01withrevers")

mod.NotRGONListVoidedAltes = {}

local Wtr = 20/13

local function InterpolateAnim(anm,frame,animTabl)
    if anm and frame and animTabl then
        local startdata,enddata
        for i,data in ipairs(animTabl) do
            if frame<data[1] then
                startdata,enddata = animTabl[i-1],data
                break
            end
        end
        if startdata and enddata then
            if enddata[5] then
                local procent = (frame-startdata[1])/(enddata[1]-startdata[1])
                local offset = startdata[2]+(enddata[2]-startdata[2])*procent
                local scale = startdata[3]+(enddata[3]-startdata[3])*procent
                local color = Color(
	            startdata[4].R+(enddata[4].R-startdata[4].R)*procent,
                    startdata[4].G+(enddata[4].G-startdata[4].G)*procent,
                    startdata[4].B+(enddata[4].B-startdata[4].B)*procent,
                    startdata[4].A+(enddata[4].A-startdata[4].A)*procent,
                    startdata[4].RO+(enddata[4].RO-startdata[4].RO)*procent,
                    startdata[4].GO+(enddata[4].GO-startdata[4].GO)*procent,
                    startdata[4].BO+(enddata[4].BO-startdata[4].BO)*procent)
                anm.Offset = offset
                anm.Scale = scale
                anm.Color = color
            else
                anm.Offset = startdata[2]
                anm.Scale = startdata[3]
                anm.Color = startdata[4]
            end
        end
    end
end

local PredisAnim = {
	{0,Vector(0,0),Vector(1.0,1.0),Color(1,1,1,1),true},
	{2,Vector(0,1),Vector(1.2,0.8),Color(0.9,0.9,0.9,1,0.1,0.05,0.14),true},
	{5,Vector(0,-1),Vector(0.8,1.3),Color(0.9,0.9,0.9,1,0.15,0.08,0.2),true},
	{8,Vector(0,-1),Vector(0.7,1.4),Color(0.6,0.6,0.6,0.9,0.15,0.08,0.2),true},
	{9,Vector(0,-2),Vector(0.6,1.6),Color(0.6,0.6,0.6,0.9,0.15,0.08,0.2),true},
	{11,Vector(0,4),Vector(1.0,0.8),Color(0.6,0.6,0.6,0.7,0.3,0.2,0.35),true},
	{15,Vector(0,5),Vector(1.5,0.0),Color(0.0,0.0,0.0,0.5,0.3,0.2,0.35),true},
	{16,Vector(0,4),Vector(1.5,0.0),Color(0.3,0.3,0.3,0.5,0.6,0.24,0.4),true},
}
local PredisAnimLastFrame = 16

function mod.EffectSpawn(pos, itemID, pickup, suckType)
    if suckType == 0 or suckType == 2 then
        SFXManager():Play(mod.SuckSoundID, 1, 5, false, 1)
    end

    local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EffectVariant, 0, pos, Vector.Zero, nil)
    local spr = eff:GetSprite()

    local effectAnm2Anim = mod.effectAnm2Anim
    if suckType == 1 then
        effectAnm2Anim = "пьедристал_black"
    elseif suckType == 2 then
        effectAnm2Anim = "пьедристал_red"
    end
    local targetColor = mod.PurpleColor
    if suckType == 1 then
        targetColor = mod.BlackColor
    elseif suckType == 2 then
        targetColor = mod.AbussColor
    end

    spr:Load(mod.effectAnm2Path, true)
    spr:Play(effectAnm2Anim, true)
    eff:Update()

    local conf = Isaac.GetItemConfig():GetCollectible(itemID)
    
    if conf then

        if not REPENTOGON then
            local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EffectVariant, 0, pos, Vector.Zero, nil)
            eff2.PositionOffset = Vector(0, -32)
            local spr = eff2:GetSprite()

            local pcspr = pickup:GetSprite()
            if pcspr:GetOverlayAnimation() == 'Alternates' and pcspr:GetOverlayFrame() == 0 then
                spr:Load(mod.effectAnm2Path, true)
                spr:Play(mod.ItemeffectAnm2Anim, true)
            else
                spr:Load(mod.PredestralAnm2Path, true)
                spr:Play("Alternates", true)
                spr:Stop()
                spr:Update()
                spr:SetFrame(pcspr:GetOverlayFrame())

                mod.NotRGONListVoidedAltes[#mod.NotRGONListVoidedAltes+1] = EntityPtr(eff2)
            end

            spr:ReplaceSpritesheet(1, conf.GfxFileName)
            spr:LoadGraphics()
        else

            local offset = pickup:GetSprite():GetCurrentAnimationData():GetLayer(1):GetFrame(pickup:GetSprite():GetFrame()):GetPos().Y

            local downpuff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector.Zero, nil)
            downpuff.SortingLayer = 1
            downpuff.Color = targetColor
            downpuff:GetSprite().Scale = Vector(0.5, 0.5)

            local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EffectVariant, 0, pos, Vector.Zero, nil)
            eff2.PositionOffset = Vector(0, (offset + 16)*Wtr)
            local spr = eff2:GetSprite()

            spr:Load(mod.effectAnm2Path, true)
            spr:Play(mod.ItemeffectRGONAnm2Anim, true)


            spr:ReplaceSpritesheet(1, conf.GfxFileName)
            spr:LoadGraphics()

            spr:SetCustomShader("shaders/DIVVOID_scukEffect")
            spr.PlaybackSpeed = 0.5
            --spr:GetLayer(1):SetWrapSMode(2)
            --spr:GetLayer(1):SetWrapTMode(2)

            --spr:GetLayer(1):SetCropOffset(Vector(-16,-16))
            --spr:GetLayer(1):SetPos(Vector(16, 16))
            --spr:GetLayer(1):SetSize(Vector(16, 16))

            local effPtr = EntityPtr(eff2)

            local r = -20
            Isaac.CreateTimer(function()
                if effPtr and effPtr.Ref then
                    local ent = effPtr.Ref
                    r = r + 1
                    local col = ent:GetColor()
                    
                    col = Color.Lerp(Color(1,1,1,1), targetColor, math.min(1.3, math.max(0, (r+20)/ 11)))
                    col:SetColorize(r/2,0,0,0)
                    ent.Color = col
                    ent.PositionOffset.Y = ent.PositionOffset.Y + math.max(0, (r+10)/50) -- r/1.5

                    local spr = ent:GetSprite()
                    spr.Scale = Vector(1 + math.max(0, (r+8)/40),  1 + math.max(0, (r+10)/30) )
                    
                end
            end, 1, 62, false)

        end
    end

    
end

function mod.CartEffectSpawn(pos, pickup, suckType)
    if suckType == 0 or suckType == 2 then
        SFXManager():Play(mod.SuckSoundID, 1, 5, false, 1)
    end

    --[[
    local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EffectVariant, 0, pos, Vector.Zero, nil)
    local spr = eff:GetSprite()

    local effectAnm2Anim = mod.effectAnm2Anim
    if suckType == 1 then
        effectAnm2Anim = "пьедристал_black"
    end

    spr:Load(mod.effectAnm2Path, true)
    spr:Play(effectAnm2Anim, true)
    eff:Update()]]

    local targetColor = mod.PurpleColor
    if suckType == 1 then
        targetColor = mod.BlackColor
    elseif suckType == 2 then
        targetColor = mod.AbussColor
    end
    
    if REPENTOGON then
        --local offset = pickup:GetSprite():GetCurrentAnimationData():GetLayer(1):GetFrame(pickup:GetSprite():GetFrame()):GetPos().Y

        local downpuff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector.Zero, nil)
        downpuff.SortingLayer = 1
        downpuff.Color = targetColor
        downpuff:GetSprite().Scale = Vector(0.5, 0.5)

        local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EffectVariant, 0, pos, Vector.Zero, nil)
        eff2.PositionOffset = Vector(0, (0 + 0)*Wtr)
        local spr = eff2:GetSprite()
        local pspr = pickup:GetSprite()

        spr:Load(pspr:GetFilename(), true)
        spr:Play(pspr:GetAnimation(), true)
        spr:SetFrame(pspr:GetFrame())

        spr.Color = pspr.Color
        spr.Scale = pspr.Scale
        spr.FlipX = pspr.FlipX
        spr.FlipY = pspr.FlipY
        spr.Rotation = pspr.Rotation

        for i = 0, pspr:GetLayerCount ()-1 do
            local Origlayer = pspr:GetLayer(i)
            if Origlayer then
                local layerSpr = spr:GetLayer(i)
                --layerSpr:Load(layer:GetFilepath(), true)
                spr:ReplaceSpritesheet (i, Origlayer:GetSpritesheetPath())
                layerSpr:SetPos(Origlayer:GetPos())
                layerSpr:SetSize(Origlayer:GetSize())
                layerSpr:SetColor(Origlayer:GetColor())
                layerSpr:SetVisible(Origlayer:IsVisible())
            end
        end

        spr:LoadGraphics()

        spr:SetCustomShader("shaders/DIVVOID_scukEffect")
        spr.PlaybackSpeed = 0.0
        --spr:GetLayer(1):SetWrapSMode(2)
        --spr:GetLayer(1):SetWrapTMode(2)

        --spr:GetLayer(1):SetCropOffset(Vector(-32,-32))
        --spr:GetLayer(1):SetPos(Vector(32, 32))
        --spr:GetLayer(1):SetSize(Vector(16, 16))

        local effPtr = EntityPtr(eff2)

        local r = -20
        Isaac.CreateTimer(function()
            if effPtr and effPtr.Ref then
                local ent = effPtr.Ref
                r = r + 1
                local col = ent:GetColor()
                
                col = Color.Lerp(Color(1,1,1,1), targetColor, math.min(1.3, math.max(0, (r+20)/ 11)))
                col:SetColorize(r/2,0,0,0)
                ent.Color = col
                ent.PositionOffset.Y = ent.PositionOffset.Y + math.min(0, -(r+15)/7) -- r/1.5

                local spr = ent:GetSprite()
                spr.Scale = Vector(1 + math.max(0, (r+8)/40),  1 + math.max(0, (r+10)/30) )
                

                if r > 10 then
                    ent:Remove()
                end
            end
        end, 1, 62, false)

    end
end

function mod.RemovePuffs(pos)
    local list = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.POOF01)
    for i = 1, #list do
        local ent = list[i]
        
        if ent.Position:Distance(pos) < 1 then
            ent.Color = Color(1,1,1,0)
            ent:Remove()
            break
        end
    end
end

if REPENTOGON then
    mod.ListVoidedPickups = {}
    local ListVoidedPickups = mod.ListVoidedPickups

    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED, function(_, pickup, IsBlackRune)
        
        --if not IsBlackRune then
            --mod.EffectSpawn(pickup.Position + Vector(0,3), pickup.SubType)
            mod.ListVoidedPickups[GetPtrHash(pickup)] = IsBlackRune and 1 or 0
            
            mod.HideNextPuff = Isaac.GetFrameCount()
            Isaac.CreateTimer(function()
                mod.RemovePuffs(pickup.Position + Vector(0, 10))
            end, 1, 2, false)
        --end
    end)
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_VOIDED_ABYSS, function(_, pickup, IsBlackRune)
        
        --if not IsBlackRune then
            --mod.EffectSpawn(pickup.Position + Vector(0,3), pickup.SubType)
            mod.ListVoidedPickups[GetPtrHash(pickup)] = 2
            
            mod.HideNextPuff = Isaac.GetFrameCount()
            Isaac.CreateTimer(function()
                mod.RemovePuffs(pickup.Position + Vector(0, 10))
            end, 1, 2, false)
        --end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, pickup)
        local hash = GetPtrHash(pickup)
        if ListVoidedPickups[hash] then
            local suckType = ListVoidedPickups[hash]
            ListVoidedPickups[hash] = nil
            
            if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                mod.EffectSpawn(pickup.Position, pickup.SubType, pickup, suckType)
            else
                mod.CartEffectSpawn(pickup.Position, pickup, suckType)
            end
        end
    end, EntityType.ENTITY_PICKUP)
else

    mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, 100000, function(_, itemID, rng, player, flags, slot, varData) 
        if itemID == CollectibleType.COLLECTIBLE_VOID then
            mod.FrameCheckVoidSuck = Isaac.GetFrameCount()
            mod.HideNextPuff = Isaac.GetFrameCount()
            mod.SuckTypeIsNext = 0
        elseif itemID == CollectibleType.COLLECTIBLE_ABYSS then
            mod.FrameCheckVoidSuck = Isaac.GetFrameCount()
            mod.HideNextPuff = Isaac.GetFrameCount()
            mod.SuckTypeIsNext = 2
        end
        
    end)

    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
        --if mod.FrameCheckVoidSuck then
            --mod.FrameCheckVoidSuck = false
        --end
        if #mod.NotRGONListVoidedAltes > 0 then
            for i = 1, #mod.NotRGONListVoidedAltes do
                local ent = mod.NotRGONListVoidedAltes[i]
                if not ent.Ref then
                    mod.NotRGONListVoidedAltes[i] = nil
                else
                    ent = ent.Ref
                    InterpolateAnim(ent:GetSprite(), ent.FrameCount, PredisAnim)
                    if ent.FrameCount>PredisAnimLastFrame then
                        ent:Remove()
                        mod.NotRGONListVoidedAltes[i] = nil
                    end
                end
               
            end
        end
    end)

    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, pickup)
        
        local frame = mod.FrameCheckVoidSuck and mod.FrameCheckVoidSuck - Isaac.GetFrameCount()
        if frame and (frame >= -7 and frame <= -6)
        and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            mod.EffectSpawn(pickup.Position, pickup.SubType, pickup, mod.SuckTypeIsNext)
            --mod.RemovePuffs(pickup.Position + Vector(0, 10))
        end
    end, EntityType.ENTITY_PICKUP)
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, ent)
    
    if mod.HideNextPuff == Isaac.GetFrameCount() then
        ent.Color = Color(1,1,1,0)
    end
end, EffectVariant.POOF01)