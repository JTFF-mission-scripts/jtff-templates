-- *****************************************************************************
-- *                         RAT settings                                      *
-- *****************************************************************************
RATConfig = {
    {
        name = 'civil',
        enable = false,
        aircrafts_groupconfigs = {
            {
                templatename = 'EL AL  757 #IFF:1562UN',
                spawns = 1,
                flightlevel = 330,
                speed = 480,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-Gazipasa'
                    },
                    arrival = {
                        AIRBASE.Syria.Beirut_Rafic_Hariri
                    }
                }
            },
        }
    },
    {
        name = 'military',
        enable = false,
        aircrafts_groupconfigs = {}
    }
}
