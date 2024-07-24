function GetPlayerJob(source)
    if Framework == 'esx' then
        return ESX.PlayerData.job and ESX.PlayerData.job.name or '?'

    elseif Framework == 'qbcore' then
        local playerData = QBCore.Functions.GetPlayerData(source)
        return playerData.job and playerData.job.name or '?'
    else
        print("Unsupported framework")
        return 'unemployed'
    end
end

function getPlayerData()
    if Framework == 'esx' then
        return ESX.GetPlayerData()
    elseif Framework == 'qbcore' then
        return QBCore.Functions.GetPlayerData()
    else
        print("unsupported framework in ")
        return nil
    end
end

function HasItem(item, count)
    print("Checking item:", item, "Count:", count)

    if Framework == 'esx' then
        local success, inventoryItem = pcall(ESX.SearchInventory, item, true)
        if not success then
            print("Error calling SearchInventory")
            return false
        end

        if inventoryItem == nil then
            print("Item not found in inventory")
            return false
        end
        
        print("SearchInventory result:", inventoryItem)

        -- Check if the inventoryItem is valid and contains the count field
        if type(inventoryItem) == "number" then
            print("Item found. Count: ", inventoryItem)
            return inventoryItem >= count
        elseif type(inventoryItem) == "table" and inventoryItem.count then
            print("Item found. Table count: ", inventoryItem.count)
            return inventoryItem.count >= count
        else
            print("Item found but count is not valid")
            return false
        end
    elseif Framework == 'qbcore' then
        local itemData = QBCore.Functions.HasItem(item)
        return itemData and itemData.count >= count or false
    else
        print("Unsupported framework")
    end

    return false
end


function SpawnVehicle(vehicleName, coords, heading, callback)
    local spawnVehicleFunction = function()
        local vehicleModel = GetHashKey(vehicleName)
        RequestModel(vehicleModel)
        while not HasModelLoaded(vehicleModel) do
            Wait(1)
        end
        local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, heading, true, false)
        local plate = GeneratePlate()  
        SetVehicleNumberPlateText(vehicle, plate)
        SetEntityAsMissionEntity(vehicle, true, true)
        if callback then
            callback(vehicle, plate) 
        end
    end
    if Framework == 'esx' then
        if ESX.Game.IsSpawnPointClear(coords, 5) then 
            spawnVehicleFunction()
        else
            Notify("error", "Error", Config.Lang["notify_spawn_blocked"])
        end
    elseif Framework == 'qbcore' then
        local closestVehicle, distance = QBCore.Functions.GetClosestVehicle(coords)
        if closestVehicle == 0 or distance > 5 then
            spawnVehicleFunction()
        else
            Notify("error", "Error", Config.Lang["notify_spawn_blocked"])
        end
    else
        print("Unsupported framework")
    end
end

function GeneratePlate()
    local plate = ""
    local possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, 8 do
        plate = plate .. possibleCharacters:sub(math.random(1, #possibleCharacters), 1)
    end
    return plate
end


