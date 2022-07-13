TankersConfig = {
    --Shell 1 S3 CVN75
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escort CVN_75 Perry',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CARRIER Truman 251.750',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-1 #IFF:4775FR',
        airboss_recovery = true,
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 104,
            morse = 'SH1',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = 15,
            back = -10
        },
        modex = 102,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 1
        }
    },
    --Shell 2 S3 CVN72
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escort CVN_72 Perry',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CARRIER Lincoln 251.850',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-2 #IFF:4776FR',
        airboss_recovery = true,
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 105,
            morse = 'SH2',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = 15,
            back = -10
        },
        modex = 102,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 2
        }
    },
    --Texaco 1
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'texaco-anchor',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 1-1 #IFF:4274FR',
        airboss_recovery = false,
        missionmaxduration = 180,
        altitude = 25000,
        speed = 420,
        tacan = {
            channel = 101,
            morse = 'TEX',
        },
        racetrack = {
            front = 15,
            back = 15
        },
        fuelwarninglevel = 15,
        freq = 317.5,
        modex = 012,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 1
        }
    }
}


OnDemandTankersConfig = {
}
