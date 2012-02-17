
-- This is a library that contains all the ways to format and output combat text
local ADDON_NAME, xCT = ...

xCT.Output = { }
local xCT_Output = xCT.Output

-- Formats
function xCT_Output.FormatCritical(msg)
  local prefix, postfix = xCT.CurrentProfile["CriticalPrefix"], xCT.CurrentProfile["CriticalPostfix"]
  return string.format("%s %s %s", prefix, msg, postfix)
end

function xCT_Output.FormatResist(msg, resist)
  if resist > 0 then
    return string.format("%s (%d)", msg, resist)
  else
    return msg
  end
end

-- Outputs
function xCT_Output.SendOutgoingMessage(msg, critical, r, g, b)
  if critical then
    msg = xCT_Output.FormatCritical(msg)
  
    -- TODO: Send to Critical Output Frame
  else
    -- TODO: Send to Regular Output Frame
  end
end

function xCT_Output.SendIncomingDamageMessage(msg, critical, r, g, b)

end

function xCT_Output.SendIncomingHealingMessage(msg, name, critical, r, g, b)

end

function xCT_Output.SendGeneralMessage(msg, r, g, b)

end

function xCT_Output.SendProcMessage(msg, critical, r, g, b)

end

function xCT_Output.SendPowerMessage(msg, power)

end
