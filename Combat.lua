-- this is the advanced combat text reader.  in the end I don't think that I am going to use it.
-- This still needs a lot of work to be completed

-- Combat Text Event Engine
local ADDON_NAME, xCT = ...
xCT.CombatText = { }

local xCT_CombatText                  = xCT.CombatText
local xCT_Player                      = xCT.Player

local xCT_Output                      = xCT.Output
local xCT_FormatCritical              = xCT_Output.FormatCritical
local xCT_FormatResist                = xCT_Output.FormatResist
local xCT_SendOutgoingMessage         = xCT_Output.SendOutgoingMessage
local xCT_SendIncomingDamageMessage   = xCT_Output.SendIncomingDamageMessage
local xCT_SendIncomingHealingMessage  = xCT_Output.SendIncomingHealingMessage
local xCT_SendGeneralMessage          = xCT_Output.SendGeneralMessage

local EnvironmentDamage = {
  ["DROWNING"] = true,
   ["FALLING"] = true,
   ["FATIGUE"] = true,
      ["FIRE"] = true,
      ["LAVA"] = true,
     ["SLIME"] = true,
}

local MissTypes = {
   ["ABSORB"] = true,
    ["BLOCK"] = true,
  ["DEFLECT"] = true,
    ["DODGE"] = true,
    ["EVADE"] = true,
   ["IMMUNE"] = true,
     ["MISS"] = true,
    ["PARRY"] = true,
  ["REFLECT"] = true,
   ["RESIST"] = true,
}

local SpellSchools = {
 --   Type     [Red - Green - Blue]
    ["Holy"] = { 0xFF, 0xE6, 0x80 },
    ["Fire"] = { 0xFF, 0x80, 0x00 },
  ["Nature"] = { 0x4D, 0xFF, 0x4D },
   ["Frost"] = { 0x80, 0xFF, 0xFF },
  ["Shadow"] = { 0x80, 0x80, 0xFF },
  ["Arcane"] = { 0xFF, 0x80, 0xFF },
}

-- Returns if this event affects a player, pet or vehicle
function xCT_CombatText:AffectedOutgoingUnits(srcGUID, srcFlags)
  local player, pet, vehicle = false, false, false
  
  if srcGUID == xCT_Player.GUID then
    player = true
  end
  if xCT_Player:HasPet() and srcGUID == xCT_Player.Pet.GUID then
    pet = true
  end
  if srcFlags == Player.GoodSourceFlags then
    vehicle = true
  end
  
  return player, pet, vehicle
end

function xCT_CombatText:AffectedIncomingUnits(destGUID, destFlags)
  local player, pet, vehicle = false, false, false
  
  if destGUID == xCT_Player.GUID then
    player = true
  end
  if xCT_Player:HasPet() and destGUID == xCT_Player.Pet.GUID then
    pet = true
  end
  if destFlags == Player.GoodSourceFlags then
    vehicle = true
  end
  
  return player, pet, vehicle
end

function xCT_CombatText:AllowShown(player, pet, vehicle)
  return (player or (pet and xCT.CurrentProfile["ShowPet"]) or (vehicle and xCT.CurrentProfile["ShowVehicle"]))
end

-- Outgoing Events
function xCT_CombatText:SWING_DAMAGE(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11

  -- DAMAGE
  local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(args, ...)
  args = args + 9

  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowSwingDamage"] then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 255, 25, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg, resist = tostring(amount), resisted + blocked + absorbed
    msg = xCT_FormatResist(msg, resist)
    
    local r, g, b = 255, 25, 25
    xCT_SendIncomingDamageMessage(msg, critical, r, g, b)
    
  end
end

function xCT_CombatText:SPELL_PERIODIC_HEAL(...)
  local args = 1

  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3

  -- HEAL
  local amount, overHealing, absorbed, critical = select(args, ...)
  args = args + 4
  
  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowHOTs"] then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 25, 255, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 25, 255, 25
    xCT_SendIncomingHealingMessage(msg, critical, r, g, b)
    
  end
end

function xCT_CombatText:SPELL_HEAL(...)
  local args = 1

  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- HEAL
  local amount, overHealing, absorbed, critical = select(args, ...)
  args = args + 4
  
  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowHOTs"] then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 25, 255, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 25, 255, 25
    xCT_SendIncomingHealingMessage(msg, critical, r, g, b)
    
  end
end

function xCT_CombatText:RANGE_DAMAGE(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- DAMAGE
  local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(args, ...)
  args = args + 9
  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 255, 25, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg, resist = tostring(amount), resisted + blocked + absorbed
    msg = xCT_FormatResist(msg, resist)
    
    local r, g, b = 255, 25, 25
    xCT_SendIncomingDamageMessage(msg, critical, r, g, b)
    
  end
  
end

function xCT_CombatText:SPELL_DAMAGE(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- DAMAGE
  local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(args, ...)
  args = args + 9

  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 255, 25, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg, resist = tostring(amount), resisted + blocked + absorbed
    msg = xCT_FormatResist(msg, resist)
    
    local r, g, b = 255, 25, 25
    xCT_SendIncomingDamageMessage(msg, critical, r, g, b)
    
  end
end

function xCT_CombatText:SPELL_PERIODIC_DAMAGE(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- DAMAGE
  local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(args, ...)
  args = args + 9
  
  -- Outgoing
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowDOT"] then
    -- FORMAT THE OUTPUT
    local msg = tostring(amount)
    local r, g, b = 255, 25, 25
    xCT_SendOutgoingMessage(msg, critical, r, g, b)
  
  -- Incoming
  elseif self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg, resist = tostring(amount), resisted + blocked + absorbed
    msg = xCT_FormatResist(msg, resist)
    
    local r, g, b = 255, 25, 25
    xCT_SendIncomingDamageMessage(msg, critical, r, g, b)
    
  end
end

function xCT_CombatText:SWING_MISSED(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- MISSED
  local missType, isOffHand, amountMissed = select(args, ...)
  args = args + 3
  
  -- Incoming
  if self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(missType)
    
    local r, g, b = 96, 96, 96
    xCT_SendIncomingDamageMessage(msg, false, r, g, b)
    
  end
  
end

function xCT_CombatText:SPELL_MISSED(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- MISSED
  local missType, isOffHand, amountMissed = select(args, ...)
  args = args + 3
  
  -- Incoming
  if self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(missType)
    
    local r, g, b = 96, 96, 96
    xCT_SendIncomingDamageMessage(msg, false, r, g, b)
    
  end
end

function xCT_CombatText:RANGE_MISSED(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- MISSED
  local missType, isOffHand, amountMissed = select(args, ...)
  args = args + 3
  
  -- Incoming
  if self:AllowShown( self:AffectedIncomingUnits(dstGUID, dstFlags) ) then
    -- FORMAT THE OUTPUT
    local msg = tostring(missType)
    
    local r, g, b = 96, 96, 96
    xCT_SendIncomingDamageMessage(msg, false, r, g, b)
    
  end
end

function xCT_CombatText:SPELL_DISPEL(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- DISPEL, STOLEN
  local extraSpellID, extraSpellName, extraSchool, auraType = select(args, ...)
  args = args + 4

  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowDOTs"] then
    -- FORMAT THE OUTPUT
    local msg = string.format("%s %s", ACTION_DISPELL, tostring(spellId))
    local r, g, b = 50, 50, 255
    xCT_SendGeneralMessage(msg, false, r, g, b)
  end
  
end

function xCT_CombatText:SPELL_STOLEN(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- DISPEL, STOLEN
  local extraSpellID, extraSpellName, extraSchool, auraType = select(args, ...)
  args = args + 4

  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowDOTs"] then
    -- FORMAT THE OUTPUT
    local msg = string.format("%s %s", ACTION_DISPELL, tostring(spellId))
    local r, g, b = 50, 50, 255
    xCT_SendGeneralMessage(msg, false, r, g, b)
  end
end

function xCT_CombatText:SPELL_INTERRUPT(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  -- RANGE, SPELL, SPELL_PERIODIC event args
  local spellId, spellName, spellSchool = select(args, ...)
  args = args + 3
  
  -- INTERRUPT
  local extraSpellID, extraSpellName, extraSchool = select(args, ...)
  args = args + 3
  
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowDOTs"] then
    -- FORMAT THE OUTPUT
    local msg = ACTION_INTERRUPT
    local r, g, b = 50, 50, 255
    xCT_SendGeneralMessage(msg, false, r, g, b)
  end
end

function xCT_CombatText:PARTY_KILL(...)
  local args = 1
  
  -- All events args
  local timesStamp, eventName, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = select(args, ...)
  args = args + 11
  
  if self:AllowShown( self:AffectedOutgoingUnits(srcGUID, srcFlags) ) and xCT.CurrentProfile["ShowDOTs"] then
    -- FORMAT THE OUTPUT
    local msg = "Killing Blow: " .. dstName
    local r, g, b = 50, 50, 255
    xCT_SendGeneralMessage(msg, false, r, g, b)
  end
end