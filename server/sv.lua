if Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
end


local function generatePlate()
    if Config.Framework == 'QB' then
        local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
        local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
        if result then
            return generatePlate()
        else
            return plate:upper()
        end
    elseif Config.Framework == 'ESX' then
        local plate = string.upper(ESX.Math.RandomInt(100, 999)) .. ESX.Math.RandomStr(3) .. string.upper(ESX.Math.RandomStr(2))
        local result = MySQL.Sync.fetchScalar('SELECT plate FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate})
        if result then
            return generatePlate()
        else
            return plate
        end
    end
end


RegisterCommand(Config.Command, function(source, args)
    if Config.GiftVehicle and Config.Framework == 'QB' then
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
    elseif Config.GiftVehicle and Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        local vehicle = Config.Vehicle
        local plate = generatePlate()

        local giftStatus = MySQL.Sync.fetchScalar('SELECT gift FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier})

        if giftStatus > 0 then
            TriggerClientEvent('esx:showNotification', source, _U('error_no_repeat'))
            return
        end

        MySQL.Sync.execute('UPDATE users SET gift = 1 WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier})

        MySQL.Sync.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, hash, mods, state) VALUES (@owner, @plate, @vehicle, @hash, @mods, @state)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = plate,
            ['@vehicle'] = vehicle,
            ['@hash'] = GetHashKey(vehicle),
            ['@mods'] = '{}',
            ['@state'] = 1,
        })

        Citizen.Wait(2000)
        TriggerClientEvent('dsco_gift:client:SpawnVehicleGift', source, vehicle, plate)
        print("Gift claimed by: " .. xPlayer.identifier)
        TriggerClientEvent('esx:showNotification', source, _U('info_car_received', { vehicle = vehicle, plate = plate }))
    end
end)