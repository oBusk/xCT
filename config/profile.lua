local ADDON_NAME, addon = ...

print("LOADING PROFILE")

addon.DefaultProfile = {
  frames = {
    general = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- position
      ["X"] = 0,
      ["Y"] = 192,
      ["Width"] = 256,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",

    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    outgoing = {
      ["enabled"] = true,
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
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
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
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
    
    -- position
      ["X"] = 256,
      ["Y"] = 0,
      ["Width"] = 256,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
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
    },
    
    damage = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- position
      ["X"] = -448,
      ["Y"] = -80,
      ["Width"] = 128,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },

    healing = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
    
    -- positioon
      ["X"] = -448,
      ["Y"] = 80,
      ["Width"] = 128,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    class = {
      ["enabled"] = true,
      
    -- position
      ["X"] = 0,
      ["Y"] = 96,
      ["Width"] = 64,
      ["Height"] = 64,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
    },
    
    power = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- position
      ["X"] = 0,
      ["Y"] = -192,
      ["Width"] = 256,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    procs = {
      ["enabled"] = true,
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
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    loot = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- position 
      ["X"] = 0,
      ["Y"] = 0,
      ["Width"] = 256,
      ["Height"] = 128,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "CENTER",
      
    -- font colors
      ["autoColor"] = true,
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

print("LOADED PROFILE")