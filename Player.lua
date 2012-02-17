-- This module is a self-contained module to help keep the player's information updated
local ADDON_NAME, xCT = ...

-- Locals
local U_P    = "UNIT_PET"
local P_E_W  = "PLAYER_ENTERING_WORLD"
local U_En_V = "UNIT_ENTERED_VEHICLE"
local U_Ex_V = "UNIT_EXITING_VEHICLE"
local XCT_PLAYER  = "player"
local XCT_VEHICLE = "vehicle"
local XCT_PET     = "pet"

local xCT_CurrentProfile = xCT.CurrentProfile


-- ===================================================
--  Module
-- ===================================================
  xCT.Player = {
    Pet = { },
  }
  local xCT_Player = xCT.Player
-- ===================================================

-- Accessors
function xCT_Player:HasPet()
  return (self.Pet.Name ~= nil)
end

local xCT_UnitHealth, xCT_UnitHealthMax = UnitHealth, UnitHealthMax
function xCT_Player:IsLowHealth()
  if xCT_UnitHealth(self.Unit) / xCT_UnitHealthMax(self.Unit) <= xCT_CurrentProfile["LowHealthThreshold"] then
    if not self.lowHealth then
      self.lowHealth = true
      return true
    end
  else
    self.lowHealth = false
  end
end

local xCT_UnitPower, xCT_UnitPowerMax = UnitPower, UnitPowerMax
function xCT_Player:IsLowMana()
  -- only works for mana users
  if not self.Power == MANA then return end
  
  if xCT_UnitPower(self.Unit) / xCT_UnitPowerMax(self.Unit) <= xCT_CurrentProfile["LowManaThreshold"] then
    if not self.lowMana then
      self.lowMana = true
      return true
    end
  else
    self.lowMana = false
  end
end

-- Methods
function xCT_Player:SetUnit()
  if UnitHasVehicleUI(XCT_PLAYER) then
    xCT_Player.Unit   = XCT_VEHICLE
    xCT_Player.GUID   = UnitGUID(XCT_VEHICLE)
    xCT_Player.Power  = select(2, UnitPowerType(XCT_VEHICLE))
    
    -- Because I am using a custom parser, I don't think I need this
    --CombatTextSetActiveUnit("vehicle")
  else
    xCT_Player.Unit   = XCT_PLAYER
    xCT_Player.GUID   = UnitGUID(XCT_PLAYER)
    xCT_Player.Power  = select(2, UnitPowerType(XCT_PLAYER))
    
    -- Because I am using a custom parser, I don't think I need this
    --CombatTextSetActiveUnit("player")
  end
end

function xCT_Player:UpdatePlayer()
  --self.Unit   = XCT_PLAYER
  --self.GUID   = UnitGUID(XCT_PLAYER)
  --self.Power  = select(2, UnitPowerType(XCT_PLAYER))
  
  self:SetUnit()
  self.Class  = select(2, UnitClass("player")),
  self.Flags  = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE,
                        COMBATLOG_OBJECT_REACTION_FRIENDLY,
                        COMBATLOG_OBJECT_CONTROL_PLAYER,
                        COMBATLOG_OBJECT_TYPE_GUARDIAN)
  
  self:UpdatePlayerPet()
end

function xCT_Player:UpdatePlayerPet()
  local pet = self.Pet
  
  if UnitExists(XCT_PET) then
    pet.Name = GetUnitName("pet")
    pet.GUID = UnitGUID("pet")
  else
    pet.Name = nil
    pet.GUID = nil
  end
end

-- Init Player's info when he enters the world
local playerEvents = CreateFrame("frame")

-- Events that affect the player
playerEvents:RegisterEvent(U_P)
playerEvents:RegisterEvent(P_E_W)
playerEvents:RegisterEvent(U_En_V)
playerEvents:RegisterEvent(U_Ex_V)

-- Handler: UNIT_PET
playerEvents:SetScript(U_P, function(unitID)
  xCT_Player:UpdatePlayerPet()

end)

-- Handler: PLAYER_ENTERING_WORLD
playerEvents:SetScript(P_E_W, function()
  -- Sets the current unit
  xCT_Player:SetUnit()
  
end)

-- Handler: UNIT_ENTERED_VEHICLE
playerEvents:SetScript(U_En_V, function()
  -- Sets the current unit to the vehicle
  xCT_Player:SetUnit()
end)

-- Handler: UNIT_EXITING_VEHICLE
playerEvents:SetScript(U_Ex_V, function()
  -- Sets the current unit to the player
  xCT_Player:SetUnit()
end)
