-- Russian translations
local strings =
{

    FANCYAB_SUBMENU_GENERAL = "|cFFFACDОбщее|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDНастройка интерфейса|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDОтображение таймера|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDИнтерфейс клавиатуры|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDДесятичные таймера|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDРазное|r",

    -- Timer descriptions
    FANCYAB_SUBMENU_TIMER_DESC = "Здесь вы можете настроить размер и положение отображения таймера, стаков и счетчика целей.\nНастройки индивидуальны для интерфейсов клавиатуры и геймпада в их соответствующих подменю и могут быть изменены независимо от текущего режима интерфейса.\nНастройки десятичных знаков таймера применяются к обоим режимам интерфейса",
    FANCYAB_SUBMENU_TIMERKB_DESC = "Настройки отображения таймера для интерфейса клавиатуры",
    FANCYAB_SUBMENU_STACKKB_DESC = "Настройки отображения счетчика стаков для интерфейса клавиатуры",
    FANCYAB_SUBMENU_TARGETKB_DESC = "Настройки отображения счетчика целей для интерфейса клавиатуры",

    -- Categories
    FANCYAB_CAT_BBVISUAL = "[ |cffdf80Видимость задней панели|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80Текст горячих клавиш|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80Рамки кнопок|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80Подсветка активных умений|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80Стрелка активной панели|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80Маркеры врагов|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80Отладка|r ]",

    -- Category descriptions
    FANCYAB_CAT_FRAMES_DESC = "Только для интерфейса клавиатуры.",
    FANCYAB_CAT_ARROW_DESC = "Смените оружие один раз после нажатия кнопки Показать стрелку, чтобы изменение вступило в силу.",
    FANCYAB_CAT_MARKER_DESC = "Да... Я полностью позаимствовал это из Untaunted.",

    -- Alpha settings
    FANCYAB_ALPHA_NAME = "Прозрачность неактивной панели",
    FANCYAB_ALPHA_TT = "Большее значение = более непрозрачно.\nМеньшее значение = более прозрачно.",

    -- Desaturation settings
    FANCYAB_DESAT_NAME = "Обесцвечивание неактивной панели",
    FANCYAB_DESAT_TT = "Большее значение = более серый.\nМеньшее значение = более цветной.",

    -- Hotkey settings
    FANCYAB_HOTKEY_NAME = "Показывать горячие клавиши",
    FANCYAB_HOTKEY_TT = "Показывать горячие клавиши под панелью действий.",

    -- Frame settings
    FANCYAB_FRAME_NAME = "Показывать рамки",
    FANCYAB_FRAME_TT = "Показывать рамку вокруг кнопок на панели действий.",
    FANCYAB_FRAME_COLOR = "Цвет рамки",

    -- Highlight settings
    FANCYAB_HIGHLIGHT_NAME = "Показывать подсветку",
    FANCYAB_HIGHLIGHT_TT = "Активные умения будут подсвечены.",
    FANCYAB_HIGHLIGHT_COLOR = "Цвет подсветки",

    -- Arrow settings
    FANCYAB_ARROW_NAME = "Показывать стрелку",
    FANCYAB_ARROW_TT = "Показывать стрелку рядом с активной панелью.",
    FANCYAB_ARROW_COLOR = "Цвет стрелки",
    FANCYAB_ARROW_ADJUSTQS_NAME = "Настроить положение быстрого слота",
    FANCYAB_ARROW_ADJUSTQS_TT = "Переместить быстрый слот ближе к панели действий, если стрелка скрыта.\nТолько для интерфейса клавиатуры.",

    -- Timer font settings
    FANCYAB_TIMER_FONTKB_TT = "Шрифт таймера для интерфейса клавиатуры.",
    FANCYAB_TIMER_STYLEKB_TT = "Эффект обводки для чисел таймера в интерфейсе клавиатуры.",
    FANCYAB_STACK_FONTKB_TT = "Шрифт счетчика стаков для интерфейса клавиатуры.",
    FANCYAB_STACK_STYLEKB_TT = "Эффект обводки счетчика стаков в интерфейсе клавиатуры.",
    FANCYAB_TARGET_FONTKB_TT = "Шрифт счетчика целей для интерфейса клавиатуры.",
    FANCYAB_TARGET_STYLEKB_TT = "Эффект обводки счетчика целей в интерфейсе клавиатуры.",

    -- Gamepad font settings
    FANCYAB_TIMER_FONTGP_TT = "Шрифт таймера для интерфейса геймпада.",
    FANCYAB_TIMER_STYLEGP_TT = "Эффект обводки для чисел таймера в интерфейсе геймпада.",
    FANCYAB_STACK_FONTGP_TT = "Шрифт счетчика стаков для интерфейса геймпада.",
    FANCYAB_STACK_STYLEGP_TT = "Эффект обводки счетчика стаков в интерфейсе геймпада.",
    FANCYAB_TARGET_FONTGP_TT = "Шрифт счетчика целей для интерфейса геймпада.",
    FANCYAB_TARGET_STYLEGP_TT = "Эффект обводки счетчика целей в интерфейсе геймпада.",

    -- Timer settings
    FANCYAB_TIMER_FONT = "Шрифт таймера",
    FANCYAB_TIMER_SIZE = "Размер таймера",
    FANCYAB_TIMER_STYLE = "Стиль таймера",
    FANCYAB_TIMER_Y_NAME = "Настроить высоту таймера",
    FANCYAB_TIMER_Y_TT = "Переместить таймер [<- вниз] или [вверх ->]",

    -- Stack settings
    FANCYAB_STACK_FONT = "Шрифт счетчика стаков",
    FANCYAB_STACK_SIZE = "Размер счетчика стаков",
    FANCYAB_STACK_STYLE = "Стиль счетчика стаков",
    FANCYAB_STACK_X_NAME = "Настроить положение стаков",
    FANCYAB_STACK_X_TT = "Переместить счетчик стаков [<- влево] или [вправо ->]",

    -- Target settings
    FANCYAB_TARGET_FONT = "Шрифт счетчика целей",
    FANCYAB_TARGET_SIZE = "Размер счетчика целей",
    FANCYAB_TARGET_STYLE = "Стиль счетчика целей",
    FANCYAB_TARGET_X_NAME = "Настроить положение целей",
    FANCYAB_TARGET_X_TT = "Переместить счетчик целей [<- влево] или [вправо ->]",

    -- Decimal settings
    FANCYAB_DECIMAL_CHOICE_NAME = "Включить десятичные знаки таймера",
    FANCYAB_DECIMAL_CHOICE_TT = "Всегда = Всегда показывать десятичные знаки, если таймер активен.\nПри истечении = Включит дополнительные опции.\nНикогда = Никогда.",
    FANCYAB_DECIMAL_THOLD_NAME = "Порог десятичных знаков",
    FANCYAB_DECIMAL_THOLD_TT = "Десятичные знаки будут показаны, когда таймеры упадут ниже выбранного количества оставшихся секунд",

    -- Expiry settings
    FANCYAB_EXPIRE_NAME = "Изменять цвет истекающего таймера",
    FANCYAB_EXPIRE_TT = "Изменять цвет таймера, когда время действия истекает.",
    FANCYAB_EXPIRE_THOLD_NAME = "Порог истечения",
    FANCYAB_EXPIRE_THOLD_TT = "Цвет изменится, когда таймеры упадут ниже выбранного количества оставшихся секунд, если настройка включена",
    FANCYAB_EXPIRE_COLOR = "Цвет истекающего таймера",

    -- Marker settings
    FANCYAB_MARKER_NAME = "Показывать маркеры врагов",
    FANCYAB_MARKER_TT = "Показывать красную стрелку над головой врагов, с которыми вы сейчас в бою.",
    FANCYAB_MARKER_SIZE = "Размер маркера врагов",

    -- Debug settings
    FANCYAB_DBG_NAME = "Режим отладки",
    FANCYAB_DBG_TT = "Показывать события обновления умений в чате (|cFF0000ВНИМАНИЕ: СПАМ!|r).",

    -- Disclaimer
    FANCYAB_DISCLAIMER = "Вся заслуга принадлежит |cFFFF00@andy.s|r за его невероятную работу и преданность сообществу.\nСначала я сделал лишь несколько изменений для настройки под свои личные потребности и добавил опции для включения этих настроек.\nФункции отслеживания для таймеров умений вдохновлены работой Solinur и Phinix, и я узнал все, что знаю, читая их код (и мне еще многому предстоит научиться).",

}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
