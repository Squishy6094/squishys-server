-- name: -Squishy's Server-
-- description: \\#008800\\~~~~~Squishy's Server Stuff~~~~~\n\n\\#dddddd\\Displays rules/welcome message to anyone who connects to your Squishy's Servers, Along with some quality of life features!\n\n\\#ff8800\\Do not host with this mod publicly, You could get in trouble as it's an unreleased mod you didn't make.\n\n\\#008800\\~~~~~~~~~~~~~~~~~~~~~~~~

local offsetX = -200
local showRules = true
local opacity = 255
local msgtimer = -3000
local lastpopupNum = 0
print("Connected to Server")

function displayrules(m)
    if showRules and offsetX < -1 then
        offsetX = offsetX/1.1
    end

    if not showRules and offsetX > -200 then
        offsetX = offsetX*1.2
    end

    if offsetX <= -200 and not showRules then return end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(0, 0, 0, 200)
    djui_hud_render_rect(0 + offsetX, 0, 195, djui_hud_get_screen_height())
    djui_hud_render_rect(3 + offsetX, 2, 190, djui_hud_get_screen_height() - 4)

    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_color(255, 255, 255, 50)
    if discordID ~= nil and discordID ~= "0" then
        djui_hud_print_text("Name-2-Model ID: ".. discordID, 190 - (djui_hud_measure_text("Name-2-Model ID: ".. discordID)*0.2) + offsetX, 5, 0.2)
    else
        djui_hud_print_text("Name-2-Model ID Not Found", 190 - (djui_hud_measure_text("Name-2-Model ID Not Found")*0.2) + offsetX, 5, 0.2)
    end

    if RoomTime ~= nil then
        djui_hud_print_text("Room Time: ".. RoomTime, 190 - (djui_hud_measure_text("Room Time: 00:00:00")*0.2) + offsetX, 11, 0.2)
    end

    if network_is_server() or network_is_moderator() then
        djui_hud_print_text("Moderator Access Granted", 190 - (djui_hud_measure_text("Moderator Access Granted")*0.2) + offsetX, 17, 0.2)
    end

    djui_hud_set_font(FONT_MENU)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("Welcome to", 12 + offsetX, 7, 0.25)
    djui_hud_set_color(0, 155, 0, 255)
    djui_hud_print_text("Squishys Server", 10 + offsetX, 20, 0.3)
    djui_hud_print_text("'", 68 + offsetX, 20, 0.3)

    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("Rules", 15 + offsetX, 50, 0.6)
    djui_hud_set_color(255, 255, 255, 255)
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
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_rect(15 + offsetX, 116, (djui_hud_measure_text("Basic Info and Tips")*0.6), 1)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("Check your Server Options via", 20 + offsetX, 120, 0.3)
    djui_hud_print_text("Pausing and Pressing the L button", 20 + offsetX, 127, 0.3)
    djui_hud_print_text("To avoid lag and clutter, some mods", 20 + offsetX, 137, 0.3)
    djui_hud_print_text('are built into into "-Squishy'.."'"..'s Server-"', 20 + offsetX, 144, 0.3)
    djui_hud_set_color(150, 150, 150, 255)
    djui_hud_print_text('All Credits are in "unlisted-mods-list.md"', 20 + offsetX, 152, 0.25)

    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("Support and Contribution", 15 + offsetX, 165, 0.6)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_render_rect(15 + offsetX, 176, (djui_hud_measure_text("Support and Contribution")*0.6), 1)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("If you have any questions about the server", 20 + offsetX, 181, 0.3)
    djui_hud_print_text("and/or the mods loaded, Feel free to ask!", 20 + offsetX, 188, 0.3)
    djui_hud_print_text('If you have any "Quality of life" Mods that', 20 + offsetX, 198, 0.3)
    djui_hud_print_text('you would like to see when I host, Go ahead and', 20 + offsetX, 205, 0.3)
    djui_hud_print_text('ask or send me the mod directly on Discord', 20 + offsetX, 212, 0.3)

    if msgtimer >= 0 then
        if opacity >= -1 then
            opacity = opacity/1.05
        end
        djui_hud_set_font(FONT_MENU)
        djui_hud_set_color(255, 255, 255, 255 - opacity)
        djui_hud_print_text("Press A to continue", 100 + offsetX - (djui_hud_measure_text("Press A to continue")/2*0.2), djui_hud_get_screen_height() - 17, 0.2)
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
        text = '\nHate all the HUD clutter? You can toggle off Extra Hud Elements\nin the "Server Options" Menu,\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 5
    },
    [5] = {
        text = '\nThese messages pop-up every 4-6 minutes, You can turn them off\nin the "Server Options" Menu\n\n\\#8c8c8c\\This can be accessed by\nPressing L on the Pause Menu!',
        lines = 5
    },
    [6] = {
        text = 'This game is brought to you by\nThe QOL Mod Creators on the\nsm64ex-coop Discord Server!',
        lines = 3
    },
    [7] = {
        text = "Remember to tip your hosts folks,\nThey won't get their pay\nany other way!",
        lines = 3
    },
    [8] = {
        text = "If you get knocked back, you can\npress Z when you hit the ground to\nTech and get right back up!",
        lines = 3
    },
    [9] = {
        text = "You can get though a door\nquicker if you kick it down!",
        lines = 2
    },
}

function mario_update_msgtimer(m)
    if msgtimer == -3000 then
        if network_is_server() then
            if discordID == "678794043018182675" then
                djui_popup_create("You are now hosting\n\\#005500\\Squishy's Server\\#dcdcdc\\,\nCheck your mods list and\nsend an Invite!",4)
            else
                djui_popup_create("\n\\#990000\\Error: Discord ID Mismatch\n\\#dcdcdc\\You are hosting via Discord without being Squishy, Don't host publicly\nwith this mod on!\n\n\\#8c8c8c\\(This error will not effect the performence of Squishy's Server\nor sm64ex-coop)",8)
            end
        else
            djui_popup_create("Thanks For Joining\n\\#005500\\Squishy's Server\\#dcdcdc\\,\nEnjoy your Stay!",3)
        end
        popupNum = math.random(1,9)
    end

    msgtimer = msgtimer + 1

    if msgtimer >= math.random(720,10800) and notif then
        msgtimer = 0
        popupNum = math.random(1,9)
        if lastpopupNum == popupNum then
            popupNum = math.random(1,9)
        end
        lastpopupNum = popupNum
        djui_popup_create(popupTable[popupNum].text, popupTable[popupNum].lines)
    end

    if showRules then
        m.pos.y = m.floorHeight
        m.action = ACT_READING_NPC_DIALOG
        if msgtimer >= 0 and m.controller.buttonDown & A_BUTTON ~= 0 then
            showRules = false
        end
    end
    
end

--Manual Pop-ups--
for i = 0, MAX_PLAYERS - 1, 1 do
    gPlayerSyncTable[i].showMSG = false
    gPlayerSyncTable[i].msg = ""
end

function chat_command(msg)
    if msg ~= nil then
        for i = 0, MAX_PLAYERS - 1, 1 do
            gPlayerSyncTable[i].showMSG = true
            gPlayerSyncTable[i].msg = msg
        end
        return true
    end
    return false
end

function update()
    local m = gMarioStates[0]
    if gPlayerSyncTable[m.playerIndex].showMSG then
        djui_popup_create(gPlayerSyncTable[m.playerIndex].msg, 4)
        gPlayerSyncTable[m.playerIndex].showMSG = false
    end
end

hook_event(HOOK_ON_HUD_RENDER, displayrules)
if network_is_server() or network_is_moderator() then
    hook_chat_command('servermsg', "Type a message to send as a popup to everyone.", chat_command)
end
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_MARIO_UPDATE, mario_update_msgtimer)