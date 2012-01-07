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
local xCT = engine[2]

-- This is what gets loaded on the first load, or after you type '/xct reset'
xCT.DEFAULT_PROFILE = {

  -- READ THIS BEFORE EDITING!
  
  -- The default config is only used EVERY time if you "BypassProfileManager"
  
  -- REASONS TO ENABLE:
  -- - Allows you to use this config to change settings
  -- - Much simpler to keep track of settings
  -- - NO FRAME SAVING SUPPORTED YET!!!!!!!!!!!!!!
  
  -- REASONS TO LEAVE DISABLED
  -- - Allows each of you characters to have a different profile
  -- - Allows each of you characters to use the same profile
  -- - FRAME positions are saved
  -- - NOT "AS" BUGGY!!! (hopefully)
  
  ["BypassProfileManager"] = false,  
  
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
  ["ClassKilled"] = true, -- Show the color of the class you killed
  ["ColorBlind"] = false,
  ["minmoney"] = 0,
  ["ShowHeadNumbers"] = false,
  
  ["SpellMerge"]  = true,
  ["MergeTime"] = 3,        -- Seconds for the length of time spells are merged
  ["MergeImmunes"] = true,
  ["NEW KEY Test"] = "This is a test",
  ["NEW KEY Test 2"] = "This is a test",
  
  
  EnergyTypes = { -- Display Energy Types
    ["MANA"]          = true,
    ["RAGE"]          = true,
    ["FOCUS"]         = true,
    ["ENERGY"]        = true,
    ["RUNIC_POWER"]   = true,
    ["SOUL_SHARDS"]   = true,
    ["HOLY_POWER"]    = true,
  },
  
  Frames = {
    -- Frame Names canNOT have a space or special character in them
    -- <Critical>
    ["Critical"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Critical>
    -- <Damage>
    ["Damage"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Damage>
    -- <General>
    ["General"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </General>
    -- <Healing>
    ["Healing"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Healing>
    -- <Loot>
    ["Loot"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Loot>
    -- <Outgoing>
    ["Outgoing"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Outgoing>
    -- <PowerGains>
    ["PowerGains"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </PowerGains>
    -- <Procs>
    ["Procs"] = {
      Enabled = true,
      Secondary = nil,
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
    }, -- </Procs>
  },
}

xCT.Colors = {      -- { Red, Green, Blue }
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
  
  -- Loot
  Money           = { 1.00, 1.00, 0.00 },
  
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
  MANA_LOW          = MANA_LOW,
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
  
  -- Loot
  GOLD_MATCH = GOLD_AMOUNT:gsub("%%d", "(%%d+)"),       -- "(%d)+ Gold"
  SILVER_MATCH = SILVER_AMOUNT:gsub("%%d", "(%%d+)"),   -- "(%d)+ Silver"
  COPPER_MATCH = COPPER_AMOUNT:gsub("%%d", "(%%d+)"),   -- "(%d)+ Copper"
  
  GOLD_LETTER = GOLD_AMOUNT:match("%%d%s+(%a)%a+"),     -- "G"
  SILVER_LETTER = SILVER_AMOUNT:match("%%d%s+(%a)%a+"), -- "S"
  COPPER_LETTER = COPPER_AMOUNT:match("%%d%s+(%a)%a+"), -- "C"
  
  MONEY             = MONEY,              -- "Money"
}

