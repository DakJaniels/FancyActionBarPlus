-- Default
local strings =
{
    FANCYAB_SUBMENU_GENERAL = "|cFFFACDGeneral|r",
    FANCYAB_SUBMENU_CUSTOMUI = "|cFFFACDUI Customization|r",
    FANCYAB_SUBMENU_TIMER = "|cFFFACDTimer Display|r",
    FANCYAB_SUBMENU_TIMERKB = "|cFFFACDKeyboard UI|r",
    FANCYAB_SUBMENU_DECIMALS = "|cFFFACDTimer Decimals|r",
    FANCYAB_SUBMENU_MISC = "|cFFFACDMiscellaneous|r",

    FANCYAB_SUBMENU_TIMER_DESC = "Here you can adjust size and postion of the timer, stacks, and target counts displays.\nThe settings are individual to the keyboard and gamepad UI's in their respective submenu, and can be changed regardless of which mode your UI is currently in.\nThe timer decimals options apply to both UI modes",
    FANCYAB_SUBMENU_TIMERKB_DESC = "Keyboard UI timer display settings",
    FANCYAB_SUBMENU_STACKKB_DESC = "Keyboard UI target count display settings",
    FANCYAB_SUBMENU_TARGETKB_DESC = "Keyboard UI target count display settings",

    FANCYAB_CAT_BBVISUAL = "[ |cffdf80Back Bar Visibility|r ]",
    FANCYAB_CAT_HOTKEY = "[ |cffdf80Hotkey Text|r ]",
    FANCYAB_CAT_FRAMES = "[ |cffdf80Button Frames|r ]",
    FANCYAB_CAT_HIGHLIGHT = "[ |cffdf80Active Ability Highlight|r ]",
    FANCYAB_CAT_ARROW = "[ |cffdf80Active Bar Arrow|r ]",
    FANCYAB_CAT_MARKER = "[ |cffdf80Enemy Markers|r ]",
    FANCYAB_CAT_DEBUG = "[ |cffdf80Debugging|r ]",

    FANCYAB_CAT_FRAMES_DESC = "Only for keyboard UI.",
    FANCYAB_CAT_ARROW_DESC = "Weapon swap once after clicking the Show arrow button to make the change take effect.",
    FANCYAB_CAT_MARKER_DESC = "yes.. I completely stole this from Untaunted.",

    FANCYAB_ALPHA_NAME = "Inactive bar alpha",
    FANCYAB_ALPHA_TT = "Higher value = more solid.\nLower value = more see through.",

    FANCYAB_DESAT_NAME = "Inactive bar desaturation",
    FANCYAB_DESAT_TT = "Higher value = more grey.\nLower value = more colors.",

    FANCYAB_HOTKEY_NAME = "Show hotkeys",
    FANCYAB_HOTKEY_TT = "Show hotkeys under the action bar.",

    FANCYAB_FRAME_NAME = "Show frames",
    FANCYAB_FRAME_TT = "Show a frame around buttons on the actionbar.",
    FANCYAB_FRAME_COLOR = "Frame color",

    FANCYAB_HIGHLIGHT_NAME = "Show highlight",
    FANCYAB_HIGHLIGHT_TT = "Active skills will be highlighted.",
    FANCYAB_HIGHLIGHT_COLOR = "Highlight color",

    FANCYAB_ARROW_NAME = "Show arrow",
    FANCYAB_ARROW_TT = "Show an arrow near the currently active bar.",
    FANCYAB_ARROW_COLOR = "Arrow color",
    FANCYAB_ARROW_ADJUSTQS_NAME = "Adjust Quick Slot placement",
    FANCYAB_ARROW_ADJUSTQS_TT = "Move Quick Slot closer to the Action Bar if the arrow is hidden.\nFor keyboard UI only.",

    FANCYAB_TIMER_FONTKB_TT = "Timer font for keyboard UI timer.",
    FANCYAB_TIMER_STYLEKB_TT = "Edge effect for Keyboard UI timer numbers.",
    FANCYAB_STACK_FONTKB_TT = "Stacks Counter font for keyboard UI.",
    FANCYAB_STACK_STYLEKB_TT = "Edge effect of the Keyboard UI stacks counter.",
    FANCYAB_TARGET_FONTKB_TT = "Target Counter font for keyboard UI.",
    FANCYAB_TARGET_STYLEKB_TT = "Edge effect of the Keyboard UI targets counter.",

    FANCYAB_TIMER_FONTGP_TT = "Timer font for Gamepad UI timer.",
    FANCYAB_TIMER_STYLEGP_TT = "Edge effect for Gamepad UI timer numbers.",
    FANCYAB_STACK_FONTGP_TT = "Stacks Counter font for Gamepad UI.",
    FANCYAB_STACK_STYLEGP_TT = "Edge effect of the Gamepad UI stacks counter.",
    FANCYAB_TARGET_FONTGP_TT = "Target Counter font for Gamepad UI.",
    FANCYAB_TARGET_STYLEGP_TT = "Edge effect of the Gamepad UI targets counter.",

    FANCYAB_TIMER_FONT = "Timer font",
    FANCYAB_TIMER_SIZE = "Timer size",
    FANCYAB_TIMER_STYLE = "Timer style",
    FANCYAB_TIMER_Y_NAME = "Adjust timer height",
    FANCYAB_TIMER_Y_TT = "Move timer [<- down] or [up ->]",

    FANCYAB_STACK_FONT = "Stack counter font",
    FANCYAB_STACK_SIZE = "Stacks counter size",
    FANCYAB_STACK_STYLE = "Stacks counter style",
    FANCYAB_STACK_X_NAME = "Adjust stacks position",
    FANCYAB_STACK_X_TT = "Move stacks counter [<- left] or [right ->]",

    FANCYAB_TARGET_FONT = "Target counter font",
    FANCYAB_TARGET_SIZE = "Targets counter size",
    FANCYAB_TARGET_STYLE = "Targets counter style",
    FANCYAB_TARGET_X_NAME = "Adjust targets position",
    FANCYAB_TARGET_X_TT = "Move targets counter [<- left] or [right ->]",

    FANCYAB_DECIMAL_CHOICE_NAME = "Enable timer decimals",
    FANCYAB_DECIMAL_CHOICE_TT = "Always = Will always display decimals if the timer is active.\nExpire = Will enable more options.\nNever = Never.",
    FANCYAB_DECIMAL_THOLD_NAME = "Decimals threshold",
    FANCYAB_DECIMAL_THOLD_TT = "Decimals will show when timers fall below selected amount of seconds remaining",

    FANCYAB_EXPIRE_NAME = "Change expiring timer color",
    FANCYAB_EXPIRE_TT = "Change timer color when duration is running out.",
    FANCYAB_EXPIRE_THOLD_NAME = "Expiring timer threshold",
    FANCYAB_EXPIRE_THOLD_TT = "Color will change when timers fall below selected amount of seconds remaining if the setting is enabled",
    FANCYAB_EXPIRE_COLOR = "Expiring timer color",

    FANCYAB_MARKER_NAME = "Show Enemy Markers",
    FANCYAB_MARKER_TT = "Display a red arrow over the head of enemies you are currently in combat with.",
    FANCYAB_MARKER_SIZE = "Enemy Marker Size",

    FANCYAB_DBG_NAME = "Debug mode",
    FANCYAB_DBG_TT = "Display ability update events in the chat (|cFF0000SPAM WARNING!|r).",

    FANCYAB_DISCLAIMER = "All credit goes to |cFFFF00@andy.s|r for his incredible work and dedication to the community.\nAt first I only made a few customization changes to better suit myself personally and added options to enable adjustments of these.\nThe tracking functions for the ability timers are inspired by the work of Solinur and Phinix, and I've learned all I know about it from reading their code (and I still have much to learn).",
}

for stringId, stringValue in pairs(strings) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end
