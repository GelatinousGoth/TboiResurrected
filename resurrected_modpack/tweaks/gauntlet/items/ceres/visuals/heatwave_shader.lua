local TR_Manager = require("resurrected_modpack.manager")

local summerFadeTimer = 0

local waveTimer = 0

---@param isContinued boolean
TheGauntlet:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function (_, isContinued)
    summerFadeTimer = 0
end)

function TheGauntlet:HeatWaveShader()
    if TheGauntlet.Items.Ceres.GetSeason() == TheGauntlet.Items.Ceres.Season.SUMMER then
        summerFadeTimer = summerFadeTimer + 0.02
        if summerFadeTimer > 1 then
            summerFadeTimer = 1
        end
    else
        summerFadeTimer = summerFadeTimer - 0.02
        if summerFadeTimer < 0 then
            summerFadeTimer = 0

            waveTimer = 0
        end
    end

    local waveAmplitude = TheGauntlet.Utility.Lerp(0, 0.001, summerFadeTimer)
    local waveFrequency = 64--TheGauntlet.Utility.Lerp(0, 32, summerFadeTimer) Frequency doesn't change to avoid weirdly fast transitions

    local waveSpeed = TheGauntlet.Utility.Lerp(0, 0.01, summerFadeTimer)
    waveTimer = waveTimer + waveSpeed



    return {
        Timer = waveTimer,
        Amplitude = waveAmplitude,
        Frequency = waveFrequency
    }
end
TR_Manager:RegisterShaderFunction(TheGauntlet, "TheGauntlet Heat Wave", TheGauntlet.HeatWaveShader)
