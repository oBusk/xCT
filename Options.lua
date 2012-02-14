local ADDON_NAME, xCT = ...

-- Options
xCT.DefaultOptions = {
  -- This will get filled as time goes on :)
  ["Option1"] = false,
  ["Option2"] = false,
  ["Frames"] = {
  
    -- General Combat Text Frame
    ["General"] = {
      ["Name"]          = "General",                -- No spaces
      ["Alignment"]     = "CENTER",
      ["ClampToScreen"] = true,
      ["Fading"]        = true,
      ["Font"]          = "Interface\\Addons\\xCT+\\HOOGE.TTF",
      ["FontSize"]      = 16,
      ["FontStyle"]     = "OUTLINE",
      ["Height"]        = 128,
      ["Justify"]       = "CENTER",
      ["Left"]          = 0,
      ["MaxHeight"]     = 768,
      ["MaxLines"]      = 64,
      ["MaxWidth"]      = 768,
      ["MinHeight"]     = 64,
      ["MinWidth"]      = 64,
      ["Movable"]       = true,
      ["Resizable"]     = true,
      ["ShadowColor"]   = { 0, 0, 0, 0 },
      ["Spacing"]       = 2,
      ["Top"]           = 192,
      ["TimeVisible"]   = 3,
      ["Title"]         = "General Combat Text",   -- Whatever you want
      ["TitleColor"]    = { .1, .1, 1, .9 },
      ["Width"]         = 256,
    },  -- /General Combat Text Frame
    
    -- Outgoing Healing and Damage Frame
    ["Outgoing"] = {
      ["Name"]          = "Outgoing",              -- No spaces
      ["Alignment"]     = "CENTER",
      ["ClampToScreen"] = true,
      ["Fading"]        = true,
      ["Font"]          = "Interface\\Addons\\xCT+\\HOOGE.TTF",
      ["FontSize"]      = 16,
      ["FontStyle"]     = "OUTLINE",
      ["Height"]        = 128,
      ["Justify"]       = "CENTER",
      ["Left"]          = 320,
      ["MaxHeight"]     = 768,
      ["MaxLines"]      = 64,
      ["MaxWidth"]      = 768,
      ["MinHeight"]     = 64,
      ["MinWidth"]      = 64,
      ["Movable"]       = true,
      ["Resizable"]     = true,
      ["ShadowColor"]   = { 0, 0, 0, 0 },
      ["Spacing"]       = 2,
      ["Top"]           = 0,
      ["TimeVisible"]   = 3,
      ["Title"]         = "Outgoing Healing / Damage",
      ["TitleColor"]    = { 1, 1, 0, .9 },
      ["Width"]         = 128,
    },  -- /Outgoing Healing and Danamge Frame
    
    -- Incoming Healing
    ["Healing"] = {
      ["Name"]          = "Healing",              -- No spaces
      ["Alignment"]     = "CENTER",
      ["ClampToScreen"] = true,
      ["Fading"]        = true,
      ["Font"]          = "Interface\\Addons\\xCT+\\HOOGE.TTF",
      ["FontSize"]      = 16,
      ["FontStyle"]     = "OUTLINE",
      ["Height"]        = 128,
      ["Justify"]       = "CENTER",
      ["Left"]          = -512,
      ["MaxHeight"]     = 768,
      ["MaxLines"]      = 64,
      ["MaxWidth"]      = 768,
      ["MinHeight"]     = 64,
      ["MinWidth"]      = 64,
      ["Movable"]       = true,
      ["Resizable"]     = true,
      ["ShadowColor"]   = { 0, 0, 0, 0 },
      ["Spacing"]       = 2,
      ["Top"]           = 0,
      ["TimeVisible"]   = 3,
      ["Title"]         = "Incoming Healing",
      ["TitleColor"]    = { .1, 1, .1, .9 },
      ["Width"]         = 256,
    },  -- /Incoming Healing Frame
    
    -- Incoming Damage
    ["Damage"] = {
      ["Name"]          = "Damage",              -- No spaces
      ["Alignment"]     = "CENTER",
      ["ClampToScreen"] = true,
      ["Fading"]        = true,
      ["Font"]          = "Interface\\Addons\\xCT+\\HOOGE.TTF",
      ["FontSize"]      = 16,
      ["FontStyle"]     = "OUTLINE",
      ["Height"]        = 128,
      ["Justify"]       = "CENTER",
      ["Left"]          = -320,
      ["MaxHeight"]     = 768,
      ["MaxLines"]      = 64,
      ["MaxWidth"]      = 768,
      ["MinHeight"]     = 64,
      ["MinWidth"]      = 64,
      ["Movable"]       = true,
      ["Resizable"]     = true,
      ["ShadowColor"]   = { 0, 0, 0, 0 },
      ["Spacing"]       = 2,
      ["Top"]           = 0,
      ["TimeVisible"]   = 3,
      ["Title"]         = "Incoming Damage",
      ["TitleColor"]    = { 1, .1, .1, .9 },
      ["Width"]         = 128,
    },  -- /Incoming Damage Frame
  }
}