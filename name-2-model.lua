--[[
-------------------------------------------
-- Name-2-Model Addition Do's and Don'ts --
-------------------------------------------

Models:
    Do:
    Unique Characters/Outfits that add to the Character/Personality
    (Mawio, Builder Mario, Casino Luigi, etc.)

    Don't:
    Alt Models that would work better as just a locally used DynOS Pack, Avoid Modifications that don't give a different feel for Personality
    (R96 Mario, Retro Mario, Beta Luigi, Better Toad, etc.)

Users:
    Do:
    Active/Well-Known Users that will commonly play on SS when it's Public

    Don't:
    Banned/Inactive/Controverstial Users that the community overall wouldn't agree with their inclusion

    We still include users such as sm64rise in the offchance they join, and Mawio is already used by so many other people anyways.
--]]

local modelTable = {}

local currModel = 0
local localModelDisplay = true

local function setup_models()
    modelTable = {
        ["0"] = { -- Unregistered users will be set to 0
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
        ["678794043018182675"] = { -- Registered Users now use the raw ID in their table
            nickname = "Squishy", -- We can still Identify People via this nickname varible
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
            [4] = {
                model = smlua_model_util_get_id("mawio_geo"),
                modelName = "Mawio :3",
                forcePlayer = CT_MARIO,
                icon = 8,
                credit = "sm64rise"
            },  
            [5] = {
                model = smlua_model_util_get_id("tuxmario_geo"),
                modelName = "Tuxedo Mario",
                forcePlayer = CT_MARIO,
                credit = "Brob2nd",
            },
            [6] = {
                model = smlua_model_util_get_id("yumi_geo"),
                modelName = "Yumi Martinez",
                forcePlayer = CT_MARIO,
                credit = "frijoles"
            }
        },
        ["1028561407433777203"] = {
            nickname = "Spoomples",
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
        ["1092073683377455215"] = {
            nickname = "Nut",
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
        },
        ["767513529036832799"] = {
            nickname = "Cosmic",
            [1] = {
                model = smlua_model_util_get_id("cosmic_geo"),
                modelName = "Weedcat",
                forcePlayer = CT_WALUIGI,
                icon = 2,
                credit = "Cosmic(Wo)Man08"
            }
        },
        ["827596624590012457"] = {
            nickname = "Trashcam",
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
        ["489114867215630336"] = {
            nickname = "Skeltan",
            [1] = {
                model = smlua_model_util_get_id("woop_geo"),
                modelName = "Wizard Wooper",
                forcePlayer = CT_MARIO,
                icon = 1,
                credit = "6b"
            }
        },
        ["490613035237507091"] = {
            nickname = "Agent X",
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
        ["491581215782993931"] = {
            nickname = "Depressed Yoshi",
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
        ["561647968084557825"] = {
            nickname = "Yosho",
            [1] = {
                model = smlua_model_util_get_id("yoshi_player_geo"),
                modelName = "Yoshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            }
        },
        ["1134242746832523414"] = {
            nickname = "KanHeaven",
            [1] = {
                model = smlua_model_util_get_id("kan_geo"),
                modelName = "KanHeaven",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "KanHeaven"
            },
            [2] = {
                model = smlua_model_util_get_id("summer_inkling_geo"),
                modelName = "Summer Inkling",
                forcePlayer = CT_MARIO,
                credit = "KanHeaven"
            },
            [3] = {
                model = smlua_model_util_get_id("nya_geo"),
                modelName = "Hatsune Maiku",
                forcePlayer = CT_MARIO,
                icon = "Default"
            }
        },
        ["662354972171567105"] = {
            nickname = "Bloxxel",
            [1] = {
                model = smlua_model_util_get_id("nya_geo"),
                modelName = "Hatsune Maiku",
                forcePlayer = CT_MARIO,
                icon = "Default"
            }
        },
        ["282702284608110593"] = {
            nickname = "0x2480",
            [1] = {
                model = smlua_model_util_get_id("croc_geo"),
                modelName = "Croc",
                forcePlayer = CT_LUIGI,
                icon = 12,
                credit = "0x2480"
            }
        },
        ["397219199375769620"] = {
            nickname = "Average <3",
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
        ["673582558507827221"] = {
            nickname = "Elby",
            [1] = {
                model = smlua_model_util_get_id("elby_geo"),
                modelName = "Elby",
                forcePlayer = CT_LUIGI,
                icon = 17,
                credit = "Trashcam"
            },
            [2] = {
                model = smlua_model_util_get_id("protogen_geo"),
                modelName = "Protogen",
                forcePlayer = CT_TOAD,
                credit = "SolonelyCapybara"
            },
            [3] = {
                model = smlua_model_util_get_id("nya_geo"),
                modelName = "Hatsune Maiku",
                forcePlayer = CT_MARIO,
                icon = "Default",
            },
            [4] = {
                model = smlua_model_util_get_id("noelle_geo"),
                modelName = "Noelle",
                forcePlayer = CT_LUIGI,
                credit = "misfiremf & deltomx3"
            },
            [5] = {
                model = smlua_model_util_get_id("boshi_geo"),
                modelName = "Boshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            },
            [6] = {
                model = smlua_model_util_get_id("sonic_geo"),
                modelName = "Sonic",
                forcePlayer = CT_MARIO,
                icon = 5,
                credit = "Steven"
            },
            [7] = {
                model = smlua_model_util_get_id("tails_geo"),
                modelName = "Tails",
                forcePlayer = CT_LUIGI,
                icon = 4,
                credit = "brob2nd"
            }
        },
        ["817821798363955251"] = {
            nickname = "Crispy",
            [1] = {
                model = smlua_model_util_get_id("wario_man_geo"),
                modelName = "Wario Man",
                forcePlayer = CT_WARIO,
                credit = "AlexXRGames"
            },
            [2] = {
                model = smlua_model_util_get_id("hat_kid_geo"),
                modelName = "Hat Kid",
                forcePlayer = CT_LUIGI,
                icon = 11,
            },
            [3] = {
                model = smlua_model_util_get_id("noelle_geo"),
                modelName = "Noelle",
                forcePlayer = CT_LUIGI
            },
            [4] = {
                model = smlua_model_util_get_id("kirby_geo"),
                modelName = "Kirby",
                forcePlayer = CT_TOAD,
                icon = 10,
                credit = "MSatiro & 6b"
            },
            [5] = {
                model = smlua_model_util_get_id("boshi_geo"),
                modelName = "Boshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            },
            [6] = {
                model = smlua_model_util_get_id("yoshi_player_geo"),
                modelName = "Yoshi",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "CheesyNacho"
            },
            [7] = {
                model = smlua_model_util_get_id("mr_l_geo"),
                modelName = "Mr. L",
                forcePlayer = CT_LUIGI,
                icon = "Default",
            },
            [8] = {
                model = smlua_model_util_get_id("rosalina_geo"),
                modelName = "Rosalina",
                forcePlayer = CT_WALUIGI,
                credit = "TheAnkleDestroyer"
            }
        },
        ["759464398946566165"] = {
            nickname = "Butter",
            [1] = {
                model = smlua_model_util_get_id("nya_geo"),
                modelName = "Hatsune Maiku",
                forcePlayer = CT_MARIO
            }
        },
        ["873511038551724152"] = {
            nickname = "Mathew",
            [1] = {
                model = smlua_model_util_get_id("mathew_geo"),
                modelName = "Mathew",
                icon = 9,
                credit = "Mathew"
            }
        },
        ["732244024567529503"] = {
            nickname = "PeachyPeach",
            [1] = {
                model = smlua_model_util_get_id("peach_player_geo"),
                modelName = "Princess Peach",
                forcePlayer = CT_MARIO,
                credit = "Cheesester, ER1CK"
            },
        },
        ["376304957168812032"] = {
            nickname = "Eros71",
            [1] = {
                model = smlua_model_util_get_id("eros_geo"),
                modelName = "Eros",
                forcePlayer = CT_MARIO,
                credit = "Eros71"
            },
        },
        ["459762042274840587"] = {
            nickname = "Oqua",
            [1] = {
                model = smlua_model_util_get_id("oqua_geo"),
                modelName = "Oqua",
                forcePlayer = CT_TOAD,
                credit = "Oquanaut"
            }
        },
        ["426548210790825984"] = {
            nickname = "Jonch",
            [1] = {
                model = smlua_model_util_get_id("yoshi_player_geo"),
                modelName = "Yoshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            },
        },
        ["542676894244536350"] = {
            nickname = "Floralys",
            [1] = {
                model = smlua_model_util_get_id("crudelo_geo"),
                modelName = "Crudelo Badge",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "Floralys"
            },
            [2] = {
                model = smlua_model_util_get_id("casino_luigi_geo"),
                modelName = "Casino Luigi",
                forcePlayer = CT_LUIGI,
                icon = "Default",
                credit = "FluffaMario, CheesyNacho"
            },
            [3] = {
                model = smlua_model_util_get_id("mawio_geo"),
                modelName = "Mawio :3",
                forcePlayer = CT_MARIO,
                icon = "Default", -- I keep this icon disabled on purpose by the way
                credit = "sm64rise"
            },
            [4] = {
                model = smlua_model_util_get_id("paper_mario_geo"),
                modelName = "Paper Mario",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "6b"
            },
            [5] = {
                model = smlua_model_util_get_id("builder_geo"),
                modelName = "Builder Mario",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "MSatiro"
            },
            [6] = {
                model = smlua_model_util_get_id("peach_player_geo"),
                modelName = "Princess Peach",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "Cheesester, ER1CK"
            },
            [7] = {
                model = smlua_model_util_get_id("daisy_geo"),
                modelName = "Princess Daisy",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "Cheesester, ER1CK"
            },
            [8] = {
                model = smlua_model_util_get_id("yumi_geo"),
                modelName = "Yumi Martinez",
                forcePlayer = CT_MARIO,
                credit = "frijoles"
            }
        },
        ["664638362484867121"] = {
            nickname = "KitKat",
            [1] = {
                model = smlua_model_util_get_id("pepperman_geo"),
                modelName = "Pepperman",
                forcePlayer = CT_WARIO,
                icon = 14,
                credit = "CheesyNacho"
            }
        },
        ["371344058167328768"] = {
            nickname = "sm64rise",
            [1] = {
                model = smlua_model_util_get_id("mawio_geo"),
                modelName = "Mawio :3",
                forcePlayer = CT_MARIO,
                icon = 8,
                credit = "sm64rise"
            }
        },
        ["397891541160558593"] = {
            nickname = "Yuyake",
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
        ["635629441678180362"] = {
            nickname = "Plus",
            [1] = {
                model = smlua_model_util_get_id("veph_geo"),
                modelName = "Veph the Dolphin-Fox",
                forcePlayer = CT_LUIGI,
                credit = "Yuyake"
            },
            [2] = {
                model = smlua_model_util_get_id("boshi_geo"),
                modelName = "Boshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            },
            [3] = {
                model = smlua_model_util_get_id("kirby_geo"),
                modelName = "Kirby",
                forcePlayer = CT_TOAD,
                icon = 10,
                credit = "MSatiro & 6b"
            },
            [4] = {
                model = smlua_model_util_get_id("sonic_geo"),
                modelName = "Sonic",
                forcePlayer = CT_TOAD,
                icon = 5,
                credit = "Steven"
            },
            [5] = {
                model = smlua_model_util_get_id("tails_geo"),
                modelName = "Tails",
                forcePlayer = CT_TOAD,
                icon = 4,
                credit = "brob2nd"
            },
            [6] = {
                model = smlua_model_util_get_id("yoshi_player_geo"),
                modelName = "Yoshi",
                forcePlayer = CT_MARIO,
                icon = "Default",
                credit = "CheesyNacho"
            },
            [7] = {
                model = smlua_model_util_get_id("tiremario_geo"),
                modelName = "Tired",
                forcePlayer = CT_MARIO,
                credit = "Endood,AquariusAlexx and Brobgonal"
            },
            [8] = {
                model = smlua_model_util_get_id("rosalina_geo"),
                modelName = "Rosalina",
                forcePlayer = CT_LUIGI,
                credit = "TheAnkleDestroyer"
            }
        },
        ["541396312608866305"] = {
            nickname = "Frosty",
            [1] = {
                model = smlua_model_util_get_id("ski_geo"),
                modelName = "Ski",
                forcePlayer = CT_TOAD,
                credit = "BBPanzu / Port by SunSpirit",
            },
        },
        ["1064980922371420313"] = {
            nickname = "Archie",
            [1] = {
                model = smlua_model_util_get_id("archie_geo"),
                modelName = "Archie",
                forcePlayer = CT_WARIO,
                icon = 13,
                credit = "Trashcam",
            },
        },
        ["1091528175575642122"] = {
            nickname = "Floofy",
            [1] = {
                model = smlua_model_util_get_id("boyfriend_geo"),
                modelName = "Boyfriend",
                forcePlayer = CT_MARIO,
                credit = "KuroButt",
            },
        },
        ["603198923120574494"] = {
            nickname = "Flipflop Bell",
            [1] = {
                model = smlua_model_util_get_id("amy_geo"),
                modelName = "Amy",
                forcePlayer = CT_MARIO,
                credit = "Flipflop Bell",
            },
        },
        ["397847847283720193"] = {
            nickname = "KoffeeMood",
            [1] = {
                model = smlua_model_util_get_id("lime_geo"),
                modelName = "Lime",
                forcePlayer = CT_LUIGI,
                icon = 15,
                credit = "Trashcam",
            },
            [2] = {
                model = smlua_model_util_get_id("lime_but_awesome_geo"),
                modelName = "Lime (Shades)",
                forcePlayer = CT_LUIGI,
                icon = 15,
                credit = "Trashcam",
            },
            [3] = {
                model = smlua_model_util_get_id("amy_geo"),
                modelName = "Amy",
                forcePlayer = CT_MARIO,
                credit = "Flipflop Bell",
            },
        },
        ["401406794649436161"] = {
            nickname = "Uoker",
            [1] = {
                model = smlua_model_util_get_id("ari_geo"),
                modelName = "Ari",
                forcePlayer = CT_LUIGI,
                icon = 16,
                credit = "Trashcam",
            },
        },
        ["922231782131265588"] = {
            nickname = "Dani",
            [1] = {
                model = smlua_model_util_get_id("mawio_geo"),
                modelName = "Mawio :3",
                forcePlayer = CT_MARIO,
                icon = 8,
                credit = "sm64rise"
            },
        },
        ["1000555727942865036"] = {
            nickname = "Brob2nd",
            [1] = {
                model = smlua_model_util_get_id("dk_geo"),
                modelName = "Donkey Kong",
                forcePlayer = CT_WARIO,
                icon = 16,
                credit = "Brob2nd",
            },
            [2] = {
                model = smlua_model_util_get_id("koopa_geo"),
                modelName = "Koopa Shell Mario",
                forcePlayer = CT_MARIO,
                credit = "sm64mods & Brob2nd",
            },
            [3] = {
                model = smlua_model_util_get_id("boshi_geo"),
                modelName = "Boshi",
                forcePlayer = CT_MARIO,
                credit = "CheesyNacho"
            },
            [4] = {
                model = smlua_model_util_get_id("tails_geo"),
                modelName = "Tails",
                forcePlayer = CT_TOAD,
                icon = 4,
                credit = "Brob2nd"
            },
            [5] = {
                model = smlua_model_util_get_id("tiremario_geo"),
                modelName = "Tired",
                forcePlayer = CT_MARIO,
                credit = "Endood, AquariusAlexx and Brobgonal"
            },
            [6] = {
                model = smlua_model_util_get_id("tuxmario_geo"),
                modelName = "Tuxedo Mario",
                forcePlayer = CT_MARIO,
                credit = "Brob2nd",
            },
            [7] = {
                model = smlua_model_util_get_id("tuxluigi_geo"),
                modelName = "Tuxedo Luigi",
                forcePlayer = CT_LUIGI,
                credit = "Brob2nd",
            },
        },
        ["358779634625806347"] = {
            nickname = "Dakun",
            [1] = {
                model = smlua_model_util_get_id("mawio_geo"),
                modelName = "Mawio :3",
                forcePlayer = CT_MARIO,
                credit = "sm64rise"
            }
        },
        ["839155992091820053"] = {
            nickname = "Ryley",
            [1] = {
                model = smlua_model_util_get_id("ski_geo"),
                modelName = "Ski",
                forcePlayer = CT_TOAD,
                credit = "BBPanzu / Port by SunSpirit",
            },
        }
    }
end

--- @param m MarioState
local function mario_update(m)
    if BootupTimer == 90 and m.playerIndex ~= 0 then
        setup_models()
        currModel = menuTable[4][1].status
        localModelDisplay = tobool(menuTable[4][2].status)
        menuErrorMsg = "Error not found"

        if discordID == "0" then
            menuErrorMsg = "Discord not Detected"
            menuTable[4][1].unlocked = 0
        end
        if modelTable[discordID] == nil then
            if menuErrorMsg == "Error not found" then
                menuErrorMsg = "No Models Found"
            end
            discordID = "0"
            menuTable[4][1].unlocked = 0
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
            menuTable[4][1].statusNames[i] = modelTable[discordID][i].modelName
        end
        menuTable[4][1].statusMax = #modelTable[discordID]

        if currModel == nil then
            currModel = 0
        end

        BootupInfo = BOOTUP_LOADED_NAME_2_MODEL_DATA
    end
    
    if BootupTimer < 110 then return end
    currModel = menuTable[4][1].status
    localModelDisplay = tobool(menuTable[4][2].status)

    if not localModelDisplay then
        lifeIcon = "Default"
        return
    end
    if m.playerIndex == 0 then
        if discordID ~= "0" then
            if modelTable[discordID][currModel].icon ~= nil then
                lifeIcon = modelTable[discordID][currModel].icon
            else
                lifeIcon = 0
            end
            gPlayerSyncTable[0].modelId = modelTable[discordID][currModel].model
            if modelTable[discordID][currModel].forcePlayer ~= nil and gPlayerSyncTable[m.playerIndex].modelId ~= nil then
                gNetworkPlayers[m.playerIndex].overrideModelIndex = modelTable[discordID][currModel].forcePlayer
            end
        else
            gPlayerSyncTable[0].modelId = nil
            if currModel ~= 0 then
                menuTable[4][1].status = 0
            end
        end
    end
    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
end

local function set_model(o, id)
    if BootupTimer < 150 then return end
    if id == E_MODEL_MARIO and localModelDisplay then
        local i = network_local_index_from_global(o.globalPlayerIndex)
        if gPlayerSyncTable[i].modelId ~= nil then
            obj_set_model_extended(o, gPlayerSyncTable[i].modelId)
        end
    end
end

function set_discord_id(msg)
    if not network_has_permissions() then
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
            menuTable[4][1].statusNames[i] = modelTable[discordID][i].modelName
        end
        menuTable[4][1].statusMax = #modelTable[discordID]
        menuTable[4][1].status = 1
        if msg == "0" then
            menuTable[4][1].unlocked = 0
        else
            menuTable[4][1].unlocked = 1
        end
        local modelString = ""
        for i = 1, #modelTable[discordID] do
            modelString = modelString..modelTable[discordID][i].modelName
            if i ~= #modelTable[discordID] then
                modelString = modelString..", "
            end
        end
        djui_chat_message_create('Name-2-Model User set to "'.. modelTable[msg].nickname ..'" Successfully!\nUser ID: '.. msg ..'\nModel Count: '..#modelTable[discordID]..'\nModels: '..modelString)
    else
        djui_chat_message_create("Invalid ID Entered")
    end
    return true
end

--Functions to keep our table local
function name2model_get_nickname()
    return modelTable[discordID].nickname
end

function name2model_get_model_name()
    return modelTable[discordID][currModel].modelName
end

function name2model_get_model_credit()
    return modelTable[discordID][currModel].credit
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_OBJECT_SET_MODEL, set_model)