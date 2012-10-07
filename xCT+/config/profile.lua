local ADDON_NAME, addon = ...

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
}