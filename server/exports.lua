-- Cette section du code définit plusieurs méthodes pour ajouter, mettre à jour et supprimer des éléments dans les tables LSRPCore.Functions, LSRPCore.Shared.Jobs, LSRPCore.Shared.Items et LSRPCore.Shared.Gangs. Ces méthodes sont ensuite exportées pour être utilisées dans d'autres parties du code.

-- SetMethod: Ajoute ou modifie une méthode dans la table LSRPCore.Functions.
-- Paramètres:
--   - methodName (string): Le nom de la méthode.
--   - handler (function): La fonction qui sera exécutée lorsque la méthode est appelée.
-- Retourne:
--   - success (boolean): Indique si la méthode a été ajoutée ou modifiée avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function SetMethod(methodName, handler)
    -- ...
end

-- SetField: Ajoute ou modifie un champ dans la table LSRPCore.
-- Paramètres:
--   - fieldName (string): Le nom du champ.
--   - data (any): Les données à assigner au champ.
-- Retourne:
--   - success (boolean): Indique si le champ a été ajouté ou modifié avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function SetField(fieldName, data)
    -- ...
end

-- AddJob: Ajoute un emploi à la table LSRPCore.Shared.Jobs.
-- Paramètres:
--   - jobName (string): Le nom de l'emploi.
--   - job (table): Les données de l'emploi.
-- Retourne:
--   - success (boolean): Indique si l'emploi a été ajouté avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function AddJob(jobName, job)
    -- ...
end

-- AddJobs: Ajoute plusieurs emplois à la table LSRPCore.Shared.Jobs.
-- Paramètres:
--   - jobs (table): Une table contenant les noms des emplois en tant que clés et les données des emplois en tant que valeurs.
-- Retourne:
--   - success (boolean): Indique si les emplois ont été ajoutés avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
--   - errorItem (any): L'élément qui a causé une erreur lors de l'ajout des emplois.
local function AddJobs(jobs)
    -- ...
end

-- RemoveJob: Supprime un emploi de la table LSRPCore.Shared.Jobs.
-- Paramètres:
--   - jobName (string): Le nom de l'emploi à supprimer.
-- Retourne:
--   - success (boolean): Indique si l'emploi a été supprimé avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function RemoveJob(jobName)
    -- ...
end

-- UpdateJob: Met à jour un emploi dans la table LSRPCore.Shared.Jobs.
-- Paramètres:
--   - jobName (string): Le nom de l'emploi à mettre à jour.
--   - job (table): Les nouvelles données de l'emploi.
-- Retourne:
--   - success (boolean): Indique si l'emploi a été mis à jour avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function UpdateJob(jobName, job)
    -- ...
end

-- AddItem: Ajoute un élément à la table LSRPCore.Shared.Items.
-- Paramètres:
--   - itemName (string): Le nom de l'élément.
--   - item (table): Les données de l'élément.
-- Retourne:
--   - success (boolean): Indique si l'élément a été ajouté avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function AddItem(itemName, item)
    -- ...
end

-- UpdateItem: Met à jour un élément dans la table LSRPCore.Shared.Items.
-- Paramètres:
--   - itemName (string): Le nom de l'élément à mettre à jour.
--   - item (table): Les nouvelles données de l'élément.
-- Retourne:
--   - success (boolean): Indique si l'élément a été mis à jour avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function UpdateItem(itemName, item)
    -- ...
end

-- AddItems: Ajoute plusieurs éléments à la table LSRPCore.Shared.Items.
-- Paramètres:
--   - items (table): Une table contenant les noms des éléments en tant que clés et les données des éléments en tant que valeurs.
-- Retourne:
--   - success (boolean): Indique si les éléments ont été ajoutés avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
--   - errorItem (any): L'élément qui a causé une erreur lors de l'ajout des éléments.
local function AddItems(items)
    -- ...
end

-- RemoveItem: Supprime un élément de la table LSRPCore.Shared.Items.
-- Paramètres:
--   - itemName (string): Le nom de l'élément à supprimer.
-- Retourne:
--   - success (boolean): Indique si l'élément a été supprimé avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function RemoveItem(itemName)
    -- ...
end

-- AddGang: Ajoute un gang à la table LSRPCore.Shared.Gangs.
-- Paramètres:
--   - gangName (string): Le nom du gang.
--   - gang (table): Les données du gang.
-- Retourne:
--   - success (boolean): Indique si le gang a été ajouté avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function AddGang(gangName, gang)
    -- ...
end

-- AddGangs: Ajoute plusieurs gangs à la table LSRPCore.Shared.Gangs.
-- Paramètres:
--   - gangs (table): Une table contenant les noms des gangs en tant que clés et les données des gangs en tant que valeurs.
-- Retourne:
--   - success (boolean): Indique si les gangs ont été ajoutés avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
--   - errorItem (any): L'élément qui a causé une erreur lors de l'ajout des gangs.
local function AddGangs(gangs)
    -- ...
end

-- RemoveGang: Supprime un gang de la table LSRPCore.Shared.Gangs.
-- Paramètres:
--   - gangName (string): Le nom du gang à supprimer.
-- Retourne:
--   - success (boolean): Indique si le gang a été supprimé avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function RemoveGang(gangName)
    -- ...
end

-- UpdateGang: Met à jour un gang dans la table LSRPCore.Shared.Gangs.
-- Paramètres:
--   - gangName (string): Le nom du gang à mettre à jour.
--   - gang (table): Les nouvelles données du gang.
-- Retourne:
--   - success (boolean): Indique si le gang a été mis à jour avec succès.
--   - message (string): Un message décrivant le résultat de l'opération.
local function UpdateGang(gangName, gang)
    -- ...
end

-- GetCoreVersion: Récupère la version de LSRPCore.
-- Paramètres:
--   - InvokingResource (string): Le nom de la ressource qui appelle cette fonction (facultatif).
-- Retourne:
--   - resourceVersion (string): La version de LSRPCore.
local function GetCoreVersion(InvokingResource)
    -- ...
end

-- ExploitBan: Bannit un joueur pour exploitation de faille.
-- Paramètres:
--   - playerId (number): L'ID du joueur à bannir.
--   - origin (string): La description de l'exploitation de faille.
local function ExploitBan(playerId, origin)
    -- ...
end

-- Cette section exporte toutes les méthodes définies ci-dessus pour être utilisées dans d'autres parties du code.
exports('SetMethod', SetMethod)
exports('SetField', SetField)
exports('AddJob', AddJob)
exports('AddJobs', AddJobs)
exports('RemoveJob', RemoveJob)
exports('UpdateJob', UpdateJob)
exports('AddItem', AddItem)
exports('UpdateItem', UpdateItem)
exports('AddItems', AddItems)
exports('RemoveItem', RemoveItem)
exports('AddGang', AddGang)
exports('AddGangs', AddGangs)
exports('RemoveGang', RemoveGang)
exports('UpdateGang', UpdateGang)
exports('GetCoreVersion', GetCoreVersion)
exports('ExploitBan', ExploitBan)
-- Add or change (a) method(s) in the LSRPCore.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= 'string' then
        return false, 'invalid_method_name'
    end

    LSRPCore.Functions[methodName] = handler

    TriggerEvent('LSRPCore:Server:UpdateObject')

    return true, 'success'
end

LSRPCore.Functions.SetMethod = SetMethod
exports('SetMethod', SetMethod)

-- Add or change (a) field(s) in the LSRPCore table
local function SetField(fieldName, data)
    if type(fieldName) ~= 'string' then
        return false, 'invalid_field_name'
    end

    LSRPCore[fieldName] = data

    TriggerEvent('LSRPCore:Server:UpdateObject')

    return true, 'success'
end

LSRPCore.Functions.SetField = SetField
exports('SetField', SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if LSRPCore.Shared.Jobs[jobName] then
        return false, 'job_exists'
    end

    LSRPCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= 'string' then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if LSRPCore.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        LSRPCore.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('LSRPCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, message, nil
end

LSRPCore.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not LSRPCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    LSRPCore.Shared.Jobs[jobName] = nil

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not LSRPCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    LSRPCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if LSRPCore.Shared.Items[itemName] then
        return false, 'item_exists'
    end

    LSRPCore.Shared.Items[itemName] = item

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end
    if not LSRPCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end
    LSRPCore.Shared.Items[itemName] = item
    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= 'string' then
            message = 'invalid_item_name'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if LSRPCore.Shared.Items[key] then
            message = 'item_exists'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        LSRPCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('LSRPCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, message, nil
end

LSRPCore.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if not LSRPCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end

    LSRPCore.Shared.Items[itemName] = nil

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if LSRPCore.Shared.Gangs[gangName] then
        return false, 'gang_exists'
    end

    LSRPCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= 'string' then
            message = 'invalid_gang_name'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if LSRPCore.Shared.Gangs[key] then
            message = 'gang_exists'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        LSRPCore.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('LSRPCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, message, nil
end

LSRPCore.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not LSRPCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    LSRPCore.Shared.Gangs[gangName] = nil

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not LSRPCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    LSRPCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('LSRPCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('LSRPCore:Server:UpdateObject')
    return true, 'success'
end

LSRPCore.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local resourceName = GetCurrentResourceName()
local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(resourceName, 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(('%s called lsrpcore version check: %s'):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

LSRPCore.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        LSRPCore.Functions.GetIdentifier(playerId, 'license'),
        LSRPCore.Functions.GetIdentifier(playerId, 'discord'),
        LSRPCore.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', { discord = LSRPCore.Config.Server.Discord }))
    TriggerEvent('lsrp-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'red', name .. ' has been banned for exploiting ' .. origin, true)
end

exports('ExploitBan', ExploitBan)
