--[[   ____ _____
__  __/ ___|_   _|_
\ \/ / |     | |_| |_
 >  <| |___  | |_   _|
/_/\_\\____| |_| |_|
World of Warcraft (4.3)

Title: xCT+
Author: Dandruff
Version: 3.0.0 beta
Description:
  xCT+ is an extremely lightwight scrolling combat text addon.  It replaces Blizzard's default
scrolling combat text with something that is more concised and organized.  xCT+ is the continuation
of xCT (by Affli) that has been outdated since WoW 4.0.6.

]]

local ADDON_NAME, engine = ...
local xCTEvents, xCT, _ = unpack(engine)

local XCT_DEBUG = true

-- Create Locals for faster lookups
local s_format  = string.format
local s_lower   = string.lower

local function t_copy(copy, lookup)
  local temp = { }
  for k, v in pairs(copy) do
    temp[k] = v end  
  if lookup then
    local tempMT = {
      __index = function(t, k)
        return lookup[k]
      end, }
    setmetatable(temp, tempMT) end
  return temp
end

-- Fast Access Locals
local ActiveProfile = nil
local C = nil
local L = nil
local EnergyTypes = nil

-- Create a Metatable for our frames
local FrameMT = {
  __index = function(t, k)
      local fakeFrame = { AddMessage = function(...)
            -- Debug
            xCT.Debug("Attempted to put a message in frame: '"..k.."' which does not exist")
          end,
        }
      t[k] = fakeFrame
      return fakeFrame
    end,
}

-- Frames
local F = { }
setmetatable(F, FrameMT)
local FramesLocked = true

-- Register Event for when we get loaded
xCTEvents["OptionsLoaded"] = function()
  ActiveProfile = xCT.ChangeProfile()
  
  -- Assign some aliases
  L = xCTOptions.Localization[xCTOptions.Localization._active]
  C = xCTOptions.Colors
  EnergyTypes = ActiveProfile.EnergyTypes
  
  -- Load the Frames
  for FrameName, Frame in pairs(xCTOptions.Frames) do
    if Frame.Enabled then
      local f = CreateFrame("ScrollingMessageFrame", _, UIParent)
      
      -- Unconfig values
      f:SetClampedToScreen(true)
      f:SetMovable(true)
      f:SetResizable(true)
      f:SetShadowColor(0, 0, 0, 0)
      f:SetTimeVisible(3)
      f:SetSpacing(2)
      f:SetMinResize(64, 64)
      f:SetMaxResize(768, 768)

      -- Config Values
      local Frame_Font = Frame.Font
      f:SetFont(Frame_Font.Name, Frame_Font.Size, Frame_Font.Style)
      f:SetClampRectInsets(0, 0, Frame_Font.Size, 0)
      f:SetWidth(Frame.Width)
      f:SetHeight(Frame.Height)
      local Frame_Point = Frame.Point
      f:ClearAllPoints() -- Don't use Blizzard's Frame saver
      f:SetPoint(Frame_Point.Relative, Frame_Point.X, Frame_Point.Y)
      f:SetJustifyH(Frame.Justify)
      
      f:SetMaxLines(Frame.Height / Frame_Font.Size)
      
      F[FrameName] = f  -- store the frame
    end
  end
  
  if not ActiveProfile.ShowHeadNumbers then  
    -- Move the options up
    InterfaceOptionsCombatTextPanelEnableFCT:ClearAllPoints()
    InterfaceOptionsCombatTextPanelEnableFCT:SetPoint("TOPLEFT", 16, -94)
    
    -- Hide some options
    InterfaceOptionsCombatTextPanelTargetDamage:Hide()
    InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
    InterfaceOptionsCombatTextPanelPetDamage:Hide()
    InterfaceOptionsCombatTextPanelHealing:Hide()
    
    -- Disallow these options (head numbers)
    SetCVar("CombatLogPeriodicSpells", 0)
    SetCVar("PetMeleeDamage", 0)
    SetCVar("CombatDamage", 0)
    SetCVar("CombatHealing", 0)
  end
  
  xCT.InvokeEvent("FramesLoaded")
end

-- xCT String Formats
xCT.Formats = {
  BlankIcon = "Interface\\Addons\\xCT\\blank",
  GoodSourceFlags = bit.bor( COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_GUARDIAN ),
  Healing = function(msg, name)
    if name and COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
      return name.." +"..msg
    else
      return "+"..msg end
    end,
  HealingCrit = function(msg, name)
    if name and COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
      return name.." "..ActiveProfile.CritPrefix.."+"..msg..ActiveProfile.CritPostfix
    else
      return ActiveProfile.CritPrefix.."+"..msg..ActiveProfile.CritPostfix end
    end,
  Damage = function(msg)
      return "-"..msg
    end,
  DamageCrit = function(msg)
      return ActiveProfile.CritPrefix.."-"..msg..ActiveProfile.CritPostfix
    end,
  DamageOut = function(amount, crit, icon)
    if crit then
      return s_format("%s%s%s %s", ActiveProfile.CritPrefix, amount, ActiveProfile.CritPostfix, icon)
    else
      return s_format("%s %s", amount, icon) end
    end,
  Icon = function(spellID, pet)
    local name, _, icon = GetSpellInfo(spellID or 0)
    local size = ActiveProfile.IconSize
    if ActiveProfile.ShowOutgoingIcons or ActiveProfile.UseTextIcons then
      if ActiveProfile.UseTextIcons then
        if pet then
          return "["..L.Pet.."]"
        else
          if not name then name = L.Swing end
          return "["..name.."]" end
      else
        if pet then
          return " \124T"..PET_ATTACK_TEXTURE..":"..size..":"..size..":0:0:64:64:5:59:5:59\124t"
        else
          if not icon then
            return " \124T"..X.BlankIcon..":"..size..":"..size..":0:0:64:64:5:59:5:59\124t"
          else
            return " \124T"..icon..":"..size..":"..size..":0:0:64:64:5:59:5:59\124t" end
        end
      end
    else
      return "" end
    end,
  Resist = function(amount, msg, resisted)
    if resisted then
      if COMBAT_TEXT_SHOW_RESISTANCES == "1" then
        return s_format("-%s (%s %s)", amount, msg, resisted)
      else
        return "-"..amount end
    elseif COMBAT_TEXT_SHOW_RESISTANCES == "1" then
      return msg end
    end,
  Energize = function(amount, energy, ...)
    if EnergyTypes[energy] and amount > 0 then
      return s_format("+%s %s", amount, L[energy]) end
    end,
}
local X = xCT.Formats

xCT.Player = {
  Name = GetUnitName("player"),
  Class = select(2, UnitClass("player")),
  Power = select(2, UnitPowerType("player")),
  Unit = "player",
  IsLowHealth = function(self)
    if UnitHealth(self.Unit) / UnitHealthMax(self.Unit) <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD then
      if not self.lowHealth then
        self.lowHealth = true
        return true end
    else
      self.lowHealth = nil end
      return false
    end,
  IsLowMana = function(self)
      if self.Power == "MANA" then
        if UnitPower(self.Unit) / UnitPowerMax(self.Unit) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
          if not self.lowMana then
            self.lowMana = true
            return true
          end
          return false
        else
          self.lowMana = nil
        end
      end
      return false
    end,
  SetUnit = function(self)
    if UnitHasVehicleUI("player") then
      self.Unit = "vehicle"
      self.Power = select(2, UnitPowerType("vehicle"))
      CombatTextSetActiveUnit("vehicle")
    else
      self.Unit = "player"
      self.Power = select(2, UnitPowerType("player"))
      CombatTextSetActiveUnit("player") end
    end,
}

local Player = xCT.Player
local PlayerMT = {
  __index = function(t, k)
      if k == "GUID" then
        return UnitGUID("player")
      end
    end
}
setmetatable(Player, PlayerMT)

local xCTCombatEvents = {
  COMBAT_TEXT_UPDATE = {  -- Sub-Events
    DAMAGE = function(amount)
        F.Damage:AddMessage(X.Damage(amount), unpack(C.Damage))
      end,
    DAMAGE_CRIT = function(amount)
        F.Damage:AddMessage(X.DamageCrit(amount), unpack(C.DamageCrit))
      end,
    SPELL_DAMAGE = function(amount)
        F.Damage:AddMessage(X.Damage(amount), unpack(C.SpellDamage))
      end,
    SPELL_DAMAGE_CRIT = function(amount)
        F.Damage:AddMessage(X.DamageCrit(amount), unpack(C.SpellDamageCrit))
      end,
    HEAL = function(name, amount)
        F.Healing:AddMessage(X.Healing(amount, name), unpack(C.Healing))
      end,
    HEAL_CRIT = function(name, amount)
        F.Healing:AddMessage(X.HealingCrit(amount, name), unpack(C.HealingCrit))
      end,
    PERIODIC_HEAL = function(name, amount)
        if amount >= ActiveProfile.HealThreshold then
          F.Healing:AddMessage(X.HealingCrit(amount, name), unpack(C.HealingCrit)) end
      end,
    SPELL_CAST = function(spell)
        F.Procs:AddMessage(spell, unpack(C.SpellCast))
      end,
    MISS = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.MISS, unpack(C.MissType)) end
      end,
    DODGE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.DODGE, unpack(C.MissType)) end
      end,
    PARRY = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.PARRY, unpack(C.MissType)) end
      end,
    EVADE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.EVADE, unpack(C.MissType)) end
      end,
    IMMUNE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.IMMUNE, unpack(C.MissType)) end
      end,
    DEFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.DEFLECT, unpack(C.MissType)) end
      end,
    REFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.REFLECT, unpack(C.MissType)) end
      end,
    SPELL_MISS = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.MISS, unpack(C.MissType)) end
      end,
    SPELL_DODGE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.DODGE, unpack(C.MissType)) end
      end,
    SPELL_PARRY = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.PARRY, unpack(C.MissType)) end
      end,
    SPELL_EVADE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.EVADE, unpack(C.MissType)) end
      end,
    SPELL_IMMUNE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.IMMUNE, unpack(C.MissType)) end
      end,
    SPELL_DEFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.DEFLECT, unpack(C.MissType)) end
      end,
    SPELL_REFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.REFLECT, unpack(C.MissType)) end
      end,
    RESIST = function(amount, resisted)
        F.Damage:AddMessage(X.Resist(amount, L.RESIST, resisted), unpack(C.MissType))
      end,
    BLOCK = function(amount, blocked)
        F.Damage:AddMessage(X.Resist(amount, L.BLOCK, blocked), unpack(C.MissType))
      end,
    ABSORB = function(amount, absorbed)
        F.Damage:AddMessage(X.Resist(amount, L.ABSORB, absorbed), unpack(C.MissType))
      end,
    SPELL_RESIST = function(amount, resisted)
        F.Damage:AddMessage(X.Resist(amount, L.RESIST, resisted), unpack(C.MissType))
      end,
    SPELL_BLOCK = function(amount, blocked)
        F.Damage:AddMessage(X.Resist(amount, L.BLOCK, blocked), unpack(C.MissType))
      end,
    SPELL_ABSORB = function(amount, absorbed)
        F.Damage:AddMessage(X.Resist(amount, L.ABSORB, absorbed), unpack(C.MissType))
      end,
    ENERGIZE = function(amount, energy)
      if COMBAT_TEXT_SHOW_ENERGIZE == "1" then
        F.PowerGains:AddMessage(X.Energize(amount, energy), C.PowerBarColor[energy].r, C.PowerBarColor[energy].g, C.PowerBarColor[energy].b) end
      end,
    PERIODIC_ENERGIZE = function(amount, energy)
      if COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE == "1" then
        F.PowerGains:AddMessage(X.Energize(amount, energy), C.PowerBarColor[energy].r, C.PowerBarColor[energy].g, C.PowerBarColor[energy].b) end
      end,
    SPELL_AURA_START = function(spell)
      if COMBAT_TEXT_SHOW_AURAS == "1" then
        F.General:AddMessage("+"..spell,  unpack(C.BuffStart)) end
      end,
    SPELL_AURA_END = function(spell)
      if COMBAT_TEXT_SHOW_AURAS == "1" then
        F.General:AddMessage("-"..spell,  unpack(C.BuffEnd)) end
      end,
    SPELL_AURA_START_HARMFUL = function(spell)
      if COMBAT_TEXT_SHOW_AURAS == "1" then
        F.General:AddMessage("+"..spell,  unpack(C.DebuffStart)) end
      end,
    SPELL_AURA_END_HARMFUL = function(spell)
      if COMBAT_TEXT_SHOW_AURAS == "1" then
        F.General:AddMessage("-"..spell,  unpack(C.DebuffEnd)) end
      end,
    HONOR_GAINED = function(gain)
      local num = tonumber(gain)
      if COMBAT_TEXT_SHOW_HONOR_GAINED == "1" and num and (abs(num) > 1 or floor(num) > 0) then
        F.General:AddMessage(L.HONOR.." +"..floor(num), unpack(C.Honor)) end
      end,
    FACTION = function(name, gain)
      if COMBAT_TEXT_SHOW_REPUTATION == "1" then
        F.General:AddMessage(name.." +"..gain, unpack(C.Reputation)) end
      end,
    SPELL_ACTIVE = function(spell)
      if COMBAT_TEXT_SHOW_REACTIVES == "1" then
        F.General:AddMessage(spell, unpack(C.SpellReactive)) end
      end,
  },
  UNIT_HEALTH = function(unit)
    if COMBAT_TEXT_SHOW_LOW_HEALTH_MANA == "1" and unit == Player.Unit then
      if Player:IsLowHealth() then
        F.General:AddMessage(L.HEALTH_LOW, unpack(C.LowHealth)) end
      end
    end,
  UNIT_MANA = function(unit)
    if COMBAT_TEXT_SHOW_LOW_HEALTH_MANA == "1" and unit == Player.Unit then
      if Player:IsLowMana() then
        F.General:AddMessage(L.MANA_LOW, unpack(C.LowMana)) end
      end
    end,
  PLAYER_REGEN_ENABLED = function()
    if COMBAT_TEXT_SHOW_COMBAT_STATE == "1" then
      F.General:AddMessage(L.LEAVING_COMBAT, unpack(C.LeavingCombat)) end
    end,
  PLAYER_REGEN_DISABLED = function()
    if COMBAT_TEXT_SHOW_COMBAT_STATE == "1" then
      F.General:AddMessage(L.ENTERING_COMBAT, unpack(C.EnteringCombat)) end
    end,
  UNIT_ENTERED_VEHICLE = function(unit)
    if unit == "player" then
      Player:SetUnit() end
    end,
  UNIT_EXITING_VEHICLE = function(unit)
    if unit == "player" then
      Player:SetUnit() end
    end,
  UNIT_COMBO_POINTS = function(unit)
    if COMBAT_TEXT_SHOW_COMBO_POINTS == "1" and unit == Player.Unit then
      local color, comboPoints = C.ComboPoint, GetComboPoints(Player.Unit, "target")
      if comboPoints == MAX_COMBO_POINTS then
        color = C.MaxComboPoints end
      F.General:AddMessage(s_format(COMBAT_TEXT_COMBO_POINTS, comboPoints), unpack(color)) end
    end,
  RUNE_POWER_UPDATE = function(runeSlot)
    local usable = select(3, GetRuneCooldown(runeSlot))
    if usable then
      local runeType = GetRuneType(runeSlot)
      if runeType then
        F.General:AddMessage("+"..L.RUNES[runeType], unpack(C.Runes[runeType])) end
      end
    end,
  -- UNIT_COMBO_POINTS
  -- RUNE_POWER_UPDATE
  -- PLAYER_ENTERING_WORLD
  -- CHAT_MSG_LOOT
  -- CHAT_MSG_MONEY
}

local xCTDamageEvents = {
  SWING_DAMAGE = function(_, pet, _, ...)
    local amount, _, _, _, _, _, critical = select(12, ...)
    local frame = F.Outgoing
    if critical then
      frame = F.Critical end
    if pet then
      frame:AddMessage(X.DamageOut(amount, critical, X.Icon(nil, true)), unpack(C["1"]))
    else
      frame:AddMessage(X.DamageOut(amount, critical, X.Icon(6603)), unpack(C["1"])) end
    end,
  RANGE_DAMAGE = function(_, _, _, ...)
    local spellId, _, _, amount, _, _, _, _, _, critical = select(12, ...)
    local frame = F.Outgoing
    if critical then
      frame = F.Critical end
    frame:AddMessage(X.DamageOut(amount, critical, X.Icon(spellId)), unpack(C["1"]))
    end,
  SPELL_DAMAGE = function(_, _, _, ...)
    local spellId, _, spellSchool, amount, _, _, _, _, _, critical = select(12, ...)
    local color, frame = C["1"], F.Outgoing
    if ActiveProfile.DamageColors then
      color = C[tostring(spellSchool)] end
    if critical then
      frame = F.Critical end
    frame:AddMessage(X.DamageOut(amount, critical, X.Icon(spellId)), unpack(color))
  end,
  SPELL_PERIODIC_DAMAGE = function(_, _, _, ...)
      local spellId, _, spellSchool, amount, _, _, _, _, _, critical = select(12, ...)
      local color, frame = C["1"], F.Outgoing
      if ActiveProfile.DamageColors then
        color = C[tostring(spellSchool)] end
      if critical then
        frame = F.Critical end
      frame:AddMessage(X.DamageOut(amount, critical, X.Icon(spellId)), unpack(color))
    end,
  SWING_MISSED = function(_, pet, _, ...)
    local missType = select(12, ...)
    if pet then
      F.Outgoing:AddMessage(X.DamageOut(L[missType], false, X.Icon(nil, true)), unpack(C.MissType))
    else
      F.Outgoing:AddMessage(X.DamageOut(L[missType], false, X.Icon(6603)), unpack(C.MissType)) end
    end,
  SPELL_MISSED = function(_, _, _, ...)
      local spellId, _, _, missType, _ = select(12, ...)
      F.Outgoing:AddMessage(X.DamageOut(L[missType], false, X.Icon(spellId)), unpack(C.MissType))
    end,
  RANGE_MISSED = function(_, _, _, ...)
      local spellId, _, _, missType, _ = select(12, ...)
      F.Outgoing:AddMessage(X.DamageOut(L[missType], false, X.Icon(spellId)), unpack(C.MissType))
    end,
  SPELL_DISPEL = function(_, _, _, ...)
      local target, _, _, id, effect, _, etype = select(12, ...)
      local color = C.DispellDebuff
      if etype == "BUFF" then
        color = C.DispellBuff end
      F.General:AddMessage(L.ACTION_DISPEL..": "..effect..X.Icon(id), unpack(color))
    end,
  SPELL_INTERRUPT = function(_, _, _, ...)
      local target, _, _, id, effect = select(12, ...)
      F.General:AddMessage(L.ACTION_INTERRUPT..": "..effect..X.Icon(id), unpack(C.Interrupt))
    end,
  PARTY_KILL = function(_, _, _, ...)
      local name = select(9, ...)
      F.General:AddMessage(L.ACTION_KILLED..": "..name, unpack(C.UnitKilled))
    end,
}

local xCTHealingEvents = {
  SPELL_HEAL = function(_, _, ...)
      local spellId, _, _, amount, _, _, critical = select(12, ...)
      local color, frame = C.Healing, F.Outgoing
      if critical then
        color = C.HealingCrit
        frame = F.Critical end
      frame:AddMessage(X.DamageOut(amount, critical, X.Icon(spellId)), unpack(color))
    end,
  SPELL_PERIODIC_HEAL = function(_, _, ...)
      local spellId, _, _, amount, _, _, critical = select(12, ...)
      local color, frame = C.Healing, F.Outgoing
      if critical then
        color = C.HealingCrit
        frame = F.Critical end
      frame:AddMessage(X.DamageOut(amount, critical, X.Icon(spellId)), unpack(color))
    end,
}

-- Register the Events
do
  -- Combat Events
  local combat = CreateFrame"FRAME"
  combat:RegisterEvent"COMBAT_TEXT_UPDATE"
  combat:RegisterEvent"UNIT_HEALTH"
  combat:RegisterEvent"UNIT_MANA"
  combat:RegisterEvent"PLAYER_REGEN_DISABLED"
  combat:RegisterEvent"PLAYER_REGEN_ENABLED"
  combat:RegisterEvent"UNIT_ENTERED_VEHICLE"
  combat:RegisterEvent"UNIT_EXITING_VEHICLE"
  combat:RegisterEvent"UNIT_COMBO_POINTS"
  combat:RegisterEvent"RUNE_POWER_UPDATE"
  combat:SetScript("OnEvent",
    function(_, event, ...)
      local handler = xCTCombatEvents[event]
      if handler then
        if type(handler) == "function" then
          return handler(...)
        end
        local subevent = ...
        if subevent and handler[subevent] then
          handler[subevent]( select(2, ...) )
        end
      end
    end)

  -- Outgoing Event Handlers
  local damage = CreateFrame"FRAME"
  damage:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
  damage:SetScript("OnEvent",
    function(self, event, ...)
      local timeStamp, eventType, hideCaster, scrGUID, scrName, scrFlags, scrFlags2, dstGUID = select(1, ...)
      local player = (scrGUID == Player.GUID and dstGUID ~= Player.GUID)
      local pet = (scrGUID == UnitGUID("pet") and ActiveProfile.PetDamage)
      local vehicle = (scrFlags == X.GoodSourceFlags)
      local handler = xCTDamageEvents[eventType]
      if handler and (player or pet or vehicle) then
        handler(player, pet, vehicle, ...)
      end
    end)
  local healing = CreateFrame"FRAME"
  healing:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
  healing:SetScript("OnEvent",
    function(self, event, ...)
      local timeStamp, eventType, hideCaster, scrGUID, scrName, scrFlags, scrFlags2, dstGUID = select(1, ...)
      local player = (scrGUID == Player.GUID)
      local vehicle = (scrFlags == X.GoodSourceFlags)
      local handler = xCTHealingEvents[eventType]
      --print("event", eventType,"player", player, "pet", pet, "vehicle", vehicle, "handler", handler, "args", select(13, ...))
      if handler and (player or vehicle) then
        handler(player, vehicle, ...)
      end
    end)
  
  
  -- Turn Off Blizzard's CT
  CombatText:UnregisterAllEvents()
  CombatText:SetScript("OnLoad", nil)
  CombatText:SetScript("OnEvent", nil)
  CombatText:SetScript("OnUpdate", nil)
  Blizzard_CombatText_AddMessage = CombatText_AddMessage
  InterfaceOptionsCombatTextPanelTitle:SetText(COMBAT_TEXT_LABEL.." (powered by \124cffFF0000x\124rCT\124cffFFFFFF+\124r)")
  InterfaceOptionsCombatTextPanelFCTDropDown:Hide()
  
  local CombatText_AddMessage = function(msg, _, r, g, b)
    F.General:AddMessage(message, r, g, b)
  end
end

function xCT.StartConfigMode()
  if not InCombatLockdown() then
    for frameName, frame in pairs(F) do
      local FrameOptions = xCTOptions.Frames[frameName]
      frame.FrameOptions = FrameOptions
      
      frame:SetBackdrop( {
        bgFile    = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile  = "Interface/Tooltips/UI-Tooltip-Border",
        tile      = false,
        tileSize  = 0,
        edgeSize  = 2,
        insets = {
          left    = 0,
          right   = 0,
          top     = 0,
          bottom  = 0,
        }
      })
      frame:SetBackdropColor(.1, .1, .1, .8)
      frame:SetBackdropBorderColor(.1, .1, .1, .5)
      
      -- Add the Frame's Title
      frame.fsTitle = frame:CreateFontString(nil, "OVERLAY")
      frame.fsTitle:SetFont(ActiveProfile.FontName, ActiveProfile.FontSize, ActiveProfile.FontStyle)
      frame.fsTitle:SetPoint("BOTTOM", frame, "TOP", 0, 0)
      frame.fsTitle:SetText(FrameOptions.Label)
      frame.fsTitle:SetTextColor(unpack(FrameOptions.LabelColor))
      
      frame.texBackHighlight = frame:CreateTexture"ARTWORK"
      frame.texBackHighlight:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
      frame.texBackHighlight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -19)
      frame.texBackHighlight:SetHeight(20)
      frame.texBackHighlight:SetTexture(.5, .5, .5)
      frame.texBackHighlight:SetAlpha(.3)

      frame.texResize = frame:CreateTexture"ARTWORK"
      frame.texResize:SetHeight(16)
      frame.texResize:SetWidth(16)
      frame.texResize:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
      frame.texResize:SetTexture(.5, .5, .5)
      frame.texResize:SetAlpha(.3)

      frame.titleRegion = frame:CreateTitleRegion()
      frame.titleRegion:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
      frame.titleRegion:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
      frame.titleRegion:SetHeight(20)
      
      -- font string Position (location)
      frame.fsPosition = frame:CreateFontString(nil, "OVERLAY")
      frame.fsPosition:SetFont(ActiveProfile.FontName, ActiveProfile.FontSize, ActiveProfile.FontStyle)
      frame.fsPosition:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
      frame.fsPosition:SetText("")
      frame.fsPosition:Hide()
      
      -- font string width
      frame.fsWidth = frame:CreateFontString(nil, "OVERLAY")
      frame.fsWidth:SetFont(ActiveProfile.FontName, ActiveProfile.FontSize, ActiveProfile.FontStyle)
      frame.fsWidth:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
      frame.fsWidth:SetText("")
      frame.fsWidth:Hide()
      
      -- font string height
      frame.fsHeight = frame:CreateFontString(nil, "OVERLAY")
      frame.fsHeight:SetFont(ActiveProfile.FontName, ActiveProfile.FontSize, ActiveProfile.FontStyle)
      frame.fsHeight:SetPoint("LEFT", frame, "LEFT", 3, 0)
      frame.fsHeight:SetText("")
      frame.fsHeight:Hide()
      
      local ResX, ResY = GetScreenWidth(), GetScreenHeight()
      local midX, midY = ResX / 2, ResY / 2
      
      frame:SetScript("OnLeave", function(self, ...)
              self:SetScript("OnUpdate", nil)
              self.fsPosition:Hide()
              self.fsWidth:Hide()
              self.fsHeight:Hide()
          end)
      frame:SetScript("OnEnter", function(self, ...)
              self:SetScript("OnUpdate", function(self, ...)
                      self.fsPosition:SetText(math.floor(self:GetLeft() - midX + 1) .. ", " .. math.floor(self:GetTop() - midY + 2))
                      self.fsWidth:SetText(math.floor(self:GetWidth()))
                      self.fsHeight:SetText(math.floor(self:GetHeight()))
                  end)
              self.fsPosition:Show()
              self.fsWidth:Show()
              self.fsHeight:Show()
          end)
      frame:EnableMouse(true)
      frame:RegisterForDrag("LeftButton")
      frame:SetScript("OnDragStart", frame.StartSizing)
      frame:SetScript("OnSizeChanged", function(self)
          self:SetMaxLines(self:GetHeight() / self.FrameOptions.Font.Size)
          self:Clear()
        end)

      frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    end
    FramesLocked = false
  end
end

function xCT.EndConfigMode()
  for frameName, frame in pairs(F) do
    local FrameOptions = xCTOptions.Frames[frameName]
    
    -- Unregister all the events
    frame:EnableMouse(false)
    frame:SetScript("OnDragStart", nil)
    frame:SetScript("OnDragStop", nil)
    frame:SetScript("OnSizeChanged", nil)
    frame:SetScript("OnLeave", nil)
    frame:SetScript("OnEnter", nil)
    frame:SetScript("OnUpdate", nil)

    -- Create Islands so they are GC'd
    frame:SetBackdrop(nil)
    frame.fsTitle:Hide()
    frame.fsTitle = nil
    frame.texBackHighlight:Hide()
    frame.texBackHighlight = nil
    frame.texResize:Hide()
    frame.texResize = nil
    frame.titleRegion = nil
    frame.fsPosition:Hide()
    frame.fsPosition = nil
    frame.fsWidth:Hide()
    frame.fsWidth = nil
    frame.fsHeight:Hide()
    frame.fsHeight = nil
    
    frame.FrameOptions = nil
    
    -- Save the Frames
    FrameOptions.Width = frame:GetWidth()
    FrameOptions.Height = frame:GetHeight()
    FrameOptions.Point.Relative, _, _, FrameOptions.Point.X, FrameOptions.Point.Y = frame:GetPoint(1)
    
    FramesLocked = true
  end
end

-- Hook Slash Commands
SLASH_XCTPLUS1 = "/xct"
SlashCmdList["XCTPLUS"] = function(input)
    input = s_lower(input)
    
    -- Get the Args
    local args = { }
    for v in input:gmatch("%w+") do
        args[#args+1] = v
    end
    
    -- Unlock the frames (show them) so that you can move them
    if args[1] == "unlock" then
        if FramesLocked then
            xCT.StartConfigMode()
        else
            xCT.Print("Frames already unlocked.")
        end
    
    -- Hides the frames and saves their position
    elseif args[1] == "lock" then
        if FramesLocked then
            xCT.Print("Frames already locked.")
        else
            xCT.EndConfigMode()
        end
    
    -- Erases ALL profiles and resets the addon back to default. for development only. this WILL BE REMOVED!
    elseif args[1] == "reset" and XCT_DEBUG then
      xCTOptions = nil
      ReloadUI()
    
    -- List all the profiles (and mark the one that's active)
    elseif args[1] == "profiles" then
      print(xCT.Print("User Profiles:"))
      local counter = 1
      for profile,_ in pairs(xCTOptions.Profiles) do
        local active = ""
        if profile == xCTOptions._activeProfile then
          active = " (|cffFFFF00active|r)" end
        print(s_format("    [%d] - %s%s", counter, profile, active))
        counter=counter+1
      end
    
    -- Load a profile (syntax: /xct load ProfileName)
    elseif args[1] == "load" then
      if not args[2] then
        xCT.ChangeProfile("Default")
      else
        if xCTOptions.Profiles[args[2]] then
          xCT.ChangeProfile(args[2])
        else
          xCT.Print("'|cff5555FF"..args[2].."|r' is not a profile. Type '/xct profiles' to see a list.")
        end
      end
    elseif args[1] == "create" then
      if xCTOptions.Profiles[args[2]] then
        xCT.Print("'|cff5555FF"..args[2].."|r' is already a profile. Type '/xct profiles' to see a list.")
      else
        xCT.CreateProfile(args[2], args[3])
        xCT.Print("Created and loaded new profile.")
      end
    

    elseif args[1] == "test" then
        xCT.Print("attempted to start Test Mode.")
        --[[if (ct.testmode) then
            EndTestMode()
            pr("test mode disabled.")
        else
            StartTestMode()
            pr("test mode enabled.")
        end]]
        
    else
        xCT.Print("|cff888888Position Commands|r")
        print("    Use |cffFF0000/xct|r |cff5555FFunlock|r to move and resize the frames.")
        print("    Use |cffFF0000/xct|r |cff5555FFlock|r to lock the frames.")
        print("    Use |cffFF0000/xct|r |cff5555FFtest|r to toggle Test Mode (|cffFFFF00on|r/|cffFFFF00off|r).")
        print()
        xCT.Print("|cff888888Profile Commands|r")
        print("    Use |cffFF0000/xct|r |cff5555FFprofiles|r to print a list of all the profiles.")
        print("    Use |cffFF0000/xct|r |cff5555FFload|r (|cff5555FFNumber|r or |cff5555FFName|r) to load a profile.")
        print("    Use |cffFF0000/xct|r |cff5555FFcreate|r (|cff5555FFName|r) to create a new profile.")
    end
end
