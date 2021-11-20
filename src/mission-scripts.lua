-- *****************************************************************************
--                     **                    Root Menus                       **
--                     *********************************************************
MenuCoalitionBlue = MENU_COALITION:New(coalition.side.BLUE, "My Coalition resources")
MenuCoalitionRed = MENU_COALITION:New(coalition.side.RED, "My Coalition resources")

-- *****************************************************************************
--                     **                    Set_Client                       **
--                     *********************************************************
Set_CLIENT = SET_CLIENT:New():FilterOnce()
Set_CLIENT:HandleEvent(EVENTS.Refueling)
Set_CLIENT:HandleEvent(EVENTS.RefuelingStop)
Set_CLIENT:HandleEvent(EVENTS.PlayerEnterAircraft)
function Set_CLIENT:OnEventPlayerEnterAircraft(EventData)
    if (EventData.IniGroup) then
        local clientSetting = SETTINGS:Set( EventData.IniPlayerName)
        clientSetting:SetImperial()
        clientSetting:SetA2G_MGRS()
        clientSetting:SetMenutextShort(true)
        debug_msg(string.format("Add Tanker Menu for group [%s], player name [%s]",EventData.IniGroupName , EventData.IniPlayerName))
        --local TankerMenu = MENU_GROUP:New( EventData.IniGroup, "Tanker Menu" )
        --MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", TankerMenu, NearestTankerInfo, { EventData.IniUnit, EventData.IniGroup}  )
        --MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", TankerMenu, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
        if EventData.IniUnit:GetCoalition() == coalition.side.BLUE then
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", MenuCoalitionTankerBlue, NearestTankerInfo, { EventData.IniUnit, EventData.IniGroup}  )
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", MenuCoalitionTankerBlue, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
        else
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", MenuCoalitionTankerRed, NearestTankerInfo, { EventData.IniUnit, EventData.IniGroup}  )
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", MenuCoalitionTankerRed, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
        end
        local GroupMenu = MENU_GROUP:New( EventData.IniGroup, "My settings" )
        debug_msg(string.format("Add Immortal Menu for group [%s], player name [%s]",EventData.IniGroupName , EventData.IniPlayerName))
        BASE:SetState( EventData.IniGroup, "isImmortal", false )
        MENU_GROUP_COMMAND:New( EventData.IniGroup, "Switch immortal status", GroupMenu, switchGroupImmortalStatus, EventData.IniGroup )
    end 
end
function Set_CLIENT:OnEventRefueling(EventData)
    if (EventData.IniGroup) then
        local client = CLIENT:Find(EventData.IniDCSUnit)
        local clientFuel = EventData.IniUnit:GetTemplateFuel()
        debug_msg(string.format("[%s] Start to refuel at the tanker %[s], current fuel : %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuel))
        BASE:SetState( client, "Fuel", clientFuel )
    end
end
function Set_CLIENT:OnEventRefuelingStop(EventData)
    if (EventData.IniGroup) then
        local client = CLIENT:Find(EventData.IniDCSUnit)
        local clientFuelTaken = EventData.IniUnit:GetTemplateFuel() - BASE:GetState(client,"Fuel")
        debug_msg(string.format("[%s] Stop to refuel at the tanker %[s], taken %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuelTaken))
    end
end

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
            self.menureset = MENU_COALITION_COMMAND:New(
                    coalition.side.BLUE,
                    "Reset Tanker "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                    MenuCoalitionTankerBlue,
                    resetRecoveryTanker,
                    self
            )
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
--                     **                       AirBoss                       **
--                     *********************************************************
AIRBOSSArray = {}
compteur = 0
for index, airbossconfig in ipairs(AirBossConfig) do
    if airbossconfig.enable == true then
        compteur = compteur +1
        --populate_SC(airbossconfig.carriername)
        local objAirboss = AIRBOSS:New(airbossconfig.carriername, airbossconfig.alias)
        objAirboss:SetTACAN(airbossconfig.tacan.channel, airbossconfig.tacan.mode, airbossconfig.tacan.morse)
        objAirboss:SetICLS(airbossconfig.icls.channel, airbossconfig.icls.morse)
        objAirboss:SetLSORadio(airbossconfig.freq.lso)
        objAirboss:SetMarshalRadio(airbossconfig.freq.marshall)
        objAirboss:SetPatrolAdInfinitum(airbossconfig.infintepatrol)
        objAirboss:SetCarrierControlledArea(airbossconfig.controlarea)
        objAirboss:SetStaticWeather(true)
        objAirboss:SetRespawnAI(false)
        objAirboss:SetRecoveryCase(airbossconfig.recoverycase)
        objAirboss:SetEmergencyLandings(true)
        objAirboss:SetMaxLandingPattern(airbossconfig.maxpatterns)
        objAirboss:SetMaxSectionSize(4)
        objAirboss:SetMaxMarshalStacks(airbossconfig.maxstacks)
        objAirboss:SetDefaultPlayerSkill(airbossconfig.difficulty) -- other options EASY / HARD
        if airbossconfig.wirecorrection then
            objAirboss:SetMPWireCorrection(airbossconfig.wirecorrection)
        else
            objAirboss:SetMPWireCorrection()
        end
        if airbossconfig.operationsstatspath then
            objAirboss:Load(airbossconfig.operationsstatspath)
            if airbossconfig.operationsstatspath then
                objAirboss:SetTrapSheet(airbossconfig.operationstrapsheetpath)
            end
            --objAirboss:SetAutoSave(airbossconfig.operationsstatspath)
        end
        if airbossconfig.handleAI == true then
            objAirboss:SetHandleAION()
            objAirboss:SetDespawnOnEngineShutdown(true)
        else
            objAirboss:SetHandleAIOFF()
        end
        if airbossconfig.recoverytanker then
            for index,value in pairs(tankersArray) do
                if ((value.customconfig.airboss_recovery == true) and (value.customconfig.groupName == airbossconfig.recoverytanker))then
                    objAirboss:SetRecoveryTanker(tankersArray[index])
                    trigger.action.outText('Recovery Tanker configured : '..airbossconfig.recoverytanker, 30)
                    break
                end
            end
        end
        if airbossconfig.menurecovery.enable == true then
            objAirboss:SetMenuRecovery(airbossconfig.menurecovery.duration,
                    airbossconfig.menurecovery.windondeck,
                    airbossconfig.menurecovery.uturn,
                    airbossconfig.menurecovery.offset)
        end
        objAirboss:SetMenuMarkZones(airbossconfig.enable_menumarkzones)
        objAirboss:SetMenuSmokeZones(airbossconfig.enable_menusmokezones)
        objAirboss:SetAirbossNiceGuy(airbossconfig.enable_niceguy)
        objAirboss:SetRadioRelayMarshal(airbossconfig.releayunit.marshall)
        objAirboss:SetRadioRelayLSO(airbossconfig.releayunit.lso)
        objAirboss:SetSoundfilesFolder("AIRBOSS/Airboss Soundfiles/")
        objAirboss:SetVoiceOversLSOByFF('AIRBOSS/Airboss Soundpack LSO FF')
        objAirboss:SetVoiceOversMarshalByGabriella('AIRBOSS/Airboss Soundpack Marshal Gabriella')
        objAirboss:SetDebugModeOFF()
        objAirboss.trapsheet = false
        if airbossconfig.singlecarrier == true then
            objAirboss:SetMenuSingleCarrier()
        end
        if not(airbossconfig.event_duration_minutes) then
            airbossconfig.event_duration_minutes = 60
        end
        objAirboss.customconfig = airbossconfig
        --airbossCVN:Load(nil, "Greenie Board.csv")
        --airbossCVN:SetAutoSave(nil, "Greenie Board.csv")

        -- create fake recovery window at the end of the mission play
        --local window1 = airbossCVN:AddRecoveryWindow("15:00", "16:30", 3, 30, true, 20, false)
        --local window2 = airbossCVN:AddRecoveryWindow("18:00", "20:30", 3, 30, true, 20, false)
        --objAirboss:AddRecoveryWindow(
        --        60*45,
        --        60*(airbossconfig.menurecovery.duration+45),
        --        airbossconfig.recoverycase,
        --        airbossconfig.menurecovery.offset,
        --        true,
        --        airbossconfig.menurecovery.windondeck,
        --        airbossconfig.menurecovery.uturn
        --)

        function objAirboss:OnAfterLSOGrade(From, Event, To, playerData, myGrade)

            local string_grade = myGrade.grade
            local player_callsign = playerData.callsign
            local unit_name = playerData.unitname
            local player_name = playerData.name
            local player_wire = playerData.wire

            player_name = player_name:gsub('[%p]', '')
            local client_performing_sh = USERFLAG:New(UNIT:FindByName(unit_name):GetClient():GetClientGroupID() + 100000000)
            --local gradeForFile
            if  string_grade == "_OK_" then
                --if  string_grade == "_OK_" and player_wire == "3" and player_Tgroove >=15 and player_Tgroove <19 then
                timer.scheduleFunction(
                        function()
                            trigger.action.outSound("Airboss Soundfiles/ffyrtp.ogg")
                        end,
                        {},
                        timer.getTime() + 5
                )
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "_OK_<SH>"
                    myGrade.points = myGrade.points
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_unicorn_AIRBOSS-trapsheet-"..player_name)
                    timer.scheduleFunction(
                            function()
                                trigger.action.outSound("Airboss Soundfiles/sureshot.ogg")
                            end,
                            {},
                            timer.getTime() + 5
                    )
                else
                    self:SetTrapSheet(self.trappath, "unicorn_AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "OK" and player_wire >1 then
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "OK<SH>"
                    myGrade.points = myGrade.points + 0.5
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "(OK)" and player_wire >1 then
                self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "(OK)<SH>"
                    myGrade.points = myGrade.points + 1.00
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "--" and player_wire >1 then
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "--<SH>"
                    myGrade.points = myGrade.points + 1.00
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end
            else
                self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
            end
            myGrade.messageType = 2
            myGrade.callsign = playerData.callsign
            myGrade.name = playerData.name
            myGrade.airbossconfig = self.customconfig
            if playerData.wire == 1 then
                myGrade.points = myGrade.points -1.00
                local onewire_to_discord = ('**'..player_name..' almost had a rampstrike with that 1-wire!**')
                HypeMan.sendBotMessage(onewire_to_discord)
            end
            self:_SaveTrapSheet(playerData, myGrade)
            HypeMan.sendBotTable(myGrade)

            --TODO reactivate the timer.schedule maybe ?
            --timer.scheduleFunction(
            --        function(airbossObject)
            --            airbossObject:SetTrapSheet(airbossObject.trappath)
            --        end,
            --        {self},
            --        timer.getTime() + 10
            --)
            --local myScheduleTime = TIMER:New(10, nil,nil):resetTrapSheetFileFormat()
        end



        function objAirboss:OnAfterRecoveryStart(From, Event, To, Case, Offset)
            EnterRecovery(self, Case)
            trigger.action.outText(self.customconfig.alias..' : Event Start !',45)
        end

        function objAirboss:OnAfterRecoveryStop(From, Event, To)
            trigger.action.outText(self.customconfig.carriername..': Recovery finished.', 30)
            if self.recoverywindow then
                if ((timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*1/3, 0) > self.recoverywindow.STOP)
                        or (timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*3/3, 0) < self.recoverywindow.START)) then
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*3/3, 0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                        --fin du prochain event apres la nuit aeronavale
                        trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
                        self:SetRecoveryCase(3)
                        self:SetMaxSectionSize(1)
                    else
                        if ((timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
                            --debut du prochain recovery apres l aube aeronavale
                            self:SetRecoveryCase(self.customconfig.recoverycase)
                            if self.customconfig.recoverycase == 3 then
                                self:SetMaxSectionSize(1)
                            else
                                self:SetMaxSectionSize(4)
                            end
                        end
                    end
                    self:AddRecoveryWindow(
                            UTILS.Round(self.customconfig.event_duration_minutes*60*1/3, 0),
                            UTILS.Round(self.customconfig.event_duration_minutes*60*3/3, 0),
                            self.defaultcase,
                            self.customconfig.menurecovery.offset,
                            true,
                            self.customconfig.menurecovery.windondeck,
                            self.customconfig.menurecovery.uturn
                    )
                    trigger.action.outText(self.customconfig.carriername..': Next Recovery in : '..UTILS.Round(self.customconfig.event_duration_minutes/3, 0)..' minutes', 30)
                    --LeaveRecovery(self)
                end
            else
                if ((timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*3/3,0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                    --fin du prochain event apres la nuit aeronavale
                    trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
                    self:SetRecoveryCase(3)
                    self:SetMaxSectionSize(1)
                else
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
                        --debut du prochain recovery apres l aube aeronavale
                        self:SetRecoveryCase(self.customconfig.recoverycase)
                        if self.customconfig.recoverycase == 3 then
                            self:SetMaxSectionSize(1)
                        else
                            self:SetMaxSectionSize(4)
                        end
                    end
                end
                self:AddRecoveryWindow(
                        UTILS.Round(self.customconfig.event_duration_minutes*60*1/3, 0),
                        UTILS.Round(self.customconfig.event_duration_minutes*60*3/3, 0),
                        self.defaultcase,
                        self.customconfig.menurecovery.offset,
                        true,
                        self.customconfig.menurecovery.windondeck,
                        self.customconfig.menurecovery.uturn
                )
                trigger.action.outText(self.customconfig.carriername..': Next Recovery in : '..UTILS.Round(self.customconfig.event_duration_minutes/3, 0)..' minutes', 30)
                --LeaveRecovery(self)
            end
        end

        AIRBOSSArray[compteur] = objAirboss
        AIRBOSSArray[compteur]:Start()
        AIRBOSSArray[compteur].CVN_GROUPZone = ZONE_GROUP:New(
                'cvnGroupZone-'..AIRBOSSArray[compteur].customconfig.alias,
                AIRBOSSArray[compteur].carrier:GetGroup(),
                1111)
        AIRBOSSArray[compteur].BlueCVNClients = SET_CLIENT:New()
                                                          :FilterCoalitions(AIRBOSSArray[compteur].customconfig.coalition)
                                                          :FilterStart()
        local myscheduler
        local myschedulerID
        myscheduler, myschedulerID = SCHEDULER:New(
                nil,
                detectShitHotBreak,
                {AIRBOSSArray[compteur]},
                2,
                1
        )
        AIRBOSSArray[compteur].scheduler = myscheduler
        AIRBOSSArray[compteur].schedulerID = myschedulerID
        trigger.action.outText('INFO '..airbossconfig.alias..' : Naval sunset at '..UTILS.SecondsToClock((AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)), 75)
        if ((timer.getAbsTime() + airbossconfig.event_duration_minutes*60) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)) then
            trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
            AIRBOSSArray[compteur]:SetRecoveryCase(3)
            AIRBOSSArray[compteur]:SetMaxSectionSize(1)
        else
            if ((timer.getAbsTime() + UTILS.Round(airbossconfig.event_duration_minutes*60/3, 0)) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunrise(true) + 30*60)) then
                AIRBOSSArray[compteur]:SetRecoveryCase(airbossconfig.recoverycase)
                if airbossconfig.recoverycase == 3 then
                    AIRBOSSArray[compteur]:SetMaxSectionSize(1)
                else
                    AIRBOSSArray[compteur]:SetMaxSectionSize(4)
                end
            end
        end
        if airbossconfig.event_ia_reserved_minutes then
            AIRBOSSArray[compteur]:AddRecoveryWindow(
                    (airbossconfig.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.event_duration_minutes*60*0/3, 0),
                    (airbossconfig.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.event_duration_minutes*60*2/3, 0),
                    AIRBOSSArray[compteur].defaultcase,
                    airbossconfig.menurecovery.offset,
                    true,
                    airbossconfig.menurecovery.windondeck,
                    airbossconfig.menurecovery.uturn
            )
        else
            AIRBOSSArray[compteur]:AddRecoveryWindow(
                    15*60+UTILS.Round(airbossconfig.event_duration_minutes*60*0/3, 0),
                    15*60+UTILS.Round(airbossconfig.event_duration_minutes*60*2/3, 0),
                    AIRBOSSArray[compteur].defaultcase,
                    airbossconfig.menurecovery.offset,
                    true,
                    airbossconfig.menurecovery.windondeck,
                    airbossconfig.menurecovery.uturn
            )
        end
        trigger.action.outText('AIRBOSS scripts Loaded for unit '..airbossconfig.carriername, 10)
        timer.scheduleFunction(function()
            trigger.action.outText(	"<< If the AIRBOSS option does not appear in your F10 - Other Menu, try switching slots a few times and you will get the AIRBOSS message popups! Check the AIRBOSS documentation (link in briefing for more info) >>", 30)
        end, nil, timer.getTime() + 30  )
    else
        timer.scheduleFunction(function()
            trigger.action.outText('AIRBOSS script disabled for unit '..airbossconfig.carriername, 10)
        end, nil, timer.getTime() + 8  )
    end
end


-- *****************************************************************************
--                     **                     Rescue Hello                    **
--                     *********************************************************
PedroArray = {}
compteur = 0
for index,pedro in ipairs(PedrosConfig) do
    if pedro.enable == true then
        compteur = compteur +1
        local rescuehelo = RESCUEHELO:New(UNIT:FindByName(pedro.patternUnit),pedro.groupName)
                                     :SetHomeBase(AIRBASE:FindByName(pedro.baseUnit))
                                     :SetTakeoffCold()
                                     :SetRespawnOnOff(pedro.autorespawn)
                                     :SetRescueDuration(1)
                                     :SetModex(pedro.modex)
        function rescuehelo:OnAfterStart(from, event, to)
            self.helo:CommandSetFrequency(pedro.freq, radio.modulation.AM)
        end
        PedroArray[compteur] = rescuehelo
        PedroArray[compteur]:Start()
    end
end



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
            self.menureset = MENU_COALITION_COMMAND:New(
                    coalition.side.BLUE,
                    "Reset AWACS "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                    MenuCoalitionAwacsBlue,
                    resetRecoveryTanker,
                    self
            )
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

-- *****************************************************************************
--                     **                        ATIS                         **
--                     *********************************************************
ATISArray = {}
compteur = 0
for index, atisconfig in ipairs(AtisConfig) do
    if atisconfig.enable == true then
        compteur = compteur + 1
        env.info('creation ATIS : '.. atisconfig.airfield..'...')
        local objAtis = ATIS:New(atisconfig.airfield, atisconfig.radio.freq, atisconfig.radio.modulation)
                            :SetImperialUnits()
                            :SetSoundfilesPath('ATIS/ATIS Soundfiles/')
                            :SetSubtitleDuration(0)
                            :SetMapMarks(true)
        if (atisconfig.radio.relayunit) then
            objAtis:SetRadioRelayUnitName(atisconfig.radio.relayunit)
        else
            if (atisconfig.radio.power) then
                objAtis:SetRadioPower(atisconfig.radio.power)
            end
        end
        if (atisconfig.radio.tower) then
            objAtis:SetTowerFrequencies(atisconfig.radio.tower);
        end
        if (atisconfig.active.side) then
            if (atisconfig.active.number) then
                objAtis:SetActiveRunway(atisconfig.active.number..atisconfig.active.side)
            else
                objAtis:SetActiveRunway(atisconfig.active.side)
            end
        else
            if (atisconfig.active.number) then
                objAtis:SetActiveRunway(atisconfig.active.number)
            end
        end
        if (atisconfig.tacan) then
            objAtis:SetTACAN(atisconfig.tacan.channel)
        end
        if (atisconfig.ils) then
            if (atisconfig.ils.runway) then
                objAtis:AddILS(atisconfig.ils.freq, atisconfig.ils.runway)
            else
                objAtis:AddILS(atisconfig.ils.freq)
            end
        end
        if (atisconfig.srs) then
            objAtis:SetSRS(atisconfig.srs.path, "male", "en-US")
        end
        objAtis.customconfig = atisconfig
        ATISArray[compteur] = objAtis
        ATISArray[compteur]:Start()
    end
end

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

-- *****************************************************************************
--                     **                    Random Air Traffic               **
--                     *********************************************************
RATArray = {}
compteur = 0
for index, ratconfig in ipairs(RATConfig) do
    if ratconfig.enable == true then
        compteur = compteur +1
        for index_planegroup, planegroupconfig in ipairs(ratconfig.aircrafts_groupconfigs) do
            if planegroupconfig.spawns > 0 then
                local RATGroup = RAT:New(planegroupconfig.templatename)
                RATGroup:SetDeparture(planegroupconfig.airbases_names.departure)
                RATGroup:SetDestination(planegroupconfig.airbases_names.arrival)
                RATGroup:TimeDestroyInactive(planegroupconfig.inactive_timer)
                RATGroup:ATC_Messages(planegroupconfig.atcmessage_enable)
                RATGroup:SetFLcruise(planegroupconfig.flightlevel)
                RATGroup:SetEPLRS(true)
                RATGroup:SetMaxCruiseSpeed(UTILS.Round(planegroupconfig.speed*1.852, 0))
                if planegroupconfig.allow_immortal == true then
                    RATGroup:Immortal()
                end
                if planegroupconfig.allow_invisible == true then
                    RATGroup:Invisible()
                end
                RATArray[compteur] = RATGroup
                RATArray[compteur]:Spawn(planegroupconfig.spawns)
            end
        end
        timer.scheduleFunction(function()
            trigger.action.outText('Random Air Traffic '..ratconfig.name..' is ENABLED...', 10)
        end, nil, timer.getTime() + 8  )
    else
        timer.scheduleFunction(function()
            trigger.action.outText('Random Air Traffic '..ratconfig.name..' is DISABLED', 10)
        end, nil, timer.getTime() + 8)
    end
end


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

-- *****************************************************************************
--                     **                     BEACONS                         **
--                     *********************************************************
BeaconArray = {}
compteur = 0
for index, beaconconfig in ipairs(BeaconsConfig) do
    if beaconconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Beacon Zone : '.. beaconconfig.name..'...')
        local myunit = UNIT:FindByName(beaconconfig.unitName)
        local mybeacon = myunit:GetBeacon()
        mybeacon.customconfig = beaconconfig
        BeaconArray[compteur] = mybeacon
        BeaconArray[compteur]:ActivateTACAN(beaconconfig.tacan.channel,
                beaconconfig.tacan.band,
                beaconconfig.tacan.morse,
                true)
    end
end


-- *****************************************************************************
--                     **                     RANGES                         **
--                     *********************************************************

mainRadioMenuForRanges   =  MENU_COALITION:New( coalition.side.BLUE , "RANGES" )
for index, rangeConfig in ipairs(RangeConfig) do
    local radioMenuForRange   =  MENU_COALITION:New( coalition.side.BLUE, rangeConfig.name ,   mainRadioMenuForRanges )
    for index, subRangeConfig in ipairs(rangeConfig.subRange) do
        local radioMenuSubRange     = MENU_COALITION:New(coalition.side.BLUE, subRangeConfig.name,   radioMenuForRange)
        AddTargetsFunction(radioMenuSubRange, rangeConfig, subRangeConfig)
    end
end
