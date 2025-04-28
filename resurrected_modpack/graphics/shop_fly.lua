local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Shop Fly", 1, true)

local monster = {}
monster.name = "Shop Parrot"
monster.type = Isaac.GetEntityTypeByName("Shop Parrot")
monster.variant = Isaac.GetEntityVariantByName("Shop Parrot")

local SOUND_KEEPAH = Isaac.GetSoundIdByName("keepah_chirp")
local SOUND_KEEPAH_PANIC = Isaac.GetSoundIdByName("keepah_panic")

local DONATE_BUY_COOLDOWN = 30
local MAX_VOLUME_RANGE = 320 --silent
local MIN_VOLUME_RANGE = 80 --loudest

---@class TR.EntityData.ShopParrot.PlayerData
---@field parrot_talk integer

---@class TR.EntityData.ShopParrot
---@field time integer
---@field real_time integer
---@field replace_sprite boolean
---@field bubble Sprite
---@field closest_enemy EntityPtr?
---@field talk_chance integer
---@field talk_animation string?
---@field donate integer
---@field buy integer

---@class TR.ShopParrot.Settings
---@field ShopParrot boolean
---@field MuteShopBird boolean

local g_Game = Game()
local g_Level = g_Game:GetLevel()

--#region Settings

local json = require("json")

local loadedSettings = false
local Settings = {}
local SettingsSchema = {
	ShopParrot = "boolean",
	MuteShopBird = "boolean"
}

local function validate_setting(data, settingKey)
	local setting = data[settingKey]
	local expectedType = SettingsSchema[settingKey]

	if type(setting) == expectedType then
		return setting
	end
end

---@param settings TR.ShopParrot.Settings
local function init_settings(settings)
	settings.ShopParrot = true
	settings.MuteShopBird = false
end

---@param settings TR.ShopParrot.Settings
local function load_settings(settings)
	init_settings(settings)
	if not mod:HasData() then
		return
	end

	local data = mod:LoadData()
	if data then
		settings.ShopParrot = validate_setting(data, "ShopParrot") or settings.ShopParrot
		settings.MuteShopBird = validate_setting(data, "MuteShopBird") or settings.MuteShopBird
	end
end

local function save_settings(settings)
	local data = json.encode(settings)
	mod:SaveData(data)
end

init_settings(Settings)

---@return TR.ShopParrot.Settings
local function get_settings()
	if not loadedSettings then
		load_settings(Settings)
	end

	return Settings
end

--#endregion

local function is_shop_parrot(entity)
	return entity.Type == monster.type and entity.Variant == monster.variant
end

local function is_room_shop()
	return g_Game:GetRoom():GetType() == RoomType.ROOM_SHOP
end

local function init_parrot_data(entity, data)
	data.time = 0
	data.real_time = 0
	data.replace_sprite = false
	data.bubble = Sprite()
	data.bubble:Load("gfx/famil_parrot.anm2", true)
	data.closest_enemy = nil
	data.talk_chance = 0
	data.talk_animation = nil
	data.donate = 0
	data.buy = 0
end

local function init_player_parrot_data(player, data)
	data.parrot_talk = 0
end

---@param entity Entity
---@return TR.EntityData.ShopParrot
local function get_parrot_data(entity)
	local data = entity:GetData()
	local modData = data[mod]

	if not modData then
		modData = {}
		data[mod] = modData
	end

	if not modData.shop_parrot then
		modData.shop_parrot = {}
		init_parrot_data(entity, modData.shop_parrot)
	end

	return modData.shop_parrot
end

---@param entity Entity
---@return TR.EntityData.ShopParrot.PlayerData
local function get_player_parrot_data(entity)
	local data = entity:GetData()
	local modData = data[mod]

	if not modData then
		modData = {}
		data[mod] = modData
	end

	if not modData.player_shop_parrot then
		modData.player_shop_parrot = {}
		init_player_parrot_data(entity, modData.player_shop_parrot)
	end

	return modData.player_shop_parrot
end

---@param data TR.EntityData.ShopParrot
---@return Entity?
local function get_cached_closed_enemy(data)
	return data.closest_enemy and data.closest_enemy.Ref
end

local function post_parrot_spawn(parrot, appear2)
	parrot.FlipX = parrot.Position.X - Isaac.GetPlayer().Position.X < 0

	if appear2 then
		parrot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		if is_room_shop() then
			parrot:GetSprite():Play("Appear2",true)
		else
			parrot:GetSprite():Play("Idle",true)
		end
	else
		local data = get_parrot_data(parrot)
		data.talk_animation = "BubbleAppear"
		data.bubble:Play(data.talk_animation,true)
	end
end

---@param index integer
local function spawn_parrot(index)
	local room = g_Game:GetRoom()
	local seed = Random()
	seed = seed == 0 and 1 or seed
	local position = room:FindFreePickupSpawnPosition(room:GetCenterPos())

	local parrot = g_Game:Spawn(monster.type, monster.variant, position, Vector.Zero, nil, 0, seed)
	local appear2 = not g_Game:GetRoom():IsFirstVisit() or not is_room_shop()
	post_parrot_spawn(parrot, appear2)

	if is_room_shop() and index > 1 then
		get_parrot_data(parrot).replace_sprite = true
	end
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@return boolean
local function has_finished_appear(entity, data)
	local sprite = entity:GetSprite()
	return not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Appear2")) and data.real_time > 2
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@return boolean
local function is_last_appear_update(entity, data)
	local sprite = entity:GetSprite()
	return (data.real_time == 2 and not sprite:IsPlaying("Appear2")) or sprite:IsFinished("Appear2")
end

local function Init(entity)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
local function set_sprite_sheet(entity, data)
	if is_room_shop() and not data.replace_sprite then
		return
	end

	local sprite = entity:GetSprite()
	sprite:ReplaceSpritesheet(0,"gfx/familiars/shopbird"..(entity.InitSeed % 3)..".png")
	sprite:LoadGraphics()
end

---@param entity Entity
---@param targetPlayer Entity
---@return Vector
local function get_target_position(entity, targetPlayer)
	local rotationSpeed = 2 + (entity.InitSeed % 20) / 20
	local rotationAngle = (entity.InitSeed + entity.FrameCount * rotationSpeed) % 360
	local scale = (entity.InitSeed / 250) % 60 + (entity.Size * 2)

	local offset = Vector(1, 0)
	offset:Rotated(rotationAngle)
	offset:Resized(scale)

	return targetPlayer.Position + offset
end

---@param entity Entity
---@param targetPosition Vector
---@param towardsTarget boolean
---@return Vector
local function get_new_flap_velocity(entity, targetPosition, towardsTarget)
	local rng = entity:GetDropRNG()
	local direction = towardsTarget and 1 or -1

	local maxJitter = math.floor(entity.Size * 16)
	local halfJitter = math.floor(entity.Size * 8)
	local jitterX = rng:RandomInt(maxJitter) - halfJitter
	local jitterY = rng:RandomInt(maxJitter) - halfJitter
	local jitter = Vector(jitterX, jitterY)

	local flapImpulse = (targetPosition - entity.Position) * direction + jitter
	return entity.Velocity + (flapImpulse / 48.0)
end

---@param entity Entity
---@param targetPosition Vector
---@return Vector
local function get_new_target_player_velocity(entity, targetPosition)
	local delta = targetPosition - entity.Position
	local distance = delta:Length()

	if distance <= entity.Size*8 then
		return entity.Velocity
	end

	local reach = math.min(distance, 64)
	local approachVelocity = delta:Resized(reach) / 192.0
	return entity.Velocity + approachVelocity
end

---@param entity Entity
---@param targetPosition Vector
---@param offensive boolean
---@return Vector
local function get_new_target_enemy_velocity(entity, targetPosition, offensive)
	if not offensive and (entity.Position - targetPosition):Length() < entity.Size*16 then
		return entity.Velocity
	end

	local direction = offensive and 1 or -1 -- 1 = towards, -1 = away
	return entity.Velocity + (targetPosition - entity.Position) * direction / 80.0
end

---@param entity Entity
local function spawn_sweat_creep(entity)
	local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector(0,0), entity)
	creep:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	creep.CollisionDamage = g_Level:GetAbsoluteStage() / 4.0 + 5.0
	creep:ToEffect().Timeout = 20
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@param player Entity
local function update_movement(entity, data, player)
	local enemyMovement = false
	local target_pos = get_target_position(entity, player)
	local sprite = entity:GetSprite()

	local closestEnemy = get_cached_closed_enemy(data)
	if not closestEnemy or closestEnemy:IsDead() or not closestEnemy:IsVisible() then
		data.closest_enemy = nil
	else
		target_pos = closestEnemy.Position
		enemyMovement = true
	end

	local offensive = not is_room_shop() and enemyMovement
	local towardsTarget = offensive or not enemyMovement

	entity.Velocity = enemyMovement and get_new_target_enemy_velocity(entity, target_pos, offensive) or get_new_target_player_velocity(entity, target_pos)

	if sprite:IsEventTriggered("Flap") then
		entity.Velocity = get_new_flap_velocity(entity, target_pos, towardsTarget)

		if offensive and string.match(sprite:GetAnimation(),"Sweat") then
			spawn_sweat_creep(entity)
		end
	end

	entity.FlipX = entity.Position.X - target_pos.X < 0
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
local function on_last_appear_update(entity, data)
	local idleAnimation = data.closest_enemy ~= nil and "IdleSweat" or "Idle"
	entity:GetSprite():Play(idleAnimation,false)
end

---@param entity EntityNPC
---@param data TR.EntityData.ShopParrot
---@param player Entity
local function update_talk_sound(entity, data, player)
	if get_settings().MuteShopBird == true then
		return
	end

	local volume_mod = 1 - math.min(1,((entity.Position - player.Position):Length()- MIN_VOLUME_RANGE) / (MAX_VOLUME_RANGE))
	data.time = math.floor(data.time)

	if volume_mod <= 0 then
		return
	end

	local pitch_off = entity:GetDropRNG():RandomFloat()

	if data.closest_enemy ~= nil then
		if data.time % 7 == 6 then -- panic
			entity:PlaySound(SOUND_KEEPAH_PANIC, 0.45*volume_mod, 0, false, 0.9-0.125+pitch_off*0.25)
		end
		return
	end

	if data.donate > 0 then
		if data.time % 5 == 3 then -- donate
			entity:PlaySound(SOUND_KEEPAH, 0.55*volume_mod, 0, false, 1.1-0.125+pitch_off*0.25)
		end
		return
	end

	if data.buy > 0 then -- buy
		if data.time % 6 == 5 then
			entity:PlaySound(SOUND_KEEPAH, 0.55*volume_mod, 0, false, 1-0.125+pitch_off*0.25)
		end
		return
	end

	if data.time % 7 == 4 then -- conversation
		entity:PlaySound(SOUND_KEEPAH_PANIC, 0.45*volume_mod, 0, false, 1.0-0.0625+pitch_off*0.125)
	end
end

---@param entity Entity
---@return boolean
local function is_enemy(entity)
	if not entity:IsVulnerableEnemy() then
		return false
	end

	if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY_BALL) then
		return false
	end

	return true
end

---@param position Vector
---@return Entity?
local function get_closest_enemy(position)
	local closest = nil
	for _, npc in ipairs(Isaac.GetRoomEntities()) do
		if is_enemy(npc) and (closest == nil or (npc.Position - position):Length() < (closest.Position - position):Length()) then
			closest = npc
		end
	end
	return closest
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@param sprite Sprite
---@return string? animation
---@return number playbackSpeed
---@return boolean resetBuyDonate
local function get_talk_animation(entity, data, sprite)
	local rng = entity:GetDropRNG()
	local playbackSpeed = 1

	if data.donate > 0 and rng:RandomInt(5) >= 5 - data.talk_chance then
		local animation = "BubbleDonate"..(rng:RandomInt(6)+1)
		return animation, playbackSpeed * 0.8, false
	end

	if data.buy > 0 and 3 - data.talk_chance <= 1 then
		local animation = "BubbleBuy"..(rng:RandomInt(6)+1)
		return animation, playbackSpeed * 1.2, false
	end

	if get_cached_closed_enemy(data) ~= nil and rng:RandomInt(3) >= 5 - data.talk_chance then
		local animation = "BubbleFear"..rng:RandomInt(2)
		if not is_room_shop() then
			animation = "BubbleFear3"
		end
		return animation, playbackSpeed, true
	end

	if rng:RandomInt(8) >= 10 - data.talk_chance then
		local animation = "Bubble"..rng:RandomInt(8)
		return animation, playbackSpeed, true
	end

	return nil, playbackSpeed, true
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@param sprite Sprite
local function update_talk_data(entity, data, sprite)
	data.talk_chance = data.talk_chance + 1
	local talkAnimation, playbackSpeed, reset_buy_donate = get_talk_animation(entity, data, sprite)

	data.talk_animation = talkAnimation
	sprite.PlaybackSpeed = playbackSpeed
	if reset_buy_donate then
		print("Reset")
		data.buy = 0
		data.donate = 0
	end

	if talkAnimation then
		data.talk_chance = 0
	end

	if data.talk_animation ~= nil then
		local animation = get_cached_closed_enemy(data) and "TalkSweat" or "Talk"
		sprite:Play(animation,true)
		data.bubble:Play(data.talk_animation,true)
	else
		local animation = get_cached_closed_enemy(data) and "IdleSweat" or "Idle"
		sprite:Play(animation,true)
	end
end

---@param entity Entity
---@param data TR.EntityData.ShopParrot
---@param sprite Sprite
local function update_state_data(entity, data, sprite)
	local closest_enemy = get_closest_enemy(entity.Position)
	data.closest_enemy = closest_enemy and EntityPtr(closest_enemy) or nil
	update_talk_data(entity, data, sprite)
end

---@param entity EntityNPC
---@param data TR.EntityData.ShopParrot
local function Update(entity, data)
	if entity.FrameCount == 1 then
		set_sprite_sheet(entity, data)
	end

	local player = entity:GetPlayerTarget()
	local appearFlag = has_finished_appear(entity, data)

	entity.Velocity = entity.Velocity * 0.8

	if appearFlag then
		update_movement(entity, data, player)
	end

	if is_last_appear_update(entity, data) then
		on_last_appear_update(entity, data)
	end

	if data.talk_animation ~= nil then
		update_talk_sound(entity, data, player)
	end

	local sprite = entity:GetSprite()
	if sprite:IsFinished("Idle") or sprite:IsFinished("Talk") or sprite:IsFinished("IdleSweat") or sprite:IsFinished("TalkSweat") and appearFlag then
		update_state_data(entity, data, sprite)
	end

	if appearFlag then
		data.bubble:Update()
	end
end

---@param entity EntityNPC
---@param data TR.EntityData.ShopParrot
local function Render(entity, data)
	if not data.bubble then
		return
	end

	local sprite = entity:GetSprite()
	if sprite:IsPlaying("Appear") or sprite:IsPlaying("Appear2") then
		data.talk_animation = "BubbleAppear"
		data.bubble:SetFrame("BubbleAppear", entity:GetSprite():GetFrame())
	elseif data.bubble:GetAnimation() == "BubbleAppear" then
		data.bubble:SetFrame(0)
	end

	data.bubble:Render(Isaac.WorldToScreen(entity.Position),Vector.Zero,Vector.Zero)
end

---@return integer
local function get_shop_parrot_count()
	return is_room_shop() and 1 or 0
end

local function OnGlobalNewRoom()
	if get_settings().ShopParrot == false then
		return
	end

	local count = get_shop_parrot_count()

	for i=1,count do
		spawn_parrot(i)
	end
end

---@param entity Entity
local function set_buy(entity)
	local data = get_parrot_data(entity)
	data.buy = 1
end

---@param entity Entity
local function set_donate(entity)
	local data = get_parrot_data(entity)
	data.donate = 1
end

---@param collider Entity
---@return function?
local function get_collider_set_function(collider)
	if collider.Type == EntityType.ENTITY_PICKUP then
		return set_buy
	end

	if collider.Type == EntityType.ENTITY_SLOT and collider.Variant == SlotVariant.DONATION_MACHINE then
		return set_donate
	end

	return nil
end

local function OnGlobalPlayerCollision(player, collider)
	local data = get_player_parrot_data(player)
	if data.parrot_talk - player.FrameCount > 0 then
		return
	end

	local SetFunction = get_collider_set_function(collider)
	if not SetFunction then
		return
	end

	for _, parrot in ipairs(Isaac.FindByType(monster.type, monster.variant)) do
		SetFunction(parrot)
	end
	data.parrot_talk = player.FrameCount + DONATE_BUY_COOLDOWN
end

--#region Callbacks

monster.npc_init = function(self,ent)
	if not is_shop_parrot(ent) then
		return
	end

	Init(ent)
end

---@param ent EntityNPC
monster.npc_update = function(self,ent)
	if not is_shop_parrot(ent) then
		return
	end

	local data = get_parrot_data(ent)
	data.time = data.time + 1
	data.real_time = data.real_time + 1
	Update(ent, data)
end

monster.npc_post_render = function(self, ent, offset)
	if not is_shop_parrot(ent) then
		return
	end

	local data = get_parrot_data(ent)
	Render(ent, data)
end

monster.new_room = function(self)
	OnGlobalNewRoom()
end

monster.player_collide = function(self, player, collider, low)
	OnGlobalPlayerCollision(player, collider)
end

function SaveSettings()
	local settings = get_settings()
	save_settings(settings)
	loadedSettings = false
end

function LoadSettings()
	get_settings()
	loadedSettings = true
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, monster.npc_init)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, monster.npc_update)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, monster.npc_post_render)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, monster.new_room)
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, monster.player_collide)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveSettings)
mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, LoadSettings)

--#endregion