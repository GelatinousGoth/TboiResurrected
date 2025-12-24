local cba = CutBossesAttacks

local json = require("json")

function cba.GetAngle(vector) --Special func for getting direction angle (Vector with y = 0 and x > 0 is 0 degrees)
	local angleBetween = math.deg(math.acos(vector.X / (math.sqrt(vector.X ^ 2 + vector.Y ^ 2))))
	if vector.Y < 0 then
        angleBetween = 360 - angleBetween
    end
	return angleBetween
end

cba.EntData = {} --entities' data table

function cba.GetData(ent) --func for getting entities' data
	local entHash = GetPtrHash(ent)
	local data = cba.EntData[entHash]
	if not data then
		local newData = {}
		cba.EntData[entHash] = newData
		data = newData
	end
	return data
end

cba:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CallbackPriority.LATE, function(_, ent)
	cba.EntData[GetPtrHash(ent)] = nil
end)