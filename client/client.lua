ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	Citizen.Wait(5000)
end)

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Config.Key) then
			menudellamadonna()
		end

	end

end)

local DragStatus = {}
DragStatus.IsDragged = false
DragStatus.draganim = false

function menudellamadonna()
	local IsHandcuffed = false
	local elements = 
	{{label = "Ammanetta", value = 'ammanetta'}, 
	{label = "Smanetta", value = 'smanetta'}, 
	{label = "Trascina", value = 'scorta'}, 
	{label = "Perquisisci", value = 'perquisisci'}, 
	{label = "Metti in un veicolo", value = 'mettiveicolo'}, 
	{label = "Togli da un veicolo", value = 'togliveicolo'}}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'menu_criminale',
	  {
		  title    = 'Interazione Giocatori',
		  align = 'bottom-right',
		  elements = elements

	  },
	  function(data, menu)
		  local val = data.current.value
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				
			if val == 'ammanetta' then

				ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
					if quantity > 0 then	
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						ExecuteCommand('me Sta Ammenettando..')
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
						exports['progressBars']:startUI(2000, "Ammanettando..")
						Citizen.Wait(2000)
						TriggerServerEvent('esx_policejob:requestarrest2', target_id, playerheading, playerCoords, playerlocation)
						TriggerServerEvent('wl_manette:toglilemantte', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification(Lang.manette)
					end
				end, Config.ItemManette)

			elseif val == 'smanetta' then

			ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
				if quantity > 0 then	
				local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(GetPlayerPed(-1))
				playerlocation = GetEntityForwardVector(PlayerPedId())
				playerCoords = GetEntityCoords(GetPlayerPed(-1))
				local target_id = GetPlayerServerId(target)
				TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
				Citizen.Wait(1200)
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'uncuff', 0.5)
				TriggerServerEvent('wl_manette:aggiungimantte', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification(Lang.chiavi)
				end
			end, Config.ItemChiavi)

            elseif val == 'scorta' then
				ExecuteCommand('me Sta Scortando..')
				exports['progressBars']:startUI(2000, "Scortando..")
				Citizen.Wait(2000)
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
			elseif val == 'perquisisci' then
				local idgiocatorevicino = GetPlayerServerId(closestPlayer)
				ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
					if quantity > 0 then	
						ExecuteCommand('me Sta Perquisendo..')
						exports['progressBars']:startUI(2000, "Percquisendo..")
						Citizen.Wait(2000)
						TriggerEvent('wolf:aprimenu')
						startAnim("random@atmrobberygen@male", "idle_a")   
						TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), 'Ti stanno perquisendo!')
					else
						ESX.ShowNotification(Lang.item)
					end
				end, Config.Item)
            elseif val == 'mettiveicolo' then
				ExecuteCommand('me Mette Giocatore nel veicolo')
                TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
            elseif val == 'togliveicolo' then
				ExecuteCommand('me Fa Scendere player dal veicolo')
                TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
            end
		else
		    ESX.ShowNotification(Lang.player)
	    end
	  end,
	function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('wolf:aprimenu')
AddEventHandler('wolf:aprimenu', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	   apriinventarioplayer(player)
	   Wait(3500)              		
       ClearPedTasks(GetPlayerPed(-1))
	end	
end, false)

function apriinventarioplayer(closestPlayer)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
end