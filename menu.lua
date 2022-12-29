
gGlobalSyncTable.pausetimerF = 0
gGlobalSyncTable.pausetimerS = 0
gGlobalSyncTable.pausetimerM = 0
gGlobalSyncTable.pausetimerH = 0
gGlobalSyncTable.pausetimerS2Digit = 0
gGlobalSyncTable.pausetimerM2Digit = 0
gGlobalSyncTable.pausetimerH2Digit = 0

gGlobalSyncTable.bubbleDeath = 2
gGlobalSyncTable.playerInteractions = gServerSettings.playerInteractions
gGlobalSyncTable.playerKnockbackStrength = gServerSettings.playerKnockbackStrength
gGlobalSyncTable.shareLives = gServerSettings.shareLives
gGlobalSyncTable.skipIntro = gServerSettings.skipIntro
gGlobalSyncTable.stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar
gGlobalSyncTable.GlobalAQS = 1
gGlobalSyncTable.GlobalMoveset = 1

local menu = false
local optionHover = 1
local optionHoverTimer = 0
local optionHoverCanMove = true
local optionTab = 1

function hud_print_description(CMDName, Line1, Line2, Line3, Line4, Line5, Line6, Line7, Line8, Line9)
    local m = gMarioStates[0]
    if gPlayerSyncTable[m.playerIndex].Descriptions == true then
        djui_hud_print_text(CMDName, ((djui_hud_get_screen_width()/2) + 100), 85, 0.3)
        if Line1 ~= nil then djui_hud_print_text(Line1, ((djui_hud_get_screen_width()/2) + 100), 100, 0.3) end
        if Line2 ~= nil then djui_hud_print_text(Line2, ((djui_hud_get_screen_width()/2) + 100), 108, 0.3) end
        if Line3 ~= nil then djui_hud_print_text(Line3, ((djui_hud_get_screen_width()/2) + 100), 116, 0.3) end
        if Line4 ~= nil then djui_hud_print_text(Line4, ((djui_hud_get_screen_width()/2) + 100), 124, 0.3) end
        if Line5 ~= nil then djui_hud_print_text(Line5, ((djui_hud_get_screen_width()/2) + 100), 132, 0.3) end
        if Line6 ~= nil then djui_hud_print_text(Line6, ((djui_hud_get_screen_width()/2) + 100), 140, 0.3) end
        if Line7 ~= nil then djui_hud_print_text(Line7, ((djui_hud_get_screen_width()/2) + 100), 148, 0.3) end
        if Line8 ~= nil then djui_hud_print_text(Line8, ((djui_hud_get_screen_width()/2) + 100), 156, 0.3) end
        if Line9 ~= nil then djui_hud_print_text(Line9, ((djui_hud_get_screen_width()/2) + 100), 164, 0.3) end

    end
end

function hud_print_toggle_status(SyncTable)
    if optionTab == 2 and optionHover <= 2 then
        if SyncTable then
            djui_hud_print_text("On", ((djui_hud_get_screen_width()/2) + 70), 70 + (optionHover * 10), 0.3)
        elseif not SyncTable then
            djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2) + 70), 70 + (optionHover * 10), 0.3)
        end
    elseif optionTab == 2 and optionHover == 3 then
        if SyncTable then
            djui_hud_print_text("On", (djui_hud_get_screen_width()/2), 70 + (optionHover * 10 - 10), 0.3)
        elseif not SyncTable then
            djui_hud_print_text("Off", (djui_hud_get_screen_width()/2), 70 + (optionHover * 10 - 10), 0.3)
        end
    else
        if SyncTable then
            djui_hud_print_text("On", ((djui_hud_get_screen_width()/2)), 70 + (optionHover * 10), 0.3)
        elseif not SyncTable then
            djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2)), 70 + (optionHover * 10), 0.3)
        end
    end
end

function hud_print_unique_toggle_status(SyncTable, ToggleText1, ToggleText2, ToggleText3, ToggleRequirement1, ToggleRequirement2, ToggleRequirement3)
    if ToggleRequirement1 == nil then ToggleRequirement1 = 0 end
    if ToggleRequirement2 == nil then ToggleRequirement2 = 1 end
    if ToggleRequirement3 == nil then ToggleRequirement3 = 2 end

    if SyncTable == ToggleRequirement1 then djui_hud_print_text(ToggleText1, ((djui_hud_get_screen_width()/2)), 70 + (optionHover * 10), 0.3) end
    if SyncTable == ToggleRequirement2 then djui_hud_print_text(ToggleText2, ((djui_hud_get_screen_width()/2)), 70 + (optionHover * 10), 0.3) end
    if SyncTable == ToggleRequirement3 then djui_hud_print_text(ToggleText3, ((djui_hud_get_screen_width()/2)), 70 + (optionHover * 10), 0.3) end
end


function mario_update(m)
    if m.playerIndex == hostnum and m.playerIndex == 0 then
        gGlobalSyncTable.pausetimerF = gGlobalSyncTable.pausetimerF + 1
    end

    if gGlobalSyncTable.bubbleDeath ~= 2 then
        gServerSettings.bubbleDeath = gGlobalSyncTable.bubbleDeath
    else 
        gServerSettings.bubbleDeath = 0
    end
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
                optionHover = 4
            elseif  optionHover > 4 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Moveset", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Movesets:", "Change small things about","how Mario moves to make","movement feel better")
                if gGlobalSyncTable.GlobalMoveset then
                    hud_print_unique_toggle_status(gPlayerSyncTable[m.playerIndex].moveset, "Default", "Character", "QOL")
                else
                    djui_hud_print_text("Forced Off", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                end
                
                if gPlayerSyncTable[m.playerIndex].moveset == 0 then
                    hud_print_description("","","","","","Default:","Just the good ol' SM64", "movement everyone knows","and loves!")
                elseif gPlayerSyncTable[m.playerIndex].moveset == 1 then
                    hud_print_description("","","","","","Character Moveset:","Changes your movement based", "on which Character you're","playing as.")
                elseif gPlayerSyncTable[m.playerIndex].moveset == 2 then
                    hud_print_description("","","","","","Quality of Life Moveset:","Adds QOL Moves like the", "The Groundpound Jump,","Groundpound Dive, Spin-Pound,", "Water-Pound, etc.")
                end
            end
            djui_hud_print_text("Lava Groundpound", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Lava Groundpound:", "Ground-Pounding on lava will","give you a speed and height","boost, at the cost of health.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].LGP)
            end
            djui_hud_print_text("Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Anti-Quicksand:", "Makes instant quicksand act","like lava, preventing what","may seem like an unfair","deaths. (Does not include","Lava Groundpound functions)")
                if gGlobalSyncTable.GlobalAQS == true then
                    hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].AQS)
                else
                    djui_hud_print_text("Forced Off", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                end
            end
            djui_hud_print_text("Modded Wallkick", ((djui_hud_get_screen_width()/2) - 70), 110, 0.3)
            if optionHover == 4 then
                hud_print_description("Modded Wallkick:", "Adds Wallsliding and more","lenient angles you can wall","kick at, best for a more","modern experience.")
                hud_print_toggle_status(gPlayerSyncTable[0].wallSlide)
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
                hud_print_description("Extra HUD:", "Adds Quality of Life HUD","Elements to tell extra","Information")
                djui_hud_print_text("Red Coin Radar", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                djui_hud_print_text("Cap Timer", ((djui_hud_get_screen_width()/2)), 90, 0.3)
            end
            if optionHover == 1 then
                hud_print_description("","","","","","Collectables Radar:", "Tells you how far away","Red coins and Secrets","are.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].radarToggle)
            end
            if optionHover == 2 then
                hud_print_description("","","","","","Cap Timer:", "Tells you how many seconds","your cap has left until it","runs out.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].radarToggle)
            end
            djui_hud_print_text("Server Popups", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 3 then
                hud_print_description("Server Popups:", "Shows Tips/Hints about the","server every 3-5 minutes.","Recommended for if you're","new to the server.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].notif)
            end
        elseif optionTab == 3 then
            if optionHover < 1 then
                optionHover = 2
            elseif  optionHover > 2 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Descriptions", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Descriptions:", "Toggles these descriptions","you see on the right,","Recommended to turn Off if","you like a more minimalistic","menu.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].Descriptions)
            end
            djui_hud_print_text("Star Spawn Cutscene", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Star Spawn Cutscene:", "Toggles if Star Spawning","Cutscenes play, Recommended","if you don't know where a","star spawns.")
                hud_print_toggle_status(gPlayerSyncTable[m.playerIndex].SSC)
            end
        elseif optionTab == 4 then
            if optionHover < 1 then
                optionHover = 7
            elseif  optionHover > 7 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 10), 70, 9)

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Death Type", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Death Type:", "Chenges how players die","and respawn after death.")
                hud_print_unique_toggle_status(gGlobalSyncTable.bubbleDeath,"Normal", "Bubble", "Downing")
            end
            djui_hud_print_text("Player Interactions", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Player Interactions:", "Changes if and how players","interact with each other.")
                hud_print_unique_toggle_status(gGlobalSyncTable.playerInteractions,"Non-Solid", "Solid", "Friendly Fire")
            end
            djui_hud_print_text("Player Knockback", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Player Knockback:", "Changes how far players get","knocked back after being hit","by another player.")
                hud_print_unique_toggle_status(gGlobalSyncTable.playerKnockbackStrength,"Weak", "Normal", "Too Much", 10, 25, 60)
            end
            djui_hud_print_text("Share Lives", ((djui_hud_get_screen_width()/2) - 70), 110, 0.3)
            if optionHover == 4 then
                hud_print_description("Share Lives:", "Changes if players in the","same level share lives.")
                hud_print_unique_toggle_status(gGlobalSyncTable.shareLives, "Off", "On")
            end
            djui_hud_print_text("On Star Collection", ((djui_hud_get_screen_width()/2) - 70), 120, 0.3)
            if optionHover == 5 then
                hud_print_description("On Star Collection:", "Determines what happens","after you collect a star.")
                hud_print_unique_toggle_status(gGlobalSyncTable.stayInLevelAfterStar, "Leave Level", "Stay in Level", "Non-Stop")
            end
            djui_hud_print_text("Global Movesets", ((djui_hud_get_screen_width()/2) - 70), 130, 0.3)
            if optionHover == 6 then
                hud_print_description("Global Movesets:", "Determines if players can","locally change what moveset","they're using, Off forces","everyone to default.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalMoveset)
            end
            djui_hud_print_text("Global Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 140, 0.3)
            if optionHover == 7 then
                hud_print_description("Global Anti-Quicksand:", "Determines if players can","locally change AQS or if","it's forced off.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalAQS)
            end
        end
    end
end

function before_update(m)
    if menu and m.playerIndex == 0 then
        if optionHoverCanMove then
            if optionTab == 1 then
                if optionHover == 1 then
                    if gPlayerSyncTable[m.playerIndex].moveset == 0 and gGlobalSyncTable.GlobalMoveset then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].moveset = 1
                            mod_storage_save("MoveSave", "1")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].moveset == 1 and gGlobalSyncTable.GlobalMoveset then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].moveset = 2
                            mod_storage_save("MoveSave", "2")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].moveset == 2 and gGlobalSyncTable.GlobalMoveset then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].moveset = 0
                            mod_storage_save("MoveSave", "0")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 2 then
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
                elseif optionHover == 3 then
                    if gPlayerSyncTable[m.playerIndex].AQS == true and gGlobalSyncTable.GlobalAQS then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].AQS = false
                            mod_storage_save("AQSSave", "false")
                            optionHoverCanMove = false
                        end
                    elseif gPlayerSyncTable[m.playerIndex].AQS == false and gGlobalSyncTable.GlobalAQS then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gPlayerSyncTable[m.playerIndex].AQS = true
                            mod_storage_save("AQSSave", "true")
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 4 then
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
                elseif optionHover == 2 then
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
                    if gGlobalSyncTable.bubbleDeath == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.bubbleDeath = 1
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.bubbleDeath == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.bubbleDeath = 2
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.bubbleDeath == 2 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.bubbleDeath = 0
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
                    if gGlobalSyncTable.GlobalMoveset == 1 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.GlobalMoveset = 0
                            print("Works")
                            optionHoverCanMove = false
                        end
                    elseif gGlobalSyncTable.GlobalMoveset == 0 then
                        if m.controller.buttonDown & A_BUTTON ~= 0 then
                            gGlobalSyncTable.GlobalMoveset = 1
                            optionHoverCanMove = false
                        end
                    end
                elseif optionHover == 7 then
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
if mod_storage_load("MoveSave") == nil then
    print("'Moveset' not found in 'squishys-server.sav', set to default 'default'")
    mod_storage_save("MoveSave", "0")
end

if mod_storage_load("LGPSave") == nil then
    print("'Lava Groundpound' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("LGPSave", "true")
end

if mod_storage_load("AQSSave") == nil then
    print("'Anti-Quicksand' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("AQSSave", "true")
end

if mod_storage_load("WKSave") == nil then
    print("'Modded Wallkick' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("WKSave", "true")
end

if mod_storage_load("CRSave") == nil then
    print("'Extra Hud' > 'Collectables Radar' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CRSave", "true")
end

if mod_storage_load("CTSave") == nil then
    print("'Extra Hud' > 'Cap Timer' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CTSave", "true")
end

if mod_storage_load("notifSave") == nil then
    print("'Server Popups' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("notifSave", "true")
end

if mod_storage_load("CMDSave") == nil then
    print("'Commands' not found in 'squishys-server.sav', set to default 'off'")
    mod_storage_save("CMDSave", "false")
end

if mod_storage_load("DescSave") == nil then
    print("'Descriptions' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("DescSave", "true")
end

if mod_storage_load("SSCSave") == nil then
    print("'Star Spawn Cutscene' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("SSCSave", "true")
end
print("Saving configuration to 'squishys-server.sav'")


function on_player_connected(m)

    gPlayerSyncTable[m.playerIndex].moveset = tonumber(mod_storage_load("MoveSave"))

    if mod_storage_load("LGPSave") == "true" then
        gPlayerSyncTable[m.playerIndex].LGP = true
    elseif mod_storage_load("LGPSave") == "false" then
        gPlayerSyncTable[m.playerIndex].LGP = false
    end

    gGlobalSyncTable.GlobalAQS = true
    if mod_storage_load("AQSSave") == "true" then
        gPlayerSyncTable[m.playerIndex].AQS = true
    elseif mod_storage_load("AQSSave") == "false" then
        gPlayerSyncTable[m.playerIndex].AQS = false
    end

    if mod_storage_load("WKSave") == "true" then
        gPlayerSyncTable[m.playerIndex].wallSlide = true
    elseif mod_storage_load("WKSave") == "false" then
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
    elseif mod_storage_load("notifSave") == "false" then
        gPlayerSyncTable[m.playerIndex].notif = false
    end

    if mod_storage_load("CMDSave") == "true" then
        gPlayerSyncTable[m.playerIndex].CMDToggle = true
    elseif mod_storage_load("CMDSave") == "false" then
        gPlayerSyncTable[m.playerIndex].CMDToggle = false
    end

    if mod_storage_load("DescSave") == "true" then
        gPlayerSyncTable[m.playerIndex].Descriptions = true
    elseif mod_storage_load("DescSave") == "false" then
        gPlayerSyncTable[m.playerIndex].Descriptions = false
    end

    if mod_storage_load("SSCSave") == "true" then
        gPlayerSyncTable[m.playerIndex].SSC = true
    elseif mod_storage_load("SSCSave") == "false" then
        gPlayerSyncTable[m.playerIndex].SSC = false
    end
end

hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)