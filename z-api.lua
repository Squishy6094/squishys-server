_G.ssExists = true
_G.ssBooted = false
_G.ssApi = {}

hook_event(HOOK_UPDATE, function ()
    if BootupTimer >= 150 then
        _G.ssBooted = true
    else
        _G.ssBooted = false
    end

    if menuTable ~= nil then
        menuTable[4] = apiTable
    end
end)

apiTable = {
    name = "External"
}

-- Toggles --
_G.ssApi.option_add = function(name, statusDefault, statusMax, statusNames, description)
    if statusNames == nil then statusNames = {} end
    if description == nil then description = {"Added via the SS Api"} end
    apiTable[#apiTable + 1] = {
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
_G.ssApi.menu_open = function (boolean)
    if boolean ~= nil then
        menu = boolean
    else
        return menu
    end
end


-- Name-2-Model Info --
_G.ssApi.name2model_get_ID = function() -- Returns User's current the Name-2-Model ID
    return discordID
end

_G.ssApi.name2model_get_nickname = function () -- Returns the User's Nickname
    return modelTable[discordID].nickname
end

_G.ssApi.name2model_get_model_name = function () -- Returns the User's Current Model Name
    return modelTable[discordID][menuTable[3][1].status].modelName
end


-- Roles Info --
_G.ssApi.roles_tag = function (localIndex) -- Returns the User's Roles String (if they have any)
    return roles_get_tag(localIndex)
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

_G.ssApi.theme_unlock = function (themeString, themeexplain) -- Unlocks a theme as long as it exists in SS
    theme_unlock(themeString, themeexplain)
end

-- Event Management --
_G.ssApi.event = function (eventString) -- Returns or Sets the current event (Useful for mod collabs)
    if eventString ~= nil then
        gGlobalSyncTable.event = eventString
    else
        return gGlobalSyncTable.event
    end
end