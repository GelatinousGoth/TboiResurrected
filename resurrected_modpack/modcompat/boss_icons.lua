local mod = RegisterMod("Boss Icons", 1)

if HPBars then
    local path = "gfx/ui/bosshp_icons/"

    HPBars.BossDefinitions["911.0"] = {sprite = path .. "altpath/rotgut_mouth_antibirth.png", offset = Vector(-9, 0)}
    HPBars.BossDefinitions["911.2"] = {sprite = path .. "altpath/rotgut_heart_antibirth.png", offset = Vector(-4, 0)}
	
	HPBars.BossDefinitions["391.162"] = {sprite = "gfx/ui/bosshp_icons/nevermore/nevermore.png", barStyle = "Steven", offset = Vector(-10, 0)}
end

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