if Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    ESX = exports["es_extended"]:getSharedObject()
end

RegisterNetEvent('dsco_gift:client:SpawnVehicleGift')
AddEventHandler('dsco_gift:client:SpawnVehicleGift', function(vehicle, plate)
    if Config.Framework == 'QB' then
        local coords = GetEntityCoords(PlayerPedId())
        local model = GetHashKey(Config.vehicle)
        local plate = plate
        QBCore.Functions.SpawnVehicle(model, function(veh)
            SetVehicleNumberPlateText(veh, plate)
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, 100.0) -- Change this to your fuel script
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            SetVehicleEngineOn(veh, true, true)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        end, coords, true)
    elseif Config.Framework == 'ESX' then
        local coords = GetEntityCoords(PlayerPedId())
        local model = GetHashKey(vehicle)

        ESX.Game.SpawnVehicle(model, coords, coords.h, function(veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            SetVehicleNumberPlateText(veh, plate)
            exports['LegacyFuel']:SetFuel(veh, 100.0) -- Change this to your fuel script
            SetVehicleEngineOn(veh, true, true)
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        end)
    end
end)
