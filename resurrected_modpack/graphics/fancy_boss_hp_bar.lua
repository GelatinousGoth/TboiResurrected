---@class ModReference
local TR_Manager = require("resurrected_modpack.manager")
FancyBossBar = TR_Manager:RegisterMod("Unique Stage Variants", 1)
include("resurrected_modpack.graphics.fancy_boss_hp_bar.FBB_config")

local isRepentance = REPENTANCE_PLUS or REPENTANCE
local vectorZero = Vector.Zero
local game = Game()

FancyBossBar.bossBarsSprites = FancyBossBar.bossBarsSprites or {
	["big"] = Sprite(),
	["small"] = Sprite()
}

FancyBossBar.bossBarsSprites["big"]:Load("gfx/ui/hp_bosshealthbar.anm2", true)
FancyBossBar.bossBarsSprites["small"]:Load("gfx/ui/hp_bosshealthbarMini.anm2", true)

FancyBossBar.bossBarsSprites["big"].PlaybackSpeed = FancyBossBar.Config["BarAnimationSpeed"] or 1.0
FancyBossBar.bossBarsSprites["small"].PlaybackSpeed = FancyBossBar.Config["BarAnimationSpeed"] or 1.0

FancyBossBar.renderBossBar = FancyBossBar.renderBossBar or false
FancyBossBar.forceBottomBossBarPosition = FancyBossBar.forceBottomBossBarPosition or false
FancyBossBar.forceBossBarDisable = FancyBossBar.forceBossBarDisable or false

local version = "1.6.2"

--to-do--
--Add MCM/Lua config support mod's options

local function GetScreenSize() --thank you, kil-sana!
	local room = game:GetRoom()
    local pos = room:WorldToScreenPosition(vectorZero) - room:GetRenderScrollOffset() - game.ScreenShakeOffset
    
    local rx = pos.X + 60 * 26 / 40
    local ry = pos.Y + 140 * (26 / 40)
    
    return Vector(rx*2 + 13*26, ry*2 + 7*26)
end

local shouldRenderBigIcon = function()
	if isRepentance then
		local room = game:GetRoom()
		return room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH or room:GetType() == RoomType.ROOM_CHALLENGE or game:GetLevel():GetStage() == LevelStage.STAGE8
	end

	return true
end

---@enum BossBarID
local BossBarID = {
	BIG = "big",
	SMALL = "small",
}

---@param id? BossBarID
local function GetFancyBossBar(id)
	id = id or shouldRenderBigIcon() and BossBarID.BIG or BossBarID.SMALL

	return FancyBossBar.bossBarsSprites[id]
end

local shouldRestrictBossCount = function ()
	local room = game:GetRoom()
	return room:GetBossID() == 55 or room:GetBossID() == 88 or room:GetBossID() == 83 or (game:GetLevel():GetStage() == 13 and room:GetType() == RoomType.ROOM_DUNGEON)
end

---@param ent Entity
local shouldIgnoreBossEntity = function (ent)
	return ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or ent:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
end

---@param npc EntityNPC
--[[local shouldForceBottomBossBarPosition = function (npc)
	if npc.Type == EntityType.ENTITY_THE_HAUNT then
		return npc.State == NpcState.STATE_SPECIAL and npc.I1 < 1
	elseif npc.Type == EntityType.ENTITY_MAMA_GURDY then
		return true
	end

	return false
end]]

local bosses = {} ---@type table<integer, Entity>
local function handleBossBarSprite()
	local bossBarSprite = GetFancyBossBar()

	if not shouldRestrictBossCount() then
		for _, ent in pairs(Isaac.GetRoomEntities()) do
			if ent:IsBoss() and not shouldIgnoreBossEntity(ent) and not bosses[ent.Index] then
				--print("adding " .. ent.Type, ent.Index)
				bosses[ent.Index] = ent
			end
		end
	end

	local sortedBosses = {} ---@type table<integer, Entity>
	for i, ent in pairs(bosses) do
		if REPENTOGON and ent.Type == EntityType.ENTITY_DOGMA then
			bossBarSprite:SetRenderFlags(AnimRenderFlags.STATIC)

			bossBarSprite:ReplaceSpritesheet(8, "gfx/ui/ui_bosshealthbarskull_dogma.png")
			bossBarSprite:ReplaceSpritesheet(9, "gfx/ui/ui_bosshealthbarskull_dogma.png", true)
		end
		if not ent:Exists() or shouldIgnoreBossEntity(ent) then
			bosses[i] = nil
		else
			table.insert(sortedBosses, ent)
		end
	end
	table.sort(
		sortedBosses,
		function(a, b)
			return a.Index < b.Index
		end
	)

	if FancyBossBar.renderBossBar then
		bossBarSprite:Update()
	end

	--print(#sortedBosses, "bosses", "IsRendering:", FancyBossBar.renderBossBar, GetFancyBossBar():GetAnimation() or "wtf")

	local appearAnim = not FancyBossBar.Config["BarGlitter"] and "AppearWithoutGlitter" or "Appear"
	local deathAnim = FancyBossBar.Config["DisableDeathBarBlink"] and "DeathWithoutBlink" or "Death"
	if #sortedBosses > 0 then
		if not FancyBossBar.renderBossBar then
			FancyBossBar.renderBossBar = true
		end

		if not bossBarSprite:IsPlaying(appearAnim) and not bossBarSprite:IsFinished(appearAnim) then
			bossBarSprite:Play(appearAnim, true)

			if FancyBossBar.Config["DisableBarStartAnim"] then
				bossBarSprite:SetLastFrame()
			end

			--[[if FancyBossBar.Config["BarGlitter"] then
				bossBarSprite:PlayOverlay("Glitter", true)
			end]]
		end
	elseif #sortedBosses == 0 and FancyBossBar.renderBossBar then
		bossBarSprite:Play(deathAnim)
	end

	if bossBarSprite:IsFinished(deathAnim) then
		FancyBossBar.renderBossBar = false
		FancyBossBar.forceBottomBossBarPosition = false
	end
end

FancyBossBar:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
	--init sprites
	if not FancyBossBar.bossBarsSprites then
		Isaac.DebugString("[FancyBossBar], Init boss bar sprites")
		FancyBossBar.bossBarsSprites = {
			["big"] = Sprite(),
			["small"] = Sprite()
		}

		GetFancyBossBar(BossBarID.BIG):Load("gfx/ui/hp_bosshealthbar.anm2", true)
		GetFancyBossBar(BossBarID.SMALL):Load("gfx/ui/hp_bosshealthbarMini.anm2", true)
	end

	FancyBossBar.renderBossBar = FancyBossBar.renderBossBar or false
	FancyBossBar.forceBottomBossBarPosition = false
	FancyBossBar.forceBossBarDisable = false
end)

--Handle boss bars logic
FancyBossBar:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
	handleBossBarSprite()
end)

function FancyBossBar:onRender(shadername)
	if REPENTOGON or (shadername and shadername == "EmptyShader") then
		if not HPBars and not FancyBossBar.forceBossBarDisable and FancyBossBar.renderBossBar then
			local screenSize = GetScreenSize()
			local isTop = not FancyBossBar.Config["BossBarOnBottom"] and not FancyBossBar.forceBottomBossBarPosition
			local yOffset = isTop and 10 or -14

			local hudOffset = isRepentance and Options.HUDOffset or FancyBossBar.Config["HUDOffset"]

			local barPosition = Vector(-61, yOffset)
			GetFancyBossBar():Render(Vector(screenSize.X / 2, isTop and 12 * hudOffset or screenSize.Y - 12 * hudOffset) + barPosition,vectorZero,vectorZero)
		end
	end
end

if REPENTOGON then
	FancyBossBar:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, FancyBossBar.onRender )
elseif StageAPI and StageAPI.Loaded then
	StageAPI.AddCallback("FancyBossBar", "POST_HUD_RENDER", 1, FancyBossBar.onRender )
else
	FancyBossBar:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, FancyBossBar.onRender )
end

FancyBossBar:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
	if FancyBossBar.renderBossBar then --dirty, very dirty fix
		GetFancyBossBar():Play("Appear", true)
	end

	bosses = {}
	FancyBossBar.renderBossBar = false
	FancyBossBar.forceBottomBossBarPosition = false
	FancyBossBar.forceBossBarDisable = false


	local bigBossSprite = GetFancyBossBar(BossBarID.BIG)
	if REPENTOGON and (bigBossSprite:GetRenderFlags() & AnimRenderFlags.STATIC > 0) then
		bigBossSprite:SetRenderFlags(0)

		bigBossSprite:ReplaceSpritesheet(8, bigBossSprite:GetLayer(8):GetDefaultSpritesheetPath())
		bigBossSprite:ReplaceSpritesheet(9, bigBossSprite:GetLayer(9):GetDefaultSpritesheetPath(), true)
	end
end)

---@param npc EntityNPC
FancyBossBar:AddCallback(ModCallbacks.MC_NPC_UPDATE, function (_, npc)
	if npc.State == NpcState.STATE_SPECIAL and npc.I1 < 1 and not FancyBossBar.forceBottomBossBarPosition then
		FancyBossBar.forceBottomBossBarPosition = true
	end
end, EntityType.ENTITY_THE_HAUNT)

---@param npc EntityNPC
FancyBossBar:AddCallback(ModCallbacks.MC_NPC_UPDATE, function (_, npc)
		FancyBossBar.forceBottomBossBarPosition = true
end, EntityType.ENTITY_MAMA_GURDY)

---@param npc EntityNPC
FancyBossBar:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function (_, npc)
	if not isRepentance or REPENTOGON then return end

	local sprite = npc:GetSprite()
	if npc.Variant == 2 and sprite:GetAnimation() == "Death" and sprite:IsEventTriggered("Shoot") then
		FancyBossBar.forceBossBarDisable = true
	end
end, 950)

local function printDebugInfo()
	print("[FancyBossBar] Version:", version, "Config:")
	Isaac.DebugString("[FancyBossBar] Version: ".. version .. " " .. "Config:")
	for key, value in pairs(FancyBossBar.Config) do
		print(key, ":", tostring(value))
		Isaac.DebugString(key .. ": " .. tostring(value))
	end

end

FancyBossBar:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function (_, cmd)
	if cmd == "fbb_config" then
		printDebugInfo()
	end
	
end)

Isaac.DebugString("[FancyBossBar] Version: " .. version .. " Loaded!")