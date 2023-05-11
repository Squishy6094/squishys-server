
print("Connected to Server")

------------------
-- Menu Handler --
------------------

menuTable = {
    [1] = {
        name = "Movement",
        tabMax = 6,
        [1] = {
            name = "Moveset",
            nameSave = "MoveSave",
            status = tonumber(mod_storage_load("MoveSave")),
            statusMax = 2,
            statusDefault = 0,
            --Status Toggle Names
            [0] = "Default",
            [1] = "Character",
            [2] = "Quality of Life",
            --Description
            Line1 = "Change small things about",
            Line2 = "how Mario moves to make",
            Line3 = "movement feel better"
        },
        [2] = {
            name = "Lava Groundpound",
            nameSave = "LGPSave",
            status = tonumber(mod_storage_load("LGPSave")),
            statusMax = 1,
            --Description
            Line1 = "Ground-Pounding on lava will",
            Line2 = "give you a speed and height",
            Line3 = "boost, at the cost of health."
        },
        [3] = {
            name = "Anti-Quicksand",
            nameSave = "AQSSave",
            status = tonumber(mod_storage_load("AQSSave")),
            statusMax = 1,
            restriction = true,
            --Description
            Line1 = "Makes instant quicksand act",
            Line2 = "like lava, preventing what",
            Line3 = "may seem like an unfair",
            Line4 = "deaths. (Does not include",
            Line5 = "Lava Groundpound functions)"
        },
        [4] = {
            name = "Modded Wallkick",
            nameSave = "WKSave",
            status = tonumber(mod_storage_load("WKSave")),
            statusMax = 1,
            --Description
            Line1 = "Adds Wallsliding and more",
            Line2 = "lenient angles you can wall",
            Line3 = "kick at, best for a more",
            Line4 = "modern experience."
        },
        [5] = {
            name = "Strafing",
            nameSave = "StrafeSave",
            status = tonumber(mod_storage_load("StrafeSave")),
            statusMax = 1,
            statusDefault = 0,
            --Description
            Line1 = "Forces Mario to face the",
            Line2 = "direction the Camera is",
            Line3 = "facing, similar to Sonic Robo",
            Line4 = "Blast 2. Recommended if you",
            Line5 = "play with Mouse and Keyboard."
        },
        [6] = {
            name = "Ledge Parkour",
            nameSave = "LedgeSave",
            status = tonumber(mod_storage_load("LedgeSave")),
            statusMax = 1,
            --Description
            Line1 = "Toggles the ability to press",
            Line2 = "A or B while moving fast onto",
            Line3 = "a ledge to trick off of it!",
            Line4 = "Recommended if you want",
            Line5 = "to retain your speed going",
            Line6 = "off a ledge."
        },
    },
    [2] = {
        name = "HUD",
        tabMax = 4,
        [1] = {
            name = "HUD Type",
            nameSave = "HUDSave",
            status = tonumber(mod_storage_load("HUDSave")),
            statusMax = 3,
            statusDefault = 0,
            --Status Toggle Names
            [0] = "Default",
            [1] = "4:3 Locked",
            [2] = "Compact",
            [3] = "Disabled",
            --Description
            Line1 = "Changes which HUD the screen",
            Line2 = "displays! (WIP)"
        },
        [2] = {
            name = "Descriptions",
            nameSave = "DescSave",
            status = tonumber(mod_storage_load("DescSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles these descriptions",
            Line2 = "you see on the right,",
            Line3 = "Recommended to turn Off if",
            Line4 = "you like a more minimalistic",
            Line5 = "menu."
        },
        [3] = {
            name = "Server Popups",
            nameSave = "notifSave",
            status = tonumber(mod_storage_load("notifSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Shows Tips/Hints about the",
            Line2 = "server every 3-5 minutes.",
            Line3 = "Recommended for if you're",
            Line4 = "new to the server."
        },
        [4] = {
            name = "Show Rules",
            nameSave = "RulesSave",
            status = tonumber(mod_storage_load("RulesSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if the Rules Screen",
            Line2 = "Displays upon joining. By",
            Line3 = "turning this option off,",
            Line4 = "You're confirming that you",
            Line5 = "have Read and Understand",
            Line6 = "the Rules."
        },
    },
    [3] = {
        name = "Misc.",
        tabMax = 3,
        [1] = {
            name = "Star Spawn Cutscene",
            nameSave = "SSCSave",
            status = tonumber(mod_storage_load("SSCSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if Star Spawning",
            Line2 = "Cutscenes play, Recommended",
            Line3 = "if you don't know where a",
            Line4 = "star spawns."
        },
        [2] = {
            name = "Personal Model",
            nameSave = "ModelSave",
            status = tonumber(mod_storage_load("ModelSave")),
            statusMax = nil,
            statusDefault = 1,
            --Description
            Line1 = "Toggles your own Custom",
            Line2 = "Player Model, Only avalible",
            Line3 = "for users with at least",
            Line4 = "one Custom Model.",
            Line5 = "",
            Line6 = "",
            Line7 = "Contact The Host for more",
            Line8 = "information about",
            Line9 = "Custom Models and DynOS"
        },
        [3] = {
            name = "Locally Display Models",
            nameSave = "ModelDisplaySave",
            status = tonumber(mod_storage_load("ModelDisplaySave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Toggles if Custom Player",
            Line2 = "Models Display locally,",
            Line3 = "Recommended if other people's",
            Line4 = "Custom models are getting",
            Line5 = "in the way.",
            Line6 = "",
            Line7 = "Contact The Host for more",
            Line8 = "information about",
            Line9 = "Custom Models and DynOS"
        }
    },
    [4] = {
        name = "Misc.",
        tabMax = 6,
        [1] = {
            name = "Death Type",
            status = gServerSettings.bubbleDeath,
            statusMax = 1,
            statusDefault = 1,
            --Status Toggle Names
            [0] = "Default",
            [1] = "Bubble",
            --Description
            Line1 = "Chenges how players die",
            Line2 = "and respawn after death."
        },
        [2] = {
            name = "Player Interactions",
            status = gServerSettings.playerInteractions,
            statusMax = 2,
            statusDefault = 2,
            --Status Toggle Names
            [0] = "Non-Solid",
            [1] = "Solid",
            [2] = "Friendly Fire",
            --Description
            Line1 = "Changes if and how players",
            Line2 = "interact with each other."
        },
        [3] = {
            name = "Player Knockback",
            status = gServerSettings.playerKnockbackStrength,
            statusMax = 2,
            statusDefault = 1,
            --Status Toggle Names
            [0] = "Weak",
            [1] = "Normal",
            [2] = "Too Much",
            --Description
            Line1 = "Changes how far players get",
            Line2 = "knocked back after being hit",
            Line3 = "by another player."
        },
        [4] = {
            name = "On Star Collection",
            status = gServerSettings.stayInLevelAfterStar,
            statusMax = 2,
            statusDefault = 1,
            --Status Toggle Names
            [0] = "Leave Level",
            [1] = "Stay in Level",
            [2] = "Non-Stop",
            --Description
            Line1 = "Determines what happens",
            Line2 = "after you collect a star."
        },
        [5] = {
            name = "Global Movesets",
            status = 1,
            statusMax = 1,
            statusDefault = 0,
            --Description
            Line1 = "Determines if players can",
            Line2 = "locally change what moveset",
            Line3 = "they're using, Off forces",
            Line4 = "everyone to default."
        },
        [6] = {
            name = "Global Anti-Quicksand",
            status = 0,
            statusMax = 1,
            statusDefault = 0,
            --Description
            Line1 = "Determines if players can",
            Line2 = "locally change AQS or if",
            Line3 = "it's forced off."
        },
    }
}

-- Optimized by ChatGPT
local function set_status_and_save(table, index, status)
    table[index].status = status
    mod_storage_save(table[index].nameSave, tostring(status))
end

if mod_storage_load("SaveData") ~= "true" then
    print("Save Data not found for 'squishys-server.sav,' Creating Save Data...")

    for i = 1, #menuTable[1] do
        if i == 1 or i == 5 then
            set_status_and_save(menuTable[1], i, 0)
        else
            set_status_and_save(menuTable[1], i, 1)
        end
    end

    for i = 1, #menuTable[2] do
        if i == 1 then
            set_status_and_save(menuTable[2], i, 0)
        else
            set_status_and_save(menuTable[2], i, 1)
        end
    end

    for i = 1, #menuTable[3] do
        set_status_and_save(menuTable[3], i, 1)
    end

    print("Save Data made successfully!")
    mod_storage_save("SaveData", "true")
end

-------------------
-- Rules Handler --
-------------------

rules = menuTable[2][4].status

------------------------
-- Custom HUD Handler --
------------------------

local Default = 0
local FourThreeLock = 1
local Compact = 2
local Off = 3

hudTable = {
    [Default] = {
        name = "Default",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = -77,
            iconOffsetY = 15,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 33,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 33,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 51,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 51,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 51,
        },
        ["Health"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
    [FourThreeLock] = {
        name = "4:3 Locked",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = -138,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = -122,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = -106,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 82,
            iconOffsetY = 15,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 82,
            iconOffsetY = 33,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 33,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 82,
            iconOffsetY = 51,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 51,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 51,
        },
        ["Health"] = {
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
    [Compact] = {
        name = "Compact",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 60,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 60,
        },
        ["Coins"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 78,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 78,
        },
        ["Stars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 96,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 96,
        },
        ["RedStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = 114,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 114,
        },
        ["GreenStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = 132,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 132,
        },
        ["Health"] = {
            scale = 64,
            xAlignment = 0,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = 15,
            meterOffsetY = 8,
        }
    },
    [Off] = {
        name = "Disabled",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = 21,
            iconOffsetY = 15,
            xShow = false,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = false,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = -77,
            iconOffsetY = 15,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 33,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 33,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 51,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 51,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 51,
        },
        ["Health"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = false,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
}

--------------------------
-- Name-2-Model Handler --
--------------------------

-- Name = Discord ID
Default = "0"
Squishy = "678794043018182675"
Spoomples = "461771557531025409"
Nut = "1092073683377455215"
Cosmic = "767513529036832799"
Trashcam = "827596624590012457"
Skeltan = "489114867215630336"
AgentX = "490613035237507091"
DepressedYoshi = "491581215782993931"
Yosho = "711762825676193874"
YoshoAlt = "561647968084557825"
KanHeaven = "799106550874243083"
Bloxxel64Nya = "662354972171567105"
Vince = "282702284608110593"
Average = "397219199375769620"
Elby = "673582558507827221"
Crispyman = "817821798363955251"
Butter = "759464398946566165"
Mathew = "468134163493421076"
Peachy = "732244024567529503"
Eros = "376304957168812032"
Oquanaut = "459762042274840587"
RedBun = "459762042274840587"
Dvk = "542676894244536350"
KitKat = "664638362484867121"

--Assign Discord/Name-2-Model ID
discordID = network_discord_id_from_local_index(0)
if modelTable[discordID] == nil then
    discordID = "0"
    menuTable[3][2].status = 0
end

modelTable = {
    [Default] = {
        maxNum = 0,
        [0] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        }
    },
    [Squishy] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD
        },
    },
    [Spoomples] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default",
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [2] = {
            model = smlua_model_util_get_id("pacman_geo"),
            modelName = "Pac-Man",
            forcePlayer = CT_MARIO
        },
        [3] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
    },
    [Nut] = {
        maxNum = 5,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD
        },
        [3] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [4] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-purple-guy")
        },
        [4] = {
            model = smlua_model_util_get_id("wander_geo"),
            modelName = "Wander",
            forcePlayer = CT_TOAD
        },
    },
    [Cosmic] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        }
    },
    [Trashcam] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
        [3] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-purple-guy")
        }
    },
    [Skeltan] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        }
    },
    [AgentX] = {
        maxNum = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
            forcePlayer = CT_MARIO,
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }

    },
    [DepressedYoshi] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD
        },
    },
    [Yosho] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        }
    },
    [YoshoAlt] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        }
    },
    [KanHeaven] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Bloxxel64Nya] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Vince] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            forcePlayer = CT_LUIGI,
            icon = get_texture_info("icon-croc")
        }
    },
    [Average] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
            forcePlayer = CT_MARIO,
        },
        [2] = {
            model = smlua_model_util_get_id("paper_mario_geo"),
            modelName = "Paper Mario",
            forcePlayer = CT_MARIO,
            icon = "Default"
        },
        [3] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_WALUIGI
        }
    },
    [Elby] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
    },
    [Crispyman] = {
        maxNum = 4,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
            forcePlayer = CT_MARIO
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
        [4] = {
            model = smlua_model_util_get_id("peepers_geo"),
            modelName = "Peepers",
            forcePlayer = CT_TOAD
        },
    },
    [Butter] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Mathew] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = get_texture_info("icon-mathew")
        }
    },
    [Peachy] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("peach_player_geo"),
            modelName = "Princess Peach",
            forcePlayer = CT_LUIGI
        },
    },
    [Eros] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("eros_geo"),
            modelName = "Eros",
            forcePlayer = CT_MARIO
        },
    },
    [Oquanaut] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("oqua_geo"),
            modelName = "Oqua",
            forcePlayer = CT_TOAD
        }
    },
    [RedBun] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        },
    },
    [Dvk] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("crudelo_geo"),
            modelName = "Crudelo Badge",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [KitKat] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("pepperman_geo"),
            modelName = "Pepperman",
            forcePlayer = CT_WARIO
        }
    },
}