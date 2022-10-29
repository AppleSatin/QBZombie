local QBCore = exports['qb-core']:GetCoreObject()

local function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end

local lootedPeds = {}

local function IsPadAlreadyLooted(entity)
    local looted = false
    for k, v in pairs(lootedPeds) do
        if v.ped == entity then
            looted = true
        end
    end
    return looted
end

local function Anim() 
    local ped = PlayerPedId()
    LoadAnim('amb@medic@standing@kneel@idle_a')
    TaskPlayAnim(ped, 'amb@medic@standing@kneel@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    -- Wait(500)
    -- LoadAnim('anim@mp_fm_event@intro')
    -- TaskPlayAnim(ped, 'anim@mp_fm_event@intro', 'beast_transform', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    FreezeEntityPosition(ped, true)

end

local function PedHasLooted(entity)
    if IsPadAlreadyLooted(entity) then return end
    lootedPeds[#lootedPeds + 1] = {ped = entity}
end

local function DeleteAllPeds()
    ClearAreaOfPeds(GetEntityCoords(PlayerPedId()), 99999099.0, 1)
    ClearAreaOfVehicles(GetEntityCoords(PlayerPedId()), 99999099.0, false, false, false, false, false)
end

-- ON PLAYER LOAD
PlayerData = {}
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent('qb-lootpeds:server:onjoin')
end)

-- ENABLE LOOT SYSTEM
local IsEnable = Config.EnableOnStart
RegisterNetEvent("qb-lootpeds:client:enable", function()
    IsEnable = true
    QBCore.Functions.Notify(Lang:t('system.enable'), "success")
end)

-- DISABLE LOOT SYSTEM
RegisterNetEvent("qb-lootpeds:client:disable", function()
    IsEnable = false
    QBCore.Functions.Notify(Lang:t('system.disable'), "success")
    DeleteAllPeds()
end)

-- Delete Dead Ped
RegisterNetEvent("qb-lootpeds:client:deleteped", function(entity)
    local closedPed = QBCore.Functions.GetClosestPed(GetEntityCoords(PlayerPedId()))
    if DoesEntityExist(closedPed) and not IsPedAPlayer(closedPed) then
        DeletePed(closedPed)
        DeleteEntity(closedPed)
    end
    if DoesEntityExist(entity) and not IsPedAPlayer(entity) then
        DeletePed(entity)
        DeleteEntity(entity)
    end
end)

-- TAKE LOOT
RegisterNetEvent("qb-lootpeds:client:takeloot", function(entity)
    Anim()
    QBCore.Functions.Progressbar("loot_zombie", "Looting Dead Corpse..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        TriggerServerEvent('qb-lootpeds:server:getloot', entity)
        PedHasLooted(entity)
       -- ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(ped, false)
        ClearPedTasksImmediately(PlayerPedId())
    end)
end)
--     local ped = PlayerPedId()
--     Anim()
--     Wait(5000)
--     TriggerServerEvent('qb-lootpeds:server:getloot', entity)
--     PedHasLooted(entity)
--    -- ClearPedTasks(PlayerPedId())
--     FreezeEntityPosition(ped, false)
--     ClearPedTasksImmediately(PlayerPedId())
-- end)

-- TARGET SYSTEM
if Config.UseTarget then 
    exports['qb-target']:AddTargetModel(Config.PedModels, {
        options = {
            {
                type = "client",
                event = "qb-lootpeds:client:takeloot",
                icon = 'fa-thin fa-circle',
                label = Lang:t('target.label'),
                targeticon = 'fa-thin fa-circle',
                action = function(entity)
                    if not IsEnable then return false end 
                    if IsPedAPlayer(entity) then return false end
                    if IsPadAlreadyLooted(entity) then return false end
                    TriggerEvent('qb-lootpeds:client:takeloot', entity)
                end,
                canInteract = function(entity, distance, data)
                    if not IsEnable then return false end 
                    if IsPedAPlayer(entity) then return false end
                    if not IsPedAPlayer(entity) and not IsEntityDead(entity) then return false end
                    if IsPadAlreadyLooted(entity) then return false end
                    return true
                end
            }
        },
        distance = 2.5,
    })
end
