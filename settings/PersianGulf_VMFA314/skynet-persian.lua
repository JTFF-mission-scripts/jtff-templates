SkynetConfig = {
    {
        name = "Iranian IADS",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_West_Iran",
                ewrs = {"EW_FAR"},
                sites = {
                    {
                        sam = "SAM Lavan SA10",
                        goLiveRangePercent = 80,
                        pointDefenses = "SAM Iran SA15 Protection SA10"
                    },
                    {
                        sam = "SAM Kish SA11",
                    },
                    {
                        sam = "SAM Sirri SA6",
                    },
                    {
                        sam = "SAM Abu Musa SA2",
                        goLiveRangePercent = 60,
                    }
                },
            }, {
                connection = "Node_North_Iran",
                ewrs = {"EW_NORTH"},
                sites = {
                    {
                        sam = "SAM Iran SA20",
                        goLiveRangePercent = 50,
                        pointDefenses = "SAM Iran SA15 Protection SA20"
                    },
                    {
                        sam = "SAM Havadarya SA2",
                    },
                    {
                        sam = "SAM Bandar Abbas SA5",
                        goLiveRangePercent = 80,
                    },
                    {
                        sam = "SAM Bandar Abbas Hawk",
                    }
                },
            }, {
                connection = "Node_Est_Iran",
                ewrs = {"EW_EST"},
                sites = {
                    {
                        sam = "SAM Seerik SA17",
                        goLiveRangePercent = 90,
                    }
                },
            }
        }
    },
    {
        name = "Iranian IADS Light",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_West_Iran",
                ewrs = {"EW_FAR"},
                sites = {
                    {
                        sam = "SAM Lavan SA10",
                        goLiveRangePercent = 80,
                        pointDefenses = "SAM Iran SA15 Protection SA10"
                    },
                    {
                        sam = "SAM Kish SA11",
                    }
                },
            }, {
                connection = "Node_North_Iran",
                ewrs = {"EW_NORTH"},
                sites = {
                    {
                        sam = "SAM Havadarya SA2",
                    },
                    {
                        sam = "SAM Bandar Abbas SA5",
                        goLiveRangePercent = 80,
                    },
                    {
                        sam = "SAM Bandar Abbas Hawk",
                    }
                },
            }, {
                connection = "Node_Est_Iran",
                ewrs = {"EW_EST"},
                sites = {
                    {
                        sam = "SAM Seerik SA17",
                        goLiveRangePercent = 90,
                    }
                },
            }
        }
    }
}
