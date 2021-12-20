-- Instructions: include HypeMan in a mission either with a DO SCRIPT FILE, or a
-- DO SCRIPT containing the following:
-- assert(loadfile("C:/HypeMan/HypeMan.lua"))()
--
-- The DO SCRIPT assert(loadfile())() is preferred because then HypeMan can be updated and modified
-- and applied to all .miz files without having to modify each individually.

-- HypeMan requires JSON.lua from here http://regex.info/blog/lua/json in C:\HypeMan
-- TODO - can this be loaded with loadfile()?
local JSONLibPath = hypemanInstallPath.."/JSON.lua"
JSON = (loadfile(JSONLibPath))() -- one-time load of the routines

HypeMan = {}
-- Configuration Options
local HypeManAnnounceTakeoffs = true
local HypeManAnnounceLandings = true
local HypeManAnnounceMissionStart = true
local HypeManAnnounceMissionEnd = true
local HypeManAnnounceAIPlanes = false
local HypeManAnnouncePilotDead = true
local HypeManAnnouncePilotEject = true
local HypeManAnnounceKills = false
local HypeManAnnounceHits = false
local HypeManAnnounceCrash = true
local HypeManAnnounceRefueling = false
local HypeManMinimumFlightTime = 1800  -- minimum flight time to report in minutes

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"
local socket = require("socket")

HypeMan.UDPSendSocket = socket.udp()
HypeMan.UDPSendSocket:settimeout(0)

-- Table to store takeoff times
HypeManTakeOffTime = {}
HypeManRefuelingTable = {}

-- table to store hits on aircraft
HypeManHitTable = {}

-- This is the function that can be called in any mission to send a message to discord.
-- From the Mission Editor add a Trigger and a DO SCRIPT action and enter as the script:
-- HypeMan.sendBotMessage('Roses are Red.  Violets are blue.  I only wrote this poem to test my Discord Bot.')

HypeMan.sendBotTable = function(tbl)
    -- env.info(msg)  -- for debugging
    local tbl_json_txt = JSON:encode(tbl)
    socket.try(HypeMan.UDPSendSocket:sendto(tbl_json_txt, '127.0.0.1', 10081))
    -- msg = nil  -- setting to nil in attempt to debug why message queue seems to grow
end

HypeMan.sendBotMessage  = function(msg)
    -- env.info(msg)  -- for debugging
    --socket.try(HypeMan.UDPSendSocket:sendto(msg, '127.0.0.1', 10081))
    messageTable = {}
    messageTable.messageType = 1
    messageTable.messageString = msg
    HypeMan.sendBotTable(messageTable)
    msg = nil  -- setting to nil in attempt to debug why message queue seems to grow
end

-- Mission Start announcement done by a function right in the script as the S_EVENT_MISSION_START event is
-- nearly impossible to catch in a script as it gets sent the moment the mission is unpaused
if HypeManAnnounceMissionStart then
    local theDate = mist.getDateString(true, true)
    local theTime = mist.getClockString()
    local theatre = env.mission.theatre
    HypeMan.sendBotMessage('$SERVERNAME - Mission '..missionName..' launched in the ' .. theatre .. '.  Local mission time is ' .. theTime .. ', ' .. theDate)
end

local function HypeManGetName(initiator)
    if initiator == nil then
        return false, nil;
    end

    local statusflag, name = pcall(Unit.getPlayerName, initiator)

    if statusflag == false then
        return false, nil;
    end

    return true, name;
end

local function HypeManTakeOffHandler(event)

    -- TODO move this check below the timing code
    if HypeManAnnounceTakeoffs ~= true then
        return true
    end

    if event.id == world.event.S_EVENT_TAKEOFF then

        -- mist.utils.tableShow(event)

        --local name = Unit.getPlayerName(event.initiator)
        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        -- for debugging get the AI plane names
        if HypeManAnnounceAIPlanes and name == nil then
            name = Unit.getName(event.initiator)
        end

        if name == nil then
            return
        end

        --   env.info(_event.initiator:getPlayerName().."HIT! ".._event.target:getName().." with ".._event.weapon:getTypeName())

        local airfieldName = Airbase.getName(event.place)

        if airfieldName == nil then
            airfieldName = 'Unknown Airstrip'
        end

        HypeMan.sendBotMessage(name .. " took off from " .. airfieldName .. " in a " .. Unit.getTypeName(event.initiator) .. " on $SERVERNAME")

        HypeManTakeOffTime[Unit.getID(event.initiator)]=timer.getAbsTime()
    end
end

local function HypeManLandingHandler(event)
    if event.id == world.event.S_EVENT_LAND then

        -- mist.utils.tableShow(event)

        -- local name = Unit.getPlayerName(event.initiator)
        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        -- for debugging get the AI plane names
        if HypeManAnnounceAIPlanes and name == nil then
            name = Unit.getName(event.initiator)
        end

        if name == nil then
            return
        end

        --   env.info(_event.initiator:getPlayerName().."HIT! ".._event.target:getName().." with ".._event.weapon:getTypeName())

        local airfieldName = Airbase.getName(event.place)

        if airfieldName == nil then
            airfieldName = 'Unknown Airfield'
        end

        local t = HypeManTakeOffTime[Unit.getID(event.initiator)]

        HypeManTakeOffTime[Unit.getID(event.initiator)] = nil

        if t == nil then
            -- HypeMan.sendBotMessage("local t = TakeOffTime[Unit.getID(event.initiator)]  was nil... wtf")
            HypeMan.sendBotMessage(name .. " landed their " ..  Unit.getTypeName(event.initiator) .. " at " .. airfieldName .. " on $SERVERNAME")
            return
        end

        local cur = timer.getAbsTime()

        local tduration = cur - t
        local theTime = mist.getClockString(tduration)

        if tduration > HypeManMinimumFlightTime then
            HypeMan.sendBotMessage(name .. " landed their " ..  Unit.getTypeName(event.initiator) .. " at " .. airfieldName .. " on $SERVERNAME. Total flight time was " .. theTime)
        end
    end
end

local function HypeManMissionEndHandler(event)
    if event.id == world.event.S_EVENT_MISSION_END then
        local theDate = mist.getDateString(true, true)
        local theTime = mist.getClockString()
        -- HypeMan.sendBotMessage('Server shutting down, Hypeman going watch some porn and hit the hay.  Local time is ' .. theTime .. ', ' .. theDate)

        local timeInSec = mist.utils.round(timer.getAbsTime(), 0)

        -- local theTimeString = mist.getClockString(timeInSec)
        local DHMS =  mist.time.getDHMS(mist.time.relativeToStart(timeInSec))
        local dayStr
        if DHMS.d == 0 then
            dayStr = ''  -- leave days portion blank
        else
            dayStr = DHMS.d .. ' days '
        end

        local theTimeString  = dayStr .. DHMS.h .. ' hours and ' .. DHMS.m .. ' minutes.'

        HypeMan.sendBotMessage('$SERVERNAME mission is ending, mission ran for ' .. theTimeString .. '  You all can go watch TOPGUN again.');
    end
end

local function HypeManBirthHandler(event)
    if event.id == world.event.S_EVENT_BIRTH then
        -- local name = Unit.getPlayerName(event.initiator)

        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        if name == nil then
            name = Unit.getName(event.initiator)
        end

        HypeManTakeOffTime[Unit.getID(event.initiator)]=nil

        --	HypeMan.sendBotMessage('S_EVENT_BIRTH UNIT.name = ' .. name)
    end
end

local function HypeManPilotDeadHandler(event)
    if event.id == world.event.S_EVENT_PILOT_DEAD then

        -- local name = Unit.getPlayerName(event.initiator)
        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        -- for debugging get the AI plane names
        if HypeManAnnounceAIPlanes and name == nil then
            name = Unit.getName(event.initiator)
        end

        if name == nil then
            return
        end

        -- if name == nil then
        --			name = Unit.getName(event.initiator)
        -- end

        local unitid = Unit.getID(event.initiator)

        if unitid ~= nil and event.iniator ~= nil then
            HypeManTakeOffTime[Unit.getID(event.initiator)]=nil
        end

        HypeMan.sendBotMessage('RIP ' .. name .. '.  HypeMan pours out a little liquor for his homie.')
    end
end


local function HypeManPilotEjectHandler(event)
    if event.id == world.event.S_EVENT_EJECTION then

        -- local name = Unit.getPlayerName(event.initiator)
        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        -- for debugging get the AI plane names
        if HypeManAnnounceAIPlanes and name == nil then
            name = Unit.getName(event.initiator)
        end

        if name == nil then
            return
        end

        HypeManTakeOffTime[Unit.getID(event.initiator)]=nil

        HypeMan.sendBotMessage(name .. ' has EJECTED from their' ..  Unit.getTypeName(event.initiator) .. ' on $SERVERNAME.  Send in the rescue helos!')
    end
end

local function HypeManRefuelingHandler(event)
    if event.id == world.event.	S_EVENT_REFUELING then

        local statusflag, name = HypeManGetName(event.initiator)

        if statusflag == false then
            return
        end

        if HypeManAnnounceAIPlanes and name == nil then
            name = Unit.getName(event.initiator)
        end

        if name == nil then
            return
        end


        local t = HypeManRefuelingTable[Unit.getID(event.initiator)]

        local sendMessage = false
        if t == nil then
            sendMessage = true
        else
            local cur = timer.getAbsTime()
            local tduration = cur - t

            if tduration < 600 then
                sendMessage = false
            else
                sendMessage = true
            end
        end

        HypeManRefuelingTable[Unit.getID(event.initiator)] = cur

        if sendMessage == true then
            HypeMan.sendBotMessage('   a\'ight, looks like ' .. name .. ' is getting a poke on the $SERVERNAME.')
        end
    end
end

if HypeManAnnounceRefueling then
    mist.addEventHandler(HypeManRefuelingHandler)
end


mist.addEventHandler(HypeManBirthHandler)

--if HypeManAnnounceCrash then
--	mist.addEventHandler(HypeManCrashHandler)
--end

--if HypeManAnnounceKills then
--	mist.addEventHandler(HypeManHitHandler)
--	mist.addEventHandler(HypeManDeadHandler)
--end

if HypeManAnnounceTakeoffs then
    mist.addEventHandler(HypeManTakeOffHandler)
end

if HypeManAnnounceLandings then
    mist.addEventHandler(HypeManLandingHandler)
end

if HypeManAnnouncePilotEject then
    mist.addEventHandler(HypeManPilotEjectHandler)
end

if HypeManAnnouncePilotDead then
    mist.addEventHandler(HypeManPilotDeadHandler)
end

if HypeManAnnounceMissionEnd then
    mist.addEventHandler(HypeManMissionEndHandler)
end

