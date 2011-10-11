--[[   ____ _____
__  __/ ___|_   _|_
\ \/ / |     | |_| |_
 >  <| |___  | |_   _|
/_/\_\\____| |_| |_|
World of Warcraft (4.3)

Title: xCT+
Author: Dandruff
Version: 3
Description:
  xCT+ is an extremely lightwight scrolling combat text addon.  It replaces Blizzard's default
scrolling combat text with something that is more concised and organized.  xCT+ is the continuation
of xCT (by Affli) that has been outdated since WoW 4.0.6.

]]
local ADDON_NAME, engine = ...

engine[1] = {} -- Events (Fake)
engine[2] = {} -- Functions
engine[3] = {} -- Options

-- Gobal xCT+ accessors
xCTShared = engine 
local xCT = engine[2]

-- Events Engine
local Events = { -- Events (Real)
  ["ChangedProfiles"] = { },
  ["OptionsLoaded"] = { },
  ["FramesLoaded"] = { },
}

--[[  In the end, this is a cool feature that I don't think anyone will use.  It would be a nice way of tying in
modules that are CPU intensive to people that would want those features.  It might be good for a GUI
config.  But as far as 3rd party dev goes, I don't know how useful this is.  ]]

local EventsMT = {
  -- You cannot create new events
  __newindex = function( _, event, handle)
      if Events[event] ~= nil then
        table.insert(Events[event], handle)
      end
    end,
    
  __metatable = { },
  
  __call = function(...)
    -- if they call the events, give them a list
      local list = { }
      for k, _ in pairs(Events) do
        table.insert(list, k)
      end
      return list
    end,
}

-- Set the engine event's metatable
setmetatable(engine[1], EventsMT)

local function InvokeEvent(event, ...)
  print("EVENT INVOKED: Attempted to fire all events tied to:   "..event)
  for _, handle in pairs(Events[event]) do
    if type(handle) == "function" then
      handle(event, ...)
    end
  end
end

-- Create Locals for faster lookups
local s_format  = string.format
local s_lower   = string.lower

local function t_copy(copy)
  local temp = { }
  for k, v in pairs(copy) do
    temp[k] = v end
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
            print("Attempted to put a message in frame: '"..k.."' which does not exist")
          end,
        }
      t[k] = fakeFrame
      return fakeFrame
    end,
}

-- Frames
local F = { }
setmetatable(F, FrameMT)

local function VariablesLoaded()
  -- Default Options
  if not xCTOptions then
    -- Debug
    print("FIRST LOAD: Could not find options. Loading default Options.")
    xCTOptions = {
      Frames = {
        -- Frame Names canNOT have a space or special character in them
        ["Critical"] = {
          Enabled = true,
          Label = "Crits",
          Color = { 1.00, 0.50, 0.00, 0.90 },
          Justify = "RIGHT",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = 128,
            Y = 0,
          },
          Width = 256,
          Height = 128,
        }, -- Critical
        ["Damage"] = {
          Enabled = true,
          Label = DAMAGE,
          Color = { 1.00, 0.10, 0.10, 0.90 },
          Justify = "LEFT",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = -320,
            Y = 0,
          },
          Width = 128,
          Height = 128,
        }, -- Damage
        ["General"] = {
          Enabled = true,
          Label = COMBAT_TEXT_LABEL,
          Color = { 0.10, 0.10, 1.00, 0.90 },
          Justify = "CENTER",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = 0,
            Y = 192,
          },
          Width = 256,
          Height = 128,
        }, -- General
        ["Healing"] = {
          Enabled = true,
          Label = SHOW_COMBAT_HEALING,
          Color = { 0.10, 1.00, 0.10, 0.90 },
          Justify = "RIGHT",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = -448,
            Y = 0,
          },
          Width = 128,
          Height = 128,
        }, -- Healing
        ["Loot"] = {
          Enabled = true,
          Label = LOOT,
          Color = { 1.00, 1.00, 1.00, 0.90 },
          Justify = "CENTER",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = 0,
            Y = -192,
          },
          Width = 256,
          Height = 128,
        },
        ["Outgoing"] = {
          Enabled = true,
          Label = SCORE_DAMAGE_DONE.." / "..SCORE_HEALING_DONE,
          Color = { 1.00, 1.00, 0.00, 0.90 },
          Justify = "RIGHT",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = 320,
            Y = 0,
          },
          Width = 128,
          Height = 128,
        },
        ["PowerGains"] = {
          Enabled = true,
          Label = "Power Gains",
          Color = { 0.80, 0.10, 1.00, 0.90 },
          Justify = "RIGHT",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = 448,
            Y = 0,
          },
          Width = 128,
          Height = 128,
        },
        ["Procs"] = {
          Enabled = true,
          Label = "Procs",
          Color = { 1.00, 0.60, 0.30, 0.90 },
          Justify = "CENTER",
          Font = {
            Size = 16,
            Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
            Style = "OUTLINE",
          },
          Point = {
            Relative = "Center",
            X = -128,
            Y = 0,
          },
          Width = 256,
          Height = 128,
        },
      },
      Profiles = {
        _active = "Default",
        Default = {
          ["ShowHeadNumbers"] = false,
          ["CritPrefix"] = "*",
          ["CritPostfix"] = "*",
          ["HealThreshold"] = 0,
          EnergyTypes = { -- Display Energy Types
            ["MANA"]          = true,
            ["RAGE"]          = true,
            ["FOCUS"]         = true,
            ["ENERGY"]        = true,
            ["RUINIC_POWER"]  = true,
            ["SOUL_SHARDS"]   = true,
            ["HOLY_POWER"]    = true,
          },
        },
      },
      Colors = {
        -- Damage Colors
        Damage          = { 0.75, 0.10, 0.10 },
        DamageCrit      = { 1.00, 0.10, 0.10 },
        SpellDamage     = { 0.75, 0.30, 0.85 },
        SpellDamageCrit = { 1.00, 0.30, 0.50 },
        
        -- Healing Colors
        Healing         = { 0.10, 0.75, 0.10 },
        HealingCrit     = { 0.10, 1.00, 0.10 },
        
        -- Spells and (De)Buffs
        SpellCast       = { 1.00, 0.82, 0.00 },
        SpellReactive   = { 1.00, 0.82, 0.00 },
        
        BuffStart       = { 1.00, 0.50, 0.50 },
        BuffEnd         = { 0.50, 0.50, 0.50 },
        DebuffStart     = { 1.00, 0.10, 0.10 },
        DebuffEnd       = { 0.10, 1.00, 0.10 },
        
        MissType        = { 0.50, 0.50, 0.50 },
        
        -- Misc
        Honor           = { 0.10, 0.10, 1.00 },
        Reputation      = { 0.10, 0.10, 1.00 },
        
        LowHealth       = { 1.00, 0.10, 0.10 },
        LowMana         = { 1.00, 0.10, 0.10 },
        
        EnteringCombat  = { 0.10, 1.00, 0.10 },
        LeavingCombat   = { 0.10, 1.00, 0.10 },
        
        PowerBarColor   = _G["PowerBarColor"]
      },
      Localization = {
        _active = "enUS",
        enUS = {
          -- Miss Types
          Absorb            = ABSORB,             -- "Absorb", 
          Block             = BLOCK,              -- "Block",
          Deflect           = DEFLECT,            -- "Deflect",
          Dodge             = DODGE,              -- "Dodge",
          Evade             = EVADE,              -- "Evade",
          Immune            = IMMUNE,             -- "Immune",
          Miss              = MISS,               -- "Miss",
          Parry             = PARRY,              -- "Parry",
          Reflect           = REFLECT,            -- "Reflect",
          Resist            = RESIST,             -- "Resist",
          
          -- Energy Types
          MANA              = MANA,               -- "Mana",
          RAGE              = RAGE,               -- "Rage",
          FOCUS             = FOCUS,              -- "Focus",
          ENERGY            = ENERGY,             -- "Energy",
          RUINIC_POWER      = RUINIC_POWER,       -- "Runic Power",
          SOUL_SHARDS       = SOUL_SHARDS,        -- "Soul Shards",
          HOLY_POWER        = HOLY_POWER,         -- "Holy Power",
          
          -- Messages and Alerts
          HEALTH_LOW        = HEALTH_LOW,         -- "Low Heath!",
          ENTERING_COMBAT   = ENTERING_COMBAT,    -- "Entering Combat!"
          LEAVING_COMBAT    = LEAVING_COMBAT,     -- "Leaving Combat!"
          
          -- Misc
          HONOR             = "Honor",
        },
      },
    }
  else
    print("FOUND CONFIG: Saved and Loaded Successfully")
  end

  ActiveProfile = xCTOptions.Profiles[xCTOptions.Profiles._active] 
  L = xCTOptions.Localization[xCTOptions.Localization._active]
  C = xCTOptions.Colors
  
  EnergyTypes = ActiveProfile.EnergyTypes
  
  engine[3] = xCTOptions
  InvokeEvent("OptionsLoaded")
  
  -- Load the Frames
  for FrameName, Frame in pairs(xCTOptions.Frames) do
    if Frame.Enabled then
      local f = CreateFrame("ScrollingMessageFrame", "xCT"..FrameName, UIParent)
      
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
  
  InvokeEvent("FramesLoaded")
end

function xCT.CreateProfile(NewProfileName, CopyFromProfile)
  if CopyFromProfile then
    xCTOptions.Profiles[NewProfileName] = t_copy(xCTOptions.Profiles[CopyFromProfile])
    xCTOptions.Profiles._active = NewProfileName
  else
    if xCTOptions.Profiles[NewProfileName] then
      _active = NewProfileName
    else
      xCTOptions.Profiles[NewProfileName] = t_copy(xCTOptions.Profiles[Default])
      xCTOptions.Profiles._active = NewProfileName
    end
  end
end

function xCT.ChangeProfile(NewProfileName)
  _active = NewProfileName
  ActiveProfile = xCTOptions.Profiles[xCTOptions.Profiles._active]
end

-- xCT String Formats
local X = {
  Healing = function(msg, name)
      if name and COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
        return name.." +"..msg
      else
        return "+"..msg
      end
    end,
  HealingCrit = function(msg, name)
      if name and COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
        return name.." "..ActiveProfile.CritPrefix.."+"..msg..ActiveProfile.CritPostfix
      else
        return ActiveProfile.CritPrefix.."+"..msg..ActiveProfile.CritPostfix
      end
    end,
  Damage = function(msg)
      return "-"..msg
    end,
  DamageCrit = function(msg)
      return ActiveProfile.CritPrefix.."-"..msg..ActiveProfile.CritPostfix
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
  xCTPrint = function (msg)
      return "\124cffFF0000x\124rCT\124cffDDFF55+\124r "..msg
    end,
}

local Player = {
  Name = GetUnitName("player"),
  Class = select(2, UnitClass("player")),
  Power = select(2, UnitPowerType("player")),
  Unit = "player",
  GUID = UnitGUID("player"),
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
    print("My power is: " .. self.Power)
    if self.Power == "MANA" then
      if UnitPower(self.Unit) / UnitPowerMax(self.Unit) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
        if not self.lowMana then
          self.lowMana = true
          return true end
      else
        self.lowMana = nil end
      end return false
    end,
  SetUnit = function(self)
      if UnitHasVehicleUI("player") then
        self.Unit = "vehicle"
        self.Power = select(2, UnitPowerType("vehicle"))
        CombatTextSetActiveUnit("vehicle")
      else
        self.Unit = "player"
        self.Power = select(2, UnitPowerType("player"))
        CombatTextSetActiveUnit("player")
      end
    end,
}

local xCTEvents = {
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
        F.General:AddMessage(spell, unpack(C.SpellCast))
      end,
    MISS = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Miss, unpack(C.MissType)) end
      end,
    DODGE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Dodge, unpack(C.MissType)) end
      end,
    PARRY = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Parry, unpack(C.MissType)) end
      end,
    EVADE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Evade, unpack(C.MissType)) end
      end,
    IMMUNE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Immune, unpack(C.MissType)) end
      end,
    DEFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Deflect, unpack(C.MissType)) end
      end,
    REFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Reflect, unpack(C.MissType)) end
      end,
    SPELL_MISS = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Miss, unpack(C.MissType)) end
      end,
    SPELL_DODGE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Dodge, unpack(C.MissType)) end
      end,
    SPELL_PARRY = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Parry, unpack(C.MissType)) end
      end,
    SPELL_EVADE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Evade, unpack(C.MissType)) end
      end,
    SPELL_IMMUNE = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Immune, unpack(C.MissType)) end
      end,
    SPELL_DEFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Deflect, unpack(C.MissType)) end
      end,
    SPELL_REFLECT = function()
      if COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
        F.Damage:AddMessage(L.Reflect, unpack(C.MissType)) end
      end,
    RESIST = function(amount, resisted)
        F.Damage:AddMessage(X.Resist(amount, L.Resist, resisted), unpack(C.MissType))
      end,
    BLOCK = function(amount, blocked)
        F.Damage:AddMessage(X.Resist(amount, L.Block, blocked), unpack(C.MissType))
      end,
    ABSORB = function(amount, absorbed)
        F.Damage:AddMessage(X.Resist(amount, L.Block, absorbed), unpack(C.MissType))
      end,
    SPELL_RESIST = function(amount, resisted)
        F.Damage:AddMessage(X.Resist(amount, L.Resist, resisted), unpack(C.MissType))
      end,
    SPELL_BLOCK = function(amount, blocked)
        F.Damage:AddMessage(X.Resist(amount, L.Block, blocked), unpack(C.MissType))
      end,
    SPELL_ABSORB = function(amount, absorbed)
        F.Damage:AddMessage(X.Resist(amount, L.Block, absorbed), unpack(C.MissType))
      end,
    ENERGIZE = function(amount, energy)
      if COMBAT_TEXT_SHOW_ENERGIZE == "1" then
        F.Damage:AddMessage(X.Energize(amount, energy), unpack(C.PowerBarColor[energy])) end
      end,
    PERIODIC_ENERGIZE = function(amount, energy)
      if COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE == "1" then
        F.PowerGains:AddMessage(X.Energize(amount, energy), unpack(C.PowerBarColor[energy])) end
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
      print("Changing/leaving to a vehicle")
      Player:SetUnit() end
    end,
  UNIT_EXITING_VEHICLE = function(unit)
    if unit == "player" then
      print("Changing/leaving to a vehicle")
      Player:SetUnit() end
    end,
  ADDON_LOADED = function(addon)
    if addon == ADDON_NAME then
      VariablesLoaded() end
    end,
    
  -- UNIT_COMBO_POINTS
  -- RUNE_POWER_UPDATE
  -- PLAYER_ENTERING_WORLD
  -- CHAT_MSG_LOOT
  -- CHAT_MSG_MONEY
}

-- Register the Events
do
  local frame = CreateFrame"Frame"
  frame:RegisterEvent"ADDON_LOADED"
  frame:RegisterEvent"COMBAT_TEXT_UPDATE"
  frame:RegisterEvent"UNIT_HEALTH"
  frame:RegisterEvent"UNIT_MANA"
  frame:RegisterEvent"PLAYER_REGEN_DISABLED"
  frame:RegisterEvent"PLAYER_REGEN_ENABLED"
  frame:RegisterEvent"UNIT_ENTERED_VEHICLE"
  frame:RegisterEvent"UNIT_EXITING_VEHICLE"
  frame:SetScript("OnEvent",
    function(_, event, ...)
      local handler = xCTEvents[event]
      if handler then
        if type(handler) == "function" then
          return handler( ... )
        end
        local subevent = ...
        if subevent then
          handler[subevent]( select(2, ...) )
        else
          print("there was no event or subevent???")
        end
      else
        print("MISSING event : "..tostring(event))
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

-- Hook Slash Commands
SLASH_XCTPLUS1 = "/xct"
SlashCmdList["XCTPLUS"] = function(input)
    input = s_lower(input)
    
    -- get the args
    local args = { }
    for v in input:gmatch("%w+") do
        args[#args+1] = v
    end

    if args[1] == "unlock" then
        if F.Locked then
            --StartConfigmode()
        else
            print(X.xCTPrint("Frames already unlocked."))
        end
        
    elseif args[1] == "lock" then
        if F.Locked then
            print(X.xCTPrint("Frames already locked."))
        else
            --StaticPopup_Show("XCT_LOCK")
        end
    elseif args[1] == "reset" then
      xCTOptions = nil
      ReloadUI()
      
    elseif args[1] == "test" then
        print(X.xCTPrint("attempted to start Test Mode."))
        --[[if (ct.testmode) then
            EndTestMode()
            pr("test mode disabled.")
        else
            StartTestMode()
            pr("test mode enabled.")
        end]]
    else
        print(X.xCTPrint("Position Commands"))
        print("    Use |cffFF0000/xct|r |cff5555FFunlock|r to move and resize the frames.")
        print("    Use |cffFF0000/xct|r |cff5555FFlock|r to lock the frames.")
        print("    Use |cffFF0000/xct|r |cff5555FFtest|r to toggle Test Mode (|cffFFFF00on|r/|cffFFFF00off|r).")
    end
end
