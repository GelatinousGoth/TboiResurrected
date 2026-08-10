-- Save Manager
local mod = ItemPedestalOverhaul
local json = require("json")

-- Save data to json
function ItemPedestalOverhaul:SaveConfig()
    self:SaveData(json.encode(self.Config))
end

-- Load data from save
function ItemPedestalOverhaul:LoadConfig()
    if self:HasData() then
        local data = json.decode(self:LoadData())
        if type(data) == "table" then
            for k, v in pairs(data) do
                self.Config[k] = v
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadConfig)