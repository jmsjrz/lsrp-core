-- Cette partie du code contient deux boucles qui s'exécutent en parallèle.
-- La première boucle est responsable de la mise à jour régulière du joueur connecté.
-- La deuxième boucle gère la diminution de la faim et de la soif du joueur.

-- Boucle de mise à jour du joueur
CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            -- Calcul du temps de sommeil en fonction de l'intervalle de mise à jour configuré
            sleep = (1000 * 60) * LSRPCore.Config.UpdateInterval
            -- Envoi d'un événement au serveur pour mettre à jour les informations du joueur
            TriggerServerEvent('LSRPCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

-- Boucle de gestion de la faim et de la soif du joueur
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            -- Vérification si la faim ou la soif du joueur est inférieure ou égale à zéro
            -- et si le joueur n'est pas mort ou en état critique
            if (LSRPCore.PlayerData.metadata['hunger'] <= 0 or LSRPCore.PlayerData.metadata['thirst'] <= 0) and not (LSRPCore.PlayerData.metadata['isdead'] or LSRPCore.PlayerData.metadata['inlaststand']) then
                -- Réduction de la santé du joueur de manière aléatoire
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)
                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end
        -- Attente de l'intervalle de statut configuré
        Wait(LSRPCore.Config.StatusInterval)
    end
end)
