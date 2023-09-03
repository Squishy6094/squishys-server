-- name: \\#ff9400\\Pasta \\#330062\\Castle \\#3697ff\\v2 \\#ff0000\\Unfinished
-- description: Type /pc_config to customize some things of the mod! \n\nAllows you to play as Peppino Spaghetti and Gustavo and Brick (the rat) from Pizza Tower! Run up to Mach 3! Super Jump all over the map! Style on your enemies with Y! Kick your friendly rat around! and more! \n\nCREDITS (discord usernames) \n\nAuthor, Code, Animations = @sharen462 \nSpeedmeter Sprite = @eros71 \nPeppino Model = @trashcamsaysfrick \nBrick Model = @mlopsfunny \nSounds, Taunt Sprite = Tour de Pizza

------- VARIABLES -------

local prevForwardVel = 0
local airForwardVel = 0
local prevYVel = 0
local heightPeakPos = 0
local whiteFlashTimer = 0

local hudGeneralTransparencyMult = 0

local hurtCounter = 0
local prevHurtCounter = 0
local wasSquished = false
local transparency = 0
local textShowTimer = 0

local openedMenu = false
local selectedSetting = 1
if _G.pcCharacter == "Peppino" then
    selectedSubSetting = 1
elseif _G.pcCharacter == "Gustavo" then
    selectedSubSetting = 2
else
    selectedSubSetting = 3
end
local configYOffset = 0
local configYStart = 100
local configAlpha = 0
local configInput = 0
local stickCooldown = 0

local charModel
local charVoice
local camEffects

if mod_storage_load("CharModel") == nil or mod_storage_load("CharModel") == "true" then
    charModel = true
else
    charModel = false
end

if mod_storage_load("CharVoice") == nil or mod_storage_load("CharVoice") == "true" then
    charVoice = true
else
    charVoice = false
end

if mod_storage_load("CamEffects") == nil or mod_storage_load("CamEffects") == "true" then
    camEffects = true
else
    camEffects = false
end

local machRunSoundTimer = 0
local superJumpSoundTimer = 0
local breakdanceMusicTimer = 0

local fovAdd = 0

local modGlobalTimer = 0

------- TABLES -------

define_custom_obj_fields({
    oOwner = 'u32',
    oIndex = 'u32',
})

local gNoMachUpdateActions = {
    [ACT_TURNING_AROUND] = true,
    [ACT_BRAKING] = true,
    [ACT_AIR_TURNING] = true,
    [ACT_WATER_DRIFT] = true,
}

local gSuperJumpCharge = {
    [ACT_CROUCH_SLIDE] = true,
    [ACT_CROUCHING] = true,
    [ACT_START_CROUCHING] = true,
    [ACT_START_CRAWLING] = true,
    [ACT_CRAWLING] = true,
    [ACT_STOP_CRAWLING] = true,
}

local gReplaceWithNormalJumpActions = {
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_BACKFLIP] = true,
}

local gReplaceWithGrabActions = {
    [ACT_PUNCHING] = true,
    [ACT_MOVE_PUNCHING] = true,
    [ACT_DIVE] = true,
    [ACT_JUMP_KICK] = true,
}

local gAllowTauntingActions = {
    [ACT_WALKING] = true,
    [ACT_DECELERATING] = true,
    [ACT_BRAKING] = true,
    [ACT_BRAKING_STOP] = true,
    [ACT_TURNING_AROUND] = true,
    [ACT_FINISH_TURNING_AROUND] = true,
    [ACT_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_LONG_JUMP] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_FREEFALL] = true,
    [ACT_FORWARD_ROLLOUT] = true,
    [ACT_BACKWARD_ROLLOUT] = true,
    [ACT_TOP_OF_POLE_JUMP] = true,
    [ACT_UPPERCUT] = true,
    [ACT_IN_QUICKSAND] = true,
    [ACT_LONG_FALL] = true,
    [ACT_PEPPINO_WATER_IDLE] = true,
    [ACT_PEPPINO_SWIM] = true,
    [ACT_GRAB_AIR_CANCEL] = true,
}

local gHurtActionWithArg = {
    [ACT_SOFT_BACKWARD_GROUND_KB] = true,
    [ACT_BACKWARD_GROUND_KB] = true,
    [ACT_HARD_BACKWARD_GROUND_KB] = true,
    [ACT_BACKWARD_AIR_KB] = true,
    [ACT_HARD_BACKWARD_AIR_KB] = true,
    [ACT_BACKWARD_WATER_KB] = true,
    [ACT_SOFT_FORWARD_GROUND_KB] = true,
    [ACT_FORWARD_GROUND_KB] = true,
    [ACT_HARD_FORWARD_GROUND_KB] = true,
    [ACT_FORWARD_AIR_KB] = true,
    [ACT_HARD_FORWARD_AIR_KB] = true,
    [ACT_FORWARD_WATER_KB] = true,
}

local gHurtActions = {
    [ACT_BURNING_JUMP] = true,
    [ACT_BURNING_FALL] = true,
    [ACT_BURNING_GROUND] = true,
    [ACT_SHOCKED] = true,
    [ACT_WATER_SHOCKED] = true,
    [ACT_LAVA_BOOST] = true,
}

local gAirControlActions = {
    [ACT_JUMP] = true,
    [ACT_HOLD_JUMP] = true,
    [ACT_WATER_JUMP] = true,
    [ACT_HOLD_WATER_JUMP] = true,
    [ACT_DOUBLE_JUMP] = true,
    [ACT_TRIPLE_JUMP] = true,
    [ACT_LONG_JUMP] = true,
    [ACT_DOLPHIN_JUMP] = true,
    [ACT_FREEFALL] = true,
    [ACT_HOLD_FREEFALL] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_LONG_FALL] = true,
    [ACT_VERTICAL_WIND] = true,
    [ACT_SUPER_JUMP_CANCEL] = true,
    [ACT_BRICK_AIR] = true,
}

local gConfig = {
    {name = "Character",       value = _G.pcCharacter, type = "multichoice", choices = {"Peppino", "Gustavo", "Mario"}},
    {name = "Character Model", value = charModel,      type = "toggle"},
    {name = "Character Voice", value = charVoice,      type = "toggle"},
    {name = "Camera Effects",  value = camEffects,     type = "toggle"}
}

------- CONSTANTS -------

local E_MODEL_SPEED_RING = smlua_model_util_get_id("speed_ring_geo")
local E_MODEL_MOTION_LINE = smlua_model_util_get_id("motionline_geo")
local E_MODEL_TAUNT = smlua_model_util_get_id("taunt_effect_geo")
local E_MODEL_BOOMBOX = smlua_model_util_get_id("boombox_geo")

local E_MODEL_PEPPINO = smlua_model_util_get_id("peppino_geo")
local E_MODEL_BRICK = smlua_model_util_get_id("brick_geo")

local SOUND_MACH_RUN = audio_sample_load("machrun.mp3")
local SOUND_MACH_3_RUN = audio_sample_load("mach3run.mp3")

local SOUND_SUP_JUMP_PREP = audio_sample_load("superjumpprep.mp3")
local SOUND_SUP_JUMP_HOLD = audio_sample_load("superjumphold.mp3")

local SOUND_TAUNT = audio_sample_load("taunt.mp3")
local SOUND_PARRY = audio_sample_load("nosugarcoating.mp3")

local SOUND_UPPERCUT = audio_sample_load("uppercut.mp3")

local SOUND_DANCE_LOOP = audio_sample_load("dancemusic.mp3")

local SOUND_HURT = audio_sample_load("hurt.mp3")

local SOUND_JUMP = audio_sample_load("jump.mp3")

local VOICE_HURT1 = audio_sample_load("pep_hurt1.mp3")
local VOICE_HURT2 = audio_sample_load("pep_hurt2.mp3")
local VOICE_FUCK = audio_sample_load("pep_fuck.mp3")
local VOICE_SHUSH = audio_sample_load("pep_shush.mp3")
local VOICE_PARANOID1 = audio_sample_load("pep_paranoid1.mp3")
local VOICE_PARANOID2 = audio_sample_load("pep_paranoid2.mp3")
local VOICE_SCREAM = audio_sample_load("pep_scream.mp3")
local VOICE_ANGRY_SCREAM = audio_sample_load("pep_angryscream.mp3")

------- GLOBAL TO LOCAL -------

local
audio_sample_stop, set_mario_action, is_anim_at_end, is_anim_past_end, perform_ground_step, perform_air_step, mario_throw_held_object, mario_set_forward_vel,
obj_mark_for_deletion, set_mario_animation, set_mario_anim_with_accel, play_character_sound, play_sound, play_mario_sound, play_sound_with_freq_scale,
drop_and_set_mario_action, atan2s, spawn_non_sync_object, update_air_without_turn, approach_f32 =

audio_sample_stop, set_mario_action, is_anim_at_end, is_anim_past_end, perform_ground_step, perform_air_step, mario_throw_held_object, mario_set_forward_vel,
obj_mark_for_deletion, set_mario_animation, set_mario_anim_with_accel, play_character_sound, play_sound, play_mario_sound, play_sound_with_freq_scale,
drop_and_set_mario_action, atan2s, spawn_non_sync_object, update_air_without_turn, approach_f32

------- GENERAL FUNCTIONS -------

local stop_voice = function(m)
    audio_sample_stop(VOICE_HURT1)
    audio_sample_stop(VOICE_HURT2)
    audio_sample_stop(VOICE_FUCK)
    audio_sample_stop(VOICE_SHUSH)
    audio_sample_stop(VOICE_PARANOID1)
    audio_sample_stop(VOICE_PARANOID2)
    audio_sample_stop(VOICE_SCREAM)
    audio_sample_stop(VOICE_ANGRY_SCREAM)
end

local obj_set_pos_relative_to_mario_fake_pos = function(o, m, dleft, dy, dforward)
    local facingZ = coss(m.faceAngle.y)
    local facingX = sins(m.faceAngle.y)

    local dz = dforward * facingZ - dleft * facingX
    local dx = dforward * facingX + dleft * facingZ

    o.oPosX = m.marioObj.header.gfx.pos.x + dx
    o.oPosY = m.marioObj.header.gfx.pos.y + dy
    o.oPosZ = m.marioObj.header.gfx.pos.z + dz
end

local white_flash = function(m)
    if m.playerIndex == 0 then
        whiteFlashTimer = 3
    end
end

local parry_attack = function(m, flinch)
    play_character_sound(m, CHAR_SOUND_PUNCH_HOO)
    play_sound_with_freq_scale(SOUND_ACTION_METAL_JUMP, m.marioObj.header.gfx.cameraToObject, 1.6)
    run_audio(SOUND_PARRY, m, 2.3)

    if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
        set_mario_action(m, ACT_PARRY, 0)
    else
        set_mario_action(m, ACT_WATER_PARRY, 0)
    end
    if flinch then
        mario_set_forward_vel(m, -40)
    else
        mario_set_forward_vel(m, 5)
    end
    m.actionTimer = math.random(0, 3)
end

------------------------ HUD ------------------------ 

local speedArrow = get_texture_info("sm64_hud_arrow_shade_grayscale") -- thanks eros71!!

local set_color_considering_pause = function(r, g, b, a)
    local mult = 1
    if is_game_paused() then
        mult = 0.5
    end
    djui_hud_set_color(r * mult, g * mult, b * mult, a * hudGeneralTransparencyMult)
end

local print_shadowed_text = function(text, x, y, scale, r, g, b, a)
    djui_hud_set_color(0, 0, 0, a * 0.65)
    djui_hud_print_text(text, x + 2, y + 2, scale)

    djui_hud_set_color(r, g, b, a)
    djui_hud_print_text(text, x, y, scale)
end

------ SPEED METER ------

local speed_meter = function()
    local m = gMarioStates[0]
    local p = gPeppinoStates[0]
    local speed = m.action == ACT_WALL_RUN and m.vel.y or m.forwardVel
    local alpha = sprintModeIntendedState and 0xA0 or 0x40

    local arrows = {
    --   filling condition (the false ones are defined later)                                            colors               size
        {speed >= 5,                                                                        {r = 0xFF, g = 0xFF, b = 0x4C},   0.6},
        {speed >= 24,                                                                       {r = 0x82, g = 0x49, b = 0   },   0.7},
        {false,                                                                             {r = 0x81, g = 0x81, b = 0xF1},   0.8},
        {false,                                                                             {r = 0x45, g = 0,    b = 0x8E},   0.9},
        {false,                                                                             {r = 0xFF, g = 0,    b = 0   },   1.0},
    }

    if speed == m.vel.y then
        arrows[3][1] = speed >= MACH_1_SPEED_MIN
        arrows[4][1] = speed >= lerp(MACH_1_SPEED_MIN, MACH_2_SPEED_MIN, 0.52)
        arrows[5][1] = speed >= MACH_2_SPEED_MIN
    else
        arrows[3][1] = speed >= MACH_1_SPEED_MIN and p.machLevel >= 1
        arrows[4][1] = speed >= lerp(MACH_1_SPEED_MIN, MACH_2_SPEED_MIN, 0.52) and p.machLevel >= 1
        arrows[5][1] = speed >= MACH_2_SPEED_MIN and p.machLevel >= 2
    end

    djui_hud_set_resolution(RESOLUTION_N64)

    djui_hud_set_render_behind_hud(false)

    for i = 1, #arrows do
        local x = 25
        local y = 47.5
        local arrowIndexOffset = (10 + lerp(0, 4, (i - 1) / #arrows)) * (i - 1)
        local heightOffset = 18 * (arrows[i][3] / 2)
        local randomOffset1 = 0
        local randomOffset2 = 0

        if speed >= MACH_3_SPEED_MIN and _G.pcCharacter == "Peppino" then
            randomOffset1 = math.random(-155, 155) / 100
            randomOffset2 = math.random(-155, 155) / 100
        elseif arrows[5][1] then
            randomOffset1 = math.random(-70, 70) / 100
            randomOffset2 = math.random(-70, 70) / 100
        elseif arrows[4][1] then
            randomOffset1 = math.random(-30, 30) / 100
            randomOffset2 = math.random(-30, 30) / 100
        end

        set_color_considering_pause(0x0, 0x0, 0x0, alpha)
        djui_hud_render_texture(speedArrow, ((x + arrowIndexOffset) + randomOffset1) + 1, ((y - heightOffset) + randomOffset2) + 1, arrows[i][3], arrows[i][3])

        if arrows[i][1] then
            if math.fmod(modGlobalTimer, 4) == 0 and arrows[5][1] then
                set_color_considering_pause(0xFF, 0xFF, 0xFF, alpha + 0x50)
            else
                set_color_considering_pause(arrows[i][2].r, arrows[i][2].g, arrows[i][2].b, alpha + 0x50)
            end

            djui_hud_render_texture(speedArrow, (x + arrowIndexOffset) + randomOffset1, (y - heightOffset) + randomOffset2, arrows[i][3], arrows[i][3])
        end
    end
end

------ HURT TEXT ------

local hurt_text = function()
    local reachedMilestone = (math.fmod(hurtCounter, 3) == 0) and true or false
    local name = charModel and "Peppino" or gMarioStates[0].character.name

    local text
    local scale = 0.8
    local textDuration = 3.2 * 30
    local randomOffset1 = math.random(-100, 100) / 100
    local randomOffset2 = math.random(-100, 100) / 100
    local hurtCountLowest3 = 3 * math.floor(hurtCounter / 3)

    djui_hud_set_render_behind_hud(false)

    if hurtCountLowest3 >= 1000 then
        text = string.format("i dont know what to say to you anymore (%d times)", hurtCountLowest3)
    elseif hurtCountLowest3 >= 500 then
        text = string.format("bro... (%d times)", hurtCountLowest3)
    elseif hurtCountLowest3 >= 100 then
        text = string.format("HOLY SHIT! (%d times)", hurtCountLowest3)
    elseif hurtCountLowest3 >= 50 then
        text = string.format("YOU WILL GO TO HELL! (%d times)", hurtCountLowest3)
    else
        text = string.format("You've hurt %s %d times...", name, hurtCountLowest3)
    end

    if hurtCounter > prevHurtCounter then
        prevHurtCounter = hurtCounter
        if reachedMilestone then
            textShowTimer = textDuration
        end
    end

    if textShowTimer > 0 then
        transparency = approach_f32(transparency, 0xFF, 0xFF / 20, 0xFF / 20)
        textShowTimer = textShowTimer - 1
    else
        transparency = approach_f32(transparency, 0, 0xFF / 60, 0xFF / 60)
    end

    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(FONT_MENU)

    print_shadowed_text(text, (djui_hud_get_screen_width() / 2 - (djui_hud_measure_text(text) / 2) * scale) + randomOffset1,
    (djui_hud_get_screen_height() - 120 * scale) + randomOffset2, scale, 0xFF, 0xFF, 0xFF, transparency)
end

------ CONFIG MENU ------

local config_menu = function()
    local m = gMarioStates[0]

    configYOffset = approach_s32(configYOffset, 0, 1, 1)

    if openedMenu then
        configYStart = approach_s32(configYStart, 0, 8.3, 8.3)
        configAlpha = approach_s32(configAlpha, 0xFF, 0xFF / 12, 0xFF / 12)
    else
        configYStart = approach_s32(configYStart, 100, 20, 20)
        configAlpha = approach_s32(configAlpha, 0, 0xFF / 5, 0xFF / 5)
    end

    if configAlpha > 0 then
        local MAX_SETTINGS = #gConfig
        local text = "PASTA CASTLE CONFIGURATION"
        local scale = 1.6

        djui_hud_set_resolution(RESOLUTION_DJUI)

        djui_hud_set_render_behind_hud(false)
        djui_hud_set_color(0, 0, 0, configAlpha * 0.7)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 4, djui_hud_get_screen_height() + 4)

        djui_hud_set_font(FONT_HUD)

        print_shadowed_text(text, (djui_hud_get_screen_width() / 2 - (djui_hud_measure_text(text) / 2) * 3.5), 40 + configYStart, 3.5,
        0xFF, 0xFF, 0xFF, configAlpha)

        djui_hud_set_font(FONT_NORMAL)

        text = "Press D-Pad Up or Down to select, D-Pad Left, Right or A to toggle, and B or Pause to quit the menu."
        print_shadowed_text(text, (djui_hud_get_screen_width() / 2 - (djui_hud_measure_text(text) / 2) * 1), 120 + configYStart, 1,
        0xFF, 0xFF, 0xFF, configAlpha)

        if configInput & U_JPAD ~= 0 then
            selectedSetting = selectedSetting - 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            configYOffset = -6

            if selectedSetting < 1 then
                selectedSetting = MAX_SETTINGS
            end
        end

        if configInput & D_JPAD ~= 0 then
            selectedSetting = selectedSetting + 1
            play_sound(SOUND_MENU_CHANGE_SELECT, m.marioObj.header.gfx.cameraToObject)
            configYOffset = 6

            if selectedSetting > MAX_SETTINGS then
                selectedSetting = 1
            end
        end

        if configInput & (B_BUTTON | START_BUTTON) ~= 0 then
            openedMenu = false
            play_sound(SOUND_MENU_HAND_DISAPPEAR, m.marioObj.header.gfx.cameraToObject)
            selectedSetting = 1
            _G.pcCharacter = gConfig[1].value
            charModel = gConfig[2].value
            charVoice = gConfig[3].value
            camEffects = gConfig[4].value

            mod_storage_save("Character", _G.pcCharacter)
            mod_storage_save("CharModel", tostring(charModel))
            mod_storage_save("CharVoice", tostring(charVoice))
            mod_storage_save("CamEffects", tostring(camEffects))
        end

        for i = 1, MAX_SETTINGS do
            local screenCenter = djui_hud_get_screen_width() / 2
            local x = screenCenter - 600
            local maxX = screenCenter + 560
            local rectWidth = maxX - x + 75
            local y = 170 + 70 * (i - 1) + configYStart

            if selectedSetting == i then
                y = y + configYOffset
            end

            djui_hud_set_color(0, 0, 0, 0xFF)
            djui_hud_render_rect(x - 14, y - 2, rectWidth + 8, 58)

            if selectedSetting == i then
                djui_hud_set_color(0x5E, 0x84, 0xFF, configAlpha)
            else
                djui_hud_set_color(0x40, 0x40, 0x40, configAlpha)
            end

            djui_hud_render_rect(x - 10, y + 2, rectWidth, 50)

            print_shadowed_text(gConfig[i].name, x, y, scale, 0xFF, 0x80, 0, configAlpha)

            if gConfig[i].type == "multichoice" then
                local settingText = gConfig[i].choices[selectedSubSetting]

                if selectedSetting == i then
                    settingText = string.format("< %s >", gConfig[i].choices[selectedSubSetting])

                    print_shadowed_text(settingText, maxX - djui_hud_measure_text(settingText), y, scale, 0x40, 0xF5, 0x33, configAlpha)

                    if configInput & L_JPAD ~= 0 then
                        selectedSubSetting = selectedSubSetting - 1
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)
                        configYOffset = math.random(0, 1) == 0 and -3 or 3

                        if selectedSubSetting < 1 then
                            selectedSubSetting = #gConfig[i].choices
                        end
                    end

                    if configInput & (R_JPAD | A_BUTTON) ~= 0 then
                        selectedSubSetting = selectedSubSetting + 1
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)
                        configYOffset = math.random(0, 1) == 0 and -3 or 3

                        if selectedSubSetting > #gConfig[i].choices then
                            selectedSubSetting = 1
                        end
                    end

                    gConfig[i].value = gConfig[i].choices[selectedSubSetting]
                else
                    print_shadowed_text(settingText, maxX - djui_hud_measure_text(settingText), y, scale, 0xFF, 0xFF, 0xFF, configAlpha)
                end
            elseif gConfig[i].type == "toggle" then
                local r, g, b
                if selectedSetting == i then
                    if gConfig[i].value then
                        r, g, b = 0, 0xFF, 0
                    else
                        r, g, b = 0xFF, 0x40, 0x40
                    end

                    if configInput & (A_BUTTON | L_JPAD | R_JPAD) ~= 0 then
                        gConfig[i].value = not gConfig[i].value
                        play_sound(SOUND_MENU_REVERSE_PAUSE, m.marioObj.header.gfx.cameraToObject)
                        configYOffset = math.random(0, 1) == 0 and -3 or 3
                    end
                else
                    r, g, b = 0xFF, 0xFF, 0xFF
                end

                if gConfig[i].value then
                    print_shadowed_text("ON", maxX, y, scale, r, g, b, configAlpha)
                else
                    print_shadowed_text("OFF", maxX, y, scale, r, g, b, configAlpha)
                end
            end
        end
    end
end

------------------------ OBJECT PARTICLES ------------------------ 

------ SPEED RINGS ------

local speed_ring_init = function(o)
    o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE)
    o.oOpacity = 0xA9
    obj_scale(o, 0.6)
end

local speed_ring_loop = function(o)
    local rollSpeed = deg_to_hex(math.random(10, 20))

    o.oVelX = o.oForwardVel * sins(o.oMoveAngleYaw) * coss(o.oMoveAnglePitch)
    o.oVelY = o.oForwardVel * sins(o.oMoveAnglePitch)
    o.oVelZ = o.oForwardVel * coss(o.oMoveAngleYaw) * coss(o.oMoveAnglePitch)

    if cur_obj_resolve_wall_collisions() == 0 then
        obj_move_xyz(o, o.oVelX, o.oVelY, o.oVelZ)
    end

    obj_scale(o, o.header.gfx.scale.x + 0.2)

    o.oMoveAngleRoll = o.oMoveAngleRoll + rollSpeed

    if o.oTimer >= 3 then
        o.oOpacity = o.oOpacity - 0xA9 / 4
    end

    if o.oOpacity <= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvSpeedRing = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, speed_ring_init, speed_ring_loop)

------ MOTION LINES ------

local motion_line_init = function(o)
    local m = gMarioStates[o.oOwner]
    local yMultiplier = math.floor(m.marioBodyState.headPos.y + 60 - m.marioObj.header.gfx.pos.y) < 0 and -1 or 1

    o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE)
    o.oOpacity = 0x86
    obj_scale(o, math.random(2, 4) / 10)
    o.header.gfx.scale.z = math.random(4, 6) / 10

    o.oHomeX = math.random(-60, 60)
    o.oHomeY = math.random(0, math.abs(math.floor(m.marioBodyState.headPos.y + 60 - m.marioObj.header.gfx.pos.y))) * yMultiplier
    o.oHomeZ = math.random(-30, 30)

    obj_set_pos_relative_to_mario_fake_pos(o, m, o.oHomeX, o.oHomeY, o.oHomeZ)
end

---@param o Object
local motion_line_loop = function(o)
    local m = gMarioStates[o.oOwner]
    local pitch = m.forwardVel > 0 and atan2s(m.forwardVel, -m.vel.y) or atan2s(-m.forwardVel, -m.vel.y)

    obj_set_pos_relative_to_mario_fake_pos(o, m, o.oHomeX, o.oHomeY, o.oHomeZ)

    o.oMoveAngleYaw = m.forwardVel > 0 and atan2s(m.vel.z, m.vel.x) or m.marioObj.header.gfx.angle.y
    o.oMoveAnglePitch = m.pos.y - m.floorHeight <= 0 and -find_floor_slope(m, 0) or pitch

    o.oOpacity = o.oOpacity - 0x86 / 4

    if o.oOpacity <= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvMotionLine = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, motion_line_init, motion_line_loop)

------ SPEED FLAMES ------

---@param o Object
local speed_flame_init = function(o)
    local m = gMarioStates[o.oOwner]

    o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE)
    obj_scale(o, math.random(200, 240) / 100)
    obj_set_billboard(o)

    obj_set_pos_relative_to_mario_fake_pos(o, m, math.random(-30, 30), 40, -40)
end

---@param o Object
local speed_flame_loop = function(o)
    o.oAnimState = o.oAnimState + 1

    if o.oTimer >= 3 then
        obj_scale(o, o.header.gfx.scale.x - 1)
    end

    if o.header.gfx.scale.x <= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvSpeedFlame = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, speed_flame_init, speed_flame_loop)

------ TAUNT EFFECT ------

---@param o Object
local taunt_effect_init = function(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oAnimState = -1
end

---@param o Object
local taunt_effect_loop = function(o)
    local m = gMarioStates[o.oOwner]
    local offset = 50
    local baseScale = 0.3

    o.oAnimState = o.oAnimState + 1

    o.oFaceAngleYaw = gMarioStates[0].area.camera.yaw

    o.oPosX = m.pos.x - offset * sins(o.oFaceAngleYaw)
    o.oPosY = m.pos.y + 80
    o.oPosZ = m.pos.z - offset * coss(o.oFaceAngleYaw)

    if o.oAnimState == 0 then
        obj_scale(o, baseScale - 0.1)
    elseif o.oAnimState == 1 then
        obj_scale(o, baseScale + 0.1)
    elseif o.oAnimState == 2 then
        obj_scale(o, baseScale - 0.05)
    else
        obj_scale(o, baseScale)
    end

    if gPlayerSyncTable[m.playerIndex].tauntTimer <= 0 then
        obj_mark_for_deletion(o)
        gPeppinoStates[m.playerIndex].spawnedTauntEffect = false
    end
end

id_bhvTauntEffect = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, taunt_effect_init, taunt_effect_loop)

------ BOOMBOX ------

local boombox_init = function(o)
    o.oFlags = (OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE | OBJ_FLAG_0020)
end

---@param o Object
local boombox_loop = function(o)
    local m = gMarioStates[o.oOwner]
    local t = o.oAnimState / 15

    o.oVelY = o.oVelY - 4

    cur_obj_update_floor()

    if o.oPosY <= o.oFloorHeight then
        o.oPosY = o.oFloorHeight
    else
        o.oPosY = o.oPosY + o.oVelY
    end

    if o.oAction == 0 then
        o.oAnimState = o.oAnimState + 1
        if t >= 1 then
            o.oAction = 1
        end
    else
        o.oAnimState = o.oAnimState - 1
        if t <= 0 then
            o.oAction = 0
        end
    end

    if m.action ~= ACT_BREAKDANCE then
        spawn_mist_particles()
        gPeppinoStates[m.playerIndex].spawnedBoombox = false
        obj_mark_for_deletion(o)
    end

    o.header.gfx.scale.x = lerp(0.25, 0.35, ease_in_out_quad(t))
    o.header.gfx.scale.y = lerp(0.35, 0.25, ease_in_out_quad(t))
    o.header.gfx.scale.z = lerp(0.25, 0.35, ease_in_out_quad(t))
end

id_bhvBoombox = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, boombox_init, boombox_loop)

------ PARTICE SPAWNERS ------

local speed_particles = function(m)
    local mGfx = m.marioObj.header.gfx
    local p = gPeppinoStates[m.playerIndex]
    local s = gPlayerSyncTable[m.playerIndex]
    local pitch = m.forwardVel > 0 and atan2s(m.forwardVel, -m.vel.y) or atan2s(-m.forwardVel, -m.vel.y)

    if m.action ~= ACT_TAUNT and m.action ~= ACT_WATER_TAUNT then
        if (m.action == ACT_WALKING or m.action == ACT_FINISH_TURNING_AROUND) and p.machLevel >= 3 and math.fmod(modGlobalTimer, 6) == 0 then
            spawn_non_sync_object(id_bhvSpeedFlame, E_MODEL_RED_FLAME, mGfx.pos.x, mGfx.pos.y, mGfx.pos.z, function(o)
                o.oOwner = m.playerIndex
            end)
        end

        if (((m.forwardVel >= MACH_2_SPEED_MIN and p.machLevel >= 2) or (m.action == ACT_SUPER_JUMP and m.actionState == 0) or
        ((m.action == ACT_GROUND_POUND or m.action == ACT_PILEDRIVER) and m.vel.y < -85)) and math.fmod(modGlobalTimer, 10) == 0)
        and _G.pcCharacter ~= "Mario" then
            local model = (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED and E_MODEL_WATER_RING or E_MODEL_SPEED_RING

            spawn_non_sync_object(id_bhvSpeedRing, model, mGfx.pos.x, mGfx.pos.y + 60, mGfx.pos.z, function(o)
                o.oMoveAngleYaw = m.faceAngle.y
                o.oMoveAnglePitch = m.pos.y - m.floorHeight <= 0 and -find_floor_slope(m, 0) or
                atan2s(math.sqrt(m.vel.x * m.vel.x + m.vel.z * m.vel.z), -m.vel.y)
                o.oForwardVel = math.max(m.forwardVel, m.vel.y) / 4
            end)

        elseif (((m.forwardVel >= MACH_1_SPEED_MIN and p.machLevel >= 1) or m.action == ACT_WALL_RUN or m.action == ACT_COMET_DIVE or
        ((m.action == ACT_GROUND_POUND or m.action == ACT_PILEDRIVER) and m.vel.y < -45)) and math.fmod(modGlobalTimer, 4) == 0)
        and _G.pcCharacter ~= "Mario" and (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
            spawn_non_sync_object(id_bhvMotionLine, E_MODEL_MOTION_LINE, mGfx.pos.x, mGfx.pos.y, mGfx.pos.z, function(o)
                o.oMoveAngleYaw = atan2s(m.vel.z, m.vel.x)
                o.oMoveAnglePitch = m.pos.y - m.floorHeight <= 0 and -find_floor_slope(m, 0) or pitch
                o.oOwner = m.playerIndex
            end)
        end
    end

    if m.action == ACT_BREAKDANCE and m.actionTimer >= 30 and is_player_active(m) ~= 0 then
        if not p.spawnedBoombox then
            spawn_non_sync_object(id_bhvBoombox, E_MODEL_BOOMBOX, mGfx.pos.x, mGfx.pos.y + 80, mGfx.pos.z, function(o)
                o.oVelY = 40
                vec3f_set(o.header.gfx.scale, 0.25, 0.35, 0.25)
                o.oOwner = m.playerIndex
                spawn_mist_particles()
                o.oFaceAnglePitch = 0
                o.oFaceAngleRoll = 0
            end)
            p.spawnedBoombox = true
        end
    end
end

---@param m MarioState
local taunt_effect_particle = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local s = gPlayerSyncTable[m.playerIndex]

    if is_player_active(m) == 0 then
        return
    end

    if (s.tauntTimer > 0 and s.tauntTimer <= 7) then
        if not p.spawnedTauntEffect then
            spawn_non_sync_object(id_bhvTauntEffect, E_MODEL_TAUNT, m.pos.x, m.pos.y + 80, m.pos.z, function(o)
                o.oOwner = m.playerIndex
                o.oFaceAnglePitch = 0
                o.oFaceAngleYaw = gMarioStates[0].area.camera.yaw
                o.oFaceAngleRoll = 0
                obj_scale(o, 0.3)
            end)
            p.spawnedTauntEffect = true
        end
    end
end

------------------------ CAMERA ------------------------ 

---@param m MarioState
local handle_camera_effects = function(m)
    if not camEffects then
        return
    end

    local speed = m.action == ACT_WALL_RUN and m.vel.y or m.forwardVel
    local t = (speed - MACH_2_SPEED_MIN) / (MACH_3_SPEED_MIN - MACH_2_SPEED_MIN)
    local maxAdd = (speed >= MACH_3_SPEED_MIN and _G.pcCharacter == "Peppino") and 10 or lerp(0, 8, t)
    local incDec = (speed >= MACH_3_SPEED_MIN and _G.pcCharacter == "Peppino") and 0.75 or 0.27

    if t > 0 then
        if fovAdd < 0 then
            fovAdd = 0
        end
    end

    fovAdd = approach_f32(fovAdd, maxAdd, incDec, incDec)

    if speed >= MACH_3_SPEED_MIN and _G.pcCharacter == "Peppino" then
        set_camera_pitch_shake(math.random(-100, 100) * 0.64, 15, 100)
        set_camera_yaw_shake(math.random(-100, 100) * 0.54, 15, 100)
        set_camera_roll_shake(math.random(-100, 100) * 0.64, 15, 100)
    end

    if fovAdd > 0 then
        set_override_fov(45 + fovAdd)
    elseif fovAdd <= 0 then
        -- only set this once just in case i break something (cant really trust this game)
        set_fov_function(CAM_FOV_DEFAULT)
        fovAdd = -1
    end
end

------------------------ HOOKS ------------------------

---@param m MarioState
local mario_update_local = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local s = gPlayerSyncTable[m.playerIndex]

    if _G.pcCharacter ~= "Mario" then
        m.peakHeight = m.pos.y
        if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_AIRBORNE or m.vel.y >= 0 then
            heightPeakPos = m.pos.y
        end
        prevYVel = m.vel.y
        if not (m.action == ACT_CROUCH_SLIDE and m.forwardVel >= 10) then
            prevForwardVel = m.forwardVel
        end

        if m.action == ACT_WALL_RUN or m.action == ACT_WALL_KICK_AIR then
            airForwardVel = MACH_1_SPEED_MIN
        elseif (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_AIRBORNE then
            airForwardVel = m.forwardVel
        end

        gAllowTauntingActions[ACT_SUPER_JUMP] = m.vel.y <= 0
        gAllowTauntingActions[ACT_SUPER_JUMP_CANCEL] = m.actionState == 1
        gAllowTauntingActions[ACT_CEIL_CRASH] = m.actionState == 1
        gAllowTauntingActions[ACT_PEPPINO_SWIM] = m.heldObj == nil
        gAllowTauntingActions[ACT_PEPPINO_WATER_IDLE] = m.heldObj == nil
        gAllowTauntingActions[ACT_DOLPHIN_JUMP] = m.heldObj == nil

        if _G.pcCharacter == "Peppino" then
            if m.action == ACT_JUMP or m.action == ACT_WALL_KICK_AIR or m.action == ACT_SIDE_FLIP or m.action == ACT_FREEFALL then
                m.actionTimer = m.actionTimer + 1

                if (m.input & INPUT_A_PRESSED) ~= 0 and m.actionTimer > 2 then
                    set_anim_to_frame(m, 0)
                    set_mario_action(m, ACT_UPPERCUT, 0)
                end
            end

            if m.action == ACT_LONG_JUMP then
                m.actionTimer = m.actionTimer + 1

                if (m.input & INPUT_A_PRESSED) ~= 0 and m.actionTimer > 1 then
                    set_mario_action(m, ACT_UPPERCUT, 0)
                end

                if (m.input & INPUT_A_DOWN) == 0 then
                    if m.vel.y > 10 then
                        m.vel.y = m.vel.y / 4
                    end
                    m.vel.y = m.vel.y - 2
                end

                if (m.input & INPUT_Z_PRESSED) ~= 0 then
                    set_mario_action(m, ACT_GROUND_POUND, 0)
                end

                if mario_check_object_grab(m) ~= 0 then
                    mario_grab_used_object(m)
                    if m.interactObj.behavior == get_behavior_from_id(id_bhvBowser) then
                        m.marioBodyState.grabPos = GRAB_POS_BOWSER
                    elseif m.interactObj.oInteractionSubtype & INT_SUBTYPE_GRABS_MARIO ~= 0 then
                        m.marioBodyState.grabPos = GRAB_POS_HEAVY_OBJ
                    else
                        m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ
                    end

                    m.vel.y = 110
                    set_mario_action(m, ACT_PILEDRIVER, 0)
                end

                if m.actionTimer > 1 then
                    check_kick_or_dive_in_air(m)
                end
            end

            if m.action == ACT_CROUCH_SLIDE and mario_floor_is_slope(m) == 0 and p.machLevel >= 2 then
                if m.forwardVel ~= 0 then
                    mario_set_forward_vel(m, approach_f32(m.forwardVel, 0, 2.8, 2.8))
                end
            end

            if (gSuperJumpCharge[m.action] and p.machLevel >= 2) or m.action == ACT_BELLY_DASH then
                p.squishIntensity = approach_f32(p.squishIntensity, 0.6, 0.1, 0.1)
                if m.action ~= ACT_BELLY_DASH then
                    set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
                    if superJumpSoundTimer <= 0 then
                        run_audio(SOUND_SUP_JUMP_HOLD, m, 1.65)
                        superJumpSoundTimer = 40
                    else
                        superJumpSoundTimer = superJumpSoundTimer - 1
                    end
                else
                    superJumpSoundTimer = 0
                end
            else
                p.squishIntensity = approach_f32(p.squishIntensity, 0, 0.2, 0.2)
            end

            if (m.controller.buttonDown & Y_BUTTON) ~= 0 and (m.action == ACT_IN_QUICKSAND or m.action == ACT_WALKING or (m.action & ACT_FLAG_IDLE) ~= 0) then
                set_mario_action(m, ACT_BREAKDANCE, 0)
            end

            if (m.action == ACT_JUMP or m.action == ACT_FREEFALL or m.action == ACT_SUPER_JUMP or m.action == ACT_WALL_KICK_AIR or m.action == ACT_SIDE_FLIP) and
            heightPeakPos - m.pos.y > 2400 then
                set_mario_action(m, ACT_LONG_FALL, 0)
            end
        elseif _G.pcCharacter == "Gustavo" then
            if m.action == ACT_TURNING_AROUND or m.action == ACT_BRAKING then
                m.forwardVel = m.forwardVel - 3
            end
        end

        if gLandActions[m.action] then
            check_ground_dive_or_punch(m)

            if (m.input & INPUT_Z_PRESSED) ~= 0 then
                if m.forwardVel ~= 0 then
                    drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0)
                else
                    drop_and_set_mario_action(m, ACT_START_CROUCHING, 0)
                end
            end
        end

        if m.action == ACT_CRAWLING and mario_floor_is_slippery(m) == 0 then
            mario_set_forward_vel(m, 15)
            m.marioObj.header.gfx.animInfo.animAccel = m.marioObj.header.gfx.animInfo.animAccel + 0x40000
        end

        if m.action == ACT_SOFT_BONK then
            m.actionTimer = m.actionTimer + 1
            if m.actionTimer > 5 then
                set_mario_action(m, ACT_FREEFALL, 0)
            end
        end

        -- update mach level
        if (not gNoMachUpdateActions[m.action] and not gSuperJumpCharge[m.action] and _G.pcCharacter == "Peppino") or _G.pcCharacter == "Gustavo" then
            if m.forwardVel >= MACH_3_SPEED_MIN and sprintMode and _G.pcCharacter == "Peppino" then
                if p.machLevel < 3 then
                    white_flash(m)
                    machRunSoundTimer = 105
                end
                p.machLevel = 3
            elseif m.forwardVel >= MACH_2_SPEED_MIN and sprintMode then
                if p.machLevel < 2 then
                    white_flash(m)
                    machRunSoundTimer = 50
                end
                p.machLevel = 2
            elseif m.forwardVel >= MACH_1_SPEED_MIN and sprintMode then
                p.machLevel = 1
            else
                p.machLevel = 0
            end
        end

        if m.forwardVel >= MACH_2_SPEED_MIN and p.machLevel >= 2 then
            adjust_sound_for_speed(m)
            play_sound(SOUND_MOVING_FLYING, m.marioObj.header.gfx.cameraToObject)

            if m.action == ACT_WALKING or m.action == ACT_FINISH_TURNING_AROUND or m.action == ACT_JUMP or m.action == ACT_FREEFALL or gLandActions[m.action] then
                if p.machLevel >= 3 then
                    audio_sample_stop(SOUND_MACH_RUN)
                    if machRunSoundTimer >= 105 then
                        run_audio(SOUND_MACH_3_RUN, m, 1.45)
                        machRunSoundTimer = 0
                    end
                else
                    audio_sample_stop(SOUND_MACH_3_RUN)
                    if machRunSoundTimer >= 50 then
                        run_audio(SOUND_MACH_RUN, m, 1.45)
                        machRunSoundTimer = 0
                    end
                end

                machRunSoundTimer = machRunSoundTimer + 1
            else
                audio_sample_stop(SOUND_MACH_RUN)
                audio_sample_stop(SOUND_MACH_3_RUN)
                machRunSoundTimer = p.machLevel >= 3 and 105 or 50
            end
        else
            audio_sample_stop(SOUND_MACH_RUN)
            audio_sample_stop(SOUND_MACH_3_RUN)
            machRunSoundTimer = p.machLevel >= 3 and 105 or 50
        end

        m.marioObj.header.gfx.scale.x = m.marioObj.header.gfx.scale.x * 1 + p.squishIntensity / 2
        m.marioObj.header.gfx.scale.y = m.marioObj.header.gfx.scale.y * 1 - p.squishIntensity
        m.marioObj.header.gfx.scale.z = m.marioObj.header.gfx.scale.z * 1 + p.squishIntensity / 2

        if gAirControlActions[m.action] then
            if (p.machLevel < 1 and (m.action ~= ACT_WALL_KICK_AIR and m.action ~= ACT_LONG_JUMP)) or
            (_G.pcCharacter == "Gustavo" and not (m.action == ACT_WALL_KICK_AIR and m.vel.y > 0)) then
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
            elseif not (_G.pcCharacter == "Gustavo" and m.action == ACT_WALL_KICK_AIR) then
                local airSpdModifier = 0
                if analog_stick_held_back(m) ~= 0 then
                    airSpdModifier = m.intendedMag * 0.3
                end
                mario_set_forward_vel(m, math.max(airForwardVel - airSpdModifier, MACH_1_SPEED_MIN + 5))
            end
        end

        if (m.action == ACT_JUMP or m.action == ACT_FREEFALL) and m.actionState > 0 then
            if m.actionState == 1 then
                if _G.pcCharacter == "Peppino" then
                    set_custom_anim(m, "MARIO_ANIM_MACH_RUN", nil, true)
                else
                    mario_roll_anim(m, 0x15000)
                end
            else
                set_custom_anim(m, "MARIO_ANIM_MACH3_RUN", 0x17500, true)
            end
        end

        if (m.controller.buttonPressed & X_BUTTON) ~= 0 then
            sprintModeIntendedState = not sprintModeIntendedState -- reverses the bool, if its false it turns true and vice versa
        end

        if m.pos.y - m.floorHeight <= 0 or (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED then
            sprintMode = sprintModeIntendedState -- made so that you cant make the game think you're in mach 0 despite going at high speeds
        end

        if (m.action == ACT_WATER_IDLE or m.action == ACT_METAL_WATER_FALLING or m.action == ACT_METAL_WATER_JUMP or
        m.action == ACT_METAL_WATER_STANDING) then
            set_mario_action(m, ACT_PEPPINO_WATER_IDLE, 0)
        end

        if (m.flags & MARIO_METAL_CAP) == 0 then
            if m.floor ~= nil and m.pos.y - m.floorHeight <= 0 and m.floor.type == SURFACE_BURNING and m.action == ACT_LAVA_BOOST then
                hurtCounter = hurtCounter + 1
                white_flash(m)
            end

            if m.action == ACT_SQUISHED and m.actionState == 1 then
                if not wasSquished then
                    hurtCounter = hurtCounter + 1
                    white_flash(m)
                    wasSquished = true
                    run_audio(SOUND_HURT, m, 1.6)
                end
            else
                wasSquished = false
            end
        end

        if _G.pcCharacter == "Gustavo" then
            if p.brickObj == nil then
                p.brickObj = spawn_non_sync_object(id_bhvBrick, E_MODEL_BRICK, m.pos.x, m.pos.y, m.pos.z, function(o)
                    o.oOwner = m.playerIndex
                end)
            end
        else
            obj_mark_for_deletion(p.brickObj)
            p.brickObj = nil
        end

        if m.action == ACT_GRABBED then
            s.tauntTimer = 0
        end

        if (m.pos.y - m.floorHeight <= 0 or m.action == ACT_WALL_KICK_AIR) then
            tauntStaleCount = -2
        end

        if tauntCooldown > 0 and (m.action ~= ACT_TAUNT and m.action ~= ACT_WATER_TAUNT) then
            tauntCooldown = tauntCooldown - 1
        end

        if whiteFlashTimer > 0 then
            whiteFlashTimer = whiteFlashTimer - 1
            for i = 0, PLAYER_PART_MAX do
                network_player_color_to_palette(gNetworkPlayers[0], i, {r = 0xCA, g = 0xCA, b = 0xFF})
            end
        else
            for i = 0, PLAYER_PART_MAX do
                local color = {r = 0, g = 0, b = 0}
                network_player_palette_to_color(nil, i, color)

                network_player_color_to_palette(gNetworkPlayers[0], i, color)
            end
        end

        secret = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvHiddenStarTrigger)

        if secret ~= nil and obj_check_if_collided_with_object(secret, m.marioObj) ~= 0 and math.random(0, 100) <= 50 and charVoice then
            local randomNum = math.random(0, 100)
            stop_voice(m)

            if _G.pcCharacter == "Peppino" then
                if randomNum < 33 then
                    run_audio(VOICE_SHUSH, m, 1.2)
                elseif randomNum < 67 then
                    run_audio(VOICE_PARANOID1, m, 1.2)
                else
                    run_audio(VOICE_PARANOID2, m, 1.2)
                end
            end
        end

        if charModel then
            s.modelId = E_MODEL_PEPPINO
        else
            s.modelId = nil
        end

        if openedMenu then
            m.input = 0
        end

        handle_camera_effects(m)
    else
        s.modelId = nil
    end

    local o = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvBoombox)

    if o ~= nil and vec3f_dist(m.marioObj.header.gfx.pos, o.header.gfx.pos) <= 3500 then
        breakdanceMusicTimer = breakdanceMusicTimer + 1
        if breakdanceMusicTimer >= 55 then
            audio_sample_play(SOUND_DANCE_LOOP, o.header.gfx.pos, 2)
            breakdanceMusicTimer = 0
        end
        seq_player_lower_volume(0, 20, 0)
    else
        audio_sample_stop(SOUND_DANCE_LOOP)
        breakdanceMusicTimer = 55
        seq_player_unlower_volume(0, 20)
    end
end

---@param m MarioState
local mario_update = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local s = gPlayerSyncTable[m.playerIndex]

    if not gNetworkPlayers[m.playerIndex].connected then
        return
    end

    if m.action == ACT_COMET_DIVE or m.action == ACT_LONG_FALL then
        m.marioObj.header.gfx.angle.x = m.marioObj.header.gfx.angle.x + 0x3000
    end

    if m.action == ACT_WALL_CRASH then
        vec3f_set(m.marioObj.header.gfx.scale, 1.4, 0.2, 1.4)
    end

    local t = m.action == ACT_UPPERCUT and m.actionTimer / 15 or m.actionState / 15

    if t > 0.15 and t < 0.85 and (m.action == ACT_UPPERCUT or ((m.action == ACT_PARRY or m.action == ACT_WATER_PARRY) and m.actionTimer >= 3)) then
        m.marioBodyState.punchState = (0 << 6) | 4
    end

    if (m.controller.buttonPressed & Y_BUTTON ~= 0 and tauntCooldown <= 0 and (gAllowTauntingActions[m.action] or (m.action & ACT_FLAG_IDLE) ~= 0 or
        gLandActions[m.action])) and _G.pcCharacter ~= "Mario" then
        if m.playerIndex == 0 then
            s.tauntTimer = 9
            tauntStaleCount = tauntStaleCount + 1
            run_audio(SOUND_TAUNT, m, 1)
        end
        p.poseIndex = math.random(1, #gPoseIndexes)
        m.prevAction = m.action
        if (m.action & ACT_GROUP_MASK) == ACT_GROUP_SUBMERGED then
            m.action = ACT_WATER_TAUNT
        else
            m.action = ACT_TAUNT
        end
    end

    if (m.action == ACT_TAUNT or m.action == ACT_WATER_TAUNT) and p.poseIndex == 16 then
        if (m.flags & MARIO_CAPS) ~= 0 then
            m.marioBodyState.capState = MARIO_HAS_WING_CAP_ON
        else
            m.marioBodyState.capState = MARIO_HAS_WING_CAP_OFF
        end
    end

    if m.marioObj.header.gfx.animInfo.animID ~= MARIO_ANIM_FORWARD_SPINNING then
        m.marioObj.header.gfx.disableAutomaticShadowPos = false
    end

    if s.modelId ~= nil then
        obj_set_model_extended(m.marioObj, s.modelId)
    end

    if m.playerIndex == 0 then
        mario_update_local(m)
    end
    taunt_effect_particle(m)
    speed_particles(m)
end

hook_event(HOOK_MARIO_UPDATE, mario_update)

--- @param m MarioState
local on_set_mario_action = function(m)
    local p = gPeppinoStates[m.playerIndex]
    local grabMinSpeed = lerp(MACH_1_SPEED_MIN, MACH_2_SPEED_MIN, 0.52)

    if m.pos.y - m.floorHeight > 0 then
        steepFloor = m.prevAction == ACT_STEEP_JUMP
    else
        steepFloor = mario_floor_is_steep(m) ~= 0 and mario_floor_is_slippery(m) ~= 0
    end

    if not gSuperJumpCharge[m.action] then
        audio_sample_stop(SOUND_SUP_JUMP_HOLD)
        audio_sample_stop(SOUND_SUP_JUMP_PREP)
    elseif not gSuperJumpCharge[m.prevAction] and p.machLevel >= 2 and _G.pcCharacter == "Peppino" then
        run_audio(SOUND_SUP_JUMP_PREP, m, 1.65)
        if m.playerIndex == 0 then
            superJumpSoundTimer = 14
        end
    end

    if gSuperJumpCharge[m.prevAction] and p.machLevel >= 2 then
        if (m.input & INPUT_A_PRESSED) ~= 0 then
            set_mario_action(m, ACT_SUPER_JUMP, 0)
        end
    end

    if m.action == ACT_SUPER_JUMP then
        white_flash(m)
        set_mario_particle_flags(m, (PARTICLE_HORIZONTAL_STAR | PARTICLE_MIST_CIRCLE), 0)
        if m.playerIndex == 0 then
            set_camera_shake_from_hit(SHAKE_GROUND_POUND)
        end
        play_sound(SOUND_ACTION_FLYING_FAST, m.marioObj.header.gfx.cameraToObject)
        run_audio(SOUND_SUP_JUMP, m, 1.075)
    end

    if m.action == ACT_GROUND_GRAB then
        play_sound(SOUND_OBJ_UNKNOWN4, m.marioObj.header.gfx.cameraToObject)
        run_audio(SOUND_GRAB_DASH, m, 0.65)

        m.vel.y = 0
        if prevForwardVel <= grabMinSpeed then
            mario_set_forward_vel(m, grabMinSpeed)
        else
            mario_set_forward_vel(m, prevForwardVel)
        end
    end

    if m.action == ACT_AIR_GRAB and m.prevAction ~= ACT_GROUND_GRAB then
        play_sound(SOUND_OBJ_UNKNOWN4, m.marioObj.header.gfx.cameraToObject)
        run_audio(SOUND_GRAB_DASH, m, 0.65)

        m.vel.y = prevYVel
        if prevForwardVel <= grabMinSpeed then
            mario_set_forward_vel(m, grabMinSpeed)
        else
            mario_set_forward_vel(m, prevForwardVel)
        end
    end

    if m.action == ACT_SPIN_ATTACK then
        m.vel.y = prevYVel
    end

    if m.action == ACT_WATER_GRAB then
        play_sound(SOUND_OBJ_UNKNOWN4, m.marioObj.header.gfx.cameraToObject)
        run_audio(SOUND_GRAB_DASH, m, 0.65)

        if prevForwardVel <= grabMinSpeed then
            m.forwardVel = grabMinSpeed
        else
            m.forwardVel = prevForwardVel
        end
    end

    if m.action == ACT_UPPERCUT then
        run_audio(SOUND_UPPERCUT, m, 0.8)
        m.vel.y = 46
    end

    if m.action == ACT_SUPER_JUMP_CANCEL then
        airForwardVel = MACH_2_SPEED_MIN
        run_audio(SOUND_SUP_JUMP_CANCEL, m, 1.5)
    end

    if m.action == ACT_BELLY_DASH and m.forwardVel < MACH_2_SPEED_MIN + 10 then
        mario_set_forward_vel(m, MACH_2_SPEED_MIN + 10)
    end

    if m.action == ACT_PARRY or m.action == ACT_WATER_PARRY then
        -- need some way to reset the anim so that it doesnt look weird when you hit things with the grab and get the first punch animation
        -- and no setting the animation frame to 0 doesnt work for some reason thanks a lot sm64
        set_mario_animation(m, MARIO_ANIM_A_POSE)
        if m.actionArg == 0 then
            white_flash(m)
        end
    end

    if m.action == ACT_DOLPHIN_JUMP then
        m.marioObj.header.gfx.angle.x = -0x8000
        m.faceAngle.x = -0x8000
        m.vel.y = 58 + m.forwardVel * 0.25
        run_audio(SOUND_JUMP, m, 2.65)
    end

    if _G.pcCharacter ~= "Mario" then
        if m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP then
            run_audio(SOUND_JUMP, m, 2.65)
            m.forwardVel = prevForwardVel
            if p.machLevel == 2 then
                m.actionState = 1
            elseif p.machLevel == 3 then
                m.actionState = 2
            end
        elseif m.action == ACT_LONG_JUMP then
            run_audio(SOUND_JUMP, m, 2.65)
            airForwardVel = math.max(prevForwardVel, grabMinSpeed + 5)
            m.vel.y = m.vel.y + m.forwardVel * 0.085
        end

        if m.action == ACT_TRIPLE_JUMP then
            m.vel.y = 69 + m.forwardVel * 0.25
        end

        if m.action == ACT_SIDE_FLIP or m.action == ACT_WALL_KICK_AIR or m.action == ACT_STEEP_JUMP then
            run_audio(SOUND_JUMP, m, 2.65)
        end

        if m.action == ACT_FREEFALL then
            if p.machLevel == 2 then
                m.actionState = 1
            elseif p.machLevel == 3 then
                m.actionState = 2
            end
        end

        -- this is so that bowser actually gets launched
        if m.action == ACT_THROW_ATTACK then
            m.actionArg = math.random(0, 1)
            m.marioObj.header.gfx.animInfo.animFrame = 0
            m.angleVel.y = 0x1A00
        elseif m.action == ACT_START_CROUCHING or m.action == ACT_CROUCH_SLIDE then
            m.angleVel.y = 0x600
        end

        if m.action == ACT_GROUND_POUND then
            if _G.pcCharacter == "Peppino" then
                m.marioObj.header.gfx.angle.x = -0x8000
                m.faceAngle.x = -0x8000
                m.vel.y = 46
                m.angleVel.y = 0x600 -- same as above
            else
                m.vel.y = -80
            end
        end

        if (m.action == ACT_FINISH_TURNING_AROUND or m.action == ACT_WALKING) and m.prevAction == ACT_TURNING_AROUND then
            if p.machLevel == 1 then
                m.forwardVel = MACH_1_SPEED_MIN + 2
            elseif p.machLevel >= 2 then
                m.forwardVel = MACH_2_SPEED_MIN + 2
            end
        end

        if (m.action == ACT_TURNING_AROUND or m.action == ACT_BRAKING) and m.forwardVel > MACH_3_SPEED_MIN + 12 then
            m.forwardVel = MACH_3_SPEED_MIN + 12
        end

        if m.action == ACT_WATER_PLUNGE then
            m.faceAngle.x = atan2s(m.forwardVel * 4, m.vel.y)
            m.forwardVel = m.forwardVel * 4 + math.abs(m.vel.y)
            m.actionTimer = 21
        end

        if m.action == ACT_HURT or m.action == ACT_WATER_HURT then
            hurtCounter = hurtCounter + 1
            white_flash(m)
            run_audio(SOUND_HURT, m, 2)
            m.vel.y = 64
            if m.interactObj ~= nil then
                local angleToObject = mario_obj_angle_to_object(m, m.interactObj)

                if angleToObject - m.faceAngle.y >= -0x4000 and angleToObject - m.faceAngle.y <= 0x4000 then
                    m.actionArg = 1
                else
                    m.actionArg = 2
                end
            else
                m.actionArg = 1
            end
        end

        if m.action == ACT_FLYING then
            m.faceAngle.x = 0
            m.angleVel.y = 0
        end

        if gHurtActions[m.action] and
        not gHurtActions[m.prevAction] and m.playerIndex == 0 and (m.flags & MARIO_METAL_CAP) == 0 then
            hurtCounter = hurtCounter + 1
            white_flash(m)
            if m.action ~= ACT_LAVA_BOOST then
                run_audio(SOUND_HURT, m, 2)
            end
        end
    end

    if m.action == ACT_BRICK_AIR then
        if m.actionArg == 0 then
            m.vel.y = 46 + m.forwardVel * 0.25
        end
    end
end

hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)

--- @param m MarioState
local before_set_mario_action = function(m, incomingAct)
    local p = gPeppinoStates[m.playerIndex]
    local steepFloor
    local endAct

    if _G.pcCharacter == "Mario" then
        return
    end

    if m.pos.y - m.floorHeight > 0 then
        steepFloor = m.action == ACT_STEEP_JUMP
    else
        steepFloor = mario_floor_is_steep(m) ~= 0 and mario_floor_is_slippery(m) ~= 0
    end

    if _G.pcCharacter == "Peppino" then
        if gReplaceWithGrabActions[incomingAct] and not steepFloor then
            if m.pos.y - m.floorHeight > 18 then
                endAct = ACT_AIR_GRAB
            else
                endAct = ACT_GROUND_GRAB
            end
        end

        if gReplaceWithNormalJumpActions[incomingAct] or (incomingAct == ACT_LONG_JUMP and m.action ~= ACT_GROUND_GRAB) then
            endAct = ACT_JUMP
        end

        if m.forwardVel >= MACH_1_SPEED_MIN then
            if (incomingAct == ACT_AIR_HIT_WALL and m.wall ~= nil) then
                m.vel.y = m.forwardVel + m.vel.y / 4
                endAct = ACT_WALL_RUN
            elseif incomingAct == ACT_GROUND_POUND and m.action ~= ACT_COMET_DIVE then
                m.vel.y = -80
                endAct = ACT_COMET_DIVE
            elseif incomingAct == ACT_FREEFALL and (m.action == ACT_BRAKING or m.action == ACT_TURNING_AROUND) then
                endAct = ACT_AIR_TURNING
            elseif incomingAct == ACT_LEDGE_GRAB and m.intendedMag >= 30 then
                endAct = ACT_WALKING
            end
        end

        if incomingAct == ACT_SLIDE_KICK or (incomingAct == ACT_BEGIN_SLIDING and mario_facing_downhill(m, 0) ~= 0) or incomingAct == ACT_BUTT_SLIDE then
            mario_set_forward_vel(m, prevForwardVel)
            endAct = ACT_ROLL
        end
    elseif _G.pcCharacter == "Gustavo" then
        if gReplaceWithGrabActions[incomingAct] and not steepFloor then
            endAct = ACT_SPIN_ATTACK
        end

        if incomingAct == ACT_LONG_JUMP then
            endAct = ACT_JUMP
        end
    end

    if incomingAct == ACT_STEEP_JUMP then
        endAct = ACT_JUMP
    end

    if m.action == ACT_WATER_PLUNGE then
        endAct = ACT_PEPPINO_SWIM
    end

    if incomingAct == ACT_WATER_ACTION_END or incomingAct == ACT_WATER_IDLE or incomingAct == ACT_BREASTSTROKE then
        endAct = ACT_PEPPINO_WATER_IDLE
    end

    if gHurtActionWithArg[incomingAct] and m.hurtCounter > 0 and m.health >= 0x100 then
        if m.pos.y + m.vel.y > m.waterLevel - 80 then
            endAct = ACT_HURT
        else
            endAct = ACT_WATER_HURT
        end
    end

    if incomingAct == ACT_BURNING_FALL or incomingAct == ACT_BURNING_JUMP or incomingAct == ACT_BURNING_GROUND then
        if (m.flags & MARIO_METAL_CAP) == 0 then
            local damage = 2
            if (m.flags & MARIO_CAP_ON_HEAD) == 0 then
                damage = 3
            end
            m.hurtCounter = m.hurtCounter + damage * 4
        end
        endAct = ACT_LAVA_BOOST
    end

    if incomingAct == ACT_THROWING or incomingAct == ACT_AIR_THROW then
        endAct = ACT_THROW_ATTACK
    end

    if (incomingAct == ACT_BACKWARD_AIR_KB or incomingAct == ACT_SOFT_BONK or incomingAct == ACT_GROUND_BONK or incomingAct == ACT_BACKWARD_GROUND_KB) and
    m.wall ~= nil and (m.forwardVel >= MACH_1_SPEED_MIN or p.machLevel >= 1) and m.action ~= ACT_WALKING then
        endAct = ACT_WALL_CRASH
    end

    return endAct
end

hook_event(HOOK_BEFORE_SET_MARIO_ACTION, before_set_mario_action)

---@param m MarioState
---@param o Object
local on_interact = function(m, o, intType)
    local p = gPeppinoStates[m.playerIndex]
    local damagingTypes = (INTERACT_BOUNCE_TOP | INTERACT_BOUNCE_TOP2 | INTERACT_HIT_FROM_BELOW | INTERACT_MR_BLIZZARD | INTERACT_KOOPA | INTERACT_DAMAGE |
    INTERACT_SNUFIT_BULLET | INTERACT_FLAME | INTERACT_SHOCK | INTERACT_CLAM_OR_BUBBA | INTERACT_BULLY)
    local damagableTypes = (INTERACT_BOUNCE_TOP | INTERACT_BOUNCE_TOP2 | INTERACT_HIT_FROM_BELOW | 2097152 | INTERACT_KOOPA | INTERACT_BREAKABLE |
    INTERACT_BULLY)
    local flinch = false

    if _G.pcCharacter == "Mario" then
        return
    end

    -- parry
    if (intType & damagingTypes) ~= 0 and (m.action == ACT_TAUNT or m.action == ACT_WATER_TAUNT) then
        m.interactObj = o
        m.faceAngle.y = mario_obj_angle_to_object(m, m.interactObj)
        -- since I cant make the bully flinch backwards through here, we make the bully ignore the attack and mario not go backwards due to the parry
        -- this way, i make the parrying action itself knock the bully
        if (intType & INTERACT_BULLY) == 0 then
            o.oInteractStatus = ATTACK_KICK_OR_TRIP + (INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED)
            flinch = true
        end
        parry_attack(m, flinch)
        return false
    end

    if m.action == ACT_AIR_GRAB or m.action == ACT_GROUND_GRAB or (m.action == ACT_LONG_JUMP and m.actionTimer <= 4) or m.action == ACT_WATER_GRAB then
        -- grab
        if (intType & (INTERACT_GRABBABLE) ~= 0) and o.oInteractionSubtype & (INT_SUBTYPE_NOT_GRABBABLE) == 0 then
            m.interactObj = o
            m.input = m.input | INPUT_INTERACT_OBJ_GRABBABLE
            if o.oSyncID ~= 0 then
                network_send_object(o, true)
            end
        elseif (intType & damagableTypes) ~= 0 then
            -- i know you dont "parry", you punch with this but this way you dont get launched to brazil by punching something, it plays an attack animation
            -- like in the original game and i dont have to code another action for that so shut up and pretend you saw nothing
            if (m.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
                set_mario_action(m, ACT_PARRY, 1)
            else
                set_mario_action(m, ACT_WATER_PARRY, 1)
            end
            play_character_sound(m, CHAR_SOUND_YAH_WAH_HOO)
            m.vel.y = 32
            m.actionTimer = math.random(0, 3)
        end
        return true
    end

    -- damage stuff if running
    if (intType & damagableTypes) ~= 0 and p.machLevel >= 2 then
        o.oInteractStatus = ATTACK_PUNCH + (INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED)
        play_sound(SOUND_ACTION_HIT, m.marioObj.header.gfx.cameraToObject)
        return false
    end

    if intType & INTERACT_BREAKABLE and m.action == ACT_SPIN_ATTACK then
        o.oInteractStatus = ATTACK_PUNCH + (INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED)
    end

    -- do not kill stuff if you stomp them
    if intType & (INTERACT_BOUNCE_TOP | INTERACT_BOUNCE_TOP2) ~= 0 and m.pos.y > o.oPosY and m.vel.y < 0 and
    (m.action ~= ACT_GROUND_POUND and m.action ~= ACT_PILEDRIVER) and _G.pcCharacter == "Peppino" then
        if (o.oInteractionSubtype & INT_SUBTYPE_TWIRL_BOUNCE) ~= 0 then
            m.vel.y = 80
            m.faceAngle.x = 0
            play_character_sound(m, CHAR_SOUND_TWIRL_BOUNCE)
            drop_and_set_mario_action(m, ACT_TWIRLING, 0)
        else
            m.vel.y = 30
        end
        m.pos.y = o.oPosY + o.hitboxHeight
        m.flags = m.flags & ~MARIO_UNKNOWN_08
        play_sound(SOUND_ACTION_BOUNCE_OFF_OBJECT, m.marioObj.header.gfx.cameraToObject)
        return false
    end

    -- play a voice clip when you collet a red or blue coin
    if (intType == INTERACT_COIN and (o.oDamageOrCoinValue > 1 or math.fmod(m.numCoins + o.oDamageOrCoinValue, 50) == 0)) and math.random(0, 100) <= 50 and
    charVoice then
        local randomNum = math.random(0, 100)
        stop_voice(m)

        if _G.pcCharacter == "Peppino" then
            if randomNum < 33 then
                run_audio(VOICE_SHUSH, m, 1.2)
            elseif randomNum < 67 then
                run_audio(VOICE_PARANOID1, m, 1.2)
            else
                run_audio(VOICE_PARANOID2, m, 1.2)
            end
        end
    end
end

hook_event(HOOK_ALLOW_INTERACT, on_interact)

hook_event(HOOK_BEFORE_MARIO_UPDATE, function(m)
    if m.playerIndex ~= 0 then
        return
    end

    if openedMenu then
        configInput = m.controller.buttonPressed
        m.controller.buttonPressed = 0
        m.controller.stickX = 0
        m.controller.stickY = 0
        m.controller.stickMag = 0

        if stickCooldown > 0 then
            stickCooldown = stickCooldown - 1
        else
            if m.controller.rawStickY > 18 then
                configInput = configInput | U_JPAD
                stickCooldown = 4
            elseif m.controller.rawStickY < -18 then
                configInput = configInput | D_JPAD
                stickCooldown = 4
            end

            if m.controller.rawStickX > 18 then
                configInput = configInput | L_JPAD
                stickCooldown = 4
            elseif m.controller.rawStickX < -18 then
                configInput = configInput | R_JPAD
                stickCooldown = 4
            end
        end
    else
        configInput = 0
    end
end)

hook_event(HOOK_ALLOW_PVP_ATTACK, function(att, vic)
    if vic.action == ACT_TAUNT or vic.action == ACT_WATER_TAUNT or gPlayerSyncTable[vic.playerIndex].tauntTimer > 0 then
        vic.interactObj = att.marioObj
        if vic.playerIndex == 0 then
            parry_attack(vic, true)
            network_send(true, {
                attPlayer = network_global_index_from_local(att.playerIndex),
                vicPlayer = network_global_index_from_local(vic.playerIndex)
            })
        end
        return false
    end
end)

hook_event(HOOK_ON_PVP_ATTACK, function(att, vic)
    -- putting this on the ALLOW_INTERACT hook did work, but the victim just doesnt get hit so thats why this is here
    if att.action == ACT_AIR_GRAB or att.action == ACT_GROUND_GRAB or att.action == ACT_WATER_GRAB then
        if (att.action & ACT_GROUP_MASK) ~= ACT_GROUP_SUBMERGED then
            set_mario_action(att, ACT_PARRY, 1)
        else
            set_mario_action(att, ACT_WATER_PARRY, 1)
        end
        play_character_sound(att, CHAR_SOUND_YAH_WAH_HOO)
        att.vel.y = 32
        att.actionTimer = math.random(0, 3)
    end
end)

hook_event(HOOK_ON_PACKET_RECEIVE, function(table)
    local vic = gMarioStates[network_local_index_from_global(table.vicPlayer)]
    local att = gMarioStates[network_local_index_from_global(table.attPlayer)]
    local kbMult = 1
    local damage = 0
    local vel = {forward = -25, y = 35}

    if att.playerIndex == 0 then
        if (vic.flags & MARIO_METAL_CAP) ~= 0 then
            kbMult = kbMult * 1.25
        end
        if (att.flags & MARIO_METAL_CAP) ~= 0 then
            kbMult = math.max(1, kbMult * 0.5)
        end

        att.faceAngle.y = mario_obj_angle_to_object(att, vic.marioObj)

        if gServerSettings.playerInteractions == PLAYER_INTERACTIONS_PVP then
            damage = 2 * 4
        end

        if att.health - damage * 0x40 < 0x100 then
            vel = {forward = -50, y = 60}
            hurt_and_set_mario_action(att, ACT_HARD_BACKWARD_AIR_KB, 0, damage)
        else
            hurt_and_set_mario_action(att, ACT_BACKWARD_AIR_KB, 0, damage)
        end

        -- this is divided by 25 as thats the value playerKnockbackStrength takes when set to Normal
        mario_set_forward_vel(att, (vel.forward / 25) * kbMult * gServerSettings.playerKnockbackStrength)
        att.vel.y = (vel.y / 25) * gServerSettings.playerKnockbackStrength
        att.knockbackTimer = 10
    end
end)

hook_event(HOOK_UPDATE, function()
    modGlobalTimer = modGlobalTimer + 1
    if modGlobalTimer > 12 then
        modGlobalTimer = 0
    end
end)

hook_event(HOOK_ON_LEVEL_INIT, function()
    gPlayerSyncTable[0].tauntTimer = 0
    hurtCounter = 0
    prevHurtCounter = 0
    textShowTimer = 0
    transparency = 0
end)

hook_event(HOOK_ON_HUD_RENDER, function()
    local m = gMarioStates[0]

    if _G.pcCharacter == "Mario" or
    (obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil or (m.action == ACT_END_PEACH_CUTSCENE or m.action == ACT_CREDITS_CUTSCENE
    or m.action == ACT_END_WAVING_CUTSCENE)) or openedMenu then
        hudGeneralTransparencyMult = approach_f32(hudGeneralTransparencyMult, 0, 0.06, 0.06)
    else
        hudGeneralTransparencyMult = approach_f32(hudGeneralTransparencyMult, 1, 0.1, 0.1)
    end

    config_menu()

    speed_meter()
    hurt_text()
end)

hook_event(HOOK_CHARACTER_SOUND, function(m, sound)
    if charVoice then
        if _G.pcCharacter == "Peppino" then
            if sound == CHAR_SOUND_OOOF or sound == CHAR_SOUND_OOOF2 then
                if math.random(0, 100) <= 50 then
                    stop_voice(m)
                    run_audio(VOICE_FUCK, m, 1.2)
                end
            elseif sound == CHAR_SOUND_ON_FIRE or sound == CHAR_SOUND_WAAAOOOW then
                stop_voice(m)
                run_audio(VOICE_SCREAM, m, 1.2)
            elseif sound == CHAR_SOUND_ATTACKED and (m.action ~= ACT_SHOCKED and m.action ~= ACT_WATER_SHOCKED) then
                if math.random(0, 100) <= 50 then
                    stop_voice(m)
                    if math.random(0, 100) <= 50 then
                        run_audio(VOICE_HURT1, m, 1.2)
                    else
                        run_audio(VOICE_HURT2, m, 1.2)
                    end
                end
            elseif sound == CHAR_SOUND_SO_LONGA_BOWSER then
                stop_voice(m)
                run_audio(VOICE_ANGRY_SCREAM, m, 1)
            end
        end

        return 0
    end
end)

------------------------ CHAT COMMANDS / SQUISHY'S SERVER ------------------------

local on_config_command = function(msg)
    local m = gMarioStates[0]

    play_sound(SOUND_MENU_HAND_APPEAR, m.marioObj.header.gfx.cameraToObject)
    openedMenu = true
    return true
end

local on_help_command = function(msg)
    djui_chat_message_create("A | Uppercut (in midair), Long Jump (while grabbing), Super Jump (while charging it), Dive Drop (while diving), Swim Upwards (in water), Dolphin Jump (at the water's surface)")
    djui_chat_message_create("B | Grab, Super Jump Cancel, Spinning Throw (holding the button as you grab something at Mach 2 or beyond), Fly (while grabbing in the air with the Wing Cap), Roll (while crouching)")
    djui_chat_message_create("Z | Body Slam (in midair and below Mach 1), Dive (in midair and at Mach 1 or beyond), Super Jump Charge (at Mach 2 or beyond), Piledrive (in midair while throwing), Belly Slide (while grabbing), Swim Downwards (in water)")
    djui_chat_message_create("X | Toggle mach running")
    djui_chat_message_create("Y | Taunt (also allows parrying!)")

    return true
end



local ss_update = function()
    if not _G.ssBooted then return end
    -- Check if the status of the Toggle was changed, and set it back to 0
    if _G.ssApi.option_read("Pasta Castle Menu") == 1 then
        on_config_command()
        _G.ssApi.menu_open(false)
        _G.ssApi.option_write("Pasta Castle Menu", 0)
    end 
end

if _G.ssExists then
    _G.ssApi.option_add("Pasta Castle Menu", 0, 1, {[0] = "", [1] = ""}, {
        "Allows you to play as Peppino",
        "Spaghetti and Gustavo and Brick",
        "(the rat) from Pizza Tower! Run",
        "up to Mach 3! Super Jump all over",
        "the map! Style on your enemies",
        "with Y! Kick your friendly rat",
        "around! and more!",
    })

    hook_event(HOOK_MARIO_UPDATE, ss_update)
else
    hook_chat_command('pc_config', '[no arguments needed] Opens a menu to configurate Pasta Castle', on_config_command)
    hook_chat_command('pep_help', '[no arguments needed] Tells a basic rundown of what buttons do what', on_help_command)
end
