QBCore = exports['qb-core']:GetCoreObject()


local function generatePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result then
        return generatePlate()
    else
        return plate:upper()
    end
end


RegisterCommand(Config.Command, function(source, args)
    if Config.GiftVehicle then
        local src = source
        local vehicle = Config.Vehicle
        local plate = generatePlate()
        local target = QBCore.Functions.GetPlayer(src)

        local giftStatus = MySQL.scalar.await('SELECT gift FROM players WHERE citizenid = ?', { target.PlayerData.citizenid })
        if giftStatus > 0 then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_repeat'))
            return
        end

        MySQL.execute('UPDATE players SET gift = 1 WHERE citizenid = ?', { target.PlayerData.citizenid })

        MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            target.PlayerData.license,
            target.PlayerData.citizenid,
            vehicle,
            GetHashKey(vehicle),
            '{}',
            plate,
            1,
            'pillboxgarage',
        })
        Wait(2000)
        TriggerClientEvent('dsco_gift:client:SpawnVehicleGift', src, vehicle, plate)
        print("Gift claimed by: " ..target.PlayerData.citizenid)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('info.car_received', { vehicle = vehicle, plate = plate }))
    end
end)