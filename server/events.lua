-- Gestionnaire d'événements

-- Gestionnaire d'événement pour les messages de chat
AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

-- Gestionnaire d'événement pour les joueurs qui se déconnectent
AddEventHandler('playerDropped', function(reason)
    local src = source
    if not LSRPCore.Players[src] then return end
    local Player = LSRPCore.Players[src]
    TriggerEvent('lsrp-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') a quitté..' .. '\n **Raison:** ' .. reason)
    Player.Functions.Save()
    LSRPCore.Player_Buckets[Player.PlayerData.license] = nil
    LSRPCore.Players[src] = nil
end)

-- Gestionnaire d'événement pour les joueurs qui se connectent
local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if LSRPCore.Config.Server.Closed and not IsPlayerAceAllowed(src, 'lsrpadmin.join') then
        return deferrals.done(LSRPCore.Config.Server.ClosedReason)
    end

    if LSRPCore.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not LSRPCore.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Bonjour %s. Votre licence est en cours de vérification', name))
    local license = LSRPCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif LSRPCore.Config.Server.CheckDuplicateLicense and LSRPCore.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    local success, isBanned, reason = pcall(LSRPCore.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('LSRPCore:Client:SharedUpdate', src, LSRPCore.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Gestionnaire d'événement pour fermer et ouvrir le serveur (empêche les joueurs de rejoindre)
RegisterNetEvent('LSRPCore:Server:CloseServer', function(reason)
    local src = source
    if LSRPCore.Functions.HasPermission(src, 'admin') then
        reason = reason or 'Aucune raison spécifiée'
        LSRPCore.Config.Server.Closed = true
        LSRPCore.Config.Server.ClosedReason = reason
        for k in pairs(LSRPCore.Players) do
            if not LSRPCore.Functions.HasPermission(k, LSRPCore.Config.Server.WhitelistPermission) then
                LSRPCore.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        LSRPCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('LSRPCore:Server:OpenServer', function()
    local src = source
    if LSRPCore.Functions.HasPermission(src, 'admin') then
        LSRPCore.Config.Server.Closed = false
    else
        LSRPCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Événements de rappel --

-- Rappel client
RegisterNetEvent('LSRPCore:Server:TriggerClientCallback', function(name, ...)
    if LSRPCore.ClientCallbacks[name] then
        LSRPCore.ClientCallbacks[name](...)
        LSRPCore.ClientCallbacks[name] = nil
    end
end)

-- Rappel serveur
RegisterNetEvent('LSRPCore:Server:TriggerCallback', function(name, ...)
    local src = source
    LSRPCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('LSRPCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Joueur

-- Événement pour mettre à jour les besoins du joueur
RegisterNetEvent('LSRPCore:UpdatePlayer', function()
    local src = source
    local Player = LSRPCore.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - LSRPCore.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - LSRPCore.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

-- Événement pour basculer le devoir du joueur
RegisterNetEvent('LSRPCore:ToggleDuty', function()
    local src = source
    local Player = LSRPCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('LSRPCore:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('LSRPCore:Notify', src, Lang:t('info.on_duty'))
    end

    TriggerEvent('LSRPCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('LSRPCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- Événements de base --

-- Véhicules
RegisterServerEvent('baseevents:enteringVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entrée'
    }
    TriggerClientEvent('LSRPCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entré'
    }
    TriggerClientEvent('LSRPCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('LSRPCore:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Sorti'
    }
    TriggerClientEvent('LSRPCore:Client:VehicleInfo', src, data)
end)

-- Objets

-- Cet événement est exploitable et ne doit pas être utilisé. Il est obsolète et sera bientôt supprimé.
RegisterNetEvent('LSRPCore:Server:UseItem', function(item)
    print(string.format('%s a déclenché LSRPCore:Server:UseItem avec l\'ID %s avec les données suivantes. Cet événement est obsolète en raison de l'exploitation et sera bientôt supprimé. Vérifiez lsrp-inventory pour l'utilisation correcte de cet événement.', GetInvokingResource(), source))
    LSRPCore.Debug(item)
end)

-- Cet événement est exploitable et ne doit pas être utilisé. Il est obsolète et sera bientôt supprimé. function(itemName, amount, slot)
RegisterNetEvent('LSRPCore:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format('%s a déclenché LSRPCore:Server:RemoveItem avec l\'ID %s pour %s %s. Cet événement est obsolète en raison de l'exploitation et sera bientôt supprimé. Ajustez vos événements en conséquence pour effectuer cette action côté serveur avec les fonctions du joueur.', GetInvokingResource(), src, amount, itemName))
end)

-- Cet événement est exploitable et ne doit pas être utilisé. Il est obsolète et sera bientôt supprimé. function(itemName, amount, slot, info)
RegisterNetEvent('LSRPCore:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format('%s a déclenché LSRPCore:Server:AddItem avec l\'ID %s pour %s %s. Cet événement est obsolète en raison de l'exploitation et sera bientôt supprimé. Ajustez vos événements en conséquence pour effectuer cette action côté serveur avec les fonctions du joueur.', GetInvokingResource(), src, amount, itemName))
end)

-- Appel de commande sans chat (ex: lsrp-adminmenu)

RegisterNetEvent('LSRPCore:CallCommand', function(command, args)
    local src = source
    if not LSRPCore.Commands.List[command] then return end
    local Player = LSRPCore.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = LSRPCore.Functions.HasPermission(src, 'command.' .. LSRPCore.Commands.List[command].name)
    if hasPerm then
        if LSRPCore.Commands.List[command].argsrequired and #LSRPCore.Commands.List[command].arguments ~= 0 and not args[#LSRPCore.Commands.List[command].arguments] then
            TriggerClientEvent('LSRPCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            LSRPCore.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('LSRPCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Utilisez ceci pour la création de véhicules par le joueur
-- Rappel de création de véhicule côté serveur (netId)
-- utilisez le netid sur le client avec la fonction native NetworkGetEntityFromNetworkId
-- convertissez-le en véhicule via la fonction native NetToVeh
LSRPCore.Functions.CreateCallback('LSRPCore:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = LSRPCore.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Utilisez ceci pour la création de véhicules à longue distance
-- Rappel de création de véhicule côté serveur (netId)
-- utilisez le netid sur le client avec la fonction native NetworkGetEntityFromNetworkId
-- convertissez-le en véhicule via la fonction native NetToVeh
LSRPCore.Functions.CreateCallback('LSRPCore:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = LSRPCore.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--LSRPCore.Functions.CreateCallback('LSRPCore:HasItem', function(source, cb, items, amount)
-- https://github.com/lsrpcore-framework/lsrp-inventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
