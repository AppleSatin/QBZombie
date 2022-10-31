fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_script 'config.lua'
client_script 'client/*.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

escrow_ignore {
    'client/main.lua',
    'config.lua',
    'shared.lua'
}