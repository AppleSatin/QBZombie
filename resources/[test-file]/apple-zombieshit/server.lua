local QBCore = exports['qb-core']:GetCoreObject()
-- 

QBCore.Functions.CreateUseableItem("anti", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    -- TriggerClientEvent("apple:client:antido", source)
    Player.Functions.RemoveItem('anti', 1)
    TriggerClientEvent("apple:removedill", source)
   --  RemoveIll()
    print("here")
    
end)