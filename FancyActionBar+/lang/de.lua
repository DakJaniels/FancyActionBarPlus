-- Add German translations
SafeAddString(FANCYAB_SUBMENU_GENERAL, "|cFFFACDAllgemein|r", 2)
SafeAddString(FANCYAB_SUBMENU_CUSTOMUI, "|cFFFACDUI-Anpassung|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMER, "|cFFFACDTimer-Anzeige|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB, "|cFFFACDTastatur-UI|r", 2)
SafeAddString(FANCYAB_SUBMENU_DECIMALS, "|cFFFACDTimer-Dezimalstellen|r", 2)
SafeAddString(FANCYAB_SUBMENU_MISC, "|cFFFACDSonstiges|r", 2)

-- Timer descriptions
SafeAddString(FANCYAB_SUBMENU_TIMER_DESC, "Hier können Sie die Größe und Position der Timer-, Stapel- und Zielanzeigen anpassen.\nDie Einstellungen sind individuell für die Tastatur- und Gamepad-UI in ihrem jeweiligen Untermenü und können unabhängig vom aktuellen UI-Modus geändert werden.\nDie Timer-Dezimaloptionen gelten für beide UI-Modi", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB_DESC, "Tastatur-UI Timer-Anzeigeeinstellungen", 2)
SafeAddString(FANCYAB_SUBMENU_STACKKB_DESC, "Tastatur-UI Stapelzähler-Anzeigeeinstellungen", 2)
SafeAddString(FANCYAB_SUBMENU_TARGETKB_DESC, "Tastatur-UI Zielzähler-Anzeigeeinstellungen", 2)

-- Categories
SafeAddString(FANCYAB_CAT_BBVISUAL, "[ |cffdf80Rückleisten-Sichtbarkeit|r ]", 2)
SafeAddString(FANCYAB_CAT_HOTKEY, "[ |cffdf80Tastenkürzel-Text|r ]", 2)
SafeAddString(FANCYAB_CAT_FRAMES, "[ |cffdf80Schaltflächen-Rahmen|r ]", 2)
SafeAddString(FANCYAB_CAT_HIGHLIGHT, "[ |cffdf80Aktive Fähigkeiten-Hervorhebung|r ]", 2)
SafeAddString(FANCYAB_CAT_ARROW, "[ |cffdf80Aktive Leisten-Pfeil|r ]", 2)
SafeAddString(FANCYAB_CAT_MARKER, "[ |cffdf80Gegner-Markierungen|r ]", 2)
SafeAddString(FANCYAB_CAT_DEBUG, "[ |cffdf80Fehlerbehebung|r ]", 2)

-- Category descriptions
SafeAddString(FANCYAB_CAT_FRAMES_DESC, "Nur für Tastatur-UI.", 2)
SafeAddString(FANCYAB_CAT_ARROW_DESC, "Führen Sie einen Waffenwechsel durch, nachdem Sie auf die Pfeil-Anzeige-Schaltfläche geklickt haben, damit die Änderung wirksam wird.", 2)
SafeAddString(FANCYAB_CAT_MARKER_DESC, "Ja... Das habe ich komplett von Untaunted übernommen.", 2)

-- Alpha settings
SafeAddString(FANCYAB_ALPHA_NAME, "Inaktive Leisten-Transparenz", 2)
SafeAddString(FANCYAB_ALPHA_TT, "Höherer Wert = undurchsichtiger.\nNiedriger Wert = durchsichtiger.", 2)

-- Desaturation settings
SafeAddString(FANCYAB_DESAT_NAME, "Inaktive Leisten-Entsättigung", 2)
SafeAddString(FANCYAB_DESAT_TT, "Höherer Wert = grauer.\nNiedriger Wert = farbiger.", 2)

-- Hotkey settings
SafeAddString(FANCYAB_HOTKEY_NAME, "Tastenkürzel anzeigen", 2)
SafeAddString(FANCYAB_HOTKEY_TT, "Zeigt Tastenkürzel unter der Aktionsleiste an.", 2)

-- Frame settings
SafeAddString(FANCYAB_FRAME_NAME, "Rahmen anzeigen", 2)
SafeAddString(FANCYAB_FRAME_TT, "Zeigt einen Rahmen um die Schaltflächen auf der Aktionsleiste an.", 2)
SafeAddString(FANCYAB_FRAME_COLOR, "Rahmenfarbe", 2)

-- Highlight settings
SafeAddString(FANCYAB_HIGHLIGHT_NAME, "Hervorhebung anzeigen", 2)
SafeAddString(FANCYAB_HIGHLIGHT_TT, "Aktive Fähigkeiten werden hervorgehoben.", 2)
SafeAddString(FANCYAB_HIGHLIGHT_COLOR, "Hervorhebungsfarbe", 2)

-- Arrow settings
SafeAddString(FANCYAB_ARROW_NAME, "Pfeil anzeigen", 2)
SafeAddString(FANCYAB_ARROW_TT, "Zeigt einen Pfeil neben der aktuell aktiven Leiste an.", 2)
SafeAddString(FANCYAB_ARROW_COLOR, "Pfeilfarbe", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_NAME, "Schnellzugriff-Position anpassen", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_TT, "Bewegt den Schnellzugriff näher an die Aktionsleiste, wenn der Pfeil ausgeblendet ist.\nNur für Tastatur-UI.", 2)

-- Timer font settings
SafeAddString(FANCYAB_TIMER_FONTKB_TT, "Timer-Schriftart für Tastatur-UI Timer.", 2)
SafeAddString(FANCYAB_TIMER_STYLEKB_TT, "Kanteneffekt für Tastatur-UI Timer-Zahlen.", 2)
SafeAddString(FANCYAB_STACK_FONTKB_TT, "Stapelzähler-Schriftart für Tastatur-UI.", 2)
SafeAddString(FANCYAB_STACK_STYLEKB_TT, "Kanteneffekt des Tastatur-UI Stapelzählers.", 2)
SafeAddString(FANCYAB_TARGET_FONTKB_TT, "Zielzähler-Schriftart für Tastatur-UI.", 2)
SafeAddString(FANCYAB_TARGET_STYLEKB_TT, "Kanteneffekt des Tastatur-UI Zielzählers.", 2)

-- Gamepad font settings
SafeAddString(FANCYAB_TIMER_FONTGP_TT, "Timer-Schriftart für Gamepad-UI Timer.", 2)
SafeAddString(FANCYAB_TIMER_STYLEGP_TT, "Kanteneffekt für Gamepad-UI Timer-Zahlen.", 2)
SafeAddString(FANCYAB_STACK_FONTGP_TT, "Stapelzähler-Schriftart für Gamepad-UI.", 2)
SafeAddString(FANCYAB_STACK_STYLEGP_TT, "Kanteneffekt des Gamepad-UI Stapelzählers.", 2)
SafeAddString(FANCYAB_TARGET_FONTGP_TT, "Zielzähler-Schriftart für Gamepad-UI.", 2)
SafeAddString(FANCYAB_TARGET_STYLEGP_TT, "Kanteneffekt des Gamepad-UI Zielzählers.", 2)

-- Timer settings
SafeAddString(FANCYAB_TIMER_FONT, "Timer-Schriftart", 2)
SafeAddString(FANCYAB_TIMER_SIZE, "Timer-Größe", 2)
SafeAddString(FANCYAB_TIMER_STYLE, "Timer-Stil", 2)
SafeAddString(FANCYAB_TIMER_Y_NAME, "Timer-Höhe anpassen", 2)
SafeAddString(FANCYAB_TIMER_Y_TT, "Timer [<- nach unten] oder [nach oben ->] bewegen", 2)

-- Stack settings
SafeAddString(FANCYAB_STACK_FONT, "Stapelzähler-Schriftart", 2)
SafeAddString(FANCYAB_STACK_SIZE, "Stapelzähler-Größe", 2)
SafeAddString(FANCYAB_STACK_STYLE, "Stapelzähler-Stil", 2)
SafeAddString(FANCYAB_STACK_X_NAME, "Stapelposition anpassen", 2)
SafeAddString(FANCYAB_STACK_X_TT, "Stapelzähler [<- nach links] oder [nach rechts ->] bewegen", 2)

-- Target settings
SafeAddString(FANCYAB_TARGET_FONT, "Zielzähler-Schriftart", 2)
SafeAddString(FANCYAB_TARGET_SIZE, "Zielzähler-Größe", 2)
SafeAddString(FANCYAB_TARGET_STYLE, "Zielzähler-Stil", 2)
SafeAddString(FANCYAB_TARGET_X_NAME, "Zielposition anpassen", 2)
SafeAddString(FANCYAB_TARGET_X_TT, "Zielzähler [<- nach links] oder [nach rechts ->] bewegen", 2)

-- Decimal settings
SafeAddString(FANCYAB_DECIMAL_CHOICE_NAME, "Timer-Dezimalstellen aktivieren", 2)
SafeAddString(FANCYAB_DECIMAL_CHOICE_TT, "Immer = Zeigt Dezimalstellen immer an, wenn der Timer aktiv ist.\nAblauf = Aktiviert weitere Optionen.\nNie = Nie.", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_NAME, "Dezimalstellen-Schwellenwert", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_TT, "Dezimalstellen werden angezeigt, wenn Timer unter die ausgewählte Sekundenzahl fallen", 2)

-- Expiry settings
SafeAddString(FANCYAB_EXPIRE_NAME, "Ablaufende Timer-Farbe ändern", 2)
SafeAddString(FANCYAB_EXPIRE_TT, "Ändert die Timer-Farbe, wenn die Dauer abläuft.", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_NAME, "Ablauf-Schwellenwert", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_TT, "Die Farbe ändert sich, wenn Timer unter die ausgewählte Sekundenzahl fallen, falls die Einstellung aktiviert ist", 2)
SafeAddString(FANCYAB_EXPIRE_COLOR, "Ablaufende Timer-Farbe", 2)

-- Marker settings
SafeAddString(FANCYAB_MARKER_NAME, "Gegner-Markierungen anzeigen", 2)
SafeAddString(FANCYAB_MARKER_TT, "Zeigt einen roten Pfeil über dem Kopf von Gegnern an, mit denen Sie sich im Kampf befinden.", 2)
SafeAddString(FANCYAB_MARKER_SIZE, "Gegner-Markierungsgröße", 2)

-- Debug settings
SafeAddString(FANCYAB_DBG_NAME, "Debug-Modus", 2)
SafeAddString(FANCYAB_DBG_TT, "Zeigt Fähigkeits-Update-Ereignisse im Chat an (|cFF0000SPAM-WARNUNG!|r).", 2)

-- Disclaimer
SafeAddString(FANCYAB_DISCLAIMER, "Alle Anerkennung geht an |cFFFF00@andy.s|r für seine unglaubliche Arbeit und sein Engagement für die Community.\nZunächst habe ich nur einige Anpassungen vorgenommen, um es besser an meine persönlichen Bedürfnisse anzupassen, und Optionen hinzugefügt, um diese Anpassungen zu ermöglichen.\nDie Tracking-Funktionen für die Fähigkeits-Timer sind von der Arbeit von Solinur und Phinix inspiriert, und ich habe alles, was ich darüber weiß, aus dem Lesen ihres Codes gelernt (und ich habe noch viel zu lernen).", 2)
