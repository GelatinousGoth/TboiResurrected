local mod = LastJudgementSprites
local game = Game()
local sfx = SFXManager()
mod.RNG = RNG()

function mod:RandomInt(min, max, rand)
    if type(min) == "table" then
        rand = max
        max = min[2]
        min = min[1]
    end
    if not (max or min) then
        rand = rand or mod.RNG
        return rand:RandomFloat()
    elseif not max then
        rand = max
        max = min
        min = 0
    end  
    if min > max then 
        local temp = min
        min = max
        max = temp
    end
    rand = rand or mod.RNG
    return min + (rand:RandomInt(max - min + 1))
end

function mod:RandomFloat(low, high, rng) --I had a comment on this function saying it's not exact but I'm just copy pasting it
    local newLow = math.floor(low)
    local newHigh = math.ceil(high)
    local val = rng:RandomFloat() * (newHigh-newLow)
    return math.max(math.min(newLow+val, high), low)
end

function mod:RandomAngle(rng)
    return mod:RandomInt(0,359,rng)
end

function mod:RandomInRange(i, entrng)
    return mod:RandomInt(-i, i, entrng)
end

function mod:RandomSign(entrng)
    local rand = entrng or mod.RNG
    return (rand:RandomFloat() < 0.5 and -1 or 1)
end

function mod:RandomBool(entrng)
    return mod:RandomSign(entrng) == 1
end

function mod:GetRandomElem(table, rand)
    if table and #table > 0 then
		local index = mod:RandomInt(1, #table, rand)
        return table[index], index
    end
end

function mod:GetRandomIndex(letable, customRNG)
    local indexes = {}
    for index, _ in pairs(letable) do
        table.insert(indexes, index)
    end
    return mod:GetRandomElem(indexes, customRNG)
end

function mod:Lerp(first, second, percent, smoothIn, smoothOut)
    if smoothIn then
        percent = percent ^ smoothIn
    end

    if smoothOut then
        percent = 1 - percent
        percent = percent ^ smoothOut
        percent = 1 - percent
    end

	return (first + (second - first)*percent)
end

function mod:LerpAngleDegrees(aStart, aEnd, percent)
    return aStart + mod:GetAngleDifference(aEnd, aStart) * percent
end

function mod:Shuffle(tbl)
	for i = #tbl, 2, -1 do
        local j = mod:RandomInt(1, i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function mod:Sway(back, forth, interval, smoothIn, smoothOut, frameCnt)
    local time = (frameCnt or game:GetFrameCount()) % interval
    local halfInterval = interval / 2
    if time < halfInterval then
        return mod:Lerp(back, forth, time / halfInterval, smoothIn, smoothOut)
    else
        return mod:Lerp(forth, back, (time - halfInterval) / halfInterval, smoothIn, smoothOut)
    end
end

function mod:SpritePlay(sprite, anim)
	if not sprite:IsPlaying(anim) then
		sprite:Play(anim)
	end
end

function mod:spritePlay(sprite, anim) --Its capatilized like this in FF so im used to this
    mod:SpritePlay(sprite, anim)
end

function mod:SpriteOverlayPlay(sprite, anim)
	if not sprite:IsOverlayPlaying(anim) then
		sprite:PlayOverlay(anim)
	end
end

function mod:SpriteSetAnimation(sprite, anim, reset)
    if reset == nil then reset = false end
    if not sprite:IsPlaying() then
        sprite:Play(anim)
    else
        sprite:SetAnimation(anim, reset)
    end
end

function mod:FlipSprite(sprite, pos1, pos2)
    if pos1.X > pos2.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end
end

function mod:SnapVector(angle, snapAngle)
    snapAngle = snapAngle or 90
	local snapped = math.floor(((angle:GetAngleDegrees() + snapAngle/2) / snapAngle)) * snapAngle
	local snappedDirection = angle:Rotated(snapped - angle:GetAngleDegrees())
	return snappedDirection
end

function mod:GetAngleDegreesButGood(vec)
    local angle
    if type(vec) == "number" then angle = vec
    else angle = (vec):GetAngleDegrees() end
    
    if angle < 0 then
        return 360 + angle
    else
        return angle
    end
end

--From Dead
function mod:GetAngleDifference(a1, a2)
    a1 = mod:GetAngleDegreesButGood(a1)
    a2 = mod:GetAngleDegreesButGood(a2)
    local sub = a1 - a2
    return (sub + 180) % 360 - 180
end

function mod:NormalizeDegrees(a)
    return -((-a + 180) % 360) + 180
end

function mod:NormalizeDegreesTo360(a)
    return a % 360
end

function mod:GetAbsoluteAngleDifference(vec1, vec2)
    local val = math.abs(mod:NormalizeDegrees(mod:NormalizeDegrees(mod:GetAngleDegreesButGood(vec1)) - mod:NormalizeDegrees(mod:GetAngleDegreesButGood(vec2))))
    return val
end

--Some of FF's Library for handling status on enemies
function mod:isFriend(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
end
function mod:isCharm(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
end
function mod:isScare(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)
end
function mod:isConfuse(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
end
function mod:isScareOrConfuse(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)
end
function mod:isBaited(npc)
	return npc:HasEntityFlags(EntityFlag.FLAG_BAITED)
end

function mod:makeProjectileConsiderFriend(npc, projectile)
	if npc then
		if mod:isFriend(npc) then
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
		elseif mod:isCharm(npc) then
			projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
		end
	end
end

function mod:reverseIfFear(npc, vec, multiplier)
	multiplier = multiplier or 1
	if mod:isScare(npc) then
		vec = vec * -1 * multiplier
	end
	return vec
end

function mod:confusePos(npc, pos, frameCountCheck, isVec, alwaysConfuse)
	frameCountCheck = frameCountCheck or 10
	local d = npc:GetData()
	if mod:isConfuse(npc) or alwaysConfuse then
		if isVec then
			if npc.FrameCount % frameCountCheck == 0 then
				d.confusedEffectPos = nil
			end
			d.confusedEffectPos = d.confusedEffectPos or RandomVector()*math.random(2,5)
			return d.confusedEffectPos
		else
			if npc.FrameCount % frameCountCheck == 0 then
				d.confusedEffectPos = nil
			end
			if d.confusedEffectPos and npc.Position:Distance(d.confusedEffectPos) < 2 then
				d.confusedEffectPos = npc.Position
			end
			d.confusedEffectPos = d.confusedEffectPos or npc.Position + RandomVector()*math.random(5,15)
			return d.confusedEffectPos
		end
	else
		d.confusedEffectPos = nil
		return pos
	end
end

function mod:rotateIfConfuse(npc, vec)
	if mod:isConfuse(npc) then
		vec = vec:Rotated(mod:RandomInt(360))
	end
	return vec
end

function mod:UnscareWhenOutOfRoom(npc, timeCheck)
	local d = npc:GetData()
	timeCheck = timeCheck or 10
	if mod:isScare(npc) then
		local room = Game():GetRoom()
		if not room:IsPositionInRoom(npc.Position, 0) then
			d.outOfRoomUncareTimer = d.outOfRoomUncareTimer or 0
			d.outOfRoomUncareTimer = d.outOfRoomUncareTimer + 1
			if d.outOfRoomUncareTimer > timeCheck then
				npc:ClearEntityFlags(EntityFlag.FLAG_FEAR)
				npc.Color = Color.Default
			end
		else
			d.outOfRoomUncareTimer = 0
		end
	else
		d.outOfRoomUncareTimer = 0
	end
end

function mod:GetPlayerTarget(npc)
    if npc.FrameCount % 30 == 0 or not (npc.Target and npc.Target:Exists()) then
        npc.Target = npc:GetPlayerTarget()
    end
    return npc.Target
end

function mod:GetPlayerTargetPos(npc)
    return mod:confusePos(npc, mod:GetPlayerTarget(npc).Position)
end

function mod:HasDamageFlag(damageFlags, damageFlag)
    return damageFlags & damageFlag ~= 0
end
local DelayedFuncs = {}
local function RunUpdates(tab)
	for i = #tab, 1, -1 do
		local f = tab[i]
		f.Delay = f.Delay - 1
		if f.Delay <= 0 then
			f.Func()
			table.remove(tab, i)
		end
	end
end

function mod:ScheduleForUpdate(foo, delay, callback, noCancelOnNewRoom)
	callback = callback or ModCallbacks.MC_POST_UPDATE
	if not DelayedFuncs[callback] then
		DelayedFuncs[callback] = {}
		mod:AddCallback(callback, function()
			RunUpdates(DelayedFuncs[callback])
		end)
	end

	table.insert(DelayedFuncs[callback], {Func = foo, Delay = delay or 0, NoCancel = noCancelOnNewRoom})
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, function()
	for callback, tab in pairs(DelayedFuncs) do
		for i = #tab, 1, -1 do
			local f = tab[i]
			if not f.NoCancel then
				table.remove(tab, i)
			end
		end
	end
end)

--EntityNPC:PlaySound() but with optional arguments
function mod:PlaySound(soundID, npc, pitch, volume, isLooping, frameDelay, pan)
    pitch = pitch or 1
    volume = volume or 1
    frameDelay = frameDelay or 2
    pan = pan or 0
    if npc and npc:ToNPC() then
        npc:ToNPC():PlaySound(soundID, volume, frameDelay, isLooping, pitch)   
    else
        sfx:Play(soundID, volume, frameDelay, isLooping, pitch, pan) 
    end
end

function mod:PrintColor(color)
    print(color.R.." "..color.G.." "..color.B.." "..color.A.." "..color.RO.." "..color.GO.." "..color.BO)
end

function mod:GetMoveString(vec, doFlipX)
    if math.abs(vec.Y) > math.abs(vec.X) then
        if vec.Y > 0 then
            return "Down", false
        else
            return "Up", false
        end
    else
        if vec.X > 0 then
            if doFlipX then
                return "Hori", false
            else
                return "Right", false
            end
        else
            if doFlipX then
                return "Hori", true
            else
                return "Left", false
            end
        end
    end
end

function mod:AnimWalkFrame(npc, sprite, horianim, vertanim, doFlip, idleAnim, idleThreshold)
    idleThreshold = idleThreshold or 0.1
    if npc.Velocity:Length() < idleThreshold then
        if idleAnim then
            mod:spritePlay(sprite, idleAnim)
        elseif type(vertanim) == "table" then
            sprite:SetFrame(vertanim[1], 0)
        else
            sprite:SetFrame(vertanim, 0)
        end
    else
        local anim
        if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            if type(horianim) == "table" and not doFlip then
                if npc.Velocity.X > 0 then
                    anim = horianim[1]
                else
                    anim = horianim[2]
                end
            else
                anim = horianim
            end
        else
            if type(vertanim) == "table" then
                if npc.Velocity.Y > 0 then
                    anim = vertanim[1]
                else
                    anim = vertanim[2]
                end
            else
                anim = vertanim
            end
        end
        if npc.Velocity.X < 0 and doFlip then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
        if not sprite:IsPlaying() then
            sprite:Play(anim)
        else
            sprite:SetAnimation(anim, false)
        end
    end
end

function mod:MinimizeVector(vec, len)
    return vec:Resized(math.min(vec:Length(), len))
end

function mod:ChasePlayer(npc, speed, lerpval, setGridPath)
    return mod:ChasePosition(npc, mod:confusePos(npc, npc:GetPlayerTarget().Position), speed, lerpval, setGridPath)
end

function mod:ChasePosition(npc, targetpos, speed, lerpval, setGridPath)
    lerpval = lerpval or 0.3
    local pathSpeed
    if type(speed) == "table" then
        pathSpeed = speed[2]
        speed = speed[1]
    else
        pathSpeed = (speed * 0.1) + 0.2
    end
    if setGridPath == nil then setGridPath = true end
    local room = game:GetRoom()

    if setGridPath then
        mod:QuickSetEntityGridPath(npc)
    end

    if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(speed)), lerpval)
        return true
    elseif npc.Pathfinder:HasPathToPos(targetpos) then
        npc.Pathfinder:FindGridPath(targetpos, pathSpeed, 900, true)
        return true
    else
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, lerpval)
    end
end

function mod:isLeavingStatusCorpse(entity)
	return entity:HasMortalDamage() and (entity:HasEntityFlags(EntityFlag.FLAG_ICE) or entity:GetData().FFApplyMartyrOnDeath == true)
end

function mod:isStatusCorpse(entity)
	return entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN) or entity:GetData().FFMartyrDuration ~= nil
end

function mod:IsReallyDead(npc)
    if npc then 
        if npc:ToNPC() ~= nil then
            npc = npc:ToNPC()
            return (npc:IsDead() or npc.State == 18 or mod:isLeavingStatusCorpse(npc) or mod:isStatusCorpse(npc))
        else
            return not npc:Exists()
        end
    end
    return true
end

function mod:GetEntityCount(id,var,sub,spawner)
    var = var or -1
    sub = sub or -1
    return Isaac.CountEntities(spawner,id,var,sub)
end

function mod:Sign(var)
    return ((var > 0 and 1) or -1)
end