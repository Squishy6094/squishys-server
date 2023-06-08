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
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = -77,
            iconOffsetY = 15,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 33,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 33,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 51,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = -61,
            xOffsetY = 51,
            numShow = true,
            numOffsetX = -46.8,
            numOffsetY = 51,
        },
        ["RedRadar"] = {
            xAlignment = 0,
            yAlignment = 2,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = -25,
            xShow = false,
            xOffsetX = 37,
            xOffsetY = -25,
            numShow = true,
            numOffsetX = 37,
            numOffsetY = -25,
        },
        ["SecretRadar"] = {
            xAlignment = 0,
            yAlignment = 2,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = -45,
            xShow = false,
            xOffsetX = 37,
            xOffsetY = -45,
            numShow = true,
            numOffsetX = 37,
            numOffsetY = -45,
        },
        ["Health"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
    [FourThreeLock] = {
        name = "4:3 Locked",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = -138,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = -122,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = -106,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = true,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 82,
            iconOffsetY = 15,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 82,
            iconOffsetY = 33,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 33,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 82,
            iconOffsetY = 51,
            xShow = true,
            hideOnTriple = true,
            xOffsetX = 98,
            xOffsetY = 51,
            numShow = true,
            numOffsetX = 112.2,
            numOffsetY = 51,
        },
        ["RedRadar"] = {
            xAlignment = 1,
            yAlignment = 2,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -138,
            iconOffsetY = -25,
            xShow = false,
            xOffsetX = -122,
            xOffsetY = -25,
            numShow = true,
            numOffsetX = -122,
            numOffsetY = -25,
        },
        ["SecretRadar"] = {
            xAlignment = 1,
            yAlignment = 2,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -138,
            iconOffsetY = -45,
            xShow = false,
            xOffsetX = -122,
            xOffsetY = -45,
            numShow = true,
            numOffsetX = -122,
            numOffsetY = -45,
        },
        ["Health"] = {
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
    [Compact] = {
        name = "Compact",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 80,
            iconOffsetY = 35,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 100,
            numOffsetY = 35,
        },
        ["Coins"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 135,
            iconOffsetY = 35,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 155,
            numOffsetY = 35,
        },
        ["Stars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 80,
            iconOffsetY = 15,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 100,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 135,
            iconOffsetY = 15,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 155,
            numOffsetY = 15,
        },
        ["GreenStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 190,
            iconOffsetY = 15,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 210,
            numOffsetY = 15,
        },
        ["Health"] = {
            scale = 64,
            xAlignment = 0,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = 15,
            meterOffsetY = 8,
        }
    },
    [Off] = {
        name = "Disabled",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = 21,
            iconOffsetY = 15,
            xShow = false,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            xAlignment = 1,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = 8,
            iconOffsetY = 15,
            xShow = false,
            xOffsetX = 24,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconOffsetX = -77,
            iconOffsetY = 15,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 15,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 15,
        },
        ["RedStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 33,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 33,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 33,
        },
        ["GreenStars"] = {
            xAlignment = 2,
            yAlignment = 0,
            iconShow = false,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = -77,
            iconOffsetY = 51,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = -61,
            xOffsetY = 51,
            numShow = false,
            numOffsetX = -46.8,
            numOffsetY = 51,
        },
        ["Health"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 64,
            xAlignment = 1,
            yAlignment = 0,
            meterShow = false,
            meterOffsetX = -52,
            meterOffsetY = 8,
        }
    },
}

local function djui_hud_render_element(element, number, icon)
    local m = gMarioStates[0]

    local r = 255
    local g = 255
    local b = 255
    local o = 255
    local iconR = 255
    local iconG = 255
    local iconB = 255
    local iconO = 255
    local scale = 1

    local xAlign = djui_hud_get_screen_width()*0.5 * hudTable[currHUD][element].xAlignment
    local yAlign = djui_hud_get_screen_height()*0.5 * hudTable[currHUD][element].yAlignment

    -- Optimized by ChatGPT
    -- Base color
    local function getColorOrDefault(value, defaultValue)
        if value ~= nil then
            return value
        else
            return defaultValue
        end
    end

    r = getColorOrDefault(hudTable[currHUD][element].colorR, r)
    g = getColorOrDefault(hudTable[currHUD][element].colorG, g)
    b = getColorOrDefault(hudTable[currHUD][element].colorB, b)
    o = getColorOrDefault(hudTable[currHUD][element].colorO, o)

    -- Icon color
    iconR = getColorOrDefault(hudTable[currHUD][element].iconColorR, r)
    iconG = getColorOrDefault(hudTable[currHUD][element].iconColorG, g)
    iconB = getColorOrDefault(hudTable[currHUD][element].iconColorB, b)
    iconO = getColorOrDefault(hudTable[currHUD][element].iconColorO, o)

    --Checks for Scale 
    if hudTable[currHUD][element].scale ~= nil then
        scale = hudTable[currHUD][element].scale
    end

    local iconX = hudTable[currHUD][element].iconOffsetX + xAlign
    local iconY = hudTable[currHUD][element].iconOffsetY + yAlign
    local xX = hudTable[currHUD][element].xOffsetX + xAlign
    local xY = hudTable[currHUD][element].xOffsetY + yAlign
    local numX = hudTable[currHUD][element].numOffsetX + xAlign
    local numY = hudTable[currHUD][element].numOffsetY + yAlign

    if is_game_paused() then
        djui_hud_set_color(iconR*0.5, iconG*0.5, iconB*0.5, iconO)
    else
        djui_hud_set_color(iconR, iconG, iconB, iconO)
    end
    if hudTable[currHUD][element].iconShow then
        djui_hud_render_texture(icon, iconX, iconY, scale, scale)
    end
    if is_game_paused() then
        djui_hud_set_color(r*0.5, g*0.5, b*0.5, o)
    else
        djui_hud_set_color(r, g, b, o)
    end

    if hudTable[currHUD][element].xShow and not (number >= 100 and hudTable[currHUD][element].hideOnTriple) then
        djui_hud_print_text("x", xX, xY, scale)
    end
    if hudTable[currHUD][element].numShow then
        if number >= 100 and hudTable[currHUD][element].hideOnTriple then
            djui_hud_print_text(tostring(number), xX, xY, scale)
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

function hud_render()
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

    if hudTable[currHUD]["Health"].colorR ~= nil then
        r = hudTable[currHUD]["Health"].colorR
    end
    if hudTable[currHUD]["Health"].colorG ~= nil then
        g = hudTable[currHUD]["Health"].colorG
    end
    if hudTable[currHUD]["Health"].colorB ~= nil then
        b = hudTable[currHUD]["Health"].colorB
    end
    if hudTable[currHUD]["Health"].colorO ~= nil then
        o = hudTable[currHUD]["Health"].colorO
    end

    local x = hudTable[currHUD]["Health"].meterOffsetX + djui_hud_get_screen_width()*0.5 * hudTable[currHUD]["Health"].xAlignment
    local y = hudTable[currHUD]["Health"].meterOffsetY + djui_hud_get_screen_height()*0.5 * hudTable[currHUD]["Health"].yAlignment
    local scale = hudTable[currHUD]["Health"].scale

    if is_game_paused() then
        djui_hud_set_color(r*0.5, g*0.5, b*0.5, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD]["Health"].meterShow then
        hud_render_power_meter(gMarioStates[0].health, x, y, scale, scale)
    end

    --Collectables Radar
    local obj = m.marioObj
    if obj ~= nil then
        obj = get_closest_object(id_bhvRedCoin)
        red_coin_distance = dist_between_objects(obj, m.marioObj)
        obj = get_closest_object(id_bhvHiddenStarTrigger)
        secret_distance = dist_between_objects(obj, m.marioObj)
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
    if obj_get_first_with_behavior_id(id_bhvRedCoin) ~= nil then
        djui_hud_render_element("RedRadar", math.floor(red_coin_distance*0.1), gTextures.coin)
    end
    if obj_get_first_with_behavior_id(id_bhvHiddenStarTrigger) ~= nil then
        djui_hud_render_element("SecretRadar", math.floor(secret_distance*0.1), gTextures.coin)
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)