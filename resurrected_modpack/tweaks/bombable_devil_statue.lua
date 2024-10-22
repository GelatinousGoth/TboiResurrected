local TR_Manager = require("resurrected_modpack.manager")

local mod = TR_Manager:RegisterMod("Bombable Devil Statue", 1)

local game = Game() 
local level = game:GetLevel() 
local music = MusicManager()
local StatueDestroyed = false
local BossDeath = false    
    
    
    
    
--RANDOM CHANCE
function random(x) 
    if math.random(0,100) < x then 
    return true else return false
    end 
end

    
   
    
--EVERY NEW STAGE RESET 
function mod:NewLevel()
    StatueDestroyed = false
    BossDeath = false   
end




--EVERY NEW ROOM
function mod:NewRoom()

	local room = level:GetCurrentRoom()
	
	--IF THIS IS THE DEVIL ROOM AND THE STATUE HAS BEEN DESTORYED REMOVE IT AGAIN
    if room:GetType() == RoomType.ROOM_DEVIL and StatueDestroyed == true  then
        		
    	local entities = Isaac.GetRoomEntities()
		
    	for i = 1, #entities do
			if entities[i].Type == 1000 and entities[i].Variant == 6 then
			
				room:RemoveGridEntity(52,0,false)
				entities[i]:Remove()
			end
		end

    end

end



--EVERY GAME UPDATE
function mod:PostUpdate()
    
	local room = level:GetCurrentRoom()
	
	--IF THE ROOM IS A DEVIL ROOM START ALL THE CHECKS
	if room:GetType() == RoomType.ROOM_DEVIL  then
	
		local entities = Isaac.GetRoomEntities()	
		local player = Isaac.GetPlayer( 0 )	

		--LOOP ALL THE ENTITIES
		for i = 1, #entities do
	    
	  
			  --IF ONE OF THE FALLEN ANGEL BORN FROM THE STATUE DIE
			   if entities[i]:HasMortalDamage() and (entities[i].Type == EntityType.ENTITY_URIEL or entities[i].Type == EntityType.ENTITY_GABRIEL) and entities[i].Variant == 1 and BossDeath == false and StatueDestroyed == true then
			   
				   --PLAY VICTORY MUSIC
				   music:Play(Music.MUSIC_JINGLE_BOSS_OVER  ,0.2)
				   music:Queue(Music.MUSIC_BOSS_OVER) 
				   
				   --SPAWN REWARDS
				   local roomCenter = room:GetCenterPos()
				   local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0,room:FindFreePickupSpawnPosition(roomCenter,0,true), Vector(0,0), nil):ToPickup()
				     pickup.AutoUpdatePrice = false
					 pickup.Price = PickupPrice.PRICE_SPIKES
					 
				   BossDeath = true
				   
			   end
   
   
   
				--IF A BOMB DESTORY THE DEVIL STATUE
				if entities[i].Type == 1000 and entities[i].Variant == 1 and entities[i].FrameCount == 1 then
					for j = 1, #entities do
						
						if entities[j].Type == 1000 and entities[j].Variant == 6 and entities[j].Position:Distance(entities[i].Position, entities[j].Position) < 80 and StatueDestroyed == false  then

							StatueDestroyed = true

							--CLOSE THE DOORS
							local enter_door = room:GetDoor(level.EnterDoor) 
						
							if enter_door ~= nil and enter_door:IsOpen() then
								enter_door:Bar()
							end

							
							--REMOVE DEVIL STATUE AND COLLISION
							room:RemoveGridEntity(52,0,false)
							entities[j]:Remove()
							
							
							--REMOVE DEVIL DEAL ITEMS
							for y = 1, #entities do
								if entities[y].Type == 5 then
									if entities[y]:ToPickup():IsShopItem() == true then
										entities[y]:Remove()   
									end
								end
							end
								
								
							--SPAWN ON OF THE FALLEN ANGEL
							local pos = entities[j].Position
							
							if random(50) then
								Isaac.Spawn(EntityType.ENTITY_URIEL , 1, 0,pos,Vector(0,0),player)
							else
								Isaac.Spawn(EntityType.ENTITY_GABRIEL , 1, 0,pos,Vector(0,0),player)
							end
						
							room:SetClear(false)											

					 
							--CHANGE THE MUSIC
							music:Play(Music.MUSIC_SATAN_BOSS ,0.2)
	
						end
					end
				end


		end --for entities loop end

	end --if devil room end
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL , mod.NewLevel)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdate)