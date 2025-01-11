-- Add Russian translations
SafeAddString(FANCYAB_SUBMENU_GENERAL, "|cFFFACDОбщее|r", 2)
SafeAddString(FANCYAB_SUBMENU_CUSTOMUI, "|cFFFACDНастройка интерфейса|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMER, "|cFFFACDОтображение таймера|r", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB, "|cFFFACDИнтерфейс клавиатуры|r", 2)
SafeAddString(FANCYAB_SUBMENU_DECIMALS, "|cFFFACDДесятичные таймера|r", 2)
SafeAddString(FANCYAB_SUBMENU_MISC, "|cFFFACDРазное|r", 2)

-- Timer descriptions
SafeAddString(FANCYAB_SUBMENU_TIMER_DESC, "Здесь вы можете настроить размер и положение отображения таймера, стаков и счетчика целей.\nНастройки индивидуальны для интерфейсов клавиатуры и геймпада в их соответствующих подменю и могут быть изменены независимо от текущего режима интерфейса.\nНастройки десятичных знаков таймера применяются к обоим режимам интерфейса", 2)
SafeAddString(FANCYAB_SUBMENU_TIMERKB_DESC, "Настройки отображения таймера для интерфейса клавиатуры", 2)
SafeAddString(FANCYAB_SUBMENU_STACKKB_DESC, "Настройки отображения счетчика стаков для интерфейса клавиатуры", 2)
SafeAddString(FANCYAB_SUBMENU_TARGETKB_DESC, "Настройки отображения счетчика целей для интерфейса клавиатуры", 2)

-- Categories
SafeAddString(FANCYAB_CAT_BBVISUAL, "[ |cffdf80Видимость задней панели|r ]", 2)
SafeAddString(FANCYAB_CAT_HOTKEY, "[ |cffdf80Текст горячих клавиш|r ]", 2)
SafeAddString(FANCYAB_CAT_FRAMES, "[ |cffdf80Рамки кнопок|r ]", 2)
SafeAddString(FANCYAB_CAT_HIGHLIGHT, "[ |cffdf80Подсветка активных умений|r ]", 2)
SafeAddString(FANCYAB_CAT_ARROW, "[ |cffdf80Стрелка активной панели|r ]", 2)
SafeAddString(FANCYAB_CAT_MARKER, "[ |cffdf80Маркеры врагов|r ]", 2)
SafeAddString(FANCYAB_CAT_DEBUG, "[ |cffdf80Отладка|r ]", 2)

-- Category descriptions
SafeAddString(FANCYAB_CAT_FRAMES_DESC, "Только для интерфейса клавиатуры.", 2)
SafeAddString(FANCYAB_CAT_ARROW_DESC, "Смените оружие один раз после нажатия кнопки Показать стрелку, чтобы изменение вступило в силу.", 2)
SafeAddString(FANCYAB_CAT_MARKER_DESC, "Да... Я полностью позаимствовал это из Untaunted.", 2)

-- Alpha settings
SafeAddString(FANCYAB_ALPHA_NAME, "Прозрачность неактивной панели", 2)
SafeAddString(FANCYAB_ALPHA_TT, "Большее значение = более непрозрачно.\nМеньшее значение = более прозрачно.", 2)

-- Desaturation settings
SafeAddString(FANCYAB_DESAT_NAME, "Обесцвечивание неактивной панели", 2)
SafeAddString(FANCYAB_DESAT_TT, "Большее значение = более серый.\nМеньшее значение = более цветной.", 2)

-- Hotkey settings
SafeAddString(FANCYAB_HOTKEY_NAME, "Показывать горячие клавиши", 2)
SafeAddString(FANCYAB_HOTKEY_TT, "Показывать горячие клавиши под панелью действий.", 2)

-- Frame settings
SafeAddString(FANCYAB_FRAME_NAME, "Показывать рамки", 2)
SafeAddString(FANCYAB_FRAME_TT, "Показывать рамку вокруг кнопок на панели действий.", 2)
SafeAddString(FANCYAB_FRAME_COLOR, "Цвет рамки", 2)

-- Highlight settings
SafeAddString(FANCYAB_HIGHLIGHT_NAME, "Показывать подсветку", 2)
SafeAddString(FANCYAB_HIGHLIGHT_TT, "Активные умения будут подсвечены.", 2)
SafeAddString(FANCYAB_HIGHLIGHT_COLOR, "Цвет подсветки", 2)

-- Arrow settings
SafeAddString(FANCYAB_ARROW_NAME, "Показывать стрелку", 2)
SafeAddString(FANCYAB_ARROW_TT, "Показывать стрелку рядом с активной панелью.", 2)
SafeAddString(FANCYAB_ARROW_COLOR, "Цвет стрелки", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_NAME, "Настроить положение быстрого слота", 2)
SafeAddString(FANCYAB_ARROW_ADJUSTQS_TT, "Переместить быстрый слот ближе к панели действий, если стрелка скрыта.\nТолько для интерфейса клавиатуры.", 2)

-- Timer font settings
SafeAddString(FANCYAB_TIMER_FONTKB_TT, "Шрифт таймера для интерфейса клавиатуры.", 2)
SafeAddString(FANCYAB_TIMER_STYLEKB_TT, "Эффект обводки для чисел таймера в интерфейсе клавиатуры.", 2)
SafeAddString(FANCYAB_STACK_FONTKB_TT, "Шрифт счетчика стаков для интерфейса клавиатуры.", 2)
SafeAddString(FANCYAB_STACK_STYLEKB_TT, "Эффект обводки счетчика стаков в интерфейсе клавиатуры.", 2)
SafeAddString(FANCYAB_TARGET_FONTKB_TT, "Шрифт счетчика целей для интерфейса клавиатуры.", 2)
SafeAddString(FANCYAB_TARGET_STYLEKB_TT, "Эффект обводки счетчика целей в интерфейсе клавиатуры.", 2)

-- Gamepad font settings
SafeAddString(FANCYAB_TIMER_FONTGP_TT, "Шрифт таймера для интерфейса геймпада.", 2)
SafeAddString(FANCYAB_TIMER_STYLEGP_TT, "Эффект обводки для чисел таймера в интерфейсе геймпада.", 2)
SafeAddString(FANCYAB_STACK_FONTGP_TT, "Шрифт счетчика стаков для интерфейса геймпада.", 2)
SafeAddString(FANCYAB_STACK_STYLEGP_TT, "Эффект обводки счетчика стаков в интерфейсе геймпада.", 2)
SafeAddString(FANCYAB_TARGET_FONTGP_TT, "Шрифт счетчика целей для интерфейса геймпада.", 2)
SafeAddString(FANCYAB_TARGET_STYLEGP_TT, "Эффект обводки счетчика целей в интерфейсе геймпада.", 2)

-- Timer settings
SafeAddString(FANCYAB_TIMER_FONT, "Шрифт таймера", 2)
SafeAddString(FANCYAB_TIMER_SIZE, "Размер таймера", 2)
SafeAddString(FANCYAB_TIMER_STYLE, "Стиль таймера", 2)
SafeAddString(FANCYAB_TIMER_Y_NAME, "Настроить высоту таймера", 2)
SafeAddString(FANCYAB_TIMER_Y_TT, "Переместить таймер [<- вниз] или [вверх ->]", 2)

-- Stack settings
SafeAddString(FANCYAB_STACK_FONT, "Шрифт счетчика стаков", 2)
SafeAddString(FANCYAB_STACK_SIZE, "Размер счетчика стаков", 2)
SafeAddString(FANCYAB_STACK_STYLE, "Стиль счетчика стаков", 2)
SafeAddString(FANCYAB_STACK_X_NAME, "Настроить положение стаков", 2)
SafeAddString(FANCYAB_STACK_X_TT, "Переместить счетчик стаков [<- влево] или [вправо ->]", 2)

-- Target settings
SafeAddString(FANCYAB_TARGET_FONT, "Шрифт счетчика целей", 2)
SafeAddString(FANCYAB_TARGET_SIZE, "Размер счетчика целей", 2)
SafeAddString(FANCYAB_TARGET_STYLE, "Стиль счетчика целей", 2)
SafeAddString(FANCYAB_TARGET_X_NAME, "Настроить положение целей", 2)
SafeAddString(FANCYAB_TARGET_X_TT, "Переместить счетчик целей [<- влево] или [вправо ->]", 2)

-- Decimal settings
SafeAddString(FANCYAB_DECIMAL_CHOICE_NAME, "Включить десятичные знаки таймера", 2)
SafeAddString(FANCYAB_DECIMAL_CHOICE_TT, "Всегда = Всегда показывать десятичные знаки, если таймер активен.\nПри истечении = Включит дополнительные опции.\nНикогда = Никогда.", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_NAME, "Порог десятичных знаков", 2)
SafeAddString(FANCYAB_DECIMAL_THOLD_TT, "Десятичные знаки будут показаны, когда таймеры упадут ниже выбранного количества оставшихся секунд", 2)

-- Expiry settings
SafeAddString(FANCYAB_EXPIRE_NAME, "Изменять цвет истекающего таймера", 2)
SafeAddString(FANCYAB_EXPIRE_TT, "Изменять цвет таймера, когда время действия истекает.", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_NAME, "Порог истечения", 2)
SafeAddString(FANCYAB_EXPIRE_THOLD_TT, "Цвет изменится, когда таймеры упадут ниже выбранного количества оставшихся секунд, если настройка включена", 2)
SafeAddString(FANCYAB_EXPIRE_COLOR, "Цвет истекающего таймера", 2)

-- Marker settings
SafeAddString(FANCYAB_MARKER_NAME, "Показывать маркеры врагов", 2)
SafeAddString(FANCYAB_MARKER_TT, "Показывать красную стрелку над головой врагов, с которыми вы сейчас в бою.", 2)
SafeAddString(FANCYAB_MARKER_SIZE, "Размер маркера врагов", 2)

-- Debug settings
SafeAddString(FANCYAB_DBG_NAME, "Режим отладки", 2)
SafeAddString(FANCYAB_DBG_TT, "Показывать события обновления умений в чате (|cFF0000ВНИМАНИЕ: СПАМ!|r).", 2)

-- Disclaimer
SafeAddString(FANCYAB_DISCLAIMER, "Вся заслуга принадлежит |cFFFF00@andy.s|r за его невероятную работу и преданность сообществу.\nСначала я сделал лишь несколько изменений для настройки под свои личные потребности и добавил опции для включения этих настроек.\nФункции отслеживания для таймеров умений вдохновлены работой Solinur и Phinix, и я узнал все, что знаю, читая их код (и мне еще многому предстоит научиться).", 2)
