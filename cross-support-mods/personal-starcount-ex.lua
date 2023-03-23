-- name: [SS] PSCEX+ Star Handler
-- description: \\#FFFF00\\Personal Star Counter EX+\nStar Handler \\#dcdcdc\\- \\#008800\\Squishy's Server\n\n\\#dcdcdc\\See how many stars you collect!\nIdea by Mr.Needlemouse, created by Sunk, Modified by Demnyx.\n\n\\#FF0000\\Note: This mod uses Squishy's Server as a Library, and can't function without it.
if mod_storage_load("StarCounter") == nil then
	mod_storage_save("StarCounter", "0")
end

_G.TotalStarCounter = tonumber(mod_storage_load("StarCounter"))
_G.StarCounter = 0
local prevNumStars = 0

---@param m MarioState
--Increments an independent counter if a star is collected.
function localStarCounter(m, o, type)
    if (m.playerIndex == 0) and (type == INTERACT_STAR_OR_KEY) then
        --This ensures that it increments ONLY if a star is collected.
        if get_id_from_behavior(o.behavior) ~= id_bhvBowserKey then
            --The hook happens after the star count increments, so this allows the independent counter to increment ONLY when YELLOW star is collected.
            if m.numStars ~= prevNumStars then
                _G.StarCounter = _G.StarCounter + 1
				_G.TotalStarCounter = _G.TotalStarCounter + 1
				mod_storage_save("StarCounter", tostring(TotalStarCounter))
            end
        end
    end
end

hook_event(HOOK_ON_INTERACT, localStarCounter)