fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '2.1'
description '代步車租借'
author 'wise#6666 & spd#9999'

escrow_ignore {
	'translations/en.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

shared_scripts {
	'@qb-core/shared/locale.lua',
	'translations/en.lua',
	'config.lua'
}
