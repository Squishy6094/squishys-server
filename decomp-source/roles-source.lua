local ID = tonumber(network_discord_id_from_local_index(0))

-- 1 = Creator
-- 2 = Developer
-- 3 = Verified Host
-- 4 = Contributer
-- 5 = Moderator

-- 0 = Default User
-- -1 = Unverified Host

roleIDtable = {
    --Creator
    [678794043018182675] = "1", --Squishy

    --Developer
    [635629441678180362] = "2", --Plussle

    --Gm_Boo3volved (Verified Host)
    [401406794649436161] = "3",  --Uoker
    [673582558507827221] = '3',  --Elby
    [664638362484867121] = "3",  --Kitkat
    [397847847283720193] = "3",  --Koffee
    --Skedar (Verified Host)
    [490613035237507091] = "3 4",--Agent X (Tons of help overall with coding)
    [376304957168812032] = "3",  --eros71
    [282702284608110593] = "3",  --0x
    [767513529036832799] = "3",  --Cosmic
    [542676894244536350] = "3",  --Floralys
    [827596624590012457] = "3", --Trashcam
    [443963592220344320] = "3", --Charity
    [732244024567529503] = "3", --PeachyPeach
    --Epic Gamer Squad (Verified Host)
    [397219199375769620] = "3", --Average
    [817821798363955251] = "3", --Crispy
    [1092073683377455215] ="3", --Nut

    --Contributer
    [409438020870078486] = "4", --EmilyEmmi (The entire Roles System)
    [376426041788465173] = "4", --Sunk (A bunch of QOL mods)
}

function update_roles()
    local m = gMarioStates[0]
    local sMario = gPlayerSyncTable[0]

    if ID ~= 0 then
        if roleIDtable[ID] ~= nil then
            sMario.role = roleIDtable[ID]
        else
            if network_is_server() then
                sMario.role = "-1"
            end
        end
        if network_is_server() then
            sMario.ishost = true
        end
        if network_is_moderator() then
            sMario.ismod = true
        end
    else
        sMario.role = "0"
        if network_is_server() then
            sMario.role = "-1"
        end
    end
end

function on_chat_message(m, msg)
    local sMario = gPlayerSyncTable[m.playerIndex]
    local np = gNetworkPlayers[m.playerIndex]
    local playerColor = network_get_player_text_color_string(m.playerIndex)
    local name = playerColor .. np.name

    if sMario.role ~= nil then
        rolestring = ""
        local args = split(sMario.role)
        for i = 1, 6 do
            if tonumber(args[i]) == 1 then
                rolestring = rolestring.." \\#00aa00\\[Creator]"
            end 
            if tonumber(args[i]) == 2 then
                rolestring = rolestring.." \\#FF2400\\[Developer]"
            end
            if tonumber(args[i]) == 3 then
                if sMario.ishost then
                    rolestring = rolestring.." \\#7FFFD4\\[Verified Host]"
                else
                    rolestring = rolestring.." \\#f23064\\[Bestie]"
                end
            end 
            if tonumber(args[i]) == 4 then
                rolestring = rolestring.." \\#0568e3\\[Contributor]"
            end 
        end
        if sMario.ismod then
            rolestring = rolestring.." \\#fcef42\\[Moderator]"
        end
        if sMario.role == "-1" then
            rolestring = " \\#ff0000\\[Unverified Host]"
        end 
        if rolestring ~= "0" then
            djui_chat_message_create(name..""..rolestring..": \\#dcdcdc\\"..msg)
        end

        if m.playerIndex == 0 then
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        else
            local myM = gMarioStates[0]
            play_sound(SOUND_MENU_MESSAGE_APPEAR, myM.marioObj.header.gfx.cameraToObject)
        end
        return false
    else
        sMario.role = "0"
    end
end
hook_event(HOOK_ON_SYNC_VALID, update_roles)
hook_event(HOOK_ON_CHAT_MESSAGE, on_chat_message)
