_G.ssExists = true
_G.ssApi = {}

-- Toggles --
_G.ssApi.option_add = function(name, statusDefault, statusMax, statusNames, description)
    if statusNames == nil then statusNames = {} end
    if description == nil then description = {"Added via the SS Api"} end
    menuTable[4][#menuTable[4]+1] = {
        name = name,
        status = statusDefault,
        statusMax = statusMax,
        statusNames = statusNames,
        description = description
    }
end

_G.ssApi.option_read = function(name)
    for i = 1, #menuTable do
        for k = 1, #menuTable[i] do
            if menuTable[i][k].name == name then
                return menuTable[i][k].status
            end
        end
    end
end

_G.ssApi.option_write = function(name, status)
    for i = 1, #menuTable do
        for k = 1, #menuTable[i] do
            if menuTable[i][k].name == name then
                menuTable[i][k].status = status
                return
            end
        end
    end
end


-- Menu Info --
_G.ssApi.menu_open = function ()
    return menu
end


-- Name-2-Model Info --
_G.ssApi.name2model_get_ID = function()
    return discordID
end

_G.ssApi.name2model_get_nickname = function ()
    return modelTable[discordID].nickname
end


-- Roles Info --
_G.ssApi.roles_tag = function ()
    return roles_get_tag()
end


-- Theme Info --
-- Perfect if you want your own Menus to use SS themes
_G.ssApi.theme_get_name = function (themeNumber) -- Returns the Theme's Name String
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].name
end

_G.ssApi.theme_get_color = function (themeNumber) -- Returns a Hex Code String: \\#ffffff\\
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].color
end

_G.ssApi.theme_get_color_hover = function (themeNumber) -- Returns a table: {r, g, b}
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].hoverColor
end

_G.ssApi.theme_get_color_header = function (themeNumber) -- Returns a table: {r, g, b}
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].headerColor
end

_G.ssApi.theme_get_has_header = function (themeNumber) -- Returns either true or false
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].hasHeader
end

_G.ssApi.theme_get_texture = function (themeNumber) -- Returns the texture info
    if themeNumber == nil then themeNumber = menuTable[2][3].status end
    return themeTable[themeNumber].texture
end
