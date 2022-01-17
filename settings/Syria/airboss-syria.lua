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
            marshall = 'MarshallRelay',
            lso = 'LSORelay',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    },
    {
        enable = true,
        carriername = 'CSG-2 CVN-73',
        alias = 'washington',
        coalition = 'blue',
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoveryops = {
            mode = 'alpha',
            cyclic = {
                event_duration_minutes = 90,
                event_ia_reserved_minutes = 15,
            },
            alpha = {
                recoveries = {
                    {
                        recovery_start_minutes = 15,
                        recovery_duration_minutes = 60,
                        recovery_case = 1
                    },
                    {
                        recovery_start_minutes = 105,
                        recovery_duration_minutes = 60,
                        recovery_case = 1
                    },
                    {
                        recovery_start_minutes = 195,
                        recovery_duration_minutes = 60,
                        recovery_case = 1
                    },
                    {
                        recovery_start_minutes = 195+90,
                        recovery_duration_minutes = 60,
                        recovery_case = 1
                    },
                    {
                        recovery_start_minutes = 195+180,
                        recovery_duration_minutes = 60,
                        recovery_case = 1
                    }
                }
            }
        },
        tacan = {
            channel = 73,
            mode = 'X',
            morse = 'WSN',
        },
        icls = {
            channel = 13,
            morse = 'WSNLSO',
        },
        freq = {
            base = 126.3,
            marshall = 126.5,
            lso = 126.4
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
            marshall = 'MarshallRelay-73',
            lso = 'LSORelay-73',
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    }
}


