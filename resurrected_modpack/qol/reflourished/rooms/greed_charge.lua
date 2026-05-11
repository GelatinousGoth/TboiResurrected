local function GreedChargeFixEnabler()

local GreedCharge = {}
local mod = IsaacReflourished
--local BOSS_SPAWNED_THIS_RUN = Isaac.GetNullItemIdByName("RF Greed Boss Tracker")

---@param entity EntityNPC
function GreedCharge:ClearRoom(entity)
    local game = Game()
    local level = game:GetLevel()
    local room = game:GetRoom()
    --print(entity.SpawnerEntity)
    if not (entity and entity:IsBoss() and entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity.SpawnerEntity) then return end
    if room:GetFrameCount() < 1 or not room:IsClear() then return end
    if not game:IsGreedMode() then return end
    if level:GetStage() ~= LevelStage.STAGE7_GREED then return end
    if level:GetCurrentRoomDesc().ListIndex ~= 1 then return end
    -- for _, player in pairs(PlayerManager.GetPlayers()) do
    --     if player:GetEffects():HasNullEffect(BOSS_SPAWNED_THIS_RUN) then
    --         return
    --     end
    -- end
    -- Isaac.GetPlayer():GetEffects():AddNullEffect(BOSS_SPAWNED_THIS_RUN)

    room:SetClear(false)

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, GreedCharge.ClearRoom)

end
return GreedChargeFixEnabler