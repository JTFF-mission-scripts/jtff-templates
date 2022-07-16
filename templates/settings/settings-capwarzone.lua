WarCAPConfig = {
    {
        enable = false,
        coalitionCAP = coalition.side.RED,
        name = 'Russian Defense',
        debug = false,
        borderZoneGroupName = 'border-russia',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        ewrPrefixes = {
            "EW_RUS",
            "108"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Caucasus.Novorossiysk,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-1",
                        groupForce = 2,
                        groupNumber = 2,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "patrol_Dombass"
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-RU-1",
                        groupForce = 2,
                        groupNumber = 2
                    }
                }
            },
            {
                baseName = AIRBASE.Caucasus.Gelendzhik,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-1",
                        groupForce = 2,
                        groupNumber = 2,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "patrol_South_Russia"
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-RU-1",
                        groupForce = 2,
                        groupNumber = 2
                    }
                }
            },
            {
                baseName = AIRBASE.Caucasus.Anapa_Vityazevo,
                patrolSquadrons = {
                    {
                        enable = false,
                        groupName = "CAP-RU-1",
                        groupForce = 2,
                        groupNumber = 2,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "patrol_Dombass"
                    }
                },
                interceptSquadrons = {
                    {
                        enable = false,
                        groupName = "INT-RU-2",
                        groupForce = 2,
                        groupNumber = 4
                    }
                }
            },
            {
                baseName = AIRBASE.Caucasus.Krasnodar_Center,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-2",
                        groupForce = 4,
                        groupNumber = 6,
                        patrolInAirNumber = 2
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-RU-2",
                        groupForce = 2,
                        groupNumber = 2
                    }
                }
            },
            {
                baseName = AIRBASE.Caucasus.Sochi_Adler,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-2",
                        groupForce = 2,
                        groupNumber = 6,
                        patrolInAirNumber = 2,
                        patrolZoneGroupName = "patrol_South_Russia"
                    }
                },
                interceptSquadrons = {
                    {
                        enable = false,
                        groupName = "INT-RU-2",
                        groupForce = 2,
                        groupNumber = 2
                    }
                }
            },
            {
                baseName = "kusnetsov",
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-3",
                        groupForce = 4,
                        groupNumber = 8,
                        patrolInAirNumber = 2,
                        patrolZoneName = "Patrol_Crimee"
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-RU-3",
                        groupForce = 2,
                        groupNumber = 2
                    }
                }
            }

        },
        skill = 'Excellent',
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    }
}
