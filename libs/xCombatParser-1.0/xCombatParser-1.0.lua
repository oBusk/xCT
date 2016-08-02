
-- Create out library
local Lib, oldLib = LibStub:NewLibrary("xCombatParser-1.0", 1)
if not Lib then return end

-- Our own personal space
local private = {}
Lib.private = private

do
	-- Upvalues
	local pairs=pairs

	-- Registered Event Handles
	-- Hook into the old handles incase someone registered with them before we could load.
	private.handles = oldLib and oldLib.private.handles or{}

	-- ------------------------------------------------------------------------------
	--                               Combat Log Helper
	-- ------------------------------------------------------------------------------
	--   A concise and easy combat log helper that helps parse events.
	-- ------------------------------------------------------------------------------
	-- function Lib:RegisterCombat ( func )
	--   Parameters:
	--       func [callback - function ( args )]:
	--           Callback for every combat event.
	--           Parameters:
	--                args [table]: A table that contains the combat event args.
	--                              Please do NOT change any of the values as it is
	--                              going to be passed to everyone. If you need to
	--                              hold it for a while, use "args:pin()" and
	--                              "args:free()" when you are finished with it.
	-- ------------------------------------------------------------------------------
	function Lib:RegisterCombat(func)
		private.handles[func]=true
		private.frame:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	end

	-- ------------------------------------------------------------------------------
	-- function Lib:RegisterCombat ( func )
	--   Parameters:
	--       func [callback - function ( args )]:
	--           The callback that you want to unregister from getting combat
	--           events. See "Lib:RegisterCombat" for more details.
	-- ------------------------------------------------------------------------------
	function Lib:UnregisterCombat(func)
		private.handles[func]=nil
		local reg
		for i in pairs(private.handles)do
			if i then reg=1;break;end
		end
		if not reg then
			private.frame:UnregisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
		end
	end
end

-- ------------------------------------------------------------------------------
--                             Recyclable Table Pool
-- ------------------------------------------------------------------------------
--   An extremely simple table recycle program. "Save the Earth"™
--
--   Look at documentation below for details on:
--       + function private.create
--       + function private.destroy
--       + function private.wipe
--       + function private.pin
--       + function private.free
-- ------------------------------------------------------------------------------
do
	-- Upvalues
	local pairs,error,next=pairs,error,next

	-- Pool of tables we've destroyed (they are kept as weak)
	-- Use our older table pool
	private.tables=oldLib and oldLib.private.tables or setmetatable({},mt_weakKeys)

	-- ------------------------------------------------------------------------------
	-- function private.create ( )
	--   Returns:
	--       t [table]:
	--           A clean table ready to go. If a table was recently recycled, you
	--           got that one, otherwise this is a brand new table.
	-- ------------------------------------------------------------------------------
	private.create=function()
		local t=next(private.tables)
		if t then private.tables[t]=nil;end
		return t or{}
	end

	-- ------------------------------------------------------------------------------
	-- function private.destroy ( t )
	--   Parameters:
	--       t [table]:
	--           A table you want recycled. All its values will be removed and it
	--           will be placed in cold storage waiting for private.create()
	--
	--  TODO: Recored where it is pinned created incase they dont destroy
	-- ------------------------------------------------------------------------------
	private.destroy=function(t)
		if t.__pinned and t.__pinned>0 then error"this table is being used somewhere"end
		private.tables[private.wipe(t)]=true
	end

	-- ------------------------------------------------------------------------------
	-- function private.wipe ( t )
	--   Parameters:
	--       t [table]:
	--           A table that contains values you want to wipe.
	--
	--   Returns:
	--       t [table]:
	--           The return "t" and the parameter "t" are the same table.
	-- ------------------------------------------------------------------------------
	private.wipe=function(t)
		for i in pairs(t)do t[i]=nil;end
		return t
	end

	-- ------------------------------------------------------------------------------
	-- function private.pin ( t )
	--   Parameters:
	--       t [table]:
	--           A table that you want to keep for an indeterminate amount of time.
	--           Once "pinned" a table cannot be destroyed until it has been "freed"
	--           the same amount of times as it has been pinned. When there are no
	--           more references, it will be destroyed automatically.
	-- ------------------------------------------------------------------------------
	private.pin=function(t)
		if not t.__pinned then
			t.__pinned=1
		else
			t.__pinned=t.__pinned+1
		end
	end

	-- ------------------------------------------------------------------------------
	-- function private.free ( t )
	--   Parameters:
	--       t [table]:
	--           A table that has been pinned. If there are no more references to
	--           this table, the table will be destroyed automatically.
	-- ------------------------------------------------------------------------------
	private.free=function(t)
		if not t.__pinned then error"table has not been pinned"end
		t.__pinned=t.__pinned-1
		if t.__pinned==0 then private.destroy(t)end
	end
end

-- Handle the Events
do
	-- Upvalues (Only values that will be used more than once)
	local select,sub,tostring,playerGUID=select,string.sub,tostring

	-- Recycle or create out event frame
	private.frame=oldLib and oldLib.private.frame or CreateFrame"frame"
	private.frame:RegisterEvent"PLAYER_ENTERING_WORLD"

	-- Localize Auto Attack
	local ENVIRONMENT_SUBHEADER,AUTO_ATTACK=ENVIRONMENT_SUBHEADER,GetSpellInfo(6603)

	-- Localize Environmental Damage
	local ENVIRONMENTAL_TYPES = {
		["Drowning"] = ACTION_ENVIRONMENTAL_DAMAGE_DROWNING,
		["Falling"] = ACTION_ENVIRONMENTAL_DAMAGE_FALLING,
		["Fatigue"] = ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE,
		["Fire"] = ACTION_ENVIRONMENTAL_DAMAGE_FIRE,
		["Lava"] = ACTION_ENVIRONMENTAL_DAMAGE_LAVA,
		["Slime"] = ACTION_ENVIRONMENTAL_DAMAGE_SLIME
	}

	-- Used for Spell Icons ONLY
	local ENVIRONMENTAL_FAKE_IDS = {
		["Drowning"] = 89662, -- Drowning (Quest in Hillsbrad (Lvl ~22), for Horde only)
		["Falling"] = 150875, -- Falling (Not sure where it is used)
		["Fatigue"] = 125024, -- Fatigue (Not sure where it is used)
		["Fire"] = 186242,    -- Fire (Not sure where it is used)
		["Lava"] = 192519,    -- Lava (New spell mechanic for something in Legion)
		["Slime"] = 179021,   -- Slime (New spell mechanic for something in Legion)
	}

	local ENVIRONMENTAL_FAKE_SPELLSCHOOL = {
		["Drowning"] = 1, -- Physical
		["Falling"] = 1,  -- Physical
		["Fatigue"] = 1,  -- Physical
		["Fire"] = 4,     -- Fire
		["Lava"] = 4,     -- Fire
		["Slime"] = 8,    -- Nature
	}

	-- Handle all the combat events. This needs to be extremely efficient
	private.frame:SetScript("OnEvent", function(self,
	                                            frameEvent,
	                                            timestamp,
	                                            event,
	                                            hideCaster,
	                                            sourceGUID,
	                                            sourceName,
	                                            sourceFlags,
	                                            sourceRaidFlags,
	                                            destGUID,
	                                            destName,
	                                            destFlags,
	                                            destRaidFlags,
	                                            ...)

		if frameEvent == "COMBAT_LOG_EVENT_UNFILTERED" then
			local i, args = 1, private.create()

			-- 11 Parameters of the COMBAT_LOG_EVENT   ---   Index
			args.timestamp = timestamp                      -- 1
			args.event = event                              -- 2
			args.hideCaster = hideCaster                    -- 3
			args.sourceGUID = sourceGUID                    -- 4
			args.sourceName = sourceName                    -- 5
			args.sourceFlags = sourceFlags                  -- 6
			args.sourceRaidFlags = sourceRaidFlags          -- 7
			args.destGUID = destGUID                        -- 8
			args.destName = destName                        -- 9
			args.destFlags = destFlags                      -- 10
			args.destRaidFlags = destRaidFlags              -- 11

			local prefix, suffix
			if event == "DAMAGE_SHIELD" or event == "DAMAGE_SPLIT" then
				prefix = "SPELL"
				suffix = "_DAMAGE"
			elseif event == "DAMAGE_SHIELD_MISSED" then
				prefix = "SPELL"
				suffix = "_MISSED"
			elseif event == "ENCHANT_APPLIED" or event == "ENCHANT_REMOVED" then
				args.spellName, args.itemId, args.itemName = select(1, ...)

			elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" or unit == "UNIT_DISSIPATES" then
				args.recapID, args.unconsciousOnDeath = select(1, ...)

			elseif event == "PARTY_KILL" then -- do nothing
			else
				prefix = sub(event, 1, 14)
				if prefix == "SPELL_PERIODIC" or prefix == "SPELL_BUILDING" then
					suffix = sub(event, 15)
				else
					prefix = sub(event, 1, 5)
					if prefix == "SPELL" or prefix == "SWING" or prefix == "RANGE" then
						suffix = sub(event, 6)
					else
						prefix = sub(event, 1, 13)
						if prefix == "ENVIRONMENTAL" then
							suffix = sub(event, 14)
						else
							error("Unhandled Combat Log Event: " .. tostring(event))
						end
					end
				end
			end

			args.prefix = prefix
			args.suffix = suffix

			if prefix == "SPELL" or prefix == "SPELL_PERIODIC" or prefix == "RANGE" or prefix == "SPELL_BUILDING" then
				args.spellId, args.spellName, args.spellSchool = select(1, ...)
				i = 4
			elseif prefix == "ENVIRONMENTAL" then
				local environmentalType = select(1, ...)
				args.environmentalType = environmentalType
				args.sourceName = ENVIRONMENT_SUBHEADER
				-- Fake out some spell things for icons and names
				args.spellId, args.spellName, args.spellSchool = ENVIRONMENTAL_FAKE_IDS[environmentalType],
				ENVIRONMENTAL_TYPES[environmentalType], ENVIRONMENTAL_FAKE_SPELLSCHOOL[environmentalType]

				-- TODO: Maybe add
				-- args.sourceName = ENVIRONMENT_SUBHEADER -- Localized "Environment"

				i = 2
			elseif prefix == "SWING" then
				-- SpellId for Auto Attack, "Auto Attack" (Localized), Physical Damage (Spell School)
				args.spellId, args.spellName, args.spellSchool = 6603, AUTO_ATTACK, 1
			end

			if suffix == "_DAMAGE" then
				args.amount, args.overkill, args.school,
				args.resisted, args.blocked, args.absorbed,
				args.critical, args.glancing, args.crushing,
				args.isOffHand = select(i, ...)

			elseif suffix == "_MISSED" then
				args.missType, args.isOffHand, args.multistrike,
				args.amountMissed = select(i, ...)

			elseif suffix == "_HEAL" then
				args.amount, args.overhealing, args.absorbed,
				args.critical, args.multistrike = select(i, ...)

			elseif suffix == "_ENERGIZE" then
				args.amount, args.powerType = select(i, ...)

			elseif suffix == "_DRAIN" or suffix == "_LEECH" then
				args.amount, args.powerType,
				args.extraAmount = select(i, ...)

			elseif suffix == "_INTERRUPT" or suffix == "_DISPEL_FAILED" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool = select(i, ...)

			elseif suffix == "_DISPEL" or suffix == "_STOLEN" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool, args.auraType = select(i, ...)

			elseif suffix == "_EXTRA_ATTACKS" then
				args.amount = select(i, ...)

			elseif suffix == "_AURA_APPLIED" or suffix == "_AURA_REMOVED"
				or suffix == "_AURA_APPLIED_DOSE" or suffix == "_AURA_REMOVED_DOSE"
				or suffix == "_AURA_REFRESH" then
				args.auraType, args.amount = select(i, ...)

			elseif suffix == "_AURA_BROKEN" then
				args.auraType = select(i, ...)

			elseif suffix == "_AURA_BROKEN_SPELL" then
				args.extraSpellId, args.extraSpellName,
				args.extraSchool, args.auraType = select(i, ...)

			elseif suffix == "_CAST_FAILED" then
				args.failedType = select(i, ...)
			end

			-- IsPlayer helpers
			args.isPlayer = playerGUID == args.sourceGUID
			args.atPlayer = playerGUID == args.destGUID

			-- Add Our API to the Combat Event Args
			-- Memory Helpers
			args.pin = private.pin
			args.free = private.free

			-- Unit Flag Helpers
			args.GetSourceType             = private.GetSourceType
			args.GetDestinationType        = private.GetDestinationType
			args.GetSourceController       = private.GetSourceController
			args.GetDestinationController  = private.GetDestinationController
			args.GetSourceReaction         = private.GetSourceReaction
			args.GetDestinationReaction    = private.GetDestinationReaction
			args.GetSourceAffiliation      = private.GetSourceAffiliation
			args.GetDestinationAffiliation = private.GetDestinationAffiliation

			-- Raid Target Flag Helpers
			args.GetSourceRaidTargetIndex      = private.GetSourceRaidTargetIndex
			args.GetDestinationRaidTargetIndex = private.GetDestinationRaidTargetIndex
			args.GetSourceRaidTargetName       = private.GetSourceRaidTargetName
			args.GetDestinationRaidTargetName  = private.GetDestinationRaidTargetName

			-- Special Unit Flag Helpers
			args.SourceIsNotSpecial      = private.SourceIsNotSpecial
			args.DestinationIsNotSpecial = private.DestinationIsNotSpecial
			args.SourceIsMainAssist      = private.SourceIsMainAssist
			args.DestinationIsMainAssist = private.DestinationIsMainAssist
			args.SourceIsMainTank        = private.SourceIsMainTank
			args.DestinationIsMainTank   = private.DestinationIsMainTank
			args.SourceIsFocus           = private.SourceIsFocus
			args.DestinationIsFocus      = private.DestinationIsFocus
			args.SourceIsTarget          = private.SourceIsTarget
			args.DestinationIsTarget     = private.DestinationIsTarget

			-- Crafted Unit Flag Helpers
			args.IsSourceMyPet          = private.IsSourceMyPet
			args.IsDestinationMyPet     = private.IsDestinationMyPet
			args.IsSourceMyVehicle      = private.IsSourceMyVehicle
			args.IsDestinationMyVehicle = private.IsDestinationMyVehicle

			-- Call all the registered handlers
			args:pin()
			for func in pairs(private.handles) do
				func(args)
			end
			args:free() -- If no one else pinned this table, it should be cleaned up now

		else
			self:UnregisterEvent"PLAYER_ENTERING_WORLD"
			playerGUID=UnitGUID"player"
		end
	end)
end

local band = bit.band
local function hasFlag (flags, flag)
	return band(flags, flag) == flag
end

-- Functions that require Flags
do
	local flags

	-- GetSourceType and GetDestinationType
	do
		local COMBATLOG_OBJECT_TYPE_OBJECT, COMBATLOG_OBJECT_TYPE_GUARDIAN,
			COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_NPC,
			COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_OBJECT,
			COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET,
			COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_TYPE_PLAYER

		function private.GetSourceType (args)
			flags = args.sourceFlags
			return hasFlag(flags, COMBATLOG_OBJECT_TYPE_OBJECT) and "OBJECT" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_GUARDIAN) and "GUARDIAN" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_PET) and "PET" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_NPC) and "NPC" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_PLAYER) and "PLAYER" or "UNKNOWN"
		end

		function private.GetDestinationType (args)
			flags = args.destFlags
			return hasFlag(flags, COMBATLOG_OBJECT_TYPE_OBJECT) and "OBJECT" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_GUARDIAN) and "GUARDIAN" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_PET) and "PET" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_NPC) and "NPC" or
				hasFlag(flags, COMBATLOG_OBJECT_TYPE_PLAYER) and "PLAYER" or "UNKNOWN"
		end
	end

	-- GetSourceController and GetDestinationController
	do
		local COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_CONTROL_PLAYER =
			COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_CONTROL_PLAYER

		function private.GetSourceController (args)
			flags = args.sourceFlags
			return hasFlag(flags, COMBATLOG_OBJECT_CONTROL_NPC) and "NPC" or
				hasFlag(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) and "PLAYER" or "UNKNOWN"
		end

		function private.GetDestinationController (args)
			flags = args.destFlags
			return hasFlag(flags, COMBATLOG_OBJECT_CONTROL_NPC) and "NPC" or
				hasFlag(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) and "PLAYER" or "UNKNOWN"
		end
	end

	-- GetSourceReaction and GetDestinationReaction
	do
		local COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_REACTION_NEUTRAL,
			COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_HOSTILE,
			COMBATLOG_OBJECT_REACTION_NEUTRAL, COMBATLOG_OBJECT_REACTION_FRIENDLY

		function private.GetSourceReaction (args)
			flags = args.sourceFlags
			return hasFlag(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) and "HOSTILE" or
				hasFlag(flags, COMBATLOG_OBJECT_REACTION_NEUTRAL) and "NEUTRAL" or
				hasFlag(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) and "FRIENDLY" or "UNKNOWN"
		end

		function private.GetDestinationReaction (args)
			flags = args.destFlags
			return hasFlag(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) and "HOSTILE" or
				hasFlag(flags, COMBATLOG_OBJECT_REACTION_NEUTRAL) and "NEUTRAL" or
				hasFlag(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) and "FRIENDLY" or "UNKNOWN"
		end
	end

	-- GetSourceAffiliation and GetDestinationAffiliation
	do
		local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_AFFILIATION_RAID,
			COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_MINE =
			COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_AFFILIATION_RAID,
			COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_MINE

		function private.GetSourceAffiliation (args)
			flags = args.sourceFlags
			return hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) and "OUTSIDER" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_RAID) and "RAID" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_PARTY) and "PARTY" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_MINE) and "MINE" or "UNKNOWN"
		end

		function private.GetDestinationAffiliation (flags)
			flags = args.destFlags
			return hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) and "OUTSIDER" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_RAID) and "RAID" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_PARTY) and "PARTY" or
				hasFlag(flags, COMBATLOG_OBJECT_AFFILIATION_MINE) and "MINE" or "UNKNOWN"
		end
	end

	-- GetSourceRaidTargetIndex, GetDestinationRaidTargetIndex, GetSourceRaidTargetName, and GetDestinationRaidTargetName
	do
		local COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_RAIDTARGET2,
			COMBATLOG_OBJECT_RAIDTARGET3, COMBATLOG_OBJECT_RAIDTARGET4,
			COMBATLOG_OBJECT_RAIDTARGET5, COMBATLOG_OBJECT_RAIDTARGET6,
			COMBATLOG_OBJECT_RAIDTARGET7, COMBATLOG_OBJECT_RAIDTARGET8 =
			COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_RAIDTARGET2,
			COMBATLOG_OBJECT_RAIDTARGET3, COMBATLOG_OBJECT_RAIDTARGET4,
			COMBATLOG_OBJECT_RAIDTARGET5, COMBATLOG_OBJECT_RAIDTARGET6,
			COMBATLOG_OBJECT_RAIDTARGET7, COMBATLOG_OBJECT_RAIDTARGET8

		function private.GetSourceRaidTargetIndex (args)
			flags = args.sourceRaidFlags
			return hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET8) and 8 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET7) and 7 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET6) and 6 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET5) and 5 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET4) and 4 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET3) and 3 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET2) and 2 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET1) and 1 or 0
		end

		function private.GetDestinationRaidTargetIndex (args)
			flags = args.destRaidFlags
			return hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET8) and 8 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET7) and 7 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET6) and 6 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET5) and 5 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET4) and 4 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET3) and 3 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET2) and 2 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET1) and 1 or 0
		end

		local RAID_TARGET_1, RAID_TARGET_2, RAID_TARGET_3, RAID_TARGET_4,
			RAID_TARGET_5, RAID_TARGET_6, RAID_TARGET_7, RAID_TARGET_8 =
			RAID_TARGET_1, RAID_TARGET_2, RAID_TARGET_3, RAID_TARGET_4,
			RAID_TARGET_5, RAID_TARGET_6, RAID_TARGET_7, RAID_TARGET_8

		function private.GetSourceRaidTargetName (flags)
			flags = args.sourceRaidFlags
			return hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET8) and RAID_TARGET_8 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET7) and RAID_TARGET_7 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET6) and RAID_TARGET_6 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET5) and RAID_TARGET_5 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET4) and RAID_TARGET_4 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET3) and RAID_TARGET_3 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET2) and RAID_TARGET_2 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET1) and RAID_TARGET_1 or "NONE"
		end

		function private.GetDestinationRaidTargetName (flags)
			flags = args.destRaidFlags
			return hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET8) and RAID_TARGET_8 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET7) and RAID_TARGET_7 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET6) and RAID_TARGET_6 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET5) and RAID_TARGET_5 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET4) and RAID_TARGET_4 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET3) and RAID_TARGET_3 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET2) and RAID_TARGET_2 or
				hasFlag(flags, COMBATLOG_OBJECT_RAIDTARGET1) and RAID_TARGET_1 or "NONE"
		end
	end

	-- IsSourceMyPet and IsDestinationMyPet
	do
		local MY_PET_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE,
		                             COMBATLOG_OBJECT_REACTION_FRIENDLY,
		                             COMBATLOG_OBJECT_CONTROL_PLAYER,
		                             COMBATLOG_OBJECT_TYPE_PET)

		function private.IsSourceMyPet (args)
			flags = args.sourceFlags
			return hasFlag(flags, MY_PET_FLAGS)
		end

		function private.IsDestinationMyPet (args)
			flags = args.destFlags
			return hasFlag(flags, MY_PET_FLAGS)
		end
	end

	-- IsSourceMyVehicle and IsDestinationMyVehicle
	do
		local MY_VEHICLE_FLAGS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE,
		                                 COMBATLOG_OBJECT_REACTION_FRIENDLY,
		                                 COMBATLOG_OBJECT_CONTROL_PLAYER,
		                                 COMBATLOG_OBJECT_TYPE_GUARDIAN)

		function private.IsSourceMyVehicle (args)
			flags = args.sourceFlags
			return hasFlag(flags, MY_VEHICLE_FLAGS)
		end

		function private.IsDestinationMyVehicle (args)
			flags = args.destFlags
			return hasFlag(flags, MY_VEHICLE_FLAGS)
		end
	end
end

-- Functions that do not require Flags
-- SourceIsNotSpecial and DestinationIsNotSpecial
do
	local COMBATLOG_OBJECT_NONE = COMBATLOG_OBJECT_NONE

	function private.SourceIsNotSpecial (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_NONE)
	end

	function private.DestinationIsNotSpecial (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_NONE)
	end
end

-- SourceIsMainAssist and DestinationIsMainAssist
do
	local COMBATLOG_OBJECT_MAINASSIST = COMBATLOG_OBJECT_MAINASSIST

	function private.SourceIsMainAssist (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_MAINASSIST)
	end

	function private.DestinationIsMainAssist (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_MAINASSIST)
	end
end

-- SourceIsMainTank and DestinationIsMainTank
do
	local COMBATLOG_OBJECT_MAINTANK = COMBATLOG_OBJECT_MAINTANK

	function private.SourceIsMainTank (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_MAINTANK)
	end

	function private.DestinationIsMainTank (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_MAINTANK)
	end
end

-- SourceIsFocus and DestinationIsFocus
do
	local COMBATLOG_OBJECT_FOCUS = COMBATLOG_OBJECT_FOCUS

	function private.SourceIsFocus (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_FOCUS)
	end

	function private.DestinationIsFocus (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_FOCUS)
	end
end

-- SourceIsTarget and DestinationIsTarget
do
	local COMBATLOG_OBJECT_TARGET = COMBATLOG_OBJECT_TARGET

	function private.SourceIsTarget (args)
		return hasFlag(args.sourceFlags, COMBATLOG_OBJECT_TARGET)
	end

	function private.DestinationIsTarget (args)
		return hasFlag(args.destFlags, COMBATLOG_OBJECT_TARGET)
	end
end
