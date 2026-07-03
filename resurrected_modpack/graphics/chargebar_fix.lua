local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Refined Chargebar", 1)

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/ui/ui_chargebar.anm2", true)

local chargeBarOverlay = Sprite()
chargeBarOverlay:Load("gfx/ui/ui_chargebar.anm2", true)

local sparklesSprite = Sprite()
sparklesSprite:Load("gfx/ui/chargebar_sparkles.anm2", true)

local overchargeSprite = Sprite()
overchargeSprite:Load("gfx/ui/chargebar_overcharge.anm2", true)

--this fixes the top of the charge bar not being rendered
local function chargeBarFix(player, slot, offset, alpha, scale, chargeBarOffset)
local charge = player:GetActiveCharge(slot)
local batteryCharge = player:GetBatteryCharge(slot)
local maxCharge = player:GetActiveMaxCharge(slot)
local overlayAnim = "BarOverlay" .. tostring(maxCharge)
local fullAnim = "BarFull"
local emptyAnim = "BarEmpty"
local pocketItem = player:GetPocketItem(PillCardSlot.PRIMARY)
local bethCharge = player:GetEffectiveSoulCharge()
local tBethCharge = player:GetEffectiveBloodCharge()
local validAnims = {
    ["BarOverlay1"]  = true,
    ["BarOverlay2"]  = true,
    ["BarOverlay3"]  = true,
    ["BarOverlay4"]  = true,
    ["BarOverlay5"]  = true,
    ["BarOverlay6"]  = true,
    ["BarOverlay8"]  = true,
    ["BarOverlay12"] = true,
}

--print("charge: " .. charge .. " maxCharge: " .. maxCharge .. " slot: " .. slot .. " bethCharge: " .. bethCharge .. " tBethCharge: " .. tBethCharge)
    if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_NULL then return end
    -- for one use active items
    if maxCharge < 1 then return end
    if charge == maxCharge then
        --this makes the chargebar smaller if its in the secondary slot
        if (slot == ActiveSlot.SLOT_PRIMARY) or (pocketItem:GetType() == PocketItemType.ACTIVE_ITEM) then 
            local scale = Vector(1,1)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale

        else
            local scale = Vector(0.5,0.5)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale

        end

        --this renders the charge
        if batteryCharge == maxCharge then
            local color = Color(1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0)
            chargeBarSprite.Color = color
        elseif FiendFolio and FiendFolio:getChargeDebt(player, slot) > 1 then
            local redBarColor = Color(1,1,1,1)
            redBarColor:SetColorize(1,0,0,1)
            chargeBarSprite.Color = redBarColor
        else
            local color = Color(1, 1, 1, 1, 0, 0, 0)
            chargeBarSprite.Color = color
        end
        chargeBarSprite:SetFrame(fullAnim, 0)
        chargeBarSprite:Update()
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 29)) -- last vector crops the bottom so only the tippy top is shown

        --for items that recharge with time
        if maxCharge > 12 then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
            chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 29))
        return
        end

        -- this renders the overlay
        if not validAnims[overlayAnim] then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
            chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 29))
        else
            chargeBarOverlay:SetFrame(overlayAnim, 0)
            chargeBarOverlay:Update()
            chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 29))
        end

        
        -- this is the worst way to do this code i am sorry 
    elseif tBethCharge >= 1 then
        --this makes the chargebar smaller if its in the secondary slot
        if (slot == ActiveSlot.SLOT_PRIMARY) or (pocketItem:GetType() == PocketItemType.ACTIVE_ITEM) then 
            local scale = Vector(1,1)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        else
            local scale = Vector(0.5,0.5)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        end

        local color = Color(1, 1, 1, 1, 0, 0, 0, 1, 0.2, 0.2, 1.0)
        chargeBarSprite.Color = color
        chargeBarSprite:SetFrame(fullAnim, 0)
        chargeBarSprite:Update()
        if tBethCharge == maxCharge then
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end

        local colorOv = Color(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
        chargeBarOverlay.Color = colorOv
        --for items that recharge with time
        if maxCharge > 12 then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
        if tBethCharge == maxCharge then
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end
        end

        if not validAnims[overlayAnim] then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
        else
            chargeBarOverlay:SetFrame(overlayAnim, 0)
            chargeBarOverlay:Update()
        end

        if tBethCharge == maxCharge then
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown, same for the next one but only the bippy(?) bottom
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end
    elseif bethCharge >= 1 then
        --this makes the chargebar smaller if its in the secondary slot
        if (slot == ActiveSlot.SLOT_PRIMARY) or (pocketItem:GetType() == PocketItemType.ACTIVE_ITEM) then 
            local scale = Vector(1,1)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        else
            local scale = Vector(0.5,0.5)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        end

        local color = Color(1, 1, 1, 1, 0, 0, 0, 0.6, 0.85, 1.2, 1.0)
        chargeBarSprite.Color = color
        chargeBarSprite:SetFrame(fullAnim, 0)
        chargeBarSprite:Update()
        if bethCharge == maxCharge then
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end

        local colorOv = Color(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
        chargeBarOverlay.Color = colorOv
        --for items that recharge with time
        if maxCharge > 12 then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
        if bethCharge == maxCharge then
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end
        end

        if not validAnims[overlayAnim] then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
        else
            chargeBarOverlay:SetFrame(overlayAnim, 0)
            chargeBarOverlay:Update()
        end

        if bethCharge == maxCharge then
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else-- last vector crops the bottom so only the tippy top is shown, same for the next one but only the bippy(?) bottom
        chargeBarOverlay:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0))
        end
    elseif charge == 0 then
        local color = Color(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
        chargeBarSprite.Color = color
        chargeBarOverlay.Color = color
        if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) == true then return end
        if (slot == ActiveSlot.SLOT_PRIMARY) or (pocketItem:GetType() == PocketItemType.ACTIVE_ITEM) then
            local scale = Vector(1,1)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        else
            local scale = Vector(0.5,0.5)
            chargeBarSprite.Scale = scale
            chargeBarOverlay.Scale = scale
        end

        chargeBarSprite:SetFrame(emptyAnim, 0)
        chargeBarSprite:Update()
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 26), Vector(0, 0)) -- last vector crops the bottom so only the tippy top is shown
        if not validAnims[overlayAnim] then
            chargeBarOverlay:SetFrame("BarOverlay1", 0)
            chargeBarOverlay:Update()
            chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else
            chargeBarOverlay:SetFrame(overlayAnim, 0)
            chargeBarOverlay:Update()
            chargeBarOverlay:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        end

    end
    
end

local sparklesIsPlaying = {}
local overchargeIsPlaying = false

--this makes little sparkles appear when you have your item charged woohoo
local function readyToFireUp2(player, slot, offset, alpha, scale, chargeBarOffset)
local charge = player:GetActiveCharge(slot)
local maxCharge = player:GetActiveMaxCharge(slot)
local batteryCharge = player:GetBatteryCharge(slot)
local pocketItem = player:GetPocketItem(PillCardSlot.SECONDARY)
local bethCharge = player:GetEffectiveSoulCharge() -- local color = Color(1, 1, 1, 1, 0, 0, 0, 0.6, 0.85, 1.2, 1.0)
local tBethCharge = player:GetEffectiveBloodCharge()-- local color = Color(1, 1, 1, 1, 0, 0, 0, 1, 0.2, 0.2, 1.0)
    if (slot == ActiveSlot.SLOT_SECONDARY) or (pocketItem:GetType() == PocketItemType.ACTIVE_ITEM) then return end
    if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_NULL then return end

    
    local key = GetPtrHash(player) .. "_" .. tostring(slot)

    if charge == maxCharge then
    local color = Color(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
    sparklesSprite.Color = color
    elseif bethCharge == maxCharge then
    local color = Color(1, 1, 1, 1, 0, 0, 0, 0.6, 0.85, 1.2, 1.0)
    sparklesSprite.Color = color
    elseif tBethCharge == maxCharge then
    local color = Color(1, 1, 1, 1, 0, 0, 0, 1, 0.2, 0.2, 1.0)
    sparklesSprite.Color = color
    end

    if ((charge == maxCharge) or (bethCharge == maxCharge) or (tBethCharge == maxCharge)) and not (maxCharge < 1) then
        if batteryCharge >= 1 then return end
        if not sparklesIsPlaying[key] then 
        sparklesSprite:SetFrame("Idle", 0)
        sparklesSprite:Play("Idle", false)
        sparklesIsPlaying[key] = true
        end
        sparklesSprite:Update()
        sparklesSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
    else
        sparklesIsPlaying[key] = false
    end
end

local function readyToFireUpOvercharge(player, slot, offset, alpha, scale, chargeBarOffset)
local batteryCharge = player:GetBatteryCharge(slot)
    if slot == ActiveSlot.SLOT_SECONDARY then return end
    if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_NULL then return end
        if batteryCharge >= 1 then
        if not overchargeIsPlaying then
        overchargeSprite:SetFrame("Idle", 0)     
        overchargeSprite:Play("Idle", false)
        overchargeIsPlaying = true
        end
        overchargeSprite:Update()
        overchargeSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        else
            overchargeIsPlaying = false
        end
end


---@param player EntityPlayer
---@param slot ActiveSlot
---@param offset Vector
---@param alpha number
---@param scale number
---@param chargeBarOffset Vector
function mod:chargeBarEdits(player, slot, offset, alpha, scale, chargeBarOffset)
    chargeBarFix(player, slot, offset, alpha, scale, chargeBarOffset)
    readyToFireUp2(player, slot, offset, alpha, scale, chargeBarOffset)
    readyToFireUpOvercharge(player, slot, offset, alpha, scale, chargeBarOffset)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.chargeBarEdits)