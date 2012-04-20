local ADDON_NAME, engine = ...

if (engine.config["DisableProfileManager"]) then return end

engine.default_profile = {
  Name = "Default",
  Frames = {
    -- <Critical>
    ["crit"] = {
      Enabled = true,
      Secondary = nil,
      Label = TEXT_MODE_A_STRING_RESULT_CRITICAL:match("%a+"),
      LabelColor = { 1.00, 0.50, 0.00, 0.90 },
      Justify = "RIGHT",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = 128,
        Y = 0,
      },
      Width = 256,
      Height = 128,
    }, -- </Critical>
    -- <Damage>
    ["dmg"] = {
      Enabled = true,
      Secondary = nil,
      Label = DAMAGE,
      LabelColor = { 1.00, 0.10, 0.10, 0.90 },
      Justify = "LEFT",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = -320,
        Y = 0,
      },
      Width = 128,
      Height = 128,
    }, -- </Damage>
    -- <General>
    ["gen"] = {
      Enabled = true,
      Secondary = nil,
      Label = COMBAT_TEXT_LABEL,
      LabelColor = { 0.10, 0.10, 1.00, 0.90 },
      Justify = "CENTER",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = 0,
        Y = 192,
      },
      Width = 256,
      Height = 128,
    }, -- </General>
    -- <Healing>
    ["heal"] = {
      Enabled = true,
      Secondary = nil,
      Label = SHOW_COMBAT_HEALING,
      LabelColor = { 0.10, 1.00, 0.10, 0.90 },
      Justify = "RIGHT",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = -448,
        Y = 0,
      },
      Width = 128,
      Height = 128,
    }, -- </Healing>
    -- <Loot>
    ["loot"] = {
      Enabled = true,
      Secondary = nil,
      Label = LOOT,
      LabelColor = { 1.00, 1.00, 1.00, 0.90 },
      Justify = "CENTER",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = 0,
        Y = -192,
      },
      Width = 256,
      Height = 128,
    }, -- </Loot>
    -- <Outgoing>
    ["done"] = {
      Enabled = true,
      Secondary = nil,
      Label = SCORE_DAMAGE_DONE.." / "..SCORE_HEALING_DONE,
      LabelColor = { 1.00, 1.00, 0.00, 0.90 },
      Justify = "RIGHT",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = 320,
        Y = 0,
      },
      Width = 128,
      Height = 128,
    }, -- </Outgoing>
    -- <PowerGains>
    ["pwr"] = {
      Enabled = true,
      Secondary = nil,
      Label = MANA.." ("..select(2, UnitPowerType("player"))..")",
      LabelColor = { 0.80, 0.10, 1.00, 0.90 },
      Justify = "RIGHT",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = 448,
        Y = 0,
      },
      Width = 128,
      Height = 128,
    }, -- </PowerGains>
    -- <SpellProcs>
    ["proc"] = {
      Enabled = true,
      Secondary = nil,
      Label = DISPLAY_SPELL_ALERTS,
      LabelColor = { 1.00, 0.60, 0.30, 0.90 },
      Justify = "CENTER",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = -128,
        Y = 0,
      },
      Width = 256,
      Height = 128,
    }, -- </SpellProcs>
    -- <ComboPoints>
    ["class"] = {
      Enabled = true,
      Secondary = nil,
      Label = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT,
      LabelColor = { 1.00, 0.60, 0.30, 0.90 },
      Justify = "CENTER",
      Font = {
        Size = 16,
        Name = "Interface\\Addons\\xCT+\\HOOGE.TTF",
        Style = "OUTLINE",
      },
      Point = {
        Relative = "Center",
        X = -128,
        Y = 0,
      },
      Width = 256,
      Height = 128,
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
      --print("Accepted: Creating new profile named '".. newProfileName.."'")
      
      engine:CreateNewProfile(newProfileName)
    end,
  OnCancel      = function() print("Cancel") end,
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
    end,
  OnCancel      = function() print("Delete Cancel") end,
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

function engine:CreateNewProfile(profileName)
  if profileName == "Default" then
    engine.pr("cannot create a profile named: 'Default'")
    return
  end

  table.insert(xCTPlus_SavedVars.Profiles, { Name = profileName })
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

