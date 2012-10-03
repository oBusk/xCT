print("HELLO WORLD")

-- this file was created to make simplecombattext more simple
-- it will be responsible to send messages to the frames
-- and handle all the smarts that are required to do it :)

local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine

-- 'framename':
-- 'message':
-- 'colorname': found in addon/media/colors.lua
function x:AddMessage(framename, message, colorname)
  local r, g, b = 1, 1, 1
  if type(colorname) == table then
    r, g, b = unpack(colorname)
  else
    if not x.colors[colorname] then
      print("xct says there is no color named:", colorname)
    else
      r, g, b = unpack(x.colors[colorname])
    end
  end

  print("Sending Message! Frame:", framename, " |t Message:", message)
  
  if framename == "general" then
    xCTgeneral:AddMessage(message, r, g, b)
  elseif framename == "outgoing" then
    xCToutgoing:AddMessage(message, r, g, b)
  elseif framename == "damage" then
    xCTdamage:AddMessage(message, r, g, b)
  elseif framename == "healing" then
    xCThealing:AddMessage(message, r, g, b)
  elseif framename == "critical" then
    xCTcritical:AddMessage(message, r, g, b)
  elseif framename == "power" then
    xCTpower:AddMessage(message, r, g, b)
  elseif framename == "procs" then
    xCTprocs:AddMessage(message, r, g, b)
  elseif framename == "class" then
    xCTclass:AddMessage(message, r, g, b)
  else
    print("xct+ frame name not found:", framename)
  end
end

