local QBCore = exports['qb-core']:GetCoreObject()

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

local Ill = false

local function GetIll()
	local ped = PlayerPedId()
	Ill = true
	print("get fucked")
	RequestAnimSet('move_m@drunk@verydrunk')
	SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)
end

function RemoveIll()
	local ped = PlayerPedId()
	print("huhhhhhh")
	Ill = false 
	RequestAnimSet('move_m@casual@b')
	SetPedMovementClipset(ped, 'move_m@casual@b', 1.0)
	print("Removed being Ill")
	QBCore.Functions.Notify('You are no longer ill', 'success', 2500)
end

local Hitsound = false


function HitSoundEffect()
	if not Hitsound then
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "zombiehitsound", 1)
		Hitsound = true
	else 
		-- Wait(1000)
		 Hitsound = false
	end
end


local LocalZombieSound = false


function LocalSoundEffect()
	if not LocalZombieSound then
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "zombielocalsound", 0.2)
	--	LocalZombieSound = true
	else 
		-- Wait(10000)
		 LocalZombieSound = false
	end
end

RegisterNetEvent("apple:removedill", function()
	QBCore.Functions.Progressbar("enject_here", "Ejecting Syring..", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@sprunk",
        anim = "plyr_buy_drink_pt1",
        flags = 49,
    }, {}, {}, function() -- Done
	print("here 3")
	RemoveIll()
	StopScreenEffect("DrugsTrevorClownsFight")
	StopScreenEffect("DrugsTrevorClownsFightIn")
	StopScreenEffect("DrugsTrevorClownsFightOut")
	end)
end)

Citizen.CreateThread(function()

	while true do
	
		local chansatthosta = math.random(1000, 10000)
	
		Citizen.Wait(chansatthosta)
	
		if Ill then --Checks if ill
	
			--Cough animation
		   RequestAnimDict("timetable@gardener@smoking_joint")
			 while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
				Citizen.Wait(100)
			 end
	 
				TaskPlayAnim(GetPlayerPed(-1), "timetable@gardener@smoking_joint", "idle_cough", 8.0, 8.0, -1, 50, 0, false, false, false)
				Citizen.Wait(3000)
				ClearPedSecondaryTask(GetPlayerPed(-1))
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId())-1)
			    QBCore.Functions.Notify('You have been bit by a zombie and is now sick..', 'error', 2500)
			end
		end
	end)


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

local CoolDown = false

local function CoolDown()
	CoolDown = true
	Wait(1000) -- Time in MS = 1Sec
	CoolDown = false
end

RegisterNetEvent("apple:effect", function(source)
	if not CoolDown then 
		print("done")
		HitEffect()
		CoolDown()
	else
		print("cant right now cool down")
	end
end)


function HitEffect()
    StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
    StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 0)
--	Wait(10000)
	-- StopScreenEffect("DrugsTrevorClownsFight")
	-- StopScreenEffect("DrugsTrevorClownsFightIn")
	-- StopScreenEffect("DrugsTrevorClownsFightOut")
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
					--print("spawned here")
	            elseif IsPlayerRunning() then
	                DistanceTarget = 50.0
	            else
	                DistanceTarget = 20.0
					 LocalSoundEffect()
					print("zombie noise spawned at this distance")
					print(Distance)
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
							-- HitEffect()
							--TriggerEvent("apple:effect")
							print("hit by zombie")
							GetIll()
							HitEffect()
							 HitSoundEffect()
							--TriggerServerEvent("InteractSound_SV:PlayOnSource", "zombiehitsound", 1)
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