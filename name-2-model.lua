E_MODEL_WEEDCAT = smlua_model_util_get_id("cosmic_geo")
E_MODEL_SSTOAD = smlua_model_util_get_id("ss_toad_player_geo")
E_MODEL_TRASHCAM = smlua_model_util_get_id("trashcam_geo")
E_MODEL_WOOPER = smlua_model_util_get_id("woop_geo")
E_MODEL_FREEMAN = smlua_model_util_get_id("gordon_geo")
E_MODEL_BLOCKY = smlua_model_util_get_id("blocky_geo")
E_MODEL_YOSHI = smlua_model_util_get_id("yoshi_player_geo")
E_MODEL_NYA = smlua_model_util_get_id("nya_geo")
E_MODEL_CROC = smlua_model_util_get_id("croc_geo")
E_MODEL_NATSUKI = smlua_model_util_get_id("natsuki_geo")
E_MODEL_PROTOGEN = smlua_model_util_get_id("protogen_geo")
E_MODEL_HATKID = smlua_model_util_get_id("hat_kid_geo")

--- @param m MarioState
function mario_update(m)
    if (m.playerIndex == 0 or m.playerIndex ~= 0) and not modelToggle then return end
    if m.playerIndex == 0 then
        if network_discord_id_from_local_index(0) == "461771557531025409" --Spoomples
        or network_discord_id_from_local_index(0) == "901908732525559828" then --Nut
            gPlayerSyncTable[0].modelId = E_MODEL_SSTOAD

        elseif network_discord_id_from_local_index(0) == "767513529036832799" then --Cosmic
            gPlayerSyncTable[0].modelId = E_MODEL_WEEDCAT

        elseif network_discord_id_from_local_index(0) == "827596624590012457" then --Trashcam
            gPlayerSyncTable[0].modelId = E_MODEL_TRASHCAM

        elseif network_discord_id_from_local_index(0) == "489114867215630336" then --Skeltan
            gPlayerSyncTable[0].modelId = E_MODEL_WOOPER

        elseif network_discord_id_from_local_index(0) == "490613035237507091" then --AgentX
            gPlayerSyncTable[0].modelId = E_MODEL_FREEMAN

        elseif network_discord_id_from_local_index(0) == "584329002689363968" then --Blocky
            gPlayerSyncTable[0].modelId = E_MODEL_BLOCKY

        elseif network_discord_id_from_local_index(0) == "491581215782993931" --DepressedYoshi
        or network_discord_id_from_local_index(0) == "711762825676193874" or network_discord_id_from_local_index(0) == "561647968084557825" then --Yosho (+Alt)
            gPlayerSyncTable[0].modelId = E_MODEL_YOSHI

        elseif network_discord_id_from_local_index(0) == "799106550874243083" --KanHeaven
        or network_discord_id_from_local_index(0) == "662354972171567105" then --Bloxxel64Nya
            gPlayerSyncTable[0].modelId = E_MODEL_NYA

        elseif network_discord_id_from_local_index(0) == "282702284608110593" then --0x2480
            gPlayerSyncTable[0].modelId = E_MODEL_CROC

        elseif network_discord_id_from_local_index(0) == "397219199375769620" then --Average
            gPlayerSyncTable[0].modelId = E_MODEL_NATSUKI

        elseif network_discord_id_from_local_index(0) == "673582558507827221" then --Elby (god why)
            gPlayerSyncTable[0].modelId = E_MODEL_PROTOGEN

        elseif network_discord_id_from_local_index(0) == "817821798363955251" then --Crispy
            gPlayerSyncTable[0].modelId = E_MODEL_HATKID

        else
            gPlayerSyncTable[0].modelId = nil
        end
    end
    
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
        if network_discord_id_from_local_index(0) == "461771557531025409" --Spoomples
        or network_discord_id_from_local_index(0) == "901908732525559828" --Nut
        or network_discord_id_from_local_index(0) == "673582558507827221" then --Elby
            gNetworkPlayers[m.playerIndex].overrideModelIndex = CT_TOAD
        elseif network_discord_id_from_local_index(0) == "767513529036832799" then --Cosmic
            gNetworkPlayers[m.playerIndex].overrideModelIndex = CT_WALUIGI
        end
    end
end


--- @param m MarioState
function on_player_connected(m)
    gPlayerSyncTable[m.playerIndex].modelId = nil
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)