QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('dsco_gift:client:SpawnVehicleGift')
AddEventHandler('dsco_gift:client:SpawnVehicleGift', function(vehicle, plate)
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
end)
