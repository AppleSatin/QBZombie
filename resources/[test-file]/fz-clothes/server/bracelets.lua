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
    for k, v in pairs(Config["Bracelets"]) do
        if (skin["bracelet"].item == v[model].drawableId) then
            data[src] = {
                bracelet = v[model].drawableId,
                item = k
            }
        end
    end
end)

for k, v in pairs(Config["Bracelets"]) do
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
                skin["bracelet"].item = v[model].drawableId
                skin["bracelet"].texture = v[model].textureId
                data[src] = {
                    bracelet = v[model].drawableId,
                    item = k
                }
                SetPedPropIndex(ped, 7, skin["bracelet"].item, skin["bracelet"].texture, true)
                TriggerClientEvent("playAnim", src, "nmt_3_rcm-10", "cs_nigel_dual-10", 8.00, -8.00, 1200, 51, 0.00, 0, 0, 0)
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

RegisterCommand("braceletoff", function(source)
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
        if skin["bracelet"].item == data[src].bracelet then
            ClearPedProp(ped, 7)
            Player.Functions.AddItem(data[src].item, 1)
        end
        skin["bracelet"].item = 0
        skin["bracelet"].texture = 0
        data[src] = {
            bracelet = 0,
            item = nil
        }
        TriggerClientEvent("playAnim", src, "nmt_3_rcm-10", "cs_nigel_dual-10", 8.00, -8.00, 1200, 51, 0.00, 0, 0, 0)
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