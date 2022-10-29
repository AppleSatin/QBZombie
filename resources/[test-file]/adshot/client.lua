local QBCore = exports['qb-core']:GetCoreObject()
local adShotStop = 0

RegisterNetEvent("adshot:client:Start", function()
    local ped = PlayerPedId()
    local eh = GetEntityHealth(ped)
    local pid = PlayerId()
    if eh > 100 and eh < 125 then
        SetEntityHealth(ped, eh + math.random(10,30))
    elseif eh > 125 then
        SetEntityHealth(ped, eh + math.random(1,5))
    end
    SetRunSprintMultiplierForPlayer(pid, 1.49)
    SetSwimMultiplierForPlayer(pid, 1.49)
    adShot()
end)

function adShot()
    if adShotStop == 0 then
        adShotStop = math.random(3,7)
        CreateThread(function()
            repeat
                Wait(1000)
                local pid = PlayerId()
                if adShotStop -1 == 0 then
                    SetRunSprintMultiplierForPlayer(pid, 1.0)
                    SetSwimMultiplierForPlayer(pid, 1.0)
                end
                SetPlayerStamina(pid, 100.0)
                adShotStop = adShotStop - 1
            until adShotStop == 0
        end)
    end
end