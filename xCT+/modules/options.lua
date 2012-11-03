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

local ADDON_NAME, addon = ...
local X = addon.engine
local blankTable, unpack, select = {}, unpack, select
local string_gsub = string.gsub

-- New Icon "!"
local NEW = X.new

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
    showStartupText = {
      order = 2,
      type = 'toggle',
      name = "Startup Message",
      get = function(info) return X.db.profile.showStartupText end,
      set = function(info, value) X.db.profile.showStartupText = value end,
    },  
    RestoreDefaults = {
      order = 3,
      type = 'execute',
      name = "Restore Defaults",
      func = X.RestoreAllDefaults,
    },
    ToggleTestMode = {
      order = 4,
      type = 'execute',
      name = "Toggle Test Mode",
      func = X.ToggleTestMode,
    },
    ToggleFrames = {
      order = 5,
      type = 'execute',
      name = "Toggle Frames",
      func = X.ToggleConfigMode,
    },
  },
}

-- Generic Get/Set methods
local function get0(info) return X.db.profile[info[#info-1]][info[#info]] end
local function set0(info, value) X.db.profile[info[#info-1]][info[#info]] = value end
local function get1(info) return X.db.profile.frames[info[#info-1]][info[#info]] end
local function set1(info, value) X.db.profile.frames[info[#info-1]][info[#info]] = value end
local function set1_update(info, value) set1(info, value); X:UpdateFrames(info[#info-1]) end
local function get2(info) return X.db.profile.frames[info[#info-2]][info[#info]] end
local function set2(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = value end
local function set2_update(info, value) set2(info, value); X:UpdateFrames(info[#info-2]) end
local function getColor2(info) return unpack(X.db.profile.frames[info[#info-2]][info[#info]] or blankTable) end
local function setColor2(info, r, g, b) X.db.profile.frames[info[#info-2]][info[#info]] = {r,g,b} end
local function getTextIn2(info) return string_gsub(X.db.profile.frames[info[#info-2]][info[#info]], "|", "||") end
local function setTextIn2(info, value) X.db.profile.frames[info[#info-2]][info[#info]] = string_gsub(value, "||", "|") end

addon.options.args["spells"] = {
  name = "Spam Merger",
  type = 'group',
  order = 2,
  args = {
    title = {
      type = "header",
      order = 0,
      name = "Spam Settings",
    },
    spamDesc = {
      type = 'description',
      order = 1,
      name = "The spam merger is used to combine certain spells together, so that output of your frames is limited to a minimum. Common spells that are merged include: |cff71d5ff|Hspell:42231|h[Hurricane]|h|r, |cff71d5ff|Hspell:85222|h[Light of Dawn]|h|r, |cff71d5ff|Hspell:596|h[Prayer of Healing]|h|r, |cff71d5ff|Hspell:2643|h[Multi-Shot]|h|4r, and many, many more!"
    },
    listSpacer0 = {
      type = "description",
      order = 2,
      name = " ",
    },
    enableMerger = {
      order = 3,
      type = 'toggle',
      name = "Enable Merger",
      get = get0,
      set = set0,
    },
    enableMergerDebug = {
      order = 4,
      type = 'toggle',
      name = "Show Spell IDs |cffFF0000(DEBUG)|r",
      get = get0,
      set = set0,
      width = "full",
    },
    
    listSpacer1 = {
      type = "description",
      order = 5,
      name = " ",
    },
    
    mergeSwings = {
      order = 9,
      type = 'toggle',
      name = "Merge Melee Swings",
      desc = "|cffFF0000ID|r 6603 |cff798BDD(Player Melee)|r\n|cffFF0000ID|r 0 |cff798BDD(Pet Melee)|r",
      get = function(info) return X.db.profile[info[#info-1]][info[#info]] end,
      set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = value end,
    },
    
    mergeRanged = {
      order = 9,
      type = 'toggle',
      name = "Merge Ranged Attacks",
      desc = "|cffFF0000ID|r 75",
      get = function(info) return X.db.profile[info[#info-1]][info[#info]] end,
      set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = value end,
    },
    
    listSpacer2 = {
      type = "description",
      order = 10,
      name = " ",
    },
    
    spellList = {
      name = "List of Mergeable Spells |cff798BDD(Class Specific)|r",
      type = 'group',
      guiInline = true,
      order = 20,
      args = {
        mergeListDesc = {
          type = "description",
          order = 1,
          name = "Uncheck a spell if you do not want it merged.",
        },
      },
    },
  },
}

addon.options.args["Credits"] = {
  name = "Credits" .. NEW,
  type = 'group',
  order = 3,
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
      name = "  |cffAA0000Tukz|r, |cffAA0000Elv|r, |cffFFFF00Affli|r, |cffFF8000BuG|r, |cff8080FFShestak|r, Nidra, gnangnan, NitZo, Naughtia",
    },
    testerTitleSpace1 = {
      type = 'description',
      order = 3,
      name = " ",
    },
    testerTitle = {
      type = 'description',
      order = 4,
      name = "|cffFFFF00Beta Testers|r  (Blame them if something breaks!)",
    },
    userName1 = {
      type = 'description',
      order = 5,
      name = " |cffAAAAFF Alex|r,|cff8080EE BuG|r,|cffAAAAFF Kkthnxbye|r,|cff8080EE Azilroka|r,|cffAAAAFF Prizma|r,|cff8080EE schmeebs|r,|cffAAAAFF Pat|r,|cff8080EE hgwells|r,|cffAAAAFF Jaron|r,|cff8080EE Fitzbattleaxe|r,|cffAAAAFF Nihan|r,|cff8080EE Jaxo|r,|cffAAAAFF Schaduw|r,|cff8080EE sylenced|r,|cffAAAAFF kaleidoscope|r,|cff8080EE Killatones|r,|cffAAAAFF Trokko|r,|cff8080EE Yperia|r,|cffAAAAFF Edoc|r,|cff8080EE Cazart|r,|cffAAAAFF Nevah|r,|cff8080EE Refrakt|r,|cffAAAAFF Thakah|r,|cff8080EE johnis007|r,|cffAAAAFF Sgt|r,|cff8080EE NitZo|r",
    },
    testerTitleSpace2 = {
      type = 'description',
      order = 6,
      name = " ",
    },
    betaTestersOnly = {
      type = 'description',
      order = 7,
      name = "If your name is not in the list above, send me (|cffFF8000Dandruff|r) a PM on tukui.org and I will add you :)",
    },
  },
}

addon.options.args["Frames"] = {
  name = "Frames" .. X.new,
  desc = "|cffFFFF00New:|r Added Damage Abbrivation",
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
      name = "Unfortunately I cannot display all the options for combat text in this configuration tool alone. Blizzard has a few tweaks you might want to look at. For performance reasons, I am leaving them there for the time being. I hope you are enjoying the |cffFF0000x|rCT+ beta!",
    },
    blizzardOptions = {
      order = 3,
      type = 'execute',
      name = "More Blizzard Options",
      func = function() InterfaceOptionsFrame:Show(); InterfaceOptionsFrameCategoriesButton8:Click(); LibStub('AceConfigDialog-3.0'):Close(ADDON_NAME); GameTooltip:Hide() end,
    },
    frameSettings = {
      name = "Frame Settings",
      type = 'group',
      order = 4,
      guiInline = true,
      args = {
        clearLeavingCombat = {
          order = 1,
          type = 'toggle',
          name = "Clear Frames When Leaving Combat",
          desc = "Enable this option if you have problems with 'floating' icons.",
          width = "full",
          get = get0,
          set = set0,
        },
        showGrid = {
          order = 2,
          type = 'toggle',
          name = "Show Align Grid",
          get = get0,
          set = set0,
        },
        
        frameStrata = {
          type = 'select',
          order = 3,
          name = "Frame Strata",
          desc = "The Z-Layer to place the |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r frame onto",
          values = {
            ["1PARENT"]             = "Parent |cffFF0000(Lowest)|r",
            ["2BACKGROUND"]         = "Background",
            ["3LOW"]                = "Low",
            ["4MEDIUM"]             = "Medium |cffFFFF00(Default)|r",
            ["5HIGH"]               = "High",
            ["6DIALOG"]             = "Dialog",
            ["7FULLSCREEN"]         = "Fullscreen",
            ["8FULLSCREEN_DIALOG"]  = "Fullscreen Dialog",
            ["9TOOLTIP"]            = "ToolTip |cffAAFF80(Highest)|r",
          },
          get = function(info) return X.db.profile[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = value; X:UpdateFrames() end,
        },
        
      },
    },
    
    megaDamage = {
      name = "Damage Abbrivation Settings" .. X.new,
      type = 'group',
      order = 5,
      guiInline = true,
      args = {
        enableMegaDamage = {
          order = 1,
          type = 'toggle',
          name = "Enable",
          desc = "Enable Damage Abbrivation",
          width = "full",
          get = function(info) return X.db.profile[info[#info-1]][info[#info]] end,
          set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = value end,
        },
      
        thousandSymbol = {
          order = 2,
          type = 'input',
          name = "Thousand",
          desc = "Symbol for: |cffFF0000Thousands|r |cff798BDD(10e+3)|r",
          get = function(info) return string_gsub(X.db.profile[info[#info-1]][info[#info]], "|", "||") end,
          set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = string_gsub(value, "||", "|") end,
        },
        
        millionSymbol = {
          order = 3,
          type = 'input',
          name = "Million",
          desc = "Symbol for: |cffFF0000Millions|r |cff798BDD(10e+6)|r",
          get = function(info) return string_gsub(X.db.profile[info[#info-1]][info[#info]], "|", "||") end,
          set = function(info, value) X.db.profile[info[#info-1]][info[#info]] = string_gsub(value, "||", "|") end,
        },
      },
    },
    general = {
      name = "|cffFFFFFFGeneral|r" .. X.new,
      desc = "|cffFFFF00New:|r Added some special tweaks",
      type = 'group',
      order = 11,
      args = {
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
            },
          },
        },

        specialTweaks = {
          order = 7,
          type = 'group',
          guiInline = true,
          name = "Special Tweaks" .. X.new,
          args = {
            showInterrupts = {
              order = 1,
              type = 'toggle',
              name = "Interrupts",
              desc = "Display the spell you successfully interrupted.",
              get = get2,
              set = set2,
            },
            showDispells = {
              order = 2,
              type = 'toggle',
              name = "Dispell/Steal",
              desc = "Show the spell that you dispelled or stole.",
              get = get2,
              set = set2,
            },
            showPartyKills = {
              order = 3,
              type = 'toggle',
              name = "Unit Killed",
              desc = "Display unit that was killed by your final blow.",
              get = get2,
              set = set2,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            enableOutHeal = {
              order = 2,
              type = 'toggle',
              name = "Outgoing Healing",
              desc = "Show healing you do.",
              get = get2,
              set = set2,
            },
            enablePetDmg = {
              order = 3,
              type = 'toggle',
              name = "Pet Damage",
              desc = "Show your pet's damage.",
              get = get2,
              set = set2,
            },
            enableAutoAttack = {
              order = 4,
              type = 'toggle',
              name = "AutoAttack",
              desc = "Show your auto attack damage.",
              get = get2,
              set = set2,
            },
            enableDotDmg = {
              order = 5,
              type = 'toggle',
              name = "DoTs",
              desc = "Show your Damage-Over-Time (DOT) damage. (|cffFF0000Requires:|r Outgoing Damage)",
              get = get2,
              set = set2,
            },
            enableHots = {
              order = 6,
              type = 'toggle',
              name = "HoTs",
              desc = "Show your Heal-Over-Time (HOT) healing. (|cffFF0000Requires:|r Outgoing Healing)",
              get = get2,
              set = set2,
            },
            enableImmunes = {
              order = 7,
              type = 'toggle',
              name = "Immunes",
              desc = "Display 'Immune' when your target cannot take damage.",
              get = get2,
              set = set2,
            },
            enableMisses = {
              order = 8,
              type = 'toggle',
              name = "Miss Types",
              desc = "Display 'Miss', 'Dodge', 'Parry' when you miss your target.",
              get = get2,
              set = set2,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = getTextIn2,
              set = setTextIn2,
            },
            
            critPostfix = {
              order = 2,
              type = 'input',
              name = "Postfix",
              desc = "Postfix this value to the end when displaying a critical amount.",
              get = getTextIn2,
              set = setTextIn2,
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
              get = get2,
              set = set2,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            prefixSwing = {
              order = 2,
              type = 'toggle',
              name = "Swing (Pre)Postfix",
              desc = "Make Swing and Auto Attack crits more visible by adding the prefix and postfix.",
              get = get2,
              set = set2,
            },
            
            redirectSwing = {
              order = 3,
              type = 'toggle',
              name = "Redirect Swing",
              desc = "Sends Swing crits to the \"|cff798BDDOutgoing|r\" frame. (|cffFF0000Requires:|r \"|cffFFFF00Swing Crits|r\". For other useful options, see: \"|cffFFFF00Swing (Pre)Postfix|r\")",
              get = get2,
              set = set2,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
          get = get1,
          set = set1,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
            },
          },
        },
        
      },
    },
    
    loot = {
      name = "|cffFFFFFFLoot & Money|r" .. X.new,
      desc = "|cffFFFF00New:|r Changed item filter to 'whitelist' |cffFF0000(See submenu)|r",
      type = 'group',
      order = 19,
      args = {
        
        enabledFrame = {
          order = 1,
          type = 'toggle',
          name = "Enable Frame",
          get = get1,
          set = set1,
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
          get = get1,
          set = set1,
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
          get = get1,
          set = set1_update,
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
              get = get2,
              set = set2_update,
            },
            
            fontSize = {
              order = 2,
              name = "Font Size",
              desc = "Set the font size of the frame.",
              type = 'range',
              min = 6, max = 32, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            
            fontColor = {
              type = 'color',
              name = "Custom Color",
              order = 2,
              get = getColor2,
              set = setColor2,
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
              get = get2,
              set = set2,
            },
          
            iconsSize = {
              order = 2,
              name = "Icon Size",
              desc = "Set the icon size.",
              type = 'range',
              min = 6, max = 22, step = 1,
              get = get2,
              set = set2,
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
              get = get2,
              set = set2_update,
            },
            scrollableLines = {
              order = 2,
              name = "Number of Lines",
              type = 'range',
              min = 10, max = 60, step = 1,
              get = get2,
              set = set2_update,
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
              get = get2,
              set = set2,
            },
            showMoney = {
              order = 2,
              type = 'toggle',
              name = "Looted Money",
              desc = "Displays money that you pick up.",
              get = get2,
              set = set2,
            },
            showItemTotal = {
              order = 3,
              type = 'toggle',
              name = "Total Items",
              desc = "Displays how many items you have in your bag.",
              get = get2,
              set = set2,
            },
            showCrafted = {
              order = 4,
              type = 'toggle',
              name = "Crafted Items",
              desc = "Displays items that you crafted.",
              get = get2,
              set = set2,
            },
            showQuest = {
              order = 5,
              type = 'toggle',
              name = "Quest Items",
              desc = "Displays items that pertain to a quest.",
              get = get2,
              set = set2,
            },
            colorBlindMoney = {
              order = 6,
              type = 'toggle',
              name = "Color Blind Mode",
              desc = "Displays money using letters G, S, and C instead of icons.",
              get = get2,
              set = set2,
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
              get = get2,
              set = set2,
            },
          },
        },
      },
    },
  },
}

