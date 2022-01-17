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
