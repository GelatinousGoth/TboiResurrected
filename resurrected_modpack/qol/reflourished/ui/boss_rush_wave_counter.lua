local function BossRushWaveCounterEnabler()

local BossCounter = {}
local mod = IsaacReflourished
local utility = IsaacReflourished.Utility


local waveBar = Sprite()
waveBar:Load("gfx/ui/boss_rush_bar2.anm2", true)
waveBar:Play("Stage1")

local font = Font()
font:Load("font/terminus.fnt")

local inBossRush =  Game():GetRoom():GetType() == RoomType.ROOM_BOSSRUSH

function BossCounter:EnterBossRush()
    if Game():GetRoom():GetType() == RoomType.ROOM_BOSSRUSH and (inBossRush == false) then
        mod:AddCallback(ModCallbacks.MC_POST_RENDER, BossCounter.RenderBossBar)
        mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BossCounter.BossBarUpdate)
        inBossRush = true
    elseif Game():GetRoom():GetType() ~= RoomType.ROOM_BOSSRUSH and (inBossRush == true) then
        mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, BossCounter.RenderBossBar)
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, BossCounter.BossBarUpdate)
        inBossRush = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BossCounter.EnterBossRush)


function BossCounter:RenderBossBar()
    if Game():GetRoom():GetType() ~= RoomType.ROOM_BOSSRUSH then return end
    --if Game():GetRoom():IsAmbushDone() then return end
    local wave = Ambush.GetCurrentWave()
    if wave == 0 then return end
    local xPos = Isaac.GetScreenWidth() - 133


    local pos = Vector(utility:HUDOffset(xPos, 16, 'topright'))
    local textOffset = Vector(5, -6)
    local textPos = pos + textOffset

    local text = Ambush.GetCurrentWave() .. "/" .. Ambush.GetMaxBossrushWaves()

    local boxWidth = 7
    local center = true

    -- waveBar.Scale = Vector(variables.barScale / 100, variables.barScale / 100)
    waveBar:Render(pos, Vector(0, 0), Vector(0, 0))

    if not waveBar:WasEventTriggered("Stop Text") then
        font:DrawStringScaled(text, textPos.X, textPos.Y, 0.7, 0.7, KColor(1, 1, 1, 1), boxWidth, center)
    end

end

if inBossRush then mod:AddCallback(ModCallbacks.MC_POST_RENDER, BossCounter.RenderBossBar) end


local lastWave = 0
local ambushFinished = false
function BossCounter:BossBarUpdate()

    if Game():GetRoom():GetType() ~= RoomType.ROOM_BOSSRUSH then return end
    --if Game():GetRoom():IsAmbushDone() then return end
    local wave = Ambush.GetCurrentWave()
    local maxWaves = Ambush.GetMaxBossrushWaves()
    if wave == 0 then return end
    if wave < maxWaves then ambushFinished = false end

    waveBar:Update()

    if wave == lastWave and not Game():GetRoom():IsAmbushDone() and not ambushFinished then return end
    lastWave = wave

    if wave == 1 then
        waveBar:Play("Stage1")

    elseif wave % (maxWaves//5) == 0 and not Game():GetRoom():IsAmbushDone() then
        local stage = (wave//(maxWaves//5)) + 1
        waveBar:Play("Stage" .. stage, true)

    elseif wave == maxWaves and Game():GetRoom():IsAmbushDone() and not ambushFinished then
        waveBar:Play("Break", true)
        ambushFinished = true

    end
end

if inBossRush then mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BossCounter.BossBarUpdate) end

end
return BossRushWaveCounterEnabler