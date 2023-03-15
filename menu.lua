
gGlobalSyncTable.RoomTimerF = 0

gGlobalSyncTable.bubbleDeath = 2
gGlobalSyncTable.playerInteractions = gServerSettings.playerInteractions
gGlobalSyncTable.playerKnockbackStrength = gServerSettings.playerKnockbackStrength
gGlobalSyncTable.stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar
gGlobalSyncTable.GlobalAQS = true
gGlobalSyncTable.GlobalMoveset = true

local menu = false
local optionType = 0
local optionTab = 1
local optionHover = 1
local optionHoverTimer = -1

function hud_print_description(CMDName, Line1, Line2, Line3, Line4, Line5, Line6, Line7, Line8, Line9)
    local m = gMarioStates[0]
    if descriptions then
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
    if optionTab == 2 and optionHover <= 3 then
        if SyncTable then
            djui_hud_print_text("On", ((djui_hud_get_screen_width()/2) + 70), 70 + (optionHover * 10), 0.3)
        elseif not SyncTable then
            djui_hud_print_text("Off", ((djui_hud_get_screen_width()/2) + 70), 70 + (optionHover * 10), 0.3)
        end
    elseif optionTab == 2 and optionHover >= 4 and optionHover <= 5 then
        if SyncTable then
            djui_hud_print_text("On", (djui_hud_get_screen_width()/2), 70 + (optionHover * 10 - 20), 0.3)
        elseif not SyncTable then
            djui_hud_print_text("Off", (djui_hud_get_screen_width()/2), 70 + (optionHover * 10 - 20), 0.3)
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
    if network_is_server() and m.playerIndex == 0 then
        gGlobalSyncTable.RoomTimerF = gGlobalSyncTable.RoomTimerF + 1
    end

    if gGlobalSyncTable.bubbleDeath ~= 2 then
        gServerSettings.bubbleDeath = gGlobalSyncTable.bubbleDeath
    else 
        gServerSettings.bubbleDeath = 0
    end
    gServerSettings.playerInteractions = gGlobalSyncTable.playerInteractions
    gServerSettings.playerKnockbackStrength = gGlobalSyncTable.playerKnockbackStrength
    gServerSettings.stayInLevelAfterStar = gGlobalSyncTable.stayInLevelAfterStar
end

function displaymenu()
    local m = gMarioStates[0]

    if menu then
        djui_hud_set_color(0, 0, 0, 50)
        djui_hud_render_rect(0, 0, 1000, 1000)
    end


    --Room Timer--

    minutes = 0
    Seconds = 0
    Hours = 0
    if math.floor(gGlobalSyncTable.RoomTimerF/30/60) < 0 then
        Seconds = math.ceil(gGlobalSyncTable.speedrunTimer/30)
    else
        Hours = math.floor(gGlobalSyncTable.RoomTimerF/30/60/60)
        minutes = math.floor(gGlobalSyncTable.RoomTimerF/30/60%60)
        Seconds = math.floor(gGlobalSyncTable.RoomTimerF/30)%60
    end

    RoomTime = string.format("%s:%s:%s", string.format("%02d", Hours), string.format("%02d", minutes), string.format("%02d", Seconds))

    if is_game_paused() then
        djui_hud_set_font(FONT_NORMAL)
        if m.action ~= ACT_EXIT_LAND_SAVE_DIALOG then
            if (m.controller.buttonPressed & L_TRIG) ~= 0 and menu == false then
                menu = true
            elseif (m.controller.buttonPressed & B_BUTTON) ~= 0 and menu then
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
            djui_hud_print_text(RoomTime, ((djui_hud_get_screen_width()/2) - 32.5), 42, 0.7)
        end
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Room has been Open for:", ((djui_hud_get_screen_width()/2) - 35), 30, 0.3)
        djui_hud_print_text(RoomTime, ((djui_hud_get_screen_width()/2) - 35), 40, 0.7)
    else 
        menu = false
    end

    if menu then
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
            optionTab = optionTab - 1
            optionHoverTimer = 0
        elseif (m.controller.stickX > 10 or (m.controller.buttonDown & R_JPAD ~= 0)) and optionHoverTimer == -1 then
            play_sound(SOUND_MENU_MESSAGE_NEXT_PAGE, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            optionTab = optionTab + 1
            optionHoverTimer = 0
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

        
        if descriptions then
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
                optionHover = 5
            elseif  optionHover > 5 then
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
                    djui_hud_print_text("Forced Default", ((djui_hud_get_screen_width()/2)), 80, 0.3)
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
                hud_print_toggle_status(LGP)
            end
            djui_hud_print_text("Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Anti-Quicksand:", "Makes instant quicksand act","like lava, preventing what","may seem like an unfair","deaths. (Does not include","Lava Groundpound functions)")
                if gGlobalSyncTable.GlobalAQS then
                    hud_print_toggle_status(AQS)
                else
                    djui_hud_print_text("Forced Off", ((djui_hud_get_screen_width()/2)), 100, 0.3)
                end
            end
            djui_hud_print_text("Modded Wallkick", ((djui_hud_get_screen_width()/2) - 70), 110, 0.3)
            if optionHover == 4 then
                hud_print_description("Modded Wallkick:", "Adds Wallsliding and more","lenient angles you can wall","kick at, best for a more","modern experience.")
                hud_print_toggle_status(gPlayerSyncTable[0].wallSlide)
            end
            djui_hud_print_text("Strafing", ((djui_hud_get_screen_width()/2) - 70), 120, 0.3)
            if optionHover == 5 then
                hud_print_description("Strafing:", "Forces Mario to face the","direction the Camera is","facing, similar to Sonic Robo","Blast 2. Recommended if you","play with Mouse and Keyboard.")
                hud_print_toggle_status(strafeToggle)
            end
        elseif optionTab == 2 then
            if optionHover < 1 then
                optionHover = 5
            elseif  optionHover > 5 then
                optionHover = 1
            end
            djui_hud_set_color(150, 150, 150, 255)
            if (optionHover >= 1 and optionHover <= 3) then
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80, 70, 9)
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 2), 110 + (optionHover * 10 - 40), 70, 9)
            else
                djui_hud_render_rect(((djui_hud_get_screen_width()/2) - 72), 80 + (optionHover * 10 - 30), 70, 9)
            end

            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("Extra HUD", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover >= 1 and optionHover <= 3 then
                hud_print_description("Extra HUD:", "Adds Quality of Life HUD","Elements to tell extra","Information")
                djui_hud_print_text("Red Coin Radar", ((djui_hud_get_screen_width()/2)), 80, 0.3)
                djui_hud_print_text("Secrets Radar", ((djui_hud_get_screen_width()/2)), 90, 0.3)
                djui_hud_print_text("Cap Timer", ((djui_hud_get_screen_width()/2)), 100, 0.3)
            end
            if optionHover == 1 then
                hud_print_description("","","","","","Red Coin Radar:", "Tells you how far away","Red Coins are.")
                hud_print_toggle_status(radarRedToggle)
            end
            if optionHover == 2 then
                hud_print_description("","","","","","Secret Radar:", "Tells you how far away","Secrets are.")
                hud_print_toggle_status(radarSecretToggle)
            end
            if optionHover == 3 then
                hud_print_description("","","","","","Cap Timer:", "Tells you how many seconds","your cap has left until it","runs out.")
                hud_print_toggle_status(capTimerToggle)
            end
            djui_hud_print_text("Descriptions", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 4 then
                hud_print_description("Descriptions:", "Toggles these descriptions","you see on the right,","Recommended to turn Off if","you like a more minimalistic","menu.")
                hud_print_toggle_status(descriptions)
            end
            djui_hud_print_text("Server Popups", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 5 then
                hud_print_description("Server Popups:", "Shows Tips/Hints about the","server every 3-5 minutes.","Recommended for if you're","new to the server.")
                hud_print_toggle_status(notif)
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
            djui_hud_print_text("Star Spawn Cutscene", ((djui_hud_get_screen_width()/2) - 70), 80, 0.3)
            if optionHover == 1 then
                hud_print_description("Star Spawn Cutscene:", "Toggles if Star Spawning","Cutscenes play, Recommended","if you don't know where a","star spawns.")
                hud_print_toggle_status(SSC)
            end
            djui_hud_print_text("Personal Model", ((djui_hud_get_screen_width()/2) - 70), 90, 0.3)
            if optionHover == 2 then
                hud_print_description("Personal Model:", "Toggles your own Custom","Player Model, Only avalible","for users with at least","one Custom Model.","","","Contact The Host for more","information about","Custom Models and DynOS")
                if discordID ~= "0" then
                    djui_hud_print_text(modelTable[discordID][currModel].modelName, (djui_hud_get_screen_width()/2), 70 + (optionHover * 10), 0.3)
                else
                    djui_hud_print_text("N/A", (djui_hud_get_screen_width()/2), 70 + (optionHover * 10), 0.3)
                end
            end
            djui_hud_print_text("Locally Display Models", ((djui_hud_get_screen_width()/2) - 70), 100, 0.3)
            if optionHover == 3 then
                hud_print_description("Locally Display Models:", "Toggles if Custom Player","Models Display locally,","Recommended if other people's","Custom models are getting","in the way.","","Contact The Host for more","information about","Custom Models and DynOS")
                hud_print_toggle_status(modelToggle)
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
            djui_hud_print_text("On Star Collection", ((djui_hud_get_screen_width()/2) - 70), 110, 0.3)
            if optionHover == 4 then
                hud_print_description("On Star Collection:", "Determines what happens","after you collect a star.")
                hud_print_unique_toggle_status(gGlobalSyncTable.stayInLevelAfterStar, "Leave Level", "Stay in Level", "Non-Stop")
            end
            djui_hud_print_text("Global Movesets", ((djui_hud_get_screen_width()/2) - 70), 120, 0.3)
            if optionHover == 5 then
                hud_print_description("Global Movesets:", "Determines if players can","locally change what moveset","they're using, Off forces","everyone to default.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalMoveset)
            end
            djui_hud_print_text("Global Anti-Quicksand", ((djui_hud_get_screen_width()/2) - 70), 130, 0.3)
            if optionHover == 6 then
                hud_print_description("Global Anti-Quicksand:", "Determines if players can","locally change AQS or if","it's forced off.")
                hud_print_toggle_status(gGlobalSyncTable.GlobalAQS)
            end
        end
    end
end

function before_update(m)
    if menu then
        if m.playerIndex ~= 0 then return end        
        if optionHoverTimer == -1 and m.controller.buttonDown & A_BUTTON ~= 0 then
            optionHoverTimer = 0
            print("Saving configuration to 'squishys-server.sav'")
            if optionTab == 1 and optionHover == 1 then
                gPlayerSyncTable[m.playerIndex].moveset = gPlayerSyncTable[m.playerIndex].moveset + 1
                if gPlayerSyncTable[m.playerIndex].moveset == 3 then
                    gPlayerSyncTable[m.playerIndex].moveset = 0
                end
                mod_storage_save("MoveSave", tostring(gPlayerSyncTable[m.playerIndex].moveset))
            end

            if optionTab == 1 and optionHover == 2 then
                if LGP then
                    LGP = false
                    mod_storage_save("LGPSave", "false")
                elseif LGP == false then
                    LGP = true
                    mod_storage_save("LGPSave", "true")
                end
            end

            if optionTab == 1 and optionHover == 3 then
                if AQS and gGlobalSyncTable.GlobalAQS then
                    AQS = false
                    mod_storage_save("AQSSave", "false")
                    print("toggle false")
                elseif AQS == false and gGlobalSyncTable.GlobalAQS then
                    AQS = true
                    mod_storage_save("AQSSave", "true")
                    print("toggle true")
                end
            end

            if optionTab == 1 and optionHover == 4 then
                if gPlayerSyncTable[0].wallSlide then
                    gPlayerSyncTable[0].wallSlide = false
                    mod_storage_save("WKSave", "false")
                elseif gPlayerSyncTable[0].wallSlide == false then
                    gPlayerSyncTable[0].wallSlide = true
                    mod_storage_save("WKSave", "true")
                end
            end

            if optionTab == 1 and optionHover == 5 then
                if strafeToggle then
                    strafeToggle = false
                    mod_storage_save("StrafeSave", "false")
                elseif strafeToggle == false then
                    strafeToggle = true
                    mod_storage_save("StrafeSave", "true")
                end
            end

            if optionTab == 2 and optionHover == 1 then
                if radarRedToggle then
                    radarRedToggle = false
                    mod_storage_save("CRRSave", "false")
                elseif radarRedToggle == false then
                    radarRedToggle = true
                    mod_storage_save("CRRSave", "true")
                end
            end

            if optionTab == 2 and optionHover == 2 then
                if radarSecretToggle then
                    radarSecretToggle = false
                    mod_storage_save("CRSSave", "false")
                elseif radarSecretToggle == false then
                    radarSecretToggle = true
                    mod_storage_save("CRSSave", "true")
                end
            end

            if optionTab == 2 and optionHover == 3 then
                if capTimerToggle then
                    capTimerToggle = false
                    mod_storage_save("CTSave", "false")
                elseif capTimerToggle == false then
                    capTimerToggle = true
                    mod_storage_save("CTSave", "true")
                end
            end

            if optionTab == 2 and optionHover == 4 then
                if descriptions then
                    descriptions = false
                    mod_storage_save("DescSave", "false")
                elseif descriptions == false then
                    descriptions = true
                    mod_storage_save("DescSave", "true")
                end
            end

            if optionTab == 2 and optionHover == 5 then
                if notif then
                    notif = false
                    mod_storage_save("notifSave", "false")
                elseif notif == false then
                    notif = true
                    mod_storage_save("notifSave", "true")
                end
            end

            if optionTab == 3 and optionHover == 1 then
                if SSC then
                    SSC = false
                    mod_storage_save("SSCSave", "false")
                elseif SSC == false then
                    SSC = true
                    mod_storage_save("SSCSave", "true")
                end
            end

            if optionTab == 3 and optionHover == 2 then
                currModel = currModel + 1
                if modelTable[discordID][currModel] == nil then
                    currModel = 0
                end
                mod_storage_save("ModelSave", tostring(currModel))
            end

            if optionTab == 3 and optionHover == 3 then
                if modelToggle then
                    modelToggle = false
                    mod_storage_save("LDMSave", "false")
                elseif modelToggle == false then
                    modelToggle = true
                    mod_storage_save("LDMSave", "true")
                end
            end

            if optionTab == 4 and optionHover == 1 then
                if gGlobalSyncTable.bubbleDeath == 0 then
                    gGlobalSyncTable.bubbleDeath = 1
                elseif gGlobalSyncTable.bubbleDeath == 1 then
                    gGlobalSyncTable.bubbleDeath = 2
                elseif gGlobalSyncTable.bubbleDeath == 2 then
                    gGlobalSyncTable.bubbleDeath = 0
                end
            end

            if optionTab == 4 and optionHover == 2 then
                if gGlobalSyncTable.playerInteractions == 0 then
                    gGlobalSyncTable.playerInteractions = 1
                elseif gGlobalSyncTable.playerInteractions == 1 then
                    gGlobalSyncTable.playerInteractions = 2
                elseif gGlobalSyncTable.playerInteractions == 2 then
                    gGlobalSyncTable.playerInteractions = 0
                end
            end

            if optionTab == 4 and optionHover == 3 then
                if gGlobalSyncTable.playerKnockbackStrength == 10 then
                    gGlobalSyncTable.playerKnockbackStrength = 25
                elseif gGlobalSyncTable.playerKnockbackStrength == 25 then
                    gGlobalSyncTable.playerKnockbackStrength = 60
                elseif gGlobalSyncTable.playerKnockbackStrength == 60 then
                    gGlobalSyncTable.playerKnockbackStrength = 10
                end
            end

            if optionTab == 4 and optionHover == 4 then
                if gGlobalSyncTable.stayInLevelAfterStar == 0 then
                    gGlobalSyncTable.stayInLevelAfterStar = 1
                elseif gGlobalSyncTable.stayInLevelAfterStar == 1 then
                    gGlobalSyncTable.stayInLevelAfterStar = 2
                elseif gGlobalSyncTable.stayInLevelAfterStar == 2 then
                    gGlobalSyncTable.stayInLevelAfterStar = 0
                end
            end

            if optionTab == 4 and optionHover == 5 then
                if gGlobalSyncTable.GlobalMoveset then
                    gGlobalSyncTable.GlobalMoveset = false
                elseif gGlobalSyncTable.GlobalMoveset == false then
                    gGlobalSyncTable.GlobalMoveset = true
                end
            end

            if optionTab == 4 and optionHover == 6 then
                if gGlobalSyncTable.GlobalAQS then
                    gGlobalSyncTable.GlobalAQS = false
                elseif gGlobalSyncTable.GlobalAQS == false then
                    gGlobalSyncTable.GlobalAQS = true
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

if mod_storage_load("StrafeSave") == nil then
    print("'Strafe' not found in 'squishys-server.sav', set to default 'off'")
    mod_storage_save("StrafeSave", "false")
end

if mod_storage_load("CRRSave") == nil then
    print("'Extra Hud' > 'Red Coin Radar' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CRRSave", "true")
end

if mod_storage_load("CRSSave") == nil then
    print("'Extra Hud' > 'Red Coin Radar' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("CRSSave", "true")
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

if mod_storage_load("ModelSave") == nil then
    print("'Player-Specific Models' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("ModelSave", "1")
end

if mod_storage_load("LDMSave") == nil then
    print("'Locally Display Models' not found in 'squishys-server.sav', set to default 'on'")
    mod_storage_save("LDMSave", "true")
end
print("Saving configuration to 'squishys-server.sav'")

--Save to Variable--
gPlayerSyncTable[0].moveset = tonumber(mod_storage_load("MoveSave"))

if mod_storage_load("LGPSave") == "true" then
    LGP = true
elseif mod_storage_load("LGPSave") == "false" then
    LGP = false
end

gGlobalSyncTable.GlobalAQS = true
if mod_storage_load("AQSSave") == "true" then
    AQS = true
elseif mod_storage_load("AQSSave") == "false" then
    AQS = false
end

if mod_storage_load("WKSave") == "true" then
    gPlayerSyncTable[0].wallSlide = true
elseif mod_storage_load("WKSave") == "false" then
    gPlayerSyncTable[0].wallSlide = false
end

if mod_storage_load("StrafeSave") == "true" then
    strafeToggle = true
elseif mod_storage_load("StrafeSave") == "false" then
    strafeToggle = false
end

if mod_storage_load("CRRSave") == "true" then
    radarRedToggle = true
elseif mod_storage_load("CRRSave") == "false" then
    radarRedToggle = false
end

if mod_storage_load("CRSSave") == "true" then
    radarSecretToggle = true
elseif mod_storage_load("CRSSave") == "false" then
    radarSecretToggle = false
end

if mod_storage_load("CTSave") == "true" then
    capTimerToggle = true
elseif mod_storage_load("CTSave") == "false" then
    capTimerToggle = false
end

if mod_storage_load("notifSave") == "true" then
    notif = true
elseif mod_storage_load("notifSave") == "false" then
    notif = false
end

if mod_storage_load("DescSave") == "true" then
    descriptions = true
elseif mod_storage_load("DescSave") == "false" then
    descriptions = false
end

if mod_storage_load("SSCSave") == "true" then
    SSC = true
elseif mod_storage_load("SSCSave") == "false" then
    SSC = false
end

currModel = tonumber(mod_storage_load("ModelSave"))

if mod_storage_load("LDMSave") == "true" then
    modelToggle = true
elseif mod_storage_load("LDMSave") == "false" then
    modelToggle = false
end

hook_event(HOOK_ON_HUD_RENDER, displaymenu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)