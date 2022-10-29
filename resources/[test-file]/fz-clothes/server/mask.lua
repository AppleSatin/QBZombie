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
    for k, v in pairs(Config["Masks"]) do
        if (skin["mask"].item == v[model].drawableId) then
            data[src] = {
                mask = v[model].drawableId,
                item = k
            }
        end
    end
end)

for k, v in pairs(Config["Masks"]) do
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
                skin["mask"].item = v[model].drawableId
                skin["mask"].texture = v[model].textureId
                if data[src] then
                    if data[src].mask ~= 0 then
                        print(data[src].item)
                        Player.Functions.AddItem(data[src].item, 1)
                    end
                end
                data[src] = {
                    mask = v[model].drawableId,
                    item = k
                }
                SetPedComponentVariation(ped, 1, skin["mask"].item, skin["mask"].texture, 2)
                TriggerClientEvent("playAnim", src, "mp_masks@standard_car@ds@", "put_on_mask", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
                -- TaskPlayAnim(ped, "mp_masks@standard_car@ds@", "put_on_mask", 8.00, -8.00, 800, 51, 0.00, 0, 0, 0)
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

RegisterCommand("maskoff", function(source)
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
        if skin["mask"].item == data[src].mask then
            SetPedComponentVariation(ped, 1, 0, 0, 2)
            Player.Functions.AddItem(data[src].item, 1)
        end

        skin["mask"].item = 0
        skin["mask"].texture = 0
        data[src] = {
            mask = 0,
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