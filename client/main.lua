--------------------------------------------------------------------------------
------------------------------------------------- Completed by JalalLinuX ------
--------------------------------------------------------------------------------

ESX = nil

Citizen.CreateThread(function()
	CheckESX()
end)


function CheckESX()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end

-- need for next version
function VehicleInFront(checkDistance)
	local vehicle, distance = ESX.Game.GetClosestVehicle()
	Citizen.Wait(10)
    if vehicle ~= nil and distance < (checkDistance and checkDistance or Config.CarLock.CheckVehicleDistance) then
		return vehicle
    else 
        return 0 
    end
end


-- Lock and Unlock Event
Citizen.CreateThread(function()
	CheckESX()
  	local dict = "anim@mp_player_intmenu@key_fob@"
  	RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
  end
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, Config.CarLock.ControlKey)) then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local hasAlreadyLocked = false
		cars = ESX.Game.GetVehiclesInArea(coords, Config.CarLock.SearchAreaRadius)
		local carstrie = {}
		local cars_dist = {}		
		notowned = 0
		if #cars == 0 then
			ESX.ShowHelpNotification(Config.CarLock.NotCarFound)
		else
			for j=1, #cars, 1 do
				local coordscar = GetEntityCoords(cars[j])
				local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
				table.insert(cars_dist, {cars[j], distance})
			end
			for k=1, #cars_dist, 1 do
				local z = -1
				local distance, car = 999
				for l=1, #cars_dist, 1 do
					if cars_dist[l][2] < distance then
						distance = cars_dist[l][2]
						car = cars_dist[l][1]
						z = l
					end
				end
				if z ~= -1 then
					table.remove(cars_dist, z)
					table.insert(carstrie, car)
				end
			end
			for i=1, #carstrie, 1 do
				local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
				ESX.TriggerServerCallback('CarLock:isVehicleOwner', function(owner)
					if owner and hasAlreadyLocked ~= true then
						local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
						vehicleLabel = GetLabelText(vehicleLabel)
						local lock = GetVehicleDoorLockStatus(carstrie[i])
						if lock == 1 or lock == 0 then
							SetVehicleDoorShut(carstrie[i], 0, false)
							SetVehicleDoorShut(carstrie[i], 1, false)
							SetVehicleDoorShut(carstrie[i], 2, false)
							SetVehicleDoorShut(carstrie[i], 3, false)
							SetVehicleDoorsLocked(carstrie[i], 2)
							PlayVehicleDoorCloseSound(carstrie[i], 1)
							
							ESX.ShowHelpNotification("~BLIP_134~ " .. Config.CarLock.CarLocked)
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							if Config.CarLock.CarBleepOnOpen then
								TriggerServerEvent('InteractSound_SV:PlayOnSource', 'carlock', Config.CarLock.CarBleepVolume) 
							end
							if Config.CarLock.BlinkingLightsON then
								Citizen.Wait(100)
								SetVehicleLights(carstrie[i], 2)
								Citizen.Wait(200)
								SetVehicleLights(carstrie[i], 1)
								Citizen.Wait(200)
								SetVehicleLights(carstrie[i], 2)
								Citizen.Wait(200)
								SetVehicleLights(carstrie[i], 1)
								Citizen.Wait(200)
								SetVehicleLights(carstrie[i], 2)
								Citizen.Wait(200)
								SetVehicleLights(carstrie[i], 0)
							end
							hasAlreadyLocked = true
						elseif lock == 2 then
							SetVehicleDoorsLocked(carstrie[i], 1)
							PlayVehicleDoorOpenSound(carstrie[i], 0)
							
							ESX.ShowHelpNotification("~BLIP_134~ " .. Config.CarLock.CarOpen)
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							if Config.CarLock.CarBleepOnClose then
								TriggerServerEvent('InteractSound_SV:PlayOnSource', 'carlock', Config.CarLock.CarBleepVolume)
							end 
							if Config.CarLock.BlinkingLightsON then
								SetVehicleLights(carstrie[i], 2)
								Citizen.Wait(100)
								SetVehicleLights(carstrie[i], 1)
								Citizen.Wait(100)
								SetVehicleLights(carstrie[i], 2)
								Citizen.Wait(100)
								SetVehicleLights(carstrie[i], 0)
							end
							hasAlreadyLocked = true
						end
					else
						notowned = notowned + 1
					end
					if notowned == #carstrie then
						ESX.ShowHelpNotification("~BLIP_INFO_ICON~ " .. Config.CarLock.NotCarFound)
					end	
				end, plate)
			end			
		end
	end
  end
end)

-- Speed Limiter Event
Citizen.CreateThread(function()
	CheckESX()
  	local resetSpeedOnEnter = true
  	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed,false)
		if Config.CarLock.SpeedLimiter then
			if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
				
			if resetSpeedOnEnter then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				resetSpeedOnEnter = false
			end
			-- Speed Limiter Off
			if IsControlJustReleased(0,Config.CarLock.SpeedLimiterKey) and IsControlPressed(0,131) then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				ESX.ShowHelpNotification("~BLIP_12~ "..Config.CarLock.LimiterIsOn, 2000)
			-- Speed Limiter On
			elseif IsControlJustReleased(0,Config.CarLock.SpeedLimiterKey) then
				cruise = GetEntitySpeed(vehicle)
				SetEntityMaxSpeed(vehicle, cruise)
				cruise = math.floor(cruise * 3.6 + 0.5)
				ESX.ShowHelpNotification("~BLIP_11~ "..Config.CarLock.LimiterIsOn.." ~b~"..cruise.."~w~ km/h", 4000)
			end
			else
			resetSpeedOnEnter = true
			end
		end
  end
end)