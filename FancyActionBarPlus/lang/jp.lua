-- Japanese translations
local strings =
{

    FANCYAB_SUBMENU_GENERAL = "|cFFFACD一般|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDUIカスタマイズ|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDタイマー表示|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDキーボードUI|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDタイマー小数点|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDその他|r",

    -- Timer descriptions
    FANCYAB_SUBMENU_TIMER_DESC = "タイマー、スタック、ターゲットカウントの表示サイズと位置を調整できます。\n設定はキーボードUIとゲームパッドUIでそれぞれ個別に設定でき、現在のUIモードに関係なく変更できます。\nタイマーの小数点オプションは両方のUIモードに適用されます",
    FANCYAB_SUBMENU_TIMERKB_DESC = "キーボードUIのタイマー表示設定",
    FANCYAB_SUBMENU_STACKKB_DESC = "キーボードUIのスタックカウンター表示設定",
    FANCYAB_SUBMENU_TARGETKB_DESC = "キーボードUIのターゲットカウンター表示設定",

    -- Categories
    FANCYAB_CAT_BBVISUAL = "[ |cffdf80バックバーの表示|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80ホットキーテキスト|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80ボタンフレーム|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80アクティブスキルのハイライト|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80アクティブバーの矢印|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80敵マーカー|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80デバッグ|r ]",

    -- Category descriptions
    FANCYAB_CAT_FRAMES_DESC = "キーボードUIのみ。",
    FANCYAB_CAT_ARROW_DESC = "矢印表示ボタンをクリックした後、武器を切り替えて変更を反映させてください。",
    FANCYAB_CAT_MARKER_DESC = "はい... これはUntauntedから完全に拝借しました。",

    -- Alpha settings
    FANCYAB_ALPHA_NAME = "非アクティブバーの透明度",
    FANCYAB_ALPHA_TT = "高い値 = より不透明。\n低い値 = より透明。",

    -- Desaturation settings
    FANCYAB_DESAT_NAME = "非アクティブバーの彩度",
    FANCYAB_DESAT_TT = "高い値 = よりグレー。\n低い値 = より色鮮やか。",

    -- Hotkey settings
    FANCYAB_HOTKEY_NAME = "ホットキーを表示",
    FANCYAB_HOTKEY_TT = "アクションバーの下にホットキーを表示します。",

    -- Frame settings
    FANCYAB_FRAME_NAME = "フレームを表示",
    FANCYAB_FRAME_TT = "アクションバーのボタンの周りにフレームを表示します。",
    FANCYAB_FRAME_COLOR = "フレームの色",

    -- Highlight settings
    FANCYAB_HIGHLIGHT_NAME = "ハイライトを表示",
    FANCYAB_HIGHLIGHT_TT = "アクティブなスキルがハイライト表示されます。",
    FANCYAB_HIGHLIGHT_COLOR = "ハイライトの色",

    -- Arrow settings
    FANCYAB_ARROW_NAME = "矢印を表示",
    FANCYAB_ARROW_TT = "現在アクティブなバーの近くに矢印を表示します。",
    FANCYAB_ARROW_COLOR = "矢印の色",
    FANCYAB_ARROW_ADJUSTQS_NAME = "クイックスロットの位置を調整",
    FANCYAB_ARROW_ADJUSTQS_TT = "矢印が非表示の場合、クイックスロットをアクションバーに近づけます。\nキーボードUIのみ。",

    -- Timer font settings
    FANCYAB_TIMER_FONTKB_TT = "キーボードUIのタイマーフォント。",
    FANCYAB_TIMER_STYLEKB_TT = "キーボードUIのタイマー数字の縁取り効果。",
    FANCYAB_STACK_FONTKB_TT = "キーボードUIのスタックカウンターフォント。",
    FANCYAB_STACK_STYLEKB_TT = "キーボードUIのスタックカウンターの縁取り効果。",
    FANCYAB_TARGET_FONTKB_TT = "キーボードUIのターゲットカウンターフォント。",
    FANCYAB_TARGET_STYLEKB_TT = "キーボードUIのターゲットカウンターの縁取り効果。",

    -- Gamepad font settings
    FANCYAB_TIMER_FONTGP_TT = "ゲームパッドUIのタイマーフォント。",
    FANCYAB_TIMER_STYLEGP_TT = "ゲームパッドUIのタイマー数字の縁取り効果。",
    FANCYAB_STACK_FONTGP_TT = "ゲームパッドUIのスタックカウンターフォント。",
    FANCYAB_STACK_STYLEGP_TT = "ゲームパッドUIのスタックカウンターの縁取り効果。",
    FANCYAB_TARGET_FONTGP_TT = "ゲームパッドUIのターゲットカウンターフォント。",
    FANCYAB_TARGET_STYLEGP_TT = "ゲームパッドUIのターゲットカウンターの縁取り効果。",

    -- Timer settings
    FANCYAB_TIMER_FONT = "タイマーフォント",
    FANCYAB_TIMER_SIZE = "タイマーサイズ",
    FANCYAB_TIMER_STYLE = "タイマースタイル",
    FANCYAB_TIMER_Y_NAME = "タイマーの高さを調整",
    FANCYAB_TIMER_Y_TT = "タイマーを [<- 下] または [上 ->] に移動",

    -- Stack settings
    FANCYAB_STACK_FONT = "スタックカウンターフォント",
    FANCYAB_STACK_SIZE = "スタックカウンターサイズ",
    FANCYAB_STACK_STYLE = "スタックカウンタースタイル",
    FANCYAB_STACK_X_NAME = "スタックの位置を調整",
    FANCYAB_STACK_X_TT = "スタックカウンターを [<- 左] または [右 ->] に移動",

    -- Target settings
    FANCYAB_TARGET_FONT = "ターゲットカウンターフォント",
    FANCYAB_TARGET_SIZE = "ターゲットカウンターサイズ",
    FANCYAB_TARGET_STYLE = "ターゲットカウンタースタイル",
    FANCYAB_TARGET_X_NAME = "ターゲットの位置を調整",
    FANCYAB_TARGET_X_TT = "ターゲットカウンターを [<- 左] または [右 ->] に移動",

    -- Decimal settings
    FANCYAB_DECIMAL_CHOICE_NAME = "タイマー小数点を有効化",
    FANCYAB_DECIMAL_CHOICE_TT = "常に = タイマーがアクティブな場合、常に小数点を表示します。\n終了時 = より多くのオプションを有効にします。\n表示しない = 表示しません。",
    FANCYAB_DECIMAL_THOLD_NAME = "小数点表示のしきい値",
    FANCYAB_DECIMAL_THOLD_TT = "タイマーの残り時間が選択した秒数を下回ると小数点が表示されます",

    -- Expiry settings
    FANCYAB_EXPIRE_NAME = "終了時のタイマーの色を変更",
    FANCYAB_EXPIRE_TT = "持続時間が終了に近づくとタイマーの色が変更されます。",
    FANCYAB_EXPIRE_THOLD_NAME = "終了時のしきい値",
    FANCYAB_EXPIRE_THOLD_TT = "設定が有効な場合、タイマーの残り時間が選択した秒数を下回ると色が変更されます",
    FANCYAB_EXPIRE_COLOR = "終了時のタイマーの色",

    -- Marker settings
    FANCYAB_MARKER_NAME = "敵マーカーを表示",
    FANCYAB_MARKER_TT = "現在戦闘中の敵の頭上に赤い矢印を表示します。",
    FANCYAB_MARKER_SIZE = "敵マーカーのサイズ",

    -- Debug settings
    FANCYAB_DBG_NAME = "デバッグモード",
    FANCYAB_DBG_TT = "チャットにスキル更新イベントを表示します（|cFF0000スパム警告！|r）。",

    -- Disclaimer
    FANCYAB_DISCLAIMER = "すべての功績は |cFFFF00@andy.s|r の素晴らしい仕事とコミュニティへの献身に帰属します。\n最初は個人的なニーズに合わせていくつかのカスタマイズ変更を行い、これらの調整を可能にするオプションを追加しただけでした。\nスキルタイマーのトラッキング機能は Solinur と Phinix の仕事にインスパイアされており、私が知っているすべてのことは彼らのコードを読むことから学びました（そしてまだ学ぶべきことがたくさんあります）。",

}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
