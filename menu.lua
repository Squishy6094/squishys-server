--Optimization I guess
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_font = djui_hud_set_font
local djui_hud_set_color = djui_hud_set_color
local djui_hud_print_text = djui_hud_print_text
local mod_storage_load = mod_storage_load
local mod_storage_save = mod_storage_save
local tostring = tostring
local get_texture_info = get_texture_info
local audio_sample_load = audio_sample_load
local tonumber = tonumber
local tobool = tobool
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_get_screen_width = djui_hud_get_screen_width
local djui_hud_get_screen_height = djui_hud_get_screen_height
local djui_hud_render_texture_tile = djui_hud_render_texture_tile
local is_game_paused = is_game_paused
local djui_hud_is_pause_menu_created = djui_hud_is_pause_menu_created
local djui_hud_set_render_behind_hud = djui_hud_set_render_behind_hud
local play_sound = play_sound
local network_player_connected_count = network_player_connected_count

local menu = false
menu_open = function (toggle)
    if toggle ~= nil then
        menu = toggle
    else
        return menu
    end
end

local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1
local scrolling = 0
local sparklesOptionHover = 0

local MAX_THEMES = 11
local MAX_DESCRIPTION_LENGTH = 9

local MENU_TABS = {
    movement = 1,
    hud = 2,
    camera = 3,
    misc = 4
}
local MENU_TAB_MOVEMENT = {
    moveset = 1,
    betterSwimming = 2,
    lavaGroundPound = 3,
    antiQuickSand = 4,
    moddedWallkick = 5,
    strafing = 6,
    ledgeParkour = 7,
}
local MENU_TAB_HUD = {
    hudType = 1,
    clashing = 2,
    theme = 3,
    descriptions = 4,
    animations = 5,
    timer = 6,
}
local MENU_TAB_CAMERA = {
    romhackCamera = 1,
    starSpawnCutscene = 2,
}
local MENU_TAB_MISC = {
    personalModel = 1,
    displayModels = 2,
    popups = 3,
    rules = 4,
    credits = 5,
}

local KBTranslate = 0

---@param reset boolean
function save_data_load(reset)
    for tab = 1, 4 do
        for option = 1, #menuTable[tab] do
            local current_option = menuTable[tab][option]
            if not current_option.statusNames then menuTable[tab][option].statusNames = {} end
            if current_option.nameSave and (reset or not mod_storage_load(current_option.nameSave) or current_option.status == nil or tonumber(mod_storage_load(current_option.nameSave)) > current_option.statusMax) then
                if current_option.statusDefault == nil --[[explicit nil check because `not` doesn't work]] then
                    menuTable[tab][option].statusDefault = 1
                end
                menuTable[tab][option].status = current_option.statusDefault
                mod_storage_save(current_option.nameSave, tostring(current_option.statusDefault))
            end
        end
    end

    for i = 1, MAX_THEMES do
        if reset or not mod_storage_load("UnlockedTheme-"..i) then
            mod_storage_save("UnlockedTheme-"..i, "nil")
        end
    end

    if reset or not mod_storage_load("SSplaytime") then
        mod_storage_save("SSplaytime", "0")
        reset_loaded_save_time()
    end
end

warioChallengeComplete = false
function theme_load()
    for i = 1, MAX_THEMES do
        themeTable[i] = nil
    end
    -- Create themes
    -- I cannot be bothered to load all of these textures and audio samples externally
    for i = 1, MAX_THEMES do
        local loaded_theme_name = mod_storage_load("UnlockedTheme-"..i)
        if loaded_theme_name == "Uoker" then
            themeTable[#themeTable + 1] = {
                name = "Uoker",
                saveName = "Uoker",
                color = "\\#5b35ec\\",
                hoverColor = {r = 91, g = 53, b = 236},
                hasHeader = true,
                texture = get_texture_info("theme-uoker"),
                sound = audio_sample_load("tadahh.mp3")
            }
        elseif loaded_theme_name == "Upper" then
            themeTable[#themeTable + 1] = {
                name = "Castle Upper",
                saveName = "Upper",
                color = "\\#ff1515\\",
                hoverColor = {r = 131, g = 93, b = 99},
                texture = get_texture_info("theme-50door")
            }
        elseif loaded_theme_name == "Plus" then
            themeTable[#themeTable + 1] = {
                name = "Plusle",
                saveName = "Plus",
                color = "\\#e3616d\\",
                hoverColor = {r = 227, g = 97, b = 109},
                texture = get_texture_info("theme-plus")
            }
        elseif loaded_theme_name == "Under" then
            themeTable[#themeTable + 1] = {
                name = "Underworld",
                saveName = "Under",
                color = "\\#19ffff\\",
                hoverColor = {r = 25, g = 255, b = 255},
                texture = get_texture_info("theme-underworld")
            }
        elseif loaded_theme_name == "Crudelo" then
            themeTable[#themeTable + 1] = {
                name = "Crudelo Sphere",
                saveName = "Crudelo",
                color = "\\#910002\\",
                hoverColor = {r = 145, g = 0, b = 2},
                texture = get_texture_info("theme-crudelo")
            }
        elseif loaded_theme_name == "StarRoad" then
            themeTable[#themeTable + 1] = {
                name = "Star Road",
                saveName = "StarRoad",
                color = "\\#ffff00\\",
                hoverColor = {r = 255, g = 255, b = 0},
                texture = get_texture_info("theme-starroad")
            }
        elseif loaded_theme_name == "Cake" then
            themeTable[#themeTable + 1] = {
                name = "Delicious Cake",
                saveName = "Cake",
                color = "\\#ff6666\\",
                hoverColor = {r = 255, g = 100, b = 100},
                texture = get_texture_info("theme-120s")
            }
        elseif loaded_theme_name == "Heavenly" then
            themeTable[#themeTable + 1] = {
                name = "Heaven's Blessing",
                saveName = "Heavenly",
                color = "\\#ffffff\\",
                hoverColor = {r = 136, g = 119, b = 86},
                texture = get_texture_info("theme-heaven")
            }
        elseif loaded_theme_name == "Care" then
            themeTable[#themeTable + 1] = {
                name = "The Caretaker",
                saveName = "Care",
                color = "\\#c1417e\\",
                hoverColor = {r = 193, g = 65, b = 126},
                hasHeader = true,
                headerColor = {r = 255, g = 255, b = 255},
                textColor = {r = 193, g = 65, b = 126},
                texture = get_texture_info("theme-care")
            }
        elseif loaded_theme_name == "Poly" then
            themeTable[#themeTable + 1] = {
                name = "Polygonal Chaos",
                saveName = "Poly",
                color = "\\#ff7700\\",
                hoverColor = {r = 255, g = 128, b = 0},
                hasHeader = true,
                headerColor = {r = 255, g = 255, b = 255},
                textColor = {r = 255, g = 128, b = 0},
                texture = get_texture_info("theme-poly")
            }
        elseif loaded_theme_name == "Wario" then
            themeTable[#themeTable + 1] = {
                name = "Wario World",
                saveName = "Wario",
                color = "\\#ffff00\\",
                hoverColor = {r = 255, g = 255, b = 0},
                hasHeader = true,
                headerColor = {r = 255, g = 255, b = 255},
                textColor = {r = 255, g = 255, b = 0},
                texture = get_texture_info("theme-ww")
            }
            warioChallengeComplete = true
        end

        if mod_storage_load("UnlockedTheme-1") == "nil" then
            themeTable[0].name = "No Themes Unlocked"
        else
            themeTable[0].name = "Default"
        end

        if tonumber(mod_storage_load("ThemeSave")) > #themeTable then
            mod_storage_save("ThemeSave", "0")
            menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].status = 0
        end
    end

    for i = 0, #themeTable do
        menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].statusNames[i] = themeTable[i].name
    end
    menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].statusMax = #themeTable
end

---@param theme_name string
---@param theme_description string?
---@param m MarioState Faster to pass around a MarioState rather than make a new one
function theme_unlock(theme_name, theme_description, m)
    for i = 1, #themeTable do
        if theme_name == themeTable[i].saveName then
            return
        end
    end
    if not theme_description then theme_description = "No description provided" end

    for i = 1, MAX_THEMES do
        local currentTheme = mod_storage_load("UnlockedTheme-"..i)

        -- Here for safety but is already checked above
        if currentTheme == theme_name then
            -- Theme is already unlocked, stop the loop
            break
        end

        -- If the value does not exist, unlock the theme
        -- ! Binary search can be faster here if more and more themes are added
        if not currentTheme or currentTheme == "nil" then
            -- Save themestring to the current UnlockedTheme slot and stop the loop
            mod_storage_save("UnlockedTheme-"..i, theme_name)
            theme_load()
            djui_chat_or_popup_message_create("\\#008800\\Squishy's Server\n ".. '\\#dcdcdc\\Theme Unlocked!\n '..themeTable[i].color..'"'..themeTable[i].name..'"\n\n \\#8c8c8c\\'..theme_description, 5)
            if themeTable[i].sound then
                audio_sample_play(themeTable[i].sound, m.pos, 1)
            end
            break
        end
    end
end

local function setup_ss_menu()
    menuTable = {
        [MENU_TABS.movement] = {
            name = "Movement",
            viewable = true,
            [MENU_TAB_MOVEMENT.moveset] = {
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
            [MENU_TAB_MOVEMENT.betterSwimming] = {
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
            [MENU_TAB_MOVEMENT.lavaGroundPound] = {
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
            [MENU_TAB_MOVEMENT.antiQuickSand] = {
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
            [MENU_TAB_MOVEMENT.moddedWallkick] = {
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
            [MENU_TAB_MOVEMENT.strafing] = {
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
            [MENU_TAB_MOVEMENT.ledgeParkour] = {
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
        [MENU_TABS.hud] = {
            name = "HUD",
            viewable = true,
            [MENU_TAB_HUD.hudType] = {
                name = "HUD Type",
                nameSave = "HUDSave",
                status = tonumber(mod_storage_load("HUDSave")),
                statusMax = 5,
                statusDefault = 0,
                statusNames = {
                    [0] = "Default",
                    [1] = "4:3 Locked",
                    [2] = "Compact",
                    [3] = "No Hud",
                    [4] = "Wario World"
                },
                description = {
                    "Changes which HUD the screen",
                    "displays! (WIP)"
                }
            },
            [MENU_TAB_HUD.clashing] = {
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
            [MENU_TAB_HUD.theme] = {
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
            [MENU_TAB_HUD.descriptions] = {
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
            [MENU_TAB_HUD.animations] = {
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
            [MENU_TAB_HUD.timer] = {
                name = "Timer",
                nameSave = "TimerSave",
                status = tonumber(mod_storage_load("TimerSave")),
                statusMax = 4,
                statusDefault = 0,
                statusNames = {
                    [0] = "Off",
                    [1] = "In Level",
                    [2] = "Room Opened",
                    [3] = "Since Joined",
                    [4] = "Total Play Time",
                },
                description = {
                    "Toggles a Pizza Tower Type",
                    "Timer that displays whatever",
                    "you choose",
                }
            },
        },
        [MENU_TABS.camera] = {
            name = "Camera",
            viewable = true,
            [MENU_TAB_CAMERA.romhackCamera] = {
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
            [MENU_TAB_CAMERA.starSpawnCutscene] = {
                name = "Star Spawn Cutscene",
                nameSave = "SSCSave",
                status = tonumber(mod_storage_load("SSCSave")),
                statusMax = 1,
                statusDefault = 0,
                description = {
                    "Toggles if Star Spawning",
                    "Cutscenes play, Recommended",
                    "if you don't know where a",
                    "star spawns."
                }
            },
        },
        [MENU_TABS.misc] = {
            name = "Misc.",
            viewable = true,
            [MENU_TAB_MISC.personalModel] = {
                name = "Personal Model",
                nameSave = "ModelSave",
                status = tonumber(mod_storage_load("ModelSave")),
                statusMax = nil,
                statusDefault = 1,
                unlocked = 1,
                lockTo = 0,
                statusNames = {
                    [-1] = "N/A",
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
            [MENU_TAB_MISC.displayModels] = {
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
            [MENU_TAB_MISC.popups] = {
                name = "Server Notifications",
                nameSave = "notifSave",
                status = tonumber(mod_storage_load("notifSave")),
                statusMax = 2,
                statusDefault = 1,
                statusNames = {
                    [0] = "Don't show",
                    [1] = "Show as Pop-up",
                    [2] = "Show as Chat Message",
                },
                description = {
                    "Shows Tips/Hints about the",
                    "server every 3-5 minutes.",
                    "Recommended for if you're",
                    "new to the server."
                }
            },
            [MENU_TAB_MISC.rules] = {
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
            },
            --[[
            [MENU_TAB_MISC.credits] = {
                name = "Credits",
                status = 0,
                statusMax = 1,
                statusDefault = 0,
                description = {
                    "Shows off everyone who has ",
                    "helped make this mod what ",
                    "it is today, Thank you all",
                    "so much!",
                }
            }
            --]]
        },
        [6] = {
            name = "Server",
            viewable = false,
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
end

local function setup_ss_menu_misc()
    if gServerSettings.playerKnockbackStrength == 10 then
        KBTranslate = 0
    elseif gServerSettings.playerKnockbackStrength == 25 then
        KBTranslate = 1
    elseif gServerSettings.playerKnockbackStrength == 60 then
        KBTranslate = 2
    end

    gGlobalSyncTable.syncData = tostring(gServerSettings.bubbleDeath) .. " " .. tostring(gServerSettings.playerInteractions) .. " " .. tostring(KBTranslate) .. " " .. tostring(gServerSettings.stayInLevelAfterStar) .. " " .. tostring(1) .. " " .. tostring(1)

    gLevelValues.extendedPauseDisplay = true

    sparklesOptionHover = #menuTable[MENU_TABS.misc]+1
    if network_is_developer() then
        menuTable[MENU_TABS.misc][sparklesOptionHover] = {
            name = "Developer Particles",
            nameSave = "DvSpks",
            status = tonumber(mod_storage_load("DvSpks")),
            statusMax = 1,
            statusDefault = 0,
            description = {
                "Displays particles around you",
                "if you are a developer."
            }
        }

        doSparkles = tobool(menuTable[MENU_TABS.misc][sparklesOptionHover].status)
    end

    save_data_load(false)

    for i in pairs(gActiveMods) do
        local name = gActiveMods[i].name
        local incompatible = gActiveMods[i].incompatible

        -- Mod Check Preventing Moveset Clashing
        if (incompatible and incompatible:find("moveset")) or name:find("Pasta Castle") then
            menuTable[6][5].status = 0
            menuTable[MENU_TABS.movement][MENU_TAB_MOVEMENT.moveset].statusNames[-1] = "External Moveset"
            gGlobalSyncTable.syncData = tostring(gServerSettings.bubbleDeath) .. " " .. tostring(gServerSettings.playerInteractions) .. " " .. tostring(KBTranslate) .. " " .. tostring(gServerSettings.stayInLevelAfterStar) .. " " .. tostring(0) .. " " .. tostring(1)
        end
        -- Mod Check Preventing HUD Overlapping
        if menuTable[MENU_TABS.hud][MENU_TAB_HUD.clashing].status ~= 0 then
            local hudType = menuTable[MENU_TABS.hud][MENU_TAB_HUD.hudType]
            if (incompatible and incompatible:find("gamemode")) and not (name:find("Personal Star Counter EX+")) and not (name:find("\\#00ffff\\Mario\\#ff5a5a\\Hun\\\\t")) and menuTable[MENU_TABS.hud][MENU_TAB_HUD.clashing].status > 0 then
                hudType.status = 3
                hudType.statusNames[3] = "External HUD"
            end
            if (name:find("OMM Rebirth")) or (name:find("Super Mario 64: The Underworld")) or (name:find("Super Mario Parallel Stars")) and menuTable[MENU_TABS.hud][MENU_TAB_HUD.clashing].status == 1 then
                hudType.status = 3
                hudType.statusNames[3] = "External HUD"
            end
        end
    end
end

local function setup_themes()
    themeTable = {
        [0] = {
            name = "Default",
            texture = get_texture_info("theme-default"),
            hasHeader = true,
            headerColor = {r = 0, g = 131, b = 0}
        }
    }

    theme_load()
end


local noLoopSound = true
local descSlide = -100
local bobbing = 0
local bobbingInt = 0

local function ss_menu_handler(m)
    djui_hud_set_resolution(RESOLUTION_N64)

    local current_tab = menuTable[optionTab]
    local next_option = current_tab[optionHover + scrolling]
    local current_theme = themeTable[menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].status]

    local audio_sample = current_theme.sound
    if noLoopSound and audio_sample then
        audio_sample_play(audio_sample, m.pos, 1)
    end
    noLoopSound = false

    if menuTable[MENU_TABS.hud][MENU_TAB_HUD.animations].status == 1 then
        bobbingInt = bobbingInt + 0.01
        bobbing = math.sin(bobbingInt)*2
        if descSlide < -1 then
            descSlide = descSlide*0.83333333333
        end
    else
        descSlide = -1
    end

    local hover_color = current_theme.hoverColor
    local header_color = current_theme.headerColor
    local text_color = current_theme.textColor

    if not hover_color then
        current_theme.hoverColor = {r = 150, g = 150, b = 150}
        hover_color = current_theme.hoverColor
    end
    if not header_color then
        current_theme.headerColor = hover_color
        header_color = current_theme.headerColor
    end
    if not text_color then
        current_theme.textColor = hover_color
        text_color = current_theme.textColor
    end

    local screen_width = djui_hud_get_screen_width()
    local screen_height = djui_hud_get_screen_height()
    local half_screen_width = screen_width * 0.5
    local half_screen_height = screen_height * 0.5

    djui_hud_set_color(0, 0, 0, 150)
    djui_hud_render_rect(0, 0, screen_width + 5, 240)

    if menuTable[MENU_TABS.hud][MENU_TAB_HUD.descriptions].status == 1 then
        djui_hud_set_color(255, 255, 255, 200)
        djui_hud_render_texture_tile(current_theme.texture, (half_screen_width + 91) + descSlide, (half_screen_height - 42) - bobbing, 1.3, 1.3, 176, 0, 80, 80)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect((half_screen_width + 93) + descSlide, (half_screen_height - 40) - bobbing, 100, 100)
        djui_hud_set_color(text_color.r, text_color.g, text_color.b, 255)
        djui_hud_print_text(next_option.name, (half_screen_width + 100) + descSlide, 85 - bobbing, 0.35)
        djui_hud_set_color(255, 255, 255, 255)
        for i = 1, MAX_DESCRIPTION_LENGTH do
            local line = next_option.description[i]
            if line then
                djui_hud_print_text(line, half_screen_width + 100 + descSlide, (100 + (i - 1) * 8) - bobbing, 0.3)
            end
        end
        djui_hud_print_text("Room has been Open for:", half_screen_width + 143 - djui_hud_measure_text("Room has been Open for:")*0.15 + descSlide, 48 - bobbing, 0.3)
        djui_hud_print_text(RoomTime, half_screen_width + 143 - djui_hud_measure_text(RoomTime)*0.35 + descSlide, 55 - bobbing, 0.7)
    end

    djui_hud_set_font(FONT_MENU)
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(255, 255, 255, 200)
    djui_hud_render_texture_tile(current_theme.texture, (half_screen_width - 88), (half_screen_height - 93) + bobbing, 1.16477272727, 1, 0, 0, 176, 205)
    djui_hud_set_color(0, 0, 0, 220)
    djui_hud_render_rect((half_screen_width - 85), (half_screen_height - 90) + bobbing, 170, 199)
    djui_hud_set_color(header_color.r, header_color.g, header_color.b, 255)
    if current_theme.hasHeader then
        djui_hud_render_texture_tile(current_theme.texture, (half_screen_width - 53), (half_screen_height - 85) + bobbing, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
    else
        djui_hud_render_texture_tile(themeTable[0].texture, (half_screen_width - 53), (half_screen_height - 85) + bobbing, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
    end

    --Toggles--
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_resolution(RESOLUTION_N64)
    if network_has_permissions() then
        menuTable[6].viewable = true
    end

    -- New Tab Renderer
    for i = -1, 1 do
        local tab = menuTable[optionTab + i]
        if tab and tab.viewable then
            djui_hud_set_color(hover_color.r, hover_color.g, hover_color.b, 200)
            if i == 0 then
                djui_hud_render_rect(half_screen_width - 15, 70 + bobbing, 30, 9)
                djui_hud_set_color(255, 255, 255, 255)
            end
            djui_hud_print_text(tab.name, (half_screen_width - (djui_hud_measure_text(tab.name) * 0.3 / 2) + i * 30), 70 + bobbing, 0.3)
        end
    end

    if discordID ~= "0" then
        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_print_text("Registered as "..name2model_get_nickname().. " via Name-2-Model", (half_screen_width - 80), 216 + bobbing, 0.3)
    else
        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_print_text("Unregistered via Name-2-Model / ".. menuErrorMsg, (half_screen_width - 80), 216 + bobbing, 0.3)
    end

    djui_hud_set_color(hover_color.r, hover_color.g, hover_color.b, 200)
    djui_hud_render_rect((half_screen_width - 72), 80 + (optionHover * 10 - 10) + bobbing, 70, 9)
    djui_hud_set_color(255, 255, 255, 255)

    if optionHover < 1 then
        optionHover = #current_tab - scrolling
    elseif optionHover > #current_tab then
        optionHover = 1
    end

    if next_option.status then
        if not next_option.unlocked then next_option.unlocked = 1 end
        local status_names = next_option.statusNames
        if not status_names[1] then status_names[1] = "On" end
        if not status_names[0] then status_names[0] = "Off" end

        if next_option.unlocked ~= 1 then
            djui_hud_print_text(next_option.statusNames[-1], (half_screen_width), 70 + (optionHover * 10) + bobbing, 0.3)
            next_option.status = next_option.lockTo
        elseif next_option.statusNames[next_option.status] then
            djui_hud_print_text(next_option.statusNames[next_option.status], (half_screen_width), 70 + (optionHover * 10) + bobbing, 0.3)
        end
    else
        if next_option.statusDefault then
            next_option.status = next_option.statusDefault
        else
            next_option.status = 1
        end
        djui_hud_print_text("Making Save Data...", (half_screen_width), 70 + (optionHover * 10) + bobbing, 0.3)
        mod_storage_save(next_option.nameSave, tostring(next_option.status))
        print("Autofilled Toggle for '" ..next_option.nameSave "' created.")
    end

    local model_status = menuTable[MENU_TABS.misc][MENU_TAB_MISC.personalModel].status
    if optionTab == 4 and optionHover == 1 and model_status ~= 0 then
        djui_hud_set_color(128, 128, 128, 255)
        local credit = name2model_get_model_credit()
        if credit then
            djui_hud_print_text("By ".. (credit or "Unknown"), half_screen_width, 90 + bobbing, 0.2)
        end
    end

    local sparkles_possible = menuTable[MENU_TABS.misc][sparklesOptionHover]
    if sparkles_possible then
        doSparkles = tobool(sparkles_possible.status)
    end

    for i = 1, #current_tab do
        if i < 14 then
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(current_tab[i + scrolling].name, half_screen_width - 70, (80 + (i - 1) * 10) + bobbing, 0.3)
        end
    end

    local hoverText = tostring(optionHover + scrolling).." / "..tostring(#current_tab)
    djui_hud_set_color(128, 128, 128, 255)
    djui_hud_print_text("Option:", half_screen_width + 80 - djui_hud_measure_text("Option: "..hoverText)*0.25, 35 + bobbing, 0.25)
    djui_hud_set_color(255, 255, 255, 255)
    local x = 0
    if (optionHover + scrolling) >= 10 then x = x + 1 end
    if #current_tab >= 10 then x = x + 1 end
    djui_hud_print_text(hoverText, half_screen_width + 80 - x - djui_hud_measure_text(hoverText)*0.25, 35 + bobbing, 0.25)
end

local voteTimer = 3600
local voteSlide = -150
local prevVote = ""
local voteScale = 1

local function ss_vote_handler()
    if gGlobalSyncTable.vote then
        if voteSlide < -1 then
            voteSlide = voteSlide/1.1
        end
        prevVote = gGlobalSyncTable.vote
    else
        if voteSlide > -150 then
            voteSlide = voteSlide*1.1
        end
    end
    if voteSlide > -150 then
        local current_theme = themeTable[menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].status]

        voteTimer = voteTimer - 1
        djui_hud_set_color(255, 255, 255, 200)
        djui_hud_render_texture_tile(current_theme.texture, 10 + voteSlide, 100, 1, 1, 176, 0, 80, 80)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect(12 + voteSlide, 102, 76, 76)
        djui_hud_set_color(current_theme.textColor.r, current_theme.textColor.g, current_theme.textColor.b, 255)
        djui_hud_print_text("Vote:", 15 + voteSlide, 105, 0.35)
        if voteTimer > 0 then
            djui_hud_print_text(tostring(math.ceil(voteTimer/30)).."s left", 84 - djui_hud_measure_text(tostring(math.ceil(voteTimer/30)).."s left")*0.35 + voteSlide, 105, 0.35)
        else
            djui_hud_print_text("Ended", 84 - djui_hud_measure_text("Ended")*0.35 + voteSlide, 105, 0.35)
        end
        if djui_hud_measure_text(prevVote)*0.32 > 70 then
            voteScale = djui_hud_measure_text(prevVote)*0.32 / 70
        else
            voteScale = 1
        end
        djui_hud_print_text(prevVote, 15 + voteSlide, 115, 0.32 / voteScale)
        local votedYes = 0
        local votedNo = 0
        local votedTotal = 0
        for i = 0, MAX_PLAYERS - 1 do
            if gPlayerSyncTable[i].vote then
                votedYes = votedYes + 1
            else
                votedNo = votedNo + 1
            end
            votedTotal = votedTotal + 1
        end
        if votedTotal == network_player_connected_count() and voteTimer > 0 then
            voteTimer = 0
        end
        djui_hud_set_color(current_theme.hoverColor.r, current_theme.hoverColor.g, current_theme.hoverColor.b, 255)
        djui_hud_render_rect(14 + voteSlide, 135.5, 72*votedYes/votedTotal, 9)
        djui_hud_render_rect(14 + voteSlide, 145.5, 72*votedNo/votedTotal, 9)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Yes: "..tostring(votedYes), 16 + voteSlide, 135, 0.32)
        djui_hud_print_text("No: "..tostring(votedNo), 16 + voteSlide, 145, 0.32)
        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_print_text('Use "/ss vote" to vote!', 15 + voteSlide, 164, 0.2)
        djui_hud_print_text(tostring(votedTotal).."/"..tostring(network_player_connected_count()).." players have voted", 15 + voteSlide, 170, 0.2)
        if voteTimer == 0 then
            if votedYes > votedNo then
                play_sound(SOUND_GENERAL2_RIGHT_ANSWER, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            elseif votedYes < votedNo then
                play_sound(SOUND_OBJ2_BOWSER_ROAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            end
        end
        if voteTimer == -300 then
            gGlobalSyncTable.vote = nil
            for i = 0, MAX_PLAYERS - 1 do
                gPlayerSyncTable[i].vote = nil
            end
        end
    else
        voteTimer = 3600
    end
end

oWario = 0
warioTimer = 0
warioChallenge = 0
playedWarioSound = false

local TEXT_SERVER_OPTIONS = "L Button - Server Options"
local function hud_render()
    local m = gMarioStates[0]

    if BootupTimer == 30 then
        setup_ss_menu()
        BootupInfo = BOOTUP_LOADED_MENU_DATA
    end

    if BootupTimer == 45 then
        setup_ss_menu_misc()
        BootupInfo = BOOTUP_FINISHED_MENU_SETUP
    end

    if BootupTimer == 60 then
        setup_themes()
        BootupInfo = BOOTUP_LOADED_THEME_DATA
    end

    if BootupTimer < 90 then return end

    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    local half_screen_width = djui_hud_get_screen_width() * 0.5

    if is_game_paused() and not djui_hud_is_pause_menu_created() then
        djui_hud_set_render_behind_hud(false)
        if m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text(TEXT_SERVER_OPTIONS, (half_screen_width - (djui_hud_measure_text(TEXT_SERVER_OPTIONS)*0.5)) + 1, 43, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(TEXT_SERVER_OPTIONS, (half_screen_width - (djui_hud_measure_text(TEXT_SERVER_OPTIONS)*0.5)), 42, 1)
        end
    end

    if menu then
        ss_menu_handler(m)
    else
        noLoopSound = true
        descSlide = -100
    end

    ss_vote_handler()
end


local function before_update(m)
    if m.playerIndex ~= 0 or BootupTimer < 150 then return end

    if menu then
        if optionHoverTimer >= 5 then
            optionHoverTimer = -1
        end
        if optionHoverTimer ~= -1 then
            optionHoverTimer = optionHoverTimer + 1
        end

        local stickX = m.controller.stickX
        local stickY = m.controller.stickY
        local buttonDown = m.controller.buttonDown
        if optionHoverTimer == -1 then
            if (stickX < -10 or (buttonDown & L_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                scrolling = 0
                optionTab = optionTab - 1
                if optionTab == 5 and menuTable[5][1] == nil then
                    optionTab = 4
                end
                optionHoverTimer = 0
            elseif (stickX > 10 or (buttonDown & R_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                scrolling = 0
                optionTab = optionTab + 1
                if optionTab == 5 and menuTable[5][1] == nil then
                    optionTab = 6
                end
                optionHoverTimer = 0
            end
        end

        if optionHoverTimer == -1 then
            if (stickY < -10 or (buttonDown & D_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                optionHover = optionHover + 1
                optionHoverTimer = 0
            elseif (stickY > 10 or (buttonDown & U_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                optionHover = optionHover - 1
                optionHoverTimer = 0
            end
        end

        local maxTabLimit = 5
        if (network_has_permissions()) then
            maxTabLimit = 6
        end

        if optionTab > maxTabLimit then optionTab = 1 end
        if optionTab < 1 then optionTab = maxTabLimit end

        local current_tab = menuTable[optionTab]
        if optionHover > #current_tab then
            optionHover = 1
        end
        if optionHover > (#current_tab - scrolling) and scrolling > 0 then
            if optionHover > 12 and scrolling <= (#current_tab - 14) then
                scrolling = scrolling + 1
                optionHover = #current_tab - scrolling
            elseif optionHover > 12 and scrolling > (#current_tab - 14) then
                optionHover = 1
                scrolling = 0
            else
                optionHover = 1
            end
        elseif optionHover > (#current_tab - scrolling - 1) and scrolling == 0 then
            if optionHover > 12 and scrolling <= (#current_tab - 14) then
                scrolling = scrolling + 1
                optionHover = #current_tab - scrolling
            end
        end
        if optionHover < 1 then
            if #current_tab > 13 and scrolling == 0 then
                scrolling = #current_tab - 13
                optionHover = #current_tab - scrolling
            elseif #current_tab > 13 and scrolling > 0 then
                scrolling = scrolling - 1
                optionHover = 1
            else
                optionHover = #current_tab
            end
        end

        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            local next_option = menuTable[optionTab][optionHover + scrolling]

            optionHoverTimer = 0
            if next_option.unlocked ~= 1 then
                play_sound(SOUND_MENU_CAMERA_BUZZ, m.marioObj.header.gfx.cameraToObject)
                print("Could not change status")
            else
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                next_option.status = next_option.status + 1
                if next_option.status > next_option.statusMax then
                    next_option.status = 0
                end
                if next_option.nameSave then
                    mod_storage_save(next_option.nameSave, tostring(next_option.status))
                end
                if network_has_permissions() then
                    if optionTab == 6 and optionHover >= 1 then
                        djui_popup_create_global("\\#00aa00\\Squishy's Server Ruleset:\n\\#ffff77\\"..next_option.name.."\\#dcdcdc\\ was set to \\#ffff00\\"..tostring(next_option.statusNames[next_option.status].."\\#dcdcdc\\!"), 3)
                    end
                end
            end
        end

        if (m.controller.buttonPressed & B_BUTTON) ~= 0 or (m.controller.buttonPressed & START_BUTTON) ~= 0 and menu then
            print("Saving configuration to 'squishys-server.sav'")
            menu = false
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        end

        nullify_inputs(m)
    end

    if is_game_paused() and not djui_hud_is_pause_menu_created() and m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
        if (m.controller.buttonDown & L_TRIG) ~= 0 and not menu then
            m.controller.buttonPressed = START_BUTTON
            menu = true
            play_sound(SOUND_MENU_MESSAGE_APPEAR, m.marioObj.header.gfx.cameraToObject)
        end
    end
end

function on_menu_command(msg)
    local m = gMarioStates[0]
    args = string_split(msg)
    if not args[2] then
        if menu then
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        else
            play_sound(SOUND_MENU_MESSAGE_APPEAR, m.marioObj.header.gfx.cameraToObject)
        end
        menu = not menu
        return true
    end
    if args[4] then
        local arg_2, arg_3, arg_4 = tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        local current_selected_option = menuTable[arg_2][arg_3]
        if not current_selected_option.statusNames[1] then current_selected_option.statusNames[1] = "On" end
        if not current_selected_option.statusNames[0] then current_selected_option.statusNames[0] = "Off" end
        if arg_4 >= 0 and arg_4 <= current_selected_option.statusMax then
            current_selected_option.status = arg_4
            djui_chat_message_create(current_selected_option.name.." set to "..tostring(current_selected_option.statusNames[current_selected_option.status]))
            if current_selected_option.nameSave then
                mod_storage_save(current_selected_option.nameSave, tostring(current_selected_option.status))
            end
            menu = false
            if network_has_permissions() then
                if arg_2 == 6 and arg_4 <= current_selected_option.statusMax then
                    djui_popup_create_global("\\#00aa00\\Squishy's Server Ruleset:\n\\#ffff77\\"..current_selected_option.name.."\\#dcdcdc\\ was set to \\#ffff00\\"..tostring(current_selected_option.statusNames[current_selected_option.status].."\\#dcdcdc\\!"), 3)
                end
            end
        else
            djui_chat_message_create("Invalid Status Entered")
        end
        return true
    else
        if args[2] then
            local args_2 = tonumber(args[2])
            if args_2 and args_2 > 0 and args_2 <= 4 then
                optionTab = args_2
                djui_chat_message_create("Redirected Tab to "..menuTable[optionTab].name)
                play_sound(SOUND_MENU_MESSAGE_APPEAR, m.marioObj.header.gfx.cameraToObject)
                menu = true
            else
                djui_chat_message_create("Invalid Tab Entered")
                return true
            end
        end
        if args[3] then
            local args_3 = tonumber(args[3])
            if args_3 and args_3 > 0 and args_3 <= #menuTable[optionTab] then
                optionHover = args_3
                djui_chat_message_create("Redirected Option to "..menuTable[optionTab][optionHover + scrolling].name)
                play_sound(SOUND_MENU_MESSAGE_APPEAR, m.marioObj.header.gfx.cameraToObject)
                menu = true
            else
                djui_chat_message_create("Invalid Option Entered")
            end
        end
    end
    return true
end


local crudeloChallenge = false
local noLoopCrudeloChallenge = true
local heavanlyChallenge = 0
local currHack = 0
for i in pairs(gActiveMods) do
    if (gActiveMods[i].name:find ("Super Mario 74")) then
        currHack = 1
    elseif (gActiveMods[i].name:find("Super Mario 64: The Underworld")) then
        currHack = 2
    elseif (gActiveMods[i].name:find("Star Road")) then
        currHack = 3
    elseif (gActiveMods[i].name:find("B3313 (v0.7)")) or (gActiveMods[i].name:find("B3313 v0.7")) or (gActiveMods[i].name:find("(EPILESY WARNING!) B3313 v0.7 in SM64ex-coop"))  or (gActiveMods[i].name:find("\\#F78AF5\\B\\#F94A36\\3\\#4C5BFF\\3\\#EDD83D\\1\\#16C31C\\3\\#ffffff\\v0.7")) then
        currHack = 4
    end
end

local function update_theme_requirements(m)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end

    local np = gNetworkPlayers[0]
    --Uoker Check
    for i = 0, MAX_PLAYERS - 1 do
        if network_discord_id_from_local_index(i) == "401406794649436161" then
            theme_unlock("Uoker", "Smile and wait for her arrival and wait and wa wai  smile and sm SMILESMILESMILESMILEthe stars", m)
        end
    end
    --Fucking Dead Check
    if (m.action == ACT_SHOCKED or m.action == ACT_WATER_SHOCKED) and m.health == 255 then
        theme_unlock("Plus", "Die via Electricity", m)
    end

    --Underworld Win Check
    if currHack == 2 and m.action == ACT_JUMBO_STAR_CUTSCENE then
        theme_unlock("Under", "Defeat the Shitilizer", m)
    end

    --Star Road 130 Stars Completion Check
    if currHack == 3 and m.numStars >= 130 then
        theme_unlock("StarRoad", "Collect 130 Stars in Star Road", m)
    end

    --Vanilla 120 Stars Check
    if currHack == 0 and m.numStars >= 120 then
        theme_unlock("Cake", "Collect all 120 Stars in Vanilla SM64", m)
    end

    --Crudelo Challenge Check
    if currHack == 1 and np.currCourseNum == COURSE_RR and np.currAreaIndex == 2 then
        for i = 1, #menuTable[1] do
            if menuTable[1][i].status > 0 and crudeloChallenge then
                crudeloChallenge = false
            end
            if not crudeloChallenge and noLoopCrudeloChallenge then
                djui_popup_create("\n\\#ff0000\\Crudelo Challenge\n Requirements not met!\\#dcdcdc\\\n\nYou must have everything in the\nMovement Tab Off/Default and\nRestart the Level to Unlock\nthe Crudelo Theme!", 6)
                noLoopCrudeloChallenge = false
            end
        end
    else
        crudeloChallenge = true
        noLoopCrudeloChallenge = true
    end

    --Wario Challenge
    if not warioChallengeComplete then
        if warioChallenge >= 1000 then
            theme_unlock("Wario", "Collect 1000 Coins as Wario", m)
            djui_chat_message_create("\\#ffff00\\This theme comes with a special Wario World HUD layout when used! Check it out!\\#ffffff\\")
            warioChallengeComplete = true
        end
    end

    --Heavenly Challenge
    if m.pos.y > m.floorHeight and m.pos.y > m.waterLevel then
        heavanlyChallenge = heavanlyChallenge + 1
    else
        heavanlyChallenge = 0
    end

    if heavanlyChallenge >= 1800 then
        theme_unlock("Heavenly", "Stay airborne for 60 seconds", m)
    end

    --B3313 Grand Star Check
    if currHack == 4 and np.currLevelNum == LEVEL_BOWSER_3 and np.currAreaIndex == 1 and m.action == ACT_JUMBO_STAR_CUTSCENE then
        theme_unlock("Poly", "Defeat Bowser in the Eternal Fort", m)
    end
end

local blueCoinBhvs = {
    [id_bhvBlueCoinJumping] = true,
    [id_bhvBlueCoinNumber] = true,
    [id_bhvBlueCoinSliding] = true,
    [id_bhvHiddenBlueCoin] = true,
    [id_bhvMovingBlueCoin] = true,
    [id_bhvMrIBlueCoin] = true,
}

local function theme_interact_requirements(m, o, type)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end
    local np = gNetworkPlayers[0]
	if (type == INTERACT_STAR_OR_KEY) then
		--This ensures that it increments ONLY if a star is collected.
		if get_id_from_behavior(o.behavior) ~= id_bhvBowserKey and crudeloChallenge and np.currCourseNum == COURSE_RR and np.currAreaIndex == 2 then
            theme_unlock("Crudelo", "Collect a star in Crudelo-Sphere\nwithout any Movement Buffs", m)
		end
	end

    if not warioChallengeComplete then
        if (type == INTERACT_COIN) and gNetworkPlayers[0].modelIndex == 4 then
            oWario = 255
            warioTimer = 0
            if get_id_from_behavior(o.behavior) == id_bhvRedCoin then
                warioChallenge = warioChallenge + 2
            elseif blueCoinBhvs[get_id_from_behavior(o.behavior)] then
                warioChallenge = warioChallenge + 5
            else
                warioChallenge = warioChallenge + 1
            end
        end
    end
end

function on_event_command(msg)
    if not network_is_server() and not network_is_moderator() then
        return false
    end
    local eventString = ""
    local args = string_split(msg)
    for i = 2, #args do
        if i ~= #args + 1 and i ~= 2 then
            eventString = eventString.." "
        end
        eventString = eventString..args[i]
    end
    if eventString then
        gGlobalSyncTable.event = eventString
        djui_chat_message_create('Event set to "'..gGlobalSyncTable.event..'"')
    else
        djui_chat_message_create('Invalid Event String')
    end
    return true
end

function on_vote_command(msg)
    local args = string_split(msg)
    if network_has_permissions() and not gGlobalSyncTable.vote and voteTimer == 3600 then
        local promptString = ""
        for i = 2, #args do
            if i ~= #args + 1 and i ~= 2 then
                promptString = promptString.." "
            end
            promptString = promptString..args[i]
            gGlobalSyncTable.vote = promptString
        end
        djui_chat_message_create('Started a vote: "'..gGlobalSyncTable.vote..'"')
        return true
    else
        if not gGlobalSyncTable.vote then
            djui_chat_message_create("A vote is not taking place at the moment")
            return true
        end
        if gPlayerSyncTable[0].vote then
            djui_chat_message_create("You've already voted")
            return true
        end
        if voteTimer <= 0 then
            djui_chat_message_create("The vote has already ended")
            return true
        end

        local response = string.lower(args[2])
        if response == "true" or response == "yes" or response == "1" or response == "y" then
            gPlayerSyncTable[0].vote = true
            djui_chat_message_create('You voted Yes for "'..gGlobalSyncTable.vote..'"')
        elseif response == "false" or response == "no" or response == "0" or response == "n" then
            gPlayerSyncTable[0].vote = false
            djui_chat_message_create('You voted No for "'..gGlobalSyncTable.vote..'"')
        else
            djui_chat_message_create('Invalid Option Entered')
            djui_chat_message_create('Use Yes/No When voting!')
        end
        return true
    end
end

local function update()
    if BootupTimer < 150 then return end
    local args = {}
    for index, value in ipairs(string_split(gGlobalSyncTable.syncData)) do
        args[index] = tonumber(value)
    end

    if menu and optionTab == 6 then
        gGlobalSyncTable.syncData = tostring(menuTable[6][1].status) .. " " .. tostring(menuTable[6][2].status) .. " " .. tostring(menuTable[6][3].status) .. " " .. tostring(menuTable[6][4].status) .. " " .. tostring(menuTable[6][5].status) .. " " .. tostring(menuTable[6][6].status)
    else
        --Death Type
        menuTable[6][1].status = args[1]
        --Player Interactions
        menuTable[6][2].status = args[2]
        --Player Knockback
        menuTable[6][3].status = args[3]
        --On Star Collection
        menuTable[6][4].status = args[4]
        --Global Movesets
        menuTable[6][5].status = args[5]
        --Global AQS
        menuTable[6][6].status = args[6]
    end
    gServerSettings.bubbleDeath = args[1]
    gServerSettings.playerInteractions = args[2]
    if args[3] == 0 then
        gServerSettings.playerKnockbackStrength = 10
    elseif args[3] == 1 then
        gServerSettings.playerKnockbackStrength = 25
    elseif args[3] == 2 then
        gServerSettings.playerKnockbackStrength = 60
    end
    gServerSettings.stayInLevelAfterStar = args[4]

    local moveset_option = menuTable[MENU_TABS.movement][MENU_TAB_MOVEMENT.moveset]
    local quicksand_option = menuTable[MENU_TABS.movement][MENU_TAB_MOVEMENT.antiQuickSand]
    moveset_option.unlocked = args[5]
    if moveset_option.unlocked ~= 1 then
        moveset_option.status = moveset_option.lockTo
    end
    quicksand_option.unlocked = args[6]
    if quicksand_option.unlocked ~= 1 then
        quicksand_option.status = quicksand_option.lockTo
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, update_theme_requirements)
hook_event(HOOK_ON_INTERACT, theme_interact_requirements)
hook_event(HOOK_UPDATE, update)
