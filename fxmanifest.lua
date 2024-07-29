fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description "vhs-multijobs - support: discord.gg/CBSSMpmqrK "
author "Bernie"
version '1.0.0'


ui_page 'web/build/index.html'
files {
	'web/build/index.html',
	'web/build/**/*',
}

client_scripts {
  '@PolyZone/client.lua',
  '@PolyZone/CircleZone.lua',
  'src/client/ui.lua',
  'src/client/c_main.lua',
  
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'src/server/s_framework.lua',
  'src/server/s_main.lua',
}
 
shared_scripts {
  '@ox_lib/init.lua',
  'config/config.lua',
  'config/utils.lua',
}

escrow_ignore {
}
