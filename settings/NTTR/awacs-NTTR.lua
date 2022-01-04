AwacsConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-focus',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.Nellis_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        groupName = 'Focus',
        airboss_recovery = false,
        missionmaxduration = 180,
        altitude = 31000,
        speed = 400 ,
        freq = 287.45,
        fuelwarninglevel=45,
        racetrack = {
            front = 35,
            back = 0
        },
        modex = 705,
        callsign = {
            alias = 'Focus',
            name = CALLSIGN.AWACS.Focus,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'anchor-wizard',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Nevada.Tonopah_Test_Range_Airfield,
        terminalType = AIRBASE.TerminalType.OpenBig,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        groupName = 'Wizard',
        airboss_recovery = false,
        missionmaxduration = 180,
        altitude = 32000,
        speed = 401,
        freq = 286.45,
        fuelwarninglevel=25,
        racetrack = {
            front = 135,
            back = 0
        },
        modex = 706,
        callsign = {
            alias = 'Wizard',
            name = CALLSIGN.AWACS.Wizard,
            number = 1
        }
    }
}
