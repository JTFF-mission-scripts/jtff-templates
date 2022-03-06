-- *****************************************************************************
--                     **                     RANGES                         **
--                     *********************************************************

IADSArray = {}
compteur = 0
mainRadioMenuForRangesBlue =  MENU_COALITION:New( coalition.side.BLUE , "RANGES", MenuCoalitionBlue )
mainRadioMenuForRangesRed =  MENU_COALITION:New( coalition.side.RED , "RANGES", MenuCoalitionRed )
for index, rangeconfig in ipairs(RangeConfig) do
    if rangeconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Range : '.. rangeconfig.name..'...')
        IADSArray[compteur] = {
            customconfig = rangeconfig
        }
        if (rangeconfig.benefit_coalition == coalition.side.BLUE) then
            local radioMenuForRange   =  MENU_COALITION:New( coalition.side.BLUE, rangeconfig.name , mainRadioMenuForRangesBlue)
            for index, subRangeConfig in ipairs(rangeconfig.subRange) do
                local radioMenuSubRange     = MENU_COALITION:New(rangeconfig.benefit_coalition, subRangeConfig.name,   radioMenuForRange)
                AddTargetsFunction(radioMenuSubRange, rangeconfig, subRangeConfig)
            end
        else
            local radioMenuForRange   =  MENU_COALITION:New( coalition.side.RED, rangeconfig.name , mainRadioMenuForRangesRed)
            for index, subRangeConfig in ipairs(rangeconfig.subRange) do
                local radioMenuSubRange     = MENU_COALITION:New(rangeconfig.benefit_coalition, subRangeConfig.name,   radioMenuForRange)
                AddTargetsFunction(radioMenuSubRange, rangeconfig, subRangeConfig)
            end
        end
    end
end
