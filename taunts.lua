local tauntMenu = 0

DpadTex = get_texture_info("d-pad")

local tauntAct = {
    [ACT_IDLE] = true
}

tauntList = {
    [1] = {
        name = "Wave",
        state = gStateExtras.wave
    },
}

function displaytaunt()
    local m = gMarioStates[0]
    djui_hud_set_resolution(RESOLUTION_N64)
    if menuTable[3][3].status == 0 then return end
    if tauntAct[m.action] and m.controller.buttonDown & L_TRIG ~= 0 and not is_game_paused() then
        tauntMenu = 1
    end
    if m.controller.buttonDown & L_TRIG == 0 and tauntMenu < 2 then
        tauntMenu = 0
    end
    if tauntMenu == 1 then
        djui_hud_render_texture(DpadTex, 10, djui_hud_get_screen_height() - 42, 1, 1)
        if m.controller.buttonDown & A_BUTTON ~= 0 then
            tauntMenu = 2
        end
    end
    if tauntMenu == 2 then
        djui_hud_set_color(0, 0, 0, 255)
        djui_hud_render_rect(10, djui_hud_get_screen_height() - 90, 50, 100)
        if m.controller.buttonDown & B_BUTTON ~= 0 then
            tauntMenu = 0
        end
    end
end

function mario_update(m)
    if m.playerIndex ~= 0 then return end
    if tauntMenu ~= 0 then
        m.action = ACT_READING_NPC_DIALOG
    end
end

hook_event(HOOK_ON_HUD_RENDER, displaytaunt)
hook_event(HOOK_MARIO_UPDATE, mario_update)