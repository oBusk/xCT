-- this file handles updating the frame settings and anything that changes the UI frames themselves
local ADDON_NAME, addon = ...

local LSM = LibStub("LibSharedMedia-3.0");
local ssub = string.sub

-- Shorten my handle
local x = addon.engine

x.frames = { }

function x:UpdateFrames()
  for framename, settings in pairs(x.db.profile.frames) do
    local f = nil
    
    -- Create the frame (or retrieve it)
    if not _G["xCT"..framename] then
      f = CreateFrame("ScrollingMessageFrame", "xCT"..framename, UIParent)
    else
      f = _G["xCT"..framename]
    end
    
    f:SetShadowColor(0, 0, 0, 0)
    --print(framename, "font", x.db.profile.frames[framename].font)
    --print(framename, "fontSize", x.db.profile.frames[framename].fontSize)
    --print(framename, "fontOutline", ssub(x.db.profile.frames[framename].fontOutline, 2))
    --print()
    f:SetFont(LSM:Fetch("font", x.db.profile.frames[framename].font), x.db.profile.frames[framename].fontSize, ssub(x.db.profile.frames[framename].fontOutline, 2))
    
    if x.db.profile.frames[framename].fontJustify then
      f:SetJustifyH(x.db.profile.frames[framename].fontJustify)
    end
    
    --TODO: add time visible
    f:SetTimeVisible(3)
    
    f:SetSpacing(2)
    
    -- TODO: add max lines
    f:SetMaxLines(64)
    
    -- Set the position
    f:ClearAllPoints()
    f:SetWidth(x.db.profile.frames[framename].Width)
    f:SetHeight(x.db.profile.frames[framename].Height)
    f:SetPoint("CENTER", x.db.profile.frames[framename].X, x.db.profile.frames[framename].Y)
    
    -- clamp to screen settings
    f:SetClampedToScreen(true)
    f:SetClampRectInsets(0, 0, x.db.profile.frames[framename].fontSize, 0)
    
    if x.db.profile.frames[framename].insertText then
      f:SetInsertMode(x.db.profile.frames[framename].insertText)
    end
    
    f:SetMinResize(64, 64)
    f:SetMaxResize(768, 768)
    
    f:SetMovable(true)
    f:SetResizable(true)
    
    -- SPECIAL OPTIONS:
    if framename == "class" then
      f:SetMaxLines(1)
      f:SetFading(false)
    end

    x.frames[framename] = f
    
  end

end