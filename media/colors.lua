local ADDON_NAME, addon = ...

-- Shorten my handle
local x = addon.engine

x.colors = {
  damage = {.75,.1,.1},
  damage_crit = {1,.1,.1},
  spell_damage = {.75,.3,.85},
  spell_damage_crit = {.75,.3,.85},
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
  spell_reactive = {1,.82,0},
  low_health = {1,.1,.1},
  low_mana = {1,.1,.1},
  combat_begin = {1,.1,.1},
  combat_end = {.1,1,.1},
  
  -- outgoing
  out_damage = {1,.82,0},
  out_damage_crit = {1,1,0},
}