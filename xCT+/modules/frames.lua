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

function x:UpdateFrames(specificFrame)

  for framename, settings in pairs(x.db.profile.frames) do
    if specificFrame and specificFrame == framename or not specificFrame then
      local f = nil

      -- Create the frame (or retrieve it)
      if x.frames[framename] then
        f = x.frames[framename]
      else
        f = CreateFrame("ScrollingMessageFrame", "xCT"..framename, UIParent)
      end
      
      --TODO: add time visible
      f:SetTimeVisible(3)
      
      -- TODO: add max lines
      
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
      
      -- scrolling
      if x.db.profile.frames[framename].scrollableLines then
        f:SetMaxLines(x.db.profile.frames[framename].scrollableLines)
        if x.db.profile.frames[framename].enableScrollable then
          f:EnableMouseWheel(true)
          f:SetScript("OnMouseWheel", function(self, delta)
              if delta > 0 then
                self:ScrollUp()
              elseif delta < 0 then
                self:ScrollDown()
              end
            end)
        else
          f:EnableMouseWheel(false)
          f:SetScript("OnMouseWheel", nil)
        end
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

end


function x:AddMessage(framename, message, colorname)
  local frame = x.frames[framename]
  local frameOptions = x.db.profile.frames[framename]
  
  -- Make sure we have a valid frame
  if not frameOptions then print("xct+ frame name not found:", framename) return end
  
  local secondFrameName = frameIndex[frameOptions.secondaryFrame]
  local secondFrame = x.frames[secondFrameName]
  local secondFrameOptions = x.db.profile.frames[secondFrameName]
  
  if frame then
    -- Load the color
    local r, g, b = 1, 1, 1
    if type(colorname) == "table" then
      r, g, b = unpack(colorname)
    else
      if not x.colors[colorname] then
        print("xct+ says there is no color named:", colorname)
      else
        r, g, b = unpack(x.colors[colorname])
      end
    end
    
    -- make sure the frame is enabled
    if frameOptions.enabledFrame then
      if frameOptions.customColor then      -- check for forced color
        r, g, b = unpack(frameOptions.fontColor or {1, 1, 1})
      end
      frame:AddMessage(message, r, g, b)
    elseif secondFrame and secondFrameOptions.enabledFrame then 
      if secondFrameOptions.customColor then      -- check for forced color
        r, g, b = unpack(secondFrameOptions.fontColor or {1, 1, 1})
      end
      secondFrame:AddMessage(message, r, g, b)
    end
  end
end