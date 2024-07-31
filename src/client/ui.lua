local function caps(str)
  return (str:gsub("^%l", string.upper))
end

local function dataReact(jobList)
  local fJobs = {}
  
  for _, job in ipairs(jobList) do
      local jName = caps(job.name)
      local reactJobs = string.format("%s - %s", jName, job.label)
      table.insert(fJobs, { name = job.name, grade = job.grade, label = reactJobs })
  end

  return fJobs
end

local function openFob()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = "OPEN" })

  local JobList = lib.callback.await('vhs-multijob:getJobs', false)
  if JobList then
      local reactData = dataReact(JobList)
      SendNUIMessage({ action = "UPDATE_STATS", module = "jobs", data = reactData })
  else
      print("Failed to fetch jobs.")
  end
end

closeFob = function()
  SetNuiFocus(false, false)
  SendNUIMessage({ event = "UI_STATE", action = "CLOSE" })
end

RegisterNUICallback('LOSE_FOCUS', function(data, cb)
  SetNuiFocus(false, false)
  cb('ok')
end)

RegisterCommand("toggleFob", function()
  if isUIOpen then
      closeFob()
  else
      openFob()
  end
end, false)


RegisterKeyMapping("toggleFob", "Toggle Fob", "keyboard", menuOptions.openUI)

RegisterCommand("closefob", function(source, args, rawCommand)
  closeFob()
end, false)