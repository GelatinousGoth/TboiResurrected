local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Chargebar GFX Fix", 1)

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/ui/ui_chargebar.anm2", true)

---@param player EntityPlayer
---@param slot ActiveSlot
---@param offset Vector
---@param alpha number
---@param scale number
---@param chargeBarOffset Vector
function mod:chargeBarFix(player, slot, offset, alpha, scale, chargeBarOffset)
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
mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.chargeBarFix)