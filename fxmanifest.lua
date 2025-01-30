--------------------------------------
------Created By Whit3Xlightning & Lumen Studios------
--https://github.com/crazy-kol https://github.com/Whit3Xlightning --
--------------------------------------
lua54 'yes'
fx_version 'bodacious'
game 'gta5'

server_script {
    'config.lua',
    'server/server.lua',
    '@ox_lib/init.lua',
}
client_scripts {
    'config.lua',
    'client/client.lua',
    'client/entityiter.lua'
}
lua54 'yes'
dependency 'ox_lib'

