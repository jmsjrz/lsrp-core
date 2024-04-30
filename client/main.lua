-- LSRPCore est une table qui contient les données et les fonctionnalités principales du script client LSRP.
LSRPCore = {}

-- LSRPCore.PlayerData est une table qui stocke les données du joueur.
LSRPCore.PlayerData = {}

-- LSRPCore.Config est une variable qui contient la configuration du script LSRP.
LSRPCore.Config = LSRPConfig

-- LSRPCore.Shared est une variable qui contient les fonctionnalités partagées du script LSRP.
LSRPCore.Shared = LSRPShared

-- LSRPCore.ClientCallbacks est une table qui stocke les rappels (callbacks) du client.
LSRPCore.ClientCallbacks = {}

-- LSRPCore.ServerCallbacks est une table qui stocke les rappels (callbacks) du serveur.
LSRPCore.ServerCallbacks = {}

-- Cette fonction exporte l'objet LSRPCore pour être utilisé dans d'autres scripts.
-- Elle renvoie la table LSRPCore.
exports('GetCoreObject', function()
    return LSRPCore
end)

-- Pour utiliser cette exportation dans un script au lieu de la méthode du manifeste,
-- il suffit d'ajouter cette ligne de code en haut du script.
-- local LSRPCore = exports['lsrp-core']:GetCoreObject()
