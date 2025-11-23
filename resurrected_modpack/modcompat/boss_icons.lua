local mod = RegisterMod("Boss Icons", 1)

if HPBars then
    local path = "gfx/ui/bosshp_icons/"

    HPBars.BossDefinitions["911.0"] = {sprite = path .. "altpath/rotgut_mouth_antibirth.png", offset = Vector(-9, 0)}
    HPBars.BossDefinitions["911.2"] = {sprite = path .. "altpath/rotgut_heart_antibirth.png", offset = Vector(-4, 0)}
end