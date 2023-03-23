Default = 0
FourThreeLock = 1
Compact = 2

hudTable = {
    [Default] = {
        name = "Default",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 50,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
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
            colorR = 50,
            colorG = 255,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 2,
            yAlignment = 0,
            iconShow = true,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 50,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
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
            colorR = 50,
            colorG = 255,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 1,
            yAlignment = 0,
            iconShow = true,
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
    [Compact] = {
        name = "Compact",
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
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
            colorR = 255,
            colorG = 50,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
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
            colorR = 50,
            colorG = 255,
            colorB = 50,
            colorO = 255,
            scale = 1,
            xAlignment = 0,
            yAlignment = 0,
            iconShow = true,
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
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 64,
            xAlignment = 0,
            yAlignment = 0,
            meterShow = true,
            meterOffsetX = 15,
            meterOffsetY = 8,
        }
    }
}

currHUD = 0

function djui_hud_render_element(element, number, icon)
    local m = gMarioStates[0]

    local xAlign = djui_hud_get_screen_width()/2 * hudTable[currHUD][element].xAlignment
    local yAlign = djui_hud_get_screen_height()/2 * hudTable[currHUD][element].yAlignment

    local r = hudTable[currHUD][element].colorR
    local g = hudTable[currHUD][element].colorG
    local b = hudTable[currHUD][element].colorB
    local o = hudTable[currHUD][element].colorO

    local iconX = hudTable[currHUD][element].iconOffsetX + xAlign
    local iconY = hudTable[currHUD][element].iconOffsetY + yAlign
    local xX = hudTable[currHUD][element].xOffsetX + xAlign
    local xY = hudTable[currHUD][element].xOffsetY + yAlign
    local numX = hudTable[currHUD][element].numOffsetX + xAlign
    local numY = hudTable[currHUD][element].numOffsetY + yAlign
    local scale = hudTable[currHUD][element].scale

    if is_game_paused() then
        djui_hud_set_color(r/2, g/2, b/2, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD][element].iconShow then
        djui_hud_render_texture(icon, iconX, iconY, scale, scale)
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

function hud_render()
    local m = gMarioStates[0]

    hud_hide()
	if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil
	or (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end
    djui_hud_set_resolution(hudTable[currHUD].res)
    djui_hud_set_font(hudTable[currHUD].font)
    djui_hud_set_color(255, 255, 255, 255)

    local r = hudTable[currHUD]["Health"].colorR
    local g = hudTable[currHUD]["Health"].colorG
    local b = hudTable[currHUD]["Health"].colorB
    local o = hudTable[currHUD]["Health"].colorO

    local x = hudTable[currHUD]["Health"].meterOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Health"].xAlignment
    local y = hudTable[currHUD]["Health"].meterOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Health"].yAlignment
    local scale = hudTable[currHUD]["Health"].scale

    if is_game_paused() then
        djui_hud_set_color(r/2, g/2, b/2, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD]["Health"].meterShow then
        hud_render_power_meter(gMarioStates[0].health, x, y, scale, scale)
    end

    if modelTable[discordID][currModel].icon ~= nil then
        if modelTable[discordID][currModel].icon == "Default" then
            lifeIcon = m.character.hudHeadTexture
        else
            lifeIcon = modelTable[discordID][currModel].icon
        end
    else
        lifeIcon = get_texture_info("icon-nil")
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