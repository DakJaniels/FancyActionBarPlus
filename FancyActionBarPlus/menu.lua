--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar
local LAM = LibAddonMenu2
local LMP = LibMediaProvider
local EM = GetEventManager()
local WM = GetWindowManager()
local GetAbilityDuration = FancyActionBar.GetAbilityDuration
local SV = ...
local CV = ...
local ACTION_BAR = GetControl("ZO_ActionBar1")
local MIN_INDEX = 3          -- first ability index
local MAX_INDEX = 7          -- last ability index
local ULT_INDEX = MAX_INDEX + 1
local SLOT_INDEX_OFFSET = 20 -- offset for backbar abilities indices
local COMPANION_INDEX_OFFSET = 30
local ULT_SLOT = 8           -- ACTION_BAR_ULTIMATE_SLOT_INDEX + 1
local QUICK_SLOT = 9         -- ACTION_BAR_FIRST_UTILITY_BAR_SLOT + 1
local COMPANION = HOTBAR_CATEGORY_COMPANION
local inMenu = false
local settingsPageCreated = false
local unlocked = false
local ultDisplayTime = 0
local qsDisplayTime = 0
local framesHidden = false
local FAB_FRAME = "/FancyActionBarPlus/texture/abilityFrame64_up.dds"
local FAB_NO_FRAME_DOWN = "/FancyActionBarPlus/texture/abilitynoframe64_down.dds"
local FAB_BLANK = "/FancyActionBarPlus/texture/blank.dds"
local FAB_MARKER = "/FancyActionBarPlus/texture/redarrow.dds"
local FAB_BG = "/FancyActionBarPlus/texture/button_bg.dds"
local FAB_BD_EDGE = "/FancyActionBarPlus/texture/CustomEdge.dds"
local FAB_BD_CENTER = "/FancyActionBarPlus/texture/CustomCenter.dds"
local FAB_Fonts =
{
    ["ProseAntique"] = "$(ANTIQUE_FONT)",
    ["Consolas"] = "/EsoUI/Common/Fonts/consola.slug",
    ["Futura Condensed"] = "$(GAMEPAD_MEDIUM_FONT)",
    ["Futura Condensed Bold"] = "$(GAMEPAD_BOLD_FONT)",
    ["Futura Condensed Light"] = "$(GAMEPAD_LIGHT_FONT)",
    ["Skyrim Handwritten"] = "$(HANDWRITTEN_FONT)",
    ["Trajan Pro"] = "$(STONE_TABLET_FONT)",
    ["Univers 55"] = "$(CHAT_FONT)",
    ["Univers 57"] = "$(MEDIUM_FONT)",
    ["Univers 67"] = "$(BOLD_FONT)",
}
local decimalOptions =
{
    ["Always"] = true,
    ["Expire"] = true,
    ["Never"] = false,
}
local ultModeOptions =
{
    ["Current"] = 1,
    ["Current / Cost (dynamic)"] = 2,
    ["Current / Cost (static)"] = 3,
}
local skillToEditID = "0"
local skillToEditName = ""
local effectToTrackID = 0
local effectToTrackName = ""
local skillEditType = -1
local skillEditChoice = ""
local skillEditTypes =
{
    [-1] = "",
    [0] = "Disable",
    [1] = "Reset",
    [2] = "New ID",
}
local skillEditValues =
{
    [""] = -1,
    ["Disable"] = 0,
    ["Reset"] = 1,
    ["New ID"] = 2,
}
local changedSkillIds = {}
local changedSkillStrings = {}
local selectedChangedSkill = 0

local skillToBlacklistID = 0
local skillToBlacklistName = ""
local blacklistedSkillNames = {}
local blacklistedSkillIds = {}
local selectedBlacklist = 0

local multiTargetSkillToBlacklistID = 0
local multiTargetSkillToBlacklistName = ""
local blacklistedMultiTargetSkillNames = {}
local blacklistedMultiTargetSkillIds = {}
local selectedMultiTargetBlacklist = 0

local debuffToEditID = 0
local debuffToEditName = ""
local debuffNames = {}
local debuffIds = {}
local selectedDebuff = 0

local uiPresets =
{
    [1] = { "None", {} },
    [2] = { "Default UI", FancyActionBar.defaultSettings },
    [3] = { "Dev's Preferred UI", FancyActionBar.devConfig },
    [4] = { "ADR-like UI", FancyActionBar.adrConfig },
}

local presetIgnoreKeys =
{
    ["configChanges"] = true,
    ["externalBlackList"] = true,
    ["multiTargetBlacklist"] = true,
    ["hideOnNoTargetList"] = true,
}

--- @param msg string
--- @param ... any
local function Chat(msg, ...)
    FancyActionBar.Chat(msg, ...)
end


function FancyActionBar.InMenu()
    return inMenu
end

function FancyActionBar.GetFonts()
    local fonts = {}

    -- Add built-in fonts
    for k in pairs(FAB_Fonts) do
        table.insert(fonts, k)
    end

    -- Add fonts from LibMediaProvider if available
    if LMP then
        for _, fontName in pairs(LMP:List(LMP.MediaType.FONT)) do
            -- Only add if we don't already have this font
            if not FAB_Fonts[fontName] then
                FAB_Fonts[fontName] = LMP:Fetch(LMP.MediaType.FONT, fontName)
                table.insert(fonts, fontName)
            end
        end
    end

    return fonts
end

function FancyActionBar.GetPresets()
    local presets = {}
    for k, v in pairs(uiPresets) do
        table.insert(presets, v[1])
    end

    return presets
end

local function SetUIPreset(preset)
    local presetIndex = 0
    for i, v in ipairs(uiPresets) do
        if v[1] == preset then
            presetIndex = i
            break
        end
    end
    local presetSetting = uiPresets[presetIndex]
    local presetData = presetSetting[2]

    for k, v in pairs(presetData) do
        if not presetIgnoreKeys[k] then
            SV[k] = v
        end
    end
    -- ReloadUI("ingame")
end

function FancyActionBar.GetDecimalOptions()
    local options = {}
    for k in pairs(decimalOptions) do
        table.insert(options, k)
    end
    return options
end

function FancyActionBar.IsUnlocked()
    return unlocked
end

-------------------------------------------------------------------------------
-----------------------------[   Font Functions   ]---------------------------
-------------------------------------------------------------------------------

---
--- @return string font
--- @return integer size
--- @return string outline
local function GetCurrentFont()
    local c = FancyActionBar.constants.duration
    return c.font, c.size, c.outline
end

---
--- @return string font
--- @return integer size
--- @return string outline
local function GetCurrentStackFont()
    local c = FancyActionBar.constants.stacks
    return c.font, c.size, c.outline
end

---
--- @return string font
--- @return integer size
--- @return string outline
local function GetCurrentTargetFont()
    local c = FancyActionBar.constants.targets
    return c.font, c.size, c.outline
end

---
--- @return string font
--- @return integer size
--- @return string outline
--- @return string stackFont
--- @return integer stackSize
--- @return string stackOutline
local function GetCurrentQuickSlotTimerFont()
    local c = FancyActionBar.constants.qs
    return c.font, c.size, c.outline, c.stackFont, c.stackSize, c.stackOutline
end

---
--- @return string font
--- @return integer size
--- @return string outline
local function GetCurrentUltFont()
    local c = FancyActionBar.constants.ult.duration
    return c.font, c.size, c.outline
end

---
--- @return string font
--- @return integer size
--- @return string outline
local function GetCurrentUltValueFont()
    local c = FancyActionBar.constants.ult.value
    return c.font, c.size, c.outline
end

-------------------------------------------------------------------------------
-----------------------------[   Local Functions   ]---------------------------
-------------------------------------------------------------------------------

---
--- @param id string|number
--- @return boolean isValidAbility
--- @return boolean isCraftedAbility
local function IsValidId(id)
    local abilityId                                       --- @type string|number?
    local isValidAbility, isCraftedAbility = false, false --- @type boolean, boolean
    if type(id) == "string" then
        local extractedAbilityId, extractedScriptKey = id:match("^(%d+)%-(.+)$")
        if not extractedAbilityId then
            extractedAbilityId = id:match("^(%d+)$")
        end
        abilityId = tonumber(extractedAbilityId)
    elseif type(id) == "number" then
        abilityId = id
    end

    if abilityId == 0 or type(abilityId) ~= "number" then
        return false, false
    end
    isValidAbility = DoesAbilityExist(abilityId)
    if not isValidAbility then
        return isValidAbility, false
    end

    isCraftedAbility = GetAbilityCraftedAbilityId(abilityId) ~= 0

    return isValidAbility, isCraftedAbility
end

local function UpdateAzurahDb()
    if not Azurah then
        return
    end
    if ((IsInGamepadPreferredMode() and Azurah.db.uiData.gamepad["ZO_ActionBar1"])
            or FancyActionBar.useGamepadActionBar and Azurah.db.uiData.keyboard["ZO_ActionBar1"]
            or (FancyActionBar.style == 1 and Azurah.db.uiData.keyboard["ZO_ActionBar1"]))
    then
        Azurah:RecordUserData("ZO_ActionBar1", TOPLEFT, FancyActionBar.constants.move.x, FancyActionBar.constants.move.y,
            FancyActionBar.GetScale())
    end
end

local function SetBarTheme(locked)
    FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
    FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
    FancyActionBar.ApplySettings()
end
----------------------------------------------
-----------[   External Buffs   ]-------------
----------------------------------------------
local function ParseExternalBlacklist()
    for id, name in pairs(SV.externalBlackList) do
        blacklistedSkillIds[id] = name
        blacklistedSkillNames[name] = id
    end
end

local function CanBlacklistId()
    local possible = true
    if skillToBlacklistID == 0 or SV.externalBlackList[skillToBlacklistID] ~= nil then
        possible = false
    end
    return possible
end

local function CanClearBlacklistId()
    local possible = true
    if selectedBlacklist == 0 or SV.externalBlackList[selectedBlacklist] == nil then
        possible = false
    end
    return possible
end

local function GetSkillToBlacklistID()
    local id = ""
    if skillToBlacklistID > 0 then
        id = tostring(skillToBlacklistID)
    end
    return id
end

local function GetSkillToBlacklistName()
    local name = ""
    if skillToBlacklistID > 0 then
        name = "|cffa31a" .. GetAbilityName(skillToBlacklistID) .. "|r"
    end
    return name
end

local function SetSkillToBlacklistID(id)
    local isValid = IsValidId(id)
    if not isValid then
        Chat("|cffffff" .. id .. " is not a valid ID.")
        skillToBlacklistID = 0
        skillToBlacklistName = ""
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToBlacklistTitle").desc:SetText("")
        end
        return
    end

    if tonumber(id) then
        skillToBlacklistID = tonumber(id)
        skillToBlacklistName = GetAbilityName(skillToBlacklistID)
        FancyActionBar:dbg("Skill to blacklist updated to: " .. skillToBlacklistName .. " (" .. skillToBlacklistID .. ")")
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToBlacklistTitle").desc:SetText(skillToBlacklistName)
        end
    end
end

local function GetSelectedBlacklist()
    if blacklistedSkillIds[selectedBlacklist] then
        return blacklistedSkillIds[selectedBlacklist]
    end
end

local function SetSelectedBlacklist(string)
    if string == "== Select a Skill ==" or string == "" or string == nil then
        return
    end
    if blacklistedSkillNames[string] then
        local id = blacklistedSkillNames[string]
        if type(id) == "string" then
            id = tonumber(id)
        end
        if SV.externalBlackList[id] then
            selectedBlacklist = id
            FancyActionBar:dbg("selected " .. string .. " (" .. selectedBlacklist .. ")")
        end
    end
end

local function GetBlacklistedSkills()
    local list = {}
    local default = "== Select a Skill =="
    table.insert(list, default)

    for id, name in pairs(SV.externalBlackList) do
        -- blacklistedSkillIds[id]     = name
        -- blacklistedSkillNames[name] = id
        table.insert(list, name)
    end
    return list
end

local function BlacklistId()
    if CanBlacklistId() then
        SV.externalBlackList[skillToBlacklistID] = skillToBlacklistName

        skillToBlacklistID = 0
        skillToBlacklistName = ""

        ParseExternalBlacklist()
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToBlacklistTitle").desc:SetText("")
            WM:GetControlByName("SkillToBlacklistID_Editbox").editbox:SetText("")
            WM:GetControlByName("Blacklist_Dropdown"):UpdateChoices(GetBlacklistedSkills())
            WM:GetControlByName("Blacklist_Dropdown").dropdown:SetSelectedItem(GetSelectedBlacklist())
        end
    else
        Chat("failed to blacklist: " .. skillToBlacklistName .. " (" .. skillToBlacklistID .. ")")
    end
end

local function ClearBlacklistId()
    if SV.externalBlackList[selectedBlacklist] then
        -- if CanClearBlacklistId() then
        SV.externalBlackList[selectedBlacklist] = nil

        blacklistedSkillNames[blacklistedSkillIds[selectedBlacklist]] = nil
        blacklistedSkillIds[selectedBlacklist] = nil

        -- Chat(selectedBlacklist .. ' clear')
        selectedBlacklist = 0

        ParseExternalBlacklist()
        if not IsConsoleUI() then
            WM:GetControlByName("Blacklist_Dropdown"):UpdateChoices(GetBlacklistedSkills())
            WM:GetControlByName("Blacklist_Dropdown").dropdown:SetSelectedItem(nil)
        end
    end
end

----------------------------------------------
------------[ MultiTarget Effects ]-----------
----------------------------------------------
local function ParseMultiTargetBlacklist()
    for id, name in pairs(SV.multiTargetBlacklist) do
        blacklistedMultiTargetSkillIds[id] = name
        blacklistedMultiTargetSkillNames[name] = id
    end
end

local function CanBlacklistMultiTargetId()
    local possible = true
    if multiTargetSkillToBlacklistID == 0 or SV.multiTargetBlacklist[multiTargetSkillToBlacklistID] ~= nil then
        possible = false
    end
    return possible
end

local function CanClearBlacklistMultiTargetId()
    local possible = true
    if selectedMultiTargetBlacklist == 0 or SV.multiTargetBlacklist[selectedMultiTargetBlacklist] == nil then
        possible = false
    end
    return possible
end

local function GetMultiTargetSkillToBlacklistID()
    local id = ""
    if multiTargetSkillToBlacklistID > 0 then
        id = tostring(multiTargetSkillToBlacklistID)
    end
    return id
end

local function GetMultiTargetSkillToBlacklistName()
    local name = ""
    if multiTargetSkillToBlacklistID > 0 then
        name = "|cffa31a" .. GetAbilityName(multiTargetSkillToBlacklistID) .. "|r"
    end
    return name
end

local function SetMultiTargetSkillToBlacklistID(id)
    local isValid = IsValidId(id)
    if not isValid then
        Chat("|cffffff" .. id .. " is not a valid ID.")
        multiTargetSkillToBlacklistID = 0
        multiTargetSkillToBlacklistName = ""
        if not IsConsoleUI() then
            WM:GetControlByName("MultiTargetSkillToBlacklistTitle").desc:SetText("")
        end
        return
    end

    if tonumber(id) then
        multiTargetSkillToBlacklistID = tonumber(id)
        multiTargetSkillToBlacklistName = GetAbilityName(multiTargetSkillToBlacklistID)
        FancyActionBar:dbg("Skill to blacklist updated to: " .. multiTargetSkillToBlacklistName .. " (" .. multiTargetSkillToBlacklistID .. ")")
        if not IsConsoleUI() then
            WM:GetControlByName("MultiTargetSkillToBlacklistTitle").desc:SetText(multiTargetSkillToBlacklistName)
        end
    end
end

local function GetSelectedMultiTargetBlacklist()
    if blacklistedMultiTargetSkillIds[selectedMultiTargetBlacklist] then
        return blacklistedMultiTargetSkillIds[selectedMultiTargetBlacklist]
    end
end

local function SetSelectedMultiTargetBlacklist(string)
    if string == "== Select a Skill ==" or string == "" or string == nil then
        return
    end
    if blacklistedMultiTargetSkillNames[string] then
        local id = blacklistedMultiTargetSkillNames[string]
        if type(id) == "string" then
            id = tonumber(id)
        end
        if SV.multiTargetBlacklist[id] then
            selectedMultiTargetBlacklist = id
            FancyActionBar:dbg("selected " .. string .. " (" .. selectedMultiTargetBlacklist .. ")")
        end
    end
end

local function GetBlacklistedMultiTargetSkills()
    local list = {}
    local default = "== Select a Skill =="
    table.insert(list, default)

    for id, name in pairs(SV.multiTargetBlacklist) do
        -- blacklistedMultiTargetSkillIds[id]     = name
        -- blacklistedMultiTargetSkillNames[name] = id
        table.insert(list, name)
    end
    return list
end

local function BlacklistMultiTargetId()
    if CanBlacklistMultiTargetId() then
        SV.multiTargetBlacklist[multiTargetSkillToBlacklistID] = multiTargetSkillToBlacklistName

        multiTargetSkillToBlacklistID = 0
        multiTargetSkillToBlacklistName = ""

        ParseMultiTargetBlacklist()
        if not IsConsoleUI() then
            WM:GetControlByName("MultiTargetSkillToBlacklistTitle").desc:SetText("")
            WM:GetControlByName("MultiTargetSkillToBlacklistID_Editbox").editbox:SetText("")
            WM:GetControlByName("MultiTargetBlacklist_Dropdown"):UpdateChoices(GetBlacklistedMultiTargetSkills())
            WM:GetControlByName("MultiTargetBlacklist_Dropdown").dropdown:SetSelectedItem(GetSelectedMultiTargetBlacklist())
        end
    else
        Chat("failed to blacklist: " .. multiTargetSkillToBlacklistName .. " (" .. multiTargetSkillToBlacklistID .. ")")
    end
end

local function ClearMultiTargetBlacklistId()
    if SV.multiTargetBlacklist[selectedMultiTargetBlacklist] then
        -- if CanClearBlacklistMultiTargetId() then
        SV.multiTargetBlacklist[selectedMultiTargetBlacklist] = nil

        blacklistedMultiTargetSkillNames[blacklistedMultiTargetSkillIds[selectedMultiTargetBlacklist]] = nil
        blacklistedMultiTargetSkillIds[selectedMultiTargetBlacklist] = nil

        -- Chat(selectedMultiTargetBlacklist .. ' clear')
        selectedMultiTargetBlacklist = 0

        ParseMultiTargetBlacklist()
        if not IsConsoleUI() then
            WM:GetControlByName("MultiTargetBlacklist_Dropdown"):UpdateChoices(GetBlacklistedMultiTargetSkills())
            WM:GetControlByName("MultiTargetBlacklist_Dropdown").dropdown:SetSelectedItem(nil)
        end
    end
end

----------------------------------------------
-----------[   Debuff Config   ]--------------
----------------------------------------------

--[[
local function ParseExternalBlacklist()
  for id, name in pairs(SV.externalBlackList) do
    blacklistedSkillIds[id]     = name
    blacklistedSkillNames[name] = id
  end
end

local function CanBlacklistId()
  local possible = true
  if skillToBlacklistID == 0 or SV.externalBlackList[skillToBlacklistID] ~= nil then
    possible = false
  end
  return possible
end

local function CanClearBlacklistId()
  local possible = true
  if selectedBlacklist == 0 or SV.externalBlackList[selectedBlacklist] == nil then
    possible = false
  end
  return possible
end

local function GetSkillToBlacklistID()
  local id = ''
  if skillToBlacklistID > 0 then
    id = tostring(skillToBlacklistID)
  end
  return id
end

local function GetSkillToBlacklistName()
  local name = ''
  if skillToBlacklistID > 0 then
    name = '|cffa31a' .. GetAbilityName(skillToBlacklistID) .. '|r'
  end
  return name
end

local function SetSkillToBlacklistID(id)
  if not IsValidId(id) then
    Chat('|cffffff' .. id .. ' is not a valid ID.')
    skillToBlacklistID   = 0
    skillToBlacklistName = ''
    WM:GetControlByName('SkillToBlacklistTitle').desc:SetText('')
    return
  end

  if tonumber(id) then
    skillToBlacklistID   = tonumber(id)
    skillToBlacklistName = GetAbilityName(skillToBlacklistID)
    FancyActionBar:dbg('Skill to blacklist updated to: ' .. skillToBlacklistName .. ' (' .. skillToBlacklistID .. ')' )
    WM:GetControlByName('SkillToBlacklistTitle').desc:SetText(skillToBlacklistName)
  end
end

local function GetSelectedBlacklist()
  if blacklistedSkillIds[selectedBlacklist] then
    return blacklistedSkillIds[selectedBlacklist]
  end
end

local function SetSelectedBlacklist(string)

  if string == '== Select a Skill ==' or string == '' or string == nil then return end
  if blacklistedSkillNames[string] then
    local id = blacklistedSkillNames[string]
    if type(id) == 'string' then
      id = tonumber(id)
    end
    if SV.externalBlackList[id] then
      selectedBlacklist = id
      FancyActionBar:dbg('selected ' .. string .. ' (' .. selectedBlacklist .. ')')
    end
  end
end

local function GetBlacklistedSkills()
  local list    = {}
  local default = '== Select a Skill =='
  table.insert(list, default)

  for id, name in pairs(SV.externalBlackList) do
    -- blacklistedSkillIds[id]     = name
    -- blacklistedSkillNames[name] = id
    table.insert(list, name)
  end
  return list
end

local function BlacklistId()
  if CanBlacklistId() then
    SV.externalBlackList[skillToBlacklistID] = skillToBlacklistName

    skillToBlacklistID   = 0
    skillToBlacklistName = ''

    ParseExternalBlacklist()

    WM:GetControlByName('SkillToBlacklistTitle').desc:SetText('')
    WM:GetControlByName('SkillToBlacklistID_Editbox').editbox:SetText('')
    WM:GetControlByName('Blacklist_Dropdown'):UpdateChoices(GetBlacklistedSkills())
    WM:GetControlByName('Blacklist_Dropdown').dropdown:SetSelectedItem(GetSelectedBlacklist())

  else
    Chat('failed to blacklist: ' .. skillToBlacklistName .. ' (' .. skillToBlacklistID .. ')' )
  end
end

local function ClearDebuff()
  if SV.externalBlackList[selectedBlacklist] then
    SV.externalBlackList[selectedBlacklist] = nil

    local skill = blacklistedSkillIds[selectedBlacklist]
    blacklistedSkillNames[skill] = nil
    blacklistedSkillIds[selectedBlacklist]  = nil

    selectedBlacklist   = 0

    ParseExternalBlacklist()

    WM:GetControlByName('Blacklist_Dropdown'):UpdateChoices(GetBlacklistedSkills())
    WM:GetControlByName('Blacklist_Dropdown').dropdown:SetSelectedItem(nil)
  end
end
]]

----------------------------------------------
-----------[   Ability Config   ]-------------
----------------------------------------------
local function GetTrackedEffectForAbility(id, scriptKey)
    local effect = nil
    local scribedEffect = nil
    local cfg = FancyActionBar.GetAbilityConfig()
    local cstcgf = FancyActionBar.GetAbilityConfigChanges()
    local name = ""

    if cstcgf[id] or cfg[id] then
        if cstcgf[id] ~= nil then
            effect = cstcgf[id]
        elseif cfg[id] ~= nil then
            effect = cfg[id]
        else
            effect = id
        end
        if type(effect) == "table" then
            if scriptKey and (cstcgf[id] and cstcgf[id][2] and cstcgf[id][2][scriptKey]) or (cfg[id] and cfg[id][2] and cfg[id][2][scriptKey]) then
                scribedEffect = cstcgf[id][2][scriptKey] or cfg[id][2][scriptKey]
                if type(scribedEffect) == "table" then
                    local a = scribedEffect[1] or id
                    name = GetAbilityName(a) .. " (" .. a .. ")"
                elseif scribedEffect == true then
                    name = GetAbilityName(id) .. " (" .. id .. ")"
                elseif scribedEffect == false then
                    name = "Disabled"
                else
                    name = "Not Tracked"
                end
            else
                local a = effect[1] ~= nil and effect[1] or id
                if a == false then
                    name = "Disabled"
                else
                    name = GetAbilityName(a) .. " (" .. a .. ")"
                end
            end
        elseif effect == true then
            name = GetAbilityName(id) .. " (" .. id .. ")"
        elseif effect == false then
            name = "Disabled"
        else
            name = "Not Tracked"
        end
    end

    return name
end

local function GetSkillChangeType()
    return skillEditTypes[skillEditType]
    -- local type = skillEditTypes[skillEditType]
    -- if type then return type end
end

local function SetSkillChangeType(type)
    skillEditType = skillEditValues[type]
    skillEditChoice = skillEditTypes[skillEditType]
    -- WM:GetControlByName('Change_Type_Dropdown').dropdown:SetSelectedItem(GetSkillEditChoice)
end

local function GetSkillChangeOptions()
    local options = {}
    for _, v in pairs(skillEditTypes) do
        table.insert(options, v)
    end
    return options
end

local function GetChangedSkills()
    local skills = {}
    local default = "== Select a Skill =="
    local changes = FancyActionBar.GetAbilityConfigChanges()

    table.insert(skills, default)

    for id, cfg in pairs(changes) do
        local craftedId = GetAbilityCraftedAbilityId(id)
        local str = GetAbilityName(id)
        if type(cfg) == "table" then
            if craftedId ~= 0 then
                local craftedAbilityDisplayName = GetCraftedAbilityDisplayName(craftedId)
                if cfg[1] ~= nil then -- Parsing for Fallback IDs
                    if cfg[1] == true then
                        str = str .. " (" .. tostring(id) .. ")"
                    elseif cfg[1] == false then
                        str = str .. " (Disabled)"
                    else
                        str = craftedAbilityDisplayName .. " (" .. tostring(id) .. "=>" .. tostring(cfg[1]) .. ")" .. " " .. GetAbilityName(cfg[1])
                    end
                    changedSkillStrings[id] = str
                    changedSkillIds[str] = id
                    table.insert(skills, str)
                end
                if cfg[2] then
                    for scriptKey, effect in pairs(cfg[2]) do
                        local scribedId = tostring(id) .. "-" .. tostring(scriptKey)
                        local scripts = { scriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
                        local scriptsStr = tostring(" [" ..
                            (GetCraftedAbilityScriptDisplayName(scripts[1]) or "?") ..
                            "/" ..
                            (GetCraftedAbilityScriptDisplayName(scripts[2]) or "?") ..
                            "/" .. (GetCraftedAbilityScriptDisplayName(scripts[3]) or "?") .. "]")
                        local scribedStr = craftedAbilityDisplayName .. scriptsStr
                        if type(effect) == "table" then
                            local a = effect[1]
                            SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), scripts[1], scripts[2], scripts[3])
                            local suffixStr = " (" .. tostring(id) .. "=>" .. tostring(a) .. ")" .. " " .. GetAbilityName(a)
                            scribedStr = scribedStr .. suffixStr
                            ResetCraftedAbilityScriptSelectionOverride()
                        elseif effect == true then
                            scribedStr = scribedStr .. " (" .. tostring(id) .. ")"
                        elseif effect == false then
                            scribedStr = scribedStr .. " (Disabled)"
                        else
                            scribedStr = scribedStr .. " (Not Tracked)"
                        end
                        changedSkillStrings[scribedId] = scribedStr
                        changedSkillIds[scribedStr] = scribedId
                        table.insert(skills, scribedStr)
                    end
                end
            else
                local a = cfg[1] or id
                str = str .. " (" .. tostring(id) .. "=>" .. tostring(a) .. ")" .. " " .. GetAbilityName(a)
                changedSkillStrings[id] = str
                changedSkillIds[str] = id
                table.insert(skills, str)
            end
        else
            if cfg == true then
                str = str .. " (" .. tostring(id) .. ")"
            elseif cfg == false then
                str = str .. " (Disabled)"
            else
                str = str .. " (Not Tracked)"
            end
            changedSkillStrings[id] = str
            changedSkillIds[str] = id
            table.insert(skills, str)
        end
    end
    return skills
end

local function GetSkillToEditID()
    local id = ""
    local isValid, isCrafted = IsValidId(skillToEditID)
    if isValid then
        if isCrafted then
            local extractedAbilityId, extractedScriptKey = skillToEditID:match("^(%d+)%-(.+)$")
            if not extractedAbilityId then
                extractedAbilityId = skillToEditID:match("^(%d+)$")
            end
            extractedAbilityId = tonumber(extractedAbilityId)
            if extractedScriptKey then
                id = tostring(skillToEditID)
            else
                local craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)
                local scripts = { GetCraftedAbilityActiveScriptIds(craftedId) }
                local scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
                if scriptKey ~= "0_0_0" then
                    SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
                    id = tostring(extractedAbilityId) .. "-" .. tostring(scriptKey)
                    ResetCraftedAbilityScriptSelectionOverride()
                    skillToEditID = id
                else
                    id = tostring(extractedAbilityId)
                end
            end
        else
            id = tostring(skillToEditID)
        end
    end
    return id
end

local function GetSkillToEditName() -- Not Working Properly?
    local name = ""
    local scripts = {}
    local isValid = IsValidId(skillToEditID)
    if isValid then
        local extractedAbilityId, extractedScriptKey = skillToEditID:match("^(%d+)%-(.+)$")
        if not extractedAbilityId then
            extractedAbilityId = skillToEditID:match("^(%d+)$")
        end
        extractedAbilityId = tonumber(extractedAbilityId)
        local craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)
        if extractedAbilityId and (craftedId ~= 0) and extractedScriptKey then
            scripts = { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
            SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
            name = "|cffa31a" .. GetAbilityName(extractedAbilityId) .. "|r: " .. GetTrackedEffectForAbility(extractedAbilityId, extractedScriptKey)
            ResetCraftedAbilityScriptSelectionOverride()
        else
            name = "|cffa31a" .. GetAbilityName(extractedAbilityId) .. "|r: " .. GetTrackedEffectForAbility(extractedAbilityId)
        end
    end
    return name
end

local function GetEffectToTrackName()
    local name = ""
    local nameString = ""
    local isValidEffect = IsValidId(effectToTrackID)
    local isValidSkill = IsValidId(skillToEditID)
    if isValidEffect then
        if isValidSkill then
            local extractedAbilityId, extractedScriptKey = skillToEditID:match("^(%d+)%-(.+)$")
            if not extractedAbilityId then
                extractedAbilityId = skillToEditID:match("^(%d+)$")
            end
            extractedAbilityId = tonumber(extractedAbilityId)
            local craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)
            if extractedAbilityId and (craftedId ~= 0) and extractedScriptKey then
                local scripts = { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
                SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
                name = GetAbilityName(effectToTrackID)
                ResetCraftedAbilityScriptSelectionOverride()
            else
                name = GetAbilityName(effectToTrackID)
            end
        else
            name = GetAbilityName(effectToTrackID)
        end
        nameString = "|cffa31a" .. name .. "|r"
    end
    return nameString
end

local function GetEffectToTrackID()
    local id = ""
    local isValid = IsValidId(effectToTrackID)
    if isValid then
        id = tostring(effectToTrackID)
    end
    return id
end

local function GetSelectedChangedSkill()
    local skill = "== Select a Skill =="
    local isValid = IsValidId(selectedChangedSkill)
    if isValid then
        if changedSkillStrings[selectedChangedSkill] then
            skill = changedSkillStrings[selectedChangedSkill]
        end
    end
    return skill
end

local function SetSkillToEditID(id)
    local isValid, isCrafted = IsValidId(id)
    if id == "" or not isValid then
        if id ~= "" then
            Chat("|cffffff" .. id .. " is not a valid ID.")
        end
        skillToEditID = 0
        skillToEditName = ""
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToEditTitle").desc:SetText("")
        end
        return
    end

    local extractedAbilityId, extractedScriptKey = id:match("^(%d+)%-(.+)$")
    if not extractedAbilityId then
        extractedAbilityId = id:match("^(%d+)$")
    end

    if isCrafted then
        local craftedId, scripts, scriptKey
        local scriptsStr = ""

        craftedId = GetAbilityCraftedAbilityId(tonumber(extractedAbilityId))
        scripts = extractedScriptKey and { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
        scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
        if scriptKey ~= "0_0_0" then
            SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
            id = tostring(extractedAbilityId) .. "-" .. tostring(scriptKey)
            skillToEditName = GetCraftedAbilityDisplayName(craftedId)
            ResetCraftedAbilityScriptSelectionOverride()

            scriptsStr = tostring(" [" ..
                (GetCraftedAbilityScriptDisplayName(tonumber(scripts[1]))) ..
                "/" ..
                (GetCraftedAbilityScriptDisplayName(tonumber(scripts[2]))) ..
                "/" .. (GetCraftedAbilityScriptDisplayName(tonumber(scripts[3]))) .. "]")

            skillToEditID = id
            WM:GetControlByName("SkillToEditID_Editbox").editbox:SetText(skillToEditID)
        else
            skillToEditID = extractedAbilityId
            skillToEditName = GetCraftedAbilityDisplayName(craftedId)
        end
        FancyActionBar:dbg("Skill to edit updated to: " .. skillToEditName .. scriptsStr .. " (" .. skillToEditID .. ")")
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToEditTitle").desc:SetText(skillToEditName)
        end
    else
        skillToEditID = extractedAbilityId
        skillToEditName = GetAbilityName(tonumber(skillToEditID))
        FancyActionBar:dbg("Skill to edit updated to: " .. skillToEditName .. " (" .. skillToEditID .. ")")
        if not IsConsoleUI() then
            WM:GetControlByName("SkillToEditTitle").desc:SetText(skillToEditID)
        end
    end
end

local function SetEffectToTrackID(id)
    local isValid = IsValidId(id)
    if id == "" or not isValid then
        if id ~= "" then
            Chat("|cffffff" .. id .. " is not a valid ID.")
        end
        effectToTrackID = 0
        effectToTrackName = ""
        if not IsConsoleUI() then
            WM:GetControlByName("EffectToTrackTitle").desc:SetText("")
        end
        return
    end

    local i = nil
    if tonumber(id) then
        i = tonumber(id)
        effectToTrackID = i
        local isValidEdit = IsValidId(skillToEditID)
        if isValidEdit then
            local extractedAbilityId, extractedScriptKey = skillToEditID:match("^(%d+)%-(.+)$")
            if not extractedAbilityId then
                extractedAbilityId = skillToEditID:match("^(%d+)$")
            end
            extractedAbilityId = tonumber(extractedAbilityId)
            local craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)
            if extractedAbilityId and (craftedId ~= 0) and extractedScriptKey then
                local scripts = { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
                SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
                effectToTrackName = GetAbilityName(effectToTrackID)
                ResetCraftedAbilityScriptSelectionOverride()
            else
                effectToTrackName = GetAbilityName(effectToTrackID)
            end
        else
            effectToTrackName = GetAbilityName(effectToTrackID)
        end

        FancyActionBar:dbg("Effect to track updated to: " .. effectToTrackName .. " (" .. effectToTrackID .. ")")
        if not IsConsoleUI() then
            WM:GetControlByName("EffectToTrackTitle").desc:SetText(effectToTrackName)
        end
    end
end

local function SetChangedSkillToEdit(string)
    if string == "== Select a Skill ==" then
        return
    end
    if changedSkillIds[string] then
        selectedChangedSkill = changedSkillIds[string]
        SetSkillToEditID(tostring(selectedChangedSkill))
    end
end

local function ResetUpdateSettings()
    skillToEditID = 0
    skillToEditName = ""
    effectToTrackID = 0
    effectToTrackName = ""
    skillEditType = -1
    skillEditChoice = skillEditTypes[skillEditType]
    selectedChangedSkill = 0

    if not IsConsoleUI() then
        WM:GetControlByName("SkillToEditTitle").desc:SetText("")
        WM:GetControlByName("EffectToTrackTitle").desc:SetText("")
        WM:GetControlByName("Change_Type_Dropdown"):UpdateChoices(GetSkillChangeOptions())
        WM:GetControlByName("Change_Type_Dropdown").dropdown:SetSelectedItem(GetSkillChangeType())

        WM:GetControlByName("Saved_Changes_Dropdown"):UpdateChoices(GetChangedSkills())
        WM:GetControlByName("Saved_Changes_Dropdown").dropdown:SetSelectedItem(GetSelectedChangedSkill())

        WM:GetControlByName("SkillToEditID_Editbox").editbox:SetText(GetSkillToEditID())
        WM:GetControlByName("EffectToTrackID_Editbox").editbox:SetText("")
    end
end

---
--- @param track integer
--- @param ability integer | string
--- @param effect integer
local function UpdateEffectForAbility(track, ability, effect)
    local config, craftedId, scriptKey
    local extractedAbilityId, extractedScriptKey = ability:match("^(%d+)%-(.+)$")
    --- @cast extractedAbilityId integer
    --- @cast extractedScriptKey string
    local hadScriptKey = extractedScriptKey ~= nil
    if not extractedAbilityId then
        extractedAbilityId = ability:match("^(%d+)$")
    end
    extractedAbilityId = assert(tonumber(extractedAbilityId))
    craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)

    -- These "track" options need to be updated to check if the ability is a crafted ability and then apply the effect to the correct scriptKey
    if track == 0 then -- UNTESTED
        if craftedId ~= 0 then
            local scripts = extractedScriptKey and { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
            scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
            if hadScriptKey and scriptKey ~= "0_0_0" then
                config = { [2] = { [scriptKey] = false } }
            else
                config = false
            end
        else
            config = false
        end
    elseif track == 1 then -- reset data for skill effect, not working properly?
        local customConfig = FancyActionBar.GetAbilityConfigChanges()
        config = customConfig[extractedAbilityId]
        if craftedId ~= 0 then
            local scripts = extractedScriptKey and { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
            scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
            if hadScriptKey and scriptKey ~= "0_0_0" then
                config[2][scriptKey] = nil
                if next(config[2]) == nil then
                    config[2] = nil
                end
                if next(config) == nil then
                    config = nil
                end
            else
                config[1] = nil
                if next(config) == nil then
                    config = nil
                end
            end
        else
            config = nil
            --   config = {}
        end
    elseif track == 2 then -- set new skill effect
        local customConfig = FancyActionBar.GetAbilityConfigChanges()
        config = customConfig[extractedAbilityId] or {}
        if craftedId ~= 0 then
            local scripts = extractedScriptKey and { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
            scriptKey = (scripts[1] or 0) .. "_" .. (scripts[2] or 0) .. "_" .. (scripts[3] or 0)
            if scriptKey ~= "0_0_0" then
                if not config[2] then
                    config[2] = {}
                end

                config[2][scriptKey] = { effect }
            else
                config[1] = effect
            end
        else
            config[1] = effect
        end
    end

    if not CV.useAccountWide then
        if CV.configChanges == nil then
            CV.configChanges = {}
        end
        CV.configChanges[extractedAbilityId] = config
    else
        if SV.configChanges == nil then
            SV.configChanges = {}
        end
        SV.configChanges[extractedAbilityId] = config
    end

    FancyActionBar.BuildAbilityConfig()
    FancyActionBar.SlotCurrentAbilityConfiguration(extractedAbilityId)
    ResetUpdateSettings()
end

local function IsChangePossible()
    local possible = true

    if (skillToEditID == 0 or skillEditType == -1 or (skillEditType > 1 and effectToTrackID == 0)) then
        possible = false
    end

    return not possible
end

local function FormatSkillUpdateMessage()
    local newEffect = 0
    local newEffectName = ""
    local extractedAbilityId, extractedScriptKey = skillToEditID:match("^(%d+)%-(.+)$")
    if not extractedAbilityId then
        extractedAbilityId = skillToEditID:match("^(%d+)$")
    end
    extractedAbilityId = tonumber(extractedAbilityId)

    local craftedId = GetAbilityCraftedAbilityId(extractedAbilityId)

    if craftedId ~= 0 then
        local scripts = extractedScriptKey and { extractedScriptKey:match("^(%d+)_(%d*)_(%d*)$") } or { GetCraftedAbilityActiveScriptIds(craftedId) }
        SetCraftedAbilityScriptSelectionOverride(tonumber(craftedId), tonumber(scripts[1]), tonumber(scripts[2]), tonumber(scripts[3]))
        skillToEditID = extractedAbilityId .. "-" .. scripts[1] .. "_" .. scripts[2] .. "_" .. scripts[3]
        skillToEditName = GetCraftedAbilityDisplayName(craftedId) .. " [" .. GetCraftedAbilityScriptDisplayName(scripts[1]) .. "/" .. GetCraftedAbilityScriptDisplayName(scripts[2]) .. "/" .. GetCraftedAbilityScriptDisplayName(scripts[3]) .. "]"
    end

    if skillEditType > 0 then
        if skillEditType == 1 then
            local old = FancyActionBar.abilityConfig[extractedAbilityId]
            if old ~= nil then
                if old ~= false then
                    if type(old) == "table" then
                        if extractedScriptKey and old[2] and old[2][extractedScriptKey] then
                            newEffect = old[2][extractedScriptKey][1]
                            newEffectName = (tonumber(newEffect) and tonumber(newEffect) > 0) and GetAbilityName(newEffect) or ""
                            ResetCraftedAbilityScriptSelectionOverride()
                        else
                            newEffect = old[1] or extractedAbilityId
                            newEffectName = (tonumber(newEffect) and tonumber(newEffect) > 0) and GetAbilityName(newEffect) or ""
                        end
                    else
                        newEffect = extractedAbilityId
                        newEffectName = (tonumber(newEffect) and tonumber(newEffect) > 0) and GetAbilityName(newEffect) or ""
                    end
                end
            else
                if GetAbilityDuration(extractedAbilityId) > 0 then
                    newEffect = extractedAbilityId
                    newEffectName = (tonumber(newEffect) and tonumber(newEffect) > 0) and GetAbilityName(newEffect) or ""
                end
            end
        elseif skillEditType == 2 then
            newEffect = effectToTrackID
            newEffectName = (tonumber(newEffect) and tonumber(newEffect) > 0) and GetAbilityName(newEffect) or ""
        end
    end

    local message = ""

    if tonumber(newEffect) > 0 then
        message = zo_strformat("Updating |cffa31a<<1>>|r (|cffffff<<2>>|r) effect to: |cffa31a<<3>>|r (|cffffff<<4>>|r)", skillToEditName, skillToEditID, newEffectName, newEffect)
    else
        message = zo_strformat("Tracking of |cffa31a<<1>>|r is now disabled.", skillToEditName)
    end
    if craftedId then
        ResetCraftedAbilityScriptSelectionOverride()
    end

    return message
end

local function ValidateSkillChange()
    local valid = true

    if (skillToEditID == 0 or skillEditType == -1 or (skillEditType > 1 and effectToTrackID == 0)) then
        valid = false
    end

    if valid then
        Chat(FormatSkillUpdateMessage())

        UpdateEffectForAbility(skillEditType, skillToEditID, effectToTrackID)
    else
        Chat("Failed to update effect")
    end
end

local function GetHideOnNoTargetForId(id)
    local hide = false

    local list = FancyActionBar.GetHideOnNoTargetList()

    if list[id] then
        return list[id]
        -- if IsValidId(skillToEditID) then
        -- hide = true
        -- end
    end

    -- return hide
end

local function SetHideOnNoTargetForId(hide)
    if CV.useAccountWide then
        SV.hideOnNoTargetList[skillToEditID] = hide
        -- if not hide then
        --   if SV.hideOnNoTargetList[skillToEditID] then
        --     SV.hideOnNoTargetList[skillToEditID] = nil
        --   end
        -- else
        --   SV.hideOnNoTargetList[skillToEditID] = true
        -- end
    else
        CV.hideOnNoTargetList[skillToEditID] = hide
        -- if not hide then
        --   if CV.hideOnNoTargetList[skillToEditID] then
        --     CV.hideOnNoTargetList[skillToEditID] = nil
        --   end
        -- else
        --   CV.hideOnNoTargetList[skillToEditID] = true
        -- end
    end

    FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = hide

    if FancyActionBar.debuffs[skillToEditID] then
        FancyActionBar.debuffs[skillToEditID].hideOnNoTarget = hide
    end

    -- if hide
    -- then FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = nil
    -- else FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = true end

    FancyActionBar.UpdateHideOnNoTargetForSkill(skillToEditID, hide)
end

local function DisableChangeHideOnNoTargetForId(id)
    if FancyActionBar.abilityConfig[id] then
        return false
    else
        return true
    end
    -- if IsValidId(skillToEditID) then return false else return true end
end

function FancyActionBar.SetHideOnNoTargetGlobalSetting(option)
    if CV.useAccountWide
    then
        SV.hideOnNoTargetGlobal = option
    else
        CV.hideOnNoTargetGlobal = option
    end

    FancyActionBar.constants.hideOnNoTargetGlobal = option

    for id, effect in pairs(FancyActionBar.debuffs) do
        if FancyActionBar.constants.hideOnNoTargetList[id] == nil then
            effect.hideOnNoTarget = option
        end
    end
end

-- local function GetUpdateUsedButtonOnly()
--   if skillToEditID == 0 or not IsValidId(skillToEditID) then return false end
--
--   if CV.useAccountWide then
--     if SV.timeSlotUsedOnly[skillToEditID] == nil then return false end
--     return SV.timeSlotUsedOnly[skillToEditID]
--   end
--
--   if CV.timeSlotUsedOnly[skillToEditID] == nil then return false end
--   return CV.timeSlotUsedOnly[skillToEditID]
-- end
--
-- local function SetUpdateUsedButtonOnly(id, value)
--   if CV.useAccountWide then
--     if SV.timeSlotUsedOnly[id] == nil then
--       SV.timeSlotUsedOnly[id] = true
--     end
--     SV.timeSlotUsedOnly[id] = value
--   else
--     if CV.timeSlotUsedOnly[id] == nil then
--       CV.timeSlotUsedOnly[id] = true
--     end
--     CV.timeSlotUsedOnly[id] = value
--   end
-- end

local function GetCurrentFrontBarInfo()
    local list = ""

    for i = 3, 8 do
        local id = FancyActionBar.GetSlotBoundAbilityId(i, 0)
        local craftedId = GetAbilityCraftedAbilityId(id)
        local line = "empty"
        local name = ""

        if craftedId ~= 0 then
            -- if FancyActionBar.destroSkills[id] then
            --   name = GetAbilityName(FancyActionBar.GetIdForDestroSkill(id, 0));
            --   line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetIdForDestroSkill(id, 0) .. ")";
            -- else
            name = GetCraftedAbilityDisplayName(craftedId)
            local scripts = { GetCraftedAbilityActiveScriptIds(craftedId) }
            local priScript = (scripts[1] and scripts[1] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[1]) or ""
            local secScript = (scripts[2] and scripts[2] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[2]) or ""
            local terScript = (scripts[3] and scripts[3] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[3]) or ""
            line = "|cffa31a" .. name .. "|r (" .. id .. ")" .. ":" .. "\n  " .. priScript .. " (" .. tostring(scripts[1]) .. ")" .. "\n  " .. secScript .. " (" .. tostring(scripts[2]) .. ")" .. "\n  " .. terScript .. " (" .. tostring(scripts[3]) .. ")"
            -- end;
        else
            if id > 0 then
                if FancyActionBar.barHighlightDestroFix[id] then
                    name = GetAbilityName(FancyActionBar.GetCorrectedAbilityId(id, FancyActionBar.weaponFront))
                    line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetCorrectedAbilityId(id, FancyActionBar.weaponFront) .. ")"
                else
                    name = GetAbilityName(id)
                    line = "|cffa31a" .. name .. "|r (" .. id .. ")"
                end
            end
        end

        list = list .. "\n" .. line
    end
    return list
end

local function GetCurrentBackBarInfo()
    local list = ""
    for i = 3, 8 do
        local id = FancyActionBar.GetSlotBoundAbilityId(i, 1)
        local craftedId = GetAbilityCraftedAbilityId(id)
        local line = "empty"
        local name = ""

        if craftedId ~= 0 then
            if id > 0 then
                -- if FancyActionBar.destroSkills[id] then
                --   name = GetAbilityName(FancyActionBar.GetIdForDestroSkill(id, 1));
                --   line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetIdForDestroSkill(id, 1) .. ")";
                -- else
                name = GetCraftedAbilityDisplayName(craftedId)
                local scripts = { GetCraftedAbilityActiveScriptIds(craftedId) }
                local priScript = (scripts[1] and scripts[1] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[1]) or ""
                local secScript = (scripts[2] and scripts[2] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[2]) or ""
                local terScript = (scripts[3] and scripts[3] ~= 0) and GetCraftedAbilityScriptDisplayName(scripts[3]) or ""
                line = "|cffa31a" .. name .. "|r (" .. id .. ")" .. ":" .. "\n  " .. priScript .. " (" .. tostring(scripts[1]) .. ")" .. "\n  " .. secScript .. " (" .. tostring(scripts[2]) .. ")" .. "\n  " .. terScript .. " (" .. tostring(scripts[3]) .. ")"
                -- end;
            end
        else
            if id > 0 then
                if FancyActionBar.barHighlightDestroFix[id] then
                    name = GetAbilityName(FancyActionBar.GetCorrectedAbilityId(id, FancyActionBar.weaponBack))
                    line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetCorrectedAbilityId(id, FancyActionBar.weaponBack) .. ")"
                else
                    name = GetAbilityName(id)
                    line = "|cffa31a" .. name .. "|r (" .. id .. ")"
                end
            end
        end
        list = list .. "\n" .. line
    end
    return list
end

function FancyActionBar.UpdateSlottedSkillsDecriptions()
    if settingsPageCreated then
        Front_Bar_List.desc:SetText(GetCurrentFrontBarInfo())
        Back_Bar_List.desc:SetText(GetCurrentBackBarInfo())
    end
end

----------------------------------------------
-----------[   Label Functions   ]------------
----------------------------------------------

local function GetUltValueOptions()
    local options = {}
    for mode in pairs(ultModeOptions) do
        table.insert(options, mode)
    end
    return options
end

local function GetUltValueMode(ui)
    local vMode
    local mode = ui == 1 and SV.ultValueModeKB or SV.ultValueModeGP
    for option, ultMode in pairs(ultModeOptions) do
        if ultMode == mode then
            vMode = option
            break
        end
    end
    if vMode ~= nil then
        return vMode
    end
end

local function DisplayUltimateSlotTimer(durationControl, duration, timerColor)
    local t = ultDisplayTime - GetFrameTimeSeconds()

    -- Ensure duration is not nil and has a default value if not provided
    duration = duration or 0.01

    -- Ensure settings variables have default values if they are nil
    local showDecimalStart = SV.showDecimalStart or 0
    local showExpireStart = SV.showExpireStart or 0
    local expireColor = SV.expireColor or { 1, 1, 1, 1 } -- Default to white color if not set

    -- Retrieve durationControl using GetControl if it's not already a valid UI element
    if type(durationControl) ~= "userdata" or not durationControl.SetText then
        durationControl = GetControl("UltimateButtonOverlay8", "Duration")
    end

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        if overlay then -- Check if overlay is not nil
            local d = overlay:GetNamedChild("Duration")
            if not d then
                d = FancyActionBar.CreateUltOverlay(i)
            end

            if d then -- Check if d is not nil
                if t <= 0 then
                    d:SetText("")
                    EM:UnregisterForUpdate(FancyActionBar.GetName() .. "UltTimer")
                else
                    -- Check if durationControl is an object with a SetText method
                    if durationControl and durationControl.SetText then
                        if SV.showDecimal and SV.showDecimal ~= "Never" and duration <= showDecimalStart then
                            durationControl:SetText(string.format("%0.1f", zo_max(0, duration)))
                        else
                            durationControl:SetText(zo_max(0, zo_ceil(duration)))
                        end

                        if duration <= showExpireStart then
                            if SV.showExpire then
                                durationControl:SetColor(unpack(expireColor))
                            end
                        else
                            durationControl:SetColor(unpack(timerColor or { 1, 1, 1, 1 })) -- Default to white color if timerColor is nil
                        end
                    else
                        -- Handle the case where durationControl is not a valid UI element
                        error("Invalid durationControl: Expected a UI element, got " .. type(durationControl))
                    end

                    d:SetText(string.format("%0.0f", t))
                end
            end
        end
    end
end

local function DisplayUltimateLabelChanges()
    EM:UnregisterForUpdate(FancyActionBar.GetName() .. "UltTimer")
    ultDisplayTime = GetFrameTimeSeconds() + 30.00
    DisplayUltimateSlotTimer()
    EM:RegisterForUpdate(FancyActionBar.GetName() .. "UltTimer", 100, DisplayUltimateSlotTimer)
end

local function DisplayQuickSlotTimer()
    local d = FancyActionBar.qsOverlay:GetNamedChild("Duration")
    local t = qsDisplayTime - GetFrameTimeSeconds()

    if t <= 0 then
        d:SetText("")
        EM:UnregisterForUpdate(FancyActionBar.GetName() .. "QSTimer")
    else
        d:SetText(string.format("%0.0f", t))
    end
end

local function DisplayQuickSlotLabelChanges()
    EM:UnregisterForUpdate(FancyActionBar.GetName() .. "QSTimer")
    qsDisplayTime = GetFrameTimeSeconds() + 5
    DisplayQuickSlotTimer()
    EM:RegisterForUpdate(FancyActionBar.GetName() .. "QSTimer", 100, DisplayQuickSlotTimer)
end
----------------------------------------------
---------[   Actionbar Position   ]-----------
----------------------------------------------
local function SaveCurrentLocation()
    if not FancyActionBar.wasMoved then
        return
    end
    local x = FAB_Mover:GetLeft()
    local y = FAB_Mover:GetTop()
    if SV.abMove == nil then
        SV.abMove = {}
    end
    -- if IsInGamepadPreferredMode() then
    if FancyActionBar.style == 2 then
        SV.abMove.gp.prevX = x
        SV.abMove.gp.prevY = y
        SV.abMove.gp.enable = true
    else
        SV.abMove.kb.prevX = x
        SV.abMove.kb.prevY = y
        SV.abMove.kb.enable = true
    end
end

local function ReanchorMover()
    local x = ACTION_BAR:GetLeft()
    local y = ACTION_BAR:GetTop()
    FAB_Mover:ClearAnchors()
    FAB_Mover:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y, FAB_Mover:GetResizeToFitConstrains())
end

local function RefreshMoverSize()
    local w, h = ACTION_BAR:GetDimensions()
    FAB_Mover:SetDimensions(w, h)
end
----------------------------------------------
----------------[   Other   ]-----------------
----------------------------------------------

local function ToggleFrameType()
    if SV.useThinFrames then
        RedirectTexture("esoui/art/miscellaneous/gamepad/gp_tooltip_edge_semitrans_16.dds", FAB_BD_EDGE)
        RedirectTexture("esoui/art/miscellaneous/gamepad/gp_tooltip_center_semitrans_16.dds", FAB_BD_CENTER)
    else
        RedirectTexture("esoui/art/miscellaneous/gamepad/gp_tooltip_edge_semitrans_16.dds",
            "esoui/art/miscellaneous/gamepad/gp_tooltip_edge_semitrans_16.dds")
        RedirectTexture("esoui/art/miscellaneous/gamepad/gp_tooltip_center_semitrans_16.dds",
            "esoui/art/miscellaneous/gamepad/gp_tooltip_center_semitrans_16.dds")
    end
end

local function SetDarkUI()
    local eso_root = "esoui/art/"
    local ui_root = "darkui/"
    local theme
    local theme_textures_up = { "actionbar/abilityframe64_up.dds", "abilityframe64_up.dds" }
    local theme_textures_dn = { "actionbar/abilityframe64_down.dds", "abilityframe64_down.dds" }
    local theme_gp_edge = { "miscellaneous/gamepad/gp_tooltip_edge_semitrans_16.dds", "gamepad/gp_tooltip_edge_semitrans_16.dds" }
    local theme_gp_center = { "miscellaneous/gamepad/gp_tooltip_center_semitrans_16.dds", "gamepad/gp_tooltip_center_semitrans_16.dds" }

    local backdrop = { "skillsadvisor/square_abilityframe64_doubleframe.dds", "abilityframe64_up.dds" }
    if darkui.SV.Icon == GetString(DARKUI_LIGHT) then
        theme = "light"
    elseif darkui.SV.Icon == GetString(DARKUI_MIXED) then
        theme = "mixed"
    else
        theme = "dark"
    end
    if framesHidden then
        RedirectTexture(eso_root .. backdrop[1], eso_root .. backdrop[1])
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_textures_up[2], FAB_BLANK)
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_textures_dn[2], FAB_NO_FRAME_DOWN)
    else
        RedirectTexture(eso_root .. backdrop[1], ui_root .. "theme_" .. theme .. "/" .. backdrop[2])
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_textures_up[2],
            ui_root .. "theme_" .. theme .. "/" .. theme_textures_up[2])
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_textures_dn[2],
            ui_root .. "theme_" .. theme .. "/" .. theme_textures_dn[2])
    end
    if SV.useThinFrames then
        RedirectTexture(FAB_BD_EDGE, FAB_BD_EDGE)
        RedirectTexture(eso_root .. theme_gp_edge[1], eso_root .. theme_gp_edge[1])
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2],
            ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2])
        RedirectTexture(eso_root .. theme_gp_edge[1], FAB_BD_EDGE)
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2], FAB_BD_EDGE)

        RedirectTexture(FAB_BD_CENTER, FAB_BD_CENTER)
        RedirectTexture(eso_root .. theme_gp_center[1], eso_root .. theme_gp_center[1])
        RedirectTexture(eso_root .. theme_gp_center[1], FAB_BD_CENTER)
    else
        RedirectTexture(FAB_BD_EDGE, FAB_BD_EDGE)
        RedirectTexture(ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2],
            ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2])
        RedirectTexture(eso_root .. theme_gp_edge[1], eso_root .. theme_gp_edge[1])
        RedirectTexture(eso_root .. theme_gp_edge[1], ui_root .. "theme_" .. theme .. "/" .. theme_gp_edge[2])

        RedirectTexture(FAB_BD_CENTER, FAB_BD_CENTER)
        RedirectTexture(eso_root .. theme_gp_center[1], eso_root .. theme_gp_center[1])
    end
end

local function SetDefaultAbilityFrame()
    local f = { "/esoui/art/actionbar/abilityframe64_up.dds", "/esoui/art/actionbar/abilityframe64_down.dds", FAB_BLANK, FAB_NO_FRAME_DOWN }
    if SV.hideDefaultFrames or SV.forceGamepadStyle then
        RedirectTexture(f[1], f[3])
        RedirectTexture(f[2], f[4])
        framesHidden = true
    else
        if framesHidden then
            RedirectTexture(f[1], f[1])
            RedirectTexture(f[2], f[2])
            framesHidden = false
        end
    end
end

local function GetUltimateFlipCardSize()
    local c = FancyActionBar.GetConstants()
    return c.ultFlipCardSize
end

-- /script local a=ACTION_BAR for i=1,a:GetNumChildren() do local c=a:GetChild(i) local s='' if c.slot ~= nil then s=c.slot.slotNum end  Chat('['..i..']: '..c:GetName()..' / '..s) end
local function CheckDeathState()
    if (IsUnitDead("player") and SV.showDeath) then
        ACTION_BAR:SetHidden(false)
    end
end

if FAB_GCD == nil then
    FAB_GCD = GetControl("FAB_GCD")
end
-------------------------------------------------------------------------------
------------------------------[    Addon Menu    ]-----------------------------
-------------------------------------------------------------------------------
function FancyActionBar.BuildMenu(sv, cv, defaults)
    SV = sv
    CV = cv
    local name = FancyActionBar.GetName() .. "Menu"
    local panel =
    {
        type = "panel",
        name = "Fancy Action Bar+",
        displayName = "Fancy Action Bar+",
        author = "|cFFFF00@andy.s|r, @nogetrandom\nMaintained by: @dack_janiels, @Incanus",
        version = string.format("|c00FF00%s|r", FancyActionBar.GetVersion()),
        registerForRefresh = true,
        -- registerForDefaults = true
    }
    local FAB_Panel = LAM:RegisterAddonPanel(name, panel)

    local function ToggleActionBarInMenu(isHidden)
        local l
        if isHidden then
            ACTION_BAR:SetHidden(false)
            l = "Hide Actionbar"
        else
            ACTION_BAR:SetHidden(true)
            l = "Show Actionbar"
        end

        -- Get the toggle button control
        local toggleButton = WINDOW_MANAGER:GetControlByName("FAB_AB_Toggle")

        -- If the button exists, update its text
        if toggleButton and toggleButton.button then
            toggleButton.button:SetText(l)
        end
    end

    local function BuildOptions()
        local optionsTable = {}
        local tableIndex = 1

        table.insert(optionsTable,
            {
                type = "button",
                name = "Toggle Actionbar Visibility",
                tooltip = "Only applies while in this settings menu.",
                func = function ()
                    ToggleActionBarInMenu(ACTION_BAR:IsHidden())
                end,
                width = "full",
            })
        tableIndex = tableIndex + 1

        -- ===========[	UI Presets	]===================
        table.insert(optionsTable,
            {
                type = "submenu",
                name = "|cFFFACDUI Presets|r",
                controls =
                {
                    {
                        type = "dropdown",
                        name = "Select UI Preset",
                        text = "Selecting a UI Preset requires reloading the game UI to take effect.",
                        scrollable = true,
                        tooltip = "Set a preset UI configuration.",
                        choices = FancyActionBar.GetPresets(),
                        sort = "name-up",
                        getFunc = function ()
                            return uiPresets[1][1]
                        end,
                        setFunc = function (value)
                            SetUIPreset(value)
                        end,
                        default = 1,
                        warning = "Requires Reloading the UI.",
                        requiresReload = true,
                    },
                },
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                type = "submenu",
                name = "|cFFFACDActionbar Size & Position|r",
                controls = {}
            })

        -- ===========[	Actionbar Scaling	]===================
        if not IsConsoleUI() then
            local azurahTable =
            {
                {
                    type = "checkbox",
                    name = "Use Azurah Actionbar Mover",
                    default = defaults.forceAzurahMover,
                    getFunc = function ()
                        return SV.forceAzurahMover
                    end,
                    setFunc = function (value)
                        SV.forceAzurahMover = value or false
                    end,
                    width = "full",
                },
                { type = "divider" },
            }
            if Azurah or SV.forceAzurahMover then
                for k, v in pairs(azurahTable) do
                    table.insert(optionsTable[tableIndex].controls, v)
                end
            end



            local kbScalingTable =
            {
                {
                    type = "description",
                    title = "[ |cffdf80Keyboard UI|r ]",
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = "Enable Actionbar Resize",
                    default = defaults.abScaling.kb.enable,
                    disabled = function ()
                        return SV.forceAzurahMover
                    end,
                    getFunc = function ()
                        return SV.abScaling.kb.enable
                    end,
                    setFunc = function (value)
                        SV.abScaling.kb.enable = value or false
                        if FancyActionBar.style == 1 then
                            FancyActionBar.constants.abScale.enable = value
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "slider",
                    name = "Actionbar Size",
                    default = defaults.abScale,
                    min = 30,
                    max = 250,
                    step = 1,
                    disabled = function ()
                        return SV.forceAzurahMover or not SV.abScaling.kb.enable
                    end,
                    getFunc = function ()
                        return SV.abScaling.kb.scale
                    end,
                    setFunc = function (value)
                        SV.abScaling.kb.scale = value
                        if FancyActionBar.style == 1 then
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.constants.abScale.enable = value
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "checkbox",
                    name = "Unlock Actionbar Position (Keyboard)",
                    default = unlocked,
                    disabled = function ()
                        return FancyActionBar.style == 2 or SV.forceAzurahMover
                    end,
                    getFunc = function ()
                        return FancyActionBar.style == 1 and FancyActionBar.IsUnlocked()
                    end,
                    setFunc = function (value)
                        local _, locked = GetActiveWeaponPairInfo()
                        FancyActionBar.ToggleMover(value)
                        SetBarTheme(locked)
                    end,
                    width = "full",
                },
                { type = "divider" },
            }
            for k, v in pairs(kbScalingTable) do
                table.insert(optionsTable[tableIndex].controls, v)
            end

            local gpScalingTablePC =
            {
                {
                    type = "description",
                    title = "[ |cffdf80Gamepad UI|r ]",
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = "Enable Actionbar Resize",
                    default = defaults.abScaling.gp.enable,
                    disabled = function ()
                        return SV.forceAzurahMover
                    end,
                    getFunc = function ()
                        return SV.abScaling.gp.enable
                    end,
                    setFunc = function (value)
                        SV.abScaling.gp.enable = value or false
                        if FancyActionBar.style == 2 then
                            FancyActionBar.constants.abScale.enable = value
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "slider",
                    name = "Actionbar Size",
                    default = defaults.abScaling.gp.scale,
                    min = 30,
                    max = 250,
                    step = 1,
                    disabled = function ()
                        return SV.forceAzurahMover or not SV.abScaling.gp.enable
                    end,
                    getFunc = function ()
                        return SV.abScaling.gp.scale
                    end,
                    setFunc = function (value)
                        SV.abScaling.gp.scale = value
                        if FancyActionBar.style == 2 then
                            FancyActionBar.constants.abScale.scale = value
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "checkbox",
                    name = "Unlock Actionbar Position (Gamepad)",
                    default = unlocked,
                    disabled = function ()
                        return FancyActionBar.style == 1 or SV.forceAzurahMover
                    end,
                    getFunc = function ()
                        return FancyActionBar.style == 2 and FancyActionBar.IsUnlocked()
                    end,
                    setFunc = function (value)
                        local _, locked = GetActiveWeaponPairInfo()
                        FancyActionBar.ToggleMover(value)
                        SetBarTheme(locked)
                    end,
                    width = "full",
                },
                { type = "divider" },
            }
            for k, v in pairs(gpScalingTablePC) do
                table.insert(optionsTable[tableIndex].controls, v)
            end
        else
            local gpScalingTableConsole =
            {
                {
                    type = "description",
                    title = "[ |cffdf80Gamepad UI|r ]",
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = "Enable Actionbar Resize",
                    default = defaults.abScaling.gp.enable,
                    getFunc = function ()
                        return SV.abScaling.gp.enable
                    end,
                    setFunc = function (value)
                        SV.abScaling.gp.enable = value or false
                        if FancyActionBar.style == 2 then
                            FancyActionBar.constants.abScale.enable = value
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "slider",
                    name = "Actionbar Size",
                    default = defaults.abScaling.gp.scale,
                    min = 30,
                    max = 250,
                    step = 1,
                    disabled = function ()
                        return not SV.abScaling.gp.enable
                    end,
                    getFunc = function ()
                        return SV.abScaling.gp.scale
                    end,
                    setFunc = function (value)
                        SV.abScaling.gp.scale = value
                        if FancyActionBar.style == 2 then
                            FancyActionBar.constants.abScale.scale = value
                            local activeWeaponPair, locked = GetActiveWeaponPairInfo()
                            FancyActionBar.SetScale()
                            FancyActionBar.ToggleMover(true)
                            SetBarTheme(locked)
                            if Azurah then UpdateAzurahDb() end
                            FancyActionBar.ToggleMover(false)
                            SetBarTheme(locked)
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end
                    end,
                    width = "half",
                },
                {
                    type = "description",
                    title = "[ |cffdf80Adjust Actionbar Position|r ]",
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = "Unlock Actionbar Position",
                    default = unlocked,
                    disabled = function ()
                        return FancyActionBar.style == 1
                    end,
                    getFunc = function ()
                        return FancyActionBar.style == 2 and FancyActionBar.IsUnlocked()
                    end,
                    setFunc = function (value)
                        ACTION_BAR:SetHidden(false)
                        local _, locked = GetActiveWeaponPairInfo()
                        FancyActionBar.ToggleMover(value)
                        SetBarTheme(locked)
                    end,
                    width = "full",
                },
                {
                    type = "slider",
                    name = "Horizontal (X) Position",
                    default = 0,
                    min = -GuiRoot:GetWidth(),
                    max = GuiRoot:GetWidth(),
                    step = 1,
                    getFunc = function ()
                        if not FancyActionBar.wasMoved then return 0 end
                        local x = SV.abMove.gp.x or 0
                        local screenWidth = GuiRoot:GetWidth()
                        local barWidth = ACTION_BAR:GetWidth()
                        local _, d = FancyActionBar:GetMovableVarsForUI()
                        local baseX = (screenWidth - barWidth) / 2 + d.x
                        return x - baseX
                    end,
                    setFunc = function (value)
                        FancyActionBar.ConsoleMoveActionBarViaMover(value, nil, true, false)
                    end,
                    width = "half",
                },
                {
                    type = "slider",
                    name = "Vertical (Y) Position",
                    default = 0,
                    min = -GuiRoot:GetHeight(),
                    max = GuiRoot:GetHeight(),
                    step = 1,
                    getFunc = function ()
                        if not FancyActionBar.wasMoved then return 0 end
                        local y = SV.abMove.gp.y or 0
                        local screenHeight = GuiRoot:GetHeight()
                        local barHeight = ACTION_BAR:GetHeight()
                        local _, d = FancyActionBar:GetMovableVarsForUI()
                        local baseY = screenHeight - barHeight + d.y
                        return y - baseY
                    end,
                    setFunc = function (value)
                        FancyActionBar.ConsoleMoveActionBarViaMover(nil, value, false, true)
                    end,
                    width = "half",
                },
                { type = "divider" },
            }
            for k, v in pairs(gpScalingTableConsole) do
                table.insert(optionsTable[tableIndex].controls, v)
            end
        end

        local miscScalingTable =
        {
            {
                type = "button",
                name = "Center Horizontally",
                width = "half",
                func = function ()
                    FancyActionBar.CenterActionBar(true, false)
                end,
                reference = "ABHorizCenter_Button",
            },
            {
                type = "button",
                name = "Center Vertically",
                width = "half",
                func = function ()
                    FancyActionBar.CenterActionBar(false, true)
                end,
                reference = "ABVertCenter_Button",
            },
            { type = "divider" },
            {
                type = "button",
                name = "Undo Last Move",
                width = "half",
                func = function ()
                    FancyActionBar.UndoMove()
                end,
                reference = "ABUndo_Button",
            },
            {
                type = "button",
                name = "Reset Actionbar Position",
                width = "half",
                func = function ()
                    FancyActionBar.ResetMoveActionBar()
                    if IsConsoleUI then
                        -- I have no idea why this needs a second delayed call on console but it does.
                        zo_callLater(function ()
                            FancyActionBar.ResetMoveActionBar()
                        end, 10)
                    end
                end,
                reference = "ABReset_Button",
            },
            { type = "divider" },
            {
                type = "description",
                title = "[ |cffdf80Adjust Quickslot Slot Position|r ]",
                width = "full",
            },
            {
                type = "slider",
                name = "Horizontal (X) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.quickSlotCustomXOffsetGP or defaults.quickSlotCustomXOffsetKB,
                min = -1200,
                max = 1200,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.quickSlotCustomXOffsetGP or SV.quickSlotCustomXOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.quickSlotCustomXOffsetGP = value
                    else
                        SV.quickSlotCustomXOffsetKB = value
                    end
                    FancyActionBar.AdjustQuickSlotSpacing()
                    -- FancyActionBar.ApplySettings();
                end,
                width = "half",
            },
            {
                type = "slider",
                name = "Vertical (Y) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.quickSlotCustomYOffsetGP or defaults.quickSlotCustomYOffsetKB,
                min = -600,
                max = 600,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.quickSlotCustomYOffsetGP or SV.quickSlotCustomYOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.quickSlotCustomYOffsetGP = value
                    else
                        SV.quickSlotCustomYOffsetKB = value
                    end
                    FancyActionBar.AdjustQuickSlotSpacing()
                    -- FancyActionBar.ApplySettings();
                end,
                width = "half",
            },
            { type = "divider" },
            {
                type = "description",
                title = "[ |cffdf80Adjust Ultimate Slot Position|r ]",
                width = "full",
            },
            {
                type = "slider",
                name = "Horizontal (X) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.ultimateSlotCustomXOffsetGP or defaults.ultimateSlotCustomXOffsetKB,
                min = -1200,
                max = 1200,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.ultimateSlotCustomXOffsetGP or SV.ultimateSlotCustomXOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.ultimateSlotCustomXOffsetGP = value
                    else
                        SV.ultimateSlotCustomXOffsetKB = value
                    end
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                end,
                width = "half",
            },
            {
                type = "slider",
                name = "Vertical (Y) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.ultimateSlotCustomYOffsetGP or defaults.ultimateSlotCustomYOffsetKB,
                min = -600,
                max = 600,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.ultimateSlotCustomYOffsetGP or SV.ultimateSlotCustomYOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.ultimateSlotCustomYOffsetGP = value
                    else
                        SV.ultimateSlotCustomYOffsetKB = value
                    end
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                end,
                width = "half",
            },
            { type = "divider" },
            {
                type = "description",
                title = "[ |cffdf80Adjust Bar Spacing and Offset|r ]",
                width = "full",
            },
            {
                type = "slider",
                name = "Horizontal (X) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.barXOffsetGP or defaults.barXOffsetKB,
                min = -1200,
                max = 1200,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.barXOffsetGP or SV.barXOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.barXOffsetGP = value
                    else
                        SV.barXOffsetKB = value
                    end
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
                    FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                end,
                width = "half",
            },
            {
                type = "slider",
                name = "Vertical (Y) Position",
                default = FancyActionBar.useGamepadActionBar and defaults.barYOffsetGP or defaults.barYOffsetKB,
                min = -600,
                max = 600,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.barYOffsetGP or SV.barYOffsetKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.barYOffsetGP = value
                    else
                        SV.barYOffsetKB = value
                    end
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
                    FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                    if not FancyActionBar.wasMoved then
                        FancyActionBar.ResetMoveActionBar()
                        FancyActionBar.RepositionHealthBar()
                    end
                end,
                width = "half",
            },
            {
                type = "slider",
                name = "Button (X) Spacing",
                default = FancyActionBar.useGamepadActionBar and defaults.abilitySlotOffsetXGP or defaults.abilitySlotOffsetXKB,
                min = -600,
                max = 600,
                step = 1,
                getFunc = function ()
                    return FancyActionBar.useGamepadActionBar and SV.abilitySlotOffsetXGP or SV.abilitySlotOffsetXKB
                end,
                setFunc = function (value)
                    if FancyActionBar.useGamepadActionBar then
                        SV.abilitySlotOffsetXGP = value
                    else
                        SV.abilitySlotOffsetXKB = value
                    end
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
                    FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                end,
                width = "half",
            },
        }
        for k, v in pairs(miscScalingTable) do
            table.insert(optionsTable[tableIndex].controls, v)
        end
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                type = "submenu",
                name = "|cFFFACDGeneral|r",
                controls =
                {

                    -- ============[	Font/Back Bar Settings	]===============
                    {
                        type = "description",
                        title = "[ |cffdf80Front & Back Bars Position|r ]",
                        text = "All changes will take effect after doing a weapon swap.",
                        width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Static bar positions",
                        tooltip = "Front bar and back bar will not switch places on weapon swap.",
                        default = defaults.staticBars,
                        getFunc = function ()
                            return SV.staticBars
                        end,
                        setFunc = function (value)
                            SV.staticBars = value or false
                            FancyActionBar.UpdateBarSettings()
                        end,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Front bar on top (only for static bars)",
                        tooltip = "ON = Front bar on top and back bar on bottom.\nOFF = Front bar on bottom and back bar on top.",
                        default = defaults.frontBarTop,
                        disabled = function ()
                            return not SV.staticBars
                        end,
                        getFunc = function ()
                            return SV.frontBarTop
                        end,
                        setFunc = function (value)
                            SV.frontBarTop = value or false
                        end,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Active bar on top (not for static bars)",
                        tooltip = "ON = Active bar on top.\nOFF = Active bar on bottom.",
                        default = defaults.activeBarTop,
                        disabled = function ()
                            return SV.staticBars
                        end,
                        getFunc = function ()
                            return SV.activeBarTop
                        end,
                        setFunc = function (value)
                            SV.activeBarTop = value or false
                        end,
                        width = "half",
                    },

                    -- ============[	Backbar Visuals	]=====================
                    {
                        type = "description",
                        title = "[ |cffdf80Back Bar Visibility|r ]",
                        text = "",
                        width = "full",
                    },
                    {
                        type = "slider",
                        name = "Inactive bar alpha",
                        tooltip = "Higher value = more solid.\nLower value = more see through.",
                        default = defaults.alphaInactive,
                        min = 0,
                        max = 100,
                        step = 1,
                        getFunc = function ()
                            return SV.alphaInactive
                        end,
                        setFunc = function (value)
                            SV.alphaInactive = value
                            FancyActionBar.ApplyAlphaInactive(value)
                        end,
                        width = "half",
                    },
                    {
                        type = "slider",
                        name = "Inactive bar desaturation",
                        tooltip = "Higher value = more grey.\nLower value = more colors.",
                        default = defaults.desaturationInactive,
                        min = 0,
                        max = 100,
                        step = 1,
                        getFunc = function ()
                            return SV.desaturationInactive
                        end,
                        setFunc = function (value)
                            FancyActionBar.ApplyDesaturationInactiveInactive(value)
                        end,
                        width = "half",
                    },
                    { type = "description", text = "", width = "full" },

                    -- ============[	Keybinds On / Off	]===================
                    {
                        type = "description",
                        title = "[ |cffdf80Hotkey Text|r ]",
                        text = "",
                        width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Show hotkeys",
                        tooltip = "Show hotkeys under the action bar.",
                        default = defaults.showHotkeys,
                        getFunc = function ()
                            return SV.showHotkeys
                        end,
                        setFunc = function (value)
                            SV.showHotkeys = value or false
                            FancyActionBar.HideHotkeys(not SV.showHotkeys)
                        end,
                        width = "half",
                    },
                    { type = "description", text = "", width = "half" },
                },
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                -- ============[	UI Customization	]===================
                type = "submenu",
                name = "|cFFFACDUI Customization|r",
                controls = {}
            })

        if not IsConsoleUI() then
            local kbCustomizationTable =
            {
                -- ============[	Button Frames	]=======================
                {
                    type = "description",
                    title = "[ |cffdf80Button Frames|r ]",
                    text = "Only for keyboard UI.",
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = "Show frames",
                    tooltip = "Show a frame around buttons on the actionbar.",
                    default = defaults.showFrames,
                    disabled = function ()
                        return (FancyActionBar.style == 2 or SV.forceGamepadStyle)
                    end, -- IsInGamepadPreferredMode() end,
                    getFunc = function ()
                        return SV.showFrames
                    end,
                    setFunc = function (value)
                        SV.showFrames = value or false
                        FancyActionBar.ConfigureFrames()
                    end,
                    width = "half",
                },
                {
                    type = "colorpicker",
                    name = "Frame color",
                    default = ZO_ColorDef:New(unpack(defaults.frameColor)),
                    disabled = function ()
                        return (FancyActionBar.style == 2 --[[IsInGamepadPreferredMode()]] or (not SV.showFrames))
                    end,
                    getFunc = function ()
                        return unpack(SV.frameColor)
                    end,
                    setFunc = function (r, g, b, a)
                        SV.frameColor = { r, g, b, a }
                        FancyActionBar.SetFrameColor()
                    end,
                    width = "half",
                },
                {
                    type = "checkbox",
                    name = "Hide default frames",
                    tooltip = "Hide the default actionbutton frames.\nIf the setting was enabled then you need to reload UI when disabling in order for inactive bar to display them correctly.",
                    default = defaults.hideDefaultFrames,
                    disabled = function ()
                        return FancyActionBar.style == 2
                    end, -- IsInGamepadPreferredMode() end,
                    getFunc = function ()
                        return SV.hideDefaultFrames
                    end,
                    setFunc = function (value)
                        SV.hideDefaultFrames = value or false
                        FancyActionBar.ConfigureFrames()
                    end,
                    width = "half",
                },
                { type = "divider" },
            }
            for k, v in pairs(kbCustomizationTable) do
                table.insert(optionsTable[tableIndex].controls, v)
            end
        end

        local gpMiscCustomizationTable =
        {
            -- ============[	Active Highlight	]===================
            {
                type = "description",
                title = "[ |cffdf80Active Ability Highlight|r ]",
                text = "",
                width = "full",
            },
            {
                type = "checkbox",
                name = "Show highlight",
                tooltip = "Active skills will be highlighted.",
                default = defaults.showHighlight,
                getFunc = function ()
                    return SV.showHighlight
                end,
                setFunc = function (value)
                    SV.showHighlight = value or false
                end,
                width = "half",
            },
            {
                type = "colorpicker",
                name = "Highlight color",
                default = ZO_ColorDef:New(unpack(defaults.highlightColor)),
                disabled = function ()
                    return not SV.showHighlight
                end,
                getFunc = function ()
                    return unpack(SV.highlightColor)
                end,
                setFunc = function (r, g, b, a)
                    SV.highlightColor = { r, g, b, a }
                end,
                width = "half",
            },
            { type = "divider" },

            -- ============[   Toggled Highlight  ]===================
            {
                type = "description",
                title = "[ |cffdf80Toggled Ability Highlight|r ]",
                text = "If a toggled ability is activated you can choose to have the highlight display a different color by setting the following option to <On>. Toggled abilities will also be highlighted regardless of the <Show highlight> option if <Toggled highlight> is enabled. If disabled, the highlight will use your settings from above.",
                width = "full",
            },
            {
                type = "checkbox",
                name = "Toggled highlight",
                default = defaults.toggledHighlight,
                getFunc = function ()
                    return SV.toggledHighlight
                end,
                setFunc = function (value)
                    SV.toggledHighlight = value or false
                end,
                width = "half",
            },
            {
                type = "colorpicker",
                name = "Toggled highlight color",
                default = ZO_ColorDef:New(unpack(defaults.toggledColor)),
                disabled = function ()
                    return not SV.toggledHighlight
                end,
                getFunc = function ()
                    return unpack(SV.toggledColor)
                end,
                setFunc = function (r, g, b, a)
                    SV.toggledColor = { r, g, b, a }
                end,
                width = "half",
            },
            { type = "divider" },

            -- ============[  Active Bar Arrow  ]=====================
            {
                type = "description",
                title = "[ |cffdf80Active Bar Arrow|r ]",
                text = "Weapon swap once after clicking the Show arrow button to make the change take effect.",
                width = "full",
            },
            {
                type = "checkbox",
                name = "Show arrow",
                tooltip = "Show an arrow near the currently active bar.",
                default = defaults.showArrow,
                getFunc = function ()
                    return SV.showArrow
                end,
                setFunc = function (value)
                    SV.showArrow = value or false
                    FancyActionBar.AdjustQuickSlotSpacing()
                    FancyActionBar.AdjustUltimateSpacing()
                end,
                width = "half",
            },
            {
                type = "colorpicker",
                name = "Arrow color",
                default = ZO_ColorDef:New(unpack(defaults.arrowColor)),
                disabled = function ()
                    return not SV.showArrow
                end,
                getFunc = function ()
                    return unpack(SV.arrowColor)
                end,
                setFunc = function (r, g, b, a)
                    SV.arrowColor = { r, g, b, a }
                    FAB_ActionBarArrow:SetColor(unpack(SV.arrowColor))
                end,
                width = "half",
            },
            { type = "divider" },

            -- =============[  Quickslot Position  ]==================
            {
                type = "checkbox",
                name = "Adjust Quickslot placement",
                tooltip = "Move Quickslot closer to the Action Bar if the arrow is hidden.\nFor gamepad UI this will also adjust the gap between normal skill buttons and the ultimate button, as well as the gap between the ultimate button and the companion ultimate button (|cff6600Only|r if gamepad ult hotkeys are hidden).",
                default = defaults.moveQS,
                getFunc = function ()
                    return SV.moveQS
                end,
                setFunc = function (value)
                    SV.moveQS = value or false
                    FancyActionBar.AdjustQuickSlotSpacing()
                    FancyActionBar.AdjustUltimateSpacing()
                end,
                width = "half",
            },
            -- =============[  Miscellaneous  ]=================
            { type = "divider" },
            {
                type = "description",
                title = "[ |cffdf80Miscellaneous|r ]",
                text = "Additional Miscellaneous Options.",
                width = "full",
            },
            {
                type = "checkbox",
                name = "Force enable gamepad Action Bar style",
                tooltip =
                "The gamepad UI enables additional action bar animations and styling, by default this is only available when using a controller, or after enabling Accessibility Mode. This setting force enables these additional UI elements. Adapted with permission from Animated Action Bar by @Geldis1306 and @undcdd.",
                default = defaults.forceGamepadStyle,
                getFunc = function ()
                    return SV.forceGamepadStyle
                end,
                setFunc = function (value)
                    SV.forceGamepadStyle = value or false
                    FancyActionBar.updateUI = true
                    FancyActionBar.useGamepadActionBar = IsInGamepadPreferredMode() or SV.forceGamepadStyle
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.UpdateBarSettings(SV.hideLockedBar and locked)
                    FancyActionBar.AdjustQuickSlotSpacing(SV.hideLockedBar and locked)
                    FancyActionBar.ApplyActiveHotbarStyle()
                    FancyActionBar.ApplyQuickSlotAndUltimateStyle()
                    FancyActionBar.ApplySettings()
                    FancyActionBar.ToggleFillAnimationsAndFrames(FancyActionBar.useGamepadActionBar)
                    FancyActionBar.updateUI = false
                end,
                width = "full",
            },
            {
                type = "checkbox",
                name = "Show gamepad ultimate hotkeys",
                tooltip = "Show the LB RB labels for gamepad UI.",
                default = defaults.showHotkeysUltGP,
                getFunc = function ()
                    return SV.showHotkeysUltGP
                end,
                setFunc = function (value)
                    SV.showHotkeysUltGP = value or false
                    FancyActionBar.HideHotkeys(not SV.showHotkeys)
                    FancyActionBar.AdjustUltimateSpacing()
                end,
                disabled = function ()
                    return not FancyActionBar.style == 2
                end, -- IsInGamepadPreferredMode() end,
                width = "full",
            },
            {
                type = "checkbox",
                name = "Use thin gamepad button frame borders",
                tooltip = "",
                default = defaults.useThinFrames,
                disabled = function ()
                    return not FancyActionBar.style == 2
                end, -- IsInGamepadPreferredMode() end,
                getFunc = function ()
                    return SV.useThinFrames
                end,
                setFunc = function (value)
                    SV.useThinFrames = value or false
                    FancyActionBar.ConfigureFrames()
                end,
                width = "full",
            },
            {
                type = "checkbox",
                name = "Hide companion ultimate slot",
                tooltip = "Hide the companion ultimate slot regardless of the companion having a slotted ultimate or not.",
                default = defaults.hideCompanionUlt,
                getFunc = function ()
                    return SV.hideCompanionUlt
                end,
                setFunc = function (value)
                    SV.hideCompanionUlt = value or false
                    FancyActionBar.HandleCompanionUltimate()
                end,
                width = "full",
            },
            -- =============[  OneBar Mode  ]==================
            {
                type = "checkbox",
                name = "Hide locked Action Bars",
                tooltip = "If enabled, locked, inactive, action bars will be hidden, such when Oakensoul is equipped or the Werewolf transformation is activated.",
                default = defaults.hideLockedBar,
                getFunc = function ()
                    return SV.hideLockedBar
                end,
                setFunc = function (value)
                    SV.hideLockedBar = value or false
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.OnWeaponSwapLocked(locked, nil, true, SV.hideLockedBar)
                end,
                width = "full"
            },
            {
                type = "checkbox",
                name = "Reposition active bar when locked",
                tooltip = "When the locked action bar is hidden the ui will reposition the active bar.",
                default = defaults.repositionActiveBar,
                getFunc = function ()
                    return SV.repositionActiveBar
                end,
                setFunc = function (value)
                    SV.repositionActiveBar = value or false
                    local _, locked = GetActiveWeaponPairInfo()
                    FancyActionBar.OnWeaponSwapLocked(locked, nil, true, SV.hideLockedBar)
                end,
                width = "full"
            },
            {
                type = "checkbox",
                name = "Hide inactive slots on inactive bars",
                tooltip = "Hide inactive action bar slots (slots without an active timer) on the inactive action bar.",
                default = defaults.hideInactiveSlots,
                getFunc = function ()
                    return SV.hideInactiveSlots
                end,
                setFunc = function (value)
                    SV.hideInactiveSlots = value or false
                end,
                width = "full"
            },
            -- =============[  Skill Styles  ]==================
            {
                type = "checkbox",
                name = "Apply skill styles to Action Bar slots",
                tooltip = "If a given skill style override is unlocked and activated, and the applicable ability is slotted on the action bar, use the skill style icon instead of the ability icon .",
                default = defaults.applyActionBarSkillStyles,
                getFunc = function ()
                    return SV.applyActionBarSkillStyles
                end,
                setFunc = function (value)
                    SV.applyActionBarSkillStyles = value or false
                    FancyActionBar.ApplyAbilityFxOverrides(true)
                end,
                width = "full",
            },
        }
        for k, v in pairs(gpMiscCustomizationTable) do
            table.insert(optionsTable[tableIndex].controls, v)
        end
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                type = "submenu",
                name = "|cFFFACDTimer Display|r",
                controls = {}
            })

        table.insert(optionsTable[tableIndex].controls,
            {
                type = "submenu",
                name = "|cFFFACDInfo|r",
                controls =
                {
                    {
                        type = "description",
                        text = FancyActionBar.strings.subTimerDesc,
                        width = "full",
                    },
                },
            })

        -- ============[ Keyboard UI ]=========================
        if not IsConsoleUI() then
            table.insert(optionsTable[tableIndex].controls,
                {
                    type = "submenu",
                    name = "|cFFFACDKeyboard UI|r",
                    controls =
                    {

                        -- ============[ Keyboard Duration ]====================
                        {
                            type = "submenu",
                            name = "|cFFFACDTimer Display Settings|r",
                            controls =
                            {
                                {
                                    type = "dropdown",
                                    name = "Timer font",
                                    scrollable = true,
                                    tooltip = "Select which font to display the timer in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontNameKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontNameKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.duration.font = value
                                            FancyActionBar.ApplyTimerFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.fontNameKB,
                                },
                                {
                                    type = "slider",
                                    name = "Timer font size",
                                    min = 10,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.fontSizeKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontSizeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.duration.size = value
                                            FancyActionBar.ApplyTimerFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.fontSizeKB,
                                },
                                {
                                    type = "dropdown",
                                    name = "Timer font style",
                                    tooltip = "Select which effect to display the timer font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontTypeKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontTypeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.duration.outline = value
                                            FancyActionBar.ApplyTimerFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.fontTypeKB,
                                },
                                {
                                    type = "slider",
                                    name = "Adjust timer height",
                                    tooltip = "Move timer [<- down] or [up ->]",
                                    default = defaults.timeYKB,
                                    min = -15,
                                    max = 15,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.timeYKB
                                    end,
                                    setFunc = function (value)
                                        SV.timeYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.duration.y = value
                                            FancyActionBar.AdjustTimerY()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "colorpicker",
                                    name = "Timer color",
                                    default = ZO_ColorDef:New(unpack(defaults.timeColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.timeColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.timeColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.duration.color = SV.timeColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },

                        -- ============[ Keyboard Stacks ]======================
                        {
                            type = "submenu",
                            name = "|cFFFACDStacks Display Settings|r",
                            controls =
                            {
                                {
                                    type = "dropdown",
                                    name = "Stacks font",
                                    scrollable = true,
                                    tooltip = "Select which font to display ability stacks for the keyboard UI in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontNameStackKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontNameStackKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.font = value
                                            FancyActionBar.ApplyStackFont()
                                        end
                                    end,
                                    default = defaults.fontNameStackKB,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Stacks font size",
                                    min = 10,
                                    max = 25,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.fontSizeStackKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontSizeStackKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.size = value
                                            FancyActionBar.ApplyStackFont()
                                        end
                                    end,
                                    default = defaults.fontSizeStackKB,
                                    width = "half",
                                },
                                {
                                    type = "dropdown",
                                    name = "Stack font style",
                                    tooltip = "Select which effect to display the stacks font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontTypeStackKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontTypeStackKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.outline = value
                                            FancyActionBar.ApplyStackFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.fontTypeStackKB,
                                },
                                {
                                    type = "colorpicker",
                                    name = "Stack color",
                                    default = ZO_ColorDef:New(unpack(defaults.stackColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.stackColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.stackColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.color = SV.stackColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizonal position",
                                    tooltip = "Move stacks [<- left] or [right ->]",
                                    default = defaults.stackXKB,
                                    min = 0,
                                    max = 40,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.stackXKB
                                    end,
                                    setFunc = function (value)
                                        SV.stackXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.x = value
                                            FancyActionBar.AdjustStackX()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Vertical position",
                                    tooltip = "Move stacks [<- up] or [down ->]",
                                    default = defaults.stackYKB,
                                    min = 0,
                                    max = 40,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.stackYKB
                                    end,
                                    setFunc = function (value)
                                        SV.stackYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.stacks.y = value
                                            FancyActionBar.AdjustStackY()
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },

                        -- ============[ Keyboard Targets ]======================
                        {
                            type = "submenu",
                            name = "|cFFFACDTargets Display Settings|r",
                            controls =
                            {
                                {
                                    type = "dropdown",
                                    name = "Targets font",
                                    scrollable = true,
                                    tooltip = "Select which font to display ability targets for the keyboard UI in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontNameTargetKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontNameTargetKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.font = value
                                            FancyActionBar.ApplyTargetFont()
                                        end
                                    end,
                                    default = defaults.fontNameTargetKB,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Targets font size",
                                    min = 10,
                                    max = 25,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.fontSizeTargetKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontSizeTargetKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.size = value
                                            FancyActionBar.ApplyTargetFont()
                                        end
                                    end,
                                    default = defaults.fontSizeTargetKB,
                                    width = "half",
                                },
                                {
                                    type = "dropdown",
                                    name = "Target font style",
                                    tooltip = "Select which effect to display the targets font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.fontTypeTargetKB
                                    end,
                                    setFunc = function (value)
                                        SV.fontTypeTargetKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.outline = value
                                            FancyActionBar.ApplyTargetFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.fontTypeTargetKB,
                                },
                                {
                                    type = "colorpicker",
                                    name = "Target color",
                                    default = ZO_ColorDef:New(unpack(defaults.targetColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.targetColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.targetColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.color = SV.targetColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizontal position",
                                    tooltip = "Move targets [<- left] or [right ->]",
                                    default = defaults.targetXKB,
                                    min = 0,
                                    max = 40,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.targetXKB
                                    end,
                                    setFunc = function (value)
                                        SV.targetXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.x = value
                                            FancyActionBar.AdjustTargetX()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Vertical position",
                                    tooltip = "Move targets [<- up] or [down ->]",
                                    default = defaults.targetYKB,
                                    min = 0,
                                    max = 40,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.targetYKB
                                    end,
                                    setFunc = function (value)
                                        SV.targetYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.targets.y = value
                                            FancyActionBar.AdjustTargetY()
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },

                        -- ==========[ Keyboard Ultimate Duration ]=============
                        {
                            type = "submenu",
                            name = "|cFFFACDUltimate Timer Settings|r",
                            controls =
                            {
                                {
                                    type = "checkbox",
                                    name = "Display Ultimate Timer",
                                    default = defaults.ultShowKB,
                                    getFunc = function ()
                                        return SV.ultShowKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultShowKB = value or false
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.show = value
                                            -- FancyActionBar.ToggleUltimateValue()
                                        end
                                    end,
                                    width = "half",
                                },
                                { type = "description", text = "", width = "full" },
                                {
                                    type = "dropdown",
                                    name = "Ultimate timer font",
                                    scrollable = true,
                                    tooltip = "Select which font to display the timer in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.ultNameKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultNameKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.font = value
                                            FancyActionBar.ApplyUltFont(true)
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultNameKB,
                                },
                                {
                                    type = "slider",
                                    name = "Ultimate timer font size",
                                    min = 10,
                                    max = 30,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultSizeKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultSizeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.size = value
                                            FancyActionBar.ApplyUltFont(true)
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultSizeKB,
                                },
                                {
                                    type = "dropdown",
                                    name = "Ultimate timer font style",
                                    tooltip = "Select which effect to display the timer font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.ultTypeKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultTypeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.outline = value
                                            FancyActionBar.ApplyUltFont(true)
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultTypeKB,
                                },
                                {
                                    type = "colorpicker",
                                    name = "Ultimate timer color",
                                    default = ZO_ColorDef:New(unpack(defaults.ultColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.ultColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.ultColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.color = SV.ultColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Vertical",
                                    tooltip = "[<- down] or [up ->]",
                                    default = defaults.ultYKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultYKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.y = value
                                            FancyActionBar.AdjustUltTimer(true)
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizontal",
                                    tooltip = "[<- left] or [right ->]",
                                    default = defaults.ultXKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultXKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.duration.x = value
                                            FancyActionBar.AdjustUltTimer(true)
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },

                        -- ===========[ Keyboard Ultimate Value ]===============
                        {
                            type = "submenu",
                            name = "|cFFFACDUltimate Value Settings|r",
                            controls =
                            {
                                {
                                    type = "checkbox",
                                    name = "Display ultimate number",
                                    default = defaults.ultValueEnableKB,
                                    getFunc = function ()
                                        return SV.ultValueEnableKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueEnableKB = value or false
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.show = value
                                            FancyActionBar.ToggleUltimateValue()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "dropdown",
                                    name = "Display Mode",
                                    tooltip = "Dynamic: display current / cost if current is lower than cost and only current when you have enough to cast it.\nStatic: always display current / cost.",
                                    choices = GetUltValueOptions(),
                                    getFunc = function ()
                                        return GetUltValueMode(1)
                                    end,
                                    setFunc = function (mode)
                                        SV.ultValueModeKB = ultModeOptions[mode]
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.mode = SV.ultValueModeKB
                                            FancyActionBar.UpdateUltValueMode()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "dropdown",
                                    name = "Ultimate value font",
                                    scrollable = true,
                                    tooltip = "Select which font to display the value in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.ultValueNameKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueNameKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.font = value
                                            FancyActionBar.ApplyUltValueFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultValueNameKB,
                                },
                                {
                                    type = "slider",
                                    name = "Ultimate value font size",
                                    min = 10,
                                    max = 60,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultValueSizeKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueSizeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.size = value
                                            FancyActionBar.ApplyUltValueFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultValueSizeKB,
                                },
                                {
                                    type = "dropdown",
                                    name = "Ultimate value font style",
                                    tooltip = "Select which effect to display the value font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.ultValueTypeKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueTypeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.outline = value
                                            FancyActionBar.ApplyUltValueFont()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultValueTypeKB,
                                },
                                {
                                    type = "slider",
                                    name = "Vertical",
                                    tooltip = "[<- down] or [up ->]",
                                    default = defaults.ultValueYKB,
                                    min = -500,
                                    max = 500,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultValueYKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.y = value
                                            FancyActionBar.AdjustUltValue()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizontal",
                                    tooltip = "[<- left] or [right ->]",
                                    default = defaults.ultValueXKB,
                                    min = -500,
                                    max = 500,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultValueXKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.x = value
                                            FancyActionBar.AdjustUltValue()
                                        end
                                    end,
                                    width = "half",
                                },
                                { type = "divider",
                                },
                                {
                                    type = "colorpicker",
                                    name = "Ult Value Base Color",
                                    default = ZO_ColorDef:New(unpack(defaults.ultValueColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.ultValueColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.ultValueColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.color = SV.ultValueColorKB
                                            FancyActionBar.ApplyUltValueColor()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "colorpicker",
                                    name = "Ult Usable Value Color",
                                    default = ZO_ColorDef:New(unpack(defaults.ultUsableValueColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.ultUsableValueColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.ultUsableValueColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.usableColor = SV.ultUsableValueColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "colorpicker",
                                    name = "Ult Max Value Color",
                                    default = ZO_ColorDef:New(unpack(defaults.ultMaxValueColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.ultMaxValueColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.ultMaxValueColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.maxColor = SV.ultMaxValueColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "colorpicker",
                                    name = "Ult 'Almost Ready' Value Color",
                                    default = ZO_ColorDef:New(unpack(defaults.ultUsableThresholdColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.ultUsableThresholdColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.ultUsableThresholdColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.usableThresholdColor = SV.ultUsableThresholdColorKB
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Ult 'Almost Ready' Threshold %",
                                    min = 50,
                                    max = 99,
                                    step = 1,
                                    getFunc = function ()
                                        return (SV.ultValueThresholdKB * 100)
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueThresholdKB = (value / 100)
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.value.threshold = value
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.ultValueThresholdKB,
                                },
                                { type = "divider",
                                },
                                {
                                    type = "description",
                                    title = "Companion Ultimate",
                                    text = "Companion ultimate value will inherit font and size of the player ultimate value.\nAdjust position below.",
                                    width = "full",
                                },
                                {
                                    type = "checkbox",
                                    name = "Display ultimate number for companion",
                                    default = defaults.ultValueEnableCompanionKB,
                                    getFunc = function ()
                                        return SV.ultValueEnableCompanionKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueEnableCompanionKB = value or false
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.companion.show = value
                                            FancyActionBar.ToggleUltimateValue()
                                        end
                                    end,
                                    width = "full",
                                },
                                {
                                    type = "slider",
                                    name = "Vertical",
                                    tooltip = "[<- down] or [up ->]",
                                    default = defaults.ultValueCompanionYKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultValueCompanionYKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueCompanionYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.companion.y = value
                                            FancyActionBar.AdjustCompanionUltValue()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizontal",
                                    tooltip = "[<- left] or [right ->]",
                                    default = defaults.ultValueCompanionXKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.ultValueCompanionXKB
                                    end,
                                    setFunc = function (value)
                                        SV.ultValueCompanionXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.ult.companion.x = value
                                            FancyActionBar.AdjustCompanionUltValue()
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },

                        -- ============[ Keyboard Quickslot ]==================
                        {
                            type = "submenu",
                            name = "|cFFFACDQuickslot Display Settings|r",
                            controls =
                            {
                                {
                                    type = "checkbox",
                                    name = "Quickslot cooldown duration",
                                    default = defaults.qsTimerEnableKB,
                                    getFunc = function ()
                                        return SV.qsTimerEnableKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsTimerEnableKB = value or false
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.show = value
                                            FancyActionBar.ToggleQuickSlotDuration()
                                        end
                                    end,
                                    width = "full",
                                },
                                { type = "description", text = "", width = "full",
                                },
                                {
                                    type = "dropdown",
                                    name = "Quickslot timer font",
                                    scrollable = true,
                                    tooltip = "Select which font to display the timer in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.qsNameKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsNameKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.font = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsNameKB,
                                },
                                {
                                    type = "slider",
                                    name = "Quickslot timer font size",
                                    min = 10,
                                    max = 30,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.qsSizeKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsSizeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.size = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsSizeKB,
                                },
                                {
                                    type = "dropdown",
                                    name = "Quickslot timer font style",
                                    tooltip = "Select which effect to display the timer font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.qsTypeKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsTypeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.outline = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsTypeKB,
                                },
                                {
                                    type = "colorpicker",
                                    name = "Quickslot timer color",
                                    default = ZO_ColorDef:New(unpack(defaults.qsColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.qsColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.qsColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.color = { r, g, b }
                                            FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetColor(unpack(SV.qsColorKB))
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Vertical",
                                    tooltip = "[<- down] or [up ->]",
                                    default = defaults.qsYKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.qsYKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsYKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.y = value
                                            FancyActionBar.AdjustQuickSlotTimer()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                },
                                {
                                    type = "slider",
                                    name = "Horizontal",
                                    tooltip = "[<- left] or [right ->]",
                                    default = defaults.qsXKB,
                                    min = -50,
                                    max = 50,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.qsXKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsXKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.x = value
                                            FancyActionBar.AdjustQuickSlotTimer()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                },
                                { type = "divider" },
                                {
                                    type = "dropdown",
                                    name = "Quickslot stack font",
                                    scrollable = true,
                                    tooltip = "Select which font to display the stack count in.",
                                    choices = FancyActionBar.GetFonts(),
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.qsStackNameKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsStackNameKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.stackFont = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsStackNameKB,
                                },
                                {
                                    type = "slider",
                                    name = "Quickslot stack font size",
                                    min = 10,
                                    max = 30,
                                    step = 1,
                                    getFunc = function ()
                                        return SV.qsStackSizeKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsStackSizeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.stackSize = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsStackSizeKB,
                                },
                                {
                                    type = "dropdown",
                                    name = "Quickslot stack font style",
                                    tooltip = "Select which effect to display the stack count font in.",
                                    choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                    sort = "name-up",
                                    getFunc = function ()
                                        return SV.qsStackTypeKB
                                    end,
                                    setFunc = function (value)
                                        SV.qsStackTypeKB = value
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.stackOutline = value
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                    default = defaults.qsStackTypeKB,
                                },
                                {
                                    type = "colorpicker",
                                    name = "Quickslot stack color",
                                    default = ZO_ColorDef:New(unpack(defaults.qsStackColorKB)),
                                    getFunc = function ()
                                        return unpack(SV.qsStackColorKB)
                                    end,
                                    setFunc = function (r, g, b)
                                        SV.qsStackColorKB = { r, g, b }
                                        if FancyActionBar.style == 1 then
                                            FancyActionBar.constants.qs.stackColor = { r, g, b }
                                            FancyActionBar.ApplyQuickSlotFont()
                                            DisplayQuickSlotLabelChanges()
                                        end
                                    end,
                                    width = "half",
                                },
                            },
                        },
                    },
                })
            table.insert(optionsTable[tableIndex].controls, { type = "divider" })
        end

        -- ============[	Gamepad UI	]=========================
        table.insert(optionsTable[tableIndex].controls,
            {
                type = "submenu",
                name = "|cFFFACDGamepad UI|r",
                controls =
                {

                    -- ============[	Gamepad Duration	]===================
                    {
                        type = "submenu",
                        name = "|cFFFACDTimer Settings|r",
                        controls =
                        {
                            {
                                type = "dropdown",
                                name = "Timer font",
                                scrollable = true,
                                tooltip = "Select which font to display the timer in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontNameGP
                                end,
                                setFunc = function (value)
                                    SV.fontNameGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.duration.font = value
                                        FancyActionBar.ApplyTimerFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.fontNameGP,
                            },
                            {
                                type = "slider",
                                name = "Timer font size",
                                min = 20,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.fontSizeGP
                                end,
                                setFunc = function (value)
                                    SV.fontSizeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.duration.size = value
                                        FancyActionBar.ApplyTimerFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.fontSizeGP,
                            },
                            {
                                type = "dropdown",
                                name = "Font style",
                                tooltip = "Select which effect to display the timer font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontTypeGP
                                end,
                                setFunc = function (value)
                                    SV.fontTypeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.duration.outline = value
                                        FancyActionBar.ApplyTimerFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.fontTypeGP,
                            },
                            {
                                type = "slider",
                                name = "Adjust timer height",
                                tooltip = "Move timer [<- down] or [up ->]",
                                default = defaults.timeYGP,
                                min = -15,
                                max = 15,
                                step = 1,
                                getFunc = function ()
                                    return SV.timeYGP
                                end,
                                setFunc = function (value)
                                    SV.timeYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.duration.y = value
                                        FancyActionBar.AdjustTimerY()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Timer color",
                                default = ZO_ColorDef:New(unpack(defaults.timeColorGP)),
                                getFunc = function ()
                                    return unpack(SV.timeColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.timeColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.duration.color = { r, g, b }
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },

                    -- ============[	Gamepad Stacks	]======================
                    {
                        type = "submenu",
                        name = "|cFFFACDstacks display settings|r",
                        controls =
                        {
                            {
                                type = "dropdown",
                                name = "Stacks font",
                                scrollable = true,
                                tooltip = "Select which font to display ability stacks in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontNameStackGP
                                end,
                                setFunc = function (value)
                                    SV.fontNameStackGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.font = value
                                        FancyActionBar.ApplyStackFont()
                                    end
                                end,
                                default = defaults.fontNameStackGP,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Stacks font size",
                                min = 10,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.fontSizeStackGP
                                end,
                                setFunc = function (value)
                                    SV.fontSizeStackGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.size = value
                                    end
                                    FancyActionBar.ApplyStackFont()
                                end,
                                default = defaults.fontSizeStackGP,
                                width = "half",
                            },
                            {
                                type = "dropdown",
                                name = "Stack font style",
                                tooltip = "Select which effect to display the stacks font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontTypeStackGP
                                end,
                                setFunc = function (value)
                                    SV.fontTypeStackGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.outline = value
                                        FancyActionBar.ApplyTimerFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.fontTypeStackGP,
                            },
                            {
                                type = "slider",
                                name = "Adjust stacks horizonatal position",
                                tooltip = "Move stacks [<- left] or [right ->]",
                                default = defaults.stackXGP,
                                min = 0,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.stackXGP
                                end,
                                setFunc = function (value)
                                    SV.stackXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.x = value
                                        FancyActionBar.AdjustStackX()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Adjust stacks vetrtical position",
                                tooltip = "Move stacks [<- up] or [down ->]",
                                default = defaults.stackYGP,
                                min = 0,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.stackYGP
                                end,
                                setFunc = function (value)
                                    SV.stackYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.y = value
                                        FancyActionBar.AdjustStackY()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Stack color",
                                default = ZO_ColorDef:New(unpack(defaults.stackColorGP)),
                                getFunc = function ()
                                    return unpack(SV.stackColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.stackColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.stacks.color = { r, g, b }
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },

                    -- ============[	Gamepad Targets	]======================
                    {
                        type = "submenu",
                        name = "|cFFFACDTargets Display Settings|r",
                        controls =
                        {
                            {
                                type = "dropdown",
                                name = "Targets font",
                                scrollable = true,
                                tooltip = "Select which font to display ability targets in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontNameTargetGP
                                end,
                                setFunc = function (value)
                                    SV.fontNameTargetGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.font = value
                                        FancyActionBar.ApplyTargetFont()
                                    end
                                end,
                                default = defaults.fontNameTargetGP,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Targets font size",
                                min = 10,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.fontSizeTargetGP
                                end,
                                setFunc = function (value)
                                    SV.fontSizeTargetGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.size = value
                                        FancyActionBar.ApplyTargetFont()
                                    end
                                end,
                                default = defaults.fontSizeTargetGP,
                                width = "half",
                            },
                            {
                                type = "dropdown",
                                name = "Target font style",
                                tooltip = "Select which effect to display the targets font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.fontTypeTargetGP
                                end,
                                setFunc = function (value)
                                    SV.fontTypeTargetGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.outline = value
                                        FancyActionBar.ApplyTimerFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.fontTypeTargetGP,
                            },
                            {
                                type = "slider",
                                name = "Horizontal position",
                                tooltip = "Move targets [<- left] or [right ->]",
                                default = defaults.targetXGP,
                                min = 0,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.targetXGP
                                end,
                                setFunc = function (value)
                                    SV.targetXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.x = value
                                        FancyActionBar.AdjustTargetX()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Vertical position",
                                tooltip = "Move targets [<- up] or [down ->]",
                                default = defaults.targetYGP,
                                min = 0,
                                max = 40,
                                step = 1,
                                getFunc = function ()
                                    return SV.targetYGP
                                end,
                                setFunc = function (value)
                                    SV.targetYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.y = value
                                        FancyActionBar.AdjustTargetY()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Target color",
                                default = ZO_ColorDef:New(unpack(defaults.targetColorGP)),
                                getFunc = function ()
                                    return unpack(SV.targetColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.targetColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.targets.color = { r, g, b }
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },

                    -- ============[ Gamepad Ultimate  ]====================
                    {
                        type = "submenu",
                        name = "|cFFFACDUltimate Timer Settings|r",
                        controls =
                        {
                            {
                                type = "checkbox",
                                name = "Display Ultimate Timer",
                                default = defaults.ultShowGP,
                                getFunc = function ()
                                    return SV.ultShowGP
                                end,
                                setFunc = function (value)
                                    SV.ultShowGP = value or false
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.show = value
                                        -- FancyActionBar.ToggleUltimateValue()
                                    end
                                end,
                                width = "half",
                            },
                            { type = "description", text = "", width = "full" },
                            {
                                type = "dropdown",
                                name = "Ultimate timer font",
                                scrollable = true,
                                tooltip = "Select which font to display the timer in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.ultNameGP
                                end,
                                setFunc = function (value)
                                    SV.ultNameGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.font = value
                                        FancyActionBar.ApplyUltFont(true)
                                    end
                                end,
                                width = "half",
                                default = defaults.ultNameGP,
                            },
                            {
                                type = "slider",
                                name = "Ultimate timer font size",
                                min = 10,
                                max = 45,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultSizeGP
                                end,
                                setFunc = function (value)
                                    SV.ultSizeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.size = value
                                        FancyActionBar.ApplyUltFont(true)
                                    end
                                end,
                                width = "half",
                                default = defaults.ultSizeGP,
                            },
                            {
                                type = "dropdown",
                                name = "Ultimate timer font style",
                                tooltip = "Select which effect to display the timer font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.ultTypeGP
                                end,
                                setFunc = function (value)
                                    SV.ultTypeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.outline = value
                                        FancyActionBar.ApplyUltFont(true)
                                    end
                                end,
                                width = "half",
                                default = defaults.ultTypeGP,
                            },
                            {
                                type = "colorpicker",
                                name = "Ultimate timer color",
                                default = ZO_ColorDef:New(unpack(defaults.ultColorGP)),
                                getFunc = function ()
                                    return unpack(SV.ultColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.ultColorGP = { r, g, b }
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Vertical",
                                tooltip = "[<- down] or [up ->]",
                                default = defaults.ultYGP,
                                min = -70,
                                max = 70,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultYGP
                                end,
                                setFunc = function (value)
                                    SV.ultYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.y = value
                                        FancyActionBar.AdjustUltTimer(true)
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Horizontal",
                                tooltip = "[<- left] or [right ->]",
                                default = defaults.ultXGP,
                                min = -80,
                                max = 80,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultXGP
                                end,
                                setFunc = function (value)
                                    SV.ultXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.duration.x = value
                                        FancyActionBar.AdjustUltTimer(true)
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },

                    -- ===========[ Gamepad Ultimate Value ]===============
                    {
                        type = "submenu",
                        name = "|cFFFACDUltimate Value Settings|r",
                        controls =
                        {
                            {
                                type = "checkbox",
                                name = "Display ultimate number",
                                default = defaults.ultValueEnableGP,
                                getFunc = function ()
                                    return SV.ultValueEnableGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueEnableGP = value or false
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.show = value
                                        FancyActionBar.ToggleUltimateValue()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "dropdown",
                                name = "Display Mode",
                                tooltip = "Dynamic: display current / cost if current is lower than cost and only current when you have enough to cast it.\nStatic: always display current / cost.",
                                choices = GetUltValueOptions(),
                                getFunc = function ()
                                    return GetUltValueMode(2)
                                end,
                                setFunc = function (mode)
                                    SV.ultValueModeGP = ultModeOptions[mode]
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.mode = SV.ultValueModeGP
                                        FancyActionBar.UpdateUltValueMode()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "dropdown",
                                name = "Ultimate value font",
                                scrollable = true,
                                tooltip = "Select which font to display the value in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.ultValueNameGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueNameGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.font = value
                                    end
                                    FancyActionBar.ApplyUltValueFont()
                                end,
                                width = "half",
                                default = defaults.ultValueNameGP,
                            },
                            {
                                type = "slider",
                                name = "Ultimate value font size",
                                min = 10,
                                max = 60,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultValueSizeGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueSizeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.size = value
                                        FancyActionBar.ApplyUltValueFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.ultValueSizeGP,
                            },
                            {
                                type = "dropdown",
                                name = "Ultimate value font style",
                                tooltip = "Select which effect to display the value font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.ultValueTypeGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueTypeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.outline = value
                                        FancyActionBar.ApplyUltValueFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.ultValueTypeGP,
                            },
                            {
                                type = "slider",
                                name = "Vertical",
                                tooltip = "[<- down] or [up ->]",
                                default = defaults.ultValueYGP,
                                min = -500,
                                max = 500,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultValueYGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.y = value
                                        FancyActionBar.AdjustUltValue()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Horizontal",
                                tooltip = "[<- left] or [right ->]",
                                default = defaults.ultValueXGP,
                                min = -500,
                                max = 500,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultValueXGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.x = value
                                        FancyActionBar.AdjustUltValue()
                                    end
                                end,
                                width = "half",
                            },
                            { type = "divider",
                            },
                            {
                                type = "colorpicker",
                                name = "Ult Value Base Color",
                                default = ZO_ColorDef:New(unpack(defaults.ultValueColorGP)),
                                getFunc = function ()
                                    return unpack(SV.ultValueColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.ultValueColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.color = SV.ultValueColorGP
                                        FancyActionBar.ApplyUltValueColor()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Ult Usable Value Color",
                                default = ZO_ColorDef:New(unpack(defaults.ultUsableValueColorGP)),
                                getFunc = function ()
                                    return unpack(SV.ultUsableValueColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.ultUsableValueColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.usableColor = SV.ultUsableValueColorGP
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Ult Max Value Color",
                                default = ZO_ColorDef:New(unpack(defaults.ultMaxValueColorGP)),
                                getFunc = function ()
                                    return unpack(SV.ultMaxValueColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.ultMaxValueColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.maxColor = SV.ultMaxValueColorGP
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Ult 'Almost Ready' Value Color",
                                default = ZO_ColorDef:New(unpack(defaults.ultUsableThresholdColorGP)),
                                getFunc = function ()
                                    return unpack(SV.ultUsableThresholdColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.ultUsableThresholdColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.usableThresholdColor = SV.ultUsableThresholdColorGP
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Ult 'Almost Ready' Threshold %",
                                min = 50,
                                max = 99,
                                step = 1,
                                getFunc = function ()
                                    return (SV.ultValueThresholdGP * 100)
                                end,
                                setFunc = function (value)
                                    SV.ultValueThresholdGP = (value / 100)
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.value.threshold = value
                                    end
                                end,
                                width = "half",
                                default = defaults.ultValueThresholdGP,
                            },
                            { type = "divider",
                            },
                            {
                                type = "description",
                                title = "Ult Fill Frame Transparency",
                                text = "Transparency (alpha) settings for the fill frame and fill bar.",
                                width = "full",
                            },
                            {
                                type = "slider",
                                name = "Ult Fill Frame Alpha",
                                min = 0,
                                max = 100,
                                step = 1,
                                default = defaults.ultFillFrameAlpha,
                                getFunc = function ()
                                    return SV.ultFillFrameAlpha * 100
                                end,
                                setFunc = function (value)
                                    SV.ultFillFrameAlpha = value / 100
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.SetUltFrameAlpha()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Ult Fill Bar Alpha",
                                min = 0,
                                max = 100,
                                step = 1,
                                default = defaults.ultFillBarAlpha,
                                getFunc = function ()
                                    return SV.ultFillBarAlpha * 100
                                end,
                                setFunc = function (value)
                                    SV.ultFillBarAlpha = value / 100
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.SetUltFrameAlpha()
                                    end
                                end,
                                width = "half",
                            },
                            { type = "divider",
                            },
                            {
                                type = "description",
                                title = "Companion Ultimate",
                                text = "Companion ultimate value will inherit font and size of the player ultimate value.\nAdjust position below.",
                                width = "full",
                            },
                            {
                                type = "checkbox",
                                name = "Display ultimate number for companion",
                                default = defaults.ultValueEnableCompanionGP,
                                getFunc = function ()
                                    return SV.ultValueEnableCompanionGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueEnableCompanionGP = value or false
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.companion.show = value
                                        FancyActionBar.ToggleUltimateValue()
                                    end
                                end,
                                width = "full",
                            },
                            {
                                type = "slider",
                                name = "Vertical",
                                tooltip = "[<- down] or [up ->]",
                                default = defaults.ultValueCompanionYGP,
                                min = -50,
                                max = 50,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultValueCompanionYGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueCompanionYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.companion.y = value
                                        FancyActionBar.AdjustCompanionUltValue()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Horizontal",
                                tooltip = "[<- left] or [right ->]",
                                default = defaults.ultValueCompanionXGP,
                                min = -50,
                                max = 50,
                                step = 1,
                                getFunc = function ()
                                    return SV.ultValueCompanionXGP
                                end,
                                setFunc = function (value)
                                    SV.ultValueCompanionXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.ult.companion.x = value
                                        FancyActionBar.AdjustCompanionUltValue()
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },

                    -- ============[	Gamepad Quickslot	]==================
                    {
                        type = "submenu",
                        name = "|cFFFACDQuickslot display settings|r",
                        controls =
                        {
                            {
                                type = "checkbox",
                                name = "Quickslot cooldown duration",
                                default = defaults.qsTimerEnableGP,
                                getFunc = function ()
                                    return SV.qsTimerEnableGP
                                end,
                                setFunc = function (value)
                                    SV.qsTimerEnableGP = value or false
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.show = value
                                        FancyActionBar.ToggleQuickSlotDuration()
                                    end
                                end,
                                width = "full",
                            },
                            { type = "description", text = "", width = "full",
                            },
                            {
                                type = "dropdown",
                                name = "Quickslot timer font",
                                scrollable = true,
                                tooltip = "Select which font to display the timer in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.qsNameGP
                                end,
                                setFunc = function (value)
                                    SV.qsNameGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.font = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsNameGP,
                            },
                            {
                                type = "slider",
                                name = "Quickslot timer font size",
                                min = 10,
                                max = 30,
                                step = 1,
                                getFunc = function ()
                                    return SV.qsSizeGP
                                end,
                                setFunc = function (value)
                                    SV.qsSizeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.size = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsSizeGP,
                            },
                            {
                                type = "dropdown",
                                name = "Quickslot timer font style",
                                tooltip = "Select which effect to display the timer font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.qsTypeGP
                                end,
                                setFunc = function (value)
                                    SV.qsTypeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.outline = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsTypeGP,
                            },
                            {
                                type = "colorpicker",
                                name = "Quickslot timer color",
                                default = ZO_ColorDef:New(unpack(defaults.qsColorGP)),
                                getFunc = function ()
                                    return unpack(SV.qsColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.qsColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.color = { r, g, b }
                                        FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetColor(unpack(SV.qsColorGP))
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "description",
                                text = "Adjust position",
                                width = "full",
                            },
                            {
                                type = "slider",
                                name = "Vertical",
                                tooltip = "[<- down] or [up ->]",
                                default = defaults.qsYGP,
                                min = -50,
                                max = 50,
                                step = 1,
                                getFunc = function ()
                                    return SV.qsYGP
                                end,
                                setFunc = function (value)
                                    SV.qsYGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.y = value
                                        FancyActionBar.AdjustQuickSlotTimer()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Horizontal",
                                tooltip = "[<- left] or [right ->]",
                                default = defaults.qsXGP,
                                min = -50,
                                max = 50,
                                step = 1,
                                getFunc = function ()
                                    return SV.qsXGP
                                end,
                                setFunc = function (value)
                                    SV.qsXGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.x = value
                                        FancyActionBar.AdjustQuickSlotTimer()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                            },
                            { type = "divider" },
                            {
                                type = "dropdown",
                                name = "Quickslot stack font",
                                scrollable = true,
                                tooltip = "Select which font to display the stack count in.",
                                choices = FancyActionBar.GetFonts(),
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.qsStackNameGP
                                end,
                                setFunc = function (value)
                                    SV.qsStackNameGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.stackFont = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsStackNameGP,
                            },
                            {
                                type = "slider",
                                name = "Quickslot stack font size",
                                min = 10,
                                max = 30,
                                step = 1,
                                getFunc = function ()
                                    return SV.qsStackSizeGP
                                end,
                                setFunc = function (value)
                                    SV.qsStackSizeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.stackSize = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsStackSizeGP,
                            },
                            {
                                type = "dropdown",
                                name = "Quickslot stack font style",
                                tooltip = "Select which effect to display the stack count font in.",
                                choices = { "normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline" },
                                sort = "name-up",
                                getFunc = function ()
                                    return SV.qsStackTypeGP
                                end,
                                setFunc = function (value)
                                    SV.qsStackTypeGP = value
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.stackOutline = value
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                                default = defaults.qsStackTypeGP,
                            },
                            {
                                type = "colorpicker",
                                name = "Quickslot stack color",
                                default = ZO_ColorDef:New(unpack(defaults.qsStackColorGP)),
                                getFunc = function ()
                                    return unpack(SV.qsStackColorGP)
                                end,
                                setFunc = function (r, g, b)
                                    SV.qsStackColorGP = { r, g, b }
                                    if FancyActionBar.style == 2 then
                                        FancyActionBar.constants.qs.stackColor = { r, g, b }
                                        FancyActionBar.ApplyQuickSlotFont()
                                        DisplayQuickSlotLabelChanges()
                                    end
                                end,
                                width = "half",
                            },
                        },
                    },
                },
            })
        table.insert(optionsTable[tableIndex].controls, { type = "divider" })

        -- ============[	Expiration Settings	]=================
        table.insert(optionsTable[tableIndex].controls,
            {
                type = "submenu",
                name = "|cFFFACDExpiration Settings (Shared)|r",
                controls =
                {

                    -- ============[  Timer Fade Delay  ]==================
                    {
                        type = "description",
                        title = "[ |cffdf80Timer Fade|r ]",
                        width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Delay timer fade",
                        tooltip = "Let the timer label display 0 for a set duration as a reminder that the ability has expired.",
                        default = defaults.delayFade,
                        getFunc = function ()
                            return SV.delayFade
                        end,
                        setFunc = function (value)
                            SV.delayFade = value or false
                        end,
                        width = "half",
                    },
                    {
                        type = "slider",
                        name = "Fade delay",
                        tooltip = "How long you would like the timer label to keep displaying 0 after the ability has expired",
                        default = defaults.fadeDelay,
                        disabled = function ()
                            return not SV.delayFade
                        end,
                        min = 0.5,
                        max = 5,
                        step = 0.1,
                        decimals = 1,
                        clampInput = true,
                        getFunc = function ()
                            return SV.fadeDelay
                        end,
                        setFunc = function (value)
                            SV.fadeDelay = value
                        end,
                        width = "half",
                    },
                    { type = "description", text = "", width = "full" },

                    -- ============[  Timer Decimals  ]====================
                    {
                        type = "description",
                        title = "[ |cffdf80Duration Display Decimals|r ]",
                        width = "full",
                    },
                    {
                        type = "dropdown",
                        name = "Enable timer decimals",
                        tooltip = "Always = Will always display decimals if the timer is active.\nExpire = Will enable more options.\nNever = Never.",
                        choices = FancyActionBar.GetDecimalOptions(),
                        default = defaults.showDecimal,
                        getFunc = function ()
                            return SV.showDecimal
                        end,
                        setFunc = function (value)
                            SV.showDecimal = value
                            FancyActionBar.constants.update = FancyActionBar.RefreshUpdateConfiguration()
                        end,
                        width = "half",
                    },
                    {
                        type = "slider",
                        name = "Decimals threshold",
                        tooltip = "Decimals will show when timers fall below selected amount of seconds remaining",
                        default = defaults.showDecimalStart,
                        disabled = function ()
                            if SV.showDecimal == "Expire" then
                                return false
                            else
                                return true
                            end
                        end,
                        min = 0,
                        max = 10,
                        step = 0.1,
                        decimals = 1,
                        clampInput = true,
                        getFunc = function ()
                            return SV.showDecimalStart
                        end,
                        setFunc = function (value)
                            SV.showDecimalStart = value
                            FancyActionBar.constants.update = FancyActionBar.RefreshUpdateConfiguration()
                        end,
                        width = "half",
                    },
                    { type = "description", text = "", width = "full" },

                    -- ============[  Expiring Effect Start  ]=============
                    {
                        type = "description",
                        title = "[ |cffdf80Display Changes For Expiring Effects|r ]",
                        width = "full",
                    },
                    {
                        type = "slider",
                        name = "Expiring timer threshold",
                        tooltip = "The color of durations and highlights will change when timers fall below selected amount of seconds remaining, if their individual settings are enabled",
                        default = defaults.showExpireStart,
                        min = 0,
                        max = 10,
                        step = 0.1,
                        decimals = 1,
                        clampInput = true,
                        getFunc = function ()
                            return SV.showExpireStart
                        end,
                        setFunc = function (value)
                            SV.showExpireStart = value
                        end,
                        width = "half",
                    },

                    -- ============[	Expiring Timer Color	]=============
                    { type = "description", title = "[ |cffdf80Timer Text|r ]", width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Change expiring timer text color",
                        tooltip = "Change timer text color when duration is running out.",
                        default = defaults.showExpire,
                        getFunc = function ()
                            return SV.showExpire
                        end,
                        setFunc = function (value)
                            SV.showExpire = value or false
                        end,
                        width = "full",
                    },
                    {
                        type = "colorpicker",
                        name = "Select timer text color for expiring effect",
                        default = ZO_ColorDef:New(unpack(defaults.expireColor)),
                        disabled = function ()
                            return (not SV.showExpire)
                        end,
                        getFunc = function ()
                            return unpack(SV.expireColor)
                        end,
                        setFunc = function (r, g, b)
                            SV.expireColor = { r, g, b }
                        end,
                        width = "full",
                    },
                    { type = "description", text = "", width = "full" },

                    -- ============[	Expiring Highlight Color	]=========
                    { type = "description", title = "[ |cffdf80Highlight|r ]", width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Change expiring timer highlight color",
                        tooltip = "Change highligh color when duration is running out.",
                        default = defaults.highlightExpire,
                        getFunc = function ()
                            return SV.highlightExpire
                        end,
                        setFunc = function (value)
                            SV.highlightExpire = value or false
                        end,
                        width = "full",
                    },
                    {
                        type = "colorpicker",
                        name = "Select highlight color for expiring effects",
                        default = ZO_ColorDef:New(unpack(defaults.highlightExpireColor)),
                        disabled = function ()
                            return (not SV.highlightExpireColor)
                        end,
                        getFunc = function ()
                            return unpack(SV.highlightExpireColor)
                        end,
                        setFunc = function (r, g, b, a)
                            SV.highlightExpireColor = { r, g, b, a }
                        end,
                        width = "full",
                    },
                    {
                        type = "description",
                        title = "[ |cffdf80Display Changes For Toggled Effects|r ]",
                        width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Show Tick Rate for Toggles",
                        tooltip = "Some toggled abilities have effects that `tick` while the ability is toggled, such as the resource return on Meditate. If enabled, the action bar will attempt to show the timer until the next tick. Load screens can cause this timer to desync from the game engine timer until the ability is retoggled.",
                        default = defaults.showToggleTicks,
                        getFunc = function ()
                            return SV.showToggleTicks
                        end,
                        setFunc = function (value)
                            SV.showToggleTicks = value or false
                        end,
                    },
                    {
                        type = "slider",
                        name = "Tick alert threshold",
                        tooltip = "The color of durations and highlights will change when timers fall below selected amount of seconds remaining, if their individual settings are enabled",
                        default = defaults.showTickStart,
                        min = 0,
                        max = 10,
                        step = 0.1,
                        decimals = 1,
                        clampInput = true,
                        getFunc = function ()
                            return SV.showTickStart
                        end,
                        setFunc = function (value)
                            SV.showTickStart = value
                        end,
                        width = "half",
                    },

                    -- ============[	Tick Alert Color	]=============
                    { type = "description", title = "[ |cffdf80Toggle Timer Text|r ]", width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Change tick alert text color",
                        tooltip = "Change timer text color when the tick alert threshold is reached, or a toggled effect becomes untoggled.",
                        default = defaults.showTickExpire,
                        getFunc = function ()
                            return SV.showTickExpire
                        end,
                        setFunc = function (value)
                            SV.showTickExpire = value or false
                        end,
                        width = "full",
                    },
                    {
                        type = "colorpicker",
                        name = "Select timer text color for tick alert effect",
                        default = ZO_ColorDef:New(unpack(defaults.tickColor)),
                        disabled = function ()
                            return (not SV.showTickExpire)
                        end,
                        getFunc = function ()
                            return unpack(SV.tickColor)
                        end,
                        setFunc = function (r, g, b)
                            SV.tickColor = { r, g, b }
                        end,
                        width = "full",
                    },
                    { type = "description", text = "", width = "full" },
                },
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                -- ==============[  Ability Config  ]=====================
                type = "submenu",
                name = "|cFFFACDAbility Configuration|r",
                controls =
                {
                    {
                        type = "checkbox",
                        name = "Accountwide Skill Settings",
                        tooltip = "If accountwide settings is enabled, changes made will affect a changed skill's ability timer for all characters.",
                        default = true,
                        getFunc = function ()
                            return CV.useAccountWide
                        end,
                        setFunc = function (value)
                            CV.useAccountWide = value or false
                        end,
                        requiresReload = true,
                        width = "full",
                    },

                    {
                        type = "submenu",
                        name = "|cFFFACDCurrently Slotted Ability IDs|r",
                        controls =
                        {

                            {
                                type = "description",
                                title = "Front Bar",
                                text = function ()
                                    return GetCurrentFrontBarInfo()
                                end,
                                width = "half",
                                reference = "Front_Bar_List",
                            },
                            {
                                type = "description",
                                title = "Back Bar",
                                text = function ()
                                    return GetCurrentBackBarInfo()
                                end,
                                width = "half",
                                reference = "Back_Bar_List",
                            },
                        },
                    },

                    {
                        type = "submenu",
                        name = "|cFFFACDTracked Effects|r",
                        controls =
                        {

                            {
                                type = "submenu",
                                name = "Info",
                                controls =
                                {

                                    {
                                        type = "description",
                                        title = "",
                                        text = "Here you can edit which effect you want the timer for a specific skill to track.\nTo track a different effect, enter the ID of the skill and the ID of the new effect, then click confirm.",
                                        width = "full",
                                    },
                                },
                            },

                            { type = "divider" },

                            {
                                type = "dropdown",
                                scrollable = 20,
                                name = "Saved Changes",
                                tooltip = "Easily find skills that you have made changes to.",
                                choices = GetChangedSkills(),
                                getFunc = function ()
                                    GetSelectedChangedSkill()
                                end,
                                setFunc = function (value)
                                    SetChangedSkillToEdit(value)
                                end,
                                reference = "Saved_Changes_Dropdown",
                                default = 0,
                                width = "half",
                            },

                            { type = "description", text = "", width = "half" },

                            {
                                type = "editbox",
                                name = "Skill ID",
                                tooltip = "Enter the ID of the skill you want to edit.",
                                -- default = '',
                                getFunc = function ()
                                    return GetSkillToEditID()
                                end,
                                setFunc = function (value)
                                    SetSkillToEditID(value)
                                end,
                                reference = "SkillToEditID_Editbox",
                                isMultiline = false,
                                isExtraWide = false,
                                width = "half",
                            },
                            {
                                type = "description",
                                title = "Selected Skill:",
                                text = function ()
                                    return GetSkillToEditName()
                                end,
                                width = "half",
                                reference = "SkillToEditTitle",
                            },
                            {
                                type = "dropdown",
                                name = "Change Type",
                                tooltip = "Select which type of change you want to apply to the skill.",
                                choices = GetSkillChangeOptions(),
                                getFunc = function ()
                                    return GetSkillChangeType()
                                end,
                                setFunc = function (value)
                                    SetSkillChangeType(value)
                                end,
                                width = "half",
                                reference = "Change_Type_Dropdown",
                                default = 0,
                            },

                            { type = "description", text = "", width = "half" },

                            {
                                type = "editbox",
                                name = "New Effect ID",
                                tooltip = "Enter the ID of the effect you want to have tracked from the selected skill.",
                                -- default = '',
                                getFunc = function ()
                                    return GetEffectToTrackID()
                                end,
                                setFunc = function (value)
                                    SetEffectToTrackID(value)
                                end,
                                reference = "EffectToTrackID_Editbox",
                                isMultiline = false,
                                isExtraWide = false,
                                width = "half",
                            },
                            {
                                type = "description",
                                title = "Selected Effect:",
                                text = function ()
                                    return GetEffectToTrackName()
                                end,
                                width = "half",
                                reference = "EffectToTrackTitle",
                            },

                            {
                                type = "button",
                                name = "Confirm Change",
                                width = "full",
                                func = function ()
                                    ValidateSkillChange()
                                end,
                                disabled = function ()
                                    return IsChangePossible()
                                end,
                            },
                            -- {	type = 'checkbox', 			name = 'Only Update Used Skill',
                            --   tooltip = 'Only update the timer for the button used to cast the effect.',
                            --   getFunc = function() return GetUpdateUsedButtonOnly() end,
                            --   setFunc = function(value) GetUpdateUsedButtonOnly(skillToEditID, value) end,
                            --   disabled = function() return skillToEditID == 0 or not IsValidId(skillToEditID) end,
                            --   width = 'half'
                            -- }
                        },
                    },
                    -- {	type = 'divider'  },

                    -- ==============[  External Buff Tracking  ]==============
                    {
                        type = "submenu",
                        name = "|cFFFACDBuffs Gained From others|r",
                        controls =
                        {

                            {
                                type = "submenu",
                                name = "Info",
                                controls =
                                {

                                    { type = "description", text = "Here you can enable the ability timers to track the duration if their tracked effect is gained from an ally.\nYou can also select which effects you do not want to have tracked if you are not the source.",
                                    },
                                },
                            },

                            {
                                type = "checkbox",
                                name = "Track Buffs From Others",
                                default = defaults.externalBuffs,
                                getFunc = function ()
                                    return SV.externalBuffs
                                end,
                                setFunc = function (value)
                                    SV.externalBuffs = value or false
                                    FancyActionBar.SetExternalBuffTracking()
                                end,
                                width = "half",
                            },
                            { type = "description", width = "half" },

                            {
                                type = "editbox",
                                name = "Add to Blacklist",
                                tooltip = "Enter the ID of the skill you dont want to have updated when you gain the effect from someone else.",
                                -- default = '',
                                getFunc = function ()
                                    return GetSkillToBlacklistID()
                                end,
                                setFunc = function (value)
                                    SetSkillToBlacklistID(value)
                                end,
                                reference = "SkillToBlacklistID_Editbox",
                                isMultiline = false,
                                isExtraWide = false,
                                width = "half",
                            },
                            {
                                type = "description",
                                title = "Selected Buff:",
                                text = function ()
                                    return GetSkillToBlacklistName()
                                end,
                                width = "half",
                                reference = "SkillToBlacklistTitle",
                            },

                            { type = "description", width = "half" },

                            {
                                type = "button",
                                name = "Confirm Blacklist",
                                width = "half",
                                func = function ()
                                    BlacklistId()
                                end,
                                disabled = function ()
                                    return not CanBlacklistId()
                                end,
                                reference = "SkillToBlacklist_Button",
                            },

                            { type = "description", width = "full" },

                            {
                                type = "dropdown",
                                scrollable = 20,
                                name = "Blacklisted IDs",
                                choices = GetBlacklistedSkills(),
                                getFunc = function ()
                                    GetSelectedBlacklist()
                                end,
                                setFunc = function (value)
                                    SetSelectedBlacklist(value)
                                end,
                                reference = "Blacklist_Dropdown",
                                -- default = '== Select a Skill ==',
                                width = "half",
                            },

                            {
                                type = "button",
                                name = "Remove From Blacklist",
                                width = "half",
                                func = function ()
                                    ClearBlacklistId()
                                end,
                                disabled = function ()
                                    return not CanClearBlacklistId()
                                end,
                                reference = "BlacklistToClear_Button",
                            },
                        },
                    },
                    -- {	type = 'divider'  },

                    -- ==================[  Target Debuffs  ]==================
                    {
                        type = "submenu",
                        name = "|cFFFACDDebuffs on Target|r",
                        controls =
                        {

                            {
                                type = "checkbox",
                                name = "Debuff timers for current target",
                                tooltip = "Update timer duration of debuffs when changing target, to display the remaining duration on them specifically.\nOnly for alive enemy targets.",
                                default = defaults.advancedDebuff,
                                getFunc = function ()
                                    return SV.advancedDebuff
                                end,
                                setFunc = function (value)
                                    SV.advancedDebuff = value or false
                                    FancyActionBar:UpdateDebuffTracking()
                                end,
                            },

                            {
                                type = "checkbox",
                                name = "Keep Timers For Last Target",
                                tooltip = "Keep timers when you look away from your target until you have a new enemy target.",
                                default = defaults.keepLastTarget,
                                getFunc = function ()
                                    return SV.keepLastTarget
                                end,
                                setFunc = function (value)
                                    SV.keepLastTarget = value or false
                                end,
                                disabled = function ()
                                    return not SV.advancedDebuff
                                end,
                            },

                            {
                                type = "checkbox",
                                name = "Show Stack Count for Overtaunt Debuff",
                                tooltip = "Multiple taunt sources can cause an enemy to gain taunt immunity, this stack counter tracks the status of this debuff.",
                                default = defaults.showOvertauntStacks,
                                getFunc = function ()
                                    return SV.showOvertauntStacks
                                end,
                                setFunc = function (value)
                                    SV.showOvertauntStacks = value or false
                                end,
                                disabled = function ()
                                    return not SV.advancedDebuff
                                end,
                            },

                            {
                                type = "description",
                                text = "More options to come.",
                                width = "full",
                            },

                            -- { type = 'checkbox',      name = 'Hide timers if not on target',
                            --   tooltip = 'This will determine if the timers for active debuffs should be hidden if they are not active on your current target.\nThis setting will apply to all debuffs that has not been added to individual settings below, and will be ignored for the ones that has.',
                            --   disabled = function() return not SV.advancedDebuff end,
                            --   getFunc = function() return FancyActionBar.GetHideOnNoTargetGlobalSetting() end,
                            --   setFunc = function(value) FancyActionBar.SetHideOnNoTargetGlobalSetting(value) end,
                            -- },
                            --
                            -- { type = 'checkbox',      name = 'Lower timer visibility if not on target',
                            --   tooltip = 'If timers are not hidden when the debuff is not on your current target, you can choose to lower its visibility instead.',
                            --   disabled = function() return not SV.advancedDebuff or not FancyActionBar.GetHideOnNoTargetGlobalSetting() end,
                            --   default = defaults.noTargetFade,
                            --   getFunc = function() return FancyActionBar.GetNoTargetFade() end,
                            --   setFunc = function(value) FancyActionBar.SetNoTargetFade(value) end,
                            --   width = 'half',
                            -- },
                            --
                            -- {	type = 'slider',        name = 'Timer visibility if not on target',
                            --   default  = defaults.noTargetAlpha,
                            --   disabled = function() return not SV.advancedDebuff or not SV.noTargetFade or not FancyActionBar.GetHideOnNoTargetGlobalSetting() end,
                            --   min      = 10, max = 100, step = 1,
                            --   getFunc  = function() return FancyActionBar.GetNoTargetAlpha() * 100 end,
                            --   setFunc  = function(value) FancyActionBar.SetNoTargetAlpha(value) end,
                            --   width    = 'half'
                            -- },
                            --
                            -- {	type = 'description',   title = 'Specify for debuff',
                            --   text = 'If you have added the ID for a debuff to this section it will ignore the above settings for visibility, and instead use the options specified below.',
                            --   width = 'full',
                            -- },

                            -- { type = 'editbox',       name = 'Add Debuff',
                            --   tooltip = 'Enter the ID of the debuff you want to enable specific options for.',
                            --     -- default = '',
                            --     getFunc = function() return GetDebuffToAddID() end,
                            --     setFunc = function(value) SetDebuffToAddID(value) end,
                            --     reference = 'DebuffToAdd_Editbox',
                            --     isMultiline = false,
                            --     isExtraWide = false,
                            --     width = 'half'
                            -- },
                            -- { type = 'description',   title = 'Selected Debuff:',
                            --   text = function() return GetDebuffToAddName() end,
                            --   width = 'half',
                            --   reference = 'DebuffToAdd_Title'
                            -- },
                            --
                            -- {	type = 'description',   width = 'half' },
                            --
                            -- { type = "button",        name = "Confirm Debuff Changes",
                            --   width = "half",
                            --   func = function() AddDebuff() end,
                            --   disabled = function() return not CanAddDebuff() end,
                            --   reference = 'DebuffToAdd_Button'
                            -- },
                            --
                            -- {	type = 'description',   width = 'full' },
                            --
                            -- { type = 'dropdown',      name = 'Debuffs',
                            --   choices = GetDebuffNames(),
                            --   getFunc = function() GetSelectedDebuff() end,
                            --   setFunc = function(value) SetSelectedDebuff(value) end,
                            --   reference = 'Debuff_Dropdown',
                            --   -- default = '== Select a Skill ==',
                            --   width = 'half'
                            -- },
                            --
                            -- { type = "button",        name = "Remove Debuff",
                            --   width = "half",
                            --   func = function() ClearDebuff() end,
                            --   disabled = function() return not CanClearDebuff() end,
                            --   reference = 'DebuffToClear_Button'
                            -- }
                        },
                    },
                    -- {	type = 'divider'  },

                    -- ============[  Additional Tracking Options  ]===========
                    {
                        type = "submenu",
                        name = "|cFFFACDAdditional Tracking Options|r",
                        controls =
                        {


                            -- { type = 'divider'	},

                            {
                                type = "description",
                                title = "[ |cffdf80Effect Duration Thresholds|r ]",
                                text = "Set the limits for when to ignore effects based on their duration.",
                                width = "full",
                            },
                            {
                                type = "slider",
                                name = "Minimum",
                                min = 1,
                                max = 4,
                                step = 0.5,
                                getFunc = function ()
                                    return SV.durationMin
                                end,
                                setFunc = function (value)
                                    SV.durationMin = value
                                    FancyActionBar.UpdateDurationLimits()
                                end,
                                width = "half",
                                default = defaults.durationMin,
                            },
                            {
                                type = "slider",
                                name = "Maximum",
                                min = 30,
                                max = 130,
                                step = 1,
                                getFunc = function ()
                                    return SV.durationMax
                                end,
                                setFunc = function (value)
                                    SV.durationMax = value
                                    FancyActionBar.UpdateDurationLimits()
                                end,
                                width = "half",
                                default = defaults.durationMax,
                            },

                            { type = "divider" },
                            {
                                type = "description",
                                title = "[ |cffdf80Multitarget Effect Tracking Options|r ]",
                                text = "Options for configuring the behavior and tracked abilities for the Target Instance Counter.",
                                width = "full",
                            },
                            {
                                type = "checkbox",
                                name = "Show Target Instance Counter",
                                tooltip = "Abilities that track an effect that can be applied to multiple targets simultaneously will show an instance counter on the top left of the ability icon.",
                                default = defaults.showTargetCount,
                                getFunc = function ()
                                    return SV.showTargetCount
                                end,
                                setFunc = function (value)
                                    SV.showTargetCount = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Show Instance Count for One Active Instance",
                                tooltip = "Show the target instance counter if only one instance of the effect is active. Note that this does not apply to debuffs when 'Debuffs on target' mode is enabled.",
                                default = defaults.showSingleTargetInstance,
                                disabled = function ()
                                    return not SV.showTargetCount
                                end,
                                getFunc = function ()
                                    return SV.showSingleTargetInstance
                                end,
                                setFunc = function (value)
                                    SV.showSingleTargetInstance = value or false
                                end,
                            },
                            { type = "divider" },
                            {
                                type = "editbox",
                                name = "Add to Blacklist",
                                tooltip =
                                "Enter the ID of the skill you dont want to track multiple target instances of.",
                                -- default = '',
                                getFunc = function ()
                                    return GetMultiTargetSkillToBlacklistID()
                                end,
                                setFunc = function (value)
                                    SetMultiTargetSkillToBlacklistID(value)
                                end,
                                reference = "MultiTargetSkillToBlacklistID_Editbox",
                                isMultiline = false,
                                isExtraWide = false,
                                width = "half",
                            },
                            {
                                type = "description",
                                title = "Selected Skill:",
                                text = function ()
                                    return GetMultiTargetSkillToBlacklistName()
                                end,
                                width = "half",
                                reference = "MultiTargetSkillToBlacklistTitle",
                            },

                            { type = "description", width = "half" },

                            {
                                type = "button",
                                name = "Confirm Blacklist",
                                width = "half",
                                func = function ()
                                    BlacklistMultiTargetId()
                                end,
                                disabled = function ()
                                    return not CanBlacklistMultiTargetId()
                                end,
                                reference = "MultiTargetSkillToBlacklist_Button",
                            },

                            { type = "description", width = "full" },

                            {
                                type = "dropdown",
                                scrollable = 20,
                                name = "Blacklisted IDs",
                                choices = GetBlacklistedMultiTargetSkills(),
                                getFunc = function ()
                                    GetSelectedMultiTargetBlacklist()
                                end,
                                setFunc = function (value)
                                    SetSelectedMultiTargetBlacklist(value)
                                end,
                                reference = "MultiTargetBlacklist_Dropdown",
                                -- default = '== Select a Skill ==',
                                width = "half",
                            },

                            {
                                type = "button",
                                name = "Remove From Blacklist",
                                width = "half",
                                func = function ()
                                    ClearMultiTargetBlacklistId()
                                end,
                                disabled = function ()
                                    return not CanClearBlacklistMultiTargetId()
                                end,
                                reference = "MultiTargetBlacklistToClear_Button",
                            },
                            { type = "divider" },
                            {
                                type = "description",
                                title = "[ |cffdf80Miscellaneous Options|r ]",
                                text = "Additional settings for configuring ability tracking.",
                                width = "full",
                            },
                            {
                                type = "checkbox",
                                name = "Show Stack Counter",
                                tooltip = "Show stack count for abilities that can have multiple stacks, or can stack multiple times.",
                                default = defaults.showStackCount,
                                getFunc = function ()
                                    return SV.showStackCount
                                end,
                                setFunc = function (value)
                                    SV.showStackCount = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Show Cast/Channel Times on Action Slots",
                                tooltip = "If an ability has a cast or channel time, it will display that duration on the slot while the ability is being cast/channeled.",
                                default = defaults.showCastDuration,
                                getFunc = function ()
                                    return SV.showCastDuration
                                end,
                                setFunc = function (value)
                                    SV.showCastDuration = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Ignore Initial Trap Placement",
                                tooltip = "By default 'Trap' effects, such as Trap Beast and Scalding Rune display an initial timer and stack when placed, and switch to tracking the DOT when triggered. Toggle ON to only track the DOT",
                                default = defaults.ignoreTrapPlacement,
                                getFunc = function ()
                                    return SV.ignoreTrapPlacement
                                end,
                                setFunc = function (value)
                                    SV.ignoreTrapPlacement = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Show Timer For Soonest Expiring Target",
                                tooltip = "By default an ability timer will show the duration for the last cast of the ability, with this option enabled it will show the duration for the soonest expiring target instead.",
                                default = defaults.showSoonestExpire,
                                getFunc = function ()
                                    return SV.showSoonestExpire
                                end,
                                setFunc = function (value)
                                    SV.showSoonestExpire = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Ignore Ungrouped Allies",
                                tooltip = "By default all buffs applied to allies are tracked. With this setting enabled, while you are in a group only buffs applied to group members will be tracked.",
                                default = defaults.ignoreUngroupedAliies,
                                getFunc = function ()
                                    return SV.ignoreUngroupedAliies
                                end,
                                setFunc = function (value)
                                    SV.ignoreUngroupedAliies = value or false
                                end,
                            },
                            {
                                type = "checkbox",
                                name = "Allow Fallback Timers",
                                tooltip = "By default only durations for the specific effect will be tracked for configured abilities. When tracking an effect ID that is a shorter duration than the “parent” (slotted) ability, allow the action bar timer to fallback to the parent ability timer for the remaining duration. This will also cause the slot to swap to the expiring effect highlight (but not timer) color when this changeover occurs.",
                                default = defaults.allowParentTime,
                                getFunc = function ()
                                    return SV.allowParentTime
                                end,
                                setFunc = function (value)
                                    SV.allowParentTime = value or false
                                end,
                            },
                        },
                    },
                },
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                -- ============[	Miscellaneous	]=======================
                type = "submenu",
                name = "|cFFFACDMiscellaneous|r",
                controls =
                {

                    {
                        type = "checkbox",
                        name = "Show bar while dead",
                        tooltip = "Will display the action bar while you are dead if enabled.",
                        default = defaults.showDeath,
                        getFunc = function ()
                            return SV.showDeath
                        end,
                        setFunc = function (value)
                            SV.showDeath = value or false
                            CheckDeathState()
                            FancyActionBar.ApplyDeathStateOption()
                        end,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Prevent casting in trade",
                        tooltip = "Blocks the use of skills while in trade, but allows the use of them while in settings and when map is open.\nThis will prevent Perfect Weave from working as intended.",
                        default = defaults.lockInTrade,
                        getFunc = function ()
                            return SV.lockInTrade
                        end,
                        setFunc = function (value)
                            SV.lockInTrade = value or false
                        end,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Enable Perfect Weave",
                        tooltip = "In order for Perfect Weave to work, changes that allows for skills to be cast while in settings or when map is open ect. has to be disabled.\nThe game did not consider these thigns well in the past, which is why I made a few alterations to them. They have been slightly improved and you can rely on them if you want to use Perfect Weave and this addon together.",
                        default = defaults.perfectWeave,
                        getFunc = function ()
                            return SV.perfectWeave
                        end,
                        setFunc = function (value)
                            SV.perfectWeave = value or false
                        end,
                        requiresReload = true,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Adjust Health Bar",
                        tooltip = "The scale of Fancy Action Bar+ can cause it to overlap the health bar in its default position. When enabled, if FAB is in its default position, it will reanchor the default health bar to be above the action bar. If FAB is moved, it will not adjust the health bar. Disabling this setting will require reloading the UI. Installation of Azurah will cause this setting to be ignored.",
                        default = defaults.moveHealthBar,
                        getFunc = function ()
                            return SV.moveHealthBar
                        end,
                        setFunc = function (value)
                            SV.moveHealthBar = value or false
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end,
                        requiresReload = true,
                        width = "half",
                    },
                    {
                        type = "checkbox",
                        name = "Adjust Mag/Stam Bars",
                        tooltip = "Also adjust the position of the magicka and stamina bars to align with health bar.",
                        default = defaults.moveResourceBars,
                        getFunc = function ()
                            return SV.moveResourceBars
                        end,
                        setFunc = function (value)
                            SV.moveResourceBars = value or false
                            if not FancyActionBar.wasMoved then
                                FancyActionBar.ResetMoveActionBar()
                                FancyActionBar.RepositionHealthBar()
                            end
                        end,
                        disabled = function ()
                            return not SV.moveHealthBar
                        end,
                        requiresReload = true,
                        width = "half",
                    },
                    { type = "description", text = "", width = "half" },

                    -- ============[	Enemy Markers	]=======================
                    {
                        type = "description",
                        title = "[ |cffdf80Enemy Markers|r ]",
                        text = "This replicates a similar feature found in the Untaunted addon.",
                        width = "full",
                    },
                    {
                        type = "checkbox",
                        name = "Show Enemy Markers",
                        tooltip = "Display a red arrow over the head of enemies you are currently in combat with.",
                        default = defaults.showMarker,
                        getFunc = function ()
                            return SV.showMarker
                        end,
                        setFunc = function (value)
                            SV.showMarker = value or false
                        end,
                        width = "half",
                    },
                    {
                        type = "slider",
                        name = "Enemy Marker Size",
                        default = defaults.markerSize,
                        min = 10,
                        max = 90,
                        step = 1,
                        getFunc = function ()
                            return SV.markerSize
                        end,
                        setFunc = function (value)
                            SV.markerSize = value
                            FancyActionBar.SetMarker(value)
                        end,
                        width = "half",
                    },
                    { type = "divider" },

                    -- ===============[  GCD Tracker  ]======================
                    {
                        type = "submenu",
                        name = "|cFFFACDGlobal Cooldown Tracker|r",
                        controls =
                        {
                            {
                                type = "description",
                                title = "[ |cffdf80Adjust GCD Size|r ]",
                                width = "full",
                            },
                            {
                                type = "checkbox",
                                name = "Enable GCD",
                                default = defaults.gcd.enable,
                                getFunc = function ()
                                    return SV.gcd.enable
                                end,
                                setFunc = function (value)
                                    SV.gcd.enable = value or false
                                    FancyActionBar.ToggleGCD()
                                end,
                                width = "half",
                            },
                            {
                                type = "checkbox",
                                name = "Only in combat",
                                default = defaults.gcd.combatOnly,
                                getFunc = function ()
                                    return SV.gcd.combatOnly
                                end,
                                setFunc = function (value)
                                    SV.gcd.combatOnly = value or false
                                    FancyActionBar.ToggleGCD()
                                end,
                                width = "half",
                            },

                            { type = "divider" },

                            {
                                type = "slider",
                                name = "Height",
                                default = SV.gcd.sizeX,
                                min = 30,
                                max = 100,
                                step = 1,
                                getFunc = function ()
                                    return SV.gcd.sizeY
                                end,
                                setFunc = function (value)
                                    SV.gcd.sizeY = value
                                    FancyActionBar.UpdateGCDSize()
                                end,
                                width = "half",
                            },
                            {
                                type = "slider",
                                name = "Width",
                                default = defaults.gcd.sizeY,
                                min = 30,
                                max = 250,
                                step = 1,
                                getFunc = function ()
                                    return SV.gcd.sizeX
                                end,
                                setFunc = function (value)
                                    SV.gcd.sizeX = value
                                    FancyActionBar.UpdateGCDSize()
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Fill color",
                                default = ZO_ColorDef:New(unpack(defaults.gcd.fillColor)),
                                getFunc = function ()
                                    return unpack(SV.gcd.fillColor)
                                end,
                                setFunc = function (r, g, b, a)
                                    SV.gcd.fillColor = { r, g, b, a }
                                    FAB_GCD.fill:SetCenterColor(unpack(SV.gcd.fillColor))
                                    FAB_GCD.fill:SetEdgeColor(unpack(SV.gcd.fillColor))
                                end,
                                width = "half",
                            },
                            {
                                type = "colorpicker",
                                name = "Edge color",
                                default = ZO_ColorDef:New(unpack(defaults.gcd.frameColor)),
                                getFunc = function ()
                                    return unpack(SV.gcd.frameColor)
                                end,
                                setFunc = function (r, g, b, a)
                                    SV.gcd.frameColor = { r, g, b, a }
                                    FAB_GCD.frame:SetColor(unpack(SV.gcd.frameColor))
                                end,
                                width = "half",
                            },
                        },
                    },
                },
            })
        if IsConsoleUI() then
            local moveGCD =
            {
                {
                    type = "description",
                    title = "[ |cffdf80Adjust GCD Position|r ]",
                    width = "full",
                },
                {
                    type = "slider",
                    name = "Horizontal (X) Position",
                    default = defaults.gcd.x,
                    min = 0,
                    max = GuiRoot:GetWidth(),
                    step = 1,
                    getFunc = function ()
                        return SV.gcd.x or defaults.gcd.x
                    end,
                    setFunc = function (value)
                        SV.gcd.x = value
                        FAB_GCD:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SV.gcd.x, SV.gcd.y, FAB_GCD:GetResizeToFitConstrains())
                    end,
                    width = "half",
                },
                {
                    type = "slider",
                    name = "Vertical (Y) Position",
                    default = defaults.gcd.y,
                    min = 0,
                    max = GuiRoot:GetHeight(),
                    step = 1,
                    getFunc = function ()
                        return SV.gcd.y or defaults.gcd.y
                    end,
                    setFunc = function (value)
                        SV.gcd.y = value
                        FAB_GCD:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SV.gcd.x, SV.gcd.y, FAB_GCD:GetResizeToFitConstrains())
                    end,
                    width = "half",
                }
            }
            for k, v in pairs(moveGCD) do
                table.insert(optionsTable[tableIndex].controls, v)
            end
        end
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                -- ===============[  Debugging  ]========================
                type = "description",
                title = "[ |cffdf80Debugging|r ]",
                text = "",
                width = "full",
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                type = "checkbox",
                name = "Debug mode",
                tooltip = "Display internal events in the chat",
                default = defaults.debug,
                getFunc = function ()
                    return SV.debug
                end, -- FancyActionBar.IsDebugMode() end,
                setFunc = function (value)
                    -- FancyActionBar.SetDebugMode(value or false)
                    FancyActionBar.SetDebugMode(value or false)
                    SV.debug = value or false
                end,
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })
        tableIndex = tableIndex + 1

        table.insert(optionsTable,
            {
                type = "description",
                text = FancyActionBar.strings.disclaimer,
                width = "full",
            })
        tableIndex = tableIndex + 1

        table.insert(optionsTable, { type = "divider" })

        return optionsTable
    end

    local options = BuildOptions()
    LAM:RegisterOptionControls(name, options)

    --- @diagnostic disable-next-line: redefined-local
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function (panel)
        if panel == FAB_Panel then
            ACTION_BAR:SetHidden(false)
            FAB_GCD:SetHidden(not SV.gcd.enable)
            inMenu = true
            FancyActionBar.UpdateSlottedSkillsDecriptions()
        else
            ACTION_BAR:SetHidden(true)
            FAB_GCD:SetHidden(true)
            inMenu = false
            qsDisplayTime = 0
        end
    end)
    --- @diagnostic disable-next-line: redefined-local
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function (panel)
        if panel ~= FAB_Panel then
            return
        end
        ACTION_BAR:SetHidden(true)
        FAB_GCD:SetHidden(true)
        inMenu = false
        qsDisplayTime = 0
    end)

    --- @diagnostic disable-next-line: redefined-local
    CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", function (panel)
        if panel == FAB_Panel then
            if not settingsPageCreated then
                settingsPageCreated = true
            end
        end
    end)

    ParseExternalBlacklist()
    ParseMultiTargetBlacklist()
end

-------------------------------------------------------------------------------
-----------------------------[   Player Settings   ]---------------------------
-------------------------------------------------------------------------------
function FancyActionBar.UpdateTextures()
    RedirectTexture("EsoUI/Art/ActionBar/ability_ultimate_frameDecoBG.dds", FAB_BLANK)
    RedirectTexture("esoui/art/actionbar/abilityInset.dds", FAB_BG)
    if BUI then
        if BUI.abilityframe then
            BUI.abilityframe = FAB_BLANK
        end
        -- local BUI_FRAME = '/BanditsUserInterface/textures/theme/abilityframe64_up.dds'
        -- RedirectTexture(BUI_FRAME, f[2])
    end
end

function FancyActionBar.HideHotkeys(hide)
    local alpha = hide == true and 0 or 1

    local QSB = QuickslotButtonButtonText

    if FancyActionBar.style == 1 then
        for i = 3, 7 do
            local b = ZO_ActionBar_GetButton(i)
            b.buttonText:SetHidden(hide)
            b.buttonText:SetAlpha(alpha)
            if hide then
                ZO_Keybindings_UnregisterLabelForBindingUpdate(b.buttonText)
            end
        end
        QSB:SetHidden(hide)
        QSB:SetAlpha(alpha)
        if hide then
            ZO_Keybindings_UnregisterLabelForBindingUpdate(ZO_ActionBar_GetButton(QUICK_SLOT, HOTBAR_CATEGORY_QUICKSLOT_WHEEL).buttonText)
        end
        -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetHidden(hide)
        -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetAlpha(alpha)
        ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetHidden(hide)
        ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetAlpha(alpha)
        if hide then
            ZO_Keybindings_UnregisterLabelForBindingUpdate(ZO_ActionBar_GetButton(ULT_SLOT).buttonText)
        end
        ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetHidden(hide)
        ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetAlpha(alpha)
    else
        for i = 3, 7 do
            local b = ZO_ActionBar_GetButton(i)
            b.buttonText:SetHidden(hide)
            if hide then
                ZO_Keybindings_UnregisterLabelForBindingUpdate(b.buttonText)
            end
        end
        QSB:SetHidden(true)
        if hide then
            ZO_Keybindings_UnregisterLabelForBindingUpdate(ZO_ActionBar_GetButton(QUICK_SLOT, HOTBAR_CATEGORY_QUICKSLOT_WHEEL).buttonText)
        end
        -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetHidden(true)
        ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetHidden(true)
        ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetHidden(true)
        if hide and not SV.showHotkeysUltGP then
            ZO_Keybindings_UnregisterLabelForBindingUpdate(ZO_ActionBar_GetButton(ULT_SLOT).buttonText)
        end
        local uAlpha = SV.showHotkeysUltGP == true and 1 or 0
        if ActionButton8 then
            if ActionButton8LeftKeybind then
                ActionButton8LeftKeybind:SetAlpha(uAlpha)
            end
            if ActionButton8RightKeybind then
                ActionButton8RightKeybind:SetAlpha(uAlpha)
            end
        end
        local c = CompanionUltimateButton
        if c then
            local l = CompanionUltimateButtonLeftKeybind
            local r = CompanionUltimateButtonRightKeybind
            if l then
                l:SetAlpha(uAlpha)
            end
            if r then
                r:SetAlpha(uAlpha)
            end
        end
    end
end

function FancyActionBar.SetMarker(value)
    if SV.showMarker ~= true then
        return
    end
    SetFloatingMarkerInfo(MAP_PIN_TYPE_AGGRO, SV.markerSize, FAB_MARKER, FAB_MARKER, true, true)
    SetFloatingMarkerGlobalAlpha(1)
end

function FancyActionBar.ConfigureFrames()
    -- ZO_CenterScreenAnnouncementLine.smallCombinedIconFrame
    -- ZO_CenterScreenAnnouncementLine.iconControlFrame

    if BUI then -- revert all this nonsense with no options or global access to prevent it initially.
        for i = 3, 9 do
            local name = "ActionButton" .. i
            local frame = _G[name]
            if frame then
                local edge = _G[name .. "Edge"]
                if edge then
                    edge:SetHidden(true)
                    edge:SetAlpha(0)
                end

                local backdrop = frame:GetNamedChild("Backdrop")
                if backdrop then
                    backdrop:SetAlpha(1)
                end

                local bg = frame:GetNamedChild("BG")
                if bg then
                    bg:SetHidden(false)
                end

                if i == 8 then
                    backdrop = frame:GetNamedChild("Frame")
                    if backdrop then
                        backdrop:SetAlpha(1)
                    end
                end
            end
        end
    end

    local function HideFrames(hide)
        for i, overlay in pairs(FancyActionBar.overlays) do
            local frame = overlay:GetNamedChild("Frame")
            if frame then
                frame:SetHidden(hide)
            end
        end
        for i, overlay in pairs(FancyActionBar.ultOverlays) do
            local frame = overlay:GetNamedChild("Frame")
            if frame then
                frame:SetHidden(hide)
            end
        end
    end

    if FancyActionBar.style == 2 then
        HideFrames(true)
        if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then
            FancyActionBar.qsOverlay.frame:SetHidden(true)
        end
    else
        if not SV.showFrames then
            HideFrames(true)
            if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then
                FancyActionBar.qsOverlay.frame:SetHidden(true)
            end
        else
            HideFrames(false)
            if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then
                FancyActionBar.qsOverlay.frame:SetHidden(false)
            end
            FancyActionBar.SetFrameColor()
        end
    end
    SetDefaultAbilityFrame()
    if _G["darkui"] then
        SetDarkUI()
    else
        ToggleFrameType()
    end
    FancyActionBar.SetUltFrameAlpha()
end

function FancyActionBar.SetFrameColor()
    if FancyActionBar.style == 2 then
        return
    end

    if FancyActionBar.style == 1 then
        for i, overlay in pairs(FancyActionBar.overlays) do
            local frame = overlay:GetNamedChild("Frame")
            frame:SetColor(unpack(SV.frameColor))
        end
        for i, overlay in pairs(FancyActionBar.ultOverlays) do
            local frame = overlay:GetNamedChild("Frame")
            frame:SetColor(unpack(SV.frameColor))
        end
        FancyActionBar.qsOverlay.frame:SetColor(unpack(SV.frameColor))
        --[[     if GetDisplayName() == "@dack_janiels" then
      local s = GetControl("ZO_SynergyTopLevel");
      local c = s:GetNamedChild("Container");
      local i = c:GetNamedChild("Icon");
      local e = i:GetNamedChild("Edge");
      e:SetColor(unpack(SV.frameColor));
    end; ]]
    end
end

function FancyActionBar.ApplyAlphaInactive(alpha)
    local alphaInactive = (alpha / 100)
    for i = MIN_INDEX, MAX_INDEX do
        local button = ZO_ActionBar_GetButton(i)
        button = FancyActionBar.buttons[i + SLOT_INDEX_OFFSET]
        button.icon:SetAlpha(alphaInactive)
    end
end

function FancyActionBar.ApplyDesaturationInactiveInactive(desaturation)
    local desaturationInactive = (desaturation / 100)
    for i = MIN_INDEX, MAX_INDEX do
        local button = ZO_ActionBar_GetButton(i)
        button = FancyActionBar.buttons[i + SLOT_INDEX_OFFSET]
        button.icon:SetDesaturation(desaturationInactive)
    end
    SV.desaturationInactive = desaturation
end

function FancyActionBar.ApplyTimerFont()
    local name, size, outline = GetCurrentFont()

    if name == "" then
        name = "$(BOLD_FONT)"
    end

    for i = MIN_INDEX, MAX_INDEX do
        local overlay = FancyActionBar.overlays[i]
        local timer = overlay:GetNamedChild("Duration")

        timer:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        timer:SetHidden(false)

        overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET]
        timer = overlay:GetNamedChild("Duration")

        timer:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        timer:SetHidden(false)
    end
end

function FancyActionBar.AdjustTimerY()
    local timerY = FancyActionBar.constants.duration.y
    local y

    if timerY == 0 then
        y = 0
    elseif timerY < 0 then
        y = timerY + (timerY * -2)
    elseif timerY > 0 then
        y = timerY - (timerY * 2)
    end

    for i = MIN_INDEX, MAX_INDEX do
        local overlay = FancyActionBar.overlays[i]
        local timer = overlay:GetNamedChild("Duration")

        timer:ClearAnchors()
        timer:SetAnchor(BOTTOM, overlay, BOTTOM, 0, y)

        overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET]
        timer = overlay:GetNamedChild("Duration")

        timer:ClearAnchors()
        timer:SetAnchor(BOTTOM, overlay, BOTTOM, 0, y)
    end
end

function FancyActionBar.ApplyStackFont()
    local name, size, outline = GetCurrentStackFont()

    if name == "" then
        name = "$(BOLD_FONT)"
    end

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local stack = overlay:GetNamedChild("Stacks")

        stack:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        stack:SetHidden(false)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        stack = overlay:GetNamedChild("Stacks")

        stack:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        stack:SetHidden(false)
    end
end

function FancyActionBar.AdjustStackX()
    local stackX = FancyActionBar.constants.stacks.x
    local stackY = FancyActionBar.constants.stacks.y
    -- so moving slider in setting will move stack the same direction
    local x = stackX - 40

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local stack = overlay:GetNamedChild("Stacks")

        stack:ClearAnchors()
        stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, stackY)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        stack = overlay:GetNamedChild("Stacks")

        stack:ClearAnchors()
        stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, stackY)
    end
end

function FancyActionBar.AdjustStackY()
    local stackX = FancyActionBar.constants.stacks.x
    local stackY = FancyActionBar.constants.stacks.y
    local x = stackX - 40
    -- so moving slider in setting will move stack the same direction

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local stack = overlay:GetNamedChild("Stacks")

        stack:ClearAnchors()
        stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, stackY)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        stack = overlay:GetNamedChild("Stacks")

        stack:ClearAnchors()
        stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, stackY)
    end
end

function FancyActionBar.ApplyTargetFont()
    local name, size, outline = GetCurrentTargetFont()

    if name == "" then
        name = "$(BOLD_FONT)"
    end

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local target = overlay:GetNamedChild("Targets")

        target:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        target:SetHidden(false)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        target = overlay:GetNamedChild("Targets")

        target:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        target:SetHidden(false)
    end
end

function FancyActionBar.AdjustTargetX()
    local targetX = FancyActionBar.constants.targets.x
    local targetY = FancyActionBar.constants.targets.y
    -- so moving slider in setting will move target the same direction

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local target = overlay:GetNamedChild("Targets")

        target:ClearAnchors()
        target:SetAnchor(TOPLEFT, overlay, TOPLEFT, targetX, targetY)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        target = overlay:GetNamedChild("Targets")

        target:ClearAnchors()
        target:SetAnchor(TOPLEFT, overlay, TOPLEFT, targetX, targetY)
    end
end

function FancyActionBar.AdjustTargetY()
    local targetX = FancyActionBar.constants.targets.x
    local targetY = FancyActionBar.constants.targets.y
    -- so moving slider in setting will move target the same direction

    for i = MIN_INDEX, ULT_INDEX do
        local overlay = FancyActionBar.GetOverlay(i)
        local target = overlay:GetNamedChild("Targets")

        target:ClearAnchors()
        target:SetAnchor(TOPLEFT, overlay, TOPLEFT, targetX, targetY)

        overlay = FancyActionBar.GetOverlay(i + SLOT_INDEX_OFFSET)
        target = overlay:GetNamedChild("Targets")

        target:ClearAnchors()
        target:SetAnchor(TOPLEFT, overlay, TOPLEFT, targetX, targetY)
    end
end

function FancyActionBar.AdjustQuickSlotTimer()
    local timerX = FancyActionBar.constants.qs.x
    local timerY = FancyActionBar.constants.qs.y
    local x = timerX
    local y

    if timerY == 0 then
        y = 0
    elseif timerY < 0 then
        y = timerY + (timerY * -2)
    elseif timerY > 0 then
        y = timerY - (timerY * 2)
    end

    local qs = FancyActionBar.qsOverlay
    local d = qs:GetNamedChild("Duration")
    d:ClearAnchors()
    d:SetAnchor(CENTER, qs, CENTER, x, y)
end

function FancyActionBar.ApplyQuickSlotFont()
    local name, size, type, stackName, stackSize, stackType = GetCurrentQuickSlotTimerFont()
    if name == "" then
        name = "$(BOLD_FONT)"
    end

    if FancyActionBar.qsOverlay then
        FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type)
    end

    local QSB = GetControl("QuickslotButton")
    QSB:GetNamedChild("CountText"):SetFont(FAB_Fonts[stackName] .. "|" .. stackSize .. "|" .. stackType)
    QSB:GetNamedChild("CountText"):SetColor(unpack(FancyActionBar.useGamepadActionBar and SV.qsStackColorGP or SV.qsStackColorKB))
end

function FancyActionBar.UpdateHighlight(index)
    local button = FancyActionBar.GetActionButton(index)
    local overlay = FancyActionBar.GetOverlay(index)
    local effect = overlay.effect
    local bgControl = overlay.bg
    local durationControl = overlay.timer

    -- local state
    if button and overlay then
        if (FancyActionBar.toggles[effect.id] == true or effect.passive == true) then
            -- state = 'On'
            if SV.toggledHighlight then
                button.status:SetAlpha(0)
                bgControl:SetColor(unpack(SV.toggledColor))
                bgControl:SetHidden(false)
            elseif SV.showHighlight then
                button.status:SetAlpha(0)
                bgControl:SetColor(unpack(SV.highlightColor))
                bgControl:SetHidden(false)
            else
                bgControl:SetHidden(true)
                button.status:SetAlpha(0.7)
            end
            durationControl:SetText("")
        else
            -- state = 'Off'
            bgControl:SetHidden(true)
            button.status:SetAlpha(0.7)
        end
        -- Chat('Toggled overlay ' .. index .. ' bg: ' .. state)
    end
end

function FancyActionBar.AdjustUltTimer(sample)
    local timerX = FancyActionBar.constants.ult.duration.x
    local timerY = FancyActionBar.constants.ult.duration.y
    local x = timerX -- - 20
    local y
    if timerY == 0 then
        y = 0
    elseif timerY < 0 then
        y = timerY + (timerY * -2)
    elseif timerY > 0 then
        y = timerY - (timerY * 2)
    end

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        overlay = FancyActionBar.ultOverlays[i]
        if overlay then
            local durationControl = overlay:GetNamedChild("Duration")
            durationControl:ClearAnchors()
            durationControl:SetAnchor(CENTER, overlay, CENTER, x, y)
            local effect = overlay.effect
            if inMenu and sample then
                DisplayUltimateLabelChanges()
            end
        end
    end
end

function FancyActionBar.ApplyUltFont(sample)
    local name, size, outline = GetCurrentUltFont()

    if name == "" then
        name = "$(BOLD_FONT)"
    end

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        overlay = FancyActionBar.ultOverlays[i]
        if overlay then
            overlay:GetNamedChild("Duration"):SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        end
    end

    if sample then
        DisplayUltimateLabelChanges()
    end
end

function FancyActionBar.AdjustUltValue()
    local timerX = FancyActionBar.constants.ult.value.x
    local timerY = FancyActionBar.constants.ult.value.y
    local x = timerX -- - 20
    local y
    if timerY == 0 then
        y = 0
    elseif timerY < 0 then
        y = timerY + (timerY * -2)
    elseif timerY > 0 then
        y = timerY - (timerY * 2)
    end

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        overlay = FancyActionBar.ultOverlays[i]
        if overlay and i < 30 then
            local value = overlay:GetNamedChild("Value")
            value:ClearAnchors()
            value:SetAnchor(BOTTOMRIGHT, overlay, BOTTOMRIGHT, x, y)
        end
    end
end

function FancyActionBar.AdjustCompanionUltValue()
    local timerX = FancyActionBar.constants.ult.companion.x
    local timerY = FancyActionBar.constants.ult.companion.y
    local x = timerX -- - 20
    local y
    if timerY == 0 then
        y = 0
    elseif timerY < 0 then
        y = timerY + (timerY * -2)
    elseif timerY > 0 then
        y = timerY - (timerY * 2)
    end

    local overlay = FancyActionBar.ultOverlays[ULT_INDEX + COMPANION_INDEX_OFFSET]
    if overlay then
        local value = overlay:GetNamedChild("Value")
        value:ClearAnchors()
        value:SetAnchor(BOTTOMRIGHT, overlay, BOTTOMRIGHT, x, y)
    end
end

function FancyActionBar.ApplyUltValueFont()
    local name, size, outline = GetCurrentUltValueFont()

    if name == "" then
        name = "$(BOLD_FONT)"
    end

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        overlay = FancyActionBar.ultOverlays[i]
        if overlay then
            local l = overlay:GetNamedChild("Value")
            l:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. outline)
        end
    end
end

function FancyActionBar.ApplyUltValueColor()
    local color = FancyActionBar.constants.ult.value.color

    for i, overlay in pairs(FancyActionBar.ultOverlays) do
        if FancyActionBar.ultOverlays[i] then
            FancyActionBar.ultOverlays[i]:GetNamedChild("Value"):SetColor(unpack(color))
        end
    end
end

function FancyActionBar.UpdateUltValueMode()
    local e = FancyActionBar.constants.ult.value.show
    local c = FancyActionBar.constants.ult.companion.show
    local current, max, effectiveMax

    if e then
        current, max, effectiveMax = GetUnitPower("player", COMBAT_MECHANIC_FLAGS_ULTIMATE)
        FancyActionBar.UpdateUltimateValueLabels(true, current)
    end

    if c then
        current, max, effectiveMax = GetUnitPower("companion", COMBAT_MECHANIC_FLAGS_ULTIMATE)
        FancyActionBar.UpdateUltimateValueLabels(false, current)
    end
end

function FancyActionBar.EnableGDC()
    SV.gcd.enable = true
    FancyActionBar.ToggleGCD()
end

function FancyActionBar.DisableGCD()
    SV.gcd.enable = false
    FancyActionBar.ToggleGCD()
end

local function OnCombatEnter()
    if (IsUnitInCombat("player") and not FancyActionBar.inCombat) then
        FancyActionBar.inCombat = true
        FAB_GCD:SetHidden(false)
        EM:RegisterForUpdate(FancyActionBar.GetName() .. "GCD", 20, FancyActionBar.UpdateGCD)
    else
        if FancyActionBar.inCombat then
            FancyActionBar.inCombat = false
            FAB_GCD:SetHidden(true)
            EM:UnregisterForUpdate(FancyActionBar.GetName() .. "GCD")
        end
    end
end

function FancyActionBar.ToggleGCD()
    local function OnStateChanged(oldState, newState)
        if (newState == SCENE_SHOWN and SV.gcd.enable) then
            if (not FancyActionBar.inCombat and SV.gcd.combatOnly) then
                return
            end
            FAB_GCD:SetHidden(false)
        else
            FAB_GCD:SetHidden(true)
        end
    end

    local name = FancyActionBar.GetName()

    EM:UnregisterForUpdate(name .. "GCD")
    --- @diagnostic disable-next-line: redundant-parameter
    EM:UnregisterForEvent(name .. "GCDCombatState", EVENT_PLAYER_COMBAT_STATE, OnCombatEnter)

    if SV.gcd.enable then
        if SV.gcd.combatOnly then
            EM:RegisterForEvent(name .. "GCDCombatState", EVENT_PLAYER_COMBAT_STATE, OnCombatEnter)
        else
            FAB_GCD:SetHidden(false)
            EM:RegisterForUpdate(name .. "GCD", 20, FancyActionBar.UpdateGCD)
        end
        SCENE_MANAGER:GetScene("hud"):RegisterCallback("StateChange", OnStateChanged)
        SCENE_MANAGER:GetScene("hudui"):RegisterCallback("StateChange", OnStateChanged)
    else
        SCENE_MANAGER:GetScene("hud"):UnregisterCallback("StateChange")
        SCENE_MANAGER:GetScene("hudui"):UnregisterCallback("StateChange")
        FAB_GCD:SetHidden(true)
    end
end

function FancyActionBar.UpdateGCDSize()
    FAB_GCD:SetDimensions(SV.gcd.sizeX, SV.gcd.sizeY)
    FAB_GCD.frame:SetDimensions(SV.gcd.sizeX + 5, SV.gcd.sizeY + 5)
end

function FancyActionBar.SetupGCD()
    FAB_GCD:SetClampedToScreen(true)
    FAB_GCD:SetHidden(true)
    FAB_GCD:SetDimensions(SV.gcd.sizeX, SV.gcd.sizeY)
    FAB_GCD:SetMouseEnabled(true)
    FAB_GCD:SetMovable(true)
    FAB_GCD:SetAlpha(1)
    FAB_GCD:ClearAnchors()

    local f = CreateControl("$(parent)Frame", FAB_GCD, CT_TEXTURE)
    f:SetTexture(FAB_FRAME)
    f:SetDimensions(SV.gcd.sizeX + 5, SV.gcd.sizeY + 5)
    f:SetAnchor(CENTER, FAB_GCD, CENTER, 0, 0)
    f:SetColor(unpack(SV.gcd.frameColor))
    f:SetDrawLevel(4)

    local b = CreateControlFromVirtual("$(parent)BG", FAB_GCD, "FAB_BG")
    b:SetCenterColor(0, 0, 0, 0.4)
    b:SetEdgeColor(0, 0, 0, 1)
    b:SetDrawLevel(1)

    local l = CreateControlFromVirtual("$(parent)Fill", FAB_GCD, "FAB_Fill")
    l:SetCenterColor(unpack(SV.gcd.fillColor))
    l:SetEdgeColor(unpack(SV.gcd.fillColor))
    l:SetDrawLevel(2)

    FAB_GCD.frame = f
    FAB_GCD.bg = b
    FAB_GCD.fill = l

    FAB_GCD:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SV.gcd.x, SV.gcd.y, FAB_GCD:GetResizeToFitConstrains())
end

function FancyActionBar.SetMoved(moved)
    FancyActionBar.wasMoved = moved
end

function FancyActionBar.UndoMove()
    local prevX, prevY
    if FancyActionBar.style == 2 then
        prevX = SV.abMove.gp.prevX
        prevY = SV.abMove.gp.prevY
    else
        prevX = SV.abMove.kb.prevX
        prevY = SV.abMove.kb.prevY
    end
    SaveCurrentLocation()
    ACTION_BAR:ClearAnchors()
    ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, prevX, prevY)
    ReanchorMover()
    FancyActionBar.SaveMoverPosition()
    FAB_Mover:SetHidden(not FancyActionBar.IsUnlocked())
end

function FancyActionBar.ResetMoveActionBar()
    local v, d = FancyActionBar:GetMovableVarsForUI()
    SaveCurrentLocation()
    ACTION_BAR:ClearAnchors()

    local screenWidth = GuiRoot:GetWidth()
    local screenHeight = GuiRoot:GetHeight()
    local barWidth = ACTION_BAR:GetWidth()
    local barHeight = ACTION_BAR:GetHeight()

    local posX, posY

    if IsConsoleUI() then
        -- Translate BOTTOM anchoring to TOPLEFT anchoring for console
        posX = (screenWidth - barWidth) / 2 + (d.x or 0)
        posY = screenHeight - barHeight + (d.y or -75)
        ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, posX, posY)
    else
        ACTION_BAR:SetAnchor(BOTTOM, GuiRoot, BOTTOM, d.x or 0, d.y or 0)
    end

    ACTION_BAR:RegisterForEvent(EVENT_SCREEN_RESIZED, function ()
        if not v.enable then
            ACTION_BAR:ClearAnchors()
            if IsConsoleUI() then
                local newX = (GuiRoot:GetWidth() - ACTION_BAR:GetWidth()) / 2 + (d.x or 0)
                local newY = GuiRoot:GetHeight() - ACTION_BAR:GetHeight() + (d.y or -75)
                ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, newX, newY)
            else
                ACTION_BAR:SetAnchor(BOTTOM, GuiRoot, BOTTOM, d.x or 0, d.y or 0)
            end
        end
    end)

    ReanchorMover()
    FancyActionBar.SaveMoverPosition()

    if FancyActionBar.style == 2 then
        SV.abMove.gp.x = d.x
        SV.abMove.gp.y = d.y
        SV.abMove.gp.enable = false
    else
        SV.abMove.kb.x = d.x
        SV.abMove.kb.y = d.y
        SV.abMove.kb.enable = false
    end

    FancyActionBar.constants.move.x = d.x
    FancyActionBar.constants.move.y = d.y
    FancyActionBar.constants.move.enable = false
    FancyActionBar.SetMoved(false)
    FAB_Mover:SetHidden(not FancyActionBar.IsUnlocked())
end

function FancyActionBar.CenterActionBar(horiz, vert)
    SaveCurrentLocation()
    local x = FAB_Mover:GetLeft()
    local y = FAB_Mover:GetTop()

    if vert then
        local height = ACTION_BAR:GetHeight()
        y = zo_floor((GuiRoot:GetHeight() - height) / 2) + 8
    end

    if horiz then
        local width = ACTION_BAR:GetWidth()
        x = zo_floor((GuiRoot:GetWidth() - width) / 2)
    end

    ACTION_BAR:ClearAnchors()
    ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
    ReanchorMover()
    FancyActionBar.SaveMoverPosition()
    FAB_Mover:SetHidden(not FancyActionBar.IsUnlocked())
end

function FancyActionBar.ToggleMover(enableMove)
    if enableMove == true then
        unlocked = enableMove
        -- RefreshMoverSize()
        ReanchorMover()
        SaveCurrentLocation()
        FAB_Mover:SetHidden(false)
        FAB_Mover:SetMovable(true)
        FAB_Mover:SetMouseEnabled(true)
    elseif enableMove == false then
        unlocked = enableMove
        FAB_Mover:SetHidden(true)
        FAB_Mover:SetMovable(false)
        FAB_Mover:SetMouseEnabled(false)
        ReanchorMover()
    end
end

function FancyActionBar.MoveActionBar()
    local v, d = FancyActionBar:GetMovableVarsForUI()
    FancyActionBar.SetMoved(v.enable or false)

    ACTION_BAR:ClearAnchors()

    if v.enable then
        -- Ensure the action bar stays within screen bounds
        local screenWidth = GuiRoot:GetWidth()
        local screenHeight = GuiRoot:GetHeight()
        local barWidth = ACTION_BAR:GetWidth()
        local barHeight = ACTION_BAR:GetHeight()

        -- Clamp position to screen bounds with padding
        local padding = 20
        local x = zo_clamp(v.x, -barWidth + padding, screenWidth - padding)
        local y = zo_clamp(v.y, -barHeight + padding, screenHeight - padding)

        ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)

        -- Update stored position if it was clamped
        if x ~= v.x or y ~= v.y then
            if FancyActionBar.style == 2 then
                SV.abMove.gp.x = x
                SV.abMove.gp.y = y
            else
                SV.abMove.kb.x = x
                SV.abMove.kb.y = y
            end
        end
    else
        ACTION_BAR:SetAnchor(BOTTOM, GuiRoot, BOTTOM, d.x, d.y)
    end
end

function FancyActionBar.SaveGCDPosition()
    if SV.gcd == nil then
        SV.gcd = {}
    end
    SV.gcd.x = FAB_GCD:GetLeft()
    SV.gcd.y = FAB_GCD:GetTop()
end

function FancyActionBar.SaveMoverPosition()
    local x = FAB_Mover:GetLeft()
    local y = FAB_Mover:GetTop()

    if FancyActionBar.style == 2 then
        SV.abMove.gp.x = x
        SV.abMove.gp.y = y
        SV.abMove.gp.enable = true
    else
        SV.abMove.kb.x = x
        SV.abMove.kb.y = y
        SV.abMove.kb.enable = true
    end

    FancyActionBar.constants.move.x = x
    FancyActionBar.constants.move.y = y
    FancyActionBar.constants.move.enable = true

    if Azurah then UpdateAzurahDb() end

    if BUI and BUI.Vars["ZO_ActionBar1"] then
        BUI.Vars["ZO_ActionBar1"][1] = TOPLEFT
        BUI.Vars["ZO_ActionBar1"][2] = TOPLEFT
        BUI.Vars["ZO_ActionBar1"][3] = x
        BUI.Vars["ZO_ActionBar1"][4] = y
    end

    if LUIE and LUIE.SV["ZO_ActionBar1"] then
        LUIE.SV["ZO_ActionBar1"][1] = x
        LUIE.SV["ZO_ActionBar1"][2] = y
    end

    ACTION_BAR:ClearAnchors()
    ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y)
    FancyActionBar.SetMoved(true)
    local activeWeaponPair, locked = GetActiveWeaponPairInfo()
    SetBarTheme(locked)
end

function FancyActionBar.ConsoleMoveActionBarViaMover(x, y, movedX, movedY)
    local oldX = FAB_Mover:GetLeft()
    local oldY = FAB_Mover:GetTop()
    local v, d = FancyActionBar:GetMovableVarsForUI()
    local screenWidth = GuiRoot:GetWidth()
    local screenHeight = GuiRoot:GetHeight()
    local barWidth = ACTION_BAR:GetWidth()
    local barHeight = ACTION_BAR:GetHeight()

    local newX, newY

    -- Convert slider offset from BOTTOM anchor base to TOPLEFT anchor position
    local baseX = (screenWidth - barWidth) / 2 + d.x
    local baseY = screenHeight - barHeight + d.y

    newX = movedX and (baseX + x) or oldX
    newY = movedY and (baseY + y) or oldY

    ACTION_BAR:ClearAnchors()
    ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, newX, newY)

    ReanchorMover()
    FancyActionBar.SaveMoverPosition()
end

function FancyActionBar.RepositionHealthBar()
    if FancyActionBar.wasMoved then
        return
    end
    if Azurah then
        return
    end
    if SV.moveHealthBar then
        local c = FancyActionBar.GetConstants()
        local scale = FancyActionBar.GetScale()
        local barYOffset = FancyActionBar.useGamepadActionBar and SV.barYOffsetGP or SV.barYOffsetKB
        local abTop = ACTION_BAR:GetTop()

        -- Reposition Health Bar
        ZO_PlayerAttributeHealth:ClearAnchors()
        ZO_PlayerAttributeHealth:SetAnchor(TOP, GuiRoot, TOP, 0, (abTop - ((c.dimensions * scale) + 4 + barYOffset)))

        if SV.moveResourceBars then
            local healthTop = ZO_PlayerAttributeHealth:GetTop()

            -- Reposition Magicka Bar
            local magX = ZO_PlayerAttributeMagicka:GetLeft()
            ZO_PlayerAttributeMagicka:ClearAnchors()
            ZO_PlayerAttributeMagicka:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, magX, healthTop)

            -- Reposition Stamina Bar
            local stamX = ZO_PlayerAttributeStamina:GetLeft()
            ZO_PlayerAttributeStamina:ClearAnchors()
            ZO_PlayerAttributeStamina:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, stamX, healthTop)
        end
    end
end

local function PlayerDeath(oldState, newState)
    if newState == SCENE_SHOWN then
        ACTION_BAR:SetHidden(false)
    else
        if not inMenu and IsUnitDead("player") then
            ACTION_BAR:SetHidden(true)
        end
    end
end

function FancyActionBar.ApplyDeathStateOption()
    -- ZO_PreHookHandler(ZO_Death, 'OnShow', PlayerDeath)

    --- @diagnostic disable-next-line: missing-parameter
    DEATH_FRAGMENT:UnregisterCallback("StateChange")

    if SV.showDeath then
        DEATH_FRAGMENT:RegisterCallback("StateChange", PlayerDeath)
    end
end

function FancyActionBar.UpdateScale(s)
    local scale = s
    ACTION_BAR:SetScale(scale)
    RefreshMoverSize()
end

function FancyActionBar.InitializeScreenResizeHandler()
    local function OnScreenResize()
        local v = FancyActionBar:GetMovableVarsForUI()
        if v.enable then
            -- Recalculate position when screen is resized
            local screenWidth = GuiRoot:GetWidth()
            local screenHeight = GuiRoot:GetHeight()
            local barWidth = ACTION_BAR:GetWidth()
            local barHeight = ACTION_BAR:GetHeight()

            -- Maintain relative position on screen
            local relativeX = v.x / screenWidth
            local relativeY = v.y / screenHeight

            -- Apply new position with bounds checking
            local padding = 20
            local newX = zo_clamp(relativeX * screenWidth, -barWidth + padding, screenWidth - padding)
            local newY = zo_clamp(relativeY * screenHeight, -barHeight + padding, screenHeight - padding)

            ACTION_BAR:ClearAnchors()
            ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, newX, newY)

            -- Update stored position
            if FancyActionBar.style == 2 then
                SV.abMove.gp.x = newX
                SV.abMove.gp.y = newY
            else
                SV.abMove.kb.x = newX
                SV.abMove.kb.y = newY
            end

            -- Update mover position
            ReanchorMover()
        end
    end

    EVENT_MANAGER:RegisterForEvent("FancyActionBar_ScreenResize", EVENT_SCREEN_RESIZED, OnScreenResize)
end
