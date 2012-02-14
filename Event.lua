-- Bubbling Event
local ADDON_NAME, xCT = ...

-- Event Handler
xCT.Event = {
  Events = { },
}

local Event = xCT.Event

-- Add an event to the list of events
function Event:CreateEvent(name)
  -- Check if event is already Registered
  if self.Events[name] then
    xCT.DebugPrint("error: already have an event by that name")
  end

  -- Add Event
  self.Events[name] = { }
  
  local event_mt = {
    __call = function(...)
      self:InvokeEvent(self.EventName, ...)
    end
  }
  
  setmetatable(self.Events[name], event_mt)
end

-- Register a handler to an event
function Event:RegisterEventHandler(eventName, funcHandler)
  local events = self.Events[eventName]
  local valid = true
  
  -- Check to make sure the handler is not already in there
  for i, v in pairs(events) do
    if v == funcHandler then
      valid = false
      break
    end
  end
  
  if valid then
    table.insert(events, funcHandler)
  else
    xCT.DebugPrint("error: event is already registered")
  end
end

-- Unregister a handler from the 
function Event:UnregisterEventHandler(eventName, funcHandler)
  local events = self.Events[eventName]
  local valid, index = false, -1
  
  -- Check to make sure the handler is in there
  for i, v in pairs(events) do
    if v == funcHandler then
      valid = true
      index = i
      break
    end
  end
  
  if valid then
    table.remove(events, index)
  else
    xCT.DebugPrint("error: event is not registered")
  end
end

-- Invoke Event with args
function Event:InvokeEvent(eventName, ...)
  local handles = self.Events[eventName]
  
  if not handles then
    xCT.DebugPrint("error: could not find the event you want '" .. tostring(eventName) .. "'")
    return
  end
  
  print("Dumping handles for event = " .. tostring(eventName))
  xCT.DumpSingleTable(handles)
  
  for i, handle in pairs(handles) do
    handle(...)
  end
end
