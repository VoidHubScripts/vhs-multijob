local function caps(str)
  return (str:gsub("^%l", string.upper))
end

local function format(jobList)
  local reactData = {}
  for _, job in ipairs(jobList) do
      local Job = string.format("%s - %s", caps(job.name), job.label)
      table.insert(reactData, { name = job.name, grade = job.grade, label = Job })
  end
  return reactData
end

local function openJobs()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = "OPEN" })
  local JobList = lib.callback.await('vhs-multijob:getJobs', false)
  if JobList then
      local jobs = format(JobList)
      SendNUIMessage({ action = "UPDATE_STATS", module = "jobs", data = jobs })
  else
  end
end

closeJobs = function()
  SetNuiFocus(false, false)
  SendNUIMessage({
      event = "UI_STATE",
      action = "CLOSE",
  })
end

RegisterCommand("toggleFob", function()
  if isUIOpen then
    closeJobs()
  else
    openJobs()
  end
end, false)

RegisterNUICallback('LOSE_FOCUS', function(data, cb)
  SetNuiFocus(false, false)
  cb('ok')
end)

RegisterKeyMapping("toggleFob", "Toggle Fob", "keyboard", menuOptions.openUI)
