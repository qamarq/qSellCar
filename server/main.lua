TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('contract', function(source)
	TriggerClientEvent('qSellCar:openMenu', source)
end)

RegisterNetEvent('qSellCar:sellRequest')
AddEventHandler('qSellCar:sellRequest', function(target, plate, price)
    TriggerClientEvent('qSellCar:requestClient', target, ESX.GetPlayerFromId(target).name, plate, price, source)
end)

RegisterNetEvent('qSellCar:acceptSell')
AddEventHandler('qSellCar:acceptSell', function(plate, price, seller)
  local _source = source
  local sellerXPlayer = ESX.GetPlayerFromId(seller)
  local sourceXPlayer = ESX.GetPlayerFromId(_source)
	if sourceXPlayer.getMoney() >= price then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate',
            {
                ['@plate'] = plate
            },
            function(result)
                if result[1] ~= nil then
                  
                    local ownerIdentifier = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
                    local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
        
                    if ownerIdentifier == sellerXPlayer.identifier then
                      data = {}
                
		      TriggerClientEvent("FeedM:showNotification", _source, _U('bought_vehicle', plate, sellerXPlayer.name), 5000)
                      sourceXPlayer.removeMoney(price)
                      sellerXPlayer.addMoney(price)     
                      MySQL.Sync.execute("UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = sourceXPlayer.identifier, ['@plate'] = plate})           
                      TriggerClientEvent("FeedM:showNotification", seller, "Sprzedałeś pojazd ~y~"..plate.."~s~ dla ~r~"..sourceXPlayer.name, 5000)   
		      TriggerClientEvent("FeedM:showNotification", seller, _U('sold_vehicle', plate, sourceXPlayer.name), 5000)   
                      TriggerClientEvent("qSellCar:sprzedano", seller, "seller")          
                      Citizen.Wait(500)
                      TriggerClientEvent("qSellCar:sprzedano", _source, "source")
                    else
                        TriggerClientEvent("FeedM:showNotification", seller, _U('not_owner'), 5000)
                    end
                else
                    TriggerClientEvent("FeedM:showNotification", seller, _U('vehicle_not_exist'), 5000)
                end
            
            end
        )
    else
        TriggerClientEvent("FeedM:showNotification", seller, _U('buyer_cannot_afford'), 5000)
        TriggerClientEvent("FeedM:showNotification", source, _U('not_money'), 5000)
    end
end)
