--[[

The Engine

  The engine is meant to be the central part of the program.  Used to load variables,
  tell modules when to do stuff, and to interact between Blizzard and xCT.
  
   - Load Saved Variable
   - Init xCT
   - Register Combat Events
   - Relay events
   
]]


-- The Engine is mainly to initiate defaults after saved variables get loaded
local ADDON_NAME, xCT = ...

-- Global Access --
  xCTGlobal = xCT
-------------------

xCT.Event:CreateEvent("OnLoaded")


function xCT:Init()
  -- Setup C Vars
  xCT.DebugPrint("Setting up C Vars")
  xCT:SetNonBlizzardCVars()
  
  -- Universal First Run
  if not xCTSavedVariables then
    xCT.DebugPrint("Universal First Run")
    xCTSavedVariables = xCT.ProfileManager.SavedVariables
  end
  
  -- Add the saved variables to the manager
  xCT.DebugPrint("Loading Saved Vars into Addon")
  xCT.ProfileManager.SavedVariables = xCTSavedVariables
  
  -- Variables loaded
  xCT.DebugPrint("Calling Event:OnLoaded()")
  xCT.Event:InvokeEvent("OnLoaded")
  
  -- Load the player's profile
  xCT.DebugPrint("Loading the Player's Profile")
  xCT.ProfileManager:LoadPlayersProfile()
  
  -- Create the frames
  xCT.DebugPrint("Create the xCT Frames")
  xCT.Frames:LoadAllFrames()
  
  xCT.Print("is now your default Combat Text handler.")
end


-- Load Saved Variables
local savedVariables = CreateFrame("Frame")
savedVariables:RegisterEvent("ADDON_LOADED")
savedVariables:SetScript("OnEvent", function(self, event, addon)
  if addon == ADDON_NAME then
    
  end
end)