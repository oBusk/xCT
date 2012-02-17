-- Combat Text LiTE!
-- This module takes advantage of Blizzard's CT filter
local ADDON_NAME, xCT = ...

-- Create Module
xCT.CombatText = { }

-- Using
local xCT_CombatText = xCT.CombatText
local xCT_Output = xCT.Output
local xCT_Player = xCT.Player

-- Locals
local string_format = string.format
local XCT_PLAYER = "player"

-- Combat Text Sub-event table
local CombatTextUpdate = { }
xCT_CombatText.COMBAT_TEXT_UPDATE = CombatTextUpdate

-- Event Frame and Registered Events
local frameEvents = CreateFrame("frame")
frameEvents:RegisterEvent("COMBAT_TEXT_UPDATE")
frameEvents:RegisterEvent("UNIT_HEALTH")
frameEvents:RegisterEvent("UNIT_MANA")
frameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
frameEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
frameEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
frameEvents:RegisterEvent("UNIT_ENTERED_VEHICLE")
frameEvents:RegisterEvent("UNIT_EXITING_VEHICLE")
frameEvents:RegisterEvent("UNIT_COMBO_POINTS")
frameEvents:RegisterEvent("RUNE_POWER_UPDATE")
frameEvents:RegisterEvent("CHAT_MSG_MONEY")

-- Event Dispatcher
local function EventHandler(...)
  local self, eventName = select(1, ...)
  local handle = xCT_CombatText[eventName]
  if handle then
    if type(handler) == "function" then
      handle(select(1, ...))
    else
      local subevent = select(3, ...)
      if subevent and handler[subevent] then
        handler[subevent](select(1, ...))
      end
    end
  end
end

-- Assign the Dispatcher
combat:SetScript("OnEvent", EventHandler)

local in_dmg    = xCT_Output.SendIncomingDamageMessage
local in_heal   = xCT_Output.SendIncomingHealingMessage
local gen_msg   = xCT_Output.SendGeneralMessage
local proc_msg  = xCT_Output.SendProcMessage
local pow_msg   = xCT_Output.SendPowerMessage

-- COMBAT_TEXT_UPDATE - Sub Events
do
  function CombatTextUpdate:DAMAGE(amount)
    in_dmg(amount, false, 255, 25, 25)
  end
  function CombatTextUpdate:DAMAGE_CRIT(amount)
    in_dmg(amount, true, 255, 25, 25)
  end
  function CombatTextUpdate:SPELL_DAMAGE(amount)
    in_dmg(amount, false, 255, 25, 25)
  end
  function CombatTextUpdate:SPELL_DAMAGE_CRIT(amount)
    in_dmg(amount, true, 255, 25, 25)
  end
  function CombatTextUpdate:HEAL(name, amount)
    in_heal(amount, name, false, 25, 255, 25)
  end
  function CombatTextUpdate:HEAL_CRIT(name, amount)
    in_heal(amount, name, true, 25, 255, 25)
  end
  function CombatTextUpdate:PERIODIC_HEAL(name, amount)
    in_heal(amount, name, false, 25, 255, 25)
  end
  function CombatTextUpdate:SPELL_CAST(spell)
    proc_msg(spell, 255, 255, 25)
  end
  function CombatTextUpdate:MISS()
    in_dmg(MISS, false, 96, 96, 96)
  end
  function CombatTextUpdate:DODGE()
    in_dmg(DODGE, false, 96, 96, 96)
  end
  function CombatTextUpdate:PARRY()
    in_dmg(PARRY, false, 96, 96, 96)
  end
  function CombatTextUpdate:EVADE()
    in_dmg(EVADE, false, 96, 96, 96)
  end
  function CombatTextUpdate:IMMUNE()
    in_dmg(IMMUNE, false, 96, 96, 96)
  end
  function CombatTextUpdate:DEFLECT()
    in_dmg(DEFLECT, false, 96, 96, 96)
  end
  function CombatTextUpdate:REFLECT()
    in_dmg(REFLECT, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_MISS()
    in_dmg(MISS, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_DODGE()
    in_dmg(DODGE, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_PARRY()
    in_dmg(PARRY, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_EVADE()
    in_dmg(EVADE, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_IMMUNE()
    in_dmg(IMMUNE, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_DEFLECT()
    in_dmg(DEFLECT, false, 96, 96, 96)
  end
  function CombatTextUpdate:SPELL_REFLECT()
    in_dmg(REFLECT, false, 96, 96, 96)
  end
  function CombatTextUpdate:RESIST(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:BLOCK(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:ABSORB(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:SPELL_RESIST(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:SPELL_BLOCK(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:SPELL_ABSORB(amount, avoid)
    in_dmg(string_format("|cffFF2121%d|r (%d)", amount, avoid), false, 160, 160, 160)
  end
  function CombatTextUpdate:ENERGIZE(amount, energy)
    pow_msg(amount, energy)
  end
  function CombatTextUpdate:PERIODIC_ENERGIZE(amount, energy)
    pow_msg(amount, energy)
  end
  function CombatTextUpdate:SPELL_AURA_START(spell)
    gen_msg(string_format("+%d", spell), 25, 255, 255)
  end
  function CombatTextUpdate:SPELL_AURA_END(spell)
    gen_msg(string_format("-%d", spell), 25, 255, 255)
  end
  function CombatTextUpdate:SPELL_AURA_START_HARMFUL(spell)
    gen_msg(string_format("+%d", spell), 255, 25, 255)
  end
  function CombatTextUpdate:SPELL_AURA_END_HARMFUL(spell)
    gen_msg(string_format("-%d", spell), 255, 25, 255)
  end
  function CombatTextUpdate:HONOR_GAINED(gain)
    gen_msg(string_format("+%d", gain), 25, 25, 255)
  end
  function CombatTextUpdate:FACTION(name, gain)
    gen_msg(string_format("%s +%d", name, gain), 25, 25, 255)
  end
  function CombatTextUpdate:SPELL_ACTIVE(spell)
    proc_msg(string_format("+%d", spell), 255, 255, 25)
  end
end


function xCT_CombatText:UNIT_HEALTH(unit)
  if xCT.CurrentProfile["ShowLowManaHealth"] and xCT_Player.Unit == unit and xCT_Player:IsLowHealth() then
    gen_msg(HEALTH_LOW, 255, 25, 25)
  end
end
function xCT_CombatText:UNIT_MANA(unit)
  if xCT.CurrentProfile["ShowLowManaHealth"] and xCT_Player.Unit == unit and xCT_Player:IsLowMana() then
    gen_msg(MANA_LOW, 25, 25, 255)
  end
end
function xCT_CombatText:PLAYER_ENTERING_WORLD()
  xCT_Player:UpdatePlayer()
end
function xCT_CombatText:PLAYER_REGEN_DISABLED()
  if not xCT.CurrentProfile["ShowEnteringLeavingCombat"] then return end
  gen_msg(ENTERING_COMBAT, 255, 255, 255)
end
function xCT_CombatText:PLAYER_REGEN_ENABLED()
  if not xCT.CurrentProfile["ShowEnteringLeavingCombat"] then return end
  gen_msg(LEAVING_COMBAT, 255, 255, 255)
end
function xCT_CombatText:UNIT_ENTERED_VEHICLE()
  xCT_Player:UpdatePlayer()
end
function xCT_CombatText:UNIT_EXITING_VEHICLE()
  xCT_Player:UpdatePlayer()
end
function xCT_CombatText:UNIT_COMBO_POINTS()
  if not xCT.CurrentProfile["ShowComboPoints"] then return end
  local comboPoints = GetComboPoints(xCT_Player.Unit, "target")
  gen_msg(string_format(COMBAT_TEXT_COMBO_POINTS, comboPoints), 255, 255, 255)
end
function xCT_CombatText:RUNE_POWER_UPDATE(runeSlot)
  local usable = select(3, GetRuneCooldown(runeSlot))
  if usable then
    local runeType = GetRuneType(runeSlot)
    if runeType then
      gen_msg(RUNES[runeType], 255, 255, 255) 
    end
  end
end
function xCT_CombatText:CHAT_MSG_MONEY()

  -- NOT IMPLEMENTED YET

  return
end