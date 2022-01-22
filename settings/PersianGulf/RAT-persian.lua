-- *****************************************************************************
-- *                         RAT settings                                      *
-- *****************************************************************************
RATConfig = {
    {
        name = 'civil',
        enable = true,
        aircrafts_groupconfigs = {
            {
                templatename = 'ETHIAD 320#IFF:7116UN',
                spawns = 1,
                flightlevel = 290,
                speed = 450,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-East'
                    },
                    arrival = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    }
                }
            },
            {
                templatename = 'FED EX #IFF:7316UN',
                spawns = 1,
                flightlevel = 370,
                speed = 500,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-East'
                    },
                    arrival = {
                        AIRBASE.PersianGulf.Abu_Dhabi_International_Airport
                    }
                }
            },
            {
                templatename = 'IRON MAIDEN 747 #IFF:7377UN',
                spawns = 1,
                flightlevel = 335,
                speed = 490,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    },
                    arrival = {
                        'zone-RAT-West'
                    }
                }
            },
            {
                templatename = 'KLM 747 #IFF:3212UN',
                spawns = 1,
                flightlevel = 360,
                speed = 480,
                inactive_timer = 360,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    },
                    arrival = {
                        'zone-RAT-East'
                    }
                }
            },
            {
                templatename = 'Quatar #IFF:2631UN',
                spawns = 1,
                flightlevel = 350,
                speed = 480,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-East'
                    },
                    arrival = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    }
                }
            },
            {
                templatename = 'UPS 737 #IFF:2361UN',
                spawns = 1,
                flightlevel = 310,
                speed = 466,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Abu_Dhabi_International_Airport
                    },
                    arrival = {
                        'zone-RAT-West'
                    }
                }
            },
            {
                templatename = 'EL AL  SP 757 #IFF:1562UN',
                spawns = 1,
                flightlevel = 330,
                speed = 466,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-West'
                    },
                    arrival = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    }
                }
            },
            {
                templatename = 'UAE 380°3 #IFF:3932UN',
                spawns = 1,
                flightlevel = 360,
                speed = 430,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    },
                    arrival = {
                        'zone-RAT-West'
                    }
                }
            },
            {
                templatename = 'Aeroflot A330 #IFF:2251UN',
                spawns = 1,
                flightlevel = 300,
                speed = 500,
                inactive_timer = 340,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Abu_Dhabi_International_Airport
                    },
                    arrival = {
                        'zone-RAT-West'
                    }
                }
            },
            {
                templatename = 'SINGAPOUR A330 #IFF:1582UN',
                spawns = 1,
                flightlevel = 340,
                speed = 515,
                inactive_timer = 500,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.PersianGulf.Abu_Dhabi_International_Airport
                    },
                    arrival = {
                        'zone-RAT-East'
                    }
                }
            },
            {
                templatename = 'CATHAY747#IFF:5156UN',
                spawns = 1,
                flightlevel = 340,
                speed = 515,
                inactive_timer = 500,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-West'
                    },
                    arrival = {
                        'zone-RAT-East'
                    }
                }
            },
        }
    },
    {
        name = 'military',
        enable = true,
        aircrafts_groupconfigs = {
            {
                templatename = 'LUFTWAFE 320 #IFF:5616UN',
                spawns = 1,
                flightlevel = 290,
                speed = 470,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone-RAT-West'
                    },
                    arrival = {
                        AIRBASE.PersianGulf.Dubai_Intl
                    }
                }
            },
        }
    }
}

