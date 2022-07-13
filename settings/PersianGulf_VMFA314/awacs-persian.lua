AwacsConfig = {
    {
        enable = true,
        autorespawn = true,
        airspawn = false,
        patternUnit = 'Escort CVN_75 Perry',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CARRIER Truman 251.750',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'WIZARD #IFF:4773FR',
        airboss_recovery = true,
        missionmaxduration = 180,
        altitude = 28000,
        speed = 380,
        freq = 377.800,
        fuelwarninglevel=45,
        racetrack = {
            front = 15,
            back = 0
        },
        tacan = {
            channel = 100,
            morse = 'WZD',
        },
        modex = 705,
        callsign = {
            alias = 'Wizard',
            name = CALLSIGN.AWACS.Wizard,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        airspawn = false,
        patternUnit = 'awacs-anchor',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'DARKSTAR #IFF:4772FR',
        airboss_recovery = false,
        missionmaxduration = 240,
        altitude = 35000,
        speed = 402,
        freq = 265.8,
        fuelwarninglevel=25,
        racetrack = {
            front = 15,
            back = 0
        },
        modex = 11,
        callsign = {
            alias = 'Darkstar',
            name = CALLSIGN.AWACS.Darkstar,
            number = 1
        }
    }
}
