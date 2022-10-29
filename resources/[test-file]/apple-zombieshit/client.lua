local Shooting = false
local Running = false

local SafeZones = {
   {x = 457.5966, y = -741.9636, z = 28.4284, radius = 105.0},-- Safe Zone One
}


local function entertimer()
    exports['qb-core']:DrawText('Safe Zone Entered', 'left')
    Wait(3000)
    exports['qb-core']:HideText()
end

local function exittimer()
    exports['qb-core']:DrawText('Safe Zone Left', 'left')
    Wait(3000)
    exports['qb-core']:HideText()
end

DecorRegister('RegisterZombie', 2)

AddRelationshipGroup('ZOMBIE')
SetRelationshipBetweenGroups(0, GetHashKey('ZOMBIE'), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('ZOMBIE'))

function IsPlayerShooting()
    return Shooting
end

function IsPlayerRunning()
    return Running
end

function IsPedInAnyVehicle()
    return driving
end

function IsPedDoingDriveby()
    return driving
end

Citizen.CreateThread(function()-- Will only work in it's own while loop
    while true do
        Citizen.Wait(0)

        -- Peds
        SetPedDensityMultiplierThisFrame(1.0)
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)

        -- Vehicles
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
    end
end)



Citizen.CreateThread(function()-- Will only work in it's own while loop
    while true do
        Citizen.Wait(0)

        if IsPedShooting(PlayerPedId()) then
	        Shooting = true
	        Citizen.Wait(5000)
	        Shooting = false
	    end

	    if IsPedSprinting(PlayerPedId()) or IsPedRunning(PlayerPedId()) or IsPedInAnyVehicle(PlayerPedId()) or IsPedDoingDriveby() then
	        if Running == false then
	            Running = true
	        end
	    else
	        if Running == true then
	            Running = false
	        end
	    end
    end
end)

function HitEffect()
    local startStamina = 8
    HitEffect2()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    while startStamina > 0 do
        Wait(1000)
        if math.random(5, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(5, 100) < 51 then
            HitEffect2()
        end
    end
    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function HitEffect2()
    StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
    Wait(3000)
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
    Wait(3000)
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
	StopScreenEffect("DrugsTrevorClownsFight")
	StopScreenEffect("DrugsTrevorClownsFightIn")
	StopScreenEffect("DrugsTrevorClownsFightOut")
end

Citizen.CreateThread(function()
	for _, zone in pairs(SafeZones) do
    	local Blip = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius)
		SetBlipHighDetail(Blip, true)
    	SetBlipColour(Blip, 2)
    	SetBlipAlpha(Blip, 128)
	end

    while true do
        Citizen.Wait(0)

    	for _, zone in pairs(SafeZones) do
	        local Zombie = -1
	        local Success = false
	        local Handler, Zombie = FindFirstPed()

	        repeat
	            if IsPedHuman(Zombie) and not IsPedAPlayer(Zombie) and not IsPedDeadOrDying(Zombie, true) then
	                local pedcoords = GetEntityCoords(Zombie)
	              	local zonecoords = vector3(zone.x, zone.y, zone.z)
	                local distance = #(zonecoords - pedcoords)

	                if distance <= zone.radius then
	                    DeleteEntity(Zombie)
	                end
	            end

	            Success, Zombie = FindNextPed(Handler)
	        until not (Success)

	        EndFindPed(Handler)
	    end
	        
		local Zombie = -1
	 	local Success = false
		local Handler, Zombie = FindFirstPed()

	    repeat
        	Citizen.Wait(10)

	        if IsPedHuman(Zombie) and not IsPedAPlayer(Zombie) and not IsPedDeadOrDying(Zombie, true) then
	            if not DecorExistOn(Zombie, 'RegisterZombie') then
	                ClearPedTasks(Zombie)
	                ClearPedSecondaryTask(Zombie)
	                ClearPedTasksImmediately(Zombie)
	                TaskWanderStandard(Zombie, 10.0, 10)
	                SetPedRelationshipGroupHash(Zombie, 'ZOMBIE')
	                ApplyPedDamagePack(Zombie, 'BigHitByVehicle', 0.0, 1.0)
	                SetEntityHealth(Zombie, 200)

	                RequestAnimSet('move_m@drunk@verydrunk')
	                while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
	                    Citizen.Wait(0)
	                end
	                SetPedMovementClipset(Zombie, 'move_m@drunk@verydrunk', 1.0)

	                SetPedConfigFlag(Zombie, 100, false)
	                DecorSetBool(Zombie, 'RegisterZombie', true)
	            end

	            SetPedRagdollBlockingFlags(Zombie, 1)
			    SetPedCanRagdollFromPlayerImpact(Zombie, false)
			    SetPedSuffersCriticalHits(Zombie, true)
			    SetPedEnableWeaponBlocking(Zombie, true)
			    DisablePedPainAudio(Zombie, true)
			    StopPedSpeaking(Zombie, true)
			    SetPedDiesWhenInjured(Zombie, false)
			    StopPedRingtone(Zombie)
			    SetPedMute(Zombie)
			    SetPedIsDrunk(Zombie, true)
			    SetPedConfigFlag(Zombie, 166, false)
			    SetPedConfigFlag(Zombie, 170, false)
			    SetBlockingOfNonTemporaryEvents(Zombie, true)
			    SetPedCanEvasiveDive(Zombie, false)
			    RemoveAllPedWeapons(Zombie, true)

	            local PlayerCoords = GetEntityCoords(PlayerPedId())
	            local PedCoords = GetEntityCoords(Zombie)
	            local Distance = #(PedCoords - PlayerCoords)
	            local DistanceTarget

	           	if IsPlayerShooting() or IsPedInAnyVehicle() or IsPedDoingDriveby() then
	                DistanceTarget = 120.0
					print("spawned here")
	            elseif IsPlayerRunning() then
	                DistanceTarget = 50.0
	            else
	                DistanceTarget = 20.0
	            end

	            if Distance <= DistanceTarget and not IsPedInAnyVehicle(PlayerPedId(), false) then
	                TaskGoToEntity(Zombie, PlayerPedId(), -1, 0.0, 2.0, 1073741824, 0)
	            end

	            if Distance <= 1.3 then
	                if not IsPedRagdoll(Zombie) and not IsPedGettingUp(Zombie) then
	                	local health = GetEntityHealth(PlayerPedId())
	                    if health == 0 then
	                        ClearPedTasks(Zombie)
	                        TaskWanderStandard(Zombie, 10.0, 10)
	                    else
	                        RequestAnimSet('melee@unarmed@streamed_core_fps')
	                        while not HasAnimSetLoaded('melee@unarmed@streamed_core_fps') do
	                            Citizen.Wait(10)
	                        end

	                        TaskPlayAnim(Zombie, 'melee@unarmed@streamed_core_fps', 'ground_attack_0_psycho', 8.0, 1.0, -1, 48, 0.001, false, false, false)

	                        ApplyDamageToPed(PlayerPedId(), 1, false)
							HitEffect()
	                    end
	                end
	            end
	            
	            if not NetworkGetEntityIsNetworked(Zombie) then
	                DeleteEntity(Zombie)
	            end
	        end
	        
	        Success, Zombie = FindNextPed(Handler)
	   	until not (Success)

    	EndFindPed(Handler)
   	end
end)



Citizen.CreateThread(function()
   local Zombie = -1
   local Handler, Zombie = FindFirstPed()
   local PedCoords = GetEntityCoords(Zombie)
    for k, v in pairs(Config.ZombieSafeZones) do
        v:onPlayerInOut(function(isPointInside, point)
			if isPointInside then
				entertimer()
				print("trigger enter event")
				DeleteEntity(Zombie)
			else
			   exittimer()
			   print("trigger leave event")
            end
        end)
    end
end)