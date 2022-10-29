--       _               __    _  _  __ ___  ____  _  _   
--      | |              \ \ _| || |/_ |__ \|___ \| || |  
--      | | __ _ _   _  (_) |_  __  _| |  ) | __) | || |_ 
--  _   | |/ _` | | | |   | |_| || |_| | / / |__ <|__   _|
-- | |__| | (_| | |_| |  _| |_  __  _| |/ /_ ___) |  | |  
--  \____/ \__,_|\__, | ( ) | |_||_| |_|____|____/   |_|  
--                __/ | |/_/                              
--               |___/   

-- The script doesn't look optimised, look at the code and optimise it if needed.

--QBCore

local QBCore = exports['qb-core']:GetCoreObject()

local ill = false

QBCore.Functions.CreateUseableItem("anti", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	Player.Functions.RemoveItem('anti', 1)
	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['anti'], "remove")
	TriggerClientEvent('sickness:frisk', source)
end)