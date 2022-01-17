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
        objFoxZone:SetExplosionPower(0.01)
                  :SetExplosionDistance(100)
                  :SetExplosionDistanceBigMissiles(150)
                  :SetDefaultMissileDestruction(foxzoneconfig.missileDestruction)
                  :SetDefaultLaunchAlerts(foxzoneconfig.missileLaunchMessages)
                  :SetDefaultLaunchMarks(false)
        if foxzoneconfig.launchZoneGroupName then
            objFoxZone.objLaunchZone = ZONE_POLYGON:New(
                    'FOX_LAUNCH_ZONE_'..foxzoneconfig.name,
                    GROUP:FindByName(foxzoneconfig.launchZoneGroupName))
            objFoxZone:AddLaunchZone(objFoxZone.objLaunchZone)
            env.info('Fox Zone : Launch zone Polygon created : '.. objFoxZone.objLaunchZone:GetName() ..'...')
        else
            if foxzoneconfig.launchZoneName then
                objFoxZone.objLaunchZone = ZONE:New(foxzoneconfig.launchZoneName)
                objFoxZone:AddLaunchZone(objFoxZone.objLaunchZone)
            end
        end
        if foxzoneconfig.safeZoneGroupName then
            objFoxZone.objSafeZone = ZONE_POLYGON:New(
                    'FOX_SAFE_ZONE_'..foxzoneconfig.name,
                    GROUP:FindByName(foxzoneconfig.safeZoneGroupName))
            objFoxZone:AddSafeZone(objFoxZone.objSafeZone)
            env.info('Fox Zone : Safe zone Polygon created : '.. objFoxZone.objSafeZone:GetName() ..'...')
        else
            if foxzoneconfig.safeZoneName then
                objFoxZone.objSafeZone = ZONE:New(foxzoneconfig.safeZoneName)
                objFoxZone:AddSafeZone(objFoxZone.objSafeZone)
            end
        end
        if foxzoneconfig.debug then
            objFoxZone:SetDebugOn()
        end
        objFoxZone.menudisabled = foxzoneconfig.f10Menu == false
        objFoxZone:SetDisableF10Menu(objFoxZone.menudisabled)
        objFoxZone.customconfig = foxzoneconfig

        -- **** Message to client *****
        function objFoxZone:OnAfterEnterSafeZone(From, Event, To, player)
            local message = '[' .. player.name .. '] You\'re entering in the missile trainer area ' .. foxzoneconfig.name
            MESSAGE:NewType(message, MESSAGE.Type.Overview):ToClient(player.client)
        end

        function objFoxZone:OnAfterExitSafeZone(From, Event, To, player)
            local message = '[' .. player.name .. '] You\'re leaving the missile trainer area ' .. foxzoneconfig.name
            MESSAGE:NewType(message, MESSAGE.Type.Overview):ToClient(player.client)
        end

        function objFoxZone:OnAfterMissileDestroyed(From, Event, To, missile)
            local unitTargeted = missile.targetUnit -- #Wrapper.Unit#UNIT
            local playerTargeted = missile.targetPlayer -- #FOX.PlayerData
            local unitShooter = missile.shooterUnit -- #Wrapper.Unit#UNIT
            local missileType = missile.missileType -- string
            local missileName = missile.missileName -- string

            local playerNameTargeted = playerTargeted.name -- string
            local clientShooter = CLIENT:Find(unitShooter:GetDCSObject(), '', false)
            local message = ''
            if (clientShooter) then
                local playerNameShooter = clientShooter:GetPlayerName()
                message = playerNameTargeted .. ' HAVE BEEN SHOOT BY ' .. playerNameShooter
            else
                message = playerNameTargeted .. ' HAVE BEEN SHOOT BY ' .. unitShooter:GetName()
            end
            debug_msg(message)
            Set_CLIENT:ForEachClientInZone(objFoxZone.objSafeZone, function(clientInZone)
                if clientInZone:IsAlive() then
                    MESSAGE:NewType(message, MESSAGE.Type.Update):ToClient(clientInZone)
                end
            end)
        end
        -- *****************************

        FoxRangesArray[compteur] = objFoxZone
        FoxRangesArray[compteur]:Start()
    end
end
