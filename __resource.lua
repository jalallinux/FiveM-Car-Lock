
name 'Jl_CarLock'
description 'Simple CarLock System'
author 'JalalLinuX'
version 'v1.0'

shared_script 'config.lua'
client_scripts {
	"@es_extended/locale.lua",
    "client/main.lua"
}

server_scripts {
	"server/main.lua",
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua'
	
}