--       _               __    _  _  __ ___  ____  _  _   
--      | |              \ \ _| || |/_ |__ \|___ \| || |  
--      | | __ _ _   _  (_) |_  __  _| |  ) | __) | || |_ 
--  _   | |/ _` | | | |   | |_| || |_| | / / |__ <|__   _|
-- | |__| | (_| | |_| |  _| |_  __  _| |/ /_ ___) |  | |  
--  \____/ \__,_|\__, | ( ) | |_||_| |_|____|____/   |_|  
--                __/ | |/_/                              
--               |___/   

-- The script doesn't look optimised, look at the code and optimise it if needed.

-- QBCore

local QBCore = exports['qb-core']:GetCoreObject()

-- Script

local ill = false
local chance = 6 -- The chance of being sick

Citizen.CreateThread(function()

while true do
		Citizen.Wait(60000)

  local chanceill = math.random(1, 100)

   if chanceill <= chance then -- Checks if the randomized number is under 6, 5% of 100 (as default).
       ill = true -- Getting sick if you successfully got under the "chance".
       QBCore.Functions.Notify('You are feeling sick, Take some medicine', 'error', 2500)
    end
  end
end)


Citizen.CreateThread(function()

while true do

    local chansatthosta = math.random(1000, 10000)

	Citizen.Wait(chansatthosta)

    if ill then --Checks if ill

        --Cough animation
	   RequestAnimDict("timetable@gardener@smoking_joint")
         while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
        	Citizen.Wait(100)
         end
 
            TaskPlayAnim(GetPlayerPed(-1), "timetable@gardener@smoking_joint", "idle_cough", 8.0, 8.0, -1, 50, 0, false, false, false)
            Citizen.Wait(3000)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())-1)
        --    QBCore.Functions.Notify('You are feeling sick, Take some medicine', 'error', 2500)
        end
    end
end)



-- Citizen.CreateThread(function()

--     while true do

--     local chanstillfrisk = math.random(900000, 1800000) -- Chance of being healthy by yourself

--     Citizen.Wait(chanstillfrisk)

--     if ill then

--     ill = false

--         end
--     end
-- end)


RegisterNetEvent('sickness:frisk')
AddEventHandler('sickness:frisk', function()

  ill = false
  
end)



-- RegisterNetEvent('sickness:f', function(val)

--     ill = val
    
--   end)

-- TriggerEvent('sickness:f', true)