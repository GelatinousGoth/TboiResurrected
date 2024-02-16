local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Hanging Dream Catcher"

local trapdoors = {}

local function isHoleRoom(roomDescriptor)
	local configRoom = roomDescriptor.Data
	return configRoom.Type == RoomType.ROOM_BOSS and configRoom.StageID == 0 and configRoom.Variant == 6000
end

local function isValidTrapdoor(Trapdoor)
	local variant = Trapdoor:GetVariant()
	if variant == TSIL.Enums.TrapdoorVariant.VOID_PORTAL then
		return false
	end
	local level = Game():GetLevel()
	local roomDescriptor = level:GetCurrentRoomDesc()
	if isHoleRoom(roomDescriptor) then
		return false
	end
	return true
end

local function AddHangingDreamCatcher(Trapdoor)
	if not isValidTrapdoor(Trapdoor) then
		return
	end
	local previousHangingCatcher = trapdoors[Trapdoor:GetGridIndex()]
	if previousHangingCatcher then
		previousHangingCatcher:Remove()
	end
	trapdoors[Trapdoor:GetGridIndex()] = Isaac.Spawn(1000, 245, 0, Trapdoor.Position, Vector(0,0), nil)
end

function mod:onTrapdoorInit(Trapdoor)
	if not mod.Functions.AnyPlayerHasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
		return
	end
	AddHangingDreamCatcher(Trapdoor)
end

function mod:RemoveTrapdoors()
	trapdoors = {}
end

local function ActualAddedDreamCatcher(CollectibleId)
	if CollectibleId ~= CollectibleType.COLLECTIBLE_DREAM_CATCHER then
		return
	end
	for _, trapdoor in ipairs(TSIL.GridSpecific.GetTrapdoors()) do
		AddHangingDreamCatcher(trapdoor)
	end
end

if REPENTOGON then
	function mod:onAddedDreamCatcher(CollectibleId)
		ActualAddedDreamCatcher(CollectibleId)
	end
else
	function mod:onAddedDreamCatcher(_, CollectibleId)
		ActualAddedDreamCatcher(CollectibleId)
	end
end

function mod:onRemovedDreamCatcher(_, CollectibleId)
	if CollectibleId ~= CollectibleType.COLLECTIBLE_DREAM_CATCHER then
		return
	end
	if mod.Functions.AnyPlayerHasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
		return
	end
	for _, hangingDreamCatcher in ipairs(trapdoors) do
		hangingDreamCatcher:Remove()
	end
end

mod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_INIT, mod.onTrapdoorInit, GridEntityType.GRID_TRAPDOOR)

mod:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_EARLY, mod.RemoveTrapdoors)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.onAddedDreamCatcher)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.onRemovedDreamCatcher)