
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


function GetIdentifier(source)
    if Framework == 'esx' then 
        local player = ESX.GetPlayerFromId(source)
        if player then 
            return player.getIdentifier()
        end 
    elseif Framework == 'qbcore' then 
        local player = QBCore.Functions.GetPlayer(source)
        if player then 
            return player.PlayerData.citizenid 
        end 
    else 
        print('no framework selected')
    end 
    return nil 
end 


