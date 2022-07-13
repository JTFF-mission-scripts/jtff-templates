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
                                 "Compound vehicule", "AAA Compound", "Compound vehicule civil", "BTR Compound"},
                holdFire = true,
                redAlert = true
            },
            {
                name = "Insurgent PickUp",
                groupsToSpawn = {"Akamas Insurgent PickUp Blue", "Akamas Insurgent PickUp Desert", "Akamas Insurgent PickUp Green"},
                holdFire = true,
                redAlert = false
            }
        }
    }
}
