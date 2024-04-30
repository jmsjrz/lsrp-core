-- LSRPShared est une table qui contient les fonctionnalités partagées du script LSRP.
LSRPShared = LSRPShared or {}

-- LSRPShared.Gangs est une table qui contient les informations sur les gangs du jeu.
LSRPShared.Gangs = {
    none = { label = 'Aucun Gang', grades = { ['0'] = { name = 'Non affilié' } } },
    lostmc = {
        label = 'The Lost MC',
        grades = {
            ['0'] = { name = 'Recrue' },
            ['1'] = { name = 'Enforcer' },
            ['2'] = { name = 'Shot Caller' },
            ['3'] = { name = 'Boss', isboss = true },
        },
    },
    ballas = {
        label = 'Ballas',
        grades = {
            ['0'] = { name = 'Recrue' },
            ['1'] = { name = 'Enforcer' },
            ['2'] = { name = 'Shot Caller' },
            ['3'] = { name = 'Boss', isboss = true },
        },
    },
}
