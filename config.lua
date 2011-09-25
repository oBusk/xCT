local addon, ns = ...
ns.config = {
    -- --------------------------------------------------------------------------------------
    -- Blizzard Damage Options.
    -- --------------------------------------------------------------------------------------   
        -- Use Blizzard Damage/Healing Output (Numbers Above Mob/Player's Head)
        ["blizzheadnumbers"]    = false, 
        
        -- Change Default Damage/Healing Font Above Mobs/Player Heads. (This has no effect if ["blizzheadnumbers"] = false)
        ["damagestyle"]         = true,  -- (You need to restart WoW to see changes!)
        
        -- "Everything else" font size (heals/interrupts and the like)
        ["fontsize"]        = 18,
        ["font"]            = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- "Fonts\\ARIALN.ttf" is default WoW font.
        
        
    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames
    -- --------------------------------------------------------------------------------------
        -- Allow mouse scrolling on ALL frames (recommended "false")
        ["scrollable"]          = false,
        ["maxlines"]            = 64,       -- Max lines to keep in scrollable mode. More lines = more Memory Nom nom nom
        
        -- __________________________________________________________________________________
        -- Healing/Damage Outing Frame (frame is called "xCTdone")
        ["damageout"]           = true,     -- show outgoing damage
        ["healingout"]          = true,     -- show outgoing heals
        
            -- Filter Units/Periodic Spells
            ["petdamage"]       = true,     -- show your pet damage.
            ["dotdamage"]       = true,     -- show DoT damage
            ["showhots"]        = true,     -- show periodic healing effects in xCT healing frame.
            
            -- Damage/Healing Icon Sizes and Appearence
            ["icons"]           = true,     -- show outgoing damage icons
            ["iconsize"]        = 28,       -- outgoing damage icons' size
            ["damagefontsize"]  = 18,
            ["fontstyle"]       = "OUTLINE",                            -- valid options are "OUTLINE", "MONOCHROME", "THICKOUTLINE", "OUTLINE,MONOCHROME", "THICKOUTLINE,MONOCHROME"
            ["damagefont"]      = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- "Fonts\\FRIZQT__.ttf" is default WoW damage font

            -- Damage/Healing Minimum Value threshold
            ["treshold"]        = 1,        -- minimum value for outgoing damage
            ["healtreshold"]    = 1,        -- minimum value for outgoing heals
        
        -- __________________________________________________________________________________
        -- Healing/Damage Incoming Frames (frames are called "xCTheal" and "xCTdmg")
        ["damagecolor"]         = true,     -- display colored damage numbers by type
        
        -- __________________________________________________________________________________
        -- Critical Damage/Healing Outging Frame (frame is called "xCTcrit")
        ["critwindow"]          = true,
        
            -- Critical Icon Sizes
            ["criticons"]       = true,     -- show crit icons
            ["criticonsize"]    = 21,       -- size of the icons in the crit frame
                        
            -- Critical Custom Font and Format
            ["critfont"]        = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- Special font for the crit frame
            ["critfontsize"]    = 24,                   -- crit font size ("auto" or Number)
            ["critprefix"]      = "|cffFF0000*|r",      -- prefix symbol shown before crit'd amount (default: red *)
            ["critpostfix"]     = "|cffFF0000*|r",      -- postfix symbol shown after crit'd amount (default: red *)

        -- __________________________________________________________________________________
        -- Power Gains Incoming Frame (frame is called "xCTpwr")
        ["powergainswindow"]    = true,
        
        -- __________________________________________________________________________________
        -- Loot Items/Money Gains (frame is called "xCTloot")
        ["lootitems"]           = true,
        ["lootmoney"]           = true,
        ["lootwindow"]          = true,     -- Use the frame "xCTloot" instead of "xCTgen" for Loot/Money Gains
            
            -- Item Options
            ["loothideicons"]   = false,    -- hide item icons when looted
            ["looticonsize"]    = 20,       -- Icon size of looted, crafted and quest items
            ["itemstotal"]      = false,    -- show the total amount of items in bag ("[Epic Item Name]x1 (x23)") - This is currently bugged and inacurate
            
            -- Item/Money Filter
            ["crafteditems"]    = nil,      -- show crafted items ( nil = default, false = always hide, true = always show)
            ["questitems"]      = nil,      -- show quest items ( nil = default, false = always hide, true = always show)
            ["itemsquality"]    = 3,        -- filter items shown by item quality: 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
            ["minmoney"]        = 0,        -- filter money received events, less than this amount (4G 32S 12C = 43212)
        
            -- Item/Money Appearance 
            ["colorblind"]      = false,    -- shows letters G, S, and C instead of textures

        -- __________________________________________________________________________________
        -- Power Gains (frame is called "xCTpwr")
        ["powergainswindow"]    = true,
        
        -- __________________________________________________________________________________
        -- Proc Frame (frame is called "xCTproc")
        ["procwindow"]          = true,
        
        
    -- --------------------------------------------------------------------------------------
    -- xCT+ Class Specific and Misc. Options
    -- --------------------------------------------------------------------------------------
        -- Priest
        ["stopvespam"]       = false,       -- Hides Healing Spam for Priests in Shadowform.
        
        -- Death Knight
        ["dkrunes"]          = true,        -- Show Death Knight Rune Recharge
        
        -- Misc.
            -- Spell Spam Spam Spam Spam Spam Spam Spam Spam
            ["mergeaoespam"]     = true,    -- merges multiple aoe spam into single message, can be useful for dots too.
            ["mergeaoespamtime"] = 3,       -- time in seconds aoe spell will be merged into single message. minimum is 1.
        
            -- Helpful Alerts
            ["killingblow"]      = true,    -- Alerts with the name of the PC/NPC that you had a killing blow on (["damageout"] needs to be on)
            ["dispel"]           = true,    -- Alerts with the name of the (De)Buff Dispelled  (["damageout"] needs to be on)
            ["interrupt"]        = true,    -- Alerts with the name of the Spell Interupted (["damageout"] needs to be on)
        
            -- Alignment Help
            ["showgrid"]        = true,     -- shows a grid when moving xCT windows around
            
            
    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames' Justification
    -- --------------------------------------------------------------------------------------
        --[[Justification Options:
              - "RIGHT"
              - "LEFT"
              - "CENTER"
        ]]
        
        -- __________________________________________________________________________________
        -- Damage Incoming Frame (frame is called "xCTdmg")
        ["justify_1"] = "LEFT",
        
        -- __________________________________________________________________________________
        -- Healing Incoming Frame (frame is called "xCTheal")
        ["justify_2"] = "RIGHT",
        
        -- __________________________________________________________________________________
        -- General Buffs Gains/Drops Frame (frame is called "xCTgen")
        ["justify_3"] = "CENTER",
        
        -- __________________________________________________________________________________
        -- Healing/Damage Outgoing Frame (frame is called "xCTdone")
        ["justify_4"] = "RIGHT",
        
        -- __________________________________________________________________________________
        -- Loot/Money Gains Frame (frame is called "xCTloot")
        ["justify_5"] = "CENTER",
        
        -- __________________________________________________________________________________
        -- Criticals Outgoing Frame (frame is called "xCTcrit")
        ["justify_6"] = "RIGHT",
        
        -- __________________________________________________________________________________
        -- Power Gains Frame (frame is called "xCTpwr")
        ["justify_7"] = "RIGHT",
        
        -- __________________________________________________________________________________
        -- Power Gains Frame (frame is called "xCTproc")
        ["justify_8"] = "CENTER",
        
        
    -- ** >>experimental<< **
    -- (not fully implemented or supported)
        -- announce and yell events 
        ["yelltaunt"]       = false,  -- yell when you taunt a target
        ["precachetaunt"]   = false,  -- yell extra info when taunting a target
        ["yellinterrupt"]   = false,  -- yell when you interrupt a target
        ["yelldispell"]     = false,  -- yell when you dispell a target
        
        ["mergeimmunespam"] = false,  -- merge multiple immune spam (uses "mergeaoespamtime" timer)
 
        ["texticons"] = false,
        
        -- (DISABLED: Currently does not work)
            ["loottimevisible"]     = 6,
            ["crittimevisible"]     = 3,
            ["timevisible"]         = 3,
}

