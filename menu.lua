menu = false
local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1

--Optimization I guess
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_font = djui_hud_set_font
local djui_hud_set_color = djui_hud_set_color
local djui_hud_print_text = djui_hud_print_text

KBTranslate = 0

if gServerSettings.playerKnockbackStrength == 10 then
    KBTranslate = 0
elseif gServerSettings.playerKnockbackStrength == 25 then
    KBTranslate = 1
elseif gServerSettings.playerKnockbackStrength == 60 then
    KBTranslate = 2
end

gGlobalSyncTable.syncData = tostring(gServerSettings.bubbleDeath) .. " " .. tostring(gServerSettings.playerInteractions) .. " " .. tostring(KBTranslate) .. " " .. tostring(gServerSettings.stayInLevelAfterStar) .. " " .. tostring(1) .. " " .. tostring(1)

gLevelValues.extendedPauseDisplay = true

local args = split(gGlobalSyncTable.syncData)

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
        },
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
            statusDefault = 0, 
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
        },
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

themeTable = {
    [0] = {
        name = "Default",
        texture = get_texture_info("theme-default"),
        hasHeader = true,
        headerColor = {r = 0, g = 131, b = 0}
    }
}

local maxThemes = 9

local function set_status_and_save(table, index, status)
    if table[index].statusNames == nil then table[index].statusNames = {} end
    if mod_storage_load(table[index].nameSave) ~= nil and table[index].status ~= nil then return end
    table[index].status = status
    mod_storage_save(table[index].nameSave, tostring(status))
end

for i = 1, #menuTable[1] do
    if i == 1 or i == 6 then
        set_status_and_save(menuTable[1], i, 0)
    else
        set_status_and_save(menuTable[1], i, 1)
    end
end

for i = 1, #menuTable[2] do
    if i == 1 or i == 3 then
        set_status_and_save(menuTable[2], i, 0)
    else
        set_status_and_save(menuTable[2], i, 1)
    end
end

for i = 1, #menuTable[3] do
    if i == 3 or i == 4 then
        set_status_and_save(menuTable[3], i, 0)
    else
        set_status_and_save(menuTable[3], i, 1)
    end
end

for i = 1, maxThemes do
    if mod_storage_load("UnlockedTheme-"..i) == nil then
        mod_storage_save("UnlockedTheme-"..i, "nil")
    end
end

for i in pairs(gActiveMods) do
    --Mod Check Preventing Moveset Clashing
    if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("moveset")) or gActiveMods[i].name:find("Pasta Castle") then
        menuTable[5][5].status = 0
        menuTable[1][1].statusNames[-1] = "External Moveset"
        gGlobalSyncTable.syncData = tostring(gServerSettings.bubbleDeath) .. " " .. tostring(gServerSettings.playerInteractions) .. " " .. tostring(KBTranslate) .. " " .. tostring(gServerSettings.stayInLevelAfterStar) .. " " .. tostring(0) .. " " .. tostring(1)
    end
    --Mod Check Preventing HUD Overlapping
    if menuTable[2][2].status ~= 0 then
        if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("gamemode")) and not (gActiveMods[i].name:find("Personal Star Counter EX+")) and not (gActiveMods[i].name:find("\\#00ffff\\Mario\\#ff5a5a\\Hun\\\\t")) and menuTable[2][2].status > 0 then
            menuTable[2][1].status = 3
            menuTable[2][1].statusNames[3] = "External HUD"
        end
        if (gActiveMods[i].name:find("OMM Rebirth")) or (gActiveMods[i].name:find("Super Mario 64: The Underworld")) or (gActiveMods[i].name:find("Super Mario Parallel Stars")) and menuTable[2][2].status == 1 then
            menuTable[2][1].status = 3
            menuTable[2][1].statusNames[3] = "External HUD"
        end
    end
end

local maxThemeNum = 0
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

theme_load()

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


local stallScriptTimer = 10
local noLoopSound = true

local descSlide = -100
local bobbingVar = 0
local bobbingStatus = true
local bobbing = -2.1

local voteTimer = 3600
local voteSlide = -150
local prevVote = ""
local voteScale = 1
function displaymenu()
    local m = gMarioStates[0]

    if stallScriptTimer < 0 then stallScriptTimer = stallScriptTimer - 1 return end
    if is_game_paused() or rules then
        RoomTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string.format("%02d", math.floor(get_time() - gGlobalSyncTable.RoomStart)%60))
    end

    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_resolution(RESOLUTION_N64)
    halfScreenWidth = djui_hud_get_screen_width()*0.5

    if is_game_paused() and not djui_hud_is_pause_menu_created() then
        djui_hud_set_render_behind_hud(false)
        if m.action == ACT_EXIT_LAND_SAVE_DIALOG then
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 33), 31, 0.3)
            djui_hud_print_text(RoomTime, (halfScreenWidth - 32.5), 42, 0.7)
        else
            djui_hud_set_resolution(RESOLUTION_DJUI)
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)) + 1, 43, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)), 42, 1)
        end
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 35), 30, 0.3)
        djui_hud_print_text(RoomTime, (halfScreenWidth - 35), 40, 0.7)
    end

    if menu then
        if noLoopSound and themeTable[menuTable[2][3].status].sound ~= nil then
            audio_sample_play(themeTable[menuTable[2][3].status].sound, m.pos, 1)
        end
        noLoopSound = false

        if menuTable[2][5].status == 1 then
            if math.abs(bobbingVar) > 100 then
                bobbingStatus = not bobbingStatus
            end
            if bobbingStatus then
                bobbingVar = bobbingVar + 1
            else
                bobbingVar = bobbingVar - 1
            end
            bobbing = bobbing + bobbingVar*0.00041666666
            if descSlide < -1 then
                descSlide = descSlide*0.83333333333
            end
        else
            descSlide = -1
        end

        if themeTable[menuTable[2][3].status].hoverColor == nil then
            themeTable[menuTable[2][3].status].hoverColor = {r = 150, g = 150, b = 150}
        end

        if themeTable[menuTable[2][3].status].headerColor == nil then
            themeTable[menuTable[2][3].status].headerColor = themeTable[menuTable[2][3].status].hoverColor
        end
        
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width()+5, 240)

        if menuTable[2][4].status == 1 then
            djui_hud_set_color(255, 255, 255, 200)
            djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, (halfScreenWidth + 91) + descSlide, ((djui_hud_get_screen_height()*0.5) - 42) - bobbing, 1.3, 1.3, 176, 0, 80, 80)
            djui_hud_set_color(0, 0, 0, 220)
            djui_hud_render_rect((halfScreenWidth + 93) + descSlide, ((djui_hud_get_screen_height()*0.5) - 40) - bobbing, 100, 100)
            djui_hud_set_color(themeTable[menuTable[2][3].status].headerColor.r, themeTable[menuTable[2][3].status].headerColor.g, themeTable[menuTable[2][3].status].headerColor.b, 255)
            djui_hud_print_text(menuTable[optionTab][optionHover].name, (halfScreenWidth + 100) + descSlide, 85 - bobbing, 0.35)
            djui_hud_set_color(255, 255, 255, 255)
            for i = 1, 9 do
                local line = menuTable[optionTab][optionHover].description[i]
                if line ~= nil then
                    djui_hud_set_color(255, 255, 255, 255)
                    djui_hud_print_text(line, halfScreenWidth + 100 + descSlide, (100 + (i - 1) * 8) - bobbing, 0.3)
                end
            end
        end

        djui_hud_set_font(FONT_MENU)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(255, 255, 255, 200)
        djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, (halfScreenWidth - 88), ((djui_hud_get_screen_height()*0.5) - 93) + bobbing, 1.16477272727, 1, 0, 0, 176, 205)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect((halfScreenWidth - 85), ((djui_hud_get_screen_height()*0.5) - 90) + bobbing, 170, 199)
        djui_hud_set_color(themeTable[menuTable[2][3].status].headerColor.r, themeTable[menuTable[2][3].status].headerColor.g, themeTable[menuTable[2][3].status].headerColor.b, 255)
        if themeTable[menuTable[2][3].status].hasHeader then
            djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, (halfScreenWidth - 53), ((djui_hud_get_screen_height()*0.5) - 85) + bobbing, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
        else
            djui_hud_render_texture_tile(themeTable[0].texture, (halfScreenWidth - 53), ((djui_hud_get_screen_height()*0.5) - 85) + bobbing, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
        end


        --Toggles--
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_resolution(RESOLUTION_N64)
        if network_has_permissions() then
            djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 200)
            if menuTable[4][1] ~= nil then
                djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30) - 15), 70 + bobbing, 30, 9)
            else
                n = optionTab
                if optionTab == 5 then
                    n = 4
                end
                djui_hud_render_rect((halfScreenWidth - 60 + (n * 30 - 30)), 70 + bobbing, 30, 9)
            end
            djui_hud_set_color(255, 255, 255, 255)
            if menuTable[4][1] ~= nil then
                djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 60), 70 + bobbing, 0.3)
                djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2) - 30), 70 + bobbing, 0.3)
                djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2)), 70 + bobbing, 0.3)
                djui_hud_print_text("External", (halfScreenWidth - (djui_hud_measure_text("External")* 0.3 / 2) + 30), 70 + bobbing, 0.3)
                djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("Server")* 0.3 / 2) + 60), 70 + bobbing, 0.3)
            else
                djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 45), 70 + bobbing, 0.3)
                djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2) - 15), 70 + bobbing, 0.3)
                djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2) + 15), 70 + bobbing, 0.3)
                djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("External")* 0.3 / 2) + 45), 70 + bobbing, 0.3)
            end
        else
            djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 200)
            if menuTable[4][1] ~= nil then
                djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30)), 70 + bobbing, 30, 9)
            else
                n = optionTab
                if optionTab == 5 then
                    n = 4
                end
                djui_hud_render_rect((halfScreenWidth - 60 + (n * 30 - 30) + 15), 70 + bobbing, 30, 9)
            end
            djui_hud_set_color(255, 255, 255, 255)
            if menuTable[4][1] ~= nil then
                djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 45), 70 + bobbing, 0.3)
                djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2) - 15), 70 + bobbing, 0.3)
                djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2) + 15), 70 + bobbing, 0.3)
                djui_hud_print_text("External", (halfScreenWidth - (djui_hud_measure_text("External")* 0.3 / 2) + 45), 70 + bobbing, 0.3)
            else
                djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 30), 70 + bobbing, 0.3)
                djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2)), 70 + bobbing, 0.3)
                djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2) + 30), 70 + bobbing, 0.3)
            end
        end
        if discordID ~= "0" then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Registered as "..modelTable[discordID].nickname.. " via Name-2-Model", (halfScreenWidth - 80), 216 + bobbing, 0.3)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Unregistered via Name-2-Model / ".. menuErrorMsg, (halfScreenWidth - 80), 216 + bobbing, 0.3)
          
        end

        djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 200)
        djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10) + bobbing, 70, 9)
        djui_hud_set_color(255, 255, 255, 255)
        
        if optionHover < 1 then
            optionHover = #menuTable[optionTab]
        elseif optionHover > #menuTable[optionTab] then
            optionHover = 1
        end

        if menuTable[optionTab][optionHover].status ~= nil then
            if menuTable[optionTab][optionHover].unlocked == nil then menuTable[optionTab][optionHover].unlocked = 1 end
            if menuTable[optionTab][optionHover].statusNames[1] == nil then menuTable[optionTab][optionHover].statusNames[1] = "On" end
            if menuTable[optionTab][optionHover].statusNames[0] == nil then menuTable[optionTab][optionHover].statusNames[0] = "Off" end

            if menuTable[optionTab][optionHover].unlocked ~= 1 then
                djui_hud_print_text(menuTable[optionTab][optionHover].statusNames[-1], (halfScreenWidth), 70 + (optionHover * 10) + bobbing, 0.3)
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].lockTo
            elseif menuTable[optionTab][optionHover].statusNames[menuTable[optionTab][optionHover].status] ~= nil then
                djui_hud_print_text(menuTable[optionTab][optionHover].statusNames[menuTable[optionTab][optionHover].status], (halfScreenWidth), 70 + (optionHover * 10) + bobbing, 0.3)
            end
        else
            if menuTable[optionTab][optionHover].statusDefault then
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].statusDefault
            else
                menuTable[optionTab][optionHover].status = 1
            end
            djui_hud_print_text("Making Save Data...", (halfScreenWidth), 70 + (optionHover * 10) + bobbing, 0.3)
            mod_storage_save(menuTable[optionTab][optionHover].nameSave, tostring(menuTable[optionTab][optionHover].status))
            print("Autofilled Toggle for '" ..menuTable[optionTab][optionHover].nameSave "' created.")
        end

        for i = 1, #menuTable[optionTab] do
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(menuTable[optionTab][i].name, halfScreenWidth - 70, (80 + (i - 1) * 10) + bobbing, 0.3)
        end
    else
        noLoopSound = true
        descSlide = -100
    end

    if gGlobalSyncTable.vote ~= nil then
        if voteSlide < -1 then
            voteSlide = voteSlide/1.1
        end
        prevVote = gGlobalSyncTable.vote
    else
        if voteSlide > -150 then
            voteSlide = voteSlide*1.1
        else
            for i = 0, MAX_PLAYERS - 1 do
                if gPlayerSyncTable[i].vote ~= nil then
                    gPlayerSyncTable[i].vote = nil
                end
            end
        end
    end
    if voteSlide > -150 then
        voteTimer = voteTimer - 1
        djui_hud_set_color(255, 255, 255, 200)
        djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, 10 + voteSlide, 100, 1, 1, 176, 0, 80, 80)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect(12 + voteSlide, 102, 76, 76)
        djui_hud_set_color(themeTable[menuTable[2][3].status].headerColor.r, themeTable[menuTable[2][3].status].headerColor.g, themeTable[menuTable[2][3].status].headerColor.b, 255)
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
            if gPlayerSyncTable[i].vote == true then
                votedYes = votedYes + 1
                votedTotal = votedTotal + 1
            elseif gPlayerSyncTable[i].vote == false then
                votedNo = votedNo + 1
                votedTotal = votedTotal + 1
            end
        end
        if votedTotal == network_player_connected_count() and voteTimer > 0 then
            voteTimer = 0
        end
        djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 255)
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
        end
    else
        voteTimer = 3600
    end
end


function before_update(m)
    if m.playerIndex ~= 0 then return end
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
                optionTab = optionTab - 1
                if optionTab == 4 and menuTable[4][1] == nil then
                    optionTab = 3
                end
                optionHoverTimer = 0
            elseif (stickX > 10 or (buttonDown & R_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                optionTab = optionTab + 1
                if optionTab == 4 and menuTable[4][1] == nil then
                    optionTab = 5
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

        local maxTabLimit = 4
        if (network_has_permissions()) then
            maxTabLimit = 5
        end

        if optionTab > maxTabLimit then optionTab = 1 end
        if optionTab < 1 then optionTab = maxTabLimit end
        if optionHover > #menuTable[optionTab] then optionHover = 1 end        
        if optionHover < 1 then optionHover = #menuTable[optionTab] end

        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            optionHoverTimer = 0
            if menuTable[optionTab][optionHover].unlocked ~= 1 then
                play_sound(SOUND_MENU_CAMERA_BUZZ, m.marioObj.header.gfx.cameraToObject)
                print("Could not change status")
            else
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].status + 1
                if menuTable[optionTab][optionHover].status > menuTable[optionTab][optionHover].statusMax then
                    menuTable[optionTab][optionHover].status = 0
                end
                if menuTable[optionTab][optionHover].nameSave ~= nil then
                    mod_storage_save(menuTable[optionTab][optionHover].nameSave, tostring(menuTable[optionTab][optionHover].status))
                end
                if network_has_permissions() then
                    if optionTab == 5 and optionHover >= 1 then
                        djui_popup_create_global("\\#00aa00\\Squishy's Server Ruleset:\n\\#ffff77\\"..menuTable[optionTab][optionHover].name.."\\#dcdcdc\\ was set to \\#ffff00\\"..tostring(menuTable[optionTab][optionHover].statusNames[menuTable[optionTab][optionHover].status].."\\#dcdcdc\\!"), 3)
                    end
                end
            end
        end

        if (m.controller.buttonDown & B_BUTTON) ~= 0 or (m.controller.buttonDown & START_BUTTON) ~= 0 or (m.controller.buttonPressed & L_TRIG) ~= 0 and menu then
            print("Saving configuration to 'squishys-server.sav'")
            menu = false
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        end

        m.controller.rawStickY = 0
        m.controller.rawStickX = 0
        m.controller.stickX = 0
        m.controller.stickY = 0
        m.controller.stickMag = 0
        m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
        m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
        m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
        m.controller.buttonPressed = m.controller.buttonPressed & ~B_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~B_BUTTON
        m.controller.buttonPressed = m.controller.buttonPressed & ~START_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~START_BUTTON
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
    args = split(msg)
    if args[2] == nil then
        if menu then
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        else
            play_sound(SOUND_MENU_MESSAGE_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        end
        menu = not menu
        return true
    end
    if args[4] ~= nil then
        local table = menuTable[tonumber(args[2])][tonumber(args[3])]
        if table.statusNames[1] == nil then table.statusNames[1] = "On" end
        if table.statusNames[0] == nil then table.statusNames[0] = "Off" end
        if tonumber(args[4]) >= 0 and tonumber(args[4]) <= table.statusMax then
            table.status = tonumber(args[4])
            djui_chat_message_create(table.name.." set to "..tostring(table.statusNames[table.status]))
            if table.nameSave ~= nil then
                mod_storage_save(table.nameSave, tostring(table.status))
            end
            menu = false
            if network_has_permissions() then
                if tonumber(args[2]) == 5 and tonumber(args[4]) <= table.statusMax then
                    djui_popup_create_global("\\#00aa00\\Squishy's Server Ruleset:\n\\#ffff77\\"..table.name.."\\#dcdcdc\\ was set to \\#ffff00\\"..tostring(table.statusNames[table.status].."\\#dcdcdc\\!"), 3)
                end
            end
            return true
        else
            djui_chat_message_create("Invalid Status Entered")
            return true
        end
    else
        if args[2] ~= nil then
            if tonumber(args[2]) > 0 and tonumber(args[2]) <= 4 then
                optionTab = tonumber(args[2])
                djui_chat_message_create("Redirected Tab to "..menuTable[optionTab].name)
                play_sound(SOUND_MENU_MESSAGE_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                menu = true
            else
                djui_chat_message_create("Invalid Tab Entered")
                return true
            end
        end
        if args[3] ~= nil then
            if tonumber(args[3]) > 0 and tonumber(args[3]) <= #menuTable[optionTab] then
                optionHover = tonumber(args[3])
                djui_chat_message_create("Redirected Option to "..menuTable[optionTab][optionHover].name)
                play_sound(SOUND_MENU_MESSAGE_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                menu = true
            else
                djui_chat_message_create("Invalid Option Entered")
                return true
            end
        end
    end
    return true
end


local crudeloChallenge = false
local noLoopCrudeloChallenge = true
local warioChallenge = 0
local heavanlyChallenge = 0
local currHack = 0
for i in pairs(gActiveMods) do
    if (gActiveMods[i].name:find ("Super Mario 74")) then
        currHack = 1
    elseif (gActiveMods[i].name:find("Super Mario 64: The Underworld")) then
        currHack = 2
    elseif (gActiveMods[i].name:find("Star Road")) then
        currHack = 3
    end
end
function update_theme_requirements(m)
    if m.playerIndex ~= 0 then return end
    --Uoker Check
    if network_discord_id_from_local_index(0) == "401406794649436161" and gGlobalSyncTable.event ~= "Space Lady Landed" then
        gGlobalSyncTable.event = "Space Lady Landed"
    end
    if gGlobalSyncTable.event == "Space Lady Landed" then
        theme_unlock("Uoker", "Smile and wait for her arrival and wait and wa wai  smile and sm SMILESMILESMILESMILEthe stars")
    end
    --Fucking Dead Check
    if (m.action == ACT_SHOCKED or m.action == ACT_WATER_SHOCKED) and m.health == 255 then
        theme_unlock("Plus", "Die via Electricity")
    end

    --Underworld Win Check
    if currHack == 2 and m.action == ACT_JUMBO_STAR_CUTSCENE then
        theme_unlock("Under", "Defeat the Shitilizer")
    end

    --Star Road 130 Stars Completion Check
    if currHack == 3 and m.numStars >= 130 then
        theme_unlock("StarRoad", "Collect 130 Stars in Star Road")
    end

    --Vanilla 120 Stars Check
    if currHack == 0 and m.numStars >= 120 then
        theme_unlock("Cake", "Collect all 120 Stars in Vanilla SM64")
    end

    --Crudelo Challenge Check
    if currHack == 1 and gNetworkPlayers[0].currCourseNum == COURSE_RR and gNetworkPlayers[0].currAreaIndex == 2 then
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
    if warioChallenge >= 1000 then

    end

    --Heavenly Challenge
    if m.pos.y > m.floorHeight and m.pos.y > m.waterLevel then
        heavanlyChallenge = heavanlyChallenge + 1
    else
        heavanlyChallenge = 0
    end

    if heavanlyChallenge >= 1800 then
        theme_unlock("Heavenly", "Stay airborne for 60 seconds")
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

function theme_interact_requirements(m, o, type)
    if m.playerIndex ~= 0 then return end
	if (type == INTERACT_STAR_OR_KEY) then
		--This ensures that it increments ONLY if a star is collected.
		if get_id_from_behavior(o.behavior) ~= id_bhvBowserKey and crudeloChallenge and gNetworkPlayers[0].currCourseNum == COURSE_RR and gNetworkPlayers[0].currAreaIndex == 2 then
            theme_unlock("Crudelo", "Collect a star in Crudelo-Sphere\nwithout any Movement Buffs")
		end
	end

    if (type == INTERACT_COIN) and gNetworkPlayers[0].modelIndex == 4 then
        if get_id_from_behavior(o.behavior) == id_bhvRedCoin then
            warioChallenge = warioChallenge + 2
        elseif blueCoinBhvs[get_id_from_behavior(o.behavior)] then
            warioChallenge = warioChallenge + 5
        else
            warioChallenge = warioChallenge + 1
        end
    end
end

function on_event_command(msg)
    if not network_is_server() and not network_is_moderator() then
        return false
    end
    local eventString = ""
    local args = split(msg)
    for i = 2, #args do
        if i ~= #args + 1 and i ~= 2 then
            eventString = eventString.." "
        end
        eventString = eventString..args[i]
    end
    if eventString ~= nil then
        gGlobalSyncTable.event = eventString
        djui_chat_message_create('Event set to "'..gGlobalSyncTable.event..'"')
        return true
    else
        djui_chat_message_create('Invalid Event String')
        return true
    end
end

function on_vote_command(msg)
    local args = split(msg)
    if network_has_permissions() and gGlobalSyncTable.vote == nil then
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
        if gGlobalSyncTable.vote == nil then
            djui_chat_message_create("A vote is not taking place at the moment")
            return true
        end
        if gPlayerSyncTable[0].vote ~= nil then
            djui_chat_message_create("You've already voted")
            return true
        end
        if voteTimer <= 0 then
            djui_chat_message_create("The vote has already ended")
            return true
        end
        local response = string.lower(tostring(args[2]))
        if response == "true" or response == "yes" or response == "1" or response == "y" then
            gPlayerSyncTable[0].vote = true
            djui_chat_message_create('You voted Yes for "'..gGlobalSyncTable.vote..'"')
            return true
        elseif response == "false" or response == "no" or response == "0" or response == "n" then
            gPlayerSyncTable[0].vote = false
            djui_chat_message_create('You voted No for "'..gGlobalSyncTable.vote..'"')
            return true
        else
            djui_chat_message_create('Invalid Option Entered')
            djui_chat_message_create('Use Yes/No When voting!')
            return true
        end
    end
end

function update()
    local args = split(gGlobalSyncTable.syncData)

    if menu and optionTab == 5 then
        gGlobalSyncTable.syncData = ""
        for i = 1, #menuTable[5] do
            gGlobalSyncTable.syncData = gGlobalSyncTable.syncData .. tostring(menuTable[5][i].status) .. " "
        end
    else
        for i = 1, #menuTable[5] do
            if menuTable[5][i].status ~= tonumber(args[i]) then
                menuTable[5][i].status = tonumber(args[i])
            end
        end
    end
    gServerSettings.bubbleDeath = tonumber(args[1])
    gServerSettings.playerInteractions = tonumber(args[2])
    if tonumber(args[3]) == 0 then
        gServerSettings.playerKnockbackStrength = 10
    elseif tonumber(args[3]) == 1 then
        gServerSettings.playerKnockbackStrength = 25
    elseif tonumber(args[3]) == 2 then
        gServerSettings.playerKnockbackStrength = 60
    end
    gServerSettings.stayInLevelAfterStar = tonumber(args[4])
    menuTable[1][1].unlocked = tonumber(args[5])
    if menuTable[1][1].unlocked ~= 1 then
        menuTable[1][1].status = menuTable[1][1].lockTo
    end
    menuTable[1][4].unlocked = tonumber(args[6])
    if menuTable[1][4].unlocked ~= 1 then
        menuTable[1][4].status = menuTable[1][4].lockTo
    end
end



hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, update_theme_requirements)
hook_event(HOOK_ON_INTERACT, theme_interact_requirements)
hook_event(HOOK_UPDATE, update)
