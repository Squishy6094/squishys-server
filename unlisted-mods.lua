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

--- @param m MarioState
function mario_update(m)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end
    p = gPlayerSyncTable[m.playerIndex]
    p.moveset = menuTable[1][1].status
    p.wallSlide = menuTable[1][5].status
    p.betterswim = menuTable[1][2].status
    --Wallslide

    --Remove Fall Damage
    m.peakHeight = m.pos.y

    --Ledge Parkour
    if menuTable[1][7].status == 1 then
        if (m.action == ACT_LEDGE_GRAB or m.action == ACT_LEDGE_CLIMB_FAST) then
            ledgeTimer = ledgeTimer + 1
        else
            ledgeTimer = 0
            velStore = m.forwardVel
        end

        if ledgeTimer <= 5 and velStore >= 15 then
            if m.action == ACT_LEDGE_CLIMB_FAST and (m.controller.buttonPressed & A_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SIDE_FLIP, 0)
                m.vel.y = math.min(velStore*0.5, 40)
                if ledgeTimer == 1 then -- Firstie gives back raw speed
                    m.forwardVel = velStore
                else
                    m.forwardVel = velStore * 0.85
                end
            end

            if m.action == ACT_LEDGE_GRAB and (m.controller.buttonPressed & B_BUTTON) ~= 0 then
                set_mario_action(m, ACT_SLIDE_KICK, 0)
                m.vel.y = math.min(velStore*0.2, 20)
                if ledgeTimer == 1 then -- Firstie gives back raw speed
                    m.forwardVel = velStore
                else
                    m.forwardVel = velStore * 0.9
                end
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
                m.marioObj.oMarioBurnTimer = m.marioObj.oMarioBurnTimer + 15
                m.particleFlags = m.particleFlags | PARTICLE_DUST
                play_sound(SOUND_GENERAL_FLAME_OUT, gMarioStates[0].marioObj.header.gfx.cameraToObject)
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
    if menuTable[1][6].status == 1 then
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
            theme_unlock("Upper", "Break the 50 Star Door with a BLJ")
        end
    end

    --Return Cap
    if m.cap ~= 0 and does_mario_have_normal_cap_on_head(m) == 1 then
        m.cap = 0
        print("Returned cap!")
    end
end

--- @param m MarioState
--- @param o Object
local function allow_interact(m, o)
    if BootupTimer < 150 then return end
    if _G.mhExists and not _G.mhApi.interactionIsValid(m, o, type) then return false end
    if get_id_from_behavior(o.behavior) == id_bhvBrokenDoor and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end

--Wallslide--

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if BootupTimer < 150 then return end
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

--This is mostly copied from the wall bonk check code
---@param m MarioState
function before_phys_step(m)
    if m.playerIndex ~= 0 then return end
    if BootupTimer < 150 then return end
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
    if BootupTimer < 150 then return end

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
    if BootupTimer < 150 then return end
    --Tech action
    if TECH_KB[m.action] then
        tech_tmr = 0
    end

    --Swim Star Anim--
    if (m.action == ACT_FALL_AFTER_STAR_GRAB) then
        m.action = ACT_STAR_DANCE_WATER
    end

    --Lava Groundpound--
    if menuTable[1][3].status == 1 then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_LAVA_BOOST then
            m.vel.y = m.vel.y * 1.1
            m.forwardVel = 70
            m.health = m.health - 272
        end
    end
    
    --Anti quicksand--
    if menuTable[1][4].status == 1 then
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
    if menuTable[1][6].status == 1 then
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

local sOverrideCameraModes = {
    [CAMERA_MODE_RADIAL]            = true,
    [CAMERA_MODE_OUTWARD_RADIAL]    = true,
    [CAMERA_MODE_CLOSE]             = true,
    [CAMERA_MODE_SLIDE_HOOT]        = true,
    [CAMERA_MODE_PARALLEL_TRACKING] = true,
    [CAMERA_MODE_FIXED]             = true,
    [CAMERA_MODE_8_DIRECTIONS]      = true,
    [CAMERA_MODE_FREE_ROAM]         = true,
    [CAMERA_MODE_SPIRAL_STAIRS]     = true,
}

local BaseGame = true
for i in pairs(gActiveMods) do
    if gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("rom-hack") then
        BaseGame = false
    end
end

--- @param m MarioState
function romhack_camera(m)
    if sOverrideCameraModes[m.area.camera.mode] == nil then return end

    if (m.controller.buttonPressed & L_TRIG) ~= 0 then center_rom_hack_camera() end

    set_camera_mode(m.area.camera, CAMERA_MODE_ROM_HACK, 0)
end

rom_hack_cam_set_collisions(false)

function update()
    if BootupTimer < 150 then return end
    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if menuTable[3][4].status == 0 and ((c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN)) then
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

    --Romhack Cam
    if menuTable[3][3].status == 1 and BaseGame then
        romhack_camera(m)
        camera_set_use_course_specific_settings(false)
    end

end

hook_event(HOOK_ON_WARP, function()
    inertiaVel.x = 0
    inertiaVel.y = 0
    inertiaVel.z = 0
end)

-- Cap Return Toad
-- DIALOG_099 is unused
local NEW_DIALOG = DIALOG_099
smlua_text_utils_dialog_replace(NEW_DIALOG,1,3,30,200, ("Hey, is this your cap?\
It seemed to appear from\
thin air.\
Here, take it-\
it looks better on you\
anyway."))

local caps = {
  [0] = E_MODEL_MARIOS_CAP,
  [1] = E_MODEL_LUIGIS_CAP,
  [2] = E_MODEL_TOADS_CAP,
  [3] = E_MODEL_WARIOS_CAP,
  [4] = E_MODEL_WALUIGIS_CAP,
}

function custom_toad_init(obj)
  local m = gMarioStates[0]
  if m.cap ~= 0 and obj.oToadMessageDialogId == 133 then -- lobby toad
    print("Found lobby toad!")
    obj.unused1 = obj.oToadMessageDialogId
    obj.oToadMessageDialogId = NEW_DIALOG
    local model = caps[m.character.type] or E_MODEL_MARIOS_CAP
    spawn_non_sync_object(
      id_bhvToadMessage,
      model,
      obj.oPosX, obj.oPosY+85, obj.oPosZ,
      function(cap)
        cap.parentObj = obj
      end)
  end
  return
end
function custom_toad_loop(obj)
  if obj.unused1 ~= 0 and obj.oDialogState == 3 then
    local m = gMarioStates[0]
    m.cap = 0
    mario_retrieve_cap(m)
    obj.oToadMessageDialogId = obj.unused1
    obj.unused1 = 0
    set_mario_action(m, ACT_PUTTING_ON_CAP, 0)
  elseif obj.parentObj ~= nil then
    local toad = obj.parentObj
    if toad ~= obj and toad.unused1 == 0 then
      obj.activeFlags = ACTIVE_FLAG_DEACTIVATED
    else
      obj.oMoveAngleYaw = toad.oMoveAngleYaw
    end
  end
  return
end
hook_behavior(id_bhvToadMessage, OBJ_LIST_GENACTOR, false, custom_toad_init, custom_toad_loop)

--Better Swimming
local ACT_SIS_WATER_IDLE = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_STATIONARY | ACT_FLAG_WATER_OR_TEXT |
ACT_FLAG_SWIMMING_OR_FLYING | ACT_FLAG_METAL_WATER)

local ACT_SIS_SWIMMING = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_SWIMMING_OR_FLYING |
ACT_FLAG_METAL_WATER)

local ACT_SIS_WATER_SKID = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_SWIMMING_OR_FLYING |
ACT_FLAG_METAL_WATER)

local ACT_SIS_WATER_GRAB = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_SWIMMING_OR_FLYING |
ACT_FLAG_METAL_WATER)

local ACT_SIS_WATER_THROW = allocate_mario_action(ACT_GROUP_SUBMERGED | ACT_FLAG_MOVING | ACT_FLAG_WATER_OR_TEXT | ACT_FLAG_SWIMMING_OR_FLYING |
ACT_FLAG_METAL_WATER | ACT_FLAG_THROWING)

local SHELL_DURATION = 30 * 30

local toIdleAction = {
    [ACT_WATER_IDLE] = true,
    [ACT_HOLD_WATER_IDLE] = true,
    [ACT_WATER_ACTION_END] = true,
    [ACT_HOLD_WATER_ACTION_END] = true,
    [ACT_METAL_WATER_FALL_LAND] = true,
    [ACT_METAL_WATER_JUMP_LAND] = true,
    [ACT_METAL_WATER_STANDING] = true,
    [ACT_HOLD_METAL_WATER_STANDING] = true,
    [ACT_HOLD_METAL_WATER_FALL_LAND] = true,
    [ACT_HOLD_METAL_WATER_JUMP_LAND] = true,
}

local toSwimAction = {
    [ACT_BREASTSTROKE] = true,
    [ACT_HOLD_BREASTSTROKE] = true,
    [ACT_FLUTTER_KICK] = true,
    [ACT_HOLD_FLUTTER_KICK] = true,
    [ACT_WATER_PUNCH] = true,
    [ACT_METAL_WATER_FALLING] = true,
    [ACT_METAL_WATER_JUMP] = true,
    [ACT_METAL_WATER_WALKING] = true,
}

local improvedSwimming = true
local shellTimer = 0

-- optimization
local set_mario_action, is_anim_at_end, mario_grab_used_object, set_mario_animation, set_mario_anim_with_accel, perform_ground_step,
perform_air_step, apply_water_current, set_mario_particle_flags, math_abs, set_swimming_at_surface_particles, approach_f32, play_sound,
play_mario_sound, mario_get_collided_object =

set_mario_action, is_anim_at_end, mario_grab_used_object, set_mario_animation, set_mario_anim_with_accel, perform_ground_step,
perform_air_step, apply_water_current, set_mario_particle_flags, math.abs, set_swimming_at_surface_particles, approach_f32, play_sound,
play_mario_sound, mario_get_collided_object

local s16 = function(x)
    x = (math.floor(x) & 0xFFFF)
    if x >= 32768 then return x - 65536 end
    return x
end

local clamp = function(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

local set_anim_hold_or_normal = function(m, normalAnim, holdAnim, accel)
    if not accel then
        accel = 0x10000
    end
    if m.heldObj then
        return set_mario_anim_with_accel(m, holdAnim, accel)
    else
        return set_mario_anim_with_accel(m, normalAnim, accel)
    end
end

local set_act_hold_or_normal = function(m, normalAct, holdAct, actArg)
    if m.heldObj then
        return set_mario_action(m, holdAct, actArg)
    else
        return set_mario_action(m, normalAct, actArg)
    end
end

local get_v_dir = function(m)
    local vDir = 0
    local goalAngle = 0x4000

    if (m.input & INPUT_A_DOWN) ~= 0 and (m.pos.y < m.waterLevel - 80 and m.pos.y < m.ceilHeight - 160) then
        vDir = vDir + 1
    end

    if (m.input & INPUT_Z_DOWN) ~= 0 and m.pos.y > m.floorHeight then
        vDir = vDir - 1
    end

    vDir = vDir * (1 - m.intendedMag / 64)

    return goalAngle * vDir
end

local common_water_update = function(m)
    local step
    local snowyTerrain = (m.area.terrainType & TERRAIN_MASK) == TERRAIN_SNOW
    local metalSink = (m.flags & MARIO_METAL_CAP) ~= 0 and -12 or 0

    if m.pos.y <= m.floorHeight and m.vel.y <= 0 then
        step = perform_ground_step(m)
    else
        step = perform_air_step(m, 0)
    end

    m.vel.x = m.forwardVel * sins(m.faceAngle.y) * coss(m.faceAngle.x)
    m.vel.y = m.forwardVel * sins(m.faceAngle.x) + metalSink
    m.vel.z = m.forwardVel * coss(m.faceAngle.y) * coss(m.faceAngle.x)

    -- not letting you heal on the surface just because of the metal cap is pretty annoying
    if m.pos.y >= m.waterLevel - 140 and not snowyTerrain then
        m.health = m.health + 0x1A
    end

    if (m.flags & MARIO_METAL_CAP) == 0 then
        set_mario_particle_flags(m, PARTICLE_BUBBLE, 0)

        apply_water_current(m, m.vel)

        if m.pos.y < m.waterLevel - 140 then
            if snowyTerrain then
                m.health = m.health - 3
            else
                m.health = m.health - 1
            end
        end
    end

    return step
end

local headDir = 0

---@param m MarioState
local act_sis_water_idle = function(m)
    local vDir = get_v_dir(m)
    local buoyancy = 0
    local shellMul = obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 and 1.82 or 1

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.pos.y >= m.waterLevel - 100 then
        return set_act_hold_or_normal(m, ACT_WATER_JUMP, ACT_HOLD_WATER_JUMP, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_act_hold_or_normal(m, ACT_SIS_WATER_GRAB, ACT_SIS_WATER_THROW, 0)
    end

    if vDir ~= 0 or (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
        if math_abs(m.forwardVel) < 16 then
            m.faceAngle.y = m.intendedYaw
            m.forwardVel = 8
        end
        return set_mario_action(m, ACT_SIS_SWIMMING, 0)
    end

    if m.forwardVel > 12 then
        return set_mario_action(m, ACT_SIS_WATER_SKID, 0)
    end

    if not improvedSwimming then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    m.forwardVel = clamp(m.forwardVel, -48 * shellMul, 48 * shellMul)

    if (m.flags & MARIO_METAL_CAP) == 0 then
        if m.waterLevel - 80 - m.pos.y < 400 then
            buoyancy = 1.25
        else
            buoyancy = -2
        end
    end

    common_water_update(m)

    m.vel.y = m.vel.y + buoyancy

    m.faceAngle.x = approach_s32(m.faceAngle.x, 0, 0x450, 0x450)

    if m.actionArg == 1 then
        set_anim_hold_or_normal(m, MARIO_ANIM_SWIM_PART1, MARIO_ANIM_SWIM_WITH_OBJ_PART1)
        if is_anim_past_end(m) ~= 0 then
            play_sound(SOUND_ACTION_SWIM, m.marioObj.header.gfx.cameraToObject)
            m.actionArg = 0
        end
    elseif m.actionState == 0 then
        set_anim_hold_or_normal(m, MARIO_ANIM_SWIM_PART2, MARIO_ANIM_SWIM_WITH_OBJ_PART2)
        if is_anim_past_end(m) ~= 0 then
            m.actionState = 1
        end
    elseif m.actionState == 1 then
        set_anim_hold_or_normal(m, MARIO_ANIM_WATER_ACTION_END, MARIO_ANIM_WATER_ACTION_END_WITH_OBJ)
        if is_anim_past_end(m) ~= 0 then
            m.actionState = 2
        end
    else
        set_anim_hold_or_normal(m, MARIO_ANIM_WATER_IDLE, MARIO_ANIM_WATER_IDLE_WITH_OBJ)
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN

    m.forwardVel = approach_f32(m.forwardVel, 0, 1 * shellMul, 1 * shellMul)

    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    m.faceAngle.z = approach_f32(m.faceAngle.z, 0, 0x180, 0x180)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x
    m.marioObj.header.gfx.angle.z = -m.faceAngle.z

    m.marioBodyState.headAngle.x = approach_f32(m.marioBodyState.headAngle.x, 0, 0x400, 0x400)
    --apparently i have to rely on this headDir variable because using approach_f32 on headAngle.y directly doesnt work properly
    -- god i love this fucking game
    if m.playerIndex == 0 then
        if m.actionState > 0 and m.actionArg == 0 then
            headDir = approach_f32(headDir, 0, 0x400, 0x400)
        end
        m.marioBodyState.headAngle.y = headDir
    end
    m.marioBodyState.headAngle.z = m.faceAngle.z

    return 0
end

---@param m MarioState
local update_swim_speed = function(m)
    local vDir = get_v_dir(m)
    local intendedDYaw = s16(m.intendedYaw - m.faceAngle.y)
    local shellMul = obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 and 1.82 or 1

    local speedGain = m.forwardVel < 28 * shellMul and 2.4 * shellMul or 0.8

    if m.actionTimer > 0 then
        m.forwardVel = m.forwardVel + speedGain * (1 - m.actionTimer / 10)
        set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)

        m.actionTimer = m.actionTimer - 1
    else
        if m.forwardVel >= 0.29 then
            m.forwardVel = m.forwardVel - 0.29
        end
    end

    m.forwardVel = clamp(m.forwardVel, -25 * shellMul, 25 * shellMul)

    common_water_update(m)

    m.faceAngle.y = m.intendedYaw - approach_s32(intendedDYaw, 0, 0x450, 0x450)
    m.faceAngle.x = approach_s32(m.faceAngle.x, vDir, 0x450, 0x450)
    m.faceAngle.z = approach_f32(m.faceAngle.z, clamp(intendedDYaw, -0xD00, 0xD00), 0x260, 0x260)

    m.marioBodyState.headAngle.x = approach_f32(m.marioBodyState.headAngle.x, clamp(m.faceAngle.x - vDir, -0x1800, 0x5C00), 0x6A0, 0x6A0)
    if m.playerIndex == 0 then
        headDir = approach_f32(headDir, clamp(intendedDYaw, -0x2400, 0x2400), 0x6A0, 0x6A0)
        m.marioBodyState.headAngle.y = headDir
    end
    m.marioBodyState.headAngle.z = m.faceAngle.z

    m.marioObj.header.gfx.angle.z = -m.faceAngle.z

    return step
end

---@param m MarioState
local act_sis_swimming = function(m)
    local vDir = get_v_dir(m)
    local intendedDYaw = s16(m.intendedYaw - m.faceAngle.y)
    local actArg = 0
    local marioAnim = m.marioObj.header.gfx.animInfo

    if m.actionState == 0 then
        actArg = 1
        set_anim_hold_or_normal(m, MARIO_ANIM_SWIM_PART1, MARIO_ANIM_SWIM_WITH_OBJ_PART1)
        if marioAnim.animFrame >= marioAnim.curAnim.loopEnd - 6 then
            m.actionTimer = 4
        end

        if is_anim_past_end(m) ~= 0 then
            m.actionState = 1
            if m.forwardVel < 28 then
                play_sound(SOUND_ACTION_SWIM, m.marioObj.header.gfx.cameraToObject)
            else
                play_sound(SOUND_ACTION_SWIM_FAST, m.marioObj.header.gfx.cameraToObject)
            end
        end
    else
        set_anim_hold_or_normal(m, MARIO_ANIM_SWIM_PART2, MARIO_ANIM_SWIM_WITH_OBJ_PART2)
        if is_anim_past_end(m) ~= 0 and math_abs(m.faceAngle.x - vDir) <= 0x1800 and math_abs(intendedDYaw) <= 0x1800 then
            m.actionState = 0
        end
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 and m.pos.y >= m.waterLevel - 100 then
        return set_act_hold_or_normal(m, ACT_WATER_JUMP, ACT_HOLD_WATER_JUMP, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_act_hold_or_normal(m, ACT_SIS_WATER_GRAB, ACT_SIS_WATER_THROW, 0)
    end

    if ((m.input & INPUT_NONZERO_ANALOG) == 0 or analog_stick_held_back(m) ~= 0) and vDir == 0 then
        if m.forwardVel > 12 then
            return set_mario_action(m, ACT_SIS_WATER_SKID, 0)
        else
            return set_mario_action(m, ACT_SIS_WATER_IDLE, actArg)
        end
    end

    if gPlayerSyncTable[m.playerIndex].betterswim == 0 then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    local step = update_swim_speed(m)

    if step == GROUND_STEP_HIT_WALL or step == AIR_STEP_HIT_WALL then
        m.forwardVel = 0
    end

    m.marioBodyState.handState = MARIO_HAND_OPEN
    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x

    return 0
end

---@param m MarioState
local act_sis_water_skid = function(m)
    local step
    local vDir = get_v_dir(m)
    local shellMul = obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 and 1.82 or 1

    if m.forwardVel <= 6 then
        return set_mario_action(m, ACT_SIS_WATER_IDLE, 0)
    end

    if ((m.input & INPUT_NONZERO_ANALOG) ~= 0 and analog_stick_held_back(m) == 0) or vDir ~= 0 then
        if math_abs(m.forwardVel) < 16 then
            m.faceAngle.y = m.intendedYaw
            m.forwardVel = 8
        end
        return set_mario_action(m, ACT_SIS_SWIMMING, 0)
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_act_hold_or_normal(m, ACT_SIS_WATER_GRAB, ACT_SIS_WATER_THROW, 0)
    end

    if not improvedSwimming then
        return set_mario_action(m, ACT_WATER_ACTION_END, 0)
    end

    m.forwardVel = clamp(approach_s32(m.forwardVel, 0, 2.4 * shellMul, 2.4 * shellMul), -48, 48)

    common_water_update(m)

    set_mario_animation(m, MARIO_ANIM_SKID_ON_GROUND)

    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)
    set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)

    play_sound(SOUND_ACTION_SWIM, m.marioObj.header.gfx.cameraToObject)

    m.faceAngle.z = approach_f32(m.faceAngle.z, 0, 0x240, 0x240)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x
    m.marioObj.header.gfx.angle.z = -m.faceAngle.z

    m.marioBodyState.headAngle.x = approach_f32(m.marioBodyState.headAngle.x, 0, 0x4A0, 0x4A0)
    if m.playerIndex == 0 then
        headDir = approach_f32(headDir, 0, 0x4A0, 0x4A0)
        m.marioBodyState.headAngle.y = headDir
    end
    m.marioBodyState.headAngle.z = m.faceAngle.z

    return 0
end

---@param m MarioState
local grab_obj_in_water = function(m)
    if m.playerIndex ~= 0 then return end

    if (m.marioObj.collidedObjInteractTypes & INTERACT_GRABBABLE) ~= 0 then
        local o = mario_get_collided_object(m, INTERACT_GRABBABLE)
        local dx = o.oPosX - m.pos.x
        local dz = o.oPosZ - m.pos.z
        local angleToObj = atan2s(dz, dx) - m.faceAngle.y

        if math_abs(angleToObj) <= 0x2AAA then
            m.usedObj = o
            mario_grab_used_object(m)
            if m.heldObj ~= nil then
                m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
                return true
            end
        end
    end

    return false
end

---@param m MarioState
local act_sis_water_grab = function(m)
    if m.actionState == 0 then
        set_mario_animation(m, MARIO_ANIM_WATER_GRAB_OBJ_PART1)

        if m.forwardVel < 56 then
            m.forwardVel = m.forwardVel + 2
        end

        grab_obj_in_water(m)

        if is_anim_at_end(m) ~= 0 then
            if m.heldObj ~= nil then
                m.actionState = 2
                if m.playerIndex == 0 and obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 then
                    shellTimer = SHELL_DURATION
                    play_shell_music()
                end
            else
                m.actionState = 1
            end
        end

    elseif m.actionState == 1 then
        set_mario_animation(m, MARIO_ANIM_WATER_GRAB_OBJ_PART2)

        if m.forwardVel > 30 then
            m.forwardVel = m.forwardVel - 1.6
        end

        grab_obj_in_water(m)

        if m.heldObj ~= nil then
            m.actionState = 2
            if m.playerIndex == 0 and obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 then
                shellTimer = SHELL_DURATION
                play_shell_music()
            end
        end

        if is_anim_at_end(m) ~= 0 then
            return set_mario_action(m, ACT_SIS_SWIMMING, 0)
        end

    elseif m.actionState == 2 then
        set_mario_animation(m, MARIO_ANIM_WATER_PICK_UP_OBJ)

        if m.forwardVel > 45 then
            m.forwardVel = m.forwardVel - 0.42
        end

        if is_anim_at_end(m) ~= 0 then
            return set_mario_action(m, ACT_SIS_SWIMMING, 0)
        end
    end

    common_water_update(m)

    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)
    set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)

    play_mario_sound(m, SOUND_ACTION_SWIM, CHAR_SOUND_YAH_WAH_HOO)

    m.faceAngle.z = approach_f32(m.faceAngle.z, 0, 0x240, 0x240)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x
    m.marioObj.header.gfx.angle.z = -m.faceAngle.z

    m.marioBodyState.headAngle.x = approach_f32(m.marioBodyState.headAngle.x, 0, 0x4A0, 0x4A0)
    if m.playerIndex == 0 then
        headDir = approach_f32(headDir, 0, 0x4A0, 0x4A0)
        m.marioBodyState.headAngle.y = headDir
    end
    m.marioBodyState.headAngle.z = m.faceAngle.z
end

---@param m MarioState
local act_sis_water_throw = function(m)
    set_mario_animation(m, MARIO_ANIM_WATER_THROW_OBJ)
    play_mario_sound(m, SOUND_ACTION_SWIM, CHAR_SOUND_YAH_WAH_HOO)

    if is_anim_at_end(m) ~= 0 then
        return set_mario_action(m, ACT_SIS_SWIMMING, 0)
    end

    m.actionTimer = m.actionTimer + 1

    if m.actionTimer == 5 then
        if m.playerIndex == 0 then
            stop_shell_music()
            shellTimer = 0
        end
        mario_throw_held_object(m)
        queue_rumble_data_mario(m, 3, 50)
    end

    if m.forwardVel >= 0.29 then
        m.forwardVel = m.forwardVel - 0.29
    end

    common_water_update(m)

    set_swimming_at_surface_particles(m, PARTICLE_WAVE_TRAIL)

    m.faceAngle.z = approach_f32(m.faceAngle.z, 0, 0x240, 0x240)

    m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x - m.faceAngle.x
    m.marioObj.header.gfx.angle.z = -m.faceAngle.z

    m.marioBodyState.headAngle.x = approach_f32(m.marioBodyState.headAngle.x, 0, 0x4A0, 0x4A0)
    if m.playerIndex == 0 then
        headDir = approach_f32(headDir, 0, 0x4A0, 0x4A0)
        m.marioBodyState.headAngle.y = headDir
    end
    m.marioBodyState.headAngle.z = m.faceAngle.z
end

hook_mario_action(ACT_SIS_WATER_IDLE, act_sis_water_idle)
hook_mario_action(ACT_SIS_SWIMMING, act_sis_swimming)
hook_mario_action(ACT_SIS_WATER_SKID, act_sis_water_skid)
hook_mario_action(ACT_SIS_WATER_GRAB, act_sis_water_grab, INT_PUNCH)
hook_mario_action(ACT_SIS_WATER_THROW, act_sis_water_throw)

hook_event(HOOK_MARIO_UPDATE, function(m)
    if gPlayerSyncTable[m.playerIndex].betterswim == 0 then return end

    if toIdleAction[m.action] then
        set_mario_action(m, ACT_SIS_WATER_IDLE, 0)
    elseif toSwimAction[m.action] then
        set_mario_action(m, ACT_SIS_SWIMMING, 0)
    end

    if obj_has_behavior_id(m.heldObj, id_bhvKoopaShellUnderwater) ~= 0 and m.playerIndex == 0 and m.action ~= ACT_SIS_WATER_GRAB then
        shellTimer = shellTimer - 1

        if shellTimer == 60 then
            --fadeout_shell_music() doesnt exist so i replicated what fadeout_cap_music() does but with the shell's sequence id
            fadeout_background_music(SEQ_EVENT_POWERUP | SEQ_VARIATION, 600)
        end

        if shellTimer <= 0 then
            stop_shell_music()
            spawn_mist_particles()
            m.heldObj.oInteractStatus = INT_STATUS_STOP_RIDING
            m.heldObj = nil
        end
    end
end)

hook_event(HOOK_ON_SET_MARIO_ACTION, function(m)
    if gPlayerSyncTable[m.playerIndex].betterswim == 0 then return end

    if m.action == ACT_WATER_PLUNGE then
        m.vel.y = m.vel.y * 0.75
        m.forwardVel = m.forwardVel * 2.2

        m.faceAngle.x = atan2s(m.forwardVel, m.vel.y)
        if m.forwardVel < 0 then
            m.faceAngle.y = m.faceAngle.y + 0x8000
        end
        m.forwardVel = math.abs(m.forwardVel) + math_abs(m.vel.y)
        m.actionTimer = 21
    end

    if m.action == ACT_WATER_JUMP or m.action == ACT_HOLD_WATER_JUMP then
        vec3f_set(m.marioBodyState.headAngle, 0, 0, 0)
    end
end)

--All Hooks
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_UPDATE, update)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_mario_action(ACT_WALL_SLIDE, act_wall_slide)
hook_event(HOOK_BEFORE_PHYS_STEP, before_phys_step)