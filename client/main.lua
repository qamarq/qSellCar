ESX                           = nil  
  
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(library)
            ESX = library
        end)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('qSellCar:openMenu')
AddEventHandler('qSellCar:openMenu', function()
  if IsPedInAnyVehicle(PlayerPedId()) == false then
    ESX.ShowNotification('Wsiądź do swojego auta')
  else
    local playerPed = GetPlayerPed(-1)
    local vehicle       = GetVehiclePedIsIn(playerPed)
    local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
    local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
    local plate         = vehicleProps.plate
    ESX.TriggerServerCallback('fivem-garages:checkIfVehicleIsOwned', function (owned)
      if owned ~= nil then             
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
          OpenMenu(GetPlayerServerId(closestPlayer), plate)
        end
      else
        ESX.ShowNotification('Nie jesteś właścicielem tego pojazdu')
      end
    end, plate)
  end
end)

RegisterNetEvent('qSellCar:requestClient')
AddEventHandler('qSellCar:requestClient', function(target, plate, price, player)
  OpenRequestMenu(target, plate, price, player)
end)

function OpenMenu(playerId, plate)
  local elements = {
      { label = playerId, value = playerId },

  }	

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloak',
  {
      title    = 'Sprzedaj pojazd',
      align    = 'center',
      elements = elements
  }, function(data, menu)

      if data.current.value ~= nil then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_odznaka_number',
        {
          title = 'Wpisz kwote sprzedaży',
        }, function(data2, menu2)
          local length = string.len(data2.value)
          if data2.value == nil then

            exports['mythic_notify']:SendAlert('error', 'Wpisz cenę!')
          else
            menu2.close()
            TriggerServerEvent('qSellCar:sellRequest', playerId, plate, data2.value)
          end
        end, data.value)
        menu.close()
      end

  end, function(data, menu)
      menu.close()
  end)

end

function OpenRequestMenu(targetName, plate, price, player)
  local elements = {
      { label = 'Zaakceptuj', value = 'accept' },
      { label = 'Odrzuć', value = 'reject' },
  }	

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloak',
  {
      title    = targetName.." chce ci sprzedać pojazd "..plate.." za "..price.."$",
      align    = 'center',
      elements = elements
  }, function(data, menu)

      if data.current.value == "accept" then
        TriggerServerEvent('qSellCar:acceptSell', plate, price, player)
        menu.close()
      end

      if data.current.value == "reject" then
        menu.close()
      end

  end, function(data, menu)
      menu.close()
  end)

end

RegisterNetEvent("qSellCar:sprzedano")
AddEventHandler("qSellCar:sprzedano", function(typek)
  if typek == "seller" then
    local playerPed = GetPlayerPed(-1)
    local vehicle       = GetVehiclePedIsIn(playerPed)
    TaskLeaveVehicle(playerPed, vehicle, 16)
  elseif typek == "source" then
    ExecuteCommand("shuff")
  end
end)
