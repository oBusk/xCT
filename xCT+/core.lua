-- Get Addon's name and Blizzard's Addon Stub
local AddonName, addon = ...

local sgsub = string.gsub

-- Load AceStuff
addon.engine.DefaultProfile = addon.DefaultProfile

-- Give a Global handle
xCT_Plus = addon.engine

-- Shorten my handle
local X = xCT_Plus

local blankTable = {}

-- invisible copy (orig table, lookup table)
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
  addon.options.args["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

  -- Check Frames
  self.db:GetCurrentProfile()

  if not self.db.profile.frames then
    self.db.profile.frames = { }
  end
  
  inv_tcopy(self.db.profile.frames, self.DefaultProfile.frames)
  
  X:UpdatePlayer()
  X:UpdateFrames()
  X:UpdateCombatTextEvents(true)
  
end

function X:OnEnable()
  -- Called when the addon is enabled
end

function X:OnDisable()
  -- Called when the addon is disabled
end



-- This allows us to create our config dialog
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")

ACD:SetDefaultSize(AddonName, 800, 550)

-- Register the Options
AC:RegisterOptionsTable(AddonName, addon.options)

-- Register Slash Commands
X:RegisterChatCommand("xct", "OpenXCTCommand")

-- Process the slash command ('input' contains whatever follows the slash command)
function X:OpenXCTCommand(input)
  if (input == "r") then
    xCTSavedDB = nil
    ReloadUI()
  end
  
  local mode = 'Close'
  if not ACD.OpenFrames[AddonName] then
    mode = 'Open'
  end
  
  if not X.configuring then
    ACD[mode](ACD, AddonName)
  end
end

