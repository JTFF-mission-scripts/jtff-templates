TankersConfig = {
    --Shell 1 CVN71
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
            morse = 'SH1',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = 40,
            back = -10
        },
        modex = 102,
        callsign = {
            alias = 'Shell1',
            name = CALLSIGN.Tanker.Shell,
            number = 1
        }
    },
    --Shell 2 CVN 73
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'Escorte CSG-1 CVN-73-1',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-1 CVN-2-2',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-2 #IFF:4776FR',
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
        modex = 102,
        callsign = {
            alias = 'Shell2',
            name = CALLSIGN.Tanker.Shell,
            number = 2
        }
    },
    --Shell 7 LHA1
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'CSG-2 LHA1-3',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-1 CVN-2-2',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'nanny-3 #IFF:4777FR',
        airboss_recovery = true,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 106,
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
    --Texaco 2 KC135MPRS
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-1',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 2-1 #IFF:4274FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 135,
        altitude = 25000,
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
    --Arco 6 KC135 Fast
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'sea-anchor-2',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 6-1 #IFF:7541FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 135,
        altitude = 23000,
        speed = 420,
        tacan = {
            channel = 102,
            morse = 'ARC',
        },
        freq = 276.2,
        fuelwarninglevel = 15,
        racetrack = {
            front = 40,
            back = 0
        },
        modex = 015,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 6
        }
    },
    --Shell 3 KC135 Slow
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'ground-anchor-1',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'SHELL 3-1 #IFF:7367FR',
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 105,
        altitude = 15000,
        speed = 230,
        tacan = {
            channel = 103,
            morse = 'SH3',
        },
        freq = 276.2,
        fuelwarninglevel = 15,
        racetrack = {
            front = 15,
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
