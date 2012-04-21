local ADDON_NAME, engine = ...

if (engine.config["DisableProfileManager"]) then return end

engine.default_profile = {
  Name = "Default",
  Frames = {
    -- <Critical>
    ["crit"] = {
      X = 128,
      Y = 0,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </Critical>
    -- <Damage>
    ["dmg"] = {
      X = -320,
      Y = 0,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </Damage>
    -- <General>
    ["gen"] = {
      X = 0,
      Y = 192,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </General>
    -- <Healing>
    ["heal"] = {
      X = -448,
      Y = 0,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </Healing>
    -- <Loot>
    ["loot"] = {
      X = 0,
      Y = -192,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </Loot>
    -- <Outgoing>
    ["done"] = {
      X = 320,
      Y = 0,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </Outgoing>
    -- <PowerGains>
    ["pwr"] = {
      X = 448,
      Y = 0,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </PowerGains>
    -- <SpellProcs>
    ["proc"] = {
      X = -128,
      Y = 0,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </SpellProcs>
    -- <ComboPoints>
    ["class"] = {
      X = 0,
      Y = -512,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </ComboPoints>
  },
}

function engine:Install()
  xCTPlus_SavedVars = {
    Profiles = {
      [1] = self.default_profile,
    },
    SelectedProfile = 1,
  }
end

local loadingFrame = CreateFrame("Frame")
loadingFrame:RegisterEvent("ADDON_LOADED")
loadingFrame:SetScript("OnEvent", function(self, event, name)
    if name == ADDON_NAME then
      if not xCTPlus_SavedVars then engine:Install() end
    
      -- init profile drop down
      UIDropDownMenu_Initialize(DropDownMenuTest, engine.DropBox_Initialize)
      UIDropDownMenu_SetSelectedID(DropDownMenuTest, xCTPlus_SavedVars.SelectedProfile)
      
      --engine:LoadFrames()
      
      local enteringWorld = CreateFrame("Frame")
      enteringWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
      enteringWorld:SetScript("OnEvent", engine.LoadFrames)
      
      -- If we are using the default profile
      if UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 1 then   -- if Defualt Profile Selected
        xCTRemoveProfileButton:Disable()
      end
    end
  end)



-- =================================================================================================
-- =================================================================================================
if not DropDownMenuTest then
   CreateFrame("Button", "DropDownMenuTest", InterfaceOptionsCombatTextPanel, "UIDropDownMenuTemplate")
end
 
DropDownMenuTest:ClearAllPoints()
DropDownMenuTest:SetPoint("TOPLEFT", 4, -400)
DropDownMenuTest:Size(300, 26)
DropDownMenuTest:Show()
 
 
local items = {
   "Default",
}
 
local function OnClick(self)
  local currentIndex = self:GetID()
  if (currentIndex == 1) then
    xCTRemoveProfileButton:Disable()
  else
    xCTRemoveProfileButton:Enable()
  end
  xCTPlus_SavedVars.SelectedProfile = currentIndex
  UIDropDownMenu_SetSelectedID(DropDownMenuTest, currentIndex)
  
  engine:LoadFrames()
end
 
function engine.DropBox_Initialize(self, level)
   local info = UIDropDownMenu_CreateInfo()
   for index, profile in ipairs(xCTPlus_SavedVars.Profiles) do
      info = UIDropDownMenu_CreateInfo()
      info.text = profile.Name
      info.value = profile.Name
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

UIDropDownMenu_SetWidth(DropDownMenuTest, 200);
UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 224)
UIDropDownMenu_JustifyText(DropDownMenuTest, "LEFT")

-- =================================================================================================
-- =================================================================================================
local defaultFont, defaultSize = InterfaceOptionsCombatTextPanelTargetEffectsText:GetFont()

local fsProfileTitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
  fsProfileTitle:SetTextColor(1.00, 0.82, 0.00, 1.00)
  fsProfileTitle:SetFont(defaultFont, defaultSize + 6)
  fsProfileTitle:SetText("xCT+ Frame Manager")
  fsProfileTitle:SetPoint("TOPLEFT", 16, -356)
  
local fsProfileSubtitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
  fsProfileSubtitle:SetTextColor(0.90, 0.90, 0.00, 1.00)
  fsProfileSubtitle:SetFont(defaultFont, defaultSize)
  fsProfileSubtitle:SetText("Frame Profiles")
  fsProfileSubtitle:SetPoint("TOPLEFT", 20, -382)
  
-- =================================================================================================
-- =================================================================================================
if not xCTNewProfileButton then
  CreateFrame("Button", "xCTNewProfileButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
end

xCTNewProfileButton:ClearAllPoints()
xCTNewProfileButton:SetPoint("TOPLEFT", 242, -400)
xCTNewProfileButton:Size(100, 26)
xCTNewProfileButton:SetText(CREATE)
xCTNewProfileButton:Show()

if not xCTRemoveProfileButton then
  CreateFrame("Button", "xCTRemoveProfileButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
end

xCTRemoveProfileButton:ClearAllPoints()
xCTRemoveProfileButton:SetPoint("TOPLEFT", 344, -400)
xCTRemoveProfileButton:Size(100, 26)
xCTRemoveProfileButton:SetText(CALENDAR_VIEW_EVENT_REMOVE)
xCTRemoveProfileButton:Show()

StaticPopupDialogs["XCT_NEWPROFILE"] = {
  text          = "|cffFFFF00Creating New Profile|r\n\nA frame profile will remember your frame positions and their enabled states, but it will not save your settings.\n\n|cff5555FFProfile Name:|r",
  hasEditBox    = 1,
  maxLetters    = 120,
  editBoxWidth  = 350,
  timeout       = 0,
  whileDead     = 1,
  OnShow = function(self)
    self.editBox:SetText(GetUnitName("player").."-"..GetRealmName());
    self.editBox:SetFocus();
    self.editBox:HighlightText();
  end,
  
  button1       = ACCEPT,
  button2       = CANCEL,
  OnAccept      = function(self)
      local newProfileName = self.editBox:GetText()
      engine:CreateNewProfile(newProfileName)
    end,
  OnCancel      = function() end,
  hideOnEscape  = true,
  
  -- Taint work around
  preferredIndex = 3,
}

-- Index 3 not skinned
-- http://www.tukui.org/code/view.php?id=DANDRUFF200412053929
StaticPopupDialogs["XCT_REMOVEPROFILE"] = {
  text          = "Are you certain you want to delete",
  timeout       = 0,
  whileDead     = 1,
  showAlert     = 1,
  OnShow = function(self)
    local currentIndex = UIDropDownMenu_GetSelectedID(DropDownMenuTest)
    local currentProfileName = xCTPlus_SavedVars.Profiles[currentIndex].Name
    self.text:SetText("Are you sure you want to delete: " .. currentProfileName)
  end,
  
  button1       = ACCEPT,
  button2       = CANCEL,
  OnAccept      = function()
      local currentIndex = UIDropDownMenu_GetSelectedID(DropDownMenuTest)
      engine:RemoveProfile(currentIndex)
      engine:LoadFrames()
    end,
  OnCancel      = function() end,
  hideOnEscape  = true,
  
  -- Taint work around
  preferredIndex = 3,
}

xCTNewProfileButton:SetScript("OnClick", function(self)
  StaticPopup_Show("XCT_NEWPROFILE")
end)

xCTRemoveProfileButton:SetScript("OnClick", function(self)
  StaticPopup_Show("XCT_REMOVEPROFILE")
end)

function engine:CreateTable(fromTable)
  local t = { }
  for i, v in pairs(fromTable) do
    if type(v) == "table" then
      t[i] = self:CreateTable(v)
    else
      t[i] = v
    end
  end
  return t
end

function engine:CreateNewProfile(profileName)
  if profileName == "Default" then
    engine.pr("cannot create a profile named: 'Default'")
    return
  end

  local newProfile = engine:CreateTable(engine.default_profile)
  newProfile.Name = profileName
  
  table.insert(xCTPlus_SavedVars.Profiles, newProfile)
  xCTPlus_SavedVars.SelectedProfile = #xCTPlus_SavedVars.Profiles
  
  UIDropDownMenu_Initialize(DropDownMenuTest, engine.DropBox_Initialize)
  UIDropDownMenu_SetSelectedID(DropDownMenuTest, xCTPlus_SavedVars.SelectedProfile)
  xCTRemoveProfileButton:Enable()
end

function engine:RemoveProfile(profileIndex)
  table.remove(xCTPlus_SavedVars.Profiles, profileIndex)
  xCTPlus_SavedVars.SelectedProfile = 1

  xCTRemoveProfileButton:Disable()
  UIDropDownMenu_Initialize(DropDownMenuTest, engine.DropBox_Initialize)
  UIDropDownMenu_SetSelectedID(DropDownMenuTest, xCTPlus_SavedVars.SelectedProfile)
end

function engine:SaveFrames()
  engine.pr("frames saved.")
  
  local selectedIndex = xCTPlus_SavedVars.SelectedProfile
  local currentProfile = xCTPlus_SavedVars.Profiles[selectedIndex]
  
  for name, config in pairs(currentProfile.Frames) do
    self:SaveFrame(name, config)
  end
  
end

function engine:SaveFrame(frameName, frameConfig)
  local frame = _G["xCT"..frameName]

  local width   = frame:GetWidth()
  local height  = frame:GetHeight()
  frameConfig.Width   = width
  frameConfig.Height  = height
  
  local ResX, ResY = GetScreenWidth(), GetScreenHeight()
  local midX, midY = ResX / 2, ResY / 2
  
  local x, y = math.floor(frame:GetLeft() - midX + 1), math.floor(frame:GetTop() - midY + 1)
  
  frameConfig.Justify = "CENTER"
  frameConfig.X       = x + (width / 2)
  frameConfig.Y       = y --+ (height / 2)
end

function engine:LoadFrames()
  local selectedIndex = xCTPlus_SavedVars.SelectedProfile
  local currentProfile = xCTPlus_SavedVars.Profiles[selectedIndex]
  
  for name, config in pairs(currentProfile.Frames) do
    engine:LoadFrame(name, config)
  end
  
end

function engine:LoadFrame(frameName, frameConfig)
  local frame = _G["xCT"..frameName]

  frame:ClearAllPoints()
  frame:SetHeight(frameConfig.Height)
  frame:SetWidth(frameConfig.Width)
  frame:SetPoint(frameConfig.Justify, frameConfig.X, frameConfig.Y)
end

