--[[   ____ _____
__  __/ ___|_   _|_
\ \/ / |     | |_| |_
 >  <| |___  | |_   _|
/_/\_\\____| |_| |_|
World of Warcraft (4.3)

Title: xCT+
Author: Dandruff
Version: 3.0.0 beta
Description:
  xCT+ is an extremely lightwight scrolling combat text addon.  It replaces Blizzard's default
scrolling combat text with something that is more concised and organized.  xCT+ is the continuation
of xCT (by Affli) that has been outdated since WoW 4.0.6.

]]

local ADDON_NAME, engine = ...

engine[1] = {} -- Events (Fake)
engine[2] = {} -- Functions
engine[3] = {} -- Options (Global and Loaded Later, No need to unpack)

local xCTEvents, xCT, _ = unpack(engine)

local function t_copy(copy, lookup)
  local temp = { }
  for k, v in pairs(copy) do
    if type(v) == "table" then
      temp[k] = t_copy(v, lookup and lookup[k] or nil)
    else
      temp[k] = v
    end
  end
  if lookup then
    local tempMT = {
      __index = function(self, key)
        return lookup[key]
      end, }
    setmetatable(temp, tempMT) end
  return temp
end

-- ==============================================================
-- xCT+   Output Functions
-- ==============================================================
function xCT.Print(...)
  print("\124cffFF0000x\124rCT\124cffDDFF55+\124r ", ...)
end

function xCT.Debug(...)
  if XCT_DEBUG then
    xCT.Print(...)
  end
end

-- ==============================================================
-- xCT+   Event Engine
-- ==============================================================
do 
  local Events = {
    ["ChangedProfiles"] = { },
    ["OptionsLoaded"] = { },
    ["FramesLoaded"] = { },
  }
  
  local EventsMT = {                                  -- You cannot create new events
    __newindex = function( _, event, handle)
      if Events[event] ~= nil then
        table.insert(Events[event], handle)
      end
    end,
    __metatable = { },
    __call = function(...)
      local list = { }
      for k, _ in pairs(Events) do
        table.insert(list, k)
      end
      return list
    end,
  }
  setmetatable(xCTEvents, EventsMT)                   -- Set the engine event's metatable
  function xCT.InvokeEvent(event, ...)
    for _, handle in pairs(Events[event]) do
      if type(handle) == "function" then
        handle(event, ...)
      end
    end
  end
end

-- ==============================================================
-- xCT+   Profile Manager
-- ==============================================================
function xCT.CreateProfile(NewProfileName, CopyFromProfile)
  if CopyFromProfile then
    -- Create a new profile as a copy of another
    xCTOptions.Profiles[NewProfileName] = t_copy(xCTOptions.Profiles[CopyFromProfile], xCT.DEFAULT_PROFILE)
    xCTOptions._activeProfile = NewProfileName
  else
    -- new profile already exists
    if xCTOptions.Profiles[NewProfileName] then
      xCTOptions._activeProfile = NewProfileName
    else
      -- create a new profile using the defaults as a template
      xCTOptions.Profiles[NewProfileName] = t_copy(xCT.DEFAULT_PROFILE)
      xCTOptions._activeProfile = NewProfileName
    end
  end
  xCT.ChangeProfile()
end

function xCT.ChangeProfile(NewProfileName)
  if NewProfileName then
    xCTOptions._activeProfile = NewProfileName end
  local ActiveProfile = xCTOptions.Profiles[xCTOptions._activeProfile]
  
  -- Backward Compatibility
  if not getmetatable(ActiveProfile) and xCTOptions._activeProfile ~= "Default" then
    local activeMT = { __index = function(self, key)
        self[key] = xCT.DEFAULT_PROFILE[key]
        return self[key]
      end, }
    setmetatable(ActiveProfile, activeMT)
  end
  
  xCT.ActiveProfile = ActiveProfile
  xCT.InvokeEvent("ChangedProfiles")
end