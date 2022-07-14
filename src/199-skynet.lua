-- *****************************************************************************
--                     **                     Skynet Groups                   **
--                     *********************************************************

IADSArray = {}
compteur = 0
mainRadioMenuForSkynet =  MENU_MISSION:New("Skynet", nil )
redIADS = nil
for index, skynetconfig in ipairs(SkynetConfig) do
    if skynetconfig.enable == true then
        compteur = compteur + 1
        env.info('Ajout menu radio pour IADS Skynet : '.. skynetconfig.name..'...')
        IADSArray[compteur] = {
            customconfig = skynetconfig
        }
        local radioMenuForSkynet = nil
        radioMenuForSkynet =  MENU_MISSION:New(skynetconfig.name , mainRadioMenuForSkynet)
        AddIADSFunction(radioMenuForSkynet, skynetconfig, redIADS)
    end
end
