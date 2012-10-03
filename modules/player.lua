-- this file is used to hold combat text information about
--    the player and types belonging to the player

local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine



-- TODO: finish this module
x.player = {
  unit = "player",
  guid = nil, -- dont get the id until we load
}

function x:UpdatePlayer()
  x.player.guid = UnitGUID("player")
end


print("PLAYER MODULE LOADED")