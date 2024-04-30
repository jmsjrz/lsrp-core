-- Cette fonction affiche le contenu d'une table de manière récursive avec un formatage spécifique.
-- Elle prend en paramètre la table à afficher (tbl) et le niveau d'indentation (indent).
local function tPrint(tbl, indent)
    indent = indent or 0
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            local tblType = type(v)
            local formatting = ('%s ^3%s:^0'):format(string.rep('  ', indent), k)

            if tblType == 'table' then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == 'boolean' then
                print(('%s^1 %s ^0'):format(formatting, v))
            elseif tblType == 'function' then
                print(('%s^9 %s ^0'):format(formatting, v))
            elseif tblType == 'number' then
                print(('%s^5 %s ^0'):format(formatting, v))
            elseif tblType == 'string' then
                print(("%s ^2'%s' ^0"):format(formatting, v))
            else
                print(('%s^2 %s ^0'):format(formatting, v))
            end
        end
    else
        print(('%s ^0%s'):format(string.rep('  ', indent), tbl))
    end
end

-- Cette fonction est un événement serveur qui affiche le contenu d'une table avec un formatage spécifique.
-- Elle prend en paramètre la table à afficher (tbl), le niveau d'indentation (indent) et le nom de la ressource (resource).
RegisterServerEvent('LSRPCore:DebugSomething', function(tbl, indent, resource)
    print(('\x1b[4m\x1b[36m[ %s : DEBUG]\x1b[0m'):format(resource))
    tPrint(tbl, indent)
    print('\x1b[4m\x1b[36m[ END DEBUG ]\x1b[0m')
end)

-- Cette fonction est utilisée pour afficher le contenu d'une table avec un formatage spécifique.
-- Elle prend en paramètre la table à afficher (tbl) et le niveau d'indentation (indent).
function LSRPCore.Debug(tbl, indent)
    TriggerEvent('LSRPCore:DebugSomething', tbl, indent, GetInvokingResource() or 'lsrp-core')
end

-- Cette fonction affiche un message d'erreur avec le nom de la ressource et le message spécifié.
-- Elle prend en paramètre le nom de la ressource (resource) et le message d'erreur (msg).
function LSRPCore.ShowError(resource, msg)
    print('\x1b[31m[' .. resource .. ':ERROR]\x1b[0m ' .. msg)
end

-- Cette fonction affiche un message de succès avec le nom de la ressource et le message spécifié.
-- Elle prend en paramètre le nom de la ressource (resource) et le message de succès (msg).
function LSRPCore.ShowSuccess(resource, msg)
    print('\x1b[32m[' .. resource .. ':LOG]\x1b[0m ' .. msg)
end
