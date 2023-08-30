--- @param m MarioState
function mario_update(m)
    if BootupTimer == 90 and m.playerIndex ~= 0 then
        -- Name = Discord ID
        Default = "0"
        Squishy = "678794043018182675"
        Spoomples = "1028561407433777203"
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
        Mathew = "873511038551724152"
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
        TroopaParaKoopa = "984667169738600479"
        floofyxd = "1091528175575642122"
        flipflop = "603198923120574494"
        Koffee = "397847847283720193"
        Uoker = "401406794649436161"
        Dani = "922231782131265588"
        Brob = "1000555727942865036"
        Dakun = "358779634625806347"
        Loganti = "801151972609622029"
        Ryley = "839155992091820053"

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
                }
            },
            [Spoomples] = {
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
            [Nut] = {
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
                [5] = {
                    model = smlua_model_util_get_id("wander_geo"),
                    modelName = "Wander",
                    forcePlayer = CT_TOAD,
                    credit = "AlexXRGames"
                },
            },
            [Cosmic] = {
                nickname = "Cosmic",
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
                [1] = {
                    model = smlua_model_util_get_id("woop_geo"),
                    modelName = "Wizard Wooper",
                    forcePlayer = CT_MARIO,
                    icon = 1,
                    credit = "6b"
                }
            },
            [AgentX] = {
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
            [DepressedYoshi] = {
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
            [Yosho] = {
                nickname = "Yosho",
                [1] = {
                    model = smlua_model_util_get_id("yoshi_player_geo"),
                    modelName = "Yoshi",
                    forcePlayer = CT_MARIO,
                    credit = "CheesyNacho"
                }
            },
            [KanHeaven] = {
                nickname = "KanHeaven",
                [1] = {
                    model = smlua_model_util_get_id("kan_geo"),
                    modelName = "KanHeaven",
                    forcePlayer = CT_MARIO,
                    icon = "Default",
                    credit = "KanHeaven"
                },
                [2] = {
                    model = smlua_model_util_get_id("nya_geo"),
                    modelName = "Hatsune Maiku",
                    forcePlayer = CT_MARIO,
                    icon = "Default"
                }
            },
            [Bloxxel64Nya] = {
                nickname = "Bloxxel",
                [1] = {
                    model = smlua_model_util_get_id("nya_geo"),
                    modelName = "Hatsune Maiku",
                    forcePlayer = CT_MARIO,
                    icon = "Default"
                }
            },
            [Vince] = {
                nickname = "0x2480",
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
            [Crispyman] = {
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
                    model = smlua_model_util_get_id("peepers_geo"),
                    modelName = "Peepers",
                    forcePlayer = CT_TOAD,
                    credit = "AlexXRGames"
                },
                [5] = {
                    model = smlua_model_util_get_id("kirby_geo"),
                    modelName = "Kirby",
                    forcePlayer = CT_TOAD,
                    icon = 10,
                    credit = "MSatiro & 6b"
                },
                [6] = {
                    model = smlua_model_util_get_id("boshi_geo"),
                    modelName = "Boshi",
                    forcePlayer = CT_MARIO,
                    credit = "CheesyNacho"
                },
                [7] = {
                    model = smlua_model_util_get_id("yoshi_player_geo"),
                    modelName = "Yoshi",
                    forcePlayer = CT_MARIO,
                    icon = "Default",
                    credit = "CheesyNacho"
                },
                [8] = {
                    model = smlua_model_util_get_id("mr_l_geo"),
                    modelName = "Mr. L",
                    forcePlayer = CT_LUIGI,
                    icon = "Default",
                },
                [9] = {
                    model = smlua_model_util_get_id("rosalina_geo"),
                    modelName = "Rosalina",
                    forcePlayer = CT_WALUIGI,
                    credit = "TheAnkleDestroyer"
                }
            },
            [Butter] = {
                nickname = "Butter",
                [1] = {
                    model = smlua_model_util_get_id("nya_geo"),
                    modelName = "Hatsune Maiku",
                    forcePlayer = CT_MARIO
                }
            },
            [Mathew] = {
                nickname = "Mathew",
                [1] = {
                    model = smlua_model_util_get_id("mathew_geo"),
                    modelName = "Mathew",
                    icon = 9,
                    credit = "Mathew"
                }
            },
            [Peachy] = {
                nickname = "PeachyPeach",
                [1] = {
                    model = smlua_model_util_get_id("peach_player_geo"),
                    modelName = "Princess Peach",
                    forcePlayer = CT_MARIO
                },
            },
            [Eros] = {
                nickname = "Eros71",
                [1] = {
                    model = smlua_model_util_get_id("eros_geo"),
                    modelName = "Eros",
                    forcePlayer = CT_MARIO,
                    credit = "Eros71"
                },
            },
            [Oquanaut] = {
                nickname = "Oqua",
                [1] = {
                    model = smlua_model_util_get_id("oqua_geo"),
                    modelName = "Oqua",
                    forcePlayer = CT_TOAD,
                    credit = "Oquanaut"
                }
            },
            [RedBun] = {
                nickname = "Jonch",
                [1] = {
                    model = smlua_model_util_get_id("yoshi_player_geo"),
                    modelName = "Yoshi",
                    forcePlayer = CT_MARIO,
                    credit = "CheesyNacho"
                },
            },
            [Dvk] = {
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
                }
            },
            [KitKat] = {
                nickname = "KitKat",
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
            [Frosty] = {
                nickname = "Frosty",
                [1] = {
                    model = smlua_model_util_get_id("ski_geo"),
                    modelName = "Ski",
                    forcePlayer = CT_TOAD,
                    credit = "BBPanzu / Port by SunSpirit",
                },
            },
            [Shard] = {
                nickname = "Archie",
                [1] = {
                    model = smlua_model_util_get_id("archie_geo"),
                    modelName = "Archie",
                    forcePlayer = CT_WARIO,
                    icon = 13,
                    credit = "Trashcam",
                },
            },
            [TroopaParaKoopa] = {
                nickname = "TroopaParaKoopa",
                [1] = {
                    model = smlua_model_util_get_id("koopa_geo"),
                    modelName = "Koopa Shell Mario",
                    forcePlayer = CT_MARIO,
                    credit = "sm64mods & Brob2nd",
                },
            },
            [floofyxd] = {
                nickname = "Floofy",
                [1] = {
                    model = smlua_model_util_get_id("boyfriend_geo"),
                    modelName = "Boyfriend",
                    forcePlayer = CT_MARIO,
                    credit = "KuroButt",
                },
            },
            [flipflop] = {
                nickname = "Flipflop Bell",
                [1] = {
                    model = smlua_model_util_get_id("amy_geo"),
                    modelName = "Amy",
                    forcePlayer = CT_MARIO,
                },
            },
            [Koffee] = {
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
            },
            [Uoker] = {
                nickname = "Uoker",
                [1] = {
                    model = smlua_model_util_get_id("ari_geo"),
                    modelName = "Ari",
                    forcePlayer = CT_LUIGI,
                    icon = 16,
                    credit = "Trashcam",
                },
            },
            [Dani] = {
                nickname = "Dani",
                [1] = {
                    model = smlua_model_util_get_id("mawio_geo"),
                    modelName = "Mawio :3",
                    forcePlayer = CT_MARIO,
                    icon = 8,
                    credit = "sm64rise"
                },
            },
            [Brob] = {
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
            },
            [Dakun] = {
                nickname = "Dakun",
                [1] = {
                    model = smlua_model_util_get_id("ds_geo"),
                    modelName = "SM64DS Mario",
                    forcePlayer = CT_MARIO,
                    credit = "FluffaMario"
                },
                [2] = {
                    model = smlua_model_util_get_id("mawio_geo"),
                    modelName = "Mawio :3",
                    forcePlayer = CT_MARIO,
                    credit = "sm64rise"
                }
            },
            [Loganti] = {
                nickname = "Loganti",
                [1] = {
                    model = smlua_model_util_get_id("hd_mario_geo"),
                    modelName = "HD Mario",
                    forcePlayer = CT_MARIO,
                    credit = "MSatiro"
                }
            },
            [Ryley] = {
                nickname = "Ryley",
                [1] = {
                    model = smlua_model_util_get_id("ski_geo"),
                    modelName = "Ski",
                    forcePlayer = CT_TOAD,
                    credit = "BBPanzu / Port by SunSpirit",
                },
            }
        }

        menuErrorMsg = "Error not found"

        if discordID == "0" then
            menuErrorMsg = "Discord not Detected"
            menuTable[3][1].unlocked = 0
        end
        if modelTable[discordID] == nil then
            if menuErrorMsg == "Error not found" then
                menuErrorMsg = "No Models Found"
            end
            discordID = "0"
            menuTable[3][1].unlocked = 0
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

        BootupInfo = "Loaded Name-2-Model Data"

    end
    if BootupTimer < 100 then return end
    if modelTable[discordID][menuTable[3][1].status].icon ~= nil then
        lifeIcon = modelTable[discordID][menuTable[3][1].status].icon
    else
        lifeIcon = 0
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
    if BootupTimer < 150 then return end
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
        if msg == "0" then
            menuTable[3][1].unlocked = 0
        else
            menuTable[3][1].unlocked = 0
        end
        djui_chat_message_create('ID set to "'.. modelTable[msg].nickname ..'" ('.. msg ..') Successfully!')
    else
        djui_chat_message_create("Invalid ID Entered")
    end
    return true
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_OBJECT_SET_MODEL, set_model)