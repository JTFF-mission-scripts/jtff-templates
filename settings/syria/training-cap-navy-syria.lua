TrainingCAPConfig = {
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'North_Turkey',
        --patrolZoneGroupName = 'CAP zone Red',
        --engageZoneGroupName = 'engage zone Red',
        patrolZoneName = 'red_north_patrol_zone',
        engageZoneName = 'red_north_engage_zone',
        CAPGoups = {
            'REDNavyCAP-1',
            'REDNavyCAP-2',
            'REDNavyCAP-3',
            'REDNavyCAP-4',
            'REDNavyCAP-5',
            'REDNavyCAP-6',
            'REDNavyCAP-7',
            'REDNavyCAP-8'
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
