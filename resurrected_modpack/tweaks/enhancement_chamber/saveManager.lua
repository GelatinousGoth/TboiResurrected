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

-- Save data
function mod:saveAll()
    local blob = {
        data = self.Data,
        configS = self.ConfigSpecial,
        configM = self.ConfigMisc
    }

    mod:SaveData(json.encode(blob))
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.saveAll)

-- Load data
---@param isContinue boolean
function mod:loadAll(isContinue)

    -- initialize empty runtime tables
    local decoded = nil
    if self:HasData() then
        local getJson = json.decode(self:LoadData())
        if getJson then
            decoded = getJson
        end
    end

    -- Always initialize defaults first
    self.Data = copy(self.DefaultData)

    -- If save exists, overwrite what is present
    if decoded then

        -- Runtime data (only on continue)
        if decoded.data and isContinue then
            self.Data = copy(decoded.data)
        end

        -- Config Special
        if decoded.configS then
            for k, v in pairs(decoded.configS) do
                self.ConfigSpecial[k] = v
            end
        end

        -- Config Misc
        if decoded.configM then
            for k, v in pairs(decoded.configM) do
                self.ConfigMisc[k] = v
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.loadAll)