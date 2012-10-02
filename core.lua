-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

-- Load AceStuff
addon.engine = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0")
MyAddon.DefaultProfile = addon.DefaultProfile

-- Give a Global handle
GUIConfig = addon.engine

-- Shorten my handle
local X = GUIConfig

local blankTable = {}

-- invisible copy (orig table, lookup table)
local function inv_tcopy(t1, t2)
  for k, v in pairs(t2) do
    if not t1[k] then -- found new key
      t1[k] = t2[k]
    elseif type(t1[k]) == "table" then
      inv_tcopy(t1[k], t2[k])
    end
  end
end



-- Important Addon Event Handlers
function X:OnInitialize()
  if not xCTSavedDB then
    xCTSavedDB = { }
  end


  self.db = LibStub("AceDB-3.0"):New("xCTSavedDB")
  self.options.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

  -- Check Frames
  self.db:GetCurrentProfile()

  if not self.db.profile.frames then
    self.db.profile.frames = { }
  end
  
  inv_tcopy(self.db.profile.frames, self.DefaultProfile.frames)
  
end

function X:OnEnable()
  -- Called when the addon is enabled
end

function X:OnDisable()
  -- Called when the addon is disabled
end





-- Creating an Config
local options = {
  name = "xCT+ - Configuration Tool",
  handler = X,
  type = 'group',
  args = {
    xCT_Header = {
      order = 1,
      type = "header",
      name = "Version: "..(GetAddOnMetadata("xCT", "Version") or "Unknown"),
      width = "full",
    },
    Enable_xCT = {
      order = 2,
      type = 'toggle',
      name = "Enable xCT+",
      get = function(info) return true end,
      set = function(info, value) end,
    },  
    RestoreDefaults = {
      order = 3,
      type = 'execute',
      name = "Restore Defaults",
      func = function() end,
    },
    ToggleFrames = {
      order = 4,
      type = 'execute',
      name = "Toggle Frames",
      func = function() end,
    },
    ToggleTestMode = {
      order = 4,
      type = 'execute',
      name = "Toggle Test Mode",
      func = function() end,
    },
    
  },
}

options.args["General"] = {
  name = "General",
  type = 'group',
  args = {
    check2 = {
      order = 1,
      type = 'toggle',
      name = "check 2",
      get = function(info) return true end,
      set = function(info, value) end,
    },
  },
}

options.args["Frames"] = {
  name = "Frames",
  type = 'group',
  args = {
  
    Frames_Header = {
      type = "header",
      name = "xCT+ Frames",
    },
    -- |cff798BDD - title
    -- |cFFFF6D1F - crits
    -- |cFFA10320 - heals
    -- |cFFFF102B - damage
    xCTgen = {
      name = "|cffFFFFFFGeneral|r",
      desc = "Frame Name: '" .. 'xCTgen' .. "'",
      type = 'group',
      order = 1,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            --[1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        scrollable = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTdone = {
      name = "|cffFFFFFFOutgoing|r",
      desc = "Frame Name: '" .. 'xCTdone' .. "'",
      type = 'group',
      order = 2,
      args = {
      
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            --[2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },

        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        icons = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Icons",
          args = {
            iconsEnabled = {
              order = 1,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
          },
        },
        
        scrollable = {
          order = 7,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        specialTweaks = {
          order = 8,
          type = 'group',
          guiInline = true,
          name = "Special Tweaks",
          args = {
            enableOutDmg = {
              order = 1,
              type = 'toggle',
              name = "Outgoing Damage",
              desc = "Show damage you do.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableOutHeal = {
              order = 2,
              type = 'toggle',
              name = "Outgoing Healing",
              desc = "Show healing you do.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enablePetDmg = {
              order = 3,
              type = 'toggle',
              name = "Pet Damage",
              desc = "Show your pet's damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableAutoAttack = {
              order = 4,
              type = 'toggle',
              name = "AutoAttack",
              desc = "Show your auto attack damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableDotDmg = {
              order = 5,
              type = 'toggle',
              name = "DoTs",
              desc = "Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableHots = {
              order = 6,
              type = 'toggle',
              name = "HoTs",
              desc = "Show your Heal-Over-Time (HOT) healing. (|cffFF0000Requires:|r Outgoing Healing)",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableImmunes = {
              order = 7,
              type = 'toggle',
              name = "Immunes",
              desc = "Display 'Immune' when your target cannot take damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            enableMisses = {
              order = 8,
              type = 'toggle',
              name = "Miss Types",
              desc = "Display 'Miss', 'Dodge', 'Parry' when you miss your target.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
          },
        },
        
      },
    },
    
    xCTcrit = {
      name = "|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r",
      desc = "Frame Name: '" .. 'xCTcrit' .. "'",
      type = 'group',
      order = 3,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            --[3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        criticalAppearance = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Critical Appearance",
          args = {
          
            critPrefix = {
              order = 1,
              type = 'input',
              name = "Prefix",
              desc = "Prefix this value to the beginning when displaying a critical amount.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            critPostfix = {
              order = 2,
              type = 'input',
              name = "Postfix",
              desc = "Postfix this value to the end when displaying a critical amount.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
          },
        },
        
        icons = {
          order = 7,
          type = 'group',
          guiInline = true,
          name = "Icons",
          args = {
            iconsEnabled = {
              order = 1,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
          },
        },
        
        scrollable = {
          order = 8,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTdmg = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Damage)|r",
      desc = "Frame Name: '" .. 'xCTdmg' .. "'",
      type = 'group',
      order = 4,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            --[4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        scrollable = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTheal = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Healing)|r",
      desc = "Frame Name: '" .. 'xCTheal' .. "'",
      type = 'group',
      order = 5,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            --[5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        scrollable = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTclass = {
      name = "|cffFFFFFFClass Combo Points|r",
      desc = "Frame Name: '" .. 'xCTclass' .. "'",
      type = 'group',
      order = 6,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'description',
          order = 2,
          name = "|cffFF0000Secondary Frame Not Available|r - |cffFFFFFFThis frame cannot output to another frame when it is disabled.",
        },
        
        fonts = {
          order = 3,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
          },
        },
        
        fontColors = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
      },
    },
    
    xCTpwr = {
      name = "|cffFFFFFFClass Power|r",
      desc = "Frame Name: '" .. 'xCTpwr' .. "'",
      type = 'group',
      order = 7,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            --[6] = "Class Power",
            [7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        scrollable = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTproc = {
      name = "|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r",
      desc = "Frame Name: '" .. 'xCTproc' .. "'",
      type = 'group',
      order = 8,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            --[7] = "Special Effects (Procs)",
            [8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        scrollable = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
      },
    },
    
    xCTloot = {
      name = "|cffFFFFFFLoot & Money|r",
      desc = "Frame Name: '" .. 'xCTloot' .. "'",
      type = 'group',
      order = 9,
      args = {
        enabled = {
          order = 1,
          type = 'toggle',
          name = "Enabled",
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        secondaryFrame = {
          type = 'select',
          order = 2,
          name = "Secondary Frame",
          desc = "A frame to forward messages to when this frame is disabled.",
          values = {
            [0] = "None",
            [1] = "General",
            [2] = "Outgoing",
            [3] = "Outgoing (Criticals)",
            [4] = "Incoming (Damage)",
            [5] = "Incoming (Healing)",
            [6] = "Class Power",
            [7] = "Special Effects (Procs)",
            --[8] = "Loot & Money",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        insertText = {
          type = 'select',
          order = 3,
          name = "Text Direction",
          desc = "Changes the direction that the text travels in the frame.",
          values = {
            ["top"] = "Down",
            ["bottom"] = "Up",
          },
          get = function(info) return X.db.profile.frames[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end,
        },
        
        fonts = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Fonts",
          args = {
          
            font = {
              type = 'select', dialogControl = 'LSM30_Font',
              order = 1,
              name = "Font",
              desc = "Set the font of the frame.",
              values = AceGUIWidgetLSMlists.font,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontOutline = {
              type = 'select',
              order = 3,
              name = "Font Outline",
              desc = "Set the font outline.",
              values = {
                ['1NONE'] = "None",
                ['2OUTLINE'] = 'OUTLINE',
                ['3MONOCHROME'] = 'MONOCHROME',
                ['4MONOCHROMEOUTLINE'] = 'MONOCHROMEOUTLINE',
                ['5THICKOUTLINE'] = 'THICKOUTLINE',
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontJustify = {
              type = 'select',
              order = 4,
              name = "Justification",
              desc = "Justifies the output to a side.",
              values = {
                ['RIGHT']  = "Right",
                ['LEFT']   = "Left",
                ['CENTER'] = "Center",
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            autoColor = {
              order = 1,
              type = 'toggle',
              name = "Use Default Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              desc = "Disable Default Colors to use a custom color.",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        icons = {
          order = 6,
          type = 'group',
          guiInline = true,
          name = "Icons",
          args = {
            iconsEnabled = {
              order = 1,
              type = 'toggle',
              name = "Icons",
              desc = "Show icons next to your damage.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          
          },
        },
        
        scrollable = {
          order = 7,
          type = 'group',
          guiInline = true,
          name = "Scrollable Frame",
          args = {
            enableScrollable = {
              order = 1,
              type = 'toggle',
              name = "Enabled",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
          },
        },
        
        specialTweaks = {
          order = 8,
          type = 'group',
          guiInline = true,
          name = "Special Tweaks",
          args = {
            showItems = {
              order = 1,
              type = 'toggle',
              name = "Looted Items",
              desc = "Displays items that you pick up.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            showMoney = {
              order = 2,
              type = 'toggle',
              name = "Looted Money",
              desc = "Displays money that you pick up.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            showItemTotal = {
              order = 3,
              type = 'toggle',
              name = "Total Items",
              desc = "Displays how many items you have in your bag.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            showCrafted = {
              order = 4,
              type = 'toggle',
              name = "Crafted Items",
              desc = "Displays items that you crafted.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            showQuest = {
              order = 5,
              type = 'toggle',
              name = "Quest Items",
              desc = "Displays items that pertain to a quest.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            colorBlindMoney = {
              order = 6,
              type = 'toggle',
              name = "Color Blind Mode",
              desc = "Displays money using letters G, S, and C instead of icons.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            filterItemQuality = {
              order = 7,
              type = 'select',
              name = "Filter Item Quality",
              desc = "Will not display any items that are below this quality (does not filter Quest or Crafted items).",
              values = {
                [0] = '1. |cff9d9d9d'..ITEM_QUALITY0_DESC..'|r',   -- Poor
                [1] = '2. |cffffffff'..ITEM_QUALITY1_DESC..'|r',   -- Common
                [2] = '3. |cff1eff00'..ITEM_QUALITY2_DESC..'|r',   -- Uncommon
                [3] = '4. |cff0070dd'..ITEM_QUALITY3_DESC..'|r',   -- Rare
                [4] = '5. |cffa335ee'..ITEM_QUALITY4_DESC..'|r',   -- Epic
                [5] = '6. |cffff8000'..ITEM_QUALITY5_DESC..'|r',   -- Legendary
                [6] = '7. |cffe6cc80'..ITEM_QUALITY6_DESC..'|r',   -- Artifact
                [7] = '8. |cffe6cc80'..ITEM_QUALITY7_DESC..'|r',   -- Heirloom
              },
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
          },
        },
        
      },
    },
    
  },
}

X.options = options

-- Called from the options
function MyAddon:GetMyMessage(info)
    return myMessageVar
end

-- Called from the options
function MyAddon:SetMyMessage(info, input)
    myMessageVar = input
end





-- This allows us to create our config dialog
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

ACD:SetDefaultSize(AddonName, 800, 550)

-- Register the Options
AC:RegisterOptionsTable(AddonName, X.options)

-- Register Slash Commands
MyAddon:RegisterChatCommand("xct", "OpenGUICommand")

-- Process the slash command ('input' contains whatever follows the slash command)
function MyAddon:OpenGUICommand(input)
  if (input == "r") then
    xCTSavedDB = nil
    ReloadUI()
  end
  
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  ACD[mode](ACD, AddonName)
end

