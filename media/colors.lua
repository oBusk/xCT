--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2016. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine

-- This old and will be replaced soon
x.colors = {
  damage = {.75,.1,.1},
  damage_crit = {1,.1,.1},
  spell_damage = {.75,.3,.85},
  spell_damage_crit = {.75,.3,.85},
  shield = {.60,.65,1},
  heal = {.1,.75,.1},
  heal_crit = {.1,1,.1},
  heal_peri = {.1,.5,.1},
  heal_out = {.1,.65,.1},
  heal_out_crit = {.1,1,.1},
  spell_cast = {1,.82,0},
  misstype_generic = {.5,.5,.5},
  resist_generic = {.75,.5,.5},
  resist_spell = {.5,.3,.5},
  aura_start = {1,.5,.5},
  aura_end = {.5,.5,.5},
  aura_start_harm = {1,.1,.1},
  honor = {.1,.1,1},
  faction_sub = {1,.1,.1},
  spell_reactive = {1,.82,0},
  low_health = {1,.1,.1},
  low_mana = {1,.1,.1},

  combat_begin = {1,.1,.1},
  combat_end = {.1,1,.1},

  -- outgoing
  out_damage = {1,.82,0},
  out_damage_crit = {1,1,0},
  out_misstype = {.5,.5,.5},
  dispell_buff = {0,1,.5},
  dispell_debuff = {1,0,.5},
  spell_interrupt = {1,.5,0},
  spell_stolen = {.9,0,.9},
  party_kill = {.2,1,.2},

  combo_points = {1,.82,0},
  combo_points_max = {0,.82,1},
}

x.colorDB = {

-- Colors covered by the General Frame
	['buffsFaded']         = { 0.50, 0.50, 0.50 },
	['buffsGained']        = { 1.00, 0.50, 0.50 },
	['combatEntering']     = { 1.00, 0.10, 0.10 },
	['combatLeaving']      = { 0.10, 1.00, 0.10 },
	['dispellBuffs']       = { 0.00, 1.00, 0.50 },
	['dispellDebuffs']     = { 1.00, 0.00, 0.50 },
	['dispellStolen']      = { 0.31, 0.71, 1.00 },
	['debuffsFaded']       = { 0.50, 0.50, 0.50 },
	['debuffsGained']      = { 1.00, 0.10, 0.10 },
	['honorGains']         = { 0.10, 0.10, 1.00 },
	['interrupts']         = { 1.00, 0.50, 0.00 },
	['killingBlow']        = { 0.20, 1.00, 0.20 },
	['lowResourcesHealth'] = { 1.00, 0.10, 0.10 },
	['lowResourcesMana']   = { 1.00, 0.10, 0.10 },
	['reputationGain']     = { 0.10, 0.10, 1.00 },
	['reputationLoss']     = { 1.00, 0.10, 0.10 },

-- Colors covered by the Outgoing Frame
  ['SpellSchool_Physical'] = { 1.00, 1.00, 0.00 },
  ['SpellSchool_Holy']     = { 1.00, 0.90, 0.50 },
  ['SpellSchool_Fire']     = { 1.00, 0.50, 0.00 },
  ['SpellSchool_Nature']   = { 0.30, 1.00, 0.30 },
  ['SpellSchool_Frost']    = { 0.50, 1.00, 1.00 },
  ['SpellSchool_Shadow']   = { 0.50, 0.50, 1.00 },
  ['SpellSchool_Arcane']   = { 1.00, 0.50, 1.00 },
}

x.damagecolor = {
  [1]  = {  1,  1,  0 },  -- physical
  [2]  = {  1, .9, .5 },  -- holy
  [4]  = {  1, .5,  0 },  -- fire
  [8]  = { .3,  1, .3 },  -- nature
  [16] = { .5,  1,  1 },  -- frost
  [32] = { .5, .5,  1 },  -- shadow
  [64] = {  1, .5,  1 },  -- arcane
}

x.runecolors = {
	[1] = {1, 0, 0},      -- Blood
	[2] = {0, 0.5, 0},    -- Unholy
	[3] = {0, 1, 1},      -- Frost
	[4] = {0.8, 0.1, 1},  -- Death
}


-- From: https://www.wowace.com/addons/yurr-combat-log/files/440-v0-74-1/
x.spellColors = {
	[SCHOOL_MASK_PHYSICAL]						= "FFFFFF",             -- Physical
	[SCHOOL_MASK_HOLY]							= "FFFF4D",             -- Holy
	[SCHOOL_MASK_FIRE]							= "FF262E",             -- Fire
	[SCHOOL_MASK_NATURE]						= "66FF66",             -- Nature
	[SCHOOL_MASK_FROST]							= "4D4DE6",             -- Frost
	[SCHOOL_MASK_SHADOW]						= "FFB3FF",             -- Shadow
	[SCHOOL_MASK_ARCANE]						= "BFBFBF",             -- Arcane

	-- Physical and a Magical
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE]	= "FF9397",             -- Flamestrike
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FROST]	= "A6A6F3",             -- Froststrike
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_ARCANE]	= "DFDFDF",             -- Spellstrike
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_NATURE]	= "B3FFB3",             -- Stormstrike
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_SHADOW]	= "FFD9FF",             -- Shadowstrike
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_HOLY]	= "FFFFD3",             -- Holystrike

	-- Two Magical Schools
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST]		= "A63A8A",             -- Frostfire
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_ARCANE]		= "DF7377",             -- Spellfire
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_NATURE]		= "B3934A",             -- Firestorm
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_SHADOW]		= "FF6D97",             -- Shadowflame
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_HOLY]		= "FF933E",             -- Holyfire (Radiant)
	[SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE]	= "8686D3",             -- Spellfrost
	[SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE]	= "5AA6A6",             -- Froststorm
	[SCHOOL_MASK_FROST + SCHOOL_MASK_SHADOW]	= "A680F3",             -- Shadowfrost
	[SCHOOL_MASK_FROST + SCHOOL_MASK_HOLY]		= "A6A69A",             -- Holyfrost
	[SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE]	= "93DF93",             -- Spellstorm (Astral)
	[SCHOOL_MASK_ARCANE + SCHOOL_MASK_SHADOW]	= "DFB9DF",             -- Spellshadow
	[SCHOOL_MASK_ARCANE + SCHOOL_MASK_HOLY]		= "DFDF86",             -- Divine
	[SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW]	= "B3D9B3",             -- Shadowstorm (Plague)
	[SCHOOL_MASK_NATURE + SCHOOL_MASK_HOLY]		= "B3FF5A",             -- Holystorm
	[SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]		= "FFD9A6",             -- Shadowlight (Twilight)

	-- Three or more schools
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE]																						= "917B7E",     -- Elemental
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW]											= "B094A5",     -- Chromatic
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]						= "BDA696",     -- Magic
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]	= "C7B3A5"      -- Chaos
}

--[==[
Convert old way to new:

[[[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE]																						= "917B7E",     -- Elemental]],
[[[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW]											= "B094A5",     -- Chromatic]],
[[[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]						= "BDA696",     -- Magic]],
[[[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY]	= "C7B3A5"      -- Chaos]],

for i, v in pairs(lines) do
  local mask, hex, name = string.match(v, "%[([^%]]-)%][^=]-= \"([^\"]-)\"[^%-]+%-%- (.*)")
  local r, g, b = tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
  print(string.format("[%s] = { enabled = false, desc = \"%s\",   default = { %.2f, %.2f, %.2f } },", mask, name, r, g, b))
end
]==]


