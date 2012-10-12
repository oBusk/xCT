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
local x = addon.engine

-- Intercept Messages Sent by other Add-Ons that use CombatText_AddMessage
hooksecurefunc('CombatText_AddMessage', function(message, scrollFunction, r, g, b, displayType, isStaggered)
  local lastEntry = COMBAT_TEXT_TO_ANIMATE[ #COMBAT_TEXT_TO_ANIMATE ]
  CombatText_RemoveMessage(lastEntry)
  x:AddMessage("general", message, {r, g, b})
end)

-- Move the options up
local defaultFont, defaultSize = InterfaceOptionsCombatTextPanelTargetEffectsText:GetFont()

-- Show Combat Options Title
local fsTitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
fsTitle:SetTextColor(1.00, 0.82, 0.00, 1.00)
fsTitle:SetFont(defaultFont, defaultSize + 6)
fsTitle:SetText("xCT+ Combat Text Options")
fsTitle:SetPoint("TOPLEFT", 16, -90)

-- Move the Effects and Floating Options
InterfaceOptionsCombatTextPanelTargetEffects:ClearAllPoints()
InterfaceOptionsCombatTextPanelTargetEffects:SetPoint("TOPLEFT", 314, -132)
InterfaceOptionsCombatTextPanelEnableFCT:ClearAllPoints()
InterfaceOptionsCombatTextPanelEnableFCT:SetPoint("TOPLEFT", 18, -132)

-- Hide invalid Objects
InterfaceOptionsCombatTextPanelTargetDamage:Hide()
InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
InterfaceOptionsCombatTextPanelPetDamage:Hide()
InterfaceOptionsCombatTextPanelHealing:Hide()
SetCVar("CombatLogPeriodicSpells", 0)
SetCVar("PetMeleeDamage", 0)
SetCVar("CombatDamage", 0)
SetCVar("CombatHealing", 0)

-- Turn off Blizzard's Combat Text
CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad", nil)
CombatText:SetScript("OnEvent", nil)
CombatText:SetScript("OnUpdate", nil)

-- Direction does NOT work with xCT+ at all
InterfaceOptionsCombatTextPanelFCTDropDown:Hide()


-- Create a button to delete profiles
if not xCTCombatTextConfigButton then
  CreateFrame("Button", "xCTCombatTextConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate")
end

xCTCombatTextConfigButton:ClearAllPoints()
xCTCombatTextConfigButton:SetPoint("TOPLEFT", 400, -90)
xCTCombatTextConfigButton:SetSize(180, 26)
xCTCombatTextConfigButton:SetText("Show more xCT+ Options")
xCTCombatTextConfigButton:Show()
xCTCombatTextConfigButton:SetScript("OnClick", function(self)
  --if not x.configuring then
    InterfaceOptionsFrameOkay:Click()
    LibStub("AceConfigDialog-3.0"):Open(ADDON_NAME)
  --end
end)


