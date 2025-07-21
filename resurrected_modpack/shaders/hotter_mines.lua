local TR_Manager = require("resurrected_modpack.manager")

local ModName = "Hotter Mines"
local mod = TR_Manager:RegisterMod(ModName, 1)
local json = require("json")

local roomIntensity = 0
local waveSpeed = 2
local intensityMultiplier = 2

local LERP_SPEED = 0.1

local MOD_PREFIX = "hotshader"

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- room:HasLava() is broken, so we have to use this instead
local function hasLava()
    return SFXManager():IsPlaying(SoundEffect.SOUND_LAVA_LOOP) and Game():GetRoom():HasLava()
end

local function split(str, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local function saveSettings()
    local data = {
        Intensity = intensityMultiplier,
        WaveSpeed = waveSpeed,
    }
    local encoded = json.encode(data)
    mod:SaveData(encoded)
end

local function loadSettings()
    if not mod:HasData() then
        return
    end

    local data = mod:LoadData()

    if data ~= "" then
        local decoded = json.decode(data)
        intensityMultiplier = decoded.Intensity or 2
        waveSpeed = decoded.WaveSpeed or 2
    else
        saveSettings()
    end
end

local function errorInCmd(correctUsage)
    Isaac.ConsoleOutput("Invalid command. Usage: " .. MOD_PREFIX .. " " .. correctUsage)
end

-- not sure if this shader crash fix by agentcucco is still necessary, but i'll put it in anyway
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end)

function mod:RenderUpdate()
    local room = Game():GetRoom()
    if hasLava() and not Game():IsPaused() then
        local lavaIntensity = room:GetLavaIntensity()
        local ratio = lavaIntensity / 1
        roomIntensity = lerp(roomIntensity, ratio * intensityMultiplier, LERP_SPEED)
    else
        roomIntensity = lerp(roomIntensity, 0, LERP_SPEED)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderUpdate)

function mod:ShaderUpdate(name)
    return {
        Time = Game():GetFrameCount(),
        Intensity = roomIntensity,
        WaveSpeed = waveSpeed,
    }
end

TR_Manager:RegisterShaderFunction(mod, "Hot_HeatWave", mod.ShaderUpdate)

mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, loadSettings)

function mod:UseConsole(cmd, argString)
    local args = split(argString, " ")
    if cmd:lower() == MOD_PREFIX then
        if args[1] == "intensity" then
            local num = tonumber(args[2])
            if num then
                intensityMultiplier = num
                saveSettings()
            elseif args[2]:lower() == "default" then
                intensityMultiplier = 2
                saveSettings()
            else
                errorInCmd("intensity <number>")
            end
        elseif args[1] == "wavespeed" then
            local num = tonumber(args[2])
            if num then
                waveSpeed = num
                saveSettings()
            elseif args[2]:lower() == "default" then
                waveSpeed = 2
                saveSettings()
            else
                errorInCmd("wavespeed <number>")
            end
        else
            errorInCmd("<intensity|wavespeed> <number>")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.UseConsole)