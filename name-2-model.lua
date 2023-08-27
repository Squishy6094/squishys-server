menuErrorMsg = "Error not found"

if discordID == "0" then
    menuErrorMsg = "Discord not Detected"
end
if modelTable[discordID] == nil then
    if menuErrorMsg == "Error not found" then
        menuErrorMsg = "No Models Found"
    end
    discordID = "0"
    menuTable[3][1].status = 0
    print("Sign-in Failed, No Models Found")
elseif discordID ~= "0" then
    print("Signed into Name-2-Model as ".. modelTable[discordID].nickname)
end

if modelTable[discordID][0] == nil then
    modelTable[discordID][0] = {
        model = nil,
        modelName = "Default",
        icon = "Default"
    }
end

for i = 0, #modelTable[discordID] do
    menuTable[3][1].statusNames[i] = modelTable[discordID][i].modelName
end
menuTable[3][1].statusMax = #modelTable[discordID]

if menuTable[3][1].status == nil then
    menuTable[3][1].status = 0
end

local stallScriptTimer = 3
--- @param m MarioState
function mario_update(m)
    if stallScriptTimer > 0 then stallScriptTimer = stallScriptTimer - 1 return end
    if modelTable[discordID][menuTable[3][1].status].icon ~= nil then
        lifeIcon = modelTable[discordID][menuTable[3][1].status].icon
    else
        lifeIcon = 0
    end
    if maxModelNum == nil then
        maxModelNum = #modelTable[discordID]
    end

    if menuTable[3][2].status == 0 then return end
    if m.playerIndex == 0 then
        if discordID ~= "0" then
            gPlayerSyncTable[0].modelId = modelTable[discordID][menuTable[3][1].status].model
            if modelTable[discordID][menuTable[3][1].status].forcePlayer ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= nil then
                gNetworkPlayers[m.playerIndex].overrideModelIndex = modelTable[discordID][menuTable[3][1].status].forcePlayer
            end
        else
            gPlayerSyncTable[0].modelId = nil
            if menuTable[3][1].status ~= 0 then
                menuTable[3][1].status = 0
            end
        end
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

function set_model(o, id)
    if id == E_MODEL_MARIO and menuTable[3][2].status ~= 0 then
        local i = network_local_index_from_global(o.globalPlayerIndex)
        if gPlayerSyncTable[i].modelId ~= nil then
            obj_set_model_extended(o, gPlayerSyncTable[i].modelId)
        end
    end
end

function set_discord_id(msg)
    if not network_is_server() and not network_is_moderator() then
        return false
    end
    if modelTable[msg] ~= nil then
        discordID = msg
        if modelTable[discordID][0] == nil then
            modelTable[discordID][0] = {
                model = nil,
                modelName = "Default",
                icon = "Default"
            }
        end
        for i = 0, #modelTable[discordID] do
            menuTable[3][1].statusNames[i] = modelTable[discordID][i].modelName
        end
        menuTable[3][1].statusMax = #modelTable[discordID]
        menuTable[3][1].status = 1
        maxModelNum = #modelTable[discordID]
        djui_chat_message_create('ID set to "'.. modelTable[msg].nickname ..'" ('.. msg ..') Successfully!')
    else
        djui_chat_message_create("Invalid ID Entered")
    end
    return true
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_OBJECT_SET_MODEL, set_model)