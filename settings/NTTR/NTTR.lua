-- NTTR Range and Target by 476vFG

--=======================================================================================================
--================================    Environment variables    ==========================================
--=======================================================================================================
DEBUG_MSG = true
DEBUG_SQ_MSG = false
DEBUG_DETECT_MSG = false
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

AWACS_NAME="Focus"
RED_AWACS_NAME="Wizard"
map_marker = {}
--BASE:TraceOn()
sead = SEAD:New({})


--=======================================================================================================
--======================================   Subfunctions   ===============================================
--=======================================================================================================

local function debug_msg(message)
  if DEBUG_MSG then 
    env.info(string.format("[DEBUG] %s", message))
  end
end

local function debug_detection_msg(message)
  if DEBUG_DETECT_MSG then 
    env.info(string.format("[DETECTION] %s", message))
  end
end

local function debug_squeduler_msg(message)
  if DEBUG_SQ_MSG then 
    env.info(string.format("[DEBUG SQ] %s", message))
  end
end

local function destroy_group(group_name)
  local set_group_alive = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
  set_group_alive:ForEachGroupAlive(
    function(group_alive)
      debug_msg(string.format("Group %s just removed", group_alive:GetName()))
      if (map_marker[group_alive:GetName()]) then
        COORDINATE:RemoveMark(map_marker[group_alive:GetName()])
      end
      group_alive:Destroy()
    end )
end

local function activate_group(group_name)
  local set_group = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
  set_group:ForEachGroup(
    function(group_inactif)
      debug_msg(string.format("Group %s just activated", group_inactif:GetName()))
      group_inactif:Activate()
    end )
end

local function destroy_red_ground_units(param)
  if (param[2][1] ~= nil) then
    local group_name = string.format("%s-%s", param[1],param[2][1])
    for i=1, #param[2] do
      destroy_group(string.format("%s-%s", param[1],param[2][i]))
    end
    MESSAGE:NewType(string.format("Remove the target site : %s", group_name),MESSAGE.Type.Information):ToBlue()
  else
    local group_name = string.format("%s-%s", param[1],param[2])
    destroy_group(string.format("%s", group_name))
    MESSAGE:NewType(string.format("Remove the target site : %s", group_name),MESSAGE.Type.Information):ToBlue()
  end

--  param[4]:Remove()
  param[3]:RemoveSubMenus()
  local repawn_function = param[5]

  repawn_function({param[3], param[2]})
end

local function destroy_blue_ground_units(param)
  local group_name = string.format("%s", param[2][1])
  for i=1, #param[2] do
    destroy_group(string.format("%s", param[2][i]))
  end
  MESSAGE:NewType(string.format("Remove groups : %s", group_name),MESSAGE.Type.Information):ToBlue()
  param[4]:Remove()
  param[3]:RemoveSubMenus()
  local repawn_function = param[5]

  repawn_function({param[3], param[2]})
end

local function get_max_threat_unit(setUnits)
  local setUnitsSorted =SET_UNIT:New()
  setUnits:ForEachUnitPerThreatLevel(10,0,  
    function (unit) 
      setUnitsSorted:AddUnit(unit)
    end
  )
  debug_msg(string.format("Max priority unit : %s", setUnitsSorted:GetFirst():GetName()))    
  return setUnitsSorted:GetFirst()
end

local function sort_units_by_threat(setUnits)
  local setUnitsSorted =SET_UNIT:New()
  setUnits:ForEachUnitPerThreatLevel(10,0,  
    function (unit) 
      setUnitsSorted:AddUnit(unit)
    end
  )
  return setUnitsSorted
end


local function smoke_on_red_ground_unit(param)
  if (param[2][1] ~= nil) then
    for i=2, #param[2] do
      local group_name = string.format("%s-%s", param[1], param[2][i])
      debug_msg(string.format("Smoke on group %s", group_name))
      local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
      dcs_groups:ForEachGroupAlive(
        function(group_alive)
          local list_units = group_alive:GetUnits()
          local set_units = SET_UNIT:New()
          for index=1, #list_units do
            local unit_tmp = list_units[index]
            if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.RED) then
              set_units:AddUnit(unit_tmp)
            end
          end
          local unit_to_smoke = get_max_threat_unit(set_units)
          unit_to_smoke:SmokeRed()
          MESSAGE:NewType(string.format("[%s] Red smoke on : %s", group_alive:GetName(), unit_to_smoke:GetTypeName() ),MESSAGE.Type.Overview):ToBlue()
        end
      )
    end
  else
    local group_name = string.format("%s-%s", param[1], param[2])
    debug_msg(string.format("Smoke on group %s", group_name))
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    dcs_groups:ForEachGroupAlive(
      function(group_alive)
        local list_units = group_alive:GetUnits()
        local set_units = SET_UNIT:New()
        for index=1, #list_units do
          local unit_tmp = list_units[index]
          if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.RED) then
            set_units:AddUnit(unit_tmp)
          end
        end
        local unit_to_smoke = get_max_threat_unit(set_units)
        unit_to_smoke:SmokeRed()
        MESSAGE:NewType(string.format("[%s] Red smoke on : %s", group_alive:GetName(), unit_to_smoke:GetTypeName() ),MESSAGE.Type.Overview):ToBlue()
      end
    )
  end
end

local function smoke_on_blue_ground_unit(param)
  if (param[2][1] ~= nil) then
    for i=2, #param[2] do
      local group_name = string.format("%s", param[2][i])
      debug_msg(string.format("Smoke on group %s", group_name))
      local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
      dcs_groups:ForEachGroupAlive(
        function(group_alive)
          local list_units = group_alive:GetUnits()
          local set_units = SET_UNIT:New()
          for index=1, #list_units do
            local unit_tmp = list_units[index]
            if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.BLUE) then
              set_units:AddUnit(unit_tmp)
              debug_msg(string.format("Add unit in set unit for Smoke %s", unit_tmp:GetName()))
            end
          end
          local unit_to_smoke = get_max_threat_unit(set_units)
          unit_to_smoke:SmokeBlue()
          MESSAGE:NewType(string.format("[%s] Blue smoke on : %s", group_alive:GetName(), unit_to_smoke:GetTypeName() ),MESSAGE.Type.Overview):ToBlue()
        end
      )
    end
  else
    local group_name = string.format("%s", param[2])
    debug_msg(string.format("Smoke on group %s", group_name))
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    dcs_groups:ForEachGroupAlive(
      function(group_alive)
        local list_units = group_alive:GetUnits()
        local set_units = SET_UNIT:New()
        for index=1, #list_units do
          local unit_tmp = list_units[index]
          if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.BLUE) then
            set_units:AddUnit(unit_tmp)
            debug_msg(string.format("Add unit in set unit for Smoke %s", unit_tmp:GetName()))
          end
        end
        local unit_to_smoke = get_max_threat_unit(set_units)
        unit_to_smoke:SmokeBlue()
        MESSAGE:NewType(string.format("[%s] Blue smoke on : %s", group_alive:GetName(), unit_to_smoke:GetTypeName() ),MESSAGE.Type.Overview):ToBlue()
      end
    )
  end
end



local function mark_group_on_map(param)
  local side = param[3]
  if (param[2][1] ~= nil) then
    for i=2, #param[2] do
      local group_name = string.format("%s-%s", param[1], param[2][i])
      debug_msg(string.format("Mark on map all groups with name prefix %s", group_name))
      local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
      dcs_groups:ForEachGroupAlive(
        function(group_alive)
          debug_msg(string.format("Mark on map the group %s", group_alive:GetName()))
          local coordinate = group_alive:GetCoordinate()
          map_marker[group_alive:GetName()] = coordinate:MarkToCoalition(group_alive:GetName(), side)
        end 
      )
    end
  else
    local group_name = string.format("%s-%s", param[1], param[2])
    debug_msg(string.format("Mark on map all groups with name prefix %s", group_name))
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    dcs_groups:ForEachGroupAlive(
      function(group_alive)
        debug_msg(string.format("Mark on map the group %s", group_alive:GetName()))
        local coordinate = group_alive:GetCoordinate()
        map_marker[group_alive:GetName()] = coordinate:MarkToCoalition(group_alive:GetName(), side)
      end 
    )
  end
end

local function give_coordinate_of_group(param)
  local FAC = param[3]
  if (param[2][1] ~= nil) then
    for i=2, #param[2] do
      local group_name = ""
      if(FAC) then
        group_name = string.format("%s", param[2][i])
      else
        group_name = string.format("%s-%s", param[1], param[2][i])
      end
      debug_msg(string.format("Coordinates of all groups with name prefix %s", group_name))
      local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
      Set_CLIENT_Bleu:ForEachClient(
        function (client)
          if (client:IsActive()) then
            debug_msg(string.format("For Client %s ", client:GetName()))
            local coordinate_txt=""
            dcs_groups:ForEachGroupAlive(
              function(group_alive)
                debug_msg(string.format("Coordinates of the group %s", group_alive:GetName()))
                local coordinate = group_alive:GetCoordinate()
                local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())             
                local coordinate_string = ""
                if (setting:IsA2G_LL_DDM()) then
                  coordinate_string = coordinate:ToStringLLDDM(setting)
                  debug_msg(string.format("%s IsA2G_LL_DDM", client:GetName()))
                elseif (setting:IsA2G_MGRS()) then
                  coordinate_string = coordinate:ToStringMGRS(setting)
                  debug_msg(string.format("%s IsA2G_MGRS", client:GetName()))
                elseif (setting:IsA2G_LL_DMS()) then
                  coordinate_string = coordinate:ToStringLLDMS(setting)
                  debug_msg(string.format("%s IsA2G_LL_DMS", client:GetName()))
                elseif (setting:IsA2G_BR()) then
                  coordinate_string = coordinate:ToStringBR(client:GetCoordinate(), setting)
                  debug_msg(string.format("%s IsA2G_BR", client:GetName()))
                end
                debug_msg(string.format ("coordinate_txt [%s] : %s", group_alive:GetName() , coordinate_string))
                coordinate_txt = string.format ("%s[%s] : %s\n", coordinate_txt, group_alive:GetName() , coordinate_string)
              end 
            )
            debug_msg(string.format ("Message to Client %s : %s", client:GetName(), coordinate_txt))
            MESSAGE:NewType(coordinate_txt,MESSAGE.Type.Detailed):ToClient(client)
          end
        end
      )
    end
  else
    local group_name = ""
    if(FAC) then
      group_name = string.format("%s", param[2])
    else
      group_name = string.format("%s-%s", param[1], param[2])
    end
    debug_msg(string.format("Coordinates of all groups with name prefix %s", group_name))
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    Set_CLIENT_Bleu:ForEachClient(
      function (client)
        if (client:IsActive()) then
          debug_msg(string.format("For Client %s ", client:GetName()))
          local coordinate_txt=""
          dcs_groups:ForEachGroupAlive(
            function(group_alive)
              debug_msg(string.format("Coordinates of the group %s", group_alive:GetName()))
              local coordinate = group_alive:GetCoordinate()
              local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())             
              local coordinate_string = ""
              if (setting:IsA2G_LL_DDM()) then
                coordinate_string = coordinate:ToStringLLDDM(setting)
                debug_msg(string.format("%s IsA2G_LL_DDM", client:GetName()))
              elseif (setting:IsA2G_MGRS()) then
                coordinate_string = coordinate:ToStringMGRS(setting)
                debug_msg(string.format("%s IsA2G_MGRS", client:GetName()))
              elseif (setting:IsA2G_LL_DMS()) then
                coordinate_string = coordinate:ToStringLLDMS(setting)
                debug_msg(string.format("%s IsA2G_LL_DMS", client:GetName()))
              elseif (setting:IsA2G_BR()) then
                coordinate_string = coordinate:ToStringBR(client:GetCoordinate(), setting)
                debug_msg(string.format("%s IsA2G_BR", client:GetName()))
              end
              debug_msg(string.format ("coordinate_txt [%s] : %s", group_alive:GetName() , coordinate_string))
              coordinate_txt = string.format ("%s[%s] : %s\n", coordinate_txt, group_alive:GetName() , coordinate_string)
            end 
          )
          debug_msg(string.format ("Message to Client %s : %s", client:GetName(), coordinate_txt))
          MESSAGE:NewType(coordinate_txt,MESSAGE.Type.Detailed):ToClient(client)
        end
      end
    )
  end
end


local function give_list_of_unit_alive_in_group(param)
  local side = param[3]
  local number_to_display = param[4]
  if (param[2][1] ~= nil) then
    for i=2, #param[2] do
      local group_name = string.format("%s-%s", param[1], param[2][i])
      debug_msg(string.format("List of units of all groups with name prefix %s", group_name))
      local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
      dcs_groups:ForEachGroupAlive(
        function(group_alive)
          debug_msg(string.format("List of units of the group %s", group_alive:GetName()))
          local info_unit_header = string.format ("Units list of the group [%s]:", group_name)
          Set_CLIENT_Bleu:ForEachClient(
            function (client)
              if (client:IsActive()) then
                MESSAGE:NewType(info_unit_header,MESSAGE.Type.Overview):ToClient(client)
              end
            end
          )
          local list_units = group_alive:GetUnits()
          local set_units = SET_UNIT:New()
          for index=1, #list_units do
            local unit_tmp = list_units[index]
            if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() ~= side) then
              set_units:AddUnit(unit_tmp)
            end
          end
          local increment = 0;
          set_units:ForEachUnitPerThreatLevel(10,0,
            function (unit_tmp)
              if ( increment < number_to_display) then
                local unit_life_pourcentage = (unit_tmp:GetLife()/(unit_tmp:GetLife0()+1))*100
                local unit_coordinate = unit_tmp:GetCoordinate()
                local unit_altitude_m = unit_tmp:GetAltitude()
                local unit_coordinate_for_client = ""
                local unit_altitude_for_client = 0
                local unit_altitude_for_client_unit = ""
                Set_CLIENT_Bleu:ForEachClient(
                  function (client)
                    if (client:IsActive()) then
                      local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())
                      unit_coordinate_for_client = ""
                      if (setting:IsA2G_LL_DDM()) then
                        unit_coordinate_for_client = unit_coordinate:ToStringLLDDM(setting)
                      elseif (setting:IsA2G_MGRS()) then
                        unit_coordinate_for_client = unit_coordinate:ToStringMGRS(setting)
                      elseif (setting:IsA2G_LL_DMS()) then
                        unit_coordinate_for_client = unit_coordinate:ToStringLLDMS(setting)
                      elseif (setting:IsA2G_BR()) then
                        unit_coordinate_for_client = unit_coordinate:ToStringBR(client:GetCoordinate(), setting)
                      end
                      if (setting:IsImperial()) then
                        unit_altitude_for_client = UTILS.MetersToFeet(unit_altitude_m)
                        unit_altitude_for_client_unit = "ft"
                      elseif(setting:IsMetric()) then
                        unit_altitude_for_client = unit_altitude_m
                        unit_altitude_for_client_unit = "m"
                      end
                      local info_unit_tmp  = string.format("[%i] %s (%i", unit_tmp:GetThreatLevel(), unit_tmp:GetTypeName(), unit_life_pourcentage)..'%),\t'..unit_coordinate_for_client..string.format("\tAlt: %.0f%s",unit_altitude_for_client, unit_altitude_for_client_unit)
                      MESSAGE:NewType(info_unit_tmp,MESSAGE.Type.Overview):ToClient(client)
                    end
                  end
                )
                increment = increment + 1;
              end
            end
          )
        end
      )  
    end
  else
    local group_name = string.format("%s-%s", param[1], param[2])
    debug_msg(string.format("List of units of all groups with name prefix %s", group_name))
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    dcs_groups:ForEachGroupAlive(
      function(group_alive)
        debug_msg(string.format("List of units of the group %s", group_alive:GetName()))
        local info_unit_header = string.format ("Units list of the group [%s]:", group_name)
        Set_CLIENT_Bleu:ForEachClient(
          function (client)
            if (client:IsActive()) then
              MESSAGE:NewType(info_unit_header,MESSAGE.Type.Overview):ToClient(client)
            end
          end
        )
        local list_units = group_alive:GetUnits()
        local set_units = SET_UNIT:New()
        for index=1, #list_units do
          local unit_tmp = list_units[index]
          if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() ~= side) then
            set_units:AddUnit(unit_tmp)
          end
        end
        local increment = 0;
        set_units:ForEachUnitPerThreatLevel(10,0,
          function (unit_tmp)
            if ( increment < number_to_display) then
              local unit_life_pourcentage = (unit_tmp:GetLife()/(unit_tmp:GetLife0()+1))*100
              local unit_coordinate = unit_tmp:GetCoordinate()
              local unit_altitude_m = unit_tmp:GetAltitude()
              local unit_coordinate_for_client = ""
              local unit_altitude_for_client = 0
              local unit_altitude_for_client_unit = ""
              Set_CLIENT_Bleu:ForEachClient(
                function (client)
                  if (client:IsActive()) then
                    local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())
                    unit_coordinate_for_client = ""
                    if (setting:IsA2G_LL_DDM()) then
                      unit_coordinate_for_client = unit_coordinate:ToStringLLDDM(setting)
                    elseif (setting:IsA2G_MGRS()) then
                      unit_coordinate_for_client = unit_coordinate:ToStringMGRS(setting)
                    elseif (setting:IsA2G_LL_DMS()) then
                      unit_coordinate_for_client = unit_coordinate:ToStringLLDMS(setting)
                    elseif (setting:IsA2G_BR()) then
                      unit_coordinate_for_client = unit_coordinate:ToStringBR(client:GetCoordinate(), setting)
                    end
                    if (setting:IsImperial()) then
                      unit_altitude_for_client = UTILS.MetersToFeet(unit_altitude_m)
                      unit_altitude_for_client_unit = "ft"
                    elseif(setting:IsMetric()) then
                      unit_altitude_for_client = unit_altitude_m
                      unit_altitude_for_client_unit = "m"
                    end
                    local info_unit_tmp  = string.format("[%i] %s (%i", unit_tmp:GetThreatLevel(), unit_tmp:GetTypeName(), unit_life_pourcentage)..'%),\t'..unit_coordinate_for_client..string.format("\tAlt: %.0f%s",unit_altitude_for_client, unit_altitude_for_client_unit)
                    MESSAGE:NewType(info_unit_tmp,MESSAGE.Type.Overview):ToClient(client)
                  end
                end
              )
              increment = increment + 1;
            end
          end
        )
      end
    )
  end
end


local function give_list_of_group_alive_in_range(param)
  local FAC = param[3]
  local sub_range = string.format("%s-%s", param[1], param[2][1])
  debug_msg(string.format("List of groups in range %s", sub_range))
  local message = ""
  if (FAC) then
    message = string.format ("FAC groups in Range %s :", sub_range)
  else
    message = string.format ("Targets groups in Range %s :", sub_range)
  end
  for i=2, #param[2] do
    local group_name = ""
    if (FAC) then 
      group_name = string.format("%s", param[2][i])
    else
      group_name = string.format("%s-%s", param[1], param[2][i])
    end
    local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    dcs_groups:ForEachGroupAlive(
      function(group_alive)
        debug_msg(string.format("group %s", group_alive:GetName()))
        message = string.format("%s %s | ", message, group_alive:GetName());        
      end
    )  
  end
  Set_CLIENT_Bleu:ForEachClient(
    function (client)
      if (client:IsActive()) then
        MESSAGE:NewType(message,MESSAGE.Type.Information):ToClient(client)
      end
    end
  )
end


Set_CLIENT_Bleu = SET_CLIENT:New():FilterCoalitions("blue"):FilterOnce()
debug_msg(string.format("Nbre Blue Client : %i", Set_CLIENT_Bleu:Count()))
Set_CLIENT_Red = SET_CLIENT:New():FilterCoalitions("red"):FilterOnce()
debug_msg(string.format("Nbre Red Client : %i", Set_CLIENT_Red:Count()))

--=======================================================================================================
--========================================     Radio menu     ===========================================
--=======================================================================================================

function DeleteAWACSBleu(param)
  Spawn_AWACSBlue:SpawnScheduleStop()
  destroy_group(AWACS_NAME)
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffAWACS   = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Take off", radio_menu_parent,SpawnBlueAWACS, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our AWACS landed", AWACS_NAME),MESSAGE.Type.Overview):ToBlue()
  MESSAGE:NewType(string.format("Ennemy AWACS landed", AWACS_NAME),MESSAGE.Type.Overview):ToRed()
end

function SpawnBlueAWACS(param)
  Spawn_AWACSBlue = SPAWN:New(AWACS_NAME):InitLimit( 1, 0 ):InitRepeatOnLanding():SpawnScheduled(800,0.2)
  Spawn_AWACSBlue_Group = Spawn_AWACSBlue:SpawnAtAirbase(AIRBASE:FindByName( AIRBASE.Nevada.Nellis_AFB ), SPAWN.Takeoff.Air )
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffAWACS = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Land", radio_menu_parent,DeleteAWACSBleu, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our AWACS has just taken off", group_name),MESSAGE.Type.Overview):ToBlue()
  MESSAGE:NewType(string.format("Ennemy AWACS has just taken off", group_name),MESSAGE.Type.Overview):ToRed()
end

function DeleteRedAWACS(param)
  Spawn_AWACSRed:SpawnScheduleStop()
  destroy_group(RED_AWACS_NAME)
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffAWACS   = MENU_COALITION_COMMAND:New(coalition.side.RED, "Take off", radio_menu_parent,SpawnRedAWACS, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our AWACS landed", RED_AWACS_NAME),MESSAGE.Type.Overview):ToRed()
  MESSAGE:NewType(string.format("Ennemy AWACS landed", RED_AWACS_NAME),MESSAGE.Type.Overview):ToBlue()
end

function SpawnRedAWACS(param)
  Spawn_AWACSRed = SPAWN:New(RED_AWACS_NAME):InitLimit( 1, 0 ):InitRepeatOnLanding():SpawnScheduled(800,0.2)
  Spawn_AWACSRed_Group = Spawn_AWACSRed:SpawnAtAirbase(AIRBASE:FindByName( AIRBASE.Nevada.Nellis_AFB ), SPAWN.Takeoff.Air )
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffAWACS = MENU_COALITION_COMMAND:New(coalition.side.RED, "Land", radio_menu_parent,DeleteRedAWACS, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our AWACS has just taken off", group_name),MESSAGE.Type.Overview):ToRed()
  MESSAGE:NewType(string.format("Ennemy AWACS has just taken off", group_name),MESSAGE.Type.Overview):ToBlue()
end

function DeleteRedTANKERS(param)
  Spawn_TankerRed3:SpawnScheduleStop()
  Spawn_TankerRed4:SpawnScheduleStop()
  destroy_group("RED ARCO Cal")
  destroy_group("RED TEXACO CAL")
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffTanker   = MENU_COALITION_COMMAND:New(coalition.side.RED, "Take off", radio_menu_parent,SpawnRedTANKERS, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our TANKERS landed", RED_AWACS_NAME),MESSAGE.Type.Overview):ToRed()
  MESSAGE:NewType(string.format("Ennemy TANKERS landed", RED_AWACS_NAME),MESSAGE.Type.Overview):ToBlue()
end

function SpawnRedTANKERS(param)
  Spawn_TankerRed3 = SPAWN:New("RED ARCO Cal"):InitLimit( 1, 0 )
  Spawn_TankerRed4 = SPAWN:New("RED TEXACO CAL"):InitLimit( 1, 0 )
  Spawn_TankerRed3:InitRepeatOnLanding()
  Spawn_TankerRed4:InitRepeatOnLanding()
  Spawn_TankerRed3:SpawnScheduled(240,0.5)
  Spawn_TankerRed4:SpawnScheduled(240,0.5)
  Spawn_Tanker_Red_Group_3 = Spawn_TankerRed3:Spawn()
  Spawn_Tanker_Red_Group_4 = Spawn_TankerRed4:Spawn()
  local radio_menu_parent = param[1]
  radio_menu_parent:RemoveSubMenus()
  RadioCommandTakeOffTanker = MENU_COALITION_COMMAND:New(coalition.side.RED, "Land", radio_menu_parent,DeleteRedTANKERS, {radio_menu_parent})
  MESSAGE:NewType(string.format("Our TANKERS has ready", group_name),MESSAGE.Type.Overview):ToRed()
  MESSAGE:NewType(string.format("Ennemy TANKERS in the air", group_name),MESSAGE.Type.Overview):ToBlue()
end

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

atisScheduler, atisSchedulerId = SCHEDULER:New(nil,
        function()
            debug_squeduler_msg("Changement piste en service Nellis")
            ATISArray[1]:SetActiveRunway("21R")
            --ATISArray[2]:SetActiveRunway("21R")
        end,{},4200
)
