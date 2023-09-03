-- Compilation Info
-- Website: https://www.luac.nl/simple/
-- Encrypt Version: Lua 5.3.5
-- Ensure that you compile with and without 64-bit for a-roles and a-roles-32

-- 1 = Creator
-- 2 = Developer
-- 3 = Verified Host
-- 4 = Contributer
-- 5 = Moderator

-- 0 = Default User
-- -1 = Unverified Host

-- optimization
local network_is_server = network_is_server
local network_is_moderator = network_is_moderator

local rolestringTable = {
    [1] = function (index)
        return "\\#00aa00\\[Creator]"
    end,
    [2] = function (index)
        return "\\#FF2400\\[Developer]"
    end,
    [3] = function (index)
        if gPlayerSyncTable[index].ishost then
            return "\\#7FFFD4\\[Verified Host]"
        else
            return "\\#f23064\\[Bestie]"
        end
    end,
    [4] = function (index)
        return "\\#0568e3\\[Contributor]"
    end,
    [5] = function (index)
        return "\\#fcef42\\[Moderator]"
    end,

    [-1] = function (index)
        return "\\#ff0000\\[Unverified Host]"
    end,
}

local roleIDtable = {
    --Creator
    [678794043018182675] = "1", --Squishy

    --Developer
    [635629441678180362] = "2", --Plussle
    [542676894244536350] = "2", --Floralys
    [817821798363955251] = "2", --Crispy

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
    [827596624590012457] = "3", --Trashcam
    [443963592220344320] = "3", --Charity
    [732244024567529503] = "3", --PeachyPeach
    [489114867215630336] = "3", --Skeltan
    [1134242746832523414] = "3", --KanHeaven
    --Epic Gamer Squad (Verified Host)
    [397219199375769620] = "3", --Average
    [1092073683377455215] ="3", --Nut
    --sm64ex-coop-dx (Verified Host)
    [541396312608866305] = "3", --Mocha
    [164574042479656962] = "3", --Chilly
    [837686580965015613] = "3", --Garlicker

    --Contributer
    [409438020870078486] = "4", --EmilyEmmi (The entire Roles System)
    [376426041788465173] = "4", --Sunk (A bunch of QOL mods)
}

function reset_roles()
    gPlayerSyncTable[0].role = nil
    gPlayerSyncTable[0].ishost = nil
    gPlayerSyncTable[0].ismod = nil
    rolestring = ""
    update_roles()
end

function update_roles()
    local ID = tonumber(network_discord_id_from_local_index(0))
    local sMario = gPlayerSyncTable[0]

    sMario.role = roleIDtable[ID]
    if network_is_server() and sMario.role == nil then
        sMario.role = "-1"
    end
    if network_is_server() then
        sMario.ishost = true
    end
    if network_is_moderator() then
        sMario.ismod = true
    end
end

function network_is_squishy()
    if tonumber(network_discord_id_from_local_index(0)) == 678794043018182675 then
        return true
    else
        return false
    end
end

function network_is_developer()
    if network_discord_id_from_local_index(0) == "0" then
        return false
    end
    local args = split(roleIDtable[tonumber(network_discord_id_from_local_index(0))])
    if tonumber(args[1]) <= 2 and tonumber(args[1]) >= 1 then
        return true
    else
        return false
    end
end

function network_is_bestie()
    if network_discord_id_from_local_index(0) == "0" then
        return false
    end
    local args = split(roleIDtable[tonumber(network_discord_id_from_local_index(0))])
    if tonumber(args[1]) <= 3 and tonumber(args[1]) >= 1 then
        return true
    else
        return false
    end
end

local rolestring = ""

function on_chat_message(m, msg)
    local sMario = gPlayerSyncTable[m.playerIndex]
    local np = gNetworkPlayers[m.playerIndex]
    local playerColor = network_get_player_text_color_string(m.playerIndex)
    local name = playerColor .. np.name

    if sMario.role ~= nil then
        local args = split(sMario.role)
        if tonumber(args[1]) > 3 and tonumber(args[1]) < 0 then
            sMario.role = "-1"
        end
        if sMario.ismod then
            args[#args + 1] = "5"
        end

        rolestring = ""
        for i = 1, #args do
            rolestring = rolestring .. " " .. rolestringTable[tonumber(args[i])](m.playerIndex)
        end

        if _G.mhExists and _G.mhApi.get_tag(m.playerIndex) ~= nil then
            rolestring = rolestring .. " \\#dcdcdc\\| \\#00ffff\\M\\#ff5a5a\\H " .. _G.mhApi.get_tag(m.playerIndex)
        end

        if _G.lcExists and _G.lcInGame and _G.lcApi.get_ranks() ~= nil then
            rolestring = rolestring .. " \\#dcdcdc\\| \\#007700\\[LC] " .. _G.lcApi.get_ranks()
        end

        if rolestring ~= "" then
            djui_chat_message_create(name .. "" .. rolestring .. ": \\#dcdcdc\\" .. msg)
        end

        if m.playerIndex == 0 then
            play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
        else
            play_sound(SOUND_MENU_MESSAGE_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        end
        return false
    else
        return true
    end
end

function roles_get_tag(localIndex)
    local rolestring = ""
    if gPlayerSyncTable[localIndex].role ~= nil then
        local args = split(gPlayerSyncTable[localIndex].role)
        if tonumber(args[1]) > 3 and tonumber(args[1]) < 0 then
            gPlayerSyncTable[localIndex].role = "-1"
        end
        if gPlayerSyncTable[localIndex].ismod then
            args[#args + 1] = "5"
        end

        rolestring = ""
        for i = 1, #args do
            rolestring = rolestring .. " " .. rolestringTable[tonumber(args[i])](gMarioStates[i].playerIndex)
        end
    end
    return rolestring
end

hook_event(HOOK_UPDATE, update_roles)
-- here, we only hook the function if MarioHunt does not exist
if _G.mhExists then
    _G.mhApi.chatValidFunction = on_chat_message -- don't worry, it will still run
else
    hook_event(HOOK_ON_CHAT_MESSAGE, on_chat_message)
end
hook_event(HOOK_JOINED_GAME, reset_roles)
hook_event(HOOK_ON_PLAYER_DISCONNECTED, reset_roles)