--- @class Locale
--- Classe représentant une instance de localisation.
Locale = {}
Locale.__index = Locale

--- Fonction de traduction d'une clé de phrase avec des substitutions.
--- @param phrase string - La phrase à traduire.
--- @param subs table<string, any> - Tableau des substitutions.
--- @return string - La phrase traduite.
local function translateKey(phrase, subs)
    if type(phrase) ~= 'string' then
        error('TypeError: la fonction translateKey attend une chaîne de caractères en argument #1')
    end

    -- Substitutions
    if not subs then
        return phrase
    end

    -- Échapper gsub au cas où il y aurait des modèles de substitution imbriqués ou une injection
    -- Créer et copier notre chaîne de retour
    local result = phrase

    -- Analyse initiale de la chaîne de retour à la recherche de substitutions
    for k, v in pairs(subs) do
        local templateToFind = '%%{' .. k .. '}'
        result = result:gsub(templateToFind, tostring(v)) -- chaîne pour permettre tous les types
    end

    return result
end

--- Fonction de constructeur pour une nouvelle instance de la classe Locale.
--- @param opts table<string, any> - Paramètres de construction.
--- @return Locale - La nouvelle instance de la classe Locale.
function Locale.new(_, opts)
    local self = setmetatable({}, Locale)

    self.fallback = opts.fallbackLang and Locale:new({
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
    }) or false

    self.warnOnMissing = type(opts.warnOnMissing) ~= 'boolean' and true or opts.warnOnMissing

    self.phrases = {}
    self:extend(opts.phrases or {})

    return self
end

--- Méthode pour étendre la table des phrases d'une instance.
--- @param phrases table<string, string> - Tableau des définitions de phrases.
--- @param prefix string | nil - Préfixe optionnel utilisé pour les appels récursifs.
--- @return nil
function Locale:extend(phrases, prefix)
    for key, phrase in pairs(phrases) do
        local prefixKey = prefix and ('%s.%s'):format(prefix, key) or key
        -- Si c'est une table imbriquée, nous devons aller récursivement
        if type(phrase) == 'table' then
            self:extend(phrase, prefixKey)
        else
            self.phrases[prefixKey] = phrase
        end
    end
end

--- Efface les phrases de l'instance de localisation.
--- Peut être utile pour la gestion de la mémoire des grandes tables de phrases.
--- @return nil
function Locale:clear()
    self.phrases = {}
end

--- Efface toutes les phrases et les remplace par le tableau de phrases passé en argument.
--- @param phrases table<string, any> - Le tableau de phrases à utiliser.
function Locale:replace(phrases)
    phrases = phrases or {}
    self:clear()
    self:extend(phrases)
end

--- Obtient ou définit une localisation en fonction de l'argument passé.
--- @param newLocale string - La nouvelle localisation à définir.
--- @return string - La localisation actuelle.
function Locale:locale(newLocale)
    if (newLocale) then
        self.currentLocale = newLocale
    end
    return self.currentLocale
end

--- Méthode de traduction principale pour une phrase donnée.
--- @param key string - La clé de la phrase à traduire.
--- @param subs table<string, any> | nil - Tableau des substitutions.
--- @return string - La phrase traduite.
function Locale:t(key, subs)
    local phrase, result
    subs = subs or {}

    -- Vérifier si la clé passée correspond à une chaîne de phrase valide
    if type(self.phrases[key]) == 'string' then
        phrase = self.phrases[key]
        -- À ce stade, nous savons si la phrase n'existe pas pour cette clé
    else
        if self.warnOnMissing then
            print(('^3Avertissement : Phrase manquante pour la clé : "%s"'):format(key))
        end
        if self.fallback then
            return self.fallback:t(key, subs)
        end
        result = key
    end

    if type(phrase) == 'string' then
        result = translateKey(phrase, subs)
    end

    return result
end

--- Vérifie si une clé de phrase est déjà définie dans les phrases de l'instance de Locale.
--- @return boolean - Vrai si la clé existe, sinon faux.
function Locale:has(key)
    return self.phrases[key] ~= nil
end

--- Supprime les clés de phrase d'une instance de Locale, en utilisant la récursion.
--- @param phraseTarget string | table - La cible de la suppression.
--- @param prefix string - Le préfixe.
function Locale:delete(phraseTarget, prefix)
    -- Si la cible est une chaîne de caractères, nous savons que c'est la fin
    -- de l'arbre de table imbriquée.
    if type(phraseTarget) == 'string' then
        self.phrases[phraseTarget] = nil
    else
        for key, phrase in pairs(phraseTarget) do
            local prefixKey = prefix and prefix .. '.' .. key or key

            if type(phrase) == 'table' then
                self:delete(phrase, prefixKey)
            else
                self.phrases[prefixKey] = nil
            end
        end
    end
end
