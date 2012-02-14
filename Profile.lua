local ADDON_NAME, xCT = ...

-- Concept Profile Manager (xCT Saved Vars)
xCT.ProfileManager = {
  SavedVariables = {
    Profiles = { },
    Characters = { },
  }
}

local ProfileManager = xCT.ProfileManager
xCT.Event:CreateEvent("OnProfileLoaded")

-- Create a new profile
function ProfileManager:CreateProfile(profileName)
  if self.SavedVariables.Profiles[profileName] then
    xCT.Print("A Profile named '" .. profileName .. "' already exisits.")
    return
  end
  
  xCT.Print("Creating Profile: '" .. profileName .. "'")

  local profile = {
    ["Options"] = xCT.Utility:CreateTable(xCT.DefaultOptions),
  }
  
  profile.Name = profileName
  self.SavedVariables.Profiles[profileName] = profile
end

function ProfileManager:RemoveProfile(profileName)
  ProfileManager.SavedVariables.Profiles[profileName] = nil
end


function ProfileManager:LoadPlayersProfile()
  local playerName = GetUnitName("player", true)
  
  xCT.DebugPrint("Dumping Saved Vars")
  xCT.DumpSingleTable(self.SavedVariables)
  
  -- Character First Run
  if not self.SavedVariables.Characters[playerName] then
    self:CreateProfile(playerName)
    self.SavedVariables.Characters[playerName] = playerName
  end

  self:LoadProfile(self.SavedVariables.Characters[playerName])
end

-- Loads a profile (invokes 'OnProfileChanged')
function ProfileManager:LoadProfile(profileName)
  if not self.SavedVariables.Profiles[profileName] then
    xCT.DebugPrint("error: no profile named '" .. profileName .. "'")
    return
  end
  
  local oldProfileName
  if xCT.CurrentProfile then
    oldProfileName = xCT.CurrentProfile.Name
  end
  
  xCT.CurrentProfile = self.SavedVariables.Profiles[profileName]
  xCT.Event:InvokeEvent("OnProfileLoaded", profileName, oldProfileName)
end
