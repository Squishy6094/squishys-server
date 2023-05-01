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

local menu = false
local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1

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

function displaymenu()
    local m = gMarioStates[0]

    halfScreenWidth = djui_hud_get_screen_width()*0.5

    djui_hud_set_render_behind_hud(false)

    if is_game_paused() or rules then
        RoomTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string.format("%02d", math.floor(get_time() - gGlobalSyncTable.RoomStart)%60))
    end

    if is_game_paused() and not djui_hud_is_pause_menu_created() then
        djui_hud_set_font(FONT_NORMAL)
        if m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
            if (m.controller.buttonDown & L_TRIG) ~= 0 and not menu then
                menu = true
            end
            if (m.controller.buttonDown & B_BUTTON) ~= 0 and menu then
                menu = false
            end
            djui_hud_set_resolution(RESOLUTION_DJUI)
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)) + 1, 43, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("L Button - Server Options", (djui_hud_get_screen_width()*0.5 - (djui_hud_measure_text("L Button - Server Options")*0.5)), 42, 1)
        end
        djui_hud_set_resolution(RESOLUTION_N64)
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
        if optionHoverTimer >= 8 then
            optionHoverTimer = -1
        end
        if optionHoverTimer ~= -1 then
            optionHoverTimer = optionHoverTimer + 1
        end

        if (m.controller.stickY < -10 or (m.controller.buttonDown & D_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover + 1
            optionHoverTimer = 0
        elseif (m.controller.stickY > 10 or (m.controller.buttonDown & U_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover - 1
            optionHoverTimer = 0
        end

        if (m.controller.stickX < -10 or (m.controller.buttonDown & L_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            if optionTab == 1 and not (network_is_server() or network_is_moderator()) then
                optionTab = 3
            elseif optionTab == 1 and (network_is_server() or network_is_moderator()) then
                optionTab = 4
            else
                optionTab = optionTab - 1
            end
            optionHoverTimer = 0
        elseif (m.controller.stickX > 10 or (m.controller.buttonDown & R_JPAD ~= 0)) and optionHoverTimer == -1 then
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

        djui_hud_set_font(FONT_MENU)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(0, 0, 0, 170)
        djui_hud_render_rect((halfScreenWidth - 87), ((djui_hud_get_screen_height()*0.5) - 92), 174, 204)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect((halfScreenWidth - 85), ((djui_hud_get_screen_height()*0.5) - 90), 170, 200)
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

        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_render_rect((halfScreenWidth - 72), 80 + (optionHover * 10 - 10), 70, 9)
        djui_hud_set_color(255, 255, 255, 255)
        
        if optionHover < 1 then
            optionHover = menuTable[optionTab].tabMax
        elseif  optionHover > menuTable[optionTab].tabMax then
            optionHover = 1
        end

        if menuTable[optionTab][optionHover].status ~= nil then
            if menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status] ~= nil then
                djui_hud_print_text(menuTable[optionTab][optionHover][menuTable[optionTab][optionHover].status], (halfScreenWidth), 70 + (optionHover * 10), 0.3)
            else
                if optionTab == 3 and optionHover == 2 then
                    djui_hud_print_text(modelTable[discordID][menuTable[3][2].status].modelName, (halfScreenWidth), 70 + (optionHover * 10), 0.3)
                    if menuTable[3][2].statusMax == nil then
                        menuTable[3][2].statusMax = maxModelNum
                    end
                else
                    if menuTable[optionTab][optionHover].status > 0 then
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
        
        if menuTable[optionTab].tabMax >= 1 then
            djui_hud_print_text(menuTable[optionTab][1].name, (halfScreenWidth - 70), 80, 0.3)
        end
        if menuTable[optionTab].tabMax >= 2 then
            djui_hud_print_text(menuTable[optionTab][2].name, (halfScreenWidth - 70), 90, 0.3)
        end
        if menuTable[optionTab].tabMax >= 3 then
            djui_hud_print_text(menuTable[optionTab][3].name, (halfScreenWidth - 70), 100, 0.3)
        end
        if menuTable[optionTab].tabMax >= 4 then
            djui_hud_print_text(menuTable[optionTab][4].name, (halfScreenWidth - 70), 110, 0.3)
        end
        if menuTable[optionTab].tabMax >= 5 then
            djui_hud_print_text(menuTable[optionTab][5].name, (halfScreenWidth - 70), 120, 0.3)
        end
        if menuTable[optionTab].tabMax >= 6 then
            djui_hud_print_text(menuTable[optionTab][6].name, (halfScreenWidth - 70), 130, 0.3)
        end

        if menuTable[2][2].status == 1 then
            djui_hud_set_color(0, 0, 0, 170)
            djui_hud_render_rect((halfScreenWidth + 91), ((djui_hud_get_screen_height()*0.5) - 42), 104, 104)
            djui_hud_set_color(0, 0, 0, 220)
            djui_hud_render_rect((halfScreenWidth + 93), ((djui_hud_get_screen_height()*0.5) - 40), 100, 100)
            djui_hud_set_color(0, 150, 0, 255)
            djui_hud_print_text(menuTable[optionTab][optionHover].name, (halfScreenWidth + 100), 85, 0.35)
            djui_hud_set_color(255, 255, 255, 255)
            if menuTable[optionTab][optionHover].Line1 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line1, (halfScreenWidth + 100), 100, 0.3) end
            if menuTable[optionTab][optionHover].Line2 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line2, (halfScreenWidth + 100), 108, 0.3) end
            if menuTable[optionTab][optionHover].Line3 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line3, (halfScreenWidth + 100), 116, 0.3) end
            if menuTable[optionTab][optionHover].Line4 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line4, (halfScreenWidth + 100), 124, 0.3) end
            if menuTable[optionTab][optionHover].Line5 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line5, (halfScreenWidth + 100), 132, 0.3) end
            if menuTable[optionTab][optionHover].Line6 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line6, (halfScreenWidth + 100), 140, 0.3) end
            if menuTable[optionTab][optionHover].Line7 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line7, (halfScreenWidth + 100), 148, 0.3) end
            if menuTable[optionTab][optionHover].Line8 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line8, (halfScreenWidth + 100), 156, 0.3) end
            if menuTable[optionTab][optionHover].Line9 ~= nil then djui_hud_print_text(menuTable[optionTab][optionHover].Line9, (halfScreenWidth + 100), 164, 0.3) end
        end
    end
end

function before_update(m)
    if menu then
        if m.playerIndex ~= 0 then return end        
        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            optionHoverTimer = 0
            menuTable[optionTab][optionHover].status = menuTable[optionTab][optionHover].status + 1
            if menuTable[optionTab][optionHover].status > menuTable[optionTab][optionHover].statusMax then
                menuTable[optionTab][optionHover].status = 0
            end
            if menuTable[optionTab][optionHover].nameSave ~= nil then
                mod_storage_save(menuTable[optionTab][optionHover].nameSave, tostring(menuTable[optionTab][optionHover].status))
            end
            print("Saving configuration to 'squishys-server.sav'")
        end
        m.controller.rawStickY = 0
        m.controller.rawStickX = 0
        m.controller.stickMag = 0
        m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
        m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
        m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
        m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
    end
end

hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)