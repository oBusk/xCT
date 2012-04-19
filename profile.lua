local ADDON_NAME, engine = ...

if (engine.config["DisableProfileManager"]) then return end

local loadingFrame = CreateFrame("Frame")
loadingFrame:RegisterEvent("ADDON_LOADED")
loadingFrame:SetScript("OnEvent", function(self, event, name)
    --print("OnEvent: ADDON_LOADED -", self, event, name)
    if name == ADDON_NAME then
    
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
  UIDropDownMenu_SetSelectedID(DropDownMenuTest, currentIndex)
end
 
local function initialize(self, level)
   local info = UIDropDownMenu_CreateInfo()
   for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo()
      info.text = v
      info.value = v
      info.func = OnClick
      UIDropDownMenu_AddButton(info, level)
   end
end

UIDropDownMenu_Initialize(DropDownMenuTest, initialize)
UIDropDownMenu_SetWidth(DropDownMenuTest, 100);
UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 124)
UIDropDownMenu_SetSelectedID(DropDownMenuTest, 1)
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
xCTNewProfileButton:SetPoint("TOPLEFT", 170, -400)
xCTNewProfileButton:Size(100, 26)
xCTNewProfileButton:SetText("New Profile")
xCTNewProfileButton:Show()

if not xCTRemoveProfileButton then
  CreateFrame("Button", "xCTRemoveProfileButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
end

xCTRemoveProfileButton:ClearAllPoints()
xCTRemoveProfileButton:SetPoint("TOPLEFT", 286, -400)
xCTRemoveProfileButton:Size(100, 26)
xCTRemoveProfileButton:SetText("Remove Profile")
xCTRemoveProfileButton:Show()

StaticPopupDialogs["XCT_NEWPROFILE"] = {
  text          = "A frame profile will remember your frame positions and its enabled state, but not your settings.\n\n\nCreate a new |cffFF0000x|rCT|cffFFFF00+|r profile named:",
  hasEditBox    = 1,
  maxLetters    = 120,
  editBoxWidth  = 350,
  timeout       = 0,
  whileDead     = 1,
  OnShow = function(self)
    self.editBox:SetText("Dandruff-Whisperwind");
    self.editBox:SetFocus();
    self.editBox:HighlightText();
  end,
  
  button1       = ACCEPT,
  button2       = CANCEL,
  OnAccept      = function() print("Accepted") end,
  OnCancel      = function() print("Cancel") end,
  hideOnEscape  = true,
}

StaticPopupDialogs["XCT_REMOVEPROFILE"] = {
  text          = "Are you certain you want to delete",
  timeout       = 0,
  whileDead     = 1,
  showAlert     = 1,
  OnShow = function(self)
    self.text:SetText("Are you sure you want to delete: "..items[UIDropDownMenu_GetSelectedID(DropDownMenuTest)])
  end,
  
  button1       = ACCEPT,
  button2       = CANCEL,
  OnAccept      = function() print("Delete Accepted") end,
  OnCancel      = function() print("Delete Cancel") end,
  hideOnEscape  = true,
}

xCTNewProfileButton:SetScript("OnClick", function(self)
  StaticPopup_Show("XCT_NEWPROFILE")
end)

xCTRemoveProfileButton:SetScript("OnClick", function(self)
  StaticPopup_Show("XCT_REMOVEPROFILE")
end)

