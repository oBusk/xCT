--[[   ____    ______      
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___ 
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/
 
 [=====================================]
 [  Author: Dandruff @ Whisperwind-US  ]
 [  xCT+ Version 3.x.x                 ]
 [  ©2012. All Rights Reserved.        ]
 [====================================]]

 -- This file is a static default profile.  After you first profile is created, editing this file will nothing.
local ADDON_NAME, addon = ...


-- =====================================================
-- CreateMergeSpellEntry(
--    enabled,       [bool] - whether or not this spell is enabled
--    interval,       [int] - How often to update merged data (in seconds)
--    prep,           [int] - The minimum time to wait to update merged data
--  )
--    Create an merge settings entry for a spell.
-- =====================================================
local function CreateMergeSpellEntry(class, enabled, interval,  prep)
  return { class = class, enabled = enabled, interval = interval or 3, prep or 0.5 }
end

local function CreateComboSpellEntry(default, spellID, watchUnit)
  return { id = spellID, unit = watchUnit or "player", enabled = default}
end

addon.defaults = {
  profile = {
    showStartupText = true,

    frames = {
      general = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        
      -- position
        ["X"] = 0,
        ["Y"] = 192,
        ["Width"] = 512,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "CENTER",

      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
      },
      
      outgoing = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        
      -- position
        ["X"] = 448,
        ["Y"] = 0,
        ["Width"] = 128,
        ["Height"] = 320,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 16,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        
      -- special tweaks
        ["enableOutDmg"] = true,
        ["enableOutHeal"] = true,
        ["enablePetDmg"] = true,
        ["enableAutoAttack"] = true,
        ["enableDotDmg"] = true,
        ["enableHots"] = true,
        ["enableImmunes"] = true,
        ["enableMisses"] = true,
      },
      
      critical = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
      
      -- position
        ["X"] = 256,
        ["Y"] = 0,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 24,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- critical appearance
        ["critPrefix"] = "|cffFF0000*|r",
        ["critPostfix"] = "|cffFF0000*|r",
        
      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 16,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        
      -- special tweaks
        ["showSwing"] = true,
        ["prefixSwing"] = true,
        ["redirectSwing"] = false,
      },
      
      damage = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "top",
        
      -- position
        ["X"] = -448,
        ["Y"] = -88, -- -80,
        ["Width"] = 128,
        ["Height"] = 144,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
      },

      healing = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
      
      -- positioon
        ["X"] = -448,
        ["Y"] = 88,
        ["Width"] = 128,
        ["Height"] = 144,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "RIGHT",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
      },
      
      class = {
        ["enabledFrame"] = true,
        
      -- position
        ["X"] = 0,
        ["Y"] = 64,
        ["Width"] = 64,
        ["Height"] = 64,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 32,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
      },
      
      power = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        
      -- position
        ["X"] = 0,
        ["Y"] = -64,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
      },
      
      procs = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "bottom",
        
      -- position
        ["X"] = -256,
        ["Y"] = 0,
        ["Width"] = 256,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
      },
      
      loot = {
        ["enabledFrame"] = true,
        ["secondaryFrame"] = 0,
        ["insertText"] = "top",
        
      -- position 
        ["X"] = 0,
        ["Y"] = -224,
        ["Width"] = 512,
        ["Height"] = 128,
        
      -- fonts
        ["font"] = "HOOGE (xCT)",
        ["fontSize"] = 16,
        ["fontOutline"] = "4MONOCHROMEOUTLINE",
        ["fontJustify"] = "CENTER",
        
      -- font colors
        ["customColor"] = false,
        ["fontColor"] = nil,
        
      -- icons
        ["iconsEnabled"] = true,
        ["iconsSize"] = 16,
        
      -- scrollable
        ["enableScrollable"] = false,
        ["scrollableLines"] = 10,
        
      -- special tweaks
        ["showItems"] = true,
        ["showMoney"] = true,
        ["showItemTotal"] = true,
        ["showCrafted"] = true,
        ["showQuest"] = true,
        ["colorBlindMoney"] = false,
        ["filterItemQuality"] = 3,
      },
    },

    spells = {
      enableMerger = true,        -- enable/disable spam merger
      enableMergerDebug = false,  -- Shows spell IDs for debugging merged spells
      
      combo = {
        ["DEATHKNIGHT"] = {
          [1] = {                                         -- Blood
            CreateComboSpellEntry(true, 49222),           --   Bone Shield
          },
          [2] = { },    -- Frost
          [3] = {                                         -- Unholy
            CreateComboSpellEntry(true, 91342, "pet"),    --   Shadow Infusion
          },
        },
        
        ["DRUID"] = {
          [1] = {                                         -- Balance
            CreateComboSpellEntry(true, 81192),           --   Lunar Shower
          },
          [2] = { [COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] = true, },    -- Feral
          [3] = { },    -- Guardian
          [4] = { },    -- Restoration
        },
      
        ["HUNTER"] = {
          [1] = {                                         -- Beast Mastery
            CreateComboSpellEntry(true, 19615, "pet"),    --   Frenzy Effect
          },
          [2] = {                                         -- Marksman
            CreateComboSpellEntry(true, 82925),           --   Ready, Set, Aim...
          },
          [3] = {                                         -- Survival
            CreateComboSpellEntry(true, 56453),           --   Lock 'n Load
          },
        },
        
        ["MAGE"] = {
          [1] = { },    -- Arcane
          [2] = { },    -- Fire
          [3] = { },    -- Frost
        },
        
        ["MONK"] = {
          [LIGHT_FORCE] = true,
          
          -- DO NOT USE - MONKS GET CHI
          [1] = { },    -- Brewmaster
          [2] = { },    -- Mistweaver
          [3] = { },    -- Windwalker
        },
        
        ["PALADIN"] = {
          [HOLY_POWER] = true,
        
          -- DO NOT USE - PALADINS GET HOLY POWER
          [1] = { },    -- Holy
          [2] = { },    -- Protection
          [3] = { },    -- Retribution
        },
        
        ["PRIEST"] = {
          [1] = {                                         -- Discipline
            CreateComboSpellEntry(true, 81661),           --   Evangelism
          },    
          [2] = {                                         -- Holy
            CreateComboSpellEntry(true, 63735),           --   Serendipity
            CreateComboSpellEntry(false, 114255),         --   Surge of Light
          },    
          -- DO NOT USE - SHADOW PRIEST GET SHADOW ORBS
          [3] = {                                         -- Shadow
            [SHADOW_ORBS] = true,
          },    
        },
        
        ["ROGUE"] = {
          [COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT] = true,
        
          -- DO NOT USE - ROGUES GET COMBO POINTS
          [1] = { },    -- Assassination
          [2] = { },    -- Combat
          [3] = { },    -- Subtlety
        },

        ["SHAMAN"] = {
          [1] = { },    -- Elemental
          [2] = {                                         -- Enhancement
            CreateComboSpellEntry(true, 53817),           --   Maelstrom Weapon
          },
          [3] = {                                         -- Restoration
            CreateComboSpellEntry(true, 53390),           --   Tidal Waves
          },
        },

        ["WARLOCK"] = {
          -- DO NOT USE - AFFLICTION WARLOCKS GET SOUL SHARDS
          [1]  = { [SOUL_SHARDS] = true },
          
          -- DO NOT USE - DEMONOLOGY WARLOCKS GET DEMONIC FURY
          [2]  = { [DEMONIC_FURY] = true },
          
          -- DO NOT USE - DESTRUCTION WARLOCKS GET BURNING EMBERS
          [3] = { [BURNING_EMBERS] = true },
        },
        
        ["WARRIOR"] = {
          [1] = { },    -- Arms
          [2] = { },    -- Fury
          [3] = { },    -- Protection
        },
        
      },
      
      merge = {
      -- death knight
        [55095]  = CreateMergeSpellEntry("DEATHKNIGHT", true),      -- Frost Fever
        [55078]  = CreateMergeSpellEntry("DEATHKNIGHT", true),      -- Blood Plague
        [48721]  = CreateMergeSpellEntry("DEATHKNIGHT", true, .5),  -- Blood Boil                                 (INSTANT)
        [49184]  = CreateMergeSpellEntry("DEATHKNIGHT", true, .5),  -- Howling Blast                              (INSTANT)
        [52212]  = CreateMergeSpellEntry("DEATHKNIGHT", true),      -- Death and Decay
        
      -- druid (damage)
        [8921]   = CreateMergeSpellEntry("DRUID", true),            -- Moonfire
        [93402]  = CreateMergeSpellEntry("DRUID", true),            -- Sunfire
        [5570]   = CreateMergeSpellEntry("DRUID", true),            -- Insect Swarm
        [42231]  = CreateMergeSpellEntry("DRUID", true),            -- Hurricane
        [50288]  = CreateMergeSpellEntry("DRUID", true),            -- Starfall
        [78777]  = CreateMergeSpellEntry("DRUID", true),            -- Wild Mushroom: Detonate	
        [61391]  = CreateMergeSpellEntry("DRUID", true, .5),        -- Typhoon                                    (INSTANT)
        [1822]   = CreateMergeSpellEntry("DRUID", true),            -- Rake
        [62078]  = CreateMergeSpellEntry("DRUID", true, .5),        -- Swipe (Cat)                                (INSTANT)
        [779]    = CreateMergeSpellEntry("DRUID", true, .5),        -- Swipe (Bear)                               (INSTANT)
        [33745]  = CreateMergeSpellEntry("DRUID", true),            -- Lacerate
        [1079]   = CreateMergeSpellEntry("DRUID", true),            -- Rip
      
      -- druid (healing)
        [774]    = CreateMergeSpellEntry("DRUID", true),            -- Rejuvenation
        [48438]  = CreateMergeSpellEntry("DRUID", true),            -- Wild Growth
        [8936]   = CreateMergeSpellEntry("DRUID", true),            -- Regrowth
        [33763]  = CreateMergeSpellEntry("DRUID", true),            -- Lifebloom
        [44203]  = CreateMergeSpellEntry("DRUID", true),            -- Tranquility
        [81269]  = CreateMergeSpellEntry("DRUID", true),            -- Swiftmend (Efflorescence)
      
      -- hunter
        [2643]   = CreateMergeSpellEntry("HUNTER", true, .5),       -- Multi-Shot                                 (INSTANT)
        [83077]  = CreateMergeSpellEntry("HUNTER", true, .5),       -- Serpent Sting (Instant Serpent Spread)     (INSTANT)
        [118253] = CreateMergeSpellEntry("HUNTER", true),           -- Serpent Sting (Tick)
        [13812]  = CreateMergeSpellEntry("HUNTER", true),           -- Explosive Trap
        [53301]  = CreateMergeSpellEntry("HUNTER", true),           -- Explosive Shot (3 ticks merged as one)
        [63468]  = CreateMergeSpellEntry("HUNTER", true),           -- Piercing Shots
      
      -- mage
        [44461]  = CreateMergeSpellEntry("MAGE", true, .5),         -- Living Bomb                                (INSTANT)
        [44457]  = CreateMergeSpellEntry("MAGE", true, 4),          -- Living Bomb (DOT)                          (over 8 seconds)
        [2120]   = CreateMergeSpellEntry("MAGE", true, 4),          -- Flamestrike                                (Over 4 seconds)
        [12654]  = CreateMergeSpellEntry("MAGE", true),             -- Ignite
        [11366]  = CreateMergeSpellEntry("MAGE", true),             -- Pyroblast
        [31661]  = CreateMergeSpellEntry("MAGE", true, .5),         -- Dragon's Breath                            (INSTANT)
        [42208]  = CreateMergeSpellEntry("MAGE", true),             -- Blizzard
        [122]    = CreateMergeSpellEntry("MAGE", true, .5),         -- Frost Nova                                 (INSTANT)
        [1449]   = CreateMergeSpellEntry("MAGE", true, .5),         -- Arcane Explosion                           (INSTANT)
        [83853]  = CreateMergeSpellEntry("MAGE", true),             -- Combustion
        [11113]  = CreateMergeSpellEntry("MAGE", true),             -- Blast Wave
        [83619]  = CreateMergeSpellEntry("MAGE", true, .5),         -- Flame Orb                                  (INSTANT)
        [120]    = CreateMergeSpellEntry("MAGE", true),             -- Cone of Cold
        
      -- paladin (damage)
        [81297]  = CreateMergeSpellEntry("PALADIN", true),          -- Consecration
        [53385]  = CreateMergeSpellEntry("PALADIN", true),          -- Divine Storm
        [31803]  = CreateMergeSpellEntry("PALADIN", true),          -- Censure
        [42463]  = CreateMergeSpellEntry("PALADIN", true),          -- Seal of Truth
        [101423] = CreateMergeSpellEntry("PALADIN", true),         -- Seal of Righteousness
        [31935]  = CreateMergeSpellEntry("PALADIN", true),          -- Avenger's Shield

      -- paladin (healing)
        [94289]  = CreateMergeSpellEntry("PALADIN", true),          -- Protector of the Innocent
        [53652]  = CreateMergeSpellEntry("PALADIN", true),          -- Beacon of Light
        [85222]  = CreateMergeSpellEntry("PALADIN", true),          -- Light of Dawn
        [82327]  = CreateMergeSpellEntry("PALADIN", true),          -- Holy Radiance
        [20167]  = CreateMergeSpellEntry("PALADIN", true),          -- Seal of Insight (Heal)
        
      -- priest (damage)
        [47666]  = CreateMergeSpellEntry("PRIEST", true),           -- Penance (Damage Effect)
        [132157] = CreateMergeSpellEntry("PRIEST", true, .5),       -- Holy Nova (Damage Effect)                  (INSTANT)
        [589]    = CreateMergeSpellEntry("PRIEST", true),           -- Shadow Word: Pain
        [34914]  = CreateMergeSpellEntry("PRIEST", true),           -- Vampiric Touch 
        [2944]   = CreateMergeSpellEntry("PRIEST", true),           -- Devouring Plague
        [15407]  = CreateMergeSpellEntry("PRIEST", true),           -- Mind Flay
        [49821]  = CreateMergeSpellEntry("PRIEST", true),           -- Mind Seer (From Derap: first one is the cast)
        [124469] = CreateMergeSpellEntry("PRIEST", true),           -- Mind Seer (the second one is the debuff that is applied to your target which lets you clip your mind sears like mind flay)
        [87532]  = CreateMergeSpellEntry("PRIEST", true),           -- Shadowy Apparition
        [14914]  = CreateMergeSpellEntry("PRIEST", true),           -- Holy Fire
      
      -- priest (healing)
        [47750]  = CreateMergeSpellEntry("PRIEST", true),           -- Penance (Heal)
        [139]    = CreateMergeSpellEntry("PRIEST", true),           -- Renew
        [596]    = CreateMergeSpellEntry("PRIEST", true, .5),       -- Prayer of Healing                          (INSTANT)
        [64844]  = CreateMergeSpellEntry("PRIEST", true),           -- Divine Hymn
        [32546]  = CreateMergeSpellEntry("PRIEST", true),           -- Binding Heal
        [77489]  = CreateMergeSpellEntry("PRIEST", true),           -- Echo of Light
        [34861]  = CreateMergeSpellEntry("PRIEST", true, .5),       -- Circle of Healing                          (INSTANT)
        [23455]  = CreateMergeSpellEntry("PRIEST", true, .5),       -- Holy Nova (Healing)                        (INSTANT)
        [33110]  = CreateMergeSpellEntry("PRIEST", true),           -- Prayer of Mending
        [63544]  = CreateMergeSpellEntry("PRIEST", true),           -- Rapid Renewal
        [88686]  = CreateMergeSpellEntry("PRIEST", true, 6),        -- Holy Word: Sanctuary                       (every 2 sec for 30 sec)
      
      -- rogue
        [51723]  = CreateMergeSpellEntry("ROGUE", true, .5),        -- Fan of Knives                              (INSTANT)
        [113780] = CreateMergeSpellEntry("ROGUE", true, .5),        -- Deadly Poison                              (INSTANT)
        [2818]   = CreateMergeSpellEntry("ROGUE", true),            -- Deadly Poison (DOT)
        [8680]   = CreateMergeSpellEntry("ROGUE", true),            -- Wound Poison
        [112974] = CreateMergeSpellEntry("ROGUE", true),            -- Leeching Poison
        [121411] = CreateMergeSpellEntry("ROGUE", true, .5),        -- Crimson Tempest                            (INSTANT)
        [122233] = CreateMergeSpellEntry("ROGUE", true),            -- Crimson Tempest (DOT)
        
      -- shaman (damage)
        [421]    = CreateMergeSpellEntry("SHAMAN", true, .5),       -- Chain Lightning                            (INSTANT)
        [8349]   = CreateMergeSpellEntry("SHAMAN", true),           -- Fire Nova
        [77478]  = CreateMergeSpellEntry("SHAMAN", true),           -- Earthquake
        [51490]  = CreateMergeSpellEntry("SHAMAN", true),           -- Thunderstorm
        [8187]   = CreateMergeSpellEntry("SHAMAN", true),           -- Magma Totem
        [8050]   = CreateMergeSpellEntry("SHAMAN", true),           -- Flame Shock
        [25504]  = CreateMergeSpellEntry("SHAMAN", true, .5),       -- Windfury Attack                            (INSTANT)
      
      -- shaman (healing)
        [73921]  = CreateMergeSpellEntry("SHAMAN", true),           -- Healing Rain
        [1064]   = CreateMergeSpellEntry("SHAMAN", true, .5),       -- Chain Heal                                 (INSTANT)
        [52042]  = CreateMergeSpellEntry("SHAMAN", true),           -- Healing Stream Totem
        [51945]  = CreateMergeSpellEntry("SHAMAN", true),           -- Earthliving
        [61295]  = CreateMergeSpellEntry("SHAMAN", true),           -- Riptide

      -- warlock
        [172]    = CreateMergeSpellEntry("WARLOCK", true),          -- Corruption
        [87389]  = CreateMergeSpellEntry("WARLOCK", true),          -- Corruption (Soulburn: Seed of Corruption)
        [27243]  = CreateMergeSpellEntry("WARLOCK", true),          -- Seed of Corruption (DoT)
        [27285]  = CreateMergeSpellEntry("WARLOCK", true, .5),      -- Seed of Corruption (Explosion)             (INSTANT)
        [87385]  = CreateMergeSpellEntry("WARLOCK", true, .5),      -- Seed of Corruption (Explosion Soulburned)  (INSTANT)
        [30108]  = CreateMergeSpellEntry("WARLOCK", true),          -- Unstable Affliction
        [348]    = CreateMergeSpellEntry("WARLOCK", true),          -- Immolate
        [50590]  = CreateMergeSpellEntry("WARLOCK", true),          -- Immolation (Aura)
        [980]    = CreateMergeSpellEntry("WARLOCK", true),          -- Agony
        [42223]  = CreateMergeSpellEntry("WARLOCK", true),          -- Rain of Fire
        [5857]   = CreateMergeSpellEntry("WARLOCK", true),          -- Hellfire
        [47897]  = CreateMergeSpellEntry("WARLOCK", true),          -- Shadowflame
        [47960]  = CreateMergeSpellEntry("WARLOCK", true),          -- Shadowflame (DOT)
        [30213]  = CreateMergeSpellEntry("WARLOCK", true, .5),      -- Legion Strike (Felguard)                   (INSTANT)
        [89753]  = CreateMergeSpellEntry("WARLOCK", true),          -- Felstorm (Felguard)
        [20153]  = CreateMergeSpellEntry("WARLOCK", true),          -- Immolation (Infrenal)
      
      -- warrior
        [845]    = CreateMergeSpellEntry("WARRIOR", true, .5),      -- Cleave                                     (INSTANT)
        [46968]  = CreateMergeSpellEntry("WARRIOR", true, .5),      -- Shockwave                                  (INSTANT)
        [6343]   = CreateMergeSpellEntry("WARRIOR", true, .5),      -- Thunder Clap                               (INSTANT)
        [1680]   = CreateMergeSpellEntry("WARRIOR", true),          -- Whirlwind
        [50622]  = CreateMergeSpellEntry("WARRIOR", true),          -- Bladestorm
        [52174]  = CreateMergeSpellEntry("WARRIOR", true, .5),      -- Heroic Leap                                (INSTANT)
        
      -- spammy items (old) ITEM CLASS CURRENTLY DOES NOTHING
        [109858] = CreateMergeSpellEntry("ITEM", true, 2.5),        -- Speaking of Rage - proc'd by: Vishanka, Jaws of the Earth (Heroic)
      },
    
      items = { },
    
    },
  },
}
