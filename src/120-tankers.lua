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

-- *****************************************************************************
--                     **                OnDemand Tankers                     **
--                     *********************************************************
--local RestrToCoal = nil
local MarkHandler = {}
local DebugMode = false

local CmdSymbol = "-"

function MarkHandler:onEvent(event)

    if event.id == 25 then
        --trigger.action.outText(" ", 0, true)
    elseif (event.id == 27 and string.find(event.text, CmdSymbol)) then
        --if (event.coalition == RestrToCoal or RestrToCoal == nil) then
            local full = nil
            local remString = nil
            local cmd = nil
            local param1 = nil
            local param1Start = nil
            local param2 = nil
            local param2Start = nil
            local param3 = nil
            local param3Start = nil
            local param4 = nil
            local param4Start = nil
            local param5 = nil
            local param5Start = nil
            local param6 = nil
            local param6Start = nil
            local mcoord = COORDINATE:New(event.pos.x, event.pos.y, event.pos.z)
            local mvec3 = event.pos

            full = string.sub(event.text, 2)

            if (string.find(full, CmdSymbol)) then
                param1Start = string.find(full, CmdSymbol)
                cmd = string.sub(full, 0, param1Start-1)
                remString = string.sub(full, param1Start+1)
                if (string.find(remString, CmdSymbol)) then
                    param2Start = string.find(remString, CmdSymbol)
                    param1 = string.sub(remString, 0, param2Start-1)
                    remString = string.sub(remString, param2Start+1)
                    if string.find(remString, CmdSymbol) then
                        param3Start = string.find(remString, CmdSymbol)
                        param2 = string.sub(remString, 0, param3Start-1)
                        remString = string.sub(remString, param3Start+1)
                        if string.find(remString, CmdSymbol) then
                            param4Start = string.find(remString, CmdSymbol)
                            param3 = string.sub(remString, 0, param4Start-1)
                            remString = string.sub(remString, param4Start+1)

                            if string.find(remString, CmdSymbol) then
                                param5Start = string.find(remString, CmdSymbol)
                                param4 = string.sub(remString, 0, param5Start-1)
                                remString = string.sub(remString, param5Start+1)

                                if string.find(remString, CmdSymbol) then
                                    param6Start = string.find(remString, CmdSymbol)
                                    param5 = string.sub(remString, 0, param6Start-1)
                                    param6 = string.sub(remString, param6Start+1)
                                else
                                    param5 = remString
                                end
                            else
                                param4 = remString
                            end
                        else
                            param3 = remString
                        end
                    else
                        param2 = remString
                    end
                else
                    param1 = remString
                end
            else
                cmd = full
            end
            if DebugMode == true then
                trigger.action.outText("Voller Text = " .. full, 10)
                trigger.action.outText("Befehl = " .. cmd, 10)
                if param1 ~= nil then trigger.action.outText("Parameter1 = " .. param1, 10) end
                if param2 ~= nil then trigger.action.outText("Parameter2 = " .. param2, 10) end
                if param3 ~= nil then trigger.action.outText("Parameter3 = " .. param3, 10) end
                if param4 ~= nil then trigger.action.outText("Parameter4 = " .. param4, 10) end
                if param5 ~= nil then trigger.action.outText("Parameter5 = " .. param5, 10) end
                if param6 ~= nil then trigger.action.outText("Parameter6 = " .. param6, 10) end
            end

            if string.find(cmd, "tanker") then
                if DebugMode == true then
                    trigger.action.outText("DEBUG: On Demand Tanker Started!", 10)
                end
                triggerOnDemandTanker(param1, param2, mcoord)
            end
        --end
    end

end

world.addEventHandler(MarkHandler)
