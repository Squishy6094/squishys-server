-- name: -Squishy's Server-
-- description: \\#008800\\Squishy's Server\n\n\\#dcdcdc\\A Server Mod filled with a bunch of Quality of Life Mods and Customizability made to suit anyones play style!\n\n\\#AAAAFF\\Github:\nSQUISHY6094/squishys-server\n\n\\#FF0000\\This mod is not intended for public hosting by anyone other than Verified Hosts! Please only use this mod privatly!

------------
-- Timers --
------------

if gGlobalSyncTable.RoomStart ~= nil then
    RoomTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string.format("%02d", math.floor(get_time() - gGlobalSyncTable.RoomStart)%60))
else
    RoomTime = "Unknown"
end

local JoinedAt = get_time()

--------------
-- Commands --
--------------

function on_rules_command()
    rules = true
    return true
end

function on_shutdown_command(msg)
    if not network_is_server() and not network_is_moderator() then
        return false
    end
    if msg == "cancel" then
        if gGlobalSyncTable.shutdownTimer ~= nil then
            gGlobalSyncTable.shutdownTimer = nil
            djui_chat_message_create("Shutdown cancelled")
        else
            djui_chat_message_create("No Active shutdown timer found.")
        end
    else
        gGlobalSyncTable.shutdownTimer = get_time() + tonumber(msg)*60
        djui_chat_message_create("Server Shutdown set for ".. msg.. " Minutes from now")
    end
    return true
end

function on_clear_command(msg)
    if msg ~= "confirm" then
        djui_chat_message_create("Are you sure you want to do this? This will clear all Toggles and Themes from your save data!\nType \\#ff8888\\/ss clear-data confirm\\#ffffff\\ to confirm")
    else
        djui_chat_message_create("Clearing Squishy's Server Save Data...")
        save_load(true)
        theme_load()
    end
    return true
end

function server_commands(msg)
    if BootupTimer < 150 then
        djui_chat_message_create("Cannot use Squishy's Server Commands During Bootup")
        return true
    end
    local args = split(msg)
    if args[1] == "help" or args[1] == nil then
        djui_chat_message_create("\\#008800\\Squishy's Server Avalible Commands:")
        djui_chat_message_create("\\#00ffff\\/ss help \\#ffffff\\Displays these Commands whenever you need them.")
        djui_chat_message_create("\\#00ffff\\/ss rules \\#ffffff\\Displays the Rules Screen.")
        djui_chat_message_create("\\#00ffff\\/ss menu \\#ffffff\\Opens the Squishy's Server Menu.")
        djui_chat_message_create("\\#00ffff\\/ss discord \\#ffffff\\Links you to \\#6577E6\\Squishy's Server | Discord Server")
        djui_chat_message_create("\\#00ffff\\/ss reload \\#ffffff\\Reloads Squishy's Server Local Assets & Data")
        djui_chat_message_create("\\#00ffff\\/ss clear-data \\#ffffff\\Clear's all of Squishy's Server Save Data")
        if network_has_permissions() then
            djui_chat_message_create("\\#ffff00\\/ss shutdown \\#ffffff\\ Starts a timer for when the room will close.")
            djui_chat_message_create("\\#ffff00\\/ss vote \\#ffffff\\ Start a vote with any Yes/No prompt.")
            djui_chat_message_create("\\#ffff00\\/ss name-2-model\\#ff0000\\ (Debug) \\#ffffff\\ Sets your registered Name-2-Model ID to any existant one.")
            djui_chat_message_create("\\#ffff00\\/ss event\\#ff0000\\ (Debug) \\#ffffff\\ Sets the current server event.")

        end
        return true
    end
    if args[1] == "rules" then
        return on_rules_command()
    end
    if args[1] == "menu" then
        return on_menu_command(msg)
    end
    if args[1] == "discord" then
        djui_chat_message_create("\\#008800\\Squishy's Server \\#ffffff\\| \\#6577E6\\Discord Server:\n\\#8888ff\\https://discord.gg/G2zMwjbxdh")
        return true
    end
    if args[1] == "reload" then
        return on_reload_command()
    end
    if args[1] == "clear-data" then
        return on_clear_command(args[2])
    end
    if args[1] == "shutdown" then
        return on_shutdown_command(args[2])
    end
    if args[1] == "name-2-model" then
        return set_discord_id(args[2])
    end
    if args[1] == "event" then
        return on_event_command(msg)
    end
    if args[1] == "vote" then
        return on_vote_command(msg)
    end
end

hook_chat_command("ss", "\\#00ffff\\[Command] \\#dcdcdc\\Access all of \\#005500\\Squishy's Server \\#dcdcdc\\Commands (Use /help for more information)", server_commands)

-----------
-- Rules --
-----------

local offsetX = -200
local opacity = 255
local rulesTimer = get_time() + 10
local lastpopupNum = 0
local firstRuleShow = true
local rules = true

if mod_storage_load("RulesSave") ~= nil and mod_storage_load("RulesSave") ~= "1" then
    rules = false
    firstRuleShow = false
end

function displayrules(m)
    if BootupTimer < 150 then return end
    if rules or menu or menuTable[2][6].status ~= 0 then
        if gGlobalSyncTable.RoomStart ~= nil then
            RoomTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string.format("%02d", math.floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string.format("%02d", math.floor(get_time() - gGlobalSyncTable.RoomStart)%60))
        else
            RoomTime = "Unknown"
        end

        JoinTime = string.format("%s:%s:%s", string.format("%02d", math.floor((get_time() - JoinedAt)/60/60)), string.format("%02d", math.floor((get_time() - JoinedAt)/60)%60), string.format("%02d", math.floor(get_time() - JoinedAt)%60))
    end
    
    if rules and offsetX < -1 then
        offsetX = offsetX/1.1
    end

    if not rules and offsetX > -200 then
        offsetX = offsetX*1.2
    end

    if offsetX <= -200 and not rules and not noLoop then
        djui_chat_message_create("Welcome to \\#008800\\Squishy's Server\\#dcdcdc\\! You can use \\#00ffff\\/ss help \\#dcdcdc\\for a list of commands!")
        if network_is_server() then
            --[[
            if network_is_bestie() ~= nil and network_is_bestie() == true then
                djui_popup_create("You are now hosting\n\\#005500\\Squishy's Server\\#dcdcdc\\,\nCheck your mods list and\nsend an Invite!",4)
            else
                djui_popup_create("\n\\#ffff00\\Warning:\n\\#dcdcdc\\You are not a Verified Host,\nand will be marked as such\nto other players.\n\nDo not host publicly with this\nmod to avoid being banned\nfrom both the\n\\#7289DA\\Sm64ex-coop Discord \\#dcdcdc\\& \\#ff3333\\Coopnet!",8)
            end
            ]]--
        else
            djui_popup_create("Thanks For Joining\n\\#005500\\Squishy's Server\\#dcdcdc\\,\nEnjoy your Stay!",3)
        end
        popupNum = math.random(1,11)
        noLoop = true
        return
    end
    if offsetX > -200 then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(255, 255, 255, 200)
        djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, 0 + offsetX, 0, 1.2905152376, 1.17073170732, 0, 0, 176, 205)
        djui_hud_set_color(0, 0, 0, 220)
        djui_hud_render_rect(3 + offsetX, 2, 190, djui_hud_get_screen_height() - 4)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 50)
        if discordID ~= "0" then
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Registered as "..modelTable[discordID].nickname.. " via Name-2-Model", 190 - (djui_hud_measure_text("Registered as "..modelTable[discordID].nickname.. " via Name-2-Model")*0.2) + offsetX, 5, 0.2)
        else
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text("Unregistered via Name-2-Model", 190 - (djui_hud_measure_text("Unregistered via Name-2-Model")*0.2) + offsetX, 5, 0.2)
        end

        if RoomTime ~= nil then
            djui_hud_print_text("Room Time: ".. RoomTime, 190 - (djui_hud_measure_text("Room Time: ".. RoomTime)*0.2) + offsetX, 11, 0.2)
        end

        if network_has_permissions() then
            djui_hud_print_text("Moderator Access Granted", 190 - (djui_hud_measure_text("Moderator Access Granted")*0.2) + offsetX, 17, 0.2)
        end

        if themeTable[menuTable[2][3].status].hoverColor == nil then
            themeTable[menuTable[2][3].status].hoverColor = {r = 150, g = 150, b = 150}
        end

        if themeTable[menuTable[2][3].status].headerColor == nil then
            themeTable[menuTable[2][3].status].headerColor = themeTable[menuTable[2][3].status].hoverColor
        end

        djui_hud_set_color(themeTable[menuTable[2][3].status].headerColor.r, themeTable[menuTable[2][3].status].headerColor.g, themeTable[menuTable[2][3].status].headerColor.b, 255)
        if themeTable[menuTable[2][3].status].hasHeader then
            djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, offsetX, 18, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
        else
            djui_hud_render_texture_tile(themeTable[0].texture, offsetX, 18, 0.16666666666, 0.58666666666, 0, 206, 176, 50)
        end

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Welcome to", 12 + offsetX, 7, 0.4)

        djui_hud_set_font(FONT_HUD)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Rules", 15 + offsetX, 50, 0.6)
        djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 255)
        djui_hud_render_rect(15 + offsetX, 61, (djui_hud_measure_text("Rules")*0.6), 1)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("#1 Don't Harass Other Users", 20 + offsetX, 65, 0.3)
        djui_hud_print_text("#2 Don't Spam/Beg for Something", 20 + offsetX, 75, 0.3)
        djui_hud_print_text("#3 Follow the same Rules you would", 20 + offsetX, 85, 0.3)
        djui_hud_print_text("in the sm64ex-coop Discord Server", 20 + offsetX, 92, 0.3)

        djui_hud_set_font(FONT_HUD)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Basic Info and Tips", 15 + offsetX, 105, 0.6)
        djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 255)
        djui_hud_render_rect(15 + offsetX, 116, (djui_hud_measure_text("Basic Info and Tips")*0.6), 1)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Check your Server Options via", 20 + offsetX, 120, 0.3)
        djui_hud_print_text("Pausing and Pressing the L button", 20 + offsetX, 127, 0.3)
        djui_hud_print_text("To avoid lag and clutter, some mods", 20 + offsetX, 137, 0.3)
        djui_hud_print_text('are built into into "-Squishy'.."'"..'s Server-"', 20 + offsetX, 144, 0.3)

        djui_hud_set_font(FONT_HUD)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Support and Contribution", 15 + offsetX, 165, 0.6)
        djui_hud_set_color(themeTable[menuTable[2][3].status].hoverColor.r, themeTable[menuTable[2][3].status].hoverColor.g, themeTable[menuTable[2][3].status].hoverColor.b, 255)
        djui_hud_render_rect(15 + offsetX, 176, (djui_hud_measure_text("Support and Contribution")*0.6), 1)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("If you have any questions about the server", 20 + offsetX, 181, 0.3)
        djui_hud_print_text("and/or the mods loaded, Feel free to ask!", 20 + offsetX, 188, 0.3)
        djui_hud_print_text('If you have any "Quality of life" Mods that', 20 + offsetX, 198, 0.3)
        djui_hud_print_text('you would like to see when I host, Go ahead and', 20 + offsetX, 205, 0.3)
        djui_hud_print_text('ask or send me the mod directly on Discord', 20 + offsetX, 212, 0.3)

        if get_time() >= rulesTimer then
            if opacity >= -1 then
                opacity = opacity/1.05
            end
            djui_hud_set_font(FONT_MENU)
            djui_hud_set_color(255, 255, 255, 255 - opacity)
            djui_hud_print_text("Press A to continue", 100 + offsetX - (djui_hud_measure_text("Press A to continue")*0.5*0.2), djui_hud_get_screen_height() - 17, 0.2)
        end
    end
end

-----------------
--Message Timer--
-----------------

popupTable = {
    [1] = {
        text = "Thanks For Playing on\n\\#005500\\Squishy's Server\\#dcdcdc\\!",
        lines = 2
    },
    [2] = {
        text = '\nRemember to customize your\nsettings via the\n"Server Options" Menu,\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 5
    },
    [3] = {
        text = '\nCustom Moves hindering your\ngameplay? You can turn them\noff under the "Movesets" Tab\nin the "Server Options" Menu,\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 6
    },
    [4] = {
        text = '\nHate all the HUD clutter?\nYou can toggle your HUD Type\nin the "Server Options" Menu\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 5
    },
    [5] = {
        text = '\nThese messages pop-up every 1-3 minutes, You can turn them off\nin the "Server Options" Menu\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 5
    },
    [6] = {
        text = 'This game is brought to you by\nThe QOL Mod Creators on the\nsm64ex-coop Discord Server!',
        lines = 3
    },
    [7] = {
        text = "Remember to keep a lookout for users\nwith an \\#ff0000\\[Unverified Host]\\#dcdcdc\\ role,\nThey're not supposed to be\nHosting with Squishy's Server and\nshould be reported as soon as possible!",
        lines = 5
    },
    [8] = {
        text = "Remember to tip your hosts folks,\nThey won't get their pay\nany other way!",
        lines = 3
    },
    [9] = {
        text = "If you get knocked back, you can\npress Z when you hit the ground to\nTech and get right back up!",
        lines = 3
    },
    [10] = {
        text = "You can get though a door\nquicker if you kick it down!",
        lines = 2
    },
    [11] = {
        text = "If you're fast enough, you can\nPress A or B on a Ledge to\ntrick and keep your speed!",
        lines = 3
    },
    [12] = {
        text = "\nPersonal Model not added?\nDM me with the models you want\nand I'll add them as soon as\npossible!",
        lines = 4
    },
    [13] = {
        text = "Join \\#008800\\Squishy's Server\\#dcdcdc\\ | \\#6577E6\\Discord Server\n\\#dcdcdc\\Use\\#6577E6\\ /ss discord\\#dcdcdc\\ for an invite link!",
        lines = 2
    }
}

local popupTimer = get_time()
local noLoop = false
local noLoopTheSequal = false
local timer = 0
doSparkles = false
function mario_update_msgtimer(m)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end
    if get_time() - popupTimer >= math.random(60,180) and menuTable[3][5].status == 1 then
        popupTimer = get_time()
        popupNum = math.random(1,#popupTable)
        if lastpopupNum == popupNum then
            popupNum = math.random(1,#popupTable)
        end
        lastpopupNum = popupNum
        djui_popup_create(popupTable[popupNum].text, popupTable[popupNum].lines)
    end

    if rules then
        if firstRuleShow then
            m.pos.y = m.floorHeight
            m.action = ACT_READING_NPC_DIALOG
        end
        if get_time() >= rulesTimer and m.controller.buttonDown & A_BUTTON ~= 0 then
            rules = false
            firstRuleShow = false
        end
    end

    if gGlobalSyncTable.shutdownTimer ~= nil then
        if not noLoop and gGlobalSyncTable.shutdownTimer > get_time() + 60 then
            djui_popup_create("Squishy's Server Maintenence\nStarting in ".. math.floor((gGlobalSyncTable.shutdownTimer - get_time())/60) .. " Minutes", 2)
            noLoop = true
        end

        if gGlobalSyncTable.shutdownTimer <= get_time() + 60 and not noLoopTheSequal then
            djui_popup_create("Squishy's Server Maintenence\nStarting in 1 Minute", 2)
            noLoop = true
            noLoopTheSequal = true
        end

        if get_time() >= gGlobalSyncTable.shutdownTimer then
            djui_popup_create("Squishy's Server Maintenence Starting,\nThank you for playing!", 2)
        end
    else
        if noLoop then
            djui_popup_create("Server Maintenence Cancelled\nEnjoy your Stay!", 2)
            noLoop = false
            noLoopTheSequal = false
        end
    end

    timer = timer + 1
    if doSparkles then
        if network_is_developer() then
            if timer >= 1000 then
                gPlayerSyncTable[0].particleFlags = PARTICLE_LEAF
                timer = 0
            end
            m.particleFlags = gPlayerSyncTable[m.playerIndex].particleFlags
        else
            if timer >= 1000 then
                gPlayerSyncTable[0].particleFlags = PARTICLE_19
                timer = 0
            end
            m.particleFlags = gPlayerSyncTable[m.playerIndex].particleFlags
        end
        if not gNetworkPlayers[m.playerIndex].connected then
            if timer >= 1000 then
                gPlayerSyncTable[0].particleFlags = PARTICLE_19
                timer = 0
            end
            m.particleFlags = gPlayerSyncTable[m.playerIndex].particleFlags
        end
    else
        if timer >= 1000 then
            gPlayerSyncTable[0].particleFlags = PARTICLE_19
            timer = 0
        end
        m.particleFlags = gPlayerSyncTable[m.playerIndex].particleFlags
    end
end

for i = 0, MAX_PLAYERS - 1 do
    gPlayerSyncTable[i].particleFlags = PARTICLE_19
    if i == 0 then
        gPlayerSyncTable[0].particleFlags = PARTICLE_19
    end
end

local function on_player_disconnected()
    for i = 0, MAX_PLAYERS - 1 do
        gPlayerSyncTable[i].particleFlags = PARTICLE_19
        gMarioStates[i].particleFlags = gPlayerSyncTable[i].particleFlags
    end
end

hook_event(HOOK_ON_HUD_RENDER, displayrules)
hook_event(HOOK_MARIO_UPDATE, mario_update_msgtimer)
hook_event(HOOK_ON_PLAYER_DISCONNECTED, on_player_disconnected)
--Fix Custom Tree Billboarding (Gone now)
--[[
hook_behavior(id_bhvTree, OBJ_LIST_POLELIKE, true, function(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_POLE
    o.hitboxRadius = 80
    o.hitboxHeight = 500
    o.oIntangibleTimer = 0
end, function(o) bhv_pole_base_loop() end, "id_bhvTree")
--]]