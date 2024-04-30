LSRPCore.Functions = {}
LSRPCore.Player_Buckets = {}
LSRPCore.Entity_Buckets = {}
LSRPCore.UsableItems = {}

-- Getters
-- Obtenez d'abord votre joueur, puis déclenchez une fonction sur lui
-- ex: local player = LSRPCore.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

---Obtient les coordonnées d'une entité
---@param entity number
---@return vector4
function LSRPCore.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

---Obtient l'identifiant du joueur du type donné
---@param source any
---@param idtype string
---@return string?
function LSRPCore.Functions.GetIdentifier(source, idtype)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, idtype or 'license')
end

---Obtient l'ID source d'un joueur. Renvoie 0 si aucun joueur n'est trouvé.
---@param identifier string
---@return number
function LSRPCore.Functions.GetSource(identifier)
    for src, _ in pairs(LSRPCore.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

---Obtient le joueur avec l'ID source donné
---@param source any
---@return table
function LSRPCore.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return LSRPCore.Players[source]
    else
        return LSRPCore.Players[LSRPCore.Functions.GetSource(source)]
    end
end

---Obtient le joueur par ID de citoyen
---@param citizenid string
---@return table?
function LSRPCore.Functions.GetPlayerByCitizenId(citizenid)
    for src in pairs(LSRPCore.Players) do
        if LSRPCore.Players[src].PlayerData.citizenid == citizenid then
            return LSRPCore.Players[src]
        end
    end
    return nil
end

---Obtient le joueur hors ligne par ID de citoyen
---@param citizenid string
---@return table?
function LSRPCore.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return LSRPCore.Player.GetOfflinePlayer(citizenid)
end

---Obtient le joueur par licence
---@param license string
---@return table?
function LSRPCore.Functions.GetPlayerByLicense(license)
    return LSRPCore.Player.GetPlayerByLicense(license)
end

---Obtient le joueur par numéro de téléphone
---@param number number
---@return table?
function LSRPCore.Functions.GetPlayerByPhone(number)
    for src in pairs(LSRPCore.Players) do
        if LSRPCore.Players[src].PlayerData.charinfo.phone == number then
            return LSRPCore.Players[src]
        end
    end
    return nil
end

---Obtient le joueur par ID de compte
---@param account string
---@return table?
function LSRPCore.Functions.GetPlayerByAccount(account)
    for src in pairs(LSRPCore.Players) do
        if LSRPCore.Players[src].PlayerData.charinfo.account == account then
            return LSRPCore.Players[src]
        end
    end
    return nil
end

---Obtient le joueur en passant la propriété et la valeur à vérifier
---@param property string
---@param value string
---@return table?
function LSRPCore.Functions.GetPlayerByCharInfo(property, value)
    for src in pairs(LSRPCore.Players) do
        local charinfo = LSRPCore.Players[src].PlayerData.charinfo
        if charinfo[property] ~= nil and charinfo[property] == value then
            return LSRPCore.Players[src]
        end
    end
    return nil
end

---Obtient tous les joueurs. Renvoie les ID serveur de tous les joueurs.
---@return table
function LSRPCore.Functions.GetPlayers()
    local sources = {}
    for k in pairs(LSRPCore.Players) do
        sources[#sources + 1] = k
    end
    return sources
end

---Renvoie un tableau d'instances de la classe LSRP Player
---contrairement à la fonction GetPlayers() qui ne renvoie que les ID
---@return table
function LSRPCore.Functions.GetLSRPPlayers()
    return LSRPCore.Players
end

---Obtient une liste de tous les joueurs en service d'un emploi spécifié et leur nombre
---@param job string
---@return table, number
function LSRPCore.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0
    for src, Player in pairs(LSRPCore.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end

---Renvoie uniquement le nombre de joueurs en service pour l'emploi spécifié
---@param job any
---@return number
function LSRPCore.Functions.GetDutyCount(job)
    local count = 0
    for _, Player in pairs(LSRPCore.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count += 1
            end
        end
    end
    return count
end

-- Routing buckets (Ne touchez que si vous savez ce que vous faites)

---Renvoie les objets liés aux buckets, la première valeur renvoyée est les buckets de joueur, la deuxième est les buckets d'entité
---@return table, table
function LSRPCore.Functions.GetBucketObjects()
    return LSRPCore.Player_Buckets, LSRPCore.Entity_Buckets
end

---Définit l'ID joueur / source fourni dans le bucket ID fourni
---@param source any
---@param bucket any
---@return boolean
function LSRPCore.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = LSRPCore.Functions.GetIdentifier(source, 'license')
        Player(source).state:set('instance', bucket, true)
        SetPlayerRoutingBucket(source, bucket)
        LSRPCore.Player_Buckets[plicense] = { id = source, bucket = bucket }
        return true
    else
        return false
    end
end

---Définit n'importe quelle entité dans le bucket fourni, par exemple les PNJ / véhicules / accessoires / etc.
---@param entity number
---@param bucket number
---@return boolean
function LSRPCore.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        LSRPCore.Entity_Buckets[entity] = { id = entity, bucket = bucket }
        return true
    else
        return false
    end
end

---Renvoie un tableau de tous les ID de joueurs dans le bucket actuel
---@param bucket number
---@return table|boolean
function LSRPCore.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if LSRPCore.Player_Buckets and next(LSRPCore.Player_Buckets) then
        for _, v in pairs(LSRPCore.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Renvoie un tableau de toutes les entités dans le bucket actuel
---(pas pour les entités de joueur, utilisez GetPlayersInBucket pour cela)
---@param bucket number
---@return table|boolean
function LSRPCore.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if LSRPCore.Entity_Buckets and next(LSRPCore.Entity_Buckets) then
        for _, v in pairs(LSRPCore.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Création de véhicule côté serveur avec rappel facultatif
---la fonction CreateVehicle RPC utilise toujours le client pour la création, donc les joueurs doivent être à proximité
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function LSRPCore.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

---Création de véhicule côté serveur avec rappel facultatif
---la fonction CreateAutomobile native est encore expérimentale mais n'utilise pas le client pour la création
---ne fonctionne pas pour tous les véhicules !
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function LSRPCore.Functions.CreateAutomobile(source, model, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local CreateAutomobile = `CREATE_AUTOMOBILE`
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

---Nouvelle fonction côté serveur plus fiable pour la création de véhicules
---@param source any
---@param model any
---@param vehtype any
-- Le type de véhicule approprié pour les informations du modèle.
-- Peut être automobile, moto, bateau, hélico, avion, sous-marin, remorque et (potentiellement) train.
-- Cela devrait être le même type que le champ type dans vehicles.meta.
---@param coords vector
---@param warp boolean
---@return number
function LSRPCore.Functions.CreateVehicle(source, model, vehtype, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    vehtype = type(vehtype) == 'string' and tostring(vehtype) or vehtype
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicleServerSetter(model, vehtype, coords, heading)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

---Paychecks (standalone - don't touch)
function PaycheckInterval()
    if next(LSRPCore.Players) then
        for _, Player in pairs(LSRPCore.Players) do
            if Player then
                local payment = LSRPShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (LSRPShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if LSRPCore.Config.Money.PayCheckSociety then
                        local account = exports['lsrp-banking']:GetAccountBalance(Player.PlayerData.job.name)
                        if account ~= 0 then          -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                TriggerClientEvent('LSRPCore:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                            else
                                Player.Functions.AddMoney('bank', payment, 'paycheck')
                                exports['lsrp-banking']:RemoveMoney(Player.PlayerData.job.name, payment, 'Employee Paycheck')
                                TriggerClientEvent('LSRPCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                            end
                        else
                            Player.Functions.AddMoney('bank', payment, 'paycheck')
                            TriggerClientEvent('LSRPCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                        end
                    else
                        Player.Functions.AddMoney('bank', payment, 'paycheck')
                        TriggerClientEvent('LSRPCore:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                    end
                end
            end
        end
    end
    SetTimeout(LSRPCore.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end

-- Callback Functions --

---Trigger Client Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function LSRPCore.Functions.TriggerClientCallback(name, source, cb, ...)
    LSRPCore.ClientCallbacks[name] = cb
    TriggerClientEvent('LSRPCore:Client:TriggerClientCallback', source, name, ...)
end

---Create Server Callback
---@param name string
---@param cb function
function LSRPCore.Functions.CreateCallback(name, cb)
    LSRPCore.ServerCallbacks[name] = cb
end

---Trigger Serv er Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function LSRPCore.Functions.TriggerCallback(name, source, cb, ...)
    if not LSRPCore.ServerCallbacks[name] then return end
    LSRPCore.ServerCallbacks[name](source, cb, ...)
end

-- Items

---Create a usable item
---@param item string
---@param data function
function LSRPCore.Functions.CreateUseableItem(item, data)
    LSRPCore.UsableItems[item] = data
end

---Checks if the given item is usable
---@param item string
---@return any
function LSRPCore.Functions.CanUseItem(item)
    return LSRPCore.UsableItems[item]
end

---Use item
---@param source any
---@param item string
function LSRPCore.Functions.UseItem(source, item)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    exports['lsrp-inventory']:UseItem(source, item)
end

---Kick Player
---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function LSRPCore.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. LSRPCore.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

---Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source any
---@return boolean
function LSRPCore.Functions.IsWhitelisted(source)
    if not LSRPCore.Config.Server.Whitelist then return true end
    if LSRPCore.Functions.HasPermission(source, LSRPCore.Config.Server.WhitelistPermission) then return true end
    return false
end

-- Setting & Removing Permissions

---Add permission for player
---@param source any
---@param permission string
function LSRPCore.Functions.AddPermission(source, permission)
    if not IsPlayerAceAllowed(source, permission) then
        ExecuteCommand(('add_principal player.%s lsrpcore.%s'):format(source, permission))
        LSRPCore.Commands.Refresh(source)
    end
end

---Remove permission from player
---@param source any
---@param permission string
function LSRPCore.Functions.RemovePermission(source, permission)
    if permission then
        if IsPlayerAceAllowed(source, permission) then
            ExecuteCommand(('remove_principal player.%s lsrpcore.%s'):format(source, permission))
            LSRPCore.Commands.Refresh(source)
        end
    else
        for _, v in pairs(LSRPCore.Config.Server.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                ExecuteCommand(('remove_principal player.%s lsrpcore.%s'):format(source, v))
                LSRPCore.Commands.Refresh(source)
            end
        end
    end
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function LSRPCore.Functions.HasPermission(source, permission)
    if type(permission) == 'string' then
        if IsPlayerAceAllowed(source, permission) then return true end
    elseif type(permission) == 'table' then
        for _, permLevel in pairs(permission) do
            if IsPlayerAceAllowed(source, permLevel) then return true end
        end
    end

    return false
end

---Get the players permissions
---@param source any
---@return table
function LSRPCore.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs(LSRPCore.Config.Server.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end

---Get admin messages opt-in state for player
---@param source any
---@return boolean
function LSRPCore.Functions.IsOptin(source)
    local license = LSRPCore.Functions.GetIdentifier(source, 'license')
    if not license or not LSRPCore.Functions.HasPermission(source, 'admin') then return false end
    local Player = LSRPCore.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

---Toggle opt-in to admin messages
---@param source any
function LSRPCore.Functions.ToggleOptin(source)
    local license = LSRPCore.Functions.GetIdentifier(source, 'license')
    if not license or not LSRPCore.Functions.HasPermission(source, 'admin') then return end
    local Player = LSRPCore.Functions.GetPlayer(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

---Check if player is banned
---@param source any
---@return boolean, string?
function LSRPCore.Functions.IsPlayerBanned(source)
    local plicense = LSRPCore.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

---Check for duplicate license
---@param license any
---@return boolean
function LSRPCore.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local playerLicense = LSRPCore.Functions.GetIdentifier(player, 'license')
        if playerLicense == license then return true end
    end
    return false
end

-- Utility functions

---Check if a player has an item [deprecated]
---@param source any
---@param items table|string
---@param amount number
---@return boolean
function LSRPCore.Functions.HasItem(source, items, amount)
    if GetResourceState('lsrp-inventory') == 'missing' then return end
    return exports['lsrp-inventory']:HasItem(source, items, amount)
end

---Notify
---@param source any
---@param text string
---@param type string
---@param length number
function LSRPCore.Functions.Notify(source, text, type, length)
    TriggerClientEvent('LSRPCore:Notify', source, text, type, length)
end

---???? ... ok
---@param source any
---@param data any
---@param pattern any
---@return boolean
function LSRPCore.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = LSRPCore.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data) then
        TriggerEvent('lsrp-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end
