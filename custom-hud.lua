-- Optimizations
local obj_get_nearest_object_with_behavior_id = obj_get_nearest_object_with_behavior_id
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_texture = djui_hud_render_texture
local djui_hud_set_rotation = djui_hud_set_rotation
local djui_hud_get_screen_width = djui_hud_get_screen_width
local djui_hud_get_screen_height = djui_hud_get_screen_height
local djui_hud_render_texture_tile = djui_hud_render_texture_tile
local djui_hud_print_text = djui_hud_print_text
local tostring = tostring
local djui_hud_set_adjusted_color = djui_hud_set_adjusted_color
local s16 = s16
local atan2s = atan2s
local vec3f_dist = vec3f_dist
local djui_hud_set_font = djui_hud_set_font
local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_render_rect = djui_hud_render_rect
local hud_hide = hud_hide
local obj_get_first_with_behavior_id = obj_get_first_with_behavior_id
local djui_hud_set_render_behind_hud = djui_hud_set_render_behind_hud
local get_dialog_id = get_dialog_id
local hud_render_power_meter = hud_render_power_meter
local ipairs = ipairs
local obj_get_nearest_objects_from_set = obj_get_nearest_objects_from_set

local math_floor = math.floor
local string_format = string.format

local TEX_ICONS = get_texture_info("icons")
local TEX_BACK = get_texture_info("back")
local TEX_CAMERA_DIAL = get_texture_info("camera-dial")
local TEX_PLAYER_DIAL = get_texture_info("player-dial")
local TEX_SECRET = get_texture_info("secret")
local TEX_WARIO_BAG = get_texture_info("wario-bag")
local TEX_WWHEART = get_texture_info("wwHeart")

local AUDIO_EXCELLENT = audio_stream_load("EXCELLENT.mp3")

-- For compass use
local find_stars = {
    [id_bhvSpawnedStar] = true,
    [id_bhvSpawnedStarNoLevelExit] = true,
    [id_bhvStarSpawnCoordinates] = true,
    [id_bhvStar] = true
}

local HUD_ELEMENT_VANILLA_LIVES = 0
local HUD_ELEMENT_VANILLA_COINS = 1
local HUD_ELEMENT_VANILLA_STARS = 2
local HUD_ELEMENT_VANILLA_HEALTH = 3
local HUD_ELEMENT_PSC_RED_STARS = 4
local HUD_ELEMENT_PSC_GREEN_STARS = 5
local HUD_ELEMENT_MISC_COMPASS = 6

local HUD_SETTING_DEFAULT = 0
local HUD_SETTING_43_LOCKED = 1
local HUD_SETTING_COMPACT = 2
local HUD_SETTING_DISABLED = 3

local MENU_TABS = {
    movement = 1,
    hud = 2,
    camera = 3,
    misc = 4
}

local MENU_TAB_HUD = {
    hudType = 1,
    clashing = 2,
    theme = 3,
    descriptions = 4,
    animations = 5,
    timer = 6,
}

local currHUD = 1
local hudTable = {}
local HUD_TABLE_MAX = 0

---@param element number
---@param number number
---@param icon TextureInfo
---@param m MarioState Exists since it would be faster to pass in a MarioState rather than create a new one
local function djui_hud_render_element(element, number, icon, m)
    local r = 255
    local g = 255
    local b = 255
    local o = 255

    local hud_element_part = hudTable[currHUD][element]
    local color = hud_element_part.color
    if color then
        r = color.r
        g = color.g
        b = color.b
        o = color.o
    end

    local iconR = r
    local iconG = g
    local iconB = b
    local iconO = o

    local icon_color = hud_element_part.iconColor
    if icon_color then
        iconR = icon_color.r
        iconG = icon_color.g
        iconB = icon_color.b
        iconO = icon_color.o
    end

    local scale = 1
    if hud_element_part.scale then
        scale = hud_element_part.scale
    end

    local xAlign = djui_hud_get_screen_width() * 0.5 * hud_element_part.alignment.x
    local yAlign = djui_hud_get_screen_height() * 0.5 * hud_element_part.alignment.y

    local iconX = hud_element_part.iconOffset.x + xAlign
    local iconY = hud_element_part.iconOffset.y + yAlign
    local divX = hud_element_part.xOffset.x + xAlign
    local divY = hud_element_part.xOffset.y + yAlign
    local numX = hud_element_part.numOffset.x + xAlign
    local numY = hud_element_part.numOffset.y + yAlign

    djui_hud_set_adjusted_color(iconR, iconG, iconB, iconO)
    if hud_element_part.shownElements.icon then
        if element == HUD_ELEMENT_VANILLA_LIVES then
            if icon ~= "Default" then
                djui_hud_render_texture_tile(TEX_ICONS, iconX, iconY, scale, scale, (icon % 16) * 16, (math_floor(icon/16)) * 16, 16, 16)
            else
                djui_hud_render_texture(m.character.hudHeadTexture, iconX, iconY, scale, scale)
            end
        else
            djui_hud_render_texture(icon, iconX, iconY, scale, scale)
        end
    end

    djui_hud_set_adjusted_color(r, g, b, o)
    if hud_element_part.shownElements.div and not (number >= 100 and hud_element_part.hideOnTriple) then
        djui_hud_print_text("x", divX, divY, scale)
    end
    if hud_element_part.shownElements.num then
        if number >= 100 and hud_element_part.hideOnTriple then
            djui_hud_print_text(tostring(number), divX, divY, scale)
        else
            djui_hud_print_text(tostring(number), numX, numY, scale)
        end
    end
end

---@param target Object
---@param iconTexture TextureInfo
---@param scale number
---@param x number
---@param y number
---@param m MarioState Exists since it would be faster to pass in a MarioState rather than create a new one
local function render_hud_radar(target, iconTexture, scale, x, y, m)
    -- direction
    local angle = s16(atan2s(target.oPosZ - m.pos.z, target.oPosX - m.pos.x))
    local dist = vec3f_dist({ x = target.oPosX, y = target.oPosY, z = target.oPosZ }, m.pos)

    local distToScale = math_clamp(100 - math_floor(dist * 0.01), 0, 100)
    distToScale = distToScale * 0.01 * scale

    djui_hud_set_rotation(angle, 0.5 / (distToScale*scale), 2.5 / (distToScale*scale))
    djui_hud_render_texture(iconTexture, x + 4, y - 12, distToScale * 0.5 * scale, distToScale * 0.5 * scale)
    djui_hud_set_rotation(0, 0, 0)
end

local function setup_custom_hud()
    hudTable = {
        [HUD_SETTING_DEFAULT] = {
            name = "Default",
            res = RESOLUTION_N64,
            font = FONT_HUD,
            [HUD_ELEMENT_VANILLA_LIVES] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = 21, y = 15},
                xOffset = {x = 37, y = 15},
                numOffset = {x = 54, y = 15},
            },
            [HUD_ELEMENT_VANILLA_COINS] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = 8, y = 15},
                xOffset = {x = 24, y = 15},
                numOffset = {x = 38, y = 15},
            },
            [HUD_ELEMENT_VANILLA_STARS] = {
                alignment = {x = 2, y = 0},
                shownElements = {icon = true, div = true, num = true},
                hideOnTriple = true,
                iconOffset = {x = -77, y = 15},
                xOffset = {x = -61, y = 15},
                numOffset = {x = -46.8, y = 15},
            },
            [HUD_ELEMENT_PSC_RED_STARS] = {
                alignment = {x = 2, y = 0},
                shownElements = {icon = true, div = true, num = true},
                hideOnTriple = true,
                iconColor = {r = 255, g = 0, b = 0, o = 255},
                iconOffset = {x = -77, y = 33},
                xOffset = {x = -61, y = 33},
                numOffset = {x = -46.8, y = 33},
            },
            [HUD_ELEMENT_PSC_GREEN_STARS] = {
                alignment = {x = 2, y = 0},
                shownElements = {icon = true, div = true, num = true},
                hideOnTriple = true,
                iconColor = {r = 0, g = 255, b = 0, o = 255},
                iconOffset = {x = -77, y = 51},
                xOffset = {x = -61, y = 51},
                numOffset = {x = -46.8, y = 51},
            },
            [HUD_ELEMENT_MISC_COMPASS] = {
                alignment = { x = 2, y = 2 },
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 1,
                compassShow = true,
                compassOffset = {x = -52, y = -52},
            },
            [HUD_ELEMENT_VANILLA_HEALTH] = {
                alignment = { x = 1, y = 0 },
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 64,
                meterShow = true,
                meterOffset = {x = -52, y = 8},
            }
        },
        [HUD_SETTING_43_LOCKED] = {
            name = "4:3 Locked",
            res = RESOLUTION_N64,
            font = FONT_HUD,
            [HUD_ELEMENT_VANILLA_LIVES] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = -138, y = 15},
                xOffset = {x = -122, y = 15},
                numOffset = {x = -106, y = 15},
            },
            [HUD_ELEMENT_VANILLA_COINS] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = 8, y = 15},
                xOffset = {x = 24, y = 15},
                numOffset = {x = 38, y = 15},
            },
            [HUD_ELEMENT_VANILLA_STARS] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                hideOnTriple = true,
                iconOffset = {x = 83, y = 15},
                xOffset = {x = 99, y = 15},
                numOffset = {x = 113.2, y = 15},
            },
            [HUD_ELEMENT_PSC_RED_STARS] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconColor = {r = 255, g = 0, b = 0, o = 255},
                hideOnTriple = true,
                iconOffset = {x = 83, y = 33},
                xOffset = {x = 99, y = 33},
                numOffset = {x = 113.2, y = 33},
            },
            [HUD_ELEMENT_PSC_GREEN_STARS] = {
                alignment = {x = 1, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconColor = {r = 0, g = 255, b = 0, o = 255},
                hideOnTriple = true,
                iconOffset = {x = 83, y = 51},
                xOffset = {x = 99, y = 51},
                numOffset = {x = 113.2, y = 51},
            },
            [HUD_ELEMENT_MISC_COMPASS] = {
                alignment = { x = 1, y = 2 },
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 1,
                compassShow = true,
                compassOffset = {x = 108, y = -52},
            },
            [HUD_ELEMENT_VANILLA_HEALTH] = {
                alignment = { x = 1, y = 0 },
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 64,
                meterShow = true,
                meterOffset = {x = -52, y = 8},
            }
        },
        [HUD_SETTING_COMPACT] = {
            name = "Compact",
            res = RESOLUTION_N64,
            font = FONT_HUD,
            [HUD_ELEMENT_VANILLA_LIVES] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = false, num = true},
                iconOffset = {x = 15, y = 15},
                xOffset = {x = 0, y = 0},
                numOffset = {x = 25, y = 20},
            },
            [HUD_ELEMENT_VANILLA_COINS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = false, num = true},
                iconOffset = {x = 15, y = 35},
                xOffset = {x = 0, y = 0},
                numOffset = {x = 25, y = 40},
            },
            [HUD_ELEMENT_VANILLA_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = false, num = true},
                iconOffset = {x = 15, y = 55},
                xOffset = {x = 0, y = 0},
                numOffset = {x = 25, y = 60},
            },
            [HUD_ELEMENT_PSC_RED_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = false, num = true},
                iconColor = {r = 255, g = 0, b = 0, o = 255},
                scale = 0.6,
                iconOffset = {x = 20, y = 72},
                xOffset = {x = 0, y = 0},
                numOffset = {x = 25, y = 77},
            },
            [HUD_ELEMENT_PSC_GREEN_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = false, num = true},
                iconColor = {r = 0, g = 255, b = 0, o = 255},
                scale = 0.6,
                iconOffset = {x = 20, y = 82},
                xOffset = {x = 0, y = 0},
                numOffset = {x = 25, y = 87},
            },
            [HUD_ELEMENT_MISC_COMPASS] = {
                alignment = { x = 2, y = 0 },
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 0.8,
                compassShow = true,
                compassOffset = {x = -92, y = 10},
            },
            [HUD_ELEMENT_VANILLA_HEALTH] = {
                alignment = { x = 2, y = 0},
                color = { r = 255, g = 255, b = 255, o = 255},
                scale = 64,
                meterShow = true,
                meterOffset = {x = -70, y = 10},
            }
        },
        [HUD_SETTING_DISABLED] = {
            name = "Disabled",
        },
    }
end

local prevLevel = 0
local levelTimer = 0
---@param np NetworkPlayer
local function setup_timers(np)
    levelTimer = levelTimer + 1
    if prevLevel ~= np.currCourseNum then
        levelTimer = 0
        prevLevel = np.currCourseNum
    end
    local timer_status = menuTable[MENU_TABS.hud][MENU_TAB_HUD.timer].status
    if timer_status ~= 0 then
        if timer_status == 1 then
            timerString = string_format("%s:%s.%s", string_format("%02d", math_floor(levelTimer/30/60)), string_format("%02d", math_floor(levelTimer/30)%60), string_format("%03d", math_floor((levelTimer*33.3333333333)%1000)))
        elseif timer_status == 2 then
            timerString = RoomTime
        elseif timer_status == 3 then
            timerString = JoinTime
        elseif timer_status == 4 then
            timerString = SavedTimer
        end

        local screen_width = djui_hud_get_screen_width()
        local screen_height = djui_hud_get_screen_height()

        djui_hud_set_font(FONT_TINY)
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_color(0, 0, 0, 150)
        djui_hud_render_rect(screen_width - djui_hud_measure_text(timerString) - 13, screen_height - 16, djui_hud_measure_text(timerString) + 6, 50)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text(timerString, screen_width - djui_hud_measure_text(timerString) - 10, screen_height - 15, 1)
    end
end

local function setup_colors(part)
    local color = part.color
    local r, g, b, o = 255, 255, 255, 255
    if color then
        r = color.r
        g = color.g
        b = color.b
        o = color.o
    end
    return r, g, b, o
end

local function setup_health()
    local part = hudTable[currHUD][HUD_ELEMENT_VANILLA_HEALTH]
    local r, g, b, o = setup_colors(part)

    cur_x = part.meterOffset.x + djui_hud_get_screen_width() * 0.5 * part.alignment.x
    cur_y = part.meterOffset.y + djui_hud_get_screen_height() * 0.5 * part.alignment.y
    cur_scale = part.scale or 1
    djui_hud_set_adjusted_color(r, g, b, o)
end

local function setup_compass()
    local part = hudTable[currHUD][HUD_ELEMENT_MISC_COMPASS]
    local r, g, b, o = setup_colors(part)

    cur_x = part.compassOffset.x + djui_hud_get_screen_width() * 0.5 * part.alignment.x
    cur_y = part.compassOffset.y + djui_hud_get_screen_height() * 0.5 * part.alignment.y
    cur_scale = part.scale or 1
    djui_hud_set_adjusted_color(r, g, b, o)
end

---@diagnostic disable
if _G.PersonalStarCounter then
    _G.PersonalStarCounter.hide_star_counters(true)
end
---@diagnostic enable

local function hud_render()
    if BootupTimer == 120 then
        setup_custom_hud()
        BootupInfo = BOOTUP_LOADED_CUSTOM_HUD_DATA
        HUD_TABLE_MAX = menuTable[MENU_TABS.hud][MENU_TAB_HUD.hudType].statusMax
    end

    if BootupTimer < 150 then return end

    local hud_type = menuTable[MENU_TABS.hud][MENU_TAB_HUD.hudType]

    ---@type NetworkPlayer
    local np = gNetworkPlayers[0]
    ---@type MarioState
    local m = gMarioStates[0]

    -- Timers --
    setup_timers(np)

    -- Random theme thing
    if themeTable[menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].status].name == "Wario World" then
        hud_type.statusMax = 4
        hudTable[4] = {
            name = "Wario World",
            res = RESOLUTION_N64,
            font = FONT_HUD,
            [HUD_ELEMENT_VANILLA_LIVES] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = false, div = false, num = false},
                iconOffset = {x = 21, y = 15},
                xOffset = {x = 37, y = 15},
                numOffset = {x = 51, y = 15},
            },
            [HUD_ELEMENT_VANILLA_COINS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = 21, y = 192},
                xOffset = {x = 37, y = 192},
                numOffset = {x = 51, y = 192},
            },
            [HUD_ELEMENT_VANILLA_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconOffset = {x = 21, y = 174},
                xOffset = {x = 37, y = 174},
                numOffset = {x = 51, y = 174},
            },
            [HUD_ELEMENT_PSC_RED_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconColor = {r = 255, g = 0, b = 0, o = 255},
                scale = 1,
                iconOffset = {x = 21, y = 156},
                xOffset = {x = 37, y = 156},
                numOffset = {x = 51, y = 156},
            },
            [HUD_ELEMENT_PSC_GREEN_STARS] = {
                alignment = {x = 0, y = 0},
                shownElements = {icon = true, div = true, num = true},
                iconColor = {r = 0, g = 255, b = 0, o = 255},
                scale = 1,
                iconOffset = {x = 21, y = 138},
                xOffset = {x = 37, y = 138},
                numOffset = {x = 51, y = 138},
            },
            [HUD_ELEMENT_MISC_COMPASS] = {
                alignment = {x = 2, y = 2},
                color = {r = 255, g = 255, b = 255, o = 255},
                scale = 1,
                compassShow = true,
                compassOffset = {x = -52, y = -52},
            },
            [HUD_ELEMENT_VANILLA_HEALTH] = {
                alignment = {x = 2, y = 0},
                color = {r = 255, g = 255, b = 255, o = 255},
                scale = 64,
                meterShow = false,
                meterOffset = {x = -70, y = 10},
            }
        }

        if currHUD == HUD_TABLE_MAX + 1 then
            currHUD = HUD_SETTING_DEFAULT
            hud_type.status = 0
        end
    else
        if currHUD == HUD_TABLE_MAX then
            currHUD = HUD_SETTING_DEFAULT
            hud_type.status = 0
        end
        hud_type.statusMax = 3
    end

    -- Finally start doing stuff with the hud
    hud_hide()

    currHUD = hud_type.status
    if currHUD == 3 then return end

    -- If in some cutscenes
	if obj_get_first_with_behavior_id(id_bhvActSelector)
	or (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end

    local current_hud = hudTable[currHUD]
    djui_hud_set_resolution(current_hud.res)
    djui_hud_set_font(current_hud.font)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_render_behind_hud(true)

    if get_dialog_id() ~= -1 then return end

    if current_hud[HUD_ELEMENT_VANILLA_HEALTH].meterShow then
        setup_health()
        hud_render_power_meter(m.health, cur_x, cur_y, cur_scale, cur_scale)
    end

    ----------------------
    -- Compass behavior --
    if current_hud[HUD_ELEMENT_MISC_COMPASS].compassShow then
        setup_compass()
        local marioObj = m.marioObj
        djui_hud_render_texture(TEX_BACK, cur_x, cur_y, cur_scale, cur_scale)
        if gLakituState.yaw then -- ?? When will this ever be nil
            djui_hud_set_rotation(gLakituState.yaw , 0.5, 0.5)
            djui_hud_render_texture(TEX_CAMERA_DIAL, cur_x, cur_y, cur_scale, cur_scale)
        end
        if m.faceAngle.y then -- ?? Seriously when will these be nil
            djui_hud_set_rotation(m.faceAngle.y , 0.5, 0.5)
            djui_hud_render_texture(TEX_PLAYER_DIAL, cur_x, cur_y, cur_scale, cur_scale)
        end
        djui_hud_set_rotation(0, 0, 0)

        -- All stars
        djui_hud_set_adjusted_color(255, 255, 255, 255)
        for _, value in ipairs(obj_get_nearest_objects_from_set(marioObj, find_stars)) do
            render_hud_radar(value, gTextures.star, cur_scale, cur_x + 8, cur_y + 8, m)
        end
        -- red coin
        local red_coin = obj_get_nearest_object_with_behavior_id(marioObj, id_bhvRedCoin)
        if red_coin then
            djui_hud_set_adjusted_color(255, 0, 0, 255)
            render_hud_radar(red_coin, gTextures.coin, cur_scale, cur_x + 8, cur_y + 8, m)
        end
        -- secret
        local secret = obj_get_nearest_object_with_behavior_id(marioObj, id_bhvHiddenStarTrigger)
        if secret then
            djui_hud_set_adjusted_color(255, 255, 0, 255)
            render_hud_radar(secret, TEX_SECRET, cur_scale, cur_x + 8, cur_y + 8, m)
        end
    end
    ----------------------

    -- I have little idea what's going on here so it's not well rewritten

    if not lifeIcon then
        lifeIcon = "Default"
    end
    djui_hud_render_element(HUD_ELEMENT_VANILLA_LIVES, m.numLives, lifeIcon, m)
    if themeTable[menuTable[MENU_TABS.hud][MENU_TAB_HUD.theme].status].name == "Wario World" then
        djui_hud_render_element(HUD_ELEMENT_VANILLA_COINS, m.numCoins, TEX_WARIO_BAG, m)
        if currHUD == 4 then
            local health = math.ceil(m.health / 256) - 1
            local xHealth = 21
            if health > 0 then
                for i = 0, health do
                    if health - 2 >= 0 then
                        djui_hud_render_texture_tile(TEX_WWHEART, xHealth, 210, 1, 1, 0, 0, 16, 16)
                        health = health - 2
                        xHealth = xHealth + 18
                    elseif health - 1 >= 0 then
                        djui_hud_render_texture_tile(TEX_WWHEART, xHealth, 210, 1, 1, 16, 0, 16, 16)
                        health = health - 1
                    end
                end
            end
            djui_hud_render_texture_tile(TEX_WWHEART, 93, 210, 1, 1, 0, 16, 16, 16)
            djui_hud_set_color(96, 255, 96, 255)
            -- TODO: Make this good
            local lives = m.numLives
            local lives_str = tostring(lives)
            if lives == 1 then
                djui_hud_print_text(lives_str, 96.5, 214.5, 0.5)
            elseif lives < 10 then
                djui_hud_print_text(lives_str, 97.25, 214.5, 0.5)
            elseif lives >= 10 and lives < 20 then
                djui_hud_print_text(lives_str, 93.5, 214.5, 0.5)
            elseif lives >= 20 and lives < 100 then
                djui_hud_print_text(lives_str, 94.25, 214.5, 0.5)
            else
                djui_hud_print_text(lives_str, 90.5, 214.5, 0.5)
            end
            djui_hud_set_color(255, 255, 255, 255)
        end
    else
        djui_hud_render_element(HUD_ELEMENT_VANILLA_COINS, m.numCoins, gTextures.coin, m)
    end
    djui_hud_render_element(HUD_ELEMENT_VANILLA_STARS, m.numStars, gTextures.star, m)
    if _G.PersonalStarCounter then
        _G.PersonalStarCounter.hide_star_counters(true)
        djui_hud_render_element(HUD_ELEMENT_PSC_RED_STARS, _G.PersonalStarCounter.get_star_counter(), gTextures.star, m)
        djui_hud_render_element(HUD_ELEMENT_PSC_GREEN_STARS, _G.PersonalStarCounter.get_total_star_counter(), gTextures.star, m)
    end

    -- I have no idea what any of this below could be so I'm not bothering

    if oWario > 0 then
        if warioTimer < 31 then
            warioTimer = warioTimer + 1
        end
        if warioTimer >= 30 then
            oWario = oWario - 3
        end
    end

    local screen_width = djui_hud_get_screen_width()
    local half_screen_width = screen_width * 0.5
    local screen_height = djui_hud_get_screen_height()

    if not warioChallengeComplete and warioChallenge ~= nil and np.modelIndex == 4 then
        djui_hud_set_font(FONT_HUD)
        djui_hud_set_color(255, 255, 255, oWario)
        if currHUD == 0 or currHUD == 1 then
            djui_hud_render_texture(TEX_WARIO_BAG, half_screen_width + 8, screen_height * 0.135, 1, 1)
            djui_hud_set_color(255, 255, 0, oWario)
            djui_hud_print_text("x", half_screen_width + 24, screen_height * 0.135, 1)
            djui_hud_print_text(tostring(warioChallenge), half_screen_width + 38, screen_height * 0.135, 1)
        elseif currHUD == 2 then
            djui_hud_render_texture(TEX_WARIO_BAG, 15, screen_height * 0.31, 1, 1)
            djui_hud_set_color(255, 255, 0, oWario)
            djui_hud_print_text(tostring(warioChallenge), 25, screen_height * 0.335, 1)
        elseif currHUD == 3 then
            djui_hud_render_texture(TEX_WARIO_BAG, screen_width - 45 - djui_hud_measure_text(tostring(warioChallenge)), screen_height * 0.9, 1, 1)
            djui_hud_set_color(255, 255, 0, oWario)
            djui_hud_print_text("x", screen_width - 29 - djui_hud_measure_text(tostring(warioChallenge)), screen_height * 0.9, 1)
            djui_hud_print_text(tostring(warioChallenge), screen_width - djui_hud_measure_text(tostring(warioChallenge)) - 15, screen_height * 0.9, 1)
        end
    end

    if warioChallenge > 0 and warioChallenge % 100 == 0 and not playedWarioSound then
        audio_stream_play(AUDIO_EXCELLENT, true, 2)
        playedWarioSound = true
    elseif warioChallenge > 0 and warioChallenge % 100 ~= 0 then
        playedWarioSound = false
    end

end

hook_event(HOOK_ON_HUD_RENDER, hud_render)