---@diagnostic disable: param-type-mismatch, assign-type-mismatch, missing-parameter
--Mods are bundled here to prevent lag and clutter--
--Credits go to all their original mod creators--

gLevelValues.starHeal = true
gLevelValues.floatingStarDance = true
gLevelValues.mushroom1UpHeal = true
gLevelValues.previewBlueCoins = true
gLevelValues.respawnBlueCoinsSwitch = true
gLevelValues.visibleSecrets = true

--Inertia Stuff
local prevPos = {x = 0, y = 0, z = 0}
local inertiaVel = {x = 0, y = 0, z = 0}
local kbAirActions = {
    [ACT_BACKWARD_AIR_KB] = true,
    [ACT_HARD_BACKWARD_AIR_KB] = true,
    [ACT_FORWARD_AIR_KB] = true,
    [ACT_HARD_FORWARD_AIR_KB] = true,
}

local is_mario_grounded = function(m)
    return m.pos.y <= m.floorHeight + 100
end

--Tech Stuff
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

--Door Bust Stuff--

define_custom_obj_fields({
    oDoorDespawnedTimer = 'u32',
    oDoorBuster = 'u32'
})

local function approach_number(current, target, inc, dec)
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

--- @param m MarioState
local function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return true
    end
    if not np.connected then
        return false
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return false
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return false
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return false
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return is_player_active(m)
end

local function lateral_dist_between_object_and_point(obj, pointX, pointZ)
    if obj == nil then return 0 end
    local dx = obj.oPosX - pointX
    local dz = obj.oPosZ - pointZ

    return math.sqrt(dx * dx + dz * dz)
end

local function if_then_else(cond, if_true, if_false)
    if cond then return if_true end
    return if_false
end

local function s16(num)
    num = math.floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
end

--- @param o Object
local function bhv_broken_door_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oInteractType = INTERACT_DAMAGE
    o.oIntangibleTimer = 0
    o.oGraphYOffset = -5
    o.oDamageOrCoinValue = 2
    obj_scale(o, 0.85)

    o.hitboxRadius = 80
    o.hitboxHeight = 100
    o.oGravity = 3
    o.oFriction = 0.8
    o.oBuoyancy = 1

    o.oVelY = 50
end

--- @param o Object
local function bhv_broken_door_loop(o)
    if o.oForwardVel > 10 then
        object_step()
        if o.oForwardVel < 30 then
            o.oInteractType = 0
        end
    else
        cur_obj_update_floor()
        o.oFaceAnglePitch = approach_number(o.oFaceAnglePitch, -0x4000, 0x500, 0x500)
    end

    o.header.gfx.angle.y = o.header.gfx.angle.y + 0x8000

    obj_flicker_and_disappear(o, 300)
end

local id_bhvBrokenDoor = hook_behavior(nil, OBJ_LIST_GENACTOR, true, bhv_broken_door_init, bhv_broken_door_loop)

--- @param m MarioState
--- @param o Object
local function should_push_or_pull_door(m, o)
    local dx = o.oPosX - m.pos.x
    local dz = o.oPosZ - m.pos.z

    local dYaw = s16(o.oMoveAngleYaw - atan2s(dz, dx))

    return if_then_else(dYaw >= -0x4000 and dYaw <= 0x4000, 0x00000001, 0x00000002)
end

extraVel = 0
IdiotSound = audio_sample_load("Idiot.mp3")
--- @param m MarioState
function mario_update(m)
    if m.playerIndex ~= 0 then return end
    gPlayerSyncTable[m.playerIndex].moveset = menuTable[1][1].status
    gPlayerSyncTable[m.playerIndex].wallSlide = menuTable[1][4].status
    --Wallslide

    --Ledge Parkour
    if menuTable[1][6].status == 1 then
        if (m.action == ACT_LEDGE_GRAB or m.action == ACT_LEDGE_CLIMB_FAST) then
            ledgeTimer = ledgeTimer + 1
        else
            ledgeTimer = 0
            velStore = m.forwardVel
        end

        if ledgeTimer <= 5 and velStore >= 15 then
            if m.action == ACT_LEDGE_CLIMB_FAST and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SIDE_FLIP, 0)
                m.vel.y = 30 * velStore/50 + 10
                m.forwardVel = velStore * 0.9
            end

            if m.action == ACT_LEDGE_GRAB and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SLIDE_KICK, 0)
                m.vel.y = 10 * velStore/50
                m.forwardVel = velStore
            end
        else
            if m.action == ACT_LEDGE_CLIMB_FAST and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
                set_mario_action(m, ACT_FORWARD_ROLLOUT, 0)
                m.vel.y = 10
                m.forwardVel = 20
            end

            if m.action == ACT_LEDGE_GRAB and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                set_mario_action(m, ACT_JUMP_KICK, 0)
                m.vel.y = 20
                m.forwardVel = 10
            end

            if m.action == ACT_LEDGE_CLIMB_SLOW_1 or m.action == ACT_LEDGE_CLIMB_SLOW_2 then
                set_mario_action(m, ACT_LEDGE_CLIMB_FAST, 0)
            end
        end
    end

    --Disable PU's
    if (m.pos.x > 57344) or (m.pos.x < -57344) or (m.pos.z > 57344) or (m.pos.z < -57344) then
        warp_restart_level()
        audio_sample_play(IdiotSound, m.pos, 1)
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
    if menuTable[1][5].status == 1 then
        if m.playerIndex ~= 0 then return end
        m.marioObj.header.gfx.angle.y = m.area.camera.yaw + 32250
    end

    --Door Bust--

    if active_player(m) == 0 then return end

    local door = nil
    if m.playerIndex == 0 then
        door = obj_get_first(OBJ_LIST_SURFACE)
        while door ~= nil do
            if get_id_from_behavior(door.behavior) == id_bhvDoor or get_id_from_behavior(door.behavior) == id_bhvStarDoor or get_id_from_behavior(door.behavior) == id_bhvDoorWarp then
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
    local starDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvStarDoor)
    local warpDoor = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvDoorWarp)
    local targetDoor = door
    if warpDoor ~= nil or starDoor ~= nil then
        if dist_between_objects(m.marioObj, starDoor) < dist_between_objects(m.marioObj, door) then
            targetDoor = starDoor
        elseif dist_between_objects(m.marioObj, warpDoor) < dist_between_objects(m.marioObj, door) or door == nil then
            targetDoor = warpDoor
        else
            targetDoor = door
        end
    end

    if targetDoor ~= nil then
        local dist = 200
        if m.action == ACT_LONG_JUMP and m.forwardVel <= -70 then dist = 1000 end

        if (m.action == ACT_SLIDE_KICK or m.action == ACT_SLIDE_KICK_SLIDE or m.action == ACT_JUMP_KICK or (m.action == ACT_LONG_JUMP and m.forwardVel <= -80)) and dist_between_objects(m.marioObj, targetDoor) < dist then
            local model = E_MODEL_CASTLE_CASTLE_DOOR

            if get_id_from_behavior(targetDoor.behavior) ~= id_bhvStarDoor then
                if obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_1_STAR) ~= 0 then
                    model = E_MODEL_CASTLE_DOOR_1_STAR
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_DOOR_3_STARS) ~= 0 then
                    model = E_MODEL_CASTLE_DOOR_3_STARS
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
                elseif obj_has_model_extended(targetDoor, E_MODEL_CASTLE_KEY_DOOR) ~= 0 then
                    model = E_MODEL_CASTLE_KEY_DOOR
                end
            else
                model = E_MODEL_CASTLE_STAR_DOOR_8_STARS
            end

            if m.forwardVel >= 30 or (m.action == ACT_LONG_JUMP and m.forwardVel <= -70) then
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
                        o.oDoorBuster = gNetworkPlayers[m.playerIndex].globalIndex
                        o.oForwardVel = 80
                        set_mario_particle_flags(m, PARTICLE_TRIANGLE, 0)
                        play_sound(SOUND_ACTION_HIT_2, m.marioObj.header.gfx.cameraToObject)
                    end
                )
                if get_id_from_behavior(targetDoor.behavior) == id_bhvDoorWarp then
                    m.interactObj = targetDoor
                    m.usedObj = targetDoor
                    m.actionArg = should_push_or_pull_door(m, targetDoor)

                    level_trigger_warp(m, WARP_OP_WARP_DOOR)
                else
                    if targetDoor.oBehParams >> 24 == 50 and m.action == ACT_LONG_JUMP and m.forwardVel <= -80 then
                        set_mario_action(m, ACT_THROWN_BACKWARD, 0)
                        m.forwardVel = -300
                        m.faceAngle.y = -0x8000
                        m.vel.y = 20
                        m.pos.x = -200
                        m.pos.y = 2350
                        m.pos.z = 4900
                    elseif m.playerIndex == 0 then
                        set_camera_shake_from_hit(SHAKE_SMALL_DAMAGE)
                    end
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
        if m.actionTimer == 6 then
            djui_chat_message_create("\\#fbfb7d\\Lakitu:\\#ffffff\\ OH SH-")
            for i = 1, 2 do
                if mod_storage_load("UnlockedTheme-"..i) == nil then
                    mod_storage_save("UnlockedTheme-"..i, theme)
                    djui_popup_create("\\#dcffdc\\Squishy's Server Theme Unlocked:\n\\#dcdcdc\\".. theme, 3)
                end
            end
        end
    end
end

--- @param m MarioState
--- @param o Object
local function allow_interact(m, o)
    if get_id_from_behavior(o.behavior) == id_bhvBrokenDoor and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end

--Wallslide--

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if gPlayerSyncTable[m.playerIndex].wallSlide ~= 1 then return end

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
    if m.vel.y < -20 then
        m.vel.y = -20
    end
    if m.vel.y > 10 then
        m.vel.y = 10
    end

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
function before_phys_step(m)
    if m.playerIndex ~= 0 then return end
    if gPlayerSyncTable[m.playerIndex].wallSlide ~= 1 then return end
    if m.wall ~= nil then
        if (m.wall.type == SURFACE_BURNING) then return end

        local wallDYaw = (atan2s(m.wall.normal.z, m.wall.normal.x) - (m.faceAngle.y))
        --I don't really understand this however I do know the lower `limit` becomes, the more possible wallkick degrees.
        local limitNegative = (-((180 - 61) * (8192/45))) + 1
        local limitPositive = ((180 - 61) * (8192/45)) - 1
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

    --Inertia
    -- Adds the inertia to his velocity, then decreases it due to drag
    if not is_mario_grounded(m) and m.action ~= ACT_GROUND_POUND then
        if kbAirActions[m.action] then
            mario_set_forward_vel(m, m.forwardVel) -- Without this you just accelerate to infinity
        end

        m.vel.x = m.vel.x + inertiaVel.x
        m.vel.z = m.vel.z + inertiaVel.z

        inertiaVel.x = inertiaVel.x * 0.97
        inertiaVel.z = inertiaVel.z * 0.97
    end
end

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

local pressed_A = false
local TIMER_MAX = 2
local timer = TIMER_MAX

---@param m MarioState
function before_mario_update(m)
    --Early Wallkick Leniency--
    if m.playerIndex ~= 0 then return end

    if m.controller.buttonPressed & A_BUTTON ~= 0 then
        pressed_A = true
    end

    if pressed_A and gPlayerSyncTable[m.playerIndex].wallSlide == 1 then
        timer = timer - 1
        if m.controller.buttonPressed & A_BUTTON ~= 0 then
            timer = TIMER_MAX
        end
        if timer <= 0 then
            pressed_A = false
            timer = TIMER_MAX
        end
    end

    --Inertia

    -- Now that Mario has undergone through the displacement calculations, we can get how much he's been displaced by just calculating the
    -- difference between his current position and the one stored beforehand
    if is_mario_grounded(m) and m.action & ACT_FLAG_AIR == 0 then
        if m.marioObj.platform then
            inertiaVel.x = m.pos.x - prevPos.x
            -- Cant exactly get y displacement with the method for x and y, so I had to resort to this instead
            inertiaVel.y = (prevPos.y - find_floor_height(m.pos.x, m.pos.y + 100, m.pos.z)) * -1
            inertiaVel.z = m.pos.z - prevPos.z
        else
            inertiaVel.x = 0
            inertiaVel.y = 0
            inertiaVel.z = 0
        end
    end

    if m.action == ACT_BUBBLED then
        inertiaVel.x = 0
        inertiaVel.y = 0
        inertiaVel.z = 0
    end
end

--- @param m MarioState
function on_set_mario_action(m)
    --Tech action
    if TECH_KB[m.action] then
        tech_tmr = 0
    end
    if m.action ~= ACT_BURNING_GROUND then
        burn_press = 0
    end

    --Swim Star Anim--
    if (m.action == ACT_FALL_AFTER_STAR_GRAB) then
        m.action = ACT_STAR_DANCE_WATER
    end

    --Lava Groundpound--
    if menuTable[1][2].status == 1 then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_LAVA_BOOST then
            m.vel.y = m.vel.y * 1.1
            m.forwardVel = 70
            m.health = m.health - 272
        end
    end
    
    --Anti quicksand--
    if menuTable[1][3].status == 1 then
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

    --Wallslide--
    if m.action == ACT_SOFT_BONK and gPlayerSyncTable[m.playerIndex].wallSlide == 1 then
        m.faceAngle.y = m.faceAngle.y + 0x8000
        set_mario_action(m, ACT_WALL_SLIDE, 0)
    end

    --Early Wallkick Leniency--
    if m.playerIndex ~= 0 then return end
    if pressed_A and gPlayerSyncTable[m.playerIndex].wallSlide == 1 then
        if m.action == ACT_AIR_HIT_WALL then
            --mario_bonk_reflection(m, 0)
            m.faceAngle.y = m.faceAngle.y + 0x8000
            set_mario_action(m, ACT_WALL_KICK_AIR, 0)
            pressed_A = false
            timer = TIMER_MAX
        end
    end

    --Strafing--
    if menuTable[1][5].status == 1 then
        if not noStrafeActs[m.action] then
            m.faceAngle.y = m.area.camera.yaw + 32250
        end
    end

    --Sideflip anywhere
    if (m.input & INPUT_A_PRESSED) ~= 0 then -- checks if marmite is going to do a steep jump and if a button is pressed
        if m.prevAction == ACT_TURNING_AROUND or m.prevAction == ACT_FINISH_TURNING_AROUND then -- checks if maio was turning around
            set_mario_action(m, ACT_SIDE_FLIP, 0) -- if all conditions are met set martin's action to sideflip
        end
    end

    --Inertia
    if m.playerIndex ~= 0 then return end

    if inertiaVel.y < 0 then
        inertiaVel.y = 0
    end

    -- Apply vertical momentum to his jumps
    if is_mario_grounded(m) then
        -- We add the velocity to his position directly to prevent platforms from eating your jumps
        -- Comment or erase this line to remove that feature (which brings back BLJs off elevators)
        m.pos.y = m.pos.y + inertiaVel.y
        m.vel.y = m.vel.y + inertiaVel.y
        inertiaVel.y = 0
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

    if menuTable[3][3].status == 0 and ((c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN)) then
        disable_time_stop_including_mario()
        m.freeze = 0
        c.cutscene = 0
    end

    --Inertia
    local m = gMarioStates[0]
    if m.playerIndex ~= 0 then
        return
    end

    -- Store his position before platform displacement is calculated
    if is_mario_grounded(m) then
        prevPos.x = m.pos.x
        prevPos.y = m.pos.y
        prevPos.z = m.pos.z
    end
end

hook_event(HOOK_ON_WARP, function()
    inertiaVel.x = 0
    inertiaVel.y = 0
    inertiaVel.z = 0
end)

--All Hooks
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_mario_action(ACT_WALL_SLIDE, act_wall_slide)
hook_event(HOOK_BEFORE_PHYS_STEP, before_phys_step)