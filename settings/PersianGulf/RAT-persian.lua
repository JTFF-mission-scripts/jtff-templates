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
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-North'
                    },
                    arrival = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    }
                }
            },
            {
                templatename = 'AirChina 330 #IFF:1563UN',
                spawns = 0,
                flightlevel = 290,
                speed = 468,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone-RAT-North'
                    }
                }
            },
            {
                templatename = 'Cathay 747 #IFF:1564UN',
                spawns = 1,
                flightlevel = 340,
                speed = 460,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone-RAT-SouthEast',
                        'zone-RAT-South'
                    }
                }
            },
            {
                templatename = 'Quantas 747 #IFF:3212UN',
                spawns = 0,
                flightlevel = 310,
                speed = 466,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-North'
                    },
                    arrival = {
                        AIRBASE.MarianaIslands.Saipan_Intl,
                        'zone-RAT-South'
                    }
                }
            },
            {
                templatename = 'DHL 757 #IFF:7316UN',
                spawns = 1,
                flightlevel = 290,
                speed = 470,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone-RAT-North',
                        'zone-RAT-South',
                        'zone-RAT-SouthEast'
                    }
                }
            },
            {
                templatename = 'MEA 320 #IFF:2631UN',
                spawns = 0,
                flightlevel = 360,
                speed = 480,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-SouthEast'
                    },
                    arrival = {
                        AIRBASE.MarianaIslands.Saipan_Intl,
                        'zone-RAT-South'
                    }
                }
            },
            {
                templatename = 'TNT 737°1 #IFF:3242UN',
                spawns = 1,
                flightlevel = 335,
                speed = 490,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone-RAT-North'
                    }
                }
            }
        }
    },
    {
        name = 'military',
        enable = false,
        aircrafts_groupconfigs = {}
    }
}

