--General Untilities
function split(s)
    local result = {}
    for match in (s):gmatch(string.format("[^%s]+", " ")) do
        table.insert(result, match)
    end
    return result
end

function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

function s16(num)
    num = math.floor(num) & 0xFFFF
    if num >= 32768 then return num - 65536 end
    return num
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

function tobool(input)
    if input == "true" or tonumber(input) >= 1 then
        return true
    else
        return false
    end
end

function tointeger(input)
    if tobool(input) then
        return 1
    else
        return 0
    end
end

function nullify_inputs(m)
    m.controller.rawStickY = 0
    m.controller.rawStickX = 0
    m.controller.stickX = 0
    m.controller.stickY = 0
    m.controller.stickMag = 0
    m.controller.buttonPressed = m.controller.buttonPressed & ~R_TRIG
    m.controller.buttonDown = m.controller.buttonDown & ~R_TRIG
    m.controller.buttonPressed = m.controller.buttonPressed & ~A_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~A_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~B_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~B_BUTTON
    m.controller.buttonPressed = m.controller.buttonPressed & ~START_BUTTON
    m.controller.buttonDown = m.controller.buttonDown & ~START_BUTTON
end