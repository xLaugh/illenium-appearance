if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()
Framework.PlayerData = nil

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    Framework.PlayerData = xPlayer
    if Framework.PlayerData then
        client.job = Framework.PlayerData.job
        client.gang = Framework.PlayerData.gang or Framework.PlayerData.job -- Fallback pour compatibilité
        client.citizenid = Framework.PlayerData.identifier
        InitAppearance()
    else
        print("[illenium-appearance] Warning: PlayerData is nil in esx:playerLoaded")
    end
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    Framework.PlayerData = nil
end)

RegisterNetEvent("esx:setJob", function(job)
    if Framework.PlayerData then
        Framework.PlayerData.job = job
        client.job = Framework.PlayerData.job
        client.gang = Framework.PlayerData.job -- ESX utilise job pour gang aussi
    end
end)

local function getRankInputValues(rankList)
    local rankValues = {}
    if rankList then
        for _, v in pairs(rankList) do
            rankValues[#rankValues + 1] = {
                label = v.label,
                value = v.grade
            }
        end
    end
    return rankValues
end

function Framework.GetPlayerGender()
    local data = ESX.GetPlayerData()
    if data and data.sex then
        if data.sex == "f" then
            return "Female"
        end
        return "Male"
    end
    
    -- Fallback pour compatibilité ESX 1.12.4
    if Framework.PlayerData and Framework.PlayerData.sex then
        if Framework.PlayerData.sex == "f" then
            return "Female"
        end
        return "Male"
    end
    
    return "Male" -- Default fallback
end

function Framework.UpdatePlayerData()
    local data = ESX.GetPlayerData()
    if data then
        if data.job then
            Framework.PlayerData = data
            client.job = Framework.PlayerData.job
            client.gang = Framework.PlayerData.job -- ESX utilise job pour gang
        end
        client.citizenid = Framework.PlayerData.identifier
    end
end

function Framework.HasTracker()
    return false
end

function Framework.CheckPlayerMeta()
    local data = ESX.GetPlayerData()
    if data then
        Framework.PlayerData = data
        return Framework.PlayerData.dead or IsPedCuffed(cache.ped or PlayerPedId())
    end
    return false
end

function Framework.IsPlayerAllowed(citizenid)
    if Framework.PlayerData and Framework.PlayerData.identifier then
        return citizenid == Framework.PlayerData.identifier
    end
    return false
end

function Framework.GetRankInputValues(type)
    if client[type] and client[type].name then
        local jobGrades = lib.callback.await("illenium-appearance:server:esx:getGradesForJob", false, client[type].name)
        return getRankInputValues(jobGrades)
    end
    return {}
end

function Framework.GetJobGrade()
    return client.job and client.job.grade or 0
end

function Framework.GetGangGrade()
    return client.gang and client.gang.grade or 0
end

function Framework.CachePed()
    local ped = cache.ped or PlayerPedId()
    ESX.SetPlayerData("ped", ped)
end

function Framework.RestorePlayerArmour()
    return nil
end
