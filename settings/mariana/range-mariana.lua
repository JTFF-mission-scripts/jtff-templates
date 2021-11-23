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
