-- NTTR Range and Target by 476vFG

--=======================================================================================================
--================================    Environment variables    ==========================================
--=======================================================================================================
--_SETTINGS:SetPlayerMenuOff()
--_SETTINGS:SetImperial()
_SETTINGS:SetLL_Accuracy(4)
_SETTINGS:SetA2G_LL_DDM()
_SETTINGS:SetMenutextShort(true)
_SETTINGS:SetMessageTime(MESSAGE.Type.Information,10)
_SETTINGS:SetMessageTime(MESSAGE.Type.Update, 15)
_SETTINGS:SetMessageTime(MESSAGE.Type.Overview,20)
_SETTINGS:SetMessageTime(MESSAGE.Type.Detailed,120)
_SETTINGS:SetMessageTime(MESSAGE.Type.Briefing,240)

--=======================================================================================================
--====================================  No Flight Zone ==================================================
--=======================================================================================================
R4808Zone = ZONE_POLYGON:NewFromGroupName("R4808")
R4808Scheduler, R4808_ID = SCHEDULER:New(nil,
  function()
    debug_squeduler_msg("Run scheduler Restricted Zone")
    Set_CLIENT_Red:ForEachClientInZone(R4808Zone,
      function(ClientRouge)
        if ClientRouge:IsAlive() then
          debug_msg(string.format("%s is in R4808",ClientRouge:GetPlayerName()))
          if (ClientRouge:GetAltitude() < UTILS.FeetToMeters(10000)) then
            MESSAGE:NewType(string.format("%s YOU HAVE TO FLY OVER 10000FT IN THIS ZONE", ClientRouge:GetPlayerName()),MESSAGE.Type.Overview):ToClient(ClientRouge)
          end
        end
      end)
    Set_CLIENT_Bleu:ForEachClientInZone(R4808Zone,
      function(ClientBleu)
        if ClientBleu:IsAlive() then
          debug_msg(string.format("%s is in R4808",ClientBleu:GetPlayerName()))
          if (ClientBleu:GetAltitude() < UTILS.FeetToMeters(10000)) then
            MESSAGE:NewType(string.format("%s YOU HAVE TO FLY OVER 10000FT IN THIS ZONE", ClientBleu:GetPlayerName()),MESSAGE.Type.Overview):ToClient(ClientBleu)
          end
        end
      end)
  end,{},7,10)
