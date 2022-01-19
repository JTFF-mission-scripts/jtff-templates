do

    customTazzIADS = SkynetIADS:create('RUSSIAN')

    ---debug settings remove from here on if you do not wan't any output on what the IADS is doing by default
    --local iadsDebug = customTazzIADS:getDebugSettings()
    --iadsDebug.IADSStatus = true
    --iadsDebug.radarWentDark = true
    --iadsDebug.contacts = true
    --iadsDebug.radarWentLive = true
    --iadsDebug.noWorkingCommmandCenter = true
    --iadsDebug.samNoConnection = true
    --iadsDebug.jammerProbability = true
    --iadsDebug.addedEWRadar = true
    --iadsDebug.harmDefence = true
    ---end remove debug ---
---
    customTazzIADS:addSAMSitesByPrefix('SAM1')
    customTazzIADS:addEarlyWarningRadarsByPrefix('EW')

    customTazzIADS:addCommandCenter(StaticObject.getByName('IADS_QG1'))

    customTazzIADS
            :getSAMSiteByGroupName('SAM1 - SA-17M1-2')
            :setActAsEW(false)
            :setHARMDetectionChance(65)
            :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
            :setGoLiveRangeInPercent(60)
    customTazzIADS
            :getSAMSiteByGroupName('SAM1 - SA-17M1-2')
            :addPointDefence(customTazzIADS:getSAMSiteByGroupName('SAM1 - SA-15-1'))
            :setHARMDetectionChance(90)
            :setIgnoreHARMSWhilePointDefencesHaveAmmo(false)
    customTazzIADS
            :getSAMSiteByGroupName('SAM1 - SA-19')
            :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
            :setGoLiveRangeInPercent(70)


    customTazzIADS:setupSAMSitesAndThenActivate()

end
