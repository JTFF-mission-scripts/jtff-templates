RangeConfig = {
    {
        name = "Akamas",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "North",
                groupsToSpawn = {"Strafe truck  Akamas", "Humvee JTAC Akamas"},
                holdFire = true,
                AI = false
            },
            {
                name = "Center",
                groupsToSpawn = {"Humvee JTAC Akamas-1", "Compound Akamas", "Compound soldat", "Manpad Compound",
                                 "Compound vehicule", "AAA Compound", "Compound vehicule civil", "BTR Compound"},
                holdFire = true,
            },
            {
                name = "Center SAM",
                groupsToSpawn = {"SAM SA6 Akamas"},
                holdFire = false,
            },
            {
                name = "SAM",
                groupsToSpawn = {"SAM SA2 Akamas"},
                holdFire = false
            },
            {
                name = "Mobile Convoy",
                groupsToSpawn = {"Akamas Convoy Mobile"},
                holdFire = true,
            }
        }
    },
    {
        name = "Paphos",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Civilian vehicules",
                groupsToSpawn = {"civil", "civil-1", "civil-2", "civil-3", "civil-4", "civil-5"},
                holdFire = true
            },
            {
                name = "Air defense",
                groupsToSpawn = {"AAA IR Paphos", "Vehicule Paphos"},
                holdFire = false
            },
            {
                name = "Parking Supply",
                groupsToSpawn = {"Infantry Paphos", "SCUD Paphos", "Truck Paphos"},
                AI = false,
                holdFire = true
            },
            {
                name = "Convoy",
                groupsToSpawn = {"Convoy Paphos"},
                holdFire = true
            },
            {
                name = "Roadblock",
                groupsToSpawn = {"Barrage Phalos nord def", "Barrage Phalos nord", "Barrage Phalos Nord est def-1",
                                 "Barrage Phalos Nord est", "Barrage Phalos est", "Barrage Phalos est def",
                                 "Barrage Phalos ouest def", "Barrage Phalos nord ouest"},
                holdFire = true
            }
        }
    },
    {
        name = "Incirlik",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Truck Line",
                groupsToSpawn = {"RANGE °2", "RANGE °2-1"},
                holdFire = true,
                AI = false
            },
            {
                name = "On the road",
                groupsToSpawn = {"Convoy", "Convoy Manpad", "Convoy Manpad-1", "Convoy Manpad-2", "Convoy Manpad-3",
                                 "Convoy Manpad-4", "Convoy Manpad-5"},
                holdFire = true
            }
        }
    },
    {
        name = "SAM Syrian",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Khalkhalah",
                groupsToSpawn = {"SAM SA-11 Khalkhalah"}
            },
            {
                name = "Marj Ruhayyil",
                groupsToSpawn = {"SAM SA-6 Marj Ruhayyil"}
            },
            {
                name = "Damascus",
                groupsToSpawn = {"SAM SA-2 Damascus"}
            },
            {
                name = "Marj North",
                groupsToSpawn = {"SAM SA-11 Marj North"}
            },
            {
                name = "Al-Dumayr",
                groupsToSpawn = {"SAM SA-6 Al-Dumayr", "SAM SA-3 Al-Dumayr"}
            },
            {
                name = "Sayqal",
                groupsToSpawn = {"SAM SA-11 Sayqal"}
            },
            {
                name = "Tabqa",
                groupsToSpawn = {"SAM SA-6 Tabqa", "SAM SA-8 Tabqa", "SA-13 Tabqa", "AAA Tabqa", "Tank Taqba"}
            }
        }
    }
}

TrainingRangeConfig = {
    {
        name = "Akamas",
        enable = true,
        targets = {
            {
                type = "Strafepit",
                unit_name = "Strafe Akamas",
                foul_line = "Foul Line",
                boxlength = 2000,
                boxwidth = 200,
                heading = nil,
                inverseheading = true,
                goodpass = 20
            },
            {
                type = "BombCircle",
                unit_name = "Cercle B Akamas",
                precision = 25
            },
            {
                type = "BombCircle",
                unit_name = "Cercle B Akamas-2",
                precision = 25
            },
            {
                type = "BombCircle",
                unit_name = "Cercle A Akamas",
                precision = 25
            },
            {
                type = "BombCircle",
                unit_name = "Cercle A Akamas-2",
                precision = 25
            }
        }
    },
    {
        name = "Incirlik",
        enable = true,
        targets = {
            {
                type = "Strafepit",
                unit_name = "Range INCIRLIK Target-1",
                foul_line = "Range INCIRLIK Target-3",
                boxlength = 1000,
                boxwidth = 200,
                heading = nil,
                inverseheading = true,
                goodpass = 20
            },
            {
                type = "Strafepit",
                unit_name = "Range INCIRLIK Target-2",
                foul_line = "Range INCIRLIK Target-4",
                boxlength = 1000,
                boxwidth = 200,
                heading = nil,
                inverseheading = true,
                goodpass = 20
            },
            {
                type = "BombCircle",
                unit_name = "Ground-11-1",
                precision = 30
            },
            {
                type = "BombCircle",
                unit_name = "Range INCIRLIK Circle-4",
                precision = 30
            },
            {
                type = "BombCircle",
                unit_name = "Range INCIRLIK Circle-2",
                precision = 50
            },
            {
                type = "BombCircle",
                unit_name = "Range INCIRLIK Circle-1",
                precision = 50
            },
            {
                type = "BombCircle",
                unit_name = "Range INCIRLIK Circle-3",
                precision = 50
            }
        }
    }
}


