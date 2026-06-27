--- @class (partial) FancyActionBar
--- @field __index FancyActionBar
--- @field constants FancyActionBarConstants
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
    configProfiles = {},
    selectedConfigProfile = 1,
    nextConfigProfileId = 1,
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
    configProfiles = {},
    selectedConfigProfile = 1,
    nextConfigProfileId = 1,
    dynamicAbilityConfig = false,
    forceGamepadStyle = false,
    keyboardBounceAnimation = false,

    externalBuffs = false,
    externalBlackListRun = false,
    externalBlackList = {},
    effectWidgets = {},
    effectWidgetActiveAlphaDefault = 1,
    effectWidgetInactiveAlphaDefault = 0,
    effectWidgetsLocked = true,

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
    useSplitShalksTimers = true,
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
    moveResourceBars = ZO_IsConsoleOrGameCoreUI(),
    moveBuffs = ZO_IsConsoleOrGameCoreUI(),
    moveSynergy = ZO_IsConsoleOrGameCoreUI(),
    forceReposition = false,
    forceAzurahMover = false,

    -- inactive bar visibility
    alphaInactive = 20,
    desaturationInactive = 50,
    tintInactive = { 1, 1, 1, 1 },
    overlayFrameAlphaInactive = 100,
    overlayBgAlphaInactive = 100,
    -- active bar visibility
    applyActiveBarAlpha = false,
    applyActiveBarDesaturation = false,
    applyActiveBarTint = false,
    alphaUsable = 100,
    alphaUnusable = 57,
    desatUsable = 0,
    desatUnusable = 100,
    tintUsable = { 1, 1, 1, 1 },
    tintUnusable = { 0.3, 0.3, 0.3, 1 },
    overlayFrameAlphaActive = 100,
    overlayBgAlphaActive = 100,
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
    parentTimeBlackListRun = false,
    parentTimeBlacklist = {},
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
    -- Use the default ZO ActionBar weapon swap control instead of the custom FAB arrow
    useDefaultWeaponSwap = false,
    -- The default control is centered between the bars because of our bar offsets, set false to do our custom repositioning of this swap control
    centerDefaultWeaponSwap = true,
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
    -- outdated and mostly unused. will make settings more manageable eventually.

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
    catFBVisual = GetString(FANCYAB_CAT_FBVISUAL),
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
    -- inactive bar
    alphaName = GetString(FANCYAB_ALPHA_NAME),
    alphaTT = GetString(FANCYAB_ALPHA_TT),
    desatName = GetString(FANCYAB_DESAT_NAME),
    desatTT = GetString(FANCYAB_DESAT_TT),
    tintInactiveName = GetString(FANCYAB_TINT_INACTIVE_NAME),
    tintInactiveTT = GetString(FANCYAB_TINT_INACTIVE_TT),

    -- active bar
    applyActiveBarAlphaName = GetString(FANCYAB_APPLY_ACTIVE_ALPHA_NAME),
    applyActiveBarAlphaTT = GetString(FANCYAB_APPLY_ACTIVE_ALPHA_TT),
    applyActiveBarDesaturationName = GetString(FANCYAB_APPLY_ACTIVE_DESAT_NAME),
    applyActiveBarDesaturationTT = GetString(FANCYAB_APPLY_ACTIVE_DESAT_TT),
    alphaUsableName = GetString(FANCYAB_ALPHA_USABLE_NAME),
    alphaUsableTT = GetString(FANCYAB_ALPHA_USABLE_TT),
    alphaUnusableName = GetString(FANCYAB_ALPHA_UNUSABLE_NAME),
    alphaUnusableTT = GetString(FANCYAB_ALPHA_UNUSABLE_TT),
    desatUsableName = GetString(FANCYAB_DESAT_USABLE_NAME),
    desatUsableTT = GetString(FANCYAB_DESAT_USABLE_TT),
    desatUnusableName = GetString(FANCYAB_DESAT_UNUSABLE_NAME),
    desatUnusableTT = GetString(FANCYAB_DESAT_UNUSABLE_TT),
    applyActiveBarTintName = GetString(FANCYAB_APPLY_ACTIVE_TINT_NAME),
    applyActiveBarTintTT = GetString(FANCYAB_APPLY_ACTIVE_TINT_TT),
    tintUsableName = GetString(FANCYAB_TINT_USABLE_NAME),
    tintUsableTT = GetString(FANCYAB_TINT_USABLE_TT),
    tintUnusableName = GetString(FANCYAB_TINT_UNUSABLE_NAME),
    tintUnusableTT = GetString(FANCYAB_TINT_UNUSABLE_TT),
    overlayFrameActiveName = GetString(FANCYAB_OVERLAY_FRAME_ACTIVE_NAME),
    overlayBgActiveName = GetString(FANCYAB_OVERLAY_BG_ACTIVE_NAME),
    overlayFrameInactiveName = GetString(FANCYAB_OVERLAY_FRAME_INACTIVE_NAME),
    overlayBgInactiveName = GetString(FANCYAB_OVERLAY_BG_INACTIVE_NAME),
    buttonBackdropAlphaTT = GetString(FANCYAB_BUTTON_BACKDROP_ALPHA_TT),
    frameBorderAlphaTT = GetString(FANCYAB_FRAME_BORDER_ALPHA_TT),

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

-- UI mode: 1 = keyboard, 2 = gamepad.
-- SV stores persisted settings with per-mode keys (SvKey, e.g. fontNameKB).
-- constants is the runtime snapshot for the active mode; menu setFuncs write SV
-- always and patch constants when constants.mode matches the panel being edited.
local modeSuffix = { [1] = "KB", [2] = "GP" }
local modeScaleKey = { [1] = "kb", [2] = "gp" }

function FancyActionBar.SvKey(base, mode)
    return base .. modeSuffix[mode]
end

function FancyActionBar.CurrentMode()
    local c = FancyActionBar.constants
    if c then
        return c.mode
    end
    return FancyActionBar.GetUIMode()
end

local layoutFields =
{
    abilitySlotOffsetX = function (c) return c.abilitySlot.offsetX end,
    quickSlotCustomXOffset = function (c) return c.layout.quickSlot.x end,
    quickSlotCustomYOffset = function (c) return c.layout.quickSlot.y end,
    ultimateSlotCustomXOffset = function (c) return c.layout.ultimate.x end,
    ultimateSlotCustomYOffset = function (c) return c.layout.ultimate.y end,
    barXOffset = function (c) return c.layout.bar.x end,
    barYOffset = function (c) return c.layout.bar.y end,
}

function FancyActionBar.GetLayoutValue(base)
    local c = FancyActionBar.constants
    local reader = c and layoutFields[base]
    if reader then
        return reader(c)
    end
    return SV[FancyActionBar.SvKey(base, FancyActionBar.CurrentMode())]
end

function FancyActionBar.SetLayoutValue(base, value)
    SV[FancyActionBar.SvKey(base, FancyActionBar.CurrentMode())] = value
    FancyActionBar.RefreshLayoutConstants()
end

local function mapSection(sv, mode, fields)
    local section = {}
    for key, base in pairs(fields) do
        section[key] = sv[FancyActionBar.SvKey(base, mode)]
    end
    return section
end

local durationFields = { font = "fontName", size = "fontSize", outline = "fontType", y = "timeY", color = "timeColor" }
local stackFields = { font = "fontNameStack", size = "fontSizeStack", outline = "fontTypeStack", x = "stackX", y = "stackY", color = "stackColor" }
local targetFields = { font = "fontNameTarget", size = "fontSizeTarget", outline = "fontTypeTarget", x = "targetX", y = "targetY", color = "targetColor" }
local ultDurationFields = { show = "ultShow", font = "ultName", size = "ultSize", outline = "ultType", x = "ultX", y = "ultY", color = "ultColor" }
local ultValueFields =
{
    show = "ultValueEnable", mode = "ultValueMode", font = "ultValueName", size = "ultValueSize", outline = "ultValueType",
    x = "ultValueX", y = "ultValueY", color = "ultValueColor", threshold = "ultValueThreshold",
    usableThresholdColor = "ultUsableThresholdColor", usableColor = "ultUsableValueColor", maxColor = "ultMaxValueColor",
}
local ultCompanionFields = { show = "ultValueEnableCompanion", mode = "ultValueModeCompanion", x = "ultValueCompanionX", y = "ultValueCompanionY" }
local qsFields =
{
    show = "qsTimerEnable", font = "qsName", size = "qsSize", outline = "qsType", x = "qsX", y = "qsY", color = "qsColor",
    stackFont = "qsStackName", stackSize = "qsStackSize", stackOutline = "qsStackType", stackColor = "qsStackColor",
}

--- User layout offsets for the active UI mode.
--- @param vars table
--- @param mode integer
--- @return table
function FancyActionBar.BuildLayout(vars, mode)
    local barX = vars[FancyActionBar.SvKey("barXOffset", mode)] or 0
    local barY = vars[FancyActionBar.SvKey("barYOffset", mode)] or 0
    return
    {
        quickSlot = { x = vars[FancyActionBar.SvKey("quickSlotCustomXOffset", mode)] or 0, y = vars[FancyActionBar.SvKey("quickSlotCustomYOffset", mode)] or 0 },
        ultimate = { x = vars[FancyActionBar.SvKey("ultimateSlotCustomXOffset", mode)] or 0, y = vars[FancyActionBar.SvKey("ultimateSlotCustomYOffset", mode)] or 0 },
        bar = { x = barX, y = barY, halfX = barX / 2, halfY = barY / 2 },
    }
end

--- Returns runtime constants for the given mode and style template.
--- @param mode number 1 for keyboard, 2 for gamepad
--- @param vars table the saved variables
--- @param style table the style table
--- @return table
function FancyActionBar.UpdateConstants(mode, vars, style)
    local scaleKey = modeScaleKey[mode]
    local c =
    {
        mode = mode,
        isGamepad = mode == 2,
        duration = mapSection(vars, mode, durationFields),
        stacks = mapSection(vars, mode, stackFields),
        targets = mapSection(vars, mode, targetFields),
        ult =
        {
            duration = mapSection(vars, mode, ultDurationFields),
            value = mapSection(vars, mode, ultValueFields),
            companion = mapSection(vars, mode, ultCompanionFields),
        },
        qs = mapSection(vars, mode, qsFields),
        abScale = { enable = vars.abScaling[scaleKey].enable, scale = vars.abScaling[scaleKey].scale },
        move = { enable = vars.abMove[scaleKey].enable, x = vars.abMove[scaleKey].x, y = vars.abMove[scaleKey].y },
        abilitySlot = { offsetX = vars[FancyActionBar.SvKey("abilitySlotOffsetX", mode)] },
        layout = FancyActionBar.BuildLayout(vars, mode),
        scaled = {},
        style = style,
    }

    c.hideOnNoTargetGlobal = FancyActionBar.GetHideOnNoTargetGlobalSetting()
    c.hideOnNoTargetList = FancyActionBar.GetHideOnNoTargetList()
    c.noTargetFade = FancyActionBar.GetNoTargetFade()
    c.noTargetAlpha = FancyActionBar.GetNoTargetAlpha()
    c.update = FancyActionBar.RefreshUpdateConfiguration()
    return c
end
