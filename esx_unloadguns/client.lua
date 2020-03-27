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

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    PlayerData = ESX.GetPlayerData()
end)

function openMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'azioni_menu', {
        title = 'Smonta Armi',
        align = 'bottom-right',
        elements = {
            {label = 'Smonta Armi', value = 'azioni'},
        }
    }, function(data, menu)
        local val = data.current.value
        if val == 'azioni' then
            SmontaggioArmi()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function SmontaggioArmi()
    local elements = {}
    local tableArmi = cfg.armi

    for i = 1, #tableArmi do
        local weapon_t = tableArmi[i].model
        local weapon = GetHashKey(weapon_t)
        if HasPedGotWeapon(GetPlayerPed(-1), weapon, false) then
            table.insert(elements, {label = 'Smonta '..tableArmi[i].label, value = tableArmi[i]}) --immagazzinapistola
        end
    end
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'id_card_menu', {
        title = 'Smonta Armi',
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        local table = data.current.value
        local playerPed = GetPlayerPed(-1)

        if playerPed ~= nil then
            menu.close()
            local weaponHash = GetHashKey(table.model)
            local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
            TriggerServerEvent('smontaggio:globale', pedAmmo, table.model, table)
        end
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 178) then
            Citizen.Wait(1000)
            openMenu()
        end
    end
end)
