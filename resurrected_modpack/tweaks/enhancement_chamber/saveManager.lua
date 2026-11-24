--[[ Save Manager ]]--
local mod = EnhancementChamber
local json = require("json")

-- Shallow copy
---@param data table
---@return table
local function copy(data)
    local clone = {}

    for key, value in pairs(data) do
        clone[key] = value
    end

    return clone
end

-- Save configuration values
---@return table
local function getConfigValues()
    local config = {}

    for key, entry in pairs(mod.Config) do
        config[key] = entry.bool
    end

    return config
end

-- Load configuration values
---@param config table
local function setConfigValues(config)
    for key, value in pairs(config) do
        if mod.Config[key] then
            mod.Config[key].bool = value
        end
    end
end

-- Save data
function mod:saveAll()
    local blob = {
        data = self.Data,
        config = getConfigValues()
    }

    self:SaveData(json.encode(blob))
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveAll)

function mod:loadAll(isContinue)
    local decoded

    if self:HasData() then
        local getJson = json.decode(self:LoadData())

        if getJson then
            decoded = getJson
        end
    end

    -- Always initialize runtime defaults
    self.Data = copy(self.DefaultData)

    if not decoded then
        return
    end

    -- Runtime data only on continue
    if decoded.data and isContinue then
        self.Data = copy(decoded.data)
    end

    -- Configuration
    if decoded.config then
        setConfigValues(decoded.config)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadAll)