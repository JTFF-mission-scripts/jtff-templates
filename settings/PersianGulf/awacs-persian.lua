AwacsConfig = {
    {
        enable = true,
        autorespawn = true,
        airspawn = false,
        patternUnit = 'Escorte CSG-1 CVN-71-2',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-1 CVN-2-1',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'WIZARD #IFF:4773FR',
        airboss_recovery = true,
        escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 120,
        altitude = 28000,
        speed = 380,
        freq = 377.800,
        fuelwarninglevel=45,
        racetrack = {
            front = 80,
            back = -20
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
        patternUnit = 'ground-anchor-2',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.PersianGulf.Al_Dhafra_AB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'DARKSTAR #IFF:4772FR',
        airboss_recovery = false,
        escortgroupname = 'F-15C CAP #IFF:7321FR',
        missionmaxduration = 165,
        altitude = 35000,
        speed = 402,
        freq = 265.8,
        fuelwarninglevel=25,
        racetrack = {
            front = 30,
            back = 0
        },
        modex = 11,
        callsign = {
            alias = 'Darkstar',
            name = CALLSIGN.AWACS.Darkstar,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        airspawn = true,
        patternUnit = 'CSG-2 LHA1-5',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-1 CVN-2-2',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'FOCUS #IFF:4775FR',
        airboss_recovery = false,
        escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 120,
        altitude = 29000,
        speed = 380,
        freq = 377.800,
        fuelwarninglevel=45,
        racetrack = {
            front = 80,
            back = -20
        },
        tacan = {
            channel = 99,
            morse = 'FOC',
        },
        modex = 705,
        callsign = {
            alias = 'Focus',
            name = CALLSIGN.AWACS.Focus,
            number = 1
        }
    }
}
