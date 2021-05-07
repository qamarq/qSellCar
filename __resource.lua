name "qSellCar"
author "qamarq"
contact "qamarq@gmail.com"
version "1.0"

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}


client_scripts {
    'config.lua',
    'client/main.lua'
}

depedency {
    'FeedM',
    'esx_vehicleshop'
}
