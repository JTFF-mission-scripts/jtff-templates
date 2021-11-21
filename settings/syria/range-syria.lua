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
                                 "Compound vehicule", "AAA Compound", "Compound vehicule civil", "BTR Compound",
                                 "SAM SA6 Akamas"},
                holdFire = true,
                AI = false
            },
            {
                name = "Training Target",
                groupsToSpawn = {"Cercle Akamas", "Strafe Akamas"},
                holdFire = true,
                AI = false
            },
            {
                name = "SAM",
                groupsToSpawn = {"SAM SA2 Akamas"},
                holdFire = false
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
                groupsToSpawn = {"civil", "civil-1", "civil-2", "civil-3", "civil-4", "civil-5"}
            },
            {
                name = "Air defense",
                groupsToSpawn = {"AAA IR Paphos", "Vehicule Paphos"},
                holdFire = false
            },
            {
                name = "Parking Supply",
                groupsToSpawn = {"Infantry Paphos", "SCUD Paphos", "Truck Paphos"},
                AI = false
            },
            {
                name = "Convoy",
                groupsToSpawn = {"Convoy Paphos"}
            },
            {
                name = "Roadblock",
                groupsToSpawn = {"Barrage Phalos nord def", "Barrage Phalos nord", "Barrage Phalos Nord est def-1",
                                 "Barrage Phalos Nord est", "Barrage Phalos est", "Barrage Phalos est def",
                                 "Barrage Phalos ouest def", "Barrage Phalos nord ouest"}
            }
        }
    },
    {
        name = "Incirlik",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Training Area",
                groupsToSpawn = {"Range INCIRLIK Target", "Range INCIRLIK Soft", "Range INCIRLIK Hard", "Range INCIRLIK JTAC"},
                holdFire = true,
                AI = false
            },
            {
                name = "Truck Line",
                groupsToSpawn = {"RANGE °2", "RANGE °2-1"},
                holdFire = true,
                AI = false
            },
            {
                name = "On the road",
                groupsToSpawn = {"Convoy", "Convoy Manpad", "Convoy Manpad-1", "Convoy Manpad-2", "Convoy Manpad-3",
                                 "Convoy Manpad-4", "Convoy Manpad-5"}
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
