-- Cette partie du code gère les fonctionnalités liées aux joueurs dans le serveur LSRP.
-- Elle comprend des fonctions pour la connexion des joueurs, la récupération des données des joueurs hors ligne,
-- la récupération des joueurs par leur licence, et la vérification des données des joueurs.

-- LSRPCore.Players : Tableau vide pour stocker les joueurs connectés.
-- LSRPCore.Player : Tableau vide pour stocker les informations d'un joueur.

-- LSRPCore.Player.Login(source, citizenid, newData) : Fonction appelée lors de la connexion d'un joueur.
-- Elle récupère les données du joueur à partir de la base de données ou utilise les nouvelles données fournies.
-- Elle vérifie également l'intégrité des données du joueur pour éviter les exploits.
-- Paramètres :
--   - source : L'identifiant du joueur.
--   - citizenid : L'identifiant du citoyen du joueur.
--   - newData : Les nouvelles données du joueur (optionnel).
-- Retourne :
--   - true si la connexion du joueur est réussie.
--   - false si une erreur se produit.

-- LSRPCore.Player.GetOfflinePlayer(citizenid) : Fonction pour récupérer les données d'un joueur hors ligne.
-- Paramètres :
--   - citizenid : L'identifiant du citoyen du joueur.
-- Retourne :
--   - Les données du joueur hors ligne si elles existent.
--   - nil si aucune donnée n'est trouvée.

-- LSRPCore.Player.GetPlayerByLicense(license) : Fonction pour récupérer les données d'un joueur par sa licence.
-- Paramètres :
--   - license : La licence du joueur.
-- Retourne :
--   - Les données du joueur si elles existent.
--   - nil si aucune donnée n'est trouvée.

-- LSRPCore.Player.CheckPlayerData(source, PlayerData) : Fonction pour vérifier les données d'un joueur.
-- Elle initialise les données manquantes avec des valeurs par défaut si nécessaire.
-- Paramètres :
--   - source : L'identifiant du joueur (optionnel).
--   - PlayerData : Les données du joueur.
-- Retourne :
--   - Les données du joueur mises à jour.

-- Note : Les autres fonctions et variables du code ne sont pas documentées ici car elles sont utilisées en interne et ne sont pas destinées à être appelées directement.
LSRPCore.Players = {}
LSRPCore.Player = {}

-- On player login get their data or set defaults
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

local resourceName = GetCurrentResourceName()
function LSRPCore.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = LSRPCore.Functions.GetIdentifier(source, 'license')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData and license == PlayerData.license then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
                LSRPCore.Player.CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, Lang:t('info.exploit_dropped'))
                TriggerEvent('lsrp-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            LSRPCore.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        LSRPCore.ShowError(resourceName, 'ERROR LSRPCORE.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end

function LSRPCore.Player.GetOfflinePlayer(citizenid)
    if citizenid then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return LSRPCore.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function LSRPCore.Player.GetPlayerByLicense(license)
    if license then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ?', { license })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return LSRPCore.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function LSRPCore.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    local Offline = true
    if source then
        PlayerData.source = source
        PlayerData.license = PlayerData.license or LSRPCore.Functions.GetIdentifier(source, 'license')
        PlayerData.name = GetPlayerName(source)
        Offline = false
    end

    PlayerData.citizenid = PlayerData.citizenid or LSRPCore.Player.CreateCitizenId()
    PlayerData.cid = PlayerData.cid or 1
    PlayerData.money = PlayerData.money or {}
    PlayerData.optin = PlayerData.optin or true
    for moneytype, startamount in pairs(LSRPCore.Config.Money.MoneyTypes) do
        PlayerData.money[moneytype] = PlayerData.money[moneytype] or startamount
    end

    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.firstname = PlayerData.charinfo.firstname or 'Firstname'
    PlayerData.charinfo.lastname = PlayerData.charinfo.lastname or 'Lastname'
    PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate or '00-00-0000'
    PlayerData.charinfo.gender = PlayerData.charinfo.gender or 0
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'USA'
    PlayerData.charinfo.phone = PlayerData.charinfo.phone or LSRPCore.Functions.CreatePhoneNumber()
    PlayerData.charinfo.account = PlayerData.charinfo.account or LSRPCore.Functions.CreateAccountNumber()
    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['tracker'] = PlayerData.metadata['tracker'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['phone'] = PlayerData.metadata['phone'] or {}
    PlayerData.metadata['fitbit'] = PlayerData.metadata['fitbit'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or LSRPCore.Config.Player.Bloodtypes[math.random(1, #LSRPCore.Config.Player.Bloodtypes)]
    PlayerData.metadata['dealerrep'] = PlayerData.metadata['dealerrep'] or 0
    PlayerData.metadata['craftingrep'] = PlayerData.metadata['craftingrep'] or 0
    PlayerData.metadata['attachmentcraftingrep'] = PlayerData.metadata['attachmentcraftingrep'] or 0
    PlayerData.metadata['currentapartment'] = PlayerData.metadata['currentapartment'] or nil
    PlayerData.metadata['jobrep'] = PlayerData.metadata['jobrep'] or {}
    PlayerData.metadata['jobrep']['tow'] = PlayerData.metadata['jobrep']['tow'] or 0
    PlayerData.metadata['jobrep']['trucker'] = PlayerData.metadata['jobrep']['trucker'] or 0
    PlayerData.metadata['jobrep']['taxi'] = PlayerData.metadata['jobrep']['taxi'] or 0
    PlayerData.metadata['jobrep']['hotdog'] = PlayerData.metadata['jobrep']['hotdog'] or 0
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or LSRPCore.Player.CreateFingerId()
    PlayerData.metadata['walletid'] = PlayerData.metadata['walletid'] or LSRPCore.Player.CreateWalletId()
    PlayerData.metadata['criminalrecord'] = PlayerData.metadata['criminalrecord'] or {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false
    }
    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }
    PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = LSRPCore.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
    -- Job
    if PlayerData.job and PlayerData.job.name and not LSRPCore.Shared.Jobs[PlayerData.job.name] then PlayerData.job = nil end
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    PlayerData.job.type = PlayerData.job.type or 'none'
    if LSRPCore.Shared.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
        PlayerData.job.onduty = LSRPCore.Shared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.isboss = PlayerData.job.isboss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    if PlayerData.gang and PlayerData.gang.name and not LSRPCore.Shared.Gangs[PlayerData.gang.name] then PlayerData.gang = nil end
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or LSRPCore.Config.DefaultSpawn
    PlayerData.items = GetResourceState('lsrp-inventory') ~= 'missing' and exports['lsrp-inventory']:LoadInventory(PlayerData.source, PlayerData.citizenid) or {}
    return LSRPCore.Player.CreatePlayer(PlayerData, Offline)
end

-- On player logout

function LSRPCore.Player.Logout(source)
    TriggerClientEvent('LSRPCore:Client:OnPlayerUnload', source)
    TriggerEvent('LSRPCore:Server:OnPlayerUnload', source)
    TriggerClientEvent('LSRPCore:Player:UpdatePlayerData', source)
    Wait(200)
    LSRPCore.Players[source] = nil
end

-- Create a new character
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function LSRPCore.Player.CreatePlayer(PlayerData, Offline)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData
    self.Offline = Offline

    function self.Functions.UpdatePlayerData()
        if self.Offline then return end -- Unsupported for Offline Players
        TriggerEvent('LSRPCore:Player:SetPlayerData', self.PlayerData)
        TriggerClientEvent('LSRPCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
    end

    function self.Functions.SetJob(job, grade)
        job = job:lower()
        grade = tostring(grade) or '0'
        if not LSRPCore.Shared.Jobs[job] then return false end
        self.PlayerData.job.name = job
        self.PlayerData.job.label = LSRPCore.Shared.Jobs[job].label
        self.PlayerData.job.onduty = LSRPCore.Shared.Jobs[job].defaultDuty
        self.PlayerData.job.type = LSRPCore.Shared.Jobs[job].type or 'none'
        if LSRPCore.Shared.Jobs[job].grades[grade] then
            local jobgrade = LSRPCore.Shared.Jobs[job].grades[grade]
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = jobgrade.name
            self.PlayerData.job.grade.level = tonumber(grade)
            self.PlayerData.job.payment = jobgrade.payment or 30
            self.PlayerData.job.isboss = jobgrade.isboss or false
        else
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = 'No Grades'
            self.PlayerData.job.grade.level = 0
            self.PlayerData.job.payment = 30
            self.PlayerData.job.isboss = false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('LSRPCore:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerClientEvent('LSRPCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        end

        return true
    end

    function self.Functions.SetGang(gang, grade)
        gang = gang:lower()
        grade = tostring(grade) or '0'
        if not LSRPCore.Shared.Gangs[gang] then return false end
        self.PlayerData.gang.name = gang
        self.PlayerData.gang.label = LSRPCore.Shared.Gangs[gang].label
        if LSRPCore.Shared.Gangs[gang].grades[grade] then
            local ganggrade = LSRPCore.Shared.Gangs[gang].grades[grade]
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = ganggrade.name
            self.PlayerData.gang.grade.level = tonumber(grade)
            self.PlayerData.gang.isboss = ganggrade.isboss or false
        else
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = 'No Grades'
            self.PlayerData.gang.grade.level = 0
            self.PlayerData.gang.isboss = false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('LSRPCore:Server:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerClientEvent('LSRPCore:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
        end

        return true
    end

    function self.Functions.Notify(text, type, lenght)
        TriggerClientEvent('LSRPCore:Notify', self.PlayerData.source, text, type, lenght)
    end

    function self.Functions.HasItem(items, amount)
        LSRPCore.Functions.HasItem(self.PlayerData.source, items, amount)
    end

    function self.Functions.SetJobDuty(onDuty)
        self.PlayerData.job.onduty = not not onDuty -- Make sure the value is a boolean if nil is sent
        TriggerEvent('LSRPCore:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        TriggerClientEvent('LSRPCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetPlayerData(key, val)
        if not key or type(key) ~= 'string' then return end
        self.PlayerData[key] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetMetaData(meta, val)
        if not meta or type(meta) ~= 'string' then return end
        if meta == 'hunger' or meta == 'thirst' then
            val = val > 100 and 100 or val
        end
        self.PlayerData.metadata[meta] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetMetaData(meta)
        if not meta or type(meta) ~= 'string' then return end
        return self.PlayerData.metadata[meta]
    end

    function self.Functions.AddJobReputation(amount)
        if not amount then return end
        amount = tonumber(amount)
        self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('lsrp-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('lsrp-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            TriggerClientEvent('LSRPCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            TriggerEvent('LSRPCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end

        return true
    end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        for _, mtype in pairs(LSRPCore.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end
        end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('lsrp-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('lsrp-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('lsrp-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            TriggerClientEvent('LSRPCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('LSRPCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end

        return true
    end

    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end
        if not self.PlayerData.money[moneytype] then return false end
        local difference = amount - self.PlayerData.money[moneytype]
        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('lsrp-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            TriggerClientEvent('LSRPCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
            TriggerEvent('LSRPCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        end

        return true
    end

    function self.Functions.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end

    function self.Functions.SetCreditCard(cardNumber)
        self.PlayerData.charinfo.card = cardNumber
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetCardSlot(cardNumber, cardType)
        local item = tostring(cardType):lower()
        local slots = exports['lsrp-inventory']:GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                if self.PlayerData.items[slot].info.cardNumber == cardNumber then
                    return slot
                end
            end
        end
        return nil
    end

    function self.Functions.Save()
        if self.Offline then
            LSRPCore.Player.SaveOffline(self.PlayerData)
        else
            LSRPCore.Player.Save(self.PlayerData.source)
        end
    end

    function self.Functions.Logout()
        if self.Offline then return end -- Unsupported for Offline Players
        LSRPCore.Player.Logout(self.PlayerData.source)
    end

    function self.Functions.AddMethod(methodName, handler)
        self.Functions[methodName] = handler
    end

    function self.Functions.AddField(fieldName, data)
        self[fieldName] = data
    end

    if self.Offline then
        return self
    else
        LSRPCore.Players[self.PlayerData.source] = self
        LSRPCore.Player.Save(self.PlayerData.source)

        -- At this point we are safe to emit new instance to third party resource for load handling
        TriggerEvent('LSRPCore:Server:PlayerLoaded', self)
        self.Functions.UpdatePlayerData()
    end
end

-- Add a new function to the Functions table of the player class
-- Use-case:
--[[
    AddEventHandler('LSRPCore:Server:PlayerLoaded', function(Player)
        LSRPCore.Functions.AddPlayerMethod(Player.PlayerData.source, "functionName", function(oneArg, orMore)
            -- do something here
        end)
    end)
]]

function LSRPCore.Functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(LSRPCore.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not LSRPCore.Players[ids] then return end

            LSRPCore.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            LSRPCore.Functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end

-- Add a new field table of the player class
-- Use-case:
--[[
    AddEventHandler('LSRPCore:Server:PlayerLoaded', function(Player)
        LSRPCore.Functions.AddPlayerField(Player.PlayerData.source, "fieldName", "fieldData")
    end)
]]

function LSRPCore.Functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(LSRPCore.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not LSRPCore.Players[ids] then return end

            LSRPCore.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            LSRPCore.Functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end

-- Save player info to database (make sure citizenid is the primary key in your database)

function LSRPCore.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = LSRPCore.Players[source].PlayerData
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata)
        })
        if GetResourceState('lsrp-inventory') ~= 'missing' then exports['lsrp-inventory']:SaveInventory(source) end
        LSRPCore.ShowSuccess(resourceName, PlayerData.name .. ' PLAYER SAVED!')
    else
        LSRPCore.ShowError(resourceName, 'ERROR LSRPCORE.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

function LSRPCore.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.Async.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(PlayerData.position),
            metadata = json.encode(PlayerData.metadata)
        })
        if GetResourceState('lsrp-inventory') ~= 'missing' then exports['lsrp-inventory']:SaveInventory(PlayerData, true) end
        LSRPCore.ShowSuccess(resourceName, PlayerData.name .. ' OFFLINE PLAYER SAVED!')
    else
        LSRPCore.ShowError(resourceName, 'ERROR LSRPCORE.PLAYER.SAVEOFFLINE - PLAYERDATA IS EMPTY!')
    end
end

-- Delete character

local playertables = { -- Add tables as needed
    { table = 'players' },
    { table = 'apartments' },
    { table = 'bank_accounts' },
    { table = 'crypto_transactions' },
    { table = 'phone_invoices' },
    { table = 'phone_messages' },
    { table = 'playerskins' },
    { table = 'player_contacts' },
    { table = 'player_houses' },
    { table = 'player_mails' },
    { table = 'player_outfits' },
    { table = 'player_vehicles' }
}

function LSRPCore.Player.DeleteCharacter(source, citizenid)
    local license = LSRPCore.Functions.GetIdentifier(source, 'license')
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)

        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('lsrp-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
        end)
    else
        DropPlayer(source, Lang:t('info.exploit_dropped'))
        TriggerEvent('lsrp-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end

function LSRPCore.Player.ForceDeleteCharacter(citizenid)
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)
        local Player = LSRPCore.Functions.GetPlayerByCitizenId(citizenid)

        if Player then
            DropPlayer(Player.PlayerData.source, 'An admin deleted the character which you are currently using')
        end
        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('lsrp-log:server:CreateLog', 'joinleave', 'Character Force Deleted', 'red', 'Character **' .. citizenid .. '** got deleted')
            end
        end)
    end
end

-- Inventory Backwards Compatibility

function LSRPCore.Player.SaveInventory(source)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    exports['lsrp-inventory']:SaveInventory(source, false)
end

function LSRPCore.Player.SaveOfflineInventory(PlayerData)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    exports['lsrp-inventory']:SaveInventory(PlayerData, true)
end

function LSRPCore.Player.GetTotalWeight(items)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    return exports['lsrp-inventory']:GetTotalWeight(items)
end

function LSRPCore.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    return exports['lsrp-inventory']:GetSlotsByItem(items, itemName)
end

function LSRPCore.Player.GetFirstSlotByItem(items, itemName)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    return exports['lsrp-inventory']:GetFirstSlotByItem(items, itemName)
end

-- Util Functions

function LSRPCore.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(LSRPCore.Shared.RandomStr(3) .. LSRPCore.Shared.RandomInt(5)):upper()
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

function LSRPCore.Functions.CreateAccountNumber()
    local UniqueFound = false
    local AccountNumber = nil
    while not UniqueFound do
        AccountNumber = 'US0' .. math.random(1, 9) .. 'LSRPCore' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
        local query = '%' .. AccountNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return AccountNumber
end

function LSRPCore.Functions.CreatePhoneNumber()
    local UniqueFound = false
    local PhoneNumber = nil
    while not UniqueFound do
        PhoneNumber = math.random(100, 999) .. math.random(1000000, 9999999)
        local query = '%' .. PhoneNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return PhoneNumber
end

function LSRPCore.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(LSRPCore.Shared.RandomStr(2) .. LSRPCore.Shared.RandomInt(3) .. LSRPCore.Shared.RandomStr(1) .. LSRPCore.Shared.RandomInt(2) .. LSRPCore.Shared.RandomStr(3) .. LSRPCore.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end

function LSRPCore.Player.CreateWalletId()
    local UniqueFound = false
    local WalletId = nil
    while not UniqueFound do
        WalletId = 'LSRP-' .. math.random(11111111, 99999999)
        local query = '%' .. WalletId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return WalletId
end

function LSRPCore.Player.CreateSerialNumber()
    local UniqueFound = false
    local SerialNumber = nil
    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
        local query = '%' .. SerialNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return SerialNumber
end

PaycheckInterval() -- This starts the paycheck system
