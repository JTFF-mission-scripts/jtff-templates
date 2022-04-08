AtisConfig = {
    {
        enable = false,
        airfield = AIRBASE.Syria.Incirlik,
        radio = {
            freq = 270.1,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'ATISRelay-1-1',
            tower = {
                360.1,
                360.2,
                360.3,
                122.1}
        },
        active = {
            number = '05',
            side = 'L'
        },
        tacan = {
            channel = 21
        },
        ils = {
            freq = 109.3,
            runway = '05'
        },
        srs = {
            path = "C:\\SRS"
        }
    }
}
