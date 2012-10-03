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

-- Show Version Number
local fsVersion = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
fsVersion:SetFont(defaultFont, 11)
fsVersion:SetText("|cff5555FFPowered By:|r \124cffFF0000x\124rCT\124cffFFFFFF+\124r (Version "
  .. GetAddOnMetadata("xCT", "Version")..")")
fsVersion:SetPoint("BOTTOMRIGHT", -8, 8)

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