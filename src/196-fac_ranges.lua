-- *****************************************************************************
--                     **                  FAC RANGES                         **
--                     *********************************************************
FACRangeArray = {}
compteur = 0
mainRadioMenuForFacRangesBlue =  MENU_COALITION:New( coalition.side.BLUE , "FAC", MenuCoalitionBlue )
mainRadioMenuForFacRangesRed =  MENU_COALITION:New( coalition.side.RED , "FAC", MenuCoalitionRed )
for index, facrangeconfig in ipairs(FACRangeConfig) do
    if facrangeconfig.enable == true then
        compteur = compteur + 1
        env.info('creation of FAC : ' .. facrangeconfig.name .. '...')
        FACRangeArray[compteur] = {
            customconfig = facrangeconfig
        }
    end
    if (facrangeconfig.benefit_coalition == coalition.side.BLUE) then
        local radioMenuForFACRange   =  MENU_COALITION:New( facrangeconfig.benefit_coalition, facrangeconfig.name , mainRadioMenuForFacRangesBlue)
        for index, facSubRangeConfig in ipairs(facrangeconfig.subRange) do
            local radioMenuFacSubRange = MENU_COALITION:New(facrangeconfig.benefit_coalition, facSubRangeConfig.name,   radioMenuForFACRange)
            AddFacFunction(radioMenuFacSubRange, facrangeconfig, facSubRangeConfig)
        end
    else
        local radioMenuForFACRange =  MENU_COALITION:New( facrangeconfig.benefit_coalition, facrangeconfig.name , mainRadioMenuForFacRangesRed)
        for index, facSubRangeConfig in ipairs(facrangeconfig.subRange) do
            local radioMenuFacSubRange     = MENU_COALITION:New(facrangeconfig.benefit_coalition, facSubRangeConfig.name, radioMenuForFACRange)
            AddFacFunction(radioMenuFacSubRange, facrangeconfig, facSubRangeConfig)
        end
    end

end
