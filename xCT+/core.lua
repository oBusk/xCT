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

local sgsub, pairs, type = string.gsub, pairs, type
xCT_Plus = addon.engine
local X = xCT_Plus

-- =====================================================
-- inv_tcopy(
--    t1,  [table] - Check this table (edited)
--    t2,  [table] - against this table (NOT edited)
--  )
--    Check table 1 against table 2. if a value is found
--  that is not defined in table 1, copy the default
--  value from table 2. Will also examine "subtables".
-- =====================================================
local function inv_tcopy(t1, t2)
  for k, v in pairs(t2) do
    if t1[k] == nil then -- found new key
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
  self.db:GetCurrentProfile()
  
  addon.options.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
  
  if not self.db.profile.frames then
    self.db.profile.frames = { }
  end
  
  inv_tcopy(self.db.profile.frames, addon.DefaultProfile.frames)
  
  if not self.db.profile.spells then
    self.db.profile.spells = { }
  end

  inv_tcopy(self.db.profile.spells, addon.DefaultProfile.spells)
  
  X:UpdatePlayer()
  X:UpdateFrames()
  X:UpdateCombatTextEvents(true)
end

-- Unused for now
function X:OnEnable() end
function X:OnDisable() end

-- This allows us to create our config dialog
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

-- Register the Options
ACD:SetDefaultSize(AddonName, 800, 550)
AC:RegisterOptionsTable(AddonName, addon.options)

-- Register Slash Commands
X:RegisterChatCommand("xct", "OpenXCTCommand")

-- Process the slash command ('input' contains whatever follows the slash command)
function X:OpenXCTCommand(input)
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  if not X.configuring then
    ACD[mode](ACD, AddonName)
  end
end

