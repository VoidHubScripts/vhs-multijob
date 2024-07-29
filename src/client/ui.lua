local function caps(str)
  return (str:gsub("^%l", string.upper))
end

local function fJob(jobList)
  local fJobs = {}
  
  for _, job in ipairs(jobList) do
      local jName = caps(job.name)
      local fJobs = string.format("%s - %s", jName, job.label)
      table.insert(fJobs, { name = job.name, grade = job.grade, label = jName })
  end
  
  return fJobs
end

local function toggleJobs()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = "OPEN" })
  local list = lib.callback.await('vhs-multijob:getJobs', false)
  
  if list then
      local fJobs = fJob(list)
      SendNUIMessage({ action = "UPDATE_STATS", module = "jobs", data = fJobs })
  else
      print("Failed to fetch jobs.")
  end
end

closeJobs = function()
  SetNuiFocus(false, false)
  SendNUIMessage({ event = "UI_STATE", action = "CLOSE" })
end

RegisterNUICallback('LOSE_FOCUS', function(data, cb)
  SetNuiFocus(false, false)
  cb('ok')
end)

RegisterCommand("toggleJobs", function()
  if isUIOpen then
      closeJobs()
  else
    toggleJobs()
  end
end, false)

RegisterKeyMapping("toggleJobs", "Opens Multi-JobS", "keyboard", menuOptions.openUI)

RegisterCommand("closeJobs", function(source, args, rawCommand)
  closeJobs()
end, false)