--Char Movesets (1)

ANGLE_QUEUE_SIZE = 9
SPIN_TIMER_SUCCESSFUL_INPUT = 4

gEventTable = {}

gStateExtras = {}
for i = 0, (MAX_PLAYERS - 1) do
    gStateExtras[i] = {}
    local m = gMarioStates[i]
    local e = gStateExtras[i]
    e.prevPos = {}
    e.prevPos.x = 0
    e.prevPos.y = 0
    e.prevPos.z = 0
    e.angleDeltaQueue = {}
    for j = 0, (ANGLE_QUEUE_SIZE - 1) do e.angleDeltaQueue[j] = 0 end
    e.lastAction = m.action
    e.animFrame = 0
    e.scuttle = 0
    e.averageForwardVel = 0
    e.boostTimer = 0
    e.rotAngle = 0
    e.lastHurtCounter = 0
    e.stickLastAngle = 0
    e.spinDirection = 0
    e.spinBufferTimer = 0
    e.spinInput = 0
    e.lastIntendedMag = 0
end

-----------
-- luigi --
-----------

ACT_SPIN_POUND_LAND = allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING)
ACT_SPIN_POUND      = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)

function act_spin_pound(m)
    local e = gStateExtras[m.playerIndex]
    if m.actionTimer == 0 then
        m.actionState = m.actionArg
    end

    local spinDirFactor = 1  -- negative for clockwise, positive for counter-clockwise
    if m.actionState == 1 then spinDirFactor = -1 end

    set_mario_animation(m, MARIO_ANIM_TWIRL)

    m.particleFlags = m.particleFlags | PARTICLE_DUST

    if (m.controller.buttonDown & Z_TRIG) == 0 then
        set_mario_action(m, ACT_TWIRLING, 5)
    end

    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then
        if should_get_stuck_in_ground(m) ~= 0 then
            queue_rumble_data_mario(m, 5, 80)
            play_character_sound(m, CHAR_SOUND_OOOF2)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0)
        else
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            if check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
                m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
                set_mario_action(m, ACT_SPIN_POUND_LAND, 0)
            end
        end
        set_camera_shake_from_hit(SHAKE_GROUND_POUND)
    elseif stepResult == AIR_STEP_HIT_WALL then
        mario_set_forward_vel(m, -16.0)
        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    end

    -- set facing direction
    -- not part of original Extended Moveset
    local yawDiff = m.faceAngle.y - m.intendedYaw
    e.rotAngle = e.rotAngle + yawDiff
    m.faceAngle.y = m.intendedYaw

    e.rotAngle = e.rotAngle + 0x3053
    if e.rotAngle >  0x10000 then e.rotAngle = e.rotAngle - 0x10000 end
    if e.rotAngle < -0x10000 then e.rotAngle = e.rotAngle + 0x10000 end
    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + e.rotAngle * spinDirFactor
    m.marioBodyState.handState = MARIO_HAND_OPEN

    m.actionTimer = m.actionTimer + 1

    return 0
end

function act_spin_pound_land(m)
    m.actionState = 1

    if m.actionTimer <= 8 then
        if (m.input & INPUT_UNKNOWN_10) ~= 0 then
            return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
        end

        if (m.input & INPUT_OFF_FLOOR) ~= 0 then
            return set_mario_action(m, ACT_FREEFALL, 0)
        end

        if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
            return set_mario_action(m, ACT_BUTT_SLIDE, 0)
        end

        stationary_ground_step(m)
        set_mario_animation(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP)
    else
        if (m.input & INPUT_UNKNOWN_10) ~= 0 then
            return set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
        end

        if (m.input & (INPUT_NONZERO_ANALOG | INPUT_A_PRESSED | INPUT_OFF_FLOOR | INPUT_ABOVE_SLIDE)) ~= 0 then
            return check_common_action_exits(m)
        end

        stopping_step(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP, ACT_IDLE)
    end

    m.actionTimer = m.actionTimer + 1

    return 0
end

function luigi_before_phys_step(m)
    local e = gStateExtras[m.playerIndex]

    local floorClass = mario_get_floor_class(m)
    local hScale = 1.0
    local vScale = 1.0

    -- faster swimming
    if (m.action & ACT_FLAG_SWIMMING) ~= 0 then
        if m.action ~= ACT_BACKWARD_WATER_KB and m.action ~= ACT_FORWARD_WATER_KB then
            hScale = hScale * 1.5
            if m.action ~= ACT_WATER_PLUNGE then
                vScale = vScale * 1.5
            end
        end
    end

    -- slower holding item
    if m.heldObj ~= nil then
        m.vel.y = m.vel.y - 1.0
        hScale = hScale * 0.9
        if (m.action & ACT_FLAG_AIR) ~= 0 then
            hScale = hScale * 0.9
        end
    end

    -- acceleration
    if (m.action == ACT_WALKING) then
        if (floorClass == 19 or floorClass == 20) then
            hScale = -(m.forwardVel / 64) + 1.5
        else
            hScale = (m.forwardVel / 64) + 0.5
        end
    end

    -- friction
    if (m.action == ACT_BRAKING or m.action == ACT_TURNING_AROUND) then
        if (floorClass == 19 or floorClass == 20) then
            m.forwardVel = m.forwardVel - 3
        elseif (floorClass == 21) then
            hScale = hScale * 1.5
            m.forwardVel = m.forwardVel + (hScale * 2)
        else
            hScale = hScale * 1.4
            m.forwardVel = m.forwardVel + hScale
        end
        if (m.forwardVel < 0) then
            m.forwardVel = 0
        end
    end

    m.vel.x = m.vel.x * hScale
    m.vel.y = m.vel.y * vScale
    m.vel.z = m.vel.z * hScale
end

function luigi_on_set_action(m)
    local e = gStateExtras[m.playerIndex]

    -- extra height to the backflip
    if m.action == ACT_BACKFLIP then
        m.vel.y = m.vel.y + 18

    -- nerf wall kicks
    elseif m.action == ACT_WALL_KICK_AIR and m.prevAction ~= ACT_HOLDING_POLE and m.prevAction ~= ACT_CLIMBING_POLE then
        if m.vel.y > 56 then m.vel.y = 56 end
        return

    -- turn dive into kick when holding jump
    elseif m.action == ACT_DIVE and (m.controller.buttonDown & A_BUTTON) ~= 0 and e.scuttle > 0 then
        return set_mario_action(m, ACT_JUMP_KICK, 0)

    -- extra height on jumps
    elseif m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP or m.action == ACT_STEEP_JUMP or m.action == ACT_SIDE_FLIP or m.action == ACT_RIDING_SHELL_JUMP then
        m.vel.y = m.vel.y + 6

    end

    e.lastAction = action
end

function luigi_update(m)
    local e = gStateExtras[m.playerIndex]

    -- increase player damage
    if (m.hurtCounter > e.lastHurtCounter) then
        m.hurtCounter = m.hurtCounter + 4
    end
    e.lastHurtCounter = m.hurtCounter

    -- air scuttle
    e.scuttle = 0
    local shouldScuttle = (m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_HOLD_JUMP) and ((m.controller.buttonDown & A_BUTTON) ~= 0 and m.vel.y < -5)
    if shouldScuttle then
        -- prevent wing flutter from glitching out while scuttling
        if m.marioBodyState.wingFlutter == 1 then
            m.vel.y = m.vel.y + 1
        else
            m.vel.y = m.vel.y + 3
            if m.action == ACT_HOLD_JUMP then
                set_mario_animation(m, MARIO_ANIM_RUN_WITH_LIGHT_OBJ)
            else
                set_mario_animation(m, MARIO_ANIM_RUNNING_UNUSED)
            end
            set_anim_to_frame(m, e.animFrame)
            e.animFrame = e.animFrame + 13
            if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
                e.animFrame = e.animFrame - m.marioObj.header.gfx.animInfo.curAnim.loopEnd
            end
            e.scuttle = 1
        end
    end

    -- twirl pound
    if m.action == ACT_TWIRLING and (m.controller.buttonDown & Z_TRIG) ~= 0 then
        set_mario_action(m, ACT_SPIN_POUND, 0)
    end

    -- backflip turns into twirl
    if m.action == ACT_BACKFLIP and m.marioObj.header.gfx.animInfo.animFrame > 18 then
        m.angleVel.y = 0x1800
        set_mario_action(m, ACT_TWIRLING, 1)
    end
end

gEventTable[CT_LUIGI] = {
    before_phys_step = luigi_before_phys_step,
    on_set_action    = luigi_on_set_action,
    update           = luigi_update,
}

-----------
-- toad --
-----------

function toad_before_phys_step(m)
    local e = gStateExtras[m.playerIndex]

    local hScale = 1.0
    local vScale = 1.0

    -- faster ground movement
    if (m.action & ACT_FLAG_MOVING) ~= 0 then
        hScale = hScale * 1.19
    end

    -- slower holding item
    if m.heldObj ~= nil then
        m.vel.y = m.vel.y - 2.0
        hScale = hScale * 0.9
        if (m.action & ACT_FLAG_AIR) ~= 0 then
            hScale = hScale * 0.9
        end
    end

    m.vel.x = m.vel.x * hScale
    m.vel.y = m.vel.y * vScale
    m.vel.z = m.vel.z * hScale
end

function toad_on_set_action(m)
    local e = gStateExtras[m.playerIndex]

    -- wall kick height based on how fast toad is going
    if m.action == ACT_WALL_KICK_AIR and m.prevAction ~= ACT_HOLDING_POLE and m.prevAction ~= ACT_CLIMBING_POLE then
        m.vel.y = m.vel.y * 0.5
        m.vel.y = m.vel.y + e.averageForwardVel * 0.7
        return
    end

    -- more distance on dive and long jump
    if m.action == ACT_DIVE or m.action == ACT_LONG_JUMP then
        m.forwardVel = m.forwardVel * 1.35
    end

    -- less height on jumps
    if m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP or m.action == ACT_STEEP_JUMP or m.action == ACT_RIDING_SHELL_JUMP or m.action == ACT_BACKFLIP or m.action == ACT_WALL_KICK_AIR  or m.action == ACT_LONG_JUMP then
        m.vel.y = m.vel.y * 0.8

        -- prevent from getting stuck on platform
        if m.marioObj.platform ~= nil then
            m.pos.y = m.pos.y + 10
        end
    elseif m.action == ACT_SIDE_FLIP then
        m.vel.y = m.vel.y * 0.86

        -- prevent from getting stuck on platform
        if m.marioObj.platform ~= nil then
            m.pos.y = m.pos.y + 10
        end
    end

    e.lastAction = action
end

function toad_update(m)
    local e = gStateExtras[m.playerIndex]

    -- track average forward velocity
    if e.averageForwardVel > m.forwardVel then
        e.averageForwardVel = e.averageForwardVel * 0.93 + m.forwardVel * 0.07
    else
        e.averageForwardVel = m.forwardVel
    end

    -- faster flip during ground pound
    if m.action == ACT_GROUND_POUND then
        if m.actionTimer < 10 then
            m.actionTimer = m.actionTimer + 1
        end
    end

    -- ground pound jump
    if m.action == ACT_GROUND_POUND_LAND and (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        m.vel.y = m.vel.y + 18
        m.forwardVel = m.forwardVel + 10
    end

end

gEventTable[CT_TOAD] = {
    before_phys_step = toad_before_phys_step,
    on_set_action    = toad_on_set_action,
    update           = toad_update,
}

-------------
-- waluigi --
-------------

ACT_WALL_SLIDE = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        local rc = set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        m.vel.y = 72.0

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
    m.vel.y = m.vel.y + 2

    return 0
end

function waluigi_before_phys_step(m)
    local e = gStateExtras[m.playerIndex]

    local hScale = 1.0
    local vScale = 1.0

    -- faster ground movement
    if (m.action & ACT_FLAG_MOVING) ~= 0 then
        hScale = hScale * 1.085
    end

    m.vel.x = m.vel.x * hScale
    m.vel.y = m.vel.y * vScale
    m.vel.z = m.vel.z * hScale

    if m.action == ACT_TRIPLE_JUMP and m.prevAction == ACT_DOUBLE_JUMP and m.actionTimer < 6 then
        m.particleFlags = m.particleFlags | PARTICLE_DUST
        m.actionTimer = m.actionTimer + 1
    end
end

function waluigi_on_set_action(m)
    local e = gStateExtras[m.playerIndex]

    -- wall slide
    if m.action == ACT_SOFT_BONK then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        set_mario_action(m, ACT_WALL_SLIDE, 0)
        m.vel.x = 0
        m.vel.y = 0
        m.vel.z = 0

    -- turn wall kick into flip
    elseif m.action == ACT_WALL_KICK_AIR and m.prevAction ~= ACT_HOLDING_POLE and m.prevAction ~= ACT_CLIMBING_POLE then
        local rc = set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        m.vel.y = 60.0

        if m.forwardVel < 20.0 then
            m.forwardVel = 20.0
        end
        m.wallKickTimer = 0
        return rc

    -- less height on jumps
    elseif m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP or m.action == ACT_STEEP_JUMP or m.action == ACT_SIDE_FLIP or m.action == ACT_RIDING_SHELL_JUMP or m.action == ACT_BACKFLIP or m.action == ACT_WALL_KICK_AIR  or m.action == ACT_LONG_JUMP then
        m.vel.y = m.vel.y * 0.91
    end

    e.lastAction = action
end

function waluigi_update(m)
    local e = gStateExtras[m.playerIndex]

    -- increase player damage
    if m.hurtCounter > e.lastHurtCounter then
        m.hurtCounter = m.hurtCounter * 2
    end
    e.lastHurtCounter = m.hurtCounter

    -- double jump
    if m.action == ACT_DOUBLE_JUMP and m.actionTimer > 0 and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
        set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        m.vel.y = m.vel.y * 0.8
    end
    if m.action == ACT_DOUBLE_JUMP then
        m.actionTimer = m.actionTimer + 1
    end

end

gEventTable[CT_WALUIGI] = {
    before_phys_step = waluigi_before_phys_step,
    on_set_action    = waluigi_on_set_action,
    update           = waluigi_update,
}

-----------
-- wario --
-----------

ACT_WARIO_DASH         = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)
ACT_WARIO_AIR_DASH     = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)
ACT_PILEDRIVER         = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WARIO_HOLD_JUMP    = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_CORKSCREW_CONK     = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WARIO_SPINNING_OBJ = allocate_mario_action(ACT_GROUP_OBJECT | ACT_FLAG_STATIONARY)

function act_corkscrew_conk(m)
    local e = gStateExtras[m.playerIndex]

    -- visuals
    m.particleFlags = m.particleFlags | PARTICLE_DUST

    -- physics
    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_FORWARD_SPINNING, AIR_STEP_NONE)

    -- animation
    set_anim_to_frame(m, e.animFrame)
    if e.animFrame >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd then
        e.animFrame = e.animFrame - m.marioObj.header.gfx.animInfo.curAnim.loopEnd
    end

    -- fast ground pound out of it
    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        local rc = set_mario_action(m, ACT_GROUND_POUND, 0)
        m.actionTimer = 5
        return rc
    end

    -- timers
    m.actionTimer = m.actionTimer + 1
    e.animFrame = e.animFrame + 1

    return 0
end

function act_wario_dash(m)
    local e = gStateExtras[m.playerIndex]

    -- when hitting wall, knock Wario backwards and thrust him upwards
    if m.actionArg == 99 then
        m.actionTimer = m.actionTimer + 1
        if m.actionTimer > 2 then
            mario_set_forward_vel(m, -30)
            m.vel.y = 40
            return set_mario_action(m, ACT_FREEFALL, 0)
        end
        return 0
    end

    -- make sound
    if m.actionTimer == 0 then
        m.actionState = m.actionArg
        play_character_sound(m, CHAR_SOUND_YAHOO)
    end

    -- walk once dash is up
    if m.actionTimer > 15 then
        return set_mario_action(m, ACT_WALKING, 0)
    end

    -- slide and set animation
    common_slide_action(m, ACT_DIVE, ACT_MOVE_PUNCHING, MARIO_ANIM_FIRST_PUNCH)
    set_anim_to_frame(m, 25)

    -- set dash speed
    local speed = 60
    if m.actionTimer > 8 then
        speed = speed - (m.actionTimer - 8)
    end
    mario_set_forward_vel(m, speed)

    -- corkscrew conk
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        set_jumping_action(m, ACT_CORKSCREW_CONK, 0)
        play_character_sound(m, CHAR_SOUND_YAHOO)
    end

    -- slide kick
    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_SLIDE_KICK, 0)
    end
    
    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x400, 0x400)

    m.actionTimer = m.actionTimer + 1
    return 0
end

function act_wario_air_dash(m)
    local e = gStateExtras[m.playerIndex]

    -- when hitting wall, knock Wario backwards and thrust him upwards
    if m.actionArg == 99 then
        m.actionTimer = m.actionTimer + 1
        if m.actionTimer > 2 then
            m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
            mario_set_forward_vel(m, -30)
            m.vel.y = 40
            return set_mario_action(m, ACT_FREEFALL, 0)
        end
        return 0
    end

    -- fall once dash is up
    if m.actionTimer > 15 then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    -- slide and set animation
    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_FIRST_PUNCH, AIR_STEP_NONE)
    set_anim_to_frame(m, 25)

    -- set dash speed
    local speed = 60
    if m.actionTimer > 8 then
        speed = speed - (m.actionTimer - 8)
    end
    mario_set_forward_vel(m, speed)

    -- corkscrew conk
    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
        set_jumping_action(m, ACT_CORKSCREW_CONK, 0)
        play_character_sound(m, CHAR_SOUND_YAHOO)
    end

    -- slide kick
    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_SLIDE_KICK, 0)
    end
    
    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x400, 0x400)

    m.actionTimer = m.actionTimer + 1
    return 0
end

function act_wario_spinning_obj(m)
    local spin = 0

    -- throw object
    if m.playerIndex == 0 and (m.input & INPUT_B_PRESSED) ~= 0 then
        play_character_sound_if_no_flag(m, CHAR_SOUND_WAH2, MARIO_MARIO_SOUND_PLAYED)
        play_sound_if_no_flag(m, SOUND_ACTION_THROW, MARIO_ACTION_SOUND_PLAYED)
        return set_mario_action(m, ACT_RELEASING_BOWSER, 0)
    end

    -- set animation
    if m.playerIndex == 0 and m.angleVel.y == 0 then
        m.actionTimer = m.actionTimer + 1
        if m.actionTimer > 120 then
            return set_mario_action(m, ACT_RELEASING_BOWSER, 1)
        end

        set_mario_animation(m, MARIO_ANIM_HOLDING_BOWSER)
    else
        m.actionTimer = 0
        set_mario_animation(m, MARIO_ANIM_SWINGING_BOWSER)
    end

    -- spin
    if m.intendedMag > 20.0 then
        -- spin = acceleration
        spin = (m.intendedYaw - m.twirlYaw) / 0x20

        if spin < -0x80 then
            spin = -0x80
        end
        if spin > 0x80 then
            spin = 0x80
        end

        m.twirlYaw = m.intendedYaw
        m.angleVel.y = m.angleVel.y + spin

        if m.angleVel.y > 0x1000 then
            m.angleVel.y = 0x1000
        end
        if m.angleVel.y < -0x1000 then
            m.angleVel.y = -0x1000
        end
    elseif m.angleVel.y > -0x750 and m.angleVel.y < 0x750 then
        -- go back to walking
        return set_mario_action(m, ACT_HOLD_IDLE, 0)
    else
        -- slow down spin
        m.angleVel.y = approach_s32(m.angleVel.y, 0, 128, 128);
    end

    -- apply spin
    spin = m.faceAngle.y
    m.faceAngle.y = m.faceAngle.y + m.angleVel.y

    -- play sound on overflow
    if m.angleVel.y <= -0x100 and spin < m.faceAngle.y then
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end
    if m.angleVel.y >= 0x100 and spin > m.faceAngle.y then
        queue_rumble_data_mario(m, 4, 20)
        play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.header.gfx.cameraToObject)
    end

    stationary_ground_step(m)

    if m.angleVel.y >= 0 then
        m.marioObj.header.gfx.angle.x = -m.angleVel.y
    else
        m.marioObj.header.gfx.angle.x = m.angleVel.y
    end

    return false
end

function wario_update_spin_input(m)
    local e = gStateExtras[m.playerIndex]
    local rawAngle = atan2s(-m.controller.stickY, m.controller.stickX)
    e.spinInput = 0

    -- prevent issues due to the frame going out of the dead zone registering the last angle as 0
    if e.lastIntendedMag > 0.5 and m.intendedMag > 0.5 then
        local angleOverFrames = 0
        local thisFrameDelta = 0
        local i = 0

        local newDirection = e.spinDirection
        local signedOverflow = 0

        if rawAngle < e.stickLastAngle then
            if (e.stickLastAngle - rawAngle) > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = 1
            else
                newDirection = -1
            end
        elseif rawAngle > e.stickLastAngle then
            if (rawAngle - e.stickLastAngle) > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = -1
            else
                newDirection = 1
            end
        end

        if e.spinDirection ~= newDirection then
            for i = 0, (ANGLE_QUEUE_SIZE - 1) do
                e.angleDeltaQueue[i] = 0
            end
            e.spinDirection = newDirection
        else
            for i = (ANGLE_QUEUE_SIZE - 1), 1, -1 do
                e.angleDeltaQueue[i] = e.angleDeltaQueue[i-1]
                angleOverFrames = angleOverFrames + e.angleDeltaQueue[i]
            end
        end

        if e.spinDirection < 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor((1.0*e.stickLastAngle + 0x10000) - rawAngle)
            else
                thisFrameDelta = e.stickLastAngle - rawAngle
            end
        elseif e.spinDirection > 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor(1.0 * rawAngle + 0x10000 - e.stickLastAngle)
            else
                thisFrameDelta = rawAngle - e.stickLastAngle
            end
        end

        e.angleDeltaQueue[0] = thisFrameDelta
        angleOverFrames = angleOverFrames + thisFrameDelta

        if angleOverFrames >= 0xA000 then
            e.spinBufferTimer = SPIN_TIMER_SUCCESSFUL_INPUT
        end


        -- allow a buffer after a successful input so that you can switch directions
        if e.spinBufferTimer > 0 then
            e.spinInput = 1
            e.spinBufferTimer = e.spinBufferTimer - 1
        end
    else
        e.spinDirection = 0
        e.spinBufferTimer = 0
    end

    e.stickLastAngle = rawAngle
    e.lastIntendedMag = m.intendedMag
end

-- patch wario's hold jump for piledriver
function act_wario_hold_jump(m)
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 and (m.heldObj ~= nil and (m.heldObj.oInteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC) ~= nil) then
        return set_mario_action(m, ACT_AIR_THROW, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_PILEDRIVER, 0)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    common_air_action_step(m, ACT_HOLD_JUMP_LAND, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ,
                           AIR_STEP_CHECK_LEDGE_GRAB)
    return false
end

function act_piledriver(m)
    local e = gStateExtras[m.playerIndex]
    if m.actionTimer == 0 then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        play_character_sound(m, CHAR_SOUND_SO_LONGA_BOWSER)
    end
    set_mario_animation(m, MARIO_ANIM_HOLDING_BOWSER)
    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then
        if should_get_stuck_in_ground(m) ~= 0 then
            queue_rumble_data_mario(m, 5, 80)
            play_sound(SOUND_MARIO_OOOF2, m.marioObj.header.gfx.cameraToObject)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0)
        else
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            if check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
                m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
                -- set facing direction
                -- not part of original Extended Moveset
                local yawDiff = m.faceAngle.y - m.intendedYaw
                e.rotAngle = e.rotAngle + yawDiff
                m.faceAngle.y = m.intendedYaw
                return set_mario_action(m, ACT_RELEASING_BOWSER, 0)
            end
        end
    end
    m.vel.y = -32
    mario_set_forward_vel(m, 0)
    m.faceAngle.y = m.faceAngle.y + 0x3000
    m.actionTimer = m.actionTimer + 1
    return 0
end

function wario_before_phys_step(m)
    local hScale = 1.0

    -- slower on ground
    if m.action == ACT_WALKING then
        hScale = hScale * 0.9
    end

    -- make wario sink
    if (m.action & ACT_FLAG_SWIMMING) ~= 0 then
        if m.action ~= ACT_BACKWARD_WATER_KB and
           m.action ~= ACT_FORWARD_WATER_KB and
           m.action ~= ACT_WATER_PLUNGE then
            m.vel.y = m.vel.y - 3
        end
    end

    -- fixes the momentum bug
    if (m.action & ACT_HOLD_WATER_JUMP) then
        return
    end

    -- faster holding item
    if m.heldObj ~= nil then
        m.vel.y = m.vel.y - 1
        hScale = hScale * 1.3
        if (m.action & ACT_FLAG_AIR) ~= 0 then
            hScale = hScale * 1.3
        end
    end

    m.vel.x = m.vel.x * hScale
    m.vel.z = m.vel.z * hScale
end

function wario_on_set_action(m)
    local e = gStateExtras[m.playerIndex]

    -- air dash
    if m.action == ACT_MOVE_PUNCHING and m.prevAction == ACT_WARIO_DASH then
        local actionTimer = m.actionTimer
        set_mario_action(m, ACT_WARIO_AIR_DASH, 0)
        m.actionTimer = actionTimer
        m.vel.x = 0
        m.vel.y = 0
        m.vel.z = 0
        return
    end

    -- slow down when dash/conk ends
    if (m.prevAction == ACT_WARIO_DASH) or (m.prevAction == ACT_WARIO_AIR_DASH) or (m.prevAction == ACT_CORKSCREW_CONK) then
        if m.action == ACT_CORKSCREW_CONK then
            mario_set_forward_vel(m, 60)
            m.vel.x = 0
            -- nerf the conk when executed in the air
            if (m.prevAction == ACT_WARIO_DASH) then
                m.vel.y = 70.0
            elseif (m.prevAction == ACT_WARIO_AIR_DASH) then
                m.vel.y = 60.0
            end
            m.vel.z = 0
        elseif m.action == ACT_SLIDE_KICK then
            mario_set_forward_vel(m, 70)
            m.vel.x = 0
            m.vel.y = 30.0
            m.vel.z = 0
        elseif m.forwardVel > 20 then
            mario_set_forward_vel(m, 20)
        end
    end

    -- when hitting a wall which dashing, have one more single frame of dash
    if m.action == ACT_GROUND_BONK and m.prevAction == ACT_WARIO_DASH then
        set_mario_action(m, ACT_WARIO_DASH, 99)
        mario_set_forward_vel(m, 1)
        m.vel.x = 0
        m.vel.y = 0
        m.vel.z = 0
    end

    -- when hitting a wall which dashing, have one more single frame of dash
    if m.action == ACT_AIR_HIT_WALL and m.prevAction == ACT_WARIO_AIR_DASH then
        set_mario_action(m, ACT_WARIO_AIR_DASH, 99)
        mario_set_forward_vel(m, 1)
        m.vel.x = 0
        m.vel.y = 0
        m.vel.z = 0
    end

    -- more height on triple jump
    if m.action == ACT_TRIPLE_JUMP or m.action == ACT_SPECIAL_TRIPLE_JUMP then
        m.vel.y = m.vel.y * 1.15
    end
    
    -- patch wario's hold jump for piledriver
    if m.action == ACT_HOLD_JUMP then
        return set_mario_action(m, ACT_WARIO_HOLD_JUMP, 0)
    end

    -- less height on other jumps
    if m.action == ACT_JUMP or
       m.action == ACT_DOUBLE_JUMP or
       m.action == ACT_STEEP_JUMP or
       m.action == ACT_RIDING_SHELL_JUMP or
       m.action == ACT_BACKFLIP or
       m.action == ACT_LONG_JUMP or
       m.action == ACT_SIDE_FLIP then

        m.vel.y = m.vel.y * 0.9

        -- prevent from getting stuck on platform
        if m.marioObj.platform ~= nil then
            m.pos.y = m.pos.y + 10
        end
    end
    e.lastAction = action
end

function wario_update(m)
    local hScale = 1.0
    local e = gStateExtras[m.playerIndex]

    wario_update_spin_input(m)

    -- spin around objects
    if m.action == ACT_HOLD_IDLE or m.action == ACT_HOLD_WALKING then
        if e.spinInput ~= 0 then
            m.twirlYaw = m.intendedYaw
            if e.spinDirection == 1 then
                m.angleVel.y = 1500
            else
                m.angleVel.y = -1500
            end
            m.intendedMag = 21
            return set_mario_action(m, ACT_WARIO_SPINNING_OBJ, 1)
        end
    end

    -- turn heavy objects into light
    if m.action == ACT_HOLD_HEAVY_IDLE then
        return set_mario_action(m, ACT_HOLD_IDLE, 0)
    end

    -- turn dive into dash
    if m.action == ACT_DIVE and m.prevAction == ACT_WALKING then
        if (m.controller.buttonPressed & B_BUTTON) ~= 0 then
            m.actionTimer = 0
            return set_mario_action(m, ACT_WARIO_DASH, 0)
        end
    end

    -- shake camera
    if m.action == ACT_GROUND_POUND_LAND then
        set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
        m.squishTimer = 5
    end

    -- faster ground pound
    if m.action == ACT_GROUND_POUND then
        m.vel.y = m.vel.y * 1.3
    end

    -- decrease player damage
    if m.hurtCounter > e.lastHurtCounter and m.action ~= ACT_LAVA_BOOST then
        m.hurtCounter = math.max(3, m.hurtCounter - 4)
    end
    e.lastHurtCounter = m.hurtCounter

    m.vel.x = m.vel.x * hScale
    m.vel.z = m.vel.z * hScale

    e.prevPos.x = m.pos.x
    e.prevPos.y = m.pos.y
    e.prevPos.z = m.pos.z
end

gEventTable[CT_WARIO] = {
    before_phys_step = wario_before_phys_step,
    on_set_action    = wario_on_set_action,
    update           = wario_update,
}

----------
-- main --
----------

function mario_before_phys_step(m)
    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].before_phys_step == nil then
        return
    end

    if gPlayerSyncTable[m.playerIndex].moveset ~= 1 then
        return
    end

    gEventTable[m.character.type].before_phys_step(m)
end

function mario_on_set_action(m)
    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].on_set_action == nil then
        return
    end

    if gPlayerSyncTable[m.playerIndex].moveset ~= 1 then
        return
    end

    gEventTable[m.character.type].on_set_action(m)
end

function mario_update(m)
    if m.action == ACT_BUBBLED then
        return
    end

    if gEventTable[m.character.type] == nil then
        return
    end

    if gEventTable[m.character.type].update == nil then
        return
    end

    if gPlayerSyncTable[m.playerIndex].moveset ~= 1 then
        return
    end
    
    gEventTable[m.character.type].update(m)
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

-----------
-- hooks --
-----------

local m = gMarioStates
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, mario_on_set_action)
hook_event(HOOK_BEFORE_PHYS_STEP, mario_before_phys_step)

hook_mario_action(ACT_WALL_SLIDE,         { every_frame = act_wall_slide })
hook_mario_action(ACT_SPIN_POUND,         { every_frame = act_spin_pound },      INT_GROUND_POUND_OR_TWIRL)
hook_mario_action(ACT_SPIN_POUND_LAND,    { every_frame = act_spin_pound_land }, INT_GROUND_POUND_OR_TWIRL)
hook_mario_action(ACT_WARIO_DASH,         { every_frame = act_wario_dash },      INT_KICK)
hook_mario_action(ACT_WARIO_AIR_DASH,     { every_frame = act_wario_air_dash },  INT_KICK)
hook_mario_action(ACT_CORKSCREW_CONK,     { every_frame = act_corkscrew_conk },  INT_FAST_ATTACK_OR_SHELL)
hook_mario_action(ACT_WARIO_SPINNING_OBJ, { every_frame = act_wario_spinning_obj })
hook_mario_action(ACT_PILEDRIVER,         { every_frame = act_piledriver})
hook_mario_action(ACT_WARIO_HOLD_JUMP,    { every_frame = act_wario_hold_jump})

--Extended Moveset (2)
------------------------
-- initialize actions --
------------------------

ACT_SPIN_POUND_LAND =           allocate_mario_action(ACT_GROUP_STATIONARY | ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING)
ACT_ROLL =                      allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_BUTT_OR_STOMACH_SLIDE)
ACT_GROUND_POUND_JUMP =         allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_SPIN_JUMP =                 allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_SPIN_POUND =                allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ATTACKING)
ACT_LEDGE_PARKOUR =             allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR)
ACT_ROLL_AIR =                  allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WALL_SLIDE =                allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WATER_GROUND_POUND =        allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_ATTACKING)
ACT_WATER_GROUND_POUND_LAND =   allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_STATIONARY | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT)
ACT_WATER_GROUND_POUND_STROKE = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT)
ACT_WATER_GROUND_POUND_JUMP =   allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT)

-----------------------------
-- initialize extra fields --
-----------------------------

ANGLE_QUEUE_SIZE = 9
SPIN_TIMER_SUCCESSFUL_INPUT = 4

gMarioStateExtras = {}
for i=0,(MAX_PLAYERS-1) do
    gMarioStateExtras[i] = {}
    local m = gMarioStates[i]
    local e = gMarioStateExtras[i]
    e.angleDeltaQueue = {}
    for j=0,(ANGLE_QUEUE_SIZE-1) do e.angleDeltaQueue[j] = 0 end
    e.rotAngle = 0
    e.boostTimer = 0

    e.stickLastAngle = 0
    e.spinDirection = 0
    e.spinBufferTimer = 0
    e.spinInput = 0
    e.lastIntendedMag = 0

    e.lastPos = {}
    e.lastPos.x = m.pos.x
    e.lastPos.y = m.pos.y
    e.lastPos.z = m.pos.z

    e.fakeSavedAction = 0
    e.fakeSavedPrevAction = 0
    e.fakeSavedActionTimer = 0
    e.fakeWroteAction = 0
    e.fakeSaved = false

    e.savedWallSlideHeight = 0
    e.savedWallSlide = false
end

function limit_angle(a)
    return (a + 0x8000) % 0x10000 - 0x8000
end

----------
-- roll --
----------

function update_roll_sliding_angle(m, accel, lossFactor)
    local floor = m.floor
    local slopeAngle = atan2s(floor.normal.z, floor.normal.x)
    local steepness = math.sqrt(floor.normal.x * floor.normal.x + floor.normal.z * floor.normal.z)

    m.slideVelX = m.slideVelX + accel * steepness * sins(slopeAngle)
    m.slideVelZ = m.slideVelZ + accel * steepness * coss(slopeAngle)

    m.slideVelX = m.slideVelX * lossFactor
    m.slideVelZ = m.slideVelZ * lossFactor

    m.slideYaw = atan2s(m.slideVelZ, m.slideVelX)

    local facingDYaw = limit_angle(m.faceAngle.y - m.slideYaw)
    local newFacingDYaw = facingDYaw

    if newFacingDYaw > 0 and newFacingDYaw <= 0x8000 then
        newFacingDYaw = newFacingDYaw - 0x800
        if newFacingDYaw < 0 then newFacingDYaw = 0 end

    elseif newFacingDYaw >= -0x8000 and newFacingDYaw < 0 then
        newFacingDYaw = newFacingDYaw + 0x800
        if newFacingDYaw > 0 then newFacingDYaw = 0 end
    end

    m.faceAngle.y = limit_angle(m.slideYaw + newFacingDYaw)

    m.vel.x = m.slideVelX
    m.vel.y = 0.0
    m.vel.z = m.slideVelZ

    mario_update_moving_sand(m)
    mario_update_windy_ground(m)

    --! Speed is capped a frame late (butt slide HSG)
    m.forwardVel = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)
    if m.forwardVel > 100.0 then
        m.slideVelX = m.slideVelX * 100.0 / m.forwardVel
        m.slideVelZ = m.slideVelZ * 100.0 / m.forwardVel
    end
end

function update_roll_sliding(m, stopSpeed)
    local stopped = 0

    local intendedDYaw = m.intendedYaw - m.slideYaw
    local forward = coss(intendedDYaw)
    local sideward = sins(intendedDYaw)

    --! 10k glitch
    if forward < 0.0 and m.forwardVel >= 0.0 then
        forward = forward * (0.5 + 0.5 * m.forwardVel / 100.0)
    end

    local accel = 4.0
    local lossFactor = 0.994

    local oldSpeed = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)

    --! This is uses trig derivatives to rotate Mario's speed.
    -- In vanilla, it was slightly off/asymmetric since it uses the new X speed, but the old
    -- Z speed. I've gone and fixed it here.
    local angleChange  = (m.intendedMag / 32.0) * 0.6
    local modSlideVelX = m.slideVelZ * angleChange * sideward * 0.05
    local modSlideVelZ = m.slideVelX * angleChange * sideward * 0.05

    m.slideVelX = m.slideVelX + modSlideVelX
    m.slideVelZ = m.slideVelZ - modSlideVelZ

    local newSpeed = math.sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ)

    if oldSpeed > 0.0 and newSpeed > 0.0 then
        m.slideVelX = m.slideVelX * oldSpeed / newSpeed
        m.slideVelZ = m.slideVelZ * oldSpeed / newSpeed
    end

    update_roll_sliding_angle(m, accel, lossFactor)

    if m.playerIndex == 0 and mario_floor_is_slope(m) == 0 and m.forwardVel * m.forwardVel < stopSpeed * stopSpeed then
        mario_set_forward_vel(m, 0.0)
        stopped = 1
    end

    return stopped
end

function act_roll(m)
    local e = gMarioStateExtras[m.playerIndex]

    local MAX_NORMAL_ROLL_SPEED = 50.0
    local ROLL_BOOST_GAIN = 10.0
    local ROLL_CANCEL_LOCKOUT_TIME = 10
    local BOOST_LOCKOUT_TIME = 20

    -- e.rotAngle is used for Mario's rotation angle during the roll (persists when going into ACT_ROLL_AIR and back)
    -- e.boostTimer is used for the boost lockout timer (persists when going into ACT_ROLL_AIR and back)
    -- m.actionTimer is used to lockout walk canceling out of rollout (reset each action switch)

    if m.actionTimer == 0 then
        if m.prevAction ~= ACT_ROLL_AIR then
            e.rotAngle = 0
            e.boostTimer = 0
        end
    elseif m.actionTimer >= ROLL_CANCEL_LOCKOUT_TIME or m.actionArg == 1 then
        if (m.input & INPUT_Z_DOWN) == 0 then
            return set_mario_action(m, ACT_WALKING, 0)
        end
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        queue_rumble_data_mario(m, 5, 80)
        return set_jumping_action(m, ACT_FORWARD_ROLLOUT, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_LONG_JUMP, 0)
    end

    if (m.controller.buttonPressed & X_BUTTON) ~= 0 and m.actionTimer > 0 then
        m.vel.y = 19.0
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

        if e.boostTimer >= BOOST_LOCKOUT_TIME then
            e.boostTimer = 0

            if m.forwardVel < MAX_NORMAL_ROLL_SPEED then
                mario_set_forward_vel(m, math.min(m.forwardVel + ROLL_BOOST_GAIN, MAX_NORMAL_ROLL_SPEED))
            end

            m.particleFlags = m.particleFlags | PARTICLE_HORIZONTAL_STAR

            -- ! playing this after the call to play_mario_sound seems to matter in making this sound play
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        return set_mario_action(m, ACT_ROLL_AIR, m.actionArg)
    end

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)

    if update_roll_sliding(m, 10.0) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    common_slide_action(m, ACT_CROUCH_SLIDE, ACT_ROLL_AIR, MARIO_ANIM_FORWARD_SPINNING)

    e.rotAngle = e.rotAngle + (0x80 * m.forwardVel)
    if e.rotAngle > 0x10000 then
        e.rotAngle = e.rotAngle - 0x10000
    end
    set_anim_to_frame(m, 10 * e.rotAngle / 0x10000)

    e.boostTimer = e.boostTimer + 1

    m.actionTimer = m.actionTimer + 1

    return 0
end

function act_roll_air(m)
    local e = gMarioStateExtras[m.playerIndex]
    local MAX_NORMAL_ROLL_SPEED = 50.0
    local ROLL_AIR_CANCEL_LOCKOUT_TIME = 15

    if m.actionTimer == 0 then
        if m.prevAction ~= ACT_ROLL then
            e.rotAngle = 0
            e.boostTimer   = 0
        end
    end

    if (m.input & INPUT_Z_DOWN) == 0 and m.actionTimer >= ROLL_AIR_CANCEL_LOCKOUT_TIME then
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)

    local air_step = perform_air_step(m, 0)
    if air_step == AIR_STEP_LANDED then
        if check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
            play_sound_and_spawn_particles(m, SOUND_ACTION_TERRAIN_STEP, 0)
            return set_mario_action(m, ACT_ROLL, m.actionArg)
        end
    elseif air_step == AIR_STEP_HIT_WALL then
        queue_rumble_data_mario(m, 5, 40)
        mario_bonk_reflection(m, false)
        m.faceAngle.y = m.faceAngle.y + 0x8000

        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    end

    e.rotAngle = e.rotAngle + 0x80 * m.forwardVel
    if e.rotAngle > 0x10000 then
        e.rotAngle = e.rotAngle - 0x10000
    end

    set_anim_to_frame(m, 10 * e.rotAngle / 0x10000)

    e.boostTimer = e.boostTimer + 1
    m.actionTimer = m.actionTimer + 1

    return false
end

function update_roll(m)
    if m.action == ACT_DIVE_SLIDE then
        if (m.input & INPUT_ABOVE_SLIDE) == 0 then
            if (m.input & INPUT_Z_DOWN) ~= 0 and m.actionTimer < 2 then
                return set_mario_action(m, ACT_ROLL, 1)
            end
        end
        m.actionTimer = m.actionTimer + 1
    end

    if m.action == ACT_LONG_JUMP_LAND then
        if (m.input & INPUT_Z_DOWN) ~= 0 and m.forwardVel > 15.0 and m.actionTimer < 1 then
            play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_LANDING)
            return set_mario_action(m, ACT_ROLL, 1)
        end
    end

    if m.action == ACT_CROUCHING then
        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then
            m.vel.y = 19.0
            mario_set_forward_vel(m, 32.0)
            play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_ROLL_AIR, 0)
        end
    end

    if m.action == ACT_CROUCH_SLIDE then
        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then
            m.vel.y = 19.0
            mario_set_forward_vel(m, math.max(32, m.forwardVel))
            play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_ROLL_AIR, 0)
        end
    end

    if m.action == ACT_GROUND_POUND_LAND then
        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then
            mario_set_forward_vel(m, 60)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)

            return set_mario_action(m, ACT_ROLL, 0)
        end
    end
end

----------
-- spin --
----------

function mario_update_spin_input(m)
    local e = gMarioStateExtras[m.playerIndex]
    local rawAngle = atan2s(-m.controller.stickY, m.controller.stickX)
    e.spinInput = 0

    -- prevent issues due to the frame going out of the dead zone registering the last angle as 0
    if e.lastIntendedMag > 0.5 and m.intendedMag > 0.5 then
        local angleOverFrames = 0
        local thisFrameDelta = 0
        local i = 0

        local newDirection = e.spinDirection
        local signedOverflow = 0

        if rawAngle < e.stickLastAngle then
            if e.stickLastAngle - rawAngle > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = 1
            else
                newDirection = -1
            end
        elseif rawAngle > e.stickLastAngle then
            if rawAngle - e.stickLastAngle > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = -1
            else
                newDirection = 1
            end
        end

        if e.spinDirection ~= newDirection then
            for i=0,(ANGLE_QUEUE_SIZE-1) do
                e.angleDeltaQueue[i] = 0
            end
            e.spinDirection = newDirection
        else
            for i=(ANGLE_QUEUE_SIZE-1),1,-1 do
                e.angleDeltaQueue[i] = e.angleDeltaQueue[i-1]
                angleOverFrames = angleOverFrames + e.angleDeltaQueue[i]
            end
        end

        if e.spinDirection < 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor((1.0*e.stickLastAngle + 0x10000) - rawAngle)
            else
                thisFrameDelta = e.stickLastAngle - rawAngle
            end
        elseif e.spinDirection > 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor(1.0*rawAngle + 0x10000 - e.stickLastAngle)
            else
                thisFrameDelta = rawAngle - e.stickLastAngle
            end
        end

        e.angleDeltaQueue[0] = thisFrameDelta
        angleOverFrames = angleOverFrames + thisFrameDelta

        if angleOverFrames >= 0xA000 then
            e.spinBufferTimer = SPIN_TIMER_SUCCESSFUL_INPUT
        end


        -- allow a buffer after a successful input so that you can switch directions
        if e.spinBufferTimer > 0 then
            e.spinInput = 1
            e.spinBufferTimer = e.spinBufferTimer - 1
        end
    else
        e.spinDirection = 0
        e.spinBufferTimer = 0
    end

    e.stickLastAngle = rawAngle
    e.lastIntendedMag = m.intendedMag
end

function act_spin_jump(m)
    local e = gMarioStateExtras[m.playerIndex]
    if m.actionTimer == 0 then
        -- determine clockwise/counter-clockwise spin
        if e.spinDirection < 0 then
            m.actionState = 1
        end
    elseif m.actionTimer == 1 or m.actionTimer == 4 then
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
    end

    local spinDirFactor = 1  -- negative for clockwise, positive for counter-clockwise
    if m.actionState == 1 then
        spinDirFactor = -1
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_DIVE, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)

        m.vel.y = -50.0
        mario_set_forward_vel(m, 0.0)

        -- choose which direction to be facing on land (practically random if no input)
        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            m.faceAngle.y = m.intendedYaw
        else
            m.faceAngle.y = limit_angle(e.rotAngle)
        end

        return set_mario_action(m, ACT_SPIN_POUND, m.actionState)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, CHAR_SOUND_YAHOO)

    common_air_action_step(m, ACT_DOUBLE_JUMP_LAND, MARIO_ANIM_TWIRL,
                           AIR_STEP_CHECK_HANG)

    e.rotAngle = e.rotAngle + 0x2867
    if (e.rotAngle >  0x10000) then e.rotAngle = e.rotAngle - 0x10000 end
    if (e.rotAngle < -0x10000) then e.rotAngle = e.rotAngle + 0x10000 end
    m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y + (e.rotAngle * spinDirFactor))

    m.actionTimer = m.actionTimer + 1

    return false
end

function act_spin_jump_gravity(m)
    if (m.flags & MARIO_WING_CAP) ~= 0 and m.vel.y < 0.0 and (m.input & INPUT_A_DOWN) ~= 0 then
        m.marioBodyState.wingFlutter = 1
        m.vel.y = m.vel.y - 0.7
        if m.vel.y < -37.5 then
            m.vel.y = m.vel.y + 1.4
            if m.vel.y > -37.5 then
                m.vel.y = -37.5
            end
        end
    else
        if m.vel.y > 0 then
            m.vel.y = m.vel.y - 4
        else
            m.vel.y = m.vel.y - 1.4
        end

        if m.vel.y < -75.0 then
            m.vel.y = -75.0
        end
    end

    return 0
end

function act_spin_pound(m)
    local e = gMarioStateExtras[m.playerIndex]
    if m.actionTimer == 0 then
        m.actionState = m.actionArg
    end

    local spinDirFactor = 1  -- negative for clockwise, positive for counter-clockwise
    if m.actionState == 1 then spinDirFactor = -1 end

    set_mario_animation(m, MARIO_ANIM_TWIRL)

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        mario_set_forward_vel(m, 10.0)
        m.vel.y = 35
        set_mario_action(m, ACT_DIVE, 0)
    end

    local stepResult = perform_air_step(m, 0)
    if stepResult == AIR_STEP_LANDED then
        if should_get_stuck_in_ground(m) ~= 0 then
            queue_rumble_data_mario(m, 5, 80)
            play_sound(CHAR_SOUND_OOOF2, m.marioObj.header.gfx.cameraToObject)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0)
        else
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            if check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB) == 0 then
                m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
                set_mario_action(m, ACT_SPIN_POUND_LAND, 0)
            end
        end
        set_camera_shake_from_hit(SHAKE_GROUND_POUND)
    elseif stepResult == AIR_STEP_HIT_WALL then
        mario_set_forward_vel(m, -16.0)
        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    end

    -- set facing direction
    -- not part of original Extended Moveset
    local yawDiff = m.faceAngle.y - m.intendedYaw
    e.rotAngle = limit_angle(e.rotAngle + yawDiff)
    m.faceAngle.y = m.intendedYaw

    e.rotAngle = e.rotAngle + 0x3053
    if e.rotAngle >  0x10000 then e.rotAngle = e.rotAngle - 0x10000 end
    if e.rotAngle < -0x10000 then e.rotAngle = e.rotAngle + 0x10000 end
    m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y + e.rotAngle * spinDirFactor)

    m.actionTimer = m.actionTimer + 1

    return 0
end

function act_spin_pound_land(m)
    m.actionState = 1

    if m.actionTimer <= 8 then
        if (m.input & INPUT_UNKNOWN_10) ~= 0 then
            return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
        end

        if (m.input & INPUT_OFF_FLOOR) ~= 0 then
            return set_mario_action(m, ACT_FREEFALL, 0)
        end

        if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
            return set_mario_action(m, ACT_BUTT_SLIDE, 0)
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            return set_jumping_action(m, ACT_GROUND_POUND_JUMP, 0)
        end

        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then
            mario_set_forward_vel(m, 60)

            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
            return set_mario_action(m, ACT_ROLL, 0)
        end

        stationary_ground_step(m)
        set_mario_animation(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP)
    else
        if (m.input & INPUT_UNKNOWN_10) ~= 0 then
            return set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0)
        end

        if (m.input & (INPUT_NONZERO_ANALOG | INPUT_A_PRESSED | INPUT_OFF_FLOOR | INPUT_ABOVE_SLIDE)) ~= 0 then
            return check_common_action_exits(m)
        end

        stopping_step(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP, ACT_IDLE)
    end

    m.actionTimer = m.actionTimer + 1

    return 0
end

----------------
-- wall slide --
----------------

function act_wall_slide(m)
    local e = gMarioStateExtras[m.playerIndex]
    e.savedWallSlideHeight = m.pos.y
    e.savedWallSlide = true

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = 52.0
        -- m.faceAngle.y = limit_angle(m.faceAngle.y + 0x8000)
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
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

    return 0
end

function act_wall_slide_gravity(m)
    m.vel.y = m.vel.y - 2

    if m.vel.y < -15 then
        m.vel.y = -15
    end
end

function act_air_hit_wall(m)
    if m.heldObj ~= 0 then
        mario_drop_held_object(m)
    end

    m.actionTimer = m.actionTimer + 1
    if m.actionTimer <= 1 and (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = 52.0
        m.faceAngle.y = limit_angle(m.faceAngle.y + 0x8000)
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0)
    elseif m.forwardVel >= 38.0 then
        m.wallKickTimer = 5
        if m.vel.y > 0.0 then
            m.vel.y = 0.0
        end

        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0)
    else
        m.faceAngle.y = limit_angle(m.faceAngle.y + 0x8000)
        return set_mario_action(m, ACT_WALL_SLIDE, 0)
    end

    --! Missing return statement (in original C code). The returned value is the result of the call
    -- to set_mario_animation. In practice, this value is nonzero.
    -- This results in this action "cancelling" into itself. It is supposed to
    -- execute three times, each on a separate frame, but instead it executes
    -- three times on the same frame.
    -- This results in firsties only being possible for a single frame, instead
    -- of three.
    return set_mario_animation(m, MARIO_ANIM_START_WALLKICK)
end

------------------------
-- water ground pound --
------------------------

function act_water_ground_pound(m)
    local GROUND_POUND_STROKE_SPEED = 27
    local GROUND_POUND_TIMER = 30

    local stepResult = 0

    if m.actionTimer == 0 then
        -- coming into action from normal ground pound
        if m.actionArg == 1 then
            -- copied from water plunge code
            play_sound(SOUND_ACTION_UNKNOWN430, m.marioObj.header.gfx.cameraToObject)
            if m.peakHeight - m.pos.y > 1150.0 then
                play_sound(CHAR_SOUND_HAHA_2, m.marioObj.header.gfx.cameraToObject)
            end

            m.particleFlags = m.particleFlags | PARTICLE_WATER_SPLASH

            if (m.prevAction & ACT_FLAG_AIR) ~= 0 then
                queue_rumble_data_mario(m, 5, 80)
            end
        end

        m.actionState = m.actionArg
    elseif m.actionTimer == 1 then
        play_sound(SOUND_ACTION_SWIM, m.marioObj.header.gfx.cameraToObject)
    end

    if m.actionState == 0 then
        if m.actionTimer == 0 then
            m.vel.y = 0.0
            mario_set_forward_vel(m, 0.0)
        end

        m.faceAngle.x = 0
        m.faceAngle.z = 0

        set_mario_animation(m, MARIO_ANIM_START_GROUND_POUND)
        if m.actionTimer == 0 then
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
        end

        m.actionTimer = m.actionTimer + 1
        if (m.actionTimer >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd + 4) then
            -- play_sound(CHAR_SOUND_GROUND_POUND_WAH, m.marioObj.header.gfx.cameraToObject)
            play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
            m.vel.y = -45.0
            m.actionState = 1
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            mario_set_forward_vel(m, GROUND_POUND_STROKE_SPEED)
            m.vel.y = 0
            return set_mario_action(m, ACT_WATER_GROUND_POUND_STROKE, 0)
        end

        -- make current apply
        stepResult = perform_water_step(m)
    else

        set_mario_animation(m, MARIO_ANIM_GROUND_POUND)

        m.particleFlags = m.particleFlags | PARTICLE_PLUNGE_BUBBLE

        local nextPos = {}
        nextPos.x = m.pos.x + m.vel.x
        nextPos.y = m.pos.y + m.vel.y
        nextPos.z = m.pos.z + m.vel.z

        -- call this one to make current NOT apply
        stepResult = perform_water_full_step(m, nextPos)

        vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
        vec3s_set(m.marioObj.header.gfx.angle, -m.faceAngle.x, m.faceAngle.y, m.faceAngle.z)

        if stepResult == WATER_STEP_HIT_FLOOR then
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR
            set_mario_action(m, ACT_WATER_GROUND_POUND_LAND, 0)
            set_camera_shake_from_hit(SHAKE_GROUND_POUND)
        else
            if (m.input & INPUT_A_PRESSED) ~= 0 then
                mario_set_forward_vel(m, GROUND_POUND_STROKE_SPEED)
                m.vel.y = 0
                return set_mario_action(m, ACT_WATER_GROUND_POUND_STROKE, 0)
            end

            m.vel.y = approach_f32(m.vel.y, 0, 2.0, 2.0)

            mario_set_forward_vel(m, 0.0)

            if m.actionTimer >= GROUND_POUND_TIMER or m.vel.y >= 0.0 then
                set_mario_action(m, ACT_WATER_ACTION_END, 0)
            end
        end

        m.actionTimer = m.actionTimer + 1
    end

    return 0
end

function act_water_ground_pound_land(m)
    local GROUND_POUND_JUMP_VEL = 40.0

    m.actionState = 1

    if (m.input & INPUT_OFF_FLOOR) ~= 0 then
        return set_mario_action(m, ACT_WATER_IDLE, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        m.vel.y = GROUND_POUND_JUMP_VEL
        play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
        return set_mario_action(m, ACT_WATER_GROUND_POUND_JUMP, 0)
    end

    m.vel.y = 0.0
    m.pos.y = m.floorHeight
    mario_set_forward_vel(m, 0.0)

    vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
    vec3s_set(m.marioObj.header.gfx.angle, 0, m.faceAngle.y, 0)

    set_mario_animation(m, MARIO_ANIM_GROUND_POUND_LANDING)
    if is_anim_at_end(m) ~= 0 then
        return set_mario_action(m, ACT_SWIMMING_END, 0)
    end

    perform_water_step(m)

    return 0
end

function act_water_ground_pound_stroke(m)
    local GROUND_POUND_STROKE_TIMER = 20
    local GROUND_POUND_STROKE_DECAY = 0.3
    local stepResult = 0

    set_mario_animation(m, MARIO_ANIM_SWIM_PART1)

    if m.actionTimer == 0 then
        play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
    end

    stepResult = perform_water_step(m)
    if stepResult == WATER_STEP_HIT_WALL then
        return set_mario_action(m, ACT_BACKWARD_WATER_KB, 0)
    end

    if m.actionTimer >= GROUND_POUND_STROKE_TIMER then
        if (m.input & INPUT_A_DOWN) ~= 0 then
            return set_mario_action(m, ACT_FLUTTER_KICK, 0)
        else
            return set_mario_action(m, ACT_SWIMMING_END, 0)
        end
    end
    m.actionTimer = m.actionTimer + 1

    mario_set_forward_vel(m, approach_f32(m.forwardVel, 0.0, GROUND_POUND_STROKE_DECAY, GROUND_POUND_STROKE_DECAY))

    float_surface_gfx(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    return 0
end

function act_water_ground_pound_jump(m)
    local e = gMarioStateExtras[m.playerIndex]
    local GROUND_POUND_JUMP_TIMER = 20
    local GROUND_POUND_JUMP_DECAY = 1.4

    -- set_mario_animation(m, MARIO_ANIM_SWIM_PART1)
    set_mario_animation(m, MARIO_ANIM_SINGLE_JUMP)
    m.particleFlags = m.particleFlags | PARTICLE_PLUNGE_BUBBLE

    if m.actionTimer == 0 then
        e.rotAngle = 0
    end

    local step = {}
    vec3f_copy(step, m.vel)
    apply_water_current(m, step)

    local nextPos = {}
    nextPos.x = m.pos.x + step.x
    nextPos.y = m.pos.y + step.y
    nextPos.z = m.pos.z + step.z

    local stepResult = perform_water_full_step(m, nextPos)

    vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
    vec3s_set(m.marioObj.header.gfx.angle, -m.faceAngle.x, m.faceAngle.y, m.faceAngle.z)

    if m.pos.y > m.waterLevel - 80 then
        return set_mario_action(m, ACT_WATER_JUMP, 0)
    end

    if m.actionTimer >= GROUND_POUND_JUMP_TIMER then
        mario_set_forward_vel(m, m.vel.y) -- normal swim routines will use forwardVel to calculate y speed
        m.faceAngle.x = 0x3EFF
        if (m.input & INPUT_A_DOWN) ~= 0 then
            return set_mario_action(m, ACT_FLUTTER_KICK, 0)
        else
            return set_mario_action(m, ACT_SWIMMING_END, 0)
        end
    end
    m.actionTimer = m.actionTimer + 1

    mario_set_forward_vel(m, 0.0)

    m.vel.y = approach_f32(m.vel.y, 0.0, GROUND_POUND_JUMP_DECAY, GROUND_POUND_JUMP_DECAY)
    -- m.faceAngle.x = 0x3EFF

    float_surface_gfx(m)
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    e.rotAngle = e.rotAngle + (0x10000*1.0 - e.rotAngle) / 5.0
    m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y - e.rotAngle)

    return 0
end

function act_ground_pound_jump(m)
    local e = gMarioStateExtras[m.playerIndex]
    if check_kick_or_dive_in_air(m) ~= 0 then
        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + e.rotAngle
        return 1
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y + e.rotAngle
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    if e.spinInput ~= 0 then
        return set_mario_action(m, ACT_SPIN_JUMP, 1)
    end

    if m.actionTimer == 0 then
        e.rotAngle = 0
    elseif m.actionTimer == 1 then
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, CHAR_SOUND_YAHOO)

    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_SINGLE_JUMP,
                           AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)

    e.rotAngle = e.rotAngle + (0x10000*1.0 - e.rotAngle) / 5.0
    m.marioObj.header.gfx.angle.y = m.marioObj.header.gfx.angle.y - e.rotAngle

    m.actionTimer = m.actionTimer + 1

    return 0
end

-------------------------------------
-- dive slide patched for dive hop --
-------------------------------------

function act_dive_slide(m)
    if (m.input & INPUT_ABOVE_SLIDE) == 0 and (m.input & INPUT_A_PRESSED) ~= 0 then
        queue_rumble_data_mario(m, 5, 80)
        if m.forwardVel > 0 then
            return set_mario_action(m, ACT_FORWARD_ROLLOUT, 0)
        else
            return set_mario_action(m, ACT_BACKWARD_ROLLOUT, 0)
        end
    end

    if (m.input & INPUT_ABOVE_SLIDE) == 0 then
        if (m.input & INPUT_B_PRESSED) ~= 0 then
            -- dive hop
            m.vel.y = 21.0
            return set_mario_action(m, ACT_DIVE, 1)
        end
    end

    play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND)

    --! If the dive slide ends on the same frame that we pick up on object,
    -- Mario will not be in the dive slide action for the call to
    -- mario_check_object_grab, and so will end up in the regular picking action,
    -- rather than the picking up after dive action.

    if update_sliding(m, 8.0) ~= 0 and is_anim_at_end(m) ~= 0 then
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

    common_slide_action(m, ACT_STOMACH_SLIDE_STOP, ACT_FREEFALL, MARIO_ANIM_DIVE)
    return false
end

-------------------------------------------------------
-- Patched actions using update_walking_speed action --
-- for Tight Controls and modfied speed caps         --
-------------------------------------------------------

function update_walking_speed_extended(m)
    local maxTargetSpeed = 0
    local targetSpeed    = 0
    local firmSpeedCap   = 0
    local hardSpeedCap   = 105.0

    if m.prevAction == ACT_ROLL then
        firmSpeedCap = 60.0
    else
        firmSpeedCap = 48.0
    end

    if m.floor ~= 0 and m.floor.type == SURFACE_SLOW then
        maxTargetSpeed = 24.0
    else
        maxTargetSpeed = 32.0
    end

    if m.intendedMag < maxTargetSpeed then
        targetSpeed = m.intendedMag
    else
        targetSpeed = maxTargetSpeed
    end

    if m.quicksandDepth > 10.0 then
        targetSpeed = targetSpeed * (6.25 / m.quicksandDepth)
    end

    if m.forwardVel <= 8.0 then
        m.forwardVel = math.min(m.intendedMag, 8.0)  -- Same fix as Melee dashback (by Kaze)
    end

    -- instead of a hard walk speed cap, going over this new firm speed cap makes you slow down to it twice as fast
    local decayFactor = 0
    if m.forwardVel > firmSpeedCap then
        decayFactor = 2.0
    else
        decayFactor = 1.0
    end

    if m.forwardVel <= 0.0 then
        m.forwardVel = m.forwardVel + 1.1
    elseif m.forwardVel <= targetSpeed then
        m.forwardVel = m.forwardVel + (1.1 - m.forwardVel / 43.0)
    elseif m.floor ~= 0 and m.floor.normal.y >= 0.95 then
        m.forwardVel = m.forwardVel - decayFactor
    else
        -- reintroduce the old hardcap for the weird slopes where you kind of just maintain your speed
        if (m.forwardVel > firmSpeedCap) then
            m.forwardVel = firmSpeedCap;
        end
    end

    if m.forwardVel > hardSpeedCap then
        m.forwardVel = hardSpeedCap
    end

    if analog_stick_held_back(m) ~= 0 then
        m.faceAngle.y = m.intendedYaw;

        if m.forwardVel < 0 then
            mario_set_forward_vel(m, -m.forwardVel);
        end
    else
        m.faceAngle.y = m.intendedYaw - approach_s32(limit_angle(m.intendedYaw - m.faceAngle.y), 0, 0xC00, 0xC00);
    end

    apply_slope_accel(m)
end

function act_walking(m)
    local startPos = m.pos
    local startYaw = m.faceAngle.y

    mario_drop_held_object(m)

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return begin_braking_action(m)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jump_from_landing(m)
    end

    if check_ground_dive_or_punch(m) ~= 0  then
        return true
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return begin_braking_action(m)
    end

    if analog_stick_held_back(m) ~= 0 and m.forwardVel >= 12.0 then
        return set_mario_action(m, ACT_TURNING_AROUND, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    m.actionState = 0

    vec3f_copy(startPos, m.pos)
    update_walking_speed_extended(m)

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
        set_mario_animation(m, MARIO_ANIM_GENERAL_FALL)
    elseif stepResult == GROUND_STEP_NONE then
        anim_and_audio_for_walk(m)
        if (m.intendedMag - m.forwardVel > 16.0) then
            m.particleFlags = m.particleFlags | PARTICLE_DUST
        end
    elseif stepResult == GROUND_STEP_HIT_WALL then
        push_or_sidle_wall(m, startPos)
        m.actionTimer = 0
    end

    check_ledge_climb_down(m)
    tilt_body_walking(m, startYaw)
    return false
end

function act_hold_walking(m)
    if m.heldObj ~= nil and m.heldObj.behavior == bhvJumpingBox then
        return set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, 0)
    end

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) ~= 0 then
        return drop_and_set_mario_action(m, ACT_WALKING, 0)
    end

    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_THROWING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_HOLD_JUMP, 0)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_HOLD_DECELERATING, 0)
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0)
    end

    m.intendedMag = m.intendedMag * 0.4

    update_walking_speed_extended(m)

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_HOLD_FREEFALL, 0)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        if m.forwardVel > 16.0 then
            mario_set_forward_vel(m, 16.0)
        end
    end

    anim_and_audio_for_hold_walk(m)

    if 0.4 * m.intendedMag - m.forwardVel > 10.0 then
        m.particleFlags = m.particleFlags | PARTICLE_DUST
    end

    return false
end

function act_hold_heavy_walking(m)
    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_HEAVY_THROW, 0)
    end

    if should_begin_sliding(m) ~= 0 then
        return drop_and_set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_HOLD_HEAVY_IDLE, 0)
    end

    m.intendedMag = m.intendedMag * 0.1

    update_walking_speed_extended(m)

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        drop_and_set_mario_action(m, ACT_FREEFALL, 0)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        if (m.forwardVel > 10.0) then
            mario_set_forward_vel(m, 10.0)
        end
    end

    anim_and_audio_for_heavy_walk(m)
    return false
end

function act_finish_turning_around(m)
    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SIDE_FLIP, 0)
    end

    update_walking_speed_extended(m)
    set_mario_animation(m, MARIO_ANIM_TURNING_PART2)

    if perform_ground_step(m) == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    if is_anim_at_end(m) ~= 0 then
        set_mario_action(m, ACT_WALKING, 0)
    end

    m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y + 0x8000)
    return false
end

function act_crawling(m)
    if should_begin_sliding(m) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0)
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return set_mario_action(m, ACT_STOP_CRAWLING, 0)
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_JUMP, 0)
    end

    if check_ground_dive_or_punch(m) ~= 0 then
        return true
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_STOP_CRAWLING, 0)
    end

    if (m.input & INPUT_Z_DOWN) == 0 then
        return set_mario_action(m, ACT_STOP_CRAWLING, 0)
    end

    m.intendedMag = m.intendedMag * 0.1

    update_walking_speed_extended(m)

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        if m.forwardVel > 10.0 then
            mario_set_forward_vel(m, 10.0)
        end
        --! Possibly unintended missing break
        align_with_floor(m)
    elseif stepResult == GROUND_STEP_NONE then
        align_with_floor(m)
    end

    local val04 = (m.intendedMag * 2.0 * 0x10000)
    set_mario_anim_with_accel(m, MARIO_ANIM_CRAWLING, val04)
    play_step_sound(m, 26, 79)
    return false
end

---------------------------------------------------------

function mario_on_set_action(m)
    if gPlayerSyncTable[m.playerIndex].moveset ~= 2 then return end
    local e = gMarioStateExtras[m.playerIndex]

    if (m.action & ACT_FLAG_MOVING) ~= 0 then
        e.savedWallSlide = false
    end

    if e.spinInput ~= 0 and (m.input & INPUT_ABOVE_SLIDE) == 0 then
        if m.action == ACT_JUMP or
           m.action == ACT_DOUBLE_JUMP or
           m.action == ACT_TRIPLE_JUMP or
           m.action == ACT_SPECIAL_TRIPLE_JUMP or
           m.action == ACT_SIDE_FLIP or
           m.action == ACT_BACKFLIP then
            set_mario_action(m, ACT_SPIN_JUMP, 1)
            m.vel.y = 65.0
            m.faceAngle.y = m.intendedYaw
        end
    end

    if m.action == ACT_GROUND_POUND_JUMP then
        m.vel.y = 65.0
    elseif m.action == ACT_WATER_PLUNGE and m.prevAction == ACT_GROUND_POUND then
        return set_mario_action(m, ACT_WATER_GROUND_POUND, 1)
    elseif m.action == ACT_WALL_SLIDE then
        m.vel.y = 0.0
    elseif m.action == ACT_GROUND_POUND and m.prevAction == ACT_SIDE_FLIP then
        -- correct animation
        m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y - 0x8000)
    elseif m.action == ACT_LEDGE_GRAB then
        e.rotAngle = m.forwardVel
    end
end

function before_mario_update(m)
    if gPlayerSyncTable[m.playerIndex].moveset ~= 2 then return end
    local e = gMarioStateExtras[m.playerIndex]
    -- revert fake saved action
    if e.fakeSaved == true then
        if m.action == e.fakeWroteAction and m.prevAction == e.fakeSavedPrevAction and m.actionTimer == e.fakeSavedActionTimer then
            m.action = e.fakeSavedAction
        end
        e.fakeSaved = false
    end
end

function after_mario_update(m)
    local e = gMarioStateExtras[m.playerIndex]
    -- pretend *_POUND_LAND is ACT_GROUND_POUND_LAND so switches work correctly
    if m.action == ACT_SPIN_POUND_LAND or m.action == ACT_WATER_GROUND_POUND_LAND then
        e.fakeSavedAction = m.action
        e.fakeSavedPrevAction = m.prevAction
        e.fakeSavedActionTimer = m.actionTimer

        m.action = ACT_GROUND_POUND_LAND
        e.fakeWroteAction = m.action
        e.fakeSaved = true
    end
end

function mario_update(m)
    if gPlayerSyncTable[m.playerIndex].moveset ~= 2 then return end
    local e = gMarioStateExtras[m.playerIndex]

    mario_update_spin_input(m)
    update_roll(m)

    -- dive out of ACT_GROUND_POUND
    if m.action == ACT_GROUND_POUND and (m.input & INPUT_B_PRESSED) ~= 0 then
        mario_set_forward_vel(m, 10.0)
        m.vel.y = 35.0
        set_mario_action(m, ACT_DIVE, 0)
    end

    -- spin
    if (m.action == ACT_JUMP or
        m.action == ACT_WALL_KICK_AIR or
        m.action == ACT_DOUBLE_JUMP or
        m.action == ACT_BACKFLIP or
        m.action == ACT_SIDE_FLIP) and e.spinInput ~= 0 then
        set_mario_action(m, ACT_SPIN_JUMP, 1)
        e.spinInput = 0
    end

    -- twirl pound
    if m.action == ACT_TWIRLING and (m.input & INPUT_Z_PRESSED) ~= 0 then
        set_mario_action(m, ACT_SPIN_POUND, 0)
    end

    -- ground pound jump
    if m.action == ACT_GROUND_POUND_LAND and (m.input & INPUT_A_PRESSED) ~= 0 then
        set_mario_action(m, ACT_GROUND_POUND_JUMP, 0)
    end

    -- water ground pound
    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        if m.action == ACT_WATER_IDLE or m.action == ACT_WATER_ACTION_END or m.action == ACT_BREASTSTROKE or m.action == ACT_SWIMMING_END or m.action == ACT_FLUTTER_KICK then
            set_mario_action(m, ACT_WATER_GROUND_POUND, 0)
        end
    end

    -- maintain spinning from water ground pound jump anim
    if m.action == ACT_WATER_JUMP and m.prevAction == ACT_WATER_GROUND_POUND_JUMP then
        e.rotAngle = e.rotAngle + (0x10000*1.0 - e.rotAngle) / 5.0
        m.marioObj.header.gfx.angle.y = limit_angle(m.marioObj.header.gfx.angle.y - e.rotAngle)
    end

    -- edge parkour
    if m.action == ACT_LEDGE_GRAB and m.actionTimer < 4 and (m.input & INPUT_B_PRESSED) ~= 0 then
        local hasSpaceForMario = (m.ceilHeight - m.floorHeight >= 160.0)
        if hasSpaceForMario and (e.rotAngle >= 31.0 or m.forwardVel >= 31.0) then
            mario_set_forward_vel(m, e.rotAngle + 5.0)
            m.vel.y = 25.0
            queue_rumble_data_mario(m, 5, 80)
            set_mario_action(m, ACT_LEDGE_PARKOUR, 0)
        end
    end

    -- save last pos
    e.lastPos.x = m.pos.x
    e.lastPos.y = m.pos.y
    e.lastPos.z = m.pos.z

    after_mario_update(m)
end

-----------
-- hooks --
-----------

hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, mario_on_set_action)

hook_mario_action(ACT_ROLL,                      { every_frame = act_roll })
hook_mario_action(ACT_ROLL_AIR,                  { every_frame = act_roll_air })
hook_mario_action(ACT_SPIN_JUMP,                 { every_frame = act_spin_jump, gravity = act_spin_jump_gravity })
hook_mario_action(ACT_SPIN_POUND,                { every_frame = act_spin_pound })
hook_mario_action(ACT_SPIN_POUND_LAND,           { every_frame = act_spin_pound_land })
hook_mario_action(ACT_GROUND_POUND_JUMP,         { every_frame = act_ground_pound_jump })
hook_mario_action(ACT_WALL_SLIDE,                { every_frame = act_wall_slide, gravity = act_wall_slide_gravity })
hook_mario_action(ACT_WATER_GROUND_POUND,        { every_frame = act_water_ground_pound })
hook_mario_action(ACT_WATER_GROUND_POUND_LAND,   { every_frame = act_water_ground_pound_land })
hook_mario_action(ACT_WATER_GROUND_POUND_STROKE, { every_frame = act_water_ground_pound_stroke })
hook_mario_action(ACT_WATER_GROUND_POUND_JUMP,   { every_frame = act_water_ground_pound_jump })
hook_mario_action(ACT_DIVE_SLIDE,                { every_frame = act_dive_slide })
hook_mario_action(ACT_WALKING,                   { every_frame = act_walking })
hook_mario_action(ACT_HOLD_WALKING,              { every_frame = act_hold_walking })
hook_mario_action(ACT_HOLD_HEAVY_WALKING,        { every_frame = act_hold_heavy_walking })
hook_mario_action(ACT_FINISH_TURNING_AROUND,     { every_frame = act_finish_turning_around })
hook_mario_action(ACT_CRAWLING,                  { every_frame = act_crawling })
hook_mario_action(ACT_AIR_HIT_WALL,              { every_frame = act_air_hit_wall })


--QOL Moveset (3)

ACT_WATER_GROUND_POUND = (ACT_GROUP_SUBMERGED | ACT_FLAG_SWIMMING | ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_CUSTOM_ACTION)
ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)


function mario_update(m)
    if gPlayerSyncTable[m.playerIndex].moveset == 3 then

        if m.action == ACT_GROUND_POUND_LAND and m.controller.buttonPressed & A_BUTTON ~=0 then
            m.vel.y = 30
            set_mario_action(m, ACT_TRIPLE_JUMP, 0)
        end

        if m.action == ACT_TWIRLING and m.controller.buttonDown & Z_TRIG ~= 0 then
            m.vel.y = -50
        end

        if m.action == ACT_TWIRL_LAND and m.controller.buttonDown & Z_TRIG ~= 0 and m.actionTimer == 0 then
            set_mario_action(m, ACT_GROUND_POUND, 0)
            m.actionTimer = 5000
        end

        if m.action == ACT_TWIRL_LAND then
            m.actionTimer = m.actionTimer + 1
        end

        if m.action == ACT_GROUND_POUND and m.controller.buttonPressed & B_BUTTON ~=0 then
            m.vel.y = 36
            m.forwardVel = 25
            m.faceAngle.y = m.intendedYaw
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_DIVE, 0)
        end

        if m.action == ACT_WATER_JUMP and m.controller.buttonPressed & Z_TRIG ~=0 then
            set_mario_action(m, ACT_GROUND_POUND, 0)
        end

        if m.action == ACT_STEEP_JUMP and m.controller.buttonPressed & Z_TRIG ~=0 then
            set_mario_action(m, ACT_GROUND_POUND, 0)
        end

        if (m.action == ACT_FORWARD_ROLLOUT or m.action == ACT_BACKWARD_ROLLOUT or m.action == ACT_FALLING_EXIT_AIRBORNE) and m.controller.buttonPressed & Z_TRIG ~= 0 then
            set_mario_action(m, ACT_GROUND_POUND, 0)
        end

        if m.action & ACT_FLAG_SWIMMING ~= 0 and m.controller.buttonPressed & Z_TRIG ~= 0 and m.action ~= ACT_WATER_GROUND_POUND then
            set_mario_action(m, ACT_WATER_GROUND_POUND, 0)
        end
    end
end

---@param m MarioState
function before_mario_update(m)
    if gPlayerSyncTable[m.playerIndex].moveset == 3 then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_TRIPLE_JUMP and m.controller.buttonPressed & B_BUTTON ~= 0 then
            m.vel.y = 36
            m.forwardVel = 25
            m.faceAngle.y = m.intendedYaw
            m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
            set_mario_action(m, ACT_DIVE, 0)
        end
    end
end

---@param m MarioState
function act_water_ground_pound(m)
    if gPlayerSyncTable[m.playerIndex].moveset == 3 then

        m.actionTimer = m.actionTimer + 1

        local stepResult = perform_water_step(m)

        m.vel.x = 0
        m.vel.z = 0
        m.forwardVel = 0
        m.faceAngle.x = 0
        m.faceAngle.z = 0

        if m.actionState == 0 then
            if m.actionTimer < 10 then
                local yOffset = 20 - 2 * m.actionTimer
                if (m.pos.y + yOffset + 160.0 < m.ceilHeight) then
                    m.pos.y = m.pos.y + yOffset
                    m.peakHeight = m.pos.y
                    vec3f_copy(m.marioObj.header.gfx.pos, m.pos)
                end
            end

            set_mario_animation(m, MARIO_ANIM_START_GROUND_POUND)
            if (m.actionTimer == 0) then
                play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject);
            end

            m.actionTimer = m.actionTimer + 1
            if (m.actionTimer >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd + 4) then
                m.actionState = 1
                m.actionTimer = 0
            end
        elseif m.actionState == 1 then
            m.vel.y = -50

            set_mario_animation(m, MARIO_ANIM_GROUND_POUND)

            if m.actionTimer >= 0.25 * 30 then
                return set_mario_action(m, ACT_WATER_IDLE, 0)
            elseif stepResult == WATER_STEP_HIT_FLOOR then
                play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
                set_mario_particle_flags(m, (PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR), 0)
                m.actionState = 2
                m.actionTimer = 0
            end
        else
            m.vel.y = 0

            if m.actionTimer >= 0.25 * 30 then
                return set_mario_action(m, ACT_WATER_IDLE, 0)
            end
        end

        if m.controller.buttonPressed & B_BUTTON ~= 0 then
            m.forwardVel = 90
            m.faceAngle.y = m.intendedYaw
            m.input = m.input & ~INPUT_B_PRESSED
            return set_mario_action(m, ACT_BREASTSTROKE, 0)
        end

        return 0
    end
end

-- hooks

hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_mario_action(ACT_WATER_GROUND_POUND, act_water_ground_pound)