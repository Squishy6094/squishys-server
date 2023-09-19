-- Heavy optimization, I want this bitch to run clean
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_set_font = djui_hud_set_font
local djui_hud_print_text = djui_hud_print_text
local djui_hud_measure_text = djui_hud_measure_text
local djui_hud_render_texture_tile = djui_hud_render_texture_tile
local djui_hud_get_screen_width = djui_hud_get_screen_width
local djui_hud_get_screen_height = djui_hud_get_screen_height
local get_texture_info = get_texture_info

local math_floor = math.floor

BootupTimer = 0
BootupInfo = BOOTUP_INITALIZING

-- Initialization
print("Connected to Server Successfully!")
discordID = network_discord_id_from_local_index(0)

if network_is_server() then
    gGlobalSyncTable.RoomStart = get_time()
    gGlobalSyncTable.event = "Default"
    gGlobalSyncTable.shutdownTimer = nil
end

local opacity = 255

-- Omega
local THIRD = 1/3
local TWENTYSIXFIFTEENTH = 26/15
local NOW_LOADING = "Now loading..."

local TEX_THEME_DEFAULT = get_texture_info("theme-default")
local TEX_SS_LOADING = get_texture_info("ssLoading")

local get_boot_info = {
    [BOOTUP_INITALIZING] = "Initalizing",
    [BOOTUP_RELOADING] = "Reloading",
    [BOOTUP_LOADED_CUSTOM_HUD_DATA] = "Loaded custom hud data",
    [BOOTUP_LOADED_MENU_DATA] = "Loaded menu data",
    [BOOTUP_FINISHED_MENU_SETUP] = "Finished menu setup",
    [BOOTUP_LOADED_THEME_DATA] = "Loaded theme data",
    [BOOTUP_LOADED_NAME_2_MODEL_DATA] = "Loaded name-2-model data"
}

local function boot_hud_render()
    if BootupTimer < 150 then
        BootupTimer = BootupTimer + 1
        opacity = 255
    elseif opacity > 0 then
        opacity = opacity - 3
    end

    local screen_width = djui_hud_get_screen_width()
    local half_width = screen_width * 0.5
    local screen_height = djui_hud_get_screen_height()
    local half_height = screen_height * 0.5
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(0, 0, 0, opacity)
    djui_hud_render_rect(0, 0, screen_width + 5, screen_width + 5)
    djui_hud_set_color(255, 255, 255, opacity)
    djui_hud_render_rect(0, screen_height - 5, ((screen_width + 5) / 150) * BootupTimer, 10)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_print_text(NOW_LOADING, half_width - djui_hud_measure_text(NOW_LOADING) * 0.5, 30, 1)
    if BootupInfo then
        local bootup_info_text = get_boot_info[BootupInfo]
        djui_hud_print_text(bootup_info_text, half_width - djui_hud_measure_text(bootup_info_text) * 0.35, screen_height - 30, 0.7)
    end
    djui_hud_set_color(0, 131, 0, opacity)
    djui_hud_render_texture_tile(TEX_THEME_DEFAULT, half_width - 106, half_height - 30, THIRD, TWENTYSIXFIFTEENTH, 0, 206, 176, 50)

    djui_hud_set_color(255, 255, 255, opacity)
    if opacity > 0 then
        djui_hud_render_texture_tile(TEX_SS_LOADING, screen_width - 40, screen_height - 40, 1, 1, (math_floor(BootupTimer * 0.1) * 32) % 128, 0, 32, 32)
    end
end

-- Prevent all inputs while booting
---@param m MarioState
local function boot_before_mario_update(m)
    if BootupTimer >= 150 or m.playerIndex ~= 0 then return end
    m.controller.rawStickY = 0
    m.controller.rawStickX = 0
    m.controller.stickX = 0
    m.controller.stickY = 0
    m.controller.stickMag = 0
    m.controller.buttonPressed = 0
    m.controller.buttonDown = 0
end

hook_event(HOOK_ON_HUD_RENDER, boot_hud_render)
hook_event(HOOK_BEFORE_MARIO_UPDATE, boot_before_mario_update)

function on_reload_command()
    BootupTimer = 0
    BootupInfo = BOOTUP_RELOADING
    return true
end