AwacsConfig = {
    {
        enable = false,
        autorespawn = true,
        patternUnit = 'Escorte CSG-1 CVN-71-1',
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
        enable = false,
        autorespawn = true,
        patternUnit = 'sea-anchor-1-1',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
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
            front = 55,
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
