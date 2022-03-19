-- *****************************************************************************
--                     **                Training RANGES                      **
--                     *********************************************************

TrainingRangeArray = {}
compteur = 0
for index, traingingrangeconfig in ipairs(TrainingRangeConfig) do
    if traingingrangeconfig.enable == true then
        compteur = compteur + 1
        env.info('creation of Training Range : ' .. traingingrangeconfig.name .. '...')
        TrainingRangeArray[compteur] = {
            customconfig = traingingrangeconfig
        }
        trainingRange = RANGE:New(traingingrangeconfig.name)
        trainingRange:SetDefaultPlayerSmokeBomb(false)
        trainingRange:SetRangeRadius(0.2) -- bomb impact at more than 200m is out of range
        trainingRange:SetScoreBombDistance(100)-- bomb impact at more than 100m won't be taken into account
        for index, subrangeTraining in ipairs(traingingrangeconfig.targets) do
            env.info('subrangeTraining type : ' .. subrangeTraining.type)
            if (subrangeTraining.type == "Strafepit") then
                local fouldist = trainingRange:GetFoullineDistance(subrangeTraining.unit_name,
                        subrangeTraining.foul_line)
                env.info('Add strafe pit : ' .. subrangeTraining.unit_name)
                trainingRange:AddStrafePit(subrangeTraining.unit_name, subrangeTraining.boxlength,
                        subrangeTraining.boxwidth, subrangeTraining.heading, subrangeTraining.inverseheading,
                        subrangeTraining.goodpass, fouldist)
            elseif (subrangeTraining.type == "BombCircle") then
                env.info('Add bombing target : ' .. subrangeTraining.unit_name)
                trainingRange:AddBombingTargets(subrangeTraining.unit_name, subrangeTraining.precision)
            end
        end
        trainingRange:Start()
    end
end
