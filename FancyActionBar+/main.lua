--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar
-------------------------------------------------------------------------------
-----------------------------[    Constants   ]--------------------------------
-------------------------------------------------------------------------------
local NAME = "FancyActionBar+"
local VERSION = "2.15.0"
local slashCommand = "/fab" or "/FAB"
local EM = GetEventManager()
local WM = GetWindowManager()
local SM = SCENE_MANAGER
local strformat = string.format
local time = GetGameTimeSeconds
local MIN_INDEX = 3                          -- first ability index
local MAX_INDEX = 7                          -- last ability index
local ULT_INDEX = 8                          -- ultimate slot index
local QUICK_SLOT = 9                         -- ACTION_BAR_FIRST_UTILITY_BAR_SLOT + 1
local SLOT_INDEX_OFFSET = 20                 -- offset for backbar abilities indices
local COMPANION_INDEX_OFFSET = 30            -- offset for companion ultimate
local SLOT_COUNT = MAX_INDEX - MIN_INDEX + 1 -- total number of slots
local ACTION_BAR = GetControl("ZO_ActionBar1")
local weaponSwapControl = ACTION_BAR:GetNamedChild("WeaponSwap")
local FAB_Default_Bar_Position = GetControl("FAB_Default_Bar_Position")
local FAB_ActionBarFakeQS = GetControl("FAB_ActionBarFakeQS")
local currentWeaponPair = GetHeldWeaponPair()
local isWeaponSwapLocked = false  -- for tracking weapon swap lock state
local specialHotbarActive = false -- for tracking if a specialHotbar is active


local specialHotbar =
{
    [HOTBAR_CATEGORY_TEMPORARY] = true,
    [HOTBAR_CATEGORY_DAEDRIC_ARTIFACT] = true,
}

local GAMEPAD_CONSTANTS =
{
    anchor = ZO_Anchor:New(BOTTOM, GuiRoot, BOTTOM, 0, -25),
    dimensions = 64,
    flipCardSize = 61,
    ultFlipCardSize = 67,
    abilitySlotWidth = 64,
    buttonTextOffsetY = 80,
    actionBarOffset = -52,
    attributesOffset = -152,
    width = 606,
    anchorOffsetY = -25,
    ultimateSlotOffsetX = 12, -- 65,
    ultSize = 70,
    quickslotOffsetX = 0,
    bindingTextOnUlt = false,
    showKeybindBG = false,
    buttonTemplate = "FAB_ActionButton_Gamepad_Template",
    ultButtonTemplate = "FAB_UltimateActionButton_Gamepad_Template",
    overlayTemplate = "FAB_ActionButtonOverlay_Gamepad_Template",
    ultOverlayTemplate = "FAB_UltimateButtonOverlay_Gamepad_Template",
    qsOverlayTemplate = "FAB_QuickSlotOverlay_Gamepad_Template",
}
local KEYBOARD_CONSTANTS =
{
    anchor = ZO_Anchor:New(BOTTOM, GuiRoot, BOTTOM, 0, 0),
    dimensions = 50,
    flipCardSize = 47,
    ultFlipCardSize = 47,
    abilitySlotWidth = 50,
    buttonTextOffsetY = 62,
    actionBarOffset = -22,
    attributesOffset = -112,
    width = 483,
    anchorOffsetY = 0,
    ultimateSlotOffsetX = 8, -- 12,
    ultSize = 50,
    quickslotOffsetX = 0,
    bindingTextOnUlt = false,
    showKeybindBG = false,
    buttonTemplate = "FAB_ActionButton_Keyboard_Template",
    ultButtonTemplate = "FAB_UltimateActionButton_Keyboard_Template",
    overlayTemplate = "FAB_ActionButtonOverlay_Keyboard_Template",
    ultOverlayTemplate = "FAB_UltimateButtonOverlay_Keyboard_Template",
    qsOverlayTemplate = "FAB_QuickSlotOverlay_Keyboard_Template",
}
local ULTIMATE_BUTTON_STYLE =
{ -- TODO make back bar ult button to display duration.
    type = ACTION_BUTTON_TYPE_VISIBLE,
    template = "ZO_UltimateActionButton",
    showBinds = false,
    parentBar = "",
}
local GROUND_EFFECT = ABILITY_TYPE_AREAEFFECT
local DEBUFF = BUFF_EFFECT_TYPE_DEBUFF
-------------------------------------------------------------------------------
-----------------------------[    Global    ]----------------------------------
-------------------------------------------------------------------------------
FancyActionBar.effects = {}        -- currently slotted abilities
FancyActionBar.stacks = {}         -- ability id => current stack count
FancyActionBar.stackIds = {}       -- stack id tables for each effectId
FancyActionBar.targets = {}        -- ability id => current active target table
FancyActionBar.activeCasts = {}    -- updating timers to account for delay and expiration ( mostly for debugging )
--- @type table<integer, boolean>
FancyActionBar.toggles = {}        -- works together with effects to update toggled abilities activation
FancyActionBar.debuffs = {}        -- effects for debuffs to update if they are active on target
FancyActionBar.stashedEffects = {} -- Used with specalEffects to track prioritized effects from skills that apply multiple with different durations


-- Backbar buttons.
FancyActionBar.buttons = {} -- Contains: abilities duration, number of stacks and debuffed targets, and visual effects.
FancyActionBar.slotHidden = {}

-- FancyActionBar.abilitySlots                  = {} -- TODO enable tooltip, mouse click and drag functions
--- @type {[1]:(FAB_ActionButtonOverlay_Keyboard_Template|FAB_ActionButtonOverlay_Gamepad_Template),[any] : any|userdata}
FancyActionBar.overlays = {}                 -- normal skill button overlays
--- @type {[1]:(FAB_UltimateButtonOverlay_Keyboard_Template|FAB_UltimateButtonOverlay_Gamepad_Template),[any] : any|userdata}
FancyActionBar.ultOverlays = {}              -- player and companion ultimate skill button overlays
FancyActionBar.style = nil                   -- Gamepad or Keyboard UI for compatibility

FancyActionBar.qsOverlay = nil               -- shortcut for.. reasons..

FancyActionBar.updateUI = false              -- don't change configuration if not needed
FancyActionBar.useGamepadActionBar = false   -- If the gamepad actionbar style should be force enabled
FancyActionBar.wasMoved = false              -- don't move action bar if it wasn't moved to begin with
FancyActionBar.wasStopped = false            -- don't register updates if already registered

FancyActionBar.zone = 0                      -- some buffs expire when traveling, and some don't. check active buffs on player
FancyActionBar.inCombat = false              -- for GCD

FancyActionBar.weaponFront = WEAPONTYPE_NONE -- for getting correct id's for destro staff skills on back bar
FancyActionBar.weaponBack = WEAPONTYPE_NONE
FancyActionBar.oakensoul = "/esoui/art/icons/u34_mythic_oakensoul_ring.dds"
FancyActionBar.oakensoulEquipped = false
FancyActionBar.isWerewolf = false

FancyActionBar.durationMin = 4
FancyActionBar.durationMax = 99

FancyActionBar.player = { name = "", id = 0 } -- might be needed to check for some effects before updating timer

FancyActionBar.constants =
{ -- all current values for the UI and configuration to use. not sure why I called it 'constants' when they are all in fact variables.
    duration =
    {
        font = "Univers 67",
        size = 24,
        outline = "thick-outline",
        y = 0,
        color = { 1, 1, 1 },
    },
    stacks =
    {
        font = "Univers 67",
        size = 20,
        outline = "thick-outline",
        x = 37,
        color = { 1, 0.8, 0 },
    },
    targets =
    {
        font = "Univers 67",
        size = 20,
        outline = "thick-outline",
        x = 37,
        color = { 1, 0.8, 0 },
    },
    ult =
    {
        duration =
        {
            show = true,
            font = "Univers 67",
            size = 24,
            outline = "thick-outline",
            x = 37,
            y = 0,
            color = { 1, 1, 1 },
        },
        value =
        {
            show = false,
            mode = 1,
            font = "Univers 67",
            size = 20,
            outline = "outline",
            x = -2,
            y = -5,
            color = { 1, 1, 1 },
        },
        companion =
        {
            show = true,
            mode = 1,
            x = 0,
            y = 0,
        },
    },
    qs =
    {
        show = true,
        font = "Univers 67",
        size = 24,
        outline = "outline",
        x = 0,
        y = 10,
        color = { 1, 0.5, 0.2 },
        stackFont = "Univers 67",
        stackSize = 18,
        stackOutline = "soft-shadow-thin",
        stackColor = { 1, 1, 1 },
    },
    abScale =
    {
        enable = false,
        scale = 100,
    },
    move =
    {
        enable = false,
        x = 0,
        y = 0,
    },
    noTargetAlpha = 90,
    abilitySlot =
    {
        offsetX = 2,
    },
    style =
    {
        abilitySlotWidth    = nil,
        actionBarOffset     = nil,
        anchor              = nil,
        anchorOffsetY       = nil,
        attributesOffset    = nil,
        bindingTextOnUlt    = nil,
        buttonTemplate      = nil,
        buttonTextOffsetY   = nil,
        dimensions          = nil,
        flipCardSize        = nil,
        overlayTemplate     = nil,
        qsOverlayTemplate   = nil,
        quickslotOffsetX    = nil,
        showKeybindBG       = nil,
        ultButtonTemplate   = nil,
        ultFlipCardSize     = nil,
        ultOverlayTemplate  = nil,
        ultSize             = nil,
        ultimateSlotOffsetX = nil,
        width               = nil,
    },
    update = {},
    hideOnNoTargetGlobal = {},
    hideOnNoTargetList = {}
}
-------------------------------------------------------------------------------
-----------------------------[    Tables    ]----------------------------------
-------------------------------------------------------------------------------
local defaultSettings = FancyActionBar.defaultSettings -- default settings variables...
local abilityConfig = {}                               -- parsed FancyActionBar.abilityConfig.
local specialIds = {}                                  -- abilities that needs to be updated individually when fired ( cause too special to be tracked by effect changed events, or if I wanna do something more with them )
local sourceAbilities = {}                             -- to track which abilities are currently slotting effects
local slottedIds = {}                                  -- to match skills with their tracked effect
local effectSlots = {}                                 -- to indentify slots that track the same effect
local debuffTargets = {}                               -- not used, but might be needed when I get better at writing tracking for debuffs on enemies
local lastAreaTargets = {}                             -- unit id for 'offline' target when casting ground effects always change. check if it was the same target id before fading if before 0
local registeredSkillLines = {}                        -- to track skill lines that have been registered for ability changes
-------------------------------------------------------------------------------
---------------------------[   Local Variables   ]-----------------------------
-------------------------------------------------------------------------------
local SV = ...         -- saved variables (accountwide)
local CV = ...         -- saved variables (character)
local debug = false    -- debug mode

local scale = 100      -- default or custom scale of the action bar to use
local updateRate = 100 -- overlay update interval

-- local lastButton = 0                       -- for repositioning of skill buttons
local channeledAbilityUsed = nil           -- for tracking channeling abilities
local isChanneling = false                 -- for tracking channeling abilities
local wasBlockActive = false               -- for tracking block state
local activeUlt = { id = 0, endTime = -1 } -- for tracking ultimate duration across barswap

local guardId = 0                          -- sync active id for guard on both bars as active and inactive are different
local cost1 = 0
local cost2 = 0
local cost3 = 0
local costAlt = 0
local WEAPONTYPE_NONE = WEAPONTYPE_NONE -- just to make sure the game isn't confused by its own constants. ( not sure why this would even happen, but it does.. )
local WEAPONTYPE_FIRE_STAFF = WEAPONTYPE_FIRE_STAFF
local WEAPONTYPE_FROST_STAFF = WEAPONTYPE_FROST_STAFF
local WEAPONTYPE_LIGHTNING_STAFF = WEAPONTYPE_LIGHTNING_STAFF
--------------------------------------------------------------------------------
-----------------------------[ 		Utility    ]----------------------------------
--------------------------------------------------------------------------------

do
    --- Adds a system message to the chat.
    --- @param messageOrFormatter string: The message to be printed.
    --- @param ... string: Variable number of arguments to be formatted into the message.
    local function AddSystemMessage(messageOrFormatter, ...)
        if not SV.debug then
            return
        end
        local formattedMessage
        if select("#", ...) > 0 then
            formattedMessage = strformat(messageOrFormatter or "", ...)
        else
            formattedMessage = messageOrFormatter or ""
        end
        CHAT_ROUTER:AddSystemMessage(formattedMessage)
    end

    FancyActionBar.AddSystemMessage = AddSystemMessage
end

--- Slash command handler
--- @param str string
function FancyActionBar.SlashCommand(str)
    local setting
    if SV.debuffTable == nil then
        SV.debuffTable = {}
    end
    local cmd = string.lower(str)
    if cmd == "dbg 0" then
        SV.debug = false
        SV.debugAll = false
        FancyActionBar.AddSystemMessage("[FAB+] debug: Off.")
    elseif cmd == "dbg 1" then
        SV.debug = not SV.debug
        if SV.debug then
            setting = "On."
        else
            setting = "Off."
        end
        FancyActionBar.AddSystemMessage("[FAB+] debug1: " .. setting)
    elseif cmd == "dbg 2" then
        SV.debugAll = not SV.debugAll
        if SV.debugAll then
            setting = "On."
        else
            setting = "Off."
        end
        FancyActionBar.AddSystemMessage("[FAB+] debugAll: " .. setting)
    elseif cmd == "dbg 3" then
        SV.debugVerbose = not SV.debugVerbose
        if SV.debugVerbose then
            setting = "On."
        else
            setting = "Off."
        end
        FancyActionBar.AddSystemMessage("[FAB+] Verbose debug: " .. setting)
    elseif cmd == "bar1" then
        FancyActionBar.PostSlottedSkills(1)
    elseif cmd == "bar2" then
        FancyActionBar.PostSlottedSkills(2)
    elseif cmd == "bars" then
        FancyActionBar.PostSlottedSkills(3)
    elseif cmd == "overlay" then
        FancyActionBar.PostOverlayEffects()
    elseif cmd == "track" then
        FancyActionBar.PostAbilityConfig()
    elseif cmd == "stacks" then
        for id, effect in pairs(FancyActionBar.stackMap) do
            for i = 1, #effect do
                FancyActionBar.AddSystemMessage("[" .. id .. "] = " .. effect[i])
            end
        end
    elseif cmd == "targets" then
        for id, effect in pairs(FancyActionBar.targets) do
            for i = 1, #effect do
                FancyActionBar.AddSystemMessage("[" .. id .. "] = " .. effect[i])
            end
        end
    elseif cmd == "dbt" then
        FancyActionBar.AddSystemMessage("[FAB+] Registered Debuff IDs:")
        for id in pairs(SV.debuffTable) do
            FancyActionBar.AddSystemMessage(tostring(id))
        end
    end
end

--- @param index number
--- @param bar? HotBarCategory
--- @return integer abilityId
function FancyActionBar.GetSlotBoundAbilityId(index, bar)
    bar = bar or GetActiveHotbarCategory()
    local id = GetSlotBoundId(index, bar)
    local actionType = GetSlotType(index, bar)
    if actionType == ACTION_TYPE_CRAFTED_ABILITY then
        id = GetAbilityIdForCraftedAbilityId(id)
    elseif FancyActionBar.barHighlightDestroFix[id] then
        local weaponType = bar == HOTBAR_CATEGORY_BACKUP and FancyActionBar.weaponBack or FancyActionBar.weaponFront
        id = FancyActionBar.GetCorrectedAbilityId(id, weaponType)
    end
    return id
end

--- Gets corrected ability ID based on weapon type and special cases
--- @param abilityId integer Original ability ID
--- @param weaponType number Weapon type (WEAPONTYPE_* constants)
--- @return integer Corrected ability ID
function FancyActionBar.GetCorrectedAbilityId(abilityId, weaponType)
    local correctedAbilityId = abilityId
    local barHighlightDestroFix = FancyActionBar.barHighlightDestroFix

    -- Only process abilities that have staff variants defined in the fix table
    if not barHighlightDestroFix[abilityId] then
        return abilityId
    end

    -- Only apply correction for staff weapon types
    if weaponType == WEAPONTYPE_FIRE_STAFF or weaponType == WEAPONTYPE_FROST_STAFF or weaponType == WEAPONTYPE_LIGHTNING_STAFF or weaponType == WEAPONTYPE_NONE then
        if barHighlightDestroFix[abilityId] and barHighlightDestroFix[abilityId][weaponType] then
            correctedAbilityId = barHighlightDestroFix[abilityId][weaponType]

            -- Debug output if enabled
            if FancyActionBar.IsDebugMode() then
                local staffType = "unknown"
                if weaponType == WEAPONTYPE_FIRE_STAFF then
                    staffType = "fire"
                elseif weaponType == WEAPONTYPE_FROST_STAFF then
                    staffType = "frost"
                elseif weaponType == WEAPONTYPE_LIGHTNING_STAFF then
                    staffType = "lightning"
                elseif weaponType == WEAPONTYPE_NONE then
                    staffType = "none"
                end

                FancyActionBar.AddSystemMessage("Corrected ability ID from %d to %d for %s staff",
                    abilityId, correctedAbilityId, staffType)
            end
        end
    end

    return correctedAbilityId
end

function FancyActionBar.GetAbilityDuration(abilityId, overrideActiveRank, overrideCasterUnitTag)
    overrideActiveRank = overrideActiveRank or nil
    overrideCasterUnitTag = overrideCasterUnitTag or "player"
    return GetAbilityDuration(abilityId, overrideActiveRank, overrideCasterUnitTag)
end

local GetAbilityDuration = FancyActionBar.GetAbilityDuration
local function CheckHyperTools()
    if _G["HyperTools"] then
        return "HT"
    elseif _G["HyperTankingTools"] and HTTsavedVars[HTT_variables.currentlySelectedProfile].isStoneFistCustomIconOn then
        return "HTT"
    else
        return ""
    end
end

--- @param hyper string
--- @return string
local function GetHyperToolsIcon(hyper)
    if hyper == "HT" then
        return "HyperTools/icons/stonefistStomp.dds"
    elseif hyper == "HTT" then
        return "HyperTankingTools/icons/stonefistStomp.dds"
    else
        return ""
    end
end

function FancyActionBar.GetSkillStyleIconForAbilityId(abilityId)
    if FancyActionBar.barHighlightDestroFix[abilityId] then
        abilityId = FancyActionBar.GetCorrectedAbilityId(abilityId, WEAPONTYPE_NONE)
    elseif FancyActionBar.styleFix[abilityId] then
        abilityId = FancyActionBar.styleFix[abilityId]
    end
    if abilityId == 31816 then
        local hyper = CheckHyperTools()
        if hyper ~= "" then
            return GetHyperToolsIcon(hyper)
        end
    end
    local skillType, skillLineIndex, skillIndex = GetSpecificSkillAbilityKeysByAbilityId(abilityId)
    local progressionId = GetProgressionSkillProgressionId(skillType, skillLineIndex, skillIndex)
    local collectibleId = GetActiveProgressionSkillAbilityFxOverrideCollectibleId(progressionId)
    if not collectibleId or collectibleId == 0 then
        return nil
    end
    local collectibleIcon = GetCollectibleIcon(collectibleId)
    return collectibleIcon
end

function FancyActionBar.SkillStyleCollectibleUpdated(collectibleId)
    if not SV.applyActionBarSkillStyles then
        return
    end
    FancyActionBar.ApplyAbilityFxOverrides(SV.applyActionBarSkillStyles) -- TODO: Only update the specific ability and only when the specific collectible is updated.
    -- local ZO_COLLECTIBLE_DATA_MANAGER = ZO_COLLECTIBLE_DATA_MANAGER;
    -- local data;
    -- local collectibleIcon;
    -- data = ZO_COLLECTIBLE_DATA_MANAGER:GetCategoryDataById(COLLECTIBLE_CATEGORY_TYPE_ABILITY_FX_OVERRIDE);
    -- if data then
    --   data:GetSpecializedSortedCollectiblesObject().dirty = true;
    -- end;
    -- local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(collectibleId);
    -- if (not collectibleData) or (not collectibleData:IsSkillStyle()) then return; end;
end

---
--- @param abilityId integer
--- @return table|integer
--- @return integer?
function FancyActionBar.GetStackIdForAbilityId(abilityId)
    local stackIds = {}
    --- @type table<integer, boolean>
    local seenStackIds = {}
    if not abilityId or abilityId == "" then
        return stackIds
    end
    if FancyActionBar.specialEffects[abilityId] then
        local specialEffect = FancyActionBar.specialEffects[abilityId]
        if specialEffect.stackId then
            return specialEffect.stackId
        end
    end

    local stackMap = FancyActionBar.stackMap
    for stackId, abilityIds in pairs(stackMap) do
        for i = 1, #abilityIds do
            if abilityIds[i] == abilityId then
                if not seenStackIds[stackId] then
                    table.insert(stackIds, stackId)
                    seenStackIds[stackId] = true
                end
            end
        end
    end
    return stackIds
end

---
--- @param stackValues {[1]:string , [2]:integer}
--- @return string|integer maxStacks
function FancyActionBar.GetStackValue(stackValues)
    local maxStacks = nil
    for _, stacks in ipairs(stackValues) do
        if type(stacks) == "string" then
            return stacks
        elseif type(stacks) == "number" then
            if maxStacks == nil or stacks > maxStacks then
                maxStacks = stacks
            end
        end
    end
    return maxStacks or 0
end

---
--- @param index number
--- @param bar HotBarCategory
--- @return string
local function GetSlotInfoString(index, bar)
    local slot = index == 8 and "Ult" or tostring(index - 2)
    local string = "[" .. slot .. "] "
    local id = FancyActionBar.GetSlotBoundAbilityId(index, bar)
    if id > 0 then
        local name = GetAbilityName(id)
        string = string .. "<" .. name .. "> " .. id
    end
    return string
end

function FancyActionBar.PostAbilityConfig()
    FancyActionBar.AddSystemMessage("FAB+ Ability Configuration:")

    local s = FancyActionBar.abilityConfig

    for skill, id in pairs(s) do
        local v --- @type string

        if type(id) == "table" then
            if id == {} or id[1] == nil
            then
                v = "{}"
            else
                v = tostring(id[1])
            end
        elseif type(id) == "boolean" then
            v = "false"
        else
            v = tostring(id)
        end
        FancyActionBar.AddSystemMessage("[|cffffff" .. tostring(skill) .. "|r] = |cff6600" .. v .. "|r")
    end
end

---
--- @param bar HotBarCategory
function FancyActionBar.PostSlottedSkills(bar)
    FancyActionBar.AddSystemMessage("[FAB+] Current Skills:")
    if bar == 1 or bar == 3 then
        FancyActionBar.AddSystemMessage("Front Bar")
        for i = 3, 8 do
            FancyActionBar.AddSystemMessage(GetSlotInfoString(i, 0))
        end
    end
    if bar == 2 or bar == 3 then
        FancyActionBar.AddSystemMessage("Back Bar")
        for i = 3, 8 do
            FancyActionBar.AddSystemMessage(GetSlotInfoString(i, 1))
        end
    end
end

function FancyActionBar.PostOverlayEffects()
    for i = 3, 7 do
        local o1 = FancyActionBar.overlays[i]
        local o2 = FancyActionBar.overlays[i + 20]
        if o1.effect and o1.effect.id and o1.effect.id > 0 then
            FancyActionBar.AddSystemMessage("[" .. i .. "]: " .. o1.effect.id)
            for k, v in pairs(o1.effect) do
                FancyActionBar.AddSystemMessage(" - [" .. k .. "]: " .. tostring(v))
            end
        end
        if o2.effect and o2.effect.id and o2.effect.id > 0 then
            FancyActionBar.AddSystemMessage("[" .. i + 20 .. "]: " .. o2.effect.id)
            for k, v in pairs(o2.effect) do
                FancyActionBar.AddSystemMessage(" - [" .. k .. "]: " .. tostring(v))
            end
        end
    end
end

function FancyActionBar.IsDebugMode()
    return debug
end

---
--- @param mode boolean
function FancyActionBar.SetDebugMode(mode)
    assert(type(mode) == "boolean", "Debug mode must be boolean.")
    debug = mode
end

---
--- @return string
function FancyActionBar.GetName()
    return NAME
end

---
--- @return string
function FancyActionBar.GetVersion()
    return VERSION
end

---
--- @return number
function FancyActionBar.GetScale()
    return scale
end

---
--- @return table
function FancyActionBar.GetExternalBlacklist()
    return SV.externalBlackList
end

---
--- @return table
function FancyActionBar.GetMultiTargetBlacklist()
    return SV.multiTargetBlacklist
end

---
--- @return table
function FancyActionBar.GetParentTimeBlacklist()
    return SV.parentTimeBlacklist
end

---
--- @return table var
--- @return table def
function FancyActionBar:GetMovableVarsForUI()
    local var = FancyActionBar.constants.move
    local def = (IsInGamepadPreferredMode() or FancyActionBar.useGamepadActionBar) and defaultSettings.abMove.gp or defaultSettings.abMove.kb
    return var, def
end

---
--- @return number durationMin
--- @return number durationMax
function FancyActionBar.GetAbilityDurationLimits()
    return SV.durationMin, SV.durationMax
end

function FancyActionBar.UpdateDurationLimits()
    FancyActionBar.durationMin, FancyActionBar.durationMax = FancyActionBar.GetAbilityDurationLimits()
end

--- @class ActionBarConstants
--- @field abilitySlotWidth integer
--- @field actionBarOffset integer
--- @field anchor table|ZO_Anchor
--- @field anchorOffsetY integer
--- @field attributesOffset integer
--- @field bindingTextOnUlt boolean
--- @field buttonTemplate string
--- @field buttonTextOffsetY integer
--- @field dimensions integer
--- @field flipCardSize integer
--- @field overlayTemplate string
--- @field qsOverlayTemplate string
--- @field quickslotOffsetX integer
--- @field showKeybindBG boolean
--- @field ultButtonTemplate string
--- @field ultFlipCardSize integer
--- @field ultOverlayTemplate string
--- @field ultSize integer
--- @field ultimateSlotOffsetX integer
--- @field width integer

--- @class FancyActionBarConstants
--- @field abScale table
--- @field abilitySlot table
--- @field duration table
--- @field hideOnNoTargetGlobal {[integer]:boolean}
--- @field hideOnNoTargetList {[integer]:boolean}
--- @field move table
--- @field noTargetAlpha integer
--- @field noTargetFade any
--- @field qs table
--- @field stacks table
--- @field style ActionBarConstants
--- @field targets table
--- @field ult table
--- @field update table

--- Gets the appropriate action bar constants based on current UI mode
--- Updates the constants if needed and returns the style-specific constants
--- @return ActionBarConstants constants The keyboard or gamepad constants table
function FancyActionBar.GetConstants()
    -- Check if UI update is needed or constants haven't been initialized
    if FancyActionBar.updateUI or not (FancyActionBar.constants and FancyActionBar.constants.style) then
        -- Determine style: 2 for gamepad, 1 for keyboard
        FancyActionBar.style = FancyActionBar.useGamepadActionBar and 2 or 1

        -- Select appropriate constants based on style
        --- @type ActionBarConstants
        local selectedConstants = FancyActionBar.style == 1 and KEYBOARD_CONSTANTS or GAMEPAD_CONSTANTS

        -- Update the style constants
        FancyActionBar.constants.style = selectedConstants
    end

    return FancyActionBar.constants.style
end

---
--- @return table
function FancyActionBar.GetAbilityConfig()
    return FancyActionBar.abilityConfig
end

---
--- @return table
function FancyActionBar.GetAbilityConfigChanges()
    if CV.useAccountWide
    then
        return SV.configChanges
    else
        return CV.configChanges
    end
end

function FancyActionBar.GetHideOnNoTargetGlobalSetting()
    if CV.useAccountWide
    then
        return SV.hideOnNoTargetGlobal
    else
        return CV.hideOnNoTargetGlobal
    end
end

function FancyActionBar.GetHideOnNoTargetList()
    if CV.useAccountWide
    then
        return SV.hideOnNoTargetList
    else
        return CV.hideOnNoTargetList
    end
end

function FancyActionBar.GetNoTargetFade()
    if CV.useAccountWide
    then
        return SV.noTargetFade
    else
        return CV.noTargetFade
    end
end

function FancyActionBar.SetNoTargetFade(fade)
    if CV.useAccountWide
    then
        SV.noTargetFade = fade
    else
        CV.noTargetFade = fade
    end
    FancyActionBar.constants.noTargetFade = fade
end

function FancyActionBar.GetNoTargetAlpha()
    if CV.useAccountWide
    then
        return SV.noTargetAlpha / 100
    else
        return CV.noTargetAlpha / 100
    end
end

function FancyActionBar.SetNoTargetAlpha(alpha)
    if CV.useAccountWide
    then
        SV.noTargetAlpha = alpha
    else
        CV.noTargetAlpha = alpha
    end
    FancyActionBar.constants.noTargetAlpha = alpha / 100
end

function FancyActionBar.UpdateHideOnNoTargetForSkill(id, hide)
    local cfg = abilityConfig[id]
    local effectId = 0

    if cfg ~= nil then
        if type(cfg) == "table" then
            cfg[5] = hide
            effectId = cfg[1]
        end

        if effectId > 0 then
            local effect = FancyActionBar.effects[effectId]
            if effect then
                effect.hideOnNoTarget = hide
                FancyActionBar.UpdateEffect(effect)
            end
        end
    end
end

function FancyActionBar.OnlyUpdateEffectForUsedSkill(id)

end

function FancyActionBar.SlotCurrentAbilityConfiguration(id)
    -- local cfg = abilityConfig[id];
    -- local isToggled, noTarget = false, false;

    -- if FancyActionBar.toggled[id] then
    --   FancyActionBar.toggles[id] = false;
    --   isToggled = true;
    -- end;

    -- -- if FancyActionBar.constants.hideOnNoTargetList[id] then
    -- --   noTarget = FancyActionBar.constants.hideOnNoTargetList[id]
    -- -- else
    -- --   noTarget = FancyActionBar.GetHideOnNoTargetGlobalSetting()
    -- -- end

    -- local cI, rI = id, false;

    -- if FancyActionBar.removeInstantly[id] then rI = true; end;

    -- if type(cfg) == "table" then
    --   abilityConfig[id] = { cfg[1], cfg[2], isToggled, rI };
    -- elseif cfg then
    --   abilityConfig[id] = { id, nil, isToggled, rI };
    -- elseif cfg == false then
    --   abilityConfig[id] = false;
    -- else
    --   abilityConfig[id] = { id };
    -- end;

    local currentSlots = {}

    for i = MIN_INDEX, ULT_INDEX do
        local I0 = FancyActionBar.GetSlotBoundAbilityId(i, HOTBAR_CATEGORY_PRIMARY)
        local I1 = FancyActionBar.GetSlotBoundAbilityId(i, HOTBAR_CATEGORY_BACKUP)
        if I0 == id then
            currentSlots[i] = true
        end
        if I1 == id then
            currentSlots[i + SLOT_INDEX_OFFSET] = true
        end
    end

    for slot in pairs(currentSlots) do
        if slot then
            FancyActionBar.UnslotEffect(slot)
        end
        if slot then
            FancyActionBar.SlotEffect(slot, id, nil, nil, true)
        end
    end
end

function FancyActionBar.GetActionButton(index) -- get actionbutton by index.
    if index > SLOT_INDEX_OFFSET
    then
        return FancyActionBar.buttons[index]
    else
        return ZO_ActionBar_GetButton(index)
    end
end

function FancyActionBar.SetActionButtonAbilityFxOverride(index)
    local btn = FancyActionBar.GetActionButton(index)
    if not btn then
        return
    end
    local id = FancyActionBar.GetSlotBoundAbilityId(index)
    if id > 0 then
        local icon = SV.applyActionBarSkillStyles and FancyActionBar.GetSkillStyleIconForAbilityId(id) or GetAbilityIcon(id)
        if icon then
            btn.icon:SetTexture(icon)
        end
    end
end

function FancyActionBar.ApplyAbilityFxOverrides(userPreferenceChanged)
    if not userPreferenceChanged and not SV.applyActionBarSkillStyles then
        return
    end
    local currentHotbarCategory = GetActiveHotbarCategory()
    local inactiveBar = currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY and HOTBAR_CATEGORY_BACKUP or HOTBAR_CATEGORY_PRIMARY
    for i = MIN_INDEX, MAX_INDEX do
        FancyActionBar.SetActionButtonAbilityFxOverride(i)
        FancyActionBar.UpdateInactiveBarIcon(i, inactiveBar)
    end
    FancyActionBar.SetActionButtonAbilityFxOverride(ULT_INDEX)
end

function FancyActionBar.GetOverlay(index)
    if (index == ULT_INDEX) or (index == ULT_INDEX + SLOT_INDEX_OFFSET)
    then
        return FancyActionBar.ultOverlays[index]
    else
        return FancyActionBar.overlays[index]
    end
end

--- Retrieves or creates an effect based on the given parameters.
--- @param id integer The unique identifier for the effect.
--- @param sourceAbility table The table of ids that can create the given effect
--- @param stackId table The table of ids that can contribute stacks to the effect stack coutner
--- @param config boolean Optional flag to determine if a new effect should be created if it doesn't exist.
--- @param custom any Custom data associated with the effect.
--- @param toggled boolean Indicates if the effect is toggled on or off.
--- @param tickRate number The rate at which the effect ticks in seconds.
--- @param ignore boolean Flag to ignore certain conditions.
--- @param passive boolean Flag to indicate if the effect is passive.
--- @param instantFade boolean Flag to indicate if the effect should fade instantly.
--- @param dontFade boolean Flag to prevent fading of the effect.
--- @param isChanneled boolean Flag to indicate if the effect is channeled.
--- @param effectChanged boolean Flag to indicate if the effect is changed.
--- @return effect table @The effect associated with the given id.
function FancyActionBar.GetEffect(id, sourceAbility, stackId, config, custom, toggled, tickRate, ignore, passive, instantFade, dontFade, isChanneled, effectChanged)
    --- @alias effect table
    local effect = FancyActionBar.effects[id] or {}

    if effectChanged or not FancyActionBar.effects[id] then
        effect.id = id
        effect.endTime = 0
        effect.custom = custom
        effect.toggled = toggled
        effect.tickRate = tickRate
        effect.ignore = ignore
        effect.passive = passive
        effect.isDebuff = false
        effect.activeOnTarget = false
        effect.instantFade = instantFade
        effect.dontFade = dontFade
        effect.faded = true
        effect.isChanneled = isChanneled
    end

    -- Portions of the effect table that should always be updated
    local sourceAbilites = effect.sourceAbilites or {}
    for k, v in pairs(sourceAbility) do
        sourceAbilites[k] = v
    end
    effect.sourceAbilites = sourceAbilites or {}

    effect.stackId = stackId
    if effectChanged or not FancyActionBar.effects[id] and config then
        FancyActionBar.effects[id] = effect
    end

    return effect -- Always returns an effect
end

function FancyActionBar.GetSlottedEffect(index)
    return slottedIds[index].effect, slottedIds[index].ability
end

function FancyActionBar.SetSlottedEffect(index, abilityId, effectId)
    if not slottedIds[index] then
        slottedIds[index] = { ability = 0, effect = 0 }
    end
    slottedIds[index].ability = abilityId or 0
    slottedIds[index].effect = effectId or 0
end

function FancyActionBar.IsSameEffect(index, abilityId)
    -- local ts      = tostring
    local overlay = FancyActionBar.overlays[index]
    if overlay.effect then
        local e, a = FancyActionBar.GetSlottedEffect(index)
        if overlay.effect.id == e and abilityId == a then
            -- local o = e or 0
            -- FancyActionBar.AddSystemMessage('overlay '..ts(index)..' effect '..ts(abilityId)..' already slotted ('..ts(o)..')')
            return true
        end
    end
    -- FancyActionBar.AddSystemMessage('overlay '..ts(index)..' new effect: '..ts(abilityId))
    return false
end

function FancyActionBar.HandleCompanionUltimate()
    -- Get companion ultimate button and early validation
    local companionButton = ZO_ActionBar_GetButton(ULT_INDEX, HOTBAR_CATEGORY_COMPANION)
    if not companionButton then return end

    local function updateVisuals(shouldShow, currentPower)
        if not CompanionUltimateButton then return end

        -- Update visibility state
        CompanionUltimateButton:SetHidden(not shouldShow)

        -- Update button text if it exists
        if companionButton.buttonText then
            local shouldHideText = not shouldShow or FancyActionBar.style == 2 or not SV.showHotkeys
            companionButton.buttonText:SetHidden(shouldHideText)
        end

        -- Update icon if showing
        if shouldShow then
            local ultimateId = GetSlotBoundId(ULT_INDEX, HOTBAR_CATEGORY_COMPANION)
            if ultimateId then
                local iconControl = CompanionUltimateButton:GetNamedChild("Icon")
                if iconControl then
                    iconControl:SetTexture(GetAbilityIcon(ultimateId))
                end
            end

            -- Update power display
            FancyActionBar.UpdateUltimateValueLabels(false, currentPower)
        end
    end

    -- Check if companion ultimate should be displayed
    local shouldShowUltimate = not SV.hideCompanionUlt
        and HasActiveCompanion()
        and DoesUnitExist("companion")
        and companionButton.hasAction

    -- Get current power and cost if should show
    local currentPower, cost = 0, 0
    if shouldShowUltimate then
        currentPower = GetUnitPower("companion", COMBAT_MECHANIC_FLAGS_ULTIMATE)
        cost = GetSlotAbilityCost(ULT_INDEX, COMBAT_MECHANIC_FLAGS_ULTIMATE, HOTBAR_CATEGORY_COMPANION)
        shouldShowUltimate = cost and cost > 0
    end

    -- Update base button state
    companionButton:SetupBounceAnimation()
    companionButton:SetupKeySlideAnimation()
    companionButton:SetupTimerSwapAnimation()
    companionButton:UpdateUltimateMeter()

    -- Update visuals with final state
    updateVisuals(shouldShowUltimate, currentPower)
end

function FancyActionBar.OnWeaponSwapLocked(isLocked, wasLocked, userPreferenceChanged, userPreferenceState)
    if (not SV.hideLockedBar) and (not userPreferenceChanged) then
        return
    end
    if isLocked == wasLocked then
        return
    end
    -- if (not isLocked) and (not wasLocked) then return; end;
    local doLock
    if userPreferenceChanged then
        doLock = userPreferenceState and isLocked or false
    else
        doLock = isLocked
    end
    local currentHotbarCategory = GetActiveHotbarCategory()
    isWeaponSwapLocked = doLock
    local hideBar = currentHotbarCategory == HOTBAR_CATEGORY_BACKUP and HOTBAR_CATEGORY_PRIMARY or HOTBAR_CATEGORY_BACKUP
    FancyActionBar.ToggleInactiveBar(hideBar, doLock)
    FancyActionBar.AdjustQuickSlotSpacing(doLock)
    FAB_ActionBarArrow:SetHidden(not SV.showArrow or doLock)
    FancyActionBar.ApplyAlphaInactive(isWeaponSwapLocked and 0 or SV.alphaInactive or defaultSettings.alphaInactive)
end

-- ZO_ActionButtons_ToggleShowGlobalCooldown()
function FancyActionBar.OnPlayerActivated() -- status update after travel.
    FancyActionBar.SetMarker()
    FancyActionBar.ToggleUltimateValue()
    FancyActionBar.SetUltFrameAlpha()
    FancyActionBar:UpdateDebuffTracking()

    FancyActionBar.HandleCompanionUltimate()

    local zone = GetZoneId(GetUnitZoneIndex("player"))
    if FancyActionBar.zone ~= zone then
        FancyActionBar.zone = zone
        FancyActionBar.RefreshEffects()
    end
    FancyActionBar.EffectCheck()
    FancyActionBar.weaponFront = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_MAIN_HAND, LINK_STYLE_DEFAULT))
    FancyActionBar.weaponBack = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN, LINK_STYLE_DEFAULT))
    FancyActionBar.oakensoulEquipped = (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING1) == FancyActionBar.oakensoul) or (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING2) == FancyActionBar.oakensoul)
    if SV.hideLockedBar then
        local locked = (FancyActionBar.oakensoulEquipped or FancyActionBar.isWerewolf) and true or false
        FancyActionBar.OnWeaponSwapLocked(locked, nil, true, SV.hideLockedBar)
    end
end

-------------------------------------------------------------------------------
-----------------------------[ 		UI Updates    ]------------------------------
-------------------------------------------------------------------------------

function FancyActionBar.CheckForActiveEffect(id) -- update timer on load / reload.
    local hasEffect = false
    local duration = 0
    local begin = 0
    local currentStacks = 0
    local GetNumBuffs = GetNumBuffs
    local GetUnitBuffInfo = GetUnitBuffInfo
    local stackableBuff = FancyActionBar.stackableBuff
    local fixedStacks = FancyActionBar.fixedStacks
    local specialEffects = FancyActionBar.specialEffects

    for i = 1, GetNumBuffs("player") do
        local name, beginTime, endTime, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", i)
        if stackableBuff[id] and not fixedStacks[id] then
            if stackableBuff[abilityId] and stackableBuff[abilityId] == id then
                currentStacks = currentStacks + 1
                if abilityId == id then
                    hasEffect = true
                    duration = endTime - time()
                    begin = beginTime
                end
            end
        elseif FancyActionBar.bannerBearer[abilityId] then
            for k, v in pairs(FancyActionBar.bannerBearer) do
                if sourceAbilities[k] == id then
                    hasEffect = true
                    begin = beginTime
                end
            end
        elseif abilityId == id then
            currentStacks = fixedStacks[id] or (specialEffects[abilityId] and specialEffects[abilityId].stacks) or stackCount or 0
            hasEffect = true
            duration = endTime - time()
            begin = beginTime
        end
    end

    return hasEffect, duration, currentStacks, begin
end

function FancyActionBar.CheckTargetEndtimes(id) -- check end times for multiTarget abilities.
    if FancyActionBar.targets[id] then
        local currentTime = time()
        local targetData = FancyActionBar.targets[id]
        if targetData.maxEndTime <= currentTime then
            FancyActionBar.targets[id].targetCount = 0
            FancyActionBar.targets[id].maxEndTime = 0
            FancyActionBar.targets[id].times = {}
            return 0
        else
            local activeTargets = 0
            for unitId, times in pairs(targetData.times) do
                if times.endTime and (times.endTime < currentTime) then
                    FancyActionBar.targets[id].times[unitId] = nil
                else
                    activeTargets = activeTargets + 1
                end
            end
            FancyActionBar.targets[id].targetCount = activeTargets
            return activeTargets
        end
    end
    return 0
end

function FancyActionBar.UpdateInactiveBarIcon(slotNum, hotbarCategory) -- for bar swapping.
    if slotNum < MIN_INDEX or slotNum > MAX_INDEX then return end
    local id = FancyActionBar.GetSlotBoundAbilityId(slotNum, hotbarCategory)
    local btn = FancyActionBar.buttons[slotNum + SLOT_INDEX_OFFSET]
    local icon = ""
    local slotState = FancyActionBar.slotHidden[hotbarCategory == HOTBAR_CATEGORY_BACKUP and slotNum + SLOT_INDEX_OFFSET or slotNum]
    local shouldHideSlot = SV.hideInactiveSlots and slotState or SV.hideLockedBar and isWeaponSwapLocked
    if id > 0 --[[TODO: and bar == 0 or bar == 1]] then
        if FancyActionBar.barHighlightDestroFix[id] then
            local weaponType = hotbarCategory == HOTBAR_CATEGORY_BACKUP and FancyActionBar.weaponBack or FancyActionBar.weaponFront
            icon = SV.applyActionBarSkillStyles and FancyActionBar.GetSkillStyleIconForAbilityId(id) or
                GetAbilityIcon(FancyActionBar.GetCorrectedAbilityId(id, weaponType))
        else
            id = GetEffectiveAbilityIdForAbilityOnHotbar(id, hotbarCategory)
            if id == 31816 then
                local hyper = CheckHyperTools()
                icon = hyper ~= "" and GetHyperToolsIcon(hyper) or GetAbilityIcon(id)
            else
                icon = SV.applyActionBarSkillStyles and FancyActionBar.GetSkillStyleIconForAbilityId(id) or GetAbilityIcon(id)
            end
        end
        btn.icon:SetTexture(shouldHideSlot and "" or icon)
        btn.icon:SetAlpha(shouldHideSlot and 0 or SV.alphaInactive / 100)
        btn.icon:SetDesaturation(SV.desaturationInactive / 100)
        btn.icon:SetHidden(shouldHideSlot)
        btn.bg:SetHidden(shouldHideSlot)
        btn.slot:SetHidden(shouldHideSlot)
    else
        btn.icon:SetHidden(true)
        btn.bg:SetHidden(shouldHideSlot)
        btn.slot:SetHidden(shouldHideSlot)
    end
end

--------------
-- abilities
--------------
function FancyActionBar.ResetOverlayDuration(overlay)
    if overlay then
        local durationControl = overlay.timer
        local bgControl = overlay.bg
        local stacksControl = overlay.stack
        local targetsControl = overlay.target
        local resetStacksControl, resetTargetsControl = true, true

        if durationControl then
            durationControl:SetText("")
        end
        if bgControl then
            bgControl:SetHidden(true)
        end
        if overlay.effect then
            local effect = overlay.effect
            if overlay.allowStacks and effect.stackId then
                local stackId = effect.stackId
                for i = 1, #stackId do
                    local currentStackId = stackId[i]
                    local _, _, currentStacks = FancyActionBar.CheckForActiveEffect(currentStackId)
                    FancyActionBar.stacks[currentStackId] = currentStacks
                    resetStacksControl = not (currentStacks > 0)
                    if FancyActionBar.stackableBuff[currentStackId] then break end
                end
                FancyActionBar.HandleStackUpdate(effect.id)
            end
            if FancyActionBar.targets[effect.id] then
                local activeTargets = FancyActionBar.CheckTargetEndtimes(effect.id)
                FancyActionBar.HandleTargetUpdate(effect.id, true)
                resetTargetsControl = not (activeTargets > 0)
            else

            end
        end
        if stacksControl and resetStacksControl then
            stacksControl:SetText("")
        end
        if targetsControl and resetTargetsControl then
            targetsControl:SetText("")
        end
    end
end

function FancyActionBar.FadeEffect(effect) -- reset effect variables and make sure overlay is cleared
    if effect == nil then
        return
    end

    effect.endTime = time()

    if effect.slot1 then
        FancyActionBar.ResetOverlayDuration(FancyActionBar.overlays[effect.slot1])
        effect.slot1 = nil
    end
    if effect.slot2 then
        FancyActionBar.ResetOverlayDuration(FancyActionBar.overlays[effect.slot2])
        effect.slot2 = nil
    end
    -- effect.faded = true

    -- FancyActionBar.AddSystemMessage('Effect <' .. GetAbilityName(effect.id) .. '> (' .. effect.id .. ') faded')
end

function FancyActionBar.UpdateTimerLabel(label, text, color)
    label:SetText(text)
    if color ~= nil then
        label:SetColor(unpack(color))
    end

    -- local a = 1
    -- if alpha ~= nil then a = alpha end
    --
    -- label:SetAlpha(a)
end

function FancyActionBar.GetHighlightColor(fading, isToggle, isToggled, isParentTime)
    local color = nil
    if isToggle then
        if isToggled and SV.toggledHighlight then
            color = SV.toggledColor
        end
    elseif fading or isParentTime then
        if SV.highlightExpire then
            color = SV.highlightExpireColor
        elseif SV.showHighlight then
            color = SV.highlightColor
        end
    elseif SV.showHighlight then
        color = SV.highlightColor
    end
    return color
end

local bgHidden = {}

function FancyActionBar.UpdateBackgroundVisuals(background, color, index, isToggled)
    if color ~= nil then
        background:SetHidden(false)
        background:SetColor(color[1], color[2], color[3], color[4])
    else
        background:SetHidden(true)
    end

    if index > 0 then
        if bgHidden[index] ~= nil then
            local wasHidden = bgHidden[index]
            if wasHidden ~= bgHidden[index] then
                local isHidden = bgHidden[index] and "hidden" or "showing"
                FancyActionBar.AddSystemMessage("[" .. index .. "] " .. isHidden)
            end
        end
        bgHidden[index] = bgHidden[index]
    else
        FancyActionBar.AddSystemMessage("Index 0 Error!")
    end
end

function FancyActionBar.ShouldShowExpire(duration)
    local u = FancyActionBar.constants.update
    if not u.showDecimal then
        return false
    end
    if (duration > u.showDecimalStart) then
        return false
    end
    return true
end

function FancyActionBar.ResolveLabelAlphaForDebuff(debuff)
    local alpha = 1
    if (debuff.activeOnTarget == false and debuff.hideOnNoTarget == false) then
        if (FancyActionBar.constants.noTargetFade == true) then
            alpha = FancyActionBar.constants.noTargetAlpha
        end
    end
    return alpha
end

function FancyActionBar.FormatTextForDurationOfActiveEffect(fading, toggle, effect, duration, currentTime)
    local timer, color = "", nil
    if duration <= 0 then
        if (SV.delayFade and not effect.instantFade or (effect.isDebuff and (effect.endTime > currentTime) and (SV.keepLastTarget == false))) then
            -- adding or (effect.isDebuff and SV.keepLastTarget == false) is to try to prevent a flicker of 0 on reticleover when a debuff isn't active
            local delayEnd = (effect.endTime + SV.fadeDelay) - currentTime
            if delayEnd > 0 then
                timer = tostring(zo_max(0, zo_ceil(assert(tonumber(duration)))))
            end
        end
    else
        if FancyActionBar.ShouldShowExpire(duration)
        then
            timer = strformat("%0.1f", duration)
        else
            timer = strformat("%0.0f", duration)
        end
    end

    if effect.toggled or toggle then
        local expire = fading or (not toggle)
        if SV.showTickExpire and expire then
            color = SV.tickColor
        else
            color = (expire and SV.showExpire) and SV.expireColor or SV.toggledColor
        end
    elseif (fading and SV.showExpire) then
        color = SV.expireColor
    else
        color = FancyActionBar.constants.duration.color
    end
    return timer, color
end

function FancyActionBar.UpdateOverlay(index) -- timer label updates.
    local overlay
    local hasDuration = false
    if (index == ULT_INDEX) or (index == ULT_INDEX + SLOT_INDEX_OFFSET) then
        FancyActionBar.UpdateUltOverlay(index)
        return
    end
    local currentHotbarCategory = GetActiveHotbarCategory()
    overlay = FancyActionBar.overlays[index]
    if overlay then
        local effect = overlay.effect
        local allowStacks = overlay.allowStacks
        local durationControl = overlay.timer
        local bgControl = overlay.bg
        local stacksControl = overlay.stack
        local targetsControl = overlay.target
        local sourceEndTime

        if effect and effect.id > 0 and not effect.ignore then
            local sourceId = effect.sourceAbilites and effect.sourceAbilites[index]
            if sourceId and sourceId ~= effect.id then
                local sourceEffect = FancyActionBar.effects[sourceId]
                if sourceEffect then
                    sourceEndTime = sourceEffect.endTime
                end
            end
            hasDuration = FancyActionBar.UpdateEffectDuration(effect, durationControl, bgControl, stacksControl, targetsControl, index,
                allowStacks, FancyActionBar.toggles[effect.id], sourceEndTime)
        else
            FancyActionBar.ClearOverlayControls(durationControl, bgControl, stacksControl, targetsControl)
        end
        if (index > SLOT_INDEX_OFFSET and currentHotbarCategory ~= HOTBAR_CATEGORY_BACKUP) or
            (index < SLOT_INDEX_OFFSET and currentHotbarCategory == HOTBAR_CATEGORY_BACKUP) then
            local shouldHideSlot = SV.hideLockedBar and isWeaponSwapLocked or SV.hideInactiveSlots and (not hasDuration)
            local doHideSlot = FancyActionBar.slotHidden[index] ~= shouldHideSlot
            FancyActionBar.slotHidden[index] = shouldHideSlot
            if doHideSlot then
                overlay:SetHidden(shouldHideSlot)
                FancyActionBar.UpdateInactiveBarIcon(index > SLOT_INDEX_OFFSET and index - SLOT_INDEX_OFFSET or index, index > SLOT_INDEX_OFFSET and HOTBAR_CATEGORY_BACKUP or HOTBAR_CATEGORY_PRIMARY)
            end
        end
    end
end

function FancyActionBar.UpdateEffectDuration(effect, durationControl, bgControl, stacksControl, targetsControl, index, allowStacks, isToggled, sourceEndTime)
    local currentTime = time()
    local fadeDelay = SV.showExpire and SV.fadeDelay or 0
    local hasDuration, duration = true, 0
    local isCastTime, isParentTime, isFading = false, false, false

    -- Handle cast/channel time overrides
    if SV.showCastDuration and (effect.castEndTime or effect.castDuration) then
        isCastTime = true
        local isBlockActive = IsBlockActive()
        local blockCancelled = (isBlockActive and not wasBlockActive) or (wasBlockActive and not isBlockActive and not isChanneling)
        wasBlockActive = isBlockActive

        if blockCancelled or not isChanneling then
            effect.castEndTime = blockCancelled and 0 or (effect.castEndTime and effect.castEndTime > currentTime and effect.castEndTime or 0)
            isChanneling = false
        end

        if effect.castEndTime and effect.castEndTime >= currentTime then
            duration = effect.castEndTime - currentTime
        elseif effect.endTime and effect.endTime + fadeDelay > currentTime then
            duration = effect.endTime - currentTime
        else
            effect.endTime = -1
            hasDuration = false
        end

        if channeledAbilityUsed and effect.castEndTime and effect.castEndTime >= currentTime then
            channeledAbilityUsed = nil
        end
    elseif effect.endTime and effect.endTime + fadeDelay > currentTime then
        if SV.showSoonestExpire and FancyActionBar.targets[effect.id] and FancyActionBar.targets[effect.id].targetCount > 0 and not (SV.advancedDebuff and effect.isDebuff) then
            local targetData = FancyActionBar.targets[effect.id] or {}
            local targetEndTime
            if targetData.times then
                for unitId, timeData in pairs(targetData.times) do
                    if not targetEndTime or (timeData.endTime > currentTime and timeData.endTime < targetEndTime) then
                        targetEndTime = timeData.endTime
                    end
                end
            end
            if targetEndTime and targetEndTime > currentTime then
                duration = targetEndTime - currentTime
            else
                duration = effect.endTime - currentTime
            end
        else
            duration = effect.endTime - currentTime
        end
    else
        effect.endTime = -1
        hasDuration = false
    end

    -- Check for parent effect duration fallback
    if SV.allowParentTime and not isCastTime and duration <= 0 and sourceEndTime and sourceEndTime > currentTime then
        duration = sourceEndTime - currentTime
        isParentTime = true
    end

    -- Handle toggled effects
    if effect.toggled then
        local tickRate = isToggled and SV.showToggleTicks and effect.tickRate or 0
        if tickRate ~= 0 then
            duration = effect.beginTime and (tickRate - ((currentTime - effect.beginTime) % tickRate)) or tickRate
            isFading = duration <= SV.showTickStart and SV.showTickExpire or false
        end
        hasDuration = isToggled or hasDuration
    else
        -- Determine fading state for non-toggles
        isFading = hasDuration and (duration <= SV.showExpireStart) and SV.showExpire or false
    end

    -- Format visuals and update controls
    local lt, lc = FancyActionBar.FormatTextForDurationOfActiveEffect(isFading, isToggled, effect, duration, currentTime)
    local bc = (hasDuration or isFading or isParentTime) and FancyActionBar.GetHighlightColor(isFading, effect.toggled, isToggled, isParentTime) or nil

    FancyActionBar.UpdateStacksControl(effect, stacksControl, allowStacks, currentTime)
    FancyActionBar.UpdateTargetsControl(effect, targetsControl, currentTime)
    FancyActionBar.UpdateTimerLabel(durationControl, lt, lc)
    FancyActionBar.UpdateBackgroundVisuals(bgControl, bc, index)

    return hasDuration or isToggled or isFading or isParentTime
end

function FancyActionBar.UpdateStacksControl(effect, stacksControl, allowStacks, currentTime)
    if effect.forceExpireStacks and (effect.endTime <= currentTime) then
        if effect.stackId then
            for _, stackId in ipairs(effect.stackId) do
                FancyActionBar.stacks[stackId] = 0
            end
        end
        stacksControl:SetText("")
        return
    end

    if not SV.showStackCount then
        stacksControl:SetText("")
        return
    end

    if FancyActionBar.stackableBuff[effect.id] then
        local stackableBuffId = FancyActionBar.stackableBuff[effect.id]
        local stackCount = FancyActionBar.stacks[stackableBuffId] or 0
        stacksControl:SetText(stackCount > 0 and stackCount or "")
        return
    end

    if allowStacks and effect.stackId then
        local stackCounts = {}
        for i, stackId in ipairs(effect.stackId) do
            stackCounts[i] = FancyActionBar.stacks[stackId]
        end
        local maxStacks = FancyActionBar.GetStackValue(stackCounts)
        stacksControl:SetText(maxStacks and maxStacks ~= 0 and maxStacks or "")
        return
    end

    stacksControl:SetText("")
end

function FancyActionBar.UpdateTargetsControl(effect, targetsControl, currentTime)
    if FancyActionBar.targets[effect.id] then
        local targetData = FancyActionBar.targets[effect.id]
        if targetData.maxEndTime <= currentTime or targetData.targetCount == 0 then
            FancyActionBar.targets[effect.id].targetCount = 0
            FancyActionBar.targets[effect.id].maxEndTime = 0
            FancyActionBar.targets[effect.id].times = {}
            targetsControl:SetText("")
        end
    else
        targetsControl:SetText("")
    end
end

function FancyActionBar.ClearOverlayControls(durationControl, bgControl, stacksControl, targetsControl)
    durationControl:SetText("")
    bgControl:SetHidden(true)
    stacksControl:SetText("")
    targetsControl:SetText("")
end

function FancyActionBar.UpdateStacks(index) -- stacks label.
    local overlay
    if (index == ULT_INDEX) or (index == (ULT_INDEX + SLOT_INDEX_OFFSET)) then
        overlay = FancyActionBar.ultOverlays[index]
    else
        overlay = FancyActionBar.overlays[index]
    end
    if overlay then
        local stacksControl = overlay.stack
        if overlay.effect and overlay.allowStacks then
            local effect = overlay.effect
            local stackId = effect.stackId
            local stacks, stackCount
            local stackCounts = {}
            local stackIndex = 1

            stackCount = FancyActionBar.stacks[effect.id]
            stackCounts[stackIndex] = stackCount
            stackIndex = stackIndex + 1

            if FancyActionBar.stackableBuff[effect.id] then
                stacks = FancyActionBar.stacks[FancyActionBar.stackableBuff[effect.id]]
            elseif effect.stackId and #effect.stackId > 0 then
                for i = 1, #stackId do
                    if FancyActionBar.stackableBuff[stackId[i]] then
                        stackCount = FancyActionBar.stacks[FancyActionBar.stackableBuff[stackId[i]]]
                        break
                    else
                        stackCount = FancyActionBar.stacks[stackId[i]]
                    end
                    stackCounts[stackIndex] = stackCount
                    stackIndex = stackIndex + 1
                end
                stacks = FancyActionBar.GetStackValue(stackCounts)
            end
            if SV.showStackCount and stacks and stacks ~= 0 then
                stacksControl:SetText(stacks)
                stacksControl:SetColor(unpack(FancyActionBar.constants.stacks.color))
            else
                stacksControl:SetText("")
            end
        end
    end
end

function FancyActionBar.UpdateTargets(index) -- targets label.
    local overlay
    if (index == ULT_INDEX) or (index == (ULT_INDEX + SLOT_INDEX_OFFSET)) then
        overlay = FancyActionBar.ultOverlays[index]
    else
        overlay = FancyActionBar.overlays[index]
    end
    if overlay then
        local effect = overlay.effect
        local targetsControl = overlay.target
        if effect and effect.id and FancyActionBar.targets[effect.id] then
            local target = FancyActionBar.targets[effect.id]
            if ((SV.showSingleTargetInstance or effect.isDebuff) and target.targetCount > 0) or (not SV.showSingleTargetInstance and target.targetCount > 1) then
                targetsControl:SetText(target.targetCount)
                targetsControl:SetColor(unpack(FancyActionBar.constants.targets.color))
                return
            end
        end
        targetsControl:SetText("")
    end
end

function FancyActionBar.UpdateUltOverlay(index) -- update ultimate labels.
    local overlay = FancyActionBar.ultOverlays[index]
    if not overlay then return end              -- Added check for nil overlay

    local effect = overlay.effect or { id = 0, endTime = -1 }
    local allowStacks = overlay.allowStacks
    local durationControl = overlay.timer
    local stacksControl = overlay.stack
    local targetsControl = overlay.target
    local timerColor = FancyActionBar.constants.ult.duration.color

    if not FancyActionBar.constants.ult.duration.show then
        durationControl:SetText("")
        -- Clear stack/target controls as well if duration is hidden
        if stacksControl then stacksControl:SetText("") end
        if targetsControl then targetsControl:SetText("") end
        return
    end

    local currentTime = time()
    local duration, ultEndTime, instantFade
    local isCastTime = false -- Flag to know if we are using cast time

    -- Check if channeling logic should apply BEFORE standard duration calculation
    if SV.showCastDuration and (effect.castEndTime or effect.castDuration) then
        local isBlockActive = IsBlockActive()
        local blockCancelled = (isBlockActive and not wasBlockActive) or (wasBlockActive and not isBlockActive and not isChanneling)
        wasBlockActive = isBlockActive

        if blockCancelled or not isChanneling then
            effect.castEndTime = blockCancelled and 0 or (effect.castEndTime and effect.castEndTime > currentTime and effect.castEndTime or 0)
            if blockCancelled then isChanneling = false end
        end

        if effect.castEndTime and effect.castEndTime >= currentTime then
            -- Currently channeling: Calculate duration based on cast time
            duration = effect.castEndTime - currentTime
            isCastTime = true -- Set flag
        end

        -- Reset channeledAbilityUsed if this effect was the one being tracked and cast has ended
        if channeledAbilityUsed == effect.id and (not effect.castEndTime or effect.castEndTime < currentTime) then
            channeledAbilityUsed = nil
            isChanneling = false
        end
    end
    if not isCastTime then
        local fadeDelay = (SV.delayFade and SV.fadeDelay or 0) -- Calculate fadeDelay only if needed

        if index ~= ULT_INDEX + COMPANION_INDEX_OFFSET then
            -- Update activeUlt table if new effect is longer
            -- Ensure effect exists and has an endTime before comparing
            if effect.endTime and (not effect.toggled) and (not effect.passive) and (activeUlt.endTime < effect.endTime) then
                activeUlt.id = effect.id
                activeUlt.endTime = effect.endTime
                activeUlt.instantFade = effect.instantFade
            end

            if effect.id == activeUlt.id then
                ultEndTime = effect.endTime
                instantFade = effect.instantFade
            elseif effect.endTime and (not effect.toggled) and (not effect.passive) and (effect.endTime > currentTime - (fadeDelay and not (effect.instantFade) and fadeDelay or 0)) then
                ultEndTime = effect.endTime
                instantFade = effect.instantFade
            else
                ultEndTime = activeUlt.endTime
                instantFade = activeUlt.instantFade
            end
        else
            ultEndTime = effect.endTime
            instantFade = effect.instantFade
        end

        if ultEndTime then
            duration = ultEndTime - currentTime
        else
            duration = -999
        end
    end

    -- Use a slightly larger negative threshold to account for fade delay correctly
    local displayThreshold = -((SV.delayFade and not instantFade and not isCastTime) and SV.fadeDelay or 0.1)

    if duration > displayThreshold then
        local displayDuration = zo_max(0, duration) -- Ensure displayed value isn't negative

        if displayDuration > 0 then
            -- Format positive duration (either channeled or standard)
            if (FancyActionBar.constants.update.showDecimal and (displayDuration <= FancyActionBar.constants.update.showDecimalStart)) then
                durationControl:SetText(strformat("%0.1f", displayDuration))
            else
                durationControl:SetText(zo_ceil(displayDuration)) -- Use zo_ceil for consistency with original non-decimal display
            end

            -- Apply color based on expiration or channel state
            -- (Note: isCastTime could be used here for a specific channel color if desired)
            if (displayDuration <= SV.showExpireStart) and SV.showExpire then
                durationControl:SetColor(unpack(SV.expireColor))
                -- elseif isCastTime and SV.channelColor then -- Optional channel color?
                --     durationControl:SetColor(unpack(SV.channelColor))
            else
                durationControl:SetColor(unpack(timerColor))
            end
        else
            -- Handle fade delay display (only applies if NOT channeling)
            if not isCastTime and SV.delayFade and not instantFade then
                local delayEnd = (ultEndTime + SV.fadeDelay) - currentTime
                if delayEnd > 0 then
                    -- Still in fade delay, show 0 (or ceiling of negative duration)
                    durationControl:SetText(zo_ceil(displayDuration)) -- Shows '0'
                    -- Could set a specific fade color here if needed
                    if SV.showExpire then durationControl:SetColor(unpack(SV.expireColor)) else durationControl:SetColor(unpack(timerColor)) end
                else
                    -- Fade delay ended
                    durationControl:SetText("")
                end
            else
                -- No fade delay or instant fade, clear text immediately
                durationControl:SetText("")
            end
        end
    else
        -- Duration is too old (below display threshold)
        durationControl:SetText("")
        -- Reset activeUlt if its time is being used and it expired
        if not isCastTime and ultEndTime == activeUlt.endTime and activeUlt.endTime and activeUlt.endTime <= currentTime then
            activeUlt.id = 0
            activeUlt.endTime = -1
        end
    end

    FancyActionBar.UpdateStacksControl(effect, stacksControl, allowStacks, currentTime)
    FancyActionBar.UpdateTargetsControl(effect, targetsControl, currentTime)

    if index == ULT_INDEX + COMPANION_INDEX_OFFSET then
        overlay:SetHidden(SV.hideCompanionUlt)
    end

    if SV.applyActionBarSkillStyles then
        FancyActionBar.SetActionButtonAbilityFxOverride(index)
    end
end

function FancyActionBar.IsValidStackId(effectStackIds, abilityStackIds)
    local found = false
    for _, aStackId in ipairs(abilityStackIds) do
        for _, eStackId in ipairs(effectStackIds) do
            if aStackId == eStackId then
                found = true
                break
            end
        end
        if found then
            break
        end
    end
    return found
end

function FancyActionBar.HasDebuffStacks(effectId)
    local hasStacks = false
    local debuffStackMap = FancyActionBar.debuffStackMap
    for stackId, abilityIds in pairs(debuffStackMap) do
        if abilityIds and #abilityIds > 0 then
            for i = 1, #abilityIds do
                if abilityIds[i] == effectId then
                    hasStacks = true
                    break
                end
            end
        end
    end
    return hasStacks
end

function FancyActionBar.HandleStackUpdate(id) -- find overlays for a specific effect and update stacks.
    local effect = FancyActionBar.effects[id]
    if effect then
        if effect.slot1 then
            FancyActionBar.UpdateStacks(effect.slot1)
        end
        if effect.slot2 then
            FancyActionBar.UpdateStacks(effect.slot2)
        end
        if id == 122658 then -- Seething Fury
            if FancyActionBar.effects[id] and FancyActionBar.stacks[id] == 0 then
                FancyActionBar.effects[122658].endTime = time()
            end
        end
    end
end

function FancyActionBar.HandleTargetUpdate(targetId, singleEffect) -- find overlays for a specific effect and update stacks.
    if SV.showTargetCount == false then
        return
    end
    if singleEffect then
        local effect = FancyActionBar.effects[targetId]
        if effect then
            if effect.slot1 then
                FancyActionBar.UpdateTargets(effect.slot1)
            end
            if effect.slot2 then
                FancyActionBar.UpdateTargets(effect.slot2)
            end
        end
    else
        for id, effect in pairs(FancyActionBar.effects) do
            if targetId == effect.id then
                if effect.slot1 then
                    FancyActionBar.UpdateTargets(effect.slot1)
                end
                if effect.slot2 then
                    FancyActionBar.UpdateTargets(effect.slot2)
                end
            end
        end
    end
end

function FancyActionBar.UpdateToggledAbility(id, active) -- toggled effect highligh update.
    local effect = FancyActionBar.effects[id]
    if effect then
        if not FancyActionBar.toggles[effect.id] then
            FancyActionBar.toggles[effect.id] = false
        end

        FancyActionBar.toggles[effect.id] = active

        if effect.slot1 then
            FancyActionBar.UpdateHighlight(effect.slot1)
        end
        if effect.slot2 then
            FancyActionBar.UpdateHighlight(effect.slot2)
        end
    end
end

function FancyActionBar.UpdatePassiveEffect(id, active) -- passive effect highligh update.
    for i, overlay in pairs(FancyActionBar.overlays) do
        local effect = overlay.effect
        if effect then
            if effect.id == id then
                effect.passive = active
                FancyActionBar.UpdateHighlight(i)
            end
        end
    end
end

function FancyActionBar.UnslotEffect(index) -- Remove effect from overlay index.
    local overlay

    if (index == ULT_INDEX) or (index == (ULT_INDEX + SLOT_INDEX_OFFSET)) then
        overlay = FancyActionBar.ultOverlays[index]
        if index == ULT_INDEX then
            cost1 = 0
        elseif index == (ULT_INDEX + SLOT_INDEX_OFFSET)
        then
            cost2 = 0
        end
    else
        overlay = FancyActionBar.overlays[index]
    end

    if overlay then
        local e, a = FancyActionBar.GetSlottedEffect(index)
        sourceAbilities[a] = nil
        overlay.effect = nil
        FancyActionBar.ResetOverlayDuration(overlay)
    end
end

function FancyActionBar.SlotEffect(index, abilityId, overrideRank, casterUnitTag, effectChanged) -- assign effect and instructions to overlay index.
    if (not abilityId or abilityId == 0) then
        FancyActionBar.UnslotEffect(index)
        return
    end
    local isChanneled, castDuration = GetAbilityCastInfo(abilityId, overrideRank, casterUnitTag)
    -- if (isChanneled and not FancyActionBar.allowedChanneled[abilityId]) then
    --   FancyActionBar.UnslotEffect(index);
    --   return;
    -- end;

    local overlay = FancyActionBar.GetOverlay(index)
    if not overlay then
        return
    end

    local effectId, stackId, duration, custom, toggled, tickRate, passive, instantFade, dontFade
    local sourceAbility = {}

    local cfg = abilityConfig[abilityId]
    local ignore = false
    if cfg == false and stackId == nil then
        ignore = true
    end

    if cfg ~= nil or FancyActionBar.specialEffects[abilityId] then
        if ignore then
            effectId = abilityId
            custom = true
            toggled = false
            tickRate = 0
            passive = false
            instantFade = FancyActionBar.removeInstantly[effectId] or false
            sourceAbility[index] = abilityId
            sourceAbilities[abilityId] = effectId
        else
            if abilityId == 81420 then -- guard slot id while active for all morphs
                if guardId > 0 then
                    effectId = guardId
                end
            else
                local craftedId = GetAbilityCraftedAbilityId(abilityId)
                if craftedId ~= 0 then
                    local scripts = { GetCraftedAbilityActiveScriptIds(craftedId) }
                    local scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
                    effectId = (cfg and ((cfg[2] and cfg[2][scriptKey] and cfg[2][scriptKey][1]) or cfg[1])) or (FancyActionBar.specialEffects[abilityId] and FancyActionBar.specialEffects[abilityId].id) or abilityId
                else
                    effectId = (cfg and cfg[1]) or (FancyActionBar.specialEffects[abilityId] and FancyActionBar.specialEffects[abilityId].id) or abilityId
                end
                if FancyActionBar.guard.ids[abilityId] then
                    guardId = abilityId
                end
            end
            custom = true
            toggled = cfg and cfg[3] or FancyActionBar.toggled[effectId] or FancyActionBar.toggled[abilityId] or false
            tickRate = ((FancyActionBar.toggleTickRate[effectId] or FancyActionBar.toggleTickRate[abilityId] or GetAbilityFrequencyMS(effectId, "player") or 0) / 1000)
            passive = FancyActionBar.passive[effectId] or FancyActionBar.passive[abilityId] or false
            instantFade = cfg and cfg[4] or FancyActionBar.removeInstantly[effectId] or false
            dontFade = ((not instantFade == true) and FancyActionBar.dontFade[effectId]) or false
            sourceAbility[index] = abilityId
            sourceAbilities[abilityId] = effectId
        end
    else
        effectId = abilityId
        custom = false
        toggled = FancyActionBar.toggled[effectId] or false
        tickRate = ((FancyActionBar.toggleTickRate[effectId] or GetAbilityFrequencyMS(effectId, "player") or 0) / 1000)
        passive = FancyActionBar.passive[effectId] or FancyActionBar.passive[abilityId] or false
        instantFade = FancyActionBar.removeInstantly[effectId] or false
        dontFade = ((not instantFade == true) and FancyActionBar.dontFade[effectId]) or false
        sourceAbility[index] = abilityId
        sourceAbilities[abilityId] = effectId
    end

    FancyActionBar.SetSlottedEffect(index, abilityId, effectId)

    if (toggled == false and ignore == false)
    then
        duration = (GetAbilityDuration(effectId) or 0) / 1000
    else
        duration = 0
    end

    local effectStackId = {}
    local abilityStackId = {}
    if FancyActionBar.stackIds[effectId] then
        effectStackId = FancyActionBar.stackIds[effectId]
    else
        effectStackId = FancyActionBar.GetStackIdForAbilityId(effectId)
        if (effectId == abilityId) and #effectStackId == 0 then
            effectStackId = { effectId }
        end
        FancyActionBar.stackIds[effectId] = #effectStackId > 0 and effectStackId or nil
    end

    -- If the slotted effect doesn't have stacks to track then check if the parent ability does
    if effectId ~= abilityId then
        if FancyActionBar.stackIds[abilityId] then
            abilityStackId = FancyActionBar.stackIds[abilityId]
        else
            abilityStackId = FancyActionBar.GetStackIdForAbilityId(abilityId)
            FancyActionBar.stackIds[abilityId] = #abilityStackId > 0 and abilityStackId or nil
        end
    else
        abilityStackId = effectStackId
    end

    stackId = #effectStackId > 0 and effectStackId or #abilityStackId > 0 and abilityStackId or {}

    local effect = FancyActionBar.GetEffect(effectId, sourceAbility, stackId, true, custom, toggled, tickRate, ignore, passive, instantFade, dontFade, isChanneled, effectChanged) -- FancyActionBar.effects[effectId]


    if not ignore then
        effect.duration = duration and duration > 0 and duration or nil
    end

    if (effect.id > 0 and FancyActionBar.activeCasts[effect.id] == nil) then
        FancyActionBar.activeCasts[effect.id] = { slot = index, cast = 0, begin = 0, fade = 0 }
    end

    if not SV.advancedDebuff and effect.isDebuff then
        effect.isDebuff = false
    end

    if not effect.isDebuff then
        local has, dur, stacks = FancyActionBar.CheckForActiveEffect(effect.id)

        if has then
            effect.endTime = time() + dur
        end

        if effect.stackId and #effect.stackId > 0 then
            local _, stackCount
            for i = 1, #effect.stackId do
                _, _, stackCount = FancyActionBar.CheckForActiveEffect(effect.stackId[i])
                FancyActionBar.stacks[effect.stackId[i]] = stackCount
            end
        else
            FancyActionBar.stacks[effect.id] = stacks
        end
    end

    local isFrontBar = index < SLOT_INDEX_OFFSET and true or false

    if (index == ULT_INDEX or index == (ULT_INDEX + SLOT_INDEX_OFFSET)) then
        if isFrontBar then
            effect.slot1 = index
            if abilityId == 113105 then
                cost1 = 70
            else
                cost1 = GetAbilityCost(abilityId, COMBAT_MECHANIC_FLAGS_ULTIMATE, overrideRank, casterUnitTag)
            end
        elseif index == (ULT_INDEX + SLOT_INDEX_OFFSET) then
            effect.slot2 = index
            if abilityId == 113105 then
                cost2 = 70
            else
                cost2 = GetAbilityCost(abilityId, COMBAT_MECHANIC_FLAGS_ULTIMATE, overrideRank, casterUnitTag)
            end
        end

        local ultOverlay = FancyActionBar.ultOverlays[index]
        if ultOverlay then
            ultOverlay.effect = effect
        end
        return effect
    end

    if isFrontBar then
        effect.slot1 = index
        if FancyActionBar.guard.ids[effect.id] then
            FancyActionBar.guard.slot1 = index
        end
    else
        effect.slot2 = index
        if FancyActionBar.guard.ids[effect.id] then
            FancyActionBar.guard.slot2 = index
        end
    end
    -- Assign effect to overlay.
    overlay["effect"] = effect
    overlay["allowStacks"] = effectId == abilityId or FancyActionBar.IsAbilityTaunt(effectId) or FancyActionBar.IsAbilityTaunt(abilityId) or FancyActionBar.IsValidStackId(stackId, abilityStackId) or FancyActionBar.HasDebuffStacks(effectId)


    if FancyActionBar.targets[effect.id] and (not SV.showTargetCount == false) then
        FancyActionBar.UpdateTargets(index)
    end

    if overlay.allowStacks then
        if FancyActionBar.stacks[effect.id] then
            FancyActionBar.UpdateOverlay(index)
            FancyActionBar.UpdateStacks(index)
        end
        if effect.stackId and #effect.stackId > 0 then
            for i = 1, #effect.stackId do
                if FancyActionBar.stacks[effect.stackId[i]] then
                    FancyActionBar.UpdateOverlay(index)
                    FancyActionBar.UpdateStacks(index)
                    break
                end
            end
        end
    end

    return effect
end

function FancyActionBar.SlotEffects() -- slot effects for primary and backup bars.
    local currentHotbarCategory = GetActiveHotbarCategory()
    if currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY or currentHotbarCategory == HOTBAR_CATEGORY_BACKUP then
        for i = MIN_INDEX, MAX_INDEX do
            FancyActionBar.SlotEffect(i, FancyActionBar.GetSlotBoundAbilityId(i, HOTBAR_CATEGORY_PRIMARY))
            FancyActionBar.SlotEffect(i + SLOT_INDEX_OFFSET, FancyActionBar.GetSlotBoundAbilityId(i, HOTBAR_CATEGORY_BACKUP))
        end
        FancyActionBar.SlotEffect(ULT_INDEX, FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, HOTBAR_CATEGORY_PRIMARY))
        FancyActionBar.SlotEffect(ULT_INDEX + SLOT_INDEX_OFFSET, FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, HOTBAR_CATEGORY_BACKUP))
    else
        -- slot effects for special bar.
        for i = MIN_INDEX, ULT_INDEX do
            FancyActionBar.SlotEffect(i, FancyActionBar.GetSlotBoundAbilityId(i, currentHotbarCategory))
        end
    end
    FancyActionBar.UpdateUltimateCost()
end

function FancyActionBar.UpdateEffect(effect) -- update overlays linked to the effect.
    if effect then
        if effect.slot1 then
            FancyActionBar.UpdateOverlay(effect.slot1)
        end
        if effect.slot2 then
            FancyActionBar.UpdateOverlay(effect.slot2)
        end
    end
end

function FancyActionBar.EffectCheck()
    FancyActionBar.toggles = {}
    local checkTime = time()
    for id, effect in pairs(FancyActionBar.effects) do
        local doStackUpdate = false
        if FancyActionBar.specialEffects[effect.id] and effect.endTime > 0 then
            zo_callLater(function ()
                FancyActionBar.ReCheckSpecialEffect(effect)
            end, (effect.endTime - checkTime) * 1000)
        else
            local hasEffect, duration, stacks, beginTime = FancyActionBar.CheckForActiveEffect(effect.id)
            doStackUpdate = doStackUpdate ~= false and doStackUpdate or stacks ~= 0 and true
            if hasEffect then
                effect.endTime = (duration ~= 0) and (checkTime + duration) or -1
                if FancyActionBar.bannerBearer[id] then
                    for k, v in pairs(FancyActionBar.bannerBearer) do
                        if sourceAbilities[k] then
                            FancyActionBar.toggles[sourceAbilities[k]] = hasEffect
                            FancyActionBar.effects[sourceAbilities[k]].beginTime = (beginTime ~= 0) and beginTime or checkTime
                        end
                    end
                elseif FancyActionBar.toggled[id] then -- update the highlight of toggled abilities.
                    local toggleAbility = sourceAbilities[id] and sourceAbilities[id] or id
                    FancyActionBar.toggles[toggleAbility] = hasEffect
                end
            end
            FancyActionBar.stacks[effect.id] = stacks
            if effect.stackId and #effect.stackId > 0 then
                for i = 1, #effect.stackId do
                    if effect.stackId[i] ~= effect.id then
                        local hasStackEffect, stackDuration, mappedStacks = FancyActionBar.CheckForActiveEffect(effect.stackId[i])
                        doStackUpdate = doStackUpdate ~= false and doStackUpdate or mappedStacks ~= 0 and true
                        FancyActionBar.stacks[effect.stackId[i]] = mappedStacks
                    end
                end
            end
            if doStackUpdate then
                FancyActionBar.HandleStackUpdate(effect.id)
            end
        end
    end
end

-- Special Effects can fail to have their values updated properly on Rezone/Death, this implements recheck handling for these scenarios
function FancyActionBar.ReCheckSpecialEffect(effect)
    local checkTime = time()
    local specialEffects = FancyActionBar.specialEffects
    local effects = FancyActionBar.effects
    local CheckForActiveEffect = FancyActionBar.CheckForActiveEffect
    local UpdateEffect = FancyActionBar.UpdateEffect
    local HandleStackUpdate = FancyActionBar.HandleStackUpdate

    if not specialEffects[effect.id] then
        return
    end

    local specialEffect = ZO_DeepTableCopy(specialEffects[effect.id])
    if specialEffect and (specialEffect.isReflect or (SV.advancedDebuff and specialEffect.isSpecialDebuff)) then
        return
    end

    local hasEffect, duration, stacks, beginTime = CheckForActiveEffect(effect.id)
    stacks = stacks ~= 0 and stacks or 0
    if stacks ~= 0 or (specialEffect.stacks and specialEffect.stacks ~= 0) then
        effect.stacks = stacks
        effect.endTime = (duration ~= 0) and (checkTime + duration) or -1
        FancyActionBar.stacks[effect.id] = stacks
    end

    if effect.stackId and not effect.stackId[effect.id] then
        for id, stackEffect in pairs(effects) do
            for i = 1, #effect.stackId do
                local currentStackId = effect.stackId[i]
                if currentStackId ~= effect.id and currentStackId == stackEffect.id then
                    if not stackEffect.processed then
                        stackEffect.processed = true
                        FancyActionBar.ReCheckSpecialEffect(stackEffect)
                        stackEffect.processed = false
                    end
                end
            end
        end
    end
    if FancyActionBar.bannerBearer[effect.id] then
        for k, v in pairs(FancyActionBar.bannerBearer) do
            if sourceAbilities[k] then
                FancyActionBar.toggles[sourceAbilities[effect.id]] = hasEffect
                FancyActionBar.effects[sourceAbilities[effect.id]].beginTime = (beginTime ~= 0) and beginTime or checkTime
            end
        end
    elseif FancyActionBar.toggled[effect.id] then -- update the highlight of toggled abilities.
        local toggleAbility = sourceAbilities[effect.id] and sourceAbilities[effect.id] or effect.id
        FancyActionBar.toggles[toggleAbility] = hasEffect
    end
    UpdateEffect(effect)
    HandleStackUpdate(effect.id)
end

--------------
-- Quick Slot
--------------
function FancyActionBar.UpdateQuickSlotOverlay() -- from LUI. update every 500ms
    local t = FancyActionBar.qsOverlay.timer
    local slotIndex = GetCurrentQuickslot()
    local remain, duration, global = GetSlotCooldownInfo(slotIndex, HOTBAR_CATEGORY_QUICKSLOT_WHEEL)
    if (duration > 5000) then
        t:SetHidden(false)
        if remain > 86400000 then    -- more then 1 day
            t:SetText(string.format("%d d", zo_floor(remain / 86400000)))
        elseif remain > 6000000 then -- over 100 minutes - display XXh
            t:SetText(string.format("%dh", zo_floor(remain / 3600000)))
        elseif remain > 600000 then  -- over 10 minutes - display XXm
            t:SetText(string.format("%dm", zo_floor(remain / 60000)))
        elseif remain > 60000 then
            local m = zo_floor(remain / 60000)
            local s = remain / 1000 - 60 * m
            t:SetText(string.format("%d:%.2d", m, s))
        else
            t:SetText(string.format("%.1d", 0.001 * remain))
        end
    else
        if not FancyActionBar.InMenu() then
            t:SetText("")
        end
    end
end

--------------
-- GCD
--------------

-- Helper function to get just cooldown and duration
local function GetCooldownInfo(slotIndex)
    local cooldown, duration = GetSlotCooldownInfo(slotIndex, HOTBAR_CATEGORY_PRIMARY)
    return cooldown, duration
end

function FancyActionBar.UpdateGCD()
    local cooldown, duration = GetCooldownInfo(MIN_INDEX)
    local cooldown2, duration2 = GetCooldownInfo(MIN_INDEX + 1)

    if (cooldown2 > cooldown) or (duration2 > duration) then
        cooldown = cooldown2
        duration = duration2
    end

    if duration <= 1 then
        duration = 1
    end

    local height = (cooldown / duration) * SV.gcd.sizeY
    FAB_GCD.fill:SetHeight(height)
end

--------------
-- Ultimate
--------------
function FancyActionBar.GetValueString(mode, value, cost) -- format label text
    local string = ""
    if mode == 1 then
        string = value
    elseif mode == 3 then
        string = value .. "/" .. cost
    else
        if value >= cost
        then
            string = value
        else
            string = value .. "/" .. cost
        end
    end
    return string
end

function FancyActionBar.UpdateUltimateValueLabels(player, value) -- update ultimate value displays
    local modeP = FancyActionBar.constants.ult.value.mode
    local modeC = FancyActionBar.constants.ult.companion.mode
    local alpha = (value < 10) and 0 or 1
    local currentHotbarCategory = GetActiveHotbarCategory()
    local cost = ((currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY) or (currentHotbarCategory == HOTBAR_CATEGORY_BACKUP)) and cost1 or costAlt
    if (player and FancyActionBar.constants.ult.value.show) then
        ActionButton8LeadingEdge:SetAlpha(alpha)
        -- ActionButton8UltimateBar:SetHidden(false)

        local o1 = FancyActionBar.ultOverlays[ULT_INDEX]
        local o2 = FancyActionBar.ultOverlays[ULT_INDEX + SLOT_INDEX_OFFSET]

        if o1 and o1.value then
            o1.value:SetText(FancyActionBar.GetValueString(modeP, value, cost))
            o1.value:SetColor(unpack(FancyActionBar.GetUltimateValueColor(value, HOTBAR_CATEGORY_PRIMARY)))
        end
        if o2 and o2.value then
            o2.value:SetText(FancyActionBar.GetValueString(modeP, value, cost2))
            o2.value:SetColor(unpack(FancyActionBar.GetUltimateValueColor(value, HOTBAR_CATEGORY_BACKUP)))
        end
    else
        local o3 = FancyActionBar.ultOverlays[ULT_INDEX + COMPANION_INDEX_OFFSET]
        if CompanionUltimateButtonLeadingEdge then
            CompanionUltimateButtonLeadingEdge:SetAlpha(SV.hideCompanionUlt and 0 or alpha)
        end
        if CompanionUltimateButton then
            CompanionUltimateButton:SetHidden(SV.hideCompanionUlt)
        end
        if o3 and o3.value then
            o3.value:SetText(SV.hideCompanionUlt and "" or FancyActionBar.GetValueString(modeC, value, cost3))
        end
    end
end

function FancyActionBar.OnUltChanged(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
    if powerType == COMBAT_MECHANIC_FLAGS_ULTIMATE then
        local current, _, _ = GetUnitPower("player", COMBAT_MECHANIC_FLAGS_ULTIMATE)
        FancyActionBar.UpdateUltimateValueLabels(true, current)
    end
end

function FancyActionBar.OnUltChangedCompanion(eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax)
    if powerType == COMBAT_MECHANIC_FLAGS_ULTIMATE then
        local current, _, _ = GetUnitPower("companion", COMBAT_MECHANIC_FLAGS_ULTIMATE)
        FancyActionBar.UpdateUltimateValueLabels(false, current)
    end
end

function FancyActionBar.UpdateUltimateCost() -- manual ultimate value update
    if not FancyActionBar.constants.ult.value.show then
        return
    end

    local function ResolveUltCost(id, overrideActiveRank, overrideCasterUnitTag)
        overrideCasterUnitTag = overrideCasterUnitTag or "player"
        local incap = 113105
        local cost = 0
        if id > 0 then
            if id == incap
            then
                cost = 70
            else
                cost = GetAbilityCost(id, COMBAT_MECHANIC_FLAGS_ULTIMATE, overrideActiveRank, overrideCasterUnitTag)
            end
        end
        return cost
    end
    local currentHotbarCategory = GetActiveHotbarCategory()
    cost1 = ResolveUltCost(FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, HOTBAR_CATEGORY_PRIMARY))
    cost2 = ResolveUltCost(FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, HOTBAR_CATEGORY_BACKUP))
    costAlt = ResolveUltCost(FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, currentHotbarCategory))

    local current, _, _ = GetUnitPower("player", COMBAT_MECHANIC_FLAGS_ULTIMATE)
    FancyActionBar.UpdateUltimateValueLabels(true, current)
end

function FancyActionBar.GetUltimateValueColor(current, hotbar)
    -- Localize constants to avoid repeated table lookups
    local constants = FancyActionBar.constants.ult.value
    local baseColor = constants.color
    local maxColor = constants.maxColor

    -- Early return for max value case
    if current == 500 then return maxColor end

    -- Get ability ID and handle special cases
    local ultAbilityId = FancyActionBar.GetSlotBoundAbilityId(ULT_INDEX, hotbar)
    if not ultAbilityId or ultAbilityId <= 0 then return baseColor end

    -- Calculate cost
    local cost = ultAbilityId == 113105 and 70 or GetAbilityCost(ultAbilityId, COMBAT_MECHANIC_FLAGS_ULTIMATE, nil, "player")
    if cost == 0 then return baseColor end

    -- Calculate color based on thresholds
    local ratio = current / cost
    local usableColor = constants.usableColor
    local threshold = constants.threshold
    local thresholdColor = constants.usableThresholdColor

    if current >= cost then
        return usableColor
    elseif ratio >= threshold then
        return thresholdColor
    end

    return baseColor
end

--------------------------------------------------------------------------------
-----------------------------[ 		Configuration    ]----------------------------
--------------------------------------------------------------------------------
function FancyActionBar.RefreshUpdateConfiguration() -- set overlays refresh rate
    local update =
    {
        showDecimal = false,
        showDecimalStart = 0,
    }
    if (SV.showDecimal == "Never") then
        update.showDecimal = false
        update.showDecimalStart = 0
    elseif (SV.showDecimal == "Always") then
        update.showDecimal = true
        update.showDecimalStart = SV.durationMax
    elseif (SV.showDecimal == "Expire") then
        update.showDecimal = true
        update.showDecimalStart = SV.showDecimalStart
    end
    return update
end

--  ---------------------------------
--  Load Saved Ability Configuration
--  ---------------------------------
function FancyActionBar.BuildAbilityConfig() -- Parse FancyActionBar.abilityConfig for faster access.
    abilityConfig = {}
    local config = FancyActionBar.GetAbilityConfig()
    local customConfig = FancyActionBar.GetAbilityConfigChanges()

    -- for id, cfg in pairs(FancyActionBar.abilityConfig) do
    -- local debuffs = FancyActionBar.constants.hideOnNoTargetList

    local parsedCustomConfig = {}
    for id, cfg in pairs(config) do
        local toggled, hide = false, false
        local craftedId = GetAbilityCraftedAbilityId(id)
        if customConfig[id] then
            cfg = customConfig[id]
            parsedCustomConfig[id] = true
        end

        -- if debuffs[id]
        -- then hide = debuffs[id]
        -- else hide = FancyActionBar.GetHideOnNoTargetGlobalSetting() end

        if FancyActionBar.toggled[id] then
            toggled = true
            FancyActionBar.toggles[id] = false
        end

        local cI, rI = id, false

        if type(cfg) == "table" then
            if craftedId ~= 0 then
                if cfg[1] and cfg[2] and not cfg[2]["0_0_0"] then
                    cfg[2]["0_0_0"] = cfg[1]
                end
            end
        end

        if FancyActionBar.removeInstantly[cI] then
            rI = true
        end

        if type(cfg) == "table" then
            abilityConfig[id] = { cfg[1], cfg[2], toggled, rI }
        elseif cfg then
            abilityConfig[id] = { cfg[1], nil, toggled, rI }
        elseif cfg == false then
            abilityConfig[id] = false
        else
            abilityConfig[id] = nil
        end
    end

    for id, cfg in pairs(customConfig) do
        if not parsedCustomConfig[id] then
            local toggled, hide = false, false
            local cI, rI = id, false
            local craftedId = GetAbilityCraftedAbilityId(id)

            cfg = customConfig[id]
            if FancyActionBar.toggled[id] then
                toggled = true
                FancyActionBar.toggles[id] = false
            end
            if FancyActionBar.removeInstantly[cI] then
                rI = true
            end
            if cfg == false then
                abilityConfig[id] = false
            elseif cfg and cfg[1] or cfg[2] then
                if craftedId ~= 0 then
                    if cfg[1] and cfg[2] and not cfg[2]["0_0_0"] then
                        cfg[2]["0_0_0"] = cfg[1]
                    end
                    abilityConfig[id] = { cfg[1], cfg[2], toggled, rI }
                else
                    abilityConfig[id] = { cfg[1], nil, toggled, rI }
                end
            else
                abilityConfig[id] = nil
            end
        end
    end

    -- for id, isToggled in pairs(FancyActionBar.toggled) do
    --   if id then
    --     local i
    --     -- if FancyActionBar.abilityConfig[id] then i = FancyActionBar.abilityConfig[id]
    --     if config[id] then i = config[id]
    --       if type(i) == 'table'
    --       then i = i[1] or id
    --       else i = id end
    --     else i = id end
    --     abilityConfig[id] = {i, true, isToggled}
    --     FancyActionBar.toggles[id]   = false
    --   end
    -- end
end

function FancyActionBar.DebugConfig(abilityId)
    return abilityConfig[abilityId]
end

--  ---------------------------------
--  Buffs gained by player from others
--  ---------------------------------
local BUFF_EFFECT_TYPE_DEBUFF = BUFF_EFFECT_TYPE_DEBUFF
function FancyActionBar.OnEffectGainedFromAlly(eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if sourceType == COMBAT_UNIT_TYPE_PLAYER then
        return
    end
    if not AreUnitsEqual("player", unitTag) then
        return
    end
    local _
    if FancyActionBar.stackableBuff[abilityId] then
        local stackableBuffId = FancyActionBar.stackableBuff[abilityId]
        _, _, stackCount = FancyActionBar.CheckForActiveEffect(stackableBuffId)
        FancyActionBar.stacks[stackableBuffId] = stackCount
        FancyActionBar.HandleStackUpdate(stackableBuffId)
    end

    if not SV.externalBuffs then
        return
    end

    local effect = FancyActionBar.effects[abilityId]
    if effect then
        local t = time()

        if SV.externalBlackList[abilityId] then
            return
        end

        if (change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED and buffType ~= BUFF_EFFECT_TYPE_DEBUFF) then
            if beginTime == endTime then
                FancyActionBar.UpdatePassiveEffect(abilityId, true)
                return
            end

            if (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax and endTime > effect.endTime) then
                effect.endTime = endTime
                FancyActionBar.UpdateEffect(effect)
            end
        elseif (change == EFFECT_RESULT_FADED) then
            local hasEffect, duration, currentStacks = FancyActionBar.CheckForActiveEffect(abilityId)
            if hasEffect then
                effect.endTime = (duration ~= 0) and (t + duration) or -1
                FancyActionBar.UpdateEffect(effect)
            else
                effect.endTime = t
                if beginTime == endTime then
                    FancyActionBar.UpdatePassiveEffect(abilityId, false)
                end
            end
        end
    end
    -- local ts = tostring
    -- FancyActionBar.AddSystemMessage('['..ts(abilityId)..'] '..effectName..' '..sourceType..': '..effectType..' --> '..unitName..endTime-beginTime..' ('..stackCount..')')
end

function FancyActionBar.SetExternalBuffTracking() -- buffs gained from others
    EM:UnregisterForEvent(NAME .. "External", EVENT_EFFECT_CHANGED)
    if SV.externalBuffs then
        EM:RegisterForEvent(NAME .. "External", EVENT_EFFECT_CHANGED, FancyActionBar.OnEffectGainedFromAlly)
        EM:AddFilterForEvent(NAME .. "External", EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
    else
        for id in pairs(FancyActionBar.stackableBuff) do
            EM:RegisterForEvent(NAME .. "External_" .. id, EVENT_EFFECT_CHANGED, FancyActionBar.OnEffectGainedFromAlly)
            EM:AddFilterForEvent(NAME .. "External_" .. id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
            EM:AddFilterForEvent(NAME .. "External_" .. id, EVENT_EFFECT_CHANGED, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        end
    end
end

--  ---------------------------------
--  UI Setup
--  ---------------------------------

-- Move action bar and attributes up a bit.
function FancyActionBar:AdjustControlsPositions() -- resource bars and default action bar position
    if FAB_ActionBarFakeQS == nil then
        FAB_ActionBarFakeQS = GetControl("FAB_ActionBarFakeQS")
    end
    FAB_ActionBarFakeQS:ClearAnchors()
    FAB_ActionBarFakeQS:SetAnchor(LEFT, ACTION_BAR, LEFT, 0, -5, FAB_ActionBarFakeQS:GetResizeToFitConstrains())

    local constants = FancyActionBar.GetConstants()
    local style = (constants and next(constants)) and constants
        or (IsInGamepadPreferredMode() and GAMEPAD_CONSTANTS or KEYBOARD_CONSTANTS)
    local anchor = style.anchor
    if FancyActionBar.updateUI then
        anchor:SetFromControlAnchor(ACTION_BAR)
        anchor:SetOffsets(nil, style.actionBarOffset)
        anchor:Set(ACTION_BAR)
    end
    anchor:SetFromControlAnchor(ZO_PlayerAttribute)
    anchor:SetOffsets(nil, style.attributesOffset)
    anchor:Set(ZO_PlayerAttribute)
end

function FancyActionBar.AdjustQuickSlotSpacing(lock)
    if SV.hideLockedBar then
        lock = lock or isWeaponSwapLocked
    end

    local abilitySlotOffsetX = FancyActionBar.constants.abilitySlot.offsetX
    local QSB = GetControl("QuickslotButton")
    local xOffset = (FancyActionBar.style == 1 and SV.quickSlotCustomXOffsetKB) or SV.quickSlotCustomXOffsetGP or 0
    local yOffset = (FancyActionBar.style == 1 and SV.quickSlotCustomYOffsetKB) or SV.quickSlotCustomYOffsetGP or 0
    local anchorOffsetY = yOffset * scale
    local anchorControl, anchorPoint, relPoint, anchorX

    if not SV.showArrow or lock then
        if SV.moveQS and weaponSwapControl then
            anchorControl = weaponSwapControl
            anchorPoint = RIGHT
            relPoint = RIGHT
            if FancyActionBar.style == 2 then
                anchorX = -(2 + (SLOT_COUNT * abilitySlotOffsetX) + xOffset) * scale
            else
                anchorX = -(5 + abilitySlotOffsetX + xOffset) * scale
            end
        else
            anchorControl = FAB_ActionBarFakeQS
            anchorPoint = LEFT
            relPoint = LEFT
            anchorX = xOffset
        end
    else
        anchorControl = FAB_ActionBarFakeQS
        anchorPoint = LEFT
        relPoint = LEFT
        anchorX = xOffset
        FAB_ActionBarArrow:SetColor(unpack(SV.arrowColor))
    end

    QSB:ClearAnchors()
    QSB:SetAnchor(anchorPoint, anchorControl, relPoint, anchorX, anchorOffsetY, QSB:GetResizeToFitConstrains())
    FAB_ActionBarArrow:SetHidden(lock or not SV.showArrow)
end

function FancyActionBar.AdjustUltimateSpacing() -- place the ultimate button according to variables
    if FancyActionBar.style == 1 then
        return
    end
    local style = FancyActionBar.GetConstants()

    ActionButton8:ClearAnchors()
    CompanionUltimateButton:ClearAnchors()

    local ultX = 10 + SV.ultimateSlotCustomXOffsetGP + (10 * scale)
    local ultY = 0 + SV.ultimateSlotCustomYOffsetGP
    local ultCX = 20 + (10 * scale)
    local ultCY = 0
    local u = 65 * scale
    local f1 = (style.abilitySlotWidth + FancyActionBar.constants.abilitySlot.offsetX)
    local f2 = f1 * SLOT_COUNT

    if SV.showHotkeysUltGP then
        ActionButton8:SetAnchor(LEFT, weaponSwapControl, RIGHT, f2 + u + SV.ultimateSlotCustomXOffsetGP, 0 + SV.ultimateSlotCustomYOffsetGP, ActionButton8:GetResizeToFitConstrains())
        CompanionUltimateButton:SetAnchor(LEFT, ActionButton8, RIGHT, u + ultCX, ultCY, CompanionUltimateButton:GetResizeToFitConstrains())
        return
    end

    if SV.moveQS == true then
        ActionButton8:SetAnchor(LEFT, weaponSwapControl, RIGHT, f2 + ultX, ultY, ActionButton8:GetResizeToFitConstrains())
        CompanionUltimateButton:SetAnchor(LEFT, ActionButton8, RIGHT, 10 + ultCX, 0, CompanionUltimateButton:GetResizeToFitConstrains())
    else
        ActionButton8:SetAnchor(LEFT, weaponSwapControl, RIGHT, f2 + u + SV.ultimateSlotCustomXOffsetGP, 0 + SV.ultimateSlotCustomYOffsetGP, ActionButton8:GetResizeToFitConstrains())
        -- ActionButton8:SetAnchor(RIGHT, ZO_ActionBar1, RIGHT, 40 * scale, 0)
        CompanionUltimateButton:SetAnchor(LEFT, ActionButton8, RIGHT, u + ultCX, ultCY, CompanionUltimateButton:GetResizeToFitConstrains())
    end
end

function FancyActionBar:ApplySettings() -- apply all UI settings for current UI mode
    self.AdjustQuickSlotSpacing()

    self.ConfigureFrames()
    self.ApplyTimerFont()
    self.AdjustTimerY()

    self.ApplyStackFont()
    self.AdjustStackX()
    self.AdjustStackY()

    self.ApplyTargetFont()
    self.AdjustTargetX()
    self.AdjustTargetY()

    self.AdjustUltTimer(false)
    self.ApplyUltFont(false)

    self.AdjustUltValue()
    self.ApplyUltValueColor()
    self.AdjustCompanionUltValue()
    self.ApplyUltValueFont()
    self.UpdateUltimateCost()

    self:AdjustQuickSlotTimer()
    self.ApplyQuickSlotFont()
    self.ToggleQuickSlotDuration()

    self.ToggleGCD()

    self.ApplyPosition()
end

function FancyActionBar.ToggleQuickSlotDuration() -- enable / disable quickslot timer
    local enable = FancyActionBar.constants.qs.show
    EM:UnregisterForUpdate(NAME .. "UpdateQuickSlot")
    if enable
    then
        EM:RegisterForUpdate(NAME .. "UpdateQuickSlot", 500, FancyActionBar.UpdateQuickSlotOverlay)
    else
        FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetText("")
    end
end

function FancyActionBar.ToggleUltimateValue() -- enable / disable ultimate value
    local function clearUltimateOverlays()
        for i in pairs(FancyActionBar.ultOverlays) do
            local valueControl = FancyActionBar.ultOverlays[i]:GetNamedChild("Value")
            if valueControl then
                valueControl:SetText("")
            end
        end
    end

    local function setupPlayerUltimate(showValue)
        if showValue then
            local current = GetUnitPower("player", COMBAT_MECHANIC_FLAGS_ULTIMATE)
            FancyActionBar.UpdateUltimateValueLabels(true, current)

            EM:RegisterForEvent(NAME .. "UltValue", EVENT_POWER_UPDATE, FancyActionBar.OnUltChanged)
            EM:AddFilterForEvent(NAME .. "UltValue", EVENT_POWER_UPDATE,
                REGISTER_FILTER_POWER_TYPE, COMBAT_MECHANIC_FLAGS_ULTIMATE,
                REGISTER_FILTER_UNIT_TAG, "player")
        end
    end

    local function setupCompanionUltimate(showValue)
        local companionCost = GetSlotAbilityCost(ULT_INDEX, COMBAT_MECHANIC_FLAGS_ULTIMATE, HOTBAR_CATEGORY_COMPANION)

        -- Hide companion ultimate if conditions aren't met
        if not DoesUnitExist("companion") or
            not HasActiveCompanion() or
            not companionCost or
            companionCost == 0 then
            CompanionUltimateButton:SetHidden(true)
            return
        end

        if showValue then
            local current = GetUnitPower("companion", COMBAT_MECHANIC_FLAGS_ULTIMATE)
            FancyActionBar.UpdateUltimateValueLabels(false, current)

            EM:RegisterForEvent(NAME .. "UltValueCompanion", EVENT_POWER_UPDATE, FancyActionBar.OnUltChangedCompanion)
            EM:AddFilterForEvent(NAME .. "UltValueCompanion", EVENT_POWER_UPDATE,
                REGISTER_FILTER_POWER_TYPE, COMBAT_MECHANIC_FLAGS_ULTIMATE,
                REGISTER_FILTER_UNIT_TAG, "companion")
        end
    end

    -- Unregister existing events
    EM:UnregisterForEvent(NAME .. "UltValue", EVENT_POWER_UPDATE)
    EM:UnregisterForEvent(NAME .. "UltValueCompanion", EVENT_POWER_UPDATE)

    -- Clear all ultimate overlays
    clearUltimateOverlays()

    -- Setup player and companion ultimates based on settings
    local showUltValue = FancyActionBar.constants.ult.value.show
    local showCompanionUlt = FancyActionBar.constants.ult.companion.show

    setupPlayerUltimate(showUltValue)
    setupCompanionUltimate(showCompanionUlt)
end

--  ---------------------------------
--  UI Prep before initial
--  ---------------------------------
---
--- This is now directly handled in the ui.xml OnInitialized
-- @param control TopLevelWindow
-- function FancyActionBar.OnActionBarInitialized(control) -- backbar control initialized.
--     ULTIMATE_BUTTON_STYLE.parentBar = control

--     -- Set active bar as a parent to make inactive bar show/hide automatically.
--     control:SetParent(ACTION_BAR)

--     -- Need to adjust it here instead of in ApplyStyle(), otherwise it won't properly work with Azurah.
--     FancyActionBar.AdjustControlsPositions()

--     -- Create inactive bar buttons.
--     for i = MIN_INDEX + SLOT_INDEX_OFFSET, MAX_INDEX + SLOT_INDEX_OFFSET do
--         --- @class ActionButton
--         local button = ActionButton:New(i, ACTION_BUTTON_TYPE_VISIBLE, control, "ZO_ActionButton")
--         button:SetShowBindingText(false)
--         button.icon:SetHidden(true)
--         button:SetupBounceAnimation()
--         FancyActionBar.buttons[i] = button
--     end
-- end

---
--- @param index integer
--- @return Control|FAB_ActionButtonOverlay_Gamepad_Template|FAB_ActionButtonOverlay_Keyboard_Template
function FancyActionBar.CreateOverlay(index) -- create normal skill button overlay.
    -- local template = ZO_GetPlatformTemplate('FAB_ActionButtonOverlay')
    local template = FancyActionBar.constants.style.overlayTemplate
    --- @type Control
    local overlay = FancyActionBar.overlays[index]
    if overlay then
        WM:ApplyTemplateToControl(overlay, template)
        overlay:ClearAnchors()
        overlay.activeEffects = {}
    else
        overlay = WM:CreateControlFromVirtual("ActionButtonOverlay", ACTION_BAR, template, index)
        overlay.timer = overlay:GetNamedChild("Duration")
        overlay.bg = overlay:GetNamedChild("BG")
        overlay.stack = overlay:GetNamedChild("Stacks")
        overlay.target = overlay:GetNamedChild("Targets")
        FancyActionBar.overlays[index] = overlay
    end
    return overlay
end

---
--- Creates or updates an ultimate button overlay
--- @param index integer The index of the ultimate button
--- @return FAB_UltimateButtonOverlay_Gamepad_Template|FAB_UltimateButtonOverlay_Keyboard_Template
function FancyActionBar.CreateUltOverlay(index)
    local function getParentButton(buttonIndex)
        if buttonIndex == ULT_INDEX + COMPANION_INDEX_OFFSET then
            return ZO_ActionBar_GetButton(ULT_INDEX, HOTBAR_CATEGORY_COMPANION)
        end
        return ZO_ActionBar_GetButton(ULT_INDEX)
    end

    local function initializeOverlayControls(overlayControl)
        overlayControl.timer = overlayControl:GetNamedChild("Duration")
        overlayControl.value = overlayControl:GetNamedChild("Value")
        overlayControl.bg = overlayControl:GetNamedChild("BG")
        overlayControl.stack = overlayControl:GetNamedChild("Stacks")
        overlayControl.target = overlayControl:GetNamedChild("Targets")
    end

    -- Get the template for the overlay
    local template = FancyActionBar.constants.style.ultOverlayTemplate
    local overlay = FancyActionBar.ultOverlays[index]

    -- Update existing overlay if it exists
    if overlay then
        WM:ApplyTemplateToControl(overlay, template)
        overlay:ClearAnchors()
        return overlay
    end

    -- Create new overlay
    local parent = getParentButton(index)
    overlay = WM:CreateControlFromVirtual("UltimateButtonOverlay", parent.slot, template, index)

    -- Initialize overlay controls
    initializeOverlayControls(overlay)

    -- Store the overlay
    FancyActionBar.ultOverlays[index] = overlay

    return overlay
end

---
--- @param index integer
--- @return FAB_QuickSlotOverlay_Gamepad_Template|FAB_QuickSlotOverlay_Keyboard_Template
function FancyActionBar.CreateQuickSlotOverlay(index) -- create quickslot button overlay.
    -- local template = ZO_GetPlatformTemplate('FAB_QuickSlotOverlay')
    local template = FancyActionBar.constants.style.qsOverlayTemplate
    local overlay = FancyActionBar.qsOverlay
    if overlay then
        WM:ApplyTemplateToControl(overlay, template)
        overlay:ClearAnchors()
    else
        overlay = WM:CreateControlFromVirtual("QuickSlotOverlay", ACTION_BAR, template, index)
        FancyActionBar.qsOverlay = overlay
    end
    return overlay
end

local applyButtonStyles = function (style)
    local ultButton = ZO_ActionBar_GetButton(ULT_INDEX)
    local ultButtonC = ZO_ActionBar_GetButton(ULT_INDEX, HOTBAR_CATEGORY_COMPANION)
    local QSButton = ZO_ActionBar_GetButton(QUICK_SLOT, HOTBAR_CATEGORY_QUICKSLOT_WHEEL)
    ultButton:ApplyStyle(style.ultButtonTemplate)
    ultButtonC:ApplyStyle(style.ultButtonTemplate)
    QSButton:ApplyStyle(style.buttonTemplate)
end

local repositionUltimateSlot = function (style)
    if FancyActionBar.style == 2 then
        FancyActionBar.AdjustUltimateSpacing()
    else
        ActionButton8:ClearAnchors()
        CompanionUltimateButton:ClearAnchors()
        local uX = (style.ultimateSlotOffsetX + SV.ultimateSlotCustomXOffsetKB) * scale
        local uY = (0 + SV.ultimateSlotCustomYOffsetKB) * scale
        local uC = style.ultimateSlotOffsetX * scale
        local f1 = (style.abilitySlotWidth + FancyActionBar.constants.abilitySlot.offsetX)
        local f2 = (f1 * SLOT_COUNT) - 2
        ActionButton8:SetAnchor(LEFT, weaponSwapControl, RIGHT, f2 + uX, uY, ActionButton8:GetResizeToFitConstrains())
        CompanionUltimateButton:SetAnchor(LEFT, ActionButton8, RIGHT, uC, 0, CompanionUltimateButton:GetResizeToFitConstrains())
    end
end

local setFlipCardDimensions = function (style)
    local c8 = GetControl("ActionButton8FlipCard")
    local c9 = GetControl("ActionButton9FlipCard")
    local c38 = GetControl("CompanionUltimateButtonFlipCard")
    local flipCardSize = style.flipCardSize
    local ultFlipCardSize = style.ultFlipCardSize

    if c8 then
        c8:ClearDimensions()
        c8:SetDimensions(ultFlipCardSize, ultFlipCardSize)
    end
    if c9 then
        c9:ClearDimensions()
        c9:SetDimensions(flipCardSize, flipCardSize)
    end
    if c38 then
        c38:ClearDimensions()
        c38:SetDimensions(ultFlipCardSize, ultFlipCardSize)
    end
end

local hideUltimateNumberIfNeeded = function ()
    local hideUltNumber = FancyActionBar.constants.ult.value.show
    if hideUltNumber and not IsConsoleUI() then
        SetSetting(SETTING_TYPE_UI, UI_SETTING_ULTIMATE_NUMBER, "false")
    end
end

---
--- @param fill Control
--- @param backdrop Control
--- @param offset1 integer
--- @param offset2 integer
local configureFillAnimation = function (fill, backdrop, offset1, offset2)
    if fill then
        fill:ClearDimensions()
        fill:ClearAnchors()
        fill:SetAnchor(TOPRIGHT, backdrop, TOP, 0, offset1, fill:GetResizeToFitConstrains())
        fill:SetAnchor(BOTTOMLEFT, backdrop, BOTTOMLEFT, offset1, offset2, fill:GetResizeToFitConstrains())
        fill:SetHidden(false)
    end
end

---
--- @param fill Control
local hideFillAnimation = function (fill)
    if fill then
        fill:ClearAnchors()
        fill:SetHidden(true)
    end
end

local configureFillAnimationsAndFrames = function (style)
    local leftFill = GetControl("ActionButton8FillAnimationLeft")
    local rightFill = GetControl("ActionButton8FillAnimationRight")
    local leftFillC = GetControl("CompanionUltimateButtonPartialFillAnimationLeft")
    local rightFillC = GetControl("CompanionUltimateButtonFillAnimationRight")
    local gpFrame = GetControl("ActionButton8Frame")
    local gpFrameC = GetControl("CompanionUltimateButtonFrame")
    local actionbutton8backdrop = GetControl("ActionButton8Backdrop")
    local companionultimatebuttonbackdrop = GetControl("CompanionUltimateButtonBackdrop")
    local ultFlipCardSize = style.ultFlipCardSize
    local halfUltFlipCardSize = ultFlipCardSize / 2
    -- Check if controls are retrieved successfully
    if not leftFill or not rightFill or not leftFillC or not rightFillC or not gpFrame or not gpFrameC then
        -- FancyActionBar.AddSystemMessage("One or more controls are nil");
        return
    end
    local currentHotbarCategory = GetActiveHotbarCategory()
    local isSlotUsed = IsSlotUsed(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, currentHotbarCategory)
    local isGamepad = FancyActionBar.useGamepadActionBar

    if FancyActionBar.style == 2 and isSlotUsed then
        -- Show fill bar if platform appropriate
        gpFrame:SetHidden(false)
        gpFrameC:SetHidden(false)
        leftFill:SetHidden(not isGamepad)
        rightFill:SetHidden(not isGamepad)
        leftFillC:SetHidden(not isGamepad)
        rightFillC:SetHidden(not isGamepad)

        -- Set textures for gamepad mode
        if isGamepad then
            leftFill:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
            rightFill:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
            leftFillC:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
            rightFillC:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
        end

        -- Set fill animations
        configureFillAnimation(leftFill, actionbutton8backdrop, -ultFlipCardSize, ultFlipCardSize)
        configureFillAnimation(rightFill, actionbutton8backdrop, -ultFlipCardSize, ultFlipCardSize)
        configureFillAnimation(leftFillC, companionultimatebuttonbackdrop, -ultFlipCardSize, ultFlipCardSize)
        configureFillAnimation(rightFillC, companionultimatebuttonbackdrop, -ultFlipCardSize, ultFlipCardSize)
    else
        -- Hide fill animations and frames
        hideFillAnimation(leftFill)
        hideFillAnimation(rightFill)
        hideFillAnimation(leftFillC)
        hideFillAnimation(rightFillC)
        gpFrame:SetHidden(true)
        gpFrameC:SetHidden(true)
    end
end

function FancyActionBar.ToggleFillAnimationsAndFrames(state)
    GetControl("ActionButton8Frame"):SetHidden(not state)
    GetControl("ActionButton8FillAnimationLeft"):SetHidden(not state)
    GetControl("ActionButton8FillAnimationRight"):SetHidden(not state)
    if AreCompanionSkillsInitialized() then
        GetControl("CompanionUltimateButtonFrame"):SetHidden(not state)
        GetControl("CompanionUltimateButtonFillAnimationLeft"):SetHidden(not state)
        GetControl("CompanionUltimateButtonFillAnimationRight"):SetHidden(not state)
    end
    FancyActionBar.SetUltFrameAlpha()
    local ultButton = ZO_ActionBar_GetButton(ULT_INDEX)
    if ultButton then
        ultButton:UpdateUltimateMeter()
    end
end

function FancyActionBar.SetUltFrameAlpha()
    GetControl("ActionButton8Frame"):SetAlpha(SV.ultFillFrameAlpha)
    GetControl("ActionButton8FillAnimationLeft"):SetAlpha(SV.ultFillBarAlpha)
    GetControl("ActionButton8FillAnimationRight"):SetAlpha(SV.ultFillBarAlpha)
    if AreCompanionSkillsInitialized() then
        GetControl("CompanionUltimateButtonFrame"):SetAlpha(SV.ultFillFrameAlpha)
        GetControl("CompanionUltimateButtonFillAnimationLeft"):SetAlpha(SV.ultFillBarAlpha)
        GetControl("CompanionUltimateButtonFillAnimationRight"):SetAlpha(SV.ultFillBarAlpha)
    end
end

local createOverlays = function (style, QSB)
    local function setupOverlay(overlay, anchorControl)
        overlay:SetAnchor(TOPLEFT, anchorControl, TOPLEFT, 0, 0)
        overlay:SetAnchor(BOTTOMRIGHT, anchorControl, BOTTOMRIGHT, 0, 0)
        overlay.value = overlay:GetNamedChild("Value")
    end
    local actionbutton8 = GetControl("ActionButton8")
    local companionultimatebutton = GetControl("CompanionUltimateButton")
    -- Front bar ultimate overlay
    local u1 = FancyActionBar.CreateUltOverlay(ULT_INDEX)
    setupOverlay(u1, actionbutton8)

    -- Back bar ultimate overlay
    local u2 = FancyActionBar.CreateUltOverlay(ULT_INDEX + SLOT_INDEX_OFFSET)
    setupOverlay(u2, actionbutton8)

    -- Companion ultimate overlay
    local u3 = FancyActionBar.CreateUltOverlay(ULT_INDEX + COMPANION_INDEX_OFFSET)
    setupOverlay(u3, companionultimatebutton)

    -- Quickslot overlay
    local QO = FancyActionBar.CreateQuickSlotOverlay(QUICK_SLOT)
    setupOverlay(QO, QSB)
    QO.timer = QO:GetNamedChild("Duration")
    QO.timer:SetColor(unpack(FancyActionBar.useGamepadActionBar and SV.qsColorGP or SV.qsColorKB))

    local qsFrame = FancyActionBar.qsOverlay:GetNamedChild("Frame")
    if qsFrame then
        QO.frame = qsFrame
    end
end

function FancyActionBar.ApplyQuickSlotAndUltimateStyle() -- make sure UI is adjusted to settings
    local style = FancyActionBar.GetConstants()
    local QSB = QuickslotButton

    -- Apply styles to buttons
    applyButtonStyles(style)

    -- Ensure scale is initialized
    scale = scale or 1

    -- Reposition ultimate slot
    repositionUltimateSlot(style)

    -- Set dimensions for flip cards
    setFlipCardDimensions(style)

    -- Hide ultimate number if needed
    hideUltimateNumberIfNeeded()

    -- Configure fill animations and frames
    configureFillAnimationsAndFrames(style)

    -- Create overlays
    createOverlays(style, QSB)
end

--- Apply style to action bars depending on keyboard/gamepad mode.
function FancyActionBar.ApplyStyle()
    FancyActionBar.UpdateStyle()
    local style = FancyActionBar.GetConstants()

    FancyActionBar.SetupActionBar(style)
    FancyActionBar.SetupButtons(style)
    FancyActionBar.SetupOverlays(style)

    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
    FancyActionBar:ApplySettings()
end

--- Setup the action bar with the given style.
--- @param style table
function FancyActionBar.SetupActionBar(style)
    ACTION_BAR:SetWidth(style.width)
    ACTION_BAR:GetNamedChild("KeybindBG"):SetHidden(true)

    weaponSwapControl:ClearAnchors()
    weaponSwapControl:SetAnchor(LEFT, FAB_ActionBarFakeQS, RIGHT, 0, 0)
    weaponSwapControl:SetAlpha(0)
    weaponSwapControl:SetMouseEnabled(false)
end

function FancyActionBar.ApplyActiveHotbarStyle()
    local style = FancyActionBar.GetConstants()
    for i = MIN_INDEX, MAX_INDEX do
        local button = ZO_ActionBar_GetButton(i)
        button:ApplyStyle(style.buttonTemplate)
        FancyActionBar.SetupButtonText(button, style, i)
        FancyActionBar.SetupButtonStatus(button)
    end
    local ult = ZO_ActionBar_GetButton(ULT_INDEX, GetActiveHotbarCategory())
    if ult and ult.hasAction then
        ult:UpdateUltimateMeter()
    end
end

--- Setup the buttons with the given style.
--- @param style table
function FancyActionBar.SetupButtons(style)
    local lastButton = nil

    for i = MIN_INDEX, MAX_INDEX do
        local button = ZO_ActionBar_GetButton(i)
        if lastButton then
            button:ApplyAnchor(lastButton.slot, FancyActionBar.constants.abilitySlot.offsetX)
        elseif i == MIN_INDEX then
            button.slot:ClearAnchors()
            button.slot:SetAnchor(BOTTOMLEFT, weaponSwapControl, RIGHT, 0, -4)
        else
            button.slot:ClearAnchors()
            button.slot:SetAnchor(LEFT, ZO_ActionBar_GetButton(i - 1).slot, RIGHT, 0, 0)
        end
        lastButton = button
        FancyActionBar.SetupButtonText(button, style, i)
        FancyActionBar.SetupButtonStatus(button)
    end
end

--- Setup the button text.
--- @param button {buttonText:LabelControl}
--- @param style table
--- @param index number
function FancyActionBar.SetupButtonText(button, style, index)
    local overlayOffsetX = (index - MIN_INDEX) * (style.abilitySlotWidth + FancyActionBar.constants.abilitySlot.offsetX)
    local barYOffset = SV.hideLockedBar and SV.repositionActiveBar and isWeaponSwapLocked and (style.dimensions + style.buttonTextOffsetY) / 3 or
        style.buttonTextOffsetY + ((FancyActionBar.style == 2 and SV.barYOffsetGP or SV.barYOffsetKB or 0) / 2)
    button.buttonText:ClearAnchors()
    button.buttonText:SetAnchor(CENTER, weaponSwapControl, RIGHT, (overlayOffsetX + style.abilitySlotWidth / 2), barYOffset)
    button.buttonText:SetHidden(not SV.showHotkeys)
end

--- Setup the button status.
--- @param button {status:TextureControl}
function FancyActionBar.SetupButtonStatus(button)
    if SV.toggledHighlight or SV.showHighlight then
        button.status:SetTexture("FancyActionBar+/texture/blank.dds")
    else
        button.status:SetTexture("EsoUI/Art/ActionBar/ActionSlot_toggledon.dds")
    end
end

--- Setup the overlays with the given style.
--- @param style table
function FancyActionBar.SetupOverlays(style)
    local lastButton = nil
    for i = MIN_INDEX, MAX_INDEX do
        local overlay = FancyActionBar.CreateOverlay(i)

        if i == MIN_INDEX then
            overlay:SetAnchor(BOTTOMLEFT, weaponSwapControl, RIGHT, 0, -4)
        else
            overlay:SetAnchor(LEFT, FancyActionBar.overlays[i - 1], RIGHT, FancyActionBar.constants.abilitySlot.offsetX, 0)
        end

        lastButton = FancyActionBar.SetupBackbarButton(style, lastButton, i)
        FancyActionBar.SetupBackbarOverlay(style, i)
    end
end

--- Setup the backbar button with the given style.
--- @param style table
--- @param lastButton ActionButton
--- @param index number
--- @return ActionButton
function FancyActionBar.SetupBackbarButton(style, lastButton, index)
    --- @type ActionButton
    local button = FancyActionBar.buttons[index + SLOT_INDEX_OFFSET]
    button:ApplyStyle(style.buttonTemplate)
    button.icon:SetDesaturation(SV.desaturationInactive / 100)
    button.icon:SetAlpha(SV.alphaInactive / 100)

    FancyActionBar.SetupButtonStatus(button)

    if index == MIN_INDEX then
        button.slot:SetAnchor(TOPLEFT, weaponSwapControl, RIGHT, 0, 0)
    else
        button:ApplyAnchor(lastButton.slot, FancyActionBar.constants.abilitySlot.offsetX)
    end

    return button
end

--- Setup the backbar overlay with the given style.
--- @param style table
--- @param index number
function FancyActionBar.SetupBackbarOverlay(style, index)
    local overlay = FancyActionBar.CreateOverlay(index + SLOT_INDEX_OFFSET)

    if index == MIN_INDEX then
        overlay:SetAnchor(TOPLEFT, weaponSwapControl, RIGHT, 0, 0)
    else
        overlay:SetAnchor(LEFT, FancyActionBar.overlays[index + SLOT_INDEX_OFFSET - 1], RIGHT, FancyActionBar.constants.abilitySlot.offsetX, 0)
    end
end

---
--- @param active userdata
--- @param inactive userdata
--- @param firstTop boolean
--- @param locked boolean
--- @param inactiveHotbarCategory HotBarCategory
local function ApplyBarPosition(active, inactive, firstTop, locked, inactiveHotbarCategory)
    local barYOffset = (FancyActionBar.style == 2 and SV.barYOffsetGP or SV.barYOffsetKB or 0) / 2
    local barXOffset = (FancyActionBar.style == 2 and SV.barXOffsetGP or SV.barXOffsetKB or 0) / 2
    if locked == true and SV.repositionActiveBar then
        if active then
            active:SetAnchor(LEFT, weaponSwapControl, RIGHT, 0, 0, active:GetResizeToFitConstrains())
        end
        if inactive then
            inactive:SetAnchor(LEFT, weaponSwapControl, RIGHT, 0, 0, inactive:GetResizeToFitConstrains())
            FancyActionBar.ToggleOverlays(inactiveHotbarCategory)
        end
    elseif firstTop then
        if active then
            active:SetAnchor(BOTTOMLEFT, weaponSwapControl, RIGHT, 0 - barXOffset,
                -2 - barYOffset, active:GetResizeToFitConstrains())
        end
        if inactive then
            inactive:SetAnchor(TOPLEFT, weaponSwapControl, RIGHT, 0 + barXOffset,
                2 + barYOffset, inactive:GetResizeToFitConstrains())
            FancyActionBar.ToggleOverlays(inactiveHotbarCategory)
        end
    else
        if active then
            active:SetAnchor(TOPLEFT, weaponSwapControl, RIGHT, 0 + barXOffset,
                2 + barYOffset, active:GetResizeToFitConstrains())
        end
        if inactive then
            inactive:SetAnchor(BOTTOMLEFT, weaponSwapControl, RIGHT, 0 - barXOffset,
                -2 - barYOffset, inactive:GetResizeToFitConstrains())
            FancyActionBar.ToggleOverlays(inactiveHotbarCategory)
        end
    end
end

function FancyActionBar.SwapControls(locked) -- refresh action bars positions.
    local hide, activeBar, inactiveBar

    FancyActionBar.ClearAnchors()
    activeBar, inactiveBar, hide = FancyActionBar.DetermineBarAndHide(locked)

    FancyActionBar.SetBarPositions(inactiveBar)
    FancyActionBar.ToggleOverlays(inactiveBar)
    FancyActionBar.ToggleUltimateOverlays(hide)

    FancyActionBar.UpdateActiveBarIcons(activeBar)
    FancyActionBar.UpdateInactiveBarIcons(inactiveBar)
end

function FancyActionBar.ClearAnchors()
    if _G["ActionButton3"] then
        _G["ActionButton3"]:ClearAnchors()
    end
    if _G["ActionButton23"] then
        _G["ActionButton23"]:ClearAnchors()
    end
    if _G["ActionButtonOverlay3"] then
        _G["ActionButtonOverlay3"]:ClearAnchors()
    end
    if _G["ActionButtonOverlay23"] then
        _G["ActionButtonOverlay23"]:ClearAnchors()
    end
end

function FancyActionBar.DetermineBarAndHide(locked)
    local currentHotbarCategory = GetActiveHotbarCategory()
    if currentHotbarCategory == HOTBAR_CATEGORY_BACKUP then
        if SV.staticBars then
            ApplyBarPosition(_G["ActionButton23"], _G["ActionButton3"], SV.frontBarTop, locked, HOTBAR_CATEGORY_PRIMARY)
            ApplyBarPosition(_G["ActionButtonOverlay23"], _G["ActionButtonOverlay3"], not SV.frontBarTop, locked, HOTBAR_CATEGORY_PRIMARY)
        else
            ApplyBarPosition(_G["ActionButton3"], _G["ActionButton23"], SV.activeBarTop, locked, HOTBAR_CATEGORY_PRIMARY)
            ApplyBarPosition(_G["ActionButtonOverlay23"], _G["ActionButtonOverlay3"], SV.activeBarTop, locked, HOTBAR_CATEGORY_PRIMARY)
        end
        return HOTBAR_CATEGORY_BACKUP, HOTBAR_CATEGORY_PRIMARY, true
    else
        if SV.staticBars then
            ApplyBarPosition(_G["ActionButton3"], _G["ActionButton23"], SV.frontBarTop, locked, HOTBAR_CATEGORY_BACKUP)
            ApplyBarPosition(_G["ActionButtonOverlay23"], _G["ActionButtonOverlay3"], not SV.frontBarTop, locked, HOTBAR_CATEGORY_BACKUP)
        else
            ApplyBarPosition(_G["ActionButton3"], _G["ActionButton23"], SV.activeBarTop, locked, HOTBAR_CATEGORY_BACKUP)
            ApplyBarPosition(_G["ActionButtonOverlay3"], _G["ActionButtonOverlay23"], SV.activeBarTop, locked, HOTBAR_CATEGORY_BACKUP)
        end
        return HOTBAR_CATEGORY_PRIMARY, HOTBAR_CATEGORY_BACKUP, false
    end
end

function FancyActionBar.SetBarPositions(bar)
    local style = FancyActionBar.GetConstants()
    bar = bar or GetActiveHotbarCategory()
    for i = MIN_INDEX, MAX_INDEX do
        FancyActionBar.UpdateInactiveBarIcon(i, bar)
        local btnMain = ZO_ActionBar_GetButton(i)
        btnMain:HandleSlotChanged()
        FancyActionBar.SetupButtonText(btnMain, style, i)
    end
end

function FancyActionBar.ToggleInactiveBar(bar, hide)
    local showOffset = bar == HOTBAR_CATEGORY_PRIMARY and SLOT_INDEX_OFFSET or 0
    local hideOffset = bar == HOTBAR_CATEGORY_PRIMARY and 0 or SLOT_INDEX_OFFSET
    for i = MIN_INDEX, MAX_INDEX do
        local hideOverlay = FancyActionBar.overlays[i + hideOffset]
        local hideSlotHidden = FancyActionBar.slotHidden[i + hideOffset]
        if hideOverlay then
            hideOverlay:SetHidden(SV.hideInactiveSlots and hideSlotHidden or hide)
        end
        -- bar to hide
        local hideButton = FancyActionBar.GetActionButton(i + hideOffset)
        if hideButton then
            hideButton.slot:SetHidden(SV.hideInactiveSlots and hideSlotHidden or hide)
        end
        if not hide then
            local showOverlay = FancyActionBar.overlays[i + showOffset]
            local showSlotHidden = FancyActionBar.slotHidden[i + showOffset]
            if showOverlay then
                showOverlay:SetHidden(SV.hideInactiveSlots and showSlotHidden or hide)
            end
            local showButton = FancyActionBar.GetActionButton(i + showOffset)
            if showButton then
                showButton.slot:SetHidden(SV.hideInactiveSlots and showSlotHidden or hide)
            end
        end
    end
    FancyActionBar.SwapControls(hide)
end

function FancyActionBar.ToggleUltimateOverlays(hide)
    local ultOverlay = FancyActionBar.ultOverlays[ULT_INDEX]
    if ultOverlay then
        ultOverlay:SetHidden(hide)
    end
    local ultOverlayBackup = FancyActionBar.ultOverlays[ULT_INDEX + SLOT_INDEX_OFFSET]
    if ultOverlayBackup then
        ultOverlayBackup:SetHidden(not hide)
    end
end

function FancyActionBar.ToggleOverlays(bar)
    for i = MIN_INDEX, MAX_INDEX do
        local index = bar == HOTBAR_CATEGORY_BACKUP and i + SLOT_INDEX_OFFSET or i
        local overlay = FancyActionBar.overlays[index]
        local slotState = FancyActionBar.slotHidden[index]
        if overlay then
            overlay:SetHidden(SV.hideInactiveSlots and slotState or SV.hideLockedBar and isWeaponSwapLocked)
        end
    end
end

function FancyActionBar.UpdateActiveBarIcons(currentHotbarCategory)
    for i = MIN_INDEX, MAX_INDEX do
        local index = currentHotbarCategory == HOTBAR_CATEGORY_BACKUP and i + SLOT_INDEX_OFFSET or i
        local overlay = FancyActionBar.overlays[index]
        if overlay then
            overlay:SetHidden(false)
        end
    end
end

function FancyActionBar.UpdateInactiveBarIcons(bar)
    for i = MIN_INDEX, MAX_INDEX do
        FancyActionBar.UpdateInactiveBarIcon(bar == HOTBAR_CATEGORY_BACKUP and i + SLOT_INDEX_OFFSET or i, bar)
    end
end

function FancyActionBar.ApplyPosition() -- check if action bar should be moved.
    FancyActionBar.HideHotkeys(not SV.showHotkeys)
    if not SV.forceAzurahMover then
        FancyActionBar.MoveActionBar()
        if SV.forceReposition or not FancyActionBar.wasMoved then
            FancyActionBar.RepositionElements()
        end
    end
end

function FancyActionBar.UpdateBarSettings(locked) -- run all UI visual updates when UI mode is changed.
    FancyActionBar.UpdateStyle()
    FancyActionBar.SetScale()
    -- FancyActionBar.SetMoved(false)
    FancyActionBar.ApplyStyle()
    FancyActionBar.SwapControls(locked)
    FancyActionBar:AdjustControlsPositions()
    FancyActionBar.ApplyPosition()
    FancyActionBar.ApplyAbilityFxOverrides()
end

function FancyActionBar.SetScale() -- resize and check for other addons with same function
    local enable = FancyActionBar.constants.abScale.enable
    local s

    if enable and not SV.forceAzurahMover then
        local S = FancyActionBar.constants.abScale.scale
        s = S / 100
    else
        s = 1
    end

    scale = s
    FancyActionBar.UpdateScale(s)
end

--------------------------------------------------------------------------------
-------------------------------[    Hooks   ]-----------------------------------
--------------------------------------------------------------------------------
local origApplySwapAnimationStyle = ActionButton["ApplySwapAnimationStyle"]
local swapSize
local function ApplySwapAnimationStyle(button)
    local timeline = button.hotbarSwapAnimation

    if (timeline) then
        -- local size = FancyActionBar.style == 2 and 67 or 47
        -- local size = function() return GetUltimateFlipCardSize() end
        -- local size, _ = button.flipCard:GetDimensions()

        local firstAnimation = timeline:GetFirstAnimation()
        local lastAnimation = timeline:GetLastAnimation()

        firstAnimation:SetStartAndEndWidth(swapSize, swapSize)
        firstAnimation:SetStartAndEndHeight(swapSize, 0)
        lastAnimation:SetStartAndEndWidth(swapSize, swapSize)
        lastAnimation:SetStartAndEndHeight(0, swapSize)
    end
end

local origHideKeys = ActionButton["HideKeys"]
local function FancyHideKeys(self, hide)
    if SV and (not SV.showHotkeysUltGP) then
        hide = true
    end
    self.leftKey:SetHidden(hide)
    self.rightKey:SetHidden(hide)
end

ActionButton["HideKeys"] = FancyHideKeys

local origSetShowBindingText = ActionButton["SetShowBindingText"]
local function FancySetShowBindingText(self, visible)
    if SV and (not SV.showHotkeys) then
        visible = false
    end
    self.buttonText:SetHidden(not visible)
end

ActionButton["SetShowBindingText"] = FancySetShowBindingText

local origSetUltimateMeter = ActionButton["SetUltimateMeter"]
local function FancySetUltimateMeter(self, ultimateCount, setProgressNoAnim)
    local isSlotUsed = IsSlotUsed(ULT_INDEX, self.slot.hotbarCategory)
    local barTexture = GetControl(self.slot, "UltimateBar")
    local leadingEdge = GetControl(self.slot, "LeadingEdge")
    local ultimateReadyBurstTexture = GetControl(self.slot, "ReadyBurst")
    local ultimateReadyLoopTexture = GetControl(self.slot, "ReadyLoop")
    local ultimateFillLeftTexture = GetControl(self.slot, "FillAnimationLeft")
    local ultimateFillRightTexture = GetControl(self.slot, "FillAnimationRight")
    local ultimateFillFrame = GetControl(self.slot, "Frame")

    local isGamepad = false
    if FancyActionBar.useGamepadActionBar then
        isGamepad = true
    end
    if isSlotUsed then
        -- Show fill bar if platform appropriate
        ultimateFillFrame:SetHidden(not isGamepad)
        ultimateFillLeftTexture:SetHidden(not isGamepad)
        ultimateFillRightTexture:SetHidden(not isGamepad)

        -- Set textures for gamepad mode
        if isGamepad then
            ultimateFillLeftTexture:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
            ultimateFillRightTexture:SetTexture("FancyActionBar+/texture/gp_ultimatefill_512.dds")
            ultimateFillLeftTexture:SetWidth(70)
            ultimateFillRightTexture:SetWidth(70)
        end

        if ultimateCount >= self.currentUltimateMax then
            -- hide progress bar
            barTexture:SetHidden(true)
            leadingEdge:SetHidden(true)

            -- Set fill bar to full
            self:PlayUltimateFillAnimation(ultimateFillLeftTexture, ultimateFillRightTexture, 1, setProgressNoAnim)
            self:PlayUltimateReadyAnimations(ultimateReadyBurstTexture, ultimateReadyLoopTexture, setProgressNoAnim)
        else
            -- stop animation
            ultimateReadyBurstTexture:SetHidden(true)
            ultimateReadyLoopTexture:SetHidden(true)
            self:StopUltimateReadyAnimations()

            -- show platform appropriate progress bar
            barTexture:SetHidden(isGamepad)
            leadingEdge:SetHidden(isGamepad)

            -- update both platforms progress bars
            local slotHeight = FancyActionBar.constants.style.ultSize or self.slot:GetHeight()
            local percentComplete = (ultimateCount / self.currentUltimateMax)
            local yOffset = zo_floor(slotHeight * (0.97 - percentComplete)) -- changed from 1 cause normally the bar shows below the button when at 0 and my OCD can't handle.
            barTexture:SetHeight(yOffset)

            leadingEdge:ClearAnchors()
            leadingEdge:SetAnchor(TOPLEFT, nil, TOPLEFT, 0, yOffset - 5)
            leadingEdge:SetAnchor(TOPRIGHT, nil, TOPRIGHT, 0, yOffset - 5)

            self:PlayUltimateFillAnimation(ultimateFillLeftTexture, ultimateFillRightTexture, percentComplete, setProgressNoAnim)
            self:AnchorKeysOut()
        end

        self:UpdateUltimateNumber()
    else
        -- stop animation
        ultimateReadyBurstTexture:SetHidden(true)
        ultimateReadyLoopTexture:SetHidden(true)
        self:StopUltimateReadyAnimations()
        -- self:ResetUltimateFillAnimations()

        -- hide progress bar for all platforms
        barTexture:SetHidden(true)
        leadingEdge:SetHidden(true)
        ultimateFillLeftTexture:SetHidden(true)
        ultimateFillRightTexture:SetHidden(true)
        ultimateFillFrame:SetHidden(true)
        self:AnchorKeysOut()
    end
    -- self:HideKeys(not isGamepad)
end

ActionButton["SetUltimateMeter"] = FancySetUltimateMeter

local function SetAnimationParameters(timeline, control, shrinkScale, resetTime, isUltimateSlot)
    local style = FancyActionBar.GetConstants()
    local GROW_SCALE = 1.1
    local shrink = timeline:GetAnimation(1)
    local grow = timeline:GetAnimation(2)
    local reset = timeline:GetAnimation(3)
    local size = isUltimateSlot and style.ultFlipCardSize or style.flipCardSize

    shrink:SetStartAndEndWidth(size, size * shrinkScale)
    shrink:SetStartAndEndHeight(size, size * shrinkScale)

    grow:SetStartAndEndWidth(size * shrinkScale, size * GROW_SCALE)
    grow:SetStartAndEndHeight(size * shrinkScale, size * GROW_SCALE)

    reset:SetStartAndEndWidth(size * GROW_SCALE, size)
    reset:SetStartAndEndHeight(size * GROW_SCALE, size)
    reset:SetDuration(resetTime)
end

local origSetBounceAnimationParameters = ActionButton["SetBounceAnimationParameters"]
local function FancySetBounceAnimationParameters(self, cooldownTime)
    local SHRINK_SCALE = 0.9
    local ICON_SHRINK_SCALE = 0.8
    local FRAME_RESET_TIME_MS = 167
    local ICON_RESET_TIME_MS = 100
    local isUltimateSlot = ZO_ActionBar_IsUltimateSlot(self:GetSlot(), self:GetHotbarCategory())
    SetAnimationParameters(self.bounceAnimation, self.flipCard, SHRINK_SCALE, FRAME_RESET_TIME_MS, isUltimateSlot)
    SetAnimationParameters(self.iconBounceAnimation, self.icon, ICON_SHRINK_SCALE, ICON_RESET_TIME_MS, isUltimateSlot)
end

function FancyActionBar.UpdateStyle()
    local style = {}
    local mode

    if FancyActionBar.updateUI then
        mode = FancyActionBar.useGamepadActionBar and 2 or 1
    else
        if ADCUI then
            if ADCUI:originalIsInGamepadPreferredMode() or SV.forceGamepadStyle then
                if ADCUI:shouldUseGamepadUI() or SV.forceGamepadStyle then
                    mode = 2
                else
                    mode = ADCUI:shouldUseGamepadActionBar() or SV.forceGamepadStyle and 2 or 1
                end
            else
                mode = 1
            end
        else
            mode = FancyActionBar.useGamepadActionBar and 2 or 1
        end
    end

    if mode == 1 then
        style = KEYBOARD_CONSTANTS
        swapSize = 47
    else
        style = GAMEPAD_CONSTANTS
        swapSize = 67
    end
    -- style = mode == 1 and KEYBOARD_CONSTANTS or GAMEPAD_CONSTANTS
    FancyActionBar.style = mode
    FancyActionBar.constants = FancyActionBar:UpdateContants(mode, SV, style)

    FAB_Default_Bar_Position:ClearAnchors()
    FAB_Default_Bar_Position:SetAnchor(BOTTOM, GuiRoot, BOTTOM, FancyActionBar.constants.move.x, FancyActionBar.constants.move.y)

    ActionButton.ApplySwapAnimationStyle = ApplySwapAnimationStyle
    ActionButton.SetBounceAnimationParameters = SV.forceGamepadStyle and FancySetBounceAnimationParameters or origSetBounceAnimationParameters
    ZO_ActionBar_GetButton(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1):ApplySwapAnimationStyle()
end

-------------------------------------------------------------------------------
-----------------------------[  Helper & Debugging  ]--------------------------
-------------------------------------------------------------------------------
function FancyActionBar.IdentifyIndex(number, bar)
    local index
    if bar == HOTBAR_CATEGORY_BACKUP then
        if number == 8
        then
            index = ULT_INDEX + SLOT_INDEX_OFFSET
        else
            index = number + SLOT_INDEX_OFFSET
        end
    else
        index = number
    end
    return index
end

function FancyActionBar.IdCheck(index, id)
    local craftedId = GetAbilityCraftedAbilityId(id)
    if craftedId ~= 0 then
        local scripts = { GetCraftedAbilityActiveScriptIds(craftedId) }
        local scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
        if abilityConfig[id] and ((abilityConfig[id] == false) or (abilityConfig[id][scriptKey] and abilityConfig[id][scriptKey][1] == false)) then
            return false
        end
    else
        if abilityConfig[id] and abilityConfig[id] == false then
            return false
        end
    end


    if slottedIds[index] ~= nil and slottedIds[index].ability ~= slottedIds[index].effect then
        if FancyActionBar.toggled[id] then
            return true
        end
        if FancyActionBar.specialEffects[id] then
            return true
        end
    end
    return true
end

function FancyActionBar.PostEffectUpdate(name, id, change, duration, stacks, when)
    if id == 61744 then
        return
    end
    if duration == 0 then
        if not FancyActionBar.toggled[id] then
            return
        end
    end
    local type
    if change == EFFECT_RESULT_GAINED then
        type = "Gained"
    elseif change == EFFECT_RESULT_UPDATED then
        type = "Updated"
    end
    local stack = "."
    if (stacks ~= nil and stacks ~= 0) then
        stack = " (x" .. stacks .. ")."
    end
    FancyActionBar.AddSystemMessage("[<<2>> (<<3>>)] <<1>>: <<4>><<5>>", type, name, id, strformat("%0.1fs", duration), stack)
end

function FancyActionBar.PostEffectFade(name, id, tag)
    if tag then
        if string.find(tag, "companion") then
            return
        end
    end
    local uptime = strformat("%0.3fs", FancyActionBar.activeCasts[id].fade - FancyActionBar.activeCasts[id].begin)
    local delay = "."
    if FancyActionBar.activeCasts[id].cast > 0 then
        delay = strformat(" (%0.3fs).", FancyActionBar.activeCasts[id].fade - FancyActionBar.activeCasts[id].cast)
    end
    FancyActionBar.AddSystemMessage("[<<1>> (<<2>>)] faded after <<3>><<4>>", name, id, uptime, delay)
    FancyActionBar.activeCasts[id] = nil
end

function FancyActionBar.PostAllChanges(e, change, eSlot, eName, tag, gain, fade, stacks, icon, bType, eType, aType, seType, uName, unitId, aId, sType)
    if FancyActionBar.ignore[aId] then
        return
    end
    -- if GetAbilityBuffType(aId) and GetAbilityBuffType(aId) ~= BUFF_TYPE_NONE then return end
    -- if aType == 0 then return end -- passives (annoying when bar swapping)

    if FancyActionBar.IsGroupUnit(tag) then
        if AreUnitsEqual("player", tag) then
            return
        end -- filter doubles from 'player' and players 'group' tags.
    end

    local types =
    {
        [EFFECT_RESULT_GAINED] = "Gained",
        [EFFECT_RESULT_FADED] = "Faded",
        [EFFECT_RESULT_UPDATED] = "Updated",
        [EFFECT_RESULT_FULL_REFRESH] = "Refreshed",
        [EFFECT_RESULT_TRANSFER] = "Transfered",
    }
    local ts = tostring
    local type = types[change] or "?"
    local dur, s

    if (fade ~= nil and gain ~= nil)
    then
        dur = strformat(" %0.1f", fade - gain) .. "s"
    else
        dur = 0
    end

    if stacks and stacks ~= 0
    then
        s = " x" .. ts(stacks) .. "."
    else
        s = "."
    end

    if not SV.debugVerbose then
        if change == EFFECT_RESULT_FADED
        then
            FancyActionBar.AddSystemMessage("[" .. ts(aId) .. "] " .. eName .. ": " .. type .. " --> " .. uName)
        else
            FancyActionBar.AddSystemMessage("[" .. ts(aId) .. "] " .. eName .. ": " .. type .. " --> " .. uName .. dur .. s)
        end
    else
        FancyActionBar.AddSystemMessage(eName .. " (" .. ts(aId) .. ")" .. "\nchange: " .. types[change] .. " || stacks: " .. ts(stacks) .. " || duration: " .. ts(dur) .. " || slot: " .. ts(eSlot) .. " || tag: " .. ts(tag) .. " || unit: " .. ts(uName) .. " || unitId: " .. ts(unitId) .. " || buffType: " .. bType .. " || effectType: " .. ts(eType) .. " || abilityType: " .. ts(aType) .. " || statusEffectType: " .. ts(seType) .. "\n===================")
    end
end

function FancyActionBar.UnitCheck(unitTag, unitId)
    if unitId ~= nil then
        if (not AreUnitsEqual("player", unitTag)) then
            return true
        end
        if unitTag == "" then
            return true
        end
    end
    return false
end

function FancyActionBar.ShouldTrackAsDebuff(id, tag)
    if not SV.advancedDebuff then
        return false
    end
    if id == 38791 then
        return false
    end -- ZoS seem to think that Stampede is a debuff and not a ground effect :S
    if tag ~= nil then
        if AreUnitsEqual("player", tag) or FancyActionBar.IsGroupUnit(tag) then
            return false
        end
    end
    return true
end

function FancyActionBar.ShouldHideIfNotOnTarget(Id) -- a setting I didn't finish making yet.
    local hide
    if FancyActionBar.constants.hideOnNoTargetList[Id]
    then
        hide = FancyActionBar.constants.hideOnNoTargetList[Id]
    else
        hide = FancyActionBar.constants.hideOnNoTargetGlobal
    end
    return hide
end

function FancyActionBar.HandleSpecialEffect(id, change, updateTime, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
    local specialEffect = ZO_DeepTableCopy(FancyActionBar.specialEffects[id])
    if specialEffect.handler then
        if specialEffect.handler == "device" then
            FancyActionBar.HandleDevice(id, specialEffect, change, updateTime, beginTime, endTime)
        end
        return
    end

    for effectId, effect in pairs(FancyActionBar.effects) do
        if effect.id == specialEffect.id then
            FancyActionBar.UpdateSpecialEffect(effect, specialEffect, change, updateTime, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
            FancyActionBar.UpdateEffect(effect)
            FancyActionBar.HandleStackUpdate(effect.id)
        end
    end
end

function FancyActionBar.UpdateSpecialEffect(effect, specialEffect, change, updateTime, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
    if change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED then
        effect.beginTime = updateTime
        effect.endTime = (specialEffect.setTime and (specialEffect.duration + updateTime)) or endTime

        local targetType = GetAbilityTargetDescription(effect.id, nil, unitTag)
        if specialEffect.isMultiTarget and (not SV.multiTargetBlacklist[effect.id]) and (abilityType ~= GROUND_EFFECT) and (targetType ~= "Self") then
            local targetData = FancyActionBar.targets[effect.id] or { targetCount = 0, maxEndTime = 0, times = {} }
            targetData.maxEndTime = zo_max(endTime, targetData.maxEndTime)
            targetData.times[unitId] = { beginTime = effect.beginTime, endTime = effect.endTime }
            FancyActionBar.targets[effect.id] = targetData
            FancyActionBar.CheckTargetEndtimes(effect.id)
            FancyActionBar.HandleTargetUpdate(effect.id)
        end

        if specialEffect.stacks then
            FancyActionBar.stacks[specialEffect.stackId[1]] = specialEffect.stacks
        elseif effect.stackId and #effect.stackId > 0 and stackCount then
            FancyActionBar.stacks[specialEffect.stackId[1]] = stackCount
        end
        for k, v in pairs(specialEffect) do
            effect[k] = v
        end

        FancyActionBar.effects[effect.id] = effect
        if FancyActionBar.activeCasts[effect.id] then
            FancyActionBar.activeCasts[effect.id].begin = updateTime
        end
    elseif change == EFFECT_RESULT_FADED then
        FancyActionBar.HandleEffectFade(effect, specialEffect, updateTime, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
    end
end

function FancyActionBar.HandleEffectFade(effect, specialEffect, updateTime, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
    -- Early return if effect was too recent
    if effect.beginTime and (updateTime - effect.beginTime < 0.3) then
        return
    end

    -- Handle multi-target effects
    if specialEffect.isMultiTarget and FancyActionBar.targets[effect.id] then
        local targetCount = FancyActionBar.HandleMultiTargetFade(effect.id, unitId)
        if targetCount >= 1 then
            return
        end
    end

    -- Check proc state compatibility
    if effect.hasProced and specialEffect.hasProced and effect.hasProced ~= specialEffect.hasProced then
        return
    end

    -- Handle special effect procs
    if FancyActionBar.specialEffectProcs[effect.id] then
        local success = FancyActionBar.UpdateEffectProcs(effect, specialEffect, stackCount)
        if not success then
            -- If proc update fails, just update the end time
            effect.endTime = endTime
            FancyActionBar.UpdateEffect(effect)
            return
        end
    end

    -- Update effect end time and trigger update
    effect.endTime = endTime
    FancyActionBar.UpdateEffect(effect)
end

-- function to handle multi-target fade
function FancyActionBar.HandleMultiTargetFade(effectId, unitId)
    local targetData = FancyActionBar.targets[effectId]
    if not targetData then return 0 end

    targetData.times[unitId] = nil
    FancyActionBar.targets[effectId] = targetData

    local targetCount = FancyActionBar.CheckTargetEndtimes(effectId)
    FancyActionBar.HandleTargetUpdate(effectId, true)

    return targetCount
end

-- function to update effect procs
function FancyActionBar.UpdateEffectProcs(effect, specialEffect, stackCount)
    local procUpdates = FancyActionBar.specialEffectProcs[effect.id]
    if not procUpdates then return false end

    local procValues = procUpdates[effect.procs]
    if not procValues then return false end

    -- Update effect values from proc
    for key, value in pairs(procValues) do
        effect[key] = value
    end

    -- Handle stacks
    if effect.stackId and #effect.stackId > 0 then
        local stackId = effect.stackId[1]
        if effect.stacks then
            FancyActionBar.stacks[stackId] = effect.stacks
        elseif stackCount then
            FancyActionBar.stacks[stackId] = stackCount
        end
    end

    FancyActionBar.effects[effect.id] = effect
    return true
end

function FancyActionBar.HandleDevice(id, specialEffect, change, updateTime, beginTime, endTime)
    local parentId = specialEffect.id
    local allowMulti = specialEffect.allowMulti
    local duration = specialEffect.duration or 0

    -- Ensure parent effect entry
    local parentEffect = FancyActionBar.effects[parentId]
    if not parentEffect then
        parentEffect = { id = parentId, instances = {} }
        FancyActionBar.effects[parentId] = parentEffect
    end
    parentEffect.instances = parentEffect.instances or {}
    local instances = parentEffect.instances

    if change == EFFECT_RESULT_GAINED then
        if not allowMulti and id ~= parentId then
            local existing = FancyActionBar.effects[id]
            if existing and existing.beginTime and (updateTime - existing.beginTime < 0.3) then
                return
            end
        end

        local instance =
        {
            id = id,
            beginTime = beginTime,
            endTime = endTime,
            isDevice = not allowMulti,
        }

        if allowMulti then
            table.insert(instances, instance)
        else
            FancyActionBar.effects[id] = instance
            instances[id] = instance
        end
    elseif change == EFFECT_RESULT_FADED then
        if not allowMulti then
            local inst = FancyActionBar.effects[id]
            if inst and inst.beginTime and (updateTime - inst.beginTime < 0.3) then
                return -- skip recast fade
            end
            FancyActionBar.effects[id] = nil
            instances[id] = nil
        else
            -- Remove the instance matching this id
            local removeIndex = nil
            for i, inst in ipairs(instances) do
                if inst.id == id then
                    removeIndex = i
                    break
                end
            end
            if removeIndex then
                table.remove(instances, removeIndex)
            end
        end

        -- If the fade is for the parent ability, wipe all devices
        if not allowMulti and id == parentId then
            for instId, instData in pairs(instances) do
                FancyActionBar.effects[instId] = nil
            end
            parentEffect.instances = {}
        end
    end

    -- Aggregate timing info
    local stackCount, latestBegin, soonestEnd, latestEnd = 0, 0, nil, nil
    for _, inst in pairs(instances) do
        if inst.endTime > updateTime then
            stackCount = stackCount + 1
            if inst.beginTime > latestBegin then latestBegin = inst.beginTime end
            if not soonestEnd or inst.endTime < soonestEnd then soonestEnd = inst.endTime end
            if not latestEnd or inst.endTime > latestEnd then latestEnd = inst.endTime end
        end
    end

    -- Compute effective end time
    local effectiveEndTime = 0
    if stackCount > 0 then
        if SV.showSoonestExpire then
            effectiveEndTime = soonestEnd
        else
            effectiveEndTime = latestEnd
            local extended = latestBegin + duration + 0.5
            if extended > updateTime and extended > effectiveEndTime then
                effectiveEndTime = extended
            end
        end
    end

    parentEffect.endTime = effectiveEndTime
    FancyActionBar.stacks[parentId] = stackCount
    FancyActionBar.UpdateEffect(parentEffect)
    FancyActionBar.HandleStackUpdate(parentId)
end

function FancyActionBar.RefreshEffects()
    FancyActionBar.activeCasts = {}
    FancyActionBar.toggles = {}

    for effect, data in pairs(FancyActionBar.effects) do
        data.endTime = 0
    end

    for id in pairs(FancyActionBar.stacks) do
        local _, _, currentStacks = FancyActionBar.CheckForActiveEffect(id)
        FancyActionBar.stacks[id] = currentStacks or 0
        FancyActionBar.HandleStackUpdate(id)

        -- if (id == 61905 or id == 61919 or id == 61927) then
        --     if GFC then
        --         local _
        --         GFC.OnEffectChanged(_, 2, _, GetAbilityName(id), "player", _, _, 1, _, _, _, _, _, _, _, id)
        --         GFC.UpdateStacks(0)
        --     end
        -- end
    end

    local t = time()

    for i = 1, GetNumBuffs("player") do
        local name, beginTime, endTime, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", i)

        if not castByPlayer then
            if SV.externalBuffs then --[[and not SV.externalBlackList[abilityId] then]]
                local effect = FancyActionBar.effects[abilityId]
                if effect and not SV.externalBlackList[abilityId] then
                    if beginTime == endTime then
                        FancyActionBar.UpdatePassiveEffect(effect.id, true)
                    else
                        if (not FancyActionBar.activeCasts[effect.id] --[[and effect.id ~= 61744]]) then
                            local slot = nil
                            if effect.slot1 then
                                slot = effect.slot1
                            elseif effect.slot2 then
                                slot = effect.slot2
                            end
                            FancyActionBar.activeCasts[effect.id] = { slot = slot, cast = 0, begin = 0, fade = 0 }
                        end
                        if endTime - t > 0 then
                            FancyActionBar.activeCasts[effect.id].begin = beginTime
                            effect.endTime = endTime
                            FancyActionBar.UpdateEffect(effect)
                        end
                    end
                end
            end
        else
            if FancyActionBar.stackMap[abilityId] then
                if FancyActionBar.fixedStacks[abilityId] then
                    stackCount = FancyActionBar.fixedStacks[abilityId]
                end
                for id, effect in pairs(FancyActionBar.effects) do
                    if effect.stackId and #effect.stackId > 0 then
                        for j = 1, #effect.stackId do
                            if effect.stackId[j] == abilityId then
                                FancyActionBar.stacks[abilityId] = stackCount or 0
                                FancyActionBar.HandleStackUpdate(id)
                            end
                        end
                    end
                end
            end
            local updateToggleEffect = false
            if FancyActionBar.bannerBearer[abilityId] then
                for k, v in pairs(FancyActionBar.bannerBearer) do
                    if sourceAbilities[k] then
                        FancyActionBar.toggles[sourceAbilities[k]] = true
                        FancyActionBar.effects[sourceAbilities[k]].beginTime = (beginTime ~= 0) and beginTime or t
                        FancyActionBar.UpdateToggledAbility(abilityId, true)
                        return
                    end
                end
            elseif FancyActionBar.toggled[abilityId] then -- update the highlight of toggled abilities.
                local toggleAbility = sourceAbilities[abilityId] and sourceAbilities[abilityId] or abilityId
                FancyActionBar.UpdateToggledAbility(toggleAbility, true)
                return
            end
            if (abilityId == 61905 or abilityId == 61919 or abilityId == 61927) then
                if GFC then -- Manually update GrimFocusCounter if enabled
                    local _
                    GFC.OnEffectChanged(_, 3, _, GetAbilityName(abilityId), "player", _, _, 0, _, _, _, _, _, _, _, abilityId)
                end
            end

            local effect = FancyActionBar.effects[abilityId]
            if effect then
                if endTime - t > 0 then
                    if not FancyActionBar.activeCasts[effect.id] then
                        local slot = nil
                        if effect.slot1 then
                            slot = effect.slot1
                        elseif effect.slot2 then
                            slot = effect.slot2
                        end
                        FancyActionBar.activeCasts[effect.id] = { slot = slot, cast = 0, begin = 0, fade = 0 }
                    end

                    if FancyActionBar.activeCasts[effect.id] then
                        FancyActionBar.activeCasts[effect.id].begin = beginTime
                        effect.endTime = endTime
                        FancyActionBar.UpdateEffect(effect)
                    end
                end
            end
        end
    end
end

-- local groundString    = GetString(SI_ABILITY_TOOLTIP_TARGET_TYPE_GROUND)
-- local groundAbilities = {}
-- local LAST_ABILITY    = 0
-- local LAST_BUTTON     = 0
--
-- local function CheckGroundAbility(id)
-- 	local result = groundAbilities[id]
-- 	if result == nil then
-- 		result = GetAbilityTargetDescription(id) == groundString
-- 		groundAbilities[id] = result
-- 	end
-- 	return result
-- end

-------------------------------------------------------------------------------
-----------------------------[      Initialize      ]--------------------------
-------------------------------------------------------------------------------
local noget = false

local function SetAbilityBarTimersEnabled()
    if tonumber(GetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR_TIMERS)) == 0 then
        SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR_TIMERS, "true")
    end
end

-- Update actionId for backbar buttons
function FancyActionBar.UpdateBackbarButtonActionIds()
    for i = MIN_INDEX + SLOT_INDEX_OFFSET, MAX_INDEX + SLOT_INDEX_OFFSET do
        local button = FancyActionBar.buttons[i]
        if button and button.button then
            -- Update actionId properly using original slot number without offset
            button.button.actionId = FancyActionBar.GetSlotBoundAbilityId(i - SLOT_INDEX_OFFSET, HOTBAR_CATEGORY_BACKUP)
        end
    end
end

-- Call this function after slot changes or bar swap
local function OnSlotChanged(_, slotNum, hotbarCategory)
    if slotNum < MIN_INDEX or slotNum > ULT_INDEX then return end
    -- local style = FancyActionBar.GetConstants()
    local currentHotbarCategory = GetActiveHotbarCategory()
    local slotIndex = hotbarCategory == HOTBAR_CATEGORY_BACKUP and slotNum + SLOT_INDEX_OFFSET or slotNum
    if hotbarCategory == currentHotbarCategory then
        local btn = FancyActionBar.GetActionButton(slotNum)
        if btn then
            btn:HandleSlotChanged()
        end
        if SV.applyActionBarSkillStyles then
            FancyActionBar.SetActionButtonAbilityFxOverride(slotNum)
        end
        -- FancyActionBar.SetupButtonText(btn, style, slotIndex)
    else
        FancyActionBar.UpdateInactiveBarIcon(slotNum, currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY and HOTBAR_CATEGORY_BACKUP or HOTBAR_CATEGORY_PRIMARY)
    end

    if (slotIndex == ULT_INDEX or slotIndex == ULT_INDEX + SLOT_INDEX_OFFSET) then
        FancyActionBar.UpdateUltimateCost()
    end
    FancyActionBar.UpdateSlottedSkillsDecriptions()
    FancyActionBar.UpdateBackbarButtonActionIds() -- Update backbar button actionIds

    -- FancyActionBar.AddSystemMessage('Slot ' .. tostring(slotNum) .. ' changed')
end

-- Button (usable) state changed.
local function OnHotbarSlotStateUpdated(_, slot, hotbar)
    if IsPlayerGroundTargeting() then
        zo_callLater(function ()
            OnHotbarSlotStateUpdated(_, slot, hotbar)
        end, 1)
        return
    end
    local isBlockActive = IsBlockActive()
    local blockCancelled = (isBlockActive and (wasBlockActive == false)) or (wasBlockActive and (isBlockActive == false) and (isChanneling == false))
    if blockCancelled then
        channeledAbilityUsed = nil
        isChanneling = false
    end

    local btn = ZO_ActionBar_GetButton(slot)
    if btn then
        btn:UpdateState()
        -- FancyActionBar.SetActionButtonAbilityFxOverride(n);
        if channeledAbilityUsed then
            local currentTime = time()
            local latencyAdjust = zo_max(GetLatency(), 150) + 200
            local effect = FancyActionBar.effects[channeledAbilityUsed]
            if effect.castEndTime and (effect.castEndTime > (currentTime + latencyAdjust)) then
                effect.castEndTime = 0
                wasBlockActive = isBlockActive
                channeledAbilityUsed = nil
                isChanneling = false
                return
            end
            local adjustFatecarver = (effect.channeledId == 183122 or effect.channeledId == 193397)
            local stackIds = effect.stackId
            local stacks = 0
            if stackIds and #stackIds > 0 then
                for i = 1, #stackIds do
                    if stackIds[i] == 184220 then
                        stacks = FancyActionBar.stacks[184220] or 0
                        break
                    end
                end
            end
            local adjust = adjustFatecarver and (stacks * .338) or 0
            effect.castEndTime = effect.castDuration and (effect.castDuration + adjust + time()) or 0
            wasBlockActive = isBlockActive
            channeledAbilityUsed = nil
            isChanneling = true
        end
    end
end

-- Set Bar Settings for hideLockedBar mode and/or apply AbilityFxOverrides
local function OnActiveHotbarUpdated(_, didActiveHotbarChange, shouldUpdateAbilityAssignments, activeHotbarCategory)
    if specialHotbar[activeHotbarCategory] then
        specialHotbarActive = true
        if SV.hideLockedBar == true then
            FancyActionBar.OnWeaponSwapLocked(specialHotbarActive, isWeaponSwapLocked)
        end
        FancyActionBar.SlotEffects()
        FancyActionBar.RefreshEffects()
    elseif didActiveHotbarChange and specialHotbarActive and not specialHotbar[activeHotbarCategory] then
        specialHotbarActive = false
        if FancyActionBar.oakensoulEquipped then
            FancyActionBar.SlotEffects()
            return
        end
        if SV.hideLockedBar == true then
            FancyActionBar.OnWeaponSwapLocked(specialHotbarActive, isWeaponSwapLocked)
        else
            isWeaponSwapLocked = false
        end
        FancyActionBar.SwapControls(specialHotbarActive)
        FancyActionBar.SlotEffects()
        FancyActionBar.RefreshEffects()
    end
    FancyActionBar.UpdateUltimateCost()
    FancyActionBar.ApplyAbilityFxOverrides()
end

-- Any skill swapped. Setup buttons and slot effects.
local function OnAllHotbarsUpdated()
    local style = FancyActionBar.GetConstants()
    local currentHotbarCategory = GetActiveHotbarCategory()
    local ultButton = ZO_ActionBar_GetButton(ULT_INDEX)
    if ultButton then
        ultButton.showTimer = false
    end
    for i = MIN_INDEX, MAX_INDEX do -- ULT_INDEX do
        local button = ZO_ActionBar_GetButton(i)
        if button then
            button.hotbarSwapAnimation = nil -- delete default animation
            button.noUpdates = true          -- disable animation updates
            button.showTimer = false
            button.stackCountText:SetHidden(true)
            button.timerText:SetHidden(true)
            button.timerOverlay:SetHidden(true)
            button:HandleSlotChanged() -- update slot manually
            button.buttonText:SetHidden(not SV.showHotkeys)
        end
        if (currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY or currentHotbarCategory == HOTBAR_CATEGORY_BACKUP) then
            local altbutton = ZO_ActionBar_GetButton(i, currentHotbarCategory == HOTBAR_CATEGORY_PRIMARY and HOTBAR_CATEGORY_BACKUP or HOTBAR_CATEGORY_PRIMARY)
            if altbutton then
                altbutton.noUpdates = true
                altbutton.showTimer = false
                altbutton.showBackRowSlot = false
            end
        end
    end
    FancyActionBar.SlotEffects()
    FancyActionBar.ToggleUltimateValue()
    FancyActionBar.SetUltFrameAlpha()
    FancyActionBar.UpdateSlottedSkillsDecriptions()
    FancyActionBar.EffectCheck()
    FancyActionBar.ApplyAbilityFxOverrides()
    FancyActionBar.UpdateBackbarButtonActionIds() -- Update backbar button actionIds
end

local function OnArmory()
    FancyActionBar.weaponFront = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_MAIN_HAND, LINK_STYLE_DEFAULT))
    FancyActionBar.weaponBack = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN, LINK_STYLE_DEFAULT))
    local wasOakensoulEquipped = FancyActionBar.oakensoulEquipped
    local isOakensoulEquipped = (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING1) == FancyActionBar.oakensoul) or
        (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING2) == FancyActionBar.oakensoul)
    FancyActionBar.oakensoulEquipped = isOakensoulEquipped
    if SV.hideLockedBar and isOakensoulEquipped or wasOakensoulEquipped then
        FancyActionBar.OnWeaponSwapLocked(isOakensoulEquipped, isWeaponSwapLocked)
    end
    OnAllHotbarsUpdated()
end

local function OnActiveWeaponPairChanged(eventCode, activeWeaponPair)
    if activeWeaponPair ~= currentWeaponPair then
        channeledAbilityUsed = nil
        isChanneling = false
        FancyActionBar.SwapControls(isWeaponSwapLocked)
        currentWeaponPair = activeWeaponPair
        FancyActionBar.UpdateBackbarButtonActionIds() -- Update backbar button actionIds after weapon swap
    end
end

-- IsAbilityUltimate(*integer* _abilityId_)
local function OnAbilityUsed(_, n)
    local currentHotbarCategory = GetActiveHotbarCategory()
    if (n >= MIN_INDEX and n <= ULT_INDEX) then -- or n == (ULT_INDEX + SLOT_INDEX_OFFSET) then
        -- local duration = t + (GetActionSlotEffectTimeRemaining(n, currentHotbarCategory) / 1000)
        local id = FancyActionBar.GetSlotBoundAbilityId(n, currentHotbarCategory)
        local index = FancyActionBar.IdentifyIndex(n, currentHotbarCategory)
        local name = GetAbilityName(id)
        local t = time()
        local effect = FancyActionBar.SlotEffect(index, id)
        -- local effect = FancyActionBar.effects[id]
        local i = FancyActionBar.GetSlottedEffect(index)
        -- lastButton = index
        local idCheck = FancyActionBar.IdCheck(index, id)
        if SV.forceGamepadStyle and n ~= ULT_INDEX then
            local btn = ZO_ActionBar_GetButton(n)
            if btn then
                btn:PlayAbilityUsedBounce()
                btn:PlayGlow()
            end
        end

        if (i and FancyActionBar.activeCasts[i] == nil and not FancyActionBar.ignore[id]) and not (idCheck == false) then -- track when the skill was used and ignore other events for it that is lower than the GCD
            FancyActionBar.activeCasts[i] = { slot = index, cast = t, begin = 0, fade = 0 }
        end

        if idCheck == false then
            local E = FancyActionBar.effects[i]
            if E then
                if FancyActionBar.activeCasts[E.id] then
                    FancyActionBar.activeCasts[E.id].cast = t
                end
                local D = E.toggled == true and "0" or tostring((GetAbilityDuration(i) or 0) / 1000)
                FancyActionBar.AddSystemMessage("4 [ActionButton%d]<%s> #%d: " .. D, index, name, E.id)
                -- return
            end
        end

        if effect and FancyActionBar.toggled[effect.id] then
            local o = not FancyActionBar.toggles[effect.id]
            local O = o == true and "On" or "Off"
            FancyActionBar.AddSystemMessage("3 [ActionButton%d]<%s> #%d: " .. O .. ".", index, name, effect.id)
        end

        if effect then
            if effect.id ~= id then
                local e = FancyActionBar.effects[i]
                if e then
                    FancyActionBar.AddSystemMessage("2 [ActionButton%d]<%s> #%d: %0.1fs", index, name, i, e.toggled == true and 0 or (GetAbilityDuration(e.id) or 0) / 1000)
                    if SV.showCastDuration then
                        wasBlockActive = IsBlockActive()
                        local isChanneled, castDuration = GetAbilityCastInfo(id, nil, "player") --[[(e.id == e.stackId and e.id or id);]]
                        castDuration = castDuration and (castDuration > 1000) and (castDuration / 1000) or nil
                        if castDuration then
                            e.castDuration = castDuration
                            e.channeledId = id
                            channeledAbilityUsed = e.id
                        else
                            e.castDuration = nil
                            e.channeledId = nil
                            channeledAbilityUsed = nil
                        end
                    end
                end
            else
                if effect.duration and not effect.custom then
                    FancyActionBar.AddSystemMessage("1 [ActionButton%d]<%s> #%d: %0.1fs", index, name, effect.id, (GetAbilityDuration(effect.id) or 0) / 1000)
                elseif FancyActionBar.specialEffects[id] then
                    local specialEffect = ZO_DeepTableCopy(FancyActionBar.specialEffects[id])
                    if not specialEffect.onAbilityUsed then
                        return
                    end
                    if FancyActionBar.traps[id] and SV.ignoreTrapPlacement then
                        return
                    end
                    for k, v in pairs(specialEffect) do
                        effect[k] = v
                    end
                    effect.beginTime = t
                    effect.endTime = ((specialEffect.setTime and specialEffect.duration) or effect.duration or 0) + t
                    FancyActionBar.UpdateEffect(effect)
                    if specialEffect.stacks then
                        FancyActionBar.stacks[specialEffect.stackId[1] or specialEffect.id] = specialEffect.stacks
                        FancyActionBar.HandleStackUpdate(effect.id)
                    end
                    FancyActionBar.AddSystemMessage("0 [ActionButton%d]<%s> #%d: %0.1fs", index, name, effect.id, (GetAbilityDuration(effect.id) or 0) / 1000)
                end
                if SV.showCastDuration then
                    wasBlockActive = IsBlockActive()
                    local isChanneled, castDuration = GetAbilityCastInfo(effect.id, nil, "player")
                    castDuration = castDuration and (castDuration > 1000) and (castDuration / 1000) or nil
                    if castDuration then
                        effect.castDuration = castDuration
                        effect.channeledId = effect.id
                        channeledAbilityUsed = effect.id
                    else
                        effect.castDuration = nil
                        effect.channeledId = nil
                        channeledAbilityUsed = nil
                    end
                end
            end
        elseif FancyActionBar.effects[i] then
            FancyActionBar.AddSystemMessage("? [ActionButton%d]<%s> #%d: %0.1fs", index, name, FancyActionBar.effects[i].id, (GetAbilityDuration(FancyActionBar.effects[i].id) or 0) / 1000)
        else
            FancyActionBar.AddSystemMessage("[ActionButton%d] #%d: %0.1fs", index, id, GetAbilityDuration(id))
        end
    end
end

local function OnActionSlotEffectUpdated(_, hotbarCategory, actionSlotIndex)
    local stackCount
    local t = time()
    local abilityId = FancyActionBar.GetSlotBoundAbilityId(actionSlotIndex, hotbarCategory)
    if FancyActionBar.specialEffects[abilityId] or SV.parentTimeBlacklist[abilityId] then
        return
    end

    local effect = FancyActionBar.effects[abilityId]
    -- Effect must be slotted and not have custom duration specified in config.lua
    if effect and (not effect.custom) or SV.allowParentTime then
        if not effect then
            if SV.allowParentTime then
                effect = { id = abilityId }
                FancyActionBar.effects[abilityId] = effect
            else
                return
            end
        end
        effect.slotEffecTime = SV.allowParentTime
        local duration = (GetActionSlotEffectDuration(actionSlotIndex, hotbarCategory) or 0) / 1000
        local effectDuration = (GetAbilityDuration(abilityId) or 0) / 1000
        if duration ~= effectDuration then
            effect.ignoreFadeTime = true
        else
            effect.ignoreFadeTime = false
        end
        duration = duration > FancyActionBar.durationMin and duration < FancyActionBar.durationMax and duration or -1

        local remain = GetActionSlotEffectTimeRemaining(actionSlotIndex, hotbarCategory) / 1000
        -- remain = remain > FancyActionBar.durationMin and remain < FancyActionBar.durationMax and remain or -1
        if effect.isChanneled --[[ and effect.castDuration and isChanneling ]] then
            effect.castEndTime = t + remain
        else
            if effect.castDuration then
                effect.castDuration = nil
            end
            -- Adjustment for Power of the Light.
            -- TODO: find a better place to do it.
            if SV.potlfix and remain > 6 and effect.id == 21763 then
                remain = 6
            end

            if FancyActionBar.dontFade[effect.id] and remain < FancyActionBar.durationMin then return end

            local hasValidDuration = (effect.duration or -1) > 0 or duration > 0
            effect.duration = hasValidDuration and duration or nil
            effect.beginTime = t - (duration - remain)
            effect.endTime = hasValidDuration and (t + remain) or -1
            FancyActionBar.UpdateEffect(effect)

            -- else
            -- effect.endTime = 0
        end
        if FancyActionBar.stackableBuff[abilityId] then
            local stackableBuffId = FancyActionBar.stackableBuff[abilityId]
            _, _, stackCount = FancyActionBar.CheckForActiveEffect(stackableBuffId)
            FancyActionBar.stacks[stackableBuffId] = stackCount
        else
            stackCount = GetActionSlotEffectStackCount(actionSlotIndex, hotbarCategory)
        end
        if not FancyActionBar.fixedStacks[abilityId] then
            for id, knownEffect in pairs(FancyActionBar.effects) do
                if knownEffect.stackId and #knownEffect.stackId > 0 then
                    for j = 1, #knownEffect.stackId do
                        if knownEffect.stackId[j] == abilityId then
                            FancyActionBar.stacks[abilityId] = stackCount or 0
                            FancyActionBar.HandleStackUpdate(id)
                        end
                    end
                end
            end
        end
    end
end

local lastCW = 0 -- track when last crystal weapon debuff was applied
local function OnEffectChanged(eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    if SV.debugAll then
        FancyActionBar.PostAllChanges(eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    end
    local _
    local t = time()
    local isTargetPlayer = AreUnitsEqual("player", unitTag)
    local isTargetPlayerOrCompanion = isTargetPlayer or (HasActiveCompanion() and unitTag == "companion")

    if isChanneling and abilityId == 29721 and change == EFFECT_RESULT_UPDATED then
        isChanneling = false
    end

    local specialEffect = FancyActionBar.specialEffects[abilityId]
        and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId])
    local useSpecialDebuffTracking = SV.advancedDebuff and specialEffect and specialEffect.isSpecialDebuff
    if specialEffect and (not useSpecialDebuffTracking) then
        if FancyActionBar.traps[abilityId] and SV.ignoreTrapPlacement then
            return
        end
        FancyActionBar.HandleSpecialEffect(abilityId, change, t, beginTime, endTime, unitTag, stackCount, abilityType, unitId)
        return
    end

    if (abilityId == 143808 and change == EFFECT_RESULT_GAINED) then -- crystal weapon. remove a stack when the debuff is applied.
        local pCW = t - lastCW
        if (FancyActionBar.effects[46331] and pCW > 0.5) then        -- filter out double events
            lastCW = t
            if (FancyActionBar.stacks[46331] and FancyActionBar.stacks[46331] > 0) then
                FancyActionBar.stacks[46331] = FancyActionBar.stacks[46331] - 1
                FancyActionBar.HandleStackUpdate(46331)
            end
            return
        end
    end

    local effect = FancyActionBar.effects[abilityId] or { id = abilityId }
    if sourceAbilities[abilityId] and not FancyActionBar.effects[abilityId] then
        FancyActionBar.effects[abilityId] = effect
    end
    if effect then
        if (FancyActionBar.bannerBearer[abilityId]) and (sourceType == COMBAT_UNIT_TYPE_PLAYER) and isTargetPlayerOrCompanion then
            for k, v in pairs(FancyActionBar.bannerBearer) do
                if sourceAbilities[k] then
                    FancyActionBar.effects[sourceAbilities[k]].beginTime = (beginTime ~= 0) and beginTime or t
                    if isTargetPlayer then
                        FancyActionBar.toggles[sourceAbilities[k]] = (change ~= EFFECT_RESULT_FADED)
                    end
                end
            end
        elseif FancyActionBar.toggled[abilityId] then
            effect.beginTime = (beginTime ~= 0) and beginTime or t
            local toggleAbility = sourceAbilities[abilityId] and sourceAbilities[abilityId] or abilityId
            FancyActionBar.toggles[toggleAbility] = (change ~= EFFECT_RESULT_FADED)
        end

        if (effectType == DEBUFF) or useSpecialDebuffTracking then -- if the ability is a debuff, check settings and handle accordingly.
            local tag = unitTag or ""

            if FancyActionBar.ShouldTrackAsDebuff(abilityId, tag) or useSpecialDebuffTracking then
                effect.isDebuff = true

                if not FancyActionBar.debuffs[abilityId] then
                    FancyActionBar.debuffs[abilityId] = effect
                end
                FancyActionBar.OnDebuffChanged(effect, t, eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)

                if noget == true then
                    if SV.debuffTable[effect.id] == nil then
                        SV.debuffTable[effect.id] = true
                    end
                end

                return
            end
        end

        if SV.ignoreUngroupedAliies and IsUnitGrouped("player") then
            if abilityType ~= GROUND_EFFECT and not (FancyActionBar.IsLocalPlayerOrEnemy(unitTag) or ZO_Group_IsGroupUnitTag(unitTag) or FancyActionBar.IsPlayerPet(unitTag) or IsGroupCompanionUnitTag(unitTag) or unitTag == "companion") then
                return
            end
        end

        if change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED then
            local targetType = GetAbilityTargetDescription(effect.id, nil, unitTag)
            if (not SV.multiTargetBlacklist[effect.id]) and (abilityType ~= GROUND_EFFECT) and (targetType ~= "Self") then
                local targetData = FancyActionBar.targets[effect.id] or { targetCount = 0, maxEndTime = 0, times = {} }
                targetData.maxEndTime = zo_max(endTime, targetData.maxEndTime)
                targetData.times[unitId] = { beginTime = beginTime, endTime = endTime }
                FancyActionBar.targets[effect.id] = targetData
                FancyActionBar.CheckTargetEndtimes(effect.id)
                FancyActionBar.HandleTargetUpdate(effect.id)
            end

            if FancyActionBar.activeCasts[effect.id] then
                FancyActionBar.activeCasts[effect.id].begin = beginTime
            end

            if endTime ~= beginTime then -- lazy fix
                if effect.passive then
                    FancyActionBar.UpdatePassiveEffect(effect.id, false)
                end
            end

            -- Ignore abilities which will end in less than min or longer than max (seconds).
            if (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax) then
                local duration = beginTime and endTime and (endTime - beginTime) or nil
                if not effect.duraton or effect.duration ~= duration then
                    effect.duration = duration > 0 and duration or nil
                end

                if abilityType == GROUND_EFFECT then -- make sure to only track duration of the most recent cast of the ground ability.
                    lastAreaTargets[abilityId] = unitId
                    if abilityId == 117805 then      -- unnerving boneyard sometimes updates to 25s duration, not sure why..
                        effect.endTime = t + 10
                        FancyActionBar.UpdateEffect(effect)
                        return
                    end
                end

                effect.endTime = endTime

                if FancyActionBar.stackableBuff[abilityId] then
                    local stackableBuffId = FancyActionBar.stackableBuff[abilityId]
                    _, _, stackCount = FancyActionBar.CheckForActiveEffect(stackableBuffId)
                    FancyActionBar.stacks[stackableBuffId] = stackCount
                end
                for id, knownEffect in pairs(FancyActionBar.effects) do
                    if knownEffect.stackId and ((effectType ~= DEBUFF) or FancyActionBar.fixedStacks[abilityId]) then
                        if FancyActionBar.fixedStacks[abilityId] then
                            stackCount = FancyActionBar.fixedStacks[abilityId]
                        end
                        for i = 1, #knownEffect.stackId do
                            if knownEffect.stackId[i] == abilityId then
                                FancyActionBar.stacks[abilityId] = stackCount or 0
                                FancyActionBar.HandleStackUpdate(id)
                            end
                        end
                    end
                end
            else
                effect.endTime = 0 -- duration too long or too short. don't track.
            end
            FancyActionBar.UpdateEffect(effect)
        elseif (change == EFFECT_RESULT_FADED) then
            if effect.ignoreFadeTime then
                return
            end
            local hasActiveTargets = false
            if FancyActionBar.targets[effect.id] then
                local targetData = FancyActionBar.targets[effect.id]
                targetData.times[unitId] = nil
                FancyActionBar.targets[effect.id] = targetData
                local targetCount = FancyActionBar.CheckTargetEndtimes(effect.id)
                FancyActionBar.HandleTargetUpdate(effect.id)
                if targetCount >= 1 then
                    hasActiveTargets = true
                end
            end

            if FancyActionBar.IsGroupUnit(unitTag) then
                return
            end -- don't track anything on group members.

            if FancyActionBar.stackableBuff[abilityId] then
                local stackableBuffId = FancyActionBar.stackableBuff[abilityId]
                _, _, stackCount = FancyActionBar.CheckForActiveEffect(stackableBuffId)
                FancyActionBar.stacks[stackableBuffId] = stackCount
                FancyActionBar.HandleStackUpdate(effect.id)
            end

            if hasActiveTargets then
                return
            end

            if effect.instantFade or FancyActionBar.removeInstantly[effect.id] then -- abilities we want to reset the overlay instantly for when expired.
                effect.endTime = endTime
                FancyActionBar.UpdateEffect(effect)
                return
            end


            if abilityId == 122658 and FancyActionBar.effects[122658] then
                FancyActionBar.effects[122658].endTime = t
                FancyActionBar.stacks[122658] = 0
                FancyActionBar.HandleStackUpdate(122658)
            end

            if (effectType == DEBUFF or abilityId == 38791) then
                return
            end -- (FancyActionBar.dontFade[abilityId]) then return end

            if ((not SV.externalBuffs) or SV.externalBlackList[effect.id]) and effect.dontFade and FancyActionBar.CheckForActiveEffect(effect.id) then
                return
            end

            if FancyActionBar.activeCasts[effect.id] then
                if abilityType == GROUND_EFFECT then -- prevent effect from fading if event is from previous cast of the ability when reapplied before it had expired
                    if lastAreaTargets[abilityId] then
                        if lastAreaTargets[abilityId] ~= unitId then
                            return
                        end
                        lastAreaTargets[abilityId] = nil
                    end
                end

                -- crystal frags
                if (abilityId == 46327 and FancyActionBar.effects[46327]) or (FancyActionBar.activeCasts[effect.id].begin < (t - 0.7)) then
                    FancyActionBar.activeCasts[effect.id].fade = t

                    -- FancyActionBar.AddSystemMessage('Fading ' .. effectName .. ': ' .. string.format(t - FancyActionBar.activeCasts[effect.id].begin) .. ' / ' .. tostring(effectType))

                    effect.endTime = t
                    if effect.passive then
                        FancyActionBar.UpdateToggledAbility(abilityId, false)
                    end
                end
            end
        end

        if FancyActionBar.stackMap[abilityId] then
            if (SV.advancedDebuff and effectType == DEBUFF) then
                return
            end -- is handled by debuff.lua
        end
    end
end

-- Update overlays.
local function Update()
    for i = MIN_INDEX, ULT_INDEX do
        FancyActionBar.UpdateOverlay(i)
        FancyActionBar.UpdateOverlay(i + SLOT_INDEX_OFFSET)
    end
    if AreCompanionSkillsInitialized() and HasActiveCompanion() and DoesUnitExist("companion") then
        local companionUlt = ZO_ActionBar_GetButton(ULT_INDEX, HOTBAR_CATEGORY_COMPANION)
        if (not companionUlt) or (not companionUlt.hasAction) then
            return
        end
        FancyActionBar.UpdateUltOverlay(ULT_INDEX + COMPANION_INDEX_OFFSET)
    end
end

--- @param eventId integer
--- @param changeType EffectResult
--- @param effectSlot integer
--- @param effectName string
--- @param unitTag string
--- @param beginTime integer
--- @param endTime integer
--- @param stackCount integer
--- @param iconName string
--- @param deprecatedBuffType string
--- @param effectType BuffEffectType
--- @param abilityType AbilityType
--- @param statusEffectType StatusEffectType
--- @param unitName string
--- @param unitId integer
--- @param abilityId integer
--- @param sourceType CombatUnitType
local function OnStackChanged(eventId, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, deprecatedBuffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    -- Skip if this is a debuff and advanced debuff tracking is enabled
    if (SV.advancedDebuff and effectType == DEBUFF) then
        return
    end

    if FancyActionBar.stackableBuff[abilityId] then
        abilityId = FancyActionBar.stackableBuff[abilityId]
        local _, _, newStackCount = FancyActionBar.CheckForActiveEffect(abilityId)
        stackCount = newStackCount
    elseif FancyActionBar.fixedStacks[abilityId] then
        stackCount = changeType ~= EFFECT_RESULT_FADED and FancyActionBar.fixedStacks[abilityId] or 0
    else
        stackCount = changeType ~= EFFECT_RESULT_FADED and stackCount or 0
    end
    FancyActionBar.stacks[abilityId] = stackCount

    if FancyActionBar.stackMap[abilityId] then
        for id, effect in pairs(FancyActionBar.effects) do
            if effect.stackId and #effect.stackId > 0 then
                for i = 1, #effect.stackId do
                    if effect.stackId[i] == abilityId then
                        FancyActionBar.HandleStackUpdate(id)
                        break
                    end
                end
            end
        end
    end

    -- Handle special case for Seething Fury
    if stackCount == 0 then
        if abilityId == 122658 and FancyActionBar.effects[122658] then
            FancyActionBar.effects[122658].endTime = time()
        end
    end

    -- Debug output (commented out)
    -- Determine change type string for debugging
    -- local changeTypeString = ""
    -- if changeType == EFFECT_RESULT_FADED then
    --     changeTypeString = "faded"
    -- elseif changeType == EFFECT_RESULT_GAINED then
    --     changeTypeString = "gained"
    -- elseif changeType == EFFECT_RESULT_UPDATED then
    --     changeTypeString = "updated"
    -- end
    -- unitName = zo_strformat("<<1>>", unitName)
    -- FancyActionBar.AddSystemMessage("[" .. abilityId .. "] " .. changeTypeString .. " -> tag(" .. unitTag .. ") name(" .. unitName .. ") id(" .. unitId .. ") stacks(" .. stackCount .. ")")
end

--- @param eventId integer
--- @param bagId Bag
--- @param slotIndex integer
--- @param isNewItem boolean
--- @param itemSoundCategory ItemUISoundCategory
--- @param inventoryUpdateReason integer
--- @param stackCountChange integer
--- @param triggeredByCharacterName string
--- @param triggeredByDisplayName string
--- @param isLastUpdateForMessage boolean
--- @param bonusDropSource BonusDropSource
local function OnEquippedGearChanged(eventId, bagId, slotIndex, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange, triggeredByCharacterName, triggeredByDisplayName, isLastUpdateForMessage, bonusDropSource)
    -- Only process worn equipment changes
    if bagId ~= BAG_WORN then
        return
    end

    -- Handle weapon slot changes
    if slotIndex == EQUIP_SLOT_MAIN_HAND or slotIndex == EQUIP_SLOT_BACKUP_MAIN then
        FancyActionBar.weaponFront = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_MAIN_HAND, LINK_STYLE_DEFAULT))
        FancyActionBar.weaponBack = GetItemLinkWeaponType(GetItemLink(BAG_WORN, EQUIP_SLOT_BACKUP_MAIN, LINK_STYLE_DEFAULT))
    end

    -- Handle ring slot changes for Oakensoul
    if slotIndex == EQUIP_SLOT_RING1 or slotIndex == EQUIP_SLOT_RING2 then
        local wasOakensoulEquipped = FancyActionBar.oakensoulEquipped
        local isOakensoulEquipped = (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING1) == FancyActionBar.oakensoul) or (GetItemInfo(BAG_WORN, EQUIP_SLOT_RING2) == FancyActionBar.oakensoul)
        FancyActionBar.oakensoulEquipped = isOakensoulEquipped

        if SV.hideLockedBar and isOakensoulEquipped or wasOakensoulEquipped then
            FancyActionBar.OnWeaponSwapLocked(isOakensoulEquipped, isWeaponSwapLocked)
        end
        FancyActionBar.ApplyAbilityFxOverrides()
    end
end

--- @param eventId integer
--- @param unitTag string
--- @param isDead boolean
local function OnDeath(eventId, unitTag, isDead)
    -- Only process if player is dead
    if not isDead or not AreUnitsEqual("player", unitTag) then
        return
    end

    -- Reset channeling states
    channeledAbilityUsed = nil
    isChanneling = false

    -- Update effects and tracking
    FancyActionBar.RefreshEffects()
    FancyActionBar.EffectCheck()
    FancyActionBar:UpdateDebuffTracking()
end

-- function to handle combat events
--- @param eventId integer
--- @param result ActionResult
--- @param isError boolean
--- @param abilityName string
--- @param abilityGraphic integer
--- @param abilityActionSlotType ActionSlotType
--- @param sourceName string
--- @param sourceType CombatUnitType
--- @param targetName string
--- @param targetType CombatUnitType
--- @param hitValue integer
--- @param powerType CombatMechanicFlags
--- @param damageType DamageType
--- @param log boolean
--- @param sourceUnitId integer
--- @param targetUnitId integer
--- @param abilityId integer
--- @param overflow integer
local function OnCombatEvent(eventId, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    local effect
    local currentTime = time()

    -- Debug logging
    if SV.debugAll then
        local ts = tostring
        FancyActionBar.AddSystemMessage("===================")
        FancyActionBar.AddSystemMessage(abilityName .. " (" .. ts(abilityId) .. ") || result: " .. ts(result) .. " || hit: " .. ts(hitValue))
        FancyActionBar.AddSystemMessage("===================")
    end

    -- Handle special effects
    local specialEffect = FancyActionBar.specialEffects[abilityId] and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId])
    local useSpecialDebuffTracking = SV.advancedDebuff and specialEffect and specialEffect.isSpecialDebuff

    if specialEffect and not useSpecialDebuffTracking then
        FancyActionBar.HandleSpecialEffect(abilityId, result, currentTime, currentTime, currentTime + GetAbilityDuration(abilityId), nil, nil, nil, targetUnitId)
        return
    end

    -- Handle needed combat events
    if FancyActionBar.needCombatEvent[abilityId] and result == FancyActionBar.needCombatEvent[abilityId].result then
        effect = FancyActionBar.effects[abilityId]
        if effect then
            effect.endTime = currentTime + FancyActionBar.needCombatEvent[abilityId].duration
            -- Debug logging for needed combat events
            -- local ts = tostring
            -- FancyActionBar.AddSystemMessage('===================')
            -- FancyActionBar.AddSystemMessage(abilityName..' ('..ts(abilityId)..') || result: '..ts(result)..' || hit: '..ts(hitValue))
            -- FancyActionBar.AddSystemMessage('===================')
            FancyActionBar.UpdateEffect(effect)
            return
        end
    end

    -- Handle Grave Lord Sacrifice
    if abilityId == FancyActionBar.graveLordSacrifice.eventId then
        effect = FancyActionBar.effects[FancyActionBar.graveLordSacrifice.id]
        if effect then
            effect.endTime = currentTime + FancyActionBar.graveLordSacrifice.duration
            FancyActionBar.UpdateEffect(effect)
        end
    end
end

--- @param eventId integer
--- @param result ActionResult
--- @param isError boolean
--- @param abilityName string
--- @param abilityGraphic integer
--- @param abilityActionSlotType ActionSlotType
--- @param sourceName string
--- @param sourceType CombatUnitType
--- @param targetName string
--- @param targetType CombatUnitType
--- @param hitValue integer
--- @param powerType CombatMechanicFlags
--- @param damageType DamageType
--- @param log boolean
--- @param sourceUnitId integer
--- @param targetUnitId integer
--- @param abilityId integer
--- @param overflow integer
local function OnReflect(eventId, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    -- Only process if target is player
    if (targetType ~= COMBAT_UNIT_TYPE_PLAYER) then
        return
    end

    local currentTime = time()
    local doStackUpdate = false

    -- Debug logging
    if SV.debugAll then
        local ts = tostring
        FancyActionBar.AddSystemMessage("===================")
        FancyActionBar.AddSystemMessage(abilityName .. " (" .. ts(abilityId) .. ") || result: " .. ts(result) .. " || hit: " .. ts(hitValue))
        FancyActionBar.AddSystemMessage("===================")
    end

    local specialEffect = FancyActionBar.specialEffects[abilityId]
    local reflectStacks = specialEffect.stackId[1]
    local effect = FancyActionBar.effects[specialEffect.id]

    -- Prevent rapid updates
    if effect.beginTime and (currentTime - effect.beginTime < 0.3) then
        return
    end

    -- Handle effect gain
    if result == ACTION_RESULT_BEGIN or result == ACTION_RESULT_EFFECT_GAINED or result == ACTION_RESULT_EFFECT_GAINED_DURATION then
        FancyActionBar.stacks[reflectStacks] = specialEffect.stacks
        doStackUpdate = true
    end

    -- Handle damage shield
    if result == ACTION_RESULT_DAMAGE_SHIELDED and FancyActionBar.stacks[reflectStacks] and FancyActionBar.stacks[reflectStacks] > 0 then
        FancyActionBar.stacks[reflectStacks] = FancyActionBar.stacks[reflectStacks] - 1
        doStackUpdate = true
    end

    -- Handle effect fade
    if (result == ACTION_RESULT_EFFECT_FADED) then
        FancyActionBar.stacks[reflectStacks] = 0
        doStackUpdate = true
    end

    -- Update stacks if needed
    if doStackUpdate then
        FancyActionBar.HandleStackUpdate(specialEffect.id)
    end
end

local function ActionBarActivated(eventCode, initial)
    if not initial then
        -- OnAllHotbarsUpdated()
        FancyActionBar.EffectCheck()
    end
    zo_callLater(function ()
        FancyActionBar.OnPlayerActivated()
        FancyActionBar.ApplyAbilityFxOverrides()
        FancyActionBar.ApplyActiveHotbarStyle()
    end, 750)
end

function FancyActionBar.RegisterClassEffects(newSkillLineId)
    local skillData = SKILLS_DATA_MANAGER
    local skillLineIds = {}

    if newSkillLineId then
        if registeredSkillLines[newSkillLineId] then return end
        skillLineIds = { newSkillLineId }
    elseif SKILLS_DATA_MANAGER:IsDataReady() then
        for i = 1, 3 do
            local skillLine = SKILLS_DATA_MANAGER:GetActiveClassSkillLine(i)
            if skillLine and skillLine.id and not registeredSkillLines[skillLine.id] then
                table.insert(skillLineIds, skillLine.id)
            end
        end
    else
        -- Fallback to the skill line info table if data is not ready to to ensure all skill line effects are set up
        for k, v in pairs(FancyActionBar.skillLineInfo) do
            for i, skillLineId in pairs(v) do
                table.insert(skillLineIds, skillLineId)
            end
        end
    end

    if not skillLineIds or #skillLineIds == 0 then return end

    for i = 1, #skillLineIds do
        local skillLineId = skillLineIds[i]
        if registeredSkillLines[skillLineId] then return end

        if FancyActionBar.specialClassEffects[skillLineId] then
            for j, x in pairs(FancyActionBar.specialClassEffects[skillLineId]) do
                FancyActionBar.specialEffects[j] = x
                if x.needCombatEvent then
                    EM:RegisterForEvent(NAME .. j, EVENT_COMBAT_EVENT, OnCombatEvent)
                    EM:AddFilterForEvent(NAME .. j, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, j, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
                elseif x.handler and (x.handler == "reflect") then
                    EM:RegisterForEvent(NAME .. "Reflect" .. j, EVENT_COMBAT_EVENT, OnReflect)
                    EM:AddFilterForEvent(NAME .. "Reflect" .. j, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, j)
                end
            end
        end

        if FancyActionBar.specialClassEffectProcs[skillLineId] then
            for j, x in pairs(FancyActionBar.specialClassEffectProcs[skillLineId]) do
                FancyActionBar.specialEffectProcs[j] = x
            end
        end

        for id in pairs(FancyActionBar.needCombatEvent) do
            if FancyActionBar.needCombatEvent[id].skillLine == skillLineId then
                EM:RegisterForEvent(NAME .. id, EVENT_COMBAT_EVENT, OnCombatEvent)
                EM:AddFilterForEvent(NAME .. id, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
            end
        end

        if FancyActionBar.graveLordSacrifice and FancyActionBar.graveLordSacrifice.skillLine == skillLineId then
            EM:RegisterForEvent(NAME .. "GraveLordSacrifice", EVENT_COMBAT_EVENT, OnCombatEvent)
            EM:AddFilterForEvent(NAME .. "GraveLordSacrifice", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, FancyActionBar.graveLordSacrifice.eventId, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER_PET)
        end

        registeredSkillLines[skillLineId] = true
    end
end

--- @param eventCode number
--- @param skillType SkillType
--- @param skillLineIndex luaindex
--- @param advised boolean
function FancyActionBar.OnSkillLineAdded(eventCode, skillType, skillLineIndex, advised)
    if skillType ~= SKILL_TYPE_CLASS then return end

    local skillLineId = GetSkillLineId(skillType, skillLineIndex)
    if not skillLineId or registeredSkillLines[skillLineId] then return end

    FancyActionBar.RegisterClassEffects(skillLineId)
end

function FancyActionBar.Initialize()
    -- defaultSettings = FancyActionBar.defaultSettings
    SV = ZO_SavedVars:NewAccountWide("FancyActionBarSV", FancyActionBar.variableVersion, nil, defaultSettings, GetWorldName())
    CV = ZO_SavedVars:NewCharacterIdSettings("FancyActionBarSV", FancyActionBar.variableVersion, nil, FancyActionBar.defaultCharacter, GetWorldName())
    -- Initialize saved variables
    if SV.abMove == nil then
        SV.abMove = {}
    end

    if SV.abMove.kb == nil then
        SV.abMove.kb = { enable = false, x = 0, y = -22, prevX = 0, prevY = -22 }
    end

    if SV.abMove.gp == nil then
        SV.abMove.gp = { enable = false, x = 0, y = -75, prevX = 0, prevY = -75 }
    end
    FancyActionBar.useGamepadActionBar = IsInGamepadPreferredMode() or SV.forceGamepadStyle
    for i = MIN_INDEX, ULT_INDEX do
        FancyActionBar.SetSlottedEffect(i, 0, 0)
        FancyActionBar.SetSlottedEffect(i + SLOT_INDEX_OFFSET, 0, 0)
    end

    FancyActionBar.ValidateVariables()
    FancyActionBar.UpdateStyle()

    FancyActionBar.updateUI = true

    FancyActionBar.UpdateTextures()

    SLASH_COMMANDS[slashCommand] = FancyActionBar.SlashCommand

    FancyActionBar.SetScale()
    FancyActionBar.constants.update = FancyActionBar.RefreshUpdateConfiguration()
    FancyActionBar.UpdateDurationLimits()
    FancyActionBar:InitializeDebuffs(NAME, SV)
    FancyActionBar.BuildMenu(SV, CV, defaultSettings)
    FancyActionBar.BuildAbilityConfig()
    FancyActionBar.SetupGCD()
    FancyActionBar.ApplyDeathStateOption()
    debug = SV.debug

    FancyActionBar.player.name = zo_strformat("<<!aC:1>>", GetUnitName("player"))

    -- ANTIQUITY_DIGGING_SCENE = 'antiquityDigging'
    -- LOCK_PICK_SCENE = 'lockpickKeyboard'

    local function LockSkillsOnTrade()
        if TRADE_WINDOW.state == 3 then
            return false
        end
        if SM.currentScene:GetName() == "antiquityDigging" then
            return false
        end
        return true
    end

    local useSlotsOverride = true
    if PerfectWeave and SV.perfectWeave then
        useSlotsOverride = false
    end

    if useSlotsOverride then
        SecurePostHook("ZO_ActionBar_CanUseActionSlots", function ()
            if SV.lockInTrade then
                return LockSkillsOnTrade()
            end
        end)
    end

    EM:UnregisterForEvent("ZO_ActionBar", EVENT_ACTIVE_COMPANION_STATE_CHANGED)
    EM:RegisterForEvent(NAME, EVENT_ACTIVE_COMPANION_STATE_CHANGED, FancyActionBar.HandleCompanionUltimate)
    EM:RegisterForEvent(NAME, EVENT_ACTION_SLOT_ABILITY_USED, OnAbilityUsed)
    EM:RegisterForEvent(NAME, EVENT_HOTBAR_SLOT_UPDATED, OnSlotChanged)
    EM:RegisterForEvent(NAME, EVENT_HOTBAR_SLOT_STATE_UPDATED, OnHotbarSlotStateUpdated)
    EM:RegisterForEvent(NAME, EVENT_ACTION_SLOT_EFFECT_UPDATE, OnActionSlotEffectUpdated)
    EM:RegisterForEvent(NAME, EVENT_ACTION_SLOTS_ACTIVE_HOTBAR_UPDATED, OnActiveHotbarUpdated)
    EM:RegisterForEvent(NAME, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, OnAllHotbarsUpdated)
    EM:RegisterForEvent(NAME, EVENT_ARMORY_BUILD_RESTORE_RESPONSE, OnArmory)
    EM:RegisterForEvent(NAME .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, OnDeath)
    EM:AddFilterForEvent(NAME .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, REGISTER_FILTER_UNIT_TAG, "player")
    EM:RegisterForEvent(NAME, EVENT_GAME_CAMERA_UI_MODE_CHANGED, function ()
        isChanneling = false
    end)
    EM:RegisterForEvent(NAME, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, function ()
        FancyActionBar.updateUI = true
        FancyActionBar.useGamepadActionBar = IsInGamepadPreferredMode() or SV.forceGamepadStyle
        local _, locked = GetActiveWeaponPairInfo()
        FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
        FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
        FancyActionBar.ApplyActiveHotbarStyle()
        FancyActionBar.ApplyQuickSlotAndUltimateStyle()
        FancyActionBar:ApplySettings()
        FancyActionBar.ToggleFillAnimationsAndFrames(FancyActionBar.useGamepadActionBar)
        FancyActionBar.updateUI = false
        -- ReloadUI("ingame");
    end)

    EM:RegisterForEvent(NAME, EVENT_WEREWOLF_STATE_CHANGED, function (_, value)
        FancyActionBar.isWerewolf = value
        if SV.hideLockedBar then
            FancyActionBar.OnWeaponSwapLocked(value, isWeaponSwapLocked)
        end
        FancyActionBar.SlotEffects()
    end)

    EM:RegisterForEvent(NAME, EVENT_PLAYER_ACTIVATED, function ()
        if not IsConsoleUI() then
            SetAbilityBarTimersEnabled()
        end
        EM:RegisterForEvent(NAME, EVENT_ACTIVE_WEAPON_PAIR_CHANGED, OnActiveWeaponPairChanged)
        FancyActionBar.ApplyStyle()
        FancyActionBar.InitializeScreenResizeHandler()
        OnAllHotbarsUpdated()
        FancyActionBar.SwapControls()
        FancyActionBar.ApplyAbilityFxOverrides()
        EM:UnregisterForUpdate(NAME .. "Update")
        EM:RegisterForUpdate(NAME .. "Update", updateRate, Update)
        EM:UnregisterForEvent(NAME, EVENT_PLAYER_ACTIVATED)
    end)

    EM:RegisterForEvent(NAME .. "_Activated", EVENT_PLAYER_ACTIVATED, ActionBarActivated)
    EM:RegisterForEvent(NAME, EVENT_COLLECTIBLE_UPDATED, FancyActionBar.SkillStyleCollectibleUpdated)
    EM:RegisterForEvent(NAME, EVENT_EFFECT_CHANGED, OnEffectChanged)
    EM:AddFilterForEvent(NAME, EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)

    for abilityId, stackAbilities in pairs(FancyActionBar.stackMap) do
        EM:RegisterForEvent(NAME .. abilityId, EVENT_EFFECT_CHANGED, OnStackChanged)
        EM:AddFilterForEvent(NAME .. abilityId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, abilityId)
        EM:AddFilterForEvent(NAME .. abilityId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
    end

    for abilityId, stackAbilities in pairs(FancyActionBar.stackableBuff) do
        if not FancyActionBar.stackMap[abilityId] then
            EM:AddFilterForEvent(NAME .. abilityId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, abilityId)
            EM:AddFilterForEvent(NAME .. abilityId, EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        end
    end

    FancyActionBar.SetExternalBuffTracking()

    EM:RegisterForEvent(NAME, EVENT_ULTIMATE_ABILITY_COST_CHANGED, FancyActionBar.UpdateUltimateCost)
    EM:RegisterForEvent(NAME, EVENT_ULTIMATE_ABILITY_COST_CHANGED, FancyActionBar.HandleCompanionUltimate)
    EM:RegisterForEvent(NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnEquippedGearChanged)
    EM:AddFilterForEvent(NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)

    ZO_PreHookHandler(ACTION_BAR, "OnHide", function ()
        -- if ZO_ActionBar1:IsHidden() and not wasStopped then
        if not FancyActionBar.wasStopped then
            EM:UnregisterForUpdate(NAME .. "Update")
            FancyActionBar.wasStopped = true
        end
    end)

    ZO_PreHookHandler(ACTION_BAR, "OnShow", function ()
        if FancyActionBar.IsUnlocked() then
            return
        end

        FancyActionBar.ApplyPosition()

        if FancyActionBar.wasStopped then
            Update()
            EM:RegisterForUpdate(NAME .. "Update", updateRate, Update)
        end
    end)

    SecurePostHook(ActionButton, "ApplyStyle", function (self)
        local style = FancyActionBar.GetConstants()
        ApplyTemplateToControl(self.slot, self.ultimateReadyBurstTimeline and style.ultButtonTemplate or style.buttonTemplate)
        setFlipCardDimensions(style)
        FancyActionBar.ApplyQuickSlotFont()
    end)

    ZO_PreHookHandler(CompanionUltimateButton, "OnShow", function ()
        if CompanionUltimateButton and (SV.hideCompanionUlt or (not ZO_ActionBar_GetButton(ULT_INDEX, HOTBAR_CATEGORY_COMPANION).hasAction or not DoesUnitExist("companion") or not HasActiveCompanion())) then
            CompanionUltimateButton:SetHidden(true)
        end
    end)

    -- Unregister some default stuff from action buttons.
    EM:UnregisterForEvent("ZO_ActionBar", EVENT_ACTION_SLOT_EFFECT_UPDATE)
    for i = MIN_INDEX, ULT_INDEX do
        EM:UnregisterForEvent("ActionButton" .. i, EVENT_INTERFACE_SETTING_CHANGED)
        EM:UnregisterForEvent("ActionBarTimer" .. i, EVENT_INTERFACE_SETTING_CHANGED)
    end

    for id in pairs(FancyActionBar.needCombatEvent) do
        if (not FancyActionBar.needCombatEvent[id].skillLine) then
            EM:RegisterForEvent(NAME .. id, EVENT_COMBAT_EVENT, OnCombatEvent)
            EM:AddFilterForEvent(NAME .. id, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        end
    end

    for id, effect in pairs(FancyActionBar.specialEffects) do
        if effect.needCombatEvent then
            EM:RegisterForEvent(NAME .. id, EVENT_COMBAT_EVENT, OnCombatEvent)
            EM:AddFilterForEvent(NAME .. id, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        end
    end

    for id, effect in pairs(FancyActionBar.specialEffects) do
        if effect.handler and (effect.handler == "reflect") then
            EM:RegisterForEvent(NAME .. "Reflect" .. id, EVENT_COMBAT_EVENT, OnReflect)
            EM:AddFilterForEvent(NAME .. "Reflect" .. id, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id)
        end
    end

    FancyActionBar.RegisterClassEffects()
    EM:RegisterForEvent(NAME, EVENT_SKILL_LINE_ADDED, FancyActionBar.OnSkillLineAdded)
    -- EM:RegisterForEvent(NAME, EVENT_ABILITY_LIST_CHANGED, FancyActionBar.RegisterClassEffects)

    -- ZO_PreHook('ZO_ActionBar_OnActionButtonDown', function(slotNum)
    --   FancyActionBar.AddSystemMessage('ActionButton' .. slotNum .. ' pressed.')
    --   return false
    -- end)
    if not IsConsoleUI() then
        SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR_BACK_ROW, "false")
        SetSetting(SETTING_TYPE_UI, UI_SETTING_SHOW_ACTION_BAR_TIMERS, "false")
    end
end

function FancyActionBar.OnAddOnLoaded(event, addonName)
    if addonName == NAME then
        EM:UnregisterForEvent(NAME, EVENT_ADD_ON_LOADED)
        FancyActionBar.Initialize()
        FancyActionBar.updateUI = false
    end
end

local function ValidateBasicSettings(sv, d)
    sv = SV
    d = d or defaultSettings

    local settings =
    {
        "dynamicAbilityConfig",
        "showDecimal",
        "alphaInactive",
        "desaturationInactive",
        "showDecimalStart",
        "showExpire",
        "showExpireStart",
        "expireColor",
        "showTickExpire",
        "showTickStart",
        "tickColor",
        "allowParentTime",
        "forceGamepadStyle",
        "useThinFrames",
        "showFrames",
        "frameColor",
        "showMarker",
        "markerSize",
        "showHighlight",
        "highlightColor",
        "showArrow",
        "arrowColor",
        "moveQS",
        "moveHealthBar",
        "moveResourceBars",
        "moveBuffs",
        "moveSynergy",
        "forceReposition",
        "showStackCount",
        "showOvertauntStacks",
        "showTargetCount",
        "showSingleTargetInstance",
        "applyActionBarSkillStyles",
        "showCastDuration",
        "showToggleTicks",
        "ignoreTrapPlacement",
        "showSoonestExpire",
        "ignoreUngroupedAliies",
        "hideLockedBar",
        "repositionActiveBar",
        "hideCompanionUlt",
        "debug",
        "showToggle",
        "toggleColor",
        "hideInactiveSlots"
    }

    for _, setting in ipairs(settings) do
        if sv[setting] == nil then
            sv[setting] = d[setting]
        end
    end
end

local function ValidateBlacklists(sv)
    sv = SV

    -- External blacklist validation
    if not sv.externalBlackListRun then
        -- just add all resto staff skills by default and player can take it from there.
        sv.externalBlackList =
        {
            [28385] = true,  -- "Grand Healing"
            [40058] = true,  -- "Illustrious Healing"
            [40060] = true,  -- "Healing Springs"
            [28536] = true,  -- "Regeneration"
            [40076] = true,  -- "Rapid Regeneration"
            [40079] = true,  -- "Radiating Regeneration"
            [29224] = true,  -- "Igneous Shield"
            [31531] = true,  -- "Force Siphon"
            [37232] = true,  -- "Steadfast Ward"
            [38552] = true,  -- "Panacea"
            [40109] = true,  -- "Siphon Spirit"
            [40116] = true,  -- "Quick Siphon"
            [40126] = true,  -- "Healing Ward"
            [40130] = true,  -- "Ward Ally"
            [61504] = true,  -- "Vigor"
            [61506] = true,  -- "Echoing Vigor"
            [61665] = true,  -- "Major Brutality"
            [61687] = true,  -- "Major Sorcery"
            [61693] = true,  -- "Minor Resolve"
            [61694] = true,  -- "Major Resolve"
            [61697] = true,  -- "Minor Fortitude"
            [61704] = true,  -- "Minor Endurance"
            [61706] = true,  -- "Minor Intellect"
            [61721] = true,  -- "Minor Protection"
            [76518] = true,  -- "Major Brutality"
            [83850] = true,  -- "Life Giver"
            [85132] = true,  -- "Lights Champion"
            [88758] = true,  -- "Major Resolve"
            [92503] = true,  -- "Major Sorcery"
            [176991] = true, -- "Minor Resolve"
            [186493] = true, -- "Minor Protection"
        }
        sv.externalBlackListRun = true
    end
    -- Update external blacklist with new abilities from config
    for abilityId, value in pairs(FancyActionBar.externalBlacklistUpdates) do
        if not sv.externalBlackList[abilityId] and value then
            sv.externalBlackList[abilityId] = GetAbilityName(abilityId)
        elseif sv.externalBlackList[abilityId] and not value then
            sv.externalBlackList[abilityId] = nil
        end
    end

    -- Multi-target blacklist validation
    if not sv.multiTargetBlackListRun then
        sv.multiTargetBlacklist =
        {
            [18746] = true, -- "Mages' Fury"
            [19118] = true, -- "Endless Fury"
            [19125] = true, -- "Mages' Wrath"
            [24326] = true, -- "Daedric Curse"
            [24328] = true, -- "Daedric Prey"
            [24330] = true, -- "Haunting Curse"
            [40229] = true, -- "Siege Weapon Shield"
            [51392] = true, -- "Bolt Escape Fatigue"
        }
        sv.multiTargetBlackListRun = true
    end
    -- Update multi-target blacklist with new abilities from config
    for abilityId, value in pairs(FancyActionBar.multiTargetBlacklistUpdates) do
        if not sv.multiTargetBlacklist[abilityId] and value then
            sv.multiTargetBlacklist[abilityId] = GetAbilityName(abilityId)
        elseif sv.multiTargetBlacklist[abilityId] and not value then
            sv.multiTargetBlacklist[abilityId] = nil
        end
    end

    -- Parent/Fallback time blacklist validation
    if not sv.parentTimeBlackListRun then
        sv.parentTimeBlacklist =
        {
            [39089] = true,  -- ele sus
            [117805] = true, -- boneyard
            [39192] = true,  -- elude
            [183648] = true, -- fatewoven armor
            [185908] = true, -- cruxweaver armor
            [186477] = true, -- unbreakable fate
            [238256] = true, -- vengeance fatewoven armor
            [118680] = true, -- skeletal arcanist
            [28858] = true,  -- wall of elements
            [39052] = true,  -- unstable wall of elements
            [39011] = true,  -- elemental blockade
            [28807] = true,  -- wall of elements (fire)
            [28854] = true,  -- wall of elements (lightning)
            [28849] = true,  -- wall of elements (frost)
            [39053] = true,  -- unstable wall of elements (fire)
            [39073] = true,  -- unstable wall of elements (lightning)
            [39067] = true,  -- unstable wall of elements (frost)
            [39012] = true,  -- elemental blockade (fire)
            [39018] = true,  -- elemental blockade (lightning)
            [39028] = true,  -- elemental blockade (frost)
            [31888] = true,  -- molten armaments
            [86050] = true,  -- betty netch
            [86054] = true,  -- blue betty
            [86058] = true,  -- bull netch
            [24326] = true,  -- Daedric Curse
            [24328] = true,  -- Daedric Prey
        }
        sv.parentTimeBlackListRun = true
    end
    -- Update Parent/Fallback with new abilities from config
    for abilityId, value in pairs(FancyActionBar.parentTimeBlacklistUpdates) do
        if not sv.parentTimeBlacklist[abilityId] and value then
            sv.parentTimeBlacklist[abilityId] = GetAbilityName(abilityId)
        elseif sv.parentTimeBlacklist[abilityId] and not value then
            sv.parentTimeBlacklist[abilityId] = nil
        end
    end
end

local function ValidateGamepadSettings(sv, d)
    sv = SV
    d = d or defaultSettings

    if IsInGamepadPreferredMode() or sv.forceGamepadStyle then
        -- Migrate old settings
        local oldToNewMappings =
        {
            fontName = "fontNameGP",
            fontSize = "fontSizeGP",
            fontType = "fontTypeGP",
            timerY = "timerYGP",
            ultimateSlotCustomXOffset = "ultimateSlotCustomXOffsetGP",
            ultimateSlotCustomYOffset = "ultimateSlotCustomYOffsetGP",
            quickSlotCustomXOffset = "quickSlotCustomXOffsetGP",
            quickSlotCustomYOffset = "quickSlotCustomYOffsetGP"
        }

        for old, new in pairs(oldToNewMappings) do
            if sv[old] then
                sv[new] = sv[old]
                sv[old] = nil
            end
        end

        -- Set default values if nil
        d =
        {
            fontNameGP = d.fontNameGP,
            fontSizeGP = d.fontSizeGP,
            fontTypeGP = d.fontTypeGP,
            timeYGP = d.timeYGP,
            fontNameStackGP = d.fontNameStackGP,
            fontSizeStackGP = d.fontSizeStackGP,
            fontTypeStackGP = d.fontTypeStackGP,
            stackXGP = d.stackXGP,
            stackYGP = d.stackYGP,
            fontNameTargetGP = d.fontNameTargetGP,
            fontSizeTargetGP = d.fontSizeTargetGP,
            fontTypeTargetGP = d.fontTypeTargetGP,
            targetXGP = d.targetXGP,
            targetYGP = d.targetYGP,
            abilitySlotOffsetXGP = d.abilitySlotOffsetXGP,
            barXOffsetGP = d.barXOffsetGP,
            barYOffsetGP = d.barYOffsetGP,
            ultimateSlotCustomXOffsetGP = d.ultimateSlotCustomXOffsetGP,
            ultimateSlotCustomYOffsetGP = d.ultimateSlotCustomYOffsetGP,
            quickSlotCustomXOffsetGP = d.quickSlotCustomXOffsetGP,
            quickSlotCustomYOffsetGP = d.quickSlotCustomYOffsetGP,
            ultValueThresholdGP = d.ultValueThresholdGP,
            ultUsableThresholdColorGP = d.ultUsableThresholdColorGP,
            ultUsableValueColorGP = d.ultUsableValueColorGP,
            ultMaxValueColorGP = d.ultMaxValueColorGP
        }

        for setting, default in pairs(d) do
            if sv[setting] == nil then
                sv[setting] = default
            end
        end
    end
end

local function ValidateKeyboardSettings(sv, d)
    sv = SV
    d = d or defaultSettings

    if not (IsInGamepadPreferredMode() or sv.forceGamepadStyle) then
        -- Migrate old settings
        local oldToNewMappings =
        {
            fontName = "fontNameKB",
            fontSize = "fontSizeKB",
            fontType = "fontTypeKB",
            timerY = "timerYKB",
            ultimateSlotCustomXOffset = "ultimateSlotCustomXOffsetKB",
            ultimateSlotCustomYOffset = "ultimateSlotCustomYOffsetKB",
            quickSlotCustomXOffset = "quickSlotCustomXOffsetKB",
            quickSlotCustomYOffset = "quickSlotCustomYOffsetKB"
        }

        for old, new in pairs(oldToNewMappings) do
            if sv[old] then
                sv[new] = sv[old]
                sv[old] = nil
            end
        end

        -- Set default values if nil
        d =
        {
            fontNameKB = d.fontNameKB,
            fontSizeKB = d.fontSizeKB,
            fontTypeKB = d.fontTypeKB,
            timeYKB = d.timeYKB,
            fontNameStackKB = d.fontNameStackKB,
            fontSizeStackKB = d.fontSizeStackKB,
            fontTypeStackKB = d.fontTypeStackKB,
            stackXKB = d.stackXKB,
            stackYKB = d.stackYKB,
            fontNameTargetKB = d.fontNameTargetKB,
            fontSizeTargetKB = d.fontSizeTargetKB,
            fontTypeTargetKB = d.fontTypeTargetKB,
            targetXKB = d.targetXKB,
            targetYKB = d.targetYKB,
            abilitySlotOffsetXKB = d.abilitySlotOffsetXKB,
            barXOffsetKB = d.barXOffsetKB,
            barYOffsetKB = d.barYOffsetKB,
            ultimateSlotCustomXOffsetKB = d.ultimateSlotCustomXOffsetKB,
            ultimateSlotCustomYOffsetKB = d.ultimateSlotCustomYOffsetKB,
            quickSlotCustomXOffsetKB = d.quickSlotCustomXOffsetKB,
            quickSlotCustomYOffsetKB = d.quickSlotCustomYOffsetKB,
            ultValueThresholdKB = d.ultValueThresholdKB,
            ultUsableThresholdColorKB = d.ultUsableThresholdColorKB,
            ultUsableValueColorKB = d.ultUsableValueColorKB,
            ultMaxValueColorKB = d.ultMaxValueColorKB
        }

        for setting, default in pairs(d) do
            if sv[setting] == nil then
                sv[setting] = default
            end
        end
    end
end

local function ValidateScalingSettings(sv, d)
    sv = SV
    d = d or defaultSettings

    if sv.abScaling == nil then
        sv.abScaling = d.abScaling
    end

    -- Migrate old scaling settings
    if SV.scaleEnable ~= nil then
        sv.abScaling.kb.enable = sv.scaleEnable
        sv.abScaling.gp.enable = sv.scaleEnable
        sv.scaleEnable = nil
    end

    if sv.abScale ~= nil then
        sv.abScaling.kb.scale = sv.abScale
        sv.abScaling.gp.scale = sv.abScale
        sv.abScale = nil
    end
end

function FancyActionBar.ValidateVariables() -- all about safety checks these days..
    local d = defaultSettings
    local sv = SV

    -- Validate SV settings
    if SV.dynamicAbilityConfig == false then
        if SV.abilityConfig then
            SV.abilityConfig = nil
        end
        SV.dynamicAbilityConfig = true
    end

    -- Validate CV settings
    if CV.dynamicAbilityConfig == false then
        if CV.abilityConfig then
            CV.abilityConfig = nil
        end
        CV.dynamicAbilityConfig = true
    end

    -- Main validation flow
    if sv.variablesValidated == false or sv.addonVersion ~= FancyActionBar.GetVersion() then
        ValidateBasicSettings(sv, d)
        ValidateBlacklists(sv)
        ValidateScalingSettings(sv, d)
        ValidateGamepadSettings(sv, d)
        ValidateKeyboardSettings(sv, d)

        -- Update validation status
        sv.variablesValidated = true
        sv.addonVersion = FancyActionBar.GetVersion()
    end
end

EM:RegisterForEvent(NAME, EVENT_ADD_ON_LOADED, FancyActionBar.OnAddOnLoaded)
