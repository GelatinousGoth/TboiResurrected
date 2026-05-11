local enums = {}
local mod = IsaacReflourished

enums.Effects = {
    GHOST_ITEM = {Type = EntityType.ENTITY_EFFECT, 
                Variant = Isaac.GetEntityVariantByName("RF Ghost Item"), 
                SubType = Isaac.GetEntitySubTypeByName("RF Ghost Item")},
    SPIKE_POOF = {Type = EntityType.ENTITY_EFFECT, 
                Variant = Isaac.GetEntityVariantByName("RF Spike Poof"), 
                SubType = Isaac.GetEntitySubTypeByName("RF Spike Poof")},
    SUCK_EFFECT = {Type = EntityType.ENTITY_EFFECT, 
                Variant = Isaac.GetEntityVariantByName("RF Suck Effect"), 
                SubType = Isaac.GetEntitySubTypeByName("RF Suck Effect")},
}

enums.Projectiles = {
    SPIKE = {Type = EntityType.ENTITY_PROJECTILE, 
            Variant = Isaac.GetEntityVariantByName("RF Spike Projectile"),
            SubType = Isaac.GetEntitySubTypeByName("RF Spike Projectile")},
}

---@enum AltPathStage
enums.AltPathStage = {
    UNKNOWN = 0,
    ASHPIT = 1,
    BOILER = 2,
    DROSS = 3,
    GEHENNA = 4,
    GROTTO = 5,
}

enums.CustomCallback = {
    --Runs before the standard calculations to get the curse chance.
    --Return a value to completely skip the calculation.
    PRE_GET_CURSE_CHANCE = "ACCURSED_PRE_GET_CURSE_CHANCE",

    --Runs after the standard calculations to get the curse chance.
    --Return a value to override the calculation. Returned values will be
    --passed to the other callback functions.
    --
    --Params:
    --
    -- * chance - number
    POST_GET_CURSE_CHANCE = "ACCURSED_POST_GET_CURSE_CHANCE",

    --Runs for each curse when a new one needs to be selected.
    --Return a number to set the curse's weight. If no value is returned
    --the default weight is 1.
    --
    --Params:
    --
    -- * curse - LevelCurse
    --
    --Optional args:
	--
	-- * curse - LevelCurse
    PRE_GET_CURSE_WEIGHT = "ACCURSED_PRE_GET_CURSE_WEIGHT",

    --Runs for each curse when a new one needs to be selected.
    --Return a number to override the curse's weight. Returned values will be
    --passed to the other callback functions.
    --
    --Params:
    --
    -- * curse - LevelCurse
    -- * weight - number
    --
    --Optional args:
    --
    -- * curse - LevelCurse
    POST_GET_CURSE_WEIGHT = "ACCURSED_POST_GET_CURSE_WEIGHT",

    --Called from the MC_POST_CURSE_EVAL after the curses for the current
    --floor have been set.
    --Return a bitmask of LevelCurse to override the curses for the floor. Returned
    --values will be passed to the other callback functions.
    --
    --Params
    --
    -- * curses - LevelCurse
    -- * curseFromTrapdoor - LevelCurse
    POST_SET_LEVEL_CURSES = "ACCURSED_POST_SET_LEVEL_CURSES"
}






IsaacReflourished.Enums = enums