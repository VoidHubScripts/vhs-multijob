
Config = Config or {}

Framework = 'esx' -- esx, qbcore 
Notifications = 'ox_lib'  -- qbcore, esx, ox_lib


menuOptions = { 
  openUI = 'O', 
  maxJobs = 3,
  cooldownTime = 3 -- seconds  
}

allowedJobs = {
  ["police"] = true,
  ["ambulance"] = true,
  ["taxi"] = true,
}