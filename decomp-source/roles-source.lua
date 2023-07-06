local ID = tonumber(network_discord_id_from_local_index(0))

function update_roles()
    local m = gMarioStates[0]
    local sMario = gPlayerSyncTable[0]

    if ID ~= 0 then
        -- 1 = Creator
        -- 2 = Developer
        -- 3 = Verified Host
        -- 4 = Bestie (Verified but not hosting)
        -- 5 = Contributer
        -- 6 = Moderator
        -- -1 = Unverified --
        roleIDtable = {
            [678794043018182675] = "1", --Squishy
        
            [635629441678180362] = "2", --Plussle
        
            --Gm_Boo3volved
            [401406794649436161] = "3", --Uoker
            [673582558507827221] = '3',  --Elby
            [664638362484867121] = "3",  --Kitkat
            [397847847283720193] = "3",  --Koffee
            --Skedar
            [490613035237507091] = "3 5",  --Agent X (Tons of help overall with coding)
            [376304957168812032] = "3",  --eros71
            [282702284608110593] = "3",  --0x
            [767513529036832799] = "3",  --Cosmic
            [542676894244536350] = "3",  --Floralys
            [827596624590012457] = "3", --Trashcam
            [443963592220344320] = "3", --Charity
            [732244024567529503] = "3", --PeachyPeach
            --Epic Gamer Squad
            [397219199375769620] = "3", --Average
            [817821798363955251] = "3", --Crispy
            [1092073683377455215] ="3", --Nut

            [409438020870078486] = "5", --EmilyEmmi (The entire Roles System)
            [376426041788465173] = "5", --Sunk (A bunch of QOL mods)
        }
        if roleIDtable[ID] ~= nil then
            sMario.role = roleIDtable[ID]
        else
            if network_is_server() then
                sMario.role = "-1"
            end
        end
        local args = split(sMario.role)
        for i = 1, 5 do
            if args[i] == "3" and not network_is_server() then
                args[i] = "4"
                sMario.role = args[1].." "..args[2].." "..args[3].." "..args[4].." "..args[5].." "..args[6]
            end
            if network_is_moderator() and args[i] == nil then
                args[i] = "6"
                sMario.role = args[1].." "..args[2].." "..args[3].." "..args[4].." "..args[5].." "..args[6]
            end
        end
    else
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
        for i = 1, 5 do
            if args[i] == "1" then
                rolestring = rolestring.." \\#00aa00\\[Creator]"
            end 
            if args[i] == "2" then
                rolestring = rolestring.." \\#9F2B68\\[Developer]"
            end 
            if args[i] == "3" then
                rolestring = rolestring.." \\##FFD700\\[Verified Host]"
            end 
            if args[i] == "4" then
                rolestring = rolestring.." \\##FFC0CB\\[Bestie]"
            end 
            if args[i] == "5" then
                rolestring = rolestring.." \\#1560bd\\[Contrubuter]"
            end 
            if args[i] == "6" then
                rolestring = rolestring.." \\#F1EB9C\\[Moderator]"
            end
        end
        if sMario.role == "-1" then
            rolestring = " \\#ff0000\\[Unverified Host]"
        end 
        if rolestring ~= "" then
            djui_chat_message_create(name..""..rolestring..": \\#dcdcdc\\"..msg)
        end

        if m.playerIndex == 0 then
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        else
            local myM = gMarioStates[0]
            play_sound(SOUND_MENU_MESSAGE_APPEAR, myM.marioObj.header.gfx.cameraToObject)
        end
        return false
    end
end
hook_event(HOOK_ON_SYNC_VALID, update_roles)
hook_event(HOOK_ON_CHAT_MESSAGE, on_chat_message)
