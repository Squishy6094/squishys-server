-- name: -Squishy's Server-
-- description: \\#005500\\~~~~~Squishy's Server Stuff~~~~~\n\n\\#dddddd\\Displays rules/welcome message to anyone who connects to your Squishy's Servers, Along with some quality of life features!\n\n\\#ff8800\\Warning: If you pulled this from your tmp folder in attempts to host with it,\n\\#ff0000\\Do Not. \\#ff8800\\You could get in serious trouble as it's an unreleased mod you didn't make.\n\n\\#005500\\~~~~~~~~~~~~~~~~~~~~~~~~

-- false: Window won't close when mouse hovers over the OK button, only Buttons work
-- true: Window will close when mouse hovers over the OK button, alternatively buttons work too
CLOSE_ON_MOUSE_HOVER = true

-- text-related options
-- sets font, scale (of text) and color for all texts;
globalFont = FONT_NORMAL
scale = 1.4
color = "#FFFFFF"

local switched = true
local hasConfirmed = false
function displayrules(m)
    hostnum = network_local_index_from_global(0)
    host = gNetworkPlayers[hostnum]

    -- texts are written inside here.
    --[[ format: 
    {
        string, 
        x, 
        y, 
        font, 
        scale, 
        color (color in "#xxxxxx" format pls)
    }
--]]
    texts = {
        {
            "Welcome to",
            -520,
            -300,
            FONT_MENU,
            1,
            color
        },
        {
            "Squishy 6094's",
            -520,
            -250,
            FONT_MENU,
            1.1,
            "#008800"
        },
        {
            "Server",
            -540,
            -200,
            FONT_MENU,
            1,
            color
        },
        {
            "RULES",
            -500,
            25,
            FONT_HUD,
            2.5,
            color
        },
        {
            "________________________________________",
            -500,
            -25,
            globalFont,
            1,
            color
        },
        {
            "#1 Don't Harass Other Users",
            -500,
            10,
            globalFont,
            1,
            color
        },
        {
            "#2 Don't Spam/Beg for Something",
            -500,
            50,
            globalFont,
            1,
            color
        },
        {
            "#3 Follow the same Rules you would",
            -500,
            90,
            globalFont,
            1,
            color
        },
        {
            "in the sm64ex-coop discord server",
            -500,
            118,
            globalFont,
            1,
            color
        },
        {
            "BASIC INFO",
            0,
            0,
            FONT_HUD,
            2.5,
            color
        },
        {
            "AND TIPS",
            0,
            50,
            FONT_HUD,
            2.5,
            color
        },
        {
            "________________________________________",
            0,
            -25,
            globalFont,
            1,
            color
        },
        {
            "Check the mods list to see what we add and",
            0,
            10,
            globalFont,
            1,
            color
        },
        {
            "use '/help' for a list of commands avalible",
            0,
            38,
            globalFont,
            1,
            color
        },
        {
            "To avoid lag and clutter, some mods are built",
            0,
            90,
            globalFont,
            1,
            color
        },
        {
            "into '-Squishy's Server-' And a listed below",
            0,
            118,
            globalFont,
            1,
            color
        },
        {
            "UNLISTED MODS",
            0,
            210,
            FONT_HUD,
            1.8,
            color
        },
        {
            "___________________________________",
            0,
            170,
            globalFont,
            1,
            color
        },
        {
            "Collectables Radar",
            -150,
            190,
            globalFont,
            0.8,
            color
        },
        {
            "Star Heal",
            0,
            190,
            globalFont,
            0.8,
            color
        },
        {
            "60 Degree Wallkicks",
            150,
            210,
            globalFont,
            0.8,
            color
        },
        {
            "Door Bust",
            0,
            210,
            globalFont,
            0.8,
            color
        },
        {
            "Teching V2",
            -150,
            230,
            globalFont,
            0.8,
            color
        },
        {
            "Spam Burnout",
            -150,
            210,
            globalFont,
            0.8,
            color
        },
        {
            "Preview Blue Coins",
            0,
            230,
            globalFont,
            0.8,
            color
        },
        {
            "Disable PUs",
            150,
            230,
            globalFont,
            0.8,
            color
        },
        {
            "Remove SSC",
            -150,
            250,
            globalFont,
            0.8,
            color
        },
        {
            "Game Over Savior",
            0,
            250,
            globalFont,
            0.8,
            color
        },
        {
            "Wall Slide",
            150,
            250,
            globalFont,
            0.8,
            color
        },
        {
            "Downing",
            -150,
            270,
            globalFont,
            0.8,
            color
        },
        {
            "Anti Quicksand",
            0,
            270,
            globalFont,
            0.8,
            color
        },
        {
            "Instant Slope Jump",
            150,
            270,
            globalFont,
            0.8,
            color
        },
        {
            "Swim Star Anim",
            -150,
            290,
            globalFont,
            0.8,
            color
        },
        {
            "Lava Groundpound",
            0,
            290,
            globalFont,
            0.8,
            color
        },
        {
            "Fixed Bubbling",
            150,
            290,
            globalFont,
            0.8,
            color
        },
        {
            "Wing Cap Timer",
            0,
            310,
            globalFont,
            0.8,
            color
        },
        {
            "SUPPORT AND",
            500,
            0,
            FONT_HUD,
            2.5,
            color
        },
        {
            "CONTRIBUTION",
            500,
            50,
            FONT_HUD,
            2.5,
            color
        },
        {
            "________________________________________",
            500,
            -25,
            globalFont,
            1,
            color
        },
        {
            "If you have any questions about the server ",
            500,
            10,
            globalFont,
            1,
            color
        },
        {
            "and/or the mods loaded, Feel free to ask!",
            500,
            38,
            globalFont,
            1,
            color
        },
        {
            "If you have any 'Quality of life' Mods that",
            500,
            90,
            globalFont,
            1,
            color
        },
        {
            "you would like to see when I host, Go ahead and",
            500,
            118,
            globalFont,
            1,
            color
        },
        {
            "ask or send me the mod directly on Discord",
            500,
            146,
            globalFont,
            1,
            color
        },
        {
            "We also support player specific models!",
            500,
            202,
            globalFont,
            1,
            color
        },
        {
            "If you would like to play as a custom model",
            500,
            230,
            globalFont,
            1,
            color
        },
        {
            "Send me a charicter.bin and a linked username!",
            500,
            258,
            globalFont,
            1,
            color
        },
        {
            "Once you've read everything",
            0,
            -178,
            globalFont,
            scale,
            color
        },
        {
            "Hover your mouse over OK or press A",
            0,
            -150,
            globalFont,
            scale,
            color
        },
        {
            "By confirming you agree to the server rules, Breaking the rules will result in a kick or ban.",
            0,
            450,
            globalFont,
            0.7,
            color
        },
        {
            "OK",
            0,
            360,
            FONT_MENU,
            scale,
            "#008800"
        }
    }

    -----------------------------------------
    -- Main code:
    m = gMarioStates[0]
    if (switched == true) then
        if (hasConfirmed == false) then
            set_mario_action(m, ACT_READING_AUTOMATIC_DIALOG, 0)
        end
        -- render the rectangle.
        renderRect(190, 120, FONT_MENU, 5000, 5000, "#000000")

        -- print all texts
        for _, v in ipairs(texts) do
            printColorText(v[1], v[2], v[3], v[4], v[5], v[6])
        end

        -- get relative coordinates of OK text
        local xd = returnX("OK", scale, globalFont)
        local yd = returnY("OK", scale, globalFont) + 360

        -- get mouse_x and mouse_y coordinates
        local mousex = djui_hud_get_mouse_x()
        local mousey = djui_hud_get_mouse_y()

        -- calculate distance between button and mouse
        -- if player presses D_PAD Down or (if mouse_hover is activated) hovers over the OK text,
        -- the window closes.
        local dist = math.sqrt(((xd - mousex) ^ 2) + (((yd + 40) - mousey) ^ 2))
        if (CLOSE_ON_MOUSE_HOVER) then
            if (dist < 40) then
                switched = false
                play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
                if (hasConfirmed == false) then
                    set_mario_action(m, ACT_IDLE, 0)
                    hasConfirmed = true
                end
            end
        end

        if (m.controller.buttonPressed & A_BUTTON) ~= 0 then
            switched = false
            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
            if (hasConfirmed == false) then
                set_mario_action(m, ACT_IDLE, 0)
                hasConfirmed = true
            end
        end
    end
end

-- prints text in the center of the screen
function printColorText(text, x, y, font, scale, color)
    local r, g, b, a = 0, 0, 0, 0

    local rgbtable = checkColorFormat(color)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    -- get centre of screen
    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 255)
    djui_hud_print_text(text, xc + x, yc + y, scale)
end

-- returns X coordinate relative to text
function returnX(text, scale, font)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    -- get centre of screen
    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    return xc
end

-- returns Y coordinate relative to text
function returnY(text, scale, font)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(font)

    local screenWidth = djui_hud_get_screen_width()
    local width = (djui_hud_measure_text(text) / 2) * scale

    local screenHeight = djui_hud_get_screen_height()
    local height = 64 * scale

    -- get centre of screen
    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = halfwidth - width
    local yc = halfheight - height

    return yc
end

-- renders a rectangle in the center of the screen
function renderRect(x, y, font, w, h, color)
    local rgbtable = checkColorFormat(color)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    --djui_hud_set_font(font);

    local screenWidth = djui_hud_get_screen_width()
    local screenHeight = djui_hud_get_screen_height()

    -- get center
    local halfwidth = screenWidth / 2
    local halfheight = screenHeight / 2

    local xc = x + halfwidth
    local yc = y + halfheight

    local xx = xc - halfwidth
    local yy = yc - halfheight

    local xd = x + (screenWidth / 2)
    local yd = y + (screenHeight / 2)

    local xe = x + (w / 2)
    local ye = y + (h / 2)

    local fx = xd - xe
    local fy = yd - ye

    djui_hud_set_color(rgbtable.r, rgbtable.g, rgbtable.b, 170)
    djui_hud_render_rect(fx, fy, w, h)
end

function displayrules2()
    if (switched) then
        djui_chat_message_create("The window has already been opened. Please close it first.")
        return true
    end
    switched = true
    return true
end

function checkColorFormat(rgbhex)
    local r, g, b, a = 0, 0, 0, 0

    local d = string.find(color, "#")
    if ((d == 1) and (string.len(rgbhex) == 7)) then
        local colorhex = string.gsub(rgbhex, "#", "")
        r = string.sub(colorhex, 0, 2)
        g = string.sub(colorhex, 3, 4)
        b = string.sub(colorhex, 5, 6)

        r = tonumber(r, 16)
        g = tonumber(g, 16)
        b = tonumber(b, 16)
        return {r = r, g = g, b = b}
    else
        print("Color format is wrong.")
        return
    end
end

-----------------
--Message Timer--
-----------------

local msgtimer = -10
local lastpopupnum = 0
print("Connected to Server")

function mario_update_msgtimer(m)
    msgtimer = msgtimer + 1
    if msgtimer == -1 then
        if network_is_server() then
            djui_popup_create("You are now hosting\n\\#005500\\Squishy's Server\\#dddddd\\,\nCheck your mods list and\nsend an Invite!",4)
        else
            djui_popup_create("Thanks For Joining\n\\#005500\\Squishy's Server\\#dddddd\\,\nEnjoy your Stay!",3)
        end
        popupnum = math.random(1,11)
    end
    if msgtimer >= math.random(72000,1080000) and gPlayerSyncTable[m.playerIndex].notif == true then
        msgtimer = 0
        popupnum = math.random(1,11)
        if lastpopupnum == popupnum then
            popupnum = math.random(1,11)
        end
        lastpopupnum = popupnum
        if popupnum >= 1 and popupnum <= 3 then
            djui_popup_create("Thanks For Playing on\n\\#005500\\Squishy's Server\\#dddddd\\!",2)
        elseif popupnum == 4 then
            djui_popup_create('Custom Moves hindering your\ngameplay? You can turn them\noff under the Movesets tab\nin the Server Options!',4)
        elseif popupnum == 5 then
            djui_popup_create('This game is brought to you by \nThe QOL Mod Creators!',3)
        elseif popupnum == 6 then
            djui_popup_create('These messages pop-up every 4-6 minutes, You can turn them off\nin the Server Options',3)
        elseif popupnum == 7 then
            djui_popup_create("Remember to tip your hosts folks,\nThey won't get their pay\nany other way!",3)
        elseif popupnum == 8 then
            djui_popup_create("If you get knocked back, you can\npress Z when you hit the ground to\nTech and get right back up",3)
        elseif popupnum == 9 then
            djui_popup_create("Hate all the HUD clutter? You can toggle off Extra Hud Elements\nin the Server Options",3)
        elseif popupnum == 10 then
            djui_popup_create("Not seeing an added feature shown\nin the changelog? Delete your\nMod Cashe and Rejoin the Room!",3)
        elseif popupnum == 11 then
            djui_popup_create("You can get though a door\nquicker if you kick it down!",2)
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

hook_event(HOOK_MARIO_UPDATE, mario_update_msgtimer)
hook_event(HOOK_ON_HUD_RENDER, displayrules)
hook_chat_command("rules", "displays the rules of this server", displayrules2)
if network_is_server() or network_is_moderator() then
    hook_chat_command('servermsg', "Type a message to send as a popup to everyone.", chat_command)
end
hook_event(HOOK_UPDATE, update)