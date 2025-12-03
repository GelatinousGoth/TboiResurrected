FancyBossBar.Config = {
    ["BossBarOnBottom"] = true,       -- should boss bar render on bottom position? - default: true
    ["HUDOffset"] = 1.0,              --for AB+ players since HUDOffset access was added in Repentance API - default: 1.0
    ["BarGlitter"] = true,            --should boss bar glitter anim play on appear animation? - default: true
    ["BarAnimationSpeed"] = 1.0,      -- sprite animations speed - default: 1.0
    ["DisableBarStartAnim"] = false,  -- disables appear animation play on boss spawn - default: false
    ["DisableDeathBarBlink"] = false, -- "disables" boss bar blink on death animation (god damn Spider, why didn't you exposed all ANM2 data for Lua?) - default false
    ["RandomDisableBar"] = false,     -- 50/50 chance to disable fancy boss bar render
    ["RandomDisableGlitter"] = false,
}
