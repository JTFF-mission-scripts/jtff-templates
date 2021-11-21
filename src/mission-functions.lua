-- *****************************************************************************
-- *                           Mission functions                               *
-- *****************************************************************************
--
-- Generic Spawn object functions
--
env.info('JTFF-SHAREDLIB: shared library loading...')
DEBUG_MSG = true
map_marker = {}
sead = SEAD:New({})

function debug_msg(message)
    if DEBUG_MSG then
        env.info(string.format("[DEBUG] %s", message))
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

function findNearestTanker(PlayerUnit, PlayerGroup, Radius)

    Radius=UTILS.NMToMeters(Radius or 50)

    local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
    if isrefuelable then
        local coord=PlayerUnit:GetCoordinate()
        local units=coord:ScanUnits(Radius)
        local coalition=PlayerUnit:GetCoalition()

        local dmin = math.huge
        local tanker = nil --Wrapper.Unit#UNIT
        local client = CLIENT:Find(PlayerUnit:GetDCSObject())
        local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())
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

        local tankerrefuelsystemName = "BOOM"
        if playerrefuelsystem == 0 then
            tankerrefuelsystemName = "PROBE"
        end
        local braa_message = give_bra_of_air_group({
            tanker:GetGroup(),
            PlayerGroup,
            setting
        })
        local aspect_message = give_heading_speed({
            tanker:GetGroup(),
            setting
        })
        local fuelState = string.format(
                "%s Lbs",
                tanker:GetTemplateFuel()*2.205
        )
        if setting:IsMetric() then
            fuelState = string.format(
                    "%s Kg",
                    tanker:GetTemplateFuel()
            )
        end
        local message = string.format(
                "%s %s [%s]\nFuel State %s(%.2f)\n%s\n%s",
                tanker:GetName(),
                tanker:GetTypeName(),
                tankerrefuelsystemName,
                fuelState,
                tanker:GetFuel()*100,
                aspect_message,
                braa_message
        )
        MESSAGE:NewType(
                message,
                MESSAGE.Type.Overview
        ):ToGroup(PlayerGroup)
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
        local client = CLIENT:Find(PlayerUnit:GetDCSObject())
        local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())
        for _,_unit in pairs(units.Set) do
            local unit=_unit --Wrapper.Unit#UNIT
            local istanker, tankerrefuelsystem=unit:IsTanker()
            if istanker and
                    playerrefuelsystem == tankerrefuelsystem and
                    coalition == unit:GetCoalition() and
                    unit:IsAlive() then
                tanker=unit
                local tankerrefuelsystemName = "BOOM"
                if playerrefuelsystem == 0 then
                    tankerrefuelsystemName = "PROBE"
                end
                local braa_message = give_bra_of_air_group({
                    tanker:GetGroup(),
                    PlayerGroup,
                    setting
                })
                local aspect_message = give_heading_speed({
                    tanker:GetGroup(),
                    setting
                })
                local fuelState = string.format(
                        "%s Lbs",
                        tanker:GetTemplateFuel()*2.205
                )
                if setting:IsMetric() then
                    fuelState = string.format(
                            "%s Kg",
                            tanker:GetTemplateFuel()
                    )
                end
                local message = string.format(
                        "%s %s [%s]\nFuel State %s (%.2f)\n%s\n%s",
                        tanker:GetName(),
                        tanker:GetTypeName(),
                        tankerrefuelsystemName,
                        fuelState,
                        tanker:GetFuel()*100,
                        aspect_message,
                        braa_message
                )
                MESSAGE:NewType(
                        message,
                        MESSAGE.Type.Overview
                ):ToGroup(PlayerGroup)
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
    return escortSpawnObject
            :SpawnAtAirbase(AIRBASE:FindByName(customconfig.baseUnit),SPAWN.Takeoff.Cold, customconfig.altitude)
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
    set_group_alive:ForEachGroupAlive(function(group_alive)
        debug_msg(string.format("Group %s just removed", group_alive:GetName()))
        if (map_marker[group_alive:GetName()]) then
            COORDINATE:RemoveMark(map_marker[group_alive:GetName()])
        end
        group_alive:Destroy()
    end)
end

function deleteSubRangeUnits(param)
    local groupsToSpawn = param[1]
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    local radioCommandSubRange = param[4]
    for i = 1, #groupsToSpawn do
        destroyGroup(groupsToSpawn[i])
    end
    MESSAGE:NewType(string.format("Remove the target site : %s-%s", rangeConfig.name, subRangeConfig.name),
        MESSAGE.Type.Information):ToBlue()
    radioCommandSubRange:RemoveSubMenus()

    AddTargetsFunction(radioCommandSubRange, rangeConfig, subRangeConfig)
end

function smokeOnSubRange(param)
    local groupsToSpawn = param[1]
    local displayToCoalition = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        debug_msg(string.format("Smoke on group %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
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
    for i = 2, #groupsToSpawn do
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
    local staticToSpawn = subRangeConfig.staticToSpawn
    local holdFire = subRangeConfig.holdFire
    local AI = subRangeConfig.AI

    debug_msg(string.format("SpawnRanges : %s-%s", rangeName, subRangeName))
    for i = 1, #groupsToSpawn do
        local groupNameToSpawn = string.format("%s", groupsToSpawn[i])
        if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
            local spawnGroup = SPAWN:New(groupNameToSpawn)
            debug_msg(string.format("SPAWN %s", groupNameToSpawn))
            local groupSpawning = spawnGroup:Spawn()
            if (holdFire) then
                groupSpawning:OptionROEHoldFire()
            else
                groupSpawning:OptionROEWeaponFree()
            end
            if (AI == true or AI == false) then
                groupSpawning:SetAIOnOff(AI)
            end
            if (string.find(groupNameToSpawn, "SAM") ~= nil) then
                sead:UpdateSet(groupNameToSpawn)
                debug_msg(string.format("SEAD for %s", groupNameToSpawn))
            end
        else
            debug_msg(string.format("GROUP to spawn %s not found in mission", groupNameToSpawn))
        end
    end

    radioCommandSubRange:RemoveSubMenus()
    local CommandZoneDetroy = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Delete", radioCommandSubRange,
        deleteSubRangeUnits, {groupsToSpawn, rangeConfig, subRangeConfig, radioCommandSubRange})
    local CommandZoneFumigene = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Smoke", radioCommandSubRange,
        smokeOnSubRange, {groupsToSpawn, rangeConfig.benefit_coalition})
    local CommandZoneCoord = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Coordinates", radioCommandSubRange,
        giveToClientGroupCoordinates, {groupsToSpawn})
    local CommandZoneListGroup = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Groups", radioCommandSubRange,
        giveListOfGroupsAliveInRange, {groupsToSpawn, rangeConfig, subRangeConfig})
    local CommandZoneList = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Units", radioCommandSubRange,
        giveListOfUnitsAliveInGroup, {groupsToSpawn, rangeConfig.benefit_coalition, 5})
    MESSAGE:NewType(string.format("Targets in range %s(%s) in place", rangeName, subRangeName), MESSAGE.Type.Information):ToBlue()
    markGroupOnMap({groupsToSpawn, rangeConfig.benefit_coalition})
end

function AddTargetsFunction(radioCommandSubRange, rangeConfig, subRangeConfig)
    local RadioCommandAdd = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Spawn", radioCommandSubRange, SpawnRanges,
        {radioCommandSubRange, rangeConfig, subRangeConfig, AddTargetsFunction})
end


env.info('JTFF-SHAREDLIB: shared library loaded succesfully')
