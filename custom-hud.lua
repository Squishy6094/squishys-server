local currHUD = 0

local DefaultHUD = 0
local FourThreeLock = 1
local Compact = 2
local Off = 3

-- Optimizations
local obj_get_nearest_object_with_behavior_id = obj_get_nearest_object_with_behavior_id
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_texture = djui_hud_render_texture
local djui_hud_set_rotation = djui_hud_set_rotation
local djui_hud_get_screen_width = djui_hud_get_screen_width
local djui_hud_get_screen_height = djui_hud_get_screen_height

local hudTable = {
    [DefaultHUD] = {
        name = "Default",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 21, y = 15},
            xOffset = {x = 37, y = 15},
            numOffset = {x = 54, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconOffset = {x = -77, y = 15},
            xOffset = {x = -61, y = 15},
            numOffset = {x = -46.8, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -77, y = 33},
            xOffset = {x = -61, y = 33},
            numOffset = {x = -46.8, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            iconOffset = {x = -77, y = 51},
            xOffset = {x = -61, y = 51},
            numOffset = {x = -46.8, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = true,
            compassOffset = {x = -52, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -52, y = 8},
        }
    },
    [FourThreeLock] = {
        name = "4:3 Locked",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = -138, y = 15},
            xOffset = {x = -122, y = 15},
            numOffset = {x = -106, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            hideOnTriple = true,
            iconOffset = {x = 82, y = 15},
            xOffset = {x = 98, y = 15},
            numOffset = {x = 112.2, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            hideOnTriple = true,
            iconOffset = {x = 82, y = 33},
            xOffset = {x = 98, y = 33},
            numOffset = {x = 112.2, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = true, num = true},
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            hideOnTriple = true,
            iconOffset = {x = 82, y = 51},
            xOffset = {x = 98, y = 51},
            numOffset = {x = 112.2, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 1, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = true,
            compassOffset = {x = -52, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -52, y = 8},
        }
    },
    [Compact] = {
        name = "Compact",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 15},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 20},
        },
        ["Coins"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 35},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 40},
        },
        ["Stars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 15, y = 55},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 60},
        },
        ["RedStars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            scale = 0.6,
            iconOffset = {x = 20, y = 72},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 77},
        },
        ["GreenStars"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            scale = 0.6,
            iconOffset = {x = 20, y = 82},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 25, y = 87},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 0.8,
            compassShow = true,
            compassOffset = {x = -92, y = 10},
        },
        ["Health"] = {
            alignment = { x = 2, y = 0},
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = true,
            meterOffset = {x = -70, y = 10},
        }
    },
    [Off] = {
        name = "Disabled",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            alignment = {x = 0, y = 0},
            shownElements = {icon = false, div = false, num = false},
            iconOffset = {x = 21, y = 15},
            xOffset = {x = 37, y = 15},
            numOffset = {x = 54, y = 15},
        },
        ["Coins"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = false, div = false, num = false},
            iconOffset = {x = 8, y = 15},
            xOffset = {x = 24, y = 15},
            numOffset = {x = 38, y = 15},
        },
        ["Stars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconOffset = {x = -77, y = 15},
            xOffset = {x = -61, y = 15},
            numOffset = {x = -46.8, y = 15},
        },
        ["RedStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -77, y = 33},
            xOffset = {x = -61, y = 33},
            numOffset = {x = -46.8, y = 33},
        },
        ["GreenStars"] = {
            alignment = {x = 2, y = 0},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 0, g = 255, b = 0, o = 255},
            iconOffset = {x = -77, y = 51},
            xOffset = {x = -61, y = 51},
            numOffset = {x = -46.8, y = 51},
        },
        ["Compass"] = {
            alignment = { x = 2, y = 2 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 1,
            compassShow = false,
            compassOffset = {x = -52, y = -52},
        },
        ["Health"] = {
            alignment = { x = 1, y = 0 },
            color = { r = 255, g = 255, b = 255, o = 255},
            scale = 64,
            meterShow = false,
            meterOffset = {x = -52, y = 8},
        }
    },
}


function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

local function djui_hud_render_element(element, number, icon)
    local m = gMarioStates[0]

    local r = 255
    local g = 255
    local b = 255
    local o = 255

    if hudTable[currHUD][element].color ~= nil then
        r = hudTable[currHUD][element].color.r
        g = hudTable[currHUD][element].color.g
        b = hudTable[currHUD][element].color.b
        o = hudTable[currHUD][element].color.o
    end

    local iconR = r
    local iconG = g
    local iconB = b
    local iconO = o

    if hudTable[currHUD][element].iconColor ~= nil then
        iconR = hudTable[currHUD][element].iconColor.r
        iconG = hudTable[currHUD][element].iconColor.g
        iconB = hudTable[currHUD][element].iconColor.b
        iconO = hudTable[currHUD][element].iconColor.o
    end

    local scale = 1

    if hudTable[currHUD][element].scale ~= nil then
        scale = hudTable[currHUD][element].scale
    end

    local xAlign = djui_hud_get_screen_width()*0.5 * hudTable[currHUD][element].alignment.x
    local yAlign = djui_hud_get_screen_height()*0.5 * hudTable[currHUD][element].alignment.y

    local iconX = hudTable[currHUD][element].iconOffset.x + xAlign
    local iconY = hudTable[currHUD][element].iconOffset.y + yAlign
    local divX = hudTable[currHUD][element].xOffset.x + xAlign
    local divY = hudTable[currHUD][element].xOffset.y + yAlign
    local numX = hudTable[currHUD][element].numOffset.x + xAlign
    local numY = hudTable[currHUD][element].numOffset.y + yAlign

    djui_hud_set_adjusted_color(iconR, iconG, iconB, iconO)
    if hudTable[currHUD][element].shownElements.icon then
        if element == "Lives" then
            if icon ~= "Default" then
                djui_hud_render_texture_tile(get_texture_info("icons"), iconX, iconY, scale, scale, (icon%16)*16, (math.floor(icon/16))*16, 16, 16)
            else
                djui_hud_render_texture(m.character.hudHeadTexture, iconX, iconY, scale, scale)
            end
        else
            djui_hud_render_texture(icon, iconX, iconY, scale, scale)
        end
    end

    djui_hud_set_adjusted_color(r, g, b, o)
    if hudTable[currHUD][element].shownElements.div and not (number >= 100 and hudTable[currHUD][element].hideOnTriple) then
        djui_hud_print_text("x", divX, divY, scale)
    end
    if hudTable[currHUD][element].shownElements.num then
        if number >= 100 and hudTable[currHUD][element].hideOnTriple then
            djui_hud_print_text(tostring(number), divX, divY, scale)
        else
            djui_hud_print_text(tostring(number), numX, numY, scale)
        end
    end
end

function s16(num)
    num = math.floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
end

--- @param target Object
--- @param iconTexture TextureInfo
function render_hud_radar(target, iconTexture, scale, x, y)
    local m = gMarioStates[0]

    -- direction
    local angle = s16(
        atan2s(
            target.oPosZ - m.pos.z,
            target.oPosX - m.pos.x
        )
    )
    
    local dist = vec3f_dist({ x = target.oPosX, y = target.oPosY, z = target.oPosZ }, m.pos)

    local distToScale = 100 - math.floor(dist*0.01)
    if distToScale < 0 then distToScale = 0 end
    if distToScale > 100 then distToScale = 100 end
    distToScale = distToScale*0.01*scale

    djui_hud_set_rotation(angle, 0.5/distToScale*scale, 2.5/distToScale*scale)
    djui_hud_render_texture(iconTexture, x + 4, y - 12, distToScale*0.5*scale, distToScale*0.5*scale)
    djui_hud_set_rotation(0, 0, 0)
end

local stallScriptTimer = 3

function hud_render()
    if stallScriptTimer > 0 then stallScriptTimer = stallScriptTimer - 1 return end
    local m = gMarioStates[0]
    currHUD = menuTable[2][1].status
    hud_hide()
	if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil
	or (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end
    djui_hud_set_resolution(hudTable[currHUD].res)
    djui_hud_set_font(hudTable[currHUD].font)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_render_behind_hud(true)

    local r = 255
    local g = 255
    local b = 255
    local o = 255

    if get_dialog_id() ~= -1 then return end

    if hudTable[currHUD]["Health"].color.r ~= nil then
        r = hudTable[currHUD]["Health"].color.r
    end
    if hudTable[currHUD]["Health"].color.g ~= nil then
        g = hudTable[currHUD]["Health"].color.g
    end
    if hudTable[currHUD]["Health"].color.b ~= nil then
        b = hudTable[currHUD]["Health"].color.b
    end
    if hudTable[currHUD]["Health"].color.o ~= nil then
        o = hudTable[currHUD]["Health"].color.o
    end

    local x = hudTable[currHUD]["Health"].meterOffset.x + djui_hud_get_screen_width()*0.5 * hudTable[currHUD]["Health"].alignment.x
    local y = hudTable[currHUD]["Health"].meterOffset.y + djui_hud_get_screen_height()*0.5 * hudTable[currHUD]["Health"].alignment.y
    local scale = hudTable[currHUD]["Health"].scale
    djui_hud_set_adjusted_color(r, g, b, o)
    if hudTable[currHUD]["Health"].meterShow then
        hud_render_power_meter(gMarioStates[0].health, x, y, scale, scale)
    end

    --Cumpiss
    local r = 255
    local g = 255
    local b = 255
    local o = 255

    if hudTable[currHUD]["Compass"].color.r ~= nil then
        r = hudTable[currHUD]["Compass"].color.r
    end
    if hudTable[currHUD]["Compass"].color.g ~= nil then
        g = hudTable[currHUD]["Compass"].color.g
    end
    if hudTable[currHUD]["Compass"].color.b ~= nil then
        b = hudTable[currHUD]["Compass"].color.b
    end
    if hudTable[currHUD]["Compass"].color.o ~= nil then
        o = hudTable[currHUD]["Compass"].color.o
    end

    local x = hudTable[currHUD]["Compass"].compassOffset.x + djui_hud_get_screen_width()*0.5 * hudTable[currHUD]["Compass"].alignment.x
    local y = hudTable[currHUD]["Compass"].compassOffset.y + djui_hud_get_screen_height()*0.5 * hudTable[currHUD]["Compass"].alignment.y
    local scale = hudTable[currHUD]["Compass"].scale
    djui_hud_set_adjusted_color(r, g, b, o)
    if hudTable[currHUD]["Compass"].compassShow then
        djui_hud_render_texture(get_texture_info("back"), x, y, scale, scale)
        if gLakituState.yaw ~= nil then
            djui_hud_set_rotation(gLakituState.yaw , 0.5, 0.5)
            djui_hud_render_texture(get_texture_info("camera-dial"), x, y, scale, scale)
        end
        if m.faceAngle.y ~= nil then
            djui_hud_set_rotation(m.faceAngle.y , 0.5, 0.5)
            djui_hud_render_texture(get_texture_info("player-dial"), x, y, scale, scale)
        end
        djui_hud_set_rotation(0, 0, 0)
        
        -- red coin
        if obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvRedCoin) ~= nil then
            local r = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvRedCoin)
            djui_hud_set_adjusted_color(255, 0, 0, 255)
            render_hud_radar(r, gTextures.coin, scale, x + 8, y + 8)
        end
        djui_hud_set_adjusted_color(255, 255, 255, 255)
        -- spawnable star
        if obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 412) ~= nil then
            local s = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 412)
            render_hud_radar(s, gTextures.star, scale, x + 8, y + 8)
        -- star from a box
        elseif obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 538) ~= nil then
            local s = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 538)
            render_hud_radar(s, gTextures.star, scale, x + 8, y + 8)
        -- regular star
        elseif obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 409) ~= nil then
            local s = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, 409)
            render_hud_radar(s, gTextures.star, scale, x + 8, y + 8)
        end
        -- secret
        if obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvHiddenStarTrigger) ~= nil then
            local sc = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvHiddenStarTrigger)
            djui_hud_set_adjusted_color(255, 255, 0, 255)
            render_hud_radar(sc, get_texture_info("secret"), scale, x + 8, y + 8)
        end
    end

    djui_hud_render_element("Lives", m.numLives, lifeIcon)
    djui_hud_render_element("Coins", m.numCoins, gTextures.coin)
    djui_hud_render_element("Stars", m.numStars, gTextures.star)
    if _G.PersonalStarCounter ~= nil then
        _G.PersonalStarCounter.hide_star_counters(true)
        djui_hud_render_element("RedStars", _G.PersonalStarCounter.get_star_counter(), gTextures.star)
        djui_hud_render_element("GreenStars", _G.PersonalStarCounter.get_total_star_counter(), gTextures.star)
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)