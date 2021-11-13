-- *****************************************************************************
-- *                           Mission functions                               *
-- *****************************************************************************
--
-- Generic Spawn object functions
--
env.info('JTFF-SHAREDLIB: shared library loading...')
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
