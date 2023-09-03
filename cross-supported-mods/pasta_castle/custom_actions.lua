------------------------ GLOBAL TO LOCAL ------------------------

local
audio_sample_stop, set_mario_action, is_anim_at_end, is_anim_past_end, perform_ground_step, perform_air_step, mario_throw_held_object, mario_set_forward_vel,
set_mario_animation, set_mario_anim_with_accel, play_character_sound, play_sound, play_mario_sound, drop_and_set_mario_action, atan2s, update_air_without_turn,
approach_f32 =

audio_sample_stop, set_mario_action, is_anim_at_end, is_anim_past_end, perform_ground_step, perform_air_step, mario_throw_held_object, mario_set_forward_vel,
set_mario_animation, set_mario_anim_with_accel, play_character_sound, play_sound, play_mario_sound, drop_and_set_mario_action, atan2s, update_air_without_turn,
approach_f32 

------------------------ ACTION CONSTANTS ------------------------

ACT_SUPER_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING |
ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_SUPER_JUMP_CANCEL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING |
ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)

ACT_WALL_RUN = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING |
ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_COMET_DIVE = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

ACT_RECOVER_ROLL = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_FIRST_PERSON |
ACT_FLAG_ATTACKING)

ACT_GROUND_GRAB = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)
ACT_AIR_GRAB = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION |
ACT_FLAG_ATTACKING)
ACT_WATER_GRAB = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_ATTACKING)

ACT_PILEDRIVER = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_THROWING)

ACT_SPIN_THROW = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING | ACT_FLAG_THROWING)

ACT_UPPERCUT = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION |
ACT_FLAG_ATTACKING)

ACT_TAUNT = allocate_mario_action(ACT_GROUP_AUTOMATIC | ACT_FLAG_INVULNERABLE)
ACT_WATER_TAUNT = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_INVULNERABLE)

ACT_PARRY = allocate_mario_action(ACT_GROUP_AUTOMATIC | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WATER_PARRY = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)

ACT_BREAKDANCE = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_SHORT_HITBOX)

ACT_BELLY_DASH = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_SHORT_HITBOX | ACT_FLAG_ATTACKING)

ACT_AIR_TURNING = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_LONG_FALL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_LONG_FALL_LAND = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY)

ACT_WALL_CRASH = allocate_mario_action(ACT_GROUP_AUTOMATIC | ACT_FLAG_INVULNERABLE)

ACT_CEIL_CRASH = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_ROLL = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_SHORT_HITBOX | ACT_FLAG_ATTACKING)

ACT_PEPPINO_WATER_IDLE = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT)

ACT_PEPPINO_SWIM = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT)

ACT_WATER_DRIFT = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT)

ACT_DOLPHIN_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_HURT = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_INVULNERABLE)
ACT_WATER_HURT = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_METAL_WATER | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_INVULNERABLE)

ACT_GRAB_AIR_CANCEL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

ACT_THROW_ATTACK = allocate_mario_action(ACT_GROUP_OBJECT | ACT_FLAG_ATTACKING | ACT_FLAG_THROWING | ACT_FLAG_INVULNERABLE)

------------------------ ACTION REWRITES ------------------------

--- @param m MarioState
update_new_walk_speed = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local canMachRun = (_G.pcCharacter ~= "Mario" and sprintMode) and true or false

    local maxTargetSpeed
    local targetSpeed

    local maxSpeed = 32
    local speedBaseGain = 1.1
    local accelLoss = 40
    local turnSpeed = 0x800

    if _G.pcCharacter == "Peppino" then
        maxSpeed = canMachRun and 120 or 32
        speedBaseGain = 2.4
        accelLoss = 37
    elseif _G.pcCharacter == "Gustavo" then
        maxSpeed = canMachRun and 76 or 32
        speedBaseGain = 2.8
        accelLoss = 27
    end

    if p.machLevel < 1 and _G.pcCharacter ~= "Mario" then
        speedBaseGain = 3
    end

    if m.floor.type == SURFACE_SLOW and m.floor ~= nil then
        maxTargetSpeed = 24
    else
        maxTargetSpeed = maxSpeed
    end

    if p.machLevel >= 3 and m.forwardVel < 120 and _G.pcCharacter == "Peppino" then
        m.forwardVel = m.forwardVel + 2.2
    end

    targetSpeed = m.intendedMag / 32 < maxTargetSpeed / maxSpeed and m.intendedMag or maxTargetSpeed

    if m.quicksandDepth > 10 then
        targetSpeed = targetSpeed * 6.25 / m.quicksandDepth
    end

    if m.forwardVel > 48 and _G.pcCharacter == "Mario" then
        m.forwardVel = 48
    end

    if canMachRun then
        apply_slope_accel(m)
    end

    if m.forwardVel <= 0 then
        m.forwardVel = m.forwardVel + speedBaseGain
    elseif m.forwardVel < targetSpeed then
        m.forwardVel = m.forwardVel + speedBaseGain - m.forwardVel / accelLoss
    elseif m.floor.normal.y >= 0.95 and m.floor ~= nil then
        m.forwardVel = m.forwardVel - 1.1
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, turnSpeed, turnSpeed)

    apply_slope_accel(m)
end

--- @param m MarioState
local new_anim_and_audio_for_walk = function(m)
    local p = gPeppinoStates[m.playerIndex]

    if p.machLevel <= 1 or _G.pcCharacter == "Mario" then
        anim_and_audio_for_walk(m)
        return
    end

    if p.machLevel == 2 then
        if _G.pcCharacter == "Peppino" then
            set_custom_anim(m, "MARIO_ANIM_MACH_RUN")
        else
            set_custom_anim(m, "GUS_ANIM_MACH_RUN")
            m.marioBodyState.punchState = (1 << 6) | 2
        end
        play_step_sound(m, 2, 4)
        play_step_sound(m, 7, 9)
        play_step_sound(m, 12, 14)
        play_step_sound(m, 17, 20)
    else
        set_custom_anim(m, "MARIO_ANIM_MACH3_RUN", 0x17500)
    end
    m.marioObj.oMarioWalkingPitch = approach_f32(m.marioObj.oMarioWalkingPitch, -find_floor_slope(m, 0), 0x800, 0x800)
    m.marioObj.header.gfx.angle.x = m.marioObj.oMarioWalkingPitch
end

--- @param m MarioState
local new_tilt_body_walking = function(m, startYaw)
    local p = gPeppinoStates[m.playerIndex]

    if p.machLevel <= 1 or _G.pcCharacter == "Mario" then
        tilt_body_walking(m, startYaw)
        return
    end

    local dYaw = -clamp((m.faceAngle.y - startYaw) * m.forwardVel / 12, -0x1555, 0x1555)

    m.marioBodyState.torsoAngle.x = 0
    m.marioBodyState.torsoAngle.z = approach_f32(m.marioBodyState.torsoAngle.z, dYaw, 0x400, 0x400)
end

--- @param m MarioState
local act_walking = function(m)
    local p = gPeppinoStates[m.playerIndex]

    local startPos = { x = 0, y = 0, z = 0 }
    local startYaw = m.faceAngle.y

    mario_drop_held_object(m)

    if (m.input & (INPUT_FIRST_PERSON | INPUT_ZERO_MOVEMENT)) ~= 0 then
        return begin_braking_action(m)
    end

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jump_from_landing(m)
    end

    if check_ground_dive_or_punch(m) ~= 0 then
        return 1
    end

    if analog_stick_held_back(m) ~= 0 and m.forwardVel >= 16 then
        return set_mario_action(m, ACT_TURNING_AROUND, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    m.actionState = 0

    vec3f_copy(startPos, m.pos)
    update_new_walk_speed(m)

    step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_FREEFALL, 0)
    elseif step == GROUND_STEP_NONE then
        new_anim_and_audio_for_walk(m)
        if m.intendedMag - m.forwardVel > 16 then
            set_mario_particle_flags(m, PARTICLE_DUST, 0)
        end
    elseif step == GROUND_STEP_HIT_WALL then
        if _G.pcCharacter == "Peppino" and p.machLevel >= 2 and m.wall ~= nil then
            if m.wall.object == nil or m.wall.object.oInteractType & (INTERACT_BREAKABLE | INTERACT_DOOR | INTERACT_WARP_DOOR) == 0 then
                set_mario_action(m, ACT_GROUND_BONK, 0)
                mario_bonk_reflection(m, 1)
                mario_set_forward_vel(m, -20)
                set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                return
            end
        else
            push_or_sidle_wall(m, startPos)
            m.actionTimer = 0
        end
    end

    check_ledge_climb_down(m)
    new_tilt_body_walking(m, startYaw)
    return 0
end

--- @param m MarioState
local act_finish_turning_around = function(m)
    local p = gPeppinoStates[m.playerIndex]

    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SIDE_FLIP, 0)
    end

    if check_ground_dive_or_punch(m) ~= 0 and _G.pcCharacter ~= "Mario" then
        return 1
    end

    if analog_stick_held_back(m) ~= 0 and m.forwardVel >= 16 and _G.pcCharacter ~= "Mario" then
        return set_mario_action(m, ACT_TURNING_AROUND, 0)
    end

    update_new_walk_speed(m)
    set_mario_animation(m, MARIO_ANIM_TURNING_PART2)

    if perform_ground_step(m) == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if is_anim_at_end(m) ~= 0 then
        set_mario_action(m, ACT_WALKING, 0)
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + 0x8000
    return 0
end

--- @param m MarioState
local new_anim_and_audio_for_hold_walk = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local animAccel
    local a = true
    local useMagOrVel = m.intendedMag > m.forwardVel and m.intendedMag or m.forwardVel

    if useMagOrVel < 2 then
        useMagOrVel = 2
    end

    while a do
        if m.actionTimer == 0 then
            if useMagOrVel > 4 then
                m.actionTimer = 1
            end
            animAccel = _G.pcCharacter ~= "Mario" and useMagOrVel / 4 * 0x10000 or useMagOrVel * 0x10000
            set_mario_anim_with_accel(m, MARIO_ANIM_SLOW_WALK_WITH_LIGHT_OBJ, animAccel)
            play_step_sound(m, 12, 62)

            a = false
        elseif m.actionTimer == 1 then
            if useMagOrVel < 3 then
                m.actionTimer = 0
            elseif useMagOrVel > 11 then
                m.actionTimer = 2
            end
            animAccel = _G.pcCharacter ~= "Mario" and useMagOrVel / 4 * 0x10000 or useMagOrVel * 0x10000
            set_mario_anim_with_accel(m, MARIO_ANIM_WALK_WITH_LIGHT_OBJ, animAccel)
            play_step_sound(m, 12, 62)

            a = false
        elseif m.actionTimer == 2 then
            if useMagOrVel < 8 then
                m.actionTimer = 1
            end
            animAccel = _G.pcCharacter ~= "Mario" and useMagOrVel / 4 * 0x10000 or useMagOrVel / 2 * 0x10000
            set_mario_anim_with_accel(m, MARIO_ANIM_RUN_WITH_LIGHT_OBJ, animAccel)
            play_step_sound(m, 10, 49)

            a = false
        end
    end
end

--- @param m MarioState
local act_hold_walking = function(m)
    local p = gPeppinoStates[m.playerIndex]

    if m.heldObj ~= nil and m.heldObj.behavior == id_bhvJumpingBox then
        return set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, 0)
    end

    if m.marioObj.oInteractStatus == INT_STATUS_MARIO_DROP_OBJECT then
        return drop_and_set_mario_action(m, ACT_WALKING, 0)
    end

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_THROWING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_HOLD_JUMP, 0)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_HOLD_DECELERATING, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    if _G.pcCharacter == "Mario" then
        m.intendedMag = m.intendedMag * 0.4
    end

    intendedMag = m.intendedMag

    update_walking_speed(m)

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    elseif step == GROUND_STEP_HIT_WALL then
        if m.forwardVel > 16 then
            mario_set_forward_vel(m, 16)
        end
    end

    new_anim_and_audio_for_hold_walk(m)

    if intendedMag - m.forwardVel > 10 then
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    end

    return 0
end

--- @param m MarioState
local act_ground_pound = function(m)
    local animation = m.actionArg == 2 and MARIO_ANIM_GROUND_POUND or MARIO_ANIM_FORWARD_SPINNING
    local step

    if m.actionArg == 2 then
        m.twirlYaw = m.twirlYaw + deg_to_hex(40)
    else
        m.twirlYaw = 0
    end

    if m.actionState == 0 then
        if _G.pcCharacter == "Gustavo" then
            m.actionState = 1
        end

        if _G.pcCharacter == "Peppino" then
            step = perform_air_step(m, 0)

            play_character_sound_if_no_flag(m, CHAR_SOUND_HOOHOO, MARIO_MARIO_SOUND_PLAYED)

            if animation ~= MARIO_ANIM_FORWARD_SPINNING then
                set_mario_anim_with_accel(m, animation, 0x15000)

                if is_anim_past_frame(m, 1) ~= 0 then
                    play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
                end

                if is_anim_at_end(m) ~= 0 then
                    m.actionState = 1
                end
            else
                if mario_roll_anim(m, 0x15000) then
                    play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
                    m.actionState = 1
                end
            end
        else
            if m.actionTimer < 10 then
                yOffset = 20 - 2 * m.actionTimer
                if m.pos.y + yOffset + 160 < m.ceilHeight then
                    m.pos.y = m.pos.y + yOffset
                    m.marioObj.header.gfx.pos.y = m.pos.y
                end
            end

            m.vel.y = -50
            mario_set_forward_vel(m, 0)

            if m.actionArg == 0 then
                set_mario_animation(m, MARIO_ANIM_START_GROUND_POUND)
            else
                set_mario_animation(m, MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND)
            end

            if m.actionTimer == 0 then
                play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
            end

            m.actionTimer = m.actionTimer + 1

            if m.actionTimer >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd + 4 then
                play_character_sound(m, CHAR_SOUND_GROUND_POUND_WAH)
                m.actionState = 1
            end
        end
    elseif m.actionState == 1 then
        animation = m.actionArg == 2 and MARIO_ANIM_GROUND_POUND or MARIO_ANIM_AIRBORNE_ON_STOMACH

        if _G.pcCharacter == "Peppino" then
            set_mario_anim_with_accel(m, animation, 0x15000)
            if m.actionArg ~= 2 then
                m.marioBodyState.handState = MARIO_HAND_OPEN
            end
        elseif _G.pcCharacter == "Gustavo" then
            set_custom_anim(m, "GUS_ANIM_STOMP")
        else
            set_mario_animation(m, MARIO_ANIM_GROUND_POUND)
        end

        step = perform_air_step(m, 0)
    end

    if _G.pcCharacter ~= "Mario" then
        local goalSpd = m.intendedMag
        local accel = 6
        if _G.pcCharacter == "Peppino" then
            goalSpd = (m.forwardVel > 32 and m.intendedMag / 32 >= 1) and m.forwardVel or m.intendedMag
            accel = 20
        end
        if analog_stick_held_back(m) ~= 0 then
            if m.forwardVel > 0 then
                mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, accel, accel))
            else
                mario_set_forward_vel(m, 0)
                m.faceAngle.y = m.intendedYaw
            end
        else
            mario_set_forward_vel(m, approach_f32(m.forwardVel, goalSpd, accel, accel))
            m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x900, 0x900)
        end
    end

    if step == AIR_STEP_LANDED then
        if should_get_stuck_in_ground(m) ~= 0 then
            queue_rumble_data_mario(m, 5, 80)

            play_character_sound(m, CHAR_SOUND_OOOF2)
            set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0)
        else
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            if check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
                set_mario_particle_flags(m, (PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR), 0)
                if _G.pcCharacter ~= "Mario" then
                    play_character_sound(m, CHAR_SOUND_GROUND_POUND_WAH)
                end
                set_mario_action(m, ACT_GROUND_POUND_LAND, m.actionArg)
            end
        end
        if m.playerIndex == 0 then
            set_camera_shake_from_hit(SHAKE_GROUND_POUND)
        end
    elseif step == AIR_STEP_HIT_WALL and _G.pcCharacter == "Mario" then
        m.vel.y = 0
        mario_set_forward_vel(m, -16)
        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return 0
end

--- @param m MarioState
local act_ground_pound_gravity = function(m)
    local p = gPeppinoStates[m.playerIndex]

    if _G.pcCharacter ~= "Mario" then
        if not ((m.input & INPUT_A_DOWN) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 and m.vel.y < 0) then
            m.vel.y = math.max(m.vel.y - 8, -280)
        else
            if m.vel.y < -75 then
                m.vel.y = m.vel.y + 4
            else
                m.vel.y = m.vel.y - 4
            end
            m.marioBodyState.wingFlutter = 1
        end
    else
        if not ((m.input & INPUT_A_DOWN) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 and m.vel.y < 0) then
            m.vel.y = math.max(m.vel.y - 4, -75)
        else
            if m.vel.y < -37.5 then
                m.vel.y = m.vel.y + 4
            else
                m.vel.y = m.vel.y - 2
            end
            m.marioBodyState.wingFlutter = 1
        end
    end
end

--- @param m MarioState
local act_ground_pound_land = function(m)
    local p = gPeppinoStates[m.playerIndex]

    m.actionState = 1
    if (m.input & INPUT_UNKNOWN_10) ~= 0 then
        return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
    end

    if (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_BUTT_SLIDE, 0)
    end

    if _G.pcCharacter == "Peppino" and m.actionArg ~= 2 then
        mario_set_forward_vel(m, 0)
        perform_ground_step(m)

        set_mario_anim_with_accel(m, MARIO_ANIM_FORWARD_KB, 0x15000)

        if m.marioObj.header.gfx.animInfo.animFrame < 7 then
            set_anim_to_frame(m, 7)
        end

        if is_anim_past_frame(m, 20) ~= 0 and (m.input & (INPUT_NONZERO_ANALOG | INPUT_A_PRESSED | INPUT_OFF_FLOOR | INPUT_ABOVE_SLIDE)) ~= 0 then
            return check_common_action_exits(m)
        end

        if is_anim_at_end(m) ~= 0 then
            return set_mario_action(m, ACT_IDLE, 0)
        end
    elseif _G.pcCharacter == "Gustavo" then
        mario_set_forward_vel(m, 0)
        set_mario_anim_with_accel(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP, 0x1A000)

        if is_anim_past_end(m) ~= 0 then
            return set_mario_action(m, ACT_IDLE, 0)
        end

        perform_ground_step(m)
    else
        landing_step(m, MARIO_ANIM_GROUND_POUND_LANDING, ACT_BUTT_SLIDE_STOP)
    end
    return 0
end

hook_mario_action(ACT_WALKING, act_walking)
hook_mario_action(ACT_FINISH_TURNING_AROUND, act_finish_turning_around)
hook_mario_action(ACT_HOLD_WALKING, act_hold_walking)
hook_mario_action(ACT_GROUND_POUND, { every_frame = act_ground_pound, gravity = act_ground_pound_gravity },
INT_GROUND_POUND_OR_TWIRL)
hook_mario_action(ACT_GROUND_POUND_LAND, act_ground_pound_land)

------------------------ NEW ACTIONS ------------------------

--- @param m MarioState
local act_super_jump = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local sound = math.random(0, 1) == 0 and CHAR_SOUND_HERE_WE_GO or CHAR_SOUND_YAHOO_WAHA_YIPPEE

    m.actionTimer = m.actionTimer + 1

    if m.actionState == 0 then
        local step = perform_air_step(m, 0)
        local t = m.actionTimer / SUPER_JUMP_MAX_DURATION

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            m.input = 0
            set_mario_action(m, ACT_SUPER_JUMP_CANCEL, 0)
            m.vel.y = 46
            m.faceAngle.y = m.intendedYaw
            audio_sample_stop(SOUND_SUP_JUMP)
            return 0
        end

        if m.ceilHeight - m.pos.y <= 190 then
            if m.playerIndex == 0 then
                set_camera_shake_from_hit(SHAKE_SMALL_DAMAGE)
            end
            play_sound(SOUND_ACTION_HIT, m.marioObj.header.gfx.cameraToObject)
            play_character_sound(m, CHAR_SOUND_OOOF2)
            return set_mario_action(m, ACT_CEIL_CRASH, 0)
        end

        play_character_sound_if_no_flag(m, sound, MARIO_MARIO_SOUND_PLAYED)
        mario_set_forward_vel(m, 0)

        if m.actionTimer <= SUPER_JUMP_MAX_DURATION then
            m.vel.y = 82
        else
            m.actionState = 1
        end

        if step == AIR_STEP_LANDED then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end

        set_mario_animation(m, MARIO_ANIM_DOUBLE_JUMP_RISE)

        set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)

        if gamemode then
            m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + lerp(0, deg_to_hex(360 * 3), ease_in_out_quad(t))
        else
            m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + lerp(0, deg_to_hex(360 * 6), ease_in_out_quad(t))
        end
    else
        local animation = MARIO_ANIM_FORWARD_SPINNING

        if m.actionState >= 4 then
            animation = MARIO_ANIM_GENERAL_FALL
        end

        step = common_air_action_step(m, ACT_FREEFALL_LAND, animation, AIR_STEP_CHECK_LEDGE_GRAB)

        if step == AIR_STEP_LANDED then
            return 1
        end

        if m.actionState < 4 then
            if mario_roll_anim(m, nil) then
                play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
                m.actionState = m.actionState + 1
            end
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            set_mario_action(m, ACT_UPPERCUT, 0)
        end

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            if m.vel.y >= -16 then
                m.input = 0
                set_mario_action(m, ACT_SUPER_JUMP_CANCEL, 0)
                audio_sample_stop(SOUND_SUP_JUMP)
                m.vel.y = 46
                m.faceAngle.y = m.intendedYaw
                return 0
            else
                if check_kick_or_dive_in_air(m) ~= 0 then
                    return 0
                end
            end
        end

        if (m.input & INPUT_Z_PRESSED) ~= 0 then
            set_anim_to_frame(m, 0)
            return set_mario_action(m, ACT_GROUND_POUND, 0)
        end
    end

    return 0
end

--- @param m MarioState
local act_super_jump_cancel = function(m)
    m.marioObj.header.gfx.angle.x = 0
    vec3f_copy(m.marioObj.header.gfx.pos, m.pos)

    if m.actionState == 0 then
        if m.marioObj.header.gfx.animInfo.animFrame == 3 then
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        if m.marioObj.header.gfx.animInfo.animFrame >= 14 then
            mario_set_forward_vel(m, MACH_2_SPEED_MIN)
            m.actionState = 1
            m.actionTimer = 0
        end

        m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x1000, 0x1000)
        m.marioObj.header.gfx.angle.y = m.faceAngle.y
    else
        if (m.input & INPUT_A_PRESSED) ~= 0 then
            set_mario_action(m, ACT_UPPERCUT, 0)
        end

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            if check_kick_or_dive_in_air(m) ~= 0 then
                return 0
            end
        end

        if (m.input & INPUT_Z_PRESSED) ~= 0 then
            return set_mario_action(m, ACT_GROUND_POUND, 0)
        end

        if m.marioObj.header.gfx.animInfo.animFrame < 14 then
            set_anim_to_frame(m, 14)
        end

        update_air_without_turn(m)

        local step = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)

        if step == AIR_STEP_LANDED then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        elseif step == AIR_STEP_HIT_WALL then
            if m.forwardVel > 16 then
                queue_rumble_data_mario(m, 5, 40)
                mario_bonk_reflection(m, 0)
                m.faceAngle.y = m.faceAngle.y + 0x8000

                if m.wall ~= nil then
                    set_mario_action(m, ACT_AIR_HIT_WALL, 0)
                else
                    m.vel.y = math.min(m.vel.y, 0)

                    if m.forwardVel >= 38 then
                        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
                    else
                        if m.forwardVel > 8 then
                            mario_set_forward_vel(m, -8)
                        end
                        return set_mario_action(m, ACT_SOFT_BONK, 0)
                    end
                end
            else
                mario_set_forward_vel(m, 0)
            end
        elseif step == AIR_STEP_GRABBED_LEDGE then
            set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
            drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
        elseif step == AIR_STEP_HIT_LAVA_WALL then
            lava_boost_on_wall(m)
        end
    end

    set_custom_anim(m, "MARIO_ANIM_SUPER_JUMP_CANCEL", 0x12000)
end

--- @param m MarioState
local check_ledge = function(m)
    local ray = collision_find_surface_on_ray(m.pos.x + 60 * sins(m.faceAngle.y), m.pos.y + 160, m.pos.z + 60 * coss(m.faceAngle.y),
    0, -170, 0)

    local ledgePos = ray.hitPos
    local ledgeFloor = ray.surface

    if ledgeFloor == nil then
        return false
    end

    if resolve_and_return_wall_collisions(ledgePos, 40, 40) ~= nil then -- make sure there's not a wall on the ledge
        return false
    end
    if ledgeFloor.type == SURFACE_BURNING or ledgeFloor.type == SURFACE_INSTANT_QUICKSAND or
    ledgeFloor.type == SURFACE_INSTANT_MOVING_QUICKSAND then
        return false
    end

    vec3f_copy(m.pos, ledgePos)
    m.floor = ledgeFloor
    m.floorHeight = ledgePos.y

    m.floorAngle = atan2s(ledgeFloor.normal.z, ledgeFloor.normal.x)

    return true
end

--- @param m MarioState
local act_wall_run = function(m)
    local p = gPeppinoStates[m.playerIndex]

    mario_drop_held_object(m)

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        local intendedDYaw = s16(m.intendedYaw - atan2s(m.wall.normal.z, m.wall.normal.x))
        local jumpAngle = clamp(intendedDYaw, deg_to_hex(-45), deg_to_hex(45))

        if (m.input & INPUT_NONZERO_ANALOG) == 0 or (intendedDYaw <= deg_to_hex(-120) or intendedDYaw >= deg_to_hex(120)) then
            jumpAngle = 0
        end

        m.vel.y = 52
        m.faceAngle.y = m.faceAngle.y + 0x8000 + jumpAngle
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
    end

    if m.vel.y <= 4 then
        m.vel.y = 4
        m.actionTimer = m.actionTimer + 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 or m.actionTimer > 8 then
        mario_set_forward_vel(m, -5)
        m.input = m.input & ~INPUT_Z_PRESSED
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    mario_set_forward_vel(m, 0.5)

    set_custom_anim(m, "MARIO_ANIM_WALL_RUN", m.vel.y / 5.3 * 0x10000)
    play_step_sound(m, 9, 45)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_FREEFALL_LAND, 0)
    end

    if check_ledge(m) then
        mario_set_forward_vel(m, m.vel.y)
        m.vel.y = 0
        return set_mario_action(m, ACT_WALKING, 0)
    end

    if m.wall ~= nil then -- Not a necesary check, but you get script errors if it doesnt detect a wall
        m.faceAngle.y = atan2s(m.wall.normal.z, m.wall.normal.x) + 0x8000
    else
        m.actionTimer = m.actionTimer + 3
    end

    if gamemode then
        m.vel.y = m.vel.y + 2
    else
        m.vel.y = math.min(m.vel.y + 4.45, 120)
    end

    m.marioObj.header.gfx.pos.x = m.pos.x + 13 * sins(m.faceAngle.y)
    m.marioObj.header.gfx.pos.z = m.pos.z + 13 * coss(m.faceAngle.y)
end

--- @param m MarioState
local act_comet_dive = function(m)
    local p = gPeppinoStates[m.playerIndex]

    play_sound_if_no_flag(m, SOUND_ACTION_THROW, MARIO_ACTION_SOUND_PLAYED)

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 2)
    end

    local step = perform_air_step(m, 0)
    set_mario_anim_with_accel(m, MARIO_ANIM_DIVE, 0x20000)

    update_air_without_turn(m)

    m.actionTimer = m.actionTimer + 1

    if step == AIR_STEP_LANDED then
        set_mario_action(m, ACT_RECOVER_ROLL, 0)
    elseif step == AIR_STEP_HIT_WALL then
        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
        mario_bonk_reflection(m, 1)
        mario_set_forward_vel(m, -20)
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    end

    return 0
end

local act_comet_dive_gravity = function(m)
    m.vel.y = math.max(m.vel.y - 6, -140)
end

--- @param m MarioState
local landing_action_step = function(m) -- common_landing_action reduces your speed a little which is why im not using it
    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        apply_landing_accel(m, 1)
    elseif m.forwardVel >= 16 then
        apply_slope_decel(m, 2)
    else
        m.vel.y = 0
    end

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.floor.type >= SURFACE_SHALLOW_QUICKSAND and m.floor.type <= SURFACE_MOVING_QUICKSAND then
        m.quicksandDepth = m.quicksandDepth + (4 - m.actionTimer) * 3.5 - 0.5
    end

    return step
end

--- @param m MarioState
local act_recover_roll = function(m)
    if m.floor.normal.y < 0.2923717 or (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return mario_push_off_steep_floor(m, ACT_FREEFALL, 0)
    end

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 or landing_action_step(m) == GROUND_STEP_HIT_WALL or m.actionState >= 1 then
        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            set_mario_action(m, ACT_WALKING, 0)
        else
            if m.actionArg == 0 then
                return set_mario_action(m, ACT_IDLE, 0)
            else
                return set_mario_action(m, ACT_BRAKING, 0)
            end
        end
    end

    if mario_roll_anim(m, 0x22000) then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        m.actionState = m.actionState + 1
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_JUMP, 0)
    end

    if check_ground_dive_or_punch(m) ~= 0 then
        return 0
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        if m.forwardVel ~= 0 then
            drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0)
        else
            drop_and_set_mario_action(m, ACT_START_CROUCHING, 0)
        end
    end

    return 0
end

--- @param m MarioState
local act_ground_grab = function(m)
    local p = gPeppinoStates[m.playerIndex]

    play_mario_sound(m, SOUND_ACTION_THROW, CHAR_SOUND_YAH_WAH_HOO)

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        return set_mario_action(m, ACT_LONG_JUMP, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        return set_mario_action(m, ACT_BELLY_DASH, 0)
    end

    if analog_stick_held_back(m) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        m.input = 0
        mario_set_forward_vel(m, 0)
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_WALKING, 0)
    end

    if mario_check_object_grab(m) ~= 0 then
        mario_grab_used_object(m)
        play_character_sound(m, CHAR_SOUND_HRMM)
        if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
            m.marioBodyState.grabPos = GRAB_POS_BOWSER
        elseif m.interactObj.oInteractionSubtype & INT_SUBTYPE_GRABS_MARIO ~= 0 then
            m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
        else
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
        audio_sample_stop(SOUND_GRAB_DASH)

        if (m.controller.buttonDown & B_BUTTON) ~= 0 and p.machLevel >= 2 then
            return set_mario_action(m, ACT_SPIN_THROW, 0)
        else
            return set_mario_action(m, ACT_HOLD_IDLE, 0)
        end
        return 1
    end

    if m.actionTimer >= GRAB_MAX_DURATION then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    set_mario_particle_flags(m, PARTICLE_DUST, 0)
    mario_set_forward_vel(m, m.forwardVel)

    set_custom_anim(m, "MARIO_ANIM_GRAB", nil)

    m.actionTimer = m.actionTimer + 1

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_AIR_GRAB, m.actionArg)
    elseif step == GROUND_STEP_HIT_WALL then
        if m.wall ~= nil and (m.wall.object == nil or m.wall.object.oInteractType & (INTERACT_BREAKABLE) == 0) then
            set_mario_action(m, ACT_GROUND_BONK, 0)
            mario_bonk_reflection(m, 1)
            mario_set_forward_vel(m, -20)
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        end
    end

    if m.marioObj.header.gfx.animInfo.animFrame >= 2 then
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end

    return 0
end

--- @param m MarioState
local act_air_grab = function(m)
    play_mario_sound(m, SOUND_ACTION_THROW, CHAR_SOUND_YAH_WAH_HOO)

    if mario_check_object_grab(m) ~= 0 then
        mario_grab_used_object(m)
        play_character_sound(m, CHAR_SOUND_HRMM)
        if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
            m.marioBodyState.grabPos = GRAB_POS_BOWSER
        elseif m.interactObj.oInteractionSubtype & INT_SUBTYPE_GRABS_MARIO ~= 0 then
            m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
        else
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 and (m.flags & MARIO_WING_CAP) ~= 0 and m.actionTimer > 0 then
        return drop_and_set_mario_action(m, ACT_FLYING, 1)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        set_anim_to_frame(m, 1)
        return drop_and_set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if analog_stick_held_back(m) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        m.input = 0
        mario_set_forward_vel(m, 0)
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        heightPeakPos = m.pos.y
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_GRAB_AIR_CANCEL, 0)
    end

    if m.marioObj.header.gfx.animInfo.animFrame > 3 then
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end

    set_custom_anim(m, "MARIO_ANIM_AIR_GRAB", nil)

    m.actionTimer = m.actionTimer + 1

    local step = perform_air_step(m, 0)

    local endAct = m.heldObj ~= nil and ACT_HOLD_FREEFALL_LAND or ACT_FREEFALL_LAND

    if step == AIR_STEP_LANDED then
        set_mario_action(m, endAct, 0)
    elseif step == AIR_STEP_HIT_WALL then
        if m.wall ~= nil and (m.wall.object == nil or m.wall.object.oInteractType & (INTERACT_BREAKABLE) == 0) then
            drop_and_set_mario_action(m, ACT_AIR_HIT_WALL, 0)
        end
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    end
end

--- @param m MarioState
local act_water_grab = function(m)
    local step

    if m.actionTimer >= GRAB_MAX_DURATION then
        return set_mario_action(m, ACT_PEPPINO_SWIM, 0)
    end

    if analog_stick_held_back(m) ~= 0 then
        audio_sample_stop(SOUND_GRAB_DASH)
        m.input = 0
        mario_set_forward_vel(m, 0)
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_PEPPINO_WATER_IDLE, 0)
    end

    if mario_check_object_grab(m) ~= 0 then
        mario_grab_used_object(m)
        play_character_sound(m, CHAR_SOUND_HRMM)
        if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
            m.marioBodyState.grabPos = GRAB_POS_BOWSER
        elseif m.interactObj.oInteractionSubtype & INT_SUBTYPE_GRABS_MARIO ~= 0 then
            m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
        else
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
        audio_sample_stop(SOUND_GRAB_DASH)

        return set_mario_action(m, ACT_PEPPINO_SWIM, 0)
    end

    m.actionTimer = m.actionTimer + 1

    if m.pos.y <= m.floorHeight and m.vel.y <= 0 then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    m.vel.x = m.forwardVel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.y = m.forwardVel * sins(m.faceAngle.x)
    m.vel.z = m.forwardVel * coss(m.faceAngle.y) * coss(m.faceAngle.x)

    if (m.flags & MARIO_METAL_CAP) ~= 0 then
        apply_water_current(m, m.vel)
    end

    if step == GROUND_STEP_HIT_WALL or step == AIR_STEP_HIT_WALL then
        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        m.forwardVel = -20
        set_mario_action(m, ACT_BACKWARD_WATER_KB, 0)
    end

    set_custom_anim(m, "MARIO_ANIM_GRAB", nil)

    if m.marioObj.header.gfx.animInfo.animFrame >= 2 then
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x

    correct_water_pitch(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)
    set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)

    set_mario_particle_flags(m, PARTICLE_BUBBLE, 0)

    return 0
end

--- @param m MarioState
local act_piledriver = function(m)
    local startYaw = m.twirlYaw

    m.angleVel.y = 0x2800

    if m.actionState == 0 then
        set_mario_anim_with_accel(m, MARIO_ANIM_GRAB_BOWSER, 0x20000)
        if is_anim_at_end(m) ~= 0 then
            m.actionState = 1
        end
    else
        set_mario_animation(m, MARIO_ANIM_HOLDING_BOWSER)
    end

    m.twirlYaw = m.twirlYaw + m.angleVel.y

    if startYaw > m.twirlYaw then
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    update_air_without_turn(m)

    local step = perform_air_step(m, 0)

    if step == AIR_STEP_LANDED then
        play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
        set_mario_particle_flags(m, (PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR), 0)
        if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
            play_character_sound(m, CHAR_SOUND_SO_LONGA_BOWSER)
        else
            play_character_sound(m, CHAR_SOUND_PUNCH_HOO)
        end
        mario_throw_held_object(m)
        set_mario_action(m, ACT_GROUND_POUND_LAND, 2)
    elseif step == AIR_STEP_HIT_WALL then
        mario_bonk_reflection(m, 0)
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return 0
end

--- @param m MarioState
local act_spin_throw = function(m)
    local startYaw = m.twirlYaw

    m.angleVel.y = deg_to_hex(45)

    m.actionTimer = m.actionTimer + 1

    if m.actionState == 0 then
        set_mario_anim_with_accel(m, MARIO_ANIM_GRAB_BOWSER, 0x20000)
        if is_anim_at_end(m) ~= 0 then
            m.actionState = 1
        end
    else
        set_mario_animation(m, MARIO_ANIM_HOLDING_BOWSER)
    end

    m.twirlYaw = m.twirlYaw + m.angleVel.y

    if startYaw > m.twirlYaw then
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
            play_character_sound(m, CHAR_SOUND_SO_LONGA_BOWSER)
        else
            play_character_sound(m, CHAR_SOUND_HERE_WE_GO)
        end
        mario_throw_held_object(m)
        m.input = m.input & ~INPUT_B_PRESSED
        return set_mario_action(m, ACT_WALKING, 0)
    end

    if m.forwardVel <= 0 then
        return set_mario_action(m, ACT_HOLD_WALKING, 0)
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x600, 0x600)

    mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 1.8, 1.8))

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        m.vel.y = 30
        set_mario_action(m, ACT_PILEDRIVER, 0)
    elseif step == GROUND_STEP_HIT_WALL then
        mario_bonk_reflection(m, 0)
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw

    return 0
end

--- @param m MarioState
local act_uppercut = function(m)
    local spinDuration = 15
    local t = m.actionTimer / spinDuration

    play_mario_sound(m, SOUND_ACTION_THROW, CHAR_SOUND_PUNCH_HOO)

    if m.forwardVel > 90 then
        mario_set_forward_vel(m, 90)
    end

    local goalSpd = m.intendedMag
    if analog_stick_held_back(m) ~= 0 then
        if m.forwardVel > 0 then
            mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 3, 3))
        else
            mario_set_forward_vel(m, 0)
            m.faceAngle.y = m.intendedYaw
        end
    else
        if m.forwardVel <= goalSpd then
            mario_set_forward_vel(m, approach_f32(m.forwardVel, goalSpd, 3, 3))
        end
        m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x900, 0x900)
    end

    if m.forwardVel > 32 then
        mario_set_forward_vel(m, m.forwardVel - 2.9)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    update_air_without_turn(m)

    if m.actionTimer < math.floor(spinDuration / 3) then
        m.actionTimer = math.floor(spinDuration / 3)
    elseif m.actionTimer < spinDuration then
        m.actionTimer = m.actionTimer + 1
    end

    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_SINGLE_JUMP, AIR_STEP_CHECK_LEDGE_GRAB)

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + lerp(0, deg_to_hex(360 * 2), ease_out_quad(t))

    return 0
end

--- @param m MarioState
local act_taunt = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local s = gPlayerSyncTable[m.playerIndex]

    if m.vel.y <= 0 then
        m.vel.y = lerp(0, -22.5, tauntStaleCount / 6)
    end

    vec3f_set(m.marioObj.header.gfx.scale, 1, 1, 1)

    if m.playerIndex == 0 then
        if m.action == ACT_PARRY or m.action == ACT_WATER_PARRY then
            s.tauntTimer = 0
        end
        s.tauntTimer = s.tauntTimer - 1
        tauntCooldown = 0.1 * 30
    end

    if s.tauntTimer <= 0 then
        m.action = m.prevAction
    end

    local offsetX = gPoseIndexes[p.poseIndex][3] * sins(gMarioStates[0].area.camera.yaw)
    local offsetZ = gPoseIndexes[p.poseIndex][3] * coss(gMarioStates[0].area.camera.yaw)

    vec3f_set(m.marioObj.header.gfx.pos, m.pos.x - offsetX, m.pos.y - m.quicksandDepth, m.pos.z - offsetZ)
    vec3f_set(m.marioObj.header.gfx.angle, 0, gMarioStates[0].area.camera.yaw, 0)     -- always face to the local player's camera

    if type(gPoseIndexes[p.poseIndex][1]) == "string" then
        set_custom_anim(m, gPoseIndexes[p.poseIndex][1], nil)
    else
        set_mario_animation(m, gPoseIndexes[p.poseIndex][1])
    end
    set_anim_to_frame(m, gPoseIndexes[p.poseIndex][2])

    m.marioBodyState.punchState = 0

    if p.poseIndex == 1 or p.poseIndex == 7 or p.poseIndex == 12 then
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN
    elseif p.poseIndex == 3 then
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_FISTS
        m.marioBodyState.punchState = (0 << 6) | 3
    elseif p.poseIndex == 4 then
        m.marioBodyState.eyeState = MARIO_EYES_HALF_CLOSED
        m.marioBodyState.handState = MARIO_HAND_OPEN
    elseif p.poseIndex == 5 or p.poseIndex == 9 or p.poseIndex == 11 or p.poseIndex == 15 then
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_OPEN
    elseif p.poseIndex == 10 then
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_RIGHT_OPEN
    elseif p.poseIndex == 16 then
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_OPEN
    else
        m.marioBodyState.eyeState = MARIO_EYES_OPEN
        m.marioBodyState.handState = MARIO_HAND_FISTS
    end

    vec3f_set(m.marioBodyState.torsoAngle, 0, 0, 0)
    vec3f_set(m.marioBodyState.headAngle, 0, 0, 0)
end

---@param m MarioState
local act_parry = function(m)
    local s = gPlayerSyncTable[m.playerIndex]
    local grounded = (m.pos.y - m.floorHeight <= 0 and m.vel.y <= 0) and true or false
    local step = grounded and perform_ground_step(m) or perform_air_step(m, 0)
    local actionAfterEnd
    local spinDuration = 15
    local t = m.actionState / spinDuration

    mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 4, 4))

    if m.action ~= ACT_WATER_PARRY then
        actionAfterEnd = grounded and ACT_IDLE or ACT_FREEFALL
    else
        actionAfterEnd = ACT_PEPPINO_SWIM
    end

    if m.actionArg == 1 then
        m.vel.y = m.vel.y - 2
    end

    s.tauntTimer = 0

    if m.actionTimer == 0 then
        if m.actionState == 0 then
            set_mario_anim_with_accel(m, MARIO_ANIM_FIRST_PUNCH, 0x12000)
            if is_anim_past_end(m) ~= 0 then
                m.marioBodyState.punchState = (0 << 6) | 3
                m.actionState = 1
            end
        else
            set_mario_anim_with_accel(m, MARIO_ANIM_FIRST_PUNCH_FAST, 0x12000)
            if is_anim_past_end(m) ~= 0 then
                if m.actionArg == 0 then
                    m.invincTimer = 45
                end
                return set_mario_action(m, actionAfterEnd, 0)
            end
        end
    elseif m.actionTimer == 1 then
        if m.actionState == 0 then
            set_mario_anim_with_accel(m, MARIO_ANIM_SECOND_PUNCH, 0x12000)
            if is_anim_past_end(m) ~= 0 then
                m.marioBodyState.punchState = (1 << 6) | 3
                m.actionState = 1
            end
        else
            set_mario_anim_with_accel(m, MARIO_ANIM_SECOND_PUNCH_FAST, 0x12000)
            if is_anim_past_end(m) ~= 0 then
                if m.actionArg == 0 then
                    m.invincTimer = 45
                end
                return set_mario_action(m, actionAfterEnd, 0)
            end
        end
    elseif m.actionTimer == 2 then
        set_mario_anim_with_accel(m, MARIO_ANIM_GROUND_KICK, 0x18000)
        if m.marioObj.header.gfx.animInfo.animFrame == 2 then
            m.marioBodyState.punchState = (2 << 6) | 3
        end
        if is_anim_past_end(m) ~= 0 then
            if m.actionArg == 0 then
                m.invincTimer = 45
            end
            return set_mario_action(m, actionAfterEnd, 0)
        end
    else
        set_mario_anim_with_accel(m, MARIO_ANIM_SINGLE_JUMP, 0x13000)
        if m.actionState < math.floor(spinDuration / 3) then
            m.actionState = math.floor(spinDuration / 3)
        else
            m.actionState = m.actionState + 1
        end

        if t >= 1 then
            t = 1
        end

        if m.actionState >= spinDuration + 5 then
            if m.actionArg == 0 then
                m.invincTimer = 45
            end
            return set_mario_action(m, actionAfterEnd, 0)
        end

        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + lerp(0, deg_to_hex(360 * 2), ease_out_quad(t))
    end

    if grounded then
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    end

    return 0
end

---@param m MarioState
local act_breakdance = function(m)
    local t = (m.actionTimer - 17) / 13
    local step = perform_ground_step(m)

    if (m.controller.buttonDown & Y_BUTTON) == 0 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    if (m.input & INPUT_A_DOWN) ~= 0 then
        return set_mario_action(m, ACT_JUMP, 0)
    end

    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    if m.actionState > 6 then
        m.actionState = 0
    elseif m.actionState > 3 then
        set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)
        m.marioObj.header.gfx.angle.z = deg_to_hex(-90)
        vec3f_set(m.marioObj.header.gfx.pos, m.pos.x + -30 * sins(m.faceAngle.y + 0x4000), m.pos.y + 30, m.pos.z + -30 * coss(m.faceAngle.y + 0x4000))

        if is_anim_past_end(m) ~= 0 then
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
            m.actionState = m.actionState + 1
        end
    else
        set_mario_animation(m, MARIO_ANIM_BREAKDANCE)
        m.marioObj.header.gfx.angle.z = 0
        vec3f_set(m.marioObj.header.gfx.pos, m.pos.x + -20 * sins(m.faceAngle.y), m.pos.y, m.pos.z + -20 * coss(m.faceAngle.y))
        if m.marioObj.header.gfx.animInfo.animFrame >= 16 then
            if t >= 1 then
                m.actionState = m.actionState + 1
            end
            set_anim_to_frame(m, 1)
        end
    end

    if t >= 1 and m.actionArg == 0 then
        run_audio(SOUND_DANCE_START, m, 1)
        play_character_sound(m, CHAR_SOUND_HOOHOO)
        m.actionArg = 1
    end

    m.actionTimer = m.actionTimer + 1

    update_walking_speed(m)

    m.marioObj.header.gfx.animInfo.animAccel = lerp(0x10000, 0x22000, t)

    return 0
end

---@param m MarioState
local act_belly_dash = function(m)
    play_mario_sound(m, SOUND_ACTION_THROW, CHAR_SOUND_HOOHOO)

    apply_slope_accel(m)
    align_with_floor(m)

    set_mario_anim_with_accel(m, MARIO_ANIM_DIVE, 0x25000)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    m.actionTimer = m.actionTimer + 1

    if m.actionTimer >= BELLY_DASH_DURATION and (m.input & INPUT_Z_DOWN) == 0 then
        return set_mario_action(m, ACT_RECOVER_ROLL, 1)
    end

    if m.forwardVel <= 0 and should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_STOMACH_SLIDE, 0)
    end

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        m.vel.y = -80
        set_anim_to_frame(m, 1)
        set_mario_action(m, ACT_COMET_DIVE, 0)
        return 0
    elseif step == GROUND_STEP_HIT_WALL then
        if m.wall ~= nil and (m.wall.object == nil or m.wall.object.oInteractType & (INTERACT_BREAKABLE) == 0) then
            set_mario_action(m, ACT_GROUND_BONK, 0)
            mario_bonk_reflection(m, 1)
            mario_set_forward_vel(m, -20)
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            return 0
        end
    end

    return 0
end

---@param m MarioState
local act_air_turning = function(m)
    mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 1.75, 1.75))

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_UPPERCUT, 0)
    end

    if check_kick_or_dive_in_air(m) ~= 0 then
        return 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    common_air_action_step(m, ACT_TURNING_AROUND, MARIO_ANIM_TURNING_PART1, 0)

    return 0
end

---@param m MarioState
local act_long_fall = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local landAct = p.machLevel >= 1 and ACT_RECOVER_ROLL or ACT_LONG_FALL_LAND

    play_character_sound_if_no_flag(m, CHAR_SOUND_WAAAOOOW, MARIO_MARIO_SOUND_PLAYED)

    update_air_without_turn(m)

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_UPPERCUT, 0)
    end

    if check_kick_or_dive_in_air(m) ~= 0 then
        return 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    local step = common_air_action_step(m, landAct, MARIO_ANIM_AIRBORNE_ON_STOMACH, AIR_STEP_CHECK_LEDGE_GRAB)
    m.marioObj.header.gfx.animInfo.animAccel = 0x22000

    m.marioBodyState.handState = MARIO_HAND_OPEN

    if step == AIR_STEP_LANDED then
        play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
        if m.playerIndex == 0 then
            set_camera_shake_from_hit(SHAKE_GROUND_POUND)
        end
        set_mario_particle_flags(m, (PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR), 0)
        if landAct == ACT_RECOVER_ROLL then
            play_character_sound(m, CHAR_SOUND_HAHA_2)
        else
            play_character_sound(m, CHAR_SOUND_OOOF2)
        end
    end

    return 0
end

---@param m MarioState
local act_long_fall_land = function(m)
    if m.marioObj.header.gfx.animInfo.animFrame > 20 then
        if check_common_landing_cancels(m, 0) ~= 0 then
            return 1
        end
    end

    landing_step(m, MARIO_ANIM_LAND_ON_STOMACH, ACT_IDLE)
    m.marioObj.header.gfx.animInfo.animAccel = 0x18000

    return 0
end

---@param m MarioState
local act_wall_crash = function(m)
    local jumpAngle = 0
    local intendedDYaw = s16(m.intendedYaw - m.faceAngle.y + 0x8000)

    if m.actionTimer <= 12 then
        if m.wall ~= nil then
            m.faceAngle.y = atan2s(m.wall.normal.z, m.wall.normal.x) + 0x8000
            jumpAngle = clamp(intendedDYaw, deg_to_hex(-45), deg_to_hex(45))
        end

        mario_set_forward_vel(m, -2)
        m.vel.y = 0

        play_mario_sound(m, SOUND_ACTION_BONK, CHAR_SOUND_DOH)

        set_mario_animation(m, MARIO_ANIM_AIR_FORWARD_KB)

        if (m.input & INPUT_A_PRESSED) ~= 0 and m.wall ~= nil then
            if (m.input & INPUT_NONZERO_ANALOG) == 0 or (intendedDYaw <= deg_to_hex(-120) or intendedDYaw >= deg_to_hex(120)) then
                jumpAngle = 0
            end

            m.faceAngle.y = m.faceAngle.y + 0x8000 + jumpAngle
            m.vel.y = 52
            return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
        end
    else
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    gPeppinoStates[m.playerIndex].squishIntensity = 0

    m.marioObj.header.gfx.angle.y = m.faceAngle.y
    m.marioObj.header.gfx.angle.x = -0x4000

    m.marioObj.header.gfx.pos.x = m.pos.x + 50 * sins(m.faceAngle.y)
    m.marioObj.header.gfx.pos.y = m.pos.y + 75
    m.marioObj.header.gfx.pos.z = m.pos.z + 50 * coss(m.faceAngle.y)

    m.actionTimer = m.actionTimer + 1

    return 0
end

---@param m MarioState 
local act_ceil_crash = function(m)
    m.flags = m.flags | MARIO_MARIO_SOUND_PLAYED -- prevents the screaming

    if m.actionState == 0 then
        m.actionTimer = m.actionTimer + 1

        if (m.input & INPUT_B_PRESSED) ~= 0 then
            m.input = 0
            set_mario_action(m, ACT_SUPER_JUMP_CANCEL, 0)
            m.vel.y = 46
            m.faceAngle.y = m.intendedYaw
            audio_sample_stop(SOUND_SUP_JUMP)
            return 0
        end

        if m.actionTimer <= 10 then
            set_mario_animation(m, MARIO_ANIM_WATER_DYING)
            set_anim_to_frame(m, m.marioObj.header.gfx.animInfo.curAnim.loopEnd)
            m.marioObj.header.gfx.pos.y = m.ceilHeight - 75
            if (m.ceilHeight - 75) - m.pos.y > 240 then
                m.actionState = 1
                m.vel.y = m.vel.y / 2
            end
        else
            m.vel.y = 0
            m.actionState = 1
        end
    else
        act_long_fall(m)
        m.angleVel.x = m.angleVel.x + deg_to_hex(35)
        m.marioObj.header.gfx.angle.x = m.angleVel.x
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN
end

---@param m MarioState 
local update_roll_angle = function(m, accel, lossFactor)
    if m.floor == nil then
        return
    end

    local slopeAngle = atan2s(m.floor.normal.z, m.floor.normal.x)
    local steepness = math.sqrt(m.floor.normal.x * m.floor.normal.x + m.floor.normal.z * m.floor.normal.z)

    m.slideVelX = m.slideVelX + accel * steepness * sins(slopeAngle)
    m.slideVelZ = m.slideVelZ + accel * steepness * coss(slopeAngle)

    m.slideVelX = m.slideVelX * lossFactor
    m.slideVelZ = m.slideVelZ * lossFactor

    m.slideYaw = atan2s(m.slideVelZ, m.slideVelX)

    local facingDYaw = s16(m.faceAngle.y - m.slideYaw)
    local newFacingDYaw = facingDYaw

    if newFacingDYaw > 0 and newFacingDYaw <= 0x8000 then
        newFacingDYaw = newFacingDYaw - 0x800
        if newFacingDYaw < 0 then
            newFacingDYaw = 0
        end

    elseif newFacingDYaw >= -0x8000 and newFacingDYaw < 0 then
        newFacingDYaw = newFacingDYaw + 0x800
        if newFacingDYaw > 0 then
            newFacingDYaw = 0
        end
    end

    m.faceAngle.y = s16(m.slideYaw + newFacingDYaw)

    m.vel.x = m.slideVelX
    m.vel.y = 0
    m.vel.z = m.slideVelZ

    mario_update_moving_sand(m)
    mario_update_windy_ground(m)

    m.forwardVel = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)
    if m.forwardVel > 140 then
        m.slideVelX = m.slideVelX * 140 / m.forwardVel
        m.slideVelZ = m.slideVelZ * 140 / m.forwardVel
    end

    if newFacingDYaw < -0x4000 or newFacingDYaw > 0x4000 then
        m.forwardVel = -m.forwardVel
    end
end

---@param m MarioState
local update_roll_speed = function(m)
    local intendedDYaw = m.intendedYaw - m.slideYaw
    local forward = coss(intendedDYaw)
    local sideward = sins(intendedDYaw)

    if forward < 0 and m.forwardVel > 0 then
        forward = forward * 0.5 + 0.5 * m.forwardVel / 100
    end

    local slopeAccel = 4 -- how fast will you reach the top speed the slope gives you
    local lossControl = 0.096 -- how much control you have over you speed loss (0.1 lets you not lose speed as long as you hold forwards)
    local lossBase = 0.91 -- base speed loss when the stick is held neutral
    local floorType = mario_get_floor_class(m)

    if floorType == SURFACE_CLASS_VERY_SLIPPERY then
        slopeAccel = 8
    elseif floorType == SURFACE_CLASS_SLIPPERY then
        slopeAccel = 6
    end

    local lossFactor = m.intendedMag / 32 * forward * lossControl + lossBase

    local oldSpeed = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)

    m.slideVelX = m.slideVelX + m.vel.z * (m.intendedMag / 32) * sideward * 0.17
    m.slideVelZ = m.slideVelZ - m.vel.x * (m.intendedMag / 32) * sideward * 0.17

    local newSpeed = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)

    if oldSpeed > 0 and newSpeed > 0 then
        m.slideVelX = m.slideVelX * oldSpeed / newSpeed
        m.slideVelZ = m.slideVelZ * oldSpeed / newSpeed
    end

    update_roll_angle(m, slopeAccel, lossFactor)
end

---@param m MarioState 
local act_roll = function(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_JUMP, 0)
    end

    if (m.input & (INPUT_Z_DOWN | INPUT_ABOVE_SLIDE)) == 0 or (math.abs(m.forwardVel) <= 6 and m.input & (INPUT_ABOVE_SLIDE)) == 0 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    local rollSpeed = 0x8000 + lerp(0, 0x26000, m.forwardVel / 120)

    local step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_FREEFALL, 0)
    elseif step == GROUND_STEP_HIT_WALL then
        if mario_floor_is_slippery(m) ~= 0 and m.wall ~= nil then
            local wallAngle = atan2s(m.wall.normal.z, m.wall.normal.x)

            m.slideYaw = wallAngle - s16(m.slideYaw - wallAngle) + 0x8000

            m.slideVelX = m.forwardVel * sins(m.slideYaw)
            m.slideVelZ = m.forwardVel * coss(m.slideYaw)
        else
            if m.forwardVel >= 40 then
                set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                set_mario_action(m, ACT_GROUND_BONK, 1)
                mario_set_forward_vel(m, -32)
            else
                return set_mario_action(m, ACT_IDLE, 0)
            end
        end
    end

    update_roll_speed(m)

    if mario_roll_anim(m, rollSpeed) then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
    end
end

---@param m MarioState
local act_peppino_water_idle = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local step
    local vDir = 0

    if (m.input & INPUT_A_DOWN) ~= 0 then
        vDir = vDir + 1
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        vDir = vDir - 1
    end

    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 or
    (vDir == 1 and m.pos.y < m.waterLevel - 80) or
    (vDir == -1 and m.pos.y > m.floorHeight) then
        if math.abs(m.forwardVel) < 16 then
            m.faceAngle.y = m.intendedYaw
            m.forwardVel = 0
        end
        set_mario_action(m, ACT_PEPPINO_SWIM, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.pos.y >= m.waterLevel - 100 then
        return set_mario_action(m, ACT_DOLPHIN_JUMP, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WATER_GRAB, 0)
    end

    if m.pos.y <= m.floorHeight and m.vel.y <= 0 then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    m.faceAngle.x = approach_s32(m.faceAngle.x, 0, 0x500, 0x500)

    m.vel.x = m.forwardVel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.y = m.forwardVel * sins(m.faceAngle.x)
    m.vel.z = m.forwardVel * coss(m.faceAngle.y) * coss(m.faceAngle.x)

    apply_water_current(m, m.vel)

    if m.actionState == 0 then
        set_mario_anim_hold(m, MARIO_ANIM_WATER_ACTION_END, MARIO_ANIM_WATER_ACTION_END_WITH_OBJ)
        if is_anim_past_end(m) ~= 0 then
            m.actionState = 1
        end
    else
        set_mario_anim_hold(m, MARIO_ANIM_WATER_IDLE, MARIO_ANIM_WATER_IDLE_WITH_OBJ)
    end

    if _G.pcCharacter == "Mario" then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN

    m.forwardVel = approach_f32(m.forwardVel, 0, 2.2, 2.2)

    correct_water_pitch(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    set_mario_particle_flags(m, PARTICLE_BUBBLE, 0)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x

    return 0
end

---@param m MarioState
local peppino_swim_update_speed = function(m)
    local maxSpeed = sprintMode and MACH_3_SPEED_MIN - 5 or 32
    local speedBaseGain = sprintMode and 2.4 or 1.1
    local accelLoss = sprintMode and 37 or 40
    local vDir = 0

    if (m.input & INPUT_A_DOWN) ~= 0 then
        vDir = vDir + 1
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        vDir = vDir - 1
    end

    local intendedDYaw = s16(m.intendedYaw - m.faceAngle.y)
    local intendedMag

    if vDir == 1 and m.pos.y < m.waterLevel - 80 then
        intendedMag = 32
    elseif vDir == -1 and m.pos.y > m.floorHeight then
        intendedMag = 32
    else
        intendedMag = m.intendedMag
    end

    targetSpeed = intendedMag / 32 < 1 and intendedMag or maxSpeed

    if m.forwardVel <= 0 then
        m.forwardVel = m.forwardVel + speedBaseGain
    elseif m.forwardVel < targetSpeed then
        m.forwardVel = m.forwardVel + speedBaseGain - m.forwardVel / accelLoss
    else
        m.forwardVel = m.forwardVel - 2
    end

    m.vel.x = m.forwardVel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.y = m.forwardVel * sins(m.faceAngle.x)
    m.vel.z = m.forwardVel * coss(m.faceAngle.y) * coss(m.faceAngle.x)

    apply_water_current(m, m.vel)

    m.faceAngle.y = m.intendedYaw - approach_s32(intendedDYaw, 0, 0x600, 0x600)
end

---@param m MarioState
local act_peppino_swim = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local goalPitch = 90
    local vDir = 0

    if (m.input & INPUT_A_DOWN) ~= 0 then
        vDir = vDir + 1
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        vDir = vDir - 1
    end

    if m.pos.y <= m.floorHeight and m.vel.y <= 0 then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    peppino_swim_update_speed(m)

    if ((m.input & INPUT_NONZERO_ANALOG) == 0 and
    (vDir < 1 or m.pos.y >= m.waterLevel - 80) and
    (vDir > -1 or m.pos.y <= m.floorHeight)) or
    analog_stick_held_back(m) ~= 0 then
        if math.abs(m.forwardVel) < 16 then
            return set_mario_action(m, ACT_PEPPINO_WATER_IDLE, 0)
        end
        set_mario_action(m, ACT_WATER_DRIFT, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.pos.y >= m.waterLevel - 100 then
        return set_mario_action(m, ACT_DOLPHIN_JUMP, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WATER_GRAB, 0)
    end

    goalPitch = goalPitch * (1 - m.intendedMag / 64)

    if vDir == 1 and m.pos.y < m.waterLevel - 80 then
        m.faceAngle.x = approach_s32(m.faceAngle.x, deg_to_hex(goalPitch), 0x500, 0x500)
    elseif vDir == -1 and m.pos.y > m.floorHeight then
        m.faceAngle.x = approach_s32(m.faceAngle.x, deg_to_hex(-goalPitch), 0x500, 0x500)
    else
        m.faceAngle.x = approach_s32(m.faceAngle.x, 0, 0x500, 0x500)
    end

    if _G.pcCharacter == "Mario" then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    if step == GROUND_STEP_HIT_WALL or step == AIR_STEP_HIT_WALL then
        if math.abs(m.faceAngle.x) < deg_to_hex(30) then
            if p.machLevel <= 1 then
                m.forwardVel = 0
            else
                set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                m.forwardVel = -20
                set_mario_action(m, ACT_BACKWARD_WATER_KB, 0)
            end
        end
    end

    if p.machLevel <= 1 then
        if m.actionState == 0 then
            set_mario_anim_hold(m, MARIO_ANIM_SWIM_PART1, MARIO_ANIM_SWIM_WITH_OBJ_PART1)
            if is_anim_past_end(m) ~= 0 then
                m.actionState = 1
                if p.machLevel == 0 then
                    play_sound(SOUND_ACTION_SWIM, m.marioObj.header.gfx.cameraToObject)
                else
                    play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
                    set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)
                end
            end
        else
            set_mario_anim_hold(m, MARIO_ANIM_SWIM_PART2, MARIO_ANIM_SWIM_WITH_OBJ_PART2)
            if is_anim_past_end(m) ~= 0 then
                m.actionState = 0
            end
        end
        m.marioBodyState.handState = MARIO_HAND_OPEN
    else
        m.actionState = 0
        set_mario_anim_hold(m, MARIO_ANIM_FLUTTERKICK, MARIO_ANIM_FLUTTERKICK_WITH_OBJ)
        if m.marioObj.header.gfx.animInfo.animFrame == 0 or m.marioObj.header.gfx.animInfo.animFrame == 12 then
            play_sound(SOUND_ACTION_UNKNOWN434, m.marioObj.header.gfx.cameraToObject)
            set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)
        end
        m.marioObj.header.gfx.animInfo.animAccel = m.forwardVel * 0x600
    end

    correct_water_pitch(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    set_mario_particle_flags(m, PARTICLE_BUBBLE, 0)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x

    return 0
end

---@param m MarioState
local act_water_drift = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local vDir = 0

    if (m.input & INPUT_A_DOWN) ~= 0 then
        vDir = vDir + 1
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        vDir = vDir - 1
    end

    if (analog_stick_held_back(m) == 0 and (m.input & INPUT_NONZERO_ANALOG) ~= 0) or
    (vDir == 1 and m.pos.y < m.waterLevel - 80) or
    (vDir == -1 and m.pos.y > m.floorHeight) then
        return set_mario_action(m, ACT_PEPPINO_SWIM, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_WATER_GRAB, 0)
    end

    m.forwardVel = approach_s32(m.forwardVel, 0, 3.2, 3.2)

    if m.pos.y <= m.floorHeight and m.vel.y <= 0 then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    m.vel.x = m.forwardVel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.y = m.forwardVel * sins(m.faceAngle.x)
    m.vel.z = m.forwardVel * coss(m.faceAngle.y) * coss(m.faceAngle.x)

    apply_water_current(m, m.vel)

    set_mario_animation(m, MARIO_ANIM_TURNING_PART1)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x

    correct_water_pitch(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)
    set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)

    set_mario_particle_flags(m, PARTICLE_BUBBLE, 0)

    if _G.pcCharacter == "Mario" then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    if m.forwardVel == 0 then
        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            if p.machLevel == 1 then
                m.forwardVel = MACH_1_SPEED_MIN + 2
            elseif p.machLevel >= 2 then
                m.forwardVel = MACH_2_SPEED_MIN + 2
            end

            m.faceAngle.y = m.intendedYaw
            return set_mario_action(m, ACT_PEPPINO_SWIM, 0)
        else
            return set_mario_action(m, ACT_PEPPINO_WATER_IDLE, 0)
        end
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN

    return 0
end

--- @param m MarioState
local act_dolphin_jump = function(m)
    if m.playerIndex == 0 then
        set_camera_mode(m.area.camera, m.area.camera.defMode, 1)
    end

    play_mario_sound(m, SOUND_OBJ_UNKNOWN4, CHAR_SOUND_HOOHOO)

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.actionTimer > 0 then
        return set_mario_action(m, ACT_UPPERCUT, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        if m.heldObj == nil then
            return set_mario_action(m, ACT_DIVE, 0)
        else
            return set_mario_action(m, ACT_AIR_THROW, 0)
        end
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    m.actionTimer = m.actionTimer + 1

    update_air_without_turn(m)

    local step = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)

    if step == AIR_STEP_LANDED then
        if m.heldObj == nil then
            set_mario_action(m, ACT_DOUBLE_JUMP_LAND, 0)
        else
            set_mario_action(m, ACT_HOLD_JUMP_LAND, 0)
        end
    elseif step == AIR_STEP_HIT_WALL then
        if m.forwardVel > 16 then
            queue_rumble_data_mario(m, 5, 40)
            mario_bonk_reflection(m, 0)
            m.faceAngle.y = m.faceAngle.y + 0x8000

            if m.wall ~= nil then
                set_mario_action(m, ACT_AIR_HIT_WALL, 0)
            else
                m.vel.y = math.min(m.vel.y, 0)

                if m.forwardVel >= 38 then
                    set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                    set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
                else
                    if m.forwardVel > 8 then
                        mario_set_forward_vel(m, -8)
                    end
                    return set_mario_action(m, ACT_SOFT_BONK, 0)
                end
            end
        else
            mario_set_forward_vel(m, 0)
        end
    elseif step == AIR_STEP_GRABBED_LEDGE then
        set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    end

    if m.vel.y >= 0 then
        m.actionState = 0

        set_mario_anim_hold(m, MARIO_ANIM_DOUBLE_JUMP_RISE, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ)
        m.marioObj.header.gfx.angle.x = lerp(0, atan2s(m.forwardVel, m.vel.y), math.abs(m.forwardVel) / 30)
    else
        if m.actionState ~= 1 then
            if mario_roll_anim(m, 0x12000) then
                m.actionState = 1
                play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
            end
        else
            set_mario_anim_hold(m, MARIO_ANIM_DOUBLE_JUMP_FALL, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ)
            if m.marioObj.header.gfx.animInfo.animFrame < 3 then
                set_anim_to_frame(m, 3)
            end
            m.marioObj.header.gfx.angle.x = lerp(0, atan2s(m.forwardVel, m.vel.y), math.abs(m.forwardVel) / 30)
        end
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN
end

---@param m MarioState
local act_hurt = function(m)
    if m.pos.y + m.vel.y > m.waterLevel - 80 then
        m.action = ACT_HURT
    else
        m.action = ACT_WATER_HURT
    end

    local step = perform_air_step(m, 0)

    play_character_sound_if_no_flag(m, CHAR_SOUND_ATTACKED, MARIO_MARIO_SOUND_PLAYED)

    if m.actionTimer >= 35 then
        heightPeakPos = m.pos.y
        m.invincTimer = 30
        if m.action == ACT_WATER_HURT then
            if m.health < 0x100 then
                return set_mario_action(m, ACT_WATER_DEATH, 0)
            else
                return set_mario_action(m, ACT_PEPPINO_WATER_IDLE, 0)
            end
        end
        if m.health < 0x100 then
            m.action = ACT_HARD_BACKWARD_AIR_KB
        else
            return set_mario_action(m, ACT_FREEFALL, 0)
        end
    end

    if m.action == ACT_WATER_HURT and (m.flags & MARIO_METAL_CAP) == 0 then
        apply_water_current(m, m.vel)
    end

    m.actionTimer = m.actionTimer + 1

    if m.actionArg == 1 then
        set_custom_anim(m, "MARIO_ANIM_HURT")
        mario_set_forward_vel(m, -34)
    else
        set_mario_animation(m, MARIO_ANIM_FIRE_LAVA_BURN)
        mario_set_forward_vel(m, 34)
    end

    m.marioBodyState.eyeState = MARIO_EYES_DEAD
    m.marioBodyState.handState = MARIO_HAND_OPEN

    if step == AIR_STEP_LANDED then
        if m.action == ACT_WATER_HURT then
            m.actionTimer = 37
            return 0
        end

        m.invincTimer = 30

        if m.health - m.hurtCounter * 0x40 < 0x100 then
            return set_mario_action(m, ACT_HARD_BACKWARD_GROUND_KB, 0)
        else
            mario_set_forward_vel(m, 0)
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end
    end

    return 0
end

---@param m MarioState
local act_grab_air_cancel = function(m)
    local spinDuration = 6
    local t = m.actionTimer / spinDuration

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.actionTimer > 0 then
        return set_mario_action(m, ACT_UPPERCUT, 0)
    end

    if check_kick_or_dive_in_air(m) ~= 0 then
        return 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    local goalSpd = m.intendedMag
    if analog_stick_held_back(m) ~= 0 then
        if m.forwardVel > 0 then
            mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 3, 3))
        else
            mario_set_forward_vel(m, 0)
            m.faceAngle.y = m.intendedYaw
        end
    else
        mario_set_forward_vel(m, approach_f32(m.forwardVel, goalSpd, 3, 3))
        m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x900, 0x900)
    end

    set_mario_animation(m, MARIO_ANIM_GENERAL_FALL)

    local step = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)

    if step == AIR_STEP_LANDED then
        return set_mario_action(m, ACT_FREEFALL_LAND, 0)
    elseif step == AIR_STEP_HIT_WALL then
        if m.forwardVel > 16 then
            queue_rumble_data_mario(m, 5, 40)
            mario_bonk_reflection(m, 0)
            m.faceAngle.y = m.faceAngle.y + 0x8000

            if m.wall ~= nil then
                set_mario_action(m, ACT_AIR_HIT_WALL, 0)
            else
                m.vel.y = math.min(m.vel.y, 0)

                if m.forwardVel >= 38 then
                    set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
                    set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
                else
                    if m.forwardVel > 8 then
                        mario_set_forward_vel(m, -8)
                    end
                    return set_mario_action(m, ACT_SOFT_BONK, 0)
                end
            end
        else
            mario_set_forward_vel(m, 0)
        end
    elseif step == AIR_STEP_GRABBED_LEDGE then
        set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    end

    if m.actionTimer < math.floor(spinDuration / 3) then
        m.actionTimer = math.floor(spinDuration / 3)
    elseif m.actionTimer < spinDuration then
        m.actionTimer = m.actionTimer + 1
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + lerp(0, deg_to_hex(360), ease_out_quad(t))
end

local act_throw_attack = function(m)
    local grounded = (m.pos.y - m.floorHeight <= 0 and m.vel.y <= 0) and true or false
    local step = grounded and perform_ground_step(m) or perform_air_step(m, 0)

    if m.actionArg == 0 then
        set_custom_anim(m, "MARIO_ANIM_THROW_ATK_PUNCH")
    else
        set_custom_anim(m, "MARIO_ANIM_THROW_ATK_KICK")
    end

    local animFrame = m.marioObj.header.gfx.animInfo.animFrame

    update_air_without_turn(m)

    if animFrame < 11 then
        if (m.input & INPUT_Z_PRESSED) ~= 0 then
            m.vel.y = 42
            set_mario_action(m, ACT_PILEDRIVER, 0)
        end
    end

    if animFrame == 11 then
        mario_throw_held_object(m)
        play_character_sound(m, CHAR_SOUND_PUNCH_HOO)
        play_sound(SOUND_ACTION_HIT, m.marioObj.header.gfx.cameraToObject)
        set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
        mario_set_forward_vel(m, math.min(-15, m.forwardVel - 25))
        m.vel.y = 30
    end

    if animFrame >= 12 and animFrame <= 14 then
        if m.actionArg == 0 then
            m.marioBodyState.punchState = (1 << 6) | 4
        else
            m.marioBodyState.punchState = (2 << 6) | 4
        end
    end

    if animFrame >= 15 then
        m.actionTimer = m.actionTimer + 1
    end

    if m.actionTimer >= 10 then
        if grounded then
            return set_mario_action(m, ACT_IDLE, 0)
        else
            return set_mario_action(m, ACT_FREEFALL, 0)
        end
    end
end

hook_mario_action(ACT_SUPER_JUMP, act_super_jump, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_SUPER_JUMP_CANCEL, act_super_jump_cancel, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_WALL_RUN, act_wall_run, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_COMET_DIVE, { every_frame = act_comet_dive, gravity = act_comet_dive_gravity }, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_RECOVER_ROLL, act_recover_roll, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_GROUND_GRAB, act_ground_grab, INT_PUNCH)
hook_mario_action(ACT_AIR_GRAB, act_air_grab, INT_PUNCH)
hook_mario_action(ACT_WATER_GRAB, act_water_grab, INT_PUNCH)
hook_mario_action(ACT_PILEDRIVER, { every_frame = act_piledriver, gravity = act_ground_pound_gravity }, INT_GROUND_POUND_OR_TWIRL)
hook_mario_action(ACT_SPIN_THROW, act_spin_throw)
hook_mario_action(ACT_UPPERCUT, act_uppercut, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_TAUNT, act_taunt)
hook_mario_action(ACT_WATER_TAUNT, act_taunt)
hook_mario_action(ACT_PARRY, act_parry, INT_KICK) -- i know its more likely to get a punch animation thats why its processed like a kick fuck you lmao
hook_mario_action(ACT_WATER_PARRY, act_parry, INT_KICK)
hook_mario_action(ACT_BREAKDANCE, act_breakdance)
hook_mario_action(ACT_BELLY_DASH, act_belly_dash, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_AIR_TURNING, act_air_turning)
hook_mario_action(ACT_LONG_FALL, act_long_fall)
hook_mario_action(ACT_LONG_FALL_LAND, act_long_fall_land)
hook_mario_action(ACT_WALL_CRASH, act_wall_crash)
hook_mario_action(ACT_CEIL_CRASH, act_ceil_crash)
hook_mario_action(ACT_ROLL, act_roll, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_PEPPINO_WATER_IDLE, act_peppino_water_idle)
hook_mario_action(ACT_PEPPINO_SWIM, act_peppino_swim)
hook_mario_action(ACT_WATER_DRIFT, act_water_drift)
hook_mario_action(ACT_DOLPHIN_JUMP, act_dolphin_jump)
hook_mario_action(ACT_HURT, act_hurt)
hook_mario_action(ACT_WATER_HURT, act_hurt)
hook_mario_action(ACT_GRAB_AIR_CANCEL, act_grab_air_cancel)
hook_mario_action(ACT_THROW_ATTACK, act_throw_attack)