AtisConfig = {
    {
        enable = true,
        airfield = AIRBASE.PersianGulf.Al_Dhafra_AB,
        radio = {
            freq = 270.1,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'ATISRelay-1',
            tower = {
                251.1,
                251.2,
                251.3,
                126.5}
        },
        active = {
            number = '13',
            side = 'L'
        },
        tacan = {
            channel = 96
        },
        ils = {
            freq = 111.1,
            runway = '13L'
        },
        srs = {
            path = "C:\\SRS"
        }
    }
}
