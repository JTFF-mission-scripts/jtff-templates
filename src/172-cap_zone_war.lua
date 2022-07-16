-- *****************************************************************************
--                     **                CAPZone War                          **
--                     *********************************************************
CAPWarZoneArray = {}
compteur = 0
MenuCoalitionCAPWarZone = MENU_MISSION:New("CAP War Zones", nil)
for index, capwarzoneconfig in ipairs(WarCAPConfig) do
    if capwarzoneconfig.enable == true and #(capwarzoneconfig.ewrPrefixes) > 0 then
        compteur = compteur + 1
        env.info('creation CAP WarZone : '.. capwarzoneconfig.name..'...')
        objCapWarZone = {}
        if capwarzoneconfig.borderZoneGroupName then
            objCapWarZone.objZone = ZONE_POLYGON:New( capwarzoneconfig.borderZoneGroupName, GROUP:FindByName( capwarzoneconfig.borderZoneGroupName ) )
        else
            if capwarzoneconfig.borderZoneName then
                objCapWarZone.objZone = ZONE:New(capwarzoneconfig.borderZoneName)
            else
                objCapWarZone.objZone = ZONE_GROUP:New(
                        "border_" .. capwarzoneconfig.name,
                        GROUP:FindByName(capwarzoneconfig.ewrPrefixes[1]),
                        UTILS.NMToMeters(600)
                )
            end
        end
        objCapWarZone.customconfig = capwarzoneconfig
        objCapWarZone.objMenu = MENU_MISSION:New(capwarzoneconfig.name, MenuCoalitionCAPWarZone)
        objCapWarZone.objMenu:RemoveSubMenus()
        CAPWarZoneArray[compteur] = objCapWarZone
        MENU_MISSION_COMMAND:New(
                "Start ".. capwarzoneconfig.name .. " CAP War Zone",
                CAPWarZoneArray[compteur].objMenu,
                startCapWarZone,
                CAPWarZoneArray[compteur])
    end
end
