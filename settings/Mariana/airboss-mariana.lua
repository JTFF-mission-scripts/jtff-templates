AirBossConfig = {
    {
        enable = true,
        carriername = 'CSG-1 CVN-71-1',
        alias = 'roosevelt',
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
                event_ia_reserved_minutes = 15,
            }
        },
        tacan = {
            channel = 71,
            mode = 'X',
            morse = 'RSV',
        },
        icls = {
            channel = 11,
            morse = 'RSVLSO',
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
            marshall = 'MarshallRelay-1',
            lso = 'LSORelay-1',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    },
    {
        enable = true,
        carriername = 'CSG-2 LHA1-1-1',
        alias = 'tarawa',
        coalition = 'blue',
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoverytanker = 'nanny-2 #IFF:4776FR',
        recoveryops = {
            mode = 'cyclic',
            cyclic = {
                event_duration_minutes = 60,
                event_ia_reserved_minutes = 5,
            }
        },
        tacan = {
            channel = 51,
            mode = 'X',
            morse = 'TWA',
        },
        icls = {
            channel = 20,
            morse = 'TWALSO',
        },
        freq = {
            base = 251.75,
            marshall = 251.95,
            lso = 251.85
        },
        infintepatrol = true,
        controlarea = 50,
        recoverycase = 1,
        maxpatterns = 5,
        maxstacks = 8,
        difficulty = AIRBOSS.Difficulty.NORMAL,
        menurecovery = {
            enable = true,
            duration = 30,
            windondeck = 15,
            offset = 0,
            uturn = true
        },
        releayunit = {
            marshall = 'MarshallRelay-2',
            lso = 'LSORelay-2',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    }
}


