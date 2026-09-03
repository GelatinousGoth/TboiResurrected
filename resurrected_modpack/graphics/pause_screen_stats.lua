local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Pause Screen Stats")

--removes the stats from the pause menu
mod:AddCallback(ModCallbacks.MC_PRE_PAUSE_SCREEN_RENDER, function(_, _, spr)
        spr.Color = Color(1,1,1,0,0,0,0)
end)

--some characters dont have their own spritesheet so they get redirected to a similar one
local specialIDs = {
    [PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
    [PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
    [PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
    [PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS_B,
    [PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB_B,
    [PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN_B
}

local statLayer = 13

mod:AddCallback(ModCallbacks.MC_POST_PAUSE_SCREEN_RENDER, function(_, spr)
    local pType = Isaac.GetPlayer(0):GetPlayerType()
    local charID = tostring((specialIDs[pType] or pType)+ 1)
    if pType > 40 then charID = "99" end
    local pausemenu = "gfx/ui/pause screen/pause stats" .. charID .. ".png"
    if spr:GetLayer(statLayer):GetSpritesheetPath() == pausemenu then return end
    spr:ReplaceSpritesheet(statLayer, pausemenu, true)
end)


--if youre looking for the modded stats on the main menu. hello its here hi. i hope these are enough keywords for a search
local statsModded = Sprite()
statsModded:Load("gfx/ui/main menu/stats_modded.anm2", true)
statsModded:LoadGraphics()
statsModded:Play("Idle")

mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, function(_)
    local pType = CharacterMenu.GetSelectedCharacterID()
    if pType < 18 then return end
    local offset = (Vector(-6,172))

	statsModded:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, offset), Vector(0,0), Vector(0,0))

end)