-- Thank you so much for to playing my game!

creditsOpen = false
local creditsScroll = 0

local creditsTable = {
    {
        sectionName = "Developers",
        sectionColor = {r = 255, g = 36, b = 0},
        sectionColumns = 2,
        sectionPos = 30,
        {
            name = "Squishy",
            color = {r = 0, g = 150, b = 0},
            handle = "squishy6094",
            creditFor = "Lead Developer"
        },
        {
            name = "Floralys",
            handle = "xfloralys",
            creditFor = "Secondary Developer"
        },
        {
            name = "Plusle",
            handle = "staticgnawer",
        },
        {
            name = "Crispyman",
            handle = "crispyman.",
        },
    },
    {
        sectionName = "Support / Contribution",
        sectionColumns = 4,
        sectionPos = 120,
        {
            name = "Agent X",
        },
        {
            name = "EmilyEmmi",
        },
        {
            name = "Sunk",
        },
    }
}

local djui_hud_set_resolution = djui_hud_set_resolution
local djui_hud_set_color = djui_hud_set_color
local djui_hud_render_rect = djui_hud_render_rect
local djui_hud_set_font = djui_hud_set_font
local djui_hud_print_text = djui_hud_print_text
local djui_hud_measure_text = djui_hud_measure_text
local djui_hud_render_texture_tile = djui_hud_render_texture_tile

function render_credits()
    if BootupTimer < 150 then return end
    if menuTable[3][7].status == 1 then
        creditsOpen = true
        menu = false
        menuTable[3][7].status = 0
    end

    if creditsOpen then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_NORMAL)
        djui_hud_set_color(0, 0, 0, 255)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 5, djui_hud_get_screen_height() + 5)
        djui_hud_set_color(60, 60, 60, 255)
        djui_hud_render_texture_tile(themeTable[menuTable[2][3].status].texture, halfScreenWidth - 113.75, 0, 1.514204545451, 1.3, 0, 0, 175, 204)
        for i = 1, #creditsTable do
            if creditsTable[i].sectionColor == nil then creditsTable[i].sectionColor = {r = 0, g = 150, b = 0} end
            djui_hud_set_color(creditsTable[i].sectionColor.r, creditsTable[i].sectionColor.g, creditsTable[i].sectionColor.b, 255)
            djui_hud_print_text(creditsTable[i].sectionName, djui_hud_get_screen_width() * 0.5 - djui_hud_measure_text(creditsTable[i].sectionName) * 0.5, creditsTable[i].sectionPos + creditsScroll, 1)
            for k = 1, #creditsTable[i] do
                if creditsTable[i][k].color == nil then creditsTable[i][k].color = creditsTable[i].sectionColor end
                djui_hud_set_color(creditsTable[i][k].color.r, creditsTable[i][k].color.g, creditsTable[i][k].color.b, 255)

                local scale = 0.5
                local x = (djui_hud_get_screen_width() * 0.5) - (djui_hud_measure_text(creditsTable[i][k].name)*(scale*0.5)) + (k%creditsTable[i].sectionColumns) * 55 - (creditsTable[i].sectionColumns - 1)*27.5
                local y = creditsTable[i].sectionPos + 15 + creditsScroll + math.ceil(k/creditsTable[i].sectionColumns)*25

                djui_hud_print_text(creditsTable[i][k].name, x, y, scale)
                if creditsTable[i][k].handle ~= nil then
                    local scale = 0.25
                    local x = (djui_hud_get_screen_width() * 0.5) - (djui_hud_measure_text(creditsTable[i][k].handle)*(scale*0.5)) + (k%creditsTable[i].sectionColumns) * 55 - (creditsTable[i].sectionColumns - 1)*27.5
                    y = y + 15
                    djui_hud_print_text(creditsTable[i][k].handle, x, y, scale)
                end
            end
        end
        for i = 0, 20 do
            djui_hud_set_color(0, 0, 0, 255 - 12.25 * i)
            djui_hud_render_rect((halfScreenWidth - 113.75) + i, 0, 1, djui_hud_get_screen_height() + 5)
            djui_hud_render_rect((halfScreenWidth + 113.75) - i, 0, 1, djui_hud_get_screen_height() + 5)
        end
    end
end

function inputs(m)
    if creditsOpen then
        if m.controller.buttonDown & B_BUTTON ~= 0 then
            creditsOpen = false
        end

        if math.abs(m.controller.stickY) >= 5 then
            creditsScroll = creditsScroll + m.controller.stickY*0.05
        end

        nullify_inputs(m)
    end
end

hook_event(HOOK_ON_HUD_RENDER, render_credits)
hook_event(HOOK_BEFORE_MARIO_UPDATE, inputs)