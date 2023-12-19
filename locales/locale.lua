local Translations = {
    error = {
    no_repeat = 'You cannot use this command again, because you have already claimed this gift.'
    },
    info = {
        car_received = 'Enjoy your welcome car. - Model: %{vehicle} - Plate: %{plate}',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})