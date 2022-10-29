local QBCore = exports['qb-core']:GetCoreObject()

-- QBCore.Functions.CreateUseableItem("adshot", function(source)
--     local source = source
-- end)

RegisterCommand("adshot", function(source, args)
    local source = source
    TriggerClientEvent('adshot:client:Start', source)
end)

