
Config = Config or {}

Framework = 'esx' -- esx, qbcore 
Notifications = 'ox_lib'  -- qbcore, esx, ox_lib
Progress = 'ox_lib_circle' -- ox_lib_circle, ox_lib_bar, qbcore
InventoryImagePath = "nui://ox_inventory/web/images/"


menuOptions = { 
  openUI = 'O', 
  maxJobs = 3
}

allowedJobs = {
  ["police"] = true,
  ["ambulance"] = true,
  ["taxi"] = true,
}