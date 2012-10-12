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
local function CreateMergeSpellEntry(enabled, interval,  prep)
  return { enabled = enabled, interval = interval or 3, prep or 0.5 }
end

addon.DefaultProfile = {
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
    enableMerger = true,    -- enable/disable spam merger
  
    merge = {
    -- death knight
      [55095]  = CreateMergeSpellEntry(true),      -- Frost Fever
      [55078]  = CreateMergeSpellEntry(true),      -- Blood Plague
      [48721]  = CreateMergeSpellEntry(true, .5),  -- Blood Boil                                 (INSTANT)
      [49184]  = CreateMergeSpellEntry(true, .5),  -- Howling Blast                              (INSTANT)
      [52212]  = CreateMergeSpellEntry(true),      -- Death and Decay
      
    -- druid (damage)
      [8921]   = CreateMergeSpellEntry(true),      -- Moonfire
      [93402]  = CreateMergeSpellEntry(true),      -- Sunfire
      [5570]   = CreateMergeSpellEntry(true),      -- Insect Swarm
      [42231]  = CreateMergeSpellEntry(true),      -- Hurricane
      [50288]  = CreateMergeSpellEntry(true),      -- Starfall
      [78777]  = CreateMergeSpellEntry(true),      -- Wild Mushroom: Detonate	
      [61391]  = CreateMergeSpellEntry(true, .5),  -- Typhoon                                    (INSTANT)
      [1822]   = CreateMergeSpellEntry(true),      -- Rake
      [62078]  = CreateMergeSpellEntry(true, .5),  -- Swipe (Cat)                                (INSTANT)
      [779]    = CreateMergeSpellEntry(true, .5),  -- Swipe (Bear)                               (INSTANT)
      [33745]  = CreateMergeSpellEntry(true),      -- Lacerate
      [1079]   = CreateMergeSpellEntry(true),      -- Rip
    
    -- druid (healing)
      [774]    = CreateMergeSpellEntry(true),      -- Rejuvenation
      [48438]  = CreateMergeSpellEntry(true),      -- Wild Growth
      [8936]   = CreateMergeSpellEntry(true),      -- Regrowth
      [33763]  = CreateMergeSpellEntry(true),      -- Lifebloom
      [44203]  = CreateMergeSpellEntry(true),      -- Tranquility
      [81269]  = CreateMergeSpellEntry(true),      -- Swiftmend (Efflorescence)
    
    -- hunter
      [2643]   = CreateMergeSpellEntry(true, .5),  -- Multi-Shot                                 (INSTANT)
      [83077]  = CreateMergeSpellEntry(true, .5),  -- Serpent Sting (Instant Serpent Spread)     (INSTANT)
      [118253] = CreateMergeSpellEntry(true),      -- Serpent Sting (Tick)
      [13812]  = CreateMergeSpellEntry(true),      -- Explosive Trap
      [53301]  = CreateMergeSpellEntry(true),      -- Explosive Shot (3 ticks merged as one)
      [63468]  = CreateMergeSpellEntry(true),      -- Piercing Shots
    
    -- mage
      [44461]  = CreateMergeSpellEntry(true, .5),  -- Living Bomb                                (INSTANT)
      [44457]  = CreateMergeSpellEntry(true, 4),   -- Living Bomb (DOT)                          (over 8 seconds)
      [2120]   = CreateMergeSpellEntry(true, 4),   -- Flamestrike                                (Over 4 seconds)
      [12654]  = CreateMergeSpellEntry(true),      -- Ignite
      [11366]  = CreateMergeSpellEntry(true),      -- Pyroblast
      [31661]  = CreateMergeSpellEntry(true, .5),  -- Dragon's Breath                            (INSTANT)
      [42208]  = CreateMergeSpellEntry(true),      -- Blizzard
      [122]    = CreateMergeSpellEntry(true, .5),  -- Frost Nova                                 (INSTANT)
      [1449]   = CreateMergeSpellEntry(true, .5),  -- Arcane Explosion                           (INSTANT)
      [83853]  = CreateMergeSpellEntry(true),      -- Combustion
      [11113]  = CreateMergeSpellEntry(true),      -- Blast Wave
      [83619]  = CreateMergeSpellEntry(true, .5),  -- Flame Orb                                  (INSTANT)
      [120]    = CreateMergeSpellEntry(true),      -- Cone of Cold
      
    -- paladin (damage)
      [81297]  = CreateMergeSpellEntry(true),      -- Consecration
      [53385]  = CreateMergeSpellEntry(true),      -- Divine Storm
      [31803]  = CreateMergeSpellEntry(true),      -- Censure
      [42463]  = CreateMergeSpellEntry(true),      -- Seal of Truth
      [101423] = CreateMergeSpellEntry(true),      -- Seal of Righteousness
      [31935]  = CreateMergeSpellEntry(true),      -- Avenger's Shield

    -- paladin (healing)
      [94289]  = CreateMergeSpellEntry(true),      -- Protector of the Innocent
      [53652]  = CreateMergeSpellEntry(true),      -- Beacon of Light
      [85222]  = CreateMergeSpellEntry(true),      -- Light of Dawn
      [82327]  = CreateMergeSpellEntry(true),      -- Holy Radiance
      [20167]  = CreateMergeSpellEntry(true),      -- Seal of Insight (Heal)
      
    -- priest (damage)
      [47666]  = CreateMergeSpellEntry(true),      -- Penance (Damage Effect)
      [15237]  = CreateMergeSpellEntry(true, .5),  -- Holy Nova (Damage Effect)                  (INSTANT)
      [589]    = CreateMergeSpellEntry(true),      -- Shadow Word: Pain
      [34914]  = CreateMergeSpellEntry(true),      -- Vampiric Touch
      [2944]   = CreateMergeSpellEntry(true),      -- Devouring Plague
      [15407]  = CreateMergeSpellEntry(true),      -- Mind Flay
      [49821]  = CreateMergeSpellEntry(true),      -- Mind Seer (From Derap: first one is the cast)
      [124469] = CreateMergeSpellEntry(true),      -- Mind Seer (the second one is the debuff that is applied to your target which lets you clip your mind sears like mind flay)
      [87532]  = CreateMergeSpellEntry(true),      -- Shadowy Apparition
      [14914]  = CreateMergeSpellEntry(true),      -- Holy Fire
    
    -- priest (healing)
      [47750]  = CreateMergeSpellEntry(true),      -- Penance (Heal)
      [139]    = CreateMergeSpellEntry(true),      -- Renew
      [596]    = CreateMergeSpellEntry(true, .5),  -- Prayer of Healing                          (INSTANT)
      [64844]  = CreateMergeSpellEntry(true),      -- Divine Hymn
      [32546]  = CreateMergeSpellEntry(true),      -- Binding Heal
      [77489]  = CreateMergeSpellEntry(true),      -- Echo of Light
      [34861]  = CreateMergeSpellEntry(true, .5),  -- Circle of Healing                          (INSTANT)
      [23455]  = CreateMergeSpellEntry(true, .5),  -- Holy Nova (Healing)                        (INSTANT)
      [33110]  = CreateMergeSpellEntry(true),      -- Prayer of Mending
      [63544]  = CreateMergeSpellEntry(true),      -- Rapid Renewal
      [88686]  = CreateMergeSpellEntry(true, 6),   -- Holy Word: Sanctuary                       (every 2 sec for 30 sec)
    
    -- rogue
      [51723]  = CreateMergeSpellEntry(true, .5),  -- Fan of Knives                              (INSTANT)
      [2818]   = CreateMergeSpellEntry(true),      -- Deadly Poison
      [8680]   = CreateMergeSpellEntry(true),      -- Wound Poison
      
    -- shaman (damage)
      [421]    = CreateMergeSpellEntry(true, .5),  -- Chain Lightning                            (INSTANT)
      [8349]   = CreateMergeSpellEntry(true),      -- Fire Nova
      [77478]  = CreateMergeSpellEntry(true),      -- Earthquake
      [51490]  = CreateMergeSpellEntry(true),      -- Thunderstorm
      [8187]   = CreateMergeSpellEntry(true),      -- Magma Totem
      [8050]   = CreateMergeSpellEntry(true),      -- Flame Shock
      [25504]  = CreateMergeSpellEntry(true, .5),  -- Windfury Attack                            (INSTANT)
    
    -- shaman (healing)
      [73921]  = CreateMergeSpellEntry(true),      -- Healing Rain
      [1064]   = CreateMergeSpellEntry(true, .5),  -- Chain Heal                                 (INSTANT)
      [52042]  = CreateMergeSpellEntry(true),      -- Healing Stream Totem
      [51945]  = CreateMergeSpellEntry(true),      -- Earthliving
      [61295]  = CreateMergeSpellEntry(true),      -- Riptide

    -- warlock
      [172]    = CreateMergeSpellEntry(true),      -- Corruption
      [87389]  = CreateMergeSpellEntry(true),      -- Corruption (Soulburn: Seed of Corruption)
      [27243]  = CreateMergeSpellEntry(true),      -- Seed of Corruption (DoT)
      [27285]  = CreateMergeSpellEntry(true, .5),  -- Seed of Corruption (Explosion)             (INSTANT)
      [87385]  = CreateMergeSpellEntry(true, .5),  -- Seed of Corruption (Explosion Soulburned)  (INSTANT)
      [30108]  = CreateMergeSpellEntry(true),      -- Unstable Affliction
      [348]    = CreateMergeSpellEntry(true),      -- Immolate
      [50590]  = CreateMergeSpellEntry(true),      -- Immolation (Aura)
      [980]    = CreateMergeSpellEntry(true),      -- Agony
      [42223]  = CreateMergeSpellEntry(true),      -- Rain of Fire
      [5857]   = CreateMergeSpellEntry(true),      -- Hellfire
      [47897]  = CreateMergeSpellEntry(true),      -- Shadowflame
      [47960]  = CreateMergeSpellEntry(true),      -- Shadowflame (DOT)
      [30213]  = CreateMergeSpellEntry(true, .5),  -- Legion Strike (Felguard)                   (INSTANT)
      [89753]  = CreateMergeSpellEntry(true),      -- Felstorm (Felguard)
      [20153]  = CreateMergeSpellEntry(true),      -- Immolation (Infrenal)
    
    -- warrior
      [845]    = CreateMergeSpellEntry(true, .5),  -- Cleave                                     (INSTANT)
      [46968]  = CreateMergeSpellEntry(true, .5),  -- Shockwave                                  (INSTANT)
      [6343]   = CreateMergeSpellEntry(true, .5),  -- Thunder Clap                               (INSTANT)
      [1680]   = CreateMergeSpellEntry(true),      -- Whirlwind
      [50622]  = CreateMergeSpellEntry(true),      -- Bladestorm
      [52174]  = CreateMergeSpellEntry(true, .5),  -- Heroic Leap                                (INSTANT)
      
    -- spammy items (old)
      [109858] = CreateMergeSpellEntry(true, 2.5), -- Speaking of Rage - proc'd by: Vishanka, Jaws of the Earth (Heroic)
    },
  
  },
}

local merge_default = {
  enabled  = false, 
  interval = 3,
}

local merge_mt = {
  __index = function(index)
    return merge_default
  end,
}

setmetatable(addon.DefaultProfile.spells.merge, merge_mt)