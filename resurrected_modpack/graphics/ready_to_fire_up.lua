local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Ready To Fire Up", 1)

local json = require("json")
local renderFlagPrimary = false
local renderFlagPocket = false
local renderFlagEssa = false
local renderFlagEssa2 = false
local renderFlagPrimaryNotEssa = false
local renderFlag2 = false
local renderFlag3 = false
local updateTimer = 0
local persistentData = {}

local SkinChoices = {
    "Yellow/Red.Slow", "Yellow/Red.Fast", "Red.Slow", "Red.Fast",
    "Purple.Slow", "Purple.Fast", "Blue.Slow", "Blue.Fast",
    "Yellow.Slow", "Yellow.Fast", "White.Slow", "White.Fast",
    "MegaMaw.Slow", "MegaMaw.Fast",
}

local defaultConfig = {
    ShowFireinMenu = false,
    Transparency = 100,
    Red = 100,
    Green = 100,
    Blue = 100,
    Speed = 30,
    YaxisOffsetPlayer1Pr = 0,
    YaxisOffsetPlayer1Po = 0,
    YaxisOffsetPlayer2Pr = 0,
    YaxisOffsetPlayerEssa = 0,
    YaxisOffsetPlayer1PrDown = 0,
    YaxisOffsetPlayer1PoDown = 0,
    YaxisOffsetPlayerEssaDown = 0,

    Player1PrSkin = SkinChoices["Yellow.Slow"],
    Player1PrSkin2 = SkinChoices["Yellow.Fast"],
    Player1PrSkin3 = SkinChoices["Yellow/Red.Fast"],

    Player1PoSkin = SkinChoices["Yellow.Slow"],
    Player1PoSkin2 = SkinChoices["Yellow.Fast"],
    Player1PoSkin3 = SkinChoices["Yellow/Red.Fast"],
    configVersion = 1
}

function mod:DeafultsConfigs()
    if persistentData["configVersion"] == nil then
        mod:loadConfiguration()
    end
    if ModConfigMenu then
        defaultConfig.Transparency = persistentData["Transparency"]
        defaultConfig.Red = persistentData["Red"]
        defaultConfig.Green = persistentData["Green"]
        defaultConfig.Blue = persistentData["Blue"]
        defaultConfig.Speed = persistentData["Speed"]
        defaultConfig.ShowFireinMenu = persistentData["ShowFireinMenu"]
        defaultConfig.Player1PrSkin = persistentData["Player1PrSkin"]
        defaultConfig.Player1PrSkin2 = persistentData["Player1PrSkin2"]
        defaultConfig.Player1PrSkin3 = persistentData["Player1PrSkin3"]
        defaultConfig.Player1PoSkin = persistentData["Player1PoSkin"]
        defaultConfig.Player1PoSkin2 = persistentData["Player1PoSkin2"]
        defaultConfig.Player1PoSkin3 = persistentData["Player1PoSkin3"]
        defaultConfig.YaxisOffsetPlayer1Pr = persistentData["YaxisOffsetPlayer1Pr"]
        defaultConfig.YaxisOffsetPlayer1Po = persistentData["YaxisOffsetPlayer1Po"]
        defaultConfig.YaxisOffsetPlayer2Pr = persistentData["YaxisOffsetPlayer2Pr"]
        defaultConfig.YaxisOffsetPlayerEssa = persistentData["YaxisOffsetPlayerEssa"]
        defaultConfig.YaxisOffsetPlayer1PrDown = persistentData["YaxisOffsetPlayer1PrDown"]
        defaultConfig.YaxisOffsetPlayer1PoDown = persistentData["YaxisOffsetPlayer1PoDown"]
        defaultConfig.YaxisOffsetPlayerEssaDown = persistentData["YaxisOffsetPlayerEssaDown"]
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.DeafultsConfigs)

local fire_Yellow = Sprite()
fire_Yellow:Load("gfx/ui/burnit.anm2", true)
fire_Yellow:Play("Yellow.Slow", true)
local fire_Yellow2 = Sprite()
fire_Yellow2:Load("gfx/ui/burnit.anm2", true)
fire_Yellow2:Play("Yellow.Slow", true)
local fire_Yellow3 = Sprite()
fire_Yellow3:Load("gfx/ui/burnit.anm2", true)
fire_Yellow3:Play("Yellow.Slow", true)
local fire_Red = Sprite()
fire_Red:Load("gfx/ui/burnit.anm2", true)

function mod:isOvercharged(player)
    if player.Index ~= 0 then
        return false
    end

    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if activeItem == nil or activeItem <= 0 then
        return false
    end

    local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    local batteryCharge = player:GetBatteryCharge(ActiveSlot.SLOT_PRIMARY)
    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
    return (activeItem > 0 and activeCharge + batteryCharge > maxCharge)
end

local currentFireAnim = nil
local currentFireAnimMini = nil

function mod:onRenderCharge()
    local player = Isaac.GetPlayer(0)
    local correctFire
    local correctFire2
    if not mod:isOvercharged(player) then
        if defaultConfig.Player1PrSkin == "Yellow/Red.Slow" then
            correctFire = "Yellow/Red.Slow"
        elseif defaultConfig.Player1PrSkin == "Yellow/Red.Fast" then
            correctFire = "Yellow/Red.Fast"
        elseif defaultConfig.Player1PrSkin == "Red.Slow" then
            correctFire = "Reed.Slow"
        elseif defaultConfig.Player1PrSkin == "Red.Fast" then
            correctFire = "Reed.Fast"
        elseif defaultConfig.Player1PrSkin == "Purple.Slow" then
            correctFire = "Purple.Slow"
        elseif defaultConfig.Player1PrSkin == "Purple.Fast" then
            correctFire = "Purple.Fast"
        elseif defaultConfig.Player1PrSkin == "Blue.Slow" then
            correctFire = "Bluue.Slow"
        elseif defaultConfig.Player1PrSkin == "Blue.Fast" then
            correctFire = "Bluue.Fast"
        elseif defaultConfig.Player1PrSkin == "Yellow.Slow" then
            correctFire = "Yelllow.Slow"
        elseif defaultConfig.Player1PrSkin == "Yellow.Fast" then
            correctFire = "Yellow.Fast"
        elseif defaultConfig.Player1PrSkin == "White.Slow" then
            correctFire = "White.Slow"
        elseif defaultConfig.Player1PrSkin == "White.Fast" then
            correctFire = "White.Fast"
        elseif defaultConfig.Player1PrSkin == "MegaMaw.Slow" then
            correctFire = "MegaMaw.Slow"
        elseif defaultConfig.Player1PrSkin == "MegaMaw.Fast" then
            correctFire = "MegaMaw.Fast"
        end
    else
        if defaultConfig.Player1PrSkin2 == "Yellow/Red.Slow" then
            correctFire = "Yellow/Red.Slow"
        elseif defaultConfig.Player1PrSkin2 == "Yellow/Red.Fast" then
            correctFire = "Yellow/Red.Fast"
        elseif defaultConfig.Player1PrSkin2 == "Red.Slow" then
            correctFire = "Reed.Slow"
        elseif defaultConfig.Player1PrSkin2 == "Red.Fast" then
            correctFire = "Reed.Fast"
        elseif defaultConfig.Player1PrSkin2 == "Purple.Slow" then
            correctFire = "Purple.Slow"
        elseif defaultConfig.Player1PrSkin2 == "Purple.Fast" then
            correctFire = "Purple.Fast"
        elseif defaultConfig.Player1PrSkin2 == "Blue.Slow" then
            correctFire = "Bluue.Slow"
        elseif defaultConfig.Player1PrSkin2 == "Blue.Fast" then
            correctFire = "Bluue.Fast"
        elseif defaultConfig.Player1PrSkin2 == "Yellow.Slow" then
            correctFire = "Yelllow.Slow"
        elseif defaultConfig.Player1PrSkin2 == "Yellow.Fast" then
            correctFire = "Yellow.Fast"
        elseif defaultConfig.Player1PrSkin2 == "White.Slow" then
            correctFire = "White.Slow"
        elseif defaultConfig.Player1PrSkin2 == "White.Fast" then
            correctFire = "White.Fast"
        elseif defaultConfig.Player1PrSkin2 == "MegaMaw.Slow" then
            correctFire = "MegaMaw.Slow"
        elseif defaultConfig.Player1PrSkin2 == "MegaMaw.Fast" then
            correctFire = "MegaMaw.Fast"
        end
    end
    if correctFire ~= currentFireAnim then
        fire_Red:Play(correctFire, true)
        currentFireAnim = correctFire
    end

    if defaultConfig.Player1PrSkin3 == "Yellow/Red.Slow" then
        correctFire2 = "Yellow/Red.Slow"
    elseif defaultConfig.Player1PrSkin3 == "Yellow/Red.Fast" then
        correctFire2 = "Yellow/Red.Fast"
    elseif defaultConfig.Player1PrSkin3 == "Red.Slow" then
        correctFire2 = "Reed.Slow"
    elseif defaultConfig.Player1PrSkin3 == "Red.Fast" then
        correctFire2 = "Reed.Fast"
    elseif defaultConfig.Player1PrSkin3 == "Purple.Slow" then
        correctFire2 = "Purple.Slow"
    elseif defaultConfig.Player1PrSkin3 == "Purple.Fast" then
        correctFire2 = "Purple.Fast"
    elseif defaultConfig.Player1PrSkin3 == "Blue.Slow" then
        correctFire2 = "Bluue.Slow"
    elseif defaultConfig.Player1PrSkin3 == "Blue.Fast" then
        correctFire2 = "Bluue.Fast"
    elseif defaultConfig.Player1PrSkin3 == "Yellow.Slow" then
        correctFire2 = "Yelllow.Slow"
    elseif defaultConfig.Player1PrSkin3 == "Yellow.Fast" then
        correctFire2 = "Yellow.Fast"
    elseif defaultConfig.Player1PrSkin3 == "White.Slow" then
        correctFire2 = "White.Slow"
    elseif defaultConfig.Player1PrSkin3 == "White.Fast" then
        correctFire2 = "White.Fast"
    elseif defaultConfig.Player1PrSkin3 == "MegaMaw.Slow" then
        correctFire2 = "MegaMaw.Slow"
    elseif defaultConfig.Player1PrSkin3 == "MegaMaw.Fast" then
        correctFire2 = "MegaMaw.Fast"
    end
    if correctFire2 ~= currentFireAnimMini then
        fire_Yellow:Play(correctFire2, true)
        currentFireAnimMini = correctFire2
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRenderCharge) -- player1 primary

local fire_Red3 = Sprite()
fire_Red3:Load("gfx/ui/burnit.anm2", true)

local currentFireAnimPocket = nil
local currentFireAnimPocketMini = nil

function mod:isOverchargedPocket(player)
    if player.Index ~= 0 then
        return false
    end

    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_POCKET)
    if activeItem == nil or activeItem <= 0 then
        return false
    end

    local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_POCKET)
    local batteryCharge = player:GetBatteryCharge(ActiveSlot.SLOT_POCKET)
    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
    return (activeItem > 0 and activeCharge + batteryCharge > maxCharge)
end

function mod:onRenderChargePocket()
    local player = Isaac.GetPlayer(0)
    local correctFire
    local correctFire2
    if not mod:isOverchargedPocket(player) then
        if defaultConfig.Player1PoSkin == "Yellow/Red.Slow" then
            correctFire = "Yellow/Red.Slow"
        elseif defaultConfig.Player1PoSkin == "Yellow/Red.Fast" then
            correctFire = "Yellow/Red.Fast"
        elseif defaultConfig.Player1PoSkin == "Red.Slow" then
            correctFire = "Reed.Slow"
        elseif defaultConfig.Player1PoSkin == "Red.Fast" then
            correctFire = "Reed.Fast"
        elseif defaultConfig.Player1PoSkin == "Purple.Slow" then
            correctFire = "Purple.Slow"
        elseif defaultConfig.Player1PoSkin == "Purple.Fast" then
            correctFire = "Purple.Fast"
        elseif defaultConfig.Player1PoSkin == "Blue.Slow" then
            correctFire = "Bluue.Slow"
        elseif defaultConfig.Player1PoSkin == "Blue.Fast" then
            correctFire = "Bluue.Fast"
        elseif defaultConfig.Player1PoSkin == "Yellow.Slow" then
            correctFire = "Yelllow.Slow"
        elseif defaultConfig.Player1PoSkin == "Yellow.Fast" then
            correctFire = "Yellow.Fast"
        elseif defaultConfig.Player1PoSkin == "White.Slow" then
            correctFire = "White.Slow"
        elseif defaultConfig.Player1PoSkin == "White.Fast" then
            correctFire = "White.Fast"
        elseif defaultConfig.Player1PoSkin == "MegaMaw.Slow" then
            correctFire = "MegaMaw.Slow"
        elseif defaultConfig.Player1PoSkin == "MegaMaw.Fast" then
            correctFire = "MegaMaw.Fast"
        end
    else
        if defaultConfig.Player1PoSkin2 == "Yellow/Red.Slow" then
            correctFire = "Yellow/Red.Slow"
        elseif defaultConfig.Player1PoSkin2 == "Yellow/Red.Fast" then
            correctFire = "Yellow/Red.Fast"
        elseif defaultConfig.Player1PoSkin2 == "Red.Slow" then
            correctFire = "Reed.Slow"
        elseif defaultConfig.Player1PoSkin2 == "Red.Fast" then
            correctFire = "Reed.Fast"
        elseif defaultConfig.Player1PoSkin2 == "Purple.Slow" then
            correctFire = "Purple.Slow"
        elseif defaultConfig.Player1PoSkin2 == "Purple.Fast" then
            correctFire = "Purple.Fast"
        elseif defaultConfig.Player1PoSkin2 == "Blue.Slow" then
            correctFire = "Bluue.Slow"
        elseif defaultConfig.Player1PoSkin2 == "Blue.Fast" then
            correctFire = "Bluue.Fast"
        elseif defaultConfig.Player1PoSkin2 == "Yellow.Slow" then
            correctFire = "Yelllow.Slow"
        elseif defaultConfig.Player1PoSkin2 == "Yellow.Fast" then
            correctFire = "Yellow.Fast"
        elseif defaultConfig.Player1PoSkin2 == "White.Slow" then
            correctFire = "White.Slow"
        elseif defaultConfig.Player1PoSkin2 == "White.Fast" then
            correctFire = "White.Fast"
        elseif defaultConfig.Player1PoSkin2 == "MegaMaw.Slow" then
            correctFire = "MegaMaw.Slow"
        elseif defaultConfig.Player1PoSkin2 == "MegaMaw.Fast" then
            correctFire = "MegaMaw.Fast"
        end
    end
    if correctFire ~= currentFireAnimPocket then
        fire_Red3:Play(correctFire, true)
        currentFireAnimPocket = correctFire
    end

    if defaultConfig.Player1PoSkin3 == "Yellow/Red.Slow" then
        correctFire2 = "Yellow/Red.Slow"
    elseif defaultConfig.Player1PoSkin3 == "Yellow/Red.Fast" then
        correctFire2 = "Yellow/Red.Fast"
    elseif defaultConfig.Player1PoSkin3 == "Red.Slow" then
        correctFire2 = "Reed.Slow"
    elseif defaultConfig.Player1PoSkin3 == "Red.Fast" then
        correctFire2 = "Reed.Fast"
    elseif defaultConfig.Player1PoSkin3 == "Purple.Slow" then
        correctFire2 = "Purple.Slow"
    elseif defaultConfig.Player1PoSkin3 == "Purple.Fast" then
        correctFire2 = "Purple.Fast"
    elseif defaultConfig.Player1PoSkin3 == "Blue.Slow" then
        correctFire2 = "Bluue.Slow"
    elseif defaultConfig.Player1PoSkin3 == "Blue.Fast" then
        correctFire2 = "Bluue.Fast"
    elseif defaultConfig.Player1PoSkin3 == "Yellow.Slow" then
        correctFire2 = "Yelllow.Slow"
    elseif defaultConfig.Player1PoSkin3 == "Yellow.Fast" then
        correctFire2 = "Yellow.Fast"
    elseif defaultConfig.Player1PoSkin3 == "White.Slow" then
        correctFire2 = "White.Slow"
    elseif defaultConfig.Player1PoSkin3 == "White.Fast" then
        correctFire2 = "White.Fast"
    elseif defaultConfig.Player1PoSkin3 == "MegaMaw.Slow" then
        correctFire2 = "MegaMaw.Slow"
    elseif defaultConfig.Player1PoSkin3 == "MegaMaw.Fast" then
        correctFire2 = "MegaMaw.Fast"
    end
    if correctFire2 ~= currentFireAnimPocketMini then
        fire_Yellow3:Play(correctFire2, true)
        currentFireAnimPocketMini = correctFire2
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRenderChargePocket) -- player1 pocket

local fire_Red2 = Sprite()
fire_Red2:Load("gfx/ui/burnit.anm2", true)
local currentFireAnimEssa = nil

function mod:isOverchargedEssa(player)
    local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if activeItem == nil or activeItem <= 0 then
        return false
    end

    local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    local batteryCharge = player:GetBatteryCharge(ActiveSlot.SLOT_PRIMARY)
    local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
    return (activeItem > 0 and activeCharge + batteryCharge > maxCharge)
end

function mod:onRenderChargeEssa()
    local player2 = Isaac.GetPlayer(1)
    local correctFire
    if not mod:isOverchargedEssa(player2) then
        correctFire = "Yellow/Red.Slow"
    else
        correctFire = "Bluue.Fast"
    end

    if correctFire ~= currentFireAnimEssa then
        fire_Red2:Play(correctFire, true)
        currentFireAnimEssa = correctFire
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRenderChargeEssa) -- player2 primary

local fire_RedNotEssa = Sprite()
fire_RedNotEssa:Load("gfx/ui/burnit.anm2", true)

local currentFireAnimNotEssa = nil

function mod:isOverchargedNotEssa(player)
    local player2 = Isaac.GetPlayer(1)
    if Game():GetNumPlayers() > 1 then
        if player2:GetPlayerType() == PlayerType.PLAYER_ESAU then
        else
            local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
            if activeItem == nil or activeItem <= 0 then
                return false
            end

            local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
            local batteryCharge = player:GetBatteryCharge(ActiveSlot.SLOT_PRIMARY)
            local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
            return (activeItem > 0 and activeCharge + batteryCharge > maxCharge)
        end
    end
end

function mod:onRenderChargeNotEssa()
    local player2 = Isaac.GetPlayer(1)
    local correctFire
    if Game():GetNumPlayers() > 1 then
        if player2:GetPlayerType() == PlayerType.PLAYER_ESAU then
        else
            if not mod:isOverchargedNotEssa(player2) then
                correctFire = "Yellow/Red.Slow"
            else
                correctFire = "Bluue.Fast"
            end
            if correctFire ~= currentFireAnimNotEssa then
                fire_RedNotEssa:Play(correctFire, true)
                currentFireAnimNotEssa = correctFire
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRenderChargeNotEssa) -- player2 primary

local firedown = Sprite()
firedown:Load("gfx/ui/burnit.anm2", true)
local firedownEssa = Sprite()
firedownEssa:Load("gfx/ui/burnit.anm2", true)
local firedown2 = Sprite()
firedown2:Load("gfx/ui/burnit.anm2", true)
local fire_YellowNotEssa = Sprite()
fire_YellowNotEssa:Load("gfx/ui/burnit.anm2", true)
fire_YellowNotEssa:Play("Yellow.Slow", true)

-- To add: Bethany/b her soul charges

function mod:FiredUPRender()
    if Game():GetNumPlayers() >= 3 and Isaac.GetPlayer(2):GetPlayerType() == PlayerType.PLAYER_JACOB then return end
    local player1 = Isaac.GetPlayer(0)
    local player2 = Isaac.GetPlayer(1)
    local isPaused = Game():IsPaused()
    local isHUDVisible
    if defaultConfig.ShowFireinMenu == true then
        isHUDVisible = not Game():GetHUD():IsVisible()
    elseif defaultConfig.ShowFireinMenu == false then
        isHUDVisible = Game():GetHUD():IsVisible()
    end
    local hudOffset = Options.HUDOffset * 10
    local card = player1:GetCard(0)
    local itemConfigCard = Isaac.GetItemConfig():GetCard(card)
    local pill = player1:GetPill(0)
    local itemConfigPill = Isaac.GetItemConfig():GetPillEffect(pill)
    local hasActiveItem1 = false
    for i = 1, CollectibleType.NUM_COLLECTIBLES do
        if player1:HasCollectible(i, false) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_ACTIVE then
            hasActiveItem1 = true
            break
        end
    end
    if hasActiveItem1 and isHUDVisible then
        if player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not (player1:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false) and player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
            if renderFlagPrimary then return end
            renderFlagPrimary = true
            local itemConfig = Isaac.GetItemConfig():GetCollectible(player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
            local currentCharge1 = player1:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
            if itemConfig.MaxCharges > 0 and currentCharge1 > 0 then
                local chargePercentage = currentCharge1 / itemConfig.MaxCharges * 100
                local yxis = 24
                if chargePercentage == 100 then
                    fire_Red.Scale = Vector(1.1, 1.1)
                    fire_Red.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                        (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                    fire_Red:Render(Vector(19.5 + 2 * hudOffset,
                        1.2 * hudOffset + 35.5 + defaultConfig.YaxisOffsetPlayer1Pr))
                    if not isPaused then fire_Red:Update() end
                elseif chargePercentage >= 1 and chargePercentage < 100 then
                    local scale = chargePercentage / 100
                    fire_Yellow.Scale = Vector(scale + 0.13, scale + 0.13)
                    fire_Yellow.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                        (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                    fire_Yellow:Render(Vector(19.5 + 2 * hudOffset,
                        1.2 * hudOffset + yxis + defaultConfig.YaxisOffsetPlayer1Pr + (scale * 10)))

                    if not isPaused then fire_Yellow:Update() end
                end
            end
        end
        ----------------------------
        local hasActiveItemNotEssa = false
        for i = 1, CollectibleType.NUM_COLLECTIBLES do
            if player2:HasCollectible(i, false) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_ACTIVE then
                hasActiveItemNotEssa = true
                break
            end
        end
        if Game():GetNumPlayers() > 1 and hasActiveItemNotEssa and isHUDVisible then
            if player2:GetPlayerType() == PlayerType.PLAYER_ESAU then

            else
                if player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0 and not (player2:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false)
                        and player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
                    if renderFlagPrimaryNotEssa then return end
                    renderFlagPrimaryNotEssa = true
                    local itemConfig = Isaac.GetItemConfig():GetCollectible(player2:GetActiveItem(ActiveSlot
                        .SLOT_PRIMARY))
                    local currentCharge1 = player2:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
                    local screenWidth = Isaac.GetScreenWidth()
                    if itemConfig.MaxCharges > 0 and currentCharge1 > 0 then
                        local chargePercentage = currentCharge1 / itemConfig.MaxCharges * 100
                        local yxis = 24
                        if chargePercentage == 100 then
                            fire_RedNotEssa.Scale = Vector(1.1, 1.1)
                            fire_RedNotEssa.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                                (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                            fire_RedNotEssa:Render(Vector(screenWidth - 155.5 - 2 * hudOffset,
                                1.2 * hudOffset + 35.5 + defaultConfig.YaxisOffsetPlayer2Pr))
                            if not isPaused then fire_RedNotEssa:Update() end
                        elseif chargePercentage >= 1 and chargePercentage < 100 then
                            local scale = chargePercentage / 100
                            fire_YellowNotEssa.Scale = Vector(scale + 0.13, scale + 0.13)
                            fire_YellowNotEssa.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                                (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                            fire_YellowNotEssa:Render(Vector(screenWidth - 155.5 - 2 * hudOffset,
                                1.2 * hudOffset + yxis + (scale * 10) + defaultConfig.YaxisOffsetPlayer2Pr))
                            if not isPaused then fire_YellowNotEssa:Update() end
                        end
                    end
                end
            end
        end
        ------------------------------
        if player1:GetActiveItem(ActiveSlot.SLOT_POCKET) ~= 0 and not (player1:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false)
                and player1:GetActiveItem(ActiveSlot.SLOT_POCKET) == CollectibleType.COLLECTIBLE_SUMPTORIUM) and not (itemConfigCard.ID > 0) and not (itemConfigPill.ID > 0) then
            if renderFlagPocket then return end
            renderFlagPocket = true
            local itemConfig = Isaac.GetItemConfig():GetCollectible(player1:GetActiveItem(ActiveSlot.SLOT_POCKET))
            local currentCharge3 = player1:GetActiveCharge(ActiveSlot.SLOT_POCKET)
            local windowsize = (Isaac.WorldToScreen(Vector(320, 280)) - Game():GetRoom():GetRenderScrollOffset() - Game().ScreenShakeOffset) *
                2
            local windowY = windowsize.Y
            local windowX = windowsize.X
            if itemConfig.MaxCharges > 0 and currentCharge3 > 0 then
                local chargePercentage = currentCharge3 / itemConfig.MaxCharges * 100
                local twenty = 21.1
                local yxis = 10
                if chargePercentage == 100 then
                    fire_Red3.Scale = Vector(1.1, 1.1)
                    fire_Red3.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                        (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                    fire_Red3:Render(Vector(windowX - twenty - 1.6 * hudOffset,
                        windowY - 0 - 0.6 * hudOffset + defaultConfig.YaxisOffsetPlayer1Po))
                    if not isPaused then fire_Red3:Update() end
                elseif chargePercentage >= 1 and chargePercentage < 100 then
                    local scale = chargePercentage / 100
                    fire_Yellow3.Scale = Vector(scale + 0.13, scale + 0.13)
                    fire_Yellow3.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                        (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                    fire_Yellow3:Render(Vector(windowX - twenty - 1.6 * hudOffset,
                        windowY - yxis - 0.6 * hudOffset + (scale * 10) + defaultConfig.YaxisOffsetPlayer1Po))
                    if not isPaused then fire_Yellow3:Update() end
                end
            end
        end
    end

    local hasActiveItem2 = false
    for i = 1, CollectibleType.NUM_COLLECTIBLES do
        if player2:HasCollectible(i, false) and Isaac.GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_ACTIVE then
            hasActiveItem2 = true
            break
        end
    end

    if player2:GetPlayerType() == PlayerType.PLAYER_ESAU then
        if hasActiveItem2 and isHUDVisible then
            if Game():GetNumPlayers() > 1 and player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY) ~= 0
                and not (player2:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false)
                    and player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
                if renderFlagEssa then return end
                renderFlagEssa = true
                local itemConfig = Isaac.GetItemConfig():GetCollectible(player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
                local currentCharge2 = player2:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
                local windowsize = (Isaac.WorldToScreen(Vector(320, 280)) - Game():GetRoom():GetRenderScrollOffset() - Game().ScreenShakeOffset) *
                    2
                local windowY = windowsize.Y
                local windowX = windowsize.X
                local yxis = -10
                local twenty = 21.1
                if itemConfig.MaxCharges > 0 and currentCharge2 > 0 then
                    local chargePercentage = currentCharge2 / itemConfig.MaxCharges * 100
                    if chargePercentage == 100 then
                        fire_Red2.Scale = Vector(1.1, 1.1)
                        fire_Red2.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                            (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                        fire_Red2:Render(Vector(windowX - twenty - 1.6 * hudOffset,
                            windowY - 9 - 0.6 * hudOffset + defaultConfig.YaxisOffsetPlayerEssa))
                        if not isPaused then fire_Red2:Update() end
                    elseif chargePercentage >= 1 and chargePercentage < 100 then
                        local scale = chargePercentage / 100
                        fire_Yellow2.Scale = Vector(scale + 0.13, scale + 0.13)
                        fire_Yellow2.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                            (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
                        fire_Yellow2:Render(Vector(windowX - twenty - 1.6 * hudOffset,
                            windowY - 9 - 0.6 * hudOffset - yxis + (scale * 10) + defaultConfig.YaxisOffsetPlayerEssa))

                        if not isPaused or CutscenesMenu then fire_Yellow2:Update() end
                    end
                end
            end
        end
    end
end

local function ifusedactive()
    local player1 = Isaac.GetPlayer(0)
    local primaryItem = player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if not (player1:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false) and primaryItem == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
        firedown:Play("Disappear", true)
    end
end

function mod:RenderOnActiveItemUse()
    if renderFlag2 then return end
    renderFlag2 = true
    local player1 = Isaac.GetPlayer(0)
    local primaryItem = player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local pocketItem = player1:GetActiveItem(ActiveSlot.SLOT_POCKET)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(primaryItem)
    if primaryItem == pocketItem then return end -- to fix
    if itemConfig and itemConfig.MaxCharges > 0 then
        local currentCharge = player1:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
        if currentCharge < itemConfig.MaxCharges then
            local hudOffset = Options.HUDOffset * 10
            firedown.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01), (defaultConfig.Blue * 0.01),
                (defaultConfig.Transparency * 0.01), 0, 0, 0)
            firedown:Render(Vector(20 + 2 * hudOffset, 1.2 * hudOffset + 33 + defaultConfig.YaxisOffsetPlayer1PrDown))
            local isPaused = Game():IsPaused()
            if not isPaused then firedown:Update() end
        end
    end
end

local function ifusedactive2()
    local player1 = Isaac.GetPlayer(0)
    local primaryItem = player1:GetActiveItem(ActiveSlot.SLOT_POCKET)
    if not (player1:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false) and primaryItem == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
        firedown2:Play("Disappear", true)
    end
end

function mod:RenderOnActiveItemUse2()
    if renderFlag3 then return end
    renderFlag3 = true
    local player1 = Isaac.GetPlayer(0)
    local pocketItem = player1:GetActiveItem(ActiveSlot.SLOT_POCKET)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(pocketItem)
    local primaryItem = player1:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if primaryItem == pocketItem then return end
    if itemConfig and itemConfig.MaxCharges > 0 then
        local currentCharge = player1:GetActiveCharge(ActiveSlot.SLOT_POCKET)
        if currentCharge < itemConfig.MaxCharges then
            local hudOffset = Options.HUDOffset * 10
            local windowsize = (Isaac.WorldToScreen(Vector(320, 280)) - Game():GetRoom():GetRenderScrollOffset() - Game().ScreenShakeOffset) *
                2
            local windowY = windowsize.Y
            local windowX = windowsize.X
            firedown2.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01), (defaultConfig.Blue * 0.01),
                (defaultConfig.Transparency * 0.01), 0, 0, 0)
            firedown2:Render(Vector(windowX - 20 - 1.6 * hudOffset,
                windowY - 3.5 - 0.6 * hudOffset + defaultConfig.YaxisOffsetPlayer1PoDown))
            local isPaused = Game():IsPaused()
            if not isPaused then firedown2:Update() end
        end
    end
end

local function ifusedactiveEssa()
    local player2 = Isaac.GetPlayer(1)
    local primaryItem = player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    if not (player2:HasCollectible(CollectibleType.COLLECTIBLE_SUMPTORIUM, false) and primaryItem == CollectibleType.COLLECTIBLE_SUMPTORIUM) then
        firedownEssa:Play("Disappear", true)
    end
end

function mod:RenderOnActiveItemUseEssa()
    if renderFlagEssa2 then return end
    renderFlagEssa2 = true
    local player2 = Isaac.GetPlayer(1)
    local EssaItem = player2:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(EssaItem)
    if itemConfig and itemConfig.MaxCharges > 0 then
        local currentCharge = player2:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
        if currentCharge < itemConfig.MaxCharges then
            local hudOffset = Options.HUDOffset * 10
            local windowsize = (Isaac.WorldToScreen(Vector(320, 280)) - Game():GetRoom():GetRenderScrollOffset() - Game().ScreenShakeOffset) *
                2
            local windowY = windowsize.Y
            local windowX = windowsize.X
            firedownEssa.Color = Color((defaultConfig.Red * 0.01), (defaultConfig.Green * 0.01),
                (defaultConfig.Blue * 0.01), (defaultConfig.Transparency * 0.01), 0, 0, 0)
            firedownEssa:Render(Vector(windowX - 20 - 1.6 * hudOffset,
                windowY - 9 - 0.6 * hudOffset + defaultConfig.YaxisOffsetPlayerEssaDown))
            local isPaused = Game():IsPaused()
            if not isPaused then firedownEssa:Update() end
        end
    end
end
local function resetSprites()
    fire_Yellow:Play("Yellow", true)
    fire_YellowNotEssa:Play("Yellow", true)
    fire_Yellow2:Play("Yellow", true)
    fire_Yellow3:Play("Yellow", true)
    fire_Red:Play("", true)
    fire_RedNotEssa:Play("Idle2", true)
    fire_Red2:Play("Idle", true)
    fire_Red3:Play("Idle", true)
end
function mod:OnGameStart(isContinued)
    resetSprites()
    renderFlagPrimary = false
    renderFlagEssa = false
    renderFlagEssa2 = false
    renderFlagPocket = false
    renderFlagPrimaryNotEssa = false
    renderFlag2 = false
    renderFlag3 = false
    updateTimer = 0
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderOnActiveItemUse)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderOnActiveItemUseEssa)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderOnActiveItemUse2)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.FiredUPRender)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, activeSlot, customVarData)
    if Game():GetNumPlayers() >= 3 and Isaac.GetPlayer(2):GetPlayerType() == PlayerType.PLAYER_JACOB then return end
    if item == player:GetActiveItem(ActiveSlot.SLOT_POCKET) then
        ifusedactive2()
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, activeSlot, customVarData)
    if Game():GetNumPlayers() >= 3 and Isaac.GetPlayer(2):GetPlayerType() == PlayerType.PLAYER_JACOB then return end
    if item == player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) then
        if player:GetPlayerType() == PlayerType.PLAYER_JACOB then return end
        if player:GetPlayerType() == PlayerType.PLAYER_ESAU then return end
        if Isaac.GetPlayer(1):GetPlayerType() == PlayerType.PLAYER_ESAU then return end
        if player.Index == 0 then
            ifusedactive()
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, activeSlot, customVarData)
    if Game():GetNumPlayers() >= 3 and Isaac.GetPlayer(2):GetPlayerType() == PlayerType.PLAYER_JACOB then return end
    if item == player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) and player:GetPlayerType() == PlayerType.PLAYER_ESAU then
        ifusedactiveEssa()
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, activeSlot, customVarData)
    if Game():GetNumPlayers() >= 3 and Isaac.GetPlayer(2):GetPlayerType() == PlayerType.PLAYER_JACOB then return end
    if item == player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
        ifusedactive()
    end
end)

function mod:OnRender()
    renderFlagPocket = false
    renderFlagPrimary = false
    renderFlagEssa2 = false
    renderFlagPrimaryNotEssa = false
    renderFlagEssa = false
    renderFlag2 = false
    renderFlag3 = false
    if not Game():IsPaused() then
        updateTimer = updateTimer + 1
    end
    if updateTimer >= defaultConfig.Speed then
        updateTimer = 0
        fire_Yellow:Update()
        fire_YellowNotEssa:Update()
        fire_Yellow2:Update()
        fire_Yellow3:Update()
        fire_Red:Update()
        fire_RedNotEssa:Update()
        fire_Red2:Update()
        fire_Red3:Update()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.OnGameStart)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnRender)

ModConfigMenu = ModConfigMenu
if ModConfigMenu then
    local modSettings = "Ready To Fire UP!"
    ModConfigMenu.RemoveCategory(modSettings)
    ModConfigMenu.UpdateCategory(modSettings, {
        Info = { "Ready To Fire UP!", }
    })
    ModConfigMenu.AddText(modSettings, "Settings", function() return "Ready To Fire UP!" end)
    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------0-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["Transparency"]
            end,
            Minimum = 0,
            Maximum = 100,
            Display = function()
                return "Transparency: " .. persistentData["Transparency"]
            end,
            OnChange = function(currentNum)
                persistentData["Transparency"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change Transparency for the fire", "100 = Default, Set from 100 to 0" }
        })
    -------------------------------------0-2
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return persistentData["ShowFireinMenu"]
            end,
            Display = function()
                return "Show Fire in Menu: " .. (persistentData["ShowFireinMenu"] and "On" or "Off")
            end,
            OnChange = function(b)
                persistentData["ShowFireinMenu"] = b
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Do not forget to turn it Off!" }
        })
    -------------------------------------0-3
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["Speed"]
            end,
            Minimum = 0,
            Maximum = 30,
            Display = function()
                return "Speed: " .. persistentData["Speed"]
            end,
            OnChange = function(currentNum)
                persistentData["Speed"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change Speed of the fire", "30 = Default, Set from 30 to 0", "Noticeable difference from 5 to 0" }
        })
    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------C-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["Red"]
            end,
            Minimum = -100,
            Maximum = 200,
            Display = function()
                return "Red: " .. persistentData["Red"]
            end,
            OnChange = function(currentNum)
                persistentData["Red"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change Red value for the fire", "100 = Default, Set from -100 to 200" }
        })
    -------------------------------------C-2
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["Green"]
            end,
            Minimum = -100,
            Maximum = 200,
            Display = function()
                return "Green: " .. persistentData["Green"]
            end,
            OnChange = function(currentNum)
                persistentData["Green"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change Green value for the fire", "100 = Default, Set from -100 to 200" }
        })
    -------------------------------------C-3
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["Blue"]
            end,
            Minimum = -100,
            Maximum = 200,
            Display = function()
                return "Blue: " .. persistentData["Blue"]
            end,
            OnChange = function(currentNum)
                persistentData["Blue"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change Blue value for the fire", "100 = Default, Set from -100 to 200" }
        })
    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------1-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayer1Pr"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "1st Player: " .. persistentData["YaxisOffsetPlayer1Pr"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayer1Pr"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for main item" }
        })
    -------------------------------------1-2
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayer1PrDown"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "Extinguish: " .. persistentData["YaxisOffsetPlayer1PrDown"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayer1PrDown"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for main item extinguish animation" }
        })
    -------------------------------------1-3
    local function getTableIndex(tbl, val)
        for i, v in ipairs(tbl) do
            if v == val then
                return i
            end
        end

        return 0
    end

    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PrSkin3"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PrSkin3"]
            end,
            OnChange = function(n)
                persistentData["Player1PrSkin3"] = SkinChoices[n]
            end,
            Info = { "Change the skin of Not Charged fire" }
        }
    )
    -------------------------------------1-4

    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PrSkin"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PrSkin"]
            end,
            OnChange = function(n)
                persistentData["Player1PrSkin"] = SkinChoices[n]
            end,
            Info = function()
                if defaultConfig.Player1PrSkin == "White.Slow" or defaultConfig.Player1PrSkin == "White.Fast" then
                    return { "Change the skin of Charged fire" }
                else
                    return { "Change the skin of Charged fire" }
                end
            end
        })

    -------------------------------------1-5


    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PrSkin2"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PrSkin2"]
            end,
            OnChange = function(n)
                persistentData["Player1PrSkin2"] = SkinChoices[n]
            end,
            Info = { "Change the skin of Overcharged fire" }
        }
    )

    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------2-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayer1Po"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "1st Player: " .. persistentData["YaxisOffsetPlayer1Po"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayer1Po"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for pocket item" }
        })
    -------------------------------------2-2
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayer1PoDown"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "Extinguish: " .. persistentData["YaxisOffsetPlayer1PoDown"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayer1PoDown"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for pocket item extinguish animation" }
        })
    -------------------------------------2-3

    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PoSkin3"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PoSkin3"]
            end,
            OnChange = function(n)
                persistentData["Player1PoSkin3"] = SkinChoices[n]
            end,
            Info = { "Change the skin of Not Charged fire" }
        }
    )
    -------------------------------------2-4
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PoSkin"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PoSkin"]
            end,
            OnChange = function(n)
                persistentData["Player1PoSkin"] = SkinChoices[n]
            end,
            Info = { "Change the skin of Charged fire" }
        })

    -------------------------------------2-5
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return getTableIndex(SkinChoices, persistentData["Player1PoSkin2"])
            end,
            Minimum = 1,
            Maximum = #SkinChoices,
            Display = function()
                return "Skin: " .. persistentData["Player1PoSkin2"]
            end,
            OnChange = function(n)
                persistentData["Player1PoSkin2"] = SkinChoices[n]
            end,
            Info = { "Change the skin of Overcharged fire" }
        }
    )
    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------3-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayerEssa"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "Player Esau: " .. persistentData["YaxisOffsetPlayerEssa"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayerEssa"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for main item" }
        })
    -------------------------------------3-2
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayerEssaDown"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "Extinguish: " .. persistentData["YaxisOffsetPlayerEssaDown"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayerEssaDown"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for main item extinguish animation" }
        })
    ModConfigMenu.AddSpace(modSettings, "Settings")
    -------------------------------------4-1
    ModConfigMenu.AddSetting(modSettings, "Settings",
        {
            Type = ModConfigMenu.OptionType.NUMBER,
            CurrentSetting = function()
                return persistentData["YaxisOffsetPlayer2Pr"]
            end,
            Minimum = -100,
            Maximum = 100,
            Display = function()
                return "2nd Player: " .. persistentData["YaxisOffsetPlayer2Pr"] * 0.25
            end,
            OnChange = function(currentNum)
                persistentData["YaxisOffsetPlayer2Pr"] = currentNum
                mod:SaveData(json.encode(persistentData))
            end,
            Info = { "Change y axis for main item" }
        })
end

function mod:loadConfiguration()
    local success, data = pcall(function()
        if (mod:HasData()) then
            return json.decode(mod:LoadData())
        else
            return defaultConfig
        end
    end)

    if success and data then
        persistentData = data
    else
        print("[RTFU!] Error loading config, using default configuration")
        persistentData = defaultConfig
    end

    if (persistentData["configVersion"] == nil or persistentData["configVersion"] ~= defaultConfig["configVersion"]) then
        print("[RTFU!] Upgrading config to v" .. defaultConfig["configVersion"])
        persistentData["configVersion"] = defaultConfig["configVersion"]
        for key, value in pairs(defaultConfig) do
            if (persistentData[key] == nil) then
                persistentData[key] = value
            end
        end
    end

    if persistentData["YaxisOffsetPlayer1Pr"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayer1Pr"] = 0
    end
    if persistentData["YaxisOffsetPlayer1Po"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayer1Po"] = 0
    end
    if persistentData["YaxisOffsetPlayer2Pr"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayer2Pr"] = 0
    end
    if persistentData["YaxisOffsetPlayerEssa"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayerEssa"] = 0
    end
    if persistentData["YaxisOffsetPlayer1PrDown"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayer1PrDown"] = 0
    end
    if persistentData["YaxisOffsetPlayer1PoDown"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayer1PoDown"] = 0
    end
    if persistentData["YaxisOffsetPlayerEssaDown"] == nil or not ModConfigMenu then
        persistentData["YaxisOffsetPlayerEssaDown"] = 0
    end
    if persistentData["Transparency"] == nil or not ModConfigMenu then
        persistentData["Transparency"] = 100
    end
    if persistentData["ShowFireinMenu"] == nil or not ModConfigMenu then
        persistentData["ShowFireinMenu"] = false
    end
    if persistentData["Speed"] == nil or not ModConfigMenu then
        persistentData["Speed"] = 30
    end
    if persistentData["Red"] == nil or not ModConfigMenu then
        persistentData["Red"] = 100
    end
    if persistentData["Green"] == nil or not ModConfigMenu then
        persistentData["Green"] = 100
    end
    if persistentData["Blue"] == nil or not ModConfigMenu then
        persistentData["Blue"] = 100
    end
    if persistentData["Player1PrSkin"] == nil or not ModConfigMenu then
        persistentData["Player1PrSkin"] = "Yellow/Red.Slow"
    end
    if persistentData["Player1PrSkin2"] == nil or not ModConfigMenu then
        persistentData["Player1PrSkin2"] = "Blue.Fast"
    end
    if persistentData["Player1PrSkin3"] == nil or not ModConfigMenu then
        persistentData["Player1PrSkin3"] = "Yellow.Slow"
    end
    if persistentData["Player1PoSkin"] == nil or not ModConfigMenu then
        persistentData["Player1PoSkin"] = "Yellow/Red.Slow"
    end
    if persistentData["Player1PoSkin2"] == nil or not ModConfigMenu then
        persistentData["Player1PoSkin2"] = "Blue.Fast"
    end
    if persistentData["Player1PoSkin3"] == nil or not ModConfigMenu then
        persistentData["Player1PoSkin3"] = "Yellow.Slow"
    end
    mod:SaveData(json.encode(persistentData))
end

function mod:onGameStart()
    mod:loadConfiguration()
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadConfiguration)
