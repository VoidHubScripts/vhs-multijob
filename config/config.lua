
Config = Config or {}

Framework = 'qbcore' -- esx, qbcore 
Notifications = 'ox_lib'  -- qbcore, esx, ox_lib

menuOptions = { 
  openUI = 'O', 
  maxJobs = 3,  --[[ Max amount of jobs a player can have in the job menu at a time ]] 
}

allowedJobs = {
  ["police"] = true,
  ["ambulance"] = true,
  ["taxi"] = true,
  -- add more if needed 
}