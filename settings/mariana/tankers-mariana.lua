TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'CSG-1 Escorte-5',
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
        patternUnit = 'CSG-2 LHA1-1-3',
        baseUnit = 'CSG-1 CVN-2-1',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-2 #IFF:4776FR',
        airboss_recovery = true,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 105,
            morse = 'SH7',
        },
        freq = 264.350,
        fuelwarninglevel = 35,
        racetrack = {
            front = 30,
            back = -10
        },
        modex = 105,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 7
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-2-1',
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 2-1 #IFF:4274FR',
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
            front = 40,
            back = 0
        },
        modex = 012,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 2
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-3-1',
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 6-1 #IFF:7541FR',
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
        modex = 015,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 6
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-4-1',
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL 3-1 #IFF:7367FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 103,
            morse = 'SHK',
        },
        freq = 276.2,
        fuelwarninglevel = 15,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 016,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 3
        }
    }
}
