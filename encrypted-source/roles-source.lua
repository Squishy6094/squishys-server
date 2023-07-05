local Creator = 1
local Developer = 2
local VerifiedHost = 3

local ID = network_discord_id_from_local_index(0)

roleIDtable = {
    [Creator] = {
        [1] = "678794043018182675"
    },
    [Developer] = {
        [1] = "635629441678180362"
    },
    [VerifiedHost] = {
        [1] = "401406794649436161"
    }
}

function on_chat_message(m, msg)
    local np = gNetworkPlayers[m.playerIndex]
    local playerColor = network_get_player_text_color_string(m.playerIndex)
    local name = playerColor .. np.name

    local rolestring = ""
    if ID == roleIDtable[Creator][1] then
        rolestring = "[Creator]"
    end 
    for i = 1, #roleIDtable[Developer] do
        if ID == roleIDtable[Developer][i] then
            rolestring = "[Developer]"
        end
    end
    for i = 1, #roleIDtable[VerifiedHost] do
        if ID == roleIDtable[VerifiedHost][i] then
            rolestring = "[Verified Host]"
        end
    end
    if rolestring == "" and network_is_server() then
        rolestring = "[Unverified Host]"
    end
    if rolestring ~= "" then
        djui_chat_message_create(name.." "..rolestring..": \\#dcdcdc\\"..msg)
    end

    if m.playerIndex == 0 then
        play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
    else
        local myM = gMarioStates[0]
        play_sound(SOUND_MENU_MESSAGE_APPEAR, myM.marioObj.header.gfx.cameraToObject)
    end
    return false
end
hook_event(HOOK_ON_CHAT_MESSAGE, on_chat_message)