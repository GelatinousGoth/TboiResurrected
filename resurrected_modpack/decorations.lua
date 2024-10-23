CrawlspacesRebuilt.decorations = {}
local decorations = CrawlspacesRebuilt.decorations


--randomly generated decoration tables
--each entry corresponds to an animation in that crawlspaces anm2 file
--entries are weighed and assigned an additional chance value before use

--variant layers are layers that can be toggled on/off to edit each sprite on the fly
--each variantlayer entry holds the corresponding layer names in the anm2 file, which can have visibility toggled using repentogon
--examples of this include swapping between shallow and full ceiling tiles and extending background walls for tall rooms

--certain layers are flagged as off by default, meaning they must be toggled on as a variant layer

--each room decor table can contain an optional table "decorChances" which holds the optional parameters:
--ceilingDecorChance, floorDecorChance, bgDecorChance
--if these aren't supplied, the chances will instead fall back on a default probability


--regular crawlspaces (& gideon crawlspace)
decorations.dungeon = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        --backgrounds are tall by default for gideon
        {name = "1", weight = 2, animCount = -1},
        {name = "2", weight = 2, animCount = -1},
        {name = "3", weight = 3, animCount = -1},
        {name = "4", weight = 3, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    bgDecor = {
        --the decorations randomly scattered across the background walls
        {name = "goob", weight = 1, animCount = 2},
        {name = "guys", weight = 1, animCount = 2},
        {name = "penta", weight = 1, animCount = -1},
        {name = "troll", weight = 0.01, animCount = -1}, --nothing to see here
    },
    ceiling = {
        --decorations hanging from the ceiling
        {name = "lip1", weight = 4, animCount = -1},
        {name = "lip2", weight = 4, animCount = -1},
        {name = "web1", weight = 1, animCount = -1},
        {name = "web2", weight = 1, animCount = -1},
        {name = "web3", weight = 1, animCount = -1},
        {name = "web4", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "web", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    edge = {
        --tiles with a convex edge sticking out. the name should come after "left_" or "right_" depending on the direction the edge faces
        {name = "1", weight = 1, animCount = -1},
    },
    floor = {
        --pebbles and other small decorations on the floor
        --non-random animations: poop_0-1000,
        {name = "pebble1", weight = 3, animCount = -1},
        {name = "pebble2", weight = 3, animCount = -1},
        {name = "pebble3", weight = 2, animCount = -1},
    },
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor(not for gideon)
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    }
}


--rotgut crawlspaces
decorations.rotgut = {
    bg = {
        {name = "1", weight = 1, animCount = -1},
        {name = "2", weight = 1, animCount = -1},
        {name = "tubes1", weight = 1, animCount = 2},
        {name = "tubes2", weight = 1, animCount = 2},
    },
    ceiling = {
        {name = "tubes1", weight = 1, animCount = 1},
        {name = "tubes2", weight = 1, animCount = 1},
        {name = "tubes3", weight = 1, animCount = 1},
        {name = "tubes4", weight = 1, animCount = 1},
        variantLayers = {shallowCeiling={"decor1","decor2","ceiling","shallowDecor1","shallowDecor2","shallowCeiling"}},
        layersOffByDefault = {"shallowDecor1", "shallowDecor2", "shallowCeiling"}
    },
    corner = {
        --bg variant layers make up the corners that run along ceilings, with a background below
        {name = "1", weight = 4, animCount = -1},
        {name = "2", weight = 1, animCount = -1},
        variantLayers = {bg={"ceiling","main","bg1","bg2","bgDecor","bgCorner","bgCeiling"}},
        layersOffByDefault = {"bg1", "bg2", "bgCeiling", "bgCorner", "bgDecor"}
    },
    hatch = {variantLayers = {toggleHatch={"main","background"}}},
    decorChances = {ceilingDecorChance = 0.4}
}




--FIENDFOLIO COMPATABILITY

--default backdrop means regular dungeon
decorations.default = decorations.dungeon


decorations.luscious = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 2, animCount = -1},
        {name = "2", weight = 2, animCount = -1},
        {name = "3", weight = 3, animCount = -1},
        {name = "4", weight = 3, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor", hatchToggle="roof"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --skipping bgdecor
    ceiling = {
        --decorations hanging from the ceiling
        {name = "vine1", weight = 4, animCount = -1},
        {name = "vine2", weight = 3, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "vine", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    --skipping floor
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
    decorChances = {ceilingDecorChance = 0.75}
}


decorations.ossuary = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 2, animCount = -1},
        {name = "2", weight = 2, animCount = -1},
        {name = "3", weight = 3, animCount = -1},
        {name = "4", weight = 3, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor", hatchToggle="roof"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --skipping bgDecor. but it would go here
    ceiling = {
        --decorations hanging from the ceiling
        {name = "web1", weight = 3, animCount = -1},
        {name = "web2", weight = 3, animCount = -1},
        {name = "web3", weight = 2, animCount = -1},
        {name = "web4", weight = 3, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "web", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    --skipping floor decorations
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
    decorChances = {ceilingDecorChance = 0.3}
}


decorations.pipes = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 3, animCount = -1},
        {name = "2", weight = 2, animCount = -1},
        {name = "3", weight = 3, animCount = -1},
        {name = "4", weight = 2, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --skipping bgdecor
    ceiling = {
        --decorations hanging from the ceiling
        {name = "web1", weight = 2, animCount = -1},
        {name = "web2", weight = 3, animCount = -1},
        {name = "web3", weight = 2, animCount = -1},
        {name = "web4", weight = 3, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 5, animCount = -1},
        {name = "cracked", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    --skipping floor
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
    decorChances = {ceilingDecorChance = 0.25}
}


decorations.creature = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 3, animCount = -1},
        {name = "2", weight = 3, animCount = -1},
        {name = "3", weight = 2, animCount = -1},
        {name = "4", weight = 3, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --bgDecor would go here but i'm not gonna focus on this until the basics are up and running.
    ceiling = {
        --decorations hanging from the ceiling
        {name = "vines", weight = 2, animCount = 2},
        {name = "littlevines", weight = 3, animCount = -1},
        {name = "bigvine", weight = 1, animCount = 2},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "vines", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    --floor decor would go here, but currently there's only non-random poop animations
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
}


decorations.fortress = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 2, animCount = -1},
        {name = "2", weight = 2, animCount = -1},
        {name = "3", weight = 3, animCount = -1},
        {name = "4", weight = 2, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --again, skipping bgDecor. the only details im really gonna bother filling in are some ceiling decorations
    ceiling = {
        --decorations hanging from the ceiling
        {name = "web1", weight = 1, animCount = -1},
        {name = "web2", weight = 1, animCount = -1},
        {name = "web3", weight = 1, animCount = -1},
        {name = "web4", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "web", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    floor = {
        --pebbles and other small decorations on the floor
        --non-random animations: poop_0-1000,
        {name = "pebble1", weight = 2, animCount = -1},
        {name = "pebble2", weight = 3, animCount = -1},
        {name = "pebble3", weight = 3, animCount = -1},
    },
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
    decorChances = {ceilingDecorChance = 0.4, floorDecorChance = 0.1}
}


decorations.insulation = {
    bg = {
        --the tiles at the top of the room with background walls attached to them
        --non-random animations: rightwall
        {name = "1", weight = 1, animCount = -1},
        {name = "2", weight = 1, animCount = -1},
        {name = "3", weight = 1, animCount = -1},
        {name = "4", weight = 1, animCount = -1},
        variantLayers = {tallBG={"tallBG1","tallBG2"}, ceiling="ceiling", ceilingDecor="ceilingDecor"},
        layersOffByDefault = {"tallBG1", "tallBG2", "ceilingDecor"}
    },
    --skipping bgdecor
    ceiling = {
        --decorations hanging from the ceiling
        {name = "web1", weight = 3, animCount = -1},
        {name = "web2", weight = 2, animCount = -1},
        {name = "web3", weight = 3, animCount = -1},
        {name = "web4", weight = 2, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    corner = {
        --tiles with a concave corner to be rounded. the name should come after "left_" or "right_" depending on the direction the corner faces
        {name = "plain", weight = 4, animCount = -1},
        {name = "web", weight = 1, animCount = -1},
        variantLayers = {shallowCeiling={"ceiling","shallowCeiling"}},
        layersOffByDefault = {"shallowCeiling"}
    },
    --skipping floor
    hatch = {
        --the hatch (and black market door), doesn't use any randomly selected animations.
        --non-random animations: opened, closed, opening, closing, marketdoor
        variantLayers = {floorBelow="floorBelow", toggleHatch={"main","background"}},
        layersOffByDefault = {"floorBelow"}
    },
    decorChances = {ceilingDecorChance = 0.3}
}