VorpCore = {}
VorpCore.Player = {}
VorpCore.Players = {}

function GetPlayers()
    local sources = {}
    for k, v in pairs(VorpCore.Players) do
        sources[#sources+1] = k
    end
    return sources
end
exports('GetPlayers', GetPlayers)

-- Returns the entire player object
exports('GetAllPlayers', function()
    return VorpCore.Players
end)

function GetPlayer(source)
    return VorpCore.Players[source]
end


-- you can use steamid, license, discord, xbl, liveid, ip as the idtype
function GetIdentifier(source, idtype)
    if type(idtype) ~= "string" then return print('Invalid usage') end
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, idtype) then
            return identifier
        end
    end
    return nil
end

function AddPermission(source, permission)
    local src = source
    local license = GetIdentifier(src, 'license')
    ExecuteCommand(('add_principal identifier.%s vorp.%s'):format(license, permission))
    RefreshCommands(src)
end

function RemovePermission(source, permission)
    local src = source
    local license = GetIdentifier(src, 'license')
    if permission then
        if IsPlayerAceAllowed(src, permission) then
            ExecuteCommand(('remove_principal identifier.%s vorp.%s'):format(license, permission))
            RefreshCommands(src)
        end
    else
        for k,v in pairs(Config.Permissions) do
            if IsPlayerAceAllowed(src, v) then
                ExecuteCommand(('remove_principal identifier.%s vorp.%s'):format(license, v))
                RefreshCommands(src)
            end
        end
    end
end

function HasPermission(source, permission)
    local src = source
    if IsPlayerAceAllowed(src, permission) then return true end
    return false
end

function GetPermissions(source)
    local src = source
    local perms = {}
    for k,v in pairs (Config.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end
