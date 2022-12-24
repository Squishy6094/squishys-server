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
    if (obj ~= nil) and gPlayerSyncTable[m.playerIndex].radarToggle == true then
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

    if (obj ~= nil) and gPlayerSyncTable[m.playerIndex].radarToggle == true then
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
    if gPlayerSyncTable[m.playerIndex].capTimerToggle == true then
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

--AFK Command--

local timer = 0
isAFK = false
isAFKWater = false
gGlobalSyncTable.CanAFK = true
local Idiot = audio_stream_load("Idiot.mp3")
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
gGlobalSyncTable.excludeLevels = true

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

--- @param m MarioState
function mario_update(m)
      -- AFK Command Behavior
      if m.playerIndex ~= 0 then return end
      
      if isAFK then
        m.freeze = true
        m.flags = m.flags | MARIO_VANISH_CAP
        set_mario_action(m, ACT_SLEEPING, 0)
        timer = 0
    end

    if isAFKWater then
        m.freeze = true
        m.faceAngle.y = m.intendedYaw
        m.flags = m.flags | MARIO_VANISH_CAP
        timer = 0
    end

          -- if AFK is disabled
          if timer >= 1 then
            set_mario_action(m, ACT_WAKING_UP, 0)
            m.flags = m.flags & ~MARIO_VANISH_CAP
            timer = 0
       end

       if (m.input & INPUT_IN_WATER) ~= 0 and isAFK == true then
            isAFK = false
            isAFKWater = true
       end

         -- Dying
    if m.action == ACT_BUBBLED then
        isAFK = false
        isAFKWater = false
    end

    if m.action == ACT_STANDING_DEATH then
        isAFK = false
        isAFKWater = false
    end

    if m.action == ACT_WATER_DEATH then
        isAFK = false
        isAFKWater = false
    end

    if m.action == ACT_DROWNING then
        isAFK = false
        isAFKWater = false
    end

    if m.action == ACT_QUICKSAND_DEATH then
        isAFK = false
        isAFKWater = false
    end

    if gGlobalSyncTable.CanAFK == false then
        isAFK = false
        isAFKWater = false
    end

    --PUDisable--

    if m.pos.x >= 0 then
        puX = math.floor((8192 + m.pos.x) / 65536)
    else
        puX = math.ceil((-8192 + m.pos.x) / 65536)
    end

    if m.pos.z >= 0 then
        puZ = math.floor((8192 + m.pos.z) / 65536)
    else
        puZ = math.ceil((-8192 + m.pos.z) / 65536)
    end

    if (puX ~= 0) or (puZ ~= 0) then
        warp_restart_level()
        audio_stream_play(Idiot, false, 1)
    end

    --Preview Blue Coins--

    if m.playerIndex ~= 0 then
        return
    end
    
    --Intializes as the blue coin switch
    local obj = find_object_with_behavior(get_behavior_from_id(id_bhvBlueCoinSwitch))
    if obj ~= nil then
        local dist = dist_between_object_and_point(obj, m.pos.x, m.pos.y, m.pos.z)
        if dist < 110 then
            --So this doesn't execute every frame Mario is on the blue coin switch
            if once == true then
                obj = obj_get_first(OBJ_LIST_LEVEL)
                while obj ~= nil do
                    if get_id_from_behavior(obj.behavior) == id_bhvHiddenBlueCoin then
                        --Having other players see and potentially collect fake coins is unideal
                        --Luckily enough, it only displays for local player
                        cur_obj_enable_rendering_and_become_tangible(obj)
                    end
                    obj = obj_get_next(obj)
                end
            end
            once = false
        else
            once = true
            --Yeah reusing code, without even putting it in a function
            obj = obj_get_first(OBJ_LIST_LEVEL)
            while obj ~= nil do
                if get_id_from_behavior(obj.behavior) == id_bhvHiddenBlueCoin then
                    cur_obj_disable_rendering_and_become_intangible(obj)
                end
                obj = obj_get_next(obj)
            end
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
                print("" ..burn_press.. "")
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

    --Door Bust--
    if gGlobalSyncTable.excludeLevels and (gNetworkPlayers[0].currLevelNum == LEVEL_BBH or gNetworkPlayers[0].currLevelNum == LEVEL_HMC) then return end

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
end

--- @param m MarioState
--- @param o Object
function allow_interact(m, o)
    if o.behavior == get_behavior_from_id(id_bhvBrokenDoor) and gNetworkPlayers[m.playerIndex].globalIndex == o.oDoorBuster then return false end
    return true
end


function on_exclude_levels_command(msg)
    if msg == "on" then
        gGlobalSyncTable.excludeLevels = true
        djui_chat_message_create("Exclude Levels status: \\00ff00\\ON")
    else
        gGlobalSyncTable.excludeLevels = false
        djui_chat_message_create("Exclude Levels status: \\ff0000\\OFF")
    end
    return true
end

-- AFK Command and mess
function AFK(msg)

    if msg == "on" and gGlobalSyncTable.CanAFK == true then
        isAFK = true
        play_sound(SOUND_GENERAL_COIN, gMarioStates[0].marioObj.header.gfx.cameraToObject)
    return true
    elseif msg == "off" and isAFK == true then
        isAFK = false
        play_sound(SOUND_GENERAL_COIN, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        timer = timer + 1
        return true
    elseif msg == "off" and isAFK == false and isAFKWater == true then
        isAFKWater = false
        play_sound(SOUND_GENERAL_COIN, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        timer = timer + 1
        return true
    elseif msg == "off" and isAFK == false then
        play_sound(SOUND_MENU_CAMERA_BUZZ, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        return true
    elseif gGlobalSyncTable.CanAFK == false then
        djui_chat_message_create("You cannot use this command right now")
        play_sound(SOUND_MENU_CAMERA_BUZZ, gMarioStates[0].marioObj.header.gfx.cameraToObject)
        return true
    end
end

function CANAFK(msg)
    if msg == "on" then
        gGlobalSyncTable.CanAFK = true
    return true
    elseif msg == "off" then
        gGlobalSyncTable.CanAFK = false
        return true
    end
end

--Wallslide--

ACT_WALL_SLIDE = (0x0BF | ACT_FLAG_AIR | ACT_FLAG_MOVING | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)

function act_wall_slide(m)
    if not gPlayerSyncTable[m.playerIndex].wallSlide and mod_storage_load("Wallslide") == true then return end

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

function on_set_mario_action(m)
    --Fixed Bubbleing
    if m.prevAction == ACT_BUBBLED then
        local underWater = (m.pos.y < m.waterLevel);
        set_mario_action(m, ternary(underWater, ACT_WATER_IDLE, ACT_FREEFALL), 0);
    end
    if m.action == ACT_BUBBLED and quicksand_death_surfaces[m.floor.type] and m.pos.y - m.floorHeight <= 100 then
        m.pos.y = m.pos.y + 200 --Unneeded?
    end

    if (m.action == ACT_FALL_AFTER_STAR_GRAB) then
        m.action = ACT_STAR_DANCE_WATER
    end
    --Lava Groundpound--

    if gPlayerSyncTable[m.playerIndex].LGP == true then
        if m.prevAction == ACT_GROUND_POUND_LAND and m.action == ACT_LAVA_BOOST then
            m.vel.y = m.vel.y * 1.1
            m.forwardVel = 70
            m.health = m.health - 272
        end
    end
    
    --Anti quicksand--

    if gPlayerSyncTable[m.playerIndex].AQS == true and gGlobalSyncTable.GlobalAQS == true then
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
end

function update()
    ---@type MarioState
    local m = gMarioStates[0]
    ---@type Camera
    local c = gMarioStates[0].area.camera

    if m == nil or c == nil then
        return
    end

    if (not gPlayerSyncTable[m.playerIndex].SSC) and ((c.cutscene == CUTSCENE_STAR_SPAWN) or (c.cutscene == CUTSCENE_RED_COIN_STAR_SPAWN)) then
        disable_time_stop_including_mario()
        m.freeze = 0
        c.cutscene = 0
    end
end

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

if network_is_server() or network_is_moderator() then
    hook_chat_command("canafk", "[on|off] Allow/Disallow players afking", CANAFK)
    hook_chat_command("bust-ex-levels", "[on|off] Exclude problematic levels in Door Bust", on_exclude_levels_command)
end
    