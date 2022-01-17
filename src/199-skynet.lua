-- *****************************************************************************
--                     **                     Skynet Groups                   **
--                     *********************************************************

IADSArray = {}
compteur = 0
mainRadioMenuForSkynetBlue =  MENU_COALITION:New( coalition.side.BLUE , "Skynet", MenuCoalitionBlue )
mainRadioMenuForSkynetRed =  MENU_COALITION:New( coalition.side.RED , "Skynet", MenuCoalitionRed )
for index, skynetconfig in ipairs(SkynetConfig) do
    if skynetconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Reseau Skynet : '.. skynetconfig.name..'...')
        IADSArray[compteur] = {
            customconfig = skynetconfig
        }
        if (skynetconfig.benefit_coalition == coalition.side.BLUE) then
            local radioMenuForSkynet =  MENU_COALITION:New( coalition.side.BLUE, skynetconfig.name , mainRadioMenuForSkynetBlue)
        else
            local radioMenuForSkynet   =  MENU_COALITION:New( coalition.side.RED, skynetconfig.name , mainRadioMenuForSkynetRed)
        end
    end
end
