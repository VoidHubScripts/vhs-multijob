
if Framework == 'esx' then ESX = exports["es_extended"]:getSharedObject() else QBCore = exports['qb-core']:GetCoreObject() end

function logDiscord(title, message, color)
    local data = { username = "vhs-multijobs", avatar_url = "https://i.imgur.com/E2Z3mDO.png", embeds = { { ["color"] = color, ["title"] = title, ["description"] = message, ["footer"] = { ["text"] = "Installation Support - [ESX, QBCore Qbox] -  https://discord.gg/CBSSMpmqrK" },} }} PerformHttpRequest(WebhookConfig.URL, function(err, text, headers) end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end

function setJob(source, job, grade)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if ESX.DoesJobExist(job, grade) then 
            xPlayer.setJob(job, grade)
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.SetJob(job, grade)
    end
end

function getJob(source)
    local data = { jobName = 0, jobGrade = 0 }
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getJob() then 
            data.jobName = xPlayer.getJob().name
            data.jobGrade = xPlayer.getJob().grade
        end 
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            data.jobName = xPlayer.PlayerData.job.name
            data.jobGrade = xPlayer.PlayerData.job.grade.level
        end
    end
    return data
end

function getName(source)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            return xPlayer.getName()
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local firstName = xPlayer.PlayerData.charinfo.firstname
            local lastName = xPlayer.PlayerData.charinfo.lastname
            return firstName .. ' ' .. lastName
        end
    else 
        print('no frame')
    end
    return nil 
end 

function GetIdentifier(source)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then 
            return xPlayer.getIdentifier()
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then 
            return xPlayer.PlayerData.citizenid 
        end 
    end 
    return nil 
end 

lib.callback.register('vhs-multijob:updateJobs', function(source, newJob, jobGrade, gradeLabel)
    local identifier = GetIdentifier(source)

    if not allowedJobs[newJob] then
        return false
    end

    local currentJobs = MySQL.query.await('SELECT jobs FROM vhs_multijob WHERE identifier = ?', {identifier})
    local jobList = {}
    if currentJobs[1] and currentJobs[1].jobs then
        jobList = json.decode(currentJobs[1].jobs) or {}
    end

    if #jobList >= menuOptions.maxJobs then
        return false
    end

    local jobExists = false
    for _, job in ipairs(jobList) do
        if job.name == newJob then
            jobExists = true
            break
        end
    end

    if not jobExists then
        table.insert(jobList, { name = newJob, grade = jobGrade, label = gradeLabel })
    end
    local success = MySQL.update.await('REPLACE INTO vhs_multijob (identifier, jobs) VALUES (?, ?)', { identifier, json.encode(jobList) })
    return success
end)

function table.contains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

lib.callback.register('vhs-multijob:getJobs', function(source)
    local identifier = GetIdentifier(source)
    local currentJobs = MySQL.query.await('SELECT jobs FROM vhs_multijob WHERE identifier = ?', {identifier})
    local jobList = {}
    if currentJobs[1] and currentJobs[1].jobs then
        jobList = json.decode(currentJobs[1].jobs) or {}
    end
    return jobList
end)

lib.callback.register('vhs-multijob:setJob', function(source, job, grade, label)
    local pJob = getJob(source)
    if pJob.jobName == job and pJob.jobGrade == grade then
        Notify("error", 'Failed to Set Job', "You already have this job and grade.", source)
        return false
    else
        Notify("success", 'Job Updated', label, source)
        setJob(source, job, grade)
        local message = string.format("**%s switched to job: %s **", getName(source), label)
        logDiscord("Job Update", message, 1742028)
        return true
    end
end)

lib.callback.register('vhs-multijob:removeJob', function(source, jobName, jobLabel)
    local identifier =  GetIdentifier(source) 
    MySQL.Async.fetchAll('SELECT jobs FROM vhs_multijob WHERE identifier = @identifier', { ['@identifier'] = identifier}, function(results)
        if results[1] and results[1].jobs then
            local jobs = json.decode(results[1].jobs)
            local updatedJobs = {}
            for i, job in ipairs(jobs) do
                if job.name ~= jobName then
                    table.insert(updatedJobs, job)
                end
            end
            MySQL.Async.execute('UPDATE vhs_multijob SET jobs = @jobs WHERE identifier = @identifier', { ['@jobs'] = json.encode(updatedJobs), ['@identifier'] = identifier }, function(affectedRows)
                if affectedRows > 0 then
                    Notify("error", "Removed", jobLabel.. ' has been removed!', source)
                    local message = string.format("**%s removed job: %s **", getName(source), jobLabel)
                    logDiscord("Job Removed", message, 9576479)
                    end
                end)
            else
        end
    end)
end)
