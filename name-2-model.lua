
-- Name = Discord ID
Default = "0"
Squishy = "678794043018182675"
Spoomples = "461771557531025409"
Nut = "1092073683377455215"
Cosmic = "767513529036832799"
Trashcam = "827596624590012457"
Skeltan = "489114867215630336"
AgentX = "490613035237507091"
DepressedYoshi = "491581215782993931"
Yosho = "711762825676193874"
YoshoAlt = "561647968084557825"
KanHeaven = "799106550874243083"
Bloxxel64Nya = "662354972171567105"
Vince = "282702284608110593"
Average = "397219199375769620"
Elby = "673582558507827221"
Crispyman = "817821798363955251"
Butter = "759464398946566165"
Mathew = "468134163493421076"
Peachy = "732244024567529503"
Eros = "376304957168812032"
Oquanaut = "459762042274840587"
RedBun = "459762042274840587"
Dvk = "542676894244536350"
KitKat = "664638362484867121"

local m = gMarioStates[0]

modelTable = {
    [Default] = {
        maxNum = 0,
        [0] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        }
    },
    [Squishy] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD
        },
    },
    [Spoomples] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default",
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [2] = {
            model = smlua_model_util_get_id("pacman_geo"),
            modelName = "Pac-Man",
            forcePlayer = CT_MARIO
        },
        [3] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
    },
    [Nut] = {
        maxNum = 4,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD
        },
        [3] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [4] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-purple-guy")
        }
    },
    [Cosmic] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        }
    },
    [Trashcam] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
        [3] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-purple-guy")
        }
    },
    [Skeltan] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        }
    },
    [AgentX] = {
        maxNum = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
            forcePlayer = CT_MARIO,
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }

    },
    [DepressedYoshi] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD
        },
    },
    [Yosho] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        }
    },
    [YoshoAlt] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        }
    },
    [KanHeaven] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Bloxxel64Nya] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [Vince] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            forcePlayer = CT_LUIGI,
            icon = get_texture_info("icon-croc")
        }
    },
    [Average] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
            forcePlayer = CT_MARIO,
        },
        [2] = {
            model = smlua_model_util_get_id("paper_mario_geo"),
            modelName = "Paper Mario",
            forcePlayer = CT_MARIO,
            icon = "Default"
        },
        [3] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_WALUIGI
        }
    },
    [Elby] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default"
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
    },
    [Crispyman] = {
        maxNum = 3,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
            forcePlayer = CT_MARIO
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = get_texture_info("icon-peppino")
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
    },
    [Butter] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Mathew] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = get_texture_info("icon-mathew")
        }
    },
    [Peachy] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("peach_player_geo"),
            modelName = "Princess Peach",
            forcePlayer = CT_LUIGI
        },
    },
    [Eros] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("eros_geo"),
            modelName = "Eros",
            forcePlayer = CT_MARIO
        },
    },
    [Oquanaut] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("oqua_geo"),
            modelName = "Oqua",
            forcePlayer = CT_TOAD
        }
    },
    [RedBun] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO
        },
    },
    [Dvk] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("crudelo_geo"),
            modelName = "Crudelo Badge",
            forcePlayer = CT_MARIO,
            icon = "Default"
        }
    },
    [KitKat] = {
        maxNum = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("pepperman_geo"),
            modelName = "Pepperman",
            forcePlayer = CT_WARIO
        }
    },
}

discordID = 0
local stallScriptTimer = 0

--- @param m MarioState
function mario_update(m)
    if stallScriptTimer < 5 then
        stallScriptTimer = stallScriptTimer + 1
        return
    end
    discordID = network_discord_id_from_local_index(0)
    if modelTable[discordID] == nil then
        discordID = "0"
        menuTable[3][2].status = 0
    end

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