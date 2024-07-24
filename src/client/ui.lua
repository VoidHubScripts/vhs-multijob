local function capitalizeFirstLetter(str)
  return (str:gsub("^%l", string.upper))
end

local function formatJobData(jobList)
  local formattedJobs = {}
  
  for _, job in ipairs(jobList) do
      local formattedName = capitalizeFirstLetter(job.name)
      local formattedJob = string.format("%s - %s", formattedName, job.label)
      table.insert(formattedJobs, {
          name = job.name,  
          grade = job.grade,
          label = formattedJob
      })
  end
  
  return formattedJobs
end

local function openFob()
  SetNuiFocus(true, true)
  SendNUIMessage({
      action = "OPEN",
  })

  local JobList = lib.callback.await('vhs-multijob:getJobs', false)
  
  if JobList then
      local formattedJobList = formatJobData(JobList)
      
      -- Debugging line
      print("Sending job data: " .. json.encode(formattedJobList))
      
      SendNUIMessage({
          action = "UPDATE_STATS",
          module = "jobs",
          data = formattedJobList
      })
  else
      print("Failed to fetch jobs.")
  end
end

closeFob = function()
  SetNuiFocus(false, false)
  SendNUIMessage({
      event = "UI_STATE",
      action = "CLOSE",
  })
end


SendNUIMessage({
  event = "UI_STATE",
  skills = data,
})


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