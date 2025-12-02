local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Animated Pickup Counter", 1)
ClockPickupCounter = mod

local game = Game()
local Vector, math, PlayerManager = Vector, math, PlayerManager
local AnyPlayer, IsHasBirthright = PlayerManager.AnyoneIsPlayerType, PlayerManager.AnyPlayerTypeHasBirthright
local z = Vector(0,0)

local SPRtoRemove = {}
local function GenSprite(gfx, anim, frame)
    if gfx then
        local spr
        spr = Sprite()
        spr:Load(gfx, true)
        if anim then
            spr:Play(anim)
        end
        if frame then
            spr:SetFrame(frame)
        end
        return spr
    end
end

mod.PickupHUDFileReplace = "gfx/ui/hudpickups_clockreplace.anm2"
mod.PickupHUDFileReplaceGfx = "gfx/ui/hudpickups_clockreplace.png"
mod.GoldenBombPickupAnim = "goldbomb_сменачётототамхзкакназвать"
mod.GoldenKeyPickupAnim = "goldkey_сменачётототамхзкакназвать"
mod.sprs = {
    Coin = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "coin_idle"),
    Bomb = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "bomb_idle"),
    Key = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "key_idle"),
    Poop = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "poop_idle"),
    RedHeart = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "redheart_idle"),
    BlueHeart = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "blueheart_idle"),
    BlackHeart = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "blackheart_idle"),

    Pixel = GenSprite("clockPickup_shaders/bluepixel.anm2", "pixel"),
    Pixel4 = GenSprite("clockPickup_shaders/bluepixel.anm2", "pixel"),
    Pixel3 = GenSprite("clockPickup_shaders/bluepixel.anm2", "pixel"),
    Pixel2 = GenSprite("clockPickup_shaders/bluepixel.anm2", "pixel"),
    Pixel1 = GenSprite("clockPickup_shaders/bluepixel.anm2", "pixel"),
    FakeFont = GenSprite("clockPickup_shaders/fakefont.anm2", "0"),
}
local sprs = mod.sprs

mod.sprs.Pixel:SetCustomShader("clockPickup_shaders/PhysHairCuttingShadder")
mod.sprs.Pixel4:SetCustomShader("clockPickup_shaders/PhysHairCuttingShadder")
mod.sprs.Pixel3:SetCustomShader("clockPickup_shaders/PhysHairCuttingShadder")
mod.sprs.Pixel2:SetCustomShader("clockPickup_shaders/PhysHairCuttingShadder")
mod.sprs.Pixel1:SetCustomShader("clockPickup_shaders/PhysHairCuttingShadder")
sprs.Pixel4.Color = Color(1,1,1,1,0,0,0,4)
sprs.Pixel3.Color = Color(1,1,1,1,0,0,0,3)
sprs.Pixel2.Color = Color(1,1,1,1,0,0,0,2)
sprs.Pixel1.Color = Color(1,1,1,1,0,0,0,1)
sprs.Coin.PlaybackSpeed = 0.5
sprs.Bomb.PlaybackSpeed = 0.5
sprs.Key.PlaybackSpeed = 0.5
sprs.Poop.PlaybackSpeed = 0.5
local fakefont = sprs.FakeFont

ClockPickupCounter.cleanspr = function() 
    for i,k in pairs(sprs) do
        sprs[i] = nil
    end
end


mod.CounterFont = Font()
mod.CounterFont:Load("font/pftempestasevencondensed.fnt")
local getwight = mod.CounterFont.GetStringWidth

mod.MainPickupsPos = Vector(0,36)


mod.HudOffsets = {
    DEFAULT = 0,
}
local HudOffsets = mod.HudOffsets



mod.PoryadokPokaza = {
    SamPoryadok = {},
    ChtoVPoryadke = {},
}
local PoryadokPokaza = mod.PoryadokPokaza

mod.CounterSklad = {}
---@type CounterData[]
local CounterSklad = mod.CounterSklad

---@class CounterData
---@field name string
---@field pos Vector
---@field sprpos Vector
---@field spr Sprite
---@field spr_idleAnim string
---@field spr_startAnim string?
---@field spr_animAnim string?
---@field spr_stopAnim string?
---@field overadeAnim boolean?
---@field gethudoffset number|fun(firstplayer:EntityPlayer):Vector
---@field getmaxvalue fun(firstplayer:EntityPlayer):number
---@field getvalue fun(firstplayer:EntityPlayer):number
---@field premaxvalue number
---@field digits digitsData[]
---@field update fun(player:EntityPlayer, sklad:CounterData)

---@class digitsData
---@field value number
---@field prevalue number
---@field pos Vector


---@class CounterInData
---@field name string
---@field pos Vector
---@field sprpos Vector
---@field spr Sprite
---@field spr_idleAnim string
---@field spr_animAnim string?
---@field spr_stopAnim string?
---@field gethudoffset number|fun(firstplayer:EntityPlayer):Vector
---@field getmaxvalue fun(firstplayer:EntityPlayer):number
---@field getvalue fun(firstplayer:EntityPlayer):number
---@field update? fun(player:EntityPlayer, sklad:CounterData)

---@param tab CounterInData
mod.AddCounterClock = function(tab)
    if tab then
        local name = tab.name
        
        local thisfuckingtable = {}
        thisfuckingtable.name = name
        --[[thisfuckingtable.pos = tab.pos
        thisfuckingtable.sprpos = tab.sprpos
        thisfuckingtable.spr = tab.spr
        thisfuckingtable.spr_idleAnim = tab.spr_idleAnim
        thisfuckingtable.spr_animAnim = tab.spr_animAnim
        thisfuckingtable.spr_stopAnim = tab.spr_stopAnim
        thisfuckingtable.gethudoffset = tab.gethudoffset
        thisfuckingtable.getmaxvalue = tab.getmaxvalue
        thisfuckingtable.getvalue = tab.getvalue
        thisfuckingtable.update = tab.update]]
        for i , k in pairs(tab) do
            thisfuckingtable[i] = k
        end

        thisfuckingtable.premaxvalue = 0
        thisfuckingtable.digits = {}

        mod.CounterSklad[name] = thisfuckingtable
    end
end


mod.SetPoraydokPokaza = function(tab)
    local newporyadok = {}
    for i=1, #tab do
        ---@type CounterData
        local AlreadySklad = PoryadokPokaza.ChtoVPoryadke[ tab[i] ]
        if AlreadySklad then
            newporyadok[i] = AlreadySklad
        else
            local sklad = CounterSklad[ tab[i] ]
            for j=1, #sklad.digits do
                local digit = sklad.digits[j]
                digit.prevalue = digit.value
            end
            newporyadok[i] = sklad
        end
    end
    PoryadokPokaza.SamPoryadok = newporyadok
    for i=1, #newporyadok do
        PoryadokPokaza.ChtoVPoryadke[ newporyadok[i].name ] = newporyadok[i]
    end
end


---@param anmA Sprite
---@param anmB Sprite
local function compareTex(anmA, anmB)
    local offsetZ = Vector(8,8)
    for x = 0, 8 do
        for y = 0, 8 do
            local sp = Vector(x*2,y*2)
            local a = anmA:GetTexel(sp, z, 0.5, 0)
            local b = anmB:GetTexel(sp, offsetZ, 0.5, 0)
            local same = a.Red == b.Red and a.Green == b.Green and a.Blue == b.Blue and a.Alpha == b.Alpha
            if not same then
                return true
            end
        end
    end
    return false
end

--[[
local ssss = GenSprite("gfx/ui/hudpickups.anm2", "Idle")
ssss.Scale = Vector(20,20)
ssss.Color = Color(0,0,0,1,0,1)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function() 
    ssss:Render(Vector(-120,-70))
end)
]]

local defaultPath = "/resources/gfx/ui/hudpickups.png"
local defaultPathAnm2 = "/resources/gfx/ui/hudpickups.anm2"
for i = 0, XMLData.GetNumEntries(XMLNode.MOD) do
    local modnode = XMLData.GetEntryById(XMLNode.MOD, i)
    if modnode then
        if modnode.enabled == "true" then
            local directory = modnode.fulldirectory --or modnode.realdirectory or modnode.directory
            directory = directory:gsub("\\Repentogon", "")
            local pathToPickupGfx = directory .. defaultPath
            local result,msg = pcall(Renderer.LoadImage, pathToPickupGfx)

            if result then
                local cspr = GenSprite("clockPickup_shaders/hudpickups_anim.anm2", "goldkey_idle")
                local spr = GenSprite("gfx/ui/hudpickups.anm2", "Idle")

                spr:SetFrame(0)
                local IsCoin = compareTex(spr, sprs.Coin)

                spr:SetFrame(1)
                local isKey = compareTex(spr, sprs.Key)

                spr:SetFrame(2)
                local isBomb = compareTex(spr, sprs.Bomb)

                spr:SetFrame(3)
                cspr:Play("goldkey_idle",true)
                local isGoldenKey = compareTex(spr, cspr)

                spr:SetFrame(6)
                cspr:Play("goldbomb_idle",true)
                local isGoldenBomb = compareTex(spr, cspr)

                spr:SetFrame(12)
                local isBlueHeart = compareTex(spr, sprs.BlueHeart)

                spr:SetFrame(13)
                local isBlackHeart = compareTex(spr, sprs.BlackHeart)

                spr:SetFrame(14)
                cspr:Play("gigabomb_idle",true)
                local isGigaBomb = compareTex(spr, cspr)

                spr:SetFrame(15)
                local isRedHeart = compareTex(spr, sprs.RedHeart)

                spr:SetFrame(16)
                local isPoop = compareTex(spr, sprs.Poop)

                mod.HasRepritedUi = {
                    isCoin = IsCoin,
                    isKey = isKey,
                    isBomb = isBomb,
                    isGoldenKey = isGoldenKey,
                    isGoldenBomb = isGoldenBomb,
                    isBlueHeart = isBlueHeart,
                    isBlackHeart = isBlackHeart,
                    isGigaBomb = isGigaBomb,
                    isRedHeart = isRedHeart,
                    isPoop = isPoop,
                    directory = "gfx/ui/hudpickups.anm2"
                }
                break
            end
        end
    end
end



mod.TriedPlaceBomb = false
mod.MaxSoulCharge = 99

    
if mod.HasRepritedUi and mod.HasRepritedUi.isCoin then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 0)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "Coin",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1),
        spr = spr,
        sprpos = Vector(0, -2),
        --sprpos = mod.MainPickupsPos + Vector(8, 6),
        spr_idleAnim = "coin_idle",
        overadeAnim = true,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxCoins() end,
        getvalue = function(player) return player:GetNumCoins() end,
    }
else
    mod.AddCounterClock{
        name = "Coin",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1),
        spr = sprs.Coin,
        sprpos = Vector(8, 6),
        --sprpos = mod.MainPickupsPos + Vector(8, 6),
        spr_idleAnim = "coin_idle",
        spr_animAnim = "coin_flip",
        spr_stopAnim = "coin_stop",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxCoins() end,
        getvalue = function(player) return player:GetNumCoins() end
    }
end

if mod.HasRepritedUi and mod.HasRepritedUi.isBomb then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 2)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "Bomb",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1 + 11),
        spr = spr,
        sprpos = Vector(0, -2),
        --sprpos = mod.MainPickupsPos + Vector(8, 6 + 11),
        spr_idleAnim = "bomb_idle",
        overadeAnim = true,
        defframe = 2,
        goldframe = 6,
        gigaframe = 14,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxBombs() end,
        getvalue = function(player) return player:GetNumBombs() end,
        update = function(player, sklad)
            if not sklad.HasGigaBomb then

                if player:HasGoldenBomb() then
                    sklad.spr:SetFrame(sklad.goldframe)

                    if mod.TriedPlaceBomb then
                        mod.TriedPlaceBomb = false
                        sklad.ImmitateCounterDrop = 0
                        sklad.digits[1].value = sklad.digits[1].value - 0.5
                    end
                    if sklad.ImmitateCounterDrop then
                        sklad.ImmitateCounterDrop = sklad.ImmitateCounterDrop + 1
                        local cd = sklad.ImmitateCounterDrop
                        local firstdig = sklad.digits[1]

                        if cd <= 12 then
                            if firstdig.value > 0 then
                                firstdig.value = sklad.getvalue(player) - (cd / 16)
                            end
                        elseif cd <= 17 then
                            if firstdig.value > 0 then
                                firstdig.value = sklad.getvalue(player) - ( ((cd % 3 - 1)/3 * 0.2 ) +  0.75 )
                            end
                        else
                            sklad.ImmitateCounterDrop = nil
                        end
                    end
                else
                    sklad.spr:SetFrame(sklad.defframe)
                end

                if player:GetNumGigaBombs() > 0 then
                    sklad.HasGigaBomb = true
                    sklad.spr:SetFrame(sklad.gigaframe)
                end
            elseif sklad.HasGigaBomb then
                if player:GetNumGigaBombs() <= 0 then
                    sklad.HasGigaBomb = false
                end
            end
        end,
    }
else
    mod.AddCounterClock{
        name = "Bomb",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1 + 11),
        spr = sprs.Bomb,
        sprpos = Vector(8, 6),
        --sprpos = mod.MainPickupsPos + Vector(8, 6 + 11),
        spr_idleAnim = "bomb_idle",
        spr_animAnim = "bomb_flip",
        altspr_idleAnim = "goldbomb_idle",
        altspr_animAnim = "goldbomb_flip",

        gigaspr_idleAnim = "gigabomb_idle",
        gigaspr_animAnim = "gigabomb_flip",
        gigaspr_stopAnim = "gigabomb_end",
        --spr_stopAnim = "bomb_end",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxBombs() end,
        getvalue = function(player) return player:GetNumBombs() end,
        update = function(player, sklad)
            if not sklad.HasGigaBomb then

                if not sklad.HasGoldenBomb then
                    if player:HasGoldenBomb() then
                        sklad.HasGoldenBomb = true

                        sklad.overadeAnim = true
                        sklad.delaysprrender = true
                        sklad.spr:Play(mod.GoldenBombPickupAnim)
                        sklad.spr.PlaybackSpeed = 0.6


                        local idle, flip = sklad.spr_idleAnim, sklad.spr_animAnim
                        sklad.spr_idleAnim, sklad.spr_animAnim = sklad.altspr_idleAnim, sklad.altspr_animAnim
                        sklad.altspr_idleAnim, sklad.altspr_animAnim = idle, flip
                    end
                elseif sklad.HasGoldenBomb then
                    if not player:HasGoldenBomb() then
                        sklad.HasGoldenBomb = false
                        sklad.overadeAnim = nil
                        sklad.delaysprrender = nil
                        sklad.spr.PlaybackSpeed = 0.5

                        local idle, flip = sklad.spr_idleAnim, sklad.spr_animAnim
                        sklad.spr_idleAnim, sklad.spr_animAnim = sklad.altspr_idleAnim, sklad.altspr_animAnim
                        sklad.altspr_idleAnim, sklad.altspr_animAnim = idle, flip
                    else
                        if sklad.spr:IsFinished() then
                            sklad.delaysprrender = nil
                            sklad.overadeAnim = nil
                            sklad.spr.PlaybackSpeed = 0.5
                            sklad.spr:Play(sklad.spr_idleAnim)
                        end

                        if mod.TriedPlaceBomb then
                            mod.TriedPlaceBomb = false
                            sklad.ImmitateCounterDrop = 0
                            sklad.digits[1].value = sklad.digits[1].value - 0.5
                        end
                        if sklad.ImmitateCounterDrop then
                            sklad.ImmitateCounterDrop = sklad.ImmitateCounterDrop + 1
                            local cd = sklad.ImmitateCounterDrop
                            local firstdig = sklad.digits[1]

                            if cd <= 12 then
                                if firstdig.value > 0 then
                                    firstdig.value = sklad.getvalue(player) - (cd / 16)
                                end
                            elseif cd <= 17 then
                                if firstdig.value > 0 then
                                    firstdig.value = sklad.getvalue(player) - ( ((cd % 3 - 1)/3 * 0.2 ) +  0.75 )
                                end
                            else
                                sklad.ImmitateCounterDrop = nil
                            end
                        end
                    end
                end

                if player:GetNumGigaBombs() > 0 then
                    sklad.HasGigaBomb = true
                    sklad.spr.PlaybackSpeed = 0.5

                    local idle, flip = sklad.spr_idleAnim, sklad.spr_animAnim
                    sklad.spr_idleAnim, sklad.spr_animAnim, sklad.spr_stopAnim = sklad.gigaspr_idleAnim, sklad.gigaspr_animAnim, sklad.gigaspr_stopAnim
                    sklad.gigaspr_idleAnim, sklad.gigaspr_animAnim = idle, flip
                end
            elseif sklad.HasGigaBomb then
                if player:GetNumGigaBombs() <= 0 then
                    sklad.HasGigaBomb = false
                    sklad.spr.PlaybackSpeed = 0.5

                    local idle, flip = sklad.spr_idleAnim, sklad.spr_animAnim
                    sklad.spr_idleAnim, sklad.spr_animAnim = sklad.gigaspr_idleAnim, sklad.gigaspr_animAnim
                    sklad.spr_stopAnim = nil
                    sklad.gigaspr_idleAnim, sklad.gigaspr_animAnim = idle, flip
                end
            end
        end,
    }
end

if mod.HasRepritedUi and mod.HasRepritedUi.isKey then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 1)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "Key",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1 + 22),
        spr = spr,
        sprpos = Vector(0, -2),
        --sprpos = mod.MainPickupsPos + Vector(8, 6 + 22),
        spr_idleAnim = "key_idle",
        overadeAnim = true,
        defframe = 1,
        goldframe = 3,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxKeys() end,
        getvalue = function(player) return player:GetNumKeys() end,
        update = function(player, sklad)
            if player:HasGoldenKey() then
                sklad.spr:SetFrame(sklad.goldframe)
            else
                sklad.spr:SetFrame(sklad.defframe)
            end
        end, 
    }
else
    mod.AddCounterClock{
        name = "Key",
        pos = Vector(16, -1),
        --pos = mod.MainPickupsPos + Vector(16, -1 + 22),
        spr = sprs.Key,
        sprpos = Vector(8, 6),
        --sprpos = mod.MainPickupsPos + Vector(8, 6 + 22),
        spr_idleAnim = "key_idle",
        spr_animAnim = "key_flip",
        spr_stopAnim = "key_end",
        altspr_idleAnim = "goldkey_idle",
        altspr_animAnim = "goldkey_flip",
        altspr_stopAnim = "goldkey_end",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return player:GetMaxKeys() end,
        getvalue = function(player) return player:GetNumKeys() end,
        update = function(player, sklad)
            if not sklad.HasGoldenKey then
                if player:HasGoldenKey() then
                    sklad.HasGoldenKey = true

                    sklad.overadeAnim = true
                    sklad.delaysprrender = true
                    sklad.spr:Play(mod.GoldenKeyPickupAnim)
                    sklad.spr.PlaybackSpeed = 0.6


                    local idle, flip, stop = sklad.spr_idleAnim, sklad.spr_animAnim, sklad.spr_stopAnim
                    sklad.spr_idleAnim, sklad.spr_animAnim, sklad.spr_stopAnim = sklad.altspr_idleAnim, sklad.altspr_animAnim, sklad.altspr_stopAnim
                    sklad.altspr_idleAnim, sklad.altspr_animAnim, sklad.altspr_stopAnim = idle, flip, stop
                end
            elseif sklad.HasGoldenKey then
                if not player:HasGoldenKey() then
                    sklad.HasGoldenKey = false
                    sklad.overadeAnim = nil
                    sklad.delaysprrender = nil
                    sklad.spr.PlaybackSpeed = 0.5

                    local idle, flip, stop = sklad.spr_idleAnim, sklad.spr_animAnim, sklad.spr_stopAnim
                    sklad.spr_idleAnim, sklad.spr_animAnim, sklad.spr_stopAnim = sklad.altspr_idleAnim, sklad.altspr_animAnim, sklad.altspr_stopAnim
                    sklad.altspr_idleAnim, sklad.altspr_animAnim, sklad.altspr_stopAnim = idle, flip, stop
                else
                    if sklad.spr:IsFinished() then
                        sklad.delaysprrender = nil
                        sklad.overadeAnim = nil
                        sklad.spr.PlaybackSpeed = 0.5
                        sklad.spr:Play(sklad.spr_idleAnim)
                    end
                end
            end
        end, 
    }
end

if mod.HasRepritedUi and mod.HasRepritedUi.isPoop then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 16)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "Poop",
        pos = Vector(16, -1),
        spr = spr,
        sprpos = Vector(0, -2),
        spr_idleAnim = "poop_idle",
        overadeAnim = true,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) 
            return player:GetMaxPoopMana()    --PlayerManager.AnyPlayerTypeHasBirthright(PlayerType.PLAYER_BLUEBABY_B) and 29 or 9
        end,
        getvalue = function(player) return player:GetPoopMana() end
    }
else
    mod.AddCounterClock{
        name = "Poop",
        pos = Vector(16, -1),
        spr = sprs.Poop,
        sprpos = Vector(8, 6),
        spr_idleAnim = "poop_idle",
        spr_animAnim = "poop_flip",
        spr_stopAnim = "poop_end",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) 
            return player:GetMaxPoopMana()    --PlayerManager.AnyPlayerTypeHasBirthright(PlayerType.PLAYER_BLUEBABY_B) and 29 or 9
        end,
        getvalue = function(player) return player:GetPoopMana() end
    }
end

if mod.HasRepritedUi and mod.HasRepritedUi.isBlueHeart then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 12)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "BlueHeart",
        pos = Vector(16, -1),
        spr = spr,
        sprpos = Vector(0, -2),
        spr_idleAnim = "blueheart_idle",
        overadeAnim = true,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return mod.MaxSoulCharge end,
        getvalue = function(player) return player:GetSoulCharge() end
    }
else
    mod.AddCounterClock{
        name = "BlueHeart",
        pos = Vector(16, -1),
        spr = sprs.BlueHeart,
        sprpos = Vector(8, 6),
        spr_idleAnim = "blueheart_idle",
        spr_startAnim = "blueheart_flip_start",
        spr_animAnim = "blueheart_flip",
        spr_stopAnim = "blueheart_end",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return mod.MaxSoulCharge end,
        getvalue = function(player) return player:GetSoulCharge() end
    }
end

if mod.HasRepritedUi and mod.HasRepritedUi.isRedHeart then
    local spr = GenSprite(mod.HasRepritedUi.directory, "Idle", 15)
    spr.PlaybackSpeed = 0
    mod.AddCounterClock{
        name = "RedHeart",
        pos = Vector(16, -1),
        spr = spr,
        sprpos = Vector(0, -2),
        spr_idleAnim = "redheart_idle",
        overadeAnim = true,
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return mod.MaxSoulCharge end,
        getvalue = function(player) return player:GetBloodCharge() end
    }
else
    mod.AddCounterClock{
        name = "RedHeart",
        pos = Vector(16, -1),
        spr = sprs.RedHeart,
        sprpos = Vector(8, 6),
        spr_idleAnim = "redheart_idle",
        spr_startAnim = "redheart_flip_start",
        spr_animAnim = "redheart_flip",
        spr_stopAnim = "redheart_end",
        gethudoffset = mod.HudOffsets.DEFAULT,
        getmaxvalue = function(player) return mod.MaxSoulCharge end,
        getvalue = function(player) return player:GetBloodCharge() end
    }
end





--[[
mod.Coin = {
    pos = Vector(8, 6),
    countpos = Vector(10+6, -1),
    preCoinCount = 0,
    currentValue = 0,
    Proc = 0,
    digits = {
        [1] = {
            pos = Vector(0,0),
            prevalue = 0,
            value = 0,
        },
        [2] = {
            pos = Vector(0,0),
            prevalue = 0,
            value = 0
        },
        [3] = {
            pos = Vector(0,0),
            prevalue = 0,
            value = 0
        },

    },
}
local CoinData = mod.Coin
]]



mod.DefauldPoryadok = {
    "Coin", "Key"
}



mod.playerInit = function(player)
    local newporyadok = {}
    for i=1, #mod.DefauldPoryadok do
        newporyadok[i] = mod.DefauldPoryadok[i]
    end

    local bomb, poop = false, false
    for i = 0, game:GetNumPlayers() - 1 do
        local ptype = Isaac.GetPlayer(i):GetPlayerType()
        if ptype == PlayerType.PLAYER_BLUEBABY_B then
            poop = true
        else
            bomb = true
        end
    end

    if poop then
        table.insert(newporyadok, 2, "Poop")
    end
    if bomb then
        table.insert(newporyadok, 2, "Bomb")
    end
    if AnyPlayer(PlayerType.PLAYER_BETHANY) then
        newporyadok[#newporyadok+1] = "BlueHeart"
    end
    if AnyPlayer(PlayerType.PLAYER_BETHANY_B) then
        newporyadok[#newporyadok+1] = "RedHeart"
    end
    
    mod.SetPoraydokPokaza(newporyadok)

    --local mainPos = mod.MainPickupsPos + Vector(16, -1)

    --for i=1, #newporyadok do
        --local sklad = mod.CounterSklad[newporyadok[i] ]
        --sklad.pos = mainPos + Vector(0, (i-1) * 11)
        --print(i, newporyadok[i])
    --end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.playerInit)
if Isaac.GetPlayer() then
    mod.playerInit(Isaac.GetPlayer())
end



local function crop999(num, max) return math.min(max, math.max(0, num)) end

local CurrentRenderFrame = 0
local IsShaderRenderState = false

mod:AddPriorityCallback(ModCallbacks.MC_HUD_RENDER, CallbackPriority.LATE, function(_, hud, offset)
    local gameHUD = game:GetHUD()
    local isRerender = false
    local CurFrame = Isaac.GetFrameCount()
    if CurFrame == CurrentRenderFrame then
        isRerender = true
    else
        IsShaderRenderState = false
    end
    CurrentRenderFrame = CurFrame

    if not gameHUD:IsVisible() then return end

    local player = Isaac.GetPlayer(0)

    local pixel = sprs.Pixel
    local pixel4, pixel3, pixel2, pixel1 = sprs.Pixel4, sprs.Pixel3, sprs.Pixel2, sprs.Pixel1
    --pixel.Color = Color(1,1,1,1,0,0,0,11)
    local font = mod.CounterFont
    local fontHeight = font:GetLineHeight()

    local hudOffsetOption = Options.HUDOffset
    local ysize = #PoryadokPokaza.SamPoryadok >= 4 and 11 or 12
    local hudOffsetV = Vector((hudOffsetOption * 20), (hudOffsetOption * ysize))

    local VanillaPickupSpr = gameHUD:GetPickupsHUDSprite()
    
    if VanillaPickupSpr:GetFilename() ~= mod.PickupHUDFileReplace then
        VanillaPickupSpr:Load(mod.PickupHUDFileReplace, true)
        local layer = VanillaPickupSpr:GetLayer(1)
        layer:SetCustomShader"clockPickup_shaders/PhysHairCuttingShadder"
    end

    local isPaused = game:IsPaused()
    --VanillaPickupSpr:ReplaceSpritesheet(0, mod.PickupHUDFileReplaceGfx, true)
    
    --pixel.Color = Color(1,1,1,1,0,0,0,3)

    local delayrender = {}

    local mainPickupPos = mod.MainPickupsPos
    if #PoryadokPokaza.SamPoryadok >= 4 then
        mainPickupPos = mainPickupPos + Vector(0, 1)
    end

    pixel.Scale = Vector(20,7)
    pixel4.Scale = Vector(20,7)
    pixel3.Scale = Vector(20,7)
    pixel2.Scale = Vector(20,7)
    pixel1.Scale = Vector(20,7)

    for i=1, #PoryadokPokaza.SamPoryadok do
        ---@type CounterData
        local sklad = PoryadokPokaza.SamPoryadok[i] 
    --for name, sklad in pairs(CounterSklad) do

        if sklad.update then
            sklad.update(player, sklad)
        end

        local maxvalue = sklad.getmaxvalue(player)
        local currentvalue = sklad.getvalue(player)

        if sklad.premaxvalue ~= maxvalue then
            local digitsNum = maxvalue == 0 and 1 or math.floor(math.log(maxvalue, 10)) + 1
            for i2 = 1, digitsNum do
                local powten = i2==1 and 1 or 10

                sklad.digits[i2] = sklad.digits[i2] or {}
                local dig = sklad.digits[i2]
                dig.pos = dig.pos or Vector(getwight(font, "0"), 0)
                dig.prevalue = dig.prevalue or 0
                dig.value = sklad.getvalue(player) // powten
                dig.wight = getwight(font, tostring(math.floor(dig.value % 10)))
            end
            for i2 = digitsNum+1, #sklad.digits do
                sklad.digits[i2] = nil
            end

            sklad.premaxvalue = maxvalue
        end

        --pixel.Color = Color(1,1,1,1,0,0,0, #sklad.digits)
        --pixel.Color:SetColorize(#sklad.digits, 0, 0, 0)

        local mainPos = mainPickupPos + Vector(0, (i-1) * ysize)
        local CounterPos = sklad.pos + mainPos
        local hudOffset
        if sklad.gethudoffset == HudOffsets.DEFAULT then
            hudOffset = hudOffsetV
        elseif type(sklad.gethudoffset) == "function" then
            hudOffset = sklad.gethudoffset(player)
        end
        if hudOffset then
            CounterPos = CounterPos + hudOffset
        end

        local pickupSpr = sklad.spr
        if pickupSpr and sklad.sprpos then
            if sklad.delaysprrender then
                delayrender[#delayrender+1] = {pickupSpr, sklad.sprpos + hudOffset + mainPos}
            else
                pickupSpr:Render(sklad.sprpos + hudOffset + mainPos)
            end

            if not isPaused then
                pickupSpr:Update()

                if not sklad.overadeAnim 
                and sklad.spr_idleAnim and sklad.spr_animAnim then
                    local canplaystop = false
                    local canplayanim = false
                    if pickupSpr:IsFinished() then
                        local curanim = pickupSpr:GetAnimation()
                        if curanim == sklad.spr_animAnim then
                            canplaystop = true
                            if sklad.spr_startAnim then
                                canplayanim = true
                            end
                        elseif curanim == sklad.spr_startAnim then
                            canplayanim = true
                        end
                        pickupSpr:Play(sklad.spr_idleAnim)
                    end
                    if sklad.digits[1] then
                        if canplayanim then
                            pickupSpr:Play(sklad.spr_animAnim)
                        end
                        if math.abs(currentvalue - sklad.digits[1].value) > 0.9 then
                            if sklad.spr_startAnim then
                                if pickupSpr:GetAnimation() == sklad.spr_idleAnim then
                                    pickupSpr:Play(sklad.spr_startAnim, true)
                                end
                            else
                                pickupSpr:Play(sklad.spr_animAnim)
                            end
                        elseif canplaystop then
                            pickupSpr:Play(sklad.spr_stopAnim or sklad.spr_idleAnim)
                        end
                    end
                end
            end
        end


        local strOffset = 0
        for j = #sklad.digits, 1, -1 do
            local dig = sklad.digits[j]

            if not isPaused then
                local powten = j==1 and 1 or 10  -- 10 ^ (i-1)
                local predig = sklad.digits[j-1]
                local predigvalue = predig and predig.value
                local valueoff = 0
                if predigvalue and currentvalue > predigvalue then
                    valueoff = 0.5
                end

                local targetValue = (predigvalue and (predigvalue+valueoff) or currentvalue) // powten

                local tarcurdiffabs = math.abs(targetValue - dig.value)
                local isbigger = targetValue > dig.value
                if tarcurdiffabs > 1000 then
                    dig.value = isbigger and (dig.value + 48.7) or (dig.value - 48.7)
                elseif tarcurdiffabs > 100 then
                    dig.value = isbigger and (dig.value + 4.8) or (dig.value - 4.8)
                elseif tarcurdiffabs > 10 then
                    dig.value = isbigger and (dig.value + .49) or (dig.value - .49)
                elseif tarcurdiffabs > 5 then
                    dig.value = isbigger and (dig.value + .2) or (dig.value - .2)
                else
                    dig.value = dig.value * 0.93 + targetValue * 0.07
                    if math.abs(targetValue - dig.value) < 0.02 then
                        dig.value = targetValue
                        dig.prevalue = targetValue
                        dig.wight = getwight(font, tostring(math.floor(dig.value % 10)))
                    end
                end
            end
            
            --[[if targetValue > dig.value + 100 then
                dig.value = dig.value + 5
            elseif targetValue < dig.value - 100 then
                dig.value = dig.value - 5
            elseif targetValue > dig.value + 10 then
                dig.value = dig.value + .5
            elseif targetValue < dig.value - 10 then
                dig.value = dig.value - .5
            else
                dig.value = dig.value * 0.93 + targetValue * 0.07
                if math.abs(targetValue - dig.value) < 0.02 then
                    dig.value = targetValue
                    dig.prevalue = targetValue
                    dig.wight = getwight(font, tostring(math.floor(dig.value % 10)))
                end
            end]]

            if not IsShaderRenderState then
                local proc = dig.value % 1
                local diff = dig.value - dig.prevalue
                local t = math.floor(dig.value % 10)

                local lpos = dig.pos
                lpos.X = lpos.X * 0.9 + (strOffset or 0) * 0.1
                
                local pos = CounterPos + lpos 
                
                --pixel2:Render(CounterPos + Vector(-2, - 11))
                --pixel1:Render(CounterPos + Vector(-2,  fontHeight+1))
                --pixel:Render(coinconterPos + Vector(-2,  fontHeight))

                if proc > 0 then
                    pixel3:Render(CounterPos + Vector(-2, - 11))
                    pixel2:Render(CounterPos + Vector(-2,  fontHeight+1))

                    font:DrawString(t, 
                    pos.X, pos.Y - fontHeight * proc, KColor(1,1,1,1))

                    font:DrawString((tonumber(t) + 1) % 10, 
                    pos.X, pos.Y + fontHeight - fontHeight * (proc), KColor(1,1,1,1))

                else
                    pixel2:Render(CounterPos + Vector(-2, - 11))
                    pixel1:Render(CounterPos + Vector(-2,  fontHeight+1))

                    font:DrawString(t, 
                    pos.X, pos.Y, KColor(1,1,1,1))
                end
            end


            strOffset = strOffset + (dig.wight or 0)
        end
    end

    if #delayrender > 0 then
        for i=1, #delayrender do
            local del = delayrender[i]
            del[1]:Render(del[2])
        end
    end

end)

TR_Manager:AddSafeShaderCallback(mod, CallbackPriority.DEFAULT, function()
    IsShaderRenderState = true
end)
--AnyPlayer, IsHasBirthright


mod:AddCallback(ModCallbacks.MC_HUD_UPDATE, function()
    local player = Isaac.GetPlayer()
    local predictedImageCount = 1
    local MaxCoin = player:GetMaxCoins()
    local MaxBomb = player:GetMaxBombs()
    local MaxKey = player:GetMaxKeys()

    predictedImageCount = predictedImageCount + #(MaxCoin.."") + 1
    predictedImageCount = predictedImageCount + #(MaxBomb.."") + 1
    predictedImageCount = predictedImageCount + #(MaxKey.."") + 1
    if AnyPlayer(PlayerType.PLAYER_BLUEBABY_B) then
        --predictedImageCount = predictedImageCount + (IsHasBirthright(PlayerType.PLAYER_BLUEBABY_B) and 2 or 1) + 1
        predictedImageCount = predictedImageCount + #(player:GetMaxPoopMana().."") + 1
    end
    if AnyPlayer(PlayerType.PLAYER_BETHANY) then
        predictedImageCount = predictedImageCount + #(mod.MaxSoulCharge.."") + 1
    end
    if AnyPlayer(PlayerType.PLAYER_BETHANY_B) then
        predictedImageCount = predictedImageCount + #(mod.MaxSoulCharge.."") + 1
    end

    local VanillaPickupSpr = game:GetHUD():GetPickupsHUDSprite()

    local ysize = #PoryadokPokaza.SamPoryadok >= 4 and 0 or 2
    local layerOne = VanillaPickupSpr:GetLayer(1)
    if layerOne then
        layerOne:SetColor(Color(1,1,1,1,0,0,0,predictedImageCount ))
        --layerOne:SetSize(Vector(50, #PoryadokPokaza.SamPoryadok * 12 / 2))
        layerOne:SetSize(Vector(50, #PoryadokPokaza.SamPoryadok * 12 / 2 + ysize))
    end
end)

---@param bomb EntityBomb
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, function(_, player, bomb)
    if player and player:HasGoldenBomb() then
        if bomb and not bomb.IsFetus then
            mod.TriedPlaceBomb = true
        end
    end
end)
