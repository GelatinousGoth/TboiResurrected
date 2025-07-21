local TR_Manager = require("resurrected_modpack.manager")

local DefaultHeatWaveParameters = {
    Time = 0,
    Intensity = 0,
    WaveSpeed = 0
}

local DefaultBlackHoleParameters = {
    Enabled = 0,
    BlackPosition = {0, 0, 0},
    Time = 0,
    WarpCheck = {0, 0}
}

local DefaultCriticalHealthParameters = {
    Amount = 0,
    RMod = 0,
    GMod = 0,
    BMod = 0,
    AMod = 0
}

local DefaultItemDungeonVignetteParams = {
    ModConfigStrength = 0,
    ScreenCenter = {0, 0},
    Time = 0,
    TrapdoorOpenAmount = 0,
    PlayerPosition = {0, 0},
}

local DefaultRotgutDungeonVignetteParams = {
    ModConfigStrength = 0,
    Time = 0,
    PlayerPosition = {0, 0}
}

TR_Manager:RegisterShader("Hot_HeatWave", DefaultHeatWaveParameters)
TR_Manager:RegisterShader("PauseScreenCompletionMarks", {})
TR_Manager:RegisterShader("Black_Hole", DefaultBlackHoleParameters)
TR_Manager:RegisterShader("EmptyShader", {})
TR_Manager:RegisterShader("Critical Health", DefaultCriticalHealthParameters)
TR_Manager:RegisterShader("itemDungeonVignette", DefaultItemDungeonVignetteParams)
TR_Manager:RegisterShader("rotgutDungeonVignette", DefaultRotgutDungeonVignetteParams)