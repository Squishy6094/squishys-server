
-- Name = Discord ID
Default = "0"
Squishy = "678794043018182675"
Spoomples = "461771557531025409"
Nut = "901908732525559828"
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
Mathew = "468134163493421076"

local m = gMarioStates[0]

modelTable = {
    [Default] = {
        modelLimit = 0,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default",
        }
    },
    [Squishy] = {
        modelLimit = 10,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        },
        [2] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        },
        [3] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        },
        [4] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        },
        [5] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        },
        [6] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
        },
        [7] = {
            model = smlua_model_util_get_id("blocky_geo"),
            modelName = "Blocky",
            icon = get_texture_info("icon-blocky")
        },
        [8] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        },
        [9] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            icon = get_texture_info("icon-croc")
        },
        [10] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
        }
    },
    [Spoomples] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        }
    },
    [Nut] = {
        modelLimit = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        },
        [2] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
        }
    },
    [Cosmic] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = get_texture_info("icon-weedcat")
        }
    },
    [Trashcam] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = get_texture_info("icon-trashcam")
        }
    },
    [Skeltan] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wooper",
            forcePlayer = CT_TOAD
        }
    },
    [AgentX] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
        }
    },
    [Blocky] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("blocky_geo"),
            modelName = "Blocky",
            icon = get_texture_info("icon-blocky")
        }
    },
    [DepressedYoshi] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [Yosho] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [YoshoAlt] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
        }
    },
    [KanHeaven] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = m.character.hudHeadTexture
        }
    },
    [Bloxxel64Nya] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = m.character.hudHeadTexture
        }
    },
    [Vince] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            icon = get_texture_info("icon-croc")
        }
    },
    [Average] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
        }
    },
    [Elby] = {
        modelLimit = 2,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
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
            icon = m.character.hudHeadTexture
        }
    },
    [Crispyman] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
        }
    },
    [Butter] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }
    },
    [Mathew] = {
        modelLimit = 1,
        [0] = {
            model = nil,
            modelName = "Default",
            icon = m.character.hudHeadTexture
        },
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = get_texture_info("icon-mathew")
        }
    },
}

--- @param m MarioState
function mario_update(m)
    discordID = network_discord_id_from_local_index(0)
    if modelTable[discordID] == nil then
        discordID = "0"
        currModel = 0
    end

    if modelTable[discordID][currModel].icon ~= nil then
        if modelTable[discordID][currModel].icon == "Default" then
            lifeIcon = m.character.hudHeadTexture
        else
            lifeIcon = modelTable[discordID][currModel].icon
        end
    else
        lifeIcon = get_texture_info("icon-nil")
    end

    if not modelToggle or network_discord_id_from_local_index(0) == nil or discordID == "0" then return end
    if m.playerIndex == 0 then
        if discordID ~= "0" or discordID ~= "678794043018182675" or discordID ~= nil then
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