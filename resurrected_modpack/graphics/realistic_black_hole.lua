local TR_Manager = require("resurrected_modpack.manager")
RealisticBH = TR_Manager:RegisterMod("Realistic Black Hole", 1)

local mod = RealisticBH
local game = Game()
local json = require("json")


------------------------------------------------------------
--SCHEDULER-------------------------------------------------
------------------------------------------------------------

--Some callbacks can't execute certain functions at the time they are execute, so we delay them

function mod:runUpdates(delayedFuncs) --This is from Fiend Folio
    for i = #delayedFuncs, 1, -1 do
        local f = delayedFuncs[i]
        f.Delay = f.Delay - 1
        if f.Delay <= 0 then
            f.Func()
            table.remove(delayedFuncs, i)
        end
    end
end
mod.delayedFuncs = {}
function mod:scheduleForUpdate(foo, delay, callback)
    callback = callback or ModCallbacks.MC_POST_UPDATE
    if not mod.delayedFuncs[callback] then
        mod.delayedFuncs[callback] = {}
        mod:AddCallback(callback, function()
            mod:runUpdates(mod.delayedFuncs[callback])
        end)
    end

    table.insert(mod.delayedFuncs[callback], { Func = foo, Delay = delay })
end

------------------------------------------------------------
--SAVE DATA-------------------------------------------------
------------------------------------------------------------

mod.savedata = {}

if mod:HasData() then
    mod.savedata = json.decode(mod:LoadData())
end

if mod.savedata.blackHoleEnabled == nil then mod.savedata.blackHoleEnabled = true end
if mod.savedata.voidEnabled == nil then mod.savedata.voidEnabled = false end

function mod:SaveModdedModData()
    mod:SaveData(json.encode(mod.savedata))
end

------------------------------------------------------------
--SHADERS---------------------------------------------------
------------------------------------------------------------

--The shader stuff is to render a black circle over the distortion

mod.ShaderData = {

	--Black hole
	blackHole = false,
	blackHolePosition = Vector.Zero,
	blackHolePositionShader = Vector.Zero,
	blackHoleTime = 0,
    blackHoleSize = 1,

}

function mod:ShadersRender(shaderName)
	if shaderName == "Black_Hole" then --Only the black circle!!!!! the distortion is just a shockwave
		if mod.ShaderData.blackHole then
			local room = game:GetRoom()
			local position = room:WorldToScreenPosition(mod.ShaderData.blackHolePositionShader + Vector(0,-3))
			local radius = room:WorldToScreenPosition(mod.ShaderData.blackHolePositionShader + Vector(20,-3))
			local time = mod.ShaderData.blackHoleTime
                
            --if game:IsPaused() then
            --    time = 0
            --end
            
			local params = {
				Enabled = 1,
				BlackPosition = {position.X,  position.Y, radius.X},
				Time = time,
				WarpCheck = {position.X + 1, position.Y + 1},
				}
			return params
		else
			local params = {
				Enabled = 0,
				BlackPosition = {0,  0,  0},
				Time = 0,
				WarpCheck = {0, 0},
				}
			return params
		end
	end
end

TR_Manager:RegisterShaderFunction(mod, "Black_Hole", mod.ShadersRender)

------------------------------------------------------------
--BLACK HOLE DISTORTION-------------------------------------
------------------------------------------------------------

--Unfortunately, only one black hole can exist at a time

--The actual distortion effect
function mod:BlackHoleUpdate()
    if mod.ShaderData.blackHole then
        if game:GetFrameCount() % 2 == 0 then
            game:MakeShockwave(mod.ShaderData.blackHolePosition, -0.1, 0.0025, 60)
        end
        mod.ShaderData.blackHoleTime = math.min(mod.ShaderData.blackHoleSize, mod.ShaderData.blackHoleTime + 10/100*mod.ShaderData.blackHoleSize)
    end
end

function mod:EnableBlackHole(position, size)
    size = size or 1

    mod.ShaderData.blackHolePosition = position
    mod.ShaderData.blackHolePositionShader = position
    mod.ShaderData.blackHoleTime = 0
    mod.ShaderData.blackHole = true
    mod.ShaderData.blackHoleSize = size

    local room = game:GetRoom()
    if room:IsMirrorWorld() then
        local ogY = mod.ShaderData.blackHolePositionShader.Y
        local center = room:GetCenterPos()
        local direction = mod.ShaderData.blackHolePositionShader - center
        mod.ShaderData.blackHolePositionShader = center - direction
        mod.ShaderData.blackHolePositionShader.Y = ogY
    end

    mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.BlackHoleUpdate)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.BlackHoleUpdate)

end
function mod:DisableBlackHole(position)
    
    if (not position) or position:Distance(mod.ShaderData.blackHolePosition) < 0.01 then
        mod.ShaderData.blackHole = false
        mod:RemoveCallback(ModCallbacks.MC_POST_UPDATE, mod.BlackHoleUpdate)
    end

end

--on new room
function mod:OnNewRoom()
    mod:DisableBlackHole()
    
    if not mod.savedata.voidEnabled then return end

    mod:VoidGateway()
    
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

--on room reward
function mod:OnRoomReward()
    if not mod.savedata.voidEnabled then return end

    mod:scheduleForUpdate(mod.VoidGateway, 1)
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnRoomReward)

------------------------------------------------------------
--BLACK HOLE ITEM-------------------------------------------
------------------------------------------------------------

function mod:BlackholeUpdate(blackhole)
    if not mod.savedata.blackHoleEnabled then return end

    local data = blackhole:GetData()
    local sprite = blackhole:GetSprite()

    --Initialization
    if not data.Init_BH and sprite:IsPlaying("Init") then
        data.Init_BH = true

        mod:EnableBlackHole(blackhole.Position)
        --print("Item black hole enabled", blackhole.Position)
    end

    --Finish
    if not data.Stop_BH and sprite:IsPlaying("Death") then
        data.Stop_BH = true

        mod:DisableBlackHole(blackhole.Position)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BlackholeUpdate, EffectVariant.BLACK_HOLE)

------------------------------------------------------------
--VOID GATEWAY----------------------------------------------
------------------------------------------------------------

function mod:VoidGateway()
    local room = game:GetRoom()

    local gridSize = room:GetGridSize()

    for index = 0, gridSize do
        local grid = room:GetGridEntity(index)

        if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR and grid:GetSprite():GetFilename() == "gfx/grid/VoidTrapdoor.anm2" then --is a trapdoor
            mod:EnableBlackHole(grid.Position + Vector(0,3), 0.5)
            --print("Void black hole enabled", grid.Position)
            break
        end
    end
end

------------------------------------------------------------
--CONFIGURATION---------------------------------------------
------------------------------------------------------------

function mod:ConsoleInput(command, args)

	if command == "RBH" then
		if args == "Item" then
            mod.savedata.blackHoleEnabled = not mod.savedata.blackHoleEnabled
            if mod.savedata.blackHoleEnabled then
                print("Black Hole item distortion is now ON")
            else
                print("Black Hole item distortion is now OFF")
            end
            mod:SaveModdedModData()
        elseif args == "Void" then
            mod.savedata.voidEnabled = not mod.savedata.voidEnabled
            if mod.savedata.voidEnabled then
                print("Void gateway distortion is now ON")
            else
                print("Void gateway distortion is now OFF")
            end
            mod:SaveModdedModData()
        end
	end

end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.ConsoleInput)