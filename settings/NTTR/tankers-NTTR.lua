TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-cal',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.Nellis_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 155,
        altitude = 15000,
        speed = 235,
        tacan = {
            channel = 113,
            morse = 'SHL',
        },
        freq = 276.200,
        fuelwarninglevel = 35,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 476,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-cal',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.Nellis_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 240,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 112,
            morse = 'ARC',
        },
        freq = 276.200,
        fuelwarninglevel = 35,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 345,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-cal',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.Nellis_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO - Drogue',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 300,
        altitude = 23000,
        speed = 365,
        tacan = {
            channel = 111,
            morse = 'TEX',
        },
        freq = 317.500,
        fuelwarninglevel = 35,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 551,
        callsign = {
            alias = 'Texaco1',
            name = CALLSIGN.Tanker.Texaco,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-cal',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'RED TEXACO CAL',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 285,
        altitude = 24000,
        speed = 411,
        tacan = {
            channel = 117,
            morse = 'TX3',
        },
        freq = 318.4,
        fuelwarninglevel = 35,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 113,
        callsign = {
            alias = 'Texaco3',
            name = CALLSIGN.Tanker.Texaco,
            number = 3
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-cal',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'RED ARCO Cal',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 300,
        altitude = 25000,
        speed = 420,
        tacan = {
            channel = 116,
            morse = 'AR3',
        },
        freq = 276.200,
        fuelwarninglevel = 35,
        racetrack = {
            front = 25,
            back = 0
        },
        modex = 309,
        callsign = {
            alias = 'Arco3',
            name = CALLSIGN.Tanker.Arco,
            number = 3
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-west',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'RED ARCO',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 300,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 115,
            morse = 'ARC',
        },
        freq = 276.200,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 321,
        callsign = {
            alias = 'Arco2',
            name = CALLSIGN.Tanker.Arco,
            number = 2
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-west',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'RED TEXACO - Drogue',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 185,
        altitude = 24000,
        speed = 335,
        tacan = {
            channel = 114,
            morse = 'TEX',
        },
        freq = 318.4,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 100,
        callsign = {
            alias = 'Texaco2',
            name = CALLSIGN.Tanker.Texaco,
            number = 2
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-west',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.McCarran_International_Airport,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO4',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 240,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 118,
            morse = 'AR4',
        },
        freq = 276.200,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 516,
        callsign = {
            alias = 'Arco4',
            name = CALLSIGN.Tanker.Arco,
            number = 4
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-tankers-west',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.McCarran_International_Airport,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO4',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 240,
        altitude = 25000,
        speed = 420,
        tacan = {
            channel = 119,
            morse = 'TX4',
        },
        freq = 317.500,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 39,
        callsign = {
            alias = 'Texaco4',
            name = CALLSIGN.Tanker.Texaco,
            number = 4
        }
    }
}

OnDemandTankersConfig = {
    --Shell 2 KC130J
    {
        enable = true,
        type = "sh2",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.McCarran_International_Airport,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL2',
        missionmaxduration = 135,
        altitude = 5000,
        speed = 120,
        tacan = {
            channel = 120,
            morse = 'SH2',
        },
        orbit = {
            heading = 0,
            length = 20,
        },
        freq = 276.200,
        modex = 40,
        callsign = {
            alias = 'Shell2',
            name = CALLSIGN.Tanker.Shell,
            number = 2
        }
    },
}
