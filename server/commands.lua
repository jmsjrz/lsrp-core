-- LSRPCore.Commands
-- Table contenant les commandes du serveur.

-- LSRPCore.Commands.List
-- Table contenant la liste des commandes enregistrées.

-- LSRPCore.Commands.IgnoreList
-- Table contenant les niveaux de permission à ignorer pour maintenir la compatibilité ascendante.

-- LSRPCore.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
-- Fonction pour ajouter une nouvelle commande.
-- - name: Le nom de la commande.
-- - help: La description de la commande.
-- - arguments: Les arguments de la commande.
-- - argsrequired: Indique si les arguments sont requis.
-- - callback: La fonction de rappel à exécuter lorsque la commande est utilisée.
-- - permission: Le niveau de permission requis pour utiliser la commande.
-- - ...: Niveaux de permission supplémentaires facultatifs.

-- LSRPCore.Commands.Refresh(source)
-- Fonction pour rafraîchir les suggestions de commandes pour un joueur spécifique.
-- - source: La source du joueur.

-- LSRPCore.Commands.Add('tp', Lang:t('command.tp.help'), { { name = Lang:t('command.tp.params.x.name'), help = Lang:t('command.tp.params.x.help') }, { name = Lang:t('command.tp.params.y.name'), help = Lang:t('command.tp.params.y.help') }, { name = Lang:t('command.tp.params.z.name'), help = Lang:t('command.tp.params.z.help') } }, false, function(source, args)
-- Fonction de rappel pour la commande 'tp' (téléportation).
-- - source: La source du joueur.
-- - args: Les arguments de la commande.

-- LSRPCore.Commands.Add('tpm', Lang:t('command.tpm.help'), {}, false, function(source)
-- Fonction de rappel pour la commande 'tpm' (téléportation au marqueur).
-- - source: La source du joueur.

-- LSRPCore.Commands.Add('togglepvp', Lang:t('command.togglepvp.help'), {}, false, function()
-- Fonction de rappel pour la commande 'togglepvp' (activer/désactiver le mode PvP).

-- LSRPCore.Commands.Add('addpermission', Lang:t('command.addpermission.help'), { { name = Lang:t('command.addpermission.params.id.name'), help = Lang:t('command.addpermission.params.id.help') }, { name = Lang:t('command.addpermission.params.permission.name'), help = Lang:t('command.addpermission.params.permission.help') } }, true, function(source, args)
-- Fonction de rappel pour la commande 'addpermission' (ajouter une permission à un joueur).
-- - source: La source du joueur.
-- - args: Les arguments de la commande.

-- LSRPCore.Commands.Add('removepermission', Lang:t('command.removepermission.help'), { { name = Lang:t('command.removepermission.params.id.name'), help = Lang:t('command.removepermission.params.id.help') }, { name = Lang:t('command.removepermission.params.permission.name'), help = Lang:t('command.removepermission.params.permission.help') } }, true, function(source, args)
-- Fonction de rappel pour la commande 'removepermission' (supprimer une permission d'un joueur).
-- - source: La source du joueur.
-- - args: Les arguments de la commande.

-- LSRPCore.Commands.Add('openserver', Lang:t('command.openserver.help'), {}, false, function(source)
-- Fonction de rappel pour la commande 'openserver' (ouvrir le serveur).
-- - source: La source du joueur.

-- LSRPCore.Commands.Add('closeserver', Lang:t('command.closeserver.help'), { { name = Lang:t('command.closeserver.params.reason.name'), help = Lang:t('command.closeserver.params.reason.help') } }, false, function(source, args)
-- Fonction de rappel pour la commande 'closeserver' (fermer le serveur).
-- - source: La source du joueur.
-- - args: Les arguments de la commande.

-- LSRPCore.Commands.Add('car', Lang:t('command.car.help'), { { name = Lang:t('command.car.params.model.name'), help = Lang:t('command.car.params.model.help') } }, true, function(source, args)
-- Fonction de rappel pour la commande 'car' (faire apparaître un véhicule).
-- - source: La source du joueur.
-- - args: Les arguments de la commande.

-- LSRPCore.Commands.Add('dv', Lang:t('command.dv.help'), {}, false, function(source)
-- Fonction de rappel pour la commande 'dv' (supprimer le véhicule du joueur).
-- - source: La source du joueur.

-- LSRPCore.Commands.Add('dvall', Lang:t('command.dvall.help'), {}, false, function()
-- Fonction de rappel pour la commande 'dvall' (supprimer tous les véhicules du serveur).

-- LSRPCore.Commands.Add('dvp', Lang:t('command.dvp.help'), {}, false, function()
-- Fonction de rappel pour la commande 'dvp' (supprimer tous les PNJ du serveur).
LSRPCore.Commands = {}
LSRPCore.Commands.List = {}
LSRPCore.Commands.IgnoreList = { -- Ignore old perm levels while keeping backwards compatibility
    ['god'] = true,            -- We don't need to create an ace because god is allowed all commands
    ['user'] = true            -- We don't need to create an ace because builtin.everyone
}

CreateThread(function() -- Add ace to node for perm checking
    local permissions = LSRPCore.Config.Server.Permissions
    for i = 1, #permissions do
        local permission = permissions[i]
        ExecuteCommand(('add_ace lsrpcore.%s %s allow'):format(permission, permission))
    end
end)

-- Register & Refresh Commands

function LSRPCore.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    local restricted = true                                  -- Default to restricted for all commands
    if not permission then permission = 'user' end           -- some commands don't pass permission level
    if permission == 'user' then restricted = false end      -- allow all users to use command

    RegisterCommand(name, function(source, args, rawCommand) -- Register command within fivem
        if argsrequired and #args < #arguments then
            return TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0 },
                multiline = true,
                args = { 'System', Lang:t('error.missing_args2') }
            })
        end
        callback(source, args, rawCommand)
    end, restricted)

    local extraPerms = ... and table.pack(...) or nil
    if extraPerms then
        extraPerms[extraPerms.n + 1] = permission -- The `n` field is the number of arguments in the packed table
        extraPerms.n += 1
        permission = extraPerms
        for i = 1, permission.n do
            if not LSRPCore.Commands.IgnoreList[permission[i]] then -- only create aces for extra perm levels
                ExecuteCommand(('add_ace lsrpcore.%s command.%s allow'):format(permission[i], name))
            end
        end
        permission.n = nil
    else
        permission = tostring(permission:lower())
        if not LSRPCore.Commands.IgnoreList[permission] then -- only create aces for extra perm levels
            ExecuteCommand(('add_ace lsrpcore.%s command.%s allow'):format(permission, name))
        end
    end

    LSRPCore.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

function LSRPCore.Commands.Refresh(source)
    local src = source
    local Player = LSRPCore.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(LSRPCore.Commands.List) do
            local hasPerm = IsPlayerAceAllowed(tostring(src), 'command.' .. command)
            if hasPerm then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/' .. command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', src, suggestions)
    end
end

-- Teleport
LSRPCore.Commands.Add('tp', Lang:t('command.tp.help'), { { name = Lang:t('command.tp.params.x.name'), help = Lang:t('command.tp.params.x.help') }, { name = Lang:t('command.tp.params.y.name'), help = Lang:t('command.tp.params.y.help') }, { name = Lang:t('command.tp.params.z.name'), help = Lang:t('command.tp.params.z.help') } }, false, function(source, args)
    if args[1] and not args[2] and not args[3] then
        if tonumber(args[1]) then
            local target = GetPlayerPed(tonumber(args[1]))
            if target ~= 0 then
                local coords = GetEntityCoords(target)
                TriggerClientEvent('LSRPCore:Command:TeleportToPlayer', source, coords)
            else
                TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
            end
        else
            local location = LSRPShared.Locations[args[1]]
            if location then
                TriggerClientEvent('LSRPCore:Command:TeleportToCoords', source, location.x, location.y, location.z, location.w)
            else
                TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.location_not_exist'), 'error')
            end
        end
    else
        if args[1] and args[2] and args[3] then
            local x = tonumber((args[1]:gsub(',', ''))) + .0
            local y = tonumber((args[2]:gsub(',', ''))) + .0
            local z = tonumber((args[3]:gsub(',', ''))) + .0
            if x ~= 0 and y ~= 0 and z ~= 0 then
                TriggerClientEvent('LSRPCore:Command:TeleportToCoords', source, x, y, z)
            else
                TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.wrong_format'), 'error')
            end
        else
            TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.missing_args'), 'error')
        end
    end
end, 'admin')

LSRPCore.Commands.Add('tpm', Lang:t('command.tpm.help'), {}, false, function(source)
    TriggerClientEvent('LSRPCore:Command:GoToMarker', source)
end, 'admin')

LSRPCore.Commands.Add('togglepvp', Lang:t('command.togglepvp.help'), {}, false, function()
    LSRPCore.Config.Server.PVP = not LSRPCore.Config.Server.PVP
    TriggerClientEvent('LSRPCore:Client:PvpHasToggled', -1, LSRPCore.Config.Server.PVP)
end, 'admin')

-- Permissions

LSRPCore.Commands.Add('addpermission', Lang:t('command.addpermission.help'), { { name = Lang:t('command.addpermission.params.id.name'), help = Lang:t('command.addpermission.params.id.help') }, { name = Lang:t('command.addpermission.params.permission.name'), help = Lang:t('command.addpermission.params.permission.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        LSRPCore.Functions.AddPermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

LSRPCore.Commands.Add('removepermission', Lang:t('command.removepermission.help'), { { name = Lang:t('command.removepermission.params.id.name'), help = Lang:t('command.removepermission.params.id.help') }, { name = Lang:t('command.removepermission.params.permission.name'), help = Lang:t('command.removepermission.params.permission.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    local permission = tostring(args[2]):lower()
    if Player then
        LSRPCore.Functions.RemovePermission(Player.PlayerData.source, permission)
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'god')

-- Open & Close Server

LSRPCore.Commands.Add('openserver', Lang:t('command.openserver.help'), {}, false, function(source)
    if not LSRPCore.Config.Server.Closed then
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.server_already_open'), 'error')
        return
    end
    if LSRPCore.Functions.HasPermission(source, 'admin') then
        LSRPCore.Config.Server.Closed = false
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('success.server_opened'), 'success')
    else
        LSRPCore.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

LSRPCore.Commands.Add('closeserver', Lang:t('command.closeserver.help'), { { name = Lang:t('command.closeserver.params.reason.name'), help = Lang:t('command.closeserver.params.reason.help') } }, false, function(source, args)
    if LSRPCore.Config.Server.Closed then
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.server_already_closed'), 'error')
        return
    end
    if LSRPCore.Functions.HasPermission(source, 'admin') then
        local reason = args[1] or 'No reason specified'
        LSRPCore.Config.Server.Closed = true
        LSRPCore.Config.Server.ClosedReason = reason
        for k in pairs(LSRPCore.Players) do
            if not LSRPCore.Functions.HasPermission(k, LSRPCore.Config.Server.WhitelistPermission) then
                LSRPCore.Functions.Kick(k, reason, nil, nil)
            end
        end
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('success.server_closed'), 'success')
    else
        LSRPCore.Functions.Kick(source, Lang:t('error.no_permission'), nil, nil)
    end
end, 'admin')

-- Vehicle

LSRPCore.Commands.Add('car', Lang:t('command.car.help'), { { name = Lang:t('command.car.params.model.name'), help = Lang:t('command.car.params.model.help') } }, true, function(source, args)
    TriggerClientEvent('LSRPCore:Command:SpawnVehicle', source, args[1])
end, 'admin')

LSRPCore.Commands.Add('dv', Lang:t('command.dv.help'), {}, false, function(source)
    TriggerClientEvent('LSRPCore:Command:DeleteVehicle', source)
end, 'admin')

LSRPCore.Commands.Add('dvall', Lang:t('command.dvall.help'), {}, false, function()
    local vehicles = GetAllVehicles()
    for _, vehicle in ipairs(vehicles) do
        DeleteEntity(vehicle)
    end
end, 'admin')

-- Peds

LSRPCore.Commands.Add('dvp', Lang:t('command.dvp.help'), {}, false, function()
    local peds = GetAllPeds()
    for _, ped in ipairs(peds) do
        DeleteEntity(ped)
    end
end, 'admin')

-- Objects

LSRPCore.Commands.Add('dvo', Lang:t('command.dvo.help'), {}, false, function()
    local objects = GetAllObjects()
    for _, object in ipairs(objects) do
        DeleteEntity(object)
    end
end, 'admin')

-- Money

LSRPCore.Commands.Add('givemoney', Lang:t('command.givemoney.help'), { { name = Lang:t('command.givemoney.params.id.name'), help = Lang:t('command.givemoney.params.id.help') }, { name = Lang:t('command.givemoney.params.moneytype.name'), help = Lang:t('command.givemoney.params.moneytype.help') }, { name = Lang:t('command.givemoney.params.amount.name'), help = Lang:t('command.givemoney.params.amount.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]), 'Admin give money')
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

LSRPCore.Commands.Add('setmoney', Lang:t('command.setmoney.help'), { { name = Lang:t('command.setmoney.params.id.name'), help = Lang:t('command.setmoney.params.id.help') }, { name = Lang:t('command.setmoney.params.moneytype.name'), help = Lang:t('command.setmoney.params.moneytype.help') }, { name = Lang:t('command.setmoney.params.amount.name'), help = Lang:t('command.setmoney.params.amount.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Job

LSRPCore.Commands.Add('job', Lang:t('command.job.help'), {}, false, function(source)
    local PlayerJob = LSRPCore.Functions.GetPlayer(source).PlayerData.job
    TriggerClientEvent('LSRPCore:Notify', source, Lang:t('info.job_info', { value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty }))
end, 'user')

LSRPCore.Commands.Add('setjob', Lang:t('command.setjob.help'), { { name = Lang:t('command.setjob.params.id.name'), help = Lang:t('command.setjob.params.id.help') }, { name = Lang:t('command.setjob.params.job.name'), help = Lang:t('command.setjob.params.job.help') }, { name = Lang:t('command.setjob.params.grade.name'), help = Lang:t('command.setjob.params.grade.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetJob(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Gang

LSRPCore.Commands.Add('gang', Lang:t('command.gang.help'), {}, false, function(source)
    local PlayerGang = LSRPCore.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('LSRPCore:Notify', source, Lang:t('info.gang_info', { value = PlayerGang.label, value2 = PlayerGang.grade.name }))
end, 'user')

LSRPCore.Commands.Add('setgang', Lang:t('command.setgang.help'), { { name = Lang:t('command.setgang.params.id.name'), help = Lang:t('command.setgang.params.id.help') }, { name = Lang:t('command.setgang.params.gang.name'), help = Lang:t('command.setgang.params.gang.help') }, { name = Lang:t('command.setgang.params.grade.name'), help = Lang:t('command.setgang.params.grade.help') } }, true, function(source, args)
    local Player = LSRPCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        Player.Functions.SetGang(tostring(args[2]), tonumber(args[3]))
    else
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

-- Out of Character Chat
LSRPCore.Commands.Add('ooc', Lang:t('command.ooc.help'), {}, false, function(source, args)
    local message = table.concat(args, ' ')
    local Players = LSRPCore.Functions.GetPlayers()
    local Player = LSRPCore.Functions.GetPlayer(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    for _, v in pairs(Players) do
        if v == source then
            TriggerClientEvent('chat:addMessage', v, {
                color = LSRPCore.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < 20.0 then
            TriggerClientEvent('chat:addMessage', v, {
                color = LSRPCore.Config.Commands.OOCColor,
                multiline = true,
                args = { 'OOC | ' .. GetPlayerName(source), message }
            })
        elseif LSRPCore.Functions.HasPermission(v, 'admin') then
            if LSRPCore.Functions.IsOptin(v) then
                TriggerClientEvent('chat:addMessage', v, {
                    color = LSRPCore.Config.Commands.OOCColor,
                    multiline = true,
                    args = { 'Proximity OOC | ' .. GetPlayerName(source), message }
                })
                TriggerEvent('lsrp-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Message:** ' .. message, false)
            end
        end
    end
end, 'user')

-- Me command

LSRPCore.Commands.Add('me', Lang:t('command.me.help'), { { name = Lang:t('command.me.params.message.name'), help = Lang:t('command.me.params.message.help') } }, false, function(source, args)
    if #args < 1 then
        TriggerClientEvent('LSRPCore:Notify', source, Lang:t('error.missing_args2'), 'error')
        return
    end
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local msg = table.concat(args, ' '):gsub('[~<].-[>~]', '')
    local Players = LSRPCore.Functions.GetPlayers()
    for i = 1, #Players do
        local Player = Players[i]
        local target = GetPlayerPed(Player)
        local tCoords = GetEntityCoords(target)
        if target == ped or #(pCoords - tCoords) < 20 then
            TriggerClientEvent('LSRPCore:Command:ShowMe3D', Player, source, msg)
        end
    end
end, 'user')
