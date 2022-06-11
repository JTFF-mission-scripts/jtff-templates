RangeConfig = {
    {
        name = "Bandar-e-Jask",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "SAM",
                groupsToSpawn = {"Ground-18"},
                holdFire = true,
                AI = false
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
