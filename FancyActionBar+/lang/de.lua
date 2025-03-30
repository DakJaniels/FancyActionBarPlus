-- German translations
local strings =
{
    FANCYAB_SUBMENU_GENERAL = "|cFFFACDAllgemein|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDUI-Anpassung|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDTimer-Anzeige|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDTastatur-UI|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDTimer-Dezimalstellen|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDSonstiges|r",

    -- Timer descriptions
    FANCYAB_SUBMENU_TIMER_DESC = "Hier können Sie die Größe und Position der Timer-, Stapel- und Zielanzeigen anpassen.\nDie Einstellungen sind individuell für die Tastatur- und Gamepad-UI in ihrem jeweiligen Untermenü und können unabhängig vom aktuellen UI-Modus geändert werden.\nDie Timer-Dezimaloptionen gelten für beide UI-Modi",
    FANCYAB_SUBMENU_TIMERKB_DESC = "Tastatur-UI Timer-Anzeigeeinstellungen",
    FANCYAB_SUBMENU_STACKKB_DESC = "Tastatur-UI Stapelzähler-Anzeigeeinstellungen",
    FANCYAB_SUBMENU_TARGETKB_DESC = "Tastatur-UI Zielzähler-Anzeigeeinstellungen",

    -- Categories
    FANCYAB_CAT_BBVISUAL = "[ |cffdf80Rückleisten-Sichtbarkeit|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80Tastenkürzel-Text|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80Schaltflächen-Rahmen|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80Aktive Fähigkeiten-Hervorhebung|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80Aktive Leisten-Pfeil|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80Gegner-Markierungen|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80Fehlerbehebung|r ]",

    -- Category descriptions
    FANCYAB_CAT_FRAMES_DESC = "Nur für Tastatur-UI.",
    FANCYAB_CAT_ARROW_DESC = "Führen Sie einen Waffenwechsel durch, nachdem Sie auf die Pfeil-Anzeige-Schaltfläche geklickt haben, damit die Änderung wirksam wird.",
    FANCYAB_CAT_MARKER_DESC = "Ja... Das habe ich komplett von Untaunted übernommen.",

    -- Alpha settings
    FANCYAB_ALPHA_NAME = "Inaktive Leisten-Transparenz",
    FANCYAB_ALPHA_TT = "Höherer Wert = undurchsichtiger.\nNiedriger Wert = durchsichtiger.",

    -- Desaturation settings
    FANCYAB_DESAT_NAME = "Inaktive Leisten-Entsättigung",
    FANCYAB_DESAT_TT = "Höherer Wert = grauer.\nNiedriger Wert = farbiger.",

    -- Hotkey settings
    FANCYAB_HOTKEY_NAME = "Tastenkürzel anzeigen",
    FANCYAB_HOTKEY_TT = "Zeigt Tastenkürzel unter der Aktionsleiste an.",

    -- Frame settings
    FANCYAB_FRAME_NAME = "Rahmen anzeigen",
    FANCYAB_FRAME_TT = "Zeigt einen Rahmen um die Schaltflächen auf der Aktionsleiste an.",
    FANCYAB_FRAME_COLOR = "Rahmenfarbe",

    -- Highlight settings
    FANCYAB_HIGHLIGHT_NAME = "Hervorhebung anzeigen",
    FANCYAB_HIGHLIGHT_TT = "Aktive Fähigkeiten werden hervorgehoben.",
    FANCYAB_HIGHLIGHT_COLOR = "Hervorhebungsfarbe",

    -- Arrow settings
    FANCYAB_ARROW_NAME = "Pfeil anzeigen",
    FANCYAB_ARROW_TT = "Zeigt einen Pfeil neben der aktuell aktiven Leiste an.",
    FANCYAB_ARROW_COLOR = "Pfeilfarbe",
    FANCYAB_ARROW_ADJUSTQS_NAME = "Schnellzugriff-Position anpassen",
    FANCYAB_ARROW_ADJUSTQS_TT = "Bewegt den Schnellzugriff näher an die Aktionsleiste, wenn der Pfeil ausgeblendet ist.\nNur für Tastatur-UI.",

    -- Timer font settings
    FANCYAB_TIMER_FONTKB_TT = "Timer-Schriftart für Tastatur-UI Timer.",
    FANCYAB_TIMER_STYLEKB_TT = "Kanteneffekt für Tastatur-UI Timer-Zahlen.",
    FANCYAB_STACK_FONTKB_TT = "Stapelzähler-Schriftart für Tastatur-UI.",
    FANCYAB_STACK_STYLEKB_TT = "Kanteneffekt des Tastatur-UI Stapelzählers.",
    FANCYAB_TARGET_FONTKB_TT = "Zielzähler-Schriftart für Tastatur-UI.",
    FANCYAB_TARGET_STYLEKB_TT = "Kanteneffekt des Tastatur-UI Zielzählers.",

    -- Gamepad font settings
    FANCYAB_TIMER_FONTGP_TT = "Timer-Schriftart für Gamepad-UI Timer.",
    FANCYAB_TIMER_STYLEGP_TT = "Kanteneffekt für Gamepad-UI Timer-Zahlen.",
    FANCYAB_STACK_FONTGP_TT = "Stapelzähler-Schriftart für Gamepad-UI.",
    FANCYAB_STACK_STYLEGP_TT = "Kanteneffekt des Gamepad-UI Stapelzählers.",
    FANCYAB_TARGET_FONTGP_TT = "Zielzähler-Schriftart für Gamepad-UI.",
    FANCYAB_TARGET_STYLEGP_TT = "Kanteneffekt des Gamepad-UI Zielzählers.",

    -- Timer settings
    FANCYAB_TIMER_FONT = "Timer-Schriftart",
    FANCYAB_TIMER_SIZE = "Timer-Größe",
    FANCYAB_TIMER_STYLE = "Timer-Stil",
    FANCYAB_TIMER_Y_NAME = "Timer-Höhe anpassen",
    FANCYAB_TIMER_Y_TT = "Timer [<- nach unten] oder [nach oben ->] bewegen",

    -- Stack settings
    FANCYAB_STACK_FONT = "Stapelzähler-Schriftart",
    FANCYAB_STACK_SIZE = "Stapelzähler-Größe",
    FANCYAB_STACK_STYLE = "Stapelzähler-Stil",
    FANCYAB_STACK_X_NAME = "Stapelposition anpassen",
    FANCYAB_STACK_X_TT = "Stapelzähler [<- nach links] oder [nach rechts ->] bewegen",

    -- Target settings
    FANCYAB_TARGET_FONT = "Zielzähler-Schriftart",
    FANCYAB_TARGET_SIZE = "Zielzähler-Größe",
    FANCYAB_TARGET_STYLE = "Zielzähler-Stil",
    FANCYAB_TARGET_X_NAME = "Zielposition anpassen",
    FANCYAB_TARGET_X_TT = "Zielzähler [<- nach links] oder [nach rechts ->] bewegen",

    -- Decimal settings
    FANCYAB_DECIMAL_CHOICE_NAME = "Timer-Dezimalstellen aktivieren",
    FANCYAB_DECIMAL_CHOICE_TT = "Immer = Zeigt Dezimalstellen immer an, wenn der Timer aktiv ist.\nAblauf = Aktiviert weitere Optionen.\nNie = Nie.",
    FANCYAB_DECIMAL_THOLD_NAME = "Dezimalstellen-Schwellenwert",
    FANCYAB_DECIMAL_THOLD_TT = "Dezimalstellen werden angezeigt, wenn Timer unter die ausgewählte Sekundenzahl fallen",

    -- Expiry settings
    FANCYAB_EXPIRE_NAME = "Ablaufende Timer-Farbe ändern",
    FANCYAB_EXPIRE_TT = "Ändert die Timer-Farbe, wenn die Dauer abläuft.",
    FANCYAB_EXPIRE_THOLD_NAME = "Ablauf-Schwellenwert",
    FANCYAB_EXPIRE_THOLD_TT = "Die Farbe ändert sich, wenn Timer unter die ausgewählte Sekundenzahl fallen, falls die Einstellung aktiviert ist",
    FANCYAB_EXPIRE_COLOR = "Ablaufende Timer-Farbe",

    -- Marker settings
    FANCYAB_MARKER_NAME = "Gegner-Markierungen anzeigen",
    FANCYAB_MARKER_TT = "Zeigt einen roten Pfeil über dem Kopf von Gegnern an, mit denen Sie sich im Kampf befinden.",
    FANCYAB_MARKER_SIZE = "Gegner-Markierungsgröße",

    -- Debug settings
    FANCYAB_DBG_NAME = "Debug-Modus",
    FANCYAB_DBG_TT = "Zeigt Fähigkeits-Update-Ereignisse im Chat an (|cFF0000SPAM-WARNUNG!|r).",

    -- Disclaimer
    FANCYAB_DISCLAIMER = "Alle Anerkennung geht an |cFFFF00@andy.s|r für seine unglaubliche Arbeit und sein Engagement für die Community.\nZunächst habe ich nur einige Anpassungen vorgenommen, um es besser an meine persönlichen Bedürfnisse anzupassen, und Optionen hinzugefügt, um diese Anpassungen zu ermöglichen.\nDie Tracking-Funktionen für die Fähigkeits-Timer sind von der Arbeit von Solinur und Phinix inspiriert, und ich habe alles, was ich darüber weiß, aus dem Lesen ihres Codes gelernt (und ich habe noch viel zu lernen).",

}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
