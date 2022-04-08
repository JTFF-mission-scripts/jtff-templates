AtisConfig = {
    {
        enable = false,
        airfield = AIRBASE.MarianaIslands.Andersen_AFB,
        radio = {
            freq = 270.1,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'ATISRelay-1-1',
            tower = {
                250.1,
                250.2,
                250.3,
                126.2}
        },
        active = {
            number = '06',
            side = 'L'
        },
        tacan = {
            channel = 54
        },
        ils = {
            freq = 109.30,
            runway = '06L'
        },
        srs = {
            path = "C:\\SRS"
        }
    }
}
