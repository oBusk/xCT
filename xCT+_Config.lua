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

-- This is what gets loaded on the first load, or after you type '/xct reset'
local DEFAULT_PROFILE = {
  ["ShowHeadNumbers"] = false,
  ["CritPrefix"] = "*",
  ["CritPostfix"] = "*",
  ["HealThreshold"] = 0,
  ["StopVESpam"] = true,
  ["ShowOutgoingIcons"] = true,
  ["UseTextIcons"] = false,
  ["IconSize"] = 22,
  ["PetDamage"] = true,
  ["DamageColors"] = true,
  ["FontSize"] = 16,
  ["FontName"] = "Interface\\Addons\\xCT+\\HOOGE.TTF",
  ["FontStyle"] = "OUTLINE",
  
  EnergyTypes = { -- Display Energy Types
    ["MANA"]          = true,
    ["RAGE"]          = true,
    ["FOCUS"]         = true,
    ["ENERGY"]        = true,
    ["RUINIC_POWER"]  = true,
    ["SOUL_SHARDS"]   = true,
    ["HOLY_POWER"]    = true,
  },
  Frames = {
    -- Frame Names canNOT have a space or special character in them
    ["Critical"] = {
      Enabled = true,
      Label = TEXT_MODE_A_STRING_RESULT_CRITICAL:match("%a+"),
      LabelColor = { 1.00, 0.50, 0.00, 0.90 },
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
      LabelColor = { 1.00, 0.10, 0.10, 0.90 },
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
      LabelColor = { 0.10, 0.10, 1.00, 0.90 },
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
      LabelColor = { 0.10, 1.00, 0.10, 0.90 },
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
      LabelColor = { 1.00, 1.00, 1.00, 0.90 },
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
      LabelColor = { 1.00, 1.00, 0.00, 0.90 },
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
      Label = MANA.." ("..select(2, UnitPowerType("player"))..")",
      LabelColor = { 0.80, 0.10, 1.00, 0.90 },
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
      Label = DISPLAY_SPELL_ALERTS,
      LabelColor = { 1.00, 0.60, 0.30, 0.90 },
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
}

-- Lua code below.  Do NOT edit below this point!

-- If you didn't listen, then that means you know what you are doing, please continue. :)
local ADDON_NAME, engine = ...

engine[1] = {} -- Events (Fake)
engine[2] = {} -- Functions
engine[3] = {} -- Options

local xCT = engine[2]

xCT.Colors = {
  -- Magic Colors
  ["1"]           = { 1.00, 1.00, 0.00 },   -- Physical Damage
  ["2"]           = { 1.00, 0.90, 0.50 },   -- Holy Damage
  ["4"]           = { 1.00, 0.50, 0.00 },   -- Fire Damage
  ["8"]           = { 0.30, 1.00, 0.30 },   -- Nature Damage
  ["16"]          = { 0.50, 1.00, 1.00 },   -- Frost Damage
  ["32"]          = { 0.50, 0.50, 1.00 },   -- Shadow Damage
  ["64"]          = { 1.00, 0.50, 1.00 },   -- Arcane Damage
  
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
  DispellBuff     = { 0.00, 1.00, 0.50 },
  DispellDebuff   = { 0.00, 1.00, 0.50 },
  Interrupt       = { 1.00, 0.50, 0.00 },
  
  ComboPoint      = { 1.00, 0.82, 0.00 },
  MaxComboPoints  = { 0.00, 0.82, 1.00 },
  
  Runes = {
    { 0.75, 0.00, 0.00 }, -- [1] Blood Rune
    { 0.75, 1.00, 0.00 }, -- [2] Unholy Rune
    { 0.00, 1.00, 1.00 }, -- [3] Frost Rune
    { 1.00, 1.00, 1.00 }, -- [4] Death Rune
  },
  
  -- Misc
  Honor           = { 0.10, 0.10, 1.00 },
  Reputation      = { 0.10, 0.10, 1.00 },
  LowHealth       = { 1.00, 0.10, 0.10 },
  LowMana         = { 1.00, 0.10, 0.10 },
  EnteringCombat  = { 0.10, 1.00, 0.10 },
  LeavingCombat   = { 0.10, 1.00, 0.10 },
  UnitKilled      = { 0.20, 1.00, 0.20 },
  PowerBarColor   = _G["PowerBarColor"]
}
xCT.Localization = {
  -- Miss Types
  ABSORB            = ABSORB,             -- "Absorb", 
  BLOCK             = BLOCK,              -- "Block",
  DEFLECT           = DEFLECT,            -- "Deflect",
  DODGE             = DODGE,              -- "Dodge",
  EVADE             = EVADE,              -- "Evade",
  IMMUNE            = IMMUNE,             -- "Immune",
  INTERRUPT         = INTERRUPT,
  MISS              = MISS,               -- "Miss",
  PARRY             = PARRY,              -- "Parry",
  REFLECT           = REFLECT,            -- "Reflect",
  RESIST            = RESIST,             -- "Resist",

  -- Energy Types
  MANA              = MANA,               -- "Mana",
  RAGE              = RAGE,               -- "Rage",
  FOCUS             = FOCUS,              -- "Focus",
  ENERGY            = ENERGY,             -- "Energy",
  RUINIC_POWER      = RUINIC_POWER,       -- "Runic Power",
  SOUL_SHARDS       = SOUL_SHARDS,        -- "Soul Shards",
  HOLY_POWER        = HOLY_POWER,         -- "Holy Power",
  RUNES = {
    [1] = COMBAT_TEXT_RUNE_BLOOD,
    [2] = COMBAT_TEXT_RUNE_UNHOLY,
    [3] = COMBAT_TEXT_RUNE_FROST,
    [4] = COMBAT_TEXT_RUNE_DEATH,
  },

  -- Messages and Alerts
  HEALTH_LOW        = HEALTH_LOW,         -- "Low Heath!",
  ENTERING_COMBAT   = ENTERING_COMBAT,    -- "Entering Combat!"
  LEAVING_COMBAT    = LEAVING_COMBAT,     -- "Leaving Combat!"

  -- Misc
  HONOR             = "Honor",
  Swing             = ACTION_SWING,       -- GetSpellInfo(5547), -- "Swing"
  Pet               = "Pet",
  
  -- Actions
  ACTION_DISPEL     = ACTION_SPELL_DISPEL,    -- "dispelled"
  ACTION_INTERRUPT  = ACTION_SPELL_INTERRUPT, -- "interrupted"
  ACTION_KILLED     = ACTION_PARTY_KILL,      -- "killed"
}

-- Events Engine
local Events = { -- Events (Real)
  ["ChangedProfiles"] = { },
  ["OptionsLoaded"] = { },
  ["FramesLoaded"] = { },
}

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

function xCT.InvokeEvent(event, ...)
  for _, handle in pairs(Events[event]) do
    if type(handle) == "function" then
      handle(event, ...)
    end
  end
end

function xCT.Print(...)
  print("\124cffFF0000x\124rCT\124cffDDFF55+\124r ", ...)
end

function xCT.Debug(...)
  if XCT_DEBUG then
    xCT.Print(...)
  end
end

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

function xCT.CreateProfile(NewProfileName, CopyFromProfile)
  if CopyFromProfile then
    -- Create a new profile as a copy of another
    xCTOptions.Profiles[NewProfileName] = t_copy(xCTOptions.Profiles[CopyFromProfile], DEFAULT_PROFILE)
    xCTOptions._activeProfile = NewProfileName
  else
    -- new profile already exists
    if xCTOptions.Profiles[NewProfileName] then
      xCTOptions._activeProfile = NewProfileName
    else
      -- create a new profile using the defaults as a template
      xCTOptions.Profiles[NewProfileName] = t_copy(DEFAULT_PROFILE)
      xCTOptions._activeProfile = NewProfileName
    end
  end
  xCT.ChangeProfile()
end

function xCT.ChangeProfile(NewProfileName)
  if NewProfileName then
    xCTOptions._activeProfile = NewProfileName end
  local ActiveProfile = xCTOptions.Profiles[xCTOptions._activeProfile]
  
  -- Backward Compatibility
  if not getmetatable(ActiveProfile) and xCTOptions._activeProfile ~= "Default" then
    local activeMT = { __index = xCTOptions.Profiles["Default"], }
    setmetatable(ActiveProfile, activeMT)
  end
  
  xCT.ActiveProfile = ActiveProfile
  xCT.InvokeEvent("ChangedProfiles")
end


-- Global Accessor to the engine
xCTShared = engine

local frame = CreateFrame"Frame"
frame:RegisterEvent"ADDON_LOADED"
frame:SetScript("OnEvent", function(self, event, addon)
  if addon == ADDON_NAME then
    if not xCTOptions then   -- Default Options
      xCTOptions = { Profiles = { }, }
      xCT.CreateProfile(xCT.Player.Name)
    else 
      xCT.ChangeProfile()
    end
    engine[3] = xCTOptions
    xCT.InvokeEvent("OptionsLoaded")
    xCT.Print("is now your default Combat Text handler.")
  end
end)
