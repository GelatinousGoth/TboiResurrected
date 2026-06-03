local function RunLoggerEnabler()

local mod = IsaacReflourished
IsaacReflourished.RunLogger = {}
local RunLogger = IsaacReflourished.RunLogger

local saveMan = IsaacReflourished.SaveManager

local lang = Options.Language


local function framesToTime(frameCount)
    local totalSeconds = math.floor(frameCount / 30)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function getItemName(id)
    if id >= CollectibleType.NUM_COLLECTIBLES then
        return(Isaac.GetItemConfig():GetCollectible(id).Name)
    else
        local name = Isaac.GetItemConfig():GetCollectible(id) 
                    and Isaac.GetItemConfig():GetCollectible(id).Name
                    and Isaac.GetLocalizedString("Items", Isaac.GetItemConfig():GetCollectible(id).Name, "en_us")
        if name then
            return name
        else
            return "Unknown Item"
        end
    end
end


mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, slot, isSelected, rawSlot)
    if not isSelected then return end
    if rawSlot == 0 then return end
    local save = saveMan.GetPersistentSave()
    if save then
        if not save.Records then
            save.Records = {}
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if isContinued then return end
    local game = Game()
    local runSave = saveMan.GetRunSave()
    local stageName = game:GetLevel():GetName()
    if StageAPI and StageAPI.CurrentStage and StageAPI.CurrentStage:GetDisplayName() then
        stageName = StageAPI.CurrentStage:GetDisplayName()
    end
    runSave.RunRecord = {
        char = Isaac.GetPlayer():GetName(),
        furthest = stageName,
        seed = game:GetSeeds():GetStartSeedString(),
        difficulty = game.Difficulty,
        challenge = game.Challenge ~= 0 and game:GetChallengeParams():GetName(),
        unlocksDisallowed = game:AchievementUnlocksDisallowed(),
        time = "00:00:00",
        realTime = os.date("%b %d, %Y - %I:%M%p"),
        score = 0,
        marks = {},
        items = {},
        firstItem = nil,
        favoriteItem = nil,
        hitCount = 0,
        itemCount = 0,
        streak = {}
    }
    runSave.UsedItems = {}
end)

local dssSettingToNum = {
    [1] = 50,
    [2] = 100,
    [3] = 150,
    [4] = 250,
    [5] = 350,
    [6] = 500,
    [7] = 750,
    [8] = 1000,
    [9] = 5000
}


function RunLogger:SaveRecord(gameOver)
    local game = Game()
    local runSave = saveMan.GetRunSave()
    local record = runSave.RunRecord
    if (not record) or record == {} then
        print("No record to save!")
        return
    end
    local stageName = game:GetLevel():GetName()
    if StageAPI and StageAPI.CurrentStage and StageAPI.CurrentStage:GetDisplayName() then
        stageName = StageAPI.CurrentStage:GetDisplayName()
    end

    record.furthest = stageName
    record.time = framesToTime(game.TimeCounter)
    ScoreSheet.Calculate()
    record.score = ScoreSheet.GetTotalScore()

    --fallbacks in case it somehow failed to store these values at the start of the run
    record.difficulty = record.difficulty or game.Difficulty
    record.realTime = record.realTime or os.date("%b %d, %Y - %I:%M%p")
    record.seed = record.seed or game:GetSeeds():GetStartSeedString()



    runSave.UsedItems = runSave.UsedItems or {}
    local favoriteItem
    local favoriteItemUses = 0
    for item, timesUsed in pairs(runSave.UsedItems) do
        if timesUsed > favoriteItemUses then
            favoriteItemUses = timesUsed
            favoriteItem = item
        end
    end
    if favoriteItem then
        record.favoriteItem = favoriteItem
        record.items = record.items or {}
        table.insert(record.items, favoriteItem)
    end

    local itemCount = 0

    local realPlayers = {}
    for i = #PlayerManager.GetPlayers(), 1, -1 do
        local player = PlayerManager.GetPlayers()[i]
        if not player.Parent then
            itemCount = itemCount + player:GetCollectibleCount()
            realPlayers[i] = player
            for _, historyItem in pairs(player:GetHistory():GetCollectiblesHistory()) do
                if not historyItem:IsTrinket() then
                    local name = getItemName(historyItem:GetItemID())
                    if name ~= favoriteItem then
                        table.insert(record.items, name)
                    end
                end
            end
        end
    end
    record.itemCount = itemCount
    for i, player in pairs(realPlayers) do
        local name = player:GetName() .. ((EntityConfig.GetPlayer(player:GetPlayerType()):IsTainted() and "?") or "")
        if i == 1 then
            record.char = name
        elseif i < #realPlayers then
            record.char = record.char .. ", " .. name
        elseif #realPlayers == 2 then
            record.char = record.char .. " & " .. name
        else
            record.char = record.char .. ", & " .. name
        end
    end

    record.streak = (Isaac.GetPersistentGameData():GetEventCounter(EventCounter.STREAK_COUNTER) or 0)
    if gameOver then record.streak = 0 end

    record.lostRun = gameOver

    local save = saveMan.GetPersistentSave()
    if save then
        save.Records = save.Records or {}
        table.insert(save.Records, 1, record)
        local maxRuns = dssSettingToNum[IsaacReflourished:GetSettingsValue("RunLoggerMaxRuns")] or 100
        if #save.Records > maxRuns then
            table.remove(save.Records)
        end
        runSave.RunRecord = nil
        print("Record Saved!")
    else
        print("Record Failed to Save!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function(_, gameOver)
    RunLogger:SaveRecord(gameOver)
end)


mod:AddCallback(ModCallbacks.MC_POST_CHALLENGE_DONE, function(_, challenge)
    RunLogger:SaveRecord(false)
end)

mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, mark)
    local runSave = saveMan.GetRunSave()
    runSave.RunRecord = runSave.RunRecord or {}
    local record = runSave.RunRecord
    record.marks = record.marks or {}

    local alreadyHas = false
    for _, existingMark in ipairs(record.marks) do
        if existingMark == mark then
            alreadyHas = true
            break
        end
    end

    if not alreadyHas then
        table.insert(record.marks, mark)
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_ , entity, damage, flags)
    local player = entity:ToPlayer()
    if not player then return end
    if flags & (DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES) > 0 then return end
    local runSave = saveMan.GetRunSave().RunRecord
    if not runSave then return end
    runSave.hitCount = (runSave.hitCount or 0) + 1

end)


mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item, charge, firstTime)
    if not firstTime then return end
    if Game():GetFrameCount() <=1 then return end
    local runSave = saveMan.GetRunSave()
    if not runSave then return end
    local record = runSave.RunRecord or {}

    if record.firstItem then return end

    record.firstItem = getItemName(item)
end)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player, flags, slot)
    if slot == -1 then return end
    local runSave = saveMan.GetRunSave()
    if not runSave then return end

    local itemName = getItemName(item)
    runSave.UsedItems = runSave.UsedItems or {}
    local usedItems = runSave.UsedItems
    usedItems[itemName] = (usedItems[itemName] or 0) + 1
end)








            ------------------------------------MENU STUFF--------------------------------------------







local COMPLETION_MARK_LAYERS = {
    [CompletionType.MOMS_HEART] = 1,
    [CompletionType.ISAAC] = 2,
    [CompletionType.SATAN] = 3,
    [CompletionType.BOSS_RUSH] = 4,
    [CompletionType.BLUE_BABY] = 5,
    [CompletionType.LAMB] = 6,
    [CompletionType.MEGA_SATAN] = 7,
    [CompletionType.ULTRA_GREED] = 8,
    [CompletionType.ULTRA_GREEDIER] = 8,
    [CompletionType.DELIRIUM] = 13,
    [CompletionType.MOTHER] = 10,
    [CompletionType.BEAST] = 11,
    [CompletionType.HUSH] = 9,
    ["MOM"] = 12
}


RunLogger.CONFIG = {
    RecordsMenuType = 346, -- change back to 346
    RecordsStatsMenuIndex = REPENTANCE_PLUS and 5 or 4,
    PagePosition = Vector(700, 600), --(high right, high down)
    RightPageOffset = Vector(215, 0),
    ViewportOffset = Vector(439.5, -1570), --(low moves camera right, low moves camera down)
    LeftPage = {
        EntriesPerPage = 10,
        PageSize = Vector(215, 226),
        TitleTextPos = Vector(-94, -100),
        ListStartPos = Vector(-86, 35),
        LeftPadding = 10,
        LineHeight = 20,
        LineMaxWidth = 184,
        CursorOffset = Vector(-12, 7),
        DifficultyIconOffset = Vector(-19, -1),
        LeftArrowOffset = Vector(-205, -93),
        RightArrowOffset = Vector(-87, -94)

    },
    RightPage = {
        PageSize = Vector(195, 235),
        SubTitleTextPos = Vector(-106, -75),
        ListStartPos = Vector(-100, 65),
        ItemListStartPos = Vector(125, 86),
        ItemCursorOffset = Vector(-84, 20),
        ItemNamePos = Vector(110, 80),
        MarksPos = Vector(145, 14),
        LeftArrowOffset = Vector(-13, 7),
        RightArrowOffset = Vector(13, 7),
        LeftPadding = 10,
        LineHeight = 20,
        ValueOffset = 90,
        SmallValueOffset = 60,
        Spacing = 20,
        MaxItemsPerPage = 20,
        ItemsPerRow = 10
    },
    InputMask = {
        AllInputs = (1 << 29) - 1,
        StatsMenu = ButtonActionBitwise.ACTION_MENULEFT
                    | ButtonActionBitwise.ACTION_MENURIGHT
                    | ButtonActionBitwise.ACTION_FULLSCREEN
                    | ButtonActionBitwise.ACTION_MUTE
                    | ButtonActionBitwise.ACTION_MENUBACK
                    | ButtonActionBitwise.ACTION_MENUCONFIRM
                    | ButtonAction.ACTION_BOMB,
    }
}


local usingController = false
local copiedTextShowing = false


local config = RunLogger.CONFIG

local displayedMarks = {}
local displayedItems = {}
local heldUp = 0
local heldDown = 0

local leftPressed = 0
local rightPressed = 0


local recordsMenuAllowedInputs = ButtonActionBitwise.ACTION_FULLSCREEN | ButtonActionBitwise.ACTION_MUTE

local wasStatsMenuOpen = false

IsaacReflourished.RecordsMenuOpen = false
local recordsPageOpen = IsaacReflourished.RecordsMenuOpen


RunLogger.SupportedLanguages = {
    ["kr"] = true,
    ["es"] = true,
    ["zh"] = true,
    ["ru"] = true
}

function RunLogger:GetAnimation(anim)
    local isRepPlus = REPENTANCE_PLUS

    local languageSuffix = Options.Language
    if RunLogger.SupportedLanguages[languageSuffix] then
        if isRepPlus then 
            return "gfx/ui_rep+/main menu/" .. anim .. "." .. languageSuffix .. ".anm2"
        else
            return "gfx/ui/main menu/" .. anim .. "." .. languageSuffix .. ".anm2"
        end
    else
        if isRepPlus then 
            return "gfx/ui_rep+/main menu/" .. anim .. ".anm2"
        else
            return "gfx/ui/main menu/" .. anim .. ".anm2"
        end
    end

end

local recordsPageSprite = Sprite()


if RunLogger.SupportedLanguages[lang] then
    recordsPageSprite:Load("gfx/ui/main menu/translations/records_menu_" .. lang .. ".anm2", true)
else
    recordsPageSprite:Load("gfx/ui/main menu/records_menu.anm2", true)
end
recordsPageSprite:Play("Idle", true)

local cursorSprite = Sprite()
cursorSprite:Load("gfx/ui/main menu/cursor.anm2", true)

local selectedIndex = 1
local currentPage = 1
local selectedItem = 1
local currentItemPage = 1

function RunLogger:RenderStatsMenu()
    if recordsPageOpen then return end

    local menu = MenuManager.GetActiveMenu()
    --Restore inputs when stats menu is closed
    if wasStatsMenuOpen and menu ~= config.RecordsMenuType and ((menu ~= MainMenuType.STATS) or (StatsMenu.IsSecretsMenuVisible())) then
        wasStatsMenuOpen = false
        MenuManager.SetInputMask(config.InputMask.AllInputs)
        return
    end


    if menu ~= MainMenuType.STATS then return end
    if not wasStatsMenuOpen then
        wasStatsMenuOpen = true
        return
    end


    if StatsMenu.IsSecretsMenuVisible() then return end


    local page = StatsMenu.GetStatsMenuSprite()
    if page:GetFilename() == "gfx/ui/main menu/StatsMenu.anm2" or page:GetFilename() == "gfx/ui/main menu/statsmenu.anm2" then
        if RunLogger.SupportedLanguages[lang] then
            page:Load("gfx/ui/main menu/translations/statsmenu_" .. lang .. ".anm2", true)
        else
            page:Load("gfx/ui/main menu/statsmenu_new.anm2", true)
        end
        page:Play("Idle", true)
    end
        -- local lang = "kr"
        -- if RunLogger.SupportedLanguages[lang] then
        --     StatsMenu.GetStatsMenuSprite():ReplaceSpritesheet(0,"gfx/ui/main menu/translations/statsmenu_es.png", true)
        --     print(StatsMenu.GetStatsMenuSprite():GetFilename())
        --     StatsMenu.GetStatsMenuSprite():LoadGraphics()
        -- end

    MenuManager.SetInputMask(config.InputMask.StatsMenu)

    local selected = StatsMenu.GetSelectedElement()
    if Input.IsActionTriggered(ButtonAction.ACTION_MENUUP, -1) or Input.IsActionTriggered(ButtonAction.ACTION_MENUDOWN, -1) then
        local elementSetTo
        if Input.IsActionTriggered(ButtonAction.ACTION_MENUUP, -1) then
            elementSetTo = selected - 1
        elseif Input.IsActionTriggered(ButtonAction.ACTION_MENUDOWN, -1) then
            elementSetTo = selected + 1
        end
        if elementSetTo then
            if elementSetTo < 0 then
                elementSetTo = config.RecordsStatsMenuIndex
            elseif elementSetTo > config.RecordsStatsMenuIndex then
                elementSetTo = 0
            end
            StatsMenu.SetSelectedElement(elementSetTo)
        end
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, -1) and selected == config.RecordsStatsMenuIndex then
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
        MenuManager.SetInputMask(recordsMenuAllowedInputs)
        MenuManager.SetActiveMenu(config.RecordsMenuType)
        recordsPageOpen = true
        --recordsPageSprite:Play("Appear", true)
        selectedIndex = 1
        currentPage = 1

    end
end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, RunLogger.RenderStatsMenu)


function RunLogger:RenderRecordsMenu()

    local renderPos = Isaac.WorldToMenuPosition(MainMenuType.STATS, config.PagePosition)
    recordsPageSprite:Render(renderPos)

    if not saveMan.Utility.IsDataInitialized(true) then return end
    local records = saveMan.GetPersistentSave() and saveMan.GetPersistentSave().Records
    if not records then return end

    local sel = records[selectedIndex] or records[1] or { seed = "-", time = "-", score = 0, marks = {}}
    RunLogger:RenderLeftPanel(records, renderPos)

    RunLogger:RenderRightPanel(sel, renderPos)

    if MenuManager.GetActiveMenu() == config.RecordsMenuType then
        local pos = Isaac.WorldToMenuPosition(MainMenuType.STATS, config.ViewportOffset)
        MenuManager.SetViewPosition(pos)

        MenuManager.SetInputMask(recordsMenuAllowedInputs)
        RunLogger:HandleListInput(records, sel)
        RunLogger:ControllerTest()
    end
end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, RunLogger.RenderRecordsMenu)


function RunLogger:HandleListInput(runs, selectedRun)
    local totalPages = math.ceil(#runs / config.LeftPage.EntriesPerPage)
    local selectedRecordChanged = false
    local startIndex = (currentPage - 1) * config.LeftPage.EntriesPerPage + 1
    local endIndex = math.min(startIndex + config.LeftPage.EntriesPerPage - 1, #runs)

    local itemsPerPage = config.RightPage.MaxItemsPerPage
    local totalItems = #(selectedRun.items or {})
    local totalItemPages = math.max(1, math.ceil(totalItems / itemsPerPage))


    local function moveUp()
        selectedIndex = selectedIndex - 1
        selectedRecordChanged = true
        if selectedIndex < startIndex then
            selectedIndex = endIndex
        end
    end

    local function moveDown()
        selectedIndex = selectedIndex + 1
        selectedRecordChanged = true
        if selectedIndex > endIndex then
            selectedIndex = startIndex
        end
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_MENUUP, -1) then
        moveUp()
    elseif Input.IsActionTriggered(ButtonAction.ACTION_MENUDOWN, -1) then
        moveDown()
    end

    if Input.IsActionPressed(ButtonAction.ACTION_MENUUP, -1) then
        heldUp = heldUp + 1
        if heldUp > 20 and heldUp % 8 == 0 then
            moveUp()
        end
    elseif Input.IsActionPressed(ButtonAction.ACTION_MENUDOWN, -1) then
        heldDown = heldDown + 1
        if heldDown > 20 and heldDown % 8 == 0 then
            moveDown()
        end

    end

    if not Input.IsActionPressed(ButtonAction.ACTION_MENUUP, -1) then
        heldUp = 0
    end
    if not Input.IsActionPressed(ButtonAction.ACTION_MENUDOWN, -1) then
        heldDown = 0
    end


    if Input.IsActionTriggered(ButtonAction.ACTION_MENULEFT, -1) and totalPages > 1 then
        currentPage = currentPage - 1
        selectedRecordChanged = true
        if currentPage < 1 then
            currentPage = totalPages
        end
        selectedIndex = (currentPage - 1) * config.LeftPage.EntriesPerPage + 1
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
    elseif Input.IsActionTriggered(ButtonAction.ACTION_MENURIGHT, -1) and totalPages > 1  then
        currentPage = currentPage + 1
        selectedRecordChanged = true
        if currentPage > totalPages then
            currentPage = 1
        end
        selectedIndex = (currentPage - 1) * config.LeftPage.EntriesPerPage + 1
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
    end

    if Input.IsActionTriggered(ButtonAction.ACTION_MENUTAB, -1) then
        local record = runs[selectedIndex]
        if record and record.seed then
            Isaac.SetClipboard(record.seed)
            SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
            copiedTextShowing = true
            recordsPageSprite:SetFrame("Idle", 1)
            print("Seed "..record.seed.. " copied to clipboard!")
        end
    end 

    if Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, -1) then
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
        MenuManager.SetInputMask(config.InputMask.StatsMenu)
        MenuManager.SetActiveMenu(MainMenuType.STATS)
        selectedRecordChanged = true
        recordsPageOpen = false
        --recordsPageSprite:Play("Disappear", true)
    end

    local function moveLeft()
        local globalIndex = (currentItemPage - 1) * itemsPerPage + selectedItem
        globalIndex = globalIndex - 1

        -- Wrap to last item
        if globalIndex < 1 then
            globalIndex = totalItems
        end

        currentItemPage = math.ceil(globalIndex / itemsPerPage)
        selectedItem = globalIndex - (currentItemPage - 1) * itemsPerPage
    end

    local function moveRight()
        local globalIndex = (currentItemPage - 1) * itemsPerPage + selectedItem
        globalIndex = globalIndex + 1

        -- Wrap to first item
        if globalIndex > totalItems then
            globalIndex = 1
        end

        currentItemPage = math.ceil(globalIndex / itemsPerPage)
        selectedItem = globalIndex - (currentItemPage - 1) * itemsPerPage
    end

    if Input.IsButtonTriggered(Keyboard.KEY_Q, -1) or Input.IsButtonTriggered(9, -1) then
        moveLeft()

    elseif Input.IsButtonTriggered(Keyboard.KEY_E, -1) or Input.IsButtonTriggered(12, -1)  then
        moveRight()
    end

    
    if Input.IsButtonPressed(Keyboard.KEY_Q, -1) or Input.IsButtonPressed(9, -1) then
        leftPressed = leftPressed + 1
        if leftPressed > 20 and leftPressed % 5 == 0 then
            moveLeft()
        end
    elseif Input.IsButtonPressed(Keyboard.KEY_E, -1) or Input.IsButtonPressed(12, -1) then
        rightPressed = rightPressed + 1
        if rightPressed > 20 and rightPressed % 5 == 0 then
            moveRight()
        end
    end

    if not (Input.IsButtonPressed(Keyboard.KEY_Q, -1) or Input.IsButtonPressed(9, -1)) then
        leftPressed = 0
    end
    if not (Input.IsButtonPressed(Keyboard.KEY_E, -1) or Input.IsButtonPressed(12, -1)) then
        rightPressed = 0
    end

    if selectedRecordChanged then
        copiedTextShowing = false
        recordsPageSprite:SetFrame("Idle", 0)
        displayedMarks = {}
        selectedItem = 1
        currentItemPage = 1
    end
end


local spriteFont = Font()
spriteFont:Load("font/teammeatfont10.fnt")

local difficultySprite = Sprite()
difficultySprite:Load("gfx/ui/RFlobbymodeicons.anm2")
difficultySprite:SetFrame("Icons", 0)


function RunLogger:RenderLeftPanel(runs, renderPos)

    local titlePos = renderPos + config.LeftPage.TitleTextPos

    if #runs == 0 then
        spriteFont:DrawString(
        "No Records Yet!",
        renderPos.X - config.LeftPage.PageSize.X/2 + config.LeftPage.ListStartPos.X,
        renderPos.Y - config.LeftPage.PageSize.Y/2 + config.LeftPage.ListStartPos.Y,
        KColor(0.2, 0.05, 0.05, 1),
        spriteFont:GetStringWidth("No Records Yet!"),
        true
    )
    return
    end

    local totalPages = math.max(1, math.ceil(#runs / config.LeftPage.EntriesPerPage))

    local pageText = string.format("(Page %d/%d)", currentPage, totalPages)
    local pageTextWidth = spriteFont:GetStringWidth(pageText)
    -- title
    spriteFont:DrawString(
        pageText,
        titlePos.X,
        titlePos.Y,
        KColor(0.2, 0.05, 0.05, 1),
        spriteFont:GetStringWidth(pageText),
        true
    )

    cursorSprite:SetFrame("cursor", 1)
    cursorSprite:Render(renderPos + config.LeftPage.LeftArrowOffset)
    cursorSprite:SetFrame("cursor", 0)
    cursorSprite:Render(renderPos + config.LeftPage.RightArrowOffset + Vector(pageTextWidth, 0))


    local lineHeight = config.LeftPage.LineHeight
    local bgX = renderPos.X - config.LeftPage.PageSize.X/2 + config.LeftPage.ListStartPos.X
    local bgY = renderPos.Y - config.LeftPage.PageSize.Y/2 + config.LeftPage.ListStartPos.Y

    local startIndex = (currentPage - 1) * config.LeftPage.EntriesPerPage + 1
    local endIndex = math.min(startIndex + config.LeftPage.EntriesPerPage - 1, #runs)
    local displayIndex = 0

    for i = startIndex, endIndex do
        displayIndex = displayIndex + 1
        local run = runs[i]
        local isChallenge = run.challenge and run.challenge ~= ""
        
        local text = (isChallenge and run.challenge) or string.format("%s to %s", run.char, run.furthest)
        local lineY = bgY + (displayIndex - 1) * lineHeight
        local iconOffset = 0

        
        difficultySprite:SetFrame("Icons", run.difficulty or 0)
        if isChallenge then
            difficultySprite:SetFrame("Icons", 4)
        end
        difficultySprite:Render(Vector(bgX, lineY) + config.LeftPage.DifficultyIconOffset)
        

        local textWidth = spriteFont:GetStringWidth(text)
        local scale = 1
        local wrapped = false
        local lines = {}

        local textSpace = config.LeftPage.LineMaxWidth

        if textWidth > textSpace then
            scale = textSpace / textWidth

            if scale < 0.8 then
                lines = RunLogger:WrapTextByWidth(text, textSpace * 1.25)
                scale = 0.8
                wrapped = true
            else
                lines = { text }
            end
        else
            lines = { text }
        end

        local yOffset = (1 - scale) / 0.2 * 2

        for li, line in ipairs(lines) do
            local y = lineY + (li - 1) * (lineHeight - 11)

            if i == selectedIndex and li == 1 then
                cursorSprite:SetFrame("cursor", 2)
                cursorSprite:Render(Vector(bgX, y) + config.LeftPage.CursorOffset)
            end

            -- draw text
            spriteFont:DrawStringScaled(
                line,
                bgX,
                (wrapped and (y - 3) or y) + yOffset,
                scale,
                scale,
                KColor(0.12, 0.06, 0.06, 1),
                0,
                false
            )
        end
    end
end



-- Render right panel (details for selected run)
function RunLogger:RenderRightPanel(run, renderPos)


    local titlePos = renderPos + config.RightPageOffset

    if not (cursorSprite and cursorSprite:IsLoaded()) then
        cursorSprite = Sprite()
        cursorSprite:Load("gfx/ui/main menu/cursor.anm2", true)
    end


    cursorSprite:SetFrame("icons", 0)
    if run.lostRun then
        cursorSprite:SetFrame("icons", 1)
    end
    cursorSprite:Render(renderPos + recordsPageSprite:GetNullFrame("victoryiconposition"):GetPos())

    if run.unlocksDisallowed then
        cursorSprite:SetFrame("icons", 2)
        cursorSprite:Render(renderPos + recordsPageSprite:GetNullFrame("achievementiconposition"):GetPos())
    end

    if not copiedTextShowing then
        if usingController then
            cursorSprite:SetFrame("buttons", 10)
        else
            cursorSprite:SetFrame("buttons", 2)
        end
        cursorSprite:Render(renderPos + recordsPageSprite:GetNullFrame("seedbuttonposition"):GetPos())
    end
    

    local bgX = renderPos.X - config.RightPage.PageSize.X/2 + config.RightPage.ListStartPos.X + config.RightPageOffset.X
    local bgY = renderPos.Y - config.RightPage.PageSize.Y/2 + config.RightPage.ListStartPos.Y + config.RightPageOffset.Y

    local labelX = bgX
    local valueX = bgX + config.RightPage.ValueOffset
    local smallValueX = bgX + config.RightPage.SmallValueOffset

    local spacing = config.RightPage.Spacing

    local y = bgY

    local timeText = run.realTime or "-"
    spriteFont:DrawString(timeText, titlePos.X + config.RightPage.SubTitleTextPos.X - (spriteFont:GetStringWidth(timeText)/2), titlePos.Y + config.RightPage.SubTitleTextPos.Y, KColor(0.2,0.05,0.05,1))

    spriteFont:DrawString("Time:", labelX, y, KColor(0.12,0.06,0.06,1))
    spriteFont:DrawString(run.time or "-", smallValueX, y, KColor(0.12,0.06,0.06,1))
    y = y + spacing

    spriteFont:DrawString("Seed:", labelX, y, KColor(0.12,0.06,0.06,1))
    spriteFont:DrawString(run.seed or "-", smallValueX, y, KColor(0.12,0.06,0.06,1))
    y = y + spacing

    spriteFont:DrawString("Score:", labelX, y, KColor(0.12,0.06,0.06,1))
    spriteFont:DrawString(tostring(run.score or 0), smallValueX, y, KColor(0.12,0.06,0.06,1))
    y = y + spacing

    spriteFont:DrawString("Streak:", labelX, y, KColor(0.12,0.06,0.06,1))
    spriteFont:DrawString(tostring(run.streak or 0), smallValueX, y, KColor(0.12,0.06,0.06,1))
    y = y + spacing

    if #run.marks > 0 and recordsPageOpen then

        if #displayedMarks <= 0 then
            displayedMarks = self:CreateMarkSprites(run)
        end
        if #displayedMarks > 0 then
            displayedMarks[1]:Render(renderPos + config.RightPage.MarksPos)
            displayedMarks[2]:Render(renderPos + config.RightPage.MarksPos)
        end


        -- if #run.marks > 5 then
        --     y = y + 5
        -- end

        -- spriteFont:DrawString("Marks Gained:", labelX, y, KColor(0.12,0.06,0.06,1), 0, false)
        -- if #displayedMarks <= 0 then
        --     displayedMarks = self:CreateMarkSprites(run)
        -- end

        -- local markSpacing = 16
        -- local markX = valueX + 8
        -- local markY = y - 2
        -- if #run.marks <= 5 then markY = markY + 8 end


        -- for i, spr in ipairs(displayedMarks) do
        --     local yOffset = 0
        --     local xOffset = 0
        --     if i > 5 then yOffset = 16 xOffset = -80  end
        --     spr:Render(Vector(markX + xOffset, markY + yOffset))
        --     markX = markX + markSpacing
        -- end
        -- y = y + spacing

        -- if #run.marks > 5 then
        --     y = y + 5
        -- end
    end

    spriteFont:DrawString("Hits:", labelX, y, KColor(0.12,0.06,0.06,1))
    spriteFont:DrawString(run.hitCount or "-", smallValueX, y, KColor(0.12,0.06,0.06,1))
    y = y + spacing

    -- spriteFont:DrawString("Items:", labelX, y, KColor(0.12,0.06,0.06,1))
    -- spriteFont:DrawString(run.itemCount or "-", smallValueX, y, KColor(0.12,0.06,0.06,1))
    -- y = y + spacing

    -- spriteFont:DrawString("First Item:", labelX, y, KColor(0.12,0.06,0.06,1))
    -- spriteFont:DrawString(run.firstItem or "-", valueX, y, KColor(0.12,0.06,0.06,1))
    -- y = y + spacing

    -- spriteFont:DrawString("Fav:", labelX, y, KColor(0.12,0.06,0.06,1))
    -- spriteFont:DrawString(run.favoriteItem or "-", smallValueX, y, KColor(0.12,0.06,0.06,1))

    if recordsPageOpen and run.items and #run.items > 0 then
        RunLogger:DrawItemSprites(run.items, renderPos, run.favoriteItem)
    end
end

local itemSprite = Sprite()
itemSprite:Load("gfx/ui/death screen.anm2", true)
for _, layer in pairs(itemSprite:GetAllLayers()) do
    if layer:GetLayerID() ~= 6 then
        layer:SetVisible(false)
    end
end

function RunLogger:DrawItemSprites(items, renderPos, fav)

    local totalItems = #(items or {})
    local itemsPerPage = config.RightPage.MaxItemsPerPage
    local startIndex = (currentItemPage - 1) * itemsPerPage + 1
    local endIndex = math.min(startIndex + itemsPerPage - 1, totalItems)

    -- Grid config
    local cols = config.RightPage.ItemsPerRow
    local rows = 2
    local spacing = 16

    local baseX = renderPos.X + config.RightPage.ItemListStartPos.X
    local baseY = renderPos.Y + config.RightPage.ItemListStartPos.Y
    local itemTextPos = config.RightPage.ItemNamePos + renderPos


    local deathSprite = itemSprite
    local itemStringWidth = 0


    for i = startIndex, endIndex do
        local item = items[i]
        if item then

            local pageIndex = i - startIndex + 1

            -- Convert 1–12 into row/col
            local col = (pageIndex - 1) % cols
            local row = math.floor((pageIndex - 1) / cols)

            local posX = baseX + col * spacing
            local posY = baseY + row * spacing

            if fav and i == 1 then
                cursorSprite:SetFrame("fav", 0)
                cursorSprite:Render(Vector(baseX, baseY) + Vector(-84, 20))
            end

            ---------------------------------------------------------
            -- Draw Item Sprite
            ---------------------------------------------------------
            local id = Isaac.GetItemIdByName(item)
            if id and id < CollectibleType.NUM_COLLECTIBLES then
                -- Vanilla item
                deathSprite:SetFrame("Diary", (id or 1)-1)
                deathSprite:Render(Vector(posX, posY))
            else
                local modSprite = Sprite()
                if REPENTANCE_PLUS and id then
                    Isaac.RenderCollectionItem(id, Vector(posX, posY) + Vector(-84, 20))
                else
                    modSprite:Load("gfx/ui/mod_defaults.anm2", true)
                    modSprite:SetFrame(modSprite:GetDefaultAnimationName(), 0)
                    modSprite:Render(Vector(posX, posY) + Vector(-84, 20))
                end
            end


            if pageIndex == selectedItem then
                itemStringWidth = spriteFont:GetStringWidth(item)
                spriteFont:DrawString(item, itemTextPos.X - itemStringWidth/2, itemTextPos.Y, KColor(0.12,0.06,0.06,1), itemStringWidth, true)
                cursorSprite:SetFrame("cursor", 2)
                cursorSprite:Render(Vector(posX, posY) + config.RightPage.ItemCursorOffset)

                if EID and EID.Config["RGON_ShowOnCollectionPage"] then
                    --EID:HandleRenderingKeys()
                    if not EID.isHidden then
                        if id then
                            local demoDescObj = EID:getDescriptionObj(5, 100, id, nil, false)
                            EID:printDescription(demoDescObj, nil)
                        else
                            EID:printDescription({Icon = EID.InlineIcons["QuestionMark"], Description = description or "", Entity = entity}, nil)
                        end
                    end
                end
            end
        end
    end

    local leftButtonPos = itemTextPos + config.RightPage.LeftArrowOffset - Vector(math.max(itemStringWidth/2, 45), 0)
    local rightButtonPos = itemTextPos + config.RightPage.RightArrowOffset + Vector(math.max(itemStringWidth/2, 45), 0)

    if usingController then
        cursorSprite:SetFrame("buttons", 4)
        cursorSprite:Render(leftButtonPos)

        cursorSprite:SetFrame("buttons", 3)
        cursorSprite:Render(rightButtonPos)
    else
        cursorSprite:SetFrame("buttons", 1)
        cursorSprite:Render(leftButtonPos)
        cursorSprite:SetFrame("buttons", 0)
        cursorSprite:Render(rightButtonPos)
    end

    
    local totalItemPages = math.max(1, math.ceil(totalItems / itemsPerPage))

    local bulletSpacing = 10 -- distance between bullets

    -- Center of the item list horizontally
    local centerX = itemTextPos.X

    -- Position bullets slightly under the grid
    local bulletsY = baseY + 50

    -- Total width of all bullets
    local totalBulletsWidth = (totalItemPages - 1) * bulletSpacing

    -- Starting X so bullets are centered
    local startX = centerX - totalBulletsWidth / 2

    for page = 1, totalItemPages do
        local frame = 0 -- empty bullet
        if page == currentItemPage then
            frame = 1 -- filled bullet
        end

        cursorSprite:SetFrame("bullets", frame or 0)
        cursorSprite:Render(Vector(startX + (page - 1) * bulletSpacing, bulletsY))
    end


end


function RunLogger:CreateMarkSprites(run)
    local paperSprite = Sprite()
    paperSprite:Load("gfx/ui/completion_widget.anm2")

    local marksSprite = Sprite()
    marksSprite:Load("gfx/ui/completion_widget.anm2")


    if run.difficulty == 1 or run.difficulty == 3 then
        marksSprite:SetFrame("Idle", 2)
    else
        marksSprite:SetFrame("Idle", 1)
    end

    for _, layer in pairs(marksSprite:GetAllLayers()) do
        layer:SetVisible(false)
    end

    for _, layer in pairs(paperSprite:GetAllLayers()) do
        layer:SetVisible(false)
    end
    paperSprite:GetLayer(0):SetVisible(true)

    local beatDelirium = false
    for _, markName in ipairs(run.marks or {}) do
        local markLayer = COMPLETION_MARK_LAYERS[markName]
        if markLayer and marksSprite:GetLayer(markLayer) then
            marksSprite:GetLayer(markLayer):SetVisible(true)
        end
        if markName == CompletionType.DELIRIUM then
            beatDelirium = true
        end
    end

    if beatDelirium then
        if run.difficulty == 1 or run.difficulty == 3 then
            paperSprite:SetFrame("Idle", 2)
        else
            paperSprite:SetFrame("Idle", 1)
        end
    else
        paperSprite:SetFrame("Idle", 0)
    end

    return {paperSprite, marksSprite}
end


-- helper: wrap text by word to maxWidth, but only wrap once
function RunLogger:WrapTextByWidth(text, maxWidth)
    local words = {}
    for w in string.gmatch(text, "%S+") do
        table.insert(words, w)
    end

    local firstLine = ""
    local secondLine = ""
    local current = ""

    for i, w in ipairs(words) do
        if current == "" then
            current = w
        else
            local test = current .. " " .. w
            local width = spriteFont:GetStringWidth(test)
            if width <= maxWidth then
                current = test
            else
                firstLine = current
                -- everything remaining goes into second line
                secondLine = table.concat({w, table.unpack(words, i+1)}, " ")
                break
            end
        end
    end

    -- if no wrap was needed, put it all in firstLine
    if firstLine == "" then
        firstLine = current
        return {firstLine}
    end

    return {firstLine, secondLine}
end


local lastControllerIndex = 0

local watchedActions = {
    ButtonAction.ACTION_LEFT,
    ButtonAction.ACTION_RIGHT,
    ButtonAction.ACTION_UP,
    ButtonAction.ACTION_DOWN,
    ButtonAction.ACTION_SHOOTLEFT,
    ButtonAction.ACTION_SHOOTRIGHT,
    ButtonAction.ACTION_SHOOTUP,
    ButtonAction.ACTION_SHOOTDOWN,
    ButtonAction.ACTION_BOMB,
    ButtonAction.ACTION_DROP,
    ButtonAction.ACTION_PILLCARD,
    ButtonAction.ACTION_ITEM,
    ButtonAction.ACTION_MAP,
    ButtonAction.ACTION_PAUSE,
    ButtonAction.ACTION_MENUCONFIRM,
    ButtonAction.ACTION_MENUBACK
}

function RunLogger:ControllerTest()

    if lastControllerIndex > 0 then
        for _, action in ipairs(watchedActions) do
            if Input.IsActionTriggered(action, 0) then
                lastControllerIndex = 0
                usingController = false
                return
            end
        end
    else
        for i = 1, 3 do  -- controller slots
            for _, action in ipairs(watchedActions) do
                if Input.IsActionTriggered(action, i) then
                    lastControllerIndex = i
                    usingController = true
                    return
                end
            end
        end
    end
end

end
return RunLoggerEnabler