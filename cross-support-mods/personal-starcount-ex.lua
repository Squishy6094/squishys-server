-- name: Personal Star Counter EX+
-- description: See how many stars you collect!\nIdea by Mr.Needlemouse, created by Sunk\nModified by Demnyx.\n\n\\#005500\\This is a Modified Version Used for Squishy's Server, and may not function\nwithout the server mod on.
if mod_storage_load("StarCounter") == nil then
	mod_storage_save("StarCounter", "0")
end

local TotalStarCounter = tonumber(mod_storage_load("StarCounter"))
local StarCounter = 0
local prevNumStars = 0

local screenHeight = 0
local screenWidth = 0

local psToggle = 1

---@param m MarioState
--Increments an independent counter if a star is collected.
function localStarCounter(m, o, type)
    if (m.playerIndex == 0) and (type == INTERACT_STAR_OR_KEY) then
        --This ensures that it increments ONLY if a star is collected.
        if get_id_from_behavior(o.behavior) ~= id_bhvBowserKey then
            --The hook happens after the star count increments, so this allows the independent counter to increment ONLY when YELLOW star is collected.
            if m.numStars ~= prevNumStars then
                StarCounter = StarCounter + 1
				TotalStarCounter = TotalStarCounter + 1
				mod_storage_save("StarCounter", tostring(TotalStarCounter))
            end
        end
    end
end

-- Hud alpha stuff from Agent X
function djui_hud_set_adjusted_color(r, g, b, a)
    local multiplier = 1
    if is_game_paused() then multiplier = 0.5 end
    djui_hud_set_color(r * multiplier, g * multiplier, b * multiplier, a)
end

function displayStarCounter()
	local m = gMarioStates[0]
	if psToggle ~= 1 then return end
	if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil
	or (m.action == ACT_END_PEACH_CUTSCENE
	or m.action == ACT_CREDITS_CUTSCENE
	or m.action == ACT_END_WAVING_CUTSCENE) then return end

	djui_hud_set_resolution(RESOLUTION_N64)
	djui_hud_set_font(FONT_HUD)

    --I don't want to put this in a seperate function, there's not enough code for it to be worth it.
    if m.playerIndex == 0 then
		prevNumStars = m.numStars
    else
       return
    end

    screenHeight = djui_hud_get_screen_height()
    screenWidth = djui_hud_get_screen_width()

	if a == nil then
		a = 255
	end

	if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil then
		if a <= 255 and a > 32 then
			a = a - 40
		else
			a = 0
		end
	else
		if a >= 0 and a < 215 then
			a = a + 16
		else
			a = 255
		end
	end

	local timerValFrames = hud_get_value(HUD_DISPLAY_TIMER)
	local timerX = 0
	local timerY = 0

	-- Move HUD graphics away from the TIMER HUD
	if timerValFrames ~= 0 then
		timerX = 60
		timerY = 17
	end

	--Normal personal star counter


	--Total star counter
	if timerValFrames ~= 0 then
		timerX = 0
		timerY = -10
	end

	local perceived_total_counter = TotalStarCounter
	local milestone_counter = 0
	while perceived_total_counter >= 10000 do
		perceived_total_counter = perceived_total_counter - 10000
		milestone_counter = milestone_counter + 1
	end

	_G.sharedRedStars = milestone_counter
	_G.sharedGreenStars = perceived_total_counter


	--StarCounter = 120
end

function PSToggle(msg)
	if msg == string.lower("On") or msg == "1" then
		psToggle = 1
		return true
	elseif msg == string.lower("Off") or msg == "0" then
		psToggle = 0
		return true
	end
end

---------
--Hooks--
---------
hook_event(HOOK_ON_INTERACT, localStarCounter)
hook_event(HOOK_ON_HUD_RENDER, displayStarCounter)
hook_chat_command('pstoggle', 'On|Off - Displays stars you"ve collected. Default is On.', PSToggle)