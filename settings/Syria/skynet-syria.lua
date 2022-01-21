SkynetConfig = {
    {
        name = "Syrian IADS",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        radioMenu = true,
        ewPrefix = "EWR",
        samPrefix = "SAM",
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_Aleppo",
                ewr = {"EWR_Kuweires"},
                sam = {"SAM-SA-2-Aleppo", "SAM-SA-3-Aleppo", "SAM-SA-3-Kuweires", "SAM-SA-3-WestAleppo"}
            }, {
                connection = "Node_Latakia",
                ewr = {"EWR_Latakia"},
                sam = {"SAM-SA-2-Latakia", "SAM-SA-3-Jablah", "SAM-SA-3-Latakia"}
            }, {
                connection = "Node_Baniyas",
                ewr = {"EWR_Baniyas"},
                sam = {"SAM-SA-2-Tartus", "SAM-SA-3-Tartus", "SAM-SA-3-ReneMouawad"}
            }, {
                connection = "Node_Hama",
                ewr = {"EWR_Hama"},
                sam = {"SAM-SA-5-Baniyas", "SAM-SA-5-Tartus"}
            }, {
                connection = "Node_Tiyas",
                ewr = {"EWR_Tiyas"},
                sam = {"SAM-SA-2-Tiyas", "SAM-SA-3-Tiyas", "SAM-SA-3-SouthTiyas"}
            }, {
                connection = "Node_Homs",
                ewr = {"EWR_Damascus_North"},
                sam = {
                    "SAM-SA-2-Homs", "SAM-SA-3-Homs", "SAM-SA-3-SouthHoms", "SAM-SA-5-Homs", "SAM-SA-6-Homs",
                    "SAM-SA-6-Shayrat"
                }
            }, {
                connection = "Node_Damascus",
                ewr = {"EWR_Damascus_West", "EWR_Sayqal"},
                sam = {
                    "SAM-SA-2-Marj", "SAM-SA-2-Damascus", "SAM-SA-3-Damascus", "SAM-SA-5-Khalkhalah", "SAM-SA-5-Damascus",
                    "SAM-SA-6-Damascus", "SAM-SA-6-Mezzeh", "SAM-SA-2-Dumayr"
                }
            }, {
                connection = "Node_Thalah",
                ewr = {"EWR_Thalah"},
                sam = {"SAM-SA-2-Thalah"}
            }
        }
    },
    {
        name = "Syrian IADS Light",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        radioMenu = true,
        ewPrefix = "EWR",
        samPrefix = "SAM",
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_Aleppo",
                ewr = {"EWR_Kuweires"},
                sam = {"SAM-SA-2-Aleppo", "SAM-SA-3-Aleppo"}
            }, {
                connection = "Node_Latakia",
                ewr = {"EWR_Latakia"},
                sam = {"SAM-SA-2-Latakia", "SAM-SA-3-Jablah"}
            }, {
                connection = "Node_Baniyas",
                ewr = {"EWR_Baniyas"},
                sam = {"SAM-SA-2-Tartus", "SAM-SA-3-Tartus"}
            }, {
                connection = "Node_Hama",
                ewr = {"EWR_Hama"},
                sam = {"SAM-SA-5-Tartus"}
            }, {
                connection = "Node_Tiyas",
                ewr = {"EWR_Tiyas"},
                sam = {"SAM-SA-2-Tiyas", "SAM-SA-3-SouthTiyas"}
            }, {
                connection = "Node_Homs",
                ewr = {"EWR_Damascus_North"},
                sam = {
                    "SAM-SA-2-Homs", "SAM-SA-3-Homs", "SAM-SA-5-Homs", "SAM-SA-6-Homs"
                }
            }, {
                connection = "Node_Damascus",
                ewr = {"EWR_Damascus_West", "EWR_Sayqal"},
                sam = {
                    "SAM-SA-2-Damascus", "SAM-SA-3-Damascus", "SAM-SA-5-Damascus",
                    "SAM-SA-6-Damascus"
                }
            }, {
                connection = "Node_Thalah",
                ewr = {"EWR_Thalah"},
                sam = {"SAM-SA-2-Thalah"}
            }
        }
    }
}
