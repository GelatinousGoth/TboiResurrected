local TR_Manager = require("resurrected_modpack.manager")
ExtraScaredHearts = TR_Manager:RegisterMod("Extra-Scared Hearts", 1)

--Modules
require("esh_mcm");

--Settings
ExtraScaredHearts.Settings = {
    ["ignoreSpiderAnms"] = false,       --remove any scared hearts with spider legs
};


--MAIN FUNCTIONS--

local numberOfAnms = 23;     --number of .anm2 files to choose from. .anm2 files should be named esh_1, esh_2, etc.

--Changes the scared heart's sprite
function ExtraScaredHearts:ChangeAnm(pickup)
    if pickup.SubType == HeartSubType.HEART_SCARED then
        local sprite = pickup:GetSprite();
        local animationToPlay = sprite:GetAnimation();
        sprite:Load(ExtraScaredHearts:GetAnmFilepath(), true);
        --play the animation that the scared heart was already playing
        sprite:Play(animationToPlay);
    end
end

--/MAIN FUNCTIONS--

--HELPER FUNCTIONS--

local rng = RNG();
local availableAnms = {};

--Returns if the player is in the Void or not
function ExtraScaredHearts:InVoid()
    return Game():GetLevel():GetAbsoluteStage() == LevelStage.STAGE7;
end

--Creates a randomly ordered array of .anm2 filepaths
function ExtraScaredHearts:SetupAvailableAnms()
    --reset and populate the table
    local anmsToPopulate = numberOfAnms;
    if ExtraScaredHearts.Settings["ignoreSpiderAnms"] then        --option to remove any hearts with spider legs, which are the final two .anm2s
        anmsToPopulate = anmsToPopulate - 2;
    end
    availableAnms = {};
    for index = 1, anmsToPopulate do
	    table.insert(availableAnms, "extrascaredhearts/esh_" .. index .. ".anm2");
    end
    --shuffle the table
    for i = #availableAnms, 2, -1 do
        local j = math.random(i);
        availableAnms[i], availableAnms[j] = availableAnms[j], availableAnms[i];
    end
end

--Returns a random .anm2 filepath that hasn't been used yet, or the Delirium .anm2 if in the Void
function ExtraScaredHearts:GetAnmFilepath()
    if ExtraScaredHearts:InVoid() then
        return "extrascaredhearts/esh_21.anm2";
    else
        if #availableAnms == 0 then
            ExtraScaredHearts:SetupAvailableAnms();
        end
        return table.remove(availableAnms);
    end
end

--/HELPER FUNCTIONS--

----SAVE DATA----

local json = require("json");
local SaveState = {};

--Saves the mod's data into a .dat file
function ExtraScaredHearts:SaveModData(_, shouldSave)
	--default values
	SaveState["availableAnms"] = availableAnms;
    SaveState["Settings"] = ExtraScaredHearts.Settings;
    --SaveState["ignoreSpiderAnms"] = ExtraScaredHearts.Settings["ignoreSpiderAnms"];
	--save the data
	ExtraScaredHearts:SaveData(json.encode(SaveState));
end

--Loads the mod's data from the .dat file
function ExtraScaredHearts:LoadModData()
	--only run this when there are no players initialized, so at the start of a run
	local totalPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER);
	if totalPlayers == 0 then
		--load the saved data into SaveState variable
		if ExtraScaredHearts:HasData() then
			SaveState = json.decode(ExtraScaredHearts:LoadData());
			--update the local variables to match the saved variables
			availableAnms = SaveState["availableAnms"] or availableAnms;
            ExtraScaredHearts.Settings = SaveState.Settings or ExtraScaredHearts.Settings;
		end
	end
end

----/SAVE DATA----

----CALLBACKS----

--Call the sprite function whenever a heart spawns (function will check if it is scared or not)
ExtraScaredHearts:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ExtraScaredHearts.ChangeAnm, PickupVariant.PICKUP_HEART)
--Save the mod's data before exiting the game
ExtraScaredHearts:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, ExtraScaredHearts.SaveModData);
--Load the mod's data when starting the game (function only runs if there are 0 players initialized)
ExtraScaredHearts:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, ExtraScaredHearts.LoadModData);

----/CALLBACKS----
