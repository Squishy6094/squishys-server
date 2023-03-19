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
        ["PersonalStars"] = {
            colorR = 255,
            colorG = 50,
            colorB = 50,
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
StarCounter = StarCounter

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

    local r = hudTable[currHUD]["Lives"].colorR
    local g = hudTable[currHUD]["Lives"].colorG
    local b = hudTable[currHUD]["Lives"].colorB
    local o = hudTable[currHUD]["Lives"].colorO

    local iconX = hudTable[currHUD]["Lives"].iconOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Lives"].xAlignment
    local iconY = hudTable[currHUD]["Lives"].iconOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Lives"].yAlignment
    local xX = hudTable[currHUD]["Lives"].xOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Lives"].xAlignment
    local xY = hudTable[currHUD]["Lives"].xOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Lives"].yAlignment
    local numX = hudTable[currHUD]["Lives"].numOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Lives"].xAlignment
    local numY = hudTable[currHUD]["Lives"].numOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Lives"].yAlignment
    local scale = hudTable[currHUD]["Lives"].scale

    if is_game_paused() then
        djui_hud_set_color(r/2, g/2, b/2, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD]["Lives"].iconShow then
        if network_discord_id_from_local_index(0) ~= nil then
            if modelTable[discordID][currModel].icon ~= nil then
                if modelTable[discordID][currModel].icon == "Default" then
                    djui_hud_render_texture(m.character.hudHeadTexture, iconX, iconY, scale, scale)
                else
                    djui_hud_render_texture(modelTable[discordID][currModel].icon, iconX, iconY, scale, scale)
                end
            else
                djui_hud_render_texture(get_texture_info("icon-nil"), iconX, iconY, scale, scale)
            end
        else
            djui_hud_render_texture(m.character.hudHeadTexture, iconX, iconY, scale, scale)
        end
    end
    if hudTable[currHUD]["Lives"].xShow then
        djui_hud_print_text("x", xX, xY, scale)
    end
    if hudTable[currHUD]["Lives"].numShow then
        djui_hud_print_text(""..m.numLives, numX, numY, scale)
    end

    local r = hudTable[currHUD]["Coins"].colorR
    local g = hudTable[currHUD]["Coins"].colorG
    local b = hudTable[currHUD]["Coins"].colorB
    local o = hudTable[currHUD]["Coins"].colorO

    local iconX = hudTable[currHUD]["Coins"].iconOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Coins"].xAlignment
    local iconY = hudTable[currHUD]["Coins"].iconOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Coins"].yAlignment
    local xX = hudTable[currHUD]["Coins"].xOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Coins"].xAlignment
    local xY = hudTable[currHUD]["Coins"].xOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Coins"].yAlignment
    local numX = hudTable[currHUD]["Coins"].numOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Coins"].xAlignment
    local numY = hudTable[currHUD]["Coins"].numOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Coins"].yAlignment
    local scale = hudTable[currHUD]["Coins"].scale

    if is_game_paused() then
        djui_hud_set_color(r/2, g/2, b/2, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD]["Coins"].iconShow then
        djui_hud_render_texture(gTextures.coin, iconX, iconY, scale, scale)
    end
    if hudTable[currHUD]["Coins"].xShow then
        djui_hud_print_text("x", xX, xY, scale)
    end
    if hudTable[currHUD]["Coins"].numShow then
        djui_hud_print_text(""..m.numCoins, numX, numY, scale)
    end

    local r = hudTable[currHUD]["Stars"].colorR
    local g = hudTable[currHUD]["Stars"].colorG
    local b = hudTable[currHUD]["Stars"].colorB
    local o = hudTable[currHUD]["Stars"].colorO

    local iconX = hudTable[currHUD]["Stars"].iconOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Stars"].xAlignment
    local iconY = hudTable[currHUD]["Stars"].iconOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Stars"].yAlignment
    local xX = hudTable[currHUD]["Stars"].xOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Stars"].xAlignment
    local xY = hudTable[currHUD]["Stars"].xOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Stars"].yAlignment
    local numX = hudTable[currHUD]["Stars"].numOffsetX + djui_hud_get_screen_width()/2 * hudTable[currHUD]["Stars"].xAlignment
    local numY = hudTable[currHUD]["Stars"].numOffsetY + djui_hud_get_screen_height()/2 * hudTable[currHUD]["Stars"].yAlignment
    local scale = hudTable[currHUD]["Stars"].scale

    if is_game_paused() then
        djui_hud_set_color(r/2, g/2, b/2, o)
    else
        djui_hud_set_color(r, g, b, o)
    end
    if hudTable[currHUD]["Stars"].iconShow then
        djui_hud_render_texture(gTextures.star, iconX, iconY, scale, scale)
    end
    if hudTable[currHUD]["Stars"].xShow and (m.numStars < 100 or not hudTable[currHUD]["Stars"].hideOnTriple) then
        djui_hud_print_text("x", xX, xY, scale)
    end
    if hudTable[currHUD]["Stars"].numShow then
        if m.numStars >= 100 and hudTable[currHUD]["Stars"].hideOnTriple then
            djui_hud_print_text(tostring(m.numStars), xX, xY, scale)
        else
            djui_hud_print_text(tostring(m.numStars), numX, numY, scale)
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)