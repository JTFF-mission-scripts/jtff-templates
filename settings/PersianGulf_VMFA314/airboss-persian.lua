AirBossConfig = {
    {
        enable = true,
        carriername = 'CARRIER Truman 251.750',
        alias = 'truman',
        coalition = 'blue',
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoverytanker = 'nanny-1 #IFF:4775FR',
        recoveryops = {
            mode = 'cyclic',
            cyclic = {
                event_duration_minutes = 60,
                event_ia_reserved_minutes = 5,
            }
        },
        tacan = {
            channel = 75,
            mode = 'X',
            morse = 'HST',
        },
        icls = {
            channel = 15,
            morse = 'HSTLSO',
        },
        freq = {
            base = 127.3,
            marshall = 127.5,
            lso = 127.4
        },
        infintepatrol = true,
        controlarea = 65,
        recoverycase = 1,
        maxpatterns = 5,
        maxstacks = 8,
        difficulty = AIRBOSS.Difficulty.NORMAL,
        menurecovery = {
            enable = true,
            duration = 30,
            windondeck = 30,
            offset = 0,
            uturn = true
        },
        releayunit = {
            marshall = 'Relay Marshall CVN_75',
            lso = 'Relay LSO CVN_75',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    },
    {
        enable = true,
        carriername = 'CARRIER Lincoln 251.850',
        alias = 'lincoln',
        coalition = 'blue',
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoverytanker = 'nanny-2 #IFF:4776FR',
        recoveryops = {
            mode = 'cyclic',
            cyclic = {
                event_duration_minutes = 45,
                event_ia_reserved_minutes = 15,
            }
        },
        tacan = {
            channel = 72,
            mode = 'X',
            morse = 'ABL',
        },
        icls = {
            channel = 12,
            morse = 'ABLLSO',
        },
        freq = {
            base = 127.3,
            marshall = 127.5,
            lso = 127.4
        },
        infintepatrol = true,
        controlarea = 65,
        recoverycase = 1,
        maxpatterns = 5,
        maxstacks = 8,
        difficulty = AIRBOSS.Difficulty.NORMAL,
        menurecovery = {
            enable = true,
            duration = 30,
            windondeck = 30,
            offset = 0,
            uturn = true
        },
        releayunit = {
            marshall = 'Relay Marshall CVN_72',
            lso = 'Relay LSO CVN_72',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    }
}


