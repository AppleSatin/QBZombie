local cam = nil
local charPed = nil
local QBCore = exports['qb-core']:GetCoreObject()

-- Main Thread

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('qb-multicharacter:client:chooseChar')
			return
		end
	end
end)

-- Functions

local function skyCam(bool)
    TriggerEvent('qb-weathersync:client:DisableSync')
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CamCoords.x, Config.CamCoords.y, Config.CamCoords.z, 0.0 ,0.0, Config.CamCoords.w, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

local function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    skyCam(bool)
end

-- Events

RegisterNetEvent('qb-multicharacter:client:closeNUIdefault', function() -- This event is only for no starting apartments
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
    Wait(500)
    openCharMenu()
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    TriggerEvent('qb-weathersync:client:EnableSync')
    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

RegisterNetEvent('qb-multicharacter:client:closeNUI', function()
    DeleteEntity(charPed)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('qb-multicharacter:client:chooseChar', function()
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    -- Wait(1000)

    -- local interior = GetInteriorAtCoords(Config.Interior.x, Config.Interior.y, Config.Interior.z - 18.9)
    -- LoadInterior(interior)
    -- while not IsInteriorReady(interior) do
    --     Wait(1000)
    -- end
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), Config.HiddenCoords.x, Config.HiddenCoords.y, Config.HiddenCoords.z)
  --  Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    openCharMenu(true)
    DoScreenFadeIn(10)
end)

-- NUI Callbacks

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-multicharacter:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('qb-multicharacter:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
end)

RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-multicharacter:server:getSkin', function(model, data)
            model = model ~= nil and tonumber(model) or false
            DoScreenFadeOut(500)
            Citizen.Wait(1000)
            DoScreenFadeIn(600)
            if model ~= nil then
                CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    data = json.decode(data)
                    ClearPedTasks(charPed)
                    -- RequestAnimDict("timetable@tracy@sleep@")
                    -- while not HasAnimDictLoaded('timetable@tracy@sleep@') do
                    --     RequestAnimDict('timetable@tracy@sleep@')
                    --     Citizen.Wait(100)
                    -- end
                    -- TaskPlayAnim(charPed,"timetable@tracy@sleep@", "idle_c", 1.0,-1.0, 3000, 1, 1, false, false, false)
                    -- Wait(1000)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][1], 12.04)
                    Wait(3500)
                    ClearPedTasks(charPed)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][2], 12.04)
                    Wait(100)
                    ClearPedTasks(charPed)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][3], 33.68)
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)

                end)
            else
                CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end
                    charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    ClearPedTasks(charPed)
                    -- RequestAnimDict("timetable@tracy@sleep@")
                    -- while not HasAnimDictLoaded('timetable@tracy@sleep@') do
                    --     RequestAnimDict('timetable@tracy@sleep@')
                    --     Citizen.Wait(100)
                    -- end
                    -- TaskPlayAnim(charPed,"timetable@tracy@sleep@", "idle_c", 1.0,-1.0, 3000, 1, 1, false, false, false)
                    -- Wait(1000)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][1], 12.04)
                    Wait(3500)
                    ClearPedTasks(charPed)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][2], 12.04)
                    Wait(100)
                    ClearPedTasks(charPed)
                    TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][3], 33.68)
                    TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
                end)
            end
        end, cData.citizenid)
    else
        CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            charPed = CreatePed(2, model, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, Config.PedCoords.w, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            ClearPedTasks(charPed)
            -- RequestAnimDict("timetable@tracy@sleep@")
            -- while not HasAnimDictLoaded('timetable@tracy@sleep@') do
            --     RequestAnimDict('timetable@tracy@sleep@')
            --     Citizen.Wait(100)
            -- end
            -- TaskPlayAnim(charPed,"timetable@tracy@sleep@", "idle_c", 1.0,-1.0, 3000, 1, 1, false, false, false)
            -- Wait(1000)
            TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][1], 12.04)
            Wait(3500)
            ClearPedTasks(charPed)
            TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][2], 12.04)
            Wait(100)
            ClearPedTasks(charPed)
            TaskPedSlideToCoord(charPed, Config.PedToCoords["pedtocoords"][3], 33.68)
            TriggerEvent('qb-clothing:client:loadPlayerClothing', data, charPed)
        end)
    end
end)

RegisterNUICallback('setupCharacters', function()
    QBCore.Functions.TriggerCallback("qb-multicharacter:server:setupCharacters", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "Male" then
        cData.gender = 0
    elseif cData.gender == "Female" then
        cData.gender = 1
    end
    TriggerServerEvent('qb-multicharacter:server:createCharacter', cData)
    Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', data.citizenid)
    TriggerEvent('qb-multicharacter:client:chooseChar')
end)