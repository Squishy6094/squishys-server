
gGlobalSyncTable.pausetimerF = 0
gGlobalSyncTable.pausetimerS = 0
gGlobalSyncTable.pausetimerM = 0
gGlobalSyncTable.pausetimerH = 0
gGlobalSyncTable.pausetimerS2Digit = 0
gGlobalSyncTable.pausetimerM2Digit = 0
gGlobalSyncTable.pausetimerH2Digit = 0

gGlobalSyncTable.bubbleDeath = gServerSettings.bubbleDeath
gGlobalSyncTable.playerInteractions = gServerSettings.playerInteractions
gGlobalSyncTable.playerKnockbackStrength = gServerSettings.playerKnockbackStrength
gGlobalSyncTable.shareLives = gServerSettings.shareLives
gGlobalSyncTable.skipIntro = gServerSettings.skipIntro
gGlobalSyncTable.stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar

local menu = false
local optionHover = 1
local optionHoverTimer = 0
local optionHoverCanMove = true
local optionTab = 1

function mario_update(m)
    if m.playerIndex == hostnum and m.playerIndex == 0 then
        gGlobalSyncTable.pausetimerF = gGlobalSyncTable.pausetimerF + 1
    end

    gServerSettings.bubbleDeath = gGlobalSyncTable.bubbleDeath
    gServerSettings.playerInteractions = gGlobalSyncTable.playerInteractions
    gServerSettings.playerKnockbackStrength = gGlobalSyncTable.playerKnockbackStrength
    gServerSettings.shareLives = gGlobalSyncTable.shareLives
    gServerSettings.skipIntro = gGlobalSyncTable.skipIntro
    gServerSettings.stayInLevelAfterStar = gGlobalSyncTable.stayInLevelAfterStar
end

function displaymenu()
    local m = gMarioStates[0]
    if is_game_paused() then
        djui_hud_set_font(FONT_NORMAL)
        if m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
            if (m.controller.buttonPressed & L_TRIG) ~= 0 and menu == false then
                menu = true
            elseif (m.controller.buttonPressed & B_BUTTON) ~= 0 and menu == true then
                menu = false
            end
            djui_hud_set_resolution(RESOLUTION_DJUI)
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("L Button - Server Options", ((djui_hud_get_screen_width()/2) - ((djui_hud_measure_text("L Button - Server Options")* 1 / 2)) + 1), 43, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("L Button - Server Options", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("L Button - Server Options")* 1 / 2)), 42, 1)
        end
        djui_hud_set_resolution(RESOLUTION_N64)
        if m.action == ACT_EXIT_LAND_SAVE_DIALOG then
            djui_hud_set_color(0, 0, 0, 255)
            djui_hud_print_text("Room has been Open for:", ((djui_hud_get_screen_width()/2) - 33), 31, 0.3)
            djui_hud_print_text(""..gGlobalSyncTable.pausetimerH2Digit..gGlobalSyncTable.pausetimerH..":"..gGlobalSyncTable.pausetimerM2Digit..gGlobalSyncTable.pausetimerM..":"..gGlobalSyncTable.pausetimerS2Digit..gGlobalSyncTable.pausetimerS.."", ((djui_hud_get_screen_width()/2) - 32.5), 42, 0.7)
        end
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Room has been Open for:", ((djui_hud_get_screen_width()/2) - 35), 30, 0.3)
        djui_hud_print_text(""..gGlobalSyncTable.pausetimerH2Digit..gGlobalSyncTable.pausetimerH..":"..gGlobalSyncTable.pausetimerM2Digit..gGlobalSyncTable.pausetimerM..":"..gGlobalSyncTable.pausetimerS2Digit..gGlobalSyncTable.pausetimerS.."", ((djui_hud_get_screen_width()/2) - 35), 40, 0.7)
    else 
        menu = false
    end

        --Room Timer--
    if gGlobalSyncTable.pausetimerF >= 30 then
        gGlobalSyncTable.pausetimerS = gGlobalSyncTable.pausetimerS + 1
        gGlobalSyncTable.pausetimerF = 0
    end    
    if gGlobalSyncTable.pausetimerS >= 10 then
        gGlobalSyncTable.pausetimerS2Digit = gGlobalSyncTable.pausetimerS2Digit + 1
        gGlobalSyncTable.pausetimerS = 0
    end
    if gGlobalSyncTable.pausetimerS2Digit >= 6 then
        gGlobalSyncTable.pausetimerM = gGlobalSyncTable.pausetimerM + 1
        gGlobalSyncTable.pausetimerS2Digit = 0
    end
    if gGlobalSyncTable.pausetimerM >= 10 then
        gGlobalSyncTable.pausetimerM2Digit = gGlobalSyncTable.pausetimerM2Digit + 1
        gGlobalSyncTable.pausetimerM = 0
    end
    if gGlobalSyncTable.pausetimerM2Digit >= 6 then
        gGlobalSyncTable.pausetimerH = gGlobalSyncTable.pausetimerH + 1
        gGlobalSyncTable.pausetimerM2Digit = 0
    end
    if gGlobalSyncTable.pausetimerH >= 10 then
        gGlobalSyncTable.pausetimerH2Digit = gGlobalSyncTable.pausetimerH2Digit + 1
        gGlobalSyncTable.pausetimerH = 0
    end

    if menu == true then
        if network_is_server() or network_is_moderator() then
            if optionTab < 1 then
                optionTab = 4
            elseif  optionTab > 4 then
                optionTab = 1
            end
        else
            if optionTab < 1 then
                optionTab = 3
            elseif  optionTab > 3 then
                optionTab = 1
            end
        end
        optionHoverTimer = optionHoverTimer + 1
        if optionHoverTimer >= 10 then
            optionHoverTimer = 0
            optionHoverCanMove = true
        end

        if (m.controller.stickY < -10 or (m.controller.buttonDown & D_JPAD ~= 0)) and optionHoverCanMove == true then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover + 1
            optionHoverCanMove = false
        elseif (m.controller.stickY > 10 or (m.controller.buttonDown & U_JPAD ~= 0)) and optionHoverCanMove == true then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionHover = optionHover - 1
            optionHoverCanMove = false
        end

        if (m.controller.stickX < -10 or (m.controller.buttonDown & L_JPAD ~= 0)) and optionHoverCanMove == true then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionTab = optionTab - 1
            optionHoverCanMove = false
        elseif (m.controller.stickX > 10 or (m.controller.buttonDown & R_JPAD ~= 0)) and optionHoverCanMove == true then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionTab = optionTab + 1
            optionHoverCanMove = false
        end

        djui_hud_set_font(FONT_MENU)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(0, 0, 0, 170)
        djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 87), ((djui_hud_get_screen_height()/2) - 92), 174, 204)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 85), ((djui_hud_get_screen_height()/2) - 90), 170, 200)
        djui_hud_set_color(0, 150, 0, 255)
        djui_hud_print_text("Squishys", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Squishys")* 0.3 / 2)), 35, 0.3)
        djui_hud_print_text("'", ((djui_hud_get_screen_width()/2) + 24), 35, 0.3)
        djui_hud_print_text("Server", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Server")* 0.3 / 2)), 50, 0.3)

        
        if gPlayerSyncTable[m.playerIndex].Descriptions == true then
            djui_hud_set_color(0, 0, 0, 170)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) + 91), ((djui_hud_get_screen_height()/2) - 42), 104, 104)
            djui_hud_set_color(0, 0, 0, 220)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) + 93), ((djui_hud_get_screen_height()/2) - 40), 100, 100)
            djui_hud_set_color(0, 150, 0, 255)
        end

        --Toggles--
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_resolution(RESOLUTION_N64)
        if network_is_server() or network_is_moderator() then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 60 + (optionTab * 30 - 30)), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Movement")* 0.3 / 2) - 45), 70, 0.3)
            djui_hud_print_text("HUD", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("HUD")* 0.3 / 2) - 15), 70, 0.3)
            djui_hud_print_text("Other", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Other")* 0.3 / 2) + 15), 70, 0.3)
            djui_hud_print_text("Server", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Server")* 0.3 / 2) + 45), 70, 0.3)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 60 + (optionTab * 30 - 30) + 15), 70, 30, 9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Movement", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Movement")* 0.3 / 2) - 30), 70, 0.3)
            djui_hud_print_text("HUD", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("HUD")* 0.3 / 2)), 70, 0.3)
            djui_hud_print_text("Other", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("Other")* 0.3 / 2) + 30), 70, 0.3)
        end

        
        if optionTab == 1 then
            if optionHover < 1 then
                optionHover = 3
            elseif  optionHover > 3 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Lava Groundpound", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Lava Groundpound:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Ground-Pounding on lava will", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("give you a speed and height", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("boost, at the cost of health.", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].LGP == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].LGP == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                end
            end
            djui_hud_print_text("Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Anti-Quicksand:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Makes instant quicksand act", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("like lava, preventing what", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("may seem like an unfair", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                    djui_hud_print_text("deaths.", ((djui_hud_get_screen_width()/2) + 100), 124, 0.3)
                    if gPlayerSyncTable[m.playerIndex].LGP == true then
                        djui_hud_print_text("(Does not include", ((djui_hud_get_screen_width()/2) + 124), 124, 0.3)
                        djui_hud_print_text("Lava Groundpound", ((djui_hud_get_screen_width()/2) + 100), 132, 0.3)
                        djui_hud_print_text("functionalities)", ((djui_hud_get_screen_width()/2) + 100), 140, 0.3)
                    end
                end
                if gGlobalSyncTable.GlobalAQS == true then
                    if gPlayerSyncTable[m.playerIndex].AQS == true then
                        djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                    elseif gPlayerSyncTable[m.playerIndex].AQS == false then
                        djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                    end
                else
                    djui_hud_print_text("Forced Off", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                end
            end
            djui_hud_print_text("Modded Wallkick", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Modded Wallkick:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Adds Wallsliding and more", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("lenient angles you can wall", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("kick at, best for a more", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                    djui_hud_print_text("modern experience.", ((djui_hud_get_screen_width()/2) + 100), 124, 0.3)
                end
                if gPlayerSyncTable[0].wallSlide == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                elseif gPlayerSyncTable[0].wallSlide == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                end
            end
        elseif optionTab == 2 then
            if optionHover < 1 then
                optionHover = 3
            elseif  optionHover > 3 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            if (optionHover == 1 or optionHover == 2) then
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80, 70, 9)
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 2), 110 + (optionHover * 10 - 40), 70, 9)
            else
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 20), 70, 9)
            end

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Extra HUD", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 or optionHover == 2 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Extra HUD:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Adds Quality of Life HUD", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("Elements to tell extra", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("Information", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                end
                djui_hud_print_text("Red Coin Radar", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                djui_hud_print_text("Cap Timer", ((djui_hud_get_screen_width()/2)), 90, 0.3)
            end
            if optionHover == 1 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Collectables Radar:", ((djui_hud_get_screen_width()/2) + 100), 130, 0.3)
                    djui_hud_print_text("Tells you how far away", ((djui_hud_get_screen_width()/2) + 100), 145, 0.3)
                    djui_hud_print_text("Red coins and Secrets", ((djui_hud_get_screen_width()/2) + 100), 153, 0.3)
                    djui_hud_print_text("are.", ((djui_hud_get_screen_width()/2) + 100), 161, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].radarToggle == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2) + 70), 80, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].radarToggle == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2) + 70), 80, 0.3)
                end
            end
            if optionHover == 2 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Cap Timer:", ((djui_hud_get_screen_width()/2) + 100), 130, 0.3)
                    djui_hud_print_text("Tells you how many seconds", ((djui_hud_get_screen_width()/2) + 100), 145, 0.3)
                    djui_hud_print_text("your cap has left until it", ((djui_hud_get_screen_width()/2) + 100), 153, 0.3)
                    djui_hud_print_text("runs out.", ((djui_hud_get_screen_width()/2) + 100), 161, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].capTimerToggle == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2) + 70), 90, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].capTimerToggle == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2) + 70), 90, 0.3)
                end
            end
            djui_hud_print_text("Server Popups", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 3 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Server Popups:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Shows Tips/Hints about the", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("server every 3-5 minutes.", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("Recommended for if you're", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                    djui_hud_print_text("new to the server.", ((djui_hud_get_screen_width()/2) + 100), 124, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].notif == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].notif == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                end
            end
        elseif optionTab == 3 then
            if optionHover < 1 then
                optionHover = 3
            elseif  optionHover > 3 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Commands", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Commands:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Allows you to edit all of", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("these options via chat", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("commands, Not recommended.", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].CMDToggle == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].CMDToggle == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                end
            end
            djui_hud_print_text("Descriptions", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Descriptions:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Toggles these descriptions", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("you see on the right, ", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("Recommended to turn Off if", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                    djui_hud_print_text("you like a more minimalistic", ((djui_hud_get_screen_width()/2) + 100), 124, 0.3)
                    djui_hud_print_text("menu.", ((djui_hud_get_screen_width()/2) + 100), 132, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].Descriptions == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                end
            end
            djui_hud_print_text("Star Spawn Cutscene", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Star Spawn Cutscene:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Toggles if Star Spawning", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("Cutscenes play, Recommended", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("if you don't know where a", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                    djui_hud_print_text("star spawns.", ((djui_hud_get_screen_width()/2) + 100), 124, 0.3)
                end
                if gPlayerSyncTable[m.playerIndex].SSC == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                elseif gPlayerSyncTable[m.playerIndex].SSC == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                end
            end
        elseif optionTab == 4 then
            if optionHover < 1 then
                optionHover = 6
            elseif  optionHover > 6 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Death Type", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Death Type:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Chenges how players die", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("and respawn after death.", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                end
                if gGlobalSyncTable.bubbleDeath == 0 then
                    djui_hud_print_text("Normal", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                elseif gGlobalSyncTable.bubbleDeath == 1 then
                    djui_hud_print_text("Bubble", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                end
            end
            djui_hud_print_text("Player Interactions", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Player Interactions:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Changes if and how players", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("interact with each other.", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                end
                if gGlobalSyncTable.playerInteractions == 0 then
                    djui_hud_print_text("Non-Solid", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                elseif gGlobalSyncTable.playerInteractions == 1 then
                    djui_hud_print_text("Solid", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                elseif gGlobalSyncTable.playerInteractions == 2 then
                    djui_hud_print_text("Friendly Fire", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                end
            end
            djui_hud_print_text("Player Knockback", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Player Knockback:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Changes how far players get", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("knocked back after being hit", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("by another player.", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                end
                if gGlobalSyncTable.playerKnockbackStrength == 10 then
                    djui_hud_print_text("Weak", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                elseif gGlobalSyncTable.playerKnockbackStrength == 25 then
                    djui_hud_print_text("Normal", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                elseif gGlobalSyncTable.playerKnockbackStrength == 60 then
                    djui_hud_print_text("Too Much", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                end
            end
            djui_hud_print_text("Share Lives", ((djui_hud_get_screen_width()/2) - 70), 110, 0.3)
            if optionHover == 4 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Share Lives:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Changes if players in the", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("same level share lives.", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                end
                if gGlobalSyncTable.shareLives == 1 then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 110, 0.3)
                elseif gGlobalSyncTable.shareLives == 0 then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 110, 0.3)
                end
            end
            djui_hud_print_text("On Star Collection", ((djui_hud_get_screen_width()/2) - 70), 120, 0.3)
            if optionHover == 5 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("On Star Collection:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Determines what happens", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("after you collect a star.", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                end
                if gGlobalSyncTable.stayInLevelAfterStar == 0 then
                    djui_hud_print_text("Leave Level", ((djui_hud_get_screen_width()/2)), 120, 0.3)
                elseif gGlobalSyncTable.stayInLevelAfterStar == 1 then
                    djui_hud_print_text("Stay in Level", ((djui_hud_get_screen_width()/2)), 120, 0.3)
                elseif gGlobalSyncTable.stayInLevelAfterStar == 2 then
                    djui_hud_print_text("Non-stop", ((djui_hud_get_screen_width()/2)), 120, 0.3)
                end
            end
            djui_hud_print_text("Global Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 130, 0.3)
            if optionHover == 6 then
                if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                    djui_hud_print_text("Global Anti-Quicksand:", ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
                    djui_hud_print_text("Determines if players can", ((djui_hud_get_screen_width()/2) + 100), 100, 0.3)
                    djui_hud_print_text("locally change AQS or if", ((djui_hud_get_screen_width()/2) + 100), 108, 0.3)
                    djui_hud_print_text("it's forced off.", ((djui_hud_get_screen_width()/2) + 100), 116, 0.3)
                end
                if gGlobalSyncTable.GlobalAQS == true then
                    djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 130, 0.3)
                elseif gGlobalSyncTable.GlobalAQS == false then
                    djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 130, 0.3)
                end
            end
        end
    end
end

function before_update(m)
    if menu == true and m.playerIndex == 0 then
        if optionHoverCanMove == true then
            if optionTab == 1 then
                if optionHover == 1 then
                    if gPlayerSyncTable[m.playerIndex].LGP == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].LGP = false
                            mod_storage_save("LGPSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].LGP == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].LGP = true
                            mod_storage_save("LGPSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 2 then
                    if gPlayerSyncTable[m.playerIndex].AQS == true and gGlobalSyncTable.GlobalAQS == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].AQS = false
                            mod_storage_save("AQSSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].AQS == false and gGlobalSyncTable.GlobalAQS == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].AQS = true
                            mod_storage_save("AQSSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 3 then
                    if gPlayerSyncTable[0].wallSlide == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[0].wallSlide = false
                            mod_storage_save("WKSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[0].wallSlide == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[0].wallSlide = true
                            mod_storage_save("WKSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                end
            elseif optionTab == 2 then
                if optionHover == 1 then
                    if gPlayerSyncTable[m.playerIndex].radarToggle == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].radarToggle = false
                            mod_storage_save("CRSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].radarToggle == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].radarToggle = true
                            mod_storage_save("CRSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 2 then
                    if gPlayerSyncTable[m.playerIndex].capTimerToggle == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].capTimerToggle = false
                            mod_storage_save("CTSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].capTimerToggle == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].capTimerToggle = true
                            mod_storage_save("CTSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 3 then
                    if gPlayerSyncTable[m.playerIndex].notif == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].notif = false
                            mod_storage_save("notifSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].notif == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].notif = true
                            mod_storage_save("notifSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                end
            elseif optionTab == 3 then
                if optionHover == 1 then
                    if gPlayerSyncTable[m.playerIndex].CMDToggle == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].CMDToggle = false
                            mod_storage_save("CMDSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].CMDToggle == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].CMDToggle = true
                            mod_storage_save("CMDSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 2 then
                    if gPlayerSyncTable[m.playerIndex].Descriptions == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].Descriptions = false
                            mod_storage_save("DescSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].Descriptions == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].Descriptions = true
                            mod_storage_save("DescSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 3 then
                    if gPlayerSyncTable[m.playerIndex].SSC == true then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].SSC = false
                            mod_storage_save("SSCSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].SSC == false then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].SSC = true
                            mod_storage_save("SSCSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                end
            elseif optionTab == 4 then
                if optionHover == 1 then
                    if gGlobalSyncTable.bubbleDeath == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.bubbleDeath = 0
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.bubbleDeath == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.bubbleDeath = 1
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 2 then
                    if gGlobalSyncTable.playerInteractions == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerInteractions = 1
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.playerInteractions == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerInteractions = 2
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.playerInteractions == 2 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerInteractions = 0
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 3 then
                    if gGlobalSyncTable.playerKnockbackStrength == 10 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerKnockbackStrength = 25
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.playerKnockbackStrength == 25 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerKnockbackStrength = 60
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.playerKnockbackStrength == 60 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.playerKnockbackStrength = 10
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 4 then
                    if gGlobalSyncTable.shareLives == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.shareLives = 0
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.shareLives == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.shareLives = 1
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 5 then
                    if gGlobalSyncTable.stayInLevelAfterStar == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.stayInLevelAfterStar = 1
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.stayInLevelAfterStar == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.stayInLevelAfterStar = 2
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.stayInLevelAfterStar == 2 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.stayInLevelAfterStar = 0
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 6 then
                    if gGlobalSyncTable.GlobalAQS == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.GlobalAQS = 0
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.GlobalAQS == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.GlobalAQS = 1
                            optionHoverCanMove = false
                        end
                    end
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
end

-- Toggle Saves --
if mod_storage_load("LGPSave") == nil then
    print("'Lava Groundpound' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("LGPSave", "true")
end

if mod_storage_load("AQSSave") == nil then
    print("'Anti-Quicksand' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("AQSSave", "true")
end

if mod_storage_load("WKSave") == nil then
    print("'Modded Wallkick' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("WKSave", "true")
end

if mod_storage_load("CRSave") == nil then
    print("'Extra Hud' > 'Collectables Radar' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("CRSave", "true")
end

if mod_storage_load("CTSave") == nil then
    print("'Extra Hud' > 'Cap Timer' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("CTSave", "true")
end

if mod_storage_load("notifSave") == nil then
    print("'Server Popups' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("notifSave", "true")
end

if mod_storage_load("CMDSave") == nil then
    print("'Commands' not found in 'squishy's-server.sav', set to default 'off'")
    mod_storage_save("CMDSave", "false")
end

if mod_storage_load("DescSave") == nil then
    print("'Descriptions' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("DescSave", "true")
end

if mod_storage_load("SSCSave") == nil then
    print("'Star Spawn Cutscene' not found in 'squishy's-server.sav', set to default 'on'")
    mod_storage_save("SSCSave", "true")
end
print("Saving configuration to 'squishy's-server.sav'")


function on_player_connected(m)
    if mod_storage_load("LGPSave") == "true" then
        gPlayerSyncTable[m.playerIndex].LGP = true
    else
        gPlayerSyncTable[m.playerIndex].LGP = false
    end

    gGlobalSyncTable.GlobalAQS = true
    if mod_storage_load("AQSSave") == "true" then
        gPlayerSyncTable[m.playerIndex].AQS = true
    else
        gPlayerSyncTable[m.playerIndex].AQS = false
    end

    if mod_storage_load("WKSave") == "true" then
        gPlayerSyncTable[m.playerIndex].wallSlide = true
    else
        gPlayerSyncTable[m.playerIndex].wallSlide = false
    end

    if mod_storage_load("CRSave") == "true" then
        gPlayerSyncTable[m.playerIndex].radarToggle = true
        gPlayerSyncTable[m.playerIndex].capTimerToggle = true
    elseif mod_storage_load("CRSave") == "false" then
        gPlayerSyncTable[m.playerIndex].radarToggle = false
        gPlayerSyncTable[m.playerIndex].capTimerToggle = false
    elseif mod_storage_load("CRSave") == "cap" then
        gPlayerSyncTable[m.playerIndex].radarToggle = false
        gPlayerSyncTable[m.playerIndex].capTimerToggle = true
    elseif mod_storage_load("CRSave") == "radar" then
        gPlayerSyncTable[m.playerIndex].radarToggle = true
        gPlayerSyncTable[m.playerIndex].capTimerToggle = false
    end

    if mod_storage_load("notifSave") == "true" then
        gPlayerSyncTable[m.playerIndex].notif = true
    else
        gPlayerSyncTable[m.playerIndex].notif = false
    end

    if mod_storage_load("CMDSave") == "true" then
        gPlayerSyncTable[m.playerIndex].CMDToggle = true
    else
        gPlayerSyncTable[m.playerIndex].CMDToggle = false
    end

    if mod_storage_load("DescSave") == "true" then
        gPlayerSyncTable[m.playerIndex].Descriptions = true
    else
        gPlayerSyncTable[m.playerIndex].Descriptions = false
    end

    if mod_storage_load("SSCSave") == "true" then
        gPlayerSyncTable[m.playerIndex].SSC = true
    else
        gPlayerSyncTable[m.playerIndex].SSC = false
    end
end

hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)