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

-- Global Accessor to the engine
xCTShared = engine

-- Functions
local xCT = engine[2]

local frame = CreateFrame"Frame"
frame:RegisterEvent"ADDON_LOADED"
frame:SetScript("OnEvent", function(addon)
  if addon == ADDON_NAME then
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
            ["StopVESpam"] = true,
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
    
    xCT.InvokeEvent("OptionsLoaded")
  end
end)
