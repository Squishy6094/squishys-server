local currHUD = 0

local DefaultHUD = 0
local FourThreeLock = 1
local Compact = 2
local Off = 3

_G.StarCounter = nil
_G.TotalStarCounter = nil

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
        ["RedRadar"] = {
            alignment = {x = 0, y = 2},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = 21, y = -25},
            xOffset = {x = 37, y = -25},
            numOffset = {x = 37, y = -25},
        },
        ["SecretRadar"] = {
            alignment = {x = 0, y = 2},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 21, y = -45},
            xOffset = {x = 37, y = -45},
            numOffset = {x = 37, y = -45},
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
        ["RedRadar"] = {
            alignment = {x = 1, y = 2},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -138, y = -25},
            xOffset = {x = -122, y = -25},
            numOffset = {x = 37, y = -25},
        },
        ["SecretRadar"] = {
            alignment = {x = 1, y = 2},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = -138, y = -45},
            xOffset = {x = -122, y = -45},
            numOffset = {x = 37, y = -45},
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
        ["RedRadar"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = -60, y = 10},
            xOffset = {x = 0, y = 0},
            numOffset = {x = -50, y = 15},
        },
        ["SecretRadar"] = {
            alignment = {x = 1, y = 0},
            shownElements = {icon = true, div = false, num = true},
            iconOffset = {x = 10, y = 10},
            xOffset = {x = 0, y = 0},
            numOffset = {x = 20, y = 15},
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
        ["RedRadar"] = {
            alignment = {x = 0, y = 2},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 255, g = 0, b = 0, o = 255},
            iconOffset = {x = 21, y = -25},
            xOffset = {x = 37, y = -25},
            numOffset = {x = 37, y = -25},
        },
        ["SecretRadar"] = {
            alignment = {x = 0, y = 2},
            shownElements = {icon = false, div = false, num = false},
            hideOnTriple = true,
            iconColor = {r = 255, g = 255, b = 255, o = 255},
            iconOffset = {x = 21, y = -45},
            xOffset = {x = 37, y = -45},
            numOffset = {x = 37, y = -45},
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
        djui_hud_render_texture(icon, iconX, iconY, scale, scale)
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

local red_coin_distance = 0
local secret_distance = 0

local function get_closest_object(id_bhv)
    local obj = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhv)
    if obj ~= nil then
        return obj
    end
    return nil
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

    djui_hud_render_element("Lives", m.numLives, lifeIcon)
    djui_hud_render_element("Coins", m.numCoins, gTextures.coin)
    djui_hud_render_element("Stars", m.numStars, gTextures.star)
    if _G.StarCounter ~= nil then
        djui_hud_render_element("RedStars", _G.StarCounter, gTextures.star)
    end
    if _G.TotalStarCounter ~= nil then
        djui_hud_render_element("GreenStars", _G.TotalStarCounter, gTextures.star)
    end
    if _G.red_coin_distance ~= nil and _G.red_coin_distance ~= 0 then
        djui_hud_render_element("RedRadar", math.floor(_G.red_coin_distance*0.1), gTextures.coin)
    end
    if _G.secret_distance ~= nil and _G.secret_distance ~= 0 then
        djui_hud_render_element("SecretRadar", math.floor(_G.secret_distance*0.1), get_texture_info("secret"))
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)