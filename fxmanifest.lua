fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description "vhs-multijobs [esx, qbcore, qbox]"
author "VoidHubScripts.com"
version '1.2'

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
}

client_scripts {
  'src/client/ui.lua',
  'src/client/c_main.lua',
  
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'src/server/s_main.lua',
  'config/sv_webhook.lua'
}
 
shared_scripts {
  '@ox_lib/init.lua',
  'config/config.lua',
  'config/utils.lua',
}

