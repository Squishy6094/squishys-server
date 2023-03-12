---@diagnostic disable: param-type-mismatch, assign-type-mismatch, missing-parameter
--Mods are bundled here to prevent lag and clutter--
--Credits go to all their original mod creators--

--Collectables Radar--
local red_coin_distance = 0
local secret_distance = 0

local function get_closest_object(id_bhv)
    local obj = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhv)
    if obj ~= nil then
        return obj
    end
    return nil
end

function display()
    local m = gMarioStates[0]

    if (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end

    --Setting up hud stuff
    djui_hud_set_font(FONT_HUD)
    djui_hud_set_resolution(RESOLUTION_N64)

    local screenHeight = djui_hud_get_screen_height()
    local screenWidth = djui_hud_get_screen_width()

    local y = screenHeight
    local x = screenWidth % 2
    local scale = 1
    local capboxmove = 0

    --Calculaing distance
    local obj = m.marioObj
    if obj ~= nil then
        obj = get_closest_object(id_bhvRedCoin)
        red_coin_distance = dist_between_objects(obj, m.marioObj)
        obj = get_closest_object(id_bhvHiddenStarTrigger)
        secret_distance = dist_between_objects(obj, m.marioObj)
    end

    --Red coins
    local distNum = tonumber(string.format('%.0f', red_coin_distance))
    local textLength = djui_hud_measure_text(tostring(distNum))
    obj = obj_get_first_with_behavior_id(id_bhvRedCoin)
    if (obj ~= nil) and radarRedToggle then
        if is_game_paused() then
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(string.format("%.0f", red_coin_distance / 10), x + 107 - textLength, y - 55, scale)
            djui_hud_set_color(246, 190, 0, 255)
            djui_hud_render_texture(get_texture_info("arrow"), x + 38.5, y - 52, scale * 1.7, scale * 1.8)
            djui_hud_set_color(227, 0, 0, 255)
            djui_hud_render_texture(gTextures.coin, x + 22, y - 52, scale * 0.9, scale * 0.9)
        else
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(string.format("%.0f", red_coin_distance / 10), x + 107 - textLength, y - 35, scale)
            djui_hud_set_color(246, 190, 0, 255)
            djui_hud_render_texture(get_texture_info("arrow"), x + 38.5, y - 34, scale * 1.7, scale * 1.8)
            djui_hud_set_color(227, 0, 0, 255)
            djui_hud_render_texture(gTextures.coin, x + 22, y - 34, scale * 0.9, scale * 0.9)
        end
    else
        --Move the secrets distance counter if there are no red coins
        y = y + 20
        capboxmove = capboxmove + 20
    end

    --Secrets
    distNum = tonumber(string.format('%.0f', secret_distance))
    textLength = djui_hud_measure_text(tostring(distNum))
    obj = obj_get_first_with_behavior_id(id_bhvHiddenStarTrigger)

    if (obj ~= nil) and radarSecretToggle then
        if is_game_paused() then
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(string.format("%.0f", secret_distance / 10), x + 107 - textLength, y - 75, scale)
            djui_hud_set_color(246, 190, 0, 255)
            djui_hud_render_texture(get_texture_info("arrow"), x + 38.5, y - 72, scale * 1.7, scale * 1.8)
            djui_hud_set_color(0, 0, 0, 127)
            djui_hud_render_texture(gTextures.coin, x + 22, y - 72, scale * 0.9, scale * 0.9)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text("S", x + 26, y - 68.5, scale * 0.5)
        else
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(string.format("%.0f", secret_distance / 10), x + 107 - textLength, y - 54, scale)
            djui_hud_set_color(246, 190, 0, 255)
            djui_hud_render_texture(get_texture_info("arrow"), x + 38.5, y - 54, scale * 1.7, scale * 1.8)
            djui_hud_set_color(0, 0, 0, 127)
            djui_hud_render_texture(gTextures.coin, x + 22, y - 54, scale * 0.9, scale * 0.9)
            djui_hud_set_color(255, 246, 0, 255)
            djui_hud_print_text("S", x + 26, y - 50.5, scale * 0.5)
        end
    else
        capboxmove = capboxmove + 20
    end

    --Cap Timer
    if is_game_paused() then
        capboxmove = capboxmove - 20
    end

    if (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end
    
    local m = gMarioStates[0]
    distNum = tonumber(string.format('%.0f', (math.ceil(m.capTimer/30))))
    textLength = djui_hud_measure_text(tostring(distNum))
    if capTimerToggle then
        if (m.flags & (MARIO_WING_CAP | MARIO_METAL_CAP | MARIO_VANISH_CAP)) ~= 0 then
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(".", 40, 167 + capboxmove, 1)
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_print_text(tostring(math.ceil(m.capTimer/30)), 96 - textLength, 167 + capboxmove, 1)
            if (m.flags & (MARIO_METAL_CAP)) ~= 0 then
                djui_hud_set_color(0, 150, 0, 255)
                djui_hud_render_rect(21, 167 + capboxmove, 16, 16)
                if (m.flags & (MARIO_VANISH_CAP)) ~= 0 then
                    if (m.flags & (MARIO_WING_CAP)) ~= 0 then
                        djui_hud_set_color(0, 0, 255, 255)
                        djui_hud_render_rect(26, 167 + capboxmove, 1, 1)
                        djui_hud_render_rect(27, 167 + capboxmove, 1, 2)
                        djui_hud_render_rect(28, 167 + capboxmove, 1, 3)
                        djui_hud_render_rect(29, 167 + capboxmove, 1, 4)
                        djui_hud_render_rect(30, 167 + capboxmove, 1, 5)
                        djui_hud_render_rect(31, 167 + capboxmove, 1, 6)
                        djui_hud_render_rect(32, 167 + capboxmove, 1, 7)
                        djui_hud_render_rect(33, 167 + capboxmove, 1, 8)
                        djui_hud_render_rect(34, 167 + capboxmove, 1, 9)
                        djui_hud_render_rect(35, 167 + capboxmove, 1, 10)
                        djui_hud_render_rect(36, 167 + capboxmove, 1, 11)
                        djui_hud_set_color(255, 0, 0, 255)
                        djui_hud_render_rect(21, 172 + capboxmove, 1, 11)
                        djui_hud_render_rect(22, 173 + capboxmove, 1, 10)
                        djui_hud_render_rect(23, 174 + capboxmove, 1, 9)
                        djui_hud_render_rect(24, 175 + capboxmove, 1, 8)
                        djui_hud_render_rect(25, 176 + capboxmove, 1, 7)
                        djui_hud_render_rect(26, 177 + capboxmove, 1, 6)
                        djui_hud_render_rect(27, 178 + capboxmove, 1, 5)
                        djui_hud_render_rect(28, 179 + capboxmove, 1, 4)
                        djui_hud_render_rect(29, 180 + capboxmove, 1, 3)
                        djui_hud_render_rect(30, 181 + capboxmove, 1, 2)
                        djui_hud_render_rect(31, 182 + capboxmove, 1, 1)
                    else
                        djui_hud_set_color(0, 0, 255, 255)
                        djui_hud_render_rect(21, 167 + capboxmove, 1, 1)
                        djui_hud_render_rect(22, 167 + capboxmove, 1, 2)
                        djui_hud_render_rect(23, 167 + capboxmove, 1, 3)
                        djui_hud_render_rect(24, 167 + capboxmove, 1, 4)
                        djui_hud_render_rect(25, 167 + capboxmove, 1, 5)
                        djui_hud_render_rect(26, 167 + capboxmove, 1, 6)
                        djui_hud_render_rect(27, 167 + capboxmove, 1, 7)
                        djui_hud_render_rect(28, 167 + capboxmove, 1, 8)
                        djui_hud_render_rect(29, 167 + capboxmove, 1, 9)
                        djui_hud_render_rect(30, 167 + capboxmove, 1, 10)
                        djui_hud_render_rect(31, 167 + capboxmove, 1, 11)
                        djui_hud_render_rect(32, 167 + capboxmove, 1, 12)
                        djui_hud_render_rect(33, 167 + capboxmove, 1, 13)
                        djui_hud_render_rect(34, 167 + capboxmove, 1, 14)
                        djui_hud_render_rect(35, 167 + capboxmove, 1, 15)
                        djui_hud_render_rect(36, 167 + capboxmove, 1, 16)
                    end
                end
                if (m.flags & (MARIO_WING_CAP)) ~= 0 and (m.flags & (MARIO_VANISH_CAP)) == 0 then
                    djui_hud_set_color(255, 0, 0, 255)
                    djui_hud_render_rect(21, 167 + capboxmove, 1, 1)
                    djui_hud_render_rect(22, 167 + capboxmove, 1, 2)
                    djui_hud_render_rect(23, 167 + capboxmove, 1, 3)
                    djui_hud_render_rect(24, 167 + capboxmove, 1, 4)
                    djui_hud_render_rect(25, 167 + capboxmove, 1, 5)
                    djui_hud_render_rect(26, 167 + capboxmove, 1, 6)
                    djui_hud_render_rect(27, 167 + capboxmove, 1, 7)
                    djui_hud_render_rect(28, 167 + capboxmove, 1, 8)
                    djui_hud_render_rect(29, 167 + capboxmove, 1, 9)
                    djui_hud_render_rect(30, 167 + capboxmove, 1, 10)
                    djui_hud_render_rect(31, 167 + capboxmove, 1, 11)
                    djui_hud_render_rect(32, 167 + capboxmove, 1, 12)
                    djui_hud_render_rect(33, 167 + capboxmove, 1, 13)
                    djui_hud_render_rect(34, 167 + capboxmove, 1, 14)
                    djui_hud_render_rect(35, 167 + capboxmove, 1, 15)
                    djui_hud_render_rect(36, 167 + capboxmove, 1, 16)
                    
                end
            elseif (m.flags & (MARIO_VANISH_CAP)) ~= 0 then
                djui_hud_set_color(0, 0, 255, 255)
                djui_hud_render_rect(21, 167 + capboxmove, 16, 16)
                if (m.flags & (MARIO_WING_CAP)) ~= 0 then
                    djui_hud_set_color(255, 0, 0, 255)
                    djui_hud_render_rect(21, 167 + capboxmove, 1, 1)
                    djui_hud_render_rect(22, 167 + capboxmove, 1, 2)
                    djui_hud_render_rect(23, 167 + capboxmove, 1, 3)
                    djui_hud_render_rect(24, 167 + capboxmove, 1, 4)
                    djui_hud_render_rect(25, 167 + capboxmove, 1, 5)
                    djui_hud_render_rect(26, 167 + capboxmove, 1, 6)
                    djui_hud_render_rect(27, 167 + capboxmove, 1, 7)
                    djui_hud_render_rect(28, 167 + capboxmove, 1, 8)
                    djui_hud_render_rect(29, 167 + capboxmove, 1, 9)
                    djui_hud_render_rect(30, 167 + capboxmove, 1, 10)
                    djui_hud_render_rect(31, 167 + capboxmove, 1, 11)
                    djui_hud_render_rect(32, 167 + capboxmove, 1, 12)
                    djui_hud_render_rect(33, 167 + capboxmove, 1, 13)
                    djui_hud_render_rect(34, 167 + capboxmove, 1, 14)
                    djui_hud_render_rect(35, 167 + capboxmove, 1, 15)
                    djui_hud_render_rect(36, 167 + capboxmove, 1, 16)
                end
            elseif (m.flags & (MARIO_WING_CAP)) ~= 0 then
                djui_hud_set_color(255, 0, 0, 255)
                djui_hud_render_rect(21, 167 + capboxmove, 16, 16)
            end 
            djui_hud_set_color(255, 255, 255, 255)
            djui_hud_render_texture(get_texture_info("capbox"), 21, 167 + capboxmove, 1, 1)
        end
    end

    --Downing
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_font(FONT_NORMAL)

    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()

    local m = gMarioStates[0]
    if m.action == _G.ACT_DOWN and not l4d2Hud then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_HUD)
        djui_hud_set_adjusted_color(255, 255, 255, 255)
        djui_hud_print_text(tostring(math.floor(gPlayerSyncTable[0].downHealth)), width * 0.53, 32, 1)
    end

    local near = nearest_mario_state_to_object(m.marioObj)
    if near ~= nil and active_player(near) ~= 0 and dist_between_objects(m.marioObj, near.marioObj) < 250 and near.action == _G.ACT_DOWN and m.action ~= _G.ACT_DOWN and (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_CUTSCENE then
        if not soundPlayed then
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            soundPlayed = true
        end
        if not (l4d2Hud and (m.controller.buttonDown & Z_TRIG) ~= 0) then
            local text = "Help " .. name_without_hex(gNetworkPlayers[near.playerIndex].name) .. " up"
            local out = { x = 0, y = 0, z = 0 }
            djui_hud_world_pos_to_screen_pos(near.pos, out)
            djui_hud_set_adjusted_color(0, 0, 0, 180)
            djui_hud_print_text(text, out.x - (djui_hud_measure_text(text) * 0.5), out.y + 1, 0.5)
            djui_hud_print_text(tostring(math.floor(reviveTimer / 30)), out.x - (djui_hud_measure_text(text) * 0.25), out.y + 13, 0.5)
            djui_hud_set_adjusted_color(255, 255, 255, 255)
            djui_hud_print_text(text, out.x - (djui_hud_measure_text(text) * 0.5), out.y, 0.5)
            djui_hud_print_text(tostring(math.floor(reviveTimer / 30)), out.x - (djui_hud_measure_text(text) * 0.25), out.y + 12, 0.5)
        end
        if (m.controller.buttonDown & Z_TRIG) ~= 0 then
            if reviveTimer > 0 then
                reviveTimer = reviveTimer - 1
                if l4d2Hud then
                    width = (djui_hud_get_screen_width() * 0.5) + 3
                    height = djui_hud_get_screen_height() * 0.5
                    djui_hud_set_adjusted_color(77, 73, 79, 255)
                    djui_hud_render_rect(width - 69, height - 18, 29, 29)
                    djui_hud_render_rect(width - 41, height - 4, 118, 15)
                    djui_hud_set_color(0, 0, 0, 255)
                    djui_hud_render_rect(width - 68, height - 17, 27, 27)
                    djui_hud_render_rect(width - 40, height - 3, 116, 13)
                    -- text
                    djui_hud_set_adjusted_color(255, 255, 255, 255)
                    djui_hud_set_font(FONT_MENU)
                    djui_hud_print_text("+", width - 67, height - 25, 0.6)
                    djui_hud_set_font(FONT_NORMAL)
                    djui_hud_set_color(0, 0, 0, 180)
                    djui_hud_print_text("REVIVING PLAYER", width - 38, height - 20, 0.45)
                    djui_hud_set_adjusted_color(255, 255, 255, 255)
                    djui_hud_print_text("REVIVING PLAYER", width - 38, height - 21, 0.45)
                    -- bar
                    djui_hud_set_adjusted_color(221, 184, 64, 255)
                    local fill = lerp(1.78, 0, (reviveTimer / reviveTime))
                    djui_hud_render_texture(_G.l4dBarTexture, width - 39, height - 2, fill, 0.175)
                end
            else
                reviveTimer = reviveTime
                network_send(true, { id = PACKET_REVIVE, global = network_global_index_from_local(near.playerIndex), savior = gNetworkPlayers[0].globalIndex })
            end
        else
            reviveTimer = reviveTime
        end
    else
        soundPlayed = false
    end

    if m.action == _G.ACT_DOWN then
        djui_hud_set_color(0, 0, 0, lerp(255, 0, gPlayerSyncTable[0].downHealth / 300))
        djui_hud_render_rect(0, 0, width + 2, height + 2)
    end
end

--Star Heal--

local HP_TO_HEAL_COUNTER_UNITS_FACTOR = 1 / 0x40
local MAX_HP_IN_HEAL_COUNTER_UNITS = 0x880 * HP_TO_HEAL_COUNTER_UNITS_FACTOR

local function on_interact(interactor, interactee, interactType, interactValue)
    --FUTURE: add back original condition when it's fixed in source
    --if not interactValue or interactType ~= INTERACT_STAR_OR_KEY then
    if interactType ~= INTERACT_STAR_OR_KEY or interactor.playerIndex ~= 0 then
        return
    end
    
    --FUTURE: exclude stuff that's already collected when source makes it possible
    
    interactor.hurtCounter = 0
    interactor.healCounter = MAX_HP_IN_HEAL_COUNTER_UNITS
        - interactor.health * HP_TO_HEAL_COUNTER_UNITS_FACTOR
end

local once
local TECH_KB = {
    [ACT_GROUND_BONK]             = ACT_BACKWARD_ROLLOUT,
    [ACT_BACKWARD_GROUND_KB]      = ACT_BACKWARD_ROLLOUT,
    [ACT_HARD_BACKWARD_GROUND_KB] = ACT_BACKWARD_ROLLOUT,
    [ACT_HARD_FORWARD_GROUND_KB]  = ACT_FORWARD_ROLLOUT,
    [ACT_FORWARD_GROUND_KB]       = ACT_FORWARD_ROLLOUT,
    [ACT_DEATH_EXIT_LAND]         = ACT_BACKWARD_ROLLOUT,
  
}
local tech_tmr = 0
local burn_press = 0
local slopetimer = 0

z = 0
--Teching hook mario action--

local function localtechaction(m)
    if TECH_KB[m.action] then
        tech_tmr = 0
    end
    if m.action ~= ACT_BURNING_GROUND then
        burn_press = 0
    end
end

--Door Bust Stuff--

define_custom_obj_fields({
    oDoorDespawnedTimer = 'u32',
    oDoorBuster = 'u32'
})

function approach_number(current, target, inc, dec)
    if current < target then
        current = current + inc
        if current > target then
            current = target
        end
    else
        current = current - dec
        if current < target then
            current = target
        end
    end
    return current
end

function lateral_dist_between_object_and_point(obj, pointX, pointZ)
    if obj == nil then return 0 end
    local dx = obj.oPosX - pointX
    local dz = obj.oPosZ - pointZ

    return math.sqrt(dx * dx + dz * dz)
end

--- @param o Object
function bhv_broken_door_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_DAMAGE
    o.oIntangibleTimer = 0
    o.oGraphYOffset = -5
    o.oDamageOrCoinValue = 3
    obj_scale(o, 0.85)

    o.hitboxRadius = 80
    o.hitboxHeight = 100
    o.oGravity = 3
    o.oFriction = 0.8
    o.oBuoyancy = 1

    o.oVelY = 50
end

--- @param o Object
function bhv_broken_door_loop(o)
    if o.oForwardVel > 10 then
        object_step()
        if o.oForwardVel < 30 then
            o.oInteractType = 0
        end
    else
        cur_obj_update_floor()
        o.oFaceAnglePitch = approach_number(o.oFaceAnglePitch, -0x4000, 0x500, 0x500)
    end

    -- TODO debug doors getting stuck on toad or whatever

    obj_flicker_and_disappear(o, 300)
end

id_bhvBrokenDoor = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_broken_door_init, bhv_broken_door_loop)

local visible = false
extraVel = 0
IdiotSound = audio_sample_load("Idiot.mp3")
--- @param m MarioState
function mario_update(m)
    if m.playerIndex ~= 0 then return end

    --Disable PU's
    if (m.pos.x > 57344) or (m.pos.x < -57344) or (m.pos.z > 57344) or (m.pos.z < -57344) then
        warp_restart_level()
        audio_sample_play(IdiotSound, m.pos, 1)
    end

    local obj = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvBlueCoinSwitch)
    if obj ~= nil then
        if m.marioObj.platform == obj or obj.oAction == 1 or obj.oAction == 2 then
            visible = true
        else
            visible = false
        end
    end

    --Teching + New Spam Burnout--
    if m.playerIndex == 0 then
        if TECH_KB[m.action] and m.health > 255 then
        tech_tmr = tech_tmr + 1
            if tech_tmr <= 9.9 and (m.controller.buttonPressed & Z_TRIG) ~= 0 then
                play_character_sound(m, CHAR_SOUND_UH2)
                m.vel.y = 21.0
                m.particleFlags = m.particleFlags | ACTIVE_PARTICLE_SPARKLES
                tech_tmr = 0
                return set_mario_action(m, TECH_KB[m.action], 1)
            end
        end

        if m.action == ACT_BURNING_GROUND then
            if (m.controller.buttonPressed & Z_TRIG) ~= 0 then
                burn_press = burn_press + 1
                m.particleFlags = m.particleFlags | PARTICLE_DUST
                play_sound(SOUND_GENERAL_FLAME_OUT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            end
            if burn_press >= 5 then
                m.marioObj.oMarioBurnTimer = 161
                m.hurtCounter = 0
                set_mario_action(m, ACT_WALKING, 0)
            end
        end
        --Instant Slope Jump--

        if (m.action == ACT_BUTT_SLIDE) or (m.action == ACT_HOLD_BUTT_SLIDE) then
            slopetimer = slopetimer + 1
            if (slopetimer <= 5) and ((m.controller.buttonPressed & A_BUTTON) ~= 0) then
                if (m.action == ACT_BUTT_SLIDE) then
                    set_mario_action(m, ACT_JUMP, 0)
                elseif (m.action == ACT_HOLD_BUTT_SLIDE) then
                    set_mario_action(m, ACT_HOLD_JUMP, 0)
                end
            end
        else
            slopetimer = 0
        end
    end

    --Strafing--
    if strafeToggle == true then
        if m.playerIndex ~= 0 then return end
        m.marioObj.header.gfx.angle.y = m.area.camera.yaw + 32250
    end

    --Door Bust--

    local door = nil
    if m.playerIndex == 0 then
        door = obj_get_first(OBJ_LIST_SURFACE)
        while door ~= nil do
            if door.behavior == get_behavior_from_id(id_bhvDoor) or door.behavior == get_behavior_from_id(id_bhvStarDoor) then
                if door.oDoorDespawnedTimer > 0 then
                    door.oDoorDespawnedTimer = door.oDoorDespawnedTimer - 1
                else
                    door.oPosY = door.oHomeY
                end
            end

            door = obj_get_next(door)
        end
    end

    door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local targetDoor = door
    local starDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)
    if starDoor ~= nil then
        if dist_between_objects(m.marioObj, starDoor) < dist_between_objects(m.marioObj, door) then
            targetDoor = starDoor
        else
            targetDoor = door
        end
    end

    if targetDoor ~= nil then
        local dist = 200
        if m.action == ACT_LONG_JUMP and m.forwardVel <= -70 then dist = 1000 end

        local starRequirement = 0
        if (m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE or m.action == ACT_JUMP_KICK or (m.action == ACT_LONG_JUMP and m.forwardVel <= -80)) and dist_between_objects(m.marioObj, targetDoor) < dist then
            local model = E_MODEL_CASTLE_CASTLE_DOOR
            -- just make obj_get_model_extended dammit
            if obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_1_STAR) ~= 0 then
                model = E_MODEL_CASTLE_DOOR_1_STAR
                starRequirement = 1
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_3_STARS) ~= 0 then
                model = E_MODEL_CASTLE_DOOR_3_STARS
                starRequirement = 3
            elseif obj_has_model_extended(targetDoor, E_MODEL_CCM_CABIN_DOOR) ~= 0 then
                model = E_MODEL_CCM_CABIN_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_METAL_DOOR) ~= 0 then
                model = E_MODEL_HMC_METAL_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_WOODEN_DOOR) ~= 0 then
                model = E_MODEL_HMC_WOODEN_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_BBH_HAUNTED_DOOR) ~= 0 then
                model = E_MODEL_BBH_HAUNTED_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_METAL_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_METAL_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_CASTLE_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_CASTLE_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_HMC_HAZY_MAZE_DOOR) ~= 0 then
                model = E_MODEL_HMC_HAZY_MAZE_DOOR
            elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_GROUNDS_METAL_DOOR) ~= 0 then
                model = E_MODEL_CASTLE_GROUNDS_METAL_DOOR
            elseif targetDoor.behavior == get_behavior_from_id(id_bhvStarDoor) ~= 0 then
                -- model = E_MODEL_CASTLE_STAR_DOOR_8_STARS
                model = E_MODEL_CASTLE_CASTLE_DOOR
                starRequirement = targetDoor.oBehParams >> 24
            end

            if m.numStars >= starRequirement then
                play_sound(SOUND_GENERAL_BREAK_BOX, m.marioObj.header.gfx.cameraToObject)
                targetDoor.oDoorDespawnedTimer = 339
                targetDoor.oPosY = 9999
                spawn_triangle_break_particles(30, 138, 1, 4)
                spawn_non_sync_object(
                    id_bhvBrokenDoor,
                    model,
                    targetDoor.oPosX, targetDoor.oHomeY, targetDoor.oPosZ,
                    --- @param o Object
                    function(o)
                        --if m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE then
                        --    o.oForwardVel = 100
                        --else
                        --    o.oForwardVel = 20

                        --    mario_set_forward_vel(m, -16)
                        --    set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        --    play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                        --end
                        o.oDoorBuster = gNetworkPlayers[m.playerIndex].globalIndex
                        o.oForwardVel = 80
                        set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                    end
                )
                if starRequirement == 50 and m.action == ACT_LONG_JUMP and m.forwardVel <= -80 then
                    set_mario_action(m, ACT_THROWN_BACKWARD, 0)
                    m.forwardVel = -300
                    m.faceAngle.y = -0x8000
                    m.vel.y = 20
                    m.pos.x = -200
                    m.pos.y = 2350
                    m.pos.z = 4900
                else
                    if m.playerIndex == 0 then set_camera_shake_from_hit(SHAKE_SMALL_DAMAGE) end
                end
            end
        end

        if lateral_dist_between_object_and_point(m.marioObj, -200, 6977) < 10 and gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_THROWN_BACKWARD then
            set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 0)
            m.hurtCounter = 4 * 4
            play_character_sound(m, CHAR_SOUND_ATTACKED)
            spawn_triangle_break_particles(20, 138, 3, 4)
            stop_background_music(SEQ_LEVEL_INSIDE_CASTLE)
        end
    end

    if gNetworkPlayers[m.playerIndex].currLevelNum == LEVEL_CASTLE and m.action == ACT_HARD_BACKWARD_AIR_KB and m.prevAction == ACT_THROWN_BACKWARD then
        m.actionTimer = m.actionTimer + 1
        m.invincTimer = 30
        set_camera_shake_from_hit(SHAKE_MED_DAMAGE)
        play_sound(SOUND_GENERAL_METAL_POUND, m.marioObj.header.gfx.cameraToObject)
    end

    --Downing
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    _G.downHealth[m.playerIndex] = gPlayerSyncTable[m.playerIndex].downHealth

    if should_be_downed(m) and not (m.playerIndex == 0 and not gotUp) then
        if m.action ~= _G.ACT_DOWN then play_character_sound(m, CHAR_SOUND_WAAAOOOW) end
        m.action = _G.ACT_DOWN
    end

    if m.action == _G.ACT_DOWN then network_player_set_description(gNetworkPlayers[0], "Down", 255, 0, 0, 255) else network_player_set_description(gNetworkPlayers[0], "", 255, 255, 255, 255) end

    if m.playerIndex ~= 0 then return end

    if gGlobalSyncTable.customFallDamage then
        m.peakHeight = m.pos.y

        if m.vel.y <= -75 then
            extraVel = extraVel + 2.5
            m.vel.y = m.vel.y - extraVel
        end

        if (m.prevAction & ACT_FLAG_AIR) ~= 0 and m.action ~= ACT_LEDGE_GRAB and m.prevAction ~= ACT_TWIRLING and m.prevAction ~= ACT_SHOT_FROM_CANNON and (m.action & ACT_FLAG_AIR) == 0 and m.vel.y <= -90 and m.floor.type ~= SURFACE_BURNING and m.floor.type ~= SURFACE_INSTANT_QUICKSAND then
            local dmgMult = get_fall_damage_multiplier(math.abs(m.vel.y))
            if dmgMult == 15 then
                m.health = 383
            else
                local dmg = (m.vel.y * dmgMult)
                m.health = m.health + dmg
                m.health = clamp(m.health, 0xff, 0x880)
            end
            set_camera_shake_from_hit(SHAKE_FALL_DAMAGE)
            m.squishTimer = 30
            play_character_sound(m, CHAR_SOUND_ATTACKED)
        end

        if (m.action & ACT_FLAG_AIR) == 0 then extraVel = 0 end
    end

    if player_alive_count() < DOWNING_MIN_PLAYERS then return end

    if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_CUTSCENE then gotUp = true end

    local heart = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvRecoveryHeart)
    if heart ~= nil and obj_check_if_collided_with_object(m.marioObj, heart) ~= 0 and gPlayerSyncTable[0].downHealth < 300 then undown(m) end

end

--- @param m MarioState
--- @param o Object
function allow_interact(m, o)
    if o.behavior == get_behavior_from_id(id_bhvBrokenDoor) and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end

--Wallslide--

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if not gPlayerSyncTable[m.playerIndex].wallSlide and mod_storage_load("Wallslide") then return end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        local rc = set_mario_action(m, ACT_WALL_KICK_AIR, 0)
        
        m.vel.y = 60.0

        if m.forwardVel < 20.0 then
            m.forwardVel = 20.0
        end
        m.wallKickTimer = 0
        return rc
    end

    -- attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls
    mario_set_forward_vel(m, -1.0)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    set_mario_animation(m, MARIO_ANIM_START_WALLKICK)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        mario_set_forward_vel(m, 0.0)
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end
    end

    m.actionTimer = m.actionTimer + 1
    if m.wall == nil and m.actionTimer > 2 then
        mario_set_forward_vel(m, 0.0)
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    -- gravity
    m.vel.y = m.vel.y + 3.5

    return 0
end

--The 60 degree part

local actions_able_to_wallkick =
{
    [ACT_JUMP] = ACT_JUMP,
    [ACT_HOLD_JUMP] = ACT_HOLD_JUMP,
    [ACT_DOUBLE_JUMP] = ACT_DOUBLE_JUMP,
    [ACT_TRIPLE_JUMP] = ACT_TRIPLE_JUMP,
    [ACT_SIDE_FLIP] = ACT_SIDE_FLIP,
    [ACT_BACKFLIP] = ACT_BACKFLIP,
    [ACT_LONG_JUMP] = ACT_LONG_JUMP,
    [ACT_WALL_KICK_AIR] = ACT_WALL_KICK_AIR,
    [ACT_TOP_OF_POLE_JUMP] = ACT_TOP_OF_POLE_JUMP,
    [ACT_FREEFALL] = ACT_FREEFALL
}

--This is in degrees
gGlobalSyncTable.limit = 61

--Thanks Djoslin
function convert_s16(num)
    local min = -32768
    local max = 32767
    while (num < min) do
        num = max + (num - min)
    end
    while (num > max) do
        num = min + (num - max)
    end
    return num
end

--This is mostly copied from the wall bonk check code
---@param m MarioState
function wallkicks(m)
    if m.playerIndex ~= 0 then return end
    if not gPlayerSyncTable[m.playerIndex].wallSlide then return end
    if m.wall ~= nil then
        if (m.wall.type == SURFACE_BURNING) then return end

        local wallDYaw = (atan2s(m.wall.normal.z, m.wall.normal.x) - (m.faceAngle.y))
        --I don't really understand this however I do know the lower `limit` becomes, the more possible wallkick degrees.
        local limitNegative = (-((180 - gGlobalSyncTable.limit) * (8192/45))) + 1
        local limitPositive = ((180 - gGlobalSyncTable.limit) * (8192/45)) - 1
        --wallDYaw is s16, so I converted it
        wallDYaw = convert_s16(wallDYaw)

        --Standard air hit wall requirements
        if (m.forwardVel >= 16) and (actions_able_to_wallkick[m.action] ~= nil) then
            if (wallDYaw >= limitPositive) or (wallDYaw <= limitNegative) then
                mario_bonk_reflection(m, 0)
                m.faceAngle.y = m.faceAngle.y + 0x8000
                set_mario_action(m, ACT_AIR_HIT_WALL, 0)
            end
        end
    end
end

local function ternary(condition, ifTrue, ifFalse)
    if condition then
        return ifTrue
    end
    return ifFalse
end

local quicksand_death_surfaces = {
    [SURFACE_INSTANT_QUICKSAND] = true,
    [SURFACE_INSTANT_MOVING_QUICKSAND] = true
}

local noStrafeActs = {
    [ACT_WALKING] = true,
    [ACT_BRAKING] = true,
    [ACT_BRAKING_STOP] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_WALL_SLIDE] = true,
    [ACT_STAR_DANCE_EXIT] = true,
    [ACT_STAR_DANCE_NO_EXIT] = true,
    [ACT_STAR_DANCE_WATER] = true,
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_HOLD_JUMP] = true,
    [ACT_DEATH_EXIT] = true,
    [ACT_UNUSED_DEATH_EXIT] = true,
    [ACT_FALLING_DEATH_EXIT] = true,
    [ACT_SPECIAL_DEATH_EXIT] = true,
}

--- @param m MarioState
function on_set_mario_action(m)
    --Swim Star Anim--
    if (m.action == ACT_FALL_AFTER_STAR_GRAB) then
        m.action = ACT_STAR_DANCE_WATER
    end

    --Lava Groundpound--
    if LGP then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_LAVA_BOOST then
            m.vel.y = m.vel.y * 1.1
            m.forwardVel = 70
            m.health = m.health - 272
        end
    end
    
    --Anti quicksand--
    if AQS and gGlobalSyncTable.GlobalAQS then
        if m.action == ACT_QUICKSAND_DEATH then
            set_mario_action(m, ACT_LAVA_BOOST, 0)
            if m.flags & MARIO_METAL_CAP ~= 0 then
                return
            elseif m.flags & MARIO_CAP_ON_HEAD ~= 0 then
                m.hurtCounter =  12
            elseif m.flags & MARIO_CAP_ON_HEAD == 0 then
                m.hurtCounter =  18
            end
        end
    end

    --wallslide--
    if m.action == ACT_SOFT_BONK and gPlayerSyncTable[m.playerIndex].wallSlide then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        set_mario_action(m, ACT_WALL_SLIDE, 0)
    end

    --Strafing--
    if strafeToggle == true then
        if not noStrafeActs[m.action] then
            m.faceAngle.y = m.area.camera.yaw + 32250
        end
    end

    --Downing--
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    if m.playerIndex ~= 0 or player_alive_count() < DOWNING_MIN_PLAYERS then return end

    if (m.prevAction == _G.ACT_DOWN or should_be_downed(m)) and (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED then
        m.health = 0xff
    end
end

function update()
    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if (not SSC) and ((c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN)) then
        disable_time_stop_including_mario()
        m.freeze = 0
        c.cutscene = 0
    end
end

--Downing

_G.downHealth = {}
for i = 0, (MAX_PLAYERS - 1) do
    downHealth[i] = 300
end

gGlobalSyncTable.downing = true
gGlobalSyncTable.customFallDamage = false

PACKET_REVIVE = 0
PACKET_POPUP = 1

DOWNING_MIN_PLAYERS = 2

gotUp = false

function check_for_mod(name, find)
    local has = false
    for k, v in pairs(gActiveMods) do
        if find then
            if v.enabled and v.name:find(name) then has = true end
        else
            if v.enabled and v.name == name then has = true end
        end
    end
    return has
end

function on_or_off(value)
    if value then return "\\#00ff00\\ON" end
    return "\\#ff0000\\OFF"
end

function clamp(x, a, b)
    if x < a then return a end
    if x > b then return b end
    return x
end

function approach_number(current, target, inc, dec)
    if current < target then
        current = current + inc
        if current > target then
            current = target
        end
    else
        current = current - dec
        if current < target then
            current = target
        end
    end
    return current
end

function lerp(a,b,t) return a * (1-t) + b * t end

function s16(num)
    num = math.floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
end

--- @param m MarioState
function active_player(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return 1
    end
    if not np.connected then
        return 0
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return 0
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return 0
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return 0
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return 0
    end
    return is_player_active(m)
end

function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

function name_without_hex(name)
    local s = ''
    local inSlash = false
    for i = 1, #name do
        local c = name:sub(i,i)
        if c == '\\' then
            inSlash = not inSlash
        elseif not inSlash then
            s = s .. c
        end
    end
    return s
end

l4d2Hud = check_for_mod("Left 4 Dead 2 HUD", false)

--- @param m MarioState
function update_fvel(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    local maxTargetSpeed = 32
    local targetSpeed

    if m.intendedMag < maxTargetSpeed then targetSpeed = m.intendedMag else targetSpeed = maxTargetSpeed end

    if m.forwardVel <= 0 then
        m.forwardVel = m.forwardVel + 1.1
    elseif m.forwardVel <= targetSpeed then
        m.forwardVel = m.forwardVel + 1.1 - m.forwardVel / 43
    elseif m.floor.normal.y >= 0.95 then
        m.forwardVel = m.forwardVel - 1
    end

    if m.forwardVel > 48 then
        m.forwardVel = 48
    end

    m.faceAngle.y = s16(approach_s32(m.faceAngle.y, m.intendedYaw, 0x300, 0x300))
    apply_slope_accel(m)
end

--- @param m MarioState
function undown(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    m.healCounter = 8
    set_mario_action(m, ACT_IDLE, 0)
    m.invincTimer = 60
    gPlayerSyncTable[m.playerIndex].downHealth = 300
    play_character_sound(m, CHAR_SOUND_OKEY_DOKEY)
end

--- @param m MarioState
function kill_downed(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    gPlayerSyncTable[m.playerIndex].downHealth = 300
    m.health = 0xff
    set_mario_action(m, ACT_IDLE, 0)
end

--- @param m MarioState
function act_down(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    if player_alive_count() < DOWNING_MIN_PLAYERS then
        kill_downed(m)
    end

    m.actionTimer = m.actionTimer + 1

    set_mario_animation(m, MARIO_ANIM_DYING_ON_BACK)
    if m.marioObj.header.gfx.animInfo.animFrame > 35 then m.marioObj.header.gfx.animInfo.animFrame = 35 end
    update_fvel(m)
    m.vel.x = m.vel.x * 0.01
    m.vel.z = m.vel.z * 0.01
    perform_ground_step(m)
    m.pos.y = m.floorHeight

    if m.playerIndex == 0 then
        if gPlayerSyncTable[0].downHealth > 0 then
            m.health = 0x180
        else
            kill_downed(m)
        end

        if m.actionTimer % 30 == 0 then gPlayerSyncTable[0].downHealth = gPlayerSyncTable[0].downHealth - 1 end
        if m.hurtCounter > 0 then
            gPlayerSyncTable[0].downHealth = gPlayerSyncTable[0].downHealth - m.hurtCounter * 4
            m.hurtCounter = 0
            m.invincTimer = 60
            play_character_sound(m, CHAR_SOUND_ATTACKED)
        end

        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then kill_downed(m) end
    end
end
_G.ACT_DOWN = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_SHORT_HITBOX)

--- @param m MarioState
function is_hazard_floor(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    return m.floor.type == SURFACE_BURNING
    or m.floor.type == SURFACE_QUICKSAND
    or m.floor.type == SURFACE_DEEP_QUICKSAND
    or m.floor.type == SURFACE_MOVING_QUICKSAND
    or m.floor.type == SURFACE_INSTANT_QUICKSAND
    or m.floor.type == SURFACE_SHALLOW_QUICKSAND
    or m.floor.type == SURFACE_DEEP_MOVING_QUICKSAND
    or m.floor.type == SURFACE_INSTANT_MOVING_QUICKSAND
    or m.floor.type == SURFACE_SHALLOW_MOVING_QUICKSAND
    or m.floor.type == SURFACE_DEATH_PLANE
end

--- @param m MarioState
function should_be_downed(m)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    return m.health < 0x180
    and m.health > 0xff
    and (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_CUTSCENE
    and m.action ~= ACT_SPECIAL_DEATH_EXIT
    and m.action ~= ACT_FALLING_DEATH_EXIT
    and m.action ~= ACT_DEATH_EXIT
    and m.action ~= ACT_DEATH_EXIT_LAND
    and (m.action & ACT_FLAG_INTANGIBLE) == 0
    and not is_hazard_floor(m)
end

function get_fall_damage_multiplier(vel)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    if vel >= 90 and vel < 100 then return 5
    elseif vel >= 100 and vel < 115 then return 10
    elseif vel >= 115 and vel < 130 then return 15
    elseif vel >= 130 then return 20 end

    return 20
end

function player_alive_count()
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    local count = 0
    for i = 0, (MAX_PLAYERS - 1) do
        if active_player(gMarioStates[i]) ~= 0 then count = count + 1 end
    end
    return count
end

--- @param m MarioState
function on_player_connected(m)
    gPlayerSyncTable[m.playerIndex].downHealth = 300
end

reviveTime = 210
reviveTimer = reviveTime
soundPlayed = false

function on_packet_receive(dataTable)
    if gGlobalSyncTable.bubbleDeath ~= 2 then return end
    local m = gMarioStates[0]

    if dataTable.id == PACKET_REVIVE then
        if network_global_index_from_local(m.playerIndex) == dataTable.global then
            undown(m)
            vec3f_copy(m.pos, gMarioStates[network_local_index_from_global(dataTable.savior)].pos)
        end
    elseif dataTable.id == PACKET_POPUP then
        djui_popup_create(dataTable.msg, 1)
    end
end

function on_level_init()
    if gPlayerSyncTable[0].downHealth ~= nil then gPlayerSyncTable[0].downHealth = 300 end
    gotUp = false
end

function on_pause_exit()
    if gPlayerSyncTable[0].downHealth < 300 or gMarioStates[0].action == _G.ACT_DOWN then return false end
    return true
end

function on_downhealth_changed(tag, oldVal, newVal)
    if oldVal == 300 and newVal ~= 300 then djui_popup_create(gNetworkPlayers[tag].name .. "\\#ffff00\\ is down!", 1) end
end

function on_custom_fall_damage_command()
    gGlobalSyncTable.customFallDamage = not gGlobalSyncTable.customFallDamage
    djui_chat_message_create("Custom fall damage status: " .. on_or_off(gGlobalSyncTable.customFallDamage))
    return true
end

for i = 1, (MAX_PLAYERS - 1) do
    hook_on_sync_table_change(gPlayerSyncTable[i], "downHealth", i, on_downhealth_changed)
end

--For blue coin preview
function bhv_custom_hidden_blue_coin_loop(obj)
    if visible then
        cur_obj_enable_rendering()
    else
        cur_obj_disable_rendering()
    end
end

--Visable Lakitu--
-- define our variables to hold the global id of each Lakitu's owner, and its blink timer
define_custom_obj_fields({ oLakituOwner = 'u32', oLakituBlinkTimer = 's32' })

-- for some reason Lua doesn't treat booleans as 1/0 numbers
local boolToNumber = { [true] = 1, [false] = 0 }

local function obj_update_blinking(o, timer, base, range, length)
    -- update our timer
    if timer > 0 then timer = timer - 1
    else timer = base + (range * math.random()) end

    -- set Lakitu's blink state depending on what our timer is at
    o.oAnimState = boolToNumber[(timer <= length)]
    return timer
end

local function is_current_area_sync_valid()
    -- check all connected players to see if their area sync is valid
    for i = 0, (MAX_PLAYERS - 1) do
        local np = gNetworkPlayers[i]
        if np ~= nil and np.connected and (not np.currLevelSyncValid or not np.currAreaSyncValid) then
            return false
        end
    end
    return true
end

local function active_player(m, np)
    -- check if this player is connected and in the same level
    if not np.connected or np.currCourseNum ~= gNetworkPlayers[0].currCourseNum or np.currActNum ~= gNetworkPlayers[0].currActNum or np.currLevelNum ~= gNetworkPlayers[0].currLevelNum or
        np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return is_player_active(m)
end

local function obj_mark_for_deletion_on_sync(o)
    -- delete this Lakitu if the area's sync status is valid
    if gNetworkPlayers[0].currAreaSyncValid then obj_mark_for_deletion(o) end
end

local function bhv_custom_lakitu_init(o)
    -- set up Lakitu's flags
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    -- use the default Lakitu animations
    o.oAnimations = gObjectAnimations.lakitu_seg6_anims_060058F8
    cur_obj_init_animation(0)

    -- spawn Lakitu's cloud if this isn't the local player's Lakitu
    if network_local_index_from_global(o.oLakituOwner) ~= 0 then
        spawn_non_sync_object(id_bhvCloud, E_MODEL_MIST, o.oPosX, o.oPosY, o.oPosZ,
            function(obj)
                -- make the cloud a child of Lakitu
                obj.parentObj = o
                -- sm64 knows this is a Lakitu cloud if oBehParams2ndByte is set to 1
                -- if oBehParams2ndByte is 0, the cloud will behave as a Fwoosh
                obj.oBehParams2ndByte = 1
                -- make the cloud twice the size size of a normal cloud (all Lakitu clouds do this)
                obj_scale(obj, 2)
            end)
    end

    -- init the networked Lakitu
    network_init_object(o, true, { "oLakituOwner", "oFaceAngleYaw", "oFaceAnglePitch" })
end

local function bhv_custom_lakitu(o)
    -- get the gNetworkPlayers table for the player that owns this Lakitu
    local np = network_player_from_global_index(o.oLakituOwner)
    -- this isn't a valid network player, delete this Lakitu
    if np == nil then
        obj_mark_for_deletion_on_sync(o)
        return
    end

    -- get the mario state of the player that owns this Lakitu
    local m = gMarioStates[np.localIndex]

    -- don't update this Lakitu if it isn't our Lakitu
    if m.playerIndex ~= 0 then
        -- delete this Lakitu if it's owner isn't active
        if not active_player(m, np) then
            obj_mark_for_deletion_on_sync(o)
            return
        end
        -- show the Lakitu for other players
        cur_obj_unhide()

        -- determine whether Lakitu should blink
        o.oLakituBlinkTimer = obj_update_blinking(o, o.oLakituBlinkTimer, 20, 40, 4)
        return
    else
        -- the local player cannot see it's own Lakitu
        cur_obj_hide()
    end

    -- set the Lakitu position to the camera position of that player
    o.oPosX = gLakituState.curPos.x
    o.oPosY = gLakituState.curPos.y
    o.oPosZ = gLakituState.curPos.z

    -- look at Mario
    o.oHomeX = gLakituState.curFocus.x
    o.oHomeZ = gLakituState.curFocus.z

    o.oFaceAngleYaw = cur_obj_angle_to_home()
    o.oFaceAnglePitch = atan2s(cur_obj_lateral_dist_to_home(), o.oPosY - gLakituState.curFocus.y)

    -- send the current state of our Lakitu to other players if the area sync is valild
    if is_current_area_sync_valid() then
        network_send_object(o, false)
    end
end

local bhvPlayerLakitu = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_custom_lakitu_init, bhv_custom_lakitu)

-- spawn the local player's Lakitu when the area's sync state is valid (every time the player warps areas)
local function update_lakitu()
    -- spawn Lakitu with our custom Lakitu behavior and the default Lakitu model; and mark it as a sync object
    spawn_sync_object(bhvPlayerLakitu, E_MODEL_LAKITU, 0, 0, 0, function(o)
        -- save the global id of the player that owns this Lakitu
        o.oLakituOwner = gNetworkPlayers[0].globalIndex
    end)
end

hook_behavior(id_bhvHiddenBlueCoin, OBJ_LIST_LEVEL, false, nil, bhv_custom_hidden_blue_coin_loop)
hook_mario_action(_G.ACT_DOWN, act_down, INTERACT_PLAYER)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, localtechaction)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_ON_HUD_RENDER, display)
hook_event(HOOK_ON_INTERACT, on_interact)
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_mario_action(ACT_WALL_SLIDE, act_wall_slide)
hook_event(HOOK_BEFORE_PHYS_STEP, wallkicks)
hook_event(HOOK_ON_PLAYER_CONNECTED, on_player_connected)
hook_event(HOOK_ON_PACKET_RECEIVE, on_packet_receive)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_ON_PAUSE_EXIT, on_pause_exit)
hook_event(HOOK_ON_SYNC_VALID, update_lakitu)