------- TABLES -------

gPeppinoStates = {}

for i = 0, MAX_PLAYERS - 1 do
    gPeppinoStates[i] = {}
    local p = gPeppinoStates[i]
    local s = gPlayerSyncTable[i]

    p.machLevel = 0
    p.squishIntensity = 0
    p.particleFlags = 0
    p.poseIndex = 1
    p.spawnedBoombox = false
    p.spawnedTauntEffect = false
    p.brickObj = nil

    s.tauntTimer = 0
end

gPoseIndexes = {
    -- animation                 frame  offset
    {MARIO_ANIM_STAR_DANCE,       50,    50},
    {MARIO_ANIM_SLEEP_LYING,      2,    -40},
    {MARIO_ANIM_SINGLE_JUMP,      12,     0},
    {MARIO_ANIM_MISSING_CAP,      130,    0},
    {MARIO_ANIM_TRIPLE_JUMP_LAND, 16,     0},
    {MARIO_ANIM_A_POSE,           0,      0},
    {"MARIO_ANIM_TAUNT",          0,      0}, -- "Thumbs up" pose
    {"MARIO_ANIM_TAUNT",          1,      0}, -- Looking back at the camera
    {"MARIO_ANIM_TAUNT",          2,      0}, -- Flexing
    {"MARIO_ANIM_TAUNT",          3,      0}, -- Grabbing cap
    {"MARIO_ANIM_TAUNT",          4,      0}, -- Daffy Duck pose
    {"MARIO_ANIM_TAUNT",          5,      0}, -- SA2's box art
    {"MARIO_ANIM_TAUNT",          6,      0}, -- peter
    {"MARIO_ANIM_TAUNT",          7,      0}, -- LARIO
    {"MARIO_ANIM_TAUNT",          8,      0}, -- SMS's box art
    {"MARIO_ANIM_TAUNT",          9,      0}, -- SM64's box art
}

gLandActions = {
    [ACT_JUMP_LAND] = true,
    [ACT_DOUBLE_JUMP_LAND] = true,
    [ACT_TRIPLE_JUMP_LAND] = true,
    [ACT_SIDE_FLIP_LAND] = true,
    [ACT_BACKFLIP_LAND] = true,
    [ACT_FREEFALL_LAND] = true,
    [ACT_LONG_JUMP_LAND] = true,
    [ACT_AIR_THROW_LAND] = true,
    [ACT_QUICKSAND_JUMP_LAND] = true,
    [ACT_JUMP_LAND_STOP] = true,
    [ACT_DOUBLE_JUMP_LAND_STOP] = true,
    [ACT_TRIPLE_JUMP_LAND_STOP] = true,
    [ACT_SIDE_FLIP_LAND_STOP] = true,
    [ACT_BACKFLIP_LAND_STOP] = true,
    [ACT_FREEFALL_LAND_STOP] = true,
    [ACT_LONG_JUMP_LAND_STOP] = true,
}

------- VARIABLES -------

if mod_storage_load("Character") == nil then
    _G.pcCharacter = "Peppino"
else
    _G.pcCharacter = mod_storage_load("Character")
end

sprintMode = true
sprintModeIntendedState = true
tauntStaleCount = -2
tauntCooldown = 0

gamemode = false

for i in pairs(gActiveMods) do
    if (gActiveMods[i].incompatible ~= nil and gActiveMods[i].incompatible:find("gamemode")) then
        gamemode = true
    end
end

------- CONSTANTS -------

MACH_1_SPEED_MIN = 34
MACH_2_SPEED_MIN = 62
MACH_3_SPEED_MIN = 87

SUPER_JUMP_MAX_DURATION = gamemode and 0.5 * 30 or 1.1 * 30
GRAB_MAX_DURATION = 0.4 * 30
BELLY_DASH_DURATION = 0.6 * 30

SOUND_SUP_JUMP = audio_sample_load("superjump.mp3")
SOUND_SUP_JUMP_CANCEL = audio_sample_load("superjumpcancel.mp3")

SOUND_GRAB_DASH = audio_sample_load("grabdash.mp3")

SOUND_DANCE_START = audio_sample_load("dancestart.mp3")

-- Brick actions work a bit differently than normal, as actions are not split into various versions
-- (say, jump and triple jump are on the same action where normaly they're different)
-- so we use m.actionArg to create a "sub action" sort of system

WALKING_SUBACT = 0
SKID_SUBACT = 1

JUMP_SUBACT = 0
DOUBLE_JUMP_SUBACT = 1
TRIPLE_JUMP_SUBACT = 2
FREEFALL_SUBACT = 3

BRICK_ACT_INACTIVE = 0
BRICK_ACT_RETURN = 1
BRICK_ACT_MOUNTED = 2

------- GENERAL FUNCTIONS -------

s16 = function(x)
    x = (math.floor(x) & 0xFFFF)
    if x >= 32768 then return x - 65536 end
    return x
end

clamp = function(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

lerp = function(min, max, p)
    return min + (max - min) * clamp(p, 0, 1)
end

ease_in_out_quad = function(t)
    if t < 0.5 then
        return 2 * t * t
    end
    t = t - 0.5
    return 2 * t * (1 - t) + 0.5
end

ease_out_quad = function(t)
    t = t - 0.5
    return 2 * t * (1 - t) + 0.5
end

deg_to_hex = function(x)
    return x * 0x10000 / 360
end

hex_to_deg = function(x)
    return x * 360 / 0x10000
end

run_audio = function(sound, mState, volume)
    audio_sample_play(sound, mState.marioObj.header.gfx.pos, volume)
end

---@param m MarioState
mario_roll_anim = function(m, accel)
    local mGfx = m.marioObj.header.gfx
    local initialPitch = m.faceAngle.x
    local offset = 60

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING)
    set_anim_to_frame(m, 0)

    if accel == nil then
        accel = 0x10000
    end

    if m.playerIndex == 0 then
        m.faceAngle.x = m.faceAngle.x + deg_to_hex(360 / mGfx.animInfo.curAnim.loopEnd) * (accel / 0x10000)
    end

    mGfx.angle.x = m.faceAngle.x - deg_to_hex(360 / mGfx.animInfo.curAnim.loopEnd)

    mGfx.pos.x = m.pos.x + offset * sins(m.faceAngle.y) * coss(m.faceAngle.x + deg_to_hex(90))
    mGfx.pos.y = m.pos.y + -offset * sins(m.faceAngle.x + deg_to_hex(90))
    mGfx.pos.z = m.pos.z + offset * coss(m.faceAngle.y) * coss(m.faceAngle.x + deg_to_hex(90))

    mGfx.pos.y = mGfx.pos.y + 55

    mGfx.disableAutomaticShadowPos = true
    vec3f_copy(mGfx.shadowPos, m.pos)

    if initialPitch > m.faceAngle.x + deg_to_hex(180) then
        return true
    end

    return false
end

---@param m MarioState
correct_water_pitch = function(m)
    local mGfx = m.marioObj.header.gfx

    if mGfx.angle.x ~= 0 then
        mGfx.pos.y = mGfx.pos.y + 60 * sins(mGfx.angle.x) ^ 2
    end
end

---@param m MarioState
set_custom_anim = function(m, anim, accel, notResetAnim)
    if accel == nil then
        accel = 0x10000
    end

    m.marioObj.header.gfx.animInfo.animAccel = accel

    if (smlua_anim_util_get_current_animation_name(m.marioObj) ~= anim or m.marioObj.header.gfx.animInfo.animID ~= -1) and not notResetAnim then
        if anim == "MARIO_ANIM_GRAB" or anim == "MARIO_ANIM_AIR_GRAB" then
            set_anim_to_frame(m, 1)
        else
            set_anim_to_frame(m, 0)
        end
    end

    -- jank may occur without this line
    m.marioObj.header.gfx.animInfo.animID = -1

    smlua_anim_util_set_animation(m.marioObj, anim)
end

---@param m MarioState
set_mario_anim_hold = function(m, normalAnim, holdAnim, accel)
    if accel == nil then
        accel = 0x10000
    end

    if m.heldObj == nil then
        set_mario_anim_with_accel(m, normalAnim, accel)
    else
        set_mario_anim_with_accel(m, holdAnim, accel)
    end
end
