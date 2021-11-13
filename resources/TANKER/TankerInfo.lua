DEBUG_MSG = true
--_SETTINGS:SetImperial()
    
local function debug_msg(message)
  if DEBUG_MSG then 
    env.info(string.format("[DEBUG] %s", message))
  end
end

local function give_bra_of_air_group(param)
  local target_group = param[1]
  local client_group = param[2]
  local settings = param[3]
  local coordinate_target = target_group:GetCoordinate()
  local coordinate_client = client_group:GetCoordinate()
  return string.format ("%s, %s", coordinate_target:ToStringBRA(coordinate_client, settings), coordinate_target:ToStringAspect(coordinate_client))  
end

local function give_heading_speed(param)
  local target_group = param[1]
  local settings = param[2]
  local heading_target = target_group:GetHeading()
  local speed_target = target_group:GetVelocityKNOTS()
  if (settings:IsMetric()) then
    speed_target = target_group:GetVelocityKMH()
    return string.format ("Heading : %.0f, Speed : %.0f km/h", heading_target, speed_target)
  end
  return string.format ("Heading : %.0f, Speed : %.0f kt", heading_target, speed_target)
end

local function findNearestTanker(PlayerUnit, PlayerGroup, Radius)

  Radius=UTILS.NMToMeters(Radius or 50)

  local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
  if isrefuelable then
    local coord=PlayerUnit:GetCoordinate()
    local units=coord:ScanUnits(Radius)
    local coalition=PlayerUnit:GetCoalition()

    local dmin=math.huge
    local tanker=nil --Wrapper.Unit#UNIT
    local client = CLIENT:Find(PlayerUnit:GetDCSObject())
    local setting = SETTINGS:Set(client:GetPlayerName())
    for _,_unit in pairs(units.Set) do
      local unit=_unit --Wrapper.Unit#UNIT
      local istanker, tankerrefuelsystem=unit:IsTanker()
      if istanker and playerrefuelsystem==tankerrefuelsystem and coalition == unit:GetCoalition() then

        -- Distance.
        local d=unit:GetCoordinate():Get2DDistance(coord)
        if d<dmin then
          d=dmin
          tanker=unit
        end
      end
    end

    local tankerrefuelsystemName = "BOOM"
    if playerrefuelsystem == 0 then
      tankerrefuelsystemName = "PROBE"
    end
    local braa_message = give_bra_of_air_group({tanker:GetGroup(), PlayerGroup, setting})
    local aspect_message = give_heading_speed({tanker:GetGroup(), setting})
      local fuelState = string.format("%s Lbs",tanker:GetTemplateFuel()*2.205)
    if setting:IsMetric() then
      local fuelState = string.format("%s Kg",tanker:GetTemplateFuel())
    end
    local message = string.format("%s %s [%s]\nFuel State %s(%.2f)\n%s\n%s", tanker:GetName(), tanker:GetTypeName(), tankerrefuelsystemName, fuelState, tanker:GetFuel()*100, aspect_message, braa_message)
    MESSAGE:NewType(message,MESSAGE.Type.Overview):ToGroup(PlayerGroup) 
  end
  return nil
end

local function findAllTanker(PlayerUnit, PlayerGroup, Radius)

  Radius=UTILS.NMToMeters(Radius or 50)

  local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
  if isrefuelable then

    local coord=PlayerUnit:GetCoordinate()
    local units=coord:ScanUnits(Radius)
    local coalition=PlayerUnit:GetCoalition()

    local tanker=nil --Wrapper.Unit#UNIT
    local client = CLIENT:Find(PlayerUnit:GetDCSObject())
    local setting = SETTINGS:Set(client:GetPlayerName())
    for _,_unit in pairs(units.Set) do
      local unit=_unit --Wrapper.Unit#UNIT
      local istanker, tankerrefuelsystem=unit:IsTanker()
      if istanker and playerrefuelsystem==tankerrefuelsystem and coalition == unit:GetCoalition() then
        tanker=unit 
        local tankerrefuelsystemName = "BOOM"
        if playerrefuelsystem == 0 then
          tankerrefuelsystemName = "PROBE"
        end
        local braa_message = give_bra_of_air_group({tanker:GetGroup(), PlayerGroup, setting})
        local aspect_message = give_heading_speed({tanker:GetGroup(), setting})
        local fuelState = string.format("%s Lbs",tanker:GetTemplateFuel()*2.205)
        if setting:IsMetric() then
          local fuelState = string.format("%s Kg",tanker:GetTemplateFuel())
        end
        local message = string.format("%s %s [%s]\nFuel State %s (%.2f)\n%s\n%s", tanker:GetName(), tanker:GetTypeName(), tankerrefuelsystemName, fuelState, tanker:GetFuel()*100,aspect_message, braa_message)  
        MESSAGE:NewType(message,MESSAGE.Type.Overview):ToGroup(PlayerGroup) 
      end
    end
  end
  return nil
end



local function NeariestTankerInfo(param)
  findNearestTanker(param[1],param[2], 200)
end

local function AllTankersInfo(param)
  findAllTanker(param[1],param[2], 200)
end

Set_CLIENT = SET_CLIENT:New():FilterOnce()
Set_CLIENT:HandleEvent(EVENTS.Refueling)
Set_CLIENT:HandleEvent(EVENTS.RefuelingStop)
Set_CLIENT:HandleEvent(EVENTS.PlayerEnterAircraft)

function Set_CLIENT:OnEventPlayerEnterAircraft(EventData)
  if (EventData.IniGroup) then
      debug_msg(string.format("Add Tanker Menu for group [%s], player name [%s]",EventData.IniGroupName , EventData.IniPlayerName))
      local TankerMenu = MENU_GROUP:New( EventData.IniGroup, "Tanker Menu" )
      MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", TankerMenu, NeariestTankerInfo, {EventData.IniUnit,EventData.IniGroup}  )
      MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", TankerMenu, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
  end
end

function Set_CLIENT:OnEventRefueling(EventData)
  if (EventData.IniGroup) then
    local client = CLIENT:Find(EventData.IniDCSUnit)
    local clientFuel = EventData.IniUnit:GetTemplateFuel()
    debug_msg(string.format("[%s] Start to refuel at the tanker %[s], current fuel : %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuel))
    BASE:SetState( client, "Fuel", clientFuel )
  end
end

function Set_CLIENT:OnEventRefuelingStop(EventData)
  if (EventData.IniGroup) then
    local client = CLIENT:Find(EventData.IniDCSUnit)
    local clientFuelTaken = EventData.IniUnit:GetTemplateFuel() - BASE:GetState(client,"Fuel")
    debug_msg(string.format("[%s] Stop to refuel at the tanker %[s], taken %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuelTaken))
  end
end
