fx_version 'cerulean'
game 'gta5'

author 'Apple'
version '1.0.0'

dependencies {
    'PolyZone',
    'qb-target'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'zones.lua',
    'client.lua'
}

server_scripts {
    'server.lua',
}

shared_scripts {
	'config.lua'
}
