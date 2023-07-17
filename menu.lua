local menu = false
local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1

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
            [-1] = "Forced Default",
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
            unlocked = 1,
            lockTo = 0,
            --Description
            --Status Toggle Names
            [-1] = "Forced Off",
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
            Line2 = "Lenient Angles and Timings",
            Line3 = "you can wall kick at, best",
            Line4 = "for a more modern experience."
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
        [5] = {
            name = "Prevent HUD Clashing",
            nameSave = "HUDDisableSave",
            status = tonumber(mod_storage_load("HUDDisableSave")),
            statusMax = 2,
            statusDefault = 1,
            --Status Toggle Names
            [0] = "Off",
            [1] = "On",
            [2] = "Gamemodes Only",
            --Description
            Line1 = "Toggles if your HUD",
            Line2 = "automatically gets set to",
            Line3 = "Disabled if another mod",
            Line4 = "has a Custom HUD, This",
            Line5 = "does not force the HUD to",
            Line6 = "Disabled."

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
        [4] = {
            name = "Menu Theme",
            nameSave = "ThemeSave",
            status = tonumber(mod_storage_load("ThemeSave")),
            statusMax = nil,
            statusDefault = 0,
            --Description
            Line1 = "Toggles what theme the",
            Line2 = "Server Menu Displays, these",
            Line3 = "are unlocked via doing",
            Line4 = "specific tasks or joining",
            Line5 = "specific events."
        }
    },
    [4] = {
        name = "Server",
        [1] = {
            name = "Death Type",
            status = tonumber(gServerSettings.bubbleDeath),
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
            status = tonumber(gServerSettings.playerInteractions),
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
            statusDefault = 1,
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
            statusDefault = 1,
            --Description
            Line1 = "Determines if players can",
            Line2 = "locally change AQS or if",
            Line3 = "it's forced off."
        },
    }
}

themeTable = {
    [0] = {
        name = "Default",
        texture = get_texture_info("theme-default")
    }
}

for i in pairs(gActiveMods) do
    --Mod Check Preventing Moveset Clashing
    if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("moveset")) or (gActiveMods[i].name:find("Pasta") and gActiveMods[i].name:find("Castle")) then
        menuTable[4][5].status = 0
        menuTable[1][1][-1] = "External Moveset"
        gGlobalSyncTable.syncData = tostring(gServerSettings.bubbleDeath) .. " " .. tostring(gServerSettings.playerInteractions) .. " " .. tostring(KBTranslate) .. " " .. tostring(gServerSettings.stayInLevelAfterStar) .. " " .. tostring(0) .. " " .. tostring(1)
    end
    --Mod Check Preventing HUD Overlapping
    if menuTable[2][5].status ~= 0 then
        if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("gamemode")) and menuTable[2][5].status > 0 then
            menuTable[2][1].status = 3
        end
        if (gActiveMods[i].name:find("OMM Rebirth")) or (gActiveMods[i].name:find("Super Mario 64: The Underworld")) and menuTable[2][5].status == 1 then
            menuTable[2][1].status = 3
        end
    end
end

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
        if i == 3 or i == 4 then
            set_status_and_save(menuTable[3], i, 0)
        else
            set_status_and_save(menuTable[3], i, 1)
        end
    end

    for i = 1, 2 do
        mod_storage_save("UnlockedTheme-"..i, "nil")
    end

    print("Save Data made successfully!")
    mod_storage_save("SaveData", "true")
end

if mod_storage_load("UnlockedTheme-1") == "nil" then
    themeTable[0].name = "No Themes Unlocked"
end

local maxThemeNum = 0
function theme_load()
    for i = 1, 2 do
        if mod_storage_load("UnlockedTheme-"..i) == "Uoker" then
            themeTable[#themeTable + 1] = {
                name = "Uoker",
                texture = get_texture_info("theme-uoker")
            }
            maxThemeNum = maxThemeNum + 1
        elseif mod_storage_load("UnlockedTheme-"..i) == "Upper" then
            themeTable[#themeTable + 1] = {
                name = "Castle Upper",
                texture = get_texture_info("theme-50door")
            }
            maxThemeNum = maxThemeNum + 1
        end
    end
end

theme_load()

function theme_unlock(themestring)
    for i = 1, 2 do
        if mod_storage_load("UnlockedTheme-"..i) == "nil" or mod_storage_load("UnlockedTheme-"..i) == nil then
            if mod_storage_load("UnlockedTheme-1") == themestring then return end
            mod_storage_save("UnlockedTheme-"..i, themestring)
            theme_load()
            djui_popup_create("You've".. 'unlocked a Theme!\n"'.. themestring..'"', 2)
        end
    end
end

function displaymenu()
    local m = gMarioStates[0]

    djui_hud_set_render_behind_hud(false)

    if is_game_paused() or rules then
        RoomTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string.format("%02d", math.floor(get_time() - gGlobalSyncTable.RoomStart)%60))
    end

    if is_game_paused() and not djui_hud_is_pause_menu_created() then
        djui_hud_set_font(FONT_NORMAL)
        halfScreenWidth = djui_hud_get_screen_width()*0.5
        djui_hud_set_resolution(RESOLUTION_DJUI)
        djui_hud_set_color(0, 0, 0, 255)
        djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)) + 1, 43, 1)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)), 42, 1)
        djui_hud_set_resolution(RESOLUTION_N64)
        halfScreenWidth = djui_hud_get_screen_width()*0.5
        if m.action == ACT_EXIT_LAND_SAVE_DIALOG then
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 33), 31, 0.3)
            djui_hud_print_text(RoomTime, (halfScreenWidth - 32.5), 42, 0.7)
        end
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Room has been Open for:", (halfScreenWidth - 35), 30, 0.3)
        djui_hud_print_text(RoomTime, (halfScreenWidth - 35), 40, 0.7)
    else
        menu = false
    end

    if menu then
        djui_hud_set_font(FONT_MENU)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(255, 255, 255, 255)
        if menuTable[3][4].status == nil then menuTable[3][4].status = 0 end
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_render_texture_tile(themeTable[menuTable[3][4].status].texture, (halfScreenWidth - 88), ((djui_hud_get_screen_height()*0.5) - 93), 1.17045454545, 1, 0, 0, 176, 205)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect((halfScreenWidth - 85), ((djui_hud_get_screen_height()*0.5) - 90), 170, 199)
        djui_hud_set_color(0, 150, 0, 255)
        djui_hud_print_text("Squishys", (halfScreenWidth - (djui_hud_measure_text("Squishys")* 0.3 / 2)), 35, 0.3)
        djui_hud_print_text("'", (halfScreenWidth + 24), 35, 0.3)      
        djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("Server")* 0.3 / 2)), 50, 0.3)

        --Toggles--
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_resolution(RESOLUTION_N64)
        if network_is_server() or network_is_moderator() then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30)), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 45), 70, 0.3)
            djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2) - 15), 70, 0.3)
            djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2) + 15), 70, 0.3)
            djui_hud_print_text("Server", (halfScreenWidth - (djui_hud_measure_text("Server")* 0.3 / 2) + 45), 70, 0.3)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect((halfScreenWidth - 60 + (optionTab * 30 - 30) + 15), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", (halfScreenWidth - (djui_hud_measure_text("Movement")* 0.3 / 2) - 30), 70, 0.3)
            djui_hud_print_text("HUD", (halfScreenWidth - (djui_hud_measure_text("HUD")* 0.3 / 2)), 70, 0.3)
            djui_hud_print_text("Misc.", (halfScreenWidth - (djui_hud_measure_text("Misc.")* 0.3 / 2) + 30), 70, 0.3)
        end
        if discordID ~= "0" then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Registered as "..modelTable[discordID].nickname.. " via Name-2-Model", (halfScreenWidth - 80), 216, 0.3)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Unregistered via Name-2-Model / ".. menuErrorMsg, (halfScreenWidth - 80), 216, 0.3)
          
        end

        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10), 70, 9)
        djui_hud_set_color(255, 255, 255, 255)
        
        if optionHover < 1 then
            optionHover = #menuTable[optionTab]
        elseif optionHover > #menuTable[optionTab] then
            optionHover = 1
        end

        if menuTable[optionTab][optionHover].status ~= nil then
            if menuTable[optionTab][optionHover].unlocked == nil then menuTable[optionTab][optionHover].unlocked = 1 end
            if menuTable[optionTab][optionHover].unlocked ~= 1 then
                djui_hud_print_text(menuTable[optionTab][optionHover][-1], (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].lockTo
            elseif menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status] ~= nil then
                djui_hud_print_text(menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status], (halfScreenWidth), 70 + (optionHover * 10), 0.3)
            else
                if optionTab == 3 and optionHover == 1 then
                    djui_hud_print_text(modelTable[discordID][menuTable[3][1].status].modelName, (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                    if menuTable[3][1].statusMax == nil then
                        menuTable[3][1].statusMax = maxModelNum
                    end
                    if modelTable[discordID][menuTable[3][1].status].credit ~= nil then
                        djui_hud_set_color(150, 150, 150, 255)
                        djui_hud_print_text("Model by " .. modelTable[discordID][menuTable[3][1].status].credit, (halfScreenWidth), 80 + (optionHover * 10), 0.225)
                    end
                elseif optionTab == 3 and optionHover == 4 then
                    djui_hud_print_text(themeTable[menuTable[3][4].status].name, (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                    if menuTable[3][4].statusMax == nil then
                        menuTable[3][4].statusMax = maxThemeNum
                    end
                else
                    if menuTable[optionTab][optionHover].status > 0 then
                        djui_hud_set_color(255, 255, 255, 255)
                        djui_hud_print_text("On", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                    else
                        djui_hud_print_text("Off", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                    end
                end
            end
        else
            if menuTable[optionTab][optionHover].statusDefault then
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].statusDefault
            else
                menuTable[optionTab][optionHover].status = 1
            end
            djui_hud_print_text("Making Save Data...", (halfScreenWidth), 70 + (optionHover * 10), 0.3)
            mod_storage_save(menuTable[optionTab][optionHover].nameSave, tostring(menuTable[optionTab][optionHover].status))
            print("Autofilled Toggle for '" ..menuTable[optionTab][optionHover].nameSave "' created.")
        end
        
        for i = 1, #menuTable[optionTab] do
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(menuTable[optionTab][i].name, halfScreenWidth - 70, 80 + (i - 1) * 10, 0.3)
        end

        if menuTable[2][2].status == 1 then
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_render_texture_tile(themeTable[menuTable[3][4].status].texture, (halfScreenWidth + 91), ((djui_hud_get_screen_height()*0.5) - 42), 1.3, 1.3, 176, 0, 80, 80)
            djui_hud_set_color(0, 0, 0, 220)
            djui_hud_render_rect((halfScreenWidth + 93), ((djui_hud_get_screen_height()*0.5) - 40), 100, 100)
            djui_hud_set_color(0, 150, 0, 255)
            djui_hud_print_text(menuTable[optionTab][optionHover].name, (halfScreenWidth + 100), 85, 0.35)
            djui_hud_set_color(255, 255, 255, 255)
            for i = 1, 9 do
                local line = menuTable[optionTab][optionHover]["Line" .. i]
                if line ~= nil then
                    djui_hud_set_color(255, 255, 255, 255)
                    djui_hud_print_text(line, halfScreenWidth + 100, 100 + (i - 1) * 8, 0.3)
                end
            end
        end
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
                if optionTab == 1 and not (network_is_server() or network_is_moderator()) then
                    optionTab = 3
                elseif optionTab == 1 and (network_is_server() or network_is_moderator()) then
                    optionTab = 4
                else
                    optionTab = optionTab - 1
                end
                optionHoverTimer = 0
            elseif (stickX > 10 or (buttonDown & R_JPAD ~= 0)) then
                play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
                if optionTab == 3 and not (network_is_server() or network_is_moderator()) then
                    optionTab = 1
                elseif optionTab == 4 and (network_is_server() or network_is_moderator()) then
                    optionTab = 1
                else
                    optionTab = optionTab + 1
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
        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            optionHoverTimer = 0
            if menuTable[optionTab][optionHover].unlocked ~= 1 then
                print("Could not change status")
            else
                menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].status + 1
                if menuTable[optionTab][optionHover].status > menuTable[optionTab][optionHover].statusMax then
                    menuTable[optionTab][optionHover].status = 0
                end
                if menuTable[optionTab][optionHover].nameSave ~= nil then
                    mod_storage_save(menuTable[optionTab][optionHover].nameSave, tostring(menuTable[optionTab][optionHover].status))
                end
            end
        end
        m.controller.rawStickY = 0
        m.controller.rawStickX = 0
        m.controller.stickMag = 0
        m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
        m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
        m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
    end

    if is_game_paused() and not djui_hud_is_pause_menu_created() and m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
        if (m.controller.buttonDown & L_TRIG) ~= 0 and not menu then
            menu = true
        end
        if (m.controller.buttonDown & B_BUTTON) ~= 0 and menu then
            print("Saving configuration to 'squishys-server.sav'")
            menu = false
        end
    end
end

function update()
    local args = split(gGlobalSyncTable.syncData)

    if menu and optionTab == 4 then
        gGlobalSyncTable.syncData = tostring(menuTable[4][1].status) .. " " .. tostring(menuTable[4][2].status) .. " " .. tostring(menuTable[4][3].status) .. " " .. tostring(menuTable[4][4].status) .. " " .. tostring(menuTable[4][5].status) .. " " .. tostring(menuTable[4][6].status)
    else
        --Death Type
        menuTable[4][1].status = tonumber(args[1])
        --Player Interactions
        menuTable[4][2].status = tonumber(args[2])
        --Player Knockback
        menuTable[4][3].status = tonumber(args[3])
        --On Star Collection
        menuTable[4][4].status = tonumber(args[4])
        --Global Movesets
        menuTable[4][5].status = tonumber(args[5])
        --Global AQS
        menuTable[4][6].status = tonumber(args[6])
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
    menuTable[1][3].unlocked = tonumber(args[6])
    if menuTable[1][3].unlocked ~= 1 then
        menuTable[1][3].status = menuTable[1][3].lockTo
    end
end



hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_UPDATE, update)