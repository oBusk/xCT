local ADDON_NAME, xCT = ...

-- Utilities
xCT.Utility = { }
local Utility = xCT.Utility


-- Create a new table that is a copy of another table (including sub tables; no metatables)
function Utility:CreateTable(fromTable)
  local table = { }
  for i, v in pairs(fromTable) do
    if type(v) == "table" then
      table[i] = self:CreateTable(v)
    else
      table[i] = v
    end
  end
  return table
end

-- Sets all the values in a table to nil
function Utility:Clear(fromTable)
  for i, v in pairs(fromTable) do
    fromTable[i] = nil
  end
end

function xCT.NullFunction() end

function xCT.Print(...)
  -- TODO:
  -- Color the output
  
  print("xCT:", ...)
end

function xCT.DebugPrint(...)
  -- TODO:
  -- Color the output
  
  print("xCT_D:", ...)
end

-- Debuging tools
function xCT.DumpSingleTable(value)
  if not type(value) == "table" then
    print("xCT_Dump: value = " .. tostring(value))
    return
  end
  
  print("xCT_Dump: value = {")
  for i, v in pairs(value) do
    local prefix, post
  
    if not type(i) == "string" then
      prefix = "    ["..tostring(i).."] = "
    else
      prefix = "    ['"..tostring(i).."'] = "
    end
    
    if not type(v) == "string" then
      post = tostring(v)..","
    else
      post = "'"..tostring(v).."',"
    end
    
    print(prefix..post)
  end
  print("}")
end