name "qSellCar"
author "qamarq"
contact "qamarq@gmail.com"
version "1.0"

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/main.lua'
}


client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/main.lua'
}

dependencies {
    'FeedM',
    'esx_vehicleshop',
    'es_extended'
}
