RangeConfig = {
    {
        name = "Akamas",
        enable = false,
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
    }
}

TrainingRangeConfig = {
    {
        name = "Akamas",
        enable = false,
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
                precision = 30
            },
            {
                type = "BombCircle",
                unit_name = "Cercle B Akamas-2",
                precision = 30
            },
            {
                type = "BombCircle",
                unit_name = "Cercle A Akamas",
                precision = 50
            },
            {
                type = "BombCircle",
                unit_name = "Cercle A Akamas-2",
                precision = 50
            }
        }
    }
}
