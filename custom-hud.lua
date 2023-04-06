Default = 0
FourThreeLock = 1
Compact = 2
Off = 3

hudTable = {
    [Default] = {
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
            iconOffsetX = 21,
            iconOffsetY = 60,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 60,
        },
        ["Coins"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 78,
            xShow = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 78,
        },
        ["Stars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconOffsetX = 21,
            iconOffsetY = 96,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 96,
        },
        ["RedStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 255,
            iconColorG = 0,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = 114,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 114,
        },
        ["GreenStars"] = {
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
            iconColorR = 0,
            iconColorG = 255,
            iconColorB = 0,
            iconColorO = 255,
            iconOffsetX = 21,
            iconOffsetY = 132,
            xShow = false,
            hideOnTriple = false,
            xOffsetX = 0,
            xOffsetY = 0,
            numShow = true,
            numOffsetX = 40,
            numOffsetY = 132,
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

local currHUD = 0

function djui_hud_render_element(element, number, icon)
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

    --Checks for Base Color
    if hudTable[currHUD][element].colorR ~= nil then
        r = hudTable[currHUD][element].colorR
    end
    if hudTable[currHUD][element].colorG ~= nil then
        g = hudTable[currHUD][element].colorG
    end
    if hudTable[currHUD][element].colorB ~= nil then
        b = hudTable[currHUD][element].colorB
    end
    if hudTable[currHUD][element].colorO ~= nil then
        o = hudTable[currHUD][element].colorO
    end

    --Checks for Icon Colors
    if hudTable[currHUD][element].iconColorR ~= nil then
        iconR = hudTable[currHUD][element].iconColorR
    else
        iconR = r
    end
    if hudTable[currHUD][element].iconColorG ~= nil then
        iconG = hudTable[currHUD][element].iconColorG
    else
        iconG = g
    end
    if hudTable[currHUD][element].iconColorB ~= nil then
        iconB = hudTable[currHUD][element].iconColorB
    else
        iconB = b
    end
    if hudTable[currHUD][element].iconColorO ~= nil then
        iconO = hudTable[currHUD][element].iconColorO
    else
        iconO = o
    end

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

local scriptStallTimer = 0

function hud_render()
    local m = gMarioStates[0]
    if scriptStallTimer < 10 then
        scriptStallTimer = scriptStallTimer + 1
        return
    end
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

    djui_hud_render_element("Lives", m.numLives, lifeIcon)
    djui_hud_render_element("Coins", m.numCoins, gTextures.coin)
    djui_hud_render_element("Stars", m.numStars, gTextures.star)
    if _G.StarCounter ~= nil then
        djui_hud_render_element("RedStars", _G.StarCounter, gTextures.star)
    end
    if _G.TotalStarCounter ~= nil then
        djui_hud_render_element("GreenStars", _G.TotalStarCounter, gTextures.star)
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)