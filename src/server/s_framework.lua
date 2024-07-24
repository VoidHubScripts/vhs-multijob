--[[ 
function AddIllegalMoney(source, amount, reason)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addAccountMoney('black_money', amount, reason)
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local info = { worth = amount }
            xPlayer.Functions.AddItem(vendorOptions.dirtyMoneyItem, 1, false, info)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[vendorOptions.dirtyMoneyItem], 'add', amount)
        end
    end
end
]]

function setJob(job, grade)
    if Framework == 'esx' then
        local player = ESX.GetPlayerFromId(source)
        if ESX.DoesJobExist(job, grade) then 
            player.setJob(job, grade)
        end
    elseif Framework == 'qbcore' then
        local player = QBCore.Functions.GetPlayer(source)
        player.Functions.SetJob(job, grade)
    end
end


function GetPlayerGang(source)
    local data = {}
    if Framework == 'esx' then
        local player = ESX.GetPlayerFromId(source)
        if player then
            local job = player.getJob()
            data.gangName = job.name or 'none'
            data.gangLabel = job.label or 'No Gang'
        else
            print("Player not found for source:", source)
        end
        
    elseif Framework == 'qbcore' then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            data.gangName = player.PlayerData.gang.name or 'none'
            data.gangLabel = player.PlayerData.gang.label or 'No Gang'
        else
            print("Player not found for source:", source)
        end
    end

    return data
end

function RemoveIllegalMoney(source, amount, reason)
    if Framework == 'esx' then
        local player = ESX.GetPlayerFromId(source)
        if player then
            player.removeAccountMoney('black_money', amount)
        end
    elseif Framework == 'qbcore' then
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            local markedBills = player.Functions.GetItemsByName(vendorOptions.dirtyMoneyItem)
            local amountToRemove = amount
            for _, bill in ipairs(markedBills) do
                if amountToRemove <= 0 then
                    break
                end
                local billWorth = bill.info.worth
                print(json.encode(billWorth))
                if billWorth <= amountToRemove then
                    player.Functions.RemoveItem(vendorOptions.dirtyMoneyItem, 1, bill.slot)
                    amountToRemove = amountToRemove - billWorth
                else
                    local newInfo = bill.info
                    newInfo.worth = billWorth - amountToRemove
                    player.Functions.AddItem(vendorOptions.dirtyMoneyItem, 1, false, newInfo)
                    player.Functions.RemoveItem(vendorOptions.dirtyMoneyItem, 1, bill.slot)
                    amountToRemove = 0
                end
            end
        if amountToRemove < amount then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[vendorOptions.dirtyMoneyItem], 'remove')
        end
    end
end
end


function UsableItem(itemName, useFunction)
    if Framework == 'esx' then
        ESX.RegisterUsableItem(itemName, function(playerId)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            useFunction(xPlayer, playerId)  
        end)
    elseif Framework == 'qbcore' then
        QBCore.Functions.CreateUseableItem(itemName, function(source, item)
            local player = QBCore.Functions.GetPlayer(source)
            useFunction(player, source) 
        end)
    end
end


function GetPlayerData(source)
    if Framework == 'esx' then 
        return 
        ESX.GetPlayerFromId(source)
    elseif Framework == 'qbcore' then 
        return QBCore.Functions.GetPlayer(source)
    end 
end   

function GetIdentifier(source)
    if Framework == 'esx' then 
        local xPlayer = GetPlayerData(source)
        if xPlayer then 
            return xPlayer.getIdentifier()
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = GetPlayerData(source)
        if xPlayer then 
            return xPlayer.PlayerData.citizenid 
        end 
    else 
        print('no framework selected')
    end 
    return nil 
end 

function getMoneys(source)
    local data = { cash = 0, illegal = 0 }

    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            data.cash = xPlayer.getMoney()
            data.illegal = xPlayer.getAccount('black_money').money
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            data.cash = xPlayer.PlayerData.money.cash

            local illegal = xPlayer.Functions.GetItemsByName(vendorOptions.dirtyMoneyItem)
            for _, bill in ipairs(illegal) do
                data.illegal = data.illegal + bill.info.worth
            end
        end
    else
        print("unsupported framework")
    end

    return data
end



function AddMoney(source, amount)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addMoney(amount)
        else
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            xPlayer.Functions.AddMoney('cash', amount)
        else
        end
    else
        print("Unsupported framework.")
    end
end

function RemoveMoneys(source, amount)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            xPlayer.removeMoney(amount)
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then 
            xPlayer.Functions.RemoveMoney('cash', amount)
        end 
    else 
    end 
end 

function AddWeapon(source, weaponName)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            xPlayer.addWeapon(weaponName, 1)
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then 
            xPlayer.Functions.AddItem(weaponName, 1)
        end
    else
        print("Unsupported framework in GivePlayerWeapon")
    end
end


function AddItem(source, item, amount)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.canCarryItem(item, amount) then 
            xPlayer.addInventoryItem(item, amount)
        else 
            Notify("error", "Error", 'You cannot carry anymore!', source)
            print('ESX: Inventory full or cannot carry item')
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local added = xPlayer.Functions.AddItem(item, amount)
            if added then
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'add', amount)
            else
                print('QBCore: Inventory full or cannot carry item') 
            end  
        else 
            print('QBCore: Player not found')
        end 
    else 
        print('')
    end 
end




function GetName(source)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            return xPlayer.getPlayerName()
        end 
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local firstName = xPlayer.PlayerData.charinfo.firstname
            local lastName = xPlayer.PlayerData.charinfo.lastname
            return firstName .. ' ' .. lastName
        end
    else 
        print('No framework detected')
    end
    return nil 
end




function GetInventoryItem(source, item)
    if Framework == 'esx' then
        local xPlayer = GetPlayerData(source)
        print(item)
        if xPlayer then
            return xPlayer.getInventoryItem(item)
            
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local qItem = xPlayer.Functions.GetItemByName(item)
            if qItem then 
                return { count = qItem.amount, label = qItem.label }
            end 
        end 
    else
        print("Unsupported framework.")
    end
    return nil
end

function GetItemLabel(item)
    if Framework == 'esx' then
        return ESX.GetItemLabel(item)
    elseif Framework == 'qbcore' then
        if QBCore and QBCore.Shared and QBCore.Shared.Items[item] then
            return QBCore.Shared.Items[item].label
        else
            return item  
        end
    else
        print("Unsupported framework.")
        return item  
    end
end


function RemoveItem(source, item, amount)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then        
            if xPlayer.getInventoryItem(item).count >= amount then
                xPlayer.removeInventoryItem(item, amount)
                return true
            else
                print("Player does not have enough of the item.")
                return false
            end
        else 
            print("Player not found.")
            return false
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
                xPlayer.Functions.RemoveItem(item, amount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove', amount)
                return true
            else
            print("Player not found.")
            return false
        end 
    else 
        print("Set your framework!")
        return false
    end 
end


