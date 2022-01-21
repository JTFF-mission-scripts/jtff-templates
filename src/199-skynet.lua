-- *****************************************************************************
--                     **                     Skynet Groups                   **
--                     *********************************************************

IADSArray = {}
compteur = 0
mainRadioMenuForSkynetBlue =  MENU_COALITION:New( coalition.side.BLUE , "Skynet", MenuCoalitionBlue )
mainRadioMenuForSkynetRed =  MENU_COALITION:New( coalition.side.RED , "Skynet", MenuCoalitionRed )
redIADS = nil
for index, skynetconfig in ipairs(SkynetConfig) do
    if skynetconfig.enable == true then
        compteur = compteur + 1
        env.info('Ajout menu radio pour IADS Skynet : '.. skynetconfig.name..'...')
        IADSArray[compteur] = {
            customconfig = skynetconfig
        }
        local radioMenuForSkynet = nil
        if (skynetconfig.benefit_coalition == coalition.side.BLUE) then
            radioMenuForSkynet =  MENU_COALITION:New( coalition.side.BLUE, skynetconfig.name , mainRadioMenuForSkynetBlue)
        else
            radioMenuForSkynet   =  MENU_COALITION:New( coalition.side.RED, skynetconfig.name , mainRadioMenuForSkynetRed)
        end
        AddIADSFunction(radioMenuForSkynet, skynetconfig, redIADS)
    end
end
