fx_version 'cerulean'

game 'gta5'

description 'By: DSCO Network.'
version '1.1.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/*.lua',
    'shared.lua'
}

client_script {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'qb-core'
}

lua54 'yes'
