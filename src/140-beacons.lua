-- *****************************************************************************
--                     **                     BEACONS                         **
--                     *********************************************************
BeaconArray = {}
compteur = 0
for index, beaconconfig in ipairs(BeaconsConfig) do
    if beaconconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Beacon Zone : '.. beaconconfig.name..'...')
        local myunit = UNIT:FindByName(beaconconfig.unitName)
        local mybeacon = myunit:GetBeacon()
        mybeacon.customconfig = beaconconfig
        BeaconArray[compteur] = mybeacon
        BeaconArray[compteur]:ActivateTACAN(beaconconfig.tacan.channel,
                beaconconfig.tacan.band,
                beaconconfig.tacan.morse,
                true)
    end
end
