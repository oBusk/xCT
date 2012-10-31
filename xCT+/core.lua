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

-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

local sgsub, ipairs, pairs, type, string_format, table_insert, print, tostring, tonumber, select, string_lower, collectgarbage =
  string.gsub, ipairs, pairs, type, string.format, table.insert, print, tostring, tonumber, select, string.lower, collectgarbage

-- Local Handle to the Engine
local X = addon.engine

-- Handle Addon Initialized
function X:OnInitialize()
  if xCT or ct and ct.myname and ct.myclass then
    print("|cffFF0000WARNING:|r xCT+ cannot load. Please disable xCT in order to use xCT+.")
    return
  end

  -- Load the Data Base
  self.db = LibStub('AceDB-3.0'):New('xCTSavedDB')
  self.db:RegisterDefaults(addon.defaults)
  self.db.RegisterCallback(self, 'OnProfileChanged', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileCopied', 'RefreshConfig')
  self.db.RegisterCallback(self, 'OnProfileReset', 'RefreshConfig')
  self.db:GetCurrentProfile()
  
  -- Add the profile options to my dialog config
  addon.options.args['Profiles'] = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
  
  -- Perform xCT+ Update
  X:UpdatePlayer()
  X:UpdateFrames()
  X:UpdateCombatTextEvents(true)
  X:UpdateSpamSpells()
  X:UpdateItemTypes()
  
  -- Everything got Initialized, show Startup Text
  if self.db.profile.showStartupText then
    print("Loaded |cffFF0000x|r|cffFFFF00CT|r|cffFF0000+|r. To configure, type: |cffFF0000/xct|r")
  end
end

-- Profile Updated, need to refresh important stuff 
function X:RefreshConfig()
  X:UpdateFrames()
  X:UpdateSpamSpells()
  X:UpdateItemTypes()
  collectgarbage()
end

-- Gets spammy spells from the database and creates options
function X:UpdateSpamSpells()
  for id, item in pairs(addon.merges) do
    if item.class == X.player.class then
      if not self.db.profile.spells.merge[id] then
        self.db.profile.spells.merge[id] = item
        self.db.profile.spells.merge[id]['enabled'] = true    -- default all to on
      else
      -- update merge setting incase they are outdated
        self.db.profile.spells.merge[id].interval = item.interval
        self.db.profile.spells.merge[id].prep = item.prep
      end
    end
  end

  local spells = addon.options.args.spells.args.spellList.args
  for spellID, entry in pairs(self.db.profile.spells.merge) do
    if entry.class == X.player.class then
      spells[tostring(spellID)] = {
        order = 3,
        type = 'toggle',
        name = GetSpellInfo(spellID),
        desc = "|cffFF0000ID|r " .. spellID,
        get = function(info) return self.db.profile.spells.merge[tonumber(info[#info])].enabled end,
        set = function(info, value) self.db.profile.spells.merge[tonumber(info[#info])].enabled = value end,
      }
    end
  end
end

-- Updates item filter list
function X:UpdateItemTypes()

  -- check to see if this is the first time we are loading this version
  local first = false
  if not self.db.profile.spells.items.version then
    self.db.profile.spells.items.version = 1
    first = true
  end


  local itemTypes = { GetAuctionItemClasses() }
  
  local allTypes = {
    order = 100,
    name = "Always Show Filter" .. X.new,
    desc = "|cffFFFF00New:|r Filter changed to whitelist",
    type = 'group',
    childGroups = "select",
    args = {
      secondaryFrame = {
          type = 'description',
          order = 0,
          name = "These options allow you to bypass the loot item filter and always show a item from any category, reguardless of the quality.\n",
        },
    },
  }
  
  for i, itype in ipairs(itemTypes) do
    local subtypes = { GetAuctionItemSubClasses(i) }
    
    if self.db.profile.spells.items[itype] == nil then
      self.db.profile.spells.items[itype] = { }
    end
    
    -- Page for the MAIN ITEM GROUP
    local group = {
      order = i,
      name = itype,
      type = 'group',
      args = { },
    }

    -- the footer for the current MAIN ITEM GROUP
    if #subtypes > 0 then
      -- Separator for the TOP toggle switches, and the BOTTOM enable/disable buttons
      group.args['enableHeader'] = {
        order = 100,
        type = 'header',
        name = "",
        width = "full",
      }
      
      -- Button to DISABLE all
      group.args['disableAll'] = {
        order = 101,
        type = 'execute',
        name = "|cffDDDD00Enable All|r",
        width = "half",
        func = function()
            for key in pairs(self.db.profile.spells.items[itype]) do
              self.db.profile.spells.items[itype][key] = true
            end
          end,
      }
      
      -- Button to ENABLE all
      group.args['enableAll'] = {
        order = 102,
        type = 'execute',
        name = "|cffDD0000Disable All|r",
        width = "half",
        func = function()
            for key in pairs(self.db.profile.spells.items[itype]) do
              self.db.profile.spells.items[itype][key] = false
            end
          end,
      }
    else
      -- Quest Items... maybe others
      if first or self.db.profile.spells.items[itype][itype] == nil then
        self.db.profile.spells.items[itype][itype] = false
      end
      
      group.args[itype] = {
        order = 1,
        type = 'toggle',
        name = "Enable",
        get = function(info) return self.db.profile.spells.items[itype][itype] end,
        set = function(info, value) self.db.profile.spells.items[itype][itype] = value end,
      }
    end

    -- add all the SUBITEMS
    for j, subtype in ipairs(subtypes) do
      if first or self.db.profile.spells.items[itype][subtype] == nil then
        self.db.profile.spells.items[itype][subtype] = false
      end
    
      group.args[subtype] = {
        order = j,
        type = 'toggle',
        name = subtype,
        get = function(info) return self.db.profile.spells.items[itype][subtype] end,
        set = function(info, value) self.db.profile.spells.items[itype][subtype] = value end,
      }
    end
    
    allTypes.args[itype] = group
  end

  addon.options.args["Frames"].args["loot"].args["typeFilter"] = allTypes
end

-- Update the combo point list
function X:UpdateComboPointOptions(force)
  if X.LOADED_COMBO_POINTS_OPTIONS and not force then return end

  local myClass, offset = X.player.class, 1
  
  local comboSpells = {
    order = 100,
    name = "Tracking Spells",
    type = 'group',
    guiInline = true,
    args = { },
  }

  -- Add "All Specializations" Entries
  for name in pairs(X.db.profile.spells.combo[myClass]) do
  
    if not tonumber(name) then
      if not comboSpells.args['allSpecsHeader'] then
        comboSpells.args['allSpecsHeader'] = {
          order = 0,
          type = 'header',
          name = "All Specializations",
          width = "full",
        }
      end
      comboSpells.args['entry' .. offset] = {
        order = offset,
        type = 'toggle',
        name = name,
        get = function(info) return self.db.profile.spells.combo[myClass][name] end,
        set = function(info, value) self.db.profile.spells.combo[myClass][name] = value end, 
      }
      offset = offset + 1
    end
  end
  
  -- Add the each spec
  for spec in ipairs(X.db.profile.spells.combo[myClass]) do
    local haveSpec = false
    for index, entry in pairs(X.db.profile.spells.combo[myClass][spec] or { }) do
      if not haveSpec then
        haveSpec = true
        local mySpecName = select(2, GetSpecializationInfo(spec)) or "Tree " .. spec
        
        comboSpells.args['mySpecHeader' .. offset] = {
            order = offset,
            type = 'header',
            name = "Specialization: " .. mySpecName,
            width = "full",
          }
        offset = offset + 1
      end
    
      if tonumber(index) then
        -- Class Combo Points ( UNIT_AURA Tracking)
        comboSpells.args['entry' .. offset] = {
          order = offset,
          type = 'toggle',
          name = GetSpellInfo(entry.id),
          desc = "Unit to track: |cffFF0000" .. entry.unit .. "|r\nSpell ID: |cffFF0000" .. entry.id .. "|r",
          get = function(info) return self.db.profile.spells.combo[myClass][spec][index].enabled end,
          set = function(info, value)
              if value == true then
                for key, entry in pairs(self.db.profile.spells.combo[myClass][spec]) do
                  if type(entry) == "table" then
                    entry.enabled = false
                  else
                    self.db.profile.spells.combo[myClass][spec][key] = false
                  end
                end
              end
              self.db.profile.spells.combo[myClass][spec][index].enabled = value
              
              -- Update tracker
              X:UpdateComboTracker()
            end, 
        }
      else
        -- Special Combo Point ( Unit Power )
        comboSpells.args['entry' .. offset] = {
          order = offset,
          type = 'toggle',
          name = index,
          desc = "Unit Power",
          get = function(info) return self.db.profile.spells.combo[myClass][spec][index] end,
          set = function(info, value)
              if value == true then
                for key, entry in pairs(self.db.profile.spells.combo[myClass][spec]) do
                  if type(entry) == "table" then
                    entry.enabled = false
                  else
                    self.db.profile.spells.combo[myClass][spec][key] = false
                  end
                end
              end
              self.db.profile.spells.combo[myClass][spec][index] = value
              
              -- Update tracker
              X:UpdateComboTracker()
            end, 
        }
      end
      
      offset = offset + 1
    end
  end
  
  addon.options.args["Frames"].args["class"].args["tracker"] = comboSpells
  
  X.LOADED_COMBO_POINTS_OPTIONS = true
  
  X:UpdateComboTracker()
end

function X:UpdateComboTracker()
  local myClass, mySpec = X.player.class, X.player.spec
  X.TrackingEntry = nil
  
  if not mySpec or mySpec < 1 then return end  -- under Level 10 probably, I don't know what to do :P

  for i, entry in pairs(X.db.profile.spells.combo[myClass][mySpec]) do
    if type(entry) == "table" and entry.enabled then
      X.TrackingEntry = entry
    end
  end
  
  X:QuickClassFrameUpdate()
end


-- Unused for now
function X:OnEnable() end
function X:OnDisable() end

-- This allows us to create our config dialog
local AC = LibStub('AceConfig-3.0')
local ACD = LibStub('AceConfigDialog-3.0')
local ACR = LibStub('AceConfigRegistry-3.0')

-- Register the Options
ACD:SetDefaultSize(AddonName, 800, 550)
AC:RegisterOptionsTable(AddonName, addon.options)
AC:RegisterOptionsTable(AddonName.."Blizzard", X.blizzardOptions)
ACD:AddToBlizOptions(AddonName.."Blizzard", "|cffFF0000x|rCT+")


-- Register Slash Commands
X:RegisterChatCommand('xct', 'OpenXCTCommand')

-- Process the slash command ('input' contains whatever follows the slash command)
function X:OpenXCTCommand(input)
  if string_lower(input):match('lock') then
    if X.configuring then
      X:SaveAllFrames()
      X.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  Frames have been saved. Please fasten your seat belts.")
    else
      X.StartConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  You are now free to move about the cabin.")
      print("      |cffFF0000/xct lock|r      - Saves your frames")
      print("      |cffFF0000/xct cancel|r  - Cancels all your recent frame movements")
    end
    
    -- return before you can do anything else
    return
  end
  
  if string_lower(input):match('cancel') then
    if X.configuring then
      X:UpdateFrames();
      X.EndConfigMode()
      print("|cffFF0000x|r|cffFFFF00CT+|r  canceled frame move.")
    else
      print("|cffFF0000x|r|cffFFFF00CT+|r  There is nothing to cancel.")
    end
    return
  end
  
  if string_lower(input) == 'help' then
    print("|cffFF0000x|r|cffFFFF00CT+|r  Commands:")
    print("      |cffFF0000/xct lock|r - Locks and unlocks the frame movers.")
    return
  end
  
  if string_lower(input):match('track %w+') then
    local unit = string_lower(input):match('%s(%w+)')
    
    local name = UnitName(unit)
    
    if not name then
      X.player.unit = ""
    else
      X.player.unit = "custom"
      CombatTextSetActiveUnit(unit)
    end
    
    X:UpdatePlayer()
    print("|cffFF0000x|r|cffFFFF00CT+|r Tracking Unit:", name or "default")
    
    return
  end
  
  -- Open/Close the config menu
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  if not X.configuring then
    ACD[mode](ACD, AddonName)
  end
end

-- Register Slash Commands
X:RegisterChatCommand('track', 'TrackXCTCommand')
function X:TrackXCTCommand(input)
  local name = UnitName("target")
    
  if not name then
    X.player.unit = ""
  else
    X.player.unit = "custom"
    CombatTextSetActiveUnit("target")
  end
  
  X:UpdatePlayer()
  print("|cffFF0000x|r|cffFFFF00CT+|r Tracking Unit:", name or "default")
end
