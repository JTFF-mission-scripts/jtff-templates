TrainingCAPConfig = {
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'West',
        patrolZoneName = 'PatrolZoneWest',
        engageZoneName = 'EngageZoneWest',
        CAPGoups = {
            'CAPZone-Tomcats',
            'CAPZone-Phantom',
            'CAPZone-Fulcrum',
            'CAPZone-Viper'
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
