
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
RedBun = "426548210790825984"
Dvk = "542676894244536350"
KitKat = "664638362484867121"
Rise = "371344058167328768"
Yuyake = "397891541160558593"
Plusle = "635629441678180362"
Frosty = "541396312608866305"
Shard = "1064980922371420313"
Isaackie = "1093357396920901643"

local m = gMarioStates[0]

modelTable = {
    [Default] = {
        nickname = "Default",
        [0] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        },
        [1] = {
            model = nil,
            modelName = "N/A",
            icon = "Default",
        },
    },
    [Squishy] = {
        nickname = "Squishy",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("squishy_geo"),
            modelName = "Squishy",
            forcePlayer = CT_MARIO,
            credit = "Trashcam"
        },
        [2] = {
            model = smlua_model_util_get_id("squishy_mc_geo"),
            modelName = "Squishy (Minecraft)",
            forcePlayer = CT_MARIO,
            credit = "Elby"
        },
        [3] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD,
            credit = "BBPanzu / Port by SunSpirit",
        },
    },
    [Spoomples] = {
        nickname = "Spoomples",
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
            credit = "Depressed Yoshi",
        },
        [2] = {
            model = smlua_model_util_get_id("pacman_geo"),
            modelName = "Pac-Man",
            forcePlayer = CT_MARIO,
            credit = "CosmicMan08"
        },
        [3] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = 8,
            credit = "Trashcam"
        },
    },
    [Nut] = {
        nickname = "Nut",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("n64_goomba_player_geo"),
            modelName = "N64 Goomba",
            forcePlayer = CT_TOAD,
            credit = "Goldenix"
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD,
            credit = "DepressedYoshi"
        },
        [3] = {
            model = smlua_model_util_get_id("ss_toad_player_geo"),
            modelName = "Super Show Toad",
            forcePlayer = CT_TOAD,
            icon = "Default",
            credit = "DepressedYoshi"
        },
        [4] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = 7,
            credit = "Trashcam"
        },
        [5] = {
            model = smlua_model_util_get_id("wander_geo"),
            modelName = "Wander",
            forcePlayer = CT_TOAD,
            credit = "AlexXRGames"
        },
    },
    [Cosmic] = {
        nickname = "Cosmic",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("cosmic_geo"),
            modelName = "Weedcat",
            forcePlayer = CT_WALUIGI,
            icon = 2,
            credit = "Cosmic(Wo)Man08"
        }
    },
    [Trashcam] = {
        nickname = "Trashcam",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("trashcam_geo"),
            modelName = "Trashcam",
            forcePlayer = CT_MARIO,
            icon = 3,
            credit = "Trashcam"
        },
        [2] = {
            model = smlua_model_util_get_id("peppino_geo"),
            modelName = "Peppino",
            forcePlayer = CT_WARIO,
            icon = 7,
            credit = "Trashcam"
        },
        [3] = {
            model = smlua_model_util_get_id("purple_guy_geo"),
            modelName = "Purple Guy",
            forcePlayer = CT_MARIO,
            icon = 6,
            credit = "Trashcam"
        }
    },
    [Skeltan] = {
        nickname = "Skeltan",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("woop_geo"),
            modelName = "Wizard Wooper",
            forcePlayer = CT_TOAD,
            icon = 1,
            credit = "6b"
        }
    },
    [AgentX] = {
        nickname = "Agent X",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("gordon_geo"),
            modelName = "Gordon Freeman",
            forcePlayer = CT_MARIO,
            credit = "Agent X"
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO
        }

    },
    [DepressedYoshi] = {
        nickname = "Depressed Yoshi",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [2] = {
            model = smlua_model_util_get_id("pizzelle_geo"),
            modelName = "Pizzelle",
            forcePlayer = CT_TOAD,
            credit = "DepressedYoshi"
        },
    },
    [Yosho] = {
        nickname = "Yosho",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        }
    },
    [KanHeaven] = {
        nickname = "KanHeaven",
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
        nickname = "Bloxxel",
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
        nickname = "0x2480",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("croc_geo"),
            modelName = "Croc",
            forcePlayer = CT_LUIGI,
            icon = 12,
            credit = "0x2480"
        }
    },
    [Average] = {
        nickname = "Average <3",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("natsuki_geo"),
            modelName = "Natsuki",
            forcePlayer = CT_MARIO,
            credit = "DusterBuster & SunSpirit"
        },
        [2] = {
            model = smlua_model_util_get_id("paper_mario_geo"),
            modelName = "Paper Mario",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "6b"
        },
        [3] = {
            model = smlua_model_util_get_id("rosalina_geo"),
            modelName = "Rosalina",
            forcePlayer = CT_WALUIGI,
            credit = "TheAnkleDestroyer"
        }
    },
    [Elby] = {
        nickname = "Elby",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("protogen_geo"),
            modelName = "Protogen",
            forcePlayer = CT_TOAD,
            credit = "SolonelyCapybara"
        },
        [2] = {
            model = smlua_model_util_get_id("nya_geo"),
            modelName = "Hatsune Maiku",
            forcePlayer = CT_MARIO,
            icon = "Default",
        },
        [3] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI,
            credit = "misfiremf & deltomx3"
        },
        [4] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [5] = {
            model = smlua_model_util_get_id("sonic_geo"),
            modelName = "Sonic",
            forcePlayer = CT_MARIO,
            icon = 5,
            credit = "Steven"
        },
        [6] = {
            model = smlua_model_util_get_id("tails_geo"),
            modelName = "Tails",
            forcePlayer = CT_LUIGI,
            icon = 4,
            credit = "brob2nd"
        }
    },
    [Crispyman] = {
        nickname = "Crispy",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("hat_kid_geo"),
            modelName = "Hat Kid",
            forcePlayer = CT_TOAD,
            icon = 11,
        },
        [2] = {
            model = smlua_model_util_get_id("noelle_geo"),
            modelName = "Noelle",
            forcePlayer = CT_LUIGI
        },
        [3] = {
            model = smlua_model_util_get_id("peepers_geo"),
            modelName = "Peepers",
            forcePlayer = CT_TOAD,
            credit = "AlexXRGames"
        },
        [4] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [5] = {
            model = smlua_model_util_get_id("kirby_geo"),
            modelName = "Kirby",
            forcePlayer = CT_TOAD,
            icon = 10,
            credit = "MSatiro & 6b"
        }
    },
    [Butter] = {
        nickname = "Butter",
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
        nickname = "Mathew",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("mathew_geo"),
            modelName = "Mathew",
            icon = 9,
            credit = "Mathew"
        }
    },
    [Peachy] = {
        nickname = "PeachyPeach",
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
        nickname = "Eros71",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("eros_geo"),
            modelName = "Eros",
            forcePlayer = CT_MARIO,
            credit = "Eros71"
        },
    },
    [Oquanaut] = {
        nickname = "Oqua",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("oqua_geo"),
            modelName = "Oqua",
            forcePlayer = CT_TOAD,
            credit = "Oquanaut"
        }
    },
    [RedBun] = {
        nickname = "Jonch",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
    },
    [Dvk] = {
        nickname = "Floralys",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("crudelo_geo"),
            modelName = "Crudelo Badge",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "Floralys"
        }
    },
    [KitKat] = {
        nickname = "KitKat",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("pepperman_geo"),
            modelName = "Pepperman",
            forcePlayer = CT_WARIO,
            icon = 14,
            credit = "CheesyNacho"
        }
    },
    [Rise] = {
        nickname = "sm64rise",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("mawio_geo"),
            modelName = "Mawio :3",
            forcePlayer = CT_MARIO,
            icon = 8,
            credit = "sm64rise"
        }
    },
    [Yuyake] = {
        nickname = "Yuyake",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("yuyake_geo"),
            modelName = "Yuyake",
            forcePlayer = CT_MARIO,
            credit = "Yuyake"
        },
        [2] = {
            model = smlua_model_util_get_id("veph_geo"),
            modelName = "Veph the Dolphin-Fox",
            forcePlayer = CT_LUIGI,
            credit = "Yuyake"
        }
    },
    [Plusle] = {
        nickname = "Plus",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("mr_l_geo"),
            modelName = "Mr. L",
            forcePlayer = CT_LUIGI,
            icon = "Default",
        },
        [2] = {
            model = smlua_model_util_get_id("veph_geo"),
            modelName = "Veph the Dolphin-Fox",
            forcePlayer = CT_LUIGI,
            credit = "Yuyake"
        },
        [3] = {
            model = smlua_model_util_get_id("boshi_geo"),
            modelName = "Boshi",
            forcePlayer = CT_MARIO,
            credit = "CheesyNacho"
        },
        [4] = {
            model = smlua_model_util_get_id("kirby_geo"),
            modelName = "Kirby",
            forcePlayer = CT_TOAD,
            icon = 10,
            credit = "MSatiro & 6b"
        },
        [5] = {
            model = smlua_model_util_get_id("sonic_geo"),
            modelName = "Sonic",
            forcePlayer = CT_MARIO,
            icon = 5,
            credit = "Steven"
        },
        [6] = {
            model = smlua_model_util_get_id("tails_geo"),
            modelName = "Tails",
            forcePlayer = CT_LUIGI,
            icon = 4,
            credit = "brob2nd"
        },
        [7] = {
            model = smlua_model_util_get_id("yoshi_player_geo"),
            modelName = "Yoshi",
            forcePlayer = CT_MARIO,
            icon = "Default",
            credit = "CheesyNacho"
        }
    },
    [Frosty] = {
        nickname = "Frosty",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("ski_geo"),
            modelName = "Ski",
            forcePlayer = CT_TOAD,
            credit = "BBPanzu / Port by SunSpirit",
        },
    },
    [Shard] = {
        nickname = "Archie",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("archie_geo"),
            modelName = "Archie",
            forcePlayer = CT_WARIO,
            icon = 13,
            credit = "Trashcam",
        },
    },
    [Isaackie] = {
        nickname = "Isaackie",
        [0] = {
            model = nil,
            modelName = "Default",
            icon = "Default"
        },
        [1] = {
            model = smlua_model_util_get_id("net64toad_player_geo"),
            modelName = "Net64 Toad",
            forcePlayer = CT_TOAD,
            credit = "By CheesyNacho",
        },
    },
}

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

--- @param m MarioState
function mario_update(m)
    if modelTable[discordID][menuTable[3][1].status].icon ~= nil then
        lifeIcon = modelTable[discordID][menuTable[3][1].status].icon
    else
        lifeIcon = 0
    end
    if maxModelNum == nil then
        maxModelNum = #modelTable[discordID]
    end
    if menuTable[3][1].status > maxModelNum then
        menuTable[3][1].status = 0
        mod_storage_save(menuTable[3][1].nameSave, "0")
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
    if not network_is_server() then
        djui_chat_message_create("This command is only avalible to the Host.")
        return true
    end
    if modelTable[msg] ~= nil then
        discordID = msg
        menuTable[3][1].statusMax = modelTable[discordID].maxNum
        menuTable[3][1].status = 0
        maxModelNum = #modelTable[discordID]
        djui_chat_message_create('ID set to "'.. modelTable[msg].nickname ..'" ('.. msg ..') Successfully!')
    else
        djui_chat_message_create("Invalid ID Entered")
    end
    return true
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)