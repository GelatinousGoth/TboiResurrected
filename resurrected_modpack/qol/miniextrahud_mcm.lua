local registered = false

local strings = {
    en = {
        visuals = "Visuals",
        keybinds = "Keybinds",
        iconSize = "Icon Size",
        iconSizeInfo = "Item icon size",
        iconOpacity = "Item Icon Opacity",
        iconOpacityInfo = "Opacity of displayed item icons. 0 is fully transparent; 1 is fully opaque.",
        updateInterval = "Refresh Interval",
        updateIntervalInfo = "Item-list refresh interval in logic frames at 30 FPS. A value of 1 refreshes 30 times per second.",
        rightMargin = "Right Margin",
        rightMarginInfo = "Item list's distance from the right side of the window",
        topPosition = "Top Position",
        topPositionInfo = "The distance between the top of ExtraHud and the top of the screen. This value is overridden by minimap avoidance.",
        bottomPosition = "Bottom Position",
        bottomPositionInfo = "The distance between the bottom of ExtraHud and the vertical center of the screen.",
        itemListColumns = "Item List Columns",
        itemListColumnsInfo = "The number of columns used to display the item list.",
        jacobEsauItemListColumns = "Jacob & Esau Item List Columns",
        jacobEsauItemListColumnsInfo = "The number of columns used to display each of Jacob and Esau's item lists.",
        showLemegetonItems = "Show Lemegeton Items",
        showLemegetonItemsInfo = "When enabled, displays temporary items created by Lemegeton in the item list.",
        scrollDown = "Scroll Item List Down",
        scrollUp = "Scroll Item List Up",
        scrollTop = "Scroll Item List to Top",
        scrollBottom = "Scroll Item List to Bottom",
        configuration = "Configuration",
        combineTrinkets = "Combine Trinkets",
        combineTrinketsInfo = "When enabled, identical swallowed trinkets are combined in the item list and their total multiplier is shown as a number.",
        combineCollectibles = "Combine Collectibles",
        combineCollectiblesInfo = "When enabled, identical collectibles are combined in the item list and their total count is shown as a number.",
        loggingEnabled = "Enable Logging",
        loggingEnabledInfo = "When enabled, creates a log file in the game root directory.",
    },
    zh = {
        visuals = "视觉",
        keybinds = "键位",
        iconSize = "图标大小",
        iconSizeInfo = "物品图标大小",
        iconOpacity = "物品图标透明度",
        iconOpacityInfo = "显示物品图标的透明度，0为完全透明，1为完全不透明",
        updateInterval = "刷新间隔",
        updateIntervalInfo = "物理帧上的刷新间隔帧数，以30fps为基准，如设置为1即为1秒刷新30次",
        rightMargin = "与右侧间隔",
        rightMarginInfo = "物品栏与窗口右侧间隔",
        topPosition = "顶部位置",
        topPositionInfo = "ExtraHud顶部与画面顶部的间隔，该值会被小地图避让功能覆盖",
        bottomPosition = "底部位置",
        bottomPositionInfo = "ExtraHud底部与画面中央的间隔",
        itemListColumns = "道具表列数",
        itemListColumnsInfo = "道具表以多少列显示",
        jacobEsauItemListColumns = "雅各&以扫道具表列数",
        jacobEsauItemListColumnsInfo = "雅各&以扫的道具表分别以多少列显示",
        showLemegetonItems = "显示所罗门魔典道具",
        showLemegetonItemsInfo = "启用后，会在道具表内显示所罗门魔典生成的临时道具",
        scrollDown = "物品栏往下",
        scrollUp = "物品栏往上",
        scrollTop = "物品栏回顶",
        scrollBottom = "物品栏置底",
        configuration = "配置",
        combineTrinkets = "合并显示饰品",
        combineTrinketsInfo = "开启后，道具表中多个相同的饰品会合并显示，并以数字呈现倍率",
        combineCollectibles = "合并显示道具",
        combineCollectiblesInfo = "开启后，道具表中多个相同的道具会合并显示，并以数字呈现数量",
        loggingEnabled = "生成日志开关",
        loggingEnabledInfo = "开启后，会在游戏根目录生成日志文件",
    },
}

local chineseLanguageAliases = {
    zh = true,
    zh_hans = true,
    ["zh-hans"] = true,
    zh_cn = true,
    ["zh-cn"] = true,
    zh_chs = true,
    chinese_s = true,
    chi_s = true,
}

local function getStrings()
    local language = Options and Options.Language
    if type(language) == "string" and chineseLanguageAliases[string.lower(language)] then
        return strings.zh
    end

    return strings.en
end

return function(modName, config)
    if registered or type(ModConfigMenu) ~= "table"
        or type(ModConfigMenu.AddNumberSetting) ~= "function"
        or type(ModConfigMenu.AddBooleanSetting) ~= "function"
        or type(ModConfigMenu.AddKeyboardSetting) ~= "function" then
        return
    end

    registered = true
    local text = getStrings()
    ModConfigMenu.AddNumberSetting(modName, text.visuals, "IconScale", 0.5, 2.0, 0.1,
        config.IconScale, text.iconSize, text.iconSizeInfo)
    ModConfigMenu.AddNumberSetting(modName, text.visuals, "IconOpacity", 0.0, 1.0, 0.1,
        config.IconOpacity, text.iconOpacity, text.iconOpacityInfo)
    ModConfigMenu.AddNumberSetting(modName, text.visuals, "RightMargin", 0, 100, 1,
        config.RightMargin, text.rightMargin, text.rightMarginInfo)
    ModConfigMenu.AddNumberSetting(modName, text.visuals, "TopPosition", 0, 100, 1,
        config.TopPosition, text.topPosition, text.topPositionInfo)
    ModConfigMenu.AddNumberSetting(modName, text.visuals, "BottomPosition", 0, 100, 1,
        config.BottomPosition, text.bottomPosition, text.bottomPositionInfo)
    ModConfigMenu.AddNumberSetting(modName, text.configuration, "UpdateInterval", 1, 30, 1,
        config.UpdateInterval, text.updateInterval, text.updateIntervalInfo)
    ModConfigMenu.AddNumberSetting(modName, text.configuration, "ItemListColumns", 1, 10, 1,
        config.ItemListColumns, text.itemListColumns, text.itemListColumnsInfo)
    ModConfigMenu.AddNumberSetting(modName, text.configuration, "JacobEsauItemListColumns", 1, 5, 1,
        config.JacobEsauItemListColumns, text.jacobEsauItemListColumns, text.jacobEsauItemListColumnsInfo)
    ModConfigMenu.AddBooleanSetting(modName, text.configuration, "CombineTrinkets", config.CombineTrinkets,
        text.combineTrinkets, text.combineTrinketsInfo)
    ModConfigMenu.AddBooleanSetting(modName, text.configuration, "CombineCollectibles", config.CombineCollectibles,
        text.combineCollectibles, text.combineCollectiblesInfo)
    ModConfigMenu.AddBooleanSetting(modName, text.configuration, "ShowLemegetonItems", config.ShowLemegetonItems,
        text.showLemegetonItems, text.showLemegetonItemsInfo)
    ModConfigMenu.AddBooleanSetting(modName, text.configuration, "LoggingEnabled", config.LoggingEnabled,
        text.loggingEnabled, text.loggingEnabledInfo)
    ModConfigMenu.AddKeyboardSetting(modName, text.keybinds, "ScrollDownKey", config.ScrollDownKey,
        text.scrollDown, false, "")
    ModConfigMenu.AddKeyboardSetting(modName, text.keybinds, "ScrollUpKey", config.ScrollUpKey,
        text.scrollUp, false, "")
    ModConfigMenu.AddKeyboardSetting(modName, text.keybinds, "ScrollHomeKey", config.ScrollHomeKey,
        text.scrollTop, false, "")
    ModConfigMenu.AddKeyboardSetting(modName, text.keybinds, "ScrollEndKey", config.ScrollEndKey,
        text.scrollBottom, false, "")
end
