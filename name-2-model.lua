
-- Name = Discord ID
Default = "0"
Nut = "678794043018182675"
Spoomples = "461771557531025409"
Squishy = "901908732525559828"
Cosmic = "767513529036832799"
Trashcam = "827596624590012457"
Skeltan = "489114867215630336"
AgentX = "490613035237507091"
Blocky = "584329002689363968"
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

modelTable = {
    [Default] = {
        [0] = {
            model = nil,
            modelName = "Default"
        }
    },
    [Squishy] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = nil,
            modelName = "Default"
        }
    },
    [Spoomples] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD
        }
    },
    [Nut] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        },
        [2] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD
        }
    },
    [Cosmic] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI
        }
    },
    [Trashcam] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO
        }
    },
    [Skeltan] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        }
    },
    [AgentX] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
        }
    },
    [Blocky] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("blocky_geo"),
            modelName = "Blocky",
        }
    },
    [DepressedYoshi] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [Yosho] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [YoshoAlt] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [KanHeaven] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Bloxxel64Nya] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Vince] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
        }
    },
    [Average] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
        }
    },
    [Elby] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD
        }
    },
    [Crispyman] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "HatKid",
        }
    },
    [Butter] = {
        [0] = {
            model = nil,
            modelName = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
}

--network_discord_id_from_local_index(0)
discordID = network_discord_id_from_local_index(0)
if modelTable[discordID] == nil then
    discordID = "0"
    print("Discord ID not found on Table, Setting to Default Table.")
end

--- @param m MarioState
function mario_update(m)
    if not modelToggle then return end
    if m.playerIndex == 0 then
        if discordID ~= "0" or discordID ~= "678794043018182675" then
            gPlayerSyncTable[0].modelId = modelTable[discordID][currModel].model
            if modelTable[discordID][currModel].forcePlayer ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= nil then
                gNetworkPlayers[m.playerIndex].overrideModelIndex = modelTable[discordID][currModel].forcePlayer
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

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)