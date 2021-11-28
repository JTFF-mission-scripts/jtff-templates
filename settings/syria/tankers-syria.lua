TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escorte CSG-1 CVN-71-1',
        baseUnit = 'CSG-1 CVN-2-1',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-1 #IFF:4775FR',
        airboss_recovery = true,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 104,
            morse = 'SHL',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = -10
        },
        modex = 102,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escorte CSG-2',
        baseUnit = 'CSG-1 CVN-2-1',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nounou #IFF:4776FR',
        airboss_recovery = true,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 105,
            morse = 'SHL',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = -10
        },
        modex = 103,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 2
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-2-1',
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 1-1 #IFF:4274FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 135,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 101,
            morse = 'TEX',
        },
        freq = 317.5,
        fuelwarninglevel = 15,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 012,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'ground-anchor-1-1',
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 1-1 #IFF:7541FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 135,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 102,
            morse = 'ARC',
        },
        freq = 276.2,
        fuelwarninglevel = 15,
        racetrack = {
            front = 55,
            back = 0
        },
        modex = 012,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor--3-1',
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 2-1 #IFF:7367FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 103,
            morse = 'ARK',
        },
        freq = 276.2,
        fuelwarninglevel = 15,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 013,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 2
        }
    }
}
