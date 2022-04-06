local CommandList = {}
local IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['superadmin'] = true, -- We don't need to create an ace because god is allowed all commands
    ['user'] = true -- We don't need to create an ace because builtin.everyone 
}

CreateThread(function() -- Add ace to node for perm checking
    for k,v in pairs(Config.Permissions) do
        ExecuteCommand(('add_ace vorp.%s %s allow'):format(v, v))
    end
end)

local function AddCommand(name, help, arguments, argsrequired, callback, permission)
    local restricted = true -- Default to restricted for all commands
    if not permission then permission = 'user' end -- some commands don't pass permission level
    if permission == 'user' then restricted = false end -- allow all users to use command
    RegisterCommand(name, callback, restricted) -- Register command within redm
    if not IgnoreList[permission] then -- only create aces for extra perm levels
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
exports('AddCommand', AddCommand)

function RefreshCommands(source)
    local src = source
    local Player = GetPlayer(src)
    local suggestions = {}
    if Player then
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
exports('RefreshCommands', RefreshCommands)