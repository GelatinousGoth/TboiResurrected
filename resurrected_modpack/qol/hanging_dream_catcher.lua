local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Hanging Dream Catcher", 1)

local DREAM_CATCHER_VARIANT = Isaac.GetEntityVariantByName("Hanging Dream Catcher")

local trapdoors = {}

---@class TrapdoorTable
---@field GridEntity GridEntity
---@field DreamCatcher Entity

---@param roomDescriptor RoomDescriptor
---@return boolean
local function isHoleRoom(roomDescriptor)
	local configRoom = roomDescriptor.Data
	return configRoom.Type == RoomType.ROOM_BOSS and configRoom.StageID == 0 and configRoom.Variant == 6000
end

---@param Trapdoor GridEntity
---@return boolean
local function isValidTrapdoor(Trapdoor)
	local variant = Trapdoor:GetVariant()
	if variant == 1 then
		return false
	end
	local level = Game():GetLevel()
	local roomDescriptor = level:GetCurrentRoomDesc()
	if isHoleRoom(roomDescriptor) then
		return false
	end
	return true
end

---@param trapdoorTable TrapdoorTable
local function TryRemoveDreamCatcher(trapdoorTable)
	if not trapdoorTable.DreamCatcher then
		return
	end

	trapdoorTable.DreamCatcher:Remove()
	trapdoorTable.DreamCatcher = nil;
end

---@param trapdoorTable TrapdoorTable
local function TryAddDreamCatcher(trapdoorTable)
	if not PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
		return
	end

	TryRemoveDreamCatcher(trapdoorTable)
	trapdoorTable.DreamCatcher = Isaac.Spawn(1000, DREAM_CATCHER_VARIANT, 0, trapdoorTable.GridEntity.Position, Vector(0,0), nil)
end

---@param Trapdoor GridEntity
local function AddTrapdoor(Trapdoor)
	if not isValidTrapdoor(Trapdoor) then
		return
	end

	trapdoors[Trapdoor:GetGridIndex()] = {GridEntity = Trapdoor}
	TryAddDreamCatcher(trapdoors[Trapdoor:GetGridIndex()])
end

---@param Trapdoor GridEntity
function mod:onTrapdoorSpawn(Trapdoor)
	AddTrapdoor(Trapdoor)
end

function mod:RemoveTrapdoors()
	trapdoors = {}
end

---@param CollectibleId CollectibleType | integer
function mod:onCollectibleAdd(CollectibleId)
	if CollectibleId ~= CollectibleType.COLLECTIBLE_DREAM_CATCHER then
		return
	end

	for _, trapdoorTable in pairs(trapdoors) do
		TryAddDreamCatcher(trapdoorTable)
	end
end

---@param _ EntityPlayer
---@param CollectibleId CollectibleType | integer
function mod:onRemovedDreamCatcher(_, CollectibleId)
	if CollectibleId ~= CollectibleType.COLLECTIBLE_DREAM_CATCHER then
		return
	end
	if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DREAM_CATCHER) then
		return
	end
	for _, trapdoorTable in pairs(trapdoors) do
		TryRemoveDreamCatcher(trapdoorTable)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, mod.onTrapdoorSpawn, GridEntityType.GRID_TRAPDOOR)

mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, mod.RemoveTrapdoors)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.onCollectibleAdd)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.onRemovedDreamCatcher)