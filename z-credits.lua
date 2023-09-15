-- Thank you so much for to playing my game!

creditsOpen = false
local creditsScroll = 0

local creditsTable = {
    {
        sectionName = "Developers",
        sectionColor = {r = 255, g = 36, b = 0},
        sectionColumns = 1,
        {
            name = "Squishy",
            handle = "@6094Squishy - Twitter",
            creditFor = "Lead Developer"
        },
        {
            name = "Floralys",
            handle = "@xfloralys - Twitter",
            creditFor = "Secondary Developer"
        },
        {
            name = "Plusle",
            handle = "staticgnawer - Discord",
        },
        {
            name = "Crispyman",
            handle = "@Crispus_Manus - Twitter",
        },
    },
    --[[
    {
        sectionName = "Support / Contribution",
        sectionColumns = 4,
        {
            name = "Agent X",
            creditFor = "Tons of coding support"
        },
        {
            name = "EmilyEmmi",
            creditFor = "Roles System"
        },
        {
            name = "Plusle",
            handle = "staticgnawer / Discord",
        },
        {
            name = "Crispyman",
            handle = "@Crispus_Manus / Twitter",
        },
    }
    --]]
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
        djui_hud_set_color(150, 150, 150, 255)
        djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 5, djui_hud_get_screen_height() + 5)
        for i = 1, #creditsTable do
            if creditsTable[i].sectionColor == nil then creditsTable[i].sectionColor = {r = 0, g = 88, b = 0} end
            djui_hud_set_color(creditsTable[i].sectionColor.r, creditsTable[i].sectionColor.g, creditsTable[i].sectionColor.b, 255)
            djui_hud_print_text(creditsTable[i].sectionName, djui_hud_get_screen_width() * 0.5 - djui_hud_measure_text(creditsTable[i].sectionName) * 0.5, 30 - creditsScroll, 1)
            for k = 1, #creditsTable[i] do
                djui_hud_print_text(creditsTable[i][k].name, (djui_hud_get_screen_width() * 0.5 - creditsTable[i].sectionColumns/2) + (k / creditsTable[i].sectionColumns) * 50 - djui_hud_measure_text(creditsTable[i][k].name) * 0.25, 30 + math.floor(creditsTable[i].sectionColumns/k) * 10 - creditsScroll, 0.5)
            end
        end
    end
end

function inputs(m)
    if creditsOpen then
        if m.controller.buttonDown & B_BUTTON ~= 0 then
            creditsOpen = false
        end
        nullify_inputs(m)
    end
end

hook_event(HOOK_ON_HUD_RENDER, render_credits)
hook_event(HOOK_BEFORE_MARIO_UPDATE, inputs)