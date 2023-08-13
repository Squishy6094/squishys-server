-- name: \\#FFCC00\\McDonald's Sandbox \\#DA291C\\(Plug and Play)\\#FFFFFF\\
-- description: McDonald's in sm64ex-coop! This map is completely isolated from the vanilla experience, which allows it to co-exist alongside the basegame!\n\n\nTo access McDonald's, simply use the /mcd command.\n\n\nMade by \\#3b8ff7\\chillyzone~\\#ffffff\\

LEVEL_MCDONALDS = level_register('level_mcdonalds_sandbox_entry', COURSE_NONE, "McDonald's", 'mcdonalds_sandbox', 28000, 0x28, 0x28, 0x28)
E_MODEL_MCDONALDCRATE = smlua_model_util_get_id("mcd_crate_geo")
-- Add Toggle to Squishy's Server
if _G.ssExists then
    _G.ssApi.option_add("Warp to McDonald's", 0, 1, {[0] = "", [1] = ""}, {
        "McDonald's in Squishy's Server!",
        "This map is completely isolated",
        "from the vanilla experience,",
        "which allows it to co-exist",
        "alongside the basegame!",
        "",
        "",
        "",
        "Map created by chillyzone~"
    })
end

function notifynewplayers()
    if _G.ssExists then
        djui_chat_message_create("This server is using the McDonald's Sandbox map mod! You can warp to this map by using the Squishy's Server Menu")
    else
        djui_chat_message_create("Welcome! This server is using the McDonald's Sandbox map mod! You can warp to this map by doing the /mcd command.")
    end
end

function check_status_change()
    if not _G.ssExists then return end
    -- Check if the status of the Toggle was changed, and set it back to 0
    if _G.ssApi.option_read("Warp to McDonald's") == 1 then
        warp_to_level(LEVEL_MCDONALDS, 1, 0)
        _G.ssApi.option_write("Warp to McDonald's", 0)
    end
end

function mcd_warp()
    if gNetworkPlayers[0] then
        warp_to_level(LEVEL_MCDONALDS, 1, 0)
        return true
    end
end


hook_event(HOOK_JOINED_GAME, notifynewplayers)
hook_event(HOOK_MARIO_UPDATE, check_status_change)
if not _G.ssExists then
    hook_chat_command("mcd", "Warps you to McDonalds", mcd_warp)
end