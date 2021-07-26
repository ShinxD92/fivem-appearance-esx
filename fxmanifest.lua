fx_version "cerulean"
game { "gta5" }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'Server/Main.lua'
}

client_scripts {
	'Client/Main.lua',
}

shared_scripts {
	'@es_extended/imports.lua'
}

dependencies {
	'es_extended'
}
