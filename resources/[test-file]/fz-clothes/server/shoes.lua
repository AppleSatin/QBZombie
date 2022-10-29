local QBCore = exports['qb-core']:GetCoreObject()
local skin
local data = {}

RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
    if result[1] ~= nil then
        skin = json.decode(result[1].skin)
    end
    local ped = GetPlayerPed(src)
    local model = GetEntityModel(ped)
    for k, v in pairs(Config["Shoes"]) do
        if (skin["shoes"].item == v[model].drawableId) then
            data[src] = {
                shoes = v[model].drawableId,
                item = k
            }
        end
    end
end)

for k, v in pairs(Config["Shoes"]) do
    QBCore.Functions.CreateUseableItem(k, function(source, item)   
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local ped = GetPlayerPed(src)
        local model = GetEntityModel(ped)
        if Player.Functions.RemoveItem(k, 1) then -- change this
            if model ~= nil then
                if not v[model] then TriggerClientEvent("QBCore:Notify", src, "You cannot use this") return end
                local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
                if result[1] ~= nil then
                    skin = json.decode(result[1].skin)
                end
                skin["shoes"].item = v[model].drawableId
                skin["shoes"].texture = v[model].textureId
                if data[src] then
                    local modalcheck = {
                        [`mp_m_freemode_01`] = 34,
                        [`mp_m_freemode_01`] = 35,
                    }
                    if data[src].shoes ~= modalcheck[model] then
                        print(data[src].item)
                        Player.Functions.AddItem(data[src].item, 1)
                    end
                end
                data[src] = {
                    shoes = v[model].drawableId,
                    item = k
                }
                SetPedComponentVariation(ped, 6, skin["shoes"].item, skin["shoes"].texture, 2)
                TriggerClientEvent("playAnim", src, "mp_shoess@standard_car@ds@", "put_on_shoes", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
                skin = json.encode(skin)
                -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
                MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
                    MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                        Player.PlayerData.citizenid,
                        model,
                        skin,
                        1
                    })
                end)
            end
        end
    end)
end

RegisterCommand("shoesoff", function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local model = GetEntityModel(ped)
    if model ~= nil then
        local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
        if result[1] ~= nil then
            skin = json.decode(result[1].skin)
        end
        if data[src].item == nil then return end
        if skin["shoes"].item == data[src].shoes then
            SetPedComponentVariation(ped, 6, 34, 0, 2)
            Player.Functions.AddItem(data[src].item, 1)
        end
        skin["shoes"].item = 34
        skin["shoes"].texture = 0
        data[src] = {
            shoes = 34,
            item = nil
        }
        TriggerClientEvent("playAnim", src, "mp_shoess@standard_car@ds@", "put_on_shoes", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
        --"random@domestic", "pickup_low", 8.00, -8.00, 1200, 0, 0.00, 0, 0, 0)
        skin = json.encode(skin)
        -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
        MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
            MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
                Player.PlayerData.citizenid,
                model,
                skin,
                1
            })
        end)
    end
end)

-- RegisterNetEvent('qb-usable-accessories:server:TheftShoe', function(playerId)
--     local source = source
--     local Player = QBCore.Functions.GetPlayer(source)
--     local Receiver = QBCore.Functions.GetPlayer(playerId)
--     if Receiver then 
--         TriggerClientEvent("qb-usable-accessories:client:StoleShoe", Receiver.PlayerData.source, Player.PlayerData.source)
--     end
-- end)

-- RegisterNetEvent("qb-usable-accessories:server:Complete", function(playerId)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     local Receiver = QBCore.Functions.GetPlayer(playerId)
--     local ped = GetPlayerPed(src)
--     local model = GetEntityModel(ped)
--     if model ~= nil then
--         local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
--         if result[1] ~= nil then
--             skin = json.decode(result[1].skin)
--         end
--         if data[src].item == nil then return end
--         if skin["shoes"].item == data[src].shoes then
--             SetPedComponentVariation(ped, 6, 34, 0, 2)
--             if Receiver then
--                 Receiver.Functions.AddItem(data[src].item, 1)
--                 TriggerClientEvent('inventory:client:ItemBox', Receiver.PlayerData.source, QBCore.Shared.Items[data[src].item], 'add')
--             end
--         end
--         skin["shoes"].item = 34
--         skin["shoes"].texture = 0
--         data[src] = {
--             shoes = 34,
--             item = nil
--         }
--         -- TriggerClientEvent("playAnim", src, "mp_shoess@standard_car@ds@", "put_on_shoes", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
--         --"random@domestic", "pickup_low", 8.00, -8.00, 1200, 0, 0.00, 0, 0, 0)
--         skin = json.encode(skin)
--         -- TODO: Update primary key to be citizenid so this can be an insert on duplicate update query
--         MySQL.Async.execute('DELETE FROM playerskins WHERE citizenid = ?', { Player.PlayerData.citizenid }, function()
--             MySQL.Async.insert('INSERT INTO playerskins (citizenid, model, skin, active) VALUES (?, ?, ?, ?)', {
--                 Player.PlayerData.citizenid,
--                 model,
--                 skin,
--                 1
--             })
--         end)
--     end
-- end)

