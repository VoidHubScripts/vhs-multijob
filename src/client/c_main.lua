if Framework == 'esx' then ESX = exports["es_extended"]:getSharedObject() else QBCore = exports['qb-core']:GetCoreObject() end


if Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
        ESX.PlayerData = xPlayer
    end)
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        local success = lib.callback.await('vhs-multijob:updateJobs', false, job.name, job.grade, job.grade_label)
    end)
end

if Framework == 'qbcore' then
    local PlayerData = {}
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        local setjob = lib.callback.await('vhs-multijob:updateJobs', false, JobInfo.name, JobInfo.grade.level, JobInfo.grade.name)
    end)
end

RegisterNUICallback('setjob', function(data, cb)
    local setjob = lib.callback.await('vhs-multijob:setJob', false, data.jobName, data.jobGrade)
end)

RegisterNUICallback('deleteJob', function(data, cb)
    local deletejob = lib.callback.await('vhs-multijob:removeJob', false, data.jobName)
end)
