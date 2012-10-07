local ADDON_NAME, addon = ...
local X = addon.engine
local blankTable, unpack, select = {}, unpack, select
local string_gsub = string.gsub

-- Creating an Config
addon.options = {
  name = "xCT+ - Configuration Tool",
  handler = X,
  type = 'group',
  args = {
    xCT_Header = {
      order = 1,
      type = "header",
      name = "Version: "..(GetAddOnMetadata("xCT+", "Version") or "Unknown"),
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
      func = X.RestoreAllDefaults,
    },
    ToggleFrames = {
      order = 4,
      type = 'execute',
      name = "Toggle Frames",
      func = X.ToggleConfigMode,
    },
    ToggleTestMode = {
      order = 4,
      type = 'execute',
      name = "Toggle Test Mode",
      func = X.ToggleTestMode,
    },
    
  },
}

addon.options.args["Credits"] = {
  name = "Credits",
  type = 'group',
  order = 2,
  args = {
    title = {
      type = "header",
      order = 0,
      name = "Credits and Mentions",
    },
    
    specialThanksTitle = {
      type = 'description',
      order = 1,
      name = "|cffFFFF00Special Thank You|r",
    },
    
    specialThanksList = {
      type = 'description',
      order = 2,
      name = "  Tukz, Elv, Affli, BuG",
    },
    
    testerTitleSpace = {
      type = 'description',
      order = 3,
      name = " ",
    },
    
    testerTitle = {
      type = 'description',
      order = 4,
      name = "|cffFFFF00Testers|r",
    },
    
    userName1 = {
      type = 'description',
      order = 5,
      name = "  "..UnitName("player"),
    },
  },
}

addon.options.args["Frames"] = {
  name = "Frames",
  type = 'group',
  order = 1,
  args = {
  
    Frames_Header = {
      type = "header",
      order = 1,
      name = "xCT+ Frames",
    },

    Frames_Description = {
      type = "description",
      order = 2,
      name = "Under Construction. Please have fun using the beta!",
    },
    
    general = {
      name = "|cffFFFFFFGeneral|r",
      type = 'group',
      order = 10,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
      },
    },
    
    outgoing = {
      name = "|cffFFFFFFOutgoing|r",
      type = 'group',
      order = 12,
      args = {
      
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
    
    critical = {
      name = "|cffFFFFFFOutgoing|r |cff798BDD(Criticals)|r",
      type = 'group',
      order = 13,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
        -- TODO: Move Crits Appearance somewhere else, because other frames use it too
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
              get = function(info) return string_gsub(X.db.profile.frames[info[#info-2]][info[#info]], "|", "||") end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = string_gsub(value, "||", "|") end,
            },
            
            critPostfix = {
              order = 2,
              type = 'input',
              name = "Postfix",
              desc = "Postfix this value to the end when displaying a critical amount.",
              get = function(info) return string_gsub(X.db.profile.frames[info[#info-2]][info[#info]], "|", "||") end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = string_gsub(value, "||", "|") end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },

        
        
        specialTweaks = {
          order = 9,
          type = 'group',
          guiInline = true,
          name = "Special Tweaks",
          args = {
          
            showSwing = {
              order = 1,
              type = 'toggle',
              name = "Swing Crits",
              desc = "Show Swing and Auto Attack crits in this frame.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            prefixSwing = {
              order = 2,
              type = 'toggle',
              name = "Swing (Pre)Postfix",
              desc = "Make Swing and Auto Attack crits more visible by adding the prefix and postfix.",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            redirectSwing = {
              order = 3,
              type = 'toggle',
              name = "Redirect Swing",
              desc = "Sends Swing crits to the \"|cff798BDDOutgoing|r\" frame. (|cffFF0000Requires:|r \"|cffFFFF00Swing Crits|r\". For other useful options, see: \"|cffFFFF00Swing (Pre)Postfix|r\")",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
          },
        },

      },
    },
    
    damage = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Damage)|r",
      type = 'group',
      order = 14,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
      },
    },
    
    healing = {
      name = "|cffFFFFFFIncoming|r |cff798BDD(Healing)|r",
      type = 'group',
      order = 15,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
      },
    },
    
    class = {
      name = "|cffFFFFFFClass Combo Points|r",
      type = 'group',
      order = 16,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
          },
        },
        
        fontColors = {
          order = 4,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = function(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end,
              set = function(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end,
            },
          },
        },
        
      },
    },
    
    power = {
      name = "|cffFFFFFFClass Power|r",
      type = 'group',
      order = 17,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
      },
    },
    
    procs = {
      name = "|cffFFFFFFSpecial Effects|r |cff798BDD(Procs)|r",
      type = 'group',
      order = 18,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
      },
    },
    
    loot = {
      name = "|cffFFFFFFLoot & Money|r",
      type = 'group',
      order = 19,
      args = {
        
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
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
          set = function(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value; X:UpdateFrames(info[#info-1]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
          },
        },
        
        fontColors = {
          order = 5,
          type = 'group',
          guiInline = true,
          name = "Font Colors",
          args = {
          
            customColor = {
              order = 1,
              type = 'toggle',
              name = "Use Custom Colors",
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
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
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = function(info) return X.db.profile.frames[info[#info-2]][info[#info]] end,
              set = function(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value; X:UpdateFrames(info[#info-2]) end,
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

-- addon.options.args["Profiles"] <-- Set in core.lua