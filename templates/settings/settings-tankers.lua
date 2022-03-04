TankersConfig = {
    {
        enable = false,
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
}
