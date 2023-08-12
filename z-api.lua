_G.ssExists = true
_G.ssApi = {}

_G.ssApi.option_add = function(name, statusDefault, statusMax, statusNames, description)
    if statusNames == nil then statusNames = {} end
    if description == nil then description = {"Added via the SS Api"} end
    menuTable[3][#menuTable[3]+1] = {
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