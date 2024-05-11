local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local QBCore = exports['qb-core']:GetCoreObject()
local havebike = false

CreateThread(function()

	if not Config.EnableBlips then 
		return 
	end

	for k, v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, Config.BlipId)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, Config.BlipColor)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.BlipTitle)
		EndTextCommandSetBlipName(blip)
	end

end)

CreateThread(function()
    while true do
    	Wait(1)
        for k, v in pairs(Config.Zones) do
           DrawMarker(Config.TypeMarker, v.x, v.y, v.z - 0.901, 0, 0, 0, 0, 0, 0, Config.MarkerScale.x, Config.MarkerScale.y, Config.MarkerScale.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, 0, 0, 0, 1)	
		end
    end
end)

CreateThread(function()
    while true do
        Wait(1)
		local xPlayer = PlayerPedId()
        for k, v in pairs(Config.Zones) do
        	local ped = xPlayer
            local pedcoords = GetEntityCoords(xPlayer)
			local distance = #(pedcoords - v)
            if distance <= 1.8 then
				if havebike == false then
					helptext(Translations.info.press_e)
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBikesMenu()
					end
				elseif havebike == true then
					helptext(Translations.info.storebike)
					if IsControlJustPressed(0, Keys['E']) and IsPedOnAnyBike(ped) then
						TriggerEvent("QBCore:Command:DeleteVehicle")
						havebike = false
					end 		
				end
            end
        end
    end
end)

function OpenBikesMenu()

	local elements = {}

	if Config.EnablePrice == false then
		table.insert(elements, {label = Translations.info.bikefree, value = 'gogoro'})
		--table.insert(elements, {label = Translations.info.gogorofree,value = 'gogoro'})
	elseif Config.EnablePrice == true then
		table.insert(elements, {label = Translations.info.bike, value = 'gogoro'})
		--table.insert(elements, {label = Translations.info.gogoro,value = 'gogoro'})
	end
	
    local bikemenu = {
        {
            header = Translations.info.biketitle,
            isMenuHeader = true,
        },
	}
	for i, v in pairs(elements) do
		bikemenu[#bikemenu+1] = {
    	    header = v.label,
    	    txt = "開始您的旅途!",
    	    params = {
    	        event = "bikerental:client:rent",
    	        args = {
    	            type = v.value
    	        }
    	    }
		}
	end
    exports['qb-menu']:openMenu(bikemenu)
end
	
RegisterNetEvent('bikerental:client:rent')
AddEventHandler('bikerental:client:rent', function(Vehicletype)
	if Vehicletype.type == 'gogoro' then
		if Config.EnablePrice then
			TriggerServerEvent("esx:bike:lowmoney_gogoro", Config.PriceGogoro)
		end
	end
end)

function helptext(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("esx:bike:rentSuccess")
AddEventHandler("esx:bike:rentSuccess", function()
	havebike = true
end)