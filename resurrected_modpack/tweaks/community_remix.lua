local TR_Manager = require("resurrected_modpack.manager")

TRCommunityRemix = TR_Manager:RegisterMod("Community Remix", 1)

TRCommunityRemix.RNG = RNG()
TRCommunityRemix.SFX = SFXManager()
TRCommunityRemix.GAME = Game()
TRCommunityRemix.MUSIC = MusicManager()
local game = TRCommunityRemix.GAME
local sfx = TRCommunityRemix.SFX
local rng = TRCommunityRemix.RNG

local pm = PlayerManager

local pgd = Isaac.GetPersistentGameData()
local json = require("json")

local diffLib = require("resurrected_modpack.tweaks.community_remix.difflib")(TRCommunityRemix)
require("resurrected_modpack.tweaks.community_remix.clearawards")
require("resurrected_modpack.tweaks.community_remix.enums")
require("resurrected_modpack.tweaks.community_remix.patch_hearts")

TRCommunityRemix.saveData = TRCommunityRemix.saveData or {}

function TRCommunityRemix.GetSaveData()
	return TRCommunityRemix.saveData
end

TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, iscont) -- seed rng n shit
	TRCommunityRemix.RNG:SetSeed(game:GetSeeds():GetStartSeed())
	TRCommunityRemix.GAME = Game()
	pgd = Isaac.GetPersistentGameData()
end)

do -- custom callbacks and core shit

TRCommunityRemix:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, died)
	Isaac.RunCallback("CR_MC_PRE_DATA_SAVE", TRCommunityRemix.saveData)
	TRCommunityRemix:SaveData(json.encode(TRCommunityRemix.saveData))
end)

TRCommunityRemix.saveData.insaneMark = TRCommunityRemix.saveData.insaneMark ~= nil and TRCommunityRemix.saveData.insaneMark or {}
TRCommunityRemix.saveData.cfg = TRCommunityRemix.saveData.cfg or {}
TRCommunityRemix.saveData.cfg.tear_sounds = TRCommunityRemix.saveData.cfg.tear_sounds ~= nil and TRCommunityRemix.saveData.cfg.tear_sounds or {}

TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, slot)
	pgd = Isaac.GetPersistentGameData()
	if TRCommunityRemix:HasData() then
		TRCommunityRemix.saveData = json.decode(TRCommunityRemix:LoadData())
		if not TRCommunityRemix.saveData.cfg then TRCommunityRemix.saveData.cfg = {} end
		Isaac.RunCallback("CR_MC_POST_DATA_LOAD", TRCommunityRemix.saveData)
		TRCommunityRemix:SaveData(json.encode(TRCommunityRemix.saveData))
	else
		TRCommunityRemix.saveData = {}
		TRCommunityRemix.saveData.cfg = {}
		TRCommunityRemix.saveData.insaneMark = TRCommunityRemix.saveData.insaneMark ~= nil and TRCommunityRemix.saveData.insaneMark or {}
		TRCommunityRemix:SaveData(json.encode(TRCommunityRemix.saveData))
	end
	if TRCommunityRemix.saveData.cfg == nil then TRCommunityRemix.saveData.cfg = {} end
end)
end

TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_)
end)

--sprite init 
local isrendermodsprite = ""
local insanemodemarksprite = Sprite()
insanemodemarksprite:Load("gfx/ui/ex/marks_remix.anm2", true)
insanemodemarksprite:LoadGraphics()

local isaacheadsprite = Sprite()
isaacheadsprite:Load("gfx/ui/ex/isaac_head.anm2", true)
isaacheadsprite:LoadGraphics()
isaacheadsprite:Play("head")
local headY = 96

local diffOverlay = Sprite()
diffOverlay:Load("gfx/ui/ex/difficulty_overlay.anm2", true)
diffOverlay:LoadGraphics()
diffOverlay:Play("NewBlood_0_fadeout")
local diffBlendMode = diffOverlay:GetLayer(0):GetBlendMode()
diffBlendMode.RGBSourceFactor = BlendFactor.DST_COLOR
diffBlendMode.RGBDestinationFactor = BlendFactor.ONE_MINUS_SRC_ALPHA
diffBlendMode.AlphaSourceFactor = BlendFactor.DST_COLOR
diffBlendMode.AlphaDestinationFactor = BlendFactor.ONE_MINUS_SRC_ALPHA

local diffShadowOverlay = Sprite()
diffShadowOverlay:Load("gfx/ui/ex/difficulty_shadowoverlay.anm2", true)
diffShadowOverlay:LoadGraphics()
diffShadowOverlay:Play("overlay_fadeout")
diffShadowOverlay.Color = Color(1,1,1,1,0,0,0)

local winStreakOverlay = Sprite()
winStreakOverlay:Load("gfx/ui/ex/winstreakwidget_overlay.anm2", true)
winStreakOverlay:LoadGraphics()
winStreakOverlay:Play("WinStreak_fadeout")
local winStreakBlendMode = winStreakOverlay:GetLayer(0):GetBlendMode()
winStreakBlendMode.RGBSourceFactor = BlendFactor.DST_COLOR
winStreakBlendMode.RGBDestinationFactor = BlendFactor.ONE_MINUS_SRC_ALPHA
winStreakBlendMode.AlphaSourceFactor = BlendFactor.DST_COLOR
winStreakBlendMode.AlphaDestinationFactor = BlendFactor.ONE_MINUS_SRC_ALPHA

local showhead_bl = {
	[MainMenuType.TITLE] = true,
	[MainMenuType.COLLECTION] = true,
	[MainMenuType.STATS] = true,
	[MainMenuType.ENDINGS] = true,
	[MainMenuType.BESTIARY] = true,
	[MainMenuType.MODCHALLENGES] = true,
	[MainMenuType.MODS] = true,
	[MainMenuType.KEYCONFIG] = true,
}

---@param playerType PlayerType
---@param sprite Sprite
---@param pos Vector
---@param defaultScale Vector
---@param defaultColor Color
TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_RENDER_CHARACTER_SELECT_PORTRAIT, function(_, playerType, sprite, pos, defaultScale, defaultColor)
	isrendermodsprite = tostring(CharacterMenu.GetSelectedCharacterPlayerType())
end)

TRCommunityRemix:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.LATE, function()
	isaacheadsprite:Update()
	diffShadowOverlay:Update()
	winStreakOverlay:Update()
	local headX = TRCommunityRemix.saveData.cfg.mainmenuhandpos or 0

	if Isaac.GetFrameCount()%2==0 then diffOverlay:Update() end
	local charpage = CharacterMenu.GetBigCharPageSprite()
	if TRCommunityRemix.saveData.insaneMark and TRCommunityRemix.saveData.insaneMark[isrendermodsprite] then
		if CharacterMenu.GetActiveStatus() ~= CharacterMenuStatus.SEED then
			insanemodemarksprite:Play("Insane")
			insanemodemarksprite:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, Vector(78, 29)), Vector.Zero, Vector.Zero)
		end
	end
	isrendermodsprite = tostring(CharacterMenu.GetSelectedCharacterPlayerType())

	if TRCommunityRemix.saveData.cfg.mainmenugfx == nil or TRCommunityRemix.saveData.cfg.mainmenugfx then
	if showhead_bl[MenuManager.GetActiveMenu()] then
		if headY < 96 then headY = headY + 1 end
		headY = headY * 1.05
		if headY > 96 then headY = 96 end
	else
		if headY > 0 then headY = headY /1.05 end
	end

	if headY > 96 then headY = 96 elseif headY < 0 then headY = 0 end

	isaacheadsprite:Render(Vector(headX, Isaac.GetScreenHeight() + 112 + headY), Vector.Zero, Vector.Zero)
	end
	local X = Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, charpage.Offset).X --39
	local Y = Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, charpage.Offset).Y--15
	diffOverlay:Render((Vector(X-39, Y-15)), Vector(0,0), Vector(0,0))
	winStreakOverlay:Render(Isaac.WorldToMenuPosition(MainMenuType.CHARACTER, charpage.Offset), Vector(0,0), Vector(0,0))
	diffShadowOverlay:Render(Vector(0,0), Vector(0,0), Vector(0,0))
	diffShadowOverlay.Scale = Vector(Isaac.GetScreenWidth()/480, Isaac.GetScreenHeight()/270)
	if DifficultyManager.GetDifficultySelected().Name ~= "Insane" then return end
	if CharacterMenu.GetActiveStatus() == CharacterMenuStatus.CHARACTER_PAPER_SWAP then
		if CharacterMenu.GetSelectedCharacterMenu() == 0 then
			diffOverlay:Play("NewBlood_swapout")
		end
		if CharacterMenu.GetSelectedCharacterMenu() == 1 then
			diffOverlay:Play("NewBlood_swapin")
		end
	end
end)

TRCommunityRemix:AddCallback("DIFFLIB_MC_POST_DIFFICULTY_CHANGED", function()
	local diffName = DifficultyManager.GetDifficultySelected().Name
	if diffName ~= nil and diffName == "Insane" then
		isaacheadsprite:Play("head_to_bloody")
		diffShadowOverlay:Play("overlay_fadein")
		winStreakOverlay:Play("WinStreak_fadein")
		if CharacterMenu.GetSelectedCharacterMenu() == 0 then
			diffOverlay:Play("NewBlood_0_fadein")
		else
			diffOverlay:Play("NewBlood_1_fadein")
		end
	else
		isaacheadsprite:Play("bloody_to_head")
		diffShadowOverlay:Play("overlay_fadeout")
		winStreakOverlay:Play("WinStreak_fadeout")
		if CharacterMenu.GetSelectedCharacterMenu() == 0 then
			diffOverlay:Play("NewBlood_0_fadeout")
		else
			diffOverlay:Play("NewBlood_1_fadeout")
		end
	end
end)

do -- gamemodes
	local drs = Sprite()
	drs:Load("gfx/ui/ex/difficulties_remix.anm2")
	drs:LoadGraphics()

	local phud = Sprite()
	phud:Load("gfx/ui/ex/playerhud.anm2")
	phud:LoadGraphics()

	do -- insane mode / easy mode

	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function(_)
		if DifficultyManager.GetDifficulty() == "Insane" then
			if game:GetHUD():IsVisible() then
				phud:Play("Insane")
				local addoffset = 0
				local isjacob = 0
				if Isaac.GetPlayer(0) and Isaac.GetPlayer(0):GetPlayerType() == PlayerType.PLAYER_JACOB then
					if addoffset <= 0 then addoffset = -4 end
					addoffset = addoffset + 18
					isjacob = 1
				end
				if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY) then
					if addoffset <= 0 then addoffset = -2 end
					addoffset = addoffset + 11 - (2*isjacob)
					isjacob = 0
				end
				if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BETHANY_B) then
					if addoffset <= 0 then addoffset = -2 end
					addoffset = addoffset + 11 - (2*isjacob)
					isjacob = 0
				end
				if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) then
					if addoffset <= 0 then addoffset = -2 end
					addoffset = addoffset + 11 - (2*isjacob)
					isjacob = 0
				end
				local hudoffsetvec = Vector(20, 12) * Options.HUDOffset
				phud:Render(Vector(4, 74 + addoffset) + hudoffsetvec, Vector.Zero, Vector.Zero)
			end
		end
	end)

	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARKS_RENDER, function(_, spr)
		if MenuManager.IsActive() then return end
		if TRCommunityRemix.saveData.insaneMark and TRCommunityRemix.saveData.insaneMark[isrendermodsprite] then
			spr:ReplaceSpritesheet(0, "gfx/ui/completion_widget_pause_insane.png", true)
		else
			spr:ReplaceSpritesheet(0, "gfx/ui/completion_widget_pause.png", true)
		end
	end)


	TRCommunityRemix:AddCallback("DIFFLIB_MC_POST_ADD_REBIRTH_DIFFICULTIES", function(_)
		if DifficultyManager then
			if DifficultyManager.GetDifficultyIdByName("Insane") then
				DifficultyManager.ClearDifficulty("Insane")
			end
			if pgd:Unlocked(33) then
				DifficultyManager.AddDifficulty("Insane", drs, 1)
			end
		end
	end)


	TRCommunityRemix:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pi, e)
		if DifficultyManager.GetDifficulty() == "Insane" then
            
			if e and e.Type == EntityType.ENTITY_PLAYER and pi.Variant == 40 and pi.SubType == 1 and pi.Price <= 0 then
				if rng:RandomInt(1, 10) == 1 then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, pi.Position, Vector.Zero, pi)
					Isaac.Spawn(4, 3, 0, pi.Position, pi.Velocity, pi)
					sfx:Play(267, 1, 0, false, 1, 0)
					pi:Remove()
					return {Collide = true, SkipCollisionEffects = true}
				end
			end
		end
	end)
	
	TRCommunityRemix:AddCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, function(_, p, amnt, keeper)
		if DifficultyManager.GetDifficulty() == "Insane" and not keeper then
			if amnt > 12 then
				return amnt - 6
			elseif amnt > 6 then
				return amnt - 6
			end
		end
	end)

	local maxHearts = 0
	TRCommunityRemix.newHearts = 0
	local heartAdded = false
	
	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, p)
		if DifficultyManager.GetDifficulty() == "Insane" then
			TRCommunityRemix.newHearts = p:GetMaxHearts()
		end
	end)


	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, p)
		if DifficultyManager.GetDifficulty() == "Insane" then
			if p.SubType ~= 3320 then return end
			if p.State ~= 1 then return end
			heartAdded = true
			p.State = 2
		end
	end, 10)


	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
		if DifficultyManager.GetDifficulty() == "Insane" then
			if Isaac.GetFrameCount() < 10*60 then return end
			maxHearts = p:GetMaxHearts()
			if maxHearts == TRCommunityRemix.newHearts then
				return
			else
				Isaac.CreateTimer(function()
					if heartAdded then TRCommunityRemix.newHearts = p:GetMaxHearts() return end
					if maxHearts < TRCommunityRemix.newHearts then TRCommunityRemix.newHearts = p:GetMaxHearts() return end
					maxHearts = p:GetMaxHearts() - TRCommunityRemix.newHearts
					p:AddMaxHearts(-maxHearts)
					p:AddBrokenHearts(maxHearts/2)
					TRCommunityRemix.newHearts = p:GetMaxHearts()
				end, 1, 1, true)
			end
		end
	end)


	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
		if DifficultyManager.GetDifficulty() == "Insane" then

			if heartAdded then
				Isaac.CreateTimer(function()
				heartAdded = false
			end, 2, 1, true)
			end
		end
	end)


	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, mark)
		if mark ~= CompletionType.MOMS_HEART then return end

		if DifficultyManager.GetDifficulty() == "Insane" then
			local players = pm.GetPlayers()
			for _, p in ipairs(players) do
				local ptype = p:GetPlayerType()
				local idstring = {
					[1] = "01_Isaac",
					[2] = "02_Magdalene",
					[3] = "03_Cain",
					[4] = "04_Judas",
					[5] = "06_Bluebaby",
					[6] = "05_Eve",
					[7] = "07_Samson",
					[8] = "08_Azazel",
					[9] = "09_Lazarus",
					[10] = "10_Eden",
					[11] = "11_TheLost",
					[12] = "09_Lazarus",
					[13] = "04_Judas",
					[14] = "12_Lilith",
					[15] = "13_Keeper",
					[16] = "15_Apollyon",
					[17] = "16_TheForgotten",
					[18] = "16_TheForgotten",
					[19] = "17_Bethany",
					[20] = "18_JacobEsau",
					[21] = "18_JacobEsau",

					[22] = "01_Isaac",
					[23] = "02_Magdalene",
					[24] = "03_Cain",
					[25] = "04_Judas",
					[26] = "06_Bluebaby",
					[27] = "05_Eve",
					[28] = "07_Samson",
					[29] = "08_Azazel",
					[30] = "09_Lazarus",
					[39] = "09_Lazarus",
					[31] = "10_Eden",
					[32] = "11_TheLost",
					[33] = "12_Lilith",
					[34] = "13_Keeper",
					[35] = "15_Apollyon",
					[36] = "16_TheForgotten",
					[41] = "16_TheForgotten",
					[37] = "17_Bethany",
					[38] = "18_JacobEsau",
					[40] = "18_JacobEsau",
				}
				local namestr = p:GetName()
				if idstring[ptype + 1] then
					namestr = idstring[ptype + 1]
				end

                if TRCommunityRemix.saveData.insaneMark == nil then
					TRCommunityRemix.saveData.insaneMark = {}
				end

				if not TRCommunityRemix.saveData.insaneMark[ptype] and not p.Parent then
					TRCommunityRemix.saveData.insaneMark[ptype] = true
				end
			end
		end
	end)

	end

end

-- yoinked insane mode features

-- insane mode gushers/pacers
---@param e EntityNPC
TRCommunityRemix:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, e)
	if DifficultyManager.GetDifficulty() == "Insane" then
		if e.SubType == 1 then return end -- no creep for gushers
		local d = e:GetData()
		d.creep_cd = d.creep_cd or 0
		if d.creep_cd > 0 then d.creep_cd = d.creep_cd - 1 end

		if d.creep_cd == 0 then
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, e.Position, Vector.Zero, e):ToEffect()
			creep:SetColor(Color(1, 1, 1, 0, 0, 0, 0), 1, 999, false, true)
			creep.Scale = 0.75
			creep:SetTimeout(90)
			d.creep_cd = 12
        end
	end
end, 11)

-- insane mode splashers
---@param e EntityNPC 
TRCommunityRemix:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, e)
	if DifficultyManager.GetDifficulty() == "Insane" then
		local d = e:GetData()
		d.creep_cd = d.creep_cd or 0
		if d.creep_cd > 0 then d.creep_cd = d.creep_cd - 1 end

		if d.creep_cd == 0 then
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, e.Position, Vector.Zero, e):ToEffect()
			creep:SetColor(Color(1, 1, 1, 0, 0, 0, 0), 1, 999, false, true)
			creep.Scale = 0.75
			creep:SetTimeout(90)
			d.creep_cd = 12
        end
	end
end, 238)

-- insane mode black globin
---@param e EntityNPC 
TRCommunityRemix:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, e)
	if DifficultyManager.GetDifficulty() == "Insane" then
		local d = e:GetData()
		d.creep_cd = d.creep_cd or 0
		if d.creep_cd > 0 then d.creep_cd = d.creep_cd - 1 end

		if d.creep_cd == 0 then
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_WHITE, 0, e.Position, Vector.Zero, e):ToEffect()
			creep:SetColor(Color(1, 1, 1, 0, 0, 0, 0), 1, 999, false, true)
			creep.Scale = 0.75
			creep:SetTimeout(90)
			d.creep_cd = 12
        end
	end
end, 280)

TRCommunityRemix:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, function(_, door)
	local level = game:GetLevel()
	if DifficultyManager.GetDifficulty() == "Insane" then
		local dimension = level:GetDimension()
		if dimension == 0 then
			if door.TargetRoomType == 4 and door.Desc.Variant ~= DoorVariant.DOOR_HIDDEN then
				if not TRCommunityRemix.saveData.lockedRoomIdx then TRCommunityRemix.saveData.lockedRoomIdx = {} end
				local islockedidx
				for i, v in ipairs(TRCommunityRemix.saveData.lockedRoomIdx) do
					if v == door.TargetRoomIndex then 
						islockedidx = true
					end
				end
				if door:IsLocked() == false and not islockedidx then
					door:SetLocked(true)
					TRCommunityRemix.saveData.lockedRoomIdx[#TRCommunityRemix.saveData.lockedRoomIdx + 1] = door.TargetRoomIndex
				end
			end
		end
	end
end)

do -- tear SFX

	local _toreplace = {
		[1] = {
			[150] = Isaac.GetSoundIdByName("remix tear block"), -- tear block
			[153] = Isaac.GetSoundIdByName("remix tear fire"), -- tear fire
			[258] = Isaac.GetSoundIdByName("remix tear splatter") -- tear fall
		},
		[2] = {
			[150] = Isaac.GetSoundIdByName("flash tear block"), -- tear block
			[153] = Isaac.GetSoundIdByName("flash tear fire"), -- tear fire
			[258] = Isaac.GetSoundIdByName("remix tear splatter") -- tear fall
		}
	}

	TRCommunityRemix:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function(_, id, vol, fd, loop, pitch, pan)
		if TRCommunityRemix.saveData.cfg then
			if TRCommunityRemix.saveData.cfg.tear_sounds and _toreplace[TRCommunityRemix.saveData.cfg.tear_sounds] and _toreplace[TRCommunityRemix.saveData.cfg.tear_sounds][id] then
				return {_toreplace[TRCommunityRemix.saveData.cfg.tear_sounds][id], vol, fd, loop, pitch, pan}
			end
		end
	end)

end

do --game feel ?????

	local goreblacklist = {}
	goreblacklist[217] = true

	TRCommunityRemix:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, e, amnt, flags, src, cd)
		if not TRCommunityRemix.saveData.cfg.gamefeel then return end
		if e:IsEnemy() and amnt > 0 then
			local e = e:ToNPC()
			if e ~= nil and e:IsVulnerableEnemy() and e:IsActiveEnemy() then
				if flags & DamageFlag.DAMAGE_POISON_BURN > 0 then
					if e:HasEntityFlags(EntityFlag.FLAG_POISON) then
						sfx:Play(TRCommunityRemix.SoundEffect.SOUND_POISON, 1, 3, false, 1, 0)
					end
					if e:HasEntityFlags(EntityFlag.FLAG_BURN) then
						sfx:Play(TRCommunityRemix.SoundEffect.SOUND_BURN, 1, 3, false, 1, 0)
					end
				else
					if amnt >= e.MaxHitPoints then
						if not goreblacklist[e.Type] then
							e:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
						end
					end
					if amnt >= (e.MaxHitPoints / 3) then
						local d = e:GetData()
						if amnt >= 10 then
							sfx:Play(77, 0.5, 3, false, 1, 0)
							sfx:Play(TRCommunityRemix.SoundEffect.SOUND_HIT_CRIT_HEAVY, 0.5, 3, false, 0.75, 0)
						elseif amnt >= 7 then
							sfx:Play(TRCommunityRemix.SoundEffect.SOUND_HIT_CRIT_HEAVY, 0.5, 3, false, 1, 0)
							sfx:Play(642, 0.5, 3, false, 1.25, 0)
						else
							sfx:Play(642, 0.5, 3, false, 1.5, 0)
						end
						if not d._gf_hitstun then
							d._gf_hitstun = 5
						end
					else
						if amnt >= 10 then
							sfx:Play(77, 0.35, 3, false, 1, 0)
							sfx:Play(TRCommunityRemix.SoundEffect.SOUND_HIT_CRIT_HEAVY, 0.35, 3, false, 1, 0)
						elseif amnt >= 7 then
							sfx:Play(TRCommunityRemix.SoundEffect.SOUND_HIT_CRIT_HEAVY, 0.35, 3, false, 1, 0)
							sfx:Play(642, 0.35, 3, false, 1.5, 0)
						else
							sfx:Play(642, 0.35, 3, false, 1.75, 0)
						end
					end
				end
			end
		end
	end)

		TRCommunityRemix:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, CallbackPriority.IMPORTANT, function(_, e)
		local d = e:GetData()
		if d._gf_hitstun and e.State ~= NpcState.STATE_APPEAR and e.FrameCount > 4 then
			local s = e:GetSprite()
			if d._gf_hitstun > 0 then 
				if s.PlaybackSpeed > 0 and e:IsBoss() == false then
					if not d._gf_original_pbspd then d._gf_original_pbspd = s.PlaybackSpeed end
					if d._gf_original_scale == nil then d._gf_original_scale = Vector(e.SpriteScale.X, e.SpriteScale.Y) end
					if not d._gf_original_vel then d._gf_original_vel = e.Velocity end
					s.PlaybackSpeed = 0
				end
				
				if d._gf_hitstun == 5 then
					e:SetColor(Color(0/255, 0/255, 0/255, 1, 192/255, 0, 0), 3, 999, false, false)
				end
				
				if d._gf_hitstun == 3 then
					e:SetColor(Color(1, 1, 1, 1, 0.5, 0.5, 0.5), 3, 1, false, false)
				end
				
				if d._gf_hitstun == 1 then
					e:SetColor(Color(172/255, 140/255, 76/255, 1, 30/255, 20/255, 5/255), 3, 1, false, false)
				end
				
				d._gf_hitstun = d._gf_hitstun - 1
				e:MultiplyFriction(0.25)
				
				if not e:HasMortalDamage() then
					return true
				else
					if d._gf_original_pbspd then
						s.PlaybackSpeed = 1
						d._gf_original_pbspd = nil
					end
					
					if d._gf_original_vel then
						e.Velocity = d._gf_original_vel
						d._gf_original_vel = nil
					end
					
					if d._gf_original_scale then
						e.SpriteScale = d._gf_original_scale
						d._gf_original_scale = nil
					end
					
					d._gf_hitstun = nil
				end
			else
				if d._gf_original_pbspd then
					s.PlaybackSpeed = 1
					d._gf_original_pbspd = nil
				end
				
				if d._gf_original_vel then
					e.Velocity = d._gf_original_vel
					d._gf_original_vel = nil
				end
				
				if d._gf_original_scale then
					e.SpriteScale = d._gf_original_scale
					d._gf_original_scale = nil
				end
				d._gf_hitstun = nil
			end
		end
	end)
	
	TRCommunityRemix:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_RENDER, CallbackPriority.IMPORTANT, function(_, e)
		local d = e:GetData()
		if d._gf_hitstun then
			local s = e:GetSprite()
			if d._gf_hitstun > 0 and e:IsBoss() == false and s:GetAnimation() ~= "Appear" then
				
				if d._gf_hitstun >= 4 then
					if d._gf_original_scale then
						e.SpriteScale = Vector(d._gf_original_scale.X * 0.9, d._gf_original_scale.Y * 1.1)
					end
				end
				
				if d._gf_hitstun < 4 then
					if d._gf_original_scale then
						e.SpriteScale = Vector(d._gf_original_scale.X * 1.1, d._gf_original_scale.Y * 0.9)
					end
				end
				
				if d._gf_hitstun < 2 then
					if d._gf_original_scale then
						e.SpriteScale = Vector(d._gf_original_scale.X * 0.95, d._gf_original_scale.Y * 1.05)
					end
				end
			end
		end
	end)


end

do -- cosmetic

	ImGui.AddElement('TRMenu', 'communityRemixMenu', ImGuiElement.MenuItem, '\u{f5d1} Community Remix Options')
	ImGui.CreateWindow('communityRemixWindow', 'Community Remix Options')
	ImGui.LinkWindowToElement('communityRemixWindow', 'communityRemixMenu')
	ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Text, "\n")
	ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Separator)
	do -- tear sfx
		local id = 'communityRemixTearsSFX'
		ImGui.AddCombobox('communityRemixWindow', id, 'Tear Sounds', function(i, v)
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				sd.cfg.tear_sounds = i
				sd.cfg.tear_sounds = sd.cfg.tear_sounds or i
				TRCommunityRemix:SaveData(json.encode(sd))
			end
		end, {"Rebirth", "Remix", "Flash"}, 1, true)
		ImGui.AddCallback(id, ImGuiCallback.Render, function()
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				sd.cfg.tear_sounds = sd.cfg.tear_sounds or 0
				ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.tear_sounds)
			end
		end)
		ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Separator)
	end
	do -- gamefeel gfx
		local id = 'communityRemixStunGFX'
		ImGui.AddCheckbox('communityRemixWindow', id, 'Stun GFX', nil, false)
		ImGui.AddCallback(id, ImGuiCallback.Render, function()
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				if sd.cfg.gamefeel == nil then sd.cfg.gamefeel = true end
				ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.gamefeel)
			end
		end)
		ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				if sd.cfg.gamefeel == nil then sd.cfg.gamefeel = v end
				sd.cfg.gamefeel = v
				TRCommunityRemix:SaveData(json.encode(sd))
			end
		end)
		ImGui.SetHelpmarker(id, "A stun effect is applied to enemies less powerful than you when you hit them.")
		ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Separator)
	end
	do -- main menu gfx
		local id = 'communityRemixMainMenuGFX'
		ImGui.AddCheckbox('communityRemixWindow', id, 'Main Menu GFX', nil, false)
		ImGui.AddCallback(id, ImGuiCallback.Render, function()
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				if sd.cfg.mainmenugfx == nil then sd.cfg.mainmenugfx = true end
				ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.mainmenugfx)
			end
		end)
		ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				if sd.cfg.mainmenugfx == nil then sd.cfg.mainmenugfx = v end
				sd.cfg.mainmenugfx = v
				TRCommunityRemix:SaveData(json.encode(sd))
			end
		end)
		ImGui.SetHelpmarker(id, "Extra main menu graphic details.")
		ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Separator)
	end
	do
		local id = 'remixMenuCosmeticMainMenuHandPos'
		ImGui.AddSliderInteger('communityRemixWindow', id, 'Main Menu Hand Position', nil, 0, -100, 100)
		ImGui.AddCallback(id, ImGuiCallback.Render, function (v) -- Function ran whenever the slider is changed.
			local sd = TRCommunityRemix.GetSaveData()
    		if sd.cfg then
				sd.cfg.mainmenuhandpos = sd.cfg.mainmenuhandpos or 0
				ImGui.UpdateData(id, ImGuiData.Value, sd.cfg.mainmenuhandpos)
			end
		end)
		ImGui.AddCallback(id, ImGuiCallback.Edited, function(v)
			local sd = TRCommunityRemix.GetSaveData()
			if sd.cfg then
				sd.cfg.mainmenuhandpos = v
				sd.cfg.mainmenuhandpos = sd.cfg.mainmenuhandpos or v
				TRCommunityRemix:SaveData(json.encode(sd))
			end
		end)
		ImGui.SetHelpmarker(id, "Position of Isaac's hand in the main menu.")
		ImGui.AddElement('communityRemixWindow', '', ImGuiElement.Separator)
	end
	end