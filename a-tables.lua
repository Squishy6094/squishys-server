-- Only used on bootup, this script contains all of the heafty tables
-- hopefully having them here will ease up the load on the other scripts and make them more consistantly load

-- Themes (High Priority [We really fucking need this])
themeTable = {
    [0] = {
        name = "Default",
        texture = get_texture_info("theme-default"),
        hasHeader = true,
        headerColor = {r = 0, g = 131, b = 0}
    }
}

local maxThemes = 10

function theme_load()
    for i = 1, maxThemes do
        themeTable[i] = nil
    end
    for i = 1, maxThemes do
        if mod_storage_load("UnlockedTheme-"..i) == "Uoker" then
            themeTable[#themeTable + 1] = {
                name = "Uoker",
                saveName = "Uoker",
                color = "\\#5b35ec\\",
                hoverColor = {r = 91, g = 53, b = 236},
                hasHeader = true,
                texture = get_texture_info("theme-uoker"),
                sound = audio_sample_load("tadahh.mp3")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Upper" then
            themeTable[#themeTable + 1] = {
                name = "Castle Upper",
                saveName = "Upper",
                color = "\\#ff1515\\",
                hoverColor = {r = 131, g = 93, b = 99},
                texture = get_texture_info("theme-50door")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Plus" then
            themeTable[#themeTable + 1] = {
                name = "Plusle",
                saveName = "Plus",
                color = "\\#e3616d\\",
                hoverColor = {r = 227, g = 97, b = 109},
                texture = get_texture_info("theme-plus")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Under" then
            themeTable[#themeTable + 1] = {
                name = "Underworld",
                saveName = "Under",
                color = "\\#19ffff\\",
                hoverColor = {r = 25, g = 255, b = 255},
                texture = get_texture_info("theme-underworld")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Crudelo" then
            themeTable[#themeTable + 1] = {
                name = "Crudelo Sphere",
                saveName = "Crudelo",
                color = "\\#910002\\",
                hoverColor = {r = 145, g = 0, b = 2},
                texture = get_texture_info("theme-crudelo")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "StarRoad" then
            themeTable[#themeTable + 1] = {
                name = "Star Road",
                saveName = "StarRoad",
                color = "\\#ffff00\\",
                hoverColor = {r = 255, g = 255, b = 0},
                texture = get_texture_info("theme-starroad")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Cake" then
            themeTable[#themeTable + 1] = {
                name = "Delicious Cake",
                saveName = "Cake",
                color = "\\#ff6666\\",
                hoverColor = {r = 255, g = 100, b = 100},
                texture = get_texture_info("theme-120s")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Heavenly" then
            themeTable[#themeTable + 1] = {
                name = "Heaven's Blessing",
                saveName = "Heavenly",
                color = "\\#ffffff\\",
                hoverColor = {r = 136, g = 119, b = 86},
                texture = get_texture_info("theme-heaven")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Care" then
            themeTable[#themeTable + 1] = {
                name = "The Caretaker",
                saveName = "Care",
                color = "\\#c1417e\\",
                hoverColor = {r = 193, g = 65, b = 126},
                hasHeader = true,
                headerColor = {r = 255, g = 255, b = 255},
                texture = get_texture_info("theme-care")
            }
        elseif mod_storage_load("UnlockedTheme-"..i) == "Poly" then
            themeTable[#themeTable + 1] = {
                name = "Polygonal Chaos",
                saveName = "Poly",
                color = "\\#ff7700\\",
                hoverColor = {r = 255, g = 128, b = 0},
                hasHeader = true,
                headerColor = {r = 255, g = 255, b = 255},
                texture = get_texture_info("theme-poly")
            }
        end
        if mod_storage_load("UnlockedTheme-1") == "nil" then
            themeTable[0].name = "No Themes Unlocked"
        else
            themeTable[0].name = "Default"
        end
    end
    for i = 0, #themeTable do
        menuTable[2][3].statusNames[i] = themeTable[i].name
    end
    menuTable[2][3].statusMax = #themeTable
end

function theme_unlock(themestring, themeexplain)
    for i = 1, #themeTable do
        if themestring == themeTable[i].saveName then
            return
        end
    end

    local m = gMarioStates[0]
    if themeexplain == nil then themeexplain = "No condition provided" end

    for i = 1, maxThemes do
        local currentTheme = mod_storage_load("UnlockedTheme-"..i)

        if currentTheme == themestring then
            -- Theme is already unlocked, stop the loop
            break
        end

        if currentTheme == "nil" or currentTheme == nil then
            -- Save themestring to the current UnlockedTheme slot and stop the loop
            mod_storage_save("UnlockedTheme-"..i, themestring)
            theme_load()
            djui_popup_create("\\#008800\\Squishy's Server\n".. '\\#dcdcdc\\Theme Unlocked!\n'..themeTable[i].color..'"'..themeTable[i].name..'"\n\n\\#8c8c8c\\'..themeexplain, 5)
            if themeTable[i].sound ~= nil then
                audio_sample_play(themeTable[i].sound, m.pos, 1)
            end
            break
        end
    end
end

-- Custom HUD

local DefaultHUD = 0
local FourThreeLock = 1
local Compact = 2
local Off = 3

hudTable = {
    [DefaultHUD] = {
        name = "Default",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 21, y = 15},
            xOffset = {x = 37, y = 15},
            numOffset = {x = 54, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconOffset = {x = -77, y = 15},
            xOffset = {x = -61, y = 15},
            numOffset = {x = -46.8, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -77, y = 33},
            xOffset = {x = -61, y = 33},
            numOffset = {x = -46.8, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            iconOffset = {x = -77, y = 51},
            xOffset = {x = -61, y = 51},
            numOffset = {x = -46.8, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = true,
            compassOffset = {x = -52, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -52, y = 8},
        }
    },
    [FourThreeLock] = {
        name = "4:3 Locked",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = -138, y = 15},
            xOffset = {x = -122, y = 15},
            numOffset = {x = -106, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconOffset = {x = 83, y = 15},
            xOffset = {x = 99, y = 15},
            numOffset = {x = 113.2, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            hideOnTriple = true,
            iconOffset = {x = 83, y = 33},
            xOffset = {x = 99, y = 33},
            numOffset = {x = 113.2, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            hideOnTriple = true,
            iconOffset = {x = 83, y = 51},
            xOffset = {x = 99, y = 51},
            numOffset = {x = 113.2, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 1, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = true,
            compassOffset = {x = 108, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -52, y = 8},
        }
    },
    [Compact] = {
        name = "Compact",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 15},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 20},
        },
        ["Coins"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 35},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 40},
        },
        ["Stars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 55},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 60},
        },
        ["RedStars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            scale = 0.6,
            iconOffset = {x = 20, y = 72},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 77},
        },
        ["GreenStars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            scale = 0.6,
            iconOffset = {x = 20, y = 82},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 87},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 0.8,
            compassShow = true,
            compassOffset = {x = -92, y = 10},
        },
        ["Health"] = {
            alignment = { x = 2, y = 0},
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -70, y = 10},
        }
    },
    [Off] = {
        name = "Disabled",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = false, div = false, num = false},
            iconOffset = {x = 21, y = 15},
            xOffset = {x = 37, y = 15},
            numOffset = {x = 54, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = false, div = false, num = false},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconOffset = {x = -77, y = 15},
            xOffset = {x = -61, y = 15},
            numOffset = {x = -46.8, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -77, y = 33},
            xOffset = {x = -61, y = 33},
            numOffset = {x = -46.8, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            iconOffset = {x = -77, y = 51},
            xOffset = {x = -61, y = 51},
            numOffset = {x = -46.8, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = false,
            compassOffset = {x = -52, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = false,
            meterOffset = {x = -52, y = 8},
        }
    },
}

--Menu

menuTable = {
    [1] = {
        name = "Movement",
        [1] = {
            name = "Moveset",
            nameSave = "MoveSave",
            status = tonumber(mod_storage_load("MoveSave")),
            statusMax = 2,
            statusDefault = 0,
            unlocked = 1,
            lockTo = 0,
            --Status Toggle Names
            statusNames = {
                [-1] = "Forced Default",
                [0] = "Default",
                [1] = "Character",
                [2] = "Quality of Life",
            }, 
            description = {
                "Change small things about",
                "how Mario moves to make",
                "movement feel better"
            },
        },
        [2] = {
            name = "Better Swimming",
            nameSave = "BSSave",
            status = tonumber(mod_storage_load("BSSave")),
            statusMax = 1,
            unlocked = 1,
            statusNames = {
                [-1] = "Forced Off",
            },
            description = {
                "Makes water movement similar",
                "to ground movement, using",
                "Analog for Horozontal Movement",
                "and A & Z for Vertical Movement."
            },
        },
        [3] = {
            name = "Lava Groundpound",
            nameSave = "LGPSave",
            status = tonumber(mod_storage_load("LGPSave")),
            statusMax = 1,
            description = {
                "Ground-Pounding on lava will",
                "give you a speed and height",
                "boost, at the cost of health."
            },
        },
        [4] = {
            name = "Anti-Quicksand",
            nameSave = "AQSSave",
            status = tonumber(mod_storage_load("AQSSave")),
            statusMax = 1,
            unlocked = 1,
            lockTo = 0, 
            --Status Toggle Names
            statusNames = {
            [-1] = "Forced Off",
            },
            description = {
                "Makes instant quicksand act",
                "like lava, preventing what",
                "may seem like an unfair",
                "deaths. (Does not include",
                "Lava Groundpound functions)"
            },
        },
        [5] = {
            name = "Modded Wallkick",
            nameSave = "WKSave",
            status = tonumber(mod_storage_load("WKSave")),
            statusMax = 1, 
            description = {
                "Adds Wallsliding and more",
                "Lenient Angles and Timings",
                "you can wall kick at, best",
                "for a more modern experience."
            },
        },
        [6] = {
            name = "Strafing",
            nameSave = "StrafeSave",
            status = tonumber(mod_storage_load("StrafeSave")),
            statusMax = 1,
            statusDefault = 0, 
            description = {
                "Forces Mario to face the",
                "direction the Camera is",
                "facing, similar to Sonic Robo",
                "Blast 2. Recommended if you",
                "play with Mouse and Keyboard."
            },
        },
        [7] = {
            name = "Ledge Parkour",
            nameSave = "LedgeSave",
            status = tonumber(mod_storage_load("LedgeSave")),
            statusMax = 1, 
            description = {
                "Toggles the ability to press",
                "A or B while moving fast onto",
                "a ledge to trick off of it!",
                "Recommended if you want",
                "to retain your speed going",
                "off a ledge."
            },
        }
    },
    [2] = {
        name = "HUD",
        [1] = {
            name = "HUD Type",
            nameSave = "HUDSave",
            status = tonumber(mod_storage_load("HUDSave")),
            statusMax = 3,
            statusDefault = 0,
            statusNames = {
                [0] = "Default",
                [1] = "4:3 Locked",
                [2] = "Compact",
                [3] = "Disabled",
            },
            description = {
                "Changes which HUD the screen",
                "displays! (WIP)"
            }
        },
        [2] = {
            name = "Prevent HUD Clashing",
            nameSave = "HUDDisableSave",
            status = tonumber(mod_storage_load("HUDDisableSave")),
            statusMax = 2,
            statusDefault = 1,
            statusNames = {
                [2] = "Gamemodes Only",
            },
            description = {
                "Toggles if your HUD",
                "automatically gets set to",
                "Disabled if another mod",
                "has a Custom HUD, This",
                "does not force the HUD to",
                "Disabled."
            }
        },
        [3] = {
            name = "Menu Theme",
            nameSave = "ThemeSave",
            status = tonumber(mod_storage_load("ThemeSave")),
            statusMax = nil,
            statusDefault = 0,
            statusNames = {},
            description = {
                "Toggles what theme the",
                "Server Menu Displays, these",
                "are unlocked via doing",
                "specific tasks or joining",
                "specific events."
            }
        },
        [4] = {
            name = "Menu Descriptions",
            nameSave = "DescSave",
            status = tonumber(mod_storage_load("DescSave")),
            statusMax = 1,
            statusDefault = 1,
            description = {
                "Toggles these descriptions",
                "you see on the right,",
                "Recommended to turn Off if",
                "you like a more minimalistic",
                "menu."
            }
        },
        [5] = {
            name = "Menu Animations",
            nameSave = "MenuAnimSave",
            status = tonumber(mod_storage_load("MenuAnimSave")),
            statusMax = 1,
            statusDefault = 1,
            description = {
                "Toggles Menu Animations like",
                "Transitions and Bobbing.",
                "(Might save Performance if",
                "Toggled Off)"
            }
        },
    },
    [3] = {
        name = "Misc.",
        [1] = {
            name = "Personal Model",
            nameSave = "ModelSave",
            status = tonumber(mod_storage_load("ModelSave")),
            statusMax = nil,
            statusDefault = 1,
            unlocked = 1,
            lockTo = 0,
            statusNames = {
                [0] = "N/A",
                [1] = "N/A",
            },
            description = {
                "Toggles your own Custom",
                "Player Model, Only available",
                "for users with at least",
                "one Custom Model.",
                "",
                "",
                "Contact The Host for more",
                "information about",
                "Custom Models and DynOS"
            }
        },
        [2] = {
            name = "Locally Display Models",
            nameSave = "ModelDisplaySave",
            status = tonumber(mod_storage_load("ModelDisplaySave")),
            statusMax = 1,
            statusDefault = 1, 
            description = {
                "Toggles if Custom Player",
                "Models Display locally,",
                "Recommended if other people's",
                "Custom models are getting",
                "in the way.",
                "",
                "Contact The Host for more",
                "information about",
                "Custom Models and DynOS"
            }
        },
        [3] = {
            name = "Rom-Hack Camera",
            nameSave = "HackCamSave",
            status = tonumber(mod_storage_load("HackCamSave")),
            statusMax = 1,
            statusDefault = 1, 
            description = {
                "Toggles if the camera acts",
                "the same way it does in",
                "Rom-Hacks. (8 directional)"
            }
        },
        [4] = {
            name = "Star Spawn Cutscene",
            nameSave = "SSCSave",
            status = tonumber(mod_storage_load("SSCSave")),
            statusMax = 1,
            statusDefault = 1, 
            description = {
                "Toggles if Star Spawning",
                "Cutscenes play, Recommended",
                "if you don't know where a",
                "star spawns."
            }
        },
        [5] = {
            name = "Server Popups",
            nameSave = "notifSave",
            status = tonumber(mod_storage_load("notifSave")),
            statusMax = 1,
            statusDefault = 1, 
            description = {
                "Shows Tips/Hints about the",
                "server every 3-5 minutes.",
                "Recommended for if you're",
                "new to the server."
            }
        },
        [6] = {
            name = "Show Rules",
            nameSave = "RulesSave",
            status = tonumber(mod_storage_load("RulesSave")),
            statusMax = 1,
            statusDefault = 1, 
            description = {
                "Toggles if the Rules Screen",
                "Displays upon joining. By",
                "turning this option off,",
                "You're confirming that you",
                "have Read and Understand",
                "the Rules."
            }
        }
    },
    [4] = {
        name = "External"
    },
    [5] = {
        name = "Server",
        [1] = {
            name = "Death Type",
            status = tonumber(gServerSettings.bubbleDeath),
            statusMax = 1,
            statusDefault = 1,
            --Status Toggle Names
            statusNames = {
                [0] = "Default",
                [1] = "Bubble",
            }, 
            description = {
                "Chenges how players die",
                "and respawn after death."
            },
        },
        [2] = {
            name = "Player Interactions",
            status = tonumber(gServerSettings.playerInteractions),
            statusMax = 2,
            statusDefault = 2,
            --Status Toggle Names
            statusNames = {
                [0] = "Non-Solid",
                [1] = "Solid",
                [2] = "Friendly Fire",
            }, 
            description = {
                "Changes if and how players",
                "interact with each other."
            },
        },
        [3] = {
            name = "Player Knockback",
            status = gServerSettings.playerKnockbackStrength,
            statusMax = 2,
            statusDefault = 1,
            --Status Toggle Names
            statusNames = {
                [0] = "Weak",
                [1] = "Normal",
                [2] = "Too Much",
            }, 
            description = {
                "Changes how far players get",
                "knocked back after being hit",
                "by another player."
            },
        },
        [4] = {
            name = "On Star Collection",
            status = gServerSettings.stayInLevelAfterStar,
            statusMax = 2,
            statusDefault = 1,
            --Status Toggle Names
            statusNames = {
                [0] = "Leave Level",
                [1] = "Stay in Level",
                [2] = "Non-Stop",
            }, 
            description = {
                "Determines what happens",
                "after you collect a star."
            },
        },
        [5] = {
            name = "Global Movesets",
            status = 1,
            statusMax = 1,
            statusDefault = 1,
            statusNames = {}, 
            description = {
                "Determines if players can",
                "locally change what moveset",
                "they're using, Off forces",
                "everyone to default."
            },
        },
        [6] = {
            name = "Global Anti-Quicksand",
            status = 0,
            statusMax = 1,
            statusDefault = 1,
            statusNames = {}, 
            description = {
                "Determines if players can",
                "locally change AQS or if",
                "it's forced off."
            },
        },
    },
}

function save_load(reset)
    if reset == nil then reset = false end
    for t = 1, 3 do
        for i = 1, #menuTable[t] do
            if menuTable[t][i].statusNames == nil then menuTable[t][i].statusNames = {} end
            if reset or mod_storage_load(menuTable[t][i].nameSave) == nil or menuTable[t][i].status == nil then
                if menuTable[t][i].statusDefault == nil then
                    menuTable[t][i].statusDefault = 1
                end
                menuTable[t][i].status = menuTable[t][i].statusDefault
                mod_storage_save(menuTable[t][i].nameSave, tostring(menuTable[t][i].statusDefault))
            end
        end
    end

    for i = 1, maxThemes do
        if mod_storage_load("UnlockedTheme-"..i) == nil or reset then
            mod_storage_save("UnlockedTheme-"..i, "nil")
        end
    end
end

--Name-2-Model

-- Name = Discord ID
Default = "0"
Squishy = "678794043018182675"
Spoomples = "1028561407433777203"
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
Mathew = "873511038551724152"
Peachy = "732244024567529503"
Eros = "376304957168812032"
Oquanaut = "459762042274840587"
RedBun = "426548210790825984"
Dvk = "542676894244536350"
KitKat = "664638362484867121"
Rise = "371344058167328768"
Yuyake = "397891541160558593"
Plusle = "635629441678180362"
Frosty = "541396312608866305"
Shard = "1064980922371420313"
Isaackie = "1093357396920901643"
TroopaParaKoopa = "984667169738600479"
floofyxd = "1091528175575642122"
flipflop = "603198923120574494"
Koffee = "397847847283720193"
Uoker = "401406794649436161"
Dani = "922231782131265588"
Brob = "1000555727942865036"
Dakun = "358779634625806347"
Loganti = "801151972609622029"
Ryley = "839155992091820053"

modelTable = {
    [Default] = {
        nickname = "Default",
        [0] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        },
        [1] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        },
    },
    [Squishy] = {
        nickname = "Squishy",
        [1] = {
            model = smlua_model_util_get_id("squishy_geo"),
            modelName = "Squishy",
            forcePlayer = CT_MARIO,
            credit = "Trashcam"
        },
        [2] = {
            model = smlua_model_util_get_id("squishy_mc_geo"),
            modelName = "Squishy (Minecraft)",
            forcePlayer = CT_MARIO,
            credit = "Elby"
        },
        [3] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD,
            credit = "BBPanzu / Port by SunSpirit",
        },
        [4] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            icon = 8,
            credit = "sm64rise"
        }
    },
    [Spoomples] = {
        nickname = "Spoomples",
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
            credit = "Depressed Yoshi",
        },
        [2] = {
            model = smlua_model_util_get_id("pacman_geo"),
            modelName = "Pac-Man",
            forcePlayer = CT_MARIO,
            credit = "CosmicMan08"
        },
        [3] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = 8,
            credit = "Trashcam"
        },
    },
    [Nut] = {
        nickname = "Nut",
        [1] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD,
            credit = "Goldenix"
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD,
            credit = "DepressedYoshi"
        },
        [3] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
            credit = "DepressedYoshi"
        },
        [4] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = 7,
            credit = "Trashcam"
        },
        [5] = {
            model = smlua_model_util_get_id("wander_geo"),
            modelName = "Wander",
            forcePlayer = CT_TOAD,
            credit = "AlexXRGames"
        },
    },
    [Cosmic] = {
        nickname = "Cosmic",
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = 2,
            credit = "Cosmic(Wo)Man08"
        }
    },
    [Trashcam] = {
        nickname = "Trashcam",
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = 3,
            credit = "Trashcam"
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = 7,
            credit = "Trashcam"
        },
        [3] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = 6,
            credit = "Trashcam"
        }
    },
    [Skeltan] = {
        nickname = "Skeltan",
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wizard Wooper",
            forcePlayer = CT_MARIO,
            icon = 1,
            credit = "6b"
        }
    },
    [AgentX] = {
        nickname = "Agent X",
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
            forcePlayer = CT_MARIO,
            credit = "Agent X"
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }

    },
    [DepressedYoshi] = {
        nickname = "Depressed Yoshi",
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD,
            credit = "DepressedYoshi"
        },
    },
    [Yosho] = {
        nickname = "Yosho",
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        }
    },
    [KanHeaven] = {
        nickname = "KanHeaven",
        [1] = {
            model = smlua_model_util_get_id("kan_geo"),
            modelName = "KanHeaven",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "KanHeaven"
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Bloxxel64Nya] = {
        nickname = "Bloxxel",
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Vince] = {
        nickname = "0x2480",
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            forcePlayer = CT_LUIGI,
            icon = 12,
            credit = "0x2480"
        }
    },
    [Average] = {
        nickname = "Average <3",
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
            forcePlayer = CT_MARIO,
            credit = "DusterBuster & SunSpirit"
        },
        [2] = {
            model = smlua_model_util_get_id("paper_mario_geo"),
            modelName = "Paper Mario",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "6b"
        },
        [3] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_WALUIGI,
            credit = "TheAnkleDestroyer"
        }
    },
    [Elby] = {
        nickname = "Elby",
        [1] = {
            model = smlua_model_util_get_id("elby_geo"),
            modelName = "Elby",
            forcePlayer = CT_LUIGI,
            icon = 17,
            credit = "Trashcam"
        },
        [2] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD,
            credit = "SolonelyCapybara"
        },
        [3] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default",
        },
        [4] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI,
            credit = "misfiremf & deltomx3"
        },
        [5] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [6] = {
            model = smlua_model_util_get_id("sonic_geo"),
            modelName = "Sonic",
            forcePlayer = CT_MARIO,
            icon = 5,
            credit = "Steven"
        },
        [7] = {
            model = smlua_model_util_get_id("tails_geo"),
            modelName = "Tails",
            forcePlayer = CT_LUIGI,
            icon = 4,
            credit = "brob2nd"
        }
    },
    [Crispyman] = {
        nickname = "Crispy",
        [1] = {
            model = smlua_model_util_get_id("wario_man_geo"),
            modelName = "Wario Man",
            forcePlayer = CT_WARIO,
            credit = "AlexXRGames"
        },
        [2] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
            forcePlayer = CT_LUIGI,
            icon = 11,
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
        [4] = {
            model = smlua_model_util_get_id("peepers_geo"),
            modelName = "Peepers",
            forcePlayer = CT_TOAD,
            credit = "AlexXRGames"
        },
        [5] = {
            model = smlua_model_util_get_id("kirby_geo"),
            modelName = "Kirby",
            forcePlayer = CT_TOAD,
            icon = 10,
            credit = "MSatiro & 6b"
        },
        [6] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [7] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "CheesyNacho"
        },
        [8] = {
            model = smlua_model_util_get_id("mr_l_geo"),
            modelName = "Mr. L",
            forcePlayer = CT_LUIGI,
            icon = "Default",
        },
        [9] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_WALUIGI,
            credit = "TheAnkleDestroyer"
        }
    },
    [Butter] = {
        nickname = "Butter",
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Mathew] = {
        nickname = "Mathew",
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = 9,
            credit = "Mathew"
        }
    },
    [Peachy] = {
        nickname = "PeachyPeach",
        [1] = {
            model = smlua_model_util_get_id("peach_player_geo"),
            modelName = "Princess Peach",
            forcePlayer = CT_MARIO
        },
    },
    [Eros] = {
        nickname = "Eros71",
        [1] = {
            model = smlua_model_util_get_id("eros_geo"),
            modelName = "Eros",
            forcePlayer = CT_MARIO,
            credit = "Eros71"
        },
    },
    [Oquanaut] = {
        nickname = "Oqua",
        [1] = {
            model = smlua_model_util_get_id("oqua_geo"),
            modelName = "Oqua",
            forcePlayer = CT_TOAD,
            credit = "Oquanaut"
        }
    },
    [RedBun] = {
        nickname = "Jonch",
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
    },
    [Dvk] = {
        nickname = "Floralys",
        [1] = {
            model = smlua_model_util_get_id("crudelo_geo"),
            modelName = "Crudelo Badge",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "Floralys"
        },
        [2] = {
            model = smlua_model_util_get_id("casino_luigi_geo"),
            modelName = "Casino Luigi",
            forcePlayer = CT_LUIGI,
            icon = "Default",
            credit = "FluffaMario, CheesyNacho"
        },
        [3] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            icon = "Default", -- I keep this icon disabled on purpose by the way
            credit = "sm64rise"
        },
        [4] = {
            model = smlua_model_util_get_id("paper_mario_geo"),
            modelName = "Paper Mario",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "6b"
        },
        [5] = {
            model = smlua_model_util_get_id("builder_geo"),
            modelName = "Builder Mario",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "MSatiro"
        }
    },
    [KitKat] = {
        nickname = "KitKat",
        [1] = {
            model = smlua_model_util_get_id("pepperman_geo"),
            modelName = "Pepperman",
            forcePlayer = CT_WARIO,
            icon = 14,
            credit = "CheesyNacho"
        }
    },
    [Rise] = {
        nickname = "sm64rise",
        [1] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            icon = 8,
            credit = "sm64rise"
        }
    },
    [Yuyake] = {
        nickname = "Yuyake",
        [1] = {
            model = smlua_model_util_get_id("yuyake_geo"),
            modelName = "Yuyake",
            forcePlayer = CT_MARIO,
            credit = "Yuyake"
        },
        [2] = {
            model = smlua_model_util_get_id("veph_geo"),
            modelName = "Veph the Dolphin-Fox",
            forcePlayer = CT_LUIGI,
            credit = "Yuyake"
        }
    },
    [Plusle] = {
        nickname = "Plus",
        [1] = {
            model = smlua_model_util_get_id("veph_geo"),
            modelName = "Veph the Dolphin-Fox",
            forcePlayer = CT_LUIGI,
            credit = "Yuyake"
        },
        [2] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [3] = {
            model = smlua_model_util_get_id("kirby_geo"),
            modelName = "Kirby",
            forcePlayer = CT_TOAD,
            icon = 10,
            credit = "MSatiro & 6b"
        },
        [4] = {
            model = smlua_model_util_get_id("sonic_geo"),
            modelName = "Sonic",
            forcePlayer = CT_TOAD,
            icon = 5,
            credit = "Steven"
        },
        [5] = {
            model = smlua_model_util_get_id("tails_geo"),
            modelName = "Tails",
            forcePlayer = CT_TOAD,
            icon = 4,
            credit = "brob2nd"
        },
        [6] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "CheesyNacho"
        },
        [7] = {
            model = smlua_model_util_get_id("tiremario_geo"),
            modelName = "Tired",
            forcePlayer = CT_MARIO,
            credit = "Endood,AquariusAlexx and Brobgonal"
        },
        [8] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_LUIGI,
            credit = "TheAnkleDestroyer"
        }
    },
    [Frosty] = {
        nickname = "Frosty",
        [1] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD,
            credit = "BBPanzu / Port by SunSpirit",
        },
    },
    [Shard] = {
        nickname = "Archie",
        [1] = {
            model = smlua_model_util_get_id("archie_geo"),
            modelName = "Archie",
            forcePlayer = CT_WARIO,
            icon = 13,
            credit = "Trashcam",
        },
    },
    [TroopaParaKoopa] = {
        nickname = "TroopaParaKoopa",
        [1] = {
            model = smlua_model_util_get_id("koopa_geo"),
            modelName = "Koopa Shell Mario",
            forcePlayer = CT_MARIO,
            credit = "sm64mods & Brob2nd",
        },
    },
    [floofyxd] = {
        nickname = "Floofy",
        [1] = {
            model = smlua_model_util_get_id("boyfriend_geo"),
            modelName = "Boyfriend",
            forcePlayer = CT_MARIO,
            credit = "KuroButt",
        },
    },
    [flipflop] = {
        nickname = "Flipflop Bell",
        [1] = {
            model = smlua_model_util_get_id("amy_geo"),
            modelName = "Amy",
            forcePlayer = CT_MARIO,
        },
    },
    [Koffee] = {
        nickname = "KoffeeMood",
        [1] = {
            model = smlua_model_util_get_id("lime_geo"),
            modelName = "Lime",
            forcePlayer = CT_LUIGI,
            icon = 15,
            credit = "Trashcam",
        },
        [2] = {
            model = smlua_model_util_get_id("lime_but_awesome_geo"),
            modelName = "Lime (Shades)",
            forcePlayer = CT_LUIGI,
            icon = 15,
            credit = "Trashcam",
        },
    },
    [Uoker] = {
        nickname = "Uoker",
        [1] = {
            model = smlua_model_util_get_id("ari_geo"),
            modelName = "Ari",
            forcePlayer = CT_LUIGI,
            icon = 16,
            credit = "Trashcam",
        },
    },
    [Dani] = {
        nickname = "Dani",
        [1] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            icon = 8,
            credit = "sm64rise"
        },
    },
    [Brob] = {
        nickname = "Brob2nd",
        [1] = {
            model = smlua_model_util_get_id("dk_geo"),
            modelName = "Donkey Kong",
            forcePlayer = CT_WARIO,
            icon = 16,
            credit = "Brob2nd",
        },
        [2] = {
            model = smlua_model_util_get_id("koopa_geo"),
            modelName = "Koopa Shell Mario",
            forcePlayer = CT_MARIO,
            credit = "sm64mods & Brob2nd",
        },
        [3] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [4] = {
            model = smlua_model_util_get_id("tails_geo"),
            modelName = "Tails",
            forcePlayer = CT_TOAD,
            icon = 4,
            credit = "Brob2nd"
        },
        [5] = {
            model = smlua_model_util_get_id("tiremario_geo"),
            modelName = "Tired",
            forcePlayer = CT_MARIO,
            credit = "Endood, AquariusAlexx and Brobgonal"
        },
    },
    [Dakun] = {
        nickname = "Dakun",
        [1] = {
            model = smlua_model_util_get_id("ds_geo"),
            modelName = "SM64DS Mario",
            forcePlayer = CT_MARIO,
            credit = "FluffaMario"
        },
        [2] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            credit = "sm64rise"
        }
    },
    [Loganti] = {
        nickname = "Loganti",
        [1] = {
            model = smlua_model_util_get_id("hd_mario_geo"),
            modelName = "HD Mario",
            forcePlayer = CT_MARIO,
            credit = "MSatiro"
        }
    },
    [Ryley] = {
        nickname = "Ryley",
        [1] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD,
            credit = "BBPanzu / Port by SunSpirit",
        },
    }
}