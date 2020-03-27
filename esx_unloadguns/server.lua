local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('smontaggio:globale')
AddEventHandler('smontaggio:globale', function(ammo, model, table)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

	for k, v in pairs(table) do
        if table.model == model and k == "model" and table.model ~= "WEAPON_PETROLCAN" and table.model ~= "WEAPON_STUNGUN" then
            TriggerClientEvent('eden_accesories:ccc', player)

            xPlayer.removeWeapon(table.model, ammo)
            xPlayer.addInventoryItem(table.item, 1)
            if ammo ~= 0 then
                xPlayer.addInventoryItem('clip', math.floor(ammo/30))
            end
        elseif k == "model" then
            xPlayer.removeWeapon(table.model, ammo)
            xPlayer.addInventoryItem(table.item, 1)
        end
    end
end)

RegisterServerEvent("smonta_armi:registraOggetti")
AddEventHandler("smonta_armi:registraOggetti", function()
    local table = cfg.armi
    if table then
        for k, v in pairs(table) do
            ESX.RegisterUsableItem(table[k].item, function(source)
                local xPlayer = ESX.GetPlayerFromId(source)

                xPlayer.removeInventoryItem(table[k].item, 1)
                xPlayer.addWeapon(table[k].model, 1)

                TriggerClientEvent('esx:showNotification', source, 'Hai equipaggiato '..table[k].label)
            end)
        end
    end
end)
TriggerEvent("smonta_armi:registraOggetti")
