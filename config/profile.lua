local ADDON_NAME, addon = ...

addon.DefaultProfile = {
  frames = {
    xCTgen = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",

    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    xCTdone = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
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
    
    xCTcrit = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- critical appearance
      ["critPrefix"] = "||cffFF0000*||r",
      ["critPostfix"] = "||cffFF0000*||r",
      
    -- icons
      ["iconsEnabled"] = true,
      ["iconsSize"] = 16,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    xCTdmg = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },

    xCTheal = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    xCTclass = {
      ["enabled"] = true,
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
    },
    
    xCTpwr = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    xCTproc = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
    -- font colors
      ["autoColor"] = true,
      ["fontColor"] = nil,
      
    -- scrollable
      ["enableScrollable"] = false,
      ["scrollableLines"] = 10,
    },
    
    xCTloot = {
      ["enabled"] = true,
      ["secondaryFrame"] = 0,
      ["insertText"] = "bottom",
      
    -- fonts
      ["font"] = "HOOGE (xCT)",
      ["fontSize"] = 16,
      ["fontOutline"] = "4MONOCHROMEOUTLINE",
      ["fontJustify"] = "RIGHT",
      
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
