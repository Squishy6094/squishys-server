-- name: Weather Cycle
-- description: \\#00ffff\\Weather Cycle v1.2.1\\#ffffff\\\n\nThis mod features wind, rain, thunderstorms, blizzards and sandstorms! Not only do they alter the game's atmosphere in different ways, they also alter your gameplay in various ways such as slippery ground when raining, lightning bolts to avoid, dust you shouldn't inhale... And more!\n\nMod made by \\#2b0013\\Floralys\\#ffffff\\ and special thanks to \\#ec7731\\ Agent X\\#ffffff\\ for helping with fixing an annoying glitch that disabled warps (v1.0).

local particle = get_texture_info("rain") -- i spent approximatively 30 seconds on that texture
local sand_spot = get_texture_info("sand")
gGlobalSyncTable.is_raining = false
gGlobalSyncTable.sandstorm = false
gGlobalSyncTable.blizzard = false
gGlobalSyncTable.thunderstorm = false
gGlobalSyncTable.timer = 0
gGlobalSyncTable.sand_timer = 0
gGlobalSyncTable.snow_timer = 0
gGlobalSyncTable.wind_timer = 0

local should_be_thunderstorm = 0
local thunder_sound = audio_stream_load("thunder.mp3")
gGlobalSyncTable.do_thunder = 0
gGlobalSyncTable.lightning_struck = false
gGlobalSyncTable.thunder_strike = false
local decided = false
gGlobalSyncTable.thunder_x = 0
gGlobalSyncTable.thunder_y = 0
gGlobalSyncTable.thunder_z = 0
gGlobalSyncTable.windy = false
local wind = audio_stream_load("wind.mp3")
local wind_tex = get_texture_info("wind")
local wind_tex2 = get_texture_info("wind2")
local wind_compatible = false
gGlobalSyncTable.wind_orient = 1

local rain_start = 1290
local rain_end = 2880
local sandstorm_start = 2880
local sandstorm_end = 4170
local blizzard_start = 645
local blizzard_end = 1935
local compatible = true
local opacity = 0

local menu_bg = get_texture_info("menubg")
local menu = false
local optionHover = 1

local menuOptions = {
    [1] = {
        name = "Rain",
        status = 0,
        statusMax = 1,
        statusDefault = 0,
        statusNames = {},
        description = {
            [1] = "Rain provides a moody ambience, and also",
            [2] = "alters your gameplay by making things more",
            [3] = "slippery and putting fire out!",
            [4] = "[Available to most courses]"
        }
    },
    [2] = {
        name = "Thunderstorm",
        status = 0,
        statusMax = 1,
        statusDefault = 0,
        statusNames = {},
        description = {
            [1] = "Thunderstorms are as spooky as they sound.",
            [2] = "You better watch out! These can hurt and",
            [3] = "they also come with rain enabled!",
            [4] = "[Available to any course with rain]"
        }
    },
    [3] = {
        name = "Blizzard",
        status = 0,
        statusMax = 1,
        statusDefault = 0,
        statusNames = {},
        description = {
            [1] = "Brrr! It's FREEZING here! You should",
            [2] = "seriously not stay here, it's so cold it hurts",
            [3] = "you and it's really breezy!",
            [4] = "[Exclusive to CCM and SL]"
        }
    },
    [4] = {
        name = "Sandstorm",
        status = 0,
        statusMax = 1,
        statusDefault = 0,
        statusNames = {},
        description = {
            [1] = "Cough, cough.. Ugh, I think I got sand in",
            [2] = "my airways.. And it's also harder to see.",
            [3] = "But oddly enough, the level looks beautiful.",
            [4] = "[Exclusive to SSL]"
        }
    },
    [5] = {
        name = "Windy",
        status = 0,
        statusMax = 1,
        statusDefault = 0,
        statusNames = {},
        description = {
            [1] = "A nice, chill little breeze with a relaxing",
            [2] = "sound to it. Sometimes, it's easier to",
            [3] = "appreciate simpler things.",
            [4] = "[Available to most courses]"
        }
    }
}

for i = 1, #menuOptions do
    if menuOptions[i].statusNames[menuOptions[i].status] == nil then
        menuOptions[i].statusNames[0] = "Disabled"
        menuOptions[i].statusNames[1] = "Enabled"
    end
end

if network_is_server() then
    if _G.ssExists then
        djui_popup_create("\\#00ffff\\[Weather Cycle]\\#ffffff\\\nAs the host, you have access to the\nWeather Cycle menu.\nAccess it via the External Tab", 4)
    else
        djui_popup_create("\\#00ffff\\[Weather Cycle]\\#ffffff\\\nAs the host, you have access to the\nWeather Cycle menu.\nAccess it by typing '/weather menu'\nor by pressing L!", 5)
    end
end

-- Which levels rain does not wish to visit
local not_compatible = {
    COURSE_CCM, COURSE_HMC, COURSE_VCUTM, COURSE_SL, COURSE_TTC, COURSE_COTMC, COURSE_SSL, COURSE_LLL, COURSE_BITFS, COURSE_PSS, COURSE_SA
}

-- Respecfully, GO FUCK YOURSELVES. I hate EVERY SINGLE ONE OF YOU. Your lives are NOTHING. You serve ZERO PURPOSE. You should kill yourselves, NOW!
local ignored_surfaces = {
    SURFACE_BURNING, SURFACE_QUICKSAND, SURFACE_INSTANT_QUICKSAND, SURFACE_INSTANT_MOVING_QUICKSAND, SURFACE_DEEP_MOVING_QUICKSAND, SURFACE_INSTANT_QUICKSAND, SURFACE_DEEP_QUICKSAND, SURFACE_SHALLOW_MOVING_QUICKSAND,
    SURFACE_SHALLOW_QUICKSAND, SURFACE_WARP, SURFACE_LOOK_UP_WARP, SURFACE_WOBBLING_WARP, SURFACE_INSTANT_WARP_1B, SURFACE_INSTANT_WARP_1C, SURFACE_INSTANT_WARP_1D, SURFACE_INSTANT_WARP_1E
}

local no_wind_courses = {
    LEVEL_HMC, LEVEL_DDD, LEVEL_VCUTM, LEVEL_COTMC, LEVEL_SA, LEVEL_PSS, LEVEL_WDW, LEVEL_CASTLE, LEVEL_TTC
}

-- The Agent X trick to improve performance
local djui_hud_get_screen_width = djui_hud_get_screen_width
local djui_hud_get_screen_height = djui_hud_get_screen_height
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_color = djui_hud_set_color
local djui_hud_set_render_behind_hud = djui_hud_set_render_behind_hud
local djui_hud_render_rect = djui_hud_render_rect
local set_override_skybox = set_override_skybox
local djui_hud_render_texture = djui_hud_render_texture
local play_sound = play_sound
local get_skybox = get_skybox
local network_is_server = network_is_server
local djui_hud_print_text = djui_hud_print_text

local show_x = 0
local function on_hud_render()
    local resx = djui_hud_get_screen_width()
    local resy = djui_hud_get_screen_height()
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_render_behind_hud(true)

    local r = 0
    local g = 0
    local b = 0
    local a = 0

    if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil then
        return
    end

    if gGlobalSyncTable.windy and wind_compatible and gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE then
        if gNetworkPlayers[0].currAreaIndex == 2 then
            if gNetworkPlayers[0].currCourseNum == COURSE_THI then
                wind_compatible = true
            else
                wind_compatible = false
            end
        end
        if gMarioStates[0].pos.y >= (gMarioStates[0].waterLevel - 350) then
            if not gGlobalSyncTable.is_raining then
                show_x = 500
            else
                show_x = 100
            end
            for j = 0, show_x do
                djui_hud_set_color(math.random(128, 255), math.random(128, 255), math.random(128, 255), math.random(0, 32))
                if gGlobalSyncTable.wind_orient == 1 then
                    djui_hud_render_texture(wind_tex, math.random(resx), math.random(resy), 2, 0.5)
                elseif gGlobalSyncTable.wind_orient == 2 then
                    djui_hud_render_texture(wind_tex2, math.random(resx), math.random(resy), 2, 0.5)
                end
            end
            audio_stream_play(wind, false, 4)
        else
            audio_stream_stop(wind)
        end
    else
        audio_stream_stop(wind)
    end
    if gGlobalSyncTable.is_raining and compatible then -- If it's raining and you're in a level the rain is willing to visit
        --djui_hud_set_color(255, 255, 255, 255)
        --djui_hud_print_text("Britain", (resx/10), (resy/50), 1)
        if gGlobalSyncTable.thunderstorm then
            set_lighting_dir(1, -1)
            r, g, b, a = 0, 0, 0, 186
            djui_hud_set_color(255, 255, 255, opacity)
            djui_hud_render_rect(0, 0, resx, resy)
            if not gGlobalSyncTable.thunder_strike then
                if opacity > 196 then
                    set_lighting_dir(1, (0.001 * opacity))
                end
                if opacity > 0 then
                    opacity = opacity - 2.5
                end
            else
                set_lighting_dir(1, -1)
            end
            if gGlobalSyncTable.thunder_strike then
                opacity = 255
                audio_stream_play(thunder_sound, false, 2)
                gGlobalSyncTable.thunder_strike = false
            end
        else
            r, g, b, a = 64, 64, 64, 150
        end
        djui_hud_set_color(r, g, b, a)
        djui_hud_render_rect(0, 0, resx, resy)
        if gGlobalSyncTable.thunderstorm then
            djui_hud_set_color(128, 255, 255, math.random(0,128))
        else
            djui_hud_set_color(128, 255, 255, math.random(0,255))
        end
        if gGlobalSyncTable.thunderstorm then
            set_override_skybox(9)
        else
            set_override_skybox(4)
        end
        if gMarioStates[0].pos.y >= (gMarioStates[0].waterLevel - 350) then
            djui_hud_set_rotation(math.sin(gMarioStates[0].area.camera.yaw/2)*0x1000, 0, 0)
            for i = 0, 500 do
                djui_hud_render_rect(math.random(resx), math.random(resy), 1, math.random(6, 18))
            end
            djui_hud_set_rotation(0, 0, 0)
        end
    else -- If it's sunny or the rain doesn't want to come to you then nothing changes lmao
        if gGlobalSyncTable.sandstorm and gNetworkPlayers[0].currCourseNum == COURSE_SSL then
            if gNetworkPlayers[0].currAreaIndex ~= 2 then
                set_lighting_dir(1, -1)
                djui_hud_set_color(158, 92, 49, 150)
                djui_hud_set_render_behind_hud(true)
                djui_hud_render_rect(0, 0, 3000, 3000)
                set_override_skybox(1)
                djui_hud_set_color(255, 255, 255, 8)
                for j = 0, 500 do
                    djui_hud_render_texture(sand_spot, math.random(resx), math.random(resy), 0.1, 0.1)
                end
            end
        else
            if gGlobalSyncTable.blizzard then
                if gNetworkPlayers[0].currCourseNum == COURSE_CCM or gNetworkPlayers[0].currCourseNum == COURSE_SL then
                    if gNetworkPlayers[0].currAreaIndex ~= 2 then
                        djui_hud_set_color(255, 255, 255, 186)
                        djui_hud_set_render_behind_hud(true)
                        djui_hud_render_rect(0, 0, resx, resy)
                        set_override_skybox(4)
                        set_lighting_dir(1, -1)
                    end
                else
                    local skybox = get_skybox()
                    set_override_skybox(skybox)
                    set_lighting_dir(1, 0)
                end
            else
                local skybox = get_skybox()
                set_override_skybox(skybox)
                set_lighting_dir(1, 0)
                return
            end
        end
    end
end

local timer = 0
local walk_timer = 0
local thunder_timer = 0
---@param m MarioState
local function mario_update(m)
    if network_is_server() then -- Timer only increases for the host - ensures rain syncing
        timer = timer + 1
        thunder_timer = thunder_timer + 1
        if timer >= 480 then
            gGlobalSyncTable.timer = gGlobalSyncTable.timer + 1
            gGlobalSyncTable.sand_timer = gGlobalSyncTable.sand_timer + 1
            gGlobalSyncTable.snow_timer = gGlobalSyncTable.snow_timer + 1
            gGlobalSyncTable.wind_timer = gGlobalSyncTable.wind_timer + 1
            timer = 0
        end
        if not decided then
            should_be_thunderstorm = math.random(0, 5)
            decided = true
        end
        if gGlobalSyncTable.thunderstorm then
            if gGlobalSyncTable.timer % 15 == 0 then
                gGlobalSyncTable.do_thunder = math.random(0, 333)
            end
        end
        if gGlobalSyncTable.thunder_strike then
            gGlobalSyncTable.thunder_x = math.random(-8200, 8200)
            gGlobalSyncTable.thunder_z = math.random(-8200, 8200)
            gGlobalSyncTable.thunder_y = find_floor_height(gGlobalSyncTable.thunder_x, 8000, gGlobalSyncTable.thunder_z)
        end
    end
    if gGlobalSyncTable.wind_timer == 645 then
        gGlobalSyncTable.windy = true
        gGlobalSyncTable.wind_orient = math.random(1, 2)
    elseif gGlobalSyncTable.wind_timer >= 1290 then
        gGlobalSyncTable.windy = false
        gGlobalSyncTable.wind_orient = 0
        gGlobalSyncTable.wind_timer = 0
    end
    if gGlobalSyncTable.timer == rain_start then -- also ensures rain syncing
        gGlobalSyncTable.is_raining = true
    end
    if gGlobalSyncTable.timer == rain_end then
        gGlobalSyncTable.is_raining = false
        gGlobalSyncTable.thunderstorm = false
        gGlobalSyncTable.timer = 0
        decided = false
    end
    if gGlobalSyncTable.sand_timer == sandstorm_start then
        gGlobalSyncTable.sandstorm = true
    end
    if gGlobalSyncTable.sand_timer == sandstorm_end then
        gGlobalSyncTable.sandstorm = false
        gGlobalSyncTable.sand_timer = 0
    end
    if gGlobalSyncTable.snow_timer == blizzard_start then
        gGlobalSyncTable.blizzard = true
    end
    if gGlobalSyncTable.snow_timer == blizzard_end then
        gGlobalSyncTable.blizzard = false
        if gGlobalSyncTable.snow_timer >= 2580 then
            gGlobalSyncTable.snow_timer = 0
        end
    end
    if gGlobalSyncTable.is_raining then
        if should_be_thunderstorm == 4 then
            gGlobalSyncTable.thunderstorm = true
        end
    end
    if gGlobalSyncTable.thunderstorm and compatible then
        if gGlobalSyncTable.do_thunder == 77 then
            gGlobalSyncTable.thunder_strike = true
        end
    end
    if gGlobalSyncTable.thunder_strike then
        if not gGlobalSyncTable.lightning_struck then
            spawn_sync_object(id_bhvBowserBombExplosion, E_MODEL_EXPLOSION, gGlobalSyncTable.thunder_x, gGlobalSyncTable.thunder_y, gGlobalSyncTable.thunder_z, function()end)
            spawn_sync_object(id_bhvBowserShockWave, E_MODEL_BOWSER_WAVE, gGlobalSyncTable.thunder_x, gGlobalSyncTable.thunder_y, gGlobalSyncTable.thunder_z, function()end)
            cur_obj_shake_screen(SHAKE_POS_LARGE)
            gGlobalSyncTable.lightning_struck = true
        end
    else
        gGlobalSyncTable.lightning_struck = false
    end
    if gGlobalSyncTable.timer == 0 then
        decided = false
    end
    if gGlobalSyncTable.blizzard then
        if gNetworkPlayers[0].currCourseNum == COURSE_CCM or gNetworkPlayers[0].currCourseNum == COURSE_SL then
            if gNetworkPlayers[0].currAreaIndex ~= 2 then
                if m.health > 260 then
                    m.health = m.health - 3
                end
                for i = 0, 10 do
                    spawn_non_sync_object(id_bhvTweesterSandParticle, E_MODEL_WHITE_PARTICLE_SMALL, math.random(-8200,8200), math.random(-8200,8200), math.random(-8200,8200), function()end)
                end
                play_sound(SOUND_ENV_WIND1, m.marioObj.header.gfx.cameraToObject)
                set_override_envfx(ENVFX_SNOW_BLIZZARD)
            else
                set_override_envfx(-1)
            end
        else
            set_override_envfx(-1)
        end
    end
    if gGlobalSyncTable.sandstorm and gNetworkPlayers[0].currCourseNum == COURSE_SSL then
        if gNetworkPlayers[0].currAreaIndex ~= 2 then
            if m.health > (256 * 3) then
                m.health = m.health - 1
            end
            for i = 0, 5 do
                spawn_non_sync_object(id_bhvTweesterSandParticle, E_MODEL_SAND_DUST, math.random(-8200,8200), math.random(-8200,8200), math.random(-8200,8200), function()end)
            end
            play_sound(SOUND_ENV_WIND1, m.marioObj.header.gfx.cameraToObject)
            if m.action == ACT_IDLE then
                m.action = ACT_COUGHING
            end
        end
    end
    for i = 0, 11 do -- checks if you're in one of those despised levels
        if gNetworkPlayers[0].currCourseNum == not_compatible[i] then
            compatible = false
            return
        else
            if gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE then
                compatible = false
                return
            else
                if gNetworkPlayers[0].currCourseNum == COURSE_TTM and gNetworkPlayers[0].currAreaIndex == 2 then
                    compatible = false
                    return
                else
                    compatible = true
                end
            end
        end
    end
    if gGlobalSyncTable.is_raining and compatible then -- Water footsteps, rain sounds, slippery floor (caution), water particles and fire extinguishment
        walk_timer = walk_timer + 1
        if m.action == ACT_WALKING then
            if walk_timer % 5 == 0 then
                play_sound(SOUND_OBJ_WALKING_WATER, m.marioObj.header.gfx.cameraToObject)
                spawn_sync_object(id_bhvWaterDropletSplash, E_MODEL_SMALL_WATER_SPLASH, m.pos.x, m.pos.y, m.pos.z, function()end)
            end
        end
        if m.action == ACT_BURNING_GROUND or m.action == ACT_BURNING_FALL or m.action == ACT_BURNING_JUMP then
            m.action = ACT_WALKING
            play_sound(SOUND_GENERAL_FLAME_OUT, m.marioObj.header.gfx.cameraToObject)
        end
        play_sound(SOUND_ENV_WATERFALL1, m.marioObj.header.gfx.cameraToObject)
        if walk_timer > 1000 then
            walk_timer = 0
        end
    end
    if not gGlobalSyncTable.blizzard then
        set_override_envfx(-1)
    end
    if gGlobalSyncTable.windy then
        wind_compatible = true
        for i = 0, #no_wind_courses do
            if gNetworkPlayers[0].currLevelNum == no_wind_courses[i] then
                wind_compatible = false
            end
        end
        if gGlobalSyncTable.blizzard then
            if gNetworkPlayers[0].currLevelNum == LEVEL_CCM or gNetworkPlayers[0].currLevelNum == LEVEL_SL then
                wind_compatible = false
            end
        end
        if gGlobalSyncTable.sandstorm then
            if gNetworkPlayers[0].currLevelNum == LEVEL_SSL then
                wind_compatible = false
            end
        end
    end

    if gGlobalSyncTable.is_raining then
        menuOptions[1].status = 1
    else
        menuOptions[1].status = 0
    end
    if gGlobalSyncTable.thunderstorm then
        menuOptions[2].status = 1
    else
        menuOptions[2].status = 0
    end
    if gGlobalSyncTable.blizzard then
        menuOptions[3].status = 1
    else
        menuOptions[3].status = 0
    end
    if gGlobalSyncTable.sandstorm then
        menuOptions[4].status = 1
    else
        menuOptions[4].status = 0
    end
    if gGlobalSyncTable.windy then
        menuOptions[5].status = 1
    else
        menuOptions[5].status = 0
    end
end

---@param m MarioState
local function before_mario_update(m)
    if gGlobalSyncTable.is_raining and compatible then
        if gNetworkPlayers[0].currLevelNum == LEVEL_BITS and gNetworkPlayers[0].currAreaIndex == 1 then
            return
        end
        for i = 0, 16 do
            if m.floor.type ~= ignored_surfaces[i] then
                if m.floor.type ~= SURFACE_DEATH_PLANE and m.floor.type ~= SURFACE_VERTICAL_WIND then -- YOU TOO. You thought I'd forget? NO. I HATE YOU. KILL YOURSELVES.
                    m.floor.type = SURFACE_SLIPPERY
                end
            end
        end
        if m.action == ACT_GROUND_POUND_LAND then
            play_sound(SOUND_OBJ_DIVING_INTO_WATER, m.marioObj.header.gfx.cameraToObject)
            spawn_sync_object(id_bhvWaterDropletSplash, E_MODEL_SMALL_WATER_SPLASH, m.pos.x, m.pos.y, m.pos.z, function()end)
        end
    end
    if gGlobalSyncTable.blizzard then
        if gNetworkPlayers[0].currCourseNum == COURSE_CCM or gNetworkPlayers[0].currCourseNum == COURSE_SL then
            if gNetworkPlayers[0].currAreaIndex ~= 2 then
                for j = 0, 16 do
                    if m.floor.type ~= ignored_surfaces[j] then
                        if m.floor.type ~= SURFACE_DEATH_PLANE and m.floor.type ~= SURFACE_VERTICAL_WIND then
                            m.floor.type = SURFACE_HORIZONTAL_WIND
                        end
                    end
                end
            end
        end
    end
end

local sliding = 200
local function render_menu()
    djui_hud_set_render_behind_hud(false)
    djui_hud_set_resolution(RESOLUTION_N64)

    if network_is_server() then
        if gMarioStates[0].controller.buttonPressed & L_TRIG ~= 0 and not _G.ssExists then
            if menu then play_sound(SOUND_MENU_MESSAGE_APPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject) end
            if not menu then play_sound(SOUND_MENU_MESSAGE_DISAPPEAR, gMarioStates[0].marioObj.header.gfx.cameraToObject) end
            menu = not menu
        end
    end

    if menu then
        if sliding > 15 then
            sliding = sliding - 6
        elseif sliding > 6 then
            sliding = sliding - 3
        elseif sliding > 0 then
            sliding = sliding - 1
        else
            sliding = 0
        end
    else
        if sliding <= 6 then
            sliding = sliding + 1
        elseif sliding < 15 then
            sliding = sliding + 3
        elseif sliding <= 200 then
            sliding = sliding + 6
        else
            sliding = 200
        end
    end

    if menu or sliding >= 0 then -- 124 154
        djui_hud_set_color(255, 255, 255, 255)
        --djui_hud_render_rect(20 - sliding, 50, 120, 150)
        djui_hud_render_texture_tile(menu_bg, 18 - sliding, 48, 1.24, 1, 0, 0, 124, 154)
        djui_hud_set_color(0, 0, 0, 192)
        djui_hud_render_rect(25 - sliding, 160, 110, 36)
        djui_hud_render_rect(22 - sliding, 87, 116, (14.1 * #menuOptions))
        djui_hud_set_color(0, 0, 0, 128)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_print_text("Press L to close the menu!", 58.25 - sliding, 202.75, 0.2)
        djui_hud_set_font(FONT_MENU)
        djui_hud_print_text("Weather", 54 - sliding, 56, 0.25)
        djui_hud_print_text("Cycle", 64 - sliding, 66, 0.25)
        djui_hud_print_text("-", 29 - sliding, 51, 0.6)
        djui_hud_print_text("-", 111 - sliding, 51, 0.6)
        djui_hud_set_color(0, 255, 255, 255)
        djui_hud_print_text("Weather", 53 - sliding, 55, 0.25)
        djui_hud_print_text("Cycle", 63 - sliding, 65, 0.25)
        djui_hud_print_text("-", 28 - sliding, 50, 0.6)
        djui_hud_print_text("-", 110 - sliding, 50, 0.6)

        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text("Press L to close the menu!", 58 - sliding, 202.5, 0.2)
        for i = 1, #menuOptions do
            djui_hud_set_color(32, 32, 32, 128)
            djui_hud_render_rect(22.5 - sliding, 73.5 + (i * 14), 115, 13.5)
            if optionHover == i then
                djui_hud_set_color(128, 128, 128, 128)
                djui_hud_render_rect(24 - sliding, 75.25 + (i * 14), 112, 10)
            else
                djui_hud_set_color(64, 64, 64, 128)
                djui_hud_render_rect(24 - sliding, 75.25 + (i * 14), 112, 10)
            end
            djui_hud_set_color(0, 0, 0, 128)
            djui_hud_print_text(menuOptions[i].name, 25.5 - sliding, 75.5 + (i * 14), 0.3)
            djui_hud_print_text(menuOptions[i].statusNames[menuOptions[i].status], 113.5 - sliding, 75.5 + (i * 14), 0.3)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(menuOptions[i].name, 25 - sliding, 75 + (i * 14), 0.3)
            for j = 1, #menuOptions[optionHover].description do
                djui_hud_set_color(0, 0, 0, 128)
                djui_hud_print_text(tostring(menuOptions[optionHover].description[j]), 30.5 - sliding, 156.5 + (j * 7), 0.25)
                if j == 4 then
                    djui_hud_set_color(255, 255, 0, 255)
                else
                    djui_hud_set_color(255, 255, 255, 255)
                end
                djui_hud_print_text(tostring(menuOptions[optionHover].description[j]), 30 - sliding, 156 + (j * 7), 0.25)
            end
            if menuOptions[i].status == 0 then
                djui_hud_set_color(255, 0, 0, 255)
            elseif menuOptions[i].status == 1 then
                djui_hud_set_color(0, 255, 0, 255)
            end
            djui_hud_print_text(menuOptions[i].statusNames[menuOptions[i].status], 113 - sliding, 75 + (i * 14), 0.3)
        end
    end
end

local function menu_changes(m)
    if menu and network_is_server() and sliding < 15 then
        if m.controller.buttonPressed & D_JPAD ~= 0 then
            optionHover = optionHover + 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
        end
        if m.controller.buttonPressed & U_JPAD ~= 0 then
            optionHover = optionHover - 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
        end
        if optionHover > #menuOptions then optionHover = 1 end
        if optionHover < 1 then optionHover = #menuOptions end
        
        if m.controller.buttonPressed & A_BUTTON ~= 0 then
            play_sound(SOUND_MENU_CLICK_FILE_SELECT, m.marioObj.header.gfx.cameraToObject)
            if menuOptions[optionHover].status > 0 then
                menuOptions[optionHover].status = 0
            else
                menuOptions[optionHover].status = menuOptions[optionHover].status + 1
            end

            if menuOptions[1].status == 1 then
                should_be_thunderstorm = 0
                gGlobalSyncTable.is_raining = true
                gGlobalSyncTable.timer = 1291
            else
                should_be_thunderstorm = 0
                gGlobalSyncTable.is_raining = false
                gGlobalSyncTable.timer = 0
            end
            if menuOptions[2].status == 1 then
                gGlobalSyncTable.is_raining = true
                gGlobalSyncTable.timer = 1291
                gGlobalSyncTable.thunderstorm = true
            else
                gGlobalSyncTable.thunderstorm = false
            end
            if menuOptions[3].status == 1 then
                gGlobalSyncTable.blizzard = true
                gGlobalSyncTable.snow_timer = 646
            else
                gGlobalSyncTable.blizzard = false
                gGlobalSyncTable.snow_timer = 0
            end
            if menuOptions[4].status == 1 then
                gGlobalSyncTable.sandstorm = true
                gGlobalSyncTable.sand_timer = 2881
            else
                gGlobalSyncTable.sandstorm = false
                gGlobalSyncTable.sand_timer = 0
            end
            if menuOptions[5].status == 1 then
                gGlobalSyncTable.wind_timer = 645
                gGlobalSyncTable.windy = true
            else
                gGlobalSyncTable.wind_timer = 0
                gGlobalSyncTable.windy = false
            end
        end

        if m.controller.buttonPressed & B_BUTTON ~= 0 and _G.ssExists then
            menu = false
        end

        m.controller.buttonPressed = m.controller.buttonPressed & ~U_JPAD
        m.controller.buttonPressed = m.controller.buttonPressed & ~D_JPAD
        m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
        m.controller.buttonPressed = m.controller.buttonPressed & ~B_BUTTON
    end
end

local function weather(msg)
    msg = string.lower(msg)
    if network_is_server() then
        if msg == "menu" then
            menu = true
            if _G.ssExists then
                _G.ssApi.menu_open(false)
            end
            return true
        end
        return true
    else
        djui_chat_message_create("This command is exclusive to the host.")
        return true
    end
end

local function softlock() -- /respawn (you die. like, seriously. you die.)
    gMarioStates[0].health = 0
    gMarioStates[0].numLives = gMarioStates[0].numLives + 1
    return true
end

local ss_update = function()
    if not _G.ssBooted then return end
    if _G.ssApi.option_read("Weather Menu") == 1 then
        weather("menu")
        _G.ssApi.option_write("Weather Menu", 0)
    end 
    if _G.ssApi.option_read("Respawn") == 1 then
        softlock()
        _G.ssApi.option_write("Respawn", 0)
    end 
end

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_HUD_RENDER, render_menu)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_BEFORE_MARIO_UPDATE, menu_changes)

if _G.ssExists then
    _G.ssApi.option_add("Weather Menu", 0, 1, {[0] = "", [1] = ""}, {
        "Open the Weather Cycle menu",
        "using this command.",
        "Host Only",
    })
    
    _G.ssApi.option_add("Respawn", 0, 1, {[0] = "", [1] = ""}, {
        "If you ever end up permanently",
        "stuck while sliding, use this.",
        "Or if you just want to die..."
    })

    hook_event(HOOK_MARIO_UPDATE, ss_update)
else
    hook_chat_command("weather", "menu -\\#00ffff\\ [Weather Cycle]\\#ffffff\\ Open the Weather Cycle menu using this command. \\#ffff00\\[Host Command]", weather)
    hook_chat_command("respawn", "- \\#00ffff\\[Weather Cycle]\\#ffffff\\ If you ever end up permanently stuck while sliding, use this. Or if you just want to die...", softlock)
end

-- v1.1.3 changes: SS Cross Support + Optimizations(?)
-- v1.1.2 changes: improved visual effects for blizzards and thunderstorms
-- v1.2 concept: windy weather state, need to figure out how to get certain particles to appear as intended
-- v1.2 changes: windy state + weather cycle menu