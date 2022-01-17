-- *****************************************************************************
--                     **                     Rescue Hello                    **
--                     *********************************************************
PedroArray = {}
compteur = 0
for index,pedro in ipairs(PedrosConfig) do
    if pedro.enable == true then
        compteur = compteur +1
        local rescuehelo = RESCUEHELO:New(UNIT:FindByName(pedro.patternUnit),pedro.groupName)
                                     :SetHomeBase(AIRBASE:FindByName(pedro.baseUnit))
                                     :SetTakeoffCold()
                                     :SetRespawnOnOff(pedro.autorespawn)
                                     :SetRescueDuration(1)
                                     :SetModex(pedro.modex)
        function rescuehelo:OnAfterStart(from, event, to)
            self.helo:CommandSetFrequency(pedro.freq, radio.modulation.AM)
        end
        PedroArray[compteur] = rescuehelo
        PedroArray[compteur]:Start()
    end
end
