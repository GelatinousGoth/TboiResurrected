local TR_Manager = require("resurrected_modpack.manager")
local BOTDreminder = TR_Manager:RegisterMod("Book of The Dead Reminder", 1)

local track_deaths = false

BOTDreminder:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    local entities = Game():GetRoom():GetEntities()
    
    for i=1,#entities do
        local e = entities:Get(i)
        if e.Type == EntityType.ENTITY_EFFECT and e.Variant == 4245 then
            e:Remove()
        end
    end
end, CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD)

function BOTDreminder:createSouls(entity)
    if (
        (not entity:IsEnemy()) or 
        (entity:HasEntityFlags(EntityFlag.FLAG_CHARM)) or
        (entity.Type < 10) or
        (entity:ToNPC() == null)
        ) then
        
        return
    end
    Game():SpawnParticles(
        entity.Position,
        4245,
        1,
        0
    )
    Game():SpawnParticles(
        entity.Position,
        196,
        1,
        0
    )
end

BOTDreminder:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    BOTDreminder:RemoveCallback(ModCallbacks.MC_POST_ENTITY_KILL, BOTDreminder.createSouls)
end)
BOTDreminder:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    BOTDreminder:RemoveCallback(ModCallbacks.MC_POST_ENTITY_KILL, BOTDreminder.createSouls)
end)

BOTDreminder:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local plrcount = Game():GetNumPlayers()

    local istrack = false
    for i=1,plrcount do
        local plr = Game():GetPlayer(i)
        if plr:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD) then
            istrack = true
        end
    end

    if istrack then
        if not track_deaths then
            BOTDreminder:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BOTDreminder.createSouls)
        end
        track_deaths = true
    else
        BOTDreminder:RemoveCallback(ModCallbacks.MC_POST_ENTITY_KILL, BOTDreminder.createSouls)
        track_deaths = false;
    end
    -- Random() % 1 == 0
    -- local room = 
    if (Random() % 10 == 0 and Game():GetRoom():GetType() == RoomType.ROOM_ERROR) then
        Game():SpawnParticles(
            Game():GetRoom():GetCenterPos(),
            4245,
            1,
            0,
            Color.Default,
            100000,
            1
        )
    end
end)