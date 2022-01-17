-- *****************************************************************************
--                     **                        ATIS                         **
--                     *********************************************************
ATISArray = {}
compteur = 0
for index, atisconfig in ipairs(AtisConfig) do
    if atisconfig.enable == true then
        compteur = compteur + 1
        env.info('creation ATIS : '.. atisconfig.airfield..'...')
        local objAtis = ATIS:New(atisconfig.airfield, atisconfig.radio.freq, atisconfig.radio.modulation)
                            :SetImperialUnits()
                            :SetSoundfilesPath('ATIS/ATIS Soundfiles/')
                            :SetSubtitleDuration(0)
                            :SetMapMarks(true)
        if (atisconfig.radio.relayunit) then
            objAtis:SetRadioRelayUnitName(atisconfig.radio.relayunit)
        else
            if (atisconfig.radio.power) then
                objAtis:SetRadioPower(atisconfig.radio.power)
            end
        end
        if (atisconfig.radio.tower) then
            objAtis:SetTowerFrequencies(atisconfig.radio.tower);
        end
        if (atisconfig.active.side) then
            if (atisconfig.active.number) then
                objAtis:SetActiveRunway(atisconfig.active.number..atisconfig.active.side)
            else
                objAtis:SetActiveRunway(atisconfig.active.side)
            end
        else
            if (atisconfig.active.number) then
                objAtis:SetActiveRunway(atisconfig.active.number)
            end
        end
        if (atisconfig.tacan) then
            objAtis:SetTACAN(atisconfig.tacan.channel)
        end
        if (atisconfig.ils) then
            if (atisconfig.ils.runway) then
                objAtis:AddILS(atisconfig.ils.freq, atisconfig.ils.runway)
            else
                objAtis:AddILS(atisconfig.ils.freq)
            end
        end
        if (atisconfig.srs) then
            objAtis:SetSRS(atisconfig.srs.path, "male", "en-US")
        end
        objAtis.customconfig = atisconfig
        ATISArray[compteur] = objAtis
        ATISArray[compteur]:Start()
    end
end
