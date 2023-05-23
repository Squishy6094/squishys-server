
print("Connected to Server")

-------------------------
-- Common Use Varibles --
-------------------------

discordID = network_discord_id_from_local_index(0)

------------------
-- Menu Handler --
------------------

if network_is_server() then
    gGlobalSyncTable.RoomStart = get_time()
end

gGlobalSyncTable.bubbleDeath = 0
gGlobalSyncTable.playerInteractions = gServerSettings.playerInteractions
gGlobalSyncTable.playerKnockbackStrength = gServerSettings.playerKnockbackStrength
gGlobalSyncTable.stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar
gGlobalSyncTable.GlobalAQS = true
gGlobalSyncTable.GlobalMoveset = true

gLevelValues.extendedPauseDisplay = true

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
        tabMax = 4,
        [1] = {
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
        [2] = {
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
        },
        [3] = {
            name = "Taunt Menu",
            nameSave = "TauntSave",
            status = tonumber(mod_storage_load("TauntSave")),
            statusMax = 1,
            statusDefault = 1,
            --Description
            Line1 = "Allows you to open a taunt",
            Line2 = "Menu with the L button.",
            Line3 = "",
            Line4 = "(Work In Progress Feature)"
        },
        [4] = {
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
        if i == 4 then
            set_status_and_save(menuTable[3], i, 0)
        else
            set_status_and_save(menuTable[3], i, 1)
        end
    end

    print("Save Data made successfully!")
    mod_storage_save("SaveData", "true")
end

------------------------
-- Custom HUD Handler --
------------------------

local DefaultHUD = 0
local FourThreeLock = 1
local Compact = 2
local Off = 3

_G.StarCounter = nil
_G.TotalStarCounter = nil

hudTable = {
    [DefaultHUD] = {
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