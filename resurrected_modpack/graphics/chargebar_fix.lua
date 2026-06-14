local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Chargebar GFX Fix", 1)

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/ui/ui_chargebar.anm2", true)

local sparklesSprite = Sprite()
sparklesSprite:Load("gfx/ui/chargebar_sparkles.anm2", true)

--this fixes the top of the charge bar not being rendered
local function chargeBarFix(player, slot, offset, alpha, scale, chargeBarOffset)
local charge = player:GetActiveCharge(slot)
local batteryCharge = player:GetBatteryCharge(slot)
local maxCharge = player:GetActiveMaxCharge(slot)
local overlayAnim = "BarOverlay" .. tostring(maxCharge)
local fullAnim = "BarFull"
    if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_NULL then return end
    -- for one use active items
    if maxCharge < 1 then return end
    if charge == maxCharge then
        --print("charge: " .. charge .. " maxCharge: " .. maxCharge .. " slot: " .. slot)

        --this renders the charge
        if batteryCharge == maxCharge then
            local color = Color(1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0)
            chargeBarSprite.Color = color
        end
        chargeBarSprite:SetFrame(fullAnim, 0)        
        chargeBarSprite:Update()
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 29)) -- last vector crops the bottom so only the tippy top is shown


        -- this renders the overlay
        if batteryCharge == maxCharge then
            --print(batteryCharge)
            local color = Color(1, 1, 1, 1, 0, 0, 0)
            chargeBarSprite.Color = color
        end
        chargeBarSprite:SetFrame(overlayAnim, 0)        
        chargeBarSprite:Update()
        chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))

        --for items that recharge with time
        if maxCharge > 12 then
            chargeBarSprite:SetFrame("BarOverlay1", 0)        
            chargeBarSprite:Update()
            chargeBarSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
        end

    end
    
end

local sparklesIsPlaying = false

--this makes little sparkles appear when you have your item charged woohoo
local function readyToFireUp2(player, slot, offset, alpha, scale, chargeBarOffset)
local charge = player:GetActiveCharge(slot)
local batteryCharge = player:GetBatteryCharge(slot)
local maxCharge = player:GetActiveMaxCharge(slot)
    if player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_NULL then return end

    if charge == maxCharge and not (maxCharge > 12) and not (maxCharge < 1) then
        if not sparklesIsPlaying then 
        sparklesSprite:SetFrame("Idle", 0)
        sparklesSprite:Play("Idle", false)
        sparklesIsPlaying = true
        end
        sparklesSprite:Update()
        sparklesSprite:Render(chargeBarOffset, Vector(0, 0), Vector(0, 0))
    else
        sparklesIsPlaying = false
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
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.chargeBarEdits)