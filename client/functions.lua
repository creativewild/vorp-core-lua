function LoadModel(hash)
    if IsModelValid(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            --Debug.WriteLine($"Waiting for model {hash} load!");
            Citizen.Wait(0)
        end
        return true
    else
        --Debug.WriteLine($"Model {hash} is not valid!");
        return false
    end
end

function LoadTexture(hash)
    if not Citizen.InvokeNative(0x7332461FC59EB7EC, texture) then
        Citizen.InvokeNative(0xC1BA29DF5631B0F8, hash)
        while not Citizen.InvokeNative(0x54D6900929CCF162, hash) do
            --Debug.WriteLine($"Waiting for texture {hash} load!");
            Citizen.Wait(0)
        end
        return true
    else
        --Debug.WriteLine($"Texture {hash} is not valid!");
        return false
    end
end

function DrawText(text, font, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(fontscale, fontsize)
    SetTextColor(r, g, b, alpha)
    SetTextCentre(textcentred)
    if shadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextFontForCurrentCommand(font)
    DisplayText(str, x, y)
end

function TeleportToCoords(x, y, z, heading)
    local playerPedId = PlayerPedId()
    SetEntityCoords(playerPedId, x, y, z, true, true, true, false)
    if heading ~= nil then SetEntityHeading(playerPedId, heading) end
end

local lastSoundSetName = ""
local lastSoundSetRef = ""

function PlayFrontendSound(frontend_soundset_ref, frontend_soundset_name, forcePlay)
    if forcePlay and lastSoundSetName ~= 0 then
        Citizen.InvokeNative(0x9D746964E0CF2C5F, lastSoundSetName, lastSoundSetRef)  -- stop audio
    end

    if frontend_soundset_ref ~= 0 then
        Citizen.InvokeNative(0x0F2A2175734926D8, frontend_soundset_name, frontend_soundset_ref)   -- load sound frontend
    end
    Citizen.InvokeNative(0x67C540AA08E4A6F5, frontend_soundset_name, frontend_soundset_ref, true, 0) -- play sound frontend

    lastSoundSetName = frontend_soundset_name
    lastSoundSetRef = frontend_soundset_ref
end
