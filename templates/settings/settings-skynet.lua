SkynetConfig = {
    {
        name = "Syrian IADS",
        enable = false,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_Aleppo",
                ewrs = {"EWR_Kuweires"},
                sites = {
                    {
                        sam = "SAM-SA-2-Aleppo",
                    },
                    {
                        sam = "SAM-SA-3-Aleppo",
                    },
                    {
                        sam = "SAM-SA-3-Kuweires",
                    },
                    {
                        sam = "SAM-SA-3-WestAleppo",
                    },
                }
            }, {
                connection = "Node_Latakia",
                ewrs = {"EWR_Latakia"},
                sites = {
                    {
                        sam = "SAM-SA-2-Latakia",
                    },
                    {
                        sam = "SAM-SA-3-Jablah",
                    },
                    {
                        sam = "SAM-SA-3-Latakia",
                    },
                }
            }, {
                connection = "Node_Baniyas",
                ewrs = {"EWR_Baniyas"},
                sites = {
                    {
                        sam = "SAM-SA-2-Tartus",
                    },
                    {
                        sam = "SAM-SA-3-Tartus",
                    },
                    {
                        sam = "SAM-SA-3-ReneMouawad",
                    },
                },
            }, {
                connection = "Node_Hama",
                ewrs = {"EWR_Hama"},
                sites = {
                    {
                        sam = "SAM-SA-5-Baniyas",
                    },
                    {
                        sam = "SAM-SA-5-Tartus",
                    },
                },
            }, {
                connection = "Node_Tiyas",
                ewrs = {"EWR_Tiyas"},
                sites = {
                    {
                        sam = "SAM-SA-2-Tiyas",
                    },
                    {
                        sam = "SAM-SA-3-Tiyas",
                    },
                    {
                        sam = "SAM-SA-3-SouthTiyas",
                    },
                },
            }, {
                connection = "Node_Homs",
                ewrs = {"EWR_Damascus_North"},
                sites = {
                    {
                        sam = "SAM-SA-2-Homs",
                    },
                    {
                        sam = "SAM-SA-3-Homs",
                    },
                    {
                        sam = "SAM-SA-3-SouthHoms",
                    },
                    {
                        sam = "SAM-SA-5-Homs",
                    },
                    {
                        sam = "SAM-SA-6-Homs",
                    },
                    {
                        sam = "SAM-SA-6-Shayrat",
                    },
                },
            }, {
                connection = "Node_Damascus",
                ewrs = {"EWR_Damascus_West", "EWR_Sayqal"},
                sites = {
                    {
                        sam = "SAM-SA-2-Marj",
                    },
                    {
                        sam = "SAM-SA-2-Damascus",
                    },
                    {
                        sam = "SAM-SA-3-Damascus",
                    },
                    {
                        sam = "SAM-SA-5-Khalkhalah",
                    },
                    {
                        sam = "SAM-SA-5-Damascus",
                    },
                    {
                        sam = "SAM-SA-6-Damascus",
                    },
                    {
                        sam = "SAM-SA-6-Mezzeh",
                    },
                    {
                        sam = "SAM-SA-2-Dumayr",
                    },
                },
            }, {
                connection = "Node_Thalah",
                ewrs = {"EWR_Thalah"},
                sites = {
                    {
                        sam = "SAM-SA-2-Thalah",
                    },
                },
            }
        }
    },
    {
        name = "Bassel El Assad IADS",
        enable = false,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Bassel"},
        nodes = {
            {
                connection = "IADS_QG_Bassel",
                ewrs = {"EW_NorthBassel", "EW_SouthBassel"},
                sites = {
                    {
                        sam = "SAM-SA-17M1-Bassel",
                        harmDetectionChance = 65,
                        goLiveRangePercent = 60,
                        pdharmDetectionChance = 90,
                        actAsEw = false,
                        pointDefenses = "SAM-SA-15-PD-Bassel"
                    },
                    {
                        sam = "SAM-SA-19-Bassel",
                        goLiveRangePercent = 70,
                    },
                    "SAM-ShortRange-Bassel",
                },
            }
        }
    }
}
