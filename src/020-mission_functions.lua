-- *****************************************************************************
-- *                           Mission functions                               *
-- *****************************************************************************
--
-- Generic Spawn object functions
--
env.info('JTFF-SHAREDLIB: shared library loading...')
DEBUG_MSG = false
DEBUG_SQ_MSG = false
DEBUG_DETECT_MSG = false
map_marker = {}
sead = SEAD:New({})

function debug_msg(message)
    if DEBUG_MSG then
        env.info(string.format("[DEBUG] %s", message))
    end
end

function debug_detection_msg(message)
    if DEBUG_DETECT_MSG then
        env.info(string.format("[DETECTION] %s", message))
    end
end

function debug_squeduler_msg(message)
    if DEBUG_SQ_MSG then
        env.info(string.format("[DEBUG SQ] %s", message))
    end
end

function switchGroupImmortalStatus(group)
    status = not BASE:GetState(group, "isImmortal")
    debug_msg(string.format("switch group %s to immortal status %s", group:GetName(), tostring(status)))
    group:SetCommandImmortal(status)
    BASE:SetState(group, "isImmortal", status)
    MESSAGE:NewType("Immortal status of your group : " .. tostring(status) , MESSAGE.Type.Update):ToGroup(group)
end


function give_bra_of_air_group(param)
    local target_group = param[1]
    local client_group = param[2]
    local settings = param[3]
    local coordinate_target = target_group:GetCoordinate()
    local coordinate_client = client_group:GetCoordinate()
    return string.format ("%s, %s",
            coordinate_target:ToStringBRA(coordinate_client, settings),
            coordinate_target:ToStringAspect(coordinate_client)
    )
end

function give_heading_speed(param)
    local target_group = param[1]
    local settings = param[2]
    local heading_target = target_group:GetHeading()
    local speed_target = target_group:GetVelocityKNOTS()
    if (settings:IsMetric()) then
        speed_target = target_group:GetVelocityKMH()
        return string.format (
                "Heading : %.0f, Speed : %.0f km/h",
                heading_target,
                speed_target
        )
    end
    return string.format (
            "Heading : %.0f, Speed : %.0f kt",
            heading_target,
            speed_target
    )
end

function tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
    local client = CLIENT:Find(PlayerUnit:GetDCSObject())
    local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())

    local tankerrefuelsystemName = "BOOM"
    if playerrefuelsystem == 0 then
        tankerrefuelsystemName = "PROBE"
    end
    local braa_message = give_bra_of_air_group({tanker:GetGroup(), PlayerGroup, setting})
    local aspect_message = give_heading_speed({tanker:GetGroup(), setting})
    local fuelState = string.format("%s Lbs", tanker:GetTemplateFuel() * 2.205)
    if setting:IsMetric() then
        fuelState = string.format("%s Kg", tanker:GetTemplateFuel())
    end

    local timeInTheAir = 0
    local timeLeftInTheAir = 0
    local timeLeftString = "Time left : "
    local groupName = tanker:GetName()
    for index, value in pairs(tankersArray) do
        debug_msg(string.format("%s spawned at %i", value.tanker.GroupName, value.spawnAbsTime))
        if (string.find(groupName, value.tanker.GroupName, 1, true) ~= nil) then
            timeInTheAir = timer.getAbsTime() - value.spawnAbsTime
            timeLeftInTheAir = value.customconfig.missionmaxduration * 60 - timeInTheAir
            if (UTILS.SecondsToClock(timeLeftInTheAir, true) ~= nil) then
                timeLeftString = timeLeftString .. UTILS.SecondsToClock(timeLeftInTheAir, true)
            end
            debug_msg(string.format("%s found in %s, time in the air : %i sec, time left %i sec",
                value.tanker.GroupName, groupName, timeInTheAir, timeLeftInTheAir))
        else
            debug_msg(string.format("%s not found in %s", value.tanker.GroupName, groupName))
        end
    end

    for index, value in pairs(tankersOnDemandArray) do
        if( value ~= nil) then
            debug_msg(string.format("%s spawned in tankersOnDemandArray", value:GetName()))
            if (string.find(groupName, value:GetName(), 1, true) ~= nil) then
                timeInTheAir = timer.getAbsTime() - value.spawnAbsTime
                timeLeftInTheAir = value.missionmaxduration * 60 - timeInTheAir
                if (UTILS.SecondsToClock(timeLeftInTheAir, true) ~= nil) then
                    timeLeftString = timeLeftString .. UTILS.SecondsToClock(timeLeftInTheAir, true)
                end
                debug_msg(string.format("%s found in %s, time in the air : %i sec, time left %i sec",
                value:GetName(), groupName, timeInTheAir, timeLeftInTheAir))
            else
                debug_msg(string.format("%s not found in %s", value:GetName(), groupName))
            end
        end
    end

    local message = string.format("%s %s [%s]\nFuel State %s (%.2f)\n%s\n%s\n%s", tanker:GetName(),
        tanker:GetTypeName(), tankerrefuelsystemName, fuelState, tanker:GetFuel() * 100, aspect_message, braa_message,
        timeLeftString)
    MESSAGE:NewType(message, MESSAGE.Type.Overview):ToGroup(PlayerGroup)
end


function findNearestTanker(PlayerUnit, PlayerGroup, Radius)

    Radius=UTILS.NMToMeters(Radius or 50)

    local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
    if isrefuelable then
        local coord=PlayerUnit:GetCoordinate()
        local units=coord:ScanUnits(Radius)
        local coalition=PlayerUnit:GetCoalition()

        local dmin = math.huge
        local tanker = nil --Wrapper.Unit#UNIT
        for _,_unit in pairs(units.Set) do
            local unit = _unit --Wrapper.Unit#UNIT
            local istanker, tankerrefuelsystem=unit:IsTanker()
            if istanker and
                    playerrefuelsystem == tankerrefuelsystem and
                    coalition == unit:GetCoalition() and
                    unit:IsAlive() then

                -- Distance.
                local d = unit:GetCoordinate():Get2DDistance(coord)
                if d < dmin then
                    d = dmin
                    tanker=unit
                end
            end
        end

        tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
    end
    return nil
end

function findAllTanker(PlayerUnit, PlayerGroup, Radius)

    Radius=UTILS.NMToMeters(Radius or 50)

    local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
    if isrefuelable then

        local coord = PlayerUnit:GetCoordinate()
        local units = coord:ScanUnits(Radius)
        local coalition = PlayerUnit:GetCoalition()

        local tanker = nil --Wrapper.Unit#UNIT
        for _,_unit in pairs(units.Set) do
            local unit=_unit --Wrapper.Unit#UNIT
            local istanker, tankerrefuelsystem=unit:IsTanker()
            if istanker and
                    playerrefuelsystem == tankerrefuelsystem and
                    coalition == unit:GetCoalition() and
                    unit:IsAlive() then
                tanker=unit
                tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
            end
        end
    end
    return nil
end

function NearestTankerInfo(param)
    findNearestTanker(
            param[1],
            param[2],
            200
    )
end

function AllTankersInfo(param)
    findAllTanker(param[1],param[2], 200)
end

function taskTankerEscort(param)
    local recoveryTankerObject = param[1]
    local EscortGroup = param[2]
    EscortGroup:OptionAlarmStateRed()
    EscortGroup:OptionROEReturnFire()
    --EscortGroup:TraceOn()
    EscortGroup:OptionRTBAmmo(true)
    EscortGroup:OptionRTBBingoFuel(true)
    local randomCoord = EscortGroup
            :GetCoordinate()
            :GetRandomCoordinateInRadius( 50000, 30000 )
    randomCoord.y = 8000
    --randomCoord:MarkToAll('rejointe '..EscortGroup.GroupName)
    local escortTask = EscortGroup:TaskEscort(
            GROUP:FindByName(recoveryTankerObject.tanker.GroupName),
            POINT_VEC3:New(0, 10, 150):GetVec3(),
            20,
            40 * 1800,
            { 'Air' }
    )
    local randomWaypoint = randomCoord:WaypointAirTurningPoint(
            COORDINATE.WaypointAltType.BARO,
            500,
            {escortTask},
            'escort-start'
    )
    EscortGroup:Route(
            {
                EscortGroup:GetCoordinate():WaypointAir(
                        COORDINATE.WaypointAltType.BARO,
                        COORDINATE.WaypointType.TurningPoint,
                        COORDINATE.WaypointAction.TurningPoint,
                        500
                ),
                randomWaypoint
            },
            1
    )
    env.info('Escort group spawned : '.. EscortGroup.GroupName..'. Escorting '..recoveryTankerObject.tanker.GroupName)
end

function spawnRecoveryTankerEscort(escortSpawnObject,customconfig)
    if (customconfig.airspawn) then
        return escortSpawnObject
                :SpawnFromCoordinate(UNIT:FindByName(customconfig.baseUnit):GetCoordinate():SetAltitude(UTILS.FeetToMeters(customconfig.altitude)))
    else
        return escortSpawnObject
                :SpawnAtAirbase(AIRBASE:FindByName(customconfig.baseUnit),SPAWN.Takeoff.Cold, customconfig.altitude)
    end
end

function EnterRecovery(objAirboss, Case)
    --local shipID = UNIT:FindByName(objAirboss.carrier:Name()):GetDCSObject():getID()
    timer.scheduleFunction(
            function()
                trigger.action.outSound("Airboss Soundfiles/BossRecoverAircraft.ogg")
                trigger.action.outText(objAirboss.customconfig.alias..': Recovery started Case '..Case..'...', 30)
            end,
            {},
            timer.getTime() + 10
    )
end

function detectShitHotBreak(objAirboss)
    local clientData={}
    local player_name=""
    --env.info('detectShitHotBreak : '.. objAirboss.customconfig.alias..' suspense ...')
    objAirboss.BlueCVNClients:ForEachClientInZone( objAirboss.CVN_GROUPZone,
            function( MooseClient )

                local function resetFlag()
                    --trigger.action.outText('RESET SH Pass FLAG)', 5 )
                    client_in_zone_flag:Set(0)
                end

                local player_velocity = MooseClient:GetVelocityKNOTS()
                local player_name = MooseClient:GetPlayerName()
                local player_alt = MooseClient:GetAltitude()
                local player_type = MooseClient:GetTypeName()

                player_alt_feet = math.floor((player_alt * ( 3.28 / 10)))*10

                player_velocity_round = math.floor((player_velocity/10))*10

                local Play_SH_Sound = USERSOUND:New( "AIRBOSS/Airboss Soundfiles/GreatBallsOfFire.ogg" )
                --trigger.action.outText(player_name..' altitude is '..player_alt, 5)
                --trigger.action.outText(player_name..' speed is '..player_velocity, 5)
                if client_in_zone_flag == nil then
                    client_in_zone_flag = USERFLAG:New(MooseClient:GetClientGroupID() + 10000000)
                else
                end

                if client_performing_sh == nil then
                    client_performing_sh = USERFLAG:New(MooseClient:GetClientGroupID() + 100000000)
                else
                end

                if client_in_zone_flag:Get() == 0 and player_velocity > 475 and player_alt < 213 then
                    -- Requirements for Shit Hot break are velocity >475 knots and less than 213 meters (700')
                    trigger.action.outText(player_name..' performing a Sierra Hotel Break!', 10)
                    local sh_message_to_discord = ('**'..player_name..' is performing a Sierra Hotel Break at '..player_velocity_round..' knots and '..player_alt_feet..' feet!**')
                    HypeMan.sendBotMessage(sh_message_to_discord)
                    Play_SH_Sound:ToAll()
                    client_in_zone_flag:Set(1)
                    client_performing_sh:Set(1)
                    timer.scheduleFunction(resetFlag, {}, timer.getTime() + 10)
                else
                end

                --trigger.action.outText('ForEachClientInZone: Client name is '..clientData.clientName , 5)
                --trigger.action.outText('ForEachClientInZone: Client fuel1 is '..clientData.clientFuel1 , 5)

            end
    )
end

function LeaveRecovery(objAirboss)
    local shipID = UNIT:FindByName(objAirboss.carrier:Name()):GetDCSObject():getID()
end

function resetRecoveryTanker(recoveryTankerObject)
    recoveryTankerObject:SetRespawnOnOff(true)
    recoveryTankerObject.tanker:Destroy()
    recoveryTankerObject:SetRespawnOnOff(recoveryTankerObject.customconfig.autorespawn)
    if recoveryTankerObject.customconfig.escortgroupname then
        recoveryTankerObject.escortGroupObject:Destroy()
        --recoveryTankerObject.escortGroupObject = spawnRecoveryTankerEscort(recoveryTankerObject.escortSpawnObject,recoveryTankerObject.customconfig)
    end
end

function startCapZone(objCAPZone)
    local AICapGroup = objCAPZone.objSpawn:SpawnInZone(objCAPZone.objPatrolZone,
            true
    )
    local objCAP = AI_CAP_ZONE:New(
            objCAPZone.objPatrolZone,
            UTILS.Round(objCAPZone.customconfig.capParameters.patrolFloor*0.3048,0),
            UTILS.Round(objCAPZone.customconfig.capParameters.patrolCeiling*0.3048,0),
            UTILS.Round(objCAPZone.customconfig.capParameters.minPatrolSpeed*1.852,0),
            UTILS.Round(objCAPZone.customconfig.capParameters.maxPatrolSpeed*1.852,0),
            AI.Task.AltitudeType.BARO
    )
    objCAP:SetControllable(AICapGroup)
    objCAP:SetEngageZone(objCAPZone.objEngageZone)
    objCAP:__Start(1)
    --local objAiCapZone = AI_CAP_ZONE:New(
    --        objCAPZone.objPatrolZone,
    --        UTILS.Round(objCAPZone.customconfig.capParameters.patrolFloor*0.3048,0),
    --        UTILS.Round(objCAPZone.customconfig.capParameters.patrolCeiling*0.3048,0),
    --        UTILS.Round(objCAPZone.customconfig.capParameters.minPatrolSpeed*1.852,0),
    --        UTILS.Round(objCAPZone.customconfig.capParameters.maxPatrolSpeed*1.852,0),
    --        AI.Task.AltitudeType.BARO
    --)
    --function objAiCapZone:OnAfterStart(from, event, to)
    --end

    --objAiCapZone:SetControllable(
    --        objCAPZone.objSpawn:SpawnInZone(objCAPZone.objPatrolZone,
    --                true
    --        )
    --)
end

function wipeCapZone(objCAPZone)
    fctKillSpawnObject(objCAPZone.objSpawn)
    trigger.action.outText('CAP Training Zone '..(objCAPZone.customconfig.name)..' cleaned !!', 30)
end

function fctKillSpawnObject(objSpawn)
    local GroupPlane, Index = objSpawn:GetFirstAliveGroup()
    while GroupPlane ~= nil do
        -- Do actions with the GroupPlane object.
        GroupPlane:Destroy(true)
        GroupPlane, Index = objSpawn:GetNextAliveGroup( Index )
    end
end

function getMaxThreatUnit(setUnits)
    local setUnitsSorted = SET_UNIT:New()
    setUnits:ForEachUnitPerThreatLevel(10, 0, function(unit)
        setUnitsSorted:AddUnit(unit)
    end)
    debug_msg(string.format("Max priority unit : %s", setUnitsSorted:GetFirst():GetName()))
    return setUnitsSorted:GetFirst()
end

function destroyGroup(group_name)
    local set_group_alive = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    set_group_alive:ForEachGroupAlive(
            function(group_alive)
                debug_msg(string.format("Group %s just removed", group_alive:GetName()))
                if (map_marker[group_alive:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[group_alive:GetName()])
                end
                group_alive:Destroy()
            end )
end

function deleteSubRangeUnits(param)
    local groupsToSpawn = param[1]
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    local radioCommandSubRange = param[4]
    for i = 1, #groupsToSpawn do
        destroyGroup(groupsToSpawn[i])
    end
    MESSAGE:NewType(string.format("Remove the site : %s-%s", rangeConfig.name, subRangeConfig.name),
        MESSAGE.Type.Information):ToBlue()
    radioCommandSubRange:RemoveSubMenus()

    AddTargetsFunction(radioCommandSubRange, rangeConfig, subRangeConfig)
end

function deleteIADSUnits(param)
    local iadsConfig = param[1]
    local skynetIADSObject = param[2]
    local parentMenu = param[3]
    local iadsName = iadsConfig.name
    local nodesConfig = iadsConfig.nodes

    if (skynetIADSObject ~= nil) then
        deactivateSkynet({ iadsConfig, skynetIADSObject, parentMenu })
    end

    for index, nodeConfig in ipairs(nodesConfig) do
        local ewrList = nodeConfig.ewrs
        local sitesList = nodeConfig.sites
        for index, ewrGroup in ipairs(ewrList) do
            local groupNameToDelete = string.format("%s", ewrGroup)
            destroyGroup(groupNameToDelete)
        end
        for siteindex, site in ipairs(sitesList) do
            if (type(site) == "string") then
                local groupNameToDelete = string.format("%s", site)
                destroyGroup(groupNameToDelete)
            elseif (type(site) == "table") then
                local groupNameToDelete = string.format("%s", site.sam)
                destroyGroup(groupNameToDelete)
            end
            if (type(site.pointDefenses) == "string") then
                local groupNameToDelete = string.format("%s", site.pointDefenses)
                destroyGroup(groupNameToDelete)
            elseif (type(site.pointDefenses) == "table") then
                for pdIndex, pdSamGroupName in ipairs(site.pointDefenses) do
                    local groupNameToDelete = string.format("%s", pdSamGroupName)
                    destroyGroup(groupNameToDelete)
                end
            end
        end
    end

    MESSAGE:NewType(string.format("Remove IADS : %s", iadsName), MESSAGE.Type.Information):ToBlue()
    parentMenu:RemoveSubMenus()

    AddIADSFunction(parentMenu, iadsConfig, skynetIADSObject)
end

function setROE(param)
    local groupsToSpawn = param[1]
    local ROEvalue = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("SET ROE of group %s at %i", group_alive:GetName(), ROEvalue))
            if (ROEvalue ~= ENUMS.ROE.WeaponHold) then
                group_alive:SetAIOn()
            end
            group_alive:OptionROE(ROEvalue)
        end)
    end
end

function setAlarmState(param)
    local groupsToSpawn = param[1]
    local AlarmStateValue = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            group_alive:SetAIOn()
            if AlarmStateValue == ENUMS.AlarmState.Auto then
                debug_msg(string.format("SET Alarm State of group %s at AUTO", group_alive:GetName()))
                group_alive:OptionAlarmStateAuto()
            elseif AlarmStateValue == ENUMS.AlarmState.Green then
                debug_msg(string.format("SET Alarm State of group %s at Green", group_alive:GetName()))
                group_alive:OptionAlarmStateGreen()
            elseif AlarmStateValue == ENUMS.AlarmState.Red then
                debug_msg(string.format("SET Alarm State of group %s at Red", group_alive:GetName()))
                group_alive:OptionAlarmStateRed()
            end
        end)
    end
end

function setEngageAirWeapons(param)
    local groupsToSpawn = param[1]
    local value = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("SET Engage Air Weapons of group %s at %s", group_alive:GetName(), tostring(value)))
            if (value) then
                group_alive:SetAIOn()
            end
            group_alive:SetOption(AI.Option.Ground.id.ENGAGE_AIR_WEAPONS, value)
        end)
    end
end

function smokeOnSubRange(param)
    local groupsToSpawn = param[1]
    local displayToCoalition = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("Smoke on group %s", group_alive))
            local list_units = group_alive:GetUnits()
            local set_units_red = SET_UNIT:New()
            local set_units_blue = SET_UNIT:New()
            for index = 1, #list_units do
                local unit_tmp = list_units[index]
                if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.RED) then
                    set_units_red:AddUnit(unit_tmp)
                end
            end
            if (set_units_red:CountAlive() > 0) then
                local unit_red_to_smoke = getMaxThreatUnit(set_units_red)
                if (unit_red_to_smoke) then
                    unit_red_to_smoke:SmokeRed()
                    MESSAGE:NewType(string.format("[%s] Red smoke on : %s", group_alive:GetName(),
                            unit_red_to_smoke:GetTypeName()), MESSAGE.Type.Overview):ToCoalition(displayToCoalition)
                end
            elseif (set_units_blue:CountAlive() > 0) then
                local unit_blue_to_smoke = getMaxThreatUnit(set_units_blue)
                if (unit_blue_to_smoke) then
                    unit_blue_to_smoke:SmokeBlue()
                    MESSAGE:NewType(string.format("[%s] Blue smoke on : %s", group_alive:GetName(),
                            unit_blue_to_smoke:GetTypeName()), MESSAGE.Type.Overview):ToCoalition(displayToCoalition)
                end
            end
        end)
    end
end

function giveToClientGroupCoordinates(param)
    local groupsToSpawn = param[1]
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("Coordinates of all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        Set_CLIENT:ForEachClient(function(client)
            if (client:IsActive()) then
                debug_msg(string.format("For Client %s ", client:GetName()))
                local coordinate_txt = ""
                dcs_groups:ForEachGroupAlive(function(group_alive)
                    debug_msg(string.format("Coordinates of the group %s", group_alive:GetName()))
                    local coordinate = group_alive:GetCoordinate()
                    local setting = _DATABASE:GetPlayerSettings(client:GetPlayerName())
                    local coordinate_string = ""
                    if (setting:IsA2G_LL_DDM()) then
                        coordinate_string = coordinate:ToStringLLDDM(setting)
                        debug_msg(string.format("%s IsA2G_LL_DDM", client:GetName()))
                    elseif (setting:IsA2G_MGRS()) then
                        coordinate_string = coordinate:ToStringMGRS(setting)
                        debug_msg(string.format("%s IsA2G_MGRS", client:GetName()))
                    elseif (setting:IsA2G_LL_DMS()) then
                        coordinate_string = coordinate:ToStringLLDMS(setting)
                        debug_msg(string.format("%s IsA2G_LL_DMS", client:GetName()))
                    elseif (setting:IsA2G_BR()) then
                        coordinate_string = coordinate:ToStringBR(client:GetCoordinate(), setting)
                        debug_msg(string.format("%s IsA2G_BR", client:GetName()))
                    end
                    debug_msg(string.format("coordinate_txt [%s] : %s", group_alive:GetName(), coordinate_string))
                    coordinate_txt = string.format("%s[%s] : %s\n", coordinate_txt, group_alive:GetName(),
                        coordinate_string)
                end)
                debug_msg(string.format("Message to Client %s : %s", client:GetName(), coordinate_txt))
                MESSAGE:NewType(coordinate_txt, MESSAGE.Type.Detailed):ToClient(client)
            end
        end)
    end
end

function giveListOfGroupsAliveInRange(param)
    local groupsToSpawn = param[1]
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    debug_msg(string.format("List of groups in range %s-%s", rangeConfig.name, subRangeConfig.name))
    local message = string.format("Targets groups in Range %s-%s :", rangeConfig.name, subRangeConfig.name)
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("group %s", group_alive:GetName()))
            message = string.format("%s %s | ", message, group_alive:GetName());
        end)
    end
    Set_CLIENT:ForEachClient(function(client)
        if (client:IsActive()) then
            MESSAGE:NewType(message, MESSAGE.Type.Information):ToClient(client)
        end
    end)
end

function giveListOfUnitsAliveInGroup(param)
    local groupsToSpawn = param[1]
    local side = param[2]
    local number_to_display = param[3]
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("List of units of all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("List of units of the group %s", group_alive:GetName()))
            local info_unit_header = string.format("Units list of the group [%s]:", group_name)
            Set_CLIENT:ForEachClient(function(client)
                if (client:IsActive()) then
                    MESSAGE:NewType(info_unit_header, MESSAGE.Type.Overview):ToClient(client)
                end
            end)
            local list_units = group_alive:GetUnits()
            local set_units = SET_UNIT:New()
            for index = 1, #list_units do
                local unit_tmp = list_units[index]
                if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() ~= side) then
                    set_units:AddUnit(unit_tmp)
                    debug_msg(string.format("Type : %s", unit_tmp:GetTypeName()))
                end
            end
            local increment = 0;
            set_units:ForEachUnitPerThreatLevel(10, 0, function(unit_tmp)
                if (increment < number_to_display) then
                    local unit_life_pourcentage = (unit_tmp:GetLife() / (unit_tmp:GetLife0() + 1)) * 100
                    local unit_coordinate = unit_tmp:GetCoordinate()
                    local unit_altitude_m = unit_tmp:GetAltitude()
                    local unit_coordinate_for_client = ""
                    local unit_altitude_for_client = 0
                    local unit_altitude_for_client_unit = ""
                    Set_CLIENT:ForEachClient(function(client)
                        if (client:IsActive()) then
                            local setting = _DATABASE:GetPlayerSettings(client:GetPlayerName())
                            unit_coordinate_for_client = ""
                            if (setting:IsA2G_LL_DDM()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringLLDDM(setting)
                            elseif (setting:IsA2G_MGRS()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringMGRS(setting)
                            elseif (setting:IsA2G_LL_DMS()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringLLDMS(setting)
                            elseif (setting:IsA2G_BR()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringBR(client:GetCoordinate(), setting)
                            end
                            if (setting:IsImperial()) then
                                unit_altitude_for_client = UTILS.MetersToFeet(unit_altitude_m)
                                unit_altitude_for_client_unit = "ft"
                            elseif (setting:IsMetric()) then
                                unit_altitude_for_client = unit_altitude_m
                                unit_altitude_for_client_unit = "m"
                            end
                            local info_unit_tmp = string.format("[%i] %s (%i", unit_tmp:GetThreatLevel(),
                                unit_tmp:GetTypeName(), unit_life_pourcentage) .. '%),\t' .. unit_coordinate_for_client ..
                                                      string.format("\tAlt: %.0f%s", unit_altitude_for_client,
                                    unit_altitude_for_client_unit)
                            MESSAGE:NewType(info_unit_tmp, MESSAGE.Type.Overview):ToClient(client)
                        end
                    end)
                    increment = increment + 1;
                end
            end)
        end)
    end
end

function markGroupOnMap(param)
    local groupsToSpawn = param[1]
    local side = param[2]
    for i = 2, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("Mark on map all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("Mark on map the group %s", group_alive:GetName()))
            local coordinate = group_alive:GetCoordinate()
            map_marker[group_alive:GetName()] = coordinate:MarkToCoalition(group_alive:GetName(), side)
        end)
    end
end

function SpawnRanges(param)
    local radioCommandSubRange = param[1]
    local rangeConfig = param[2]
    local rangeName = rangeConfig.name
    local subRangeConfig = param[3]
    local subRangeName = subRangeConfig.name
    local groupsToSpawn = subRangeConfig.groupsToSpawn
    local staticsToSpawn = subRangeConfig.staticsToSpawn
    local holdFire = subRangeConfig.holdFire
    local engageAirWeapons = subRangeConfig.engageAirWeapons
    local activateAI = subRangeConfig.AI
    local redAlert = subRangeConfig.redAlert

    debug_msg(string.format("SpawnRanges : Range %s - Targets %s", rangeName, subRangeName))
    for i = 1, #groupsToSpawn do
        local groupNameToSpawn = string.format("%s", groupsToSpawn[i])
        if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
            local spawnGroup = SPAWN:New(groupNameToSpawn)
            debug_msg(string.format("SPAWN %s", groupNameToSpawn))
            local groupSpawning
            if (subRangeConfig.spawnZone) then
                groupSpawning = spawnGroup:SpawnInZone(ZONE:New(subRangeConfig.spawnZone),true)
            else
                groupSpawning = spawnGroup:Spawn()
            end
            if (holdFire) then
                groupSpawning:OptionROEHoldFire()
            else
                groupSpawning:OptionROEOpenFire()
            end
            if (engageAirWeapons) then
                groupSpawning:SetOption(AI.Option.Ground.id.ENGAGE_AIR_WEAPONS, true)
            end
            if (activateAI == true or activateAI == false) then
                groupSpawning:SetAIOnOff(activateAI)
            end
            if (redAlert == true or redAlert == false) then
                if (redAlert == true) then
                    groupSpawning:OptionAlarmStateRed()
                else
                    groupSpawning:OptionAlarmStateGreen()   
                end 
            else
                groupSpawning:OptionAlarmStateAuto()
            end
            if (string.find(groupNameToSpawn, "SAM") ~= nil) then
                sead:UpdateSet(groupNameToSpawn)
                debug_msg(string.format("SEAD for %s", groupNameToSpawn))
            end
        else
            debug_msg(string.format("GROUP to spawn %s not found in mission", groupNameToSpawn))
        end
    end

    if (staticsToSpawn ~= nil)then
        for index, staticToSpawn in ipairs(staticsToSpawn) do
            local staticNameToSpawn = string.format("%s", staticToSpawn.name)
            local spawnStatic = SPAWNSTATIC:NewFromStatic(staticNameToSpawn)
            local x = staticToSpawn.x
            local y = staticToSpawn.y
            local heading = staticToSpawn.heading
            local name = string.format("%s_%s_%i", subRangeName, staticNameToSpawn,index)
            debug_msg(string.format("Static to spawn %s at %i,%i -> %s", staticNameToSpawn, x, y, name))
            spawnStatic:SpawnFromPointVec2( POINT_VEC2:New( x, y ), heading, name )
        end
    else
        debug_msg(string.format("No static in %s", subRangeName))  
    end      


    radioCommandSubRange:RemoveSubMenus()
    local CommandZoneDetroy = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Delete", radioCommandSubRange,
        deleteSubRangeUnits, {groupsToSpawn, rangeConfig, subRangeConfig, radioCommandSubRange})
    local ROE = MENU_COALITION:New(rangeConfig.benefit_coalition, "ROE", radioCommandSubRange)
    local ROEOpenFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Open Fire", ROE, setROE,
        {groupsToSpawn, ENUMS.ROE.OpenFire})
    local ROEReturnFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Return Fire", ROE, setROE,
        {groupsToSpawn, ENUMS.ROE.ReturnFire})
    local ROEHoldFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Hold Fire", ROE, setROE,
        {groupsToSpawn, ENUMS.ROE.WeaponHold})
    local AlarmState = MENU_COALITION:New(rangeConfig.benefit_coalition, "Alarm State", radioCommandSubRange)
    local AlarmStateAuto = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Auto", AlarmState, setAlarmState,
        {groupsToSpawn, ENUMS.AlarmState.Auto})
    local AlarmStateGreen = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Green", AlarmState, setAlarmState,
        {groupsToSpawn, ENUMS.AlarmState.Green})
    local AlarmStateRed = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Red", AlarmState, setAlarmState,
        {groupsToSpawn, ENUMS.AlarmState.Red})
    local Engage_Air_Weapons = MENU_COALITION:New(rangeConfig.benefit_coalition, "Engage Air Weapons", radioCommandSubRange)
    local Engage_Air_Weapons_True = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "True", Engage_Air_Weapons, setEngageAirWeapons,
        {groupsToSpawn, true})
    local Engage_Air_Weapons_False = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "False", Engage_Air_Weapons, setEngageAirWeapons,
        {groupsToSpawn, false})
    local CommandZoneFumigene = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Smoke", radioCommandSubRange,
        smokeOnSubRange, {groupsToSpawn, rangeConfig.benefit_coalition})
    local CommandZoneCoord = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Coordinates",
        radioCommandSubRange, giveToClientGroupCoordinates, {groupsToSpawn})
    local CommandZoneListGroup = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Groups",
        radioCommandSubRange, giveListOfGroupsAliveInRange, {groupsToSpawn, rangeConfig, subRangeConfig})
    local CommandZoneList = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Units",
        radioCommandSubRange, giveListOfUnitsAliveInGroup, {groupsToSpawn, rangeConfig.benefit_coalition, 5})
    MESSAGE:NewType(string.format("Units in range %s(%s) in place", rangeName, subRangeName), MESSAGE.Type.Information)
        :ToBlue()
    markGroupOnMap({groupsToSpawn, rangeConfig.benefit_coalition})
end

function SpawnFacRanges(param)
    local radioCommandSubRange = param[1]
    local facRangeConfig = param[2]
    local facRangeName = facRangeConfig.name
    local facSubRangeConfig = param[3]
    local facSubRangeName = facSubRangeConfig.name
    local groupsToSpawn = facSubRangeConfig.groupsToSpawn
    local staticsToSpawn = facSubRangeConfig.staticsToSpawn

    debug_msg(string.format("SpawnFacRanges : %s-%s", facRangeName, facSubRangeName))
    for i = 1, #groupsToSpawn do
        local groupNameToSpawn = string.format("%s", groupsToSpawn[i])
        if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
            local spawnGroup = SPAWN:New(groupNameToSpawn)
            debug_msg(string.format("SPAWN %s", groupNameToSpawn))
            local groupSpawning
            if (facSubRangeConfig.spawnZone) then
                groupSpawning = spawnGroup:SpawnInZone(ZONE:New(facSubRangeConfig.spawnZone),true)
            else
                groupSpawning = spawnGroup:Spawn()
            end
        else
            debug_msg(string.format("GROUP to spawn %s not found in mission", groupNameToSpawn))
        end
    end

    radioCommandSubRange:RemoveSubMenus()
    local CommandZoneDetroy = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Delete", radioCommandSubRange,
            deleteSubRangeUnits, { groupsToSpawn, facRangeConfig, facSubRangeConfig, radioCommandSubRange})
    local CommandZoneFumigene = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Smoke", radioCommandSubRange,
            smokeOnSubRange, { groupsToSpawn, facRangeConfig.benefit_coalition})
    local CommandZoneCoord = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Coordinates",
            radioCommandSubRange, giveToClientGroupCoordinates, {groupsToSpawn})
    local CommandZoneListGroup = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "List Groups",
            radioCommandSubRange, giveListOfGroupsAliveInRange, { groupsToSpawn, facRangeConfig, facSubRangeConfig })
    local CommandZoneList = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "List Units",
            radioCommandSubRange, giveListOfUnitsAliveInGroup, { groupsToSpawn, facRangeConfig.benefit_coalition, 5})
    MESSAGE:NewType(string.format("FAC in range %s(%s) in place", facRangeName, facSubRangeName), MESSAGE.Type.Information)
           :ToBlue()
    markGroupOnMap({ groupsToSpawn, facRangeConfig.benefit_coalition})
end

function skynetUpdateDisplay(param)
    local skynetIADSObject = param[1]
    local option =  param[2]
    local value =   param[3]

    skynetIADSObject:getDebugSettings()[option] = value
end

function deactivateSkynet(param)
    local iadsConfig = param[1]
    local skynetIADSObject = param[2]
    local parentMenu = param[3]

    --skynetIADSObject:removeRadioMenu()
    skynetIADSObject:deactivate()

    parentMenu:RemoveSubMenus()
    local CommandIADSDetroy = MENU_MISSION_COMMAND:New("Delete", parentMenu,
        deleteIADSUnits, { iadsConfig, skynetIADSObject, parentMenu })
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Activate Skynet",
            parentMenu, activateSkynet, { iadsConfig, skynetIADSObject, parentMenu })
    MESSAGE:NewType(string.format("Skynet of %s is desactivated", iadsConfig.name), MESSAGE.Type.Information):ToBlue()
end

function activateSkynet(param)
    local iadsConfig = param[1]
    local skynetIADSObject = param[2]
    local parentMenu = param[3]
    debug_msg(string.format("IADS - Skynet activation for %s", iadsConfig.name))
    -- create an instance of the IADS
    skynetIADSObject = SkynetIADS:create(iadsConfig.name)

    ---debug settings remove from here on if you do not wan't any output on what the IADS is doing by default
    local iadsDebug = skynetIADSObject:getDebugSettings()
    iadsDebug.IADSStatus = false
    iadsDebug.radarWentDark = false
    iadsDebug.contacts = false
    iadsDebug.radarWentLive = false
    iadsDebug.noWorkingCommmandCenter = false
    iadsDebug.ewRadarNoConnection = false
    iadsDebug.samNoConnection = false
    iadsDebug.jammerProbability = false
    iadsDebug.addedEWRadar = false
    iadsDebug.hasNoPower = false
    iadsDebug.harmDefence = false
    iadsDebug.samSiteStatusEnvOutput = false
    iadsDebug.earlyWarningRadarStatusEnvOutput = false
    iadsDebug.commandCenterStatusEnvOutput = false
    ---end remove debug ---

    -- add a command center:
    for index, headQuarter in ipairs(iadsConfig.headQuarter) do
        local commandCenter = StaticObject.getByName(headQuarter)
        skynetIADSObject:addCommandCenter(commandCenter)
    end

    for index, node in ipairs(iadsConfig.nodes) do
        debug_msg(string.format("IADS - Connection Node %s", node.connection))
        local connectionNode = StaticObject.getByName(node.connection)
        for index, ewr in ipairs(node.ewrs) do
            if (ewr ~= nil and connectionNode ~= nil) then
                debug_msg(string.format("IADS - EWR Unit name in config file : %s", ewr))
                local set_ewr_units = SET_UNIT:New():FilterPrefixes(ewr):FilterOnce()
                set_ewr_units:ForEachUnit(function(ewr_alive)
                    if ewr_alive:IsAlive() then
                        debug_msg(string.format("Alive EWR Unit name found %s", ewr_alive:Name()))
                        skynetIADSObject:addEarlyWarningRadar(ewr_alive:Name())
                        skynetIADSObject:getEarlyWarningRadarByUnitName(ewr_alive:Name()):addConnectionNode(connectionNode)
                    end
                end)
            end
        end
        for siteIndex, site in ipairs(node.sites) do
            if (site ~= nil and connectionNode ~= nil) then
                if (type(site) == "string") then
                    debug_msg(string.format("IADS - Sam Group name in config file :  %s", site))
                    local set_group_alive = SET_GROUP:New():FilterPrefixes(site):FilterOnce()
                    set_group_alive:ForEachGroupAlive(function(group_alive)
                        debug_msg(string.format("IADS - Alive Sam Group found %s", group_alive:GetName()))
                        skynetIADSObject:addSAMSite(group_alive:GetName())
                        skynetIADSObject:getSAMSiteByGroupName(group_alive:GetName()):addConnectionNode(connectionNode)
                    end)
                elseif (type(site) == "table") then
                    debug_msg(string.format("IADS - Sam Group name in config file :  %s", site.sam))
                    local set_group_alive = SET_GROUP:New():FilterPrefixes(site.sam):FilterOnce()
                    set_group_alive:ForEachGroupAlive(function(samGroupAlive)
                        debug_msg(string.format("IADS - Alive Sam Group found %s", samGroupAlive:GetName()))
                        skynetIADSObject:addSAMSite(samGroupAlive:GetName())
                        local skynetSam = skynetIADSObject:getSAMSiteByGroupName(samGroupAlive:GetName())
                        skynetSam:addConnectionNode(connectionNode)
                        if (type(site.actAsEW) == "boolean") then
                            debug_msg(string.format("IADS - actAsEW %s", tostring(site.actAsEW)))
                            skynetSam:setActAsEW(site.actAsEW)
                        end
                        if (type(site.harmDetectionChance) == "number") then
                            debug_msg(string.format("IADS - HARM detection chance : %i", site.harmDetectionChance))
                            skynetSam:setHARMDetectionChance(site.harmDetectionChance)
                        end
                        if (type(site.goLiveRangePercent) == "number") then
                            debug_msg(string.format("IADS - Go Live Range : %i perc", site.goLiveRangePercent))
                            skynetSam
                                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                                    :setGoLiveRangeInPercent(site.goLiveRangePercent)
                        else
                            skynetSam
                                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                        end
                        if (type(site.pointDefenses) == "string") then
                            local set_pdgroup_alive = SET_GROUP:New():FilterPrefixes(site.pointDefenses):FilterOnce()
                            set_pdgroup_alive:ForEachGroupAlive(function(pdGroupAlive)
                                debug_msg(string.format("IADS - Alive Point Defense Sam Group found %s", pdGroupAlive:GetName()))
                                skynetIADSObject:addSAMSite(pdGroupAlive:GetName())
                                local skynetPdSam = skynetIADSObject:getSAMSiteByGroupName(pdGroupAlive:GetName())
                                skynetPdSam:addConnectionNode(connectionNode)
                                if (type(site.pdactAsEw) == "boolean") then
                                    debug_msg(string.format("IADS - actAsEW %s", tostring(site.pdactAsEw)))
                                    skynetPdSam:setActAsEW(site.pdactAsEw)
                                end
                                if (type(site.pdharmDetectionChance) == "number") then
                                    debug_msg(string.format("IADS - HARM detection chance : %i", site.pdharmDetectionChance))
                                    skynetPdSam:setHARMDetectionChance(site.pdharmDetectionChance)
                                end
                                if (type(site.pdgoLiveRangePercent) == "number") then
                                    debug_msg(string.format("IADS - Go Live Range : %i perc", site.pdgoLiveRangePercent))
                                    skynetPdSam
                                            :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                                            :setGoLiveRangeInPercent(site.pdgoLiveRangePercent)
                                else
                                    skynetPdSam
                                            :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                                end
                                debug_msg(string.format("IADS - Point Defense Sam Group %s Defending SAM %s", pdGroupAlive:GetName(), samGroupAlive:GetName()))
                                skynetSam:addPointDefence(skynetPdSam)
                            end)
                        elseif (type(site.pointDefenses) == "table") then
                            for pdIndex, pdSamGroupName in ipairs(site.pointDefenses) do
                                debug_msg(string.format("IADS - Point Defense Sam Group name in config file :  %s", pdSamGroupName))
                                local set_pdgroup_alive = SET_GROUP:New():FilterPrefixes(pdSamGroupName):FilterOnce()
                                set_pdgroup_alive:ForEachGroupAlive(function(pdGroupAlive)
                                    debug_msg(string.format("IADS - Alive Point Defense Sam Group found %s", pdGroupAlive:GetName()))
                                    skynetIADSObject:addSAMSite(pdGroupAlive:GetName())
                                    local skynetPdSam = skynetIADSObject:getSAMSiteByGroupName(pdGroupAlive:GetName())
                                    skynetPdSam:addConnectionNode(connectionNode)
                                    if (type(site.pdactAsEw) == "boolean") then
                                        debug_msg(string.format("IADS - actAsEW %s", tostring(site.pdactAsEw)))
                                        skynetPdSam:setActAsEW(site.pdactAsEw)
                                    end
                                    if (type(site.pdharmDetectionChance) == "number") then
                                        debug_msg(string.format("IADS - HARM detection chance : %i", site.pdharmDetectionChance))
                                        skynetPdSam:setHARMDetectionChance(site.pdharmDetectionChance)
                                    end
                                    if (type(site.pdgoLiveRangePercent) == "number") then
                                        debug_msg(string.format("IADS - Go Live Range : %i perc", site.pdgoLiveRangePercent))
                                        skynetPdSam
                                                :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                                                :setGoLiveRangeInPercent(site.pdgoLiveRangePercent)
                                    else
                                        skynetPdSam
                                                :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                                    end
                                    debug_msg(string.format("IADS - Point Defense Sam Group %s Defending SAM %s", pdGroupAlive:GetName(), samGroupAlive:GetName()))
                                    skynetSam:addPointDefence(skynetPdSam)
                                end)
                            end
                        end
                    end)
                end
            end
        end
    end

    -- activate the radio menu to toggle IADS Status output
    if (iadsConfig.radioMenu) then
        debug_msg(string.format("IADS - Add radio menu %s", iadsConfig.name))
        skynetIADSObject:addRadioMenu()
    end

    -- activate the IADS
    skynetIADSObject:setupSAMSitesAndThenActivate()

    parentMenu:RemoveSubMenus()
    local CommandIADSDetroy = MENU_MISSION_COMMAND:New("Delete", parentMenu,
        deleteIADSUnits, { iadsConfig, skynetIADSObject, parentMenu })
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Show IADS Status",
            parentMenu, skynetUpdateDisplay, {skynetIADSObject, 'IADSStatus', true})
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Hide IADS Status",
            parentMenu, skynetUpdateDisplay, {skynetIADSObject, 'IADSStatus', false})
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Show contacts",
            parentMenu, skynetUpdateDisplay, {skynetIADSObject, 'contacts', true})
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Hide contacts",
            parentMenu, skynetUpdateDisplay, {skynetIADSObject, 'contacts', false})
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Disable Skynet",
            parentMenu, deactivateSkynet, { iadsConfig, skynetIADSObject, parentMenu })
    MESSAGE:NewType(string.format("Skynet of %s activate in 60 secondes", iadsConfig.name), MESSAGE.Type.Information):ToCoalition(iadsConfig.benefit_coalition)
end

function SpawnIADS(param)
    local parentMenu = param[1]
    local iadsConfig = param[2]
    local skynetIADSObject = param[3]
    local iadsName = iadsConfig.name
    local nodesConfig = iadsConfig.nodes

    local samGroupsSpawned = {}

    for index, nodeConfig in ipairs(nodesConfig) do
        local ewrList = nodeConfig.ewrs
        local siteList = nodeConfig.sites
        for index, ewrGroup in ipairs(ewrList) do
            local groupNameToSpawn = string.format("%s", ewrGroup)
            if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                local spawnGroup = SPAWN:New(groupNameToSpawn)
                debug_msg(string.format("SPAWN EWR : %s", groupNameToSpawn))
                local groupSpawning = spawnGroup:Spawn():OptionAlarmStateRed()
            else
                debug_msg(string.format("EWR GROUP to spawn %s not found in mission", groupNameToSpawn))
            end
        end
        for siteIndex, site in ipairs(siteList) do
            if (type(site) == "string") then
                local groupNameToSpawn = string.format("%s", site)
                if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(groupNameToSpawn)
                    debug_msg(string.format("SPAWN SAM : %s", groupNameToSpawn))
                    samGroupsSpawned[index] = spawnGroup:Spawn():OptionAlarmStateRed()
                else
                    debug_msg(string.format("SAM GROUP to spawn %s not found in mission", groupNameToSpawn))
                end
            elseif (type(site) == "table") then
                debug_msg(string.format("SAM in config file is table"))
                local groupNameToSpawn = string.format("%s", site.sam)
                if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(groupNameToSpawn)
                    debug_msg(string.format("SPAWN SAM : %s", groupNameToSpawn))
                    samGroupsSpawned[index] = spawnGroup:Spawn():OptionAlarmStateRed()
                else
                    debug_msg(string.format("SAM GROUP to spawn %s not found in mission", groupNameToSpawn))
                end
            end
            if (type(site.pointDefenses) == "string") then
                local pdGroupNameToSpawn = string.format("%s", site.pointDefenses)
                if (GROUP:FindByName(pdGroupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(pdGroupNameToSpawn)
                    debug_msg(string.format("SPAWN SAM-PointDefense : %s", pdGroupNameToSpawn))
                    spawnGroup:Spawn():OptionAlarmStateRed()
                else
                    debug_msg(string.format("SAM-PointDefense GROUP to spawn %s not found in mission", pdGroupNameToSpawn))
                end
            elseif (type(site.pointDefenses) == "table") then
                local pdSamGroupsSpawned = {}
                for pdindex, pdSamGroup in ipairs(site.pointDefenses) do
                    local pdGroupNameToSpawn = string.format("%s", pdSamGroup)
                    if (GROUP:FindByName(pdGroupNameToSpawn) ~= nil) then
                        local spawnGroup = SPAWN:New(pdGroupNameToSpawn)
                        debug_msg(string.format("SPAWN SAM-PointDefense : %s", pdGroupNameToSpawn))
                        pdSamGroupsSpawned[pdindex] = spawnGroup:Spawn():OptionAlarmStateRed()
                    else
                        debug_msg(string.format("SAM-PointDefense GROUP to spawn %s not found in mission", pdGroupNameToSpawn))
                    end
                end
            end
        end
    end

    debug_msg(string.format("Spawn IADS : %s DONE", iadsName))
    parentMenu:RemoveSubMenus()
    local CommandIADSDetroy = MENU_MISSION_COMMAND:New("Delete", parentMenu,
        deleteIADSUnits, { iadsConfig, skynetIADSObject, parentMenu })
    local CommandIADSActivate = MENU_MISSION_COMMAND:New("Skynet Activation",
            parentMenu, activateSkynet, { iadsConfig, skynetIADSObject, parentMenu })
    MESSAGE:NewType(string.format("IADS Units %s in place", iadsName), MESSAGE.Type.Information):ToBlue()
end

function AddTargetsFunction(radioCommandSubRange, rangeConfig, subRangeConfig)
    local RadioCommandAdd = MENU_COALITION_COMMAND:New(
            rangeConfig.benefit_coalition,
            "Spawn",
            radioCommandSubRange,
            SpawnRanges,
            {
                radioCommandSubRange,
                rangeConfig,
                subRangeConfig,
                AddTargetsFunction
            }
    )
end

function AddFacFunction(radioCommandSubRange, facRangeConfig, facSubRangeConfig)
    local RadioCommandAdd = MENU_COALITION_COMMAND:New(
            facRangeConfig.benefit_coalition,
            "Spawn",
            radioCommandSubRange,
            SpawnFacRanges,
            {
                radioCommandSubRange,
                facRangeConfig,
                facSubRangeConfig,
                AddFacFunction
            }
    )
end

function AddIADSFunction(parentMenu, iadsconfig, skynetIADSObject)
    local RadioCommandAdd = MENU_MISSION_COMMAND:New("Spawn", parentMenu,
        SpawnIADS, { parentMenu, iadsconfig, skynetIADSObject})
end

function triggerOnDemandTanker(type, askedDuration, askedFL, askedSpeed, askedAnchorCoord, askedOrbitHeading, askedOrbitLeg)
    local TankerGroup = nil
    if (OnDemandTankersConfig) then
        for index, OnDemandTanker in ipairs(OnDemandTankersConfig) do
            if ((OnDemandTanker.type == type) and (OnDemandTanker.enable)) then
                debug_msg(string.format('OnDemandTanker : Found type %s Tanker : %s Group!', type, OnDemandTanker.groupName))
                if (askedSpeed and askedSpeed > 0) then
                    OnDemandTanker.speed = askedSpeed
                end
                if (askedFL and askedFL > 0) then
                    OnDemandTanker.altitude = askedFL * 100
                end
                if ( askedDuration == nil or askedDuration == 0 ) then
                    askedDuration = 480
                end
                if (askedOrbitHeading) then
                    if (askedOrbitLeg and askedOrbitLeg > 10) then
                        --heading et Leg demandés
                        OnDemandTanker.orbit = {
                            heading = askedOrbitHeading % 360,
                            length = askedOrbitLeg,
                        }
                    else
                        --heading demandé et leg non demandé
                        if (OnDemandTanker.orbit ) then
                            if (not(OnDemandTanker.orbit.length)) then
                                OnDemandTanker.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = 30,
                                }
                            else
                                OnDemandTanker.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = math.max(10, OnDemandTanker.orbit.length),
                                }
                            end
                        else
                            OnDemandTanker.orbit = {
                                heading = askedOrbitHeading % 360,
                                length = 30,
                            }
                        end
                    end
                else
                    --pas de heading demandé
                    if (OnDemandTanker.orbit ) then
                        if (not(OnDemandTanker.orbit.heading)) then
                            OnDemandTanker.orbit.heading = 90
                        end
                        if (not(OnDemandTanker.orbit.length)) then
                            OnDemandTanker.orbit.length = 30
                        else
                            OnDemandTanker.orbit.length = math.max(10, OnDemandTanker.orbit.length)
                        end
                    else
                        OnDemandTanker.orbit = {
                            heading = 90,
                            length = 30,
                        }
                    end
                end
                local set_group_tanker = SET_GROUP:New():FilterActive():FilterPrefixes(OnDemandTanker.groupName):FilterOnce()
                local aliveTankersGroupList = set_group_tanker:GetSetObjects()
                --local RefuelTask = nil
                --local OrbitTask = nil
                local RTBAirbase = nil
                local TankerRoute = {}
                if (OnDemandTanker.baseUnit) then
                    RTBAirbase = AIRBASE:FindByName(OnDemandTanker.baseUnit)
                else
                    RTBAirbase = askedAnchorCoord:GetClosestAirbase2(Airbase.Category.AIRDROME, OnDemandTanker.benefit_coalition)
                end
                if ( #aliveTankersGroupList > 0) then
                    debug_msg(string.format('OnDemandTanker already in air : rerouting %s', OnDemandTanker.groupName))
                    TankerGroup = aliveTankersGroupList[1]
                    TankerGroup:ClearTasks()
                    --RefuelTask = TankerGroup:EnRouteTaskTanker()
                    --OrbitTask = TankerGroup:TaskControlled(
                    --        TankerGroup:TaskOrbitCircle(
                    --                UTILS.FeetToMeters(OnDemandTanker.altitude),
                    --                UTILS.KnotsToMps(OnDemandTanker.speed)
                    --        ),
                    --        TankerGroup:TaskCondition(
                    --                nil,
                    --                nil,
                    --                nil,
                    --                nil,
                    --                maxtime * 60,
                    --                nil
                    --        )
                    --)
                    table.insert(
                            TankerRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        },
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.RACE_TRACK,
                                                        speed = UTILS.KnotsToMps(OnDemandTanker.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandTanker.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Refuel Start"
                            )
                    )
                    table.insert(
                            TankerRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandTanker.orbit.length), OnDemandTanker.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        },
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(
                            TankerRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    RTBAirbase
                            )
                    )
                else
                    debug_msg(string.format('OnDemandTanker Spawning %s', OnDemandTanker.groupName))
                    local SpawnTanker = SPAWN:New(OnDemandTanker.groupName)
                    if (OnDemandTanker.freq) then
                        SpawnTanker:InitRadioFrequency(OnDemandTanker.freq)
                        SpawnTanker:InitRadioModulation("AM")
                    end
                    if (OnDemandTanker.modex) then
                        SpawnTanker:InitModex(OnDemandTanker.modex)
                    end
                    if (OnDemandTanker.baseUnit) then
                        TankerGroup = SpawnTanker:SpawnAtAirbase(
                                AIRBASE:FindByName(OnDemandTanker.baseUnit),
                                SPAWN.Takeoff.Hot,
                                nil,
                                OnDemandTanker.terminalType
                        )
                        table.insert(TankerRoute,
                                AIRBASE
                                        :FindByName(OnDemandTanker.baseUnit)
                                        :GetCoordinate()
                                        :WaypointAirTakeOffParkingHot()
                        )
                    else
                        TankerGroup = SpawnTanker:SpawnFromCoordinate(
                                askedAnchorCoord
                                        :GetRandomCoordinateInRadius(
                                        UTILS.NMToMeters(30),
                                        UTILS.NMToMeters(20)
                                )
                                        :SetAltitude(
                                        UTILS.FeetToMeters(OnDemandTanker.altitude)
                                )
                        )
                    end
                    TankerGroup.spawnAbsTime = timer.getAbsTime()
                    TankerGroup.missionmaxduration = askedDuration
                    --RefuelTask = TankerGroup:EnRouteTaskTanker()
                    --OrbitTask = TankerGroup:TaskControlled(
                    --        TankerGroup:TaskOrbitCircle(
                    --                UTILS.FeetToMeters(OnDemandTanker.altitude),
                    --                UTILS.KnotsToMps(OnDemandTanker.speed)
                    --        ),
                    --        TankerGroup:TaskCondition(
                    --                nil,
                    --                nil,
                    --                nil,
                    --                nil,
                    --                (maxtime) * 60,
                    --                nil
                    --        )
                    --)
                    table.insert(TankerRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        },
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.RACE_TRACK,
                                                        speed = UTILS.KnotsToMps(OnDemandTanker.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandTanker.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Refuel Start"
                            )
                    )
                    table.insert(TankerRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandTanker.orbit.length), OnDemandTanker.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        }
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(TankerRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    RTBAirbase,
                                    {},
                                    'RTB'
                            )
                    )
                end
                TankerGroup:Route(TankerRoute)
                TankerGroup:CommandEPLRS(true, 4)
                if (OnDemandTanker.tacan) then
                    TankerGroup.beacon=BEACON:New(TankerGroup:GetUnit(1))
                    TankerGroup.beacon:ActivateTACAN(OnDemandTanker.tacan.channel, "Y", OnDemandTanker.tacan.morse, true)
                end
                if (OnDemandTanker.callsign) then
                    TankerGroup:CommandSetCallsign(OnDemandTanker.callsign.name, OnDemandTanker.callsign.number, 2)
                end
                if (map_marker[TankerGroup:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[TankerGroup:GetName()])
                end
                map_marker[TankerGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                        string.format(
                                'OnDemand Tanker %s - TCN %i\nFL %i at %i knots\nFreq %i MHz\nOn station for %i minutes\nRacetrack : %i ° for %i nm',
                                OnDemandTanker.type,
                                OnDemandTanker.tacan.channel,
                                UTILS.Round(OnDemandTanker.altitude / 100 , 0),
                                OnDemandTanker.speed,
                                OnDemandTanker.freq,
                                askedDuration,
                                OnDemandTanker.orbit.heading,
                                OnDemandTanker.orbit.length
                        ),
                        OnDemandTanker.benefit_coalition,
                        true,
                        'OnDemand Tanker %s is Activated'
                )
                TankerGroup:HandleEvent(EVENTS.Land)
                TankerGroup:HandleEvent(EVENTS.Crash)
                TankerGroup:HandleEvent(EVENTS.Dead)
                function TankerGroup:OnEventLand(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                end
                function TankerGroup:OnEventCrash(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                end
                function TankerGroup:OnEventDead(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                end
            end
        end
    end
    return TankerGroup;
end

env.info('JTFF-SHAREDLIB: shared library loaded succesfully')
