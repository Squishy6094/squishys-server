------- DISMOUNTED ACTIONS -------

ACT_SPIN_ATTACK = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_MOVING | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

--- @param m MarioState
local act_spin_attack = function(m)
    local step
    local startYaw = m.twirlYaw
    local grounded = m.pos.y <= m.floorHeight and m.vel.y <= 0

    if analog_stick_held_back(m) ~= 0 then
        if m.forwardVel > 0 or m.forwardVel < -12 then
            mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 10, 10))
        else
            mario_set_forward_vel(m, 0)
            m.faceAngle.y = m.intendedYaw
        end
    else
        m.forwardVel = approach_s32(m.forwardVel, lerp(MACH_1_SPEED_MIN + 24, 20, (m.actionTimer - 12) / 18), 10, 10)
        mario_set_forward_vel(m, m.forwardVel)
        m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x900, 0x900)
    end

    m.twirlYaw = m.twirlYaw + deg_to_hex(lerp(70, 40, (m.actionTimer - 12) / 18))

    if m.twirlYaw >= deg_to_hex(60) and m.twirlYaw <= deg_to_hex(120) then
        m.marioBodyState.punchState = (0 << 6) | 3
    elseif (m.twirlYaw >= deg_to_hex(20) and m.twirlYaw < deg_to_hex(60)) or (m.twirlYaw > deg_to_hex(120) and m.twirlYaw <= deg_to_hex(160)) then
        m.marioBodyState.punchState = (0 << 6) | 2

    elseif m.twirlYaw >= deg_to_hex(-120) and m.twirlYaw <= deg_to_hex(-60) then
        m.marioBodyState.punchState = (1 << 6) | 3
    elseif (m.twirlYaw >= deg_to_hex(-60) and m.twirlYaw < deg_to_hex(-20)) or (m.twirlYaw > deg_to_hex(-160) and m.twirlYaw <= deg_to_hex(-120)) then
        m.marioBodyState.punchState = (1 << 6) | 2
    end

    set_mario_animation(m, MARIO_ANIM_TWIRL)

    if startYaw > m.twirlYaw then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
    end

    m.actionTimer = m.actionTimer + 1

    if m.actionTimer > 16 and (m.controller.buttonDown & B_BUTTON) == 0 then
        if grounded then
            if m.forwardVel < -10 then
                mario_set_forward_vel(m, -10)
            end
            return set_mario_action(m, ACT_WALKING, 0)
        else
            return set_mario_action(m, ACT_FREEFALL, 0)
        end
    end

    if grounded then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    if step == GROUND_STEP_HIT_WALL or step == AIR_STEP_HIT_WALL then
        if m.wall == nil or m.wall.object == nil or m.wall.object.oInteractType & INTERACT_BREAKABLE == 0 then
            mario_set_forward_vel(m, -90)
        end
        play_sound(SOUND_ACTION_HIT, m.marioObj.header.gfx.cameraToObject)
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + m.twirlYaw
end

hook_mario_action(ACT_SPIN_ATTACK, act_spin_attack, INT_FAST_ATTACK_OR_SHELL)

------- MOUNTED ACTIONS -------

ACT_BRICK_IDLE = (ACT_GROUP_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_PAUSE_EXIT | ACT_FLAG_STATIONARY)

ACT_BRICK_MOVING = (ACT_GROUP_MOVING | ACT_FLAG_MOVING)


ACT_BRICK_AIR = (ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

---@param m MarioState
local act_brick_idle = function(m)
    if m.floor and m.floor.normal.y < 0.29237169 then
        return mario_push_off_steep_floor(m, ACT_BRICK_AIR, FREEFALL_SUBACT)
    end

    if (m.input & INPUT_UNKNOWN_10) ~= 0 then
        return set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_BRICK_AIR, JUMP_SUBACT)
    end

    if (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return set_mario_action(m, ACT_BRICK_AIR, FREEFALL_SUBACT)
    end

    if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        m.faceAngle.y = m.intendedYaw
        return set_mario_action(m, ACT_BRICK_MOVING, 0)
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 then
        return set_mario_action(m, ACT_START_CROUCHING, 0);
    end

    set_custom_anim(m, "GUS_ANIM_IDLE_MOUNT")

    stationary_ground_step(m)
    return 0
end

---@param m MarioState
local act_brick_moving = function(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_BRICK_AIR, JUMP_SUBACT)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    if m.actionArg == WALKING_SUBACT then
        set_custom_anim(m, "GUS_ANIM_WALK_MOUNT", m.forwardVel / 4 * 0x10000)
        update_new_walk_speed(m)

        if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
            m.actionArg = SKID_SUBACT
        end
    elseif m.actionArg == SKID_SUBACT then
        set_custom_anim(m, "GUS_ANIM_IDLE_MOUNT")
        if apply_slope_decel(m, 2) ~= 0 then
            set_mario_action(m, ACT_BRICK_IDLE, 0)
        end
    end

    step = perform_ground_step(m)

    if step == GROUND_STEP_LEFT_GROUND then
        return set_mario_action(m, ACT_BRICK_AIR, FREEFALL_SUBACT)
    end

    return 0
end

---@param m MarioState
local act_brick_air = function(m)
    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if m.actionArg == JUMP_SUBACT then
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
        if m.vel.y > 10 and (m.input & INPUT_A_DOWN) == 0 then
            m.vel.y = m.vel.y / 4
        end
    end
    set_custom_anim(m, "GUS_ANIM_JUMP_MOUNT")

    update_air_without_turn(m)

    step = perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)

    if step == AIR_STEP_LANDED then
        set_mario_action(m, ACT_BRICK_MOVING, 0)
    elseif step == AIR_STEP_HIT_WALL then
        mario_set_forward_vel(m, 0)
    elseif step == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    elseif step == AIR_STEP_GRABBED_LEDGE then
        set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE)
        drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0)
    elseif step == AIR_STEP_GRABBED_CEILING then
        set_mario_action(m, ACT_START_HANGING, 0)
    end
    return 0
end

hook_mario_action(ACT_BRICK_IDLE, act_brick_idle)
hook_mario_action(ACT_BRICK_MOVING, act_brick_moving)
hook_mario_action(ACT_BRICK_AIR, act_brick_air)