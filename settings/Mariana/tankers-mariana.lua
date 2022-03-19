TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'CSG-1 Escorte-5',
        benefit_coalition = coalition.side.BLUE,
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
        benefit_coalition = coalition.side.BLUE,
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
}

OnDemandTankersConfig = {
    {
        enable = true,
        type = "tx2",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 2-1 #IFF:4274FR',
        missionmaxduration = 135,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 101,
            morse = 'TEX',
        },
        orbit = {
            heading = 90,
            length = 50,
        },
        freq = 317.5,
        modex = 012,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 2
        }
    },
    -- ARCO 6 - KC135
    {
        enable = true,
        type = "ar6",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 6-1 #IFF:7541FR',
        missionmaxduration = 135,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 102,
            morse = 'ARC',
        },
        orbit = {
            heading = 21,
            length = 40,
        },
        freq = 276.2,
        modex = 015,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 6
        }
    },
    -- SHEL 3 - KC135
    {
        enable = true,
        type = "sh3",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL 3-1 #IFF:7367FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 103,
            morse = 'SHK',
        },
        orbit = {
            heading = 090,
            length = 50,
        },
        freq = 276.2,
        modex = 016,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 3
        }
    }
}
