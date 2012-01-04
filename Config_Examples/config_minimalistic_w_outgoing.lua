local addon, ns = ...
ns.config = {
    -- --------------------------------------------------------------------------------------
    -- Blizzard Damage Options.
    -- --------------------------------------------------------------------------------------   
        -- Use Blizzard Damage/Healing Output (Numbers Above Mob/Player's Head)
        ["blizzheadnumbers"]    = false,  -- (You need to restart WoW to see changes!)
        
        -- "Everything else" font size (heals/interrupts and the like)
        ["fontsize"]        = 16,
        ["font"]            = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- "Fonts\\ARIALN.ttf" is default WoW font.
        
        
    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames
    -- --------------------------------------------------------------------------------------
        -- Allow mouse scrolling on ALL frames (recommended "false")
        ["scrollable"]          = false,
        ["maxlines"]            = 12,       -- Max lines to keep in scrollable mode. More lines = more Memory Nom nom nom
        
        
        -- ==================================================================================
        -- Healing/Damage Outing Frame (frame is called "xCTdone")
        -- ==================================================================================
        ["damageout"]           = true,     -- show outgoing damage
        ["healingout"]          = true,     -- show outgoing heals
        
            -- Filter Units/Periodic Spells
            ["petdamage"]       = true,     -- show your pet damage.
            ["dotdamage"]       = true,     -- show DoT damage
            ["showhots"]        = true,     -- show periodic healing effects in xCT healing frame.
            ["showimmunes"]     = true,     -- show "IMMUNE"s when you or your target cannot take damage or healing
            
            -- Damage/Healing Icon Sizes and Appearence
            ["icons"]           = false,    -- show outgoing damage icons
            ["iconsize"]        = 16,       -- outgoing damage icons' size
            ["damagefontsize"]  = 16,
            ["fontstyle"]       = "OUTLINE",                            -- valid options are "OUTLINE", "MONOCHROME", "THICKOUTLINE", "OUTLINE,MONOCHROME", "THICKOUTLINE,MONOCHROME"
            ["damagefont"]      = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- "Fonts\\FRIZQT__.ttf" is default WoW damage font

            -- Damage/Healing Minimum Value threshold
            ["treshold"]        = 1,        -- minimum value for outgoing damage
            ["healtreshold"]    = 1,        -- minimum value for outgoing heals
        -- __________________________________________________________________________________


        -- ==================================================================================
        -- Critical Damage/Healing Outging Frame (frame is called "xCTcrit")
        -- ==================================================================================
        ["critwindow"]          = false,
        
            -- Critical Icon Sizes
            ["criticons"]       = true,     -- show crit icons
            ["criticonsize"]    = 14,       -- size of the icons in the crit frame
                        
            -- Critical Custom Font and Format
            ["critfont"]        = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- Special font for the crit frame
            ["critfontstyle"]   = "OUTLINE",
            ["critfontsize"]    = 24,                   -- crit font size ("auto" or Number)
            
            -- Critical Appearance Options
            ["critprefix"]      = "|cffFF0000*|r",      -- prefix symbol shown before crit'd amount (default: red *)
            ["critpostfix"]     = "|cffFF0000*|r",      -- postfix symbol shown after crit'd amount (default: red *)
        -- __________________________________________________________________________________

        
        -- ==================================================================================
        -- Loot Items/Money Gains (frame is called "xCTloot")
        -- ==================================================================================
        ["lootwindow"]          = false,     -- Enable the frame "xCTloot" (use instead of "xCTgen" for Loot/Money)
        
            -- What to show in "xCTloot"
            ["lootitems"]       = false,
            ["lootmoney"]       = false,
            
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


        -- ==================================================================================
        -- Spell / Ability Procs Frame (frame is called "xCTproc")
        -- ==================================================================================
        -- NOTE: This only has the ability to show only procs that blizzards sends to it
        --       (mostly spells that "light up" and some others too).
        ["procwindow"]          = false,     -- Enable the frame to show Procs
        
            -- Proc Frame Custom Font Options
            ["procfont"]        = "Interface\\Addons\\xCT\\HOOGE.TTF",  -- Special font for the proc frame
            ["procfontsize"]    = 16,                   -- proc font size ("auto" or Number)
            ["procfontstyle"]   = "OUTLINE",
        -- __________________________________________________________________________________
        
        
        -- ==================================================================================
        -- Misc. Frames
        -- ==================================================================================
            -- Healing/Damage Incoming Frames (frames are called "xCTheal" and "xCTdmg")
            ["damagecolor"]         = true,     -- display colored damage numbers by type
        
            -- Power Gains Incoming Frame (frame is called "xCTpwr")
            ["powergainswindow"]    = false,
        -- __________________________________________________________________________________
        
    -- --------------------------------------------------------------------------------------
    -- xCT+ Class Specific and Misc. Options
    -- --------------------------------------------------------------------------------------
        -- Priest
        ["stopvespam"]       = true,         -- Hides Healing Spam for Priests in Shadowform.
        
        -- Death Knight
        ["dkrunes"]          = false,        -- Show Death Knight Rune Recharge
        
        -- Misc.
            -- Spell Spam Spam Spam Spam Spam Spam Spam Spam
            ["mergeaoespam"]     = false,   -- Merges multiple AoE spam into single message, can be useful for dots too.
            ["mergeaoespamtime"] = 3,       -- Time in seconds AoE spell will be merged into single message.  Minimum is 1.
        
            -- Helpful Alerts (Shown in the Gerenal Gains/Drops Frame)
            ["killingblow"]      = true,    -- Alerts with the name of the PC/NPC that you had a killing blow on (Req. ["damageout"] = true)
            ["dispel"]           = true,    -- Alerts with the name of the (De)Buff Dispelled (Req. ["damageout"] = true)
            ["interrupt"]        = true,    -- Alerts with the name of the Spell Interupted (Req. ["damageout"] = true)
        
            -- Alignment Help (Shown when configuring frames)
            ["showgrid"]        = false,    -- shows a grid when moving xCT windows around
            
            -- Show Procs
            ["filterprocs"]     = true,     -- Enable to hide procs from ALL frames (will show in xCTproc or xCTgen otherwise)
            
            
    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames' Justification
    -- --------------------------------------------------------------------------------------
        --[[Justification Options: "RIGHT", "LEFT", "CENTER" ]]
        ["justify_1"] = "LEFT",             -- Damage Incoming Frame (frame is called "xCTdmg")
        ["justify_2"] = "RIGHT",            -- Healing Incoming Frame (frame is called "xCTheal")
        ["justify_3"] = "CENTER",           -- General Buffs Gains/Drops Frame (frame is called "xCTgen")
        ["justify_4"] = "RIGHT",            -- Healing/Damage Outgoing Frame (frame is called "xCTdone")
        ["justify_5"] = "CENTER",           -- Loot/Money Gains Frame (frame is called "xCTloot")
        ["justify_6"] = "RIGHT",            -- Criticals Outgoing Frame (frame is called "xCTcrit")
        ["justify_7"] = "LEFT",             -- Power Gains Frame (frame is called "xCTpwr")
        ["justify_8"] = "CENTER",           -- Procs Frame (frame is called "xCTproc")
        
    -- ** >> !! experimental !! << **
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