-------------------------------------------------------------------------------------------------        
--------------------------------------- VORP ADMIN COMMANDS -------------------------------------
-- TODO 
-- MAKE COMMAND ONLY SHOWING FOR GROUP
-- ADD MORE ADMIN COMMANDS
-- WEBHOOK FOR EACH COMMAND 

------------------------------------- START ---------------------------------------
    

        
        
RegisterCommand("addwhitelist", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                local steamId = args[1]
                exports.ghmattimysql:execute("SELECT * FROM whitelist WHERE identifier = ?", {steamId}, function(result)
                    if #result == 0 then
                        exports.ghmattimysql:execute("INSERT INTO whitelist (`identifier`) VALUES (?)", {steamId})
                        AddUserToWhitelist(steamId)
                        TriggerClientEvent("vorp:Tip", source, string.format("Added %s to whitelist", steamId), 4000);
                    else
                        TriggerClientEvent("vorp:Tip", source, string.format("%s Is Whitelisted %s", steamId, steamId), 4000);
                    end
                end)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local steamId = args[1]
        exports.ghmattimysql:execute("SELECT * FROM whitelist WHERE identifier = ?", {steamId}, function(result)
            if #result == 0 then
                exports.ghmattimysql:execute("INSERT INTO whitelist (`identifier`) VALUES (?)", {steamId})
                AddUserToWhitelist(steamId)
                print(string.format("Added %s to whitelist", steamId))
            else
                print(string.format("%s Is Whitelisted %s", steamId, steamId))
            end
        end)
    end
end, false)

---------------------------------------------------------------------------------------------------
------------------------------------------ ADDITEM ------------------------------------------------

---------------------------------------------------------------------------------------------------
----------------------------------------- ADD WEAPON ----------------------------------------------


    end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------- REVIVE ------------------------------------------------------
RegisterCommand("revive", function(source, args)
    if args ~= nil then
        TriggerEvent("vorp:getCharacter", source, function(user)
            local id =  args[1]
            local _source = source 

            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
                TriggerClientEvent('vorp:resurrectPlayer', id)
            else 
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000) 
            end
        end)
    end
end)

------------------------------------------------------------------------------------------------------
------------------------------------ TP TO MARKER ----------------------------------------------------

------------------------------------------------------------------------------------------------------
-------------------------------------- DELETE WAGONS -------------------------------------------------

RegisterCommand("delwagon", function(source )
    TriggerEvent("vorp:getCharacter", source, function(user)
        local _source = source

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
            TriggerClientEvent("vorp:delWagon",_source)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)
end)


RegisterCommand("delhorse", function(source)
    TriggerEvent("vorp:getCharacter", source, function(user)
        local _source = source

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
            TriggerClientEvent("vorp:delHorse",_source)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)

end)


 
---------------------------------------------------------------------------------------------------------
----------------------------------- CHAT ADD SUGGESTION --------------------------------------------------

-- TRANSLATE HERE
-- TODO ADD TO CONFIG


