local QBCore = exports['qb-core']:GetCoreObject()

local havebike = false

RegisterServerEvent("esx:bike:lowmoney_gogoro")
AddEventHandler("esx:bike:lowmoney_gogoro", function(money)
    local _source = source	
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	local cash 	  = xPlayer.PlayerData.money['cash']

	if cash >= Config.PriceGogoro then
		xPlayer.Functions.RemoveMoney('cash', Config.PriceGogoro)
		TriggerClientEvent("QBCore:Command:SpawnVehicle", _source, "gogoro")
		TriggerClientEvent("esx:bike:rentSuccess", _source)
	end
end)
