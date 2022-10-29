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
    for k, v in pairs(Config["Vests"]) do
        if (skin["vest"].item == v[model].drawableId) then
            data[src] = {
                vest = v[model].drawableId,
                item = k
            }
        end
    end
end)

for k, v in pairs(Config["Vests"]) do
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
                skin["vest"].item = v[model].drawableId
                skin["vest"].texture = v[model].textureId
                data[src] = {
                    vest = v[model].drawableId,
                    item = k
                }
                SetPedComponentVariation(ped, 9, skin["vest"].item, skin["vest"].texture, 2)
                -- TaskPlayAnim(ped, "clothingtie", "try_tie_negative_a", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
                TriggerClientEvent("playAnim", src, "clothingtie", "try_tie_negative_a", 8.00, -8.00, 1200, 51, 0.00, 0, 0, 0)
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

RegisterCommand("vestoff", function(source)
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
        if skin["vest"].item == data[src].vest then
            SetPedComponentVariation(ped, 9, 0, 0, 2)
            Player.Functions.AddItem(data[src].item, 1)
        end
        skin["vest"].item = 0
        skin["vest"].texture = 0
        data[src] = {
            vest = 0,
            item = nil
        }
        TriggerClientEvent("playAnim", src, "clothingtie", "try_tie_negative_a", 8.00, -8.00, 1200, 51, 0.00, 0, 0, 0)
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


RegisterNetEvent("qb-usable-accessories:server:VestComplete", function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Receiver = QBCore.Functions.GetPlayer(playerId)
    local ped = GetPlayerPed(src)
    local model = GetEntityModel(ped)
    if model ~= nil then
        local result = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { Player.PlayerData.citizenid, 1 })
        if result[1] ~= nil then
            skin = json.decode(result[1].skin)
        end
        if data[src].item == nil then return end
        if skin["vest"].item == data[src].vest then
            SetPedComponentVariation(ped, 6, 34, 0, 2)
            if Receiver then
                Receiver.Functions.AddItem(data[src].item, 1)
                TriggerClientEvent('inventory:client:ItemBox', Receiver.PlayerData.source, QBCore.Shared.Items[data[src].item], 'add')
            end
        end
        skin["vest"].item = 34
        skin["vest"].texture = 0
        data[src] = {
            vest = 34,
            item = nil
        }
        -- TriggerClientEvent("playAnim", src, "mp_shoess@standard_car@ds@", "put_on_shoes", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
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
