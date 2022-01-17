-- *****************************************************************************
--                     **                     Awacs                           **
--                     *********************************************************
AwacsArray = {}
compteur = 0
MenuCoalitionAwacsBlue = MENU_COALITION:New(coalition.side.BLUE, "Awacs", MenuCoalitionBlue)
MenuCoalitionAwacsRed = MENU_COALITION:New(coalition.side.RED, "Awacs", MenuCoalitionRed)
for index, awacsconfig in ipairs(AwacsConfig) do
    if awacsconfig.enable == true then
        compteur = compteur + 1
        env.info('creation AWACS : '.. awacsconfig.groupName..'...')
        local objAwacs = RECOVERYTANKER:New(UNIT:FindByName(awacsconfig.patternUnit), awacsconfig.groupName)
                                       :SetAWACS(true, true)
                                       :SetRespawnOnOff(awacsconfig.autorespawn)
                                       :SetLowFuelThreshold(awacsconfig.fuelwarninglevel)
                                       :SetAltitude(awacsconfig.altitude)
                                       :SetSpeed(awacsconfig.speed)
                                       :SetHomeBase(AIRBASE:FindByName(awacsconfig.baseUnit),awacsconfig.terminalType)
                                       :SetCallsign(awacsconfig.callsign.name, awacsconfig.callsign.number)
                                       :SetRecoveryAirboss(awacsconfig.airboss_recovery)
                                       :SetRadio(awacsconfig.freq)
                                       :SetModex(awacsconfig.modex)
                                       :SetRacetrackDistances(awacsconfig.racetrack.front, awacsconfig.racetrack.back)
        if (awacsconfig.airspawn) then
            objAwacs:SetTakeoffAir()
        else
            objAwacs:SetTakeoffCold()

        end
        if (awacsconfig.tacan) then
            objAwacs:SetTACAN(awacsconfig.tacan.channel , awacsconfig.tacan.morse)
        end
        objAwacs.customconfig = awacsconfig
        function objAwacs:OnAfterStart(from, event, to)
            env.info('popup AWACS : '..self.tanker.GroupName)
            if self.customconfig.escortgroupname then
                self.escortSpawnObject = SPAWN:NewWithAlias(self.customconfig.escortgroupname,'escort-'.. self.customconfig.groupName)
                                              :InitRepeatOnEngineShutDown()
                                              :InitSkill("Excellent")
                                              :OnSpawnGroup(function(SpawnGroup)
                    taskTankerEscort({self, SpawnGroup})
                end)
                self.escortGroupObject = spawnRecoveryTankerEscort(self.escortSpawnObject,self.customconfig)
                if self.customconfig.missionmaxduration then
                    self.escortGroupObject:ScheduleOnce(self.customconfig.missionmaxduration*60,
                            function(SpawnGroup, airBaseName)
                                --trigger.action.outText('RTB schedule trigger Tanker-escort group : '..(SpawnGroup.GroupName)..' airbase'..(airBaseName)..'...', 45)
                                SpawnGroup:RouteRTB(AIRBASE:FindByName(airBaseName))
                            end,
                            self.escortGroupObject,
                            self.customconfig.baseUnit
                    )
                    --trigger.action.outText('Tanker-escort configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
                end
            end
            if self.customconfig.missionmaxduration then
                (self.tanker):ScheduleOnce(self.customconfig.missionmaxduration*60,
                        function(tankerObject, airBaseName)
                            --trigger.action.outText('RTB schedule trigger AWACS group : '..(tankerObject.tanker.GroupName)..' airbase'..(tankerObject.customconfig.baseUnit)..'...', 45)
                            tankerObject:RTB(AIRBASE:FindByName(tankerObject.customconfig.baseUnit))
                        end,
                        self
                )
                --trigger.action.outText('AWACS configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
            end
            if (self.customconfig.benefit_coalition == coalition.side.RED) then
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.RED,
                        "Reset AWACS "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionAwacsRed,
                        resetRecoveryTanker,
                        self
                )
            else
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.BLUE,
                        "Reset AWACS "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionAwacsBlue,
                        resetRecoveryTanker,
                        self
                )
            end
        end
        function objAwacs:OnAfterRTB(from, event, to, airbase)
            if self.customconfig.escortgroupname then
                env.info('Tanker RTB: '..self.tanker.GroupName..'...')
                if self.escortGroupObject:IsAirborne(false) == true then
                    env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.tanker.GroupName..'...')
                    self.escortGroupObject:RouteRTB(airbase)
                else
                    --self.escortGroupObject:Destroy(nil, 5)
                end
            end
        end
        function objAwacs:OnEventKill(event)
            if self.customconfig.escortgroupname then
                env.info(event.target' Killed !! Sending escort Home')
                self.escortGroupObject:RouteRTB(AIRBASE:FindByName(self.customconfig.baseUnit))
            end
        end
        function objAwacs:OnAfterStatus(from, event, to)
            if ((self.customconfig.escortgroupname) and (self.escortGroupObject)) then
                if not(GROUP:FindByName(self.escortGroupObject.GroupName)) then
                    env.info('Respawning escort Group '..self.escortGroupObject.GroupName)
                    self.escortGroupObject = self.escortSpawnObject
                                                 :SpawnAtAirbase(AIRBASE:FindByName(self.customconfig.baseUnit),SPAWN.Takeoff.Cold, self.customconfig.altitude)
                end
            end
        end
        AwacsArray[compteur] = objAwacs
        AwacsArray[compteur]:Start()
    end
end
