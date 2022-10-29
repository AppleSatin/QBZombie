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
    for k, v in pairs(Config["Hats"]) do
        if (skin["hat"].item == v[model].drawableId) then
            data[src] = {
                hat = v[model].drawableId,
                item = k
            }
        end
    end
end)

for k, v in pairs(Config["Hats"]) do
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
                skin["hat"].item = v[model].drawableId
                skin["hat"].texture = v[model].textureId
                if data[src] then
                    if data[src].hat ~= -1 then
                        print(data[src].item)
                        Player.Functions.AddItem(data[src].item, 1)
                    end
                end
                data[src] = {
                    hat = v[model].drawableId,
                    item = k
                }
                SetPedPropIndex(ped, 0, skin["hat"].item, skin["hat"].texture, true)
                TriggerClientEvent("playAnim", src, "mp_masks@standard_car@ds@", "put_on_mask", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
                -- TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.00, -8.00, 2100, 51, 0.00, 0, 0, 0)
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

RegisterCommand("hatoff", function(source)
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
        if skin["hat"].item == data[src].hat then
            ClearPedProp(ped, 0)
            -- SetPedPropIndex(ped, 0, -1, 0, true)
            Player.Functions.AddItem(data[src].item, 1)
        end
        skin["hat"].item = 0
        skin["hat"].texture = 0
        data[src] = {
            hat = 0,
            item = nil
        }
        TriggerClientEvent("playAnim", src, "mp_masks@standard_car@ds@", "put_on_mask", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
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

--[[


]]