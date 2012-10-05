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

-- Static Title Lookup
local frameTitles = {
  ["general"]   = COMBAT_TEXT_LABEL,
  ["outgoing"]  = SCORE_DAMAGE_DONE.." / "..SCORE_HEALING_DONE,
  ["critical"]  = ssub(ssub(TEXT_MODE_A_STRING_RESULT_CRITICAL, "(", ""), ")", ""), -- "(Critical)" --> "Critical"
  ["damage"]    = DAMAGE,
  ["healing"]   = SHOW_COMBAT_HEALING,
  ["power"]     = COMBAT_TEXT_SHOW_ENERGIZE_TEXT,
  ["procs"]     = COMBAT_TEXT_SHOW_REACTIVES_TEXT,
  ["loot"]      = LOOT,
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
      f:SetWidth(settings.Width)
      f:SetHeight(settings.Height)
      f:SetPoint("CENTER", settings.X, settings.Y)
      f:SetClampedToScreen(true)
      f:SetClampRectInsets(0, 0, settings.fontSize, 0)
      
      
      -- Insert Direction
      if settings.insertText then
        f:SetInsertMode(settings.insertText)
      end
      
      -- Font Template
      f:SetFont(LSM:Fetch("font", settings.font), settings.fontSize, ssub(settings.fontOutline, 2))
      if settings.fontJustify then
        f:SetJustifyH(settings.fontJustify)
      end
      
      -- scrolling
      if settings.scrollableLines then
        f:SetMaxLines(settings.scrollableLines)
        if settings.enableScrollable then
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

local function StartConfigMode()
  for framename, settings in pairs(x.db.profile.frames) do
    if settings.enabledFrame then
      local f = x.frames[framename]
      f:SetBackdrop( {
         bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile     = false,
        tileSize = 0,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
                   } )
      f:SetBackdropColor(.1, .1, .1, .8)
      f:SetBackdropBorderColor(.1, .1, .1, .5)
    
      -- Frame Title
      f.title = f:CreateFontString(nil, "OVERLAY")
      f.title:SetPoint("BOTTOM", f, "TOP", 0, 0)
      f.title = f:SetFont(settings.font, settings.fontSize, settings.fontOutline)
      f.title:SetText(frameTitles[framename])
      
      f.t=f:CreateTexture("ARTWORK")
      f.t:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
      f.t:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -19)
      f.t:SetHeight(20)
      f.t:SetTexture(.5, .5, .5)
      f.t:SetAlpha(.3)

      f.d=f:CreateTexture("ARTWORK")
      f.d:SetHeight(16)
      f.d:SetWidth(16)
      f.d:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
      f.d:SetTexture(.5, .5, .5)
      f.d:SetAlpha(.3)

      f.tr=f:CreateTitleRegion()
      f.tr:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
      f.tr:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
      f.tr:SetHeight(21)
      
      
      -- Moving Settings
      f:EnableMouse(true)
      f:RegisterForDrag("LeftButton")
      f:SetScript("OnDragStart", f.StartSizing)
      
      -- TODO: Add option to adjust the number of lines for memory purposes
      
      f:SetScript("OnDragStop", f.StopMovingOrSizing)
      ct.locked = false
      
      -- TODO: Show Alignment Grid
      
    end
  end
end

local function EndConfigMode()

end

function x:ToggleConfigMode()

end