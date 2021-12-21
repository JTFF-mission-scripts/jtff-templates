objAirboss = AIRBOSS:New('Naval-1-1', 'roosevelt')


trigger.action.outText('Sunset at  : '..objAirboss:GetCoordinate():GetSunset(true), 45)
trigger.action.outText('time is  : '..timer.getTime(), 45) -- temps depuis le debut de mission
trigger.action.outText('time0 is  : '..timer.getTime0(), 45) -- heure de debut de mission
trigger.action.outText('abstime is  : '..timer.getAbsTime(), 45) -- heure actuelle
