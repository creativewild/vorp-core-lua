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

AddCommand('setgroup', 'VORPcore command set group to user.', { {name = "Id", help='player ID'}, {name = "Group", help='Group Name'} }, true, function(source, args)
    local _source = source
    local target, newgroup = args[1], args[2]
    if newgroup == nil or newgroup == '' then
        TriggerClientEvent("vorp:Tip", source, "ERROR: Use Correct Sintaxis", 4000)
        return
    end
    TriggerEvent("vorp:setGroup", target, newgroup)
    TriggerClientEvent("vorp:Tip", _source, string.format("Target %s have group %s", target, newgroup), 4000)
end, 'admin')

AddCommand('setjob', 'VORPcore command set job to user.', { {name = "Id", help='player ID'},{name = "Job", help='Job Name'},{name = "Rank", help=' player Rank'} }, true, function(source, args)
    local _source = source
    local target, newjob, jobgrade = tonumber(args[1]), args[2], args[3]
    if newjob == nil or newjob == '' then
        if jobgrade == nil or jobgrade == '' then
            TriggerClientEvent("vorp:Tip", source, "ERROR: Use Correct Sintaxis", 4000)
            return
        end
    end
    TriggerEvent("vorp:setJob", target, newjob, jobgrade)
    TriggerClientEvent("vorp:Tip", _source, string.format("Target %s have new job %s", target, newjob), 4000)
end, 'admin')




AddCommand('addmoney', 'VORPcore command add money/gold to user', { {name = "Id", help='player ID'}, {name = "Type", help='Money 0 Gold 1'}, {name = "Quantity", help='Quantity to give'} }, true, function(source, args)
    local _source = source
    local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    TriggerEvent("vorp:addMoney", target, montype, quantity)
    TriggerClientEvent("vorp:Tip", _source, string.format("Added %s to %s", target, quantity), 4000)
end, 'admin')

AddCommand('delmoney', 'VORPcore command remove money/gold from user', { {name = "Id", help='player ID'}, {name = "Type", help='Money 0 Gold 1'}, {name = "Quantity", help='Quantity to remove from User'} }, true, function(source, args)
    local _source = source
    local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    TriggerEvent("vorp:removeMoney", target, montype, quantity)
    TriggerClientEvent("vorp:Tip", _source, string.format("Removed %s to %s", target, quantity), 4000)
end, 'admin')


AddCommand('cmd', 'detail', { help }, true, function(source, args)
    local _source = source
    
end, 'admin')

AddCommand('additems', 'VORPcore command to give items', { {name = "Id", help='player ID'}, {name = "Item", help='item name'}, {name = "Quantity", help='amount of items to give'} }, true, function(source, args)
    local _source = source
    VORP = exports.vorp_inventory:vorp_inventoryApi()
    local id, item, count =  args[1], args[2], args[3]
    VORP.addItem(_source, item, count)
end, 'admin')

AddCommand('addweapons', 'Give a weapon', { {name = "Id", help='player ID'}, {name = "Weapon", help='Weapon Name. ex.: WEAPON_BOW'} }, true, function(source, args)
    VORP = exports.vorp_inventory:vorp_inventoryApi()
    local id, weaponHash = tonumber(args[1]), tostring(args[2])

    TriggerEvent("vorpCore:canCarryWeapons", id, 1, function(canCarry)
        if canCarry then
            VORP.createWeapon(id, weaponHash)
        else
            TriggerClientEvent("vorp:Tip", source, Config.Langs.cantCarry, 4000)
        end
    end)    
end, 'admin')

AddCommand('revive', 'VORPcore command to revive.', { {name = "Id", help='player ID'} }, true, function(source, args)
    local id =  args[1]
    TriggerClientEvent('vorp:resurrectPlayer', id)
end, 'admin')

AddCommand('delwagon', 'VORPcore command to delete wagons.', { help }, true, function(source, args)
    local _source = source
    TriggerClientEvent("vorp:delWagon",_source)
end, 'admin')




