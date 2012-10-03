-- this file handles updating the frame settings and anything that changes the UI frames themselves
local ADDON_NAME, addon = ...

local LSM = LibStub("LibSharedMedia-3.0");
local ssub = string.sub

-- Shorten my handle
local x = addon.engine

-- store my frames
x.frames = { }

-- Static frame lookup
local frameIndex = {
  [1] = "general",
  [2] = "outgoing",
  [3] = "critical",
  [4] = "damage",
  [5] = "healing",
  [6] = "power",
  [7] = "procs",
  [8] = "loot",
}

function x:UpdateFrames()
  for framename, settings in pairs(x.db.profile.frames) do
    local f = nil
    
    -- Create the frame (or retrieve it)
    if x.frames[framename] then
      f = CreateFrame("ScrollingMessageFrame", "xCT"..framename, UIParent)
    else
      f = x.frames[framename]
    end
    
    --TODO: add time visible
    f:SetTimeVisible(3)
    
    -- TODO: add max lines
    f:SetMaxLines(64)
    f:SetSpacing(2)
    
    -- Set the position
    f:ClearAllPoints()
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetMinResize(64, 64)
    f:SetMaxResize(768, 768)
    f:SetShadowColor(0, 0, 0, 0)
    f:SetWidth(x.db.profile.frames[framename].Width)
    f:SetHeight(x.db.profile.frames[framename].Height)
    f:SetPoint("CENTER", x.db.profile.frames[framename].X, x.db.profile.frames[framename].Y)
    f:SetClampedToScreen(true)
    f:SetClampRectInsets(0, 0, x.db.profile.frames[framename].fontSize, 0)
    
    
    -- Insert Direction
    if x.db.profile.frames[framename].insertText then
      f:SetInsertMode(x.db.profile.frames[framename].insertText)
    end
    
    -- Font Template
    f:SetFont(LSM:Fetch("font", x.db.profile.frames[framename].font), x.db.profile.frames[framename].fontSize, ssub(x.db.profile.frames[framename].fontOutline, 2))
    if x.db.profile.frames[framename].fontJustify then
      f:SetJustifyH(x.db.profile.frames[framename].fontJustify)
    end
    
    -- ==================================================
    -- Frame Output Attributes
    -- ==================================================
    f.frameEnabled = x.db.profile.frames[framename].enabled
    f.secondaryFrame = x.db.profile.frames[framename].secondaryFrame
    if not x.db.profile.frames[framename].autoColor then
      f.forceColor = x.db.profile.frames[framename].fontColor
    else
      f.forceColor = nil
    end
    
    -- ==================================================
    -- Frame Specific Properties
    -- ==================================================
    if framename == "class" then
      f:SetMaxLines(1)
      f:SetFading(false)
    end
    
    x.frames[framename] = f
  end

end


function x:AddMessage(framename, message, colorname)
  local frame = x.frames[framename]
  local secondFrame = x.frames[frameIndex[f.secondaryFrame]]
  
  if frame then
    -- Load the color
    local r, g, b = 1, 1, 1
    if type(colorname) == table then
      r, g, b = unpack(colorname)
    else
      if not x.colors[colorname] then
        print("xct says there is no color named:", colorname)
      else
        r, g, b = unpack(x.colors[colorname])
      end
    end

    -- make sure the frame is enabled
    if frame.frameEnabled then
      if frame.forceColor then      -- check for forced color
        r, g, b = unpack(frame.forceColor)
      end
      frame:AddMessage(message, r, g, b)
    elseif secondFrame and secondFrame.frameEnabled then 
      if secondFrame.forceColor then      -- check for forced color
        r, g, b = unpack(frame.forceColor)
      end
      secondFrame:AddMessage(message, r, g, b)
    end
  
  else
    print("xct+ frame name not found:", framename)
  end
end