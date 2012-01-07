--[[   ____ _____
__  __/ ___|_   _|_
\ \/ / |     | |_| |_
 >  <| |___  | |_   _|
/_/\_\\____| |_| |_|
World of Warcraft (4.3)

Title: xCT+
Author: Dandruff
Version: 3.0.0 beta
Description:
  xCT+ is an extremely lightwight scrolling combat text addon.  It replaces Blizzard's default
scrolling combat text with something that is more concised and organized.  xCT+ is the continuation
of xCT (by Affli) that has been outdated since WoW 4.0.6.

]]

-- Lua code below.  Do NOT edit below this point!
-- If you didn't listen, then that means you know what you are doing, please continue. :)

local ADDON_NAME, engine = ...
local xCTEvents, xCT, _ = unpack(engine)  -- xCTEvents, xCT, xCTOptions (assigned later)
local myClassSpells, MERGE_SPELLS = {}, false

-- Mergeable Spells List = [CLASS] []
local mergeable_spells = {
  ['HUNTER'] = {
    [2643]  = true,  -- Multi-Shot
    [83077] = true,  -- Serpent Sting (Instant Serpent Spread)
    [88466] = true,  -- Serpent Sting (DOT Serpent Spread)
    [1978]  = true,  -- Serpent Sting
    [13812] = true,  -- Explosive Trap
  },
  ['PRIEST'] = {
    [47750] = true,  -- Penance (Heal Effect)
    [139]   = true,  -- Renew
    [596]   = true,  -- Prayer of Healing
    [56161] = true,  -- Glyph of Prayer of Healing
    [64844] = true,  -- Divine Hymn
    [32546] = true,  -- Binding Heal
    [77489] = true,  -- Echo of Light
    [34861] = true,  -- Circle of Healing
    [23455] = true,  -- Holy Nova (Healing Effect)
    [33110] = true,  -- Prayer of Mending
    [63544] = true,  -- Divine Touch
    
     -- Damager spells
    [47666] = true,  -- Penance (Damage Effect)
    [15237] = true,  -- Holy Nova (Damage Effect)
    [589]   = true,  -- Shadow Word: Pain
    [34914] = true,  -- Vampiric Touch
    [2944]  = true,  -- Devouring Plague
    [63675] = true,  -- Improved Devouring Plague
    [15407] = true,  -- Mind Flay
    [49821] = true,  -- Mind Seer
    [87532] = true,  -- Shadowy Apparition
  },  
}


function xCT.IsSpellMergeable(spellID)
  if MERGE_SPELLS then
    return myClassSpells[spellID]
  else
    return false
  end
end

-- Update Mergeable Spell List
xCTEvents["FramesLoaded"] = function()
  local t = mergeable_spells[xCT.Player.Class]
  
  -- If my class has mergeable spells
  if t then
    myClassSpells = t
  else
    myClassSpells = {}
  end
end

-- Update Cached Options value
xCTEvents["ChangedProfiles"] = function()
  MERGE_SPELLS = xCT.ActiveProfile.SpellMerge
end