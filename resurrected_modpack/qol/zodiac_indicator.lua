local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("Zodiac Indicator", 1, true)

_G.ZodiacIndicator = mod

local sfx = SFXManager()
local itemConfig = Isaac.GetItemConfig()

local Constants = {
    EFFECT_INDICATOR = Isaac.GetEntityVariantByName("Zodiac Indicator"),
    EFFECT_INDICATOR_SUB = 0,
    EFFECT_INDICATOR_PARTICLE_SUB = 1,
    EFFECT_INDICATOR_PARTICLE_SMALL_SUB = 2,
    ITEM_LAYER = 1,
    MONAS_LAYER = 2,
    States = {
        RISING = 0,
        IDLE = 1,
        FADING = 2,
    },

    RISING_TIME = 15,
    IDLE_TIME = 90,
    FADE_TIME = 30,

    INTERVAL_BIG_PARTICLE = 2,
    INTERVAL_SMALL_PARTICLE = 4,

    OFFSET = Vector(0, -30),
    CENTER_SCALE = 1.5,
}

local idleStart = Constants.RISING_TIME
local fadeStart = Constants.IDLE_TIME + idleStart
local particlesEnd = fadeStart + (Constants.FADE_TIME // 2)

local backdrop = "gfx/backdrop/planetarium_blue_base.png"
local backdropSprite = Sprite("gfx/zodiac_background.anm2", true)
backdropSprite:Play("Idle")
local blend = backdropSprite:GetLayer(0):GetBlendMode()
--[[
blend.RGBSourceFactor = BlendFactor.SRC_ALPHA
blend.RGBDestinationFactor = BlendFactor.ONE_MINUS_SRC_ALPHA
blend.AlphaSourceFactor = BlendFactor.ONE
blend.AlphaDestinationFactor = BlendFactor.ONE
]]

function mod:Lerp(first, second, percent)
	return (first + (second - first) * percent)
end

function mod:EaseOutQuint(x)
    return 1 - (1 - x)^5
end

function mod:CreateSpriteAsImage(spr, imageName)
    local scale = spr.Scale * Vector(32, 32)
	local image = Renderer.CreateImage(math.ceil(scale.X), math.ceil(scale.Y), imageName)

    -- Make a copy with only what we need from the original sprite
    -- Don't include offset because the image is translated later
    local copySprite = Sprite()
    copySprite:Load(spr:GetFilename(), true)
    copySprite:SetFrame(spr:GetAnimation(), spr:GetFrame())
    copySprite.Scale = spr.Scale
    copySprite.Rotation = spr.Rotation

	-- Render the sprite onto the image.
	Renderer.RenderToImage(image, function()
		local imageCenter = scale / 2
		copySprite:Render(imageCenter)
	end)

    return image
end

---@return EntityPlayer?
function mod:GetPlayerFromSpawner(spawner)
    return spawner and spawner:ToPlayer()
end

local queueSpawnIndicator = false
---@param player EntityPlayer
function mod:QueueIndicator(player, _, isPostLevelInitFinished)
    if not isPostLevelInitFinished then
        return
    end

    local shouldShow = false
    if player:HasCollectible(CollectibleType.COLLECTIBLE_ZODIAC) then
        shouldShow = true
    end

    if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA) then
        shouldShow = true
    end

    -- Spawn indicator first update (looks nicer)
    if shouldShow then
        queueSpawnIndicator = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, mod.QueueIndicator)

function mod:ResetQueuedSpawn()
    queueSpawnIndicator = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.ResetQueuedSpawn)

function mod:SpawnIndicator()
    if not queueSpawnIndicator then
        return
    end

    local playedSound = false
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if FiendFolio and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA) then
            local indicator = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_SUB, player.Position, Vector.Zero, player):ToEffect()
            indicator:FollowParent(player)

            -- Sounds
            if not playedSound then
                sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
                playedSound = true
            end
        elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ZODIAC) then
            local indicator = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_SUB, player.Position, Vector.Zero, player):ToEffect()
            indicator:FollowParent(player)

            -- Sounds
            if not playedSound then
                sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
                playedSound = true
            end
        end
    end

    mod:ResetQueuedSpawn()
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.SpawnIndicator)

---@param effect EntityEffect
function mod:InitIndicator(effect)
    local sprite = effect:GetSprite()
    if effect.SubType == Constants.EFFECT_INDICATOR_SUB then
        -- Safety checks
        local player = mod:GetPlayerFromSpawner(effect.SpawnerEntity)
        if not player then
            return
        end

        -- Load item sprite
        local data = player:GetData()
        local zodiacEffect = player:GetZodiacEffect()
        local configOne = zodiacEffect ~= nil and itemConfig:GetCollectible(zodiacEffect)
        local configTwo
        if FiendFolio and data.ffsavedata.MonasHieroglyphicaItem then
            configTwo = itemConfig:GetCollectible(data.ffsavedata.MonasHieroglyphicaItem)
        end

        if not configOne and not configTwo then
            return
        end

        if configTwo and configOne then
            sprite:Play("ItemTwoFadeIn", true)
            sprite:ReplaceSpritesheet(Constants.MONAS_LAYER, configOne.GfxFileName, true)
            sprite:ReplaceSpritesheet(Constants.ITEM_LAYER, configTwo.GfxFileName, true)
        else
            sprite:Play("ItemFadeIn", true)
            sprite:ReplaceSpritesheet(Constants.ITEM_LAYER, (configOne or configTwo).GfxFileName, true)
        end

        -- Spawn background
        local child = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_PARTICLE_SUB, effect.Position, Vector.Zero, player):ToEffect()
        child:FollowParent(player)

        if configTwo then
            child:GetData().ZodiacPurple = true
        end

        effect:GetData().ZodiacIndicatorChild = EntityPtr(child)
    elseif effect.SubType == Constants.EFFECT_INDICATOR_PARTICLE_SUB then
        sprite:Play("PoofFadeIn", true)
        effect.DepthOffset = -10
    elseif effect.SubType == Constants.EFFECT_INDICATOR_PARTICLE_SMALL_SUB then
        sprite:Play("Poof", true)
        effect.DepthOffset = -10
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.InitIndicator, Constants.EFFECT_INDICATOR)


---@param effect EntityEffect
function mod:UpdateIndicator(effect)
    local sprite = effect:GetSprite()
    if effect.SubType == Constants.EFFECT_INDICATOR_SUB then
        local player = mod:GetPlayerFromSpawner(effect.SpawnerEntity)
        if not player then
            return
        end

        local data = effect:GetData()
        local ptr = data.ZodiacIndicatorChild and data.ZodiacIndicatorChild.Ref

        if ptr then
            ptr.SpriteOffset = effect.SpriteOffset
        end

        local forehead = player:GetCostumeNullPos("Forehead", true, Vector(0, 1))
        local frame = effect.FrameCount
        if frame < particlesEnd then
            if frame % Constants.INTERVAL_SMALL_PARTICLE == 0 then
                local angle = math.random(0, 360)
                local dir = Vector.FromAngle(angle) * 6
                local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_PARTICLE_SMALL_SUB, effect.Position + effect.SpriteOffset * 1.5, dir, player):ToEffect()
                particle:GetSprite().PlaybackSpeed = 0.75

                if ptr and ptr:GetData().ZodiacPurple then
                    particle:GetData().ZodiacPurple = true
                end
            end
        end


        if effect.State == Constants.States.RISING then
            local progress = frame / Constants.RISING_TIME

            -- Get hover position and set
            local easing = mod:EaseOutQuint(progress)
            local offsetEased = mod:Lerp(forehead, forehead + Constants.OFFSET, easing)
            effect.SpriteOffset = offsetEased

            if ptr then
                ptr:GetSprite().Scale = mod:Lerp(Vector(0, 0), Vector(Constants.CENTER_SCALE, Constants.CENTER_SCALE), easing)
            end

            if progress >= 1 then
                effect.State = Constants.States.IDLE
                ptr:GetSprite():Play("PoofLoop", true)
            end
        elseif effect.State == Constants.States.IDLE then
            local progress = (frame - idleStart) / Constants.IDLE_TIME
            if ptr then
                ptr:GetSprite().Scale = Vector(Constants.CENTER_SCALE, Constants.CENTER_SCALE)
            end
            if progress >= 1 then
                if sprite:IsFinished("ItemTwoFadeIn") then
                    sprite:Play("ItemTwoFadeOut", true)
                else
                    sprite:Play("ItemFadeOut", true)
                end
                if ptr then
                    ptr:GetSprite():Play("PoofFadeOut", true)
                end
                effect.State = Constants.States.FADING
            end
        else
            local progress = (frame - fadeStart) / Constants.FADE_TIME

            -- Get hover position and set
            local easing = mod:EaseOutQuint(progress)
            local offsetEased = mod:Lerp(forehead + Constants.OFFSET, forehead, easing)
            effect.SpriteOffset = offsetEased

            if ptr then
                ptr:GetSprite().Scale = mod:Lerp(Vector(Constants.CENTER_SCALE, Constants.CENTER_SCALE), Vector(0, 0), easing)
            end

            if progress >= 1 then
                effect:Remove()
            end
        end
    else
        if sprite:IsFinished("Poof") or sprite:IsFinished("PoofFadeOut") then
            effect:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.UpdateIndicator, Constants.EFFECT_INDICATOR)

local queuedImages = {}
local backdropImage = Renderer.LoadImage(backdrop)
function mod:RenderParticle(effect)
    ---@type Sprite
    local sprite = effect:GetSprite()
    local scale = sprite.Scale * Vector(32, 32)

    local renderPos = Isaac.WorldToScreen(effect.Position)

    local src = SourceQuad(Vector(0, 0), Vector(scale.X, 0), Vector(0, scale.Y), Vector(scale.X, scale.Y))
    local dst = DestinationQuad(Vector(0, 0), Vector(scale.X, 0), Vector(0, scale.Y), Vector(scale.X, scale.Y))

    local translation = renderPos - scale/2 + effect.SpriteOffset

    -- Create the backdrop image and render it over the whole screen
    -- It should only be visible through the current Image
    local image = mod:CreateSpriteAsImage(sprite, "ZODIAC_INDICATOR_" .. effect.SubType)

    -- Render backdrop over circle sprite
    -- We use blend modes to make it render using the circle's alpha values
    -- So when the circle has transparency, so will the background
    Renderer.RenderToImage(image, function (surfaceRenderController)
        local blendMode = BlendMode.New(BlendFactor.ONE, BlendFactor.SRC_COLOR, BlendFactor.DST_ALPHA, BlendFactor.ONE)
        surfaceRenderController:SetBlendMode(blendMode)

        local RES_X, RES_Y = 600, 400
        local backdropSrc = SourceQuad(Vector(0, 0), Vector(RES_X, 0), Vector(0, RES_Y), Vector(RES_X, RES_Y))
        local backdropDst = DestinationQuad(Vector(0, 0), Vector(RES_X, 0), Vector(0, RES_Y), Vector(RES_X, RES_Y))
        backdropDst:Translate(-translation)

        backdropImage:Render(
            backdropSrc, backdropDst, KColor.White
        )

        -- Render above too to stop white line due to background cutting off
        backdropDst:Translate(Vector(0, -RES_Y))
        backdropImage:Render(
            backdropSrc, backdropDst, KColor.White
        )
    end)

    dst:Translate(translation)
    queuedImages[#queuedImages+1] = {image, src, dst, effect:GetData().ZodiacPurple and KColor.Magenta or KColor.White}
end

-- Create images on pre_render in order to prevent flickering due to issue with the game engine
function mod:GenerateImageIndicator()
    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_PARTICLE_SMALL_SUB)) do
        local effect = ent:ToEffect()
        mod:RenderParticle(effect)
    end

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, Constants.EFFECT_INDICATOR_PARTICLE_SUB)) do
        local effect = ent:ToEffect()
        mod:RenderParticle(effect)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_RENDER, mod.GenerateImageIndicator)

function mod:RenderIndicators()
    for _, imageInfo in ipairs(queuedImages) do
        local image, src, dst, kcolor = table.unpack(imageInfo)
        image:Render(src, dst, kcolor)
    end

    queuedImages = {}

    for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, Constants.EFFECT_INDICATOR, 0)) do
        local effect = ent:ToEffect()
        effect:Render(Vector.Zero)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.RenderIndicators)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function (_, effect)
    if effect.SubType > 0 then
        return false
    end
end, Constants.EFFECT_INDICATOR)