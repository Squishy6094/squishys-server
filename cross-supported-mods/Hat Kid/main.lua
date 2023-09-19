-- name: \\#ad5fb7\\Hat Kid
-- description: Adds Hat Kid with custom moveset as an echo character.\n\ \n\Type /hatkid \\#00C7FF\\on \\#ffffff\\-or-\\#A02200\\ off\\#ffffff\\ as "any" character to use this echo character!\n\ \n\Model ripped from AHIT DLC 1 by \\#ad5fb7\\Quotation\\#ffffff\\\n\Original Hat Kid voice mod by SoggieWafflz\n\\\#ffffff\\Moveset and coding by \\#00ffff\\steven.
ACT_SECOND_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WALL_SLIDE_CLIMB =
    allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_HAT_KID_WALKING = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING)
ACT_HAT_KID_DIVE =
    allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_ATTACKING)
ACT_HAT_KID_DIVE_CANCEL = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_HAT_KID_DIVE_SLIDE =
    allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_BUTT_OR_STOMACH_SLIDE | ACT_FLAG_ATTACKING)

function s16(num)
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

E_MODEL_HAT_KID = smlua_model_util_get_id("hat_kid_geo")
gStateExtras = {}
for i = 0, (MAX_PLAYERS - 1) do
    gStateExtras[i] = {}
    local m = gMarioStates[i]
    local e = gStateExtras[i]
    e.animFrame = 0
    e.hasDoubleJumped = false

    e.lastPos = {}
    e.lastPos.x = m.pos.x
    e.lastPos.y = m.pos.y
    e.lastPos.z = m.pos.z

    e.savedWallSlideHeight = 0
    e.savedWallSlide = false

    e.lastforwardVel = 0
end

function hatkid_command(msg)
    if gMarioStates[0].character.type == 3 and msg == "on" then
        djui_chat_message_create(
            "\\#ff0000\\You cannot be \\#7e0cd6\\Waluigi \\#ff0000\\for this Echo Character! (Nobody likes him.)"
        )
        return true
    elseif gMarioStates[0].character.type == 3 and msg == "off" then
        djui_chat_message_create(
            "\\#ff0000\\You cannot be \\#7e0cd6\\Waluigi \\#ff0000\\for this Echo Character! (Nobody likes him.)"
        )
        return true
    end
    if msg == "on" then
        djui_chat_message_create("\\#ad5fb7\\Hat Kid\\#ffffff\\ is \\#00C7FF\\on\\#ffffff\\!")
        gPlayerSyncTable[0].modelId = E_MODEL_HAT_KID
        return true
    elseif msg == "off" then
        djui_chat_message_create("\\#ad5fb7\\Hat Kid\\#ffffff\\ is \\#A02200\\off\\#ffffff\\!")
        gPlayerSyncTable[0].modelId = nil
        return true
    end
    return false
end

function mario_update_local(m)
    if gMarioStates[0].character.type == 3 then
        gPlayerSyncTable[0].modelId = nil
    end

    if _G.ssBooted then
        if _G.ssApi.option_read("Hat Kid") == 1 then
            gPlayerSyncTable[0].modelId = E_MODEL_HAT_KID
        else
            gPlayerSyncTable[0].modelId = nil
        end
    end
end

function mario_on_set_action(m)
    local e = gStateExtras[m.playerIndex]
    if gPlayerSyncTable[0].modelId == E_MODEL_HAT_KID then
        if m.action == ACT_GROUND_POUND and m.flags & (MARIO_METAL_CAP) == 0 then
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            return set_mario_action(m, ACT_HAT_KID_DIVE, 0)
        end
        if (m.input & INPUT_B_PRESSED) ~= 0 and m.action == ACT_DIVE and m.prevAction ~= ACT_GROUND_POUND then
            set_mario_action(m, ACT_JUMP_KICK, 0)
        end
        if m.action == ACT_DOUBLE_JUMP then
            return set_mario_action(m, ACT_JUMP, 0)
        end

        if m.action == ACT_HAT_KID_DIVE then
            mario_set_forward_vel(m, m.forwardVel + 20)
            if m.actionArg == 1 then
                if m.forwardVel < 50 then
                    mario_set_forward_vel(m, 50)
                elseif m.forwardVel > 100 then
                    mario_set_forward_vel(m, 100)
                end
                m.vel.y = 8
                m.faceAngle.x = 0
            end
        end

        if m.action == ACT_CROUCH_SLIDE then
            start_ground_dive(m)
        end

        local jumpActions = {
            [ACT_LONG_JUMP] = true,
            [ACT_DOUBLE_JUMP] = true,
            [ACT_TRIPLE_JUMP] = true,
            [ACT_SIDE_FLIP] = true,
            [ACT_BACKFLIP] = true,
            [ACT_TOP_OF_POLE_JUMP] = true,
            [ACT_WALL_KICK_AIR] = true,
            [ACT_FLYING_TRIPLE_JUMP] = true
        }

        if jumpActions[m.action] then
            m.vel.y = m.vel.y - 20
        end
        if m.action == ACT_JUMP or m.action == ACT_STEEP_JUMP then
            m.vel.y = m.vel.y - 15
        end

        if (m.action == ACT_SOFT_BONK or (m.action == ACT_BACKWARD_AIR_KB and m.wall ~= nil)) then
            start_wall_climb(m)
        end
		
    end
end

function start_wall_climb(m)
    local e = gStateExtras[m.playerIndex]
	local forbiddenActions = {
            [ACT_FLYING] = true,
            [ACT_HAT_KID_DIVE] = true,
            [ACT_DIVE] = true,
            [ACT_LEDGE_GRAB] = true,
            [ACT_SHOT_FROM_CANNON] = true,
        }
		
	if forbiddenActions[m.prevAction] then return end
	
    m.particleFlags = m.particleFlags & ~PARTICLE_VERTICAL_STAR
    m.faceAngle.y = m.faceAngle.y + 0x8000
    m.pos.x = e.lastPos.x
    m.pos.y = e.lastPos.y
    m.pos.z = e.lastPos.z
    if e.lastforwardVel > 0 then
        m.vel.y = e.lastforwardVel
    else
        m.vel.y = 0
    end
    return set_mario_action(m, ACT_WALL_SLIDE_CLIMB, 1)
end

function start_ground_dive(m)
    m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE

    return set_mario_action(m, ACT_HAT_KID_DIVE, 1)
end

function custom_walking_door_check(m)
    --replacin' the walking action while make sure the player can still open doors
    local dist = 100
    local doorwarp = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)
    local door = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoor)
    local stardoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)
    if m.action == ACT_WALKING then
        if
            (dist_between_objects(m.marioObj, doorwarp) > dist and doorwarp ~= nil) or
                (dist_between_objects(m.marioObj, door) > dist and door ~= nil) or
                (dist_between_objects(m.marioObj, stardoor) > dist and stardoor ~= nil)
         then
            return set_mario_action(m, ACT_HAT_KID_WALKING, 0)
        elseif doorwarp == nil and door == nil and stardoor == nil then
            return set_mario_action(m, ACT_HAT_KID_WALKING, 0)
        end
    end

    if m.action == ACT_HAT_KID_WALKING then
        if
            (dist_between_objects(m.marioObj, doorwarp) < dist and doorwarp ~= nil) or
                (dist_between_objects(m.marioObj, door) < dist and door ~= nil) or
                (dist_between_objects(m.marioObj, stardoor) < dist and stardoor ~= nil)
         then
            return set_mario_action(m, ACT_WALKING, 0)
        end
    end
end

function mario_update(m)
    local e = gStateExtras[m.playerIndex]
    if m.playerIndex == 0 then
        mario_update_local(m)
    end
    if gPlayerSyncTable[0].modelId == E_MODEL_HAT_KID then
        custom_walking_door_check(m)

        local doubleJumpableActions = {
            [ACT_JUMP] = true,
            [ACT_WALL_KICK_AIR] = true,
            [ACT_FREEFALL] = true,
            [ACT_STEEP_JUMP] = true,
        }

        if doubleJumpableActions[m.action] and
                e.hasDoubleJumped == false and
                m.actionTimer > 0 and
                (m.controller.buttonPressed & A_BUTTON) ~= 0
        then
            m.faceAngle.y = m.intendedYaw
            m.vel.y = 35
            set_mario_action(m, ACT_SECOND_JUMP, 0)
        end
		
		if (m.action == ACT_LAVA_BOOST) then
			if m.vel.y > 50 then m.vel.y = 50 end
		end

        if (m.action & ACT_FLAG_AIR) == 0 then
            e.hasDoubleJumped = false
        end
        if doubleJumpableActions[m.action] then
            m.actionTimer = m.actionTimer + 1
        end
        if (m.action == ACT_GROUND_POUND and m.flags & (MARIO_METAL_CAP) ~= 0 and
                (m.controller.buttonPressed & B_BUTTON) ~= 0) or
                (m.action == ACT_JUMP_KICK and (m.input & INPUT_Z_PRESSED) ~= 0)
        then
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_HAT_KID_DIVE, 0)
        end

        cap_switcher(m)

        -- save last pos
        e.lastPos.x = m.pos.x
        e.lastPos.y = m.pos.y
        e.lastPos.z = m.pos.z
        if m.forwardVel >= 0 then
            e.lastforwardVel = m.forwardVel
        end

        if (m.action & ACT_FLAG_AIR) ~= 0 and (m.action & ACT_FLAG_SWIMMING_OR_FLYING) == 0 and
                (m.action ~= ACT_WALL_SLIDE_CLIMB)
			and (m.action ~= ACT_SHOT_FROM_CANNON)
			and (m.action & ACT_GROUP_CUTSCENE) == 0
			and (m.action & ACT_GROUP_AUTOMATIC) == 0
        then
            m.vel.y = m.vel.y + 1.5
        end
    end

    if gPlayerSyncTable[m.playerIndex].modelId ~= nil then
        obj_set_model_extended(m.marioObj, gPlayerSyncTable[m.playerIndex].modelId)
    end
    return 0
end

if _G.ssExists then
    _G.ssApi.option_add("Hat Kid", 0, 1, nil, 
    {"Adds Hat Kid with custom",
    "moveset as an echo character",
    "",
    "",
    "",
    "Credits:",
    "Model ripped by Quotation",
    "Voice mod by SoogieWafflz",
    "Moveset and coding by steven.",})
end

function cap_switcher(m)
    local saveflag = save_file_get_flags()

    if (saveflag & SAVE_FLAG_HAVE_METAL_CAP) ~= 0 then
        if (m.controller.buttonPressed & L_JPAD) ~= 0 then
            m.flags = m.flags | MARIO_METAL_CAP
            m.flags = m.flags & ~MARIO_WING_CAP & ~MARIO_VANISH_CAP
        end
    end
    if (saveflag & SAVE_FLAG_HAVE_WING_CAP) ~= 0 then
        if (m.controller.buttonPressed & U_JPAD) ~= 0 then
            m.flags = m.flags | MARIO_WING_CAP
            m.flags = m.flags & ~MARIO_METAL_CAP & ~MARIO_VANISH_CAP
        end
    end
    if (saveflag & SAVE_FLAG_HAVE_VANISH_CAP) ~= 0 then
        if (m.controller.buttonPressed & R_JPAD) ~= 0 then
            m.flags = m.flags | MARIO_VANISH_CAP
            m.flags = m.flags & ~MARIO_METAL_CAP & ~MARIO_WING_CAP
        end
    end
    if (m.controller.buttonPressed & D_JPAD) ~= 0 then
        m.flags = m.flags & ~MARIO_WING_CAP & ~MARIO_METAL_CAP & ~MARIO_VANISH_CAP
    end
end

function act_second_jump(m)
    local e = gStateExtras[m.playerIndex]
    play_mario_sound(m, SOUND_ACTION_SPIN, CHAR_SOUND_HOOHOO)
    e.hasDoubleJumped = true
    if check_kick_or_dive_in_air(m) ~= 0 then
        return 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if m.actionTimer == 0 then
        e.animFrame = 0
        m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
    end

    local stepResult =
        common_air_action_step(
        m,
        ACT_FREEFALL_LAND,
        MARIO_ANIM_FORWARD_FLIP,
        AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG
    )
    set_anim_to_frame(m, e.animFrame)
    if stepResult == AIR_STEP_LANDED then
        e.hasDoubleJumped = false
    end
    if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
        e.animFrame = m.marioObj.header.gfx.animInfo.curAnim.loopEnd
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + 0x8000
    e.animFrame = e.animFrame + 1

    m.actionTimer = m.actionTimer + 1

    return 0
end

function act_hat_kid_dive_cancel(m)
    local e = gStateExtras[m.playerIndex]
    play_mario_sound(m, SOUND_ACTION_SPIN, 0)

    common_air_action_step(m, ACT_FREEFALL_LAND, MARIO_ANIM_FORWARD_FLIP, AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)

    if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
        e.animFrame = m.marioObj.header.gfx.animInfo.curAnim.loopEnd
    end

    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + 0x8000
end

function act_wall_slide_climb(m)
    local e = gStateExtras[m.playerIndex]
    e.savedWallSlideHeight = m.pos.y
    e.savedWallSlide = true

    if m.actionTimer == 0 then
        e.animFrame = 0
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = 52.0
        -- m.faceAngle.y = m.faceAngle.y + 0x8000
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
    end

    if (m.controller.buttonPressed & Z_TRIG) ~= 0 then
        set_mario_action(m, ACT_FREEFALL, 0)
    end
    -- attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls
    mario_set_forward_vel(m, -1.0)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)

    if perform_air_step(m, 0) == AIR_STEP_LANDED then
        mario_set_forward_vel(m, 0.0)
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            return set_mario_action(m, ACT_FREEFALL_LAND, 0)
        end
    end

    m.actionTimer = m.actionTimer + 1
    if m.wall == nil and m.actionTimer > 2 then
        mario_set_forward_vel(m, 0.0)
        if m.actionArg == 1 then
            m.faceAngle.y = m.faceAngle.y + 0x8000
        end
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    -- gravity
    m.peakHeight = m.vel.y
    if m.vel.y <= -30 then
        m.vel.y = -30
    end

    -- Anim changin' stuff.
    if m.actionArg == 0 then
        set_mario_animation(m, MARIO_ANIM_START_WALLKICK)
    elseif m.actionArg == 1 then
        set_mario_animation(m, MARIO_ANIM_CRAWLING)
        set_anim_to_frame(m, e.animFrame)
        if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
            e.animFrame = 0
        else
            e.animFrame = e.animFrame + math.abs(m.vel.y)
        end

        if m.vel.y <= 0 then
            m.pos.x = e.lastPos.x
            m.pos.y = e.lastPos.y
            m.pos.z = e.lastPos.z
            set_mario_action(m, ACT_WALL_SLIDE_CLIMB, 0)
        end

        m.marioObj.header.gfx.angle.x = -0x36000
        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + 0x8000
    end

    return 0
end

function custom_update_walking_speed(m)
    local maxTargetSpeed = 0
    local targetSpeed = 0
    local cap = 43
    local acc = 1.1

    if (m.controller.buttonDown & B_BUTTON) ~= 0 then
        cap = 63
        acc = 1.4
    else
        cap = 43
        acc = 1.1
    end
	
    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = cap - 6
    else
        maxTargetSpeed = cap
    end

    if m.intendedMag < 20 then
        targetSpeed = m.intendedMag
    else
        targetSpeed = maxTargetSpeed
    end

    if (m.quicksandDepth > 10.0) then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth)
    end

    if (m.forwardVel <= 0.0) then
        m.forwardVel = m.forwardVel + acc
    elseif (m.forwardVel <= targetSpeed) then
        m.forwardVel = m.forwardVel + (acc - m.forwardVel / cap)
    elseif (m.floor ~= nil and m.floor.normal.y >= 0.95) then
        m.forwardVel = m.forwardVel - (acc - 0.1)
    end

    if (m.forwardVel > cap + 3) then
        m.forwardVel = m.forwardVel - 1
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800)

    apply_slope_accel(m)
end

function act_hat_kid_walking(m)
    local startYaw = m.faceAngle.y
    mario_drop_held_object(m)

    m.actionState = 0
    custom_update_walking_speed(m)
    local stepResult = perform_ground_step(m)

    if stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_animation(m, MARIO_ANIM_GENERAL_FALL)
    elseif stepResult == GROUND_STEP_NONE then
        anim_and_audio_for_walk(m)
        if (m.intendedMag - m.forwardVel) > 16 or m.forwardVel >= 60 then
            set_mario_particle_flags(m, PARTICLE_DUST, false)
        end
    elseif stepResult == GROUND_STEP_HIT_WALL then
        push_or_sidle_wall(m, m.pos)
        m.actionTimer = 0
    end

    check_ledge_climb_down(m)
    --tilt_body_walking(m, startYaw)
    custom_tilt_body_walking(m, startYaw)

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        start_ground_dive(m)
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return begin_braking_action(m)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        if (m.controller.buttonDown & B_BUTTON) ~= 0 and m.forwardVel > 60 then
            mario_set_forward_vel(m, m.forwardVel + 2)
            if (m.flags & MARIO_WING_CAP) ~= 0 then
                set_mario_action(m, ACT_FLYING_TRIPLE_JUMP, 0)
            else
                set_mario_action(m, ACT_TRIPLE_JUMP, 0)
            end
        else
            set_mario_action(m, ACT_JUMP, 0)
        end
    end

    if (check_ground_dive_or_punch(m)) ~= 0 then
        return true
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return begin_braking_action(m)
    end

    if m.forwardVel > 16 and analog_stick_held_back(m) ~= 0 then
        return set_mario_action(m, ACT_TURNING_AROUND, 0)
    end
    return 0
end

function custom_tilt_body_walking(m, startYaw)
    local val0C = m.marioObj

    local dYaw = m.faceAngle.y - startYaw
    -- (Speed Crash) These casts can cause a crash if (dYaw * forwardVel / 12) or
    -- (forwardVel * 170) exceed or equal 2^31.
    local val02 = 0 - s16((dYaw * m.forwardVel / 12.0))
    local val00 = s16((m.forwardVel * 170.0))

    if (val02 > 0x1000) then
        val02 = 0x1000
    end
    if (val02 < -0x1000) then
        val02 = -0x1000
    end

    if (val00 > 0x1000) then
        val00 = 0x1000
    end
    if (val00 < 0) then
        val00 = 0
    end

    val0C.header.gfx.angle.z = approach_s32(val0C.header.gfx.angle.z + val02, 0, 0x900, 0x900)
    val0C.header.gfx.angle.x = approach_s32(val0C.header.gfx.angle.x + val00, 0, 0x900, 0x900)
end

function act_hat_kid_dive(m)
    if (m.actionArg == 0) then
        play_mario_sound(m, SOUND_ACTION_THROW, CHAR_SOUND_HOOHOO)
    else
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    end

    if m.actionTimer < 10 then
        if m.actionArg == 0 then
            if m.forwardVel < 50 then
                mario_set_forward_vel(m, 50)
            elseif m.forwardVel > 100 then
                mario_set_forward_vel(m, 100)
            end
            m.vel.y = 0
            m.faceAngle.x = 0
        end
        set_mario_particle_flags(m, PARTICLE_DUST, false)
    end

    set_mario_animation(m, MARIO_ANIM_DIVE)
    if (mario_check_object_grab(m) ~= 0) then
        mario_grab_used_object(m)
        if (m.heldObj ~= nil) then
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
            if (m.action ~= ACT_HAT_KID_DIVE) then
                return 1
            end
        end
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_HAT_KID_DIVE_CANCEL, 0)
    end

    update_air_without_turn(m)

    local stepResult = perform_air_step(m, 0)

    if stepResult == AIR_STEP_NONE then
        if (m.vel.y < 0.0 and m.faceAngle.x > -0x2AAA) then
            m.faceAngle.x = m.faceAngle.x - 0x200
            if (m.faceAngle.x < -0x2AAA) then
                m.faceAngle.x = -0x2AAA
            end
        end
        m.marioObj.header.gfx.angle.x = -m.faceAngle.x
    elseif stepResult == AIR_STEP_LANDED then
        if (should_get_stuck_in_ground(m) ~= 0 and m.faceAngle[0] == -0x2AAA) then
            queue_rumble_data_mario(m, 5, 80)
            play_character_sound(m, CHAR_SOUND_OOOF2)
            set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, false)
            drop_and_set_mario_action(m, ACT_HEAD_STUCK_IN_GROUND, 0)
        elseif check_fall_damage(m, ACT_HARD_FORWARD_GROUND_KB) == 0 then
            if (m.heldObj == nil) then
                set_mario_action(m, ACT_HAT_KID_DIVE_SLIDE, 0)
            else
                set_mario_action(m, ACT_DIVE_PICKING_UP, 0)
            end
        end
        m.faceAngle.x = 0
    elseif stepResult == AIR_STEP_HIT_WALL then
        mario_bonk_reflection(m, true)
        m.faceAngle.x = 0

        if (m.vel.y > 0.0) then
            m.vel.y = 0.0
        end

        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, false)
        drop_and_set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    elseif stepResult == AIR_STEP_HIT_LAVA_WALL then
        lava_boost_on_wall(m)
    end

    m.actionTimer = m.actionTimer + 1

    return 0
end

function act_hat_kid_dive_slide(m)
    if (mario_check_object_grab(m) ~= 0) then
        mario_grab_used_object(m)
        if (m.heldObj ~= nil) then
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
    end

    if (m.input & INPUT_ABOVE_SLIDE) == 0 and (m.input & INPUT_A_PRESSED) ~= 0 then
        queue_rumble_data_mario(m, 5, 80)
        if m.forwardVel > 0 then
            if m.actionTimer <= 1 then
                m.particleFlags = m.particleFlags | PARTICLE_SPARKLES
                return set_mario_action(m, ACT_TOP_OF_POLE_JUMP, 0)
            else
                m.vel.y = 30
                if m.forwardVel < 100 then
                    m.forwardVel = m.forwardVel + 10
                end
                return set_mario_action(m, ACT_HAT_KID_DIVE_CANCEL, 0)
            end
        else
            return set_mario_action(m, ACT_BACKWARD_ROLLOUT, 0)
        end
    end

    mario_set_forward_vel(m, m.forwardVel + 1.3)

    play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND)

    --! If the dive slide ends on the same frame that we pick up on object,
    -- Mario will not be in the dive slide action for the call to
    -- mario_check_object_grab, and so will end up in the regular picking action,
    -- rather than the picking up after dive action.

    if update_sliding(m, 8) ~= 0 and is_anim_at_end(m) ~= 0 then
        mario_set_forward_vel(m, 0.0)
        set_mario_action(m, ACT_STOMACH_SLIDE_STOP, 0)
    end

    if mario_check_object_grab(m) ~= 0 then
        mario_grab_used_object(m)
        if m.heldObj ~= 0 then
            m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
        end
        return true
    end

    --lazy-ass speed cap
    if m.forwardVel > 100 then
        m.forwardVel = m.forwardVel - 5
    else
        m.forwardVel = m.forwardVel - 1
    end

    common_slide_action(m, ACT_STOMACH_SLIDE_STOP, ACT_FREEFALL, MARIO_ANIM_DIVE)
    m.actionTimer = m.actionTimer + 1
    return 0
end

function on_interact(m, o, type)
    if m.action == ACT_HAT_KID_DIVE or m.action == ACT_HAT_KID_DIVE_SLIDE then
        if (type & (INTERACT_GRABBABLE) ~= 0) and o.oInteractionSubtype & (INT_SUBTYPE_NOT_GRABBABLE) == 0 then
            m.interactObj = o
            m.input = m.input | INPUT_INTERACT_OBJ_GRABBABLE
            if o.oSyncID ~= 0 then
                network_send_object(o, true)
            end
        end
        return true
    end
	
    if m.action == ACT_HAT_KID_WALKING then
        if (type & (INTERACT_KOOPA_SHELL) ~= 0) then
            if o.oSyncID ~= 0 then
                network_send_object(o, true)
            end
            return set_mario_action(m, ACT_RIDING_SHELL, 0)
        end
        return true
    end
end

-----------
-- hooks --
-----------
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, mario_on_set_action)
hook_event(HOOK_ALLOW_INTERACT, on_interact)

hook_mario_action(ACT_SECOND_JUMP, act_second_jump)
hook_mario_action(ACT_WALL_SLIDE_CLIMB, act_wall_slide_climb)
hook_mario_action(ACT_HAT_KID_WALKING, act_hat_kid_walking)
hook_mario_action(ACT_HAT_KID_DIVE, act_hat_kid_dive, INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_HAT_KID_DIVE_CANCEL, act_hat_kid_dive_cancel)
hook_mario_action(ACT_HAT_KID_DIVE_SLIDE, act_hat_kid_dive_slide, INT_FAST_ATTACK_OR_SHELL)
hook_chat_command(
    "hatkid",
    "[\\#00C7FF\\on\\#ffffff\\|\\#A02200\\off\\#ffffff\\] turn \\#ad5fb7\\Hat Kid \\#ffffff\\ \\#00C7FF\\on \\#ffffff\\or \\#A02200\\off",
    hatkid_command
)
