-- Configuration du serveur LSRP
LSRPConfig = {}

-- Nombre maximum de joueurs sur le serveur
LSRPConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Obtient le nombre maximum de joueurs à partir du fichier de configuration, par défaut 48

-- Position de spawn par défaut des joueurs
LSRPConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)

-- Intervalle de mise à jour des données des joueurs en minutes
LSRPConfig.UpdateInterval = 5

-- Intervalle de vérification de l'état de faim/soif en millisecondes
LSRPConfig.StatusInterval = 5000

-- Configuration de l'argent
LSRPConfig.Money = {}
LSRPConfig.Money.MoneyTypes = { cash = 500, bank = 5000, crypto = 0 } -- type = montant initial - Ajoutez ou supprimez des types d'argent pour votre serveur (par exemple, blackmoney = 0), rappelez-vous qu'une fois ajouté, il ne sera pas supprimé de la base de données !
LSRPConfig.Money.DontAllowMinus = { 'cash', 'crypto' } -- Argent qui n'est pas autorisé à être négatif
LSRPConfig.Money.PayCheckTimeOut = 10 -- Temps en minutes avant de recevoir le salaire
LSRPConfig.Money.PayCheckSociety = false -- Si vrai, le salaire proviendra du compte de la société à laquelle le joueur est employé, nécessite lsrp-management

-- Configuration du joueur
LSRPConfig.Player = {}
LSRPConfig.Player.HungerRate = 4.2 -- Taux de diminution de la faim
LSRPConfig.Player.ThirstRate = 3.8 -- Taux de diminution de la soif
LSRPConfig.Player.Bloodtypes = {
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
}

-- Configuration du serveur
LSRPConfig.Server = {}
LSRPConfig.Server.Closed = false -- Définit si le serveur est fermé (personne ne peut rejoindre sauf les personnes ayant la permission ace 'lsrpadmin.join')
LSRPConfig.Server.ClosedReason = 'Serveur fermé' -- Message de raison à afficher lorsque les gens ne peuvent pas rejoindre le serveur
LSRPConfig.Server.Uptime = 0 -- Temps depuis lequel le serveur est en ligne
LSRPConfig.Server.Whitelist = false -- Active ou désactive la liste blanche sur le serveur
LSRPConfig.Server.WhitelistPermission = 'admin' -- Permission qui permet d'entrer sur le serveur lorsque la liste blanche est activée
LSRPConfig.Server.PVP = true -- Active ou désactive le PVP sur le serveur (possibilité de tirer sur d'autres joueurs)
LSRPConfig.Server.Discord = '' -- Lien d'invitation Discord
LSRPConfig.Server.CheckDuplicateLicense = true -- Vérifie les licences Rockstar en double lors de la connexion
LSRPConfig.Server.Permissions = { 'god', 'admin', 'mod' } -- Ajoutez autant de groupes que vous le souhaitez ici après les avoir créés dans votre server.cfg

-- Configuration des commandes
LSRPConfig.Commands = {}
LSRPConfig.Commands.OOCColor = { 255, 151, 133 } -- Code RGB de couleur pour la commande OOC

-- Configuration des notifications
LSRPConfig.Notify = {}

-- Configuration du style des notifications
LSRPConfig.Notify.NotificationStyling = {
    group = false, -- Permet aux notifications de s'empiler avec un badge au lieu de se répéter
    position = 'right', -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = true -- Affiche une barre de progression
}

-- Définition des différentes variantes de notifications
-- La clé "color" est la couleur de fond de la notification
-- La clé "icon" est le code de l'icône CSS, ce projet utilise `Material Icons` & `Font Awesome`
LSRPConfig.Notify.VariantDefinitions = {
    success = {
        classes = 'success',
        icon = 'check_circle'
    },
    primary = {
        classes = 'primary',
        icon = 'notifications'
    },
    warning = {
        classes = 'warning',
        icon = 'warning'
    },
    error = {
        classes = 'error',
        icon = 'error'
    },
    police = {
        classes = 'police',
        icon = 'local_police'
    },
    ambulance = {
        classes = 'ambulance',
        icon = 'fas fa-ambulance'
    }
}
