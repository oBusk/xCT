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

local function CreateMergeSpellEntry(enabled, interval)
  return { enabled = enabled, interval = interval or 3 }
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
    merge = {
    -- priest 
      [47666]  = CreateMergeSpellEntry(true),      -- Penance (Damage Effect)
      [15237]  = CreateMergeSpellEntry(true, .5),  -- Holy Nova (Damage Effect)                  (INSTANT)
      [589]    = CreateMergeSpellEntry(true),      -- Shadow Word: Pain
      [34914]  = CreateMergeSpellEntry(true),      -- Vampiric Touch
      [2944]   = CreateMergeSpellEntry(true),      -- Devouring Plague
      [63675]  = CreateMergeSpellEntry(true),      -- Improved Devouring Plague
      [15407]  = CreateMergeSpellEntry(true),      -- Mind Flay
      [49821]  = CreateMergeSpellEntry(true, 5),   -- Mind Seer (From Derap: first one is the cast)
      [124469] = CreateMergeSpellEntry(true),      -- Mind Seer (the second one is the debuff that is applied to your target which lets you clip your mind sears like mind flay)
      [87532]  = CreateMergeSpellEntry(true),      -- Shadowy Apparition
      [14914]  = CreateMergeSpellEntry(true),      -- Holy Fire
      
    -- hunter
      [2643]   = CreateMergeSpellEntry(true, .5),  -- Multi-Shot                                 (INSTANT)
      [83077]  = CreateMergeSpellEntry(true, .5),  -- Serpent Sting (Instant Serpent Spread)     (INSTANT)
      [118253] = CreateMergeSpellEntry(true),      -- Serpent Sting (Tick)
      [13812]  = CreateMergeSpellEntry(true),      -- Explosive Trap
      [53301]  = CreateMergeSpellEntry(true),      -- Explosive Shot (3 ticks merged as one)
      [63468]  = CreateMergeSpellEntry(true),      -- Piercing Shots
      
      
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