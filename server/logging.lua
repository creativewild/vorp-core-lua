RegisterServerEvent('vorp:discord:log')
AddEventHandler('vorp:discord:log', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone ~= nil and tagEveryone or false
    local webHook = Config.log.discord.webhooks[name] ~= nil and Config.log.discord.webhooks[name] or Config.log.discord.webhooks["default"]
    local embedData = {
        {
            ["title"] = title,
            ["color"] = Config.log.discord.colors[color] ~= nil and Config.log.discord.colors[color] or Config.log.discord.colors["default"],
            ["footer"] = {
                ["text"] = os.date("%c"),
            },
            ["description"] = message,
        }
    }
    PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = Config.log.discord.username, embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function(err, text, headers) end, 'POST', json.encode({ username = Config.log.discord.username, content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    end
end)


function DebugMessage(msg)
	if(Config.log.file.debugInfo and msg)then
		print("VORP-DEBUG: " .. msg)
	end
end

function LogExists(date, cb)
	Citizen.CreateThread(function()
		local log = LoadResourceFile(GetCurrentResourceName(), "logs/" .. date .. ".txt")
		if log then cb(true) else cb(false) end
		return
	end)
end

function DoesLogExist(cb)
	LogExists(string.gsub(os.date('%x'), '(/)', '-'), function(exists)
		Citizen.CreateThread(function()
			if not exists then
				local file = SaveResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt", '-- Begin of log for ' .. string.gsub(os.date('%x'), '(/)', '-') .. ' --\n', -1)
			end
			cb(exists)

			log(' -- Vorp Core log started. --')

			return
		end)
	end)
end

Citizen.CreateThread(function()
	if Config.log.file.enabled ~= "false" then DoesLogExist(function()end) end
	return
end)


function Log(log)
	if Config.log.file.enabled ~= "false" then
		Citizen.CreateThread(function()
			local file = LoadResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt")
			if file then
				SaveResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt", file .. log .. "\n", -1)
				return
			end
		end)
	end
end
RegisterServerEvent('vorp:log:debug')
AddEventHandler("vorp:log:debug", DebugMessage)

RegisterServerEvent('vorp:log:file')
AddEventHandler("vorp:log:file", Log)