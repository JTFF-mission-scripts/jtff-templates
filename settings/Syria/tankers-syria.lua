TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escorte CSG-1 CVN-71-1',
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
        patternUnit = 'Escorte CSG-2',
        benefit_coalition = coalition.side.BLUE,
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
            morse = 'SH2',
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
}

OnDemandTankersConfig = {
    --Texaco 3 KC135MPRS
    {
        enable = true,
        type = "tx3",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 3-1 #IFF:4275FR',
        missionmaxduration = 135,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 106,
            morse = 'TX3',
        },
        orbit = {
            heading = 300,
            length = 20,
        },
        freq = 317.5,
        modex = 23,
        callsign = {
            alias = 'Texaco-3',
            name = CALLSIGN.Tanker.Texaco,
            number = 3
        }
    },
    --Arco 7 KC135
    {
        enable = true,
        type = "ar7",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 7-1 #IFF:7542FR',
        missionmaxduration = 135,
        altitude = 23000,
        speed = 420,
        tacan = {
            channel = 107,
            morse = 'AR7',
        },
        orbit = {
            heading = 192,
            length = 40,
        },
        freq = 276.2,
        modex = 029,
        callsign = {
            alias = 'Arco-7',
            name = CALLSIGN.Tanker.Arco,
            number = 7
        }
    },
    --Shell 4 KC135
    {
        enable = true,
        type = "sh4",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL 4-1 #IFF:7377FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 108,
            morse = 'SH4',
        },
        orbit = {
            heading = 087,
            length = 30,
        },
        freq = 276.2,
        modex = 018,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 4
        }
    },
    --Texaco 1 MPRS
    {
        enable = true,
        type = "tx1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 1-1 #IFF:4274FR',
        missionmaxduration = 135,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 101,
            morse = 'TEX',
        },
        orbit = {
            heading = 090,
            length = 30,
        },
        freq = 317.5,
        modex = 012,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 1
        }
    },
    --ARCO 1 KC135
    {
        enable = true,
        type = "ar1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 1-1 #IFF:7541FR',
        missionmaxduration = 135,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 102,
            morse = 'ARC',
        },
        orbit = {
            heading = 090,
            length = 30,
        },
        freq = 276.2,
        modex = 012,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 1
        }
    },
    --ARCO 2 KC135
    {
        enable = true,
        type="ar2",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 2-1 #IFF:7367FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 103,
            morse = 'AR2',
        },
        orbit = {
            heading = 090,
            length = 30,
        },
        freq = 276.2,
        modex = 013,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 2
        }
    }
}
