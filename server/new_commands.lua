local CommandList = {}
local IgnoreList = {
    ['superadmin'] = true,
    ['user'] = true
}

CreateThread(function()
    for k,v in pairs(Config.Permissions) do
        ExecuteCommand(('add_ace vorp.%s %s allow'):format(v, v))
    end
end)

function AddCommand(name, help, arguments, argsrequired, callback, permission)
    local restricted = true
    if not permission then permission = 'user' end
    if permission == 'user' then restricted = false end
    RegisterCommand(name, callback, restricted)
    if not IgnoreList[permission] then
        ExecuteCommand(('add_ace vorp.%s command.%s allow'):format(permission, name))
    end
    CommandList[name:lower()] = {
        name = name:lower(),
        permission = tostring(permission:lower()),
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end


function RefreshCommands(source)
    local src = source
    local Player = src
    local suggestions = {}
    if src then
        for command, info in pairs(CommandList) do
            local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.'..command)
            if hasPerm then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', src, suggestions)
    end
end



AddCommand('tpm', 'TP To Marker', {}, false, function(source)
    local _source = source
    TriggerClientEvent('vorp:teleportWayPoint', _source)
end, 'mod')

AddCommand('addmoney', 'VORPcore command add money/gold to user', { {name = "Id", help='player ID'}, {name = "Type", help='Money 0 Gold 1'}, {name = "Quantity", help='Quantity to give'} }, true, function(source, args)
    local _source = source
    local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    TriggerEvent("vorp:addMoney", target, montype, quantity)
    TriggerClientEvent("vorp:Tip", _source, string.format("Added %s to %s", target, quantity), 4000)
end, 'admin')

AddCommand('setgroup', 'VORPcore command set group to user.', { {name = "Id", help='player ID'}, {name = "Group", help='Group Name'} }, true, function(source, args)
    local _source = source
    local target, newgroup = args[1], args[2]
    if newgroup == nil or newgroup == '' then
        TriggerClientEvent("vorp:Tip", source, "ERROR: Use Correct Sintaxis", 4000)
        return
    end
    TriggerEvent("vorp:setGroup", target, newgroup)
    TriggerClientEvent("vorp:Tip", source, string.format("Target %s have group %s", target, newgroup), 4000)
end, 'admin')


