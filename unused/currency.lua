--
local hudShow = false
local hudTimer = 0
local opacity = 255
local randomXPos = 0
local objtype = 0

function hud_render()
    local m = gMarioStates[0]
    if objtype ~= 0 then
        hudShow = true
    end
    if opacity >= 10 and hudShow == true then
        if objtype == 1 then
            opacity = 255 - (hudTimer * 6)
            hudTimer = hudTimer + 1
            djui_hud_set_font(FONT_HUD)
            djui_hud_set_resolution(RESOLUTION_N64)
            djui_hud_set_color(255, 255, 255, opacity)
            djui_hud_print_text("+10", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("+10") / 2) + randomXPos), 60 - (hudTimer / 4), 1)
        elseif objtype == 2 then
            opacity = 255 - (hudTimer * 6)
            hudTimer = hudTimer + 1
            djui_hud_set_font(FONT_HUD)
            djui_hud_set_resolution(RESOLUTION_N64)
            djui_hud_set_color(255, 255, 255, opacity)
            djui_hud_print_text("+15", ((djui_hud_get_screen_width()/2) - (djui_hud_measure_text("+25") / 2) + randomXPos), 60 - (hudTimer / 4), 1)
        end
    elseif not (m.action == ACT_STAR_DANCE_EXIT 
    or m.action == ACT_STAR_DANCE_NO_EXIT 
    or m.action == ACT_STAR_DANCE_WATER) then
        hudShow = false
        hudTimer = 0
        opacity = 255
        objtype = 0
    end
end

function findobj (obj)
    nearest = nearest_mario_state_to_object(obj)
    if (((get_id_from_behavior(obj.behavior) == id_bhv1Up)
    or (get_id_from_behavior(obj.behavior) == id_bhvHidden1upInPole)
    or (get_id_from_behavior(obj.behavior) == id_bhvHidden1up))
    and nearest.playerIndex == 0) then
        objtype = 1
        randomXPos =  math.random(-5,5)
    end
end

function findact(m)
    if m.playerIndex == 0 and objtype == 0 then
        if m.action == ACT_STAR_DANCE_EXIT 
        or m.action == ACT_STAR_DANCE_NO_EXIT 
        or m.action == ACT_STAR_DANCE_WATER then
            objtype = 2
            randomXPos =  math.random(-5,5)
        end
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render) 
hook_event(HOOK_ON_OBJECT_UNLOAD, findobj)
hook_event(HOOK_MARIO_UPDATE, findact)