local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine

-- Registers or Updates the combat text event frame
function x:UpdateCombatTextEvents()
  local f = nil
  
  if x.combatEvents then
    x.combatEvents:UnregisterAllEvents()
    f = x.combatEvents
  else
    f = CreateFrame"FRAME"
  end
  
  -- if enabled
  f:RegisterEvent("COMBAT_TEXT_UPDATE")
  f:RegisterEvent("UNIT_HEALTH")
  f:RegisterEvent("UNIT_MANA")
  f:RegisterEvent("PLAYER_REGEN_DISABLED")
  f:RegisterEvent("PLAYER_REGEN_ENABLED")
  f:RegisterEvent("UNIT_COMBO_POINTS")
  f:RegisterEvent("UNIT_ENTERED_VEHICLE")
  f:RegisterEvent("UNIT_EXITING_VEHICLE")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("PLAYER_TARGET_CHANGED")
  
  -- if runes
  f:RegisterEvent("RUNE_POWER_UPDATE")
  
  -- if loot
  f:RegisterEvent("CHAT_MSG_LOOT")
  f:RegisterEvent("CHAT_MSG_MONEY")
  
  -- damage and healing
  f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  
  -- Class combo points
  f:RegisterEvent("UNIT_AURA")
  f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  
  X.combatEvents = f
  
  f:SetScript("OnEvent", x.OnCombatTextEvent)
end

function x.OnCombatTextEvent(self, event, arg1, ...)

end
