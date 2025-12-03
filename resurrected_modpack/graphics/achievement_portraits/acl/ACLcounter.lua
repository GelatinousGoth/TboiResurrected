local ACLcounter = {}

--local CountingNum = require("ACLcounter")
--..CountingNum:GetCounter(DATA:GetEventCounter(EventCounter.MOM_KILLS), 10)
local uniquekills = 0

function ACLcounter:GetCounter(Event, Limit)

	local Str
	
	if Event > Limit then
	
		Str = " ~ (" .. Limit .. "/" .. Limit .. ")"
	
	else
	
		Str = " ~ (" .. Event .. "/" .. Limit .. ")"
	
	end
	
	return Str

end

function ACLcounter:UniqueBlueBabyKills(Limit)

	local DATA = Isaac.GetPersistentGameData()
	
	local BB_kills = {
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_ISAAC),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_MAGDALENE),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_CAIN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JUDAS),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_BLUE_BABY),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_EVE),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_SAMSON),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_AZAZEL),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_LAZARUS),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_EDEN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_THE_LOST),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_LILITH),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_KEEPER),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_APOLLYON),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_THE_FORGOTTEN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_BETHANY),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_JACOB_AND_ESAU),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_ISAAC),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_MAGDALENE),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_CAIN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_JUDAS),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_BLUE_BABY),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_EVE),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_SAMSON),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_AZAZEL),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_LAZARUS),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_EDEN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_THE_LOST),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_LILITH),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_KEEPER),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_APOLLYON),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_THE_FORGOTTEN),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_BETHANY),
		DATA:GetEventCounter(EventCounter.PROGRESSION_KILL_BLUE_BABY_WITH_T_JACOB_AND_ESAU)
	}
	
	local uniquekills = 0
	
	
	Isaac.DebugString(uniquekills)
	
	for k, v in pairs(BB_kills) do
		if v ~= 0 then
			uniquekills = uniquekills + 1
		end
	end
	Isaac.DebugString(uniquekills)
	local Str = ""
	
	if uniquekills > Limit then
	
		Str = " ~ (" .. Limit .. "/" .. Limit .. ")"
	
	else
	
		Str = " ~ (" .. uniquekills .. "/" .. Limit .. ")"
	
	end
	
	return Str

end

return ACLcounter