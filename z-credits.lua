-- Thank you so much for to playing my game!

creditsOpen = false
local creditsScroll = 0

local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_set_font = djui_hud_set_font
local djui_hud_print_text = djui_hud_print_text
local djui_hud_measure_text = djui_hud_measure_text
local djui_hud_render_texture_tile = djui_hud_render_texture_tile

function render_credits()
    if menuTable[3][7].status == 1 and BootupTimer >= 150 then
        menuTable[3][7].status = 0
        creditsOpen = true
    end
end

function inputs()
    nullify_inputs(m)
end

hook_event(HOOK_ON_HUD_RENDER, render_credits)
hook_event(HOOK_BEFORE_MARIO_UPDATE, inputs)