local TR_Manager = require("resurrected_modpack.manager")
ControlledRandomChar = TR_Manager:RegisterMod("Controlled Random Character", 1)

local mod = ControlledRandomChar
local json = require("json")

-- this code is messy don't mind me

SkipRender = false

local function copyColor(color)
    local colorize = color:GetColorize()

    local newColor = Color( color.R, color.G, color.B, color.A, 
                            color.RO, color.GO, color.BO, 
                            colorize.R, colorize.G, colorize.B, colorize.A)

    return newColor

end

mod:AddCallback(ModCallbacks.MC_PRE_RENDER_CHARACTER_SELECT_PORTRAIT, function(_, playerType, sprite, pos, scale, color)
    if not SkipRender then
        local charData = SelectedChars[tostring(playerType)]
        if charData then
            SkipRender = true
            local color = copyColor(sprite.Color)
            sprite.Color = Color(0,0,0,1,.75)
    
            local offset = Vector(1, 0) * scale
            for i = 0, 3 do
                sprite:Render(pos + offset:Rotated(i * 90))
            end
    
            sprite.Color = color
            SkipRender = false
        end
    end
end)

if mod:HasData() then
    SelectedChars = json.decode(mod:LoadData())
else
    SelectedChars = {}
end

CharSprites = {}

local portraitAnims = {
    [0] = "01_Isaac",
    [1] = "02_Magdalene",
    [2] = "03_Cain",
    [3] = "04_Judas",
    [4] = "06_Bluebaby",
    [5] = "05_Eve",
    [6] = "07_Samson",
    [7] = "08_Azazel",
    [8] = "09_Lazarus",
    [9] = "10_Eden",
    [10] = "11_TheLost",
    [11] = "09_Lazarus",
    [12] = "04_Judas",
    [13] = "12_Lilith",
    [14] = "13_Keeper",
    [15] = "15_Apollyon",
    [16] = "16_TheForgotten",
    [17] = "16_TheForgotten",
    [18] = "17_Bethany",
    [19] = "18_JacobEsau",
    [20] = "18_JacobEsau",
    
    [21] = "01_Isaac",
    [22] = "02_Magdalene",
    [23] = "03_Cain",
    [24] = "04_Judas",
    [25] = "06_Bluebaby",
    [26] = "05_Eve",
    [27] = "07_Samson",
    [28] = "08_Azazel",
    [29] = "09_Lazarus",
    [30] = "10_Eden",
    [31] = "11_TheLost",
    [32] = "12_Lilith",
    [33] = "13_Keeper",
    [34] = "15_Apollyon",
    [35] = "16_TheForgotten",
    [36] = "17_Bethany",
    [37] = "18_JacobEsau",
    [38] = "09_Lazarus",
    [39] = "18_JacobEsau",
    [40] = "16_TheForgotten",

}

CharSprites = {}

local function isSpriteLoadedForChar(playerType)
    return CharSprites[playerType] ~= nil
end

local function loadSpriteForChar(playerType)
    if not playerType then
        return
    end
    local sprite = Sprite()
    local playerCfg = EntityConfig.GetPlayer(playerType)
    local portraitSpriteModded = playerCfg:GetModdedMenuPortraitSprite()
    if portraitSpriteModded then
        sprite:Load(portraitSpriteModded:GetFilename(), true)
        sprite:Play(playerCfg:GetName(), true)
    else
        if playerCfg:IsTainted() then
            sprite:Load("gfx/ui/main menu/characterportraitsalt.anm2", true)
        else
            sprite:Load("gfx/ui/main menu/characterportraits.anm2", true)
        end
        sprite:Play(portraitAnims[playerType] or "01_Isaac", true)
    end
    CharSprites[playerType] = sprite
end

local bgPaper = Sprite("gfx/ui/random_char_ui.anm2", true)

local ctrlWidget = Sprite("gfx/ui/random_char_widget.anm2", true)
ctrlWidget:Play("Idle")

function Lerp(vec1, vec2, percent)
    return vec1 * (1 - percent) + vec2 * percent
end

IsMenuSpinning = false
WheelSpinOffset = 0
WheelSpinSpeed = .1

TeamMenuSecret = false

local RSTICK_PRESS = 13

local sfx = SFXManager()

local wasOnCharMenu = false
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, function(_)

    local isOnCharMenu = MenuManager.GetActiveMenu() == MainMenuType.CHARACTER
    if isOnCharMenu then
        if Input.IsButtonTriggered(Keyboard.KEY_G, 0) or Input.IsButtonTriggered(RSTICK_PRESS, 1) then
            TeamMenuSecret = not TeamMenuSecret
        end 

        if Input.IsActionTriggered(ButtonAction.ACTION_RESTART, 0) or Input.IsButtonTriggered(RSTICK_PRESS, 1) then
            SelectedChars = {}
            CharSprites = {}
            mod:SaveData(json.encode(SelectedChars))
        end
        
        local playerTypeNum = CharacterMenu.GetSelectedCharacterPlayerType()
        if playerTypeNum and (Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) or Input.IsActionTriggered(ButtonAction.ACTION_DROP, 1)) then
            local playerType = tostring(playerTypeNum) -- to string to force encoding as dict
            if playerType then
                if SelectedChars[playerType] then
                    SelectedChars[playerType] = nil
                    CharSprites[playerType] = nil
                    sfx:Play(SoundEffect.SOUND_CHARACTER_SELECT_LEFT, nil, nil, nil, .85)
                else
                    SelectedChars[playerType] = true
                    loadSpriteForChar(playerTypeNum)
                    sfx:Play(SoundEffect.SOUND_CHARACTER_SELECT_RIGHT, nil, nil, nil, .85)
                end
    
                mod:SaveData(json.encode(SelectedChars))
            end
        end
    end
    
    local sprites = {}
    for playerType,data in pairs(SelectedChars) do
        table.insert(sprites, {0, 0, playerType})
    end
    table.sort(sprites, function(var1,var2)
        var1 = tonumber(var1)
        var2 = tonumber(var2)

        if var1 and var2 and var1 < var2 then
            return true
        end 
    end)

    
    local renderTasks = {} -- anim, posOffset
    local distFromCenter = Lerp(0, 50, math.min(1, #sprites / 14))
    local spriteScale = 1

    
    for i,data in ipairs(sprites) do
        local index = data[1]
        local anim = data[2]
        local playerType = data[3]

        local rotOffset = ((((i - 1) / (#sprites)) * 360) + WheelSpinOffset) % 360
        local posOffset = Vector(0, distFromCenter):Rotated(rotOffset) * Vector(1, .5)
        
        table.insert(renderTasks, {anim, posOffset, playerType})
    end
    
    table.sort(renderTasks, function(var1, var2)
        if var1[2].Y < var2[2].Y then
            return true
        end
    end)

    
    local offsetFromVecZero = (MenuManager.GetViewPosition())
    local circleCenterPos = offsetFromVecZero + Vector(72,1000)

    bgPaper:Update()
    local anim = bgPaper:GetAnimation()
    
    local isFinished = bgPaper:IsFinished() or anim == ""

    local shouldPaperShow = #sprites > 0

    if isFinished then
        if not TeamMenuSecret then
            if shouldPaperShow then
                if (anim == "") or (anim == "Disappear") or (anim == "Disappear2") then
                    bgPaper:Play("Appear")
                    sfx:Play(SoundEffect.SOUND_PAPER_IN)
                end
            else
                if anim == "Appear" then
                    bgPaper:Play("Disappear")
                    sfx:Play(SoundEffect.SOUND_PAPER_OUT)
                end
            end
    
            if anim == "Appear2" then
                bgPaper:Play("Disappear2")
                sfx:Play(SoundEffect.SOUND_PAPER_OUT)
            end
        else
            if shouldPaperShow then
                if anim == "Disappear" or anim == "Disappear2" then
                    bgPaper:Play("Appear2")
                    sfx:Play(SoundEffect.SOUND_PAPER_IN)
                end
            else
                if anim == "Appear2" then
                    bgPaper:Play("Disappear2")
                    sfx:Play(SoundEffect.SOUND_PAPER_OUT)
                end
            end
            if anim == "Appear" then
                bgPaper:Play("Disappear")
                sfx:Play(SoundEffect.SOUND_PAPER_OUT)
            end
        end
    end

    ctrlWidget:Render(circleCenterPos + Vector(385, -71))

    bgPaper:Render(circleCenterPos + Vector(46, 20))

    local backScale = .33

    local paperLayerFrame = bgPaper:GetLayerFrameData(0)
    local paperScale = paperLayerFrame and paperLayerFrame:GetScale() or Vector.One
    local paperPos = paperLayerFrame and paperLayerFrame:GetPos() or Vector.Zero

    local closestToFront = nil

    for _,data in ipairs(renderTasks) do
        local anim = data[1]
        local posOffset = data[2]
        local playerType = data[3]
        local playerTypeNum = tonumber(playerType)
        
        if playerType and not isSpriteLoadedForChar(playerTypeNum) then
            loadSpriteForChar(playerTypeNum)
        end

        local sprite = CharSprites[playerTypeNum]
        if sprite then
            local frontDist = 27.5
            local backDist = 82.5
            local span = backDist - frontDist

            local distFromFront = math.abs(distFromCenter - posOffset.Y)
            local t = math.min(math.max(distFromFront - frontDist, 0), span)

            local camDist = span * backScale / (1 - backScale)

            local depthScale = camDist / (camDist + t)
            local toBackPercent = 1 - depthScale

            sprite.Color = Color.Lerp(Color(1,1,1,1), Color(.19,.19,.19,1,.75,.7,.7), toBackPercent)

            sprite.Scale = Vector.One * spriteScale * (depthScale) * paperScale

            posOffset.X = posOffset.X * depthScale * 2
            posOffset.Y = posOffset.Y * depthScale

            sprite:Render(circleCenterPos + posOffset + paperPos)
            
            closestToFront = playerTypeNum
        end
    end



    if (isOnCharMenu and wasOnCharMenu) and CharacterMenu.GetSelectedCharacterID() == 0 then
        -- Question selected
        MenuManager.SetInputMask(MenuManager.GetInputMask() & ~ButtonActionBitwise.ACTION_MENUCONFIRM)
        
        local confirmKeyboard = Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, 0)
        local confirmController = Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, 1)
        
        if confirmKeyboard or confirmController then
            if confirmKeyboard then
                NewPlayerIndex = 0
            else
                NewPlayerIndex = 1
            end
            WheelSpinSpeed = math.max(math.random(100, 250) / 10, WheelSpinSpeed)
            IsMenuSpinning = true
        end
    else
        MenuManager.SetInputMask(MenuManager.GetInputMask() | ButtonActionBitwise.ACTION_MENUCONFIRM)
    end

    local prevWheelSpinOffset = WheelSpinOffset
    WheelSpinOffset = WheelSpinOffset + WheelSpinSpeed
    
    if not isOnCharMenu then
        IsMenuSpinning = false
    end

    if not IsMenuSpinning then
        WheelSpinSpeed = Lerp(WheelSpinSpeed, .1, .025)
    else
        WheelSpinSpeed = WheelSpinSpeed - .05
        local step = (360 / #sprites)
        
        if math.floor(prevWheelSpinOffset / step) ~= math.floor(WheelSpinOffset / step) then
            sfx:Play(SoundEffect.SOUND_CHARACTER_SELECT_RIGHT)
        end
        
        if WheelSpinSpeed <= .0025 then
            WheelSpinSpeed = 0
            
            local snappedOffset = math.floor(WheelSpinOffset / step + 0.5) * step
            WheelSpinOffset = Lerp(WheelSpinOffset, snappedOffset, .05)
            
            if math.abs(snappedOffset - WheelSpinOffset) < .25 then
                Isaac.StartNewGame(closestToFront, nil, CharacterMenu.GetDifficulty())
                IsMenuSpinning = false
            end
        end
    end

    wasOnCharMenu = isOnCharMenu
end)



CharsSpawned = false
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if not SkipInit then
        CharSprites = {}
        if NewPlayerIndex then
            player:SetControllerIndex(NewPlayerIndex, true)
            local twin = player:GetOtherTwin()
            if twin then
                player:SetControllerIndex(NewPlayerIndex, true)
            end
        end
        if TeamMenuSecret then
            SkipInit = true
            for playerType, _ in pairs(SelectedChars) do
                local playerTypeNum = tonumber(playerType)
                if playerTypeNum and player:GetPlayerType() ~= playerTypeNum then
                    player:InitTwin(playerTypeNum)
                end
            end
            SkipInit = nil
        end
        NewPlayerIndex = nil
    end
end)