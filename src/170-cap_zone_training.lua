-- *****************************************************************************
--                     **                CAPZone Training                     **
--                     *********************************************************
CAPZoneArray = {}
compteur = 0
MenuCoalitionCAPZoneBlue = MENU_COALITION:New(coalition.side.BLUE, "Hostile CAP Zones", MenuCoalitionBlue)
MenuCoalitionCAPZoneRed = MENU_COALITION:New(coalition.side.RED, "Hostile CAP Zones", MenuCoalitionRed)
for index, capzoneconfig in ipairs(TrainingCAPConfig) do
    if capzoneconfig.enable == true then
        compteur = compteur + 1
        env.info('creation CAP Zone : '.. capzoneconfig.name..'...')
        objCapZone = {}
        objCapZone.objSpawn = SPAWN:New(capzoneconfig.CAPGoups[1])
                                   :InitSkill(capzoneconfig.skill)
                                   :InitRandomizeTemplate(capzoneconfig.CAPGoups)
                                   :OnSpawnGroup(function(SpawnGroup)
            SpawnGroup:OptionROE(ENUMS.ROE.OpenFireWeaponFree)
            SpawnGroup:OptionROT(ENUMS.ROT.EvadeFire)
            SpawnGroup:OptionRTBBingoFuel(false)
            --if math.random(0,100) > 50 then
            --    SpawnGroup:OptionAAAttackRange(AI.Option.Air.val.MISSILE_ATTACK.MAX_RANGE)
            --else
            --    SpawnGroup:OptionAAAttackRange(AI.Option.Air.val.MISSILE_ATTACK.HALF_WAY_RMAX_NEZ)
            --end
            SpawnGroup:OptionRestrictBurner(false)
            SpawnGroup:OptionECM_OnlyLockByRadar()
            SpawnGroup:EnableEmission(true)
            SpawnGroup:OptionAlarmStateRed()
        end)
        if capzoneconfig.patrolZoneGroupName then
            objCapZone.objPatrolZone = ZONE_POLYGON:New(
                    'CAP_PATROL_ZONE_'..capzoneconfig.name,
                    GROUP:FindByName(capzoneconfig.patrolZoneGroupName))
            env.info('Training CAP : Patrol zone Polygon created : '.. objCapZone.objPatrolZone:GetName() ..'...')
        else
            if capzoneconfig.patrolZoneName then
                objCapZone.objPatrolZone = ZONE:New(capzoneconfig.patrolZoneName)
            end
        end
        if capzoneconfig.engageZoneGroupName then
            objCapZone.objEngageZone = ZONE_POLYGON:New(
                    'CAP_ENGAGE_ZONE_'..capzoneconfig.name,
                    GROUP:FindByName(capzoneconfig.engageZoneGroupName))
            env.info('Training CAP : Engage zone Polygon created : '.. objCapZone.objEngageZone:GetName() ..'...')
        else
            if capzoneconfig.engageZoneName then
                objCapZone.objEngageZone = ZONE:New(capzoneconfig.engageZoneName)
            end
        end
        objCapZone.customconfig = capzoneconfig
        CAPZoneArray[compteur] = objCapZone
        if capzoneconfig.coalitionCAP == coalition.side.RED then
            MENU_COALITION_COMMAND:New(
                    coalition.side.BLUE,
                    "Zone "..capzoneconfig.name.." Start",
                    MenuCoalitionCAPZoneBlue,
                    startCapZone,
                    CAPZoneArray[compteur])
            MENU_COALITION_COMMAND:New(
                    coalition.side.BLUE,
                    "Zone "..capzoneconfig.name.." Clean",
                    MenuCoalitionCAPZoneBlue,
                    wipeCapZone,
                    CAPZoneArray[compteur]
            )
        else
            MENU_COALITION_COMMAND:New(
                    coalition.side.RED,
                    "Zone "..capzoneconfig.name.." Start",
                    MenuCoalitionCAPZoneRed,
                    startCapZone,
                    CAPZoneArray[compteur])
            MENU_COALITION_COMMAND:New(
                    coalition.side.RED,
                    "Zone "..capzoneconfig.name.." Clean",
                    MenuCoalitionCAPZoneRed,
                    wipeCapZone,
                    CAPZoneArray[compteur]
            )
        end
        --CAPZoneArray[compteur]:Start()
    end
end
