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
        if (airbossconfig.recoveryops.mode == 'cyclic') then
            if not(airbossconfig.recoveryops.cyclic.event_duration_minutes) then
                airbossconfig.recoveryops.cyclic.event_duration_minutes = 60
            end
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
            if (airbossconfig.recoveryops.mode == 'cyclic') then
                if self.recoverywindow then
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0) > self.recoverywindow.STOP)
                            or (timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0) < self.recoverywindow.START)) then
                        if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                            --fin du prochain event apres la nuit aeronavale
                            trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
                            self:SetRecoveryCase(3)
                            self:SetMaxSectionSize(1)
                        else
                            if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
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
                                UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0),
                                UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0),
                                self.defaultcase,
                                self.customconfig.menurecovery.offset,
                                true,
                                self.customconfig.menurecovery.windondeck,
                                self.customconfig.menurecovery.uturn
                        )
                        trigger.action.outText(self.customconfig.carriername..': Next Recovery in : '..UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes/3, 0)..' minutes', 30)
                        --LeaveRecovery(self)
                    end
                else
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3,0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                        --fin du prochain event apres la nuit aeronavale
                        trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
                        self:SetRecoveryCase(3)
                        self:SetMaxSectionSize(1)
                    else
                        if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
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
                            UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0),
                            UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0),
                            self.defaultcase,
                            self.customconfig.menurecovery.offset,
                            true,
                            self.customconfig.menurecovery.windondeck,
                            self.customconfig.menurecovery.uturn
                    )
                    trigger.action.outText(self.customconfig.carriername..': Next Recovery in : '..UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes/3, 0)..' minutes', 30)
                    --LeaveRecovery(self)
                end
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
        if (airbossconfig.recoveryops.mode == 'cyclic') then
            if ((timer.getAbsTime() + airbossconfig.recoveryops.cyclic.event_duration_minutes*60) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)) then
                trigger.action.outText('switching to case III due to Naval Sunset on the next event !', 45)
                AIRBOSSArray[compteur]:SetRecoveryCase(3)
                AIRBOSSArray[compteur]:SetMaxSectionSize(1)
            else
                if ((timer.getAbsTime() + UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60/3, 0)) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunrise(true) + 30*60)) then
                    AIRBOSSArray[compteur]:SetRecoveryCase(airbossconfig.recoverycase)
                    if airbossconfig.recoverycase == 3 then
                        AIRBOSSArray[compteur]:SetMaxSectionSize(1)
                    else
                        AIRBOSSArray[compteur]:SetMaxSectionSize(4)
                    end
                end
            end
            if airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes then
                AIRBOSSArray[compteur]:AddRecoveryWindow(
                        (airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*0/3, 0),
                        (airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*2/3, 0),
                        AIRBOSSArray[compteur].defaultcase,
                        airbossconfig.menurecovery.offset,
                        true,
                        airbossconfig.menurecovery.windondeck,
                        airbossconfig.menurecovery.uturn
                )
            else
                AIRBOSSArray[compteur]:AddRecoveryWindow(
                        15*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*0/3, 0),
                        15*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*2/3, 0),
                        AIRBOSSArray[compteur].defaultcase,
                        airbossconfig.menurecovery.offset,
                        true,
                        airbossconfig.menurecovery.windondeck,
                        airbossconfig.menurecovery.uturn
                )
            end
        else
            if (airbossconfig.recoveryops.mode == 'alpha') then
                if (airbossconfig.recoveryops.alpha) then
                    if (airbossconfig.recoveryops.alpha.recoveries) then
                        for alphaindex, alphaevent in ipairs(airbossconfig.recoveryops.alpha.recoveries) do
                            local effectiveeventcase = airbossconfig.recoverycase or 1
                            if (alphaevent.recovery_case) then
                                effectiveeventcase = alphaevent.recovery_case
                            end
                            if (env.mission.start_time +
                                    ( ( alphaevent.recovery_start_minutes +
                                            alphaevent.recovery_duration_minutes ) * 60
                                    )
                                    >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)) then
                                effectiveeventcase = 3
                            end
                            AIRBOSSArray[compteur]:AddRecoveryWindow(
                                    UTILS.SecondsToClock(env.mission.start_time + (alphaevent.recovery_start_minutes * 60) ),
                                    UTILS.SecondsToClock(env.mission.start_time +
                                            ( (alphaevent.recovery_start_minutes + alphaevent.recovery_duration_minutes) * 60)),
                                    effectiveeventcase,
                                    airbossconfig.menurecovery.offset,
                                    true,
                                    airbossconfig.menurecovery.windondeck,
                                    airbossconfig.menurecovery.uturn
                            )
                        end
                    end
                end
            end
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
