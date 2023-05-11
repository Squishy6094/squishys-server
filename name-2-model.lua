--- @param m MarioState
function mario_update(m)
    if discordID == "0" then return end
    if modelTable[discordID][menuTable[3][2].status].icon ~= nil then
        if modelTable[discordID][menuTable[3][2].status].icon == "Default" then
            lifeIcon = m.character.hudHeadTexture
        else
            lifeIcon = modelTable[discordID][menuTable[3][2].status].icon
        end
    else
        lifeIcon = get_texture_info("icon-nil")
    end
    if maxModelNum == nil then
        maxModelNum = modelTable[discordID].maxNum
        mod_storage_save(menuTable[3][2].nameSave, "0")
    end

    if menuTable[3][3].status == 0 or discordID == "0" then return end
    if m.playerIndex == 0 then
        if discordID ~= "0" or discordID ~= "678794043018182675" or discordID ~= nil then
            gPlayerSyncTable[0].modelId = modelTable[discordID][menuTable[3][2].status].model
            if modelTable[discordID][menuTable[3][2].status].forcePlayer ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= nil then
                gNetworkPlayers[m.playerIndex].overrideModelIndex = modelTable[discordID][menuTable[3][2].status].forcePlayer
            end
        else
            gPlayerSyncTable[0].modelId = nil
        end
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

--- @param m MarioState
function on_player_connected(m)
    gPlayerSyncTable[m.playerIndex].modelId = nil
end

function set_discord_id(msg)
    if modelTable[msg] ~= nil then
        discordID = msg
        djui_chat_message_create("Valid ID Entered!")
    else
        djui_chat_message_create("Invalid ID Entered")
    end
    return true
end

if network_is_server() then
    hook_chat_command("discordID", "[ID] Set the local discordID to any ID for Debugging", set_discord_id)
end

hook_event(HOOK_MARIO_UPDATE, mario_update)