-- Spanish translations
local strings =
{
    FANCYAB_SUBMENU_GENERAL = "|cFFFACDGeneral|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDPersonalización de la interfaz|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDVisualizador del temporizador|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDInterfaz de teclado|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDDecimales del temporizador|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDMiscelánea|r",

    -- Timer descriptions
    FANCYAB_SUBMENU_TIMER_DESC = "Aquí puedes ajustar el tamaño y la posición de las visualizaciones del temporizador, pilas y conteo de objetivos.\nLa configuración es individual para las interfaces de teclado y mando en sus respectivos submenús, y se puede cambiar independientemente del modo de interfaz actual.\nLas opciones de decimales del temporizador se aplican a ambos modos de interfaz",
    FANCYAB_SUBMENU_TIMERKB_DESC = "Configuración de visualización del temporizador para la interfaz de teclado",
    FANCYAB_SUBMENU_STACKKB_DESC = "Configuración de visualización del contador de pilas para la interfaz de teclado",
    FANCYAB_SUBMENU_TARGETKB_DESC = "Configuración de visualización del contador de objetivos para la interfaz de teclado",

    -- Categories
    FANCYAB_CAT_BBVISUAL = "[ |cffdf80Visibilidad de la barra trasera|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80Texto de teclas rápidas|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80Marcos de botones|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80Resaltado de habilidad activa|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80Flecha de barra activa|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80Marcadores de enemigos|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80Depuración|r ]",

    -- Category descriptions
    FANCYAB_CAT_FRAMES_DESC = "Solo para la interfaz de teclado.",
    FANCYAB_CAT_ARROW_DESC = "Cambia de arma una vez después de hacer clic en el botón Mostrar flecha para que el cambio surta efecto.",
    FANCYAB_CAT_MARKER_DESC = "Sí... Lo tomé completamente de Untaunted.",

    -- Alpha settings
    FANCYAB_ALPHA_NAME = "Transparencia de barra inactiva",
    FANCYAB_ALPHA_TT = "Valor más alto = más sólido.\nValor más bajo = más transparente.",

    -- Desaturation settings
    FANCYAB_DESAT_NAME = "Desaturación de barra inactiva",
    FANCYAB_DESAT_TT = "Valor más alto = más gris.\nValor más bajo = más colores.",

    -- Hotkey settings
    FANCYAB_HOTKEY_NAME = "Mostrar teclas rápidas",
    FANCYAB_HOTKEY_TT = "Mostrar teclas rápidas debajo de la barra de acción.",

    -- Frame settings
    FANCYAB_FRAME_NAME = "Mostrar marcos",
    FANCYAB_FRAME_TT = "Mostrar un marco alrededor de los botones en la barra de acción.",
    FANCYAB_FRAME_COLOR = "Color del marco",

    -- Highlight settings
    FANCYAB_HIGHLIGHT_NAME = "Mostrar resaltado",
    FANCYAB_HIGHLIGHT_TT = "Las habilidades activas serán resaltadas.",
    FANCYAB_HIGHLIGHT_COLOR = "Color de resaltado",

    -- Arrow settings
    FANCYAB_ARROW_NAME = "Mostrar flecha",
    FANCYAB_ARROW_TT = "Mostrar una flecha cerca de la barra actualmente activa.",
    FANCYAB_ARROW_COLOR = "Color de la flecha",
    FANCYAB_ARROW_ADJUSTQS_NAME = "Ajustar posición de ranura rápida",
    FANCYAB_ARROW_ADJUSTQS_TT = "Mover la ranura rápida más cerca de la barra de acción si la flecha está oculta.\nSolo para interfaz de teclado.",

    -- Timer font settings
    FANCYAB_TIMER_FONTKB_TT = "Fuente del temporizador para la interfaz de teclado.",
    FANCYAB_TIMER_STYLEKB_TT = "Efecto de borde para los números del temporizador en la interfaz de teclado.",
    FANCYAB_STACK_FONTKB_TT = "Fuente del contador de pilas para la interfaz de teclado.",
    FANCYAB_STACK_STYLEKB_TT = "Efecto de borde del contador de pilas en la interfaz de teclado.",
    FANCYAB_TARGET_FONTKB_TT = "Fuente del contador de objetivos para la interfaz de teclado.",
    FANCYAB_TARGET_STYLEKB_TT = "Efecto de borde del contador de objetivos en la interfaz de teclado.",

    -- Gamepad font settings
    FANCYAB_TIMER_FONTGP_TT = "Fuente del temporizador para la interfaz de mando.",
    FANCYAB_TIMER_STYLEGP_TT = "Efecto de borde para los números del temporizador en la interfaz de mando.",
    FANCYAB_STACK_FONTGP_TT = "Fuente del contador de pilas para la interfaz de mando.",
    FANCYAB_STACK_STYLEGP_TT = "Efecto de borde del contador de pilas en la interfaz de mando.",
    FANCYAB_TARGET_FONTGP_TT = "Fuente del contador de objetivos para la interfaz de mando.",
    FANCYAB_TARGET_STYLEGP_TT = "Efecto de borde del contador de objetivos en la interfaz de mando.",

    -- Timer settings
    FANCYAB_TIMER_FONT = "Fuente del temporizador",
    FANCYAB_TIMER_SIZE = "Tamaño del temporizador",
    FANCYAB_TIMER_STYLE = "Estilo del temporizador",
    FANCYAB_TIMER_Y_NAME = "Ajustar altura del temporizador",
    FANCYAB_TIMER_Y_TT = "Mover temporizador [<- abajo] o [arriba ->]",

    -- Stack settings
    FANCYAB_STACK_FONT = "Fuente del contador de pilas",
    FANCYAB_STACK_SIZE = "Tamaño del contador de pilas",
    FANCYAB_STACK_STYLE = "Estilo del contador de pilas",
    FANCYAB_STACK_X_NAME = "Ajustar posición de pilas",
    FANCYAB_STACK_X_TT = "Mover contador de pilas [<- izquierda] o [derecha ->]",

    -- Target settings
    FANCYAB_TARGET_FONT = "Fuente del contador de objetivos",
    FANCYAB_TARGET_SIZE = "Tamaño del contador de objetivos",
    FANCYAB_TARGET_STYLE = "Estilo del contador de objetivos",
    FANCYAB_TARGET_X_NAME = "Ajustar posición de objetivos",
    FANCYAB_TARGET_X_TT = "Mover contador de objetivos [<- izquierda] o [derecha ->]",

    -- Decimal settings
    FANCYAB_DECIMAL_CHOICE_NAME = "Habilitar decimales del temporizador",
    FANCYAB_DECIMAL_CHOICE_TT = "Siempre = Siempre mostrará decimales si el temporizador está activo.\nExpiración = Habilitará más opciones.\nNunca = Nunca.",
    FANCYAB_DECIMAL_THOLD_NAME = "Umbral de decimales",
    FANCYAB_DECIMAL_THOLD_TT = "Los decimales se mostrarán cuando los temporizadores caigan por debajo de la cantidad seleccionada de segundos restantes",

    -- Expiry settings
    FANCYAB_EXPIRE_NAME = "Cambiar color del temporizador al expirar",
    FANCYAB_EXPIRE_TT = "Cambiar el color del temporizador cuando la duración está por terminar.",
    FANCYAB_EXPIRE_THOLD_NAME = "Umbral de expiración",
    FANCYAB_EXPIRE_THOLD_TT = "El color cambiará cuando los temporizadores caigan por debajo de la cantidad seleccionada de segundos restantes si la configuración está habilitada",
    FANCYAB_EXPIRE_COLOR = "Color del temporizador al expirar",

    -- Marker settings
    FANCYAB_MARKER_NAME = "Mostrar marcadores de enemigos",
    FANCYAB_MARKER_TT = "Mostrar una flecha roja sobre la cabeza de los enemigos con los que estás actualmente en combate.",
    FANCYAB_MARKER_SIZE = "Tamaño del marcador de enemigos",

    -- Debug settings
    FANCYAB_DBG_NAME = "Modo de depuración",
    FANCYAB_DBG_TT = "Mostrar eventos de actualización de habilidades en el chat (|cFF0000¡ADVERTENCIA DE SPAM!|r).",

    -- Disclaimer
    FANCYAB_DISCLAIMER = "Todo el crédito es para |cFFFF00@andy.s|r por su increíble trabajo y dedicación a la comunidad.\nAl principio solo hice algunos cambios de personalización para adaptarlo mejor a mis necesidades personales y agregué opciones para permitir estos ajustes.\nLas funciones de seguimiento para los temporizadores de habilidades están inspiradas en el trabajo de Solinur y Phinix, y he aprendido todo lo que sé al leer su código (y todavía tengo mucho que aprender).",

}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
