--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar
local d = FancyActionBar.defaultSettings -- default settings variables...

FancyActionBar.devConfig =
{
    ["noTargetAlpha"] = 90,
    ["targetYGP"] = 0,
    ["showStackCount"] = true,
    ["markerSize"] = 26,
    ["qsColorGP"] =
    {
        [1] = 1,
        [2] = 0.5000000000,
        [3] = 0.2000000000,
    },
    ["debugVerbose"] = false,
    ["fontSizeStackGP"] = 26,
    ["fontSizeGP"] = 34,
    ["staticBars"] = true,
    ["showDecimal"] = "Expire",
    ["showHotkeysUltGP"] = false,
    ["arrowColor"] =
    {
        [4] = 1,
        [1] = 0,
        [2] = 1,
        [3] = 0,
    },
    ["ultValueNameKB"] = "Univers 67",
    ["ultValueColorKB"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["fontSizeKB"] = 24,
    ["keepLastTarget"] = true,
    ["ultUsableValueColorGP"] =
    {
        [1] = 0,
        [2] = 1,
        [3] = 0,
    },
    ["ultimateSlotCustomXOffsetGP"] = 10,
    ["qsNameGP"] = "Univers 67",
    ["moveQS"] = true,
    ["ultFlash"] = true,
    ["barXOffsetGP"] = 0,
    ["showSingleTargetInstance"] = false,
    ["dynamicAbilityConfig"] = true,
    ["toggledColor"] =
    {
        [4] = 0.7000000000,
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["debuffConfigUpgraded"] = false,
    ["ultValueXGP"] = 15,
    ["debug"] = false,
    ["ultValueEnableCompanionGP"] = true,
    ["quickSlotCustomXOffsetKB"] = 0,
    ["ultXGP"] = 67,
    ["fontSizeStackKB"] = 20,
    ["debugAll"] = false,
    ["fontNameGP"] = "Univers 67",
    ["showCastDuration"] = true,
    ["showToggleTicks"] = true,
    ["showHotkeys"] = false,
    ["ultValueEnableCompanionKB"] = true,
    ["fadeDelay"] = 2,
    ["fontNameStackGP"] = "Univers 67",
    ["ultValueNameGP"] = "Univers 67",
    ["ultValueSizeKB"] = 20,
    ["qsXKB"] = 0,
    ["stackYGP"] = 0,
    ["targetXGP"] = 3,
    ["qsSizeGP"] = 34,
    ["ultValueColorGP"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["applyActionBarSkillStyles"] = true,
    ["qsTimerEnableKB"] = true,
    ["ultSizeGP"] = 40,
    ["ultValueThresholdKB"] = 0.9000000000,
    ["ultYKB"] = 0,
    ["ultimateSlotCustomYOffsetKB"] = 0,
    ["abilitySlotOffsetXGP"] = 4,
    ["ultMaxValueColorGP"] =
    {
        [1] = 1,
        [2] = 0,
        [3] = 0,
    },
    ["ultValueYGP"] = 80,
    ["variablesValidated"] = true,
    ["showExpire"] = true,
    ["ultTypeGP"] = "thick-outline",
    ["ignoreTrapPlacement"] = false,
    ["useThinFrames"] = true,
    ["fontTypeStackKB"] = "thick-outline",
    ["showFrames"] = true,
    ["frameColor"] =
    {
        [4] = 1,
        [1] = 0,
        [2] = 0,
        [3] = 0,
    },
    ["ultValueModeCompanionGP"] = 1,
    ["timeColorGP"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["ultMaxValueColorKB"] =
    {
        [1] = 1,
        [2] = 0,
        [3] = 0,
    },
    ["fontSizeTargetKB"] = 20,
    ["quickSlotCustomYOffsetKB"] = 0,
    ["frontBarTop"] = false,
    ["ultValueSizeGP"] = 35,
    ["ultValueTypeKB"] = "outline",
    ["ultUsableThresholdColorKB"] =
    {
        [1] = 1,
        [2] = 0.8000000000,
        [3] = 0,
    },
    ["hideOnNoTargetList"] =
    {
    },
    ["ultNameGP"] = "Univers 67",
    ["qsTypeGP"] = "outline",
    ["hideDefaultFrames"] = true,
    ["ultNameKB"] = "Univers 67",
    ["durationMin"] = 2,
    ["ultValueThresholdGP"] = 0.9000000000,
    ["ultColorGP"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["showDecimalStart"] = 2,
    ["qsColorKB"] =
    {
        [1] = 1,
        [2] = 0.5000000000,
        [3] = 0.2000000000,
    },
    ["hideLockedBar"] = true,
    ["ignoreUngroupedAliies"] = true,
    ["showExpireStart"] = 2,
    ["externalBlackListRun"] = true,
    ["fontNameTargetGP"] = "Univers 67",
    ["barXOffsetKB"] = 0,
    ["hideOnNoTargetGlobal"] = false,
    ["ultSizeKB"] = 24,
    ["showSoonestExpire"] = true,
    ["ultFillFrameAlpha"] = 0.2500000000,
    ["ultimateSlotCustomXOffsetKB"] = 0,
    ["showArrow"] = true,
    ["fontTypeTargetKB"] = "thick-outline",
    ["ultShowKB"] = true,
    ["externalBuffs"] = false,
    ["ultValueModeGP"] = 3,
    ["activeBarTop"] = false,
    ["timeYGP"] = -2,
    ["targetColorGP"] =
    {
        [1] = 1,
        [2] = 0.8000000000,
        [3] = 0,
    },
    ["stackXKB"] = 37,
    ["highlightExpireColor"] =
    {
        [4] = 0.7000000000,
        [1] = 1,
        [2] = 0,
        [3] = 0,
    },
    ["allowParentTime"] = true,
    ["qsYKB"] = 7,
    ["targetColorKB"] =
    {
        [1] = 1,
        [2] = 0.8000000119,
        [3] = 0,
    },
    ["multiTargetBlackListRun"] = true,
    ["ultYGP"] = 0,
    ["delayFade"] = true,
    ["ultValueCompanionYGP"] = 0,
    ["qsTypeKB"] = "outline",
    ["ultValueEnableKB"] = true,
    ["ultimateSlotCustomOffset"] = 0,
    ["ultFillColor"] =
    {
        [1] = 0.4901960790,
        [2] = 0.5803921819,
        [3] = 1,
    },
    ["ultValueXKB"] = 5,
    ["qsXGP"] = 0,
    ["timeYKB"] = 0,
    ["ultShowGP"] = true,
    ["highlightColor"] =
    {
        [4] = 0.7000000000,
        [1] = 0,
        [2] = 1,
        [3] = 0,
    },
    ["barYOffsetKB"] = 0,
    ["ultUsableValueColorKB"] =
    {
        [1] = 0,
        [2] = 1,
        [3] = 0,
    },
    ["qsNameKB"] = "Univers 67",
    ["ultValueModeKB"] = 3,
    ["stackYKB"] = 1,
    ["ultValueCompanionXKB"] = 0,
    ["fontNameKB"] = "Univers 67",
    ["repositionActiveBar"] = true,
    ["fontNameTargetKB"] = "Univers 67",
    ["fontTypeStackGP"] = "thick-outline",
    ["allowStaticBarSwap"] = false,
    ["quickSlotCustomXOffsetGP"] = 0,
    ["stackColorKB"] =
    {
        [1] = 1,
        [2] = 0.8000000000,
        [3] = 0,
    },
    ["ultimateSlotCustomYOffsetGP"] = 0,
    ["noTargetFade"] = false,
    ["ultValueModeCompanionKB"] = 1,
    ["lockInTrade"] = true,
    ["fontTypeGP"] = "thick-outline",
    ["ultValueEnableGP"] = true,
    ["showOvertauntStacks"] = false,
    ["ultValueCompanionYKB"] = 0,
    ["abilitySlotOffsetXKB"] = 2,
    ["ultValueCompanionXGP"] = 0,
    ["stackColorGP"] =
    {
        [1] = 1,
        [2] = 0.8000000000,
        [3] = 0,
    },
    ["ultUsableThresholdColorGP"] =
    {
        [1] = 1,
        [2] = 0.8000000000,
        [3] = 0,
    },
    ["targetYKB"] = 1,
    ["ultColorKB"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["hideCompanionUlt"] = false,
    ["addonVersion"] = "2.9.0",
    ["barYOffsetGP"] = 2,
    ["alphaInactive"] = 33,
    ["toggledHighlight"] = true,
    ["showHighlight"] = true,
    ["durationMax"] = 120,
    ["fontTypeKB"] = "thick-outline",
    ["fontSizeTargetGP"] = 26,
    ["highlightExpire"] = true,
    ["qsYGP"] = 5,
    ["timeColorKB"] =
    {
        [1] = 1,
        [2] = 1,
        [3] = 1,
    },
    ["moveHealthBar"] = true,
    ["ultValueYKB"] = 50,
    ["showDeath"] = false,
    ["showTargetCount"] = true,
    ["targetXKB"] = 3,
    ["ultXKB"] = 37,
    ["fontTypeTargetGP"] = "thick-outline",
    ["quickSlotCustomYOffsetGP"] = 0,
    ["stackXGP"] = 37,
    ["ultTypeKB"] = "thick-outline",
    ["version"] = 1,
    ["expireColor"] =
    {
        [1] = 1,
        [2] = 0,
        [3] = 0.3921568692,
    },
    ["forceGamepadStyle"] = true,
    ["ultFillBarAlpha"] = 1,
    ["fontNameStackKB"] = "Univers 67",
    ["ultValueTypeGP"] = "outline",
    ["advancedDebuff"] = true,
    ["qsSizeKB"] = 24,
    ["desaturationInactive"] = 50,
    ["qsTimerEnableGP"] = true,
    ["hideInactiveSlots"] = false,
}

FancyActionBar.adrConfig =
{
    ["hideInactiveSlots"] = true,
    ["staticBars"] = false,
    ["frontBarTop"] = true,
    ["ultimateSlotCustomYOffsetKB"] = 27,
    ["quickSlotCustomYOffsetKB"] = 27,
    ["ultimateSlotCustomYOffsetGP"] = 34,
    ["quickSlotCustomYOffsetGP"] = 34,
}