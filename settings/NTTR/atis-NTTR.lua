AtisConfig = {
    {
        enable = false,
        airfield = AIRBASE.Nevada.Nellis_AFB,
        radio = {
            freq = 270.1,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'Radio Relay Nellis',
            tower = {
                327.000,
                132.550}
        },
        active = {
            number = '03',
            side = 'L'
        },
        tacan = {
            channel = 12
        },
        ils = {
            freq = 109.1,
            runway = '21L'
        },
        srs = {
            path = "C:\\SRS"
        }
    },
    {
        enable = false,
        airfield = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        radio = {
            freq = 113.0,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'Radio Relay Tonopah',
            tower = {
                257.950,
                124.750}
        },
        active = {
            number = '14'
        },
        tacan = {
            channel = 77
        },
        ils = {
            freq = 108.3,
            runway = '14'
        },
        srs = {
            path = "C:\\SRS"
        }
    }
}
