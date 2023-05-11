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