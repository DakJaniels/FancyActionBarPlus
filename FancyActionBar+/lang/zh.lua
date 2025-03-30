-- Traditional Chinese translations
local strings =
{
    FANCYAB_SUBMENU_GENERAL = "|cFFFACD常规|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACD界面自定义|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACD计时器显示|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACD键盘界面|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACD计时器小数点|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACD其他|r",

    FANCYAB_SUBMENU_TIMER_DESC = "在这里您可以调整计时器、堆叠和目标计数显示的大小和位置。\n键盘和手柄界面的设置在各自的子菜单中是独立的，无论当前界面模式如何都可以更改。\n计时器小数点选项适用于两种界面模式",
    FANCYAB_SUBMENU_TIMERKB_DESC = "键盘界面计时器显示设置",
    FANCYAB_SUBMENU_STACKKB_DESC = "键盘界面堆叠计数显示设置",
    FANCYAB_SUBMENU_TARGETKB_DESC = "键盘界面目标计数显示设置",

    FANCYAB_CAT_BBVISUAL = "[ |cffdf80后置技能栏可见性|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80快捷键文本|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80按钮边框|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80当前技能高亮|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80当前技能栏箭头|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80敌人标记|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80调试|r ]",

    FANCYAB_CAT_FRAMES_DESC = "仅适用于键盘界面。",
    FANCYAB_CAT_ARROW_DESC = "点击显示箭头按钮后切换一次武器以使更改生效。",
    FANCYAB_CAT_MARKER_DESC = "是的...这个功能完全借鉴自Untaunted。",

    FANCYAB_ALPHA_NAME = "非当前技能栏透明度",
    FANCYAB_ALPHA_TT = "数值越高 = 越不透明。\n数值越低 = 越透明。",

    FANCYAB_DESAT_NAME = "非当前技能栏饱和度",
    FANCYAB_DESAT_TT = "数值越高 = 越灰暗。\n数值越低 = 越鲜艳。",

    FANCYAB_HOTKEY_NAME = "显示快捷键",
    FANCYAB_HOTKEY_TT = "在技能栏下方显示快捷键。",

    FANCYAB_FRAME_NAME = "显示边框",
    FANCYAB_FRAME_TT = "在技能栏按钮周围显示边框。",
    FANCYAB_FRAME_COLOR = "边框颜色",

    FANCYAB_HIGHLIGHT_NAME = "显示高亮",
    FANCYAB_HIGHLIGHT_TT = "高亮显示当前激活的技能。",
    FANCYAB_HIGHLIGHT_COLOR = "高亮颜色",

    FANCYAB_ARROW_NAME = "显示箭头",
    FANCYAB_ARROW_TT = "在当前激活的技能栏旁显示箭头。",
    FANCYAB_ARROW_COLOR = "箭头颜色",
    FANCYAB_ARROW_ADJUSTQS_NAME = "调整快速栏位置",
    FANCYAB_ARROW_ADJUSTQS_TT = "当箭头隐藏时将快速栏移近技能栏。\n仅适用于键盘界面。",

    FANCYAB_TIMER_FONTKB_TT = "键盘界面计时器字体。",
    FANCYAB_TIMER_STYLEKB_TT = "键盘界面计时器数字的边缘效果。",
    FANCYAB_STACK_FONTKB_TT = "键盘界面堆叠计数器字体。",
    FANCYAB_STACK_STYLEKB_TT = "键盘界面堆叠计数器的边缘效果。",
    FANCYAB_TARGET_FONTKB_TT = "键盘界面目标计数器字体。",
    FANCYAB_TARGET_STYLEKB_TT = "键盘界面目标计数器的边缘效果。",

    FANCYAB_TIMER_FONTGP_TT = "手柄界面计时器字体。",
    FANCYAB_TIMER_STYLEGP_TT = "手柄界面计时器数字的边缘效果。",
    FANCYAB_STACK_FONTGP_TT = "手柄界面堆叠计数器字体。",
    FANCYAB_STACK_STYLEGP_TT = "手柄界面堆叠计数器的边缘效果。",
    FANCYAB_TARGET_FONTGP_TT = "手柄界面目标计数器字体。",
    FANCYAB_TARGET_STYLEGP_TT = "手柄界面目标计数器的边缘效果。",

    FANCYAB_TIMER_FONT = "计时器字体",
    FANCYAB_TIMER_SIZE = "计时器大小",
    FANCYAB_TIMER_STYLE = "计时器样式",
    FANCYAB_TIMER_Y_NAME = "调整计时器高度",
    FANCYAB_TIMER_Y_TT = "移动计时器 [<- 向下] 或 [向上 ->]",

    FANCYAB_STACK_FONT = "堆叠计数器字体",
    FANCYAB_STACK_SIZE = "堆叠计数器大小",
    FANCYAB_STACK_STYLE = "堆叠计数器样式",
    FANCYAB_STACK_X_NAME = "调整堆叠位置",
    FANCYAB_STACK_X_TT = "移动堆叠计数器 [<- 向左] 或 [向右 ->]",

    FANCYAB_TARGET_FONT = "目标计数器字体",
    FANCYAB_TARGET_SIZE = "目标计数器大小",
    FANCYAB_TARGET_STYLE = "目标计数器样式",
    FANCYAB_TARGET_X_NAME = "调整目标位置",
    FANCYAB_TARGET_X_TT = "移动目标计数器 [<- 向左] 或 [向右 ->]",

    FANCYAB_DECIMAL_CHOICE_NAME = "启用计时器小数点",
    FANCYAB_DECIMAL_CHOICE_TT = "总是 = 计时器激活时始终显示小数点。\n即将结束 = 将启用更多选项。\n从不 = 从不显示。",
    FANCYAB_DECIMAL_THOLD_NAME = "小数点阈值",
    FANCYAB_DECIMAL_THOLD_TT = "当计时器剩余时间低于选定的秒数时显示小数点",

    FANCYAB_EXPIRE_NAME = "改变即将结束的计时器颜色",
    FANCYAB_EXPIRE_TT = "当持续时间即将结束时改变计时器颜色。",
    FANCYAB_EXPIRE_THOLD_NAME = "即将结束阈值",
    FANCYAB_EXPIRE_THOLD_TT = "如果启用此设置，当计时器剩余时间低于选定的秒数时将改变颜色",
    FANCYAB_EXPIRE_COLOR = "即将结束的计时器颜色",

    FANCYAB_MARKER_NAME = "显示敌人标记",
    FANCYAB_MARKER_TT = "在当前战斗中的敌人头顶显示红色箭头。",
    FANCYAB_MARKER_SIZE = "敌人标记大小",

    FANCYAB_DBG_NAME = "调试模式",
    FANCYAB_DBG_TT = "在聊天框中显示技能更新事件（|cFF0000警告：会刷屏！|r）。",

    FANCYAB_DISCLAIMER = "所有功劳归于 |cFFFF00@andy.s|r 对社区的杰出贡献和奉献。\n起初我只是为了更好地适应个人需求而做了一些自定义更改，并添加了这些调整的选项。\n技能计时器的追踪功能受到了 Solinur 和 Phinix 工作的启发，我从阅读他们的代码中学到了所有知识（我仍然有很多要学习的地方）。",
}

for stringId, stringValue in pairs(strings) do
    SafeAddString(_G[stringId], stringValue, 2)
end
