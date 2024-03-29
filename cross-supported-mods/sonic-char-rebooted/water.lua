ACT_SONIC_WATER_FALLING =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_SONIC_WATER_STANDING =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_IDLE | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_SONIC_WATER_WALKING =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_SONIC_WATER_SPINDASH =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT
)
ACT_SONIC_WATER_ROLLING =
allocate_mario_action(
ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING |
ACT_FLAG_WATER_OR_TEXT
)

function sonic_underwater_check_object_grab(m)
    if (m.marioObj.collidedObjInteractTypes & INTERACT_GRABBABLE) ~= 0 then
        local object = mario_get_collided_object(m, INTERACT_GRABBABLE)
        local dx = object.oPosX - m.pos.x
        local dz = object.oPosZ - m.pos.z
        local dAngleToObject = atan2s(dz, dx) - m.faceAngle.x
        if (dAngleToObject >= -0x2AAA and dAngleToObject <= 0x2AAA) then
            m.usedObj = object
            mario_grab_used_object(m)
            if (m.heldObj ~= nil) then
                m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
                if m.heldObj.behavior == get_behavior_from_id(id_bhvKoopaShellUnderwater) then
                    if (m.playerIndex == 0) then play_shell_music() end
                    set_mario_action(m, ACT_WATER_SHELL_SWIMMING, 0)
                else
                    set_mario_action(m, ACT_HOLD_WATER_ACTION_END, 1)
                end
                return true
            end
        end
    end
end

function act_sonic_water_falling(m)
    if gPlayerSyncTable[0].modelId == E_MODEL_SONIC then
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            m.health = m.health + 0x100
        end

        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x300, 0x300)
            mario_set_forward_vel(m, 20)
        else
            mario_set_forward_vel(m, 0)
        end
        if m.vel.y < -20 then
            m.vel.y = m.vel.y + 5
        end
        if m.actionArg == 0 then
            if m.heldObj ~= nil then
                set_mario_animation(m, MARIO_ANIM_FALL_WITH_LIGHT_OBJ)
            else
                set_mario_animation(m, MARIO_ANIM_GENERAL_FALL)
            end
        elseif m.actionArg == 1 then
            if m.heldObj ~= nil then
                set_mario_animation(m, MARIO_ANIM_FALL_WITH_LIGHT_OBJ)
            else
                set_mario_animation(m, MARIO_ANIM_FALL_FROM_WATER)
            end
        else
            if m.heldObj ~= nil then
                set_mario_animation(m, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ)
            else
                set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)
            end
        end
        stepResult = perform_air_step(m, 0)
        if stepResult == AIR_STEP_LANDED then --hit floor or cancelled
            set_mario_action(m, ACT_SONIC_WATER_STANDING, 0)
        end
        if (m.input & INPUT_A_PRESSED) ~= 0 and m.actionTimer >= 1 and m.heldObj == nil then
            m.vel.y = 40
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
        end

        if (m.pos.y >= m.waterLevel - 150) then
            set_mario_particle_flags(m, PARTICLE_IDLE_WATER_WAVE, false)
            if (m.input & INPUT_A_PRESSED) ~= 0 then
                set_mario_particle_flags(m, PARTICLE_WATER_SPLASH, false)
                return set_mario_action(m, ACT_WATER_JUMP, 0)
            end
        end
        m.actionTimer = m.actionTimer + 1
        return 0
    else
        return set_mario_action(m, ACT_WATER_IDLE, 0)
    end
end

function act_sonic_water_standing(m)
    if gPlayerSyncTable[0].modelId == E_MODEL_SONIC then
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            m.health = m.health + 0x100
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            m.vel.y = 40
            mario_set_forward_vel(m, 0)
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
        end

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            if m.heldObj ~= nil then
                mario_drop_held_object(m)
            else
                audio_sample_play(SOUND_SONIC_SPIN, m.pos, 1)
                return set_mario_action(m, ACT_SONIC_WATER_SPINDASH, 0)
            end
        end

        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            return set_mario_action(m, ACT_SONIC_WATER_WALKING, 0)
        end


        if m.heldObj ~= nil then
            set_mario_animation(m, MARIO_ANIM_IDLE_WITH_LIGHT_OBJ)
        else
            if m.actionState == 0 then
                set_mario_animation(m, MARIO_ANIM_IDLE_HEAD_LEFT)
            elseif m.actionState == 1 then
                set_mario_animation(m, MARIO_ANIM_IDLE_HEAD_RIGHT)
            elseif m.actionState == 2 then
                set_mario_animation(m, MARIO_ANIM_IDLE_HEAD_CENTER)
            end
        end

        if is_anim_at_end(m) ~= 0 then
            if m.actionState >= 3 then
                m.actionState = 0
            else
                m.actionState = m.actionState + 1
            end
        end

        if (m.pos.y >= m.waterLevel - 150) then
            set_mario_particle_flags(m, PARTICLE_IDLE_WATER_WAVE, false)
        end

        return 0
    else
        return set_mario_action(m, ACT_WATER_IDLE, 0)
    end
end

function act_sonic_water_walking(m)
    local e = gMarioStateExtras[m.playerIndex]
    if gPlayerSyncTable[0].modelId == E_MODEL_SONIC then
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            m.health = m.health + 0x100
        end

        if (m.input & INPUT_FIRST_PERSON) ~= 0 then
            return set_mario_action(m, ACT_SONIC_WATER_STANDING, 0)
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            m.vel.y = 40
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
        end

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            if m.heldObj ~= nil then
                mario_drop_held_object(m)
            else
                audio_sample_play(SOUND_SONIC_SPIN, m.pos, 1)
                set_mario_action(m, ACT_SONIC_WATER_SPINDASH, 0)
            end
        end

        if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
            mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 5, 5))
            if math.abs(m.forwardVel) < 2 then
                return set_mario_action(m, ACT_SONIC_WATER_STANDING, 0)
            end
        end

        update_walking_speed(m)
        local stepResult = perform_ground_step(m)

        if stepResult == GROUND_STEP_LEFT_GROUND then
            set_mario_action(m, ACT_SONIC_WATER_FALLING, 1)
        elseif stepResult == GROUND_STEP_NONE then
            if m.heldObj ~= nil then
                anim_and_audio_for_hold_walk(m)
            else
                sonic_anim_and_audio_for_walk(m)
            end
            mario_set_forward_vel(m, m.forwardVel)
        elseif stepResult == GROUND_STEP_HIT_WALL then
            push_or_sidle_wall(m, m.pos)
            m.actionTimer = 0
        end

        return 0
    else
        return set_mario_action(m, ACT_WATER_IDLE, 0)
    end
end

-- This version of rolling was modified from EM's version.
function act_water_roll(m)
    local e = gMarioStateExtras[m.playerIndex]
    if m.actionTimer == 0 then
        e.rotAngle = 0x000
    end
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = 40
        mario_set_forward_vel(m, m.forwardVel)
        return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
    end

    if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
        e.spamdashdelay = 3
        set_mario_action(m, ACT_SONIC_WATER_WALKING, 0)
    end

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_NONE then
        if mario_floor_is_slope(m) ~= 0 or mario_floor_is_steep(m) ~= 0 then
            apply_slope_accel(m)
        else
            mario_set_forward_vel(m, m.forwardVel - 1)
        end
        m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x1000, 0x1000)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        mario_set_forward_vel(m, -16.0)

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        return set_mario_action(m, ACT_GROUND_BONK, 0)
    elseif stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.playerIndex == 0 then
        sonic_underwater_check_object_grab(m)
    end

    if math.abs(m.forwardVel) < 10 then
        set_mario_action(m, ACT_SONIC_WATER_WALKING, 0)
    end
    e.rotAngle = e.rotAngle + (0x50 * m.forwardVel)
    if e.rotAngle > 0x9000 then
        e.rotAngle = e.rotAngle - 0x9000
    end
    set_anim_to_frame(m, 10 * e.rotAngle / 0x9000)

    m.actionTimer = m.actionTimer + 1

    return false
end

function act_water_spindash(m)
    local e = gMarioStateExtras[m.playerIndex]
    local MAXDASH = 12
    local MINDASH = 5

    if gPlayerSyncTable[0].modelId == E_MODEL_SONIC then
        if (m.flags & MARIO_METAL_CAP) ~= 0 then
            m.health = m.health + 0x100
        end
        -- Spindash revving
        e.dashspeed = e.dashspeed + 0.5
        if m.actionTimer == 0 then
            e.dashspeed = 0
        end
        if e.dashspeed < MINDASH then
            e.dashspeed = MINDASH
        elseif e.dashspeed > MAXDASH then
            e.dashspeed = MAXDASH
            m.particleFlags = m.particleFlags | PARTICLE_SPARKLES
        end
        set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)
        set_anim_to_frame(m, e.animFrame)
        if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
            e.animFrame = e.animFrame - m.marioObj.header.gfx.animInfo.curAnim.loopEnd
        end
        if (m.controller.buttonDown & B_BUTTON) == 0 then
            mario_set_forward_vel(m, e.dashspeed * 5)
            audio_sample_play(SOUND_SONIC_DASH, m.pos, 1)
            audio_sample_stop(SOUND_SONIC_SPIN)
            return set_mario_action(m, ACT_SONIC_WATER_ROLLING, 0)
        end
        if (m.controller.buttonDown & A_BUTTON) ~= 0 then
            m.vel.y = 40
            mario_set_forward_vel(m, 0)
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
        end


        if m.playerIndex == 0 then
            sonic_underwater_check_object_grab(m)
        end
        m.particleFlags = m.particleFlags | PARTICLE_DUST
        e.animFrame = e.animFrame + (e.dashspeed / 4)
        m.actionTimer = m.actionTimer + 1
        local stepResult = perform_air_step(m, 0)
        if stepResult == GROUND_STEP_LEFT_GROUND then
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 1)
        end

        m.forwardVel = approach_f32(m.forwardVel, 0.0, 1, 1)
        m.faceAngle.y = m.intendedYaw
        m.marioObj.header.gfx.angle.y = m.intendedYaw
        return 0
    end
    m.actionTimer = m.actionTimer + 1
end

function mario_update(m)
    if gPlayerSyncTable[0].modelId == E_MODEL_SONIC then
        local waterActions =
        m.action == ACT_WATER_PLUNGE or m.action == ACT_WATER_IDLE or m.action == ACT_FLUTTER_KICK or
        m.action == ACT_SWIMMING_END or
        m.action == ACT_WATER_ACTION_END or
        m.action == ACT_HOLD_WATER_IDLE or
        m.action == ACT_HOLD_WATER_JUMP or
        m.action == ACT_HOLD_WATER_ACTION_END or
        (m.action & ACT_FLAG_METAL_WATER) ~= 0 or
        m.action == ACT_BREASTSTROKE
        if waterActions then
            if m.vel.y <= -25 then
                set_mario_particle_flags(m, PARTICLE_WATER_SPLASH, false)
            end
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 0)
        end
        if m.action == ACT_SONIC_WATER_FALLING and (m.controller.buttonDown & Z_TRIG) ~= 0 then
            m.vel.y = -50.0
            set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, false)
            m.marioObj.header.gfx.scale.y = 1.5
            m.marioObj.header.gfx.scale.z = 0.7
            m.marioObj.header.gfx.scale.x = 0.7
            return set_mario_action(m, ACT_SONIC_WATER_FALLING, 2)
        end
    end
end

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

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_mario_action(ACT_SONIC_WATER_FALLING, act_sonic_water_falling)
hook_mario_action(ACT_SONIC_WATER_STANDING, act_sonic_water_standing)
hook_mario_action(ACT_SONIC_WATER_WALKING, act_sonic_water_walking)
hook_mario_action(ACT_SONIC_WATER_SPINDASH, act_water_spindash)
hook_mario_action(ACT_SONIC_WATER_ROLLING, act_water_roll)
