local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Items Renamed"

-- {itemId, 'name', 'desc'}
local items = {
    --$$$ITEMS-START$$$
    {276, "Veyeral Heart", "Void Rains Upon It"}, {561, "Almond Water", "Backroom Beverage"}, {581, "Grey Matter", "Cerebral Discharge"}, {775, "Blue Milk", "HP + DMG Up, Perfect Freeze"}, {745, "Cool Shades", "Gold Rush"}, {809, "SPAM!", "Hunger Down"}, {904, "Fighter's Trophy", "It's The Winner!"}, {861, "Spherical Dice", "-0.1"}, {919, "Packed Lunch", "HP Up + Energy Up!"}, {844, "Hellhound Kibble", "DMG Up + It's all burnt"} 
  
  }
  
  local trinkets = {
    --$$$TRINKETS-START$$$
    {98, "Booger", "Nose Picker"}, {225, "Overcharged Battery", "Potentially Dangerous"}, {211, "Replica Gun", "Keep away from children"}
  
  }
  
  local game = Game()
  if EID then
    -- Adds trinkets defined in trinkets
      for _, trinket in ipairs(trinkets) do
          local EIDdescription = EID:getDescriptionObj(5, 350, trinket[1]).Description
          EID:addTrinket(trinket[1], EIDdescription, trinket[2], "en_us")
      end
  
    -- Adds items defined in items
    for _, item in ipairs(items) do
          local EIDdescription = EID:getDescriptionObj(5, 100, item[1]).Description
          EID:addCollectible(item[1], EIDdescription, item[2], "en_us")
      end
  end
  
  if Encyclopedia then
    -- Adds trinkets defined in trinkets
      for _,trinket in ipairs(trinkets) do
          Encyclopedia.UpdateTrinket(trinket[1], {
              Name = trinket[2],
              Description = trinket[3],
          })
      end
  
    -- Adds items defined in items
    for _, item in ipairs(items) do
          Encyclopedia.UpdateItem(item[1], {
              Name = item[2],
              Description = item[3],
          })
      end
  end
  
  -- Handle displaying trinket names
  
  if #trinkets ~= 0 then
      local t_queueLastFrame
      local t_queueNow
      mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
          t_queueNow = player.QueuedItem.Item
          if (t_queueNow ~= nil) then
              for _, trinket in ipairs(trinkets) do
                  if (t_queueNow.ID == trinket[1] and t_queueNow:IsTrinket() and t_queueLastFrame == nil) then
                      game:GetHUD():ShowItemText(trinket[2], trinket[3])
                  end
              end
          end
          t_queueLastFrame = t_queueNow
      end)
  end
  
  -- Handle displaying item names
  
  if #items ~= 0 then
      local i_queueLastFrame
      local i_queueNow
      mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
          i_queueNow = player.QueuedItem.Item
          if (i_queueNow ~= nil) then
              for _, item in ipairs(items) do
                  if (i_queueNow.ID == item[1] and i_queueNow:IsCollectible() and i_queueLastFrame == nil) then
                      game:GetHUD():ShowItemText(item[2], item[3])
                  end
              end
          end
          i_queueLastFrame = i_queueNow
      end)
  end
  
  