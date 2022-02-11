TrainingCAPConfig = {
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'West',
        --patrolZoneGroupName = 'CAP zone Red',
        --engageZoneGroupName = 'engage zone Red',
        patrolZoneName = 'red_west_patrol_zone',
        engageZoneName = 'red_west_engage_zone',
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
    },
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'East',
        --patrolZoneGroupName = 'CAP zone Red',
        --engageZoneGroupName = 'engage zone Red',
        patrolZoneName = 'red_east_patrol_zone',
        engageZoneName = 'red_east_engage_zone',
        CAPGoups = {
            'REDNavyCAP-9',
            'REDNavyCAP-10',
            'REDNavyCAP-11',
            'REDNavyCAP-12',
            'REDNavyCAP-13',
            'REDNavyCAP-14',
            'REDNavyCAP-15',
            'REDNavyCAP-16'
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
