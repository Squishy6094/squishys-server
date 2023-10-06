local string_format = string.format
local table_insert = table.insert
local is_game_paused = is_game_paused
local djui_hud_set_color = djui_hud_set_color
local math_floor = math.floor

--General Untilities

---@param s string
function string_split(s)
    local result = {}
    for match in (s):gmatch(string_format("[^%s]+", " ")) do
        table_insert(result, match)
    end
    return result
end

function math_clamp(val, beginning, ending)
    if val < beginning then return beginning end
    if val > ending then return ending end
    return val
end

---@param r number
---@param g number
---@param b number
---@param a number
function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

function s16(num)
    num = math_floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
end

---@param input any
---@return boolean
function tobool(input)
    return input and (input == "true" or input >= 1)
end

---@param input any
---@return integer
function tointeger(input)
    return tobool(input) and 1 or 0
end

---@param m MarioState
function nullify_inputs(m)
     m.controller.rawStickY = 0 
     m.controller.rawStickX = 0 
     m.controller.stickX = 0 
     m.controller.stickY = 0 
     m.controller.stickMag = 0 
     m.controller.buttonPressed = 0 
     m.controller.buttonDown = 0
end

---@param compare_object Object
---@param behavior_id_table BehaviorId[]
---@return Object[]
function obj_get_nearest_objects_from_set(compare_object, behavior_id_table)
    local found_object_table = {}
    for _, value in ipairs(behavior_id_table) do
        table_insert(found_object_table, obj_get_nearest_object_with_behavior_id(compare_object, value))
    end
    return found_object_table
end

function string_without_hex(string)
    local s = ''
    local inSlash = false
    for i = 1, #string do
        local c = string:sub(i,i)
        if c == '\\' then
            inSlash = not inSlash
        elseif not inSlash then
            s = s .. c
        end
    end
    return s
end

function string_without_line_skip(string)
    local s = ''
    for i = 1, #string do
        local c = string:sub(i,i)
        if c ~= '\n' then
            s = s .. c
        end
    end
    return s
end