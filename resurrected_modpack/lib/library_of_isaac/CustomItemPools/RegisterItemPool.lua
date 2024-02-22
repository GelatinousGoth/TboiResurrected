

if not TSIL.__VERSION_PERSISTENT_DATA.CustomItemPools then
    TSIL.__VERSION_PERSISTENT_DATA.CustomItemPools = {}
end


local function OnTSILLoad()
    TSIL.SaveManager.AddPersistentVariable(
        TSIL.__MOD,
        "itemPools_CUSTOM_ITEM_POOLS",
        {},
        TSIL.Enums.VariablePersistenceMode.RESET_RUN
    )
end
TSIL.__AddInternalCallback(
    "CUSTOM_ITEM_POOLS_TSIL_LOAD",
    TSIL.Enums.CustomCallback.POST_TSIL_LOAD,
    OnTSILLoad
)


local function OnGameStart(_, isContinued)
    if isContinued then return end

    TSIL.SaveManager.SetPersistentVariable(
        TSIL.__MOD,
        "itemPools_CUSTOM_ITEM_POOLS",
        TSIL.Utils.Tables.Copy(TSIL.__VERSION_PERSISTENT_DATA.CustomItemPools)
    )
end
TSIL.__AddInternalCallback(
    "CUSTOM_ITEM_POOLS_GAME_START_REORDERED_LAST",
    TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED,
    OnGameStart,
    CallbackPriority.EARLY
)


function TSIL.CustomItemPools.RegisterCustomItemPool(collectibles)
    if collectibles == nil then
        collectibles = {}
    end

    local customItemPools = TSIL.__VERSION_PERSISTENT_DATA.CustomItemPools
    local newIndex = #customItemPools+1
    customItemPools[newIndex] = TSIL.Utils.Tables.Copy(collectibles)
    return newIndex
end