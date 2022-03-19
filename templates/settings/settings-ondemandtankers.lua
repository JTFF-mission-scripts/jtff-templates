OnDemandTankersConfig = {
    --Texaco 3 KC135MPRS
    {
        enable = false,
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
        freq = 317.5,
        modex = 23,
        orbit = {
            heading = 090,
            length = 30,
        },
        callsign = {
            alias = 'Texaco-3',
            name = CALLSIGN.Tanker.Texaco,
            number = 3
        }
    },
}
