BootupTimer = 0
BootupInfo = "Initializing"

-- Heavy optimization, I want this bitch to run clean
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_set_font = djui_hud_set_font
local djui_hud_print_text = djui_hud_print_text
local djui_hud_measure_text = djui_hud_measure_text
local djui_hud_render_texture_tile = djui_hud_render_texture_tile

-- Initialization
print("Connected to Server Successfully!")
discordID = network_discord_id_from_local_index(0)

if network_is_server() then
    gGlobalSyncTable.RoomStart = get_time()
    gGlobalSyncTable.event = "Default"
    gGlobalSyncTable.shutdownTimer = nil
end

local opacity = 255
hook_event(HOOK_ON_HUD_RENDER, function ()
    if BootupTimer < 150 then
        BootupTimer = BootupTimer + 1
        opacity = 255
    elseif opacity > 0 then
        opacity = opacity - 3
    end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(0, 0, 0, opacity)
    djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 5, djui_hud_get_screen_height() + 5)
    djui_hud_set_color(255, 255, 255, opacity)
    djui_hud_render_rect(0, djui_hud_get_screen_height() - 5, ((djui_hud_get_screen_width() + 5) / 150) * BootupTimer, 10)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_print_text("Now loading...", djui_hud_get_screen_width()*0.5 - djui_hud_measure_text("Now loading...")*0.5, 30, 1)
    if BootupInfo ~= nil then
        djui_hud_print_text(BootupInfo, djui_hud_get_screen_width()*0.5 - djui_hud_measure_text(BootupInfo)*0.35, djui_hud_get_screen_height() - 30, 0.7)
    end
    djui_hud_set_color(0, 131, 0, opacity)
    djui_hud_render_texture_tile(get_texture_info("theme-default"), djui_hud_get_screen_width()*0.5 - 106, djui_hud_get_screen_height()*0.5 - 30, 0.33333333332, 1.17333333332, 0, 206, 176, 50)

    djui_hud_set_color(255, 255, 255, opacity)
    if opacity > 0 then
        djui_hud_render_texture_tile(get_texture_info("ssLoading"), djui_hud_get_screen_width() - 40, djui_hud_get_screen_height() - 40, 1, 1, (math.floor(BootupTimer*0.1)*32)%128, 0, 32, 32)
    end
end)

--Pervent all inputs
hook_event(HOOK_BEFORE_MARIO_UPDATE, function (m)
    if BootupTimer >= 150 then return end
    m.controller.rawStickY = 0
    m.controller.rawStickX = 0
    m.controller.stickX = 0
    m.controller.stickY = 0
    m.controller.stickMag = 0
    m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
    m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
    m.controller.buttonPressed = m.controller.buttonPressed & ~L_TRIG
    m.controller.buttonDown = m.controller.buttonDown & ~L_TRIG
    m.controller.buttonPressed = m.controller.buttonPressed & ~Z_TRIG
    m.controller.buttonDown = m.controller.buttonDown & ~Z_TRIG
    m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~B_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~B_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~X_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~X_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~Y_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~Y_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~START_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~START_BUTTON
end)

function on_reload_command()
    BootupTimer = 0
    BootupInfo = "Reloading"
    return true
end

function network_has_permissions()
    if network_is_server() or network_is_moderator() or network_is_squishy() or network_is_developer() then
        return true
    else
        return false
    end
end