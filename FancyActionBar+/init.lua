--- @class (partial) FancyActionBar
--- @field __index FancyActionBar
FancyActionBar = {}
FancyActionBar.__index = FancyActionBar

--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar

FancyActionBar.variableVersion = 1

FancyActionBar.defaultCharacter =
{
    -- for character specific ability tracking
    useAccountWide = true,

    configChanges = {},
    dynamicAbilityConfig = false,

    hideOnNoTargetGlobal = false,
    hideOnNoTargetList = {},

    noTargetFade = false,
    noTargetAlpha = 90,
    debuffConfigUpgraded = false,
}
FancyActionBar.defaultSettings =
{
    variablesValidated = false,
    -- ability tracking

    configChanges = {},
    dynamicAbilityConfig = false,
    forceGamepadStyle = false,

    externalBuffs = false,
    externalBlackList = {},
    externalBlackListRun = false,

    multiTargetBlackListRun = false,
    multiTargetBlacklist = {},

    advancedDebuff = false,
    keepLastTarget = true,
    debuffConfigUpgraded = false,

    hideOnNoTargetGlobal = false,
    hideOnNoTargetList = {},

    noTargetFade = false,
    noTargetAlpha = 90,
    applyActionBarSkillStyles = true,

    durationMin = 2,
    durationMax = 120,
    showCastDuration = true,
    showToggleTicks = false,

    showStackCount = true,
    showOvertauntStacks = false,
    showTargetCount = true,
    showSingleTargetInstance = false,
    ignoreTrapPlacement = false,
    showSoonestExpire = false,
    ignoreUngroupedAliies = false,

    -- general
    lockInTrade = true,
    staticBars = true,
    frontBarTop = true,
    activeBarTop = false,
    hideLockedBar = true,
    repositionActiveBar = true,
    showHotkeys = true,
    showHotkeysUltGP = true,
    hideCompanionUlt = false,
    showHighlight = true,
    highlightColor = { 0, 1, 0, 0.7 },
    highlightExpire = false,
    highlightExpireColor = { 1, 0, 0, 0.7 },
    toggledHighlight = true,
    toggledColor = { 1, 1, 1, 0.7 },
    abilitySlotOffsetXKB = 2,
    barXOffsetKB = 0,
    barYOffsetKB = 0,
    abilitySlotOffsetXGP = 10,
    barXOffsetGP = 0,
    barYOffsetGP = 0,
    moveHealthBar = true,
    moveResourceBars = IsConsoleUI(),
    forceAzurahMover = false,

    -- back bar visibility
    alphaInactive = 20,
    desaturationInactive = 50,
    -- timer display settings
    delayFade = true,
    fadeDelay = 2,
    showDecimal = "Expire",
    showDecimalStart = 2,
    showExpire = true,
    showExpireStart = 2,
    expireColor = { 1, 1, 0 },
    showTickExpire = false,
    showTickStart = 2,
    tickColor = { 1, 1, 0 },
    allowParentTime = false,
    -- keyboard UI visuals
    -- duration
    fontNameKB = "Univers 67",
    fontSizeKB = 24,
    fontTypeKB = "thick-outline",
    timeYKB = 0,
    timeColorKB = { 1, 1, 1 },
    -- stacks
    fontNameStackKB = "Univers 67",
    fontSizeStackKB = 20,
    fontTypeStackKB = "thick-outline",
    stackXKB = 37,
    stackYKB = 1,
    stackColorKB = { 1, 0.8, 0 },
    -- targets
    fontNameTargetKB = "Univers 67",
    fontSizeTargetKB = 20,
    fontTypeTargetKB = "thick-outline",
    targetXKB = 3,
    targetYKB = 1,
    targetColorKB = { 1, 0.8, 0 },
    -- ult duration
    ultShowKB = true,
    ultNameKB = "Univers 67",
    ultSizeKB = 24,
    ultTypeKB = "thick-outline",
    ultXKB = 37,
    ultYKB = 0,
    ultColorKB = { 1, 1, 1 },
    -- ult value
    ultValueEnableKB = true,
    ultValueModeKB = 1,
    ultValueNameKB = "Univers 67",
    ultValueSizeKB = 20,
    ultValueTypeKB = "outline",
    ultValueXKB = -2,
    ultValueYKB = -5,
    ultValueColorKB = { 1, 1, 1 },
    ultValueThresholdKB = 0.9,
    ultUsableThresholdColorKB = { 1, 0.8, 0 },
    ultUsableValueColorKB = { 0, 1, 0 },
    ultMaxValueColorKB = { 1, 0, 0 },
    -- companion
    ultValueEnableCompanionKB = true,
    ultValueModeCompanionKB = 1,
    ultValueCompanionXKB = 0,
    ultValueCompanionYKB = 0,
    -- quick slot
    qsTimerEnableKB = true,
    qsNameKB = "Univers 67",
    qsSizeKB = 24,
    qsTypeKB = "outline",
    qsXKB = 0,
    qsYKB = 10,
    qsColorKB = { 1, 0.5, 0.2 },
    qsStackNameKB = "Univers 67",
    qsStackSizeKB = 18,
    qsStackTypeKB = "soft-shadow-thin",
    qsStackColorKB = { 1, 1, 1 },
    quickSlotCustomXOffsetKB = 0,
    quickSlotCustomYOffsetKB = 0,
    -- gamepad UI visuals
    useThinFrames = false,
    -- duration
    fontNameGP = "Univers 67",
    fontSizeGP = 34,
    fontTypeGP = "thick-outline",
    timeYGP = 0,
    timeColorGP = { 1, 1, 1 },
    -- stacks
    fontNameStackGP = "Univers 67",
    fontSizeStackGP = 22,
    fontTypeStackGP = "thick-outline",
    stackXGP = 37,
    stackYGP = 1,
    stackColorGP = { 1, 0.8, 0 },
    -- targets
    fontNameTargetGP = "Univers 67",
    fontSizeTargetGP = 22,
    fontTypeTargetGP = "thick-outline",
    targetXGP = 3,
    targetYGP = 1,
    targetColorGP = { 1, 0.8, 0 },
    -- ult
    ultShowGP = true,
    ultNameGP = "Univers 67",
    ultSizeGP = 40,
    ultTypeGP = "thick-outline",
    ultXGP = 70,
    ultYGP = 0,
    ultColorGP = { 1, 1, 1 },
    ultimateSlotCustomXOffsetKB = 0,
    ultimateSlotCustomYOffsetKB = 0,
    ultimateSlotCustomXOffsetGP = 0,
    ultimateSlotCustomYOffsetGP = 0,
    -- ult value
    ultValueEnableGP = true,
    ultValueModeGP = 1,
    ultValueNameGP = "Univers 67",
    ultValueSizeGP = 22,
    ultValueTypeGP = "outline",
    ultValueXGP = -2,
    ultValueYGP = -5,
    ultValueColorGP = { 1, 1, 1 },
    ultValueThresholdGP = 0.9,
    ultUsableThresholdColorGP = { 1, 0.8, 0 },
    ultUsableValueColorGP = { 0, 1, 0 },
    ultMaxValueColorGP = { 1, 0, 0 },
    ultFillFrameAlpha = 1,
    ultFillBarAlpha = 1,
    -- companion
    ultValueEnableCompanionGP = true,
    ultValueModeCompanionGP = 1,
    ultValueCompanionXGP = 0,
    ultValueCompanionYGP = 0,
    -- quick slot
    qsTimerEnableGP = true,
    qsNameGP = "Univers 67",
    qsSizeGP = 34,
    qsTypeGP = "outline",
    qsXGP = 0,
    qsYGP = 10,
    qsColorGP = { 1, 0.5, 0.2 },
    qsStackNameGP = "Univers 67",
    qsStackSizeGP = 18,
    qsStackTypeGP = "soft-shadow-thin",
    qsStackColorGP = { 1, 1, 1 },
    quickSlotCustomXOffsetGP = 0,
    quickSlotCustomYOffsetGP = 0,
    -- both
    ultFlash = true,
    -- frames for keyboard UI
    showFrames = true,
    frameColor = { 0, 0, 0, 1 },
    hideDefaultFrames = false,
    -- arrow and quick slot display style
    showArrow = true,
    arrowColor = { 0, 1, 0, 1 },
    moveQS = true,
    -- enemy markers
    showMarker = false,
    markerSize = 26,
    -- global cooldown tracker
    gcd =
    {
        enable = false,
        combatOnly = false,
        x = 1000,
        y = 1000,
        sizeX = 50,
        sizeY = 50,
        fillColor = { 0.2, 0.6, 1, 1 },
        frameColor = { 0, 0, 0, 1 },
    },
    -- action bar scale and position
    abScaling =
    {
        kb = { enable = false, scale = 100 },
        gp = { enable = false, scale = 100 },
    },
    abMove =
    {                                                                    -- y = -(default + adjusted) anchor offset
        kb = { enable = false, x = 0, y = -22, prevX = 0, prevY = -22 }, -- y =      -( 0 + 22)
        gp = { enable = false, x = 0, y = -75, prevX = 0, prevY = -75 }, -- y =      -(25 + 52)
    },
    showDeath = false,
    hideInactiveSlots = false,
    -- compatibility
    perfectWeave = false,
    -- debug
    debug = false,
    debugAll = false,
    debugVerbose = false,
}
FancyActionBar.strings =
{
    -- outdated and mostly unused. will make settings more managable eventually.

    -- submenu names
    subGeneral = GetString(FANCYAB_SUBMENU_GENERAL),
    subCustomUI = GetString(FANCYAB_SUBMENU_CUSTOMUI),
    subTimer = GetString(FANCYAB_SUBMENU_TIMER),
    subTimerKB = GetString(FANCYAB_SUBMENU_TIMERKB),
    subDecimals = GetString(FANCYAB_SUBMENU_DECIMALS),
    subMisc = GetString(FANCYAB_SUBMENU_MISC),

    -- submenu descriptions
    subTimerDesc = GetString(FANCYAB_SUBMENU_TIMER_DESC),
    subTimerKBDesc = GetString(FANCYAB_SUBMENU_TIMERKB_DESC),
    subStackKBDesc = GetString(FANCYAB_SUBMENU_STACKKB_DESC),
    subTargetKBDesc = GetString(FANCYAB_SUBMENU_TARGETKB_DESC),

    -- submenu category titles
    catBBVisual = GetString(FANCYAB_CAT_BBVISUAL),
    catHotkey = GetString(FANCYAB_CAT_HOTKEY),
    catFrames = GetString(FANCYAB_CAT_FRAMES),
    catHighlight = GetString(FANCYAB_CAT_HIGHLIGHT),
    catArrow = GetString(FANCYAB_CAT_ARROW),
    catMarker = GetString(FANCYAB_CAT_MARKER),
    catDebug = GetString(FANCYAB_CAT_DEBUG),

    -- submenu category descriptions
    catFramesDesc = GetString(FANCYAB_CAT_FRAMES_DESC),
    catArrowDesc = GetString(FANCYAB_CAT_ARROW_DESC),
    catMarkerDesc = GetString(FANCYAB_CAT_MARKER_DESC),

    -- settings names and tooltips
    -- back bar alpha
    alphaName = GetString(FANCYAB_ALPHA_NAME),
    alphaTT = GetString(FANCYAB_ALPHA_TT),

    -- backbar desaturation
    desatName = GetString(FANCYAB_DESAT_NAME),
    desatTT = GetString(FANCYAB_DESAT_TT),

    -- keybinds
    hotkeyName = GetString(FANCYAB_HOTKEY_NAME),
    hotkeyTT = GetString(FANCYAB_HOTKEY_TT),

    -- button frames
    frameName = GetString(FANCYAB_FRAME_NAME),
    frameTT = GetString(FANCYAB_FRAME_TT),
    frameColor = GetString(FANCYAB_FRAME_COLOR),

    -- highlight
    highlightName = GetString(FANCYAB_HIGHLIGHT_NAME),
    highlightTT = GetString(FANCYAB_HIGHLIGHT_TT),
    highlightColor = GetString(FANCYAB_HIGHLIGHT_COLOR),

    -- arrow
    arrowName = GetString(FANCYAB_ARROW_NAME),
    arrowTT = GetString(FANCYAB_ARROW_TT),
    arrowColor = GetString(FANCYAB_ARROW_COLOR),
    arrowAdjustQSName = GetString(FANCYAB_ARROW_ADJUSTQS_NAME),
    arrowAdjustQSTT = GetString(FANCYAB_ARROW_ADJUSTQS_TT),

    -- KB UI tooltips
    timerFontKBTT = GetString(FANCYAB_TIMER_FONTKB_TT),
    timerStyleKBTT = GetString(FANCYAB_TIMER_STYLEKB_TT),
    stackFontKBTT = GetString(FANCYAB_STACK_FONTKB_TT),
    stackStyleKBTT = GetString(FANCYAB_STACK_STYLEKB_TT),
    targetFontKBTT = GetString(FANCYAB_TARGET_FONTKB_TT),
    targetStyleKBTT = GetString(FANCYAB_TARGET_STYLEKB_TT),

    -- GP UI tooltips
    timerFontGPTT = GetString(FANCYAB_TIMER_FONTGP_TT),
    timerStyleGPTT = GetString(FANCYAB_TIMER_STYLEGP_TT),
    stackFontGPTT = GetString(FANCYAB_STACK_FONTGP_TT),
    stackStyleGPTT = GetString(FANCYAB_STACK_STYLEGP_TT),
    targetFontGPTT = GetString(FANCYAB_TARGET_FONTGP_TT),
    targetStyleGPTT = GetString(FANCYAB_TARGET_STYLEGP_TT),

    -- timer for both KB and GP
    timerFont = GetString(FANCYAB_TIMER_FONT),
    timerSize = GetString(FANCYAB_TIMER_SIZE),
    timerStyle = GetString(FANCYAB_TIMER_STYLE),
    timerYName = GetString(FANCYAB_TIMER_Y_NAME),
    timerYTT = GetString(FANCYAB_TIMER_Y_TT),

    -- stacks for both KB and GP
    stackFont = GetString(FANCYAB_STACK_FONT),
    stackSize = GetString(FANCYAB_STACK_SIZE),
    stackStyle = GetString(FANCYAB_STACK_STYLE),
    stackXName = GetString(FANCYAB_STACK_X_NAME),
    stackXTT = GetString(FANCYAB_STACK_X_TT),

    -- targets for both KB and GP
    targetFont = GetString(FANCYAB_TARGET_FONT),
    targetSize = GetString(FANCYAB_TARGET_SIZE),
    targetStyle = GetString(FANCYAB_TARGET_STYLE),
    targetXName = GetString(FANCYAB_TARGET_X_NAME),
    targetXTT = GetString(FANCYAB_TARGET_X_TT),

    -- timer decimals and expiration color
    decimalChoiceName = GetString(FANCYAB_DECIMAL_CHOICE_NAME),
    decimalChoiceTT = GetString(FANCYAB_DECIMAL_CHOICE_TT),
    decimalTholdName = GetString(FANCYAB_DECIMAL_THOLD_NAME),
    decimalTholdTT = GetString(FANCYAB_DECIMAL_THOLD_TT),

    expireName = GetString(FANCYAB_EXPIRE_NAME),
    expireTT = GetString(FANCYAB_EXPIRE_TT),
    expireTholdName = GetString(FANCYAB_EXPIRE_THOLD_NAME),
    expireTholdTT = GetString(FANCYAB_EXPIRE_THOLD_TT),
    expirecolor = GetString(FANCYAB_EXPIRE_COLOR),

    -- enemy markers
    markerName = GetString(FANCYAB_MARKER_NAME),
    markerTT = GetString(FANCYAB_MARKER_TT),
    markerSize = GetString(FANCYAB_MARKER_SIZE),

    -- debug
    dbgName = GetString(FANCYAB_DBG_NAME),
    dbgTT = GetString(FANCYAB_DBG_TT),

    -- disclaimer
    disclaimer = GetString(FANCYAB_DISCLAIMER),
}

--- Returns a table with the configuration for the given mode and style
--- @param mode number 1 for keyboard, 2 for gamepad
--- @param vars table|FAB_AC_SV the saved variables
--- @param style table the style table
--- @return table
function FancyActionBar:UpdateContants(mode, vars, style)
    local SV = vars
    local c = {}

    if mode == 1 then
        local kb =
        {
            duration =
            {
                font = SV.fontNameKB,
                size = SV.fontSizeKB,
                outline = SV.fontTypeKB,
                y = SV.timeYKB,
                color = SV.timeColorKB,
            },
            stacks =
            {
                font = SV.fontNameStackKB,
                size = SV.fontSizeStackKB,
                outline = SV.fontTypeStackKB,
                x = SV.stackXKB,
                y = SV.stackYKB,
                color = SV.stackColorKB,
            },
            targets =
            {
                font = SV.fontNameTargetKB,
                size = SV.fontSizeTargetKB,
                outline = SV.fontTypeTargetKB,
                x = SV.targetXKB,
                y = SV.targetYKB,
                color = SV.targetColorKB,
            },
            ult =
            {
                duration =
                {
                    show = SV.ultShowKB,
                    font = SV.ultNameKB,
                    size = SV.ultSizeKB,
                    outline = SV.ultTypeKB,
                    x = SV.ultXKB,
                    y = SV.ultYKB,
                    color = SV.ultColorKB,
                },
                value =
                {
                    show = SV.ultValueEnableKB,
                    mode = SV.ultValueModeKB,
                    font = SV.ultValueNameKB,
                    size = SV.ultValueSizeKB,
                    outline = SV.ultValueTypeKB,
                    x = SV.ultValueXKB,
                    y = SV.ultValueYKB,
                    color = SV.ultValueColorKB,
                    threshold = SV.ultValueThresholdKB,
                    usableThresholdColor = SV.ultUsableThresholdColorKB,
                    usableColor = SV.ultUsableValueColorKB,
                    maxColor = SV.ultMaxValueColorKB,
                },
                companion =
                {
                    show = SV.ultValueEnableCompanionKB,
                    mode = SV.ultValueModeCompanionKB,
                    x = SV.ultValueCompanionXKB,
                    y = SV.ultValueCompanionYKB,
                },
            },
            qs =
            {
                show = SV.qsTimerEnableKB,
                font = SV.qsNameKB,
                size = SV.qsSizeKB,
                outline = SV.qsTypeKB,
                x = SV.qsXKB,
                y = SV.qsYKB,
                color = SV.qsColorKB,
                stackFont = SV.qsStackNameKB,
                stackSize = SV.qsStackSizeKB,
                stackOutline = SV.qsStackTypeKB,
                stackColor = SV.qsStackColorKB,
            },
            abScale =
            {
                enable = SV.abScaling.kb.enable,
                scale = SV.abScaling.kb.scale,
            },
            move =
            {
                enable = SV.abMove.kb.enable,
                x = SV.abMove.kb.x,
                y = SV.abMove.kb.y,
            },
            abilitySlot =
            {
                offsetX = SV.abilitySlotOffsetXKB,
            },
            style = {},
        }
        c = kb
    else
        local gp =
        {
            duration =
            {
                font = SV.fontNameGP,
                size = SV.fontSizeGP,
                outline = SV.fontTypeGP,
                y = SV.timeYGP,
                color = SV.timeColorGP,
            },
            stacks =
            {
                font = SV.fontNameStackGP,
                size = SV.fontSizeStackGP,
                outline = SV.fontTypeStackGP,
                x = SV.stackXGP,
                y = SV.stackYGP,
                color = SV.stackColorGP,
            },
            targets =
            {
                font = SV.fontNameTargetGP,
                size = SV.fontSizeTargetGP,
                outline = SV.fontTypeTargetGP,
                x = SV.targetXGP,
                y = SV.targetYGP,
                color = SV.targetColorGP,
            },
            ult =
            {
                duration =
                {
                    show = SV.ultShowGP,
                    font = SV.ultNameGP,
                    size = SV.ultSizeGP,
                    outline = SV.ultTypeGP,
                    x = SV.ultXGP,
                    y = SV.ultYGP,
                    color = SV.ultColorGP,
                },
                value =
                {
                    show = SV.ultValueEnableGP,
                    mode = SV.ultValueModeGP,
                    font = SV.ultValueNameGP,
                    size = SV.ultValueSizeGP,
                    outline = SV.ultValueTypeGP,
                    x = SV.ultValueXGP,
                    y = SV.ultValueYGP,
                    color = SV.ultValueColorGP,
                    threshold = SV.ultValueThresholdGP,
                    usableThresholdColor = SV.ultUsableThresholdColorGP,
                    usableColor = SV.ultUsableValueColorGP,
                    maxColor = SV.ultMaxValueColorGP,
                },
                companion =
                {
                    show = SV.ultValueEnableCompanionGP,
                    mode = SV.ultValueModeCompanionGP,
                    x = SV.ultValueCompanionXGP,
                    y = SV.ultValueCompanionYGP,
                },
            },
            qs =
            {
                show = SV.qsTimerEnableGP,
                font = SV.qsNameGP,
                size = SV.qsSizeGP,
                outline = SV.qsTypeGP,
                x = SV.qsXGP,
                y = SV.qsYGP,
                color = SV.qsColorGP,
                stackFont = SV.qsStackNameGP,
                stackSize = SV.qsStackSizeGP,
                stackOutline = SV.qsStackTypeGP,
                stackColor = SV.qsStackColorGP,
            },
            abScale =
            {
                enable = SV.abScaling.gp.enable,
                scale = SV.abScaling.gp.scale,
            },
            move =
            {
                enable = SV.abMove.gp.enable,
                x = SV.abMove.gp.x,
                y = SV.abMove.gp.y,
            },
            abilitySlot =
            {
                offsetX = SV.abilitySlotOffsetXGP,
            },
            style = {},
        }
        c = gp
    end

    c.hideOnNoTargetGlobal = FancyActionBar.GetHideOnNoTargetGlobalSetting()
    c.hideOnNoTargetList = FancyActionBar.GetHideOnNoTargetList()
    c.noTargetFade = FancyActionBar.GetNoTargetFade()
    c.noTargetAlpha = FancyActionBar.GetNoTargetAlpha()
    c.update = FancyActionBar.RefreshUpdateConfiguration()
    c.style = style
    return c
end
