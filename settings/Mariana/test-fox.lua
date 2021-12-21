FoxRangesConfig= {
    {
        name = 'East',
        enable = true,
        safeZoneName = 'training-pvp-safezone',
        launchZoneName = 'training-pvp-launchzone',
        debug = false,
        missilemessages = true
    }
}

-- *****************************************************************************
--                     **                FoxZone Training                     **
--                     *********************************************************
FoxRangesArray = {}
compteur = 0
for index, foxzoneconfig in ipairs(FoxRangesConfig) do
    if foxzoneconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Fox Zone : '.. foxzoneconfig.name..'...')
        local objFoxZone = FOX:New()
        objFoxZone.objSafeZone = ZONE:New(foxzoneconfig.safeZoneName)
        objFoxZone.objLaunchZone = ZONE:New(foxzoneconfig.launchZoneName)
        objFoxZone:SetExplosionPower(0.01)
                :SetExplosionDistance(100)
                :AddSafeZone(objFoxZone.objSafeZone)
                :AddLaunchZone(objFoxZone.objLaunchZone)
                :SetDefaultMissileDestruction(true)
                :SetDefaultLaunchAlerts(foxzoneconfig.missilemessages)
                :SetDefaultLaunchMarks(false)
                :SetDefaultMissileDestruction(true)
        if foxzoneconfig.debug then
            objFoxZone:SetDebugOn()
        end
        --function objFoxZone:OnAfterEnterSafeZone(From, Event, To, PlayerData)
        --    self:_AddF10Commands(PlayerData.unitname)
        --    self:AddProtectedGroup(playerData.group)
        --    trigger.action.outText('Fox Zone protect '..playerData.group..' is ENABLED...', 30)
        --end
        --function objFoxZone:OnAfterExitSafeZone(From, Event, To, PlayerData)
        --    trigger.action.outText('Fox Zone protect Exit'..playerData.group..' is DISABLED...', 30)
        --end
        objFoxZone:SetProtectedGroupSet(SET_GROUP:New():FilterPrefixes('REDNavyCAP-9'):FilterStart())
        objFoxZone.menudisabled = false
        objFoxZone.customconfig = foxzoneconfig
        FoxRangesArray[compteur] = objFoxZone
        FoxRangesArray[compteur]:Start()
    end
end

