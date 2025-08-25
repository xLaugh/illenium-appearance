if not Framework.ESX() then return end

local ESX = exports["es_extended"]:getSharedObject()

function Framework.GetPlayerID(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        return Player.identifier
    end
    return nil
end

function Framework.HasMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        local account = Player.getAccount(type)
        return account and account.money >= money
    end
    return false
end

function Framework.RemoveMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        local account = Player.getAccount(type)
        if account and account.money >= money then
            Player.removeAccountMoney(type, money)
            return true
        end
    end
    return false
end

function normalizeGrade(job)
    if job then
        job.grade = {
            level = job.grade
        }
        return job
    end
    return nil
end

function Framework.GetJob(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        return normalizeGrade(Player.getJob())
    end
    return nil
end

function Framework.GetGang(src)
    local Player = ESX.GetPlayerFromId(src)
    if Player then
        return normalizeGrade(Player.getJob())
    end
    return nil
end

function Framework.SaveAppearance(appearance, citizenID)
    if appearance and citizenID then
        Database.Users.UpdateSkinForUser(citizenID, json.encode(appearance))
    end
end

function Framework.GetAppearance(citizenID)
    if not citizenID then
        return nil
    end
    
    local user = Database.Users.GetSkinByCitizenID(citizenID)
    if user and user.skin then
        local success, skin = pcall(json.decode, user.skin)
        if success and skin then
            skin.sex = skin.model == "mp_m_freemode_01" and 0 or 1
            return skin
        end
    end
    return nil
end
