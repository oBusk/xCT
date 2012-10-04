local ADDON_NAME, addon = ...

local x = addon.engine
x.BLANK_ICON = "Interface\\Addons\\" .. ADDON_NAME .. "\\media\\blank"


local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("font", "HOOGE (xCT)", [[Interface\AddOns\]] .. ADDON_NAME .. [[\media\HOOGE.TTF]], LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)