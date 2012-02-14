local ADDON_NAME, xCT = ...

-- The frames
xCT.Frames = {
  Configuring = false,
  FrameList = { }
}

-- Upvalue
local Frames = xCT.Frames

-- Module Events
xCT.Event:CreateEvent("OnFramesCreated")
xCT.Event:CreateEvent("OnConfigModeStart")
xCT.Event:CreateEvent("OnConfigModeEnd")


function Frames:LoadAllFrames()
  for i, frameOptions in pairs(xCT.CurrentProfile.Options.Frames) do
    local frameName, frame = "xCT" .. i, nil
    
    -- Check to see if we need to create the frame for this porfile
    if not _G[frameName] then
      frame = CreateFrame("ScrollingMessageFrame", "xCT" .. i, UIParent)
    else
      frame = _G[frameName]
    end
    
    frame:SetFont(frameOptions["Font"], frameOptions["FontSize"], frameOptions["FontStyle"])
    frame:SetShadowColor(unpack(frameOptions["ShadowColor"]))
    frame:SetFading(frameOptions["Fading"])
    frame:SetTimeVisible(frameOptions["TimeVisible"])
    frame:SetMaxLines(frameOptions["MaxLines"])
    frame:SetSpacing(frameOptions["Spacing"])
    frame:SetHeight(frameOptions["Height"])
    frame:SetWidth(frameOptions["Width"])
    frame:SetPoint(frameOptions["Alignment"], frameOptions["Top"], frameOptions["Left"])
    frame:SetMovable(frameOptions["Movable"])
    frame:SetResizable(frameOptions["Resizable"])
    frame:SetMinResize(frameOptions["MinWidth"], frameOptions["MinHeight"])
    frame:SetMaxResize(frameOptions["MaxWidth"], frameOptions["MaxHeight"])
    frame:SetClampedToScreen(frameOptions["ClampToScreen"])
    frame:SetClampRectInsets(0, 0, frameOptions["FontSize"], 0)
    frame:SetJustifyH(frameOptions["Justify"])
    
    self.FrameList[frameOptions.Name] = frame
    frame.Options = frameOptions
    frame.Title = frameOptions["Title"]
    frame.TitleColor = frameOptions["TitleColor"]
  end
  
  xCT.Event:InvokeEvent("OnFramesCreated")
end



function Frames:StartConfig()

  -- Cannot configure in combat lockdown
  if InCombatLockdown() then
    xCT.DebugPrint("error: can't start config mode in combat")
    return
  end
  
  -- Enable Configure Mode
  self.Configuring = true
  
  local backdrop = {
    bgFile    = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile  = "Interface/Tooltips/UI-Tooltip-Border",
    tile      = false,
    tileSize  = 0,
    edgeSize  = 2,
    insets = {
      left    = 0,
      right   = 0,
      top     = 0,
      bottom  = 0,
    },
  }
  
  -- Frame Events
  local midX, midY = GetScreenWidth() / 2, GetScreenHeight() / 2
  local frame_OnLeave = function(self)
    self:SetScript("OnUpdate", nil)
    self.fsPosition:Hide()
    self.fsWidth:Hide()
    self.fsHeight:Hide()
  end
  local frame_OnUpdate = function(self)
    self.fsPosition:SetText(math.floor(self:GetLeft() - midX + 1) .. ", " .. math.floor(self:GetTop() - midY + 2))
    self.fsWidth:SetText(math.floor(self:GetWidth()))
    self.fsHeight:SetText(math.floor(self:GetHeight()))
  end
  local frame_OnEnter = function(self)
    self:SetScript("OnUpdate", frame_OnUpdate)
    self.fsPosition:Show()
    self.fsWidth:Show()
    self.fsHeight:Show()
  end
  
  -- Create Config Mode Items
  for i, frame in pairs(self.FrameList) do
    local frameOptions = frame.Options
   
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(.1, .1, .1, .8)
    frame:SetBackdropBorderColor(.1, .1, .1, .5)
    
    -- Frame Title
    frame.fsTitle = frame:CreateFontString(nil, "OVERLAY")
    frame.fsTitle:SetFont(frameOptions["Font"], frameOptions["FontSize"], frameOptions["FontStyle"])
    frame.fsTitle:SetPoint("BOTTOM", frame, "TOP", 0, 0)
    frame.fsTitle:SetText(frame.Title)
    frame.fsTitle:SetTextColor(unpack(frame.TitleColor))
    
    -- Top Bar
    frame.topBar = frame:CreateTexture("ARTWORK")
    frame.topBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame.topBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -19)
    frame.topBar:SetHeight(20)
    frame.topBar:SetTexture(.5, .5, .5)
    frame.topBar:SetAlpha(.3)
    
    -- Resize Bottom Right Box
    frame.resizeBox = frame:CreateTexture("ARTWORK")
    frame.resizeBox:SetHeight(16)
    frame.resizeBox:SetWidth(16)
    frame.resizeBox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    frame.resizeBox:SetTexture(.5, .5, .5)
    frame.resizeBox:SetAlpha(.3)
    
    -- Movable Title Region
    frame.titleRegion = frame:CreateTitleRegion()
    frame.titleRegion:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.titleRegion:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.titleRegion:SetHeight(20)
    
    -- FontString Position (X, Y)
    frame.fsPosition = frame:CreateFontString(nil, "OVERLAY")
    frame.fsPosition:SetFont(frameOptions["Font"], frameOptions["FontSize"], frameOptions["FontStyle"])
    frame.fsPosition:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
    frame.fsPosition:SetText("")
    frame.fsPosition:Hide()
    
    -- FontString Width
    frame.fsWidth = frame:CreateFontString(nil, "OVERLAY")
    frame.fsWidth:SetFont(frameOptions["Font"], frameOptions["FontSize"], frameOptions["FontStyle"])
    frame.fsWidth:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
    frame.fsWidth:SetText("")
    frame.fsWidth:Hide()
    
    -- FontString Height
    frame.fsHeight = frame:CreateFontString(nil, "OVERLAY")
    frame.fsHeight:SetFont(frameOptions["Font"], frameOptions["FontSize"], frameOptions["FontStyle"])
    frame.fsHeight:SetPoint("LEFT", frame, "LEFT", 3, 0)
    frame.fsHeight:SetText("")
    frame.fsHeight:Hide()
    
    -- Frame Events
    frame:SetScript("OnEnter", frame_OnEnter)
    frame:SetScript("OnLeave", frame_OnLeave)
    
    -- Frame Drag Events
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartSizing)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    --frame:SetScript("OnSizeChanged", function(self)
    --    self:SetMaxLines(self:GetHeight() / ct.fontsize)
    --    self:Clear()
    --  end)
  end
  
  xCT.Event:InvokeEvent("OnConfigModeStart")
end

function Frames:EndConfig(savePositions)

  -- Disable config mode
  self.Configuring = false

  if savePositions then
    -- TODO:
    -- Save the positions and data
  end
  
  -- Clear Config Mode Items
  for i, frame in pairs(xCT.Frames) do
    frame:SetScript("OnUpdate", nil)
    frame:SetScript("OnEnter", nil)
    frame:SetScript("OnLeave", nil)
    frame:SetScript("OnDragStart", nil)
    frame:SetScript("OnDragStop", nil)
  
    frame:SetBackdrop(nil)
    frame.fsTitle:Hide()
    frame.fsTitle = nil
    frame.resizeBox:Hide()
    frame.resizeBox = nil
    frame.topBar:Hide()
    frame.topBar = nil
    frame.titleRegion = nil
    frame:EnableMouse(false)
  end
  
  -- Clean-up left overs
  collectgarbage()
    
  xCT.Event:InvokeEvent("OnConfigModeEnd")
end
