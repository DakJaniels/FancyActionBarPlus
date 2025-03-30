-- French translations
local strings =
{
    FANCYAB_SUBMENU_GENERAL = "|cFFFACDGénéral|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDPersonnalisation de l'interface|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDAffichage du minuteur|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDInterface clavier|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDDécimales du minuteur|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDDivers|r",

    -- Timer descriptions
    FANCYAB_SUBMENU_TIMER_DESC = "Ici, vous pouvez ajuster la taille et la position des affichages du minuteur, des piles et du nombre de cibles.\nLes paramètres sont individuels pour les interfaces clavier et manette dans leurs sous-menus respectifs, et peuvent être modifiés quel que soit le mode d'interface actuel.\nLes options des décimales du minuteur s'appliquent aux deux modes d'interface",
    FANCYAB_SUBMENU_TIMERKB_DESC = "Paramètres d'affichage du minuteur pour l'interface clavier",
    FANCYAB_SUBMENU_STACKKB_DESC = "Paramètres d'affichage du compteur de piles pour l'interface clavier",
    FANCYAB_SUBMENU_TARGETKB_DESC = "Paramètres d'affichage du compteur de cibles pour l'interface clavier",

    -- Categories
    FANCYAB_CAT_BBVISUAL = "[ |cffdf80Visibilité de la barre arrière|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80Texte des raccourcis|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80Cadres des boutons|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80Surbrillance des capacités actives|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80Flèche de barre active|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80Marqueurs d'ennemis|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80Débogage|r ]",

    -- Category descriptions
    FANCYAB_CAT_FRAMES_DESC = "Uniquement pour l'interface clavier.",
    FANCYAB_CAT_ARROW_DESC = "Changez d'arme une fois après avoir cliqué sur le bouton Afficher la flèche pour que le changement prenne effet.",
    FANCYAB_CAT_MARKER_DESC = "Oui... J'ai complètement emprunté ceci à Untaunted.",

    -- Alpha settings
    FANCYAB_ALPHA_NAME = "Transparence de la barre inactive",
    FANCYAB_ALPHA_TT = "Valeur plus élevée = plus solide.\nValeur plus basse = plus transparent.",

    -- Desaturation settings
    FANCYAB_DESAT_NAME = "Désaturation de la barre inactive",
    FANCYAB_DESAT_TT = "Valeur plus élevée = plus gris.\nValeur plus basse = plus de couleurs.",

    -- Hotkey settings
    FANCYAB_HOTKEY_NAME = "Afficher les raccourcis",
    FANCYAB_HOTKEY_TT = "Afficher les raccourcis sous la barre d'action.",

    -- Frame settings
    FANCYAB_FRAME_NAME = "Afficher les cadres",
    FANCYAB_FRAME_TT = "Afficher un cadre autour des boutons de la barre d'action.",
    FANCYAB_FRAME_COLOR = "Couleur du cadre",

    -- Highlight settings
    FANCYAB_HIGHLIGHT_NAME = "Afficher la surbrillance",
    FANCYAB_HIGHLIGHT_TT = "Les capacités actives seront mises en surbrillance.",
    FANCYAB_HIGHLIGHT_COLOR = "Couleur de surbrillance",

    -- Arrow settings
    FANCYAB_ARROW_NAME = "Afficher la flèche",
    FANCYAB_ARROW_TT = "Afficher une flèche près de la barre actuellement active.",
    FANCYAB_ARROW_COLOR = "Couleur de la flèche",
    FANCYAB_ARROW_ADJUSTQS_NAME = "Ajuster la position de l'emplacement rapide",
    FANCYAB_ARROW_ADJUSTQS_TT = "Déplacer l'emplacement rapide plus près de la barre d'action si la flèche est masquée.\nUniquement pour l'interface clavier.",

    -- Timer font settings
    FANCYAB_TIMER_FONTKB_TT = "Police du minuteur pour l'interface clavier.",
    FANCYAB_TIMER_STYLEKB_TT = "Effet de bordure pour les chiffres du minuteur de l'interface clavier.",
    FANCYAB_STACK_FONTKB_TT = "Police du compteur de piles pour l'interface clavier.",
    FANCYAB_STACK_STYLEKB_TT = "Effet de bordure du compteur de piles de l'interface clavier.",
    FANCYAB_TARGET_FONTKB_TT = "Police du compteur de cibles pour l'interface clavier.",
    FANCYAB_TARGET_STYLEKB_TT = "Effet de bordure du compteur de cibles de l'interface clavier.",

    -- Gamepad font settings
    FANCYAB_TIMER_FONTGP_TT = "Police du minuteur pour l'interface manette.",
    FANCYAB_TIMER_STYLEGP_TT = "Effet de bordure pour les chiffres du minuteur de l'interface manette.",
    FANCYAB_STACK_FONTGP_TT = "Police du compteur de piles pour l'interface manette.",
    FANCYAB_STACK_STYLEGP_TT = "Effet de bordure du compteur de piles de l'interface manette.",
    FANCYAB_TARGET_FONTGP_TT = "Police du compteur de cibles pour l'interface manette.",
    FANCYAB_TARGET_STYLEGP_TT = "Effet de bordure du compteur de cibles de l'interface manette.",

    -- Timer settings
    FANCYAB_TIMER_FONT = "Police du minuteur",
    FANCYAB_TIMER_SIZE = "Taille du minuteur",
    FANCYAB_TIMER_STYLE = "Style du minuteur",
    FANCYAB_TIMER_Y_NAME = "Ajuster la hauteur du minuteur",
    FANCYAB_TIMER_Y_TT = "Déplacer le minuteur [<- bas] ou [haut ->]",

    -- Stack settings
    FANCYAB_STACK_FONT = "Police du compteur de piles",
    FANCYAB_STACK_SIZE = "Taille du compteur de piles",
    FANCYAB_STACK_STYLE = "Style du compteur de piles",
    FANCYAB_STACK_X_NAME = "Ajuster la position des piles",
    FANCYAB_STACK_X_TT = "Déplacer le compteur de piles [<- gauche] ou [droite ->]",

    -- Target settings
    FANCYAB_TARGET_FONT = "Police du compteur de cibles",
    FANCYAB_TARGET_SIZE = "Taille du compteur de cibles",
    FANCYAB_TARGET_STYLE = "Style du compteur de cibles",
    FANCYAB_TARGET_X_NAME = "Ajuster la position des cibles",
    FANCYAB_TARGET_X_TT = "Déplacer le compteur de cibles [<- gauche] ou [droite ->]",

    -- Decimal settings
    FANCYAB_DECIMAL_CHOICE_NAME = "Activer les décimales du minuteur",
    FANCYAB_DECIMAL_CHOICE_TT = "Toujours = Affichera toujours les décimales si le minuteur est actif.\nExpiration = Activera plus d'options.\nJamais = Jamais.",
    FANCYAB_DECIMAL_THOLD_NAME = "Seuil des décimales",
    FANCYAB_DECIMAL_THOLD_TT = "Les décimales s'afficheront lorsque les minuteurs passeront sous le nombre de secondes restantes sélectionné",

    -- Expiry settings
    FANCYAB_EXPIRE_NAME = "Changer la couleur du minuteur à l'expiration",
    FANCYAB_EXPIRE_TT = "Changer la couleur du minuteur lorsque la durée arrive à expiration.",
    FANCYAB_EXPIRE_THOLD_NAME = "Seuil d'expiration",
    FANCYAB_EXPIRE_THOLD_TT = "La couleur changera lorsque les minuteurs passeront sous le nombre de secondes restantes sélectionné si le paramètre est activé",
    FANCYAB_EXPIRE_COLOR = "Couleur du minuteur à l'expiration",

    -- Marker settings
    FANCYAB_MARKER_NAME = "Afficher les marqueurs d'ennemis",
    FANCYAB_MARKER_TT = "Afficher une flèche rouge au-dessus de la tête des ennemis avec lesquels vous êtes actuellement en combat.",
    FANCYAB_MARKER_SIZE = "Taille des marqueurs d'ennemis",

    -- Debug settings
    FANCYAB_DBG_NAME = "Mode débogage",
    FANCYAB_DBG_TT = "Afficher les événements de mise à jour des capacités dans le chat (|cFF0000ATTENTION AU SPAM !|r).",

    -- Disclaimer
    FANCYAB_DISCLAIMER = "Tout le mérite revient à |cFFFF00@andy.s|r pour son travail incroyable et son dévouement envers la communauté.\nAu début, j'ai seulement fait quelques modifications de personnalisation pour mieux l'adapter à mes besoins personnels et ajouté des options pour permettre ces ajustements.\nLes fonctions de suivi pour les minuteurs de capacités sont inspirées du travail de Solinur et Phinix, et j'ai appris tout ce que je sais en lisant leur code (et j'ai encore beaucoup à apprendre).",

}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
