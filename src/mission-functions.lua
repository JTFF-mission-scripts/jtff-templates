-- *****************************************************************************
-- *                           Mission functions                               *
-- *****************************************************************************
--
-- Generic Spawn object functions
--
env.info('JTFF-SHAREDLIB: shared library loading...')
DEBUG_MSG = true

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


env.info('JTFF-SHAREDLIB: shared library loaded succesfully')
