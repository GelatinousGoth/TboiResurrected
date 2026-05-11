local mod = RegisterMod("Boss Icons", 1)

if HPBars then
    local path = "gfx/ui/bosshp_icons/"

    HPBars.BossDefinitions["911.0"] = {sprite = path .. "altpath/rotgut_mouth_antibirth.png", offset = Vector(-9, 0)}
    HPBars.BossDefinitions["911.2"] = {sprite = path .. "altpath/rotgut_heart_antibirth.png", offset = Vector(-4, 0)}
	
	HPBars.BossDefinitions["391.162"] = {sprite = "gfx/ui/bosshp_icons/nevermore/nevermore.png", barStyle = "Steven", offset = Vector(-10, 0)}
end

local function isBoilerStage()
    local isBoiler = StageAPI.GetCurrentStageDisplayName() == "Boiler I"
        or StageAPI.GetCurrentStageDisplayName() == "Boiler II"
        or StageAPI.GetCurrentStageDisplayName() == "Boiler XL"
    return isBoiler
end

-- #region replaceHPBarIcon
if HPBars then
    HPBars.Conditions["isBoilerStage"] = isBoilerStage
    --#region Boiler
        --#region Charlie
    HPBars.BossDefinitions["360.3"] = { 
        sprite = "gfx/ui/bosshp_icons/boiler/charlie/charlie.png",
        offset = Vector(-10, 0)
    }
        --#endregion
        --#region Blister Twins (Affusion and Salmon)
    HPBars.BossDefinitions["360.10"] = {
        sprite = "gfx/ui/bosshp_icons/boiler/blister twins/affusion.png",
        offset = Vector(-7,0)
    }

    HPBars.BossDefinitions["360.11"] = {
        sprite = "gfx/ui/bosshp_icons/boiler/blister twins/salmon.png",
        offset = Vector(-6,0)
    }
        --#endregion
        --#region Creem & Mate
    HPBars.BossDefinitions["360.20"] = {
        sprite = "gfx/ui/bosshp_icons/boiler/creem/creem.png",
        offset = Vector(-10,0)
    }
        --#endregion
        --#region Pipeline
    HPBars.BossDefinitions["360.30"] = {
        sprite = "gfx/ui/bosshp_icons/boiler/pipeline/tootie.png",
        offset = Vector(-10,0)
    }
        --#endregion
        --#region Bitchwood (Wormwood Boiler)
    HPBars.BossDefinitions["62.3"] = {
        sprite = "gfx/ui/bosshp_icons/altpath/wormwood.png",
		conditionalSprites = {
			{"isAbsoluteStage", "gfx/ui/bosshp_icons/altpath/wormwood_corpse.png", {LevelStage.STAGE4_1}},
			{"isAbsoluteStage", "gfx/ui/bosshp_icons/altpath/wormwood_corpse.png", {LevelStage.STAGE4_2}},
			{"isStageType", "gfx/ui/bosshp_icons/altpath/wormwood_dross.png", {StageType.STAGETYPE_REPENTANCE_B}},
            {"isBoilerStage", "gfx/ui/bosshp_icons/boiler/bitchwood/bitchwood.png"},
		},
		offset = Vector(-10, 0)
    }
        --#endregion
    --#endregion
    --#region Grotto
        --#region Stub
    HPBars.BossDefinitions["360.40"] = {
        sprite = "gfx/ui/bosshp_icons/grotto/stub/stub.png",
        offset = Vector(0,0)
    }
        --#endregion
        --#region Sloppy Joe
    HPBars.BossDefinitions["360.50"] = {
        sprite = "gfx/ui/bosshp_icons/grotto/sloppy joe/sloppyjoe.png",
        offset = Vector(0,0)
    }
        --#endregion
        --#region Plumpod II
    HPBars.BossDefinitions["360.60"] = {
        sprite = "gfx/ui/bosshp_icons/grotto/plumpod/plumpod.png",
        offset = Vector(0,0)
    }
        --#endregion
        --#region Ms. Guano
    HPBars.BossDefinitions["360.70"] = {
        sprite = "gfx/ui/bosshp_icons/grotto/ms. guano/msguano.png",
        offset = Vector(0,0)
    }
        --#endregion
        --#region Dripilla
    HPBars.BossDefinitions["360.80"] = {
        sprite = "gfx/ui/bosshp_icons/grotto/dripilla/dripilla.png",
        offset = Vector(-14,0)
    }
        --#endregion
    --#endregion
    --#region Bastille
    --#endregion
end
--#endregion

-- #region replaceHPBarIcon
if HPBars then
    --#region Virtues
    --Kindness
    HPBars.BossDefinitions["714.0"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/kindness.png",
        offset = Vector(-8, 0)
    }
    HPBars.BossDefinitions["714.1"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_kindness.png",
        offset = Vector(-8, 0)
    }
    --Chastity
    HPBars.BossDefinitions["714.10"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/chastity.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.11"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_chastity.png",
        offset = Vector(-10, 0)
    }
    --Charity
    HPBars.BossDefinitions["714.20"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/charity.png",
        offset = Vector(-5, 0)
    }
    HPBars.BossDefinitions["714.21"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_charity.png",
        offset = Vector(-10, 0)
    }
    --Humility
    HPBars.BossDefinitions["714.30"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/humility.png",
        offset = Vector(-8, 0)
    }
    HPBars.BossDefinitions["714.31"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_humility.png",
        offset = Vector(-10, 0)
    }
    --Diligence
    HPBars.BossDefinitions["714.40"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligence.png",
        offset = Vector(-5, 0)
    }
    HPBars.BossDefinitions["714.41"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_diligence.png",
        offset = Vector(-6, 0)
    }
    --Temperance
    HPBars.BossDefinitions["714.50"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/temperance.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.51"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_temperance.png",
        offset = Vector(-10, 0)
    }
    --Patience
    HPBars.BossDefinitions["714.60"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/patience.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.61"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/super_patience.png",
        offset = Vector(-9, 0)
    }
    --Ultra Diligence
    HPBars.BossDefinitions["714.70"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/ultra_diligence.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.71"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_rambler.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.72"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_rattler.png",
        offset = Vector(-8, 0)
    }
    HPBars.BossDefinitions["714.73"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_stickler.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.74"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_slimer.png",
        offset = Vector(-4, 0)
    }
    HPBars.BossDefinitions["714.75"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_clasper.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.76"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/virtues/diligent_cascader.png",
        offset = Vector(-8, 0)
    }
    --#endregion
    --#region Plagues
    --Blood
    HPBars.BossDefinitions["714.100"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_water.png",
        conditionalSprites = {
            { "isHPSmallerPercent", "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_blood.png", { 50 } }
        },
        offset = Vector(-5, 0)
    }
    HPBars.BossDefinitions["714.101"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_water.png",
        conditionalSprites = {
            { "isHPSmallerPercent", "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_blood.png", { 50 } }
        },
        offset = Vector(-5, 0)
    }
    --Frogs
    HPBars.BossDefinitions["714.110"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_frogs.png",
        offset = Vector(-8, 0)
    }
    HPBars.BossDefinitions["714.111"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_frogs.png",
        offset = Vector(-9, 0)
    }
    --Lice
    HPBars.BossDefinitions["714.120"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_lice.png",
        offset = Vector(-10, 0)
    }
    HPBars.BossDefinitions["714.121"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_lice.png",
        offset = Vector(-7, 0)
    }
    --Flies
    HPBars.BossDefinitions["714.130"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_flies.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.131"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_flies.png",
        offset = Vector(-8, 0)
    }
    --Livestock
    HPBars.BossDefinitions["714.140"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_livestock.png",
        offset = Vector(-3, 0)
    }
    HPBars.BossDefinitions["714.141"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_livestock.png",
        offset = Vector(-9, 0)
    }
    --Boils
    HPBars.BossDefinitions["714.150"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_boils.png",
        offset = Vector(-8, 0)
    }
    HPBars.BossDefinitions["714.151"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_boils.png",
        offset = Vector(-8, 0)
    }
    --Hail
    HPBars.BossDefinitions["714.160"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_hail.png",
        offset = Vector(-6, 0)
    }
    HPBars.BossDefinitions["714.161"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_hail.png",
        offset = Vector(-4, 0)
    }
    --Locusts
    HPBars.BossDefinitions["714.170"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_locusts.png",
        barStyle = "Abyss",
        offset = Vector(-9, 0)
    }
    HPBars.BossDefinitions["714.171"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_locusts.png",
        barStyle = "Abyss",
        offset = Vector(-8, 0)
    }
    --Darkness
    HPBars.BossDefinitions["714.180"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_darkness.png",
        offset = Vector(-5, 0)
    }
    HPBars.BossDefinitions["714.181"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_darkness.png",
        offset = Vector(-6, 0)
    }
    --Furstborn
    HPBars.BossDefinitions["714.190"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/plague_of_the_firstborn.png",
        offset = Vector(-7, 0)
    }
    HPBars.BossDefinitions["714.191"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/plagues/calamity_of_the_firstborn.png",
        offset = Vector(-8, 0)
    }
    --#endregion
end
--endregion

-- Hacky way to makes Mother have dedicated barStyle depending on the floor she's in
local function isMortisStage()
    local isMortisStage = StageAPI.GetCurrentStageDisplayName() == "Mortis I"
        or StageAPI.GetCurrentStageDisplayName() == "Mortis II"
        or StageAPI.GetCurrentStageDisplayName() == "Mortis XL"
    if isMortisStage == true then
        HPBars.BossDefinitions["912.0"].barStyle = "Mortis Mother"
        HPBars.BossDefinitions["912.10"].barStyle = "Mortis Mother"
    else
        HPBars.BossDefinitions["912.0"].barStyle = "Mother"
        HPBars.BossDefinitions["912.10"].barStyle = "Mother"
    end
    return isMortisStage
end

function mod:getMotherBarStyle()
    local motherBarStyleName = 'Mother'
    if isMortisStage == true then
        motherBarStyleName = "Mortis Mother"
    end
    return motherBarStyleName
end

-- #region replaceHPBarIcon
if HPBars then
    HPBars.BarStyles["Mortis Mother"] = {
        sprite = "gfx/ui/bosshp_bars/bosses/bossbar_mortis_mother.png",
        overlayAnm2 = "gfx/ui/bosshp_bars/default_overlay.anm2",
        overlaySprite = "gfx/ui/bosshp_bars/bosses/bossbar_overlay_mortis_mother.png",
        idleColoring = HPBars.BarColorings.none,
    }

    HPBars.BarStyles["Haemotoxia"] = {
        sprite = "gfx/ui/bosshp_bars/bosses/bossbar_haemotoxia.png",
        verticalSprite = "gfx/ui/bosshp_bars/bosses/bossbar_haemotoxia_vertical.png",
        barAnm2 = "gfx/ui/bosshp_bars/bosses/haemotoxia_bosshp.anm2",
        barAnimationType = "Animated",
        idleColoring = HPBars.BarColorings.none,
        hitColoring = HPBars.BarColorings.white,
    }

    HPBars.Conditions["isMortisStage"] = isMortisStage

    --#region Mama Plum
    HPBars.BossDefinitions["908.743"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/mamaplum/mamaplum.png",
        offset = Vector(-10, 0)
    }
    --#endregion
    --#region AIDS
    HPBars.BossDefinitions["744.2"] = {
        sprite = "gfx/ui/bosshp_icons/minibosses/aids/aids.png",
        offset = Vector(-10, 0)
    }
    --#endregion
    --#region Cadavra
    HPBars.BossDefinitions["743.1000"] = {
        sprite = "gfx/ui/bosshp_icons/mortis/cadavra/cadavra.png",
        forceSegmentation = true,
        offset = Vector(-8, 0)
    }
    --#endregion
    --#region Chubs
    HPBars.BossDefinitions["743.1001"] = {
        sprite = "gfx/ui/bosshp_icons/mortis/cadavra/chubs.png",
        offset = Vector(-8, 0)
    }
    --#endregion
    --#region Nibs
    HPBars.BossDefinitions["743.1002"] = {
        sprite = "gfx/ui/bosshp_icons/mortis/cadavra/nibs.png",
        offset = Vector(-4, 0)
    }
    --#endregion
    --#region Pinky
    HPBars.BossDefinitions["743.1010"] = {
        sprite = "gfx/ui/bosshp_icons/mortis/pinky/pinky.png",
        offset = Vector(-10, 0)
    }
    --#endregion
    --#region Haemotoxia
    HPBars.BossDefinitions["743.1020"] = {
        sprite = "gfx/ui/bosshp_icons/mortis/haemotoxia/haemotoxia.png",
        conditionalSprites = {
            { "isHPSmallerPercent", "gfx/ui/bosshp_icons/mortis/haemotoxia/haemotoxia_phase2.png", { 50 } }
        },
        barStyle = "Haemotoxia",
        offset = Vector(-7, 0)
    }
    --#endregion
    --#region Mother (phase 1)
    HPBars.BossDefinitions["912.0"] = {
        sprite = "gfx/ui/bosshp_icons/final/mother/mother.png",
        conditionalSprites = {
            { "isMortisStage", "gfx/ui/bosshp_icons/final/mother/mortis_mother.png" },
        },
        barStyle = mod:getMotherBarStyle(),
        offset = Vector(-8, 0)
    }
    --#endregion
    --#region Mother (phase 2)
    HPBars.BossDefinitions["912.10"] = {
        sprite = "gfx/ui/bosshp_icons/final/mother/mother_phase2.png",
        conditionalSprites = {
            { "isMortisStage", "gfx/ui/bosshp_icons/final/mother/mortis_mother_phase2.png" },
        },
        barStyle = mod:getMotherBarStyle(),
        offset = Vector(-8, 0)
    }
    --#endregion
end
--#endregion

if HPBars then
	HPBars.BossIgnoreList["643.3133"] = function(entity) -- Williwaw Clones
        return entity.Parent ~= nil
    end
HPBars.BossIgnoreList["765.2679"] = true -- Freezer Burn's Head
HPBars.BossIgnoreList["770.1010"] = true -- Chuck Ice Block
HPBars.BossIgnoreList["659.2679"] = true -- Wendy Snowpile
HPBars.BossIgnoreList["659.2680"] = true -- Wendy Stalagmite
HPBars.BossIgnoreList["1000.3480"] = true -- Narcissus Monstro
HPBars.BossIgnoreList["790.2679"] = true -- Aragnid Innard
HPBars.BossIgnoreList["758.2679"] = true -- Sarcophaguts Head
HPBars.BossIgnoreList["505.2681"] = true -- Tammy
HPBars.BossIgnoreList["505.2680"] = true -- Guppy
HPBars.BossIgnoreList["505.2679"] = true -- Moxie
HPBars.BossIgnoreList["505.2682"] = true -- Cricket
HPBars.BossIgnoreList["525.2678"] = true -- Jeffrey
HPBars.BossIgnoreList["634.532"] = true -- Lover's Libido Pedestal (lmfao why is this even considered a boss)
-- Main Path Bosses
	HPBars.BossDefinitions["583.2678"] = { -- Raging Long Legs (god i fucking hated this boss back in the day)
		sprite = "gfx/ui/bosshp_icons/revelcommon/raginglonglegs.png",
		bossColors={ "_champion", },
		offset = Vector(-4, 0) 
	}
	HPBars.BossDefinitions["479.2678"] = { -- Punker (ruthless punker go bonkers lowkey)
		sprite = "gfx/ui/bosshp_icons/revelcommon/punker.png",
		bossColors={ "_poop", },
		offset = Vector(-4, 0)
	}          -- Glacier Bosses
	HPBars.BossDefinitions["627.3133"] = { -- Frost Rider Phase 1 (frost rider got that ice lowkey)
		sprite = "gfx/ui/bosshp_icons/revel1/frost_rider.png", 
		bossColors={ "_champion", },
		offset = Vector(-4, 0) 
	}
	HPBars.BossDefinitions["628.3133"] = { -- Frost Rider Phase 2
		sprite = "gfx/ui/bosshp_icons/revel1/frost_rider.png",
		bossColors={ "_champion", },
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["770.1005"] = { -- Chuck the fucking chad
		sprite = "gfx/ui/bosshp_icons/revel1/chuck.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["765.2678"] = { -- Freezer Burn (i love oxymorons)
		sprite = "gfx/ui/bosshp_icons/revel1/freezer_burn.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["625.2678"] = { -- Stalagmight (cool boss but, did you know that there was originally gonna be a gemini variant for glacier? you can actually see it in the chapter 1 cover art
		sprite = "gfx/ui/bosshp_icons/revel1/stalagmight.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["625.2679"] = { -- Stalagmight On Foot! (okay so he is gemini)
		sprite = "gfx/ui/bosshp_icons/revel1/stalagmight.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["20.3133"] = { -- Monsnow (the only reskin that didnt get fuckin deleted)
		sprite = "gfx/ui/bosshp_icons/revel1/monsnow.png",
		bossColors={ "_champion", },
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["475.3133"] = { -- Flurry Jr. (here just in rare case they actually add these goobers back)
		sprite = "gfx/ui/bosshp_icons/revel1/flurry.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["475.3132"] = { -- Flurry Jr. Body ..........
		sprite = "gfx/ui/bosshp_icons/revel1/flurry_body.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["475.3131"] = { -- Flurry Jr. Frozen Body (Glacier ripped off Frostbite Caves from Plants. vs Zombies 2.)
		sprite = "gfx/ui/bosshp_icons/revel1/flurry_frozen_body.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["657.3133"] = { -- Duke of Flakes (this guy is kinda lame ngl)
		sprite = "gfx/ui/bosshp_icons/revel1/duke_of_flakes.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["659.2678"] = { -- Wendy (when i was a kid i red a book about wendigos and it kept me scared for like 1 minute)
		sprite = "gfx/ui/bosshp_icons/revel1/wendy.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["783.2678"] = { -- Prong (this guy bothers the heck out of me)
		sprite = "gfx/ui/bosshp_icons/revel1/prong.png",
		bossColors={ "_champ", },
		offset = Vector(-4, -6)
	}
	HPBars.BossDefinitions["643.3133"] = { -- Williwaw (it's one of those easy once you know the pattern bosses)
		sprite = "gfx/ui/bosshp_icons/revel1/williwaw.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["626.826"] = { -- Narcissus (looked cool back in 2018 ngl)
		sprite = "gfx/ui/bosshp_icons/revel1/narcissus.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["753.1005"] = { -- Prank (when prank died i cried)
		sprite = "gfx/ui/bosshp_icons/revel1/prank.png",
		offset = Vector(-4, 0)
	}	-- Tomb Bosses
	HPBars.BossDefinitions["790.2678"] = { -- Aragnid (the best revelations boss)
		sprite = "gfx/ui/bosshp_icons/revel2/aragnid.png",
		bossColors={ "_ruthless", },
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["758.2678"] = { -- Sarcophaguts (really like this guys new sounds)
		sprite = "gfx/ui/bosshp_icons/revel2/sarcophaguts.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["505.2678"] = { -- Catastrophe (speaking of sounds this boss sounds fucking terrifying)
		sprite = "gfx/ui/bosshp_icons/revel2/catastrophe.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["523.2678"] = { -- Sandy (ah yes the infamous full health heal, glad thats been fixed)
		sprite = "gfx/ui/bosshp_icons/revel2/sandy.png",
		bossColors={ "_champion", },
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["676.2678"] = { -- Maxwell (this guy has too much shit going on)
		sprite = "gfx/ui/bosshp_icons/revel2/maxwell.png",
		iconAnm2 = "gfx/ui/bosshp_icons/revel2/maxwell.anm2",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["761.826"] = { -- Narcissus II: Return to Monke (bullshit boss hes abit more bearable now though)
		sprite = "gfx/ui/bosshp_icons/revel2/narcissus_2.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["771.1005"] = { -- Dungo (lowkey felt bad when he started crying)
		sprite = "gfx/ui/bosshp_icons/revel2/dungo.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["775.1005"] = { -- Ragtime (I love when Ragtime said "It's raggin' time!" and proceeded to rag all over the place. nah fr i like this guy)
		sprite = "gfx/ui/bosshp_icons/revel2/ragtime.png",
		offset = Vector(-4, 0)
	}
	HPBars.BossDefinitions["753.1006"] = { -- Prank (he pranked me)
		sprite = "gfx/ui/bosshp_icons/revel2/prank.png",
		offset = Vector(-4, 0)
	}
end

if HPBars then
-- Old Shopkeeper
	HPBars.BossDefinitions["722.1700"] = {
		sprite = "gfx/ui/bosshp_icons/mod/old_shopkeeper.png",
		offset = Vector(-6, 0)
	}
end