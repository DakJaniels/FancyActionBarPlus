-- Add French translations
SafeAddString(FANCYAB_SUBMENU_GENERAL, "|cFFFACDGénéral|r", 2)
SafeAddString(FANCYAB_SUBMENU_CUSTOMUI, "|cFFFACDPersonnalisation de l'interface|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMER, "|cFFFACDAffichage du minuteur|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB, "|cFFFACDInterface clavier|r", 2)
SafeAddString(FANCYAB_SUBMENU_DECIMALS, "|cFFFACDDécimales du minuteur|r", 2)
SafeAddString(FANCYAB_SUBMENU_MISC, "|cFFFACDDivers|r", 2)

-- Timer descriptions
SafeAddString(FANCYAB_SUBMENU_TIMER_DESC, "Ici, vous pouvez ajuster la taille et la position des affichages du minuteur, des piles et du nombre de cibles.\nLes paramètres sont individuels pour les interfaces clavier et manette dans leurs sous-menus respectifs, et peuvent être modifiés quel que soit le mode d'interface actuel.\nLes options des décimales du minuteur s'appliquent aux deux modes d'interface", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB_DESC, "Paramètres d'affichage du minuteur pour l'interface clavier", 2)
SafeAddString(FANCYAB_SUBMENU_STACKKB_DESC, "Paramètres d'affichage du compteur de piles pour l'interface clavier", 2)
SafeAddString(FANCYAB_SUBMENU_TARGETKB_DESC, "Paramètres d'affichage du compteur de cibles pour l'interface clavier", 2)

-- Categories
SafeAddString(FANCYAB_CAT_BBVISUAL, "[ |cffdf80Visibilité de la barre arrière|r ]", 2)
SafeAddString(FANCYAB_CAT_HOTKEY, "[ |cffdf80Texte des raccourcis|r ]", 2)
SafeAddString(FANCYAB_CAT_FRAMES, "[ |cffdf80Cadres des boutons|r ]", 2)
SafeAddString(FANCYAB_CAT_HIGHLIGHT, "[ |cffdf80Surbrillance des capacités actives|r ]", 2)
SafeAddString(FANCYAB_CAT_ARROW, "[ |cffdf80Flèche de barre active|r ]", 2)
SafeAddString(FANCYAB_CAT_MARKER, "[ |cffdf80Marqueurs d'ennemis|r ]", 2)
SafeAddString(FANCYAB_CAT_DEBUG, "[ |cffdf80Débogage|r ]", 2)

-- Category descriptions
SafeAddString(FANCYAB_CAT_FRAMES_DESC, "Uniquement pour l'interface clavier.", 2)
SafeAddString(FANCYAB_CAT_ARROW_DESC, "Changez d'arme une fois après avoir cliqué sur le bouton Afficher la flèche pour que le changement prenne effet.", 2)
SafeAddString(FANCYAB_CAT_MARKER_DESC, "Oui... J'ai complètement emprunté ceci à Untaunted.", 2)

-- Alpha settings
SafeAddString(FANCYAB_ALPHA_NAME, "Transparence de la barre inactive", 2)
SafeAddString(FANCYAB_ALPHA_TT, "Valeur plus élevée = plus solide.\nValeur plus basse = plus transparent.", 2)

-- Desaturation settings
SafeAddString(FANCYAB_DESAT_NAME, "Désaturation de la barre inactive", 2)
SafeAddString(FANCYAB_DESAT_TT, "Valeur plus élevée = plus gris.\nValeur plus basse = plus de couleurs.", 2)

-- Hotkey settings
SafeAddString(FANCYAB_HOTKEY_NAME, "Afficher les raccourcis", 2)
SafeAddString(FANCYAB_HOTKEY_TT, "Afficher les raccourcis sous la barre d'action.", 2)

-- Frame settings
SafeAddString(FANCYAB_FRAME_NAME, "Afficher les cadres", 2)
SafeAddString(FANCYAB_FRAME_TT, "Afficher un cadre autour des boutons de la barre d'action.", 2)
SafeAddString(FANCYAB_FRAME_COLOR, "Couleur du cadre", 2)

-- Highlight settings
SafeAddString(FANCYAB_HIGHLIGHT_NAME, "Afficher la surbrillance", 2)
SafeAddString(FANCYAB_HIGHLIGHT_TT, "Les capacités actives seront mises en surbrillance.", 2)
SafeAddString(FANCYAB_HIGHLIGHT_COLOR, "Couleur de surbrillance", 2)

-- Arrow settings
SafeAddString(FANCYAB_ARROW_NAME, "Afficher la flèche", 2)
SafeAddString(FANCYAB_ARROW_TT, "Afficher une flèche près de la barre actuellement active.", 2)
SafeAddString(FANCYAB_ARROW_COLOR, "Couleur de la flèche", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_NAME, "Ajuster la position de l'emplacement rapide", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_TT, "Déplacer l'emplacement rapide plus près de la barre d'action si la flèche est masquée.\nUniquement pour l'interface clavier.", 2)

-- Timer font settings
SafeAddString(FANCYAB_TIMER_FONTKB_TT, "Police du minuteur pour l'interface clavier.", 2)
SafeAddString(FANCYAB_TIMER_STYLEKB_TT, "Effet de bordure pour les chiffres du minuteur de l'interface clavier.", 2)
SafeAddString(FANCYAB_STACK_FONTKB_TT, "Police du compteur de piles pour l'interface clavier.", 2)
SafeAddString(FANCYAB_STACK_STYLEKB_TT, "Effet de bordure du compteur de piles de l'interface clavier.", 2)
SafeAddString(FANCYAB_TARGET_FONTKB_TT, "Police du compteur de cibles pour l'interface clavier.", 2)
SafeAddString(FANCYAB_TARGET_STYLEKB_TT, "Effet de bordure du compteur de cibles de l'interface clavier.", 2)

-- Gamepad font settings
SafeAddString(FANCYAB_TIMER_FONTGP_TT, "Police du minuteur pour l'interface manette.", 2)
SafeAddString(FANCYAB_TIMER_STYLEGP_TT, "Effet de bordure pour les chiffres du minuteur de l'interface manette.", 2)
SafeAddString(FANCYAB_STACK_FONTGP_TT, "Police du compteur de piles pour l'interface manette.", 2)
SafeAddString(FANCYAB_STACK_STYLEGP_TT, "Effet de bordure du compteur de piles de l'interface manette.", 2)
SafeAddString(FANCYAB_TARGET_FONTGP_TT, "Police du compteur de cibles pour l'interface manette.", 2)
SafeAddString(FANCYAB_TARGET_STYLEGP_TT, "Effet de bordure du compteur de cibles de l'interface manette.", 2)

-- Timer settings
SafeAddString(FANCYAB_TIMER_FONT, "Police du minuteur", 2)
SafeAddString(FANCYAB_TIMER_SIZE, "Taille du minuteur", 2)
SafeAddString(FANCYAB_TIMER_STYLE, "Style du minuteur", 2)
SafeAddString(FANCYAB_TIMER_Y_NAME, "Ajuster la hauteur du minuteur", 2)
SafeAddString(FANCYAB_TIMER_Y_TT, "Déplacer le minuteur [<- bas] ou [haut ->]", 2)

-- Stack settings
SafeAddString(FANCYAB_STACK_FONT, "Police du compteur de piles", 2)
SafeAddString(FANCYAB_STACK_SIZE, "Taille du compteur de piles", 2)
SafeAddString(FANCYAB_STACK_STYLE, "Style du compteur de piles", 2)
SafeAddString(FANCYAB_STACK_X_NAME, "Ajuster la position des piles", 2)
SafeAddString(FANCYAB_STACK_X_TT, "Déplacer le compteur de piles [<- gauche] ou [droite ->]", 2)

-- Target settings
SafeAddString(FANCYAB_TARGET_FONT, "Police du compteur de cibles", 2)
SafeAddString(FANCYAB_TARGET_SIZE, "Taille du compteur de cibles", 2)
SafeAddString(FANCYAB_TARGET_STYLE, "Style du compteur de cibles", 2)
SafeAddString(FANCYAB_TARGET_X_NAME, "Ajuster la position des cibles", 2)
SafeAddString(FANCYAB_TARGET_X_TT, "Déplacer le compteur de cibles [<- gauche] ou [droite ->]", 2)

-- Decimal settings
SafeAddString(FANCYAB_DECIMAL_CHOICE_NAME, "Activer les décimales du minuteur", 2)
SafeAddString(FANCYAB_DECIMAL_CHOICE_TT, "Toujours = Affichera toujours les décimales si le minuteur est actif.\nExpiration = Activera plus d'options.\nJamais = Jamais.", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_NAME, "Seuil des décimales", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_TT, "Les décimales s'afficheront lorsque les minuteurs passeront sous le nombre de secondes restantes sélectionné", 2)

-- Expiry settings
SafeAddString(FANCYAB_EXPIRE_NAME, "Changer la couleur du minuteur à l'expiration", 2)
SafeAddString(FANCYAB_EXPIRE_TT, "Changer la couleur du minuteur lorsque la durée arrive à expiration.", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_NAME, "Seuil d'expiration", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_TT, "La couleur changera lorsque les minuteurs passeront sous le nombre de secondes restantes sélectionné si le paramètre est activé", 2)
SafeAddString(FANCYAB_EXPIRE_COLOR, "Couleur du minuteur à l'expiration", 2)

-- Marker settings
SafeAddString(FANCYAB_MARKER_NAME, "Afficher les marqueurs d'ennemis", 2)
SafeAddString(FANCYAB_MARKER_TT, "Afficher une flèche rouge au-dessus de la tête des ennemis avec lesquels vous êtes actuellement en combat.", 2)
SafeAddString(FANCYAB_MARKER_SIZE, "Taille des marqueurs d'ennemis", 2)

-- Debug settings
SafeAddString(FANCYAB_DBG_NAME, "Mode débogage", 2)
SafeAddString(FANCYAB_DBG_TT, "Afficher les événements de mise à jour des capacités dans le chat (|cFF0000ATTENTION AU SPAM !|r).", 2)

-- Disclaimer
SafeAddString(FANCYAB_DISCLAIMER, "Tout le mérite revient à |cFFFF00@andy.s|r pour son travail incroyable et son dévouement envers la communauté.\nAu début, j'ai seulement fait quelques modifications de personnalisation pour mieux l'adapter à mes besoins personnels et ajouté des options pour permettre ces ajustements.\nLes fonctions de suivi pour les minuteurs de capacités sont inspirées du travail de Solinur et Phinix, et j'ai appris tout ce que je sais en lisant leur code (et j'ai encore beaucoup à apprendre).", 2)
