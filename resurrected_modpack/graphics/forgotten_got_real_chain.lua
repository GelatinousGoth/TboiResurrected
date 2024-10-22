
local TR_Manager = require("resurrected_modpack.manager")
local mod = TR_Manager:RegisterMod("forgotten_got_real_chain", 1)

local game = Game()
local room = game:GetRoom()

local mod_CORD_HELPER = Isaac.GetEntityVariantByName("SW Cord helper")

Isaac.DebugString("If error \"ERROR Could not open gfx/characters/jasau_costume.anm2\" is shown below, please ignore it.")
local DeepLab = false
local DeepLabSprTest = Sprite() 
DeepLabSprTest:Load("gfx/characters/jasau_costume.anm2", true) 
if DeepLabSprTest:GetDefaultAnimation() == "WalkDown" then
	DeepLab = true
end

local FORGOTTEN_SPRITE = "gfx/effects/forgotten chain.png"
local GEMINI_SPRITE = DeepLab and "gfx/effects/lab_gemini_cord.png" or "gfx/effects/gemini_cord.png"
local GEMINI_BLUE_SPRITE = DeepLab and "gfx/effects/lab_gemini_cord.png" or "gfx/effects/gemini_cord_blue.png"
local MRMAW_SPRITE = DeepLab and "gfx/effects/lab_mrmaw_cord.png" or "gfx/effects/mrmaw_cord.png"
local MRMINE_SPRITE = DeepLab and "gfx/effects/lab_mrmine_cord.png" or "gfx/effects/mrmine_cord.png"
local SWINGER_SPRITE = DeepLab and "gfx/effects/lab_swinger_cord.png" or "gfx/effects/swinger_cord.png"
local HOMUNCULUS_SPRITE = DeepLab and "gfx/effects/lab_homunuclus_cord.png" or "gfx/effects/gemini_cord.png"
local BEGOTTEN_SPRITE = DeepLab and "gfx/effects/lab_Begotten_cord.png" or "gfx/effects/Begotten_cord.png"

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, ent)
	local data = ent:GetData()
	
	if not data.SWkishki and not data.SWkishkiINIT then 
		data.SWkishkiINIT = true
   		data.SWkishki = {["Sprite"] = nil, ["baseOffset"] = Vector(0,-9), ["targetOffset"] = Vector(0,-7), ["Stretch"] = 12, 
			["CordFrame"] = 0,["Unit"] = 6,["ZoffMulti"] = 6,["NoZ"]=nil}  
		local maxp = 1000000
		for _, p in pairs(Isaac.FindByType(1, 0, -1, false, false)) do
			if p.SubType == PlayerType.PLAYER_THEFORGOTTEN or p.SubType == PlayerType.PLAYER_THESOUL then
				if p.Position:Distance(ent.Position) <= maxp then
					maxp = p.Position:Distance(ent.Position)
					data.SWkishki.target = p
				end
			end
		end 

		local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 1, ent.Position+Vector(0,0), Vector(0,0), ent):ToEffect()
		cord.Parent = ent
		cord.DepthOffset = 1
		--cord:FollowParent(ent)
		cord:GetData().SWkishki = data.SWkishki
		data.SWMyCord = cord
		cord:FollowParent(ent)
		--cord:GetData().SWkishki["CordFrame"] = nil
		data.SWkishki.base = ent
		data.SWkishki = nil

	elseif data.SWMyCord:GetData().SWkishki then 
		local data = data.SWMyCord:GetData()
		local sprite = ent:GetSprite()
		if sprite:IsPlaying("FlyingAppear") then
			data.SWkishki.baseOffset = Vector(0,-7)
		elseif sprite:IsPlaying("FlyingIdle") then
			if sprite:GetFrame() == 0 then
				data.SWkishki.targetOffset = Vector(0,-9)
			elseif sprite:GetFrame() == 3 then
				data.SWkishki.targetOffset = Vector(0,-10)
			elseif sprite:GetFrame() == 7 then
				data.SWkishki.targetOffset = Vector(0,-9)
			elseif sprite:GetFrame() == 12 then
				data.SWkishki.targetOffset = Vector(0,-8)
			elseif sprite:GetFrame() == 15 then
				data.SWkishki.targetOffset = Vector(0,-7)
			elseif sprite:GetFrame() == 19 then
				data.SWkishki.targetOffset = Vector(0,-8)
			end
		end
		--[[if ent:IsDead() then
			local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 1, ent.Position+Vector(0,3), Vector(0,0), ent)
			cord.Parent = ent
			cord:GetData().SWkishki = data.SWkishki
			cord:GetData().SWkishki["CordFrame"] = nil
			data.SWkishki.base = cord
		end]]
	end 

end, FamiliarVariant.FORGOTTEN_BODY)

--						outdated

local function ForgottenRender(ent,offset)
   --if ent.Variant ~= 900 then return end

   local ReflectArg = 0.29   --0.29 
   local data = ent:GetData()
   local birthrightCheck = false
   if data.SWkishki and data.SWkishki.target and data.SWkishki.target:ToPlayer() then
	birthrightCheck = data.SWkishki.target:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT,false)
   end

   if data.SWkishki and data.SWkishki.target and not birthrightCheck and not data.SWkishki.ignoreFrame then
	local LastPos = data.SWkishki.target.Position 
	--or data.SWkishki.LastPos and data.SWkishki.LastPos.Position
	if not ent.Parent or not data.SWkishki["CordFrame"] then
		local angle = (data.SWkishki.target.Position-data.SWkishki.LastPos):GetAngleDegrees() 
		local vel = not Game():IsPaused() and Vector.FromAngle(angle) or Vector(0,0)
		LastPos = data.SWkishki.LastPos --+ vel*3
		for posdsos in ipairs(data.SWkishki.pos) do
		--	data.SWkishki.pos[posdsos] = data.SWkishki.pos[posdsos] + vel*2
		end
	end
	data.SWkishki.LastPos = LastPos
	
	--if not data.SWkishki.SavedSpr then data.SWkishki.SavedSpr = Sprite() end

	if not data.SWkishki.SavedSpr or data.SWkishki.SavedSpr and not data.SWkishki.SavedSpr:GetFilename() then
		data.SWkishki.SavedSpr = Sprite() 
		data.SWkishki.SavedSpr:Load("gfx/SWforgotten_chain.anm2", true) 
		if data.SWkishki.Sprite then
			data.SWkishki.SavedSpr:ReplaceSpritesheet(0, data.SWkishki["Sprite"])
			data.SWkishki.SavedSpr:LoadGraphics()
		end
	end
	local spr = data.SWkishki.SavedSpr or Sprite()

	local basePos = game:GetRoom():WorldToScreenPosition(ent.Position )
	local targetPos = LastPos
	if data.SWkishki["baseOffset"] then
	else 
		data.SWkishki["baseOffset"] = Vector(0,0)
	end
	if data.SWkishki["targetOffset"] then
	else
		data.SWkishki["targetOffset"] = Vector(0,0)
	end 
		
	local clamb = 0
	
	local Stretch = 0
	if data.SWkishki.Stretch then   
		Stretch = data.SWkishki.Stretch
	end

	local Dis = ent.Position:Distance(LastPos)
	local CountPos = 10 
	if data.SWkishki.Unit then
		CountPos = data.SWkishki.Unit
	end
	
	local Dungeon = false
	if Game():GetRoom():GetType() == RoomType.ROOM_DUNGEON then
		Dungeon = true
	end

	local frame = spr:GetFrame()

	if not data.SWkishki.pos then
		
		data.SWkishki.pos = {}
		data.SWkishki.vel = {}
		data.SWkishki.Zoff = {}
		data.SWkishki.CosinCoff = {}
		data.SWkishki.Height = {}
		for i=1, CountPos-1 do
			--data.SWkishki.pos[i] =  (ent.Position +(LastPos+Vector(0.00005,0.00005) - ent.Position)/(ent.Position:Distance(LastPos+Vector(0.0005,0.0005))/10) * i) 
			data.SWkishki.pos[i] = ent.Position - (ent.Position-LastPos)/(CountPos-i)
		end
		for i=1, CountPos do
			data.SWkishki.CosinCoff[i] = math.abs(i-1-(CountPos)/2)/((CountPos)/2)
		end
		
	end
	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and not data.SWkishki.Reflectpos then
		data.SWkishki.Reflectpos = {}
		data.SWkishki.Reflectvel = {}
		for i=1, #data.SWkishki.pos do	
			data.SWkishki.Reflectpos[i] = data.SWkishki.pos[i]
			--data.SWkishki.Reflectvel[i] = Vector(0,0)
			--data.SWkishki.Reflectpos[i] = 
		end
	end

	if not Game():IsPaused() and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT  then
	--if Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then

	    if not data.SWkishki["CordFrame"] then
		spr:Update()
		frame = spr:GetFrame()
	    end

	    for i=1, CountPos-1 do

		--if not Game():IsPaused() and i ~= CountPos and Isaac.GetFrameCount()%1 == 0 then
			
			if not data.SWkishki.vel or (data.SWkishki.vel and data.SWkishki.vel[i] == nil) then
				data.SWkishki.vel = {}
				for j=1, #data.SWkishki.pos do
					data.SWkishki.vel[j] = Vector(0,0)
				end
			end 
			local nextpos
			if data.SWkishki.pos[i+1] then
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					nextpos = data.SWkishki.Reflectpos[i+1] 
				else
					nextpos =  data.SWkishki.pos[i+1] 
				end
			end
			if i+1 == CountPos and LastPos then 
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					nextpos = LastPos - (data.SWkishki["baseOffset"]*1.54)  --*1.5384615384615384615384615384615
				else
					nextpos = LastPos + (data.SWkishki["baseOffset"]*1.54) 
				end
			end

			local prepos 
			if data.SWkishki.pos[i-1] then
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					prepos = data.SWkishki.Reflectpos[i-1]
				else
					prepos =  data.SWkishki.pos[i-1] 
				end
			end 
			if i-1 == 0 then 
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					prepos =  ent.Position - (data.SWkishki["targetOffset"]*1.54) 
				else
					prepos = ent.Position + (data.SWkishki["targetOffset"]*1.54) 
				end 
			end
		
			if prepos and nextpos then
				local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-2)  
				local BOff = data.SWkishki["baseOffset"].Y * (i)/(CountPos-2)   
				local height = (TOff + BOff) 

				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					local bttdis = prepos:Distance(nextpos)

					--local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.Reflectpos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data.SWkishki.Reflectpos[i])-Stretch)*0.08) )
					--velic = velic + Vector(1,0):Rotated( (prepos - data.SWkishki.Reflectpos[i]):GetAngleDegrees() ):Resized( math.max(0,(prepos:Distance(data.SWkishki.Reflectpos[i])-Stretch)*0.08) )
				
					--data.SWkishki.Reflectvel[i] = data.SWkishki.Reflectvel[i] + velic   --*0.8
					--data.SWkishki.Reflectpos[i] = data.SWkishki.Reflectpos[i] + data.SWkishki.Reflectvel[i]
					--data.SWkishki.Reflectvel[i] = data.SWkishki.Reflectvel[i] * 0.9
					--local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-2)  
					--local BOff = data.SWkishki["baseOffset"].Y * (i)/(CountPos-2)   
					--local height = (TOff + BOff) * 2.0
					--data.SWkishki.Reflectpos[i] = data.SWkishki.pos[i] - Vector(0,height*2)
					--print(i,height,TOff , BOff)

				else
					local bttdis = prepos:Distance(nextpos)

					local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) ) --0.07
					velic = velic + Vector(1,0):Rotated( (prepos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(prepos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) )
					velic = Dungeon and (velic + Vector(0,0.1)) or velic   --Vector(0,0.07)

					data.SWkishki.vel[i] = data.SWkishki.vel[i] + velic   --*0.8
					data.SWkishki.pos[i] = data.SWkishki.pos[i] + data.SWkishki.vel[i]
					data.SWkishki.vel[i] = data.SWkishki.vel[i] * 0.87
					data.SWkishki.Height[i] = data.SWkishki.pos[i] - Vector(0,height)

					if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE then
						data.SWkishki.Reflectpos[i] = data.SWkishki.pos[i] - Vector(0,height*2)
					end

					if not Game():IsPaused() and Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE 
					and data.SWkishki.Zoff and math.abs(velic.Y+velic.X)>0.1 then
						data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown or math.random(5,15)
						data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown - 1
						if data.SWkishki.RippleCooldown <= 0 and data.SWkishki.Zoff[i]+height/1.54 >= -2 and data.SWkishki.pos[i] and math.random(1,5) == 5 then
							data.SWkishki.RippleCooldown = math.random(10,25)
							if REPENTANCE then
								Isaac.Spawn(1000,EffectVariant.WATER_RIPPLE,0,data.SWkishki.pos[i]+Vector(0,data.SWkishki.Zoff[i]),Vector(0,0),nil).DepthOffset = -100
								
								local EfPos = data.SWkishki.pos[i]+Vector(0,data.SWkishki.Zoff[i])+ Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1)
								Isaac.Spawn(1000,EffectVariant.WATER_SPLASH,1,EfPos,Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1),nil):Update()
								
							end
						end
					end
				end
			end
		--end
	    end
	end
	
	spr.FlipY = Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT

	if not data.SWkishki["NoShadow"] and not Dungeon and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT 
	and data.SWkishki.Height and ent.FrameCount>1 then

		spr.Color = Color.Default
		spr:Play("shadow", true)
		for i=1, CountPos do
			local SbasePos = basePos
			local StargetPos = targetPos

			if i ~= 1 and data.SWkishki.Height[i-1] then
				SbasePos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Height[i-1])
				
			end	
			if i < CountPos and i ~= 1 and data.SWkishki.Height[i] then
				StargetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Height[i])
			elseif i == CountPos and LastPos then 
				StargetPos  = game:GetRoom():WorldToScreenPosition(LastPos) 
			end
			if i==1 and data.SWkishki.pos[i] then
				if data.SWkishki["targetOffset"] then
					if data.SWkishki.Height[i] then
						StargetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Height[i])
						
					end
				end
			end
			
			local clamb2 = 96 - (96/CountPos)*(i) -1
			local clamb =  (96/CountPos)*(i-1) -1
			
			if SbasePos and StargetPos and LastPos then
				--spr:Play("shadow", true)
				--spr.Color = Color.Default
				spr.Rotation = (StargetPos-SbasePos):GetAngleDegrees() 
				spr.Scale = Vector(ent:GetSprite().Scale.X,math.max(0,SbasePos:Distance(StargetPos) / (96/CountPos) )) 
				local bttdis = (SbasePos):Distance(StargetPos)
				spr.Offset = Vector( (bttdis)*(i-1) ,0):Rotated(spr.Rotation+180)
				renderPos =  SbasePos
				spr:Render(renderPos, Vector(0,clamb+1), Vector(0,clamb2+1))
			end
		end
	end

	spr:SetFrame(frame)
		
	spr:Play("cord", true)
	spr.Color = data.SWkishki.target:GetColor() 
	for i=1, CountPos do

		--[[local height
		if Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
			local Zoffset 
			local CosinCoff = data.SWkishki["NoZ"] and 1 or (data.SWkishki.CosinCoff[i] or 0) 
			local ZoffMulti = data.SWkishki["NoZ"] and 0 or (data.SWkishki.ZoffMulti or 0) 

			Zoffset = math.min(8, math.max(0,24/basePos:Distance(targetPos)/1.54-1) * (1-CosinCoff)*ZoffMulti*3)
			--data.SWkishki.Zoff[i] = (data.SWkishki.Zoff[i] or 0) * 0.9 + Zoffset * 0.1
			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-1)  
			local BOff = data.SWkishki["baseOffset"].Y * (i-1)/(CountPos-1)   
			height = (TOff + BOff) + (Zoffset or 0)

			data.SWkishki.Zoff[i] = (data.SWkishki.Zoff[i] or 0) * 0.9 + Zoffset * 0.1
			print(i,Zoffset,"aa", data.SWkishki.pos[i],targetPos)
			data.SWkishki.target:Render(targetPos)
		else
			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-1)  
			local BOff = data.SWkishki["baseOffset"].Y * (i-1)/(CountPos-1)   
			height = (TOff + BOff) 
		end]]

		if i ~= 1 and data.SWkishki.pos[i-1] then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				basePos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i-1]) --+ Vector(0,-data.SWkishki.Zoff[i-1] or 0)  
			else
				basePos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i-1]) -- Vector(0,-data.SWkishki.Zoff[i-1] or 0)
			end
		end	
		if i < CountPos and i ~= 1 and data.SWkishki.pos[i] then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i]) --+ Vector(0,-data.SWkishki.Zoff[i] or 0)
			else
				targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i]) -- Vector(0,-data.SWkishki.Zoff[i] or 0)
			end
		elseif i == CountPos and LastPos then 
			targetPos = game:GetRoom():WorldToScreenPosition(LastPos) 
			StargetPos  = game:GetRoom():WorldToScreenPosition(LastPos) 
			if data.SWkishki["baseOffset"] then
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					targetPos = targetPos - data.SWkishki["baseOffset"] --+ Vector(0,-height)
				else
					targetPos = targetPos + data.SWkishki["baseOffset"]
				end
			end
		end
		if i==1 and data.SWkishki.pos[i] then
			if data.SWkishki["targetOffset"] then
				--local LastZoffset = math.min(0,14/basePos:Distance(targetPos)-1) * (data.SWkishki["targetOffset"].Y*(CountPos-i)*0.3+data.SWkishki["baseOffset"].Y*i*0.3)
				
				--basePos = basePos - Vector(0,-height) --+ data.SWkishki["targetOffset"] 
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					basePos = basePos - data.SWkishki["targetOffset"]
					targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i])  
				else
					basePos = basePos + data.SWkishki["targetOffset"]  -- Vector(0,-height)
					targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i]) -- Vector(0,-height)
				end
			end
		end


		--Z offset
		--Zoffset = math.max(0,24/basePos:Distance(targetPos)/1.54-1) * (data.SWkishki["targetOffset"].Y*(CountPos-i)*0.1+data.SWkishki["baseOffset"].Y*i*0.1)

		local height
		if Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
			local Zoffset 
			local CosinCoff = data.SWkishki["NoZ"] and 1 or (data.SWkishki.CosinCoff[i] or 0) 
			local ZoffMulti = data.SWkishki["NoZ"] and 0 or (data.SWkishki.ZoffMulti or 0) 
			local bottomBorder = 8
			local bottomBorderMulti = 35
			
			Zoffset = Dungeon and 0 or math.min(bottomBorder, math.max(0,bottomBorderMulti/basePos:Distance(targetPos)/1.54-1) * (1-CosinCoff)*ZoffMulti*1)
			--data.SWkishki.Zoff[i] = (data.SWkishki.Zoff[i] or 0) * 0.9 + Zoffset * 0.1
			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-1)  
			local BOff = data.SWkishki["baseOffset"].Y * (i-1)/(CountPos-1)   
			height = (TOff + BOff) + (Zoffset or 0)
			
			if not Game():IsPaused() then
				data.SWkishki.Zoff[i] = (data.SWkishki.Zoff[i] or 0) * 0.7 + Zoffset * 0.3
			end

			--data.SWkishki.target:Render(targetPos)
		else
			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos-1)  
			local BOff = data.SWkishki["baseOffset"].Y * (i-1)/(CountPos-1)   
			height = (TOff + BOff) 
		end
		
		--Zoffset = math.max(-8, math.max(0,24/basePos:Distance(targetPos)/1.54-1) * -(CountPos-math.abs( (i-CountPos/2)/CountPos*14)))
		
		--data.SWkishki.Zoff[i] = data.SWkishki.Zoff[i] * 0.9 + Zoffset * 0.1
		
		if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
			--Zoffset = Zoffset * -1
		end
		if i ~= 1  then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				--targetPos = targetPos + Vector(0,-data.SWkishki.Zoff[i] or 0)
				basePos = basePos - Vector(0,data.SWkishki.Zoff[i] or 0)
			else
				basePos = basePos + Vector(0,data.SWkishki.Zoff[i] or 0) --Vector(0,Zoffset)
			end
		end
		if i < CountPos and i ~= 1 then
			--local predZoffset = data.SWkishki.Zoff[i+1] or 0
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				targetPos = targetPos - Vector(0,data.SWkishki.Zoff[i+1] or 0)
			else
				targetPos = targetPos + Vector(0,data.SWkishki.Zoff[i+1] or 0) -- Vector(0,-predZoffset)
			end
		--elseif i == CountPos then 
			--targetPos = targetPos 
			--if data.SWkishki["baseOffset"] then
			--	targetPos = targetPos  
			--end
		end
		if i==1 then
			if data.SWkishki["targetOffset"] then
				--basePos = basePos -- Vector(0,Zoffset)
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					targetPos = targetPos - Vector(0,data.SWkishki.Zoff[i+1] or 0)
				else
					targetPos = targetPos + Vector(0,data.SWkishki.Zoff[i+1] or 0) -- Vector(0,Zoffset)
				end
			end
		end

		if ent.FrameCount>-1 and basePos and targetPos and LastPos then   --and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT
			--spr:Play("cord", true)
			spr:SetFrame(frame)
			--if data.SWkishki["CordFrame"] then spr:SetFrame(data.SWkishki["CordFrame"]) end

			spr.Rotation = (targetPos-basePos):GetAngleDegrees() 
			--spr.Color = data.SWkishki.target:GetColor() 
			spr.Scale = Vector(ent:GetSprite().Scale.X,math.max(0,basePos:Distance(targetPos) / (96/CountPos) ))   
			local bttdis = game:GetRoom():WorldToScreenPosition(Vector(96,0)).X    
			--local numwtf = 1   
			local bttdis = (basePos):Distance(targetPos)
			spr.Offset = Vector( (bttdis)*(i-1) ,0):Rotated(spr.Rotation+180) 
			--spr.FlipY = Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT			

			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE then   --Почему игра не может выдавать правильный offset
				data.SWkishki.OffsetReflect = offset

				--[[if not Game():IsPaused() then
					data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown or math.random(350,450)
					data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown - 1
					--print(data.SWkishki.RippleCooldown,data.SWkishki.Zoff[i])
					if data.SWkishki.RippleCooldown <= 0 and data.SWkishki.Zoff[i] >= 7.9 and data.SWkishki.pos[i] and math.random(1,5) == 5 then
						data.SWkishki.RippleCooldown = math.random(150,350)
						Isaac.Spawn(1000,EffectVariant.WATER_RIPPLE,0,data.SWkishki.pos[i]+Vector(0,data.SWkishki.Zoff[i]),Vector(0,0),nil)
					end
				end]]
				
			elseif Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and data.SWkishki.OffsetReflect then
				--spr.FlipY = Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
				--spr.Rotation = (targetPos - basePos):GetAngleDegrees()
				--spr.Offset = spr.Offset +  Vector(0, -data.SWkishki["targetOffset"].Y*(CountPos-i)*ReflectArg-data.SWkishki["baseOffset"].Y*i*ReflectArg) - data.SWkishki.OffsetReflect + offset   --0.29
				spr.Offset = spr.Offset - data.SWkishki.OffsetReflect + offset   --0.29 data.SWkishki.OffsetReflect
			else
				
			end

			local renderPos =  basePos
			local clamb2 = 96 - (96/CountPos)*(i) -1
			local clamb =  (96/CountPos)*(i-1) -1

			spr:Render(renderPos, Vector(0,clamb), Vector(0,clamb2))
			--[[if Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
				spr:Play("shadow", true)
				spr.Color = Color.Default
				renderPos =  SbasePos
				spr:Render(renderPos, Vector(0,clamb+1), Vector(0,clamb2+1))
			end]]
		end
	end
	--if LastPos.Position.Y<=ent.Position.Y and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT  then
	if data.SWkishki.pos and data.SWkishki.targetOffset and not data.SWkishki.ignoreFrame
	and data.SWkishki.pos[1] and data.SWkishki.pos[1].Y-data.SWkishki.targetOffset.Y*1.5+5 <= ent.Position.Y 
	and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
		--[[local bpos = game:GetRoom():WorldToScreenPosition(ent.Position)
		local npcOvSpr = Sprite()
		local npcSpr = Sprite()
		npcSpr:Load(ent:GetSprite():GetFilename(), true)
		npcSpr:Play(ent:GetSprite():GetAnimation(), true)
		npcSpr:SetFrame(ent:GetSprite():GetFrame())
		npcSpr.Scale = ent:GetSprite().Scale
		npcSpr.FlipX = ent:GetSprite().FlipX
		npcSpr.Color = ent:GetColor()
		npcSpr:Render(bpos)
		if ent:GetSprite():IsOverlayPlaying() == ent:GetSprite():GetOverlayAnimation() then
			npcOvSpr:Load(ent:GetSprite():GetFilename(), true)
			npcOvSpr:Play(ent:GetSprite():GetOverlayAnimation(), true)
			npcOvSpr:SetFrame(ent:GetSprite():GetOverlayFrame())
			--npcSpr:Render(bpos)
			npcOvSpr.Scale = ent:GetSprite().Scale
			npcOvSpr:Render(bpos)
		end]]

		--data.SWkishki.ignoreFrame = true
		if ent.Parent then
			ent.Parent:Render(Vector(0,0)+offset)
		end
	--elseif data.SWkishki and data.SWkishki.ignoreFrame then
		--data.SWkishki.ignoreFrame = nil
	end
   elseif data.SWkishki and data.SWkishki.ignoreFrame then
	data.SWkishki.ignoreFrame = nil
   end
end


mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, ent,offset)
	--ForgottenRender(ent,offset)
end, FamiliarVariant.FORGOTTEN_BODY)



----------------------------------------------------------------------------------------------------------------
--============================================================================================================--
----------------------------------------------------------------------------------------------------------------

local function cordrender2(data,ent,offset)
   --local Edata = ent:GetData()
  
   if data.SWkishki and data.SWkishki.target and data.SWkishki.target:Exists() and not data.SWkishki.ignoreFrame then
	
	local LastPos = game:GetRoom():WorldToScreenPosition( data.SWkishki.target.Position )
	--local LastTarget = data.SWkishki.target  

	if not data.SWkishki.SavedSpr or data.SWkishki.SavedSpr and not data.SWkishki.SavedSpr:GetFilename() then
		data.SWkishki.SavedSpr = Sprite() 
		local anm = data.SWkishki.anm or "gfx/SWforgotten_chain.anm2"
		data.SWkishki.SavedSpr:Load(anm, true) 
		if data.SWkishki.Sprite then
			data.SWkishki.SavedSpr:ReplaceSpritesheet(0, data.SWkishki["Sprite"])
			data.SWkishki.SavedSpr:LoadGraphics()
		end
		data.SWkishki.SavedSpr:Play("cord", true)
		if not data.SWkishki["NoShadow"] then
			data.SWkishki.SavedShadowSpr = Sprite() 
			data.SWkishki.SavedShadowSpr:Load(anm, true) 
			data.SWkishki.SavedShadowSpr:Play("shadow", false)
			data.SWkishki.SavedShadowSpr.Color = Color.Default
		end
	end

	local spr = data.SWkishki.SavedSpr or Sprite():Load("gfx/SWforgotten_chain.anm2", true) 
	spr.Color = data.SWkishki.target:GetColor()
	local Shadowspr = not data.SWkishki["NoShadow"] and data.SWkishki.SavedShadowSpr or Sprite():Load("gfx/SWforgotten_chain.anm2", true) 

	local basePos = game:GetRoom():WorldToScreenPosition(ent.Position )
	local targetPos = LastPos
	
	data.SWkishki["baseOffset"] = data.SWkishki["baseOffset"] or Vector(0,0)
	data.SWkishki["targetOffset"] = data.SWkishki["targetOffset"] or Vector(0,0)
		
	local clamb = 0
	
	local Stretch = data.SWkishki.Stretch or 0

	local Dis = ent.Position:Distance(LastPos)
	local CountPos = data.SWkishki.Unit or 10 
	
	local Dungeon = false
	if Game():GetRoom():GetType() == RoomType.ROOM_DUNGEON then
		Dungeon = true
	end
	local spritelenght = data.SWkishki.length or 96

	local frame = spr:GetFrame()

	if not data.SWkishki.pos then  --Инит
		
		data.SWkishki.pos = {}
		data.SWkishki.Renderpos = {}
		data.SWkishki.vel = {}
		data.SWkishki.Zoff = {}
		data.SWkishki.CosinCoff = {}
		data.SWkishki.Height = {}
		data.SWkishki.shadowpos = {}
		for i=1, CountPos-1 do
			local TarPos = data.SWkishki.target.Position
			data.SWkishki.pos[i] = ent.Position - (ent.Position-TarPos)/(CountPos-i)
		end
		for i=1, CountPos do
			data.SWkishki.CosinCoff[i] = math.abs(i-1-(CountPos)/2)/((CountPos)/2)

			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos)  
			local BOff = data.SWkishki["baseOffset"].Y * (i)/(CountPos)   
			local height = (TOff + BOff) --*1.538
			data.SWkishki.Height[i] = height
			data.SWkishki.Zoff[i] = 0
		end
		
	end
	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and not data.SWkishki.Reflectpos then  --Инит для отражения
		data.SWkishki.Reflectpos = {}
		--data.SWkishki.Reflectvel = {}
		for i=1, #data.SWkishki.pos do	
			data.SWkishki.Reflectpos[i] = data.SWkishki.pos[i]
			--data.SWkishki.Reflectvel[i] = Vector(0,0)
		end
	end

	if data.SWkishki["targetOffset"] or data.SWkishki["baseOffset"] then
		data.SWkishki.LastOffset = data.SWkishki.LastOffset or {targetOffset = data.SWkishki["targetOffset"], baseOffset = data.SWkishki["baseOffset"] }
		if (data.SWkishki.LastOffset["targetOffset"].X ~= data.SWkishki["targetOffset"].X or data.SWkishki.LastOffset["targetOffset"].Y ~= data.SWkishki["targetOffset"].Y)
		or (data.SWkishki.LastOffset["baseOffset"].X ~= data.SWkishki["baseOffset"].X or data.SWkishki.LastOffset["baseOffset"].Y ~= data.SWkishki["baseOffset"].Y) then
			data.SWkishki.OffsetChanged = true
		end
		data.SWkishki.LastOffset["targetOffset"] = data.SWkishki["targetOffset"]
		data.SWkishki.LastOffset["baseOffset"] = data.SWkishki["baseOffset"]
	end

	if data.SWkishki.OffsetChanged then
		for i=1, CountPos do
			data.SWkishki.CosinCoff[i] = math.abs(i-1-(CountPos)/2)/((CountPos)/2)
			--local PrA, PrB = (CountPos-i)/(CountPos), (i-1)/(CountPos) 
			local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos)  
			local BOff = data.SWkishki["baseOffset"].Y * (i)/(CountPos)   
			local height = (TOff + BOff) --*1.538
			data.SWkishki.Height[i] = height
			--print(i,PrA, PrB,PrA+ PrB)
		end

		data.SWkishki.OffsetChanged = nil
	end
	
	if not Game():IsPaused() and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT  then  --физика
	   
	    if not data.SWkishki["CordFrame"] and Isaac.GetFrameCount()%2 == 0 then
		spr:Update()
		frame = spr:GetFrame()
	    elseif data.SWkishki["CordFrame"] then
		spr:SetFrame(data.SWkishki["CordFrame"])
	    end
	    for i=1, CountPos-1 do

		--if not Game():IsPaused() and i ~= CountPos and Isaac.GetFrameCount()%2 == 0 then
			
			if not data.SWkishki.vel or (data.SWkishki.vel and data.SWkishki.vel[i] == nil) then
				data.SWkishki.vel = {}
				for j=1, #data.SWkishki.pos do
					data.SWkishki.vel[j] = Vector(0,0)
				end
			end 

			local nextpos
			if data.SWkishki.pos[i+1] then
				--if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					--nextpos = data.SWkishki.Reflectpos[i+1] 
				--else
					nextpos =  data.SWkishki.pos[i+1] 
				--end
			end
			if i+1 == CountPos and LastPos then 
				--if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					--nextpos = data.SWkishki.target.Position  --LastPos -- (data.SWkishki["baseOffset"]*1.54)  --*1.5384615384615384615384615384615
				--else
					nextpos = data.SWkishki.target.Position + data.SWkishki["baseOffset"]*1.54 -- Vector(0,data.SWkishki.Height[i]*1.54)   --LastPos --+ (data.SWkishki["baseOffset"]*1.54) 
				--end
			end

			local prepos 
			if data.SWkishki.pos[i-1] then
				--if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					--prepos = data.SWkishki.Reflectpos[i-1]
				--else
					prepos =  data.SWkishki.pos[i-1] 
				--end
			end 
			if i-1 == 0 then 
				--if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					--prepos =  ent.Position --- (data.SWkishki["targetOffset"]*1.54) 
				--else
					prepos = ent.Position + (data.SWkishki["targetOffset"]*1.54) -- Vector(0,data.SWkishki.Height[i]*1.54)
				--end 
			end
		
			if prepos and nextpos then
				--local TOff = data.SWkishki["targetOffset"].Y * (CountPos-i)/(CountPos)  
				--local BOff = data.SWkishki["baseOffset"].Y * (i)/(CountPos)     
				local height = data.SWkishki.Height[i] or 0    --(TOff + BOff) *1.538
				--14  11,332  8,666  6
				--14  10.5  9.5  5

				local bttdis = prepos:Distance(nextpos)

				local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(nextpos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) ) --0.07
				velic = velic + Vector(1,0):Rotated( (prepos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(0,(prepos:Distance(data.SWkishki.pos[i])-Stretch)*0.10) )
				velic = Dungeon and (velic + Vector(0,0.1)) or velic   --Vector(0,0.07)

				data.SWkishki.vel[i] = data.SWkishki.vel[i] + velic   --*0.8
				data.SWkishki.pos[i] = data.SWkishki.pos[i] + data.SWkishki.vel[i]
				data.SWkishki.vel[i] = data.SWkishki.vel[i] * 0.87

				local ScreenPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i])
				
				data.SWkishki.Renderpos[i] = ScreenPos --+ Vector(0,height)
				data.SWkishki.shadowpos[i] = ScreenPos - Vector(0,height)

				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE then
					data.SWkishki.Reflectpos[i] = ScreenPos - Vector(0,height*2)   --data.SWkishki.pos[i] - Vector(0,height*2)
				end

				if not Game():IsPaused() and Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE 
				and data.SWkishki.Zoff and data.SWkishki.Zoff[i] and math.abs(velic.Y+velic.X)>0.1 then
					data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown or math.random(5,15)
					data.SWkishki.RippleCooldown = data.SWkishki.RippleCooldown - 1
					
					if data.SWkishki.RippleCooldown and data.SWkishki.RippleCooldown <= 0 and data.SWkishki.Zoff[i]+height/1.54 >= -2 
					and data.SWkishki.pos[i] and math.random(1,5) == 5 then
						data.SWkishki.RippleCooldown = math.random(5,12)
						if REPENTANCE then
							Isaac.Spawn(1000,EffectVariant.WATER_RIPPLE,0,data.SWkishki.pos[i]+Vector(0,data.SWkishki.Zoff[i]),Vector(0,0),nil).DepthOffset = -100
							
							local EfPos = data.SWkishki.pos[i]+Vector(0,data.SWkishki.Zoff[i])+ Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1)
							Isaac.Spawn(1000,EffectVariant.WATER_SPLASH,1,EfPos,Vector(math.random(-10,10)*0.1,math.random(-10,10)*0.1),nil):Update()
							
						end
					end
				end
				
			end
		--end
	    end
	end
	
	spr.FlipY = Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT 

	if ent.FrameCount>1 and not data.SWkishki["NoShadow"] and not Dungeon and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT 
	and data.SWkishki.shadowpos then
		
		--Shadowspr:Play("shadow", false)
		--Shadowspr.Color = Color.Default
		for i=1, CountPos do   --Рендер тени
			local SbasePos = basePos
			local StargetPos = targetPos

			--Опредение начальной точки(SbasePos) и конечной точки(StargetPos)
			if i ~= 1 and data.SWkishki.shadowpos[i-1] then
				SbasePos = data.SWkishki.shadowpos[i-1]  --game:GetRoom():WorldToScreenPosition(data.SWkishki.shadowpos[i-1])
				
			end	
			if i < CountPos and i ~= 1 and data.SWkishki.shadowpos[i] then
				StargetPos = data.SWkishki.shadowpos[i] --game:GetRoom():WorldToScreenPosition(data.SWkishki.shadowpos[i])
			elseif i == CountPos and LastPos then 
				StargetPos  = LastPos --game:GetRoom():WorldToScreenPosition(LastPos) 
				if data.SWkishki["baseOffset"] then
					StargetPos = StargetPos + Vector(data.SWkishki["baseOffset"].X,0)
				end
			end
			if i==1 and data.SWkishki.pos[i] then
				if data.SWkishki["targetOffset"] then
					SbasePos = SbasePos + Vector(data.SWkishki["targetOffset"].X,0)  
				end
				StargetPos = data.SWkishki.shadowpos[i] --game:GetRoom():WorldToScreenPosition(data.SWkishki.shadowpos[i])
			end

			local clamb2 = spritelenght - (spritelenght/CountPos)*(i) +(96-spritelenght) 
			local clamb = (spritelenght/CountPos)*(i-1) 
			
			--Рендер
			if SbasePos and StargetPos and LastPos then

				Shadowspr.Rotation = (StargetPos-SbasePos):GetAngleDegrees() 
				Shadowspr.Scale = Vector(ent:GetSprite().Scale.X,math.max(0,SbasePos:Distance(StargetPos) / (spritelenght/CountPos) )) 
				local bttdis = (SbasePos):Distance(StargetPos)
				Shadowspr.Offset = Vector( (bttdis)*(i-1) ,0):Rotated(Shadowspr.Rotation+180)
				renderPos =  SbasePos
				Shadowspr:Render(renderPos, Vector(0,clamb), Vector(0,clamb2))
			end
		end
		
	end

	if basePos and targetPos and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT 
	or (Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and not data.SWkishki["NoReflect"] and data.SWkishki.OffsetReflect) then
		
	    for i=1, CountPos do  --Рендер
		--Опредение начальной точки(basePos) и конечной точки(targetPos)
		if i ~= 1 and data.SWkishki.Renderpos[i-1] then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				basePos = data.SWkishki.Reflectpos[i-1] --game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i-1])   
			else
				basePos = data.SWkishki.Renderpos[i-1] --game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i-1])
			end
		end	
		if i < CountPos and i ~= 1 and data.SWkishki.Renderpos[i] then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				targetPos = data.SWkishki.Reflectpos[i]  --game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i]) 
			else
				targetPos = data.SWkishki.Renderpos[i]  --game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i])
			end
		elseif i == CountPos and LastPos then 
			targetPos = LastPos  --game:GetRoom():WorldToScreenPosition(LastPos) 
			 
			if data.SWkishki["baseOffset"] then
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					targetPos = targetPos + Vector(data.SWkishki["baseOffset"].X,-data.SWkishki["baseOffset"].Y) --data.SWkishki["baseOffset"] 
				else
					targetPos = targetPos + data.SWkishki["baseOffset"]
				end
			end
		end
		if i==1 and data.SWkishki.Renderpos[i] then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				if data.SWkishki["targetOffset"] then
					basePos = basePos + Vector(data.SWkishki["targetOffset"].X,-data.SWkishki["targetOffset"].Y)
				end
				targetPos = data.SWkishki.Reflectpos[i] --game:GetRoom():WorldToScreenPosition(data.SWkishki.Reflectpos[i])  
			else
				if data.SWkishki["targetOffset"] then
					basePos = basePos + data.SWkishki["targetOffset"]  
				end
				targetPos = data.SWkishki.Renderpos[i]  --game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i])
			end
		end

		local height
		if not data.SWkishki["NoZ"] and basePos and targetPos 
		and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then  --Смещение по высоте
			local Zoffset 
			local CosinCoff = data.SWkishki["NoZ"] and 1 or (data.SWkishki.CosinCoff[i] or 0) 
			local ZoffMulti = data.SWkishki["NoZ"] and 0 or (data.SWkishki.ZoffMulti or 0) 
			local bottomBorder = 8
			local bottomBorderMulti = 35
			
			Zoffset = Dungeon and 0 or data.SWkishki["NoZ"] and 0 or math.min(bottomBorder, math.max(0,bottomBorderMulti/basePos:Distance(targetPos)/1.54-1) * (1-CosinCoff)*ZoffMulti*1)
			  
			height = (Zoffset or 0) or 0  --data.SWkishki.Height[i]
			
			if not Game():IsPaused() then
				data.SWkishki.Zoff[i] = (data.SWkishki.Zoff[i] or 0) * 0.7 + Zoffset * 0.3
			end
		else
			--height = data.SWkishki.Height[i] --(TOff + BOff) 
		end

		if i ~= 1  then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				basePos = basePos - Vector(0,data.SWkishki.Zoff[i] or 0)
			else
				basePos = basePos + Vector(0,data.SWkishki.Zoff[i] or 0)
			end
		end
		if i < CountPos and i ~= 1 then
			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
				targetPos = targetPos - Vector(0,data.SWkishki.Zoff[i+1] or 0)
			else
				targetPos = targetPos + Vector(0,data.SWkishki.Zoff[i+1] or 0)
			end
		end
		if i==1 then
			if data.SWkishki["targetOffset"] then
				if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
					targetPos = targetPos - Vector(0,data.SWkishki.Zoff[i+1] or 0)
				else
					targetPos = targetPos + Vector(0,data.SWkishki.Zoff[i+1] or 0) 
				end
			end
		end

		 --Рендер
		if ent.FrameCount>1 and basePos and targetPos and LastPos then   
			
			spr.Rotation = (targetPos-basePos):GetAngleDegrees() 
			spr.Scale = Vector(ent:GetSprite().Scale.X,math.max(0,basePos:Distance(targetPos) / (spritelenght/CountPos) ))    
			local bttdis = (basePos):Distance(targetPos)
			spr.Offset = Vector( (bttdis)*(i-1) ,0):Rotated(spr.Rotation+180) 			

			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE then   --Почему игра не может выдавать правильный offset
				data.SWkishki.OffsetReflect = offset  
			elseif Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and data.SWkishki.OffsetReflect then
				spr.Offset = spr.Offset - data.SWkishki.OffsetReflect + offset  
			end

			local renderPos =  basePos
			local clamb2 = spritelenght - (spritelenght/CountPos)*(i) +(96-spritelenght) -1
			local clamb =  (spritelenght/CountPos)*(i-1) -1

			spr:Render(renderPos, Vector(0,clamb), Vector(0,clamb2))
		end
	   end
	end
	
	if data.SWkishki.pos and data.SWkishki.targetOffset and not data.SWkishki.ignoreFrame
	and data.SWkishki.pos[1] and data.SWkishki.pos[1].Y-data.SWkishki.targetOffset.Y*1.5 <= ent.Position.Y 
	and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
		data.SWkishki.ignoreFrame = true
		ent:Render(Vector(0,0)+offset)
	end
   elseif data.SWkishki and data.SWkishki.ignoreFrame then
	data.SWkishki.ignoreFrame = nil
   end
end

----------------------------------------------------------------------------------------------------------------
--============================================================================================================--
----------------------------------------------------------------------------------------------------------------
--							unused

local function cordrender(data,ent,offset)
 if data.SWkishki and data.SWkishki.target and data.SWkishki.target:Exists()  then
	local spritelenght = data.SWkishki.length or 96
	data.SWkishki.ReflectTarget = data.SWkishki.ReflectTarget or 0.29
	data.SWkishki.ReflectBase = data.SWkishki.ReflectBase or 0.29
	data.SWkishki.ReflectRotation = data.SWkishki.ReflectRotation or 0.1
		
	local LastTarget = data.SWkishki.target  
	local spr = Sprite()
	
	spr:Load("gfx/SWforgotten_chain.anm2", true)   
	if data.SWkishki.Sprite then                                  
		spr:ReplaceSpritesheet(0, data.SWkishki["Sprite"])
		spr:LoadGraphics()
		--spr:Load(data.SWkishki["Sprite"], true)
	end

	local basePos = game:GetRoom():WorldToScreenPosition(ent.Position )
	local targetPos = LastTarget.Position
	if data.SWkishki["baseOffset"] then
	else 
		data.SWkishki["baseOffset"] = Vector(0,0)
	end
	if data.SWkishki["targetOffset"] then
	else
		data.SWkishki["targetOffset"] = Vector(0,0)
	end 
		
	local clamb = 0
	
	local Stretch = 0
	if data.SWkishki.Stretch then   
		Stretch = data.SWkishki.Stretch
	end

	local Dis = ent.Position:Distance(LastTarget.Position)
	local CountPos = 10 
	if data.SWkishki.Unit then
		CountPos = data.SWkishki.Unit
	end
	
	if not data.SWkishki.pos then
		
		data.SWkishki.pos = {}
		data.SWkishki.vel = {}
		data.SWkishki.Zoff = {}
		for i=1, CountPos-1 do
			data.SWkishki.pos[i] =  (ent.Position +(LastTarget.Position+Vector(0.00005,0.00005) - ent.Position)/(ent.Position:Distance(LastTarget.Position+Vector(0.0005,0.0005))/10) * i) 
		end
	end
	for i=1, CountPos do    --физика
		local PbasePos = basePos
		local PtargetPos = targetPos
		
		if i ~= 1 then
			PbasePos = data.SWkishki.pos[i-1] 
		end	
		if i < CountPos and i ~= 1  then
			PtargetPos = data.SWkishki.pos[i] 
		elseif i == CountPos then 
			PtargetPos = LastTarget.Position
			if data.SWkishki["baseOffset"] then
				PtargetPos = PtargetPos + data.SWkishki["baseOffset"]
			end
		end
		if i==1 then
			if data.SWkishki["targetOffset"] then
				PbasePos = basePos + data.SWkishki["targetOffset"]
				PtargetPos = data.SWkishki.pos[i] 
			end
		end
 
		if not Game():IsPaused() and i ~= CountPos and Isaac.GetFrameCount()%1 == 0 then   
			
			if not data.SWkishki.vel or (data.SWkishki.vel and data.SWkishki.vel[i] == nil) then
				data.SWkishki.vel = {}
				for j=1, #data.SWkishki.pos do
					data.SWkishki.vel[j] = Vector(0,0)
				end
			end 
			local nextpos
			if data.SWkishki.pos[i+1] then
				nextpos =  data.SWkishki.pos[i+1] 
			end
			if i+1 == CountPos and LastTarget then nextpos = LastTarget.Position + (data.SWkishki["baseOffset"] and data.SWkishki["baseOffset"]*1.5384615384615384615384615384615)  end
			local prepos 
			if data.SWkishki.pos[i-1] then
				prepos =  data.SWkishki.pos[i-1]
			end 
			if i-1 == 0 then prepos =  ent.Position + (data.SWkishki["targetOffset"]*1.5384615384615384615384615384615)  end
			if prepos and nextpos then
				local bttdis = prepos:Distance(nextpos)
			
				local velic = Vector(1,0):Rotated( (nextpos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(-10,(nextpos:Distance(data.SWkishki.pos[i])-Stretch)*0.1) )
				velic = velic + Vector(1,0):Rotated( (prepos - data.SWkishki.pos[i]):GetAngleDegrees() ):Resized( math.max(-10,(prepos:Distance(data.SWkishki.pos[i])-Stretch)*0.1) )
				data.SWkishki.vel[i] = data.SWkishki.vel[i] + velic*0.8
				data.SWkishki.pos[i] = data.SWkishki.pos[i] + data.SWkishki.vel[i]
				data.SWkishki.vel[i] = data.SWkishki.vel[i] * 0.9
			end
		end
	end
	for i=1, CountPos do    --рендер
		local Zoffset = 0
		--Zoffset = math.max(0,14/basePos:Distance(targetPos)) * (data.SWkishki["targetOffset"].Y*(CountPos-i)*0.1+data.SWkishki["baseOffset"].Y*i*0.1)

		if i ~= 1 and data.SWkishki.pos[i-1] then
			basePos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i-1]) 
		end	
		if i < CountPos and i ~= 1 and data.SWkishki.pos[i] then
			targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i]) 
		elseif i == CountPos and LastTarget then 
			targetPos = game:GetRoom():WorldToScreenPosition(LastTarget.Position)   
			if data.SWkishki["baseOffset"] then
				targetPos = targetPos + data.SWkishki["baseOffset"]
			end
		end
		if i==1 and data.SWkishki.pos[i] then
			if data.SWkishki["targetOffset"] then
				basePos = basePos + data.SWkishki["targetOffset"] 
				targetPos = game:GetRoom():WorldToScreenPosition(data.SWkishki.pos[i]) 
			end
		end

		--Z offset
		if not data.SWkishki["NoZ"] then
			Zoffset = math.max(-8, math.max(0,14/basePos:Distance(targetPos)/1.54-1) * -((CountPos-i)+i))
			data.SWkishki.Zoff[i] = Zoffset
		end
		
		if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
			Zoffset = Zoffset * -1
		end
		if i ~= 1  then
			basePos = basePos - Vector(0,Zoffset)
		end
		if i < CountPos and i ~= 1 then
			local predZoffset = data.SWkishki.Zoff[i+1] or Zoffset
			targetPos = targetPos  - Vector(0,predZoffset)
			--targetPos = targetPos  - Vector(0,Zoffset)
		elseif i == CountPos then 
			targetPos = targetPos 
			if data.SWkishki["baseOffset"] then
				targetPos = targetPos 
			end
		end
		if i==1 then
			if data.SWkishki["targetOffset"] then
				--basePos = basePos - Vector(0,Zoffset)
				targetPos = targetPos  - Vector(0,Zoffset)
			end
		end
		
		if basePos and targetPos and LastTarget and not data.SWkishki.ignoreFrame  then   
			spr:Play("cord", true)
			if data.SWkishki["CordFrame"] then spr:SetFrame(data.SWkishki["CordFrame"]) end
			--spr.Rotation = (targetPos - basePos):GetAngleDegrees() 
			local ZOffbasePos = Game():GetRoom():GetRenderMode() == 5 and basePos + Vector(0,Zoffset*2) or basePos
			spr.Rotation = (targetPos - basePos):GetAngleDegrees() 
			spr.Color = ent:GetColor()
			spr.Scale = Vector(ent:GetSprite().Scale.X,math.max(0,basePos:Distance(targetPos) / (spritelenght/CountPos) )) 

			local bttdis = (basePos*CountPos):Distance(targetPos*CountPos)
			spr.Offset = Vector( (bttdis/CountPos)*(i-1) ,0):Rotated(spr.Rotation+180) 

			if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_ABOVE then   --Почему игра не может выдавать правильный offset
				data.SWkishki.OffsetReflect = offset
			elseif Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT and data.SWkishki.OffsetReflect then
				spr.FlipY = Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
				--spr.Offset = spr.Offset + Vector(0, -data.SWkishki["targetOffset"].Y*(CountPos-i)*data.SWkishki.ReflectTarget-data.SWkishki["baseOffset"].Y*i*data.SWkishki.ReflectBase) - data.SWkishki.OffsetReflect + offset
				spr.Offset = (spr.Offset - data.SWkishki.OffsetReflect + offset) 

				local TRD = (data.SWkishki["targetOffset"].Y*(CountPos-i)*data.SWkishki.ReflectTarget)
				local BRD = data.SWkishki["baseOffset"].Y*i*data.SWkishki.ReflectBase
				local RTFG = Vector(0, -data.SWkishki["targetOffset"].Y*(CountPos-i)-data.SWkishki["baseOffset"].Y*i)
				--spr.Rotation = ( (targetPos+Vector(0,TRD*data.SWkishki.ReflectRotation)) - (basePos+Vector(0,BRD*data.SWkishki.ReflectRotation))):GetAngleDegrees() 
				spr.Rotation = (targetPos - basePos ):GetAngleDegrees() 
				--print(i,CountPos,targetPos - basePos,RTFG,data.SWkishki["targetOffset"])
			end
		
			local renderPos =  basePos
			local clamb = spritelenght - (spritelenght/CountPos)*(i) +(96-spritelenght) -1
			local clamb2 =  (spritelenght/CountPos)*(i-1) -1
			--print(spritelenght,spritelenght - (spritelenght/CountPos)*(i),96 - (96/CountPos)*(i),(96/CountPos) )
			spr:Render(renderPos, Vector(0,clamb2), Vector(0,clamb))
		end
	end

	if data.SWkishki and data.SWkishki.pos and data.SWkishki.targetOffset and not data.SWkishki.ignoreFrame
	and data.SWkishki.pos[1] and data.SWkishki.pos[1].Y-data.SWkishki.targetOffset.Y*1.5 <= ent.Position.Y 
	and Game():GetRoom():GetRenderMode() ~= RenderMode.RENDER_WATER_REFLECT then
		--[[local bpos = game:GetRoom():WorldToScreenPosition(ent.Position)
		local npcOvSpr = Sprite()
		local npcSpr = Sprite()
		npcSpr:Load(ent:GetSprite():GetFilename(), true)
		npcSpr:Play(ent:GetSprite():GetAnimation(), true)
		npcSpr:SetFrame(ent:GetSprite():GetFrame())
		npcSpr.Scale = ent:GetSprite().Scale
		npcSpr.FlipX = ent:GetSprite().FlipX
		npcSpr.Color = ent:GetColor()
		npcSpr:Render(bpos)
		if ent:GetSprite():IsOverlayPlaying() == ent:GetSprite():GetOverlayAnimation() then
			npcOvSpr:Load(ent:GetSprite():GetFilename(), true)
			npcOvSpr:Play(ent:GetSprite():GetOverlayAnimation(), true)
			npcOvSpr:SetFrame(ent:GetSprite():GetOverlayFrame())
			npcSpr:Render(bpos)
			npcOvSpr.Scale = ent:GetSprite().Scale
			npcOvSpr:Render(bpos)
		end]]
		data.SWkishki.ignoreFrame = true
		ent:Render(Vector(0,0))
	elseif data.SWkishki and data.SWkishki.ignoreFrame then
		data.SWkishki.ignoreFrame = nil
	end
  end
end

-----------------------CORD HELPER------------------------

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_,ent,offset)
	if not ent.Parent or (ent.Parent and not ent.Parent:Exists()) then
		if ent.SubType == 1 then
			local data = ent:GetData()

			if data.SWkishki and data.SWkishki["CordFrame"]  then
				data.SWkishki["CordFrame"] = nil
				data.SWkishki["NoShadow"] = true
				data.SWkishki.SavedSpr:SetFrame(1)
				ent.Parent = data.SWkishki.target
				ent:FollowParent(ent.Parent)
			end
			--[[if data.SWkishki and data.SWkishki.SavedSpr and data.SWkishki.SavedSpr:IsPlaying("cord") 
			and (data.SWkishki.SavedSpr:GetFrame() == 21 or data.SWkishki.SavedSpr:GetFrame() == -1) then
				ent:Remove()
			else]]
				ForgottenRender(ent,offset)
			--end
		else
			ent:Remove()
		end
	else
		local data = ent:GetData().SWkishki and ent:GetData() or ent.Parent:GetData()
		if ent.SubType == 1 and ent.FrameCount > -1 then
			if data.SWkishki and (not data.SWkishki.base or data.SWkishki.base and not data.SWkishki.base:Exists()) then
				--local data = ent:GetData()

				--if data.SWkishki and data.SWkishki["CordFrame"]  then
				--	data.SWkishki["CordFrame"] = nil
				--	data.SWkishki["NoShadow"] = true
				--	data.SWkishki.SavedSpr:SetFrame(1)
				--	ent.Parent = data.SWkishki.target
				--	ent:FollowParent(ent.Parent)
				--end
				if data.SWkishki and data.SWkishki.SavedSpr and data.SWkishki.SavedSpr:IsPlaying("cord") 
				and (data.SWkishki.SavedSpr:GetFrame() == 21 or data.SWkishki.SavedSpr:GetFrame() == -1) then
					ent:Remove()
				else
					--ForgottenRender(ent,offset)
				end
			end

			ForgottenRender(ent,offset)
		elseif ent.SubType == 0 then
			cordrender2(data,ent,offset)
		end
	end
end, mod_CORD_HELPER)

--[[mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, ent,offset)
	local data = ent:GetData()
	if not data.SWkishki  then 
   		data.SWkishki = {["Sprite"] = GEMINI_SPRITE, ["baseOffset"] = Vector(0,-11), ["targetOffset"] = Vector(0,-14), ["Stretch"] = 6, ["CordFrame"] = 0,["Unit"] = 4, ["length"] = 80}
		data.SWkishki.target = ent.Player
	end
	--cordrender(data,ent)
end, FamiliarVariant.GEMINI)]]

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 20 then return end
	ent.PositionOffset = Vector(0,2000)
end, EntityType.ENTITY_GEMINI)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()

	if not data.SWkishki and ent.Parent and ent.Parent.SubType ~= 1 then 
   		data.SWkishki = {["Sprite"] = GEMINI_SPRITE, ["baseOffset"] = Vector(0,-8), ["targetOffset"] = Vector(0,-14), 
			["Stretch"] = 1,["ZoffMulti"] = 1, ["CordFrame"] = 0,["Unit"] = 9, ["length"] = 80} --6

		data.SWkishki.target = ent.Parent
		if ent.Parent.SubType == 2 then
			data.SWkishki.Sprite = GEMINI_BLUE_SPRITE
		end 
	elseif data.SWkishki then 
		data.SWkishki.targetOffset = sprite.FlipX and Vector(2,-14) or Vector(-2,-14)
		if sprite:IsPlaying("Attack01") then
			if sprite:GetFrame() == 14 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(4,-14) or Vector(-4,-14)
			elseif sprite:GetFrame() == 15 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(10,-20) or Vector(-10,-20)
			elseif sprite:GetFrame() == 16 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(6,-20) or Vector(-6,-20)
			elseif sprite:GetFrame() == 17 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(8,-16) or Vector(-8,-16)
			elseif sprite:GetFrame() >= 18 and sprite:GetFrame() < 31 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(5,-16) or Vector(-5,-16)
			elseif sprite:GetFrame() >= 31 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(3,-15) or Vector(-3,-15)
			end
		end
		if ent.Parent and ent.Parent:GetSprite() then
			local Psprite = ent.Parent:GetSprite()
			data.SWkishki.baseOffset = Psprite.FlipX and Vector(-2,-6) or Vector(2,-6)
			if Psprite:IsPlaying("Pant") and Psprite:GetFrame() >= 10 and Psprite:IsPlaying("Pant") and Psprite:GetFrame() < 15 then
				data.SWkishki.baseOffset = Psprite.FlipX and Vector(-3,-5) or Vector(3,-5)
			elseif Psprite:IsPlaying("Pant") and Psprite:GetFrame() >= 15 then
				data.SWkishki.baseOffset = Psprite.FlipX and Vector(-4,-5) or Vector(4,-5)
			end
		end
	end
end, EntityType.ENTITY_GEMINI)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent,offset)
	if ent.Variant ~= 10 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()

	--[[if not data.SWkishki and ent.Parent and ent.Parent.SubType ~= 1 then 
   		data.SWkishki = {["Sprite"] = "gfx/effects/gemini_cord.png", ["baseOffset"] = Vector(0,-8), ["targetOffset"] = Vector(0,-14), 
			["Stretch"] = 6, ["CordFrame"] = 0,["Unit"] = 5, ["length"] = 80}
		data.SWkishki.target = ent.Parent
		if ent.Parent.SubType == 2 then
			data.SWkishki.Sprite = "gfx/effects/gemini_cord_blue.png"
		end 
	elseif data.SWkishki then 
		data.SWkishki.targetOffset = sprite.FlipX and Vector(2,-14) or Vector(-2,-14)
		if sprite:IsPlaying("Attack01") then
			if sprite:GetFrame() == 14 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(4,-14) or Vector(-4,-14)
			elseif sprite:GetFrame() == 15 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(10,-20) or Vector(-10,-20)
			elseif sprite:GetFrame() == 16 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(6,-20) or Vector(-6,-20)
			elseif sprite:GetFrame() == 17 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(8,-16) or Vector(-8,-16)
			elseif sprite:GetFrame() >= 18 then
				data.SWkishki.targetOffset = sprite.FlipX and Vector(5,-16) or Vector(-5,-16)
			end
		end
		if ent.Parent and ent.Parent:GetSprite() then
			local Psprite = ent.Parent:GetSprite()
			data.SWkishki.baseOffset = Psprite.FlipX and Vector(-2,-6) or Vector(2,-6)
			if Psprite:IsPlaying("Pant") and Psprite:GetFrame() >= 10 and Psprite:IsPlaying("Pant") and Psprite:GetFrame() < 15 then
				data.SWkishki.baseOffset = Psprite.FlipX and Vector(-3,-5) or Vector(3,-5)
			elseif Psprite:IsPlaying("Pant") and Psprite:GetFrame() >= 15 then
				data.SWkishki.baseOffset = Psprite.FlipX and Vector(-4,-5) or Vector(4,-5)
			end
		end
	end]]
	cordrender2(data,ent,offset)
end, EntityType.ENTITY_GEMINI)

----------------------MR MAW---------------------------

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	ent.PositionOffset = Vector(0,2000)
end, EntityType.ENTITY_MRMAW)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent,offset)
	if ent.Variant ~= 1 and ent.Variant ~= 3 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()
	
	if not data.SWkishki and ent.Child and ent.Position:Distance(ent.Child.Position) >= 8 then 
   		data.SWkishki = {["Sprite"] = MRMAW_SPRITE, ["baseOffset"] = Vector(0,-8), ["targetOffset"] = Vector(0,-8), 
			["Stretch"] = 0, ["CordFrame"] = 0,["Unit"] = 3, ["length"] = 64, ["NoZ"] = true}
		if DeepLab then data.SWkishki.anm = "gfx/SW_LAB_mrmaw_cord.anm2" data.SWkishki["CordFrame"] = nil end
		data.SWkishki.target = ent.Child
	elseif data.SWkishki and ent.Child and ent.Position:Distance(ent.Child.Position) < 8  then
		data.SWkishki = nil
	end

	cordrender2(data,ent,offset)
end, EntityType.ENTITY_MRMAW)

-----------------------HOMUNCULUS----------------------

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	ent.PositionOffset = Vector(0,2000)
end, EntityType.ENTITY_HOMUNCULUS)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 0 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()
	if not data.SWkishki  then 
   		data.SWkishki = {["Sprite"] = HOMUNCULUS_SPRITE, ["baseOffset"] = Vector(0,-6), ["targetOffset"] = Vector(0,-4), 
			["Stretch"] = 0, ["CordFrame"] = 0,["Unit"] = 4, ["length"] = 80, ["NoZ"] = true}
		local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 0, ent.TargetPosition, Vector(0,0), ent)
		cord.Parent = ent
		data.SWkishki.target = ent
		data.SWkishki.base = cord
	elseif data.SWkishki.base and ent.State > 4 and data.SWkishki.base:Exists() then 
		data.SWkishki.base:Remove()
	end
end, EntityType.ENTITY_HOMUNCULUS)

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent,offset)
	if ent.Variant ~= 0 then return end
	local data = ent:GetData()
	data.SWkishki.RenderOffset = offset
	--cordrender(data,ent,offset)
end, EntityType.ENTITY_HOMUNCULUS)]]

---------------------BEGOTTEN------------------

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	ent.PositionOffset = Vector(0,2000)
end, EntityType.ENTITY_BEGOTTEN)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 0 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()
	if not data.SWkishki  then 
   		data.SWkishki = {["Sprite"] = BEGOTTEN_SPRITE, ["baseOffset"] = Vector(0,-6), ["targetOffset"] = Vector(0,-4), 
			["Stretch"] = 0, ["CordFrame"] = 0,["Unit"] = 4, ["length"] = 64, ["NoZ"] = true, ["NoShadow"] = true}
		if DeepLab then data.SWkishki.anm = "gfx/SW_LAB_begootten_cord.anm2" data.SWkishki["CordFrame"] = nil end
		local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 0, ent.TargetPosition, Vector(0,0), ent)
		cord.Parent = ent
		data.SWkishki.target = ent
		data.SWkishki.base = cord
	elseif data.SWkishki.base and ent.State > 4 and data.SWkishki.base:Exists() then 
		data.SWkishki.base:Remove()
	end
end, EntityType.ENTITY_BEGOTTEN)

-------------------SWINGER-------------------

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	ent.PositionOffset = Vector(3000,3000)
end, EntityType.ENTITY_SWINGER)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, ent,offset)
	if ent.Variant ~= 1 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()

	if not data.SWkishki and ent.Parent then   
   		data.SWkishki = {["Sprite"] = SWINGER_SPRITE, ["baseOffset"] = Vector(0,-7), ["targetOffset"] = Vector(0,-13), 
			["Stretch"] = 6, ["CordFrame"] = 0,["Unit"] = 8, ["length"] = 64, ["NoZ"] = true,["NoShadow"] = true}
		data.SWkishki.target = ent.Parent
	end
	cordrender2(data,ent,offset)
end, EntityType.ENTITY_SWINGER)

---------------------MR MINE-------------------

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 10 then return end
	ent.PositionOffset = Vector(0,2000)
end, EntityType.ENTITY_MR_MINE)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, ent)
	if ent.Variant ~= 0 then return end
	local data = ent:GetData()
	local sprite = ent:GetSprite()
	
	if not data.SWkishki and ent.FrameCount > 3 and ent.TargetPosition.X>0 then 
   		data.SWkishki = {["Sprite"] = MRMINE_SPRITE, ["baseOffset"] = Vector(0,-6), ["targetOffset"] = Vector(0,1), ["Stretch"] = 0, ["CordFrame"] = 0,["Unit"] = 4, ["length"] = 64, ["NoZ"] = true}
		
		local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 0, ent.TargetPosition, Vector(0,0), ent)
		cord.Parent = ent
		data.SWkishki.target = ent
		data.SWkishki.base = cord
	elseif data.SWkishki and sprite:IsPlaying("Idle") and sprite:GetFrame() == 0 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(-1,-6)
	elseif data.SWkishki and sprite:IsPlaying("Idle") and sprite:GetFrame() == 1 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-6)
	elseif data.SWkishki and sprite:IsPlaying("Idle") and sprite:GetFrame() == 2 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(1,-6)
	elseif data.SWkishki and sprite:IsPlaying("Idle") and sprite:GetFrame() == 3 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-6)
	elseif data.SWkishki and sprite:IsPlaying("DigIn") and sprite:GetFrame() == 4 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-10)
	elseif data.SWkishki and sprite:IsPlaying("DigIn") and sprite:GetFrame() == 6 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-12)
	elseif data.SWkishki and sprite:IsPlaying("DigIn") and sprite:GetFrame() == 8 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-6)
	elseif data.SWkishki and sprite:IsPlaying("DigOut") and sprite:GetFrame() == 3 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-14)
	elseif data.SWkishki and sprite:IsPlaying("DigOut") and sprite:GetFrame() == 5 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-18)
	elseif data.SWkishki and sprite:IsPlaying("DigOut") and sprite:GetFrame() == 8 and data.SWkishki.base:Exists() then 
		data.SWkishki.baseOffset = Vector(0,-6)
	elseif data.SWkishki and sprite:IsPlaying("DigIn") and sprite:GetFrame() == 10 and data.SWkishki.base:Exists() and ent.FrameCount >= 45 then 
		data.SWkishki.base:Remove()
		data.SWkishki.pos = nil
		data.SWkishki.vel = nil
		data.SWkishki.Reflectpos = nil
	elseif data.SWkishki and sprite:IsPlaying("DigOut") and sprite:GetFrame() == 2 and not data.SWkishki.base:Exists() then 
		local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 0, ent.TargetPosition, Vector(0,0), ent)
		cord.Parent = ent
		data.SWkishki.target = ent
		data.SWkishki.base = cord
	end
end, EntityType.ENTITY_MR_MINE)


---------------------SPIRIT SHACKLES-------------------

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, ent)
if ent.FrameCount < 1 then
	local d = ent:GetData()
	local s = ent:GetSprite()

	if ent.SpawnerEntity and ent.SpawnerEntity:ToPlayer() then
	--and (s:GetFilename() == "gfx/001.000_Player.anm2" or s:GetAnimation() == "Death") then
		local player = ent.SpawnerEntity:ToPlayer()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES,false) and not d.SWkishki then
			d.SWkishki = {["Sprite"] = FORGOTTEN_SPRITE, ["baseOffset"] = Vector(0,-7), ["targetOffset"] = Vector(9,-10), 
				["Stretch"] = 12, ["CordFrame"] = 0,["ZoffMulti"] = 6,["Unit"] = 6,["NoZ"]=nil}

			local cord = Isaac.Spawn(1000, mod_CORD_HELPER, 0, ent.Position+Vector(0,3), Vector(0,0), ent)
			cord.Parent = ent
			d.SWkishki.target = player
			d.SWkishki.base = cord
		end
	end
end
end, EffectVariant.DEVIL)
