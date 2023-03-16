Default = 0
Compact = 1

local hudTable = {
    [Default] = {
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = djui_hud_get_screen_width()/2 + 24,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = djui_hud_get_screen_width()/2 + 38,
            numOffsetY = 15,
        },
        ["Stars"] = {
            colorR = 255,
            colorG = 255,
            colorB = 255,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = djui_hud_get_screen_width() - 61,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = djui_hud_get_screen_width() - 47,
            numOffsetY = 15,
        },
    },
    [Compact] = {
        res = RESOLUTION_N64,
        font = FONT_HUD,
        ["Lives"] = {
            colorR = 255,
            colorG = 0,
            colorB = 0,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 15,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 15,
        },
        ["Coins"] = {
            colorR = 0,
            colorG = 255,
            colorB = 0,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 33,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 33,
        },
        ["Stars"] = {
            colorR = 0,
            colorG = 0,
            colorB = 255,
            colorO = 255,
            scale = 1,
            iconShow = true,
            iconOffsetX = 0,
            iconOffsetY = 0,
            xShow = true,
            xOffsetX = 37,
            xOffsetY = 51,
            numShow = true,
            numOffsetX = 54,
            numOffsetY = 51,
        },
    }
}

currHUD = 0

function hud_render()
    
    local m = gMarioStates[0]

    hud_hide()
    djui_hud_set_resolution(hudTable[currHUD].res)
    djui_hud_set_font(hudTable[currHUD].font)
    djui_hud_set_color(255, 255, 255, 255)

    djui_hud_set_color(hudTable[currHUD]["Lives"].colorR, hudTable[currHUD]["Lives"].colorG, hudTable[currHUD]["Lives"].colorB, hudTable[currHUD]["Lives"].colorO)
    if hudTable[currHUD]["Lives"].xShow then
        djui_hud_print_text("x", hudTable[currHUD]["Lives"].xOffsetX, hudTable[currHUD]["Lives"].xOffsetY, hudTable[currHUD]["Lives"].scale)
    end
    if hudTable[currHUD]["Lives"].numShow then
        djui_hud_print_text(""..m.numLives, hudTable[currHUD]["Lives"].numOffsetX, hudTable[currHUD]["Lives"].numOffsetY, hudTable[currHUD]["Lives"].scale)
    end

    djui_hud_set_color(hudTable[currHUD]["Coins"].colorR, hudTable[currHUD]["Coins"].colorG, hudTable[currHUD]["Coins"].colorB, hudTable[currHUD]["Coins"].colorO)
    if hudTable[currHUD]["Coins"].xShow then
        djui_hud_print_text("x", hudTable[currHUD]["Coins"].xOffsetX, hudTable[currHUD]["Coins"].xOffsetY, hudTable[currHUD]["Coins"].scale)
    end
    if hudTable[currHUD]["Coins"].numShow then
        djui_hud_print_text(""..m.numCoins, hudTable[currHUD]["Coins"].numOffsetX, hudTable[currHUD]["Coins"].numOffsetY, hudTable[currHUD]["Coins"].scale)
    end

    djui_hud_set_color(hudTable[currHUD]["Stars"].colorR, hudTable[currHUD]["Stars"].colorG, hudTable[currHUD]["Stars"].colorB, hudTable[currHUD]["Stars"].colorO)
    if hudTable[currHUD]["Stars"].xShow then
        djui_hud_print_text("x", hudTable[currHUD]["Stars"].xOffsetX, hudTable[currHUD]["Stars"].xOffsetY, hudTable[currHUD]["Stars"].scale)
    end
    if hudTable[currHUD]["Stars"].numShow then
        djui_hud_print_text(""..m.numStars, hudTable[currHUD]["Stars"].numOffsetX, hudTable[currHUD]["Stars"].numOffsetY, hudTable[currHUD]["Stars"].scale)
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)