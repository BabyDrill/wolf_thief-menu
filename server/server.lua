ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Users = {}

ESX.RegisterServerCallback('wl_criminale:getValue', function(source, cb, targetSID)
	if Users[targetSID] then
		cb(Users[targetSID])
	else
		cb({value = false, time = 0})
	end
end)

RegisterServerEvent('wl_criminale:manialzate')
AddEventHandler('wl_criminale:manialzate', function(bool)
	local _source = source
	Users[_source] = {value = bool, time = os.time()}
end)

RegisterServerEvent('wl_criminale:getValue')
AddEventHandler('wl_criminale:getValue', function(targetSID)
	local _source = source
	if Users[targetSID] then
		TriggerClientEvent('wl_criminale:returnValue', _source, Users[targetSID])
	else
		TriggerClientEvent('wl_criminale:returnValue', _source, Users[targetSID])
	end
end)