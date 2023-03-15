function hud_render()
    
    local m = gMarioStates[0]

    --hud_hide()
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_print_text("x "..m.numLives, 37, 15, 1)
    djui_hud_print_text("x "..m.numStars, 30, 30, 1)
    djui_hud_print_text("x "..m.numCoins, 30, 50, 1)
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)