-- name: [SS] Radar Handler
-- description: \\#FFdcdc\\Red Coin Radar \nRadar Handler \\#dcdcdc\\- \\#008800\\Squishy's Server\n\n\\#dcdcdc\\Shows how close you are to the nearest red coin or secret\nCreated by Sunk.\nAssisted by Pianta.\n\nModified by Demnyx.\n\n\\#FF0000\\Note: This mod uses Squishy's Server as a Library, and can't function without it.

_G.red_coin_distance = nil
_G.secret_distance = nil

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

    --Calculaing distance
    local obj = m.marioObj
    if obj ~= nil then
        obj = get_closest_object(id_bhvRedCoin)
        _G.red_coin_distance = dist_between_objects(obj, m.marioObj)
        obj = get_closest_object(id_bhvHiddenStarTrigger)
        _G.secret_distance = dist_between_objects(obj, m.marioObj)
    end
end

hook_event(HOOK_ON_HUD_RENDER, display)