-- *****************************************************************************
--                     **                     Tankers                         **
--                     *********************************************************
tankersArray = {}
compteur = 0
MenuCoalitionTankerBlue = MENU_COALITION:New(coalition.side.BLUE, "Tankers", MenuCoalitionBlue)
MenuCoalitionTankerRed = MENU_COALITION:New(coalition.side.RED, "Tankers", MenuCoalitionRed)
for index, tankerconfig in ipairs(TankersConfig) do
    if tankerconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Tanker : '.. tankerconfig.groupName..'...')
        local objTanker = RECOVERYTANKER:New(UNIT:FindByName(tankerconfig.patternUnit), tankerconfig.groupName)
                                        :SetTakeoffCold()
                                        :SetRespawnOnOff(tankerconfig.autorespawn)
                                        :SetLowFuelThreshold(tankerconfig.fuelwarninglevel)
                                        :SetAltitude(tankerconfig.altitude)
                                        :SetSpeed(tankerconfig.speed)
                                        :SetHomeBase(AIRBASE:FindByName(tankerconfig.baseUnit),tankerconfig.terminalType)
                                        :SetCallsign(tankerconfig.callsign.name, tankerconfig.callsign.number)
                                        :SetRecoveryAirboss(tankerconfig.airboss_recovery)
                                        :SetRadio(tankerconfig.freq)
                                        :SetModex(tankerconfig.modex)
                                        :SetTACAN(tankerconfig.tacan.channel, tankerconfig.tacan.band, tankerconfig.tacan.morse)
                                        :SetRacetrackDistances(tankerconfig.racetrack.front, tankerconfig.racetrack.back)
        objTanker.customconfig = tankerconfig
        function objTanker:OnAfterStart(from, event, to)
            env.info('popup Tanker : '..self.tanker.GroupName)
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
                            --trigger.action.outText('RTB schedule trigger Tanker group : '..(tankerObject.tanker.GroupName)..' airbase'..(tankerObject.customconfig.baseUnit)..'...', 45)
                            tankerObject:RTB(AIRBASE:FindByName(tankerObject.customconfig.baseUnit))
                        end,
                        self
                )
                --trigger.action.outText('Tanker configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
            end
            if (self.customconfig.benefit_coalition == coalition.side.RED) then
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.RED,
                        "Reset Tanker "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionTankerRed,
                        resetRecoveryTanker,
                        self
                )
            else
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.BLUE,
                        "Reset Tanker "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionTankerBlue,
                        resetRecoveryTanker,
                        self
                )
            end
        end
        function objTanker:OnAfterRTB(from, event, to, airbase)
            if self.customconfig.escortgroupname then
                env.info('Tanker RTB: '..self.tanker.GroupName..'...')
                if self.escortGroupObject:IsAirborne(false) == true then
                    env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.tanker.GroupName..'...')
                    self.escortGroupObject:RouteRTB(airbase)
                else
                    --self.escortGroupObject:Destroy(nil, 5)
                end
            end
            trigger.action.outText('Tanker is RTB : '..(self.customconfig.groupName)..'...', 45)
        end
        function objTanker:OnEventKill(event)
            if self.customconfig.escortgroupname then
                env.info(event.target' Killed !! Sending escort Home')
                self.escortGroupObject:RouteRTB(AIRBASE:FindByName(self.customconfig.baseUnit))
            end
        end
        function objTanker:OnAfterStatus(from, event, to)
            if ((self.customconfig.escortgroupname) and (self.escortGroupObject)) then
                if not(GROUP:FindByName(self.escortGroupObject.GroupName)) then
                    env.info('Respawning escort Group '..self.escortGroupObject.GroupName)
                    self.escortGroupObject = self.escortSpawnObject
                                                 :SpawnAtAirbase(AIRBASE:FindByName(self.customconfig.baseUnit),SPAWN.Takeoff.Cold, self.customconfig.altitude)
                end
            end
        end
        tankersArray[compteur] = objTanker
        tankersArray[compteur]:Start()
    end
end

