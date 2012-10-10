-- Yep, thats the spam merger... pretty lame
local dbSpam = { }
do        -- set up spell merger database
  dbSpam.index = 1
  for _, fn in pairs(frameIndex) do
    dbSpam[fn] = { }
    dbSpam.args[fn] = { }
  end
end

function x:AddSpamMessage(framename, mergeID, message, colorname)
  local currentTable = dbSpam[framename]
  if currentTable then
    if currentTable[mergeID] then
      table_insert(currentTable[mergeID], message)
    else
      currentTable[mergeID] = { message } 
    end
  else
    print("xct+ frame name not found:", framename)
  end
end

local spam_format = "%s%s x%s"


-- only update one frame, one merge id at a time
local function OnSpamUpdate(self, elapsed)
  if not self.index then self.index = 0 end
  if self.index > #frameIndex then self.index = 0 end

  local fn = frameIndex[self.index]
  local settings, spam, args = x.db.profile.frames[fn], dbSpam[fn], dbSpam.args[fn]
  
  if not settings.enabledFrame then return end
  if not args.index then args.index = 0 end
  if args.index > #spam then args.index = 0 end
  
  
  if #spam > 0 then  -- check zero entries
    local currentID, total = spam[args.index].id, 0
    for _, amount in pairs(spam[args.index].merges) do
      total = total + amount  -- Add all the amounts
    end
    local message = format(spam_format, tostring(total), x:GetSpellTextureFormatted(), #merges)
    x:AddMessage(framename, message, args.colorName)
  end
  
end





local function OnSpamUpdate(self, elapsed)
  if dbSpam.index > #frameIndex then dbSpam.index = 1 end

  local f = frameIndex[dbSpam.index] -- frame name
  local settings, spam, args = x.db.profile.frames[f], dbSpam[f], dbSpam.args[f]
  
  if settings.enabledFrame then
    if not args.index then args.index = 1 end
    if args.index > #spam.entries then args.index = 1 end
    
    local entries = spam[args.index].entries
    
    if #spam > 0 then
      local total = 0 
      
      for _, amount in pairs(entries) do
        total = total + amount  -- Add all the amounts
      end
      
      local message = format(spam_format, tostring(total), x:GetSpellTextureFormatted(spam.id, settings.iconsSize), #entries)
      x:AddMessage(f, message, args.colorName)
      
      -- clean up
      
      
    end
    
    args.index = args.index + 1
  end
  
end


local dbSpam = { }
do
  for _, frameName in pairs(frameIndex) do
    dbSpam[frameName] = { }
    --dbSpam.args[fn] = { }
  end
end


do
  local index
  local 


  local function OnSpamUpdate(self, elapsed)

    -- Check to see if we are out of bounds
    if index > #frameIndex then index = 1 end
    
    local spam, settings = dbSpam
    
    
    
    

  end
end



















dbSpam = {
  index -- frameIndex

  [FRAME_NAME] = { 
    [1] = {  -- spam
        id = SPELL_ID
        entries = {
          ENTRY1_AMOUNT
        }
      }
  }
  
  args = {
  
    [FRAME_NAME] = {
      index
      colorName
    }
  }
}