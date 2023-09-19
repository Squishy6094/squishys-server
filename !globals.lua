---- Globals
BOOTUP_INITALIZING = 0
BOOTUP_RELOADING = 1
BOOTUP_LOADED_CUSTOM_HUD_DATA = 2
BOOTUP_LOADED_MENU_DATA = 3
BOOTUP_FINISHED_MENU_SETUP = 4
BOOTUP_LOADED_THEME_DATA = 5
BOOTUP_LOADED_NAME_2_MODEL_DATA = 6

---- Other

-- ChatGPT code
-- Don't worry though as I looked through and understand what it's actually doing

----------------

local table_concat = table.concat
local cache = {}

-- Memoization is the process of caching the return value on functions.<br>
-- When the same input parameters are given, the return the cached output value.<br>
-- !!! Because of this, memoization does NOT work with functions that have side effects.
---@param func function
---@return function
function memoize(func)
    return (function(...)
        -- Store args and convert it to a string to be cached
        local args = {...}
        local key = table_concat(args, ',')

        -- If it has already been cached, simply return the value
        if cache[key] then
            return cache[key]
        else -- Otherwise, run the function
            local result = func(...)

            -- Cache the result for future use
            cache[key] = result

            return result
        end
    end)
end

----------------
