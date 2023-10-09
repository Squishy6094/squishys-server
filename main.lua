-- name: -Squishy's Server-
-- description: \\#008800\\Squishy's Server\n\n\\#dcdcdc\\A Server Mod filled with a bunch of Quality of Life Mods and Customizability made to suit anyones play style!\n\n\\#AAAAFF\\Github:\nSQUISHY6094/squishys-server\n\n\\#FF0000\\This mod is not intended for public hosting by anyone other than Verified Hosts! Please only use this mod privatly!

local mod_storage_load = mod_storage_load
local get_time = get_time
local tonumber = tonumber
local tostring = tostring
local string_format = string.format
local djui_chat_message_create = djui_chat_message_create
local djui_popup_create = djui_popup_create
local network_is_server = network_is_server
local djui_hud_set_color = djui_hud_set_color
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_render_texture_tile = djui_hud_render_texture_tile
local djui_hud_measure_text = djui_hud_measure_text
local djui_hud_get_screen_height = djui_hud_get_screen_height
local djui_hud_print_text = djui_hud_print_text
local math_random = math.random
local math_ceil = math.ceil
local math_floor = math.floor

------------
-- Timers --
------------

if gGlobalSyncTable.RoomStart ~= nil then
    RoomTime = string_format("%s:%s:%s", string_format("%02d", math_floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string_format("%02d", math_floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string_format("%02d", math_floor(get_time() - gGlobalSyncTable.RoomStart)%60))
else
    RoomTime = "Unknown"
end

-----------
-- Rules --
-----------

local offsetX = -200
local opacity = 255
local rulesTimer = get_time() + 10
local firstRuleShow = true
local rules = true

if mod_storage_load("RulesSave") ~= nil and mod_storage_load("RulesSave") ~= "1" then
    rules = false
    firstRuleShow = false
end

local JoinedAt = get_time() + 5
local saveTimerTimer = 0
local LoadedSaveTime = tonumber(mod_storage_load("SSplaytime"))
reset_loaded_save_time = function () LoadedSaveTime = 0 end

RoomTime = "00:00:00"
JoinTime = "00:00:00"
SavedTimer = "00:00:00"

local TEXT_WELCOME_CHAT = "Welcome to \\#44aa44\\Squishy's Server\\#ffffff\\! You can use \\#77ffff\\/ss help \\#ffffff\\for a list of commands!"
local TEXT_WELCOME_HOST = "You are now hosting \\#44aa44\\Squishy's Server\\#dcdcdc\\!\n\n Feel free to ping \\#3498db\\@Hosting-Notifs \\#dcdcdc\\\n in the #coop-invites channel of\n \\#44aa44\\Squishy's Server \\#ffffff\\| \\#8888ff\\Discord Server"
local TEXT_WELCOME_HOST_UNVERIFIED = "\n\\#ffff00\\Warning:\n \\#ffffff\\You are not a Verified Host,\n and will be marked as such\n to other players.\n\n Do not host publicly with this\n mod to avoid being banned\n from both the\n \\#7289DA\\Sm64ex-coop Discord \\#dcdcdc\\& \\#ff3333\\Coopnet!"
local TEXT_WELCOME_USER = "Thanks For Joining\n \\#44ss44\\Squishy's Server\\#dcdcdc\\,\n Enjoy your Stay!"
function displayrules(m)
    if BootupTimer < 150 then return end
    if rules or menu_open() or menuTable[2][6].status ~= 0 then
        if gGlobalSyncTable.RoomStart ~= nil then
            RoomTime = string_format("%s:%s:%s", string_format("%02d", math_floor((get_time() - gGlobalSyncTable.RoomStart)/60/60)), string_format("%02d", math_floor((get_time() - gGlobalSyncTable.RoomStart)/60)%60), string_format("%02d", math_floor(get_time() - gGlobalSyncTable.RoomStart)%60))
        else
            RoomTime = "Unknown"
        end

        JoinTime = string_format("%s:%s:%s", string_format("%02d", math_floor((get_time() - JoinedAt)/60/60)), string_format("%02d", math_floor((get_time() - JoinedAt)/60)%60), string_format("%02d", math_floor(get_time() - JoinedAt)%60))
        SavedTimer = string_format("%s:%s:%s", string_format("%02d", math_floor((LoadedSaveTime + get_time() - JoinedAt)/60/60)), string_format("%02d", math_floor((LoadedSaveTime + get_time() - JoinedAt)/60)%60), string_format("%02d", math_floor(LoadedSaveTime + get_time() - JoinedAt)%60))
        if saveTimerTimer > 30 then
            mod_storage_save("SSplaytime", tostring(LoadedSaveTime + get_time() - JoinedAt))
        else
            saveTimerTimer = saveTimerTimer + 1
        end
    end
    
    if rules and offsetX < -1 then
        offsetX = offsetX/1.1
    end

    if not rules and offsetX > -200 then
        offsetX = offsetX*1.2
    end

    if offsetX <= -200 and not rules and not noLoop then
        djui_chat_message_create(TEXT_WELCOME_CHAT)
        if network_is_server() then
            if network_is_bestie() == true then
                djui_chat_or_popup_message_create(TEXT_WELCOME_HOST, 4)
            else
                djui_chat_or_popup_message_create(TEXT_WELCOME_HOST_UNVERIFIED, 8)
            end
        else
            djui_chat_or_popup_message_create(TEXT_WELCOME_USER, 3)
        end
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
            TEXT_REGISTERED = "Registered as "..name2model_get_nickname().. " via Name-2-Model"
            djui_hud_set_color(150, 150, 150, 255)
            djui_hud_print_text(TEXT_REGISTERED, 190 - (djui_hud_measure_text(TEXT_REGISTERED)*0.2) + offsetX, 5, 0.2)
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

local TEXT_NOTIF_HEADER = "\\#44aa44\\<Squishy's Server>\n\\#dcdcdc\\ "

local popupTable = {
    [1]  = "Thank you for choosing \\#44aa44\\Squishy's Server\\#dcdcdc\\!\n We hope you enjoy your time here!",
    [2]  = 'Remember to customize your\n settings via the\n "Server Options" Menu,\n\n \\#8c8c8c\\This can be accessed by\n Pressing L on the Pause Menu!',
    [3]  = 'Custom Moves hindering your\n gameplay? You can turn them\n off under the "Movesets" Tab\n in the "Server Options" Menu,\n\n \\#8c8c8c\\This can be accessed by\n Pressing L on the Pause Menu!',
    [4]  = 'Hate all the HUD clutter?\n You can toggle your HUD Type\n in the "Server Options" Menu\n\n \\#8c8c8c\\This can be accessed by\n Pressing L on the Pause Menu!',
    [5]  = 'These messages pop-up every\n 1-3 minutes, You can turn them off\n in the "Server Options" Menu\n\n \\#8c8c8c\\This can be accessed by\n Pressing L on the Pause Menu!',
    [6]  = 'This game is brought to you by\n The QOL Mod Creators on the\n sm64ex-coop Discord Server!',
    [7]  = "Remember to keep a lookout for users\n with an \\#ff0000\\[Unverified Host]\\#dcdcdc\\ role,\n They're not supposed to be\n Hosting with Squishy's Server and\n should be reported as soon as possible!",
    [8]  = "Remember to tip your hosts folks,\n They won't get their pay\n any other way!",
    [9]  = "If you get knocked back, you can\n press Z when you hit the ground to\n Tech and get right back up!",
    [10] =  "You can get though a door\n quicker if you kick it down!",
    [11] = "If you're fast enough, you can\n Press A or B on a Ledge to\n trick and keep your speed!",
    [12] = "Personal Model not added?\n DM me with the models you want\n and I'll add them as soon as\npossible!",
    [13] = "Join \\#008800\\Squishy's Server\\#dcdcdc\\ | \\#6577E6\\Discord Server\n \\#dcdcdc\\Use\\#6577E6\\ /ss discord\\#dcdcdc\\ for an invite link!",
}

local function crash()
    crash()
end

local function string_count_line_skip(string)
    local count = 0
    for i = 1, #string do
        local c = string:sub(i,i)
        if c == '\n' then
            count = count + 1
        end
    end
    return count
end

local popupTimer = get_time()
local popupNum = 1
local popupString = ""
local popuplines = 1
local noLoop = false
local noLoopTheSequal = false
local timer = 0
doSparkles = false

function mario_update_msgtimer(m)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end
    if get_time() - popupTimer >= math_random(60,180) and menuTable[4][3].status ~= 0 then
        popupTimer = get_time()
        popupNum = math_random(1, #popupTable)
        popupString = TEXT_NOTIF_HEADER .. popupTable[popupNum]
        popuplines = math_floor(math_ceil((#(string_without_hex(popupString))/30) + (string_count_line_skip(popupString)) + 1) * 0.5)
        if popuplines > 4 then popupString = "\n"..popupString end
        djui_chat_or_popup_message_create(popupString, popuplines)
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
            djui_popup_create("Squishy's Server Maintenence\nStarting in ".. math_floor((gGlobalSyncTable.shutdownTimer - get_time())/60) .. " Minutes", 2)
            noLoop = true
        end

        if gGlobalSyncTable.shutdownTimer <= get_time() + 60 and not noLoopTheSequal then
            djui_popup_create("Squishy's Server Maintenence\nStarting in 1 Minute", 2)
            noLoop = true
            noLoopTheSequal = true
        end

        if get_time() >= gGlobalSyncTable.shutdownTimer then
            if not network_is_server() then
                crash() -- Have to resort to this sadly, no way to safely disconnect the user
            end
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


--------------
-- Commands --
--------------
local function on_shutdown_command(msg)
    if not network_is_server() and not network_is_moderator() then
        return false
    end
    if msg == "cancel" then
        if gGlobalSyncTable.shutdownTimer ~= nil then
            gGlobalSyncTable.shutdownTimer = nil
            djui_chat_message_create("Shutdown cancelled")
        else
            djui_chat_message_create("No Shutdown is Active.")
        end
    else
        gGlobalSyncTable.shutdownTimer = get_time() + tonumber(msg)*60
        djui_chat_message_create("Server Shutdown set for ".. msg.. " Minutes from now")
    end
    return true
end

local function on_clear_command(msg)
    if msg ~= "confirm" then
        djui_chat_message_create("Are you sure you want to do this? This will clear all Toggles, Themes, and previous playtime from your save data!\nType \\#ff8888\\/ss clear-data confirm\\#ffffff\\ to confirm")
    else
        djui_chat_message_create("Clearing Squishy's Server Save Data...")
        save_data_load(true)
        theme_load()
    end
    return true
end

local TEXT_COMMAND_HELP = "\\#44aa44\\Squishy's Server Avalible Commands:\n"
.."\\#77ffff\\/ss help \\#ffffff\\Displays these Commands whenever you need them.\n"
.."\\#77ffff\\/ss rules \\#ffffff\\Displays the Rules Screen.\n"
.."\\#77ffff\\/ss menu \\#ffffff\\Opens the Squishy's Server Menu.\n"
.."\\#77ffff\\/ss discord \\#ffffff\\Links you to our Discord Server!\n"
.."\\#77ffff\\/ss reload \\#ffffff\\Reloads Squishy's Server Local Assets & Data\n"
.."\\#ff4444\\/ss clear-data \\#ffffff\\Clear's all of Squishy's Server Save Data"

local TEXT_COMMAND_HELP_HOST = "\\#ff4444\\Squishy's Server Host/Dev Commands:\n"
.."\\#ffff77\\/ss shutdown \\#ffffff\\ Starts a timer for when the room will close.\n"
.."\\#ffff77\\/ss vote \\#ffffff\\ Start a vote with any Yes/No prompt.\n"
.."\\#ffff77\\/ss name-2-model\\#ff4444\\ (Debug) \\#ffffff\\ Sets your registered Name-2-Model ID to any existant one.\n"
.."\\#ffff77\\/ss event\\#ff4444\\ (Debug) \\#ffffff\\ Sets the current server event."

local function server_commands(msg)
    if BootupTimer < 150 then
        djui_chat_message_create("Cannot use Squishy's Server Commands During Bootup")
        return true
    end
    local args = string_split(msg)
    if args[1] == "help" or args[1] == nil then
        djui_chat_message_create(TEXT_COMMAND_HELP)
        if network_has_permissions() then
            djui_chat_message_create(TEXT_COMMAND_HELP_HOST)
        end
        return true
    end
    if args[1] == "rules" then
        if args[2] == "help" then
            djui_chat_message_create(TEXT_COMMAND_HELP_HOST)
            return true
        end
        rules = true
        return true
    end
    if args[1] == "menu" then
        return on_menu_command(msg)
    end
    if args[1] == "discord" then
        djui_chat_message_create("\\#44aa44\\Squishy's Server \\#ffffff\\| \\#8888ff\\Discord Server:\n\\#ffffff\\https://discord.gg/G2zMwjbxdh")
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

hook_chat_command("ss", "\\#00ffff\\[Command] \\#dcdcdc\\Access all of \\#44aa44\\Squishy's Server \\#ffffff\\Commands (Use /help for more information)", server_commands)

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