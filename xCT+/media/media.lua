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

-- Textures
local x = addon.engine
x.BLANK_ICON = "Interface\\AddOns\\" .. ADDON_NAME .. "\\media\\blank"
x.new = "\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1\124t"

-- Fonts
local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "HOOGE (xCT)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\HOOGE.TTF]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)