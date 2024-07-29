
if Framework == 'esx' then ESX = exports["es_extended"]:getSharedObject() else QBCore = exports['qb-core']:GetCoreObject() end


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


lib.callback.register('vhs-multijob:setJob', function(source, job, grade)
    setJob(job, grade)
end)

lib.callback.register('vhs-multijob:removeJob', function(source, jobName)
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
                        else
                    end
                end)
            else
        end
    end)
end)
