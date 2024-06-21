---@class (partial) FancyActionBar
local FancyActionBar = FancyActionBar;
local LAM = LibAddonMenu2;
local EM = GetEventManager();
local WM = GetWindowManager();
local SM = SCENE_MANAGER;
local SV;
local CV;
local ACTION_BAR = GetControl("ZO_ActionBar1");
local FAB_Default_Bar_Position = GetControl("FAB_Default_Bar_Position");
local MIN_INDEX = 3;          -- first ability index
local MAX_INDEX = 7;          -- last ability index
local ULT_INDEX = MAX_INDEX + 1;
local SLOT_INDEX_OFFSET = 20; -- offset for backbar abilities indices
local COMPANION_INDEX_OFFSET = 30;
local ULT_SLOT = 8;           -- ACTION_BAR_ULTIMATE_SLOT_INDEX + 1
local QUICK_SLOT = 9;         --ACTION_BAR_FIRST_UTILITY_BAR_SLOT + 1
local COMPANION = HOTBAR_CATEGORY_COMPANION;
local hideStatus = false;
local inMenu = false;
local settingsPageCreated = false;
local unlocked = false;
local ultDisplayTime = 0;
local qsDisplayTime = 0;
local FAB_FRAME = "/FancyActionBar+/texture/abilityFrame64_up.dds";
local FAB_NO_FRAME_DOWN = "/FancyActionBar+/texture/abilitynoframe64_down.dds";
local FAB_BLANK = "/FancyActionBar+/texture/blank.dds";
local FAB_MARKER = "/FancyActionBar+/texture/redarrow.dds";
local FAB_BG = "/FancyActionBar+/texture/button_bg.dds";
local FAB_Fonts = {
  ["ProseAntique"] = "$(ANTIQUE_FONT)";
  ["Consolas"] = "/EsoUI/Common/Fonts/consola.slug";
  ["Futura Condensed"] = "$(GAMEPAD_MEDIUM_FONT)";
  ["Futura Condensed Bold"] = "$(GAMEPAD_BOLD_FONT)";
  ["Futura Condensed Light"] = "$(GAMEPAD_LIGHT_FONT)";
  ["Skyrim Handwritten"] = "$(HANDWRITTEN_FONT)";
  ["Trajan Pro"] = "$(STONE_TABLET_FONT)";
  ["Univers 55"] = "$(CHAT_FONT)";
  ["Univers 57"] = "$(MEDIUM_FONT)";
  ["Univers 67"] = "$(BOLD_FONT)";
};
local decimalOptions = {
  ["Always"] = true;
  ["Expire"] = true;
  ["Never"] = false;
};
local ultModeOptions = {
  ["Current"] = 1;
  ["Current / Cost (dynamic)"] = 2;
  ["Current / Cost (static)"] = 3;
};
local skillToEditID = 0;
local skillToEditName = "";
local effectToTrackID = 0;
local effectToTrackName = "";
local skillEditType = -1;
local skillEditChoice = "";
local skillEditTypes = {
  [-1] = "";
  [0] = "Disable";
  [1] = "Reset";
  [2] = "New ID";
};
local skillEditValues = {
  [""] = -1;
  ["Disable"] = 0;
  ["Reset"] = 1;
  ["New ID"] = 2;
};
local changedSkillIds = {};
local changedSkillStrings = {};
local selectedChangedSkill = 0;

local skillToBlacklistID = 0;
local skillToBlacklistName = "";
local blacklistedSkillNames = {};
local blacklistedSkillIds = {};
local selectedBlacklist = 0;

local debuffToEditID = 0;
local debuffToEditName = "";
local debuffNames = {};
local debuffIds = {};
local selectedDebuff = 0;

---@param msg string
---@param ... any
local function Chat(msg, ...)
  FancyActionBar.Chat(msg, ...);
end;


function FancyActionBar.InMenu()
  return inMenu;
end;

function FancyActionBar.GetFonts()
  local fonts = {};
  for k in pairs(FAB_Fonts) do table.insert(fonts, k); end;
  return fonts;
end;

function FancyActionBar.GetDecimalOptions()
  local options = {};
  for k in pairs(decimalOptions) do table.insert(options, k); end;
  return options;
end;

function FancyActionBar.IsUnlocked()
  return unlocked;
end;

-------------------------------------------------------------------------------
-----------------------------[   Local Functions   ]---------------------------
-------------------------------------------------------------------------------
local function IsValidId(id)
  local abilityId = 0;
  if type(id) == "string" then
    abilityId = tonumber(id);
  elseif type(id) == "number" then
    abilityId = id;
  end;

  if abilityId == 0 or type(abilityId) ~= "number" then return false; end;

  if not DoesAbilityExist(abilityId) then return false; end;

  if abilityId == 133027 then
    Chat("Please use id |cffffff13816|r instead of |cffffff" .. abilityId .. "|r");
    return false;
  end;

  return true;
end;
----------------------------------------------
-----------[   External Buffs   ]-------------
----------------------------------------------
local function ParseExternalBlacklist()
  for id, name in pairs(SV.externalBlackList) do
    blacklistedSkillIds[id] = name;
    blacklistedSkillNames[name] = id;
  end;
end;

local function CanBlacklistId()
  local possible = true;
  if skillToBlacklistID == 0 or SV.externalBlackList[skillToBlacklistID] ~= nil then
    possible = false;
  end;
  return possible;
end;

local function CanClearBlacklistId()
  local possible = true;
  if selectedBlacklist == 0 or SV.externalBlackList[selectedBlacklist] == nil then
    possible = false;
  end;
  return possible;
end;

local function GetSkillToBlacklistID()
  local id = "";
  if skillToBlacklistID > 0 then
    id = tostring(skillToBlacklistID);
  end;
  return id;
end;

local function GetSkillToBlacklistName()
  local name = "";
  if skillToBlacklistID > 0 then
    name = "|cffa31a" .. GetAbilityName(skillToBlacklistID) .. "|r";
  end;
  return name;
end;

local function SetSkillToBlacklistID(id)
  if not IsValidId(id) then
    Chat("|cffffff" .. id .. " is not a valid ID.");
    skillToBlacklistID = 0;
    skillToBlacklistName = "";
    WM:GetControlByName("SkillToBlacklistTitle").desc:SetText("");
    return;
  end;

  if tonumber(id) then
    skillToBlacklistID = tonumber(id);
    skillToBlacklistName = GetAbilityName(skillToBlacklistID);
    FancyActionBar:dbg("Skill to blacklist updated to: " .. skillToBlacklistName .. " (" .. skillToBlacklistID .. ")");
    WM:GetControlByName("SkillToBlacklistTitle").desc:SetText(skillToBlacklistName);
  end;
end;

local function GetSelectedBlacklist()
  if blacklistedSkillIds[selectedBlacklist] then
    return blacklistedSkillIds[selectedBlacklist];
  end;
end;

local function SetSelectedBlacklist(string)
  if string == "== Select a Skill ==" or string == "" or string == nil then return; end;
  if blacklistedSkillNames[string] then
    local id = blacklistedSkillNames[string];
    if type(id) == "string" then
      id = tonumber(id);
    end;
    if SV.externalBlackList[id] then
      selectedBlacklist = id;
      FancyActionBar:dbg("selected " .. string .. " (" .. selectedBlacklist .. ")");
    end;
  end;
end;

local function GetBlacklistedSkills()
  local list = {};
  local default = "== Select a Skill ==";
  table.insert(list, default);

  for id, name in pairs(SV.externalBlackList) do
    -- blacklistedSkillIds[id]     = name
    -- blacklistedSkillNames[name] = id
    table.insert(list, name);
  end;
  return list;
end;

local function BlacklistId()
  if CanBlacklistId() then
    SV.externalBlackList[skillToBlacklistID] = skillToBlacklistName;

    skillToBlacklistID = 0;
    skillToBlacklistName = "";

    ParseExternalBlacklist();

    WM:GetControlByName("SkillToBlacklistTitle").desc:SetText("");
    WM:GetControlByName("SkillToBlacklistID_Editbox").editbox:SetText("");
    WM:GetControlByName("Blacklist_Dropdown"):UpdateChoices(GetBlacklistedSkills());
    WM:GetControlByName("Blacklist_Dropdown").dropdown:SetSelectedItem(GetSelectedBlacklist());
  else
    Chat("failed to blacklist: " .. skillToBlacklistName .. " (" .. skillToBlacklistID .. ")");
  end;
end;

local function ClearBlacklistId()
  if SV.externalBlackList[selectedBlacklist] then
    -- if CanClearBlacklistId() then
    SV.externalBlackList[selectedBlacklist] = nil;

    blacklistedSkillNames[blacklistedSkillIds[selectedBlacklist]] = nil;
    blacklistedSkillIds[selectedBlacklist] = nil;

    -- Chat(selectedBlacklist .. ' clear')
    selectedBlacklist = 0;

    ParseExternalBlacklist();

    WM:GetControlByName("Blacklist_Dropdown"):UpdateChoices(GetBlacklistedSkills());
    WM:GetControlByName("Blacklist_Dropdown").dropdown:SetSelectedItem(nil);
  end;
end;
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
local function GetTrackedEffectForAbility(id)
  local effect = nil;
  local cfg = FancyActionBar.GetAbilityConfig();
  local cstcgf = FancyActionBar.GetAbilityConfigChanges();
  local name = "";

  if cstcgf[id] or cfg[id] then
    effect = cstcgf[id] or cfg[id];
    if type(effect) == "table" then
      local a = effect[1] or id;
      name = GetAbilityName(a) .. " (" .. a .. ")";
    elseif effect == true then
      name = GetAbilityName(id) .. " (" .. id .. ")";
    elseif effect == false then
      name = "Disabled";
    else
      name = "Not Tracked";
    end;
  end;

  return name;
end;

local function GetSkillChangeType()
  return skillEditTypes[skillEditType];
  -- local type = skillEditTypes[skillEditType]
  -- if type then return type end
end;

local function SetSkillChangeType(type)
  skillEditType = skillEditValues[type];
  skillEditChoice = skillEditTypes[skillEditType];
  -- WM:GetControlByName('Change_Type_Dropdown').dropdown:SetSelectedItem(GetSkillEditChoice)
end;

local function GetSkillChangeOptions()
  local options = {};
  for _, v in pairs(skillEditTypes) do
    table.insert(options, v);
  end;
  return options;
end;

local function GetChangedSkills()
  local skills = {};
  local default = "== Select a Skill ==";
  local changes = FancyActionBar.GetAbilityConfigChanges();

  table.insert(skills, default);

  for id, cfg in pairs(changes) do
    if id ~= 133027 then -- ignore sencond id for stone giant
      local str = GetAbilityName(id) .. " (";
      if type(cfg) == "table" then
        local a = cfg[1] or id;
        str = str .. tostring(a) .. ")";
      elseif cfg == true then
        str = str .. tostring(id) .. ")";
      elseif cfg == false then
        str = str .. "Disabled)";
      else
        str = str .. "Not Tracked)";
      end;

      changedSkillStrings[id] = str;
      changedSkillIds[str] = id;
      table.insert(skills, str);
    end;
  end;
  return skills;
end;

local function GetSkillToEditID()
  local id = "";
  if skillToEditID > 0 then
    id = tostring(skillToEditID);
  end;
  return id;
end;

local function GetSkillToEditName()
  local name = "";
  if skillToEditID > 0 then
    name = "|cffa31a" .. GetAbilityName(skillToEditID) .. "|r: " .. GetTrackedEffectForAbility(skillToEditID);
  end;
  return name;
end;

local function GetEffectToTrackName()
  local name = "";
  if effectToTrackID > 0 then
    name = "|cffa31a" .. GetAbilityName(effectToTrackID) .. "|r";
  end;
  return name;
end;

local function GetEffectToTrackID()
  local id = "";
  if effectToTrackID > 0 then
    id = tostring(effectToTrackID);
  end;
  return id;
end;

local function GetSelectedChangedSkill()
  local skill = "== Select a Skill ==";
  if selectedChangedSkill > 0 then
    if changedSkillStrings[selectedChangedSkill] then
      skill = changedSkillStrings[selectedChangedSkill];
    end;
  end;
  return skill;
end;

local function SetSkillToEditID(id)
  if id == "" or not IsValidId(id) then
    if id ~= "" then
      Chat("|cffffff" .. id .. " is not a valid ID.");
    end;
    skillToEditID = 0;
    skillToEditName = "";
    WM:GetControlByName("SkillToEditTitle").desc:SetText("");
    return;
  end;

  local i = nil;
  if tonumber(id) then
    i = tonumber(id);
    skillToEditID = i;
    skillToEditName = GetAbilityName(skillToEditID);
    FancyActionBar:dbg("Skill to edit updated to: " .. skillToEditName .. " (" .. skillToEditID .. ")");
    WM:GetControlByName("SkillToEditTitle").desc:SetText(skillToEditName);
  end;
end;

local function SetEffectToTrackID(id)
  if id == "" or not IsValidId(id) then
    if id ~= "" then
      Chat("|cffffff" .. id .. " is not a valid ID.");
    end;
    effectToTrackID = 0;
    effectToTrackName = "";
    WM:GetControlByName("EffectToTrackTitle").desc:SetText("");
    return;
  end;

  local i = nil;
  if tonumber(id) then
    i = tonumber(id);
    effectToTrackID = i;
    effectToTrackName = GetAbilityName(effectToTrackID);
    FancyActionBar:dbg("Effect to track updated to: " .. effectToTrackName .. " (" .. effectToTrackID .. ")");
    WM:GetControlByName("EffectToTrackTitle").desc:SetText(effectToTrackName);
  end;
end;

local function SetChangedSkillToEdit(string)
  if string == "== Select a Skill ==" then return; end;
  if changedSkillIds[string] then
    selectedChangedSkill = changedSkillIds[string];
    SetSkillToEditID(tostring(selectedChangedSkill));
  end;
end;

local function ResetUpdateSettings()
  skillToEditID = 0;
  skillToEditName = "";
  effectToTrackID = 0;
  effectToTrackName = "";
  skillEditType = -1;
  skillEditChoice = skillEditTypes[skillEditType];
  selectedChangedSkill = 0;

  WM:GetControlByName("SkillToEditTitle").desc:SetText("");
  WM:GetControlByName("EffectToTrackTitle").desc:SetText("");

  WM:GetControlByName("Change_Type_Dropdown"):UpdateChoices(GetSkillChangeOptions());
  WM:GetControlByName("Change_Type_Dropdown").dropdown:SetSelectedItem(GetSkillChangeType());

  WM:GetControlByName("Saved_Changes_Dropdown"):UpdateChoices(GetChangedSkills());
  WM:GetControlByName("Saved_Changes_Dropdown").dropdown:SetSelectedItem(GetSelectedChangedSkill());

  WM:GetControlByName("SkillToEditID_Editbox").editbox:SetText(GetSkillToEditID());
  WM:GetControlByName("EffectToTrackID_Editbox").editbox:SetText("");
end;

local function UpdateEffectForAbility(track, ability, effect)
  local config;

  if track == 0 then     -- dont track this skill
    config = false;
  elseif track == 1 then -- reset data for skill effect
    if FancyActionBar.abilityConfig[ability] then
      config = FancyActionBar.abilityConfig[ability];
      -- else
      --   config = {}
    end;
  elseif track == 2 then -- set new skill effect
    config = { effect };
  end;

  if not CV.useAccountWide then
    CV.configChanges[ability] = config or FancyActionBar.abilityConfig[ability];
    if track == 1 then
      CV.configChanges[ability] = nil;
    else
      CV.configChanges[ability] = config;
    end;
    if ability == 31816 then
      FancyActionBar.abilityConfig[133027] = FancyActionBar.abilityConfig[ability] or nil;
      CV.configChanges[133027] = CV.configChanges[ability] or nil;
    end;
  else
    SV.configChanges[ability] = config or FancyActionBar.abilityConfig[ability];
    if track == 1 then
      SV.configChanges[ability] = nil;
    else
      SV.configChanges[ability] = config;
    end;
    if ability == 31816 then
      FancyActionBar.abilityConfig[133027] = FancyActionBar.abilityConfig[ability] or nil;
      SV.configChanges[133027] = SV.configChanges[ability] or nil;
    end;
  end;

  ResetUpdateSettings();

  FancyActionBar.EditCurrentAbilityConfiguration(ability, config);
end;

local function IsChangePossible()
  local possible = true;

  if (skillToEditID == 0 or skillEditType == -1 or (skillEditType > 1 and effectToTrackID == 0)) then possible = false; end;

  return not possible;
end;

local function FormatSkillUpdateMessage()
  local newEffect = 0;
  if skillEditType > 0 then
    if skillEditType == 1 then
      local old = FancyActionBar.abilityConfig[skillToEditID];
      if old ~= nil then
        if old ~= false then
          if type(old) == "table"
          then
            newEffect = old[1] or skillToEditID;
          else
            newEffect = skillToEditID;
          end;
        end;
      else
        if GetAbilityDuration(skillToEditID) > 0 then
          newEffect = skillToEditID;
        end;
      end;
    elseif skillEditType == 2 then
      newEffect = effectToTrackID;
    end;
  end;

  local message = "";

  if newEffect > 0
  then
    message = zo_strformat("Updating |cffa31a<<1>>|r (|cffffff<<2>>|r) effect to: |cffa31a<<3>>|r (|cffffff<<4>>|r)", skillToEditName, skillToEditID, GetAbilityName(newEffect), newEffect);
  else
    message = zo_strformat("Tracking of |cffa31a<<1>>|r is now disabled.", skillToEditName);
  end;
  return message;
end;

local function ValidateSkillChange()
  local valid = true;

  if (skillToEditID == 0 or skillEditType == -1 or (skillEditType > 1 and effectToTrackID == 0)) then valid = false; end;

  if valid then
    Chat(FormatSkillUpdateMessage());

    UpdateEffectForAbility(skillEditType, skillToEditID, effectToTrackID);
  else
    Chat("Failed to update effect");
  end;
end;

local function GetHideOnNoTargetForId(id)
  local hide = false;

  local list = FancyActionBar.GetHideOnNoTargetList();

  if list[id] then
    return list[id];
    -- if IsValidId(skillToEditID) then
    -- hide = true
    -- end
  end;

  -- return hide
end;

local function SetHideOnNoTargetForId(hide)
  if CV.useAccountWide then
    SV.hideOnNoTargetList[skillToEditID] = hide;
    -- if not hide then
    --   if SV.hideOnNoTargetList[skillToEditID] then
    --     SV.hideOnNoTargetList[skillToEditID] = nil
    --   end
    -- else
    --   SV.hideOnNoTargetList[skillToEditID] = true
    -- end
  else
    CV.hideOnNoTargetList[skillToEditID] = hide;
    -- if not hide then
    --   if CV.hideOnNoTargetList[skillToEditID] then
    --     CV.hideOnNoTargetList[skillToEditID] = nil
    --   end
    -- else
    --   CV.hideOnNoTargetList[skillToEditID] = true
    -- end
  end;

  FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = hide;

  if FancyActionBar.debuffs[skillToEditID] then
    FancyActionBar.debuffs[skillToEditID].hideOnNoTarget = hide;
  end;

  -- if hide
  -- then FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = nil
  -- else FancyActionBar.constants.hideOnNoTargetList[skillToEditID] = true end

  FancyActionBar.UpdateHideOnNoTargetForSkill(skillToEditID, hide);
end;

local function DisableChangeHideOnNoTargetForId(id)
  if FancyActionBar.abilityConfig[id] then
    return false;
  else
    return true;
  end;
  -- if IsValidId(skillToEditID) then return false else return true end
end;

function FancyActionBar.SetHideOnNoTargetGlobalSetting(option)
  if CV.useAccountWide
  then
    SV.hideOnNoTargetGlobal = option;
  else
    CV.hideOnNoTargetGlobal = option;
  end;

  FancyActionBar.constants.hideOnNoTargetGlobal = option;

  for id, effect in pairs(FancyActionBar.debuffs) do
    if FancyActionBar.constants.hideOnNoTargetList[id] == nil then
      effect.hideOnNoTarget = option;
    end;
  end;
end;

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
  local list = "";

  for i = 3, 8 do
    local id = FancyActionBar.GetSlotTrueBoundId(i, 0);
    local line = "empty";
    local name = "";

    if id > 0 then
      if FancyActionBar.destroSkills[id] then
        name = GetAbilityName(FancyActionBar.GetIdForDestroSkill(id, 0));
        line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetIdForDestroSkill(id, 0) .. ")";
      else
        name = GetAbilityName(id);
        line = "|cffa31a" .. name .. "|r (" .. id .. ")";
      end;
    end;

    list = list .. "\n" .. line;
  end;
  return list;
end;

local function GetCurrentBackBarInfo()
  local list = "";

  for i = 3, 8 do
    local id = FancyActionBar.GetSlotTrueBoundId(i, 1);
    local line = "empty";
    local name = "";

    if id > 0 then
      if FancyActionBar.destroSkills[id] then
        name = GetAbilityName(FancyActionBar.GetIdForDestroSkill(id, 1));
        line = "|cffa31a" .. name .. "|r (" .. FancyActionBar.GetIdForDestroSkill(id, 1) .. ")";
      else
        name = GetAbilityName(id);
        line = "|cffa31a" .. name .. "|r (" .. id .. ")";
      end;
    end;

    list = list .. "\n" .. line;
  end;
  return list;
end;

function FancyActionBar.UpdateSlottedSkillsDecriptions()
  if settingsPageCreated then
    Front_Bar_List.desc:SetText(GetCurrentFrontBarInfo());
    Back_Bar_List.desc:SetText(GetCurrentBackBarInfo());
  end;
end;

----------------------------------------------
-----------[   Label Functions   ]------------
----------------------------------------------
local function UpdateHiglightSettings()
  if ((not SV.showHighlight) and (not SV.toggledHighlight))
  then
    hideStatus = false;
  else
    hideStatus = true;
  end;
end;

local function GetUltValueOptions()
  local options = {};
  for mode in pairs(ultModeOptions) do table.insert(options, mode); end;
  return options;
end;

local function GetUltValueMode(ui)
  local vMode;
  local mode = ui == 1 and SV.ultValueModeKB or SV.ultValueModeGP;
  for option, ultMode in pairs(ultModeOptions) do
    if ultMode == mode then
      vMode = option;
      break;
    end;
  end;
  if vMode ~= nil then return vMode; end;
end;

local function DisplayUltimateSlotTimer(durationControl, duration, timerColor)
  local t = ultDisplayTime - GetFrameTimeSeconds();

  for i in pairs(FancyActionBar.ultOverlays) do
    local d = FancyActionBar.ultOverlays[i]:GetNamedChild("Duration");

    if t <= 0 then
      d:SetText("");
      EM:UnregisterForUpdate(FancyActionBar.GetName() .. "UltTimer");
    else
      if (SV.showDecimal and SV.showDecimalStart and SV.showExpireStart) and (SV.showDecimal ~= "Never" and (duration <= SV.showDecimalStart)) then
        durationControl:SetText(string.format("%0.1f", zo_max(0, duration)));
      else
        durationControl:SetText(zo_max(0, zo_ceil(duration)));
      end;
      if (duration <= SV.showExpireStart) then
        if (SV.showExpire) then durationControl:SetColor(unpack(SV.expireColor)); end;
      else
        durationControl:SetColor(unpack(timerColor));
      end;
      d:SetText(string.format("%0.0f", t));
    end;
  end;
end;

local function DisplayUltimateLabelChanges()
  EM:UnregisterForUpdate(FancyActionBar.GetName() .. "UltTimer");
  ultDisplayTime = GetFrameTimeSeconds() + 5;
  DisplayUltimateSlotTimer();
  EM:RegisterForUpdate(FancyActionBar.GetName() .. "UltTimer", 100, DisplayUltimateSlotTimer);
end;

local function DisplayQuickSlotTimer()
  local d = FancyActionBar.qsOverlay:GetNamedChild("Duration");
  local t = qsDisplayTime - GetFrameTimeSeconds();

  if t <= 0 then
    d:SetText("");
    EM:UnregisterForUpdate(FancyActionBar.GetName() .. "QSTimer");
  else
    d:SetText(string.format("%0.0f", t));
  end;
end;

local function DisplayQuickSlotLabelChanges()
  EM:UnregisterForUpdate(FancyActionBar.GetName() .. "QSTimer");
  qsDisplayTime = GetFrameTimeSeconds() + 5;
  DisplayQuickSlotTimer();
  EM:RegisterForUpdate(FancyActionBar.GetName() .. "QSTimer", 100, DisplayQuickSlotTimer);
end;
----------------------------------------------
---------[   Actionbar Position   ]-----------
----------------------------------------------
local function SaveCurrentLocation()
  local x = FAB_Mover:GetLeft();
  local y = FAB_Mover:GetBottom();
  -- if IsInGamepadPreferredMode() then
  if FancyActionBar.style == 2 then
    SV.abMove.gp.prevX = x;
    SV.abMove.gp.prevY = y;
  else
    SV.abMove.kb.prevX = x;
    SV.abMove.kb.prevY = y;
  end;
end;

local function GetMovable(mode)
  local isKB = mode == 1 and true or false;
  if isKB
  then
    return SV.abMove.kb.enable;
  else
    return SV.abMove.gp.enable;
  end;
end;

local function AllowMovable(mode, allow)
  local isKB = mode == 1 and true or false;
  if isKB
  then
    SV.abMove.kb.enable = allow;
  else
    SV.abMove.gp.enable = allow;
  end;

  if mode == FancyActionBar.style then FancyActionBar.constants.move.enable = allow; end;
  FancyActionBar.MoveActionBar();
  -- FancyActionBar.UpdateBarSettings()
end;

local function ReanchorMover()
  -- FAB_Mover:SetHidden(true)
  -- FAB_Mover:SetMovable(false)
  -- FAB_Mover:SetMouseEnabled(false)
  FAB_Mover:ClearAnchors();
  FAB_Mover:SetAnchor(BOTTOM, ACTION_BAR, BOTTOM, 0, 0, FAB_Mover:GetResizeToFitConstrains());
end;

local function RefreshMoverSize()
  local w, h = ACTION_BAR:GetDimensions();
  FAB_Mover:SetDimensions(w, h);
end;
----------------------------------------------
----------------[   Other   ]-----------------
----------------------------------------------
local framesHidden = false;
local function SetDefaultAbilityFrame()
  local f = { "/esoui/art/actionbar/abilityframe64_up.dds"; "/esoui/art/actionbar/abilityframe64_down.dds"; FAB_BLANK; FAB_NO_FRAME_DOWN };
  if SV.hideDefaultFrames then
    RedirectTexture(f[1], f[3]);
    RedirectTexture(f[2], f[4]);
    framesHidden = true;
  else
    if framesHidden then
      RedirectTexture(f[1], f[1]);
      RedirectTexture(f[2], f[2]);
      framesHidden = false;
    end;
  end;
end;

local function GetUltimateFlipCardSize()
  local c = FancyActionBar.GetContants();
  return c.ultFlipCardSize;
end;

-- /script local a=ACTION_BAR for i=1,a:GetNumChildren() do local c=a:GetChild(i) local s='' if c.slot ~= nil then s=c.slot.slotNum end  Chat('['..i..']: '..c:GetName()..' / '..s) end
local function CheckDeathState()
  if (IsUnitDead("player") and SV.showDeath) then
    ACTION_BAR:SetHidden(false);
  end;
end;

if FAB_GCD == nil then
  FAB_GCD = GetControl("FAB_GCD");
end;
-------------------------------------------------------------------------------
------------------------------[    Addon Menu    ]-----------------------------
-------------------------------------------------------------------------------
function FancyActionBar.BuildMenu(sv, cv, defaults)
  SV = sv;
  CV = cv;
  local name = FancyActionBar.GetName() .. "Menu";
  local panel = {
    type = "panel";
    name = "Fancy Action Bar+";
    displayName = "Fancy Action Bar+";
    author = "|cFFFF00@andy.s|r - modified by @dack_janiels";
    version = string.format("|c00FF00%s|r", FancyActionBar.GetVersion());
    donation = "https://www.esoui.com/downloads/info2311-HodorReflexes-DPSampUltimateShare.html#donate";
    registerForRefresh = true;
  };
  local FAB_Panel = LAM:RegisterAddonPanel(name, panel);

  UpdateHiglightSettings();

  local function ToggleActionBarInMenu(isHidden)
    local l;
    if isHidden then
      ACTION_BAR:SetHidden(false);
      l = "Hide Actionbar";
    else
      ACTION_BAR:SetHidden(true);
      l = "Show Actionbar";
    end;
    WINDOW_MANAGER:GetControlByName("FAB_AB_Toggle").button:SetText(l);
  end;

  local options = {
    {
      type = "button";
      name = "Hide Actionbar";
      tooltip = "Only applies while in this settings menu.";
      func = function () ToggleActionBarInMenu(ACTION_BAR:IsHidden()); end;
      width = "full";
      reference = "FAB_AB_Toggle";
    };

    --===========[	Actionbar Scaling	]===================
    {
      type = "submenu";
      name = "|cFFFACDActionbar Size & Position|r";
      controls = {

        {
          type = "description";
          title = "This section is still undergoing test for compatibility with other addons, so think carefully before enabling";
          width = "full";
        };

        {
          type = "description";
          title = "[ |cffdf80Keyboard UI|r ]";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Enable Actionbar Resize";
          default = defaults.abScaling.kb.enable;
          getFunc = function () return SV.abScaling.kb.enable; end;
          setFunc = function (value)
            SV.abScaling.kb.enable = value or false;
            if FancyActionBar.style == 1 then
              FancyActionBar.constants.abScale.enable = value;
              FancyActionBar.UpdateBarSettings();
            end;
          end;
          width = "half";
        };
        {
          type = "slider";
          name = "Actionbar Size";
          default = defaults.abScale;
          min = 30;
          max = 250;
          disabled = function () return not SV.abScaling.kb.enable; end;
          getFunc = function () return SV.abScaling.kb.scale; end;
          setFunc = function (value)
            SV.abScaling.kb.scale = value;
            if FancyActionBar.style == 1 then
              FancyActionBar.constants.abScale.enable = value;
              FancyActionBar.UpdateBarSettings();
            end;
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Enable Actionbar Reposition";
          default = false;
          getFunc = function () return GetMovable(1); end;
          setFunc = function (value) AllowMovable(1, value); end;
          width = "full";
        };

        { type = "divider" };

        {
          type = "description";
          title = "[ |cffdf80Gamepad UI|r ]";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Enable Actionbar Resize";
          default = defaults.abScaling.gp.enable;
          getFunc = function () return SV.abScaling.gp.enable; end;
          setFunc = function (value)
            SV.abScaling.gp.enable = value or false;
            if FancyActionBar.style == 2 then
              FancyActionBar.constants.abScale.enable = value;
              FancyActionBar.UpdateBarSettings();
            end;
          end;
          width = "half";
        };
        {
          type = "slider";
          name = "Actionbar Size";
          default = defaults.abScaling.gp.scale;
          min = 30;
          max = 250;
          disabled = function () return not SV.abScaling.gp.enable; end;
          getFunc = function () return SV.abScaling.gp.scale; end;
          setFunc = function (value)
            SV.abScaling.gp.scale = value;
            if FancyActionBar.style == 2 then
              FancyActionBar.constants.abScale.scale = value;
              FancyActionBar.UpdateBarSettings();
            end;
          end;
          width = "half";
        };

        { type = "divider" };

        {
          type = "checkbox";
          name = "Enable Actionbar Reposition";
          default = false;
          getFunc = function () return GetMovable(2); end;
          setFunc = function (value) AllowMovable(2, value); end;
          width = "full";
        };

        { type = "divider" };

        {
          type = "button";
          name = function () return "Unlock Actionbar"; end;
          func = function () FancyActionBar.ToggleMover(); end;
          disabled = function ()
            local mode = FancyActionBar.style; -- IsInGamepadPreferredMode() and 2 or 1
            return not GetMovable(mode);
          end;
          width = "half";
          reference = "FAB_AB_Move";
        };
        -- {	type = 'button',        name = 'Undo Last Move',
        --   func = function() FancyActionBar.UndoMove() end,
        --   disabled = function() return not wasMoved end,
        --   width = 'half'
        -- }
      };
    };

    --===========[    General    ]===================
    {
      type = "submenu";
      name = "|cFFFACDGeneral|r";
      controls = {

        --============[	Font/Back Bar Settings	]===============
        {
          type = "description";
          title = "[ |cffdf80Front & Back Bars Position|r ]";
          text = "All changes will take effect after doing a weapon swap.";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Static bar positions";
          tooltip = "Front bar and back bar will not switch places on weapon swap.";
          default = defaults.staticBars;
          getFunc = function () return SV.staticBars; end;
          setFunc = function (value)
            SV.staticBars = value or false;
            FancyActionBar.UpdateBarSettings();
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Front bar on top (only for static bars)";
          tooltip = "ON = Front bar on top and back bar on bottom.\nOFF = Front bar on bottom and back bar on top.";
          default = defaults.frontBarTop;
          disabled = function () return not SV.staticBars; end;
          getFunc = function () return SV.frontBarTop; end;
          setFunc = function (value)
            SV.frontBarTop = value or false;
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Active bar on top (not for static bars)";
          tooltip = "ON = Active bar on top.\nOFF = Active bar on bottom.";
          default = defaults.activeBarTop;
          disabled = function () return SV.staticBars; end;
          getFunc = function () return SV.activeBarTop; end;
          setFunc = function (value)
            SV.activeBarTop = value or false;
          end;
          width = "half";
        };

        -- { type = 'checkbox', 			name = 'Hide inactive back bar buttons (not for static bars)',
        -- 	tooltip = 'ON = Inactive back bar buttons WILL be hidden.\nOFF = Inactive back bar buttons WONT be hidden.',
        -- 	disabled = function() return SV.staticBars end,
        -- 	default = defaults.hideInactive,
        -- 	getFunc = function() return SV.hideInactive end,
        -- 	setFunc = function(value)
        -- 		SV.hideInactive = value or false
        -- 	end,
        -- 	width = 'full'
        -- },

        --============[	Backbar Visuals	]=====================
        {
          type = "description";
          title = "[ |cffdf80Back Bar Visibility|r ]";
          text = "";
          width = "full";
        };
        {
          type = "slider";
          name = "Inactive bar alpha";
          tooltip = "Higher value = more solid.\nLower value = more see through.";
          default = defaults.alphaInactive;
          min = 10;
          max = 90;
          getFunc = function () return SV.alphaInactive; end;
          setFunc = function (value) FancyActionBar.ApplyAlphaInactive(value); end;
          width = "half";
        };
        {
          type = "slider";
          name = "Inactive bar desaturation";
          tooltip = "Higher value = more grey.\nLower value = more colors.";
          default = defaults.desaturationInactive;
          min = 10;
          max = 90;
          getFunc = function () return SV.desaturationInactive; end;
          setFunc = function (value)
            FancyActionBar.ApplyDesaturationInactiveInactive(value);
          end;
          width = "half";
        };
        { type = "description"; text = ""; width = "full" };

        --============[	Keybinds On / Off	]===================
        {
          type = "description";
          title = "[ |cffdf80Hotkey Text|r ]";
          text = "";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Show hotkeys";
          tooltip = "Show hotkeys under the action bar.";
          default = defaults.showHotkeys;
          getFunc = function () return SV.showHotkeys; end;
          setFunc = function (value)
            SV.showHotkeys = value or false;
            FancyActionBar.HideHotkeys(not SV.showHotkeys);
          end;
          width = "half";
        };
        { type = "description"; text = ""; width = "half" };
      };
    };

    --============[	UI Customization	]===================
    {
      type = "submenu";
      name = "|cFFFACDUI Customization|r";
      controls = {

        --============[	Buttom Frames	]=======================
        {
          type = "description";
          title = "[ |cffdf80Button Frames|r ]";
          text = "Only for keyboard UI.";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Show frames";
          tooltip = "Show a frame around buttons on the actionbar.";
          default = defaults.showFrames;
          disabled = function () return FancyActionBar.style == 2; end; --IsInGamepadPreferredMode() end,
          getFunc = function () return SV.showFrames; end;
          setFunc = function (value)
            SV.showFrames = value or false;
            FancyActionBar.ConfigureFrames();
          end;
          width = "half";
        };
        {
          type = "colorpicker";
          name = "Frame color";
          default = ZO_ColorDef:New(unpack(defaults.frameColor));
          disabled = function () return (FancyActionBar.style == 2 --[[IsInGamepadPreferredMode()]] or (not SV.showFrames)); end;
          getFunc = function () return unpack(SV.frameColor); end;
          setFunc = function (r, g, b, a)
            SV.frameColor = { r; g; b; a };
            FancyActionBar.SetFrameColor();
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Hide default frames";
          tooltip = "Hide the default actionbutton frames.\nIf the setting was enabled then you need to reload UI when disabling in order for inactive bar to display them correctly.";
          default = defaults.hideDefaultFrames;
          disabled = function () return FancyActionBar.style == 2; end; --IsInGamepadPreferredMode() end,
          getFunc = function () return SV.hideDefaultFrames; end;
          setFunc = function (value)
            SV.hideDefaultFrames = value or false;
            SetDefaultAbilityFrame();
          end;
          width = "half";
        };
        { type = "divider" };

        --============[	Active Highlight	]===================
        {
          type = "description";
          title = "[ |cffdf80Active Ability Highlight|r ]";
          text = "";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Show highlight";
          tooltip = "Active skills will be highlighted.";
          default = defaults.showHighlight;
          getFunc = function () return SV.showHighlight; end;
          setFunc = function (value)
            SV.showHighlight = value or false;
            UpdateHiglightSettings();
          end;
          width = "half";
        };
        {
          type = "colorpicker";
          name = "Highlight color";
          default = ZO_ColorDef:New(unpack(defaults.highlightColor));
          disabled = function () return not SV.showHighlight; end;
          getFunc = function () return unpack(SV.highlightColor); end;
          setFunc = function (r, g, b, a)
            SV.highlightColor = { r; g; b; a };
          end;
          width = "half";
        };
        { type = "divider" };

        --============[   Toggled Highlight  ]===================
        {
          type = "description";
          title = "[ |cffdf80Toggled Ability Highlight|r ]";
          text = "If a toggled ability is activated you can choose to have the highlight display a different color by setting the following option to <On>. Toggled abilities will also be highlighted regardless of the <Show highlight> option if <Toggled highlight> is enabled. If disabled, the highlight will use your settings from above.";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Toggled highlight";
          default = defaults.toggledHighlight;
          getFunc = function () return SV.toggledHighlight; end;
          setFunc = function (value)
            SV.toggledHighlight = value or false;
            UpdateHiglightSettings();
          end;
          width = "half";
        };
        {
          type = "colorpicker";
          name = "Toggled highlight color";
          default = ZO_ColorDef:New(unpack(defaults.toggledColor));
          disabled = function () return not SV.toggledHighlight; end;
          getFunc = function () return unpack(SV.toggledColor); end;
          setFunc = function (r, g, b, a)
            SV.toggledColor = { r; g; b; a };
          end;
          width = "half";
        };
        { type = "divider" };

        --============[  Active Bar Arrow  ]=====================
        {
          type = "description";
          title = "[ |cffdf80Active Bar Arrow|r ]";
          text = "Weapon swap once after clicking the Show arrow button to make the change take effect.";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Show arrow";
          tooltip = "Show an arrow near the currently active bar.";
          default = defaults.showArrow;
          getFunc = function () return SV.showArrow; end;
          setFunc = function (value)
            SV.showArrow = value or false;
            FAB_ActionBarArrow:SetHidden(not SV.showArrow);
            FancyActionBar.AdjustQuickSlotSpacing();
            FancyActionBar.AdjustUltimateSpacing();
          end;
          width = "half";
        };
        {
          type = "colorpicker";
          name = "Arrow color";
          default = ZO_ColorDef:New(unpack(defaults.arrowColor));
          disabled = function () return not SV.showArrow; end;
          getFunc = function () return unpack(SV.arrowColor); end;
          setFunc = function (r, g, b, a)
            SV.arrowColor = { r; g; b; a };
            FAB_ActionBarArrow:SetColor(unpack(SV.arrowColor));
          end;
          width = "half";
        };
        { type = "divider" };

        --=============[  Quickslot Position  ]==================
        {
          type = "checkbox";
          name = "Adjust Quick Slot placement";
          tooltip = "Move Quick Slot closer to the Action Bar if the arrow is hidden.\nFor gamepad UI this will also adjust the gap between normal skill buttons and the ultimate button, as well as the gap between the ultimate button and the companion ultimate button (|cff6600Only|r if gamepad ult hotkeys are hidden).";
          default = defaults.moveQS;
          getFunc = function () return SV.moveQS; end;
          setFunc = function (value)
            SV.moveQS = value or false;
            FancyActionBar.AdjustQuickSlotSpacing();
            FancyActionBar.AdjustUltimateSpacing();
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Show gamepad ult hotkeys";
          tooltip = "Show the LB RB labels for gamepad UI.";
          default = defaults.showHotkeysUltGP;
          getFunc = function () return SV.showHotkeysUltGP; end;
          setFunc = function (value)
            SV.showHotkeysUltGP = value or false;
            FancyActionBar.HideHotkeys(not SV.showHotkeys);
            FancyActionBar.AdjustUltimateSpacing();
          end;
          disabled = function () return not FancyActionBar.style == 2; end; --IsInGamepadPreferredMode() end,
          width = "half";
        };
      };
    };

    --=============[  Timer Display  ]=======================
    {
      type = "submenu";
      name = "|cFFFACDTimer Display|r";
      controls = {

        {
          type = "submenu";
          name = "|cFFFACDInfo|r";
          controls = {
            {
              type = "description";
              text = FancyActionBar.strings.subTimerDesc;
              width = "full";
            };
          };
        };

        --============[ Keyboard UI ]=========================
        {
          type = "submenu";
          name = "|cFFFACDKeyboard UI|r";
          controls = {

            --============[ Keyboard Duration ]====================
            {
              type = "submenu";
              name = "|cFFFACDTimer Display Settings|r";
              controls = {
                {
                  type = "dropdown";
                  name = "Timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.fontNameKB; end;
                  setFunc = function (value)
                    SV.fontNameKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.duration.font = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontNameKB;
                };
                {
                  type = "slider";
                  name = "Timer font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.fontSizeKB; end;
                  setFunc = function (value)
                    SV.fontSizeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.duration.size = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontSizeKB;
                };
                {
                  type = "dropdown";
                  name = "Timer font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.fontTypeKB; end;
                  setFunc = function (value)
                    SV.fontTypeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.duration.outline = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontTypeKB;
                };
                {
                  type = "colorpicker";
                  name = "Timer color";
                  default = ZO_ColorDef:New(unpack(defaults.timeColorKB));
                  getFunc = function () return unpack(SV.timeColorKB); end;
                  setFunc = function (r, g, b)
                    SV.timeColorKB = { r; g; b };
                    if FancyActionBar.style == 1 then FancyActionBar.constants.duration.color = SV.timeColorKB; end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Adjust timer hight";
                  tooltip = "Move timer [<- down] or [up ->]";
                  default = defaults.timeYKB;
                  min = -15;
                  max = 15;
                  step = 1;
                  getFunc = function () return SV.timeYKB; end;
                  setFunc = function (value)
                    SV.timeYKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.duration.y = value;
                      FancyActionBar.AdjustTimerY();
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --============[ Keyboard Stacks ]======================
            {
              type = "submenu";
              name = "|cFFFACDStacks Display Settings|r";
              controls = {
                {
                  type = "dropdown";
                  name = "Stacks font";
                  scrollable = true;
                  tooltip = "Select which font to display ability stacks for the keyboard UI in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.fontNameStackKB; end;
                  setFunc = function (value)
                    SV.fontNameStackKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.stacks.font = value;
                      FancyActionBar.ApplyStackFont();
                    end;
                  end;
                  default = defaults.fontNameStackKB;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Stacks font size";
                  min = 10;
                  max = 25;
                  step = 1;
                  getFunc = function () return SV.fontSizeStackKB; end;
                  setFunc = function (value)
                    SV.fontSizeStackKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.stacks.size = value;
                      FancyActionBar.ApplyStackFont();
                    end;
                  end;
                  default = defaults.fontSizeStackKB;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Stack font style";
                  tooltip = "Select which effect to display the stacks font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.fontTypeStackKB; end;
                  setFunc = function (value)
                    SV.fontTypeStackKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.stacks.outline = value;
                      FancyActionBar.ApplyStackFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontTypeStackKB;
                };
                {
                  type = "colorpicker";
                  name = "Stack color";
                  default = ZO_ColorDef:New(unpack(defaults.stackColorKB));
                  getFunc = function () return unpack(SV.stackColorKB); end;
                  setFunc = function (r, g, b)
                    SV.stackColorKB = { r; g; b };
                    if FancyActionBar.style == 1 then FancyActionBar.constants.stacks.color = SV.stackColorKB; end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Adjust stacks position";
                  tooltip = "Move stacks [<- left] or [right ->]";
                  default = defaults.stackXKB;
                  min = 0;
                  max = 40;
                  step = 1;
                  getFunc = function () return SV.stackXKB; end;
                  setFunc = function (value)
                    SV.stackXKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.stacks.x = value;
                      FancyActionBar.AdjustStackX();
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --==========[ Keyboard Ultimate Duration ]=============
            {
              type = "submenu";
              name = "|cFFFACDUltimate Timer Settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Display ultimate Timer";
                  default = defaults.ultShowKB;
                  getFunc = function () return SV.ultShowKB; end;
                  setFunc = function (value)
                    SV.ultShowKB = value or false;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.show = value;
                      -- FancyActionBar.ToggleUltimateValue()
                    end;
                  end;
                  width = "half";
                };
                { type = "description"; text = ""; width = "full" };
                {
                  type = "dropdown";
                  name = "Ultimate timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.ultNameKB; end;
                  setFunc = function (value)
                    SV.ultNameKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.font = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultNameKB;
                };
                {
                  type = "slider";
                  name = "Ultimate timer font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.ultSizeKB; end;
                  setFunc = function (value)
                    SV.ultSizeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.size = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultSizeKB;
                };
                {
                  type = "dropdown";
                  name = "Ultimate timer font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.ultTypeKB; end;
                  setFunc = function (value)
                    SV.ultTypeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.outline = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultTypeKB;
                };
                {
                  type = "colorpicker";
                  name = "Ultimate timer color";
                  default = ZO_ColorDef:New(unpack(defaults.ultColorKB));
                  getFunc = function () return unpack(SV.ultColorKB); end;
                  setFunc = function (r, g, b)
                    SV.ultColorKB = { r; g; b };
                    if FancyActionBar.style == 1 then FancyActionBar.constants.ult.duration.color = SV.ultColorKB; end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultYKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultYKB; end;
                  setFunc = function (value)
                    SV.ultYKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.y = value;
                      FancyActionBar.AdjustUltTimer(true);
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultXKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultXKB; end;
                  setFunc = function (value)
                    SV.ultXKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.duration.x = value;
                      FancyActionBar.AdjustUltTimer(true);
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --===========[ Keyboard Ultimate Value ]===============
            {
              type = "submenu";
              name = "|cFFFACDUltimate Value Settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Display ultimate number";
                  default = defaults.ultValueEnableKB;
                  getFunc = function () return SV.ultValueEnableKB; end;
                  setFunc = function (value)
                    SV.ultValueEnableKB = value or false;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.show = value;
                      FancyActionBar.ToggleUltimateValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Display Mode";
                  tooltip = "Dynamic: display current / cost if current is lower than cost and only current when you have enough to cast it.\nStatic: always display current / cost.";
                  choices = GetUltValueOptions();
                  getFunc = function () return GetUltValueMode(1); end;
                  setFunc = function (mode)
                    SV.ultValueModeKB = ultModeOptions[mode];
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.mode = SV.ultValueModeKB;
                      FancyActionBar.UpdateUltValueMode();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Ultimate value font";
                  scrollable = true;
                  tooltip = "Select which font to display the value in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.ultValueNameKB; end;
                  setFunc = function (value)
                    SV.ultValueNameKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.font = value;
                      FancyActionBar.ApplyUltValueFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.ultValueNameKB;
                };
                {
                  type = "slider";
                  name = "Ultimate value font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.ultValueSizeKB; end;
                  setFunc = function (value)
                    SV.ultValueSizeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.size = value;
                      FancyActionBar.ApplyUltValueFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.ultValueSizeKB;
                };
                {
                  type = "dropdown";
                  name = "Ultimate value font style";
                  tooltip = "Select which effect to display the value font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.ultValueTypeKB; end;
                  setFunc = function (value)
                    SV.ultValueTypeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.outline = value;
                      FancyActionBar.ApplyUltValueFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.ultValueTypeKB;
                };
                {
                  type = "colorpicker";
                  name = "Ultimate value color";
                  default = ZO_ColorDef:New(unpack(defaults.ultValueColorKB));
                  getFunc = function () return unpack(SV.ultValueColorKB); end;
                  setFunc = function (r, g, b)
                    SV.ultValueColorKB = { r; g; b };
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.color = SV.ultValueColorKB;
                      FancyActionBar.ApplyUltValueColor();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultValueYKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueYKB; end;
                  setFunc = function (value)
                    SV.ultValueYKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.y = value;
                      FancyActionBar.AdjustUltValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultValueXKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueXKB; end;
                  setFunc = function (value)
                    SV.ultValueXKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.value.x = value;
                      FancyActionBar.AdjustUltValue();
                    end;
                  end;
                  width = "half";
                };
                { type = "divider";
                };
                {
                  type = "description";
                  title = "Companion Ultimate";
                  text = "Companion ultimate value will inherit font and size of the player ultimate value.\nAdjust position below.";
                  width = "full";
                };
                {
                  type = "checkbox";
                  name = "Display ultimate number for companion";
                  default = defaults.ultValueEnableCompanionKB;
                  getFunc = function () return SV.ultValueEnableCompanionKB; end;
                  setFunc = function (value)
                    SV.ultValueEnableCompanionKB = value or false;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.companion.show = value;
                      FancyActionBar.ToggleUltimateValue();
                    end;
                  end;
                  width = "full";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultValueCompanionYKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueCompanionYKB; end;
                  setFunc = function (value)
                    SV.ultValueCompanionYKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.companion.y = value;
                      FancyActionBar.AdjustCompanionUltValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultValueCompanionXKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueCompanionXKB; end;
                  setFunc = function (value)
                    SV.ultValueCompanionXKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.ult.companion.x = value;
                      FancyActionBar.AdjustCompanionUltValue();
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --============[ Keyboard Quick Slot ]==================
            {
              type = "submenu";
              name = "|cFFFACDQuick Slot Display Settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Quick Slot cooldown duration";
                  default = defaults.qsTimerEnableKB;
                  getFunc = function () return SV.qsTimerEnableKB; end;
                  setFunc = function (value)
                    SV.qsTimerEnableKB = value or false;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.show = value;
                      FancyActionBar.ToggleQuickSlotDuration();
                    end;
                  end;
                  width = "full";
                };
                { type = "description"; text = ""; width = "full";
                };
                {
                  type = "dropdown";
                  name = "Quick Slot timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.qsNameKB; end;
                  setFunc = function (value)
                    SV.qsNameKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.font = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsNameKB;
                };
                {
                  type = "slider";
                  name = "Quick Slot timer font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.qsSizeKB; end;
                  setFunc = function (value)
                    SV.qsSizeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.size = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsSizeKB;
                };
                {
                  type = "dropdown";
                  name = "Quick Slot timer font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.qsTypeKB; end;
                  setFunc = function (value)
                    SV.qsTypeKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.outline = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsTypeKB;
                };
                {
                  type = "colorpicker";
                  name = "Quick Slot timer color";
                  default = ZO_ColorDef:New(unpack(defaults.qsColorKB));
                  getFunc = function () return unpack(SV.qsColorKB); end;
                  setFunc = function (r, g, b)
                    SV.qsColorKB = { r; g; b };
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.color = { r; g; b };
                      FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetColor(unpack(SV.qsColorKB));
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.qsYKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.qsYKB; end;
                  setFunc = function (value)
                    SV.qsYKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.y = value;
                      FancyActionBar.AdjustQuickSlotTimer();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.qsXKB;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.qsXKB; end;
                  setFunc = function (value)
                    SV.qsXKB = value;
                    if FancyActionBar.style == 1 then
                      FancyActionBar.constants.qs.x = value;
                      FancyActionBar.AdjustQuickSlotTimer();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
              };
            };
          };
        };
        { type = "divider" };

        --============[	Gamepad UI	]=========================
        {
          type = "submenu";
          name = "|cFFFACDGamepad UI|r";
          controls = {

            --============[	Gamepad Duration	]===================
            {
              type = "submenu";
              name = "|cFFFACDTimer Settings|r";
              controls = {
                {
                  type = "dropdown";
                  name = "Timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.fontNameGP; end;
                  setFunc = function (value)
                    SV.fontNameGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.duration.font = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontNameGP;
                };
                {
                  type = "slider";
                  name = "Timer font size";
                  min = 20;
                  max = 40;
                  step = 1;
                  getFunc = function () return SV.fontSizeGP; end;
                  setFunc = function (value)
                    SV.fontSizeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.duration.size = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontSizeGP;
                };
                {
                  type = "dropdown";
                  name = "Font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.fontTypeGP; end;
                  setFunc = function (value)
                    SV.fontTypeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.duration.outline = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontTypeGP;
                };
                {
                  type = "slider";
                  name = "Adjust timer hight";
                  tooltip = "Move timer [<- down] or [up ->]";
                  default = defaults.timeYGP;
                  min = -15;
                  max = 15;
                  step = 1;
                  getFunc = function () return SV.timeYGP; end;
                  setFunc = function (value)
                    SV.timeYGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.duration.y = value;
                      FancyActionBar.AdjustTimerY();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "colorpicker";
                  name = "Timer color";
                  default = ZO_ColorDef:New(unpack(defaults.timeColorGP));
                  getFunc = function () return unpack(SV.timeColorGP); end;
                  setFunc = function (r, g, b)
                    SV.timeColorGP = { r; g; b };
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.duration.color = { r; g; b };
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --============[	Gamepad Stacks	]======================
            {
              type = "submenu";
              name = "|cFFFACDstacks display settings|r";
              controls = {
                {
                  type = "dropdown";
                  name = "Stacks font";
                  scrollable = true;
                  tooltip = "Select which font to display ability stacks in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.fontNameStackGP; end;
                  setFunc = function (value)
                    SV.fontNameStackGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.stacks.font = value;
                      FancyActionBar.ApplyStackFont();
                    end;
                  end;
                  default = defaults.fontNameStackGP;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Stacks font size";
                  min = 10;
                  max = 40;
                  step = 1;
                  getFunc = function () return SV.fontSizeStackGP; end;
                  setFunc = function (value)
                    SV.fontSizeStackGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.stacks.size = value;
                    end;
                    FancyActionBar.ApplyStackFont();
                  end;
                  default = defaults.fontSizeStackGP;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Stack font style";
                  tooltip = "Select which effect to display the stacks font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.fontTypeStackGP; end;
                  setFunc = function (value)
                    SV.fontTypeStackGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.stacks.outline = value;
                      FancyActionBar.ApplyTimerFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.fontTypeStackGP;
                };
                {
                  type = "slider";
                  name = "Adjust stacks position";
                  tooltip = "Move stacks [<- left] or [right ->]";
                  default = defaults.stackXGP;
                  min = 0;
                  max = 40;
                  step = 1;
                  getFunc = function () return SV.stackXGP; end;
                  setFunc = function (value)
                    SV.stackXGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.stacks.x = value;
                      FancyActionBar.AdjustStackX();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "colorpicker";
                  name = "Stack color";
                  default = ZO_ColorDef:New(unpack(defaults.stackColorGP));
                  getFunc = function () return unpack(SV.stackColorGP); end;
                  setFunc = function (r, g, b)
                    SV.stackColorGP = { r; g; b };
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.stacks.color = { r; g; b };
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --============[ Gamepad Ultimate  ]====================
            {
              type = "submenu";
              name = "|cFFFACDultimate display settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Display ultimate Timer";
                  default = defaults.ultShowGP;
                  getFunc = function () return SV.ultShowGP; end;
                  setFunc = function (value)
                    SV.ultShowGP = value or false;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.show = value;
                      -- FancyActionBar.ToggleUltimateValue()
                    end;
                  end;
                  width = "half";
                };
                { type = "description"; text = ""; width = "full" };
                {
                  type = "dropdown";
                  name = "Ultimate timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.ultNameGP; end;
                  setFunc = function (value)
                    SV.ultNameGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.font = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultNameGP;
                };
                {
                  type = "slider";
                  name = "Ultimate timer font size";
                  min = 10;
                  max = 45;
                  step = 1;
                  getFunc = function () return SV.ultSizeGP; end;
                  setFunc = function (value)
                    SV.ultSizeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.size = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultSizeGP;
                };
                {
                  type = "dropdown";
                  name = "Ultimate timer font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.ultTypeGP; end;
                  setFunc = function (value)
                    SV.ultTypeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.outline = value;
                      FancyActionBar.ApplyUltFont(true);
                    end;
                  end;
                  width = "half";
                  default = defaults.ultTypeGP;
                };
                {
                  type = "colorpicker";
                  name = "Ultimate timer color";
                  default = ZO_ColorDef:New(unpack(defaults.ultColorGP));
                  getFunc = function () return unpack(SV.ultColorGP); end;
                  setFunc = function (r, g, b)
                    SV.ultColorGP = { r; g; b };
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultYGP;
                  min = -70;
                  max = 70;
                  step = 1;
                  getFunc = function () return SV.ultYGP; end;
                  setFunc = function (value)
                    SV.ultYGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.y = value;
                      FancyActionBar.AdjustUltTimer(true);
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultXGP;
                  min = -80;
                  max = 80;
                  step = 1;
                  getFunc = function () return SV.ultXGP; end;
                  setFunc = function (value)
                    SV.ultXGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.duration.x = value;
                      FancyActionBar.AdjustUltTimer(true);
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --===========[ Gamepad Ultimate Value ]===============
            {
              type = "submenu";
              name = "|cFFFACDUltimate Value Settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Display ultimate number";
                  default = defaults.ultValueEnableGP;
                  getFunc = function () return SV.ultValueEnableGP; end;
                  setFunc = function (value)
                    SV.ultValueEnableGP = value or false;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.show = value;
                      FancyActionBar.ToggleUltimateValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Display Mode";
                  tooltip = "Dynamic: display current / cost if current is lower than cost and only current when you have enough to cast it.\nStatic: always display current / cost.";
                  choices = GetUltValueOptions();
                  getFunc = function () return GetUltValueMode(2); end;
                  setFunc = function (mode)
                    SV.ultValueModeGP = ultModeOptions[mode];
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.mode = SV.ultValueModeGP;
                      FancyActionBar.UpdateUltValueMode();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "dropdown";
                  name = "Ultimate value font";
                  scrollable = true;
                  tooltip = "Select which font to display the value in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.ultValueNameGP; end;
                  setFunc = function (value)
                    SV.ultValueNameGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.font = value;
                    end;
                    FancyActionBar.ApplyUltValueFont();
                  end;
                  width = "half";
                  default = defaults.ultValueNameGP;
                };
                {
                  type = "slider";
                  name = "Ultimate value font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.ultValueSizeGP; end;
                  setFunc = function (value)
                    SV.ultValueSizeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.size = value;
                      FancyActionBar.ApplyUltValueFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.ultValueSizeGP;
                };
                {
                  type = "dropdown";
                  name = "Ultimate value font style";
                  tooltip = "Select which effect to display the value font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.ultValueTypeGP; end;
                  setFunc = function (value)
                    SV.ultValueTypeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.outline = value;
                      FancyActionBar.ApplyUltValueFont();
                    end;
                  end;
                  width = "half";
                  default = defaults.ultValueTypeGP;
                };
                {
                  type = "colorpicker";
                  name = "Ultimate value color";
                  default = ZO_ColorDef:New(unpack(defaults.ultValueColorGP));
                  getFunc = function () return unpack(SV.ultValueColorGP); end;
                  setFunc = function (r, g, b)
                    SV.ultValueColorGP = { r; g; b };
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.color = { r; g; b };
                      FancyActionBar.ApplyUltValueColor();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultValueYGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueYGP; end;
                  setFunc = function (value)
                    SV.ultValueYGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.y = value;
                      FancyActionBar.AdjustUltValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultValueXGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueXGP; end;
                  setFunc = function (value)
                    SV.ultValueXGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.value.x = value;
                      FancyActionBar.AdjustUltValue();
                    end;
                  end;
                  width = "half";
                };
                { type = "divider";
                };
                {
                  type = "description";
                  title = "Companion Ultimate";
                  text = "Companion ultimate value will inherit font and size of the player ultimate value.\nAdjust position below.";
                  width = "full";
                };
                {
                  type = "checkbox";
                  name = "Display ultimate number for companion";
                  default = defaults.ultValueEnableCompanionGP;
                  getFunc = function () return SV.ultValueEnableCompanionGP; end;
                  setFunc = function (value)
                    SV.ultValueEnableCompanionGP = value or false;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.companion.show = value;
                      FancyActionBar.ToggleUltimateValue();
                    end;
                  end;
                  width = "full";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.ultValueCompanionYGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueCompanionYGP; end;
                  setFunc = function (value)
                    SV.ultValueCompanionYGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.companion.y = value;
                      FancyActionBar.AdjustCompanionUltValue();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.ultValueCompanionXGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.ultValueCompanionXGP; end;
                  setFunc = function (value)
                    SV.ultValueCompanionXGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.ult.companion.x = value;
                      FancyActionBar.AdjustCompanionUltValue();
                    end;
                  end;
                  width = "half";
                };
              };
            };

            --============[	Gamepad Quick Slot	]==================
            {
              type = "submenu";
              name = "|cFFFACDQuick slot display settings|r";
              controls = {
                {
                  type = "checkbox";
                  name = "Quick Slot cooldown duration";
                  default = defaults.qsTimerEnableGP;
                  getFunc = function () return SV.qsTimerEnableGP; end;
                  setFunc = function (value)
                    SV.qsTimerEnableGP = value or false;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.show = value;
                      FancyActionBar.ToggleQuickSlotDuration();
                    end;
                  end;
                  width = "full";
                };
                { type = "description"; text = ""; width = "full";
                };
                {
                  type = "dropdown";
                  name = "Quick Slot timer font";
                  scrollable = true;
                  tooltip = "Select which font to display the timer in.";
                  choices = FancyActionBar.GetFonts();
                  sort = "name-up";
                  getFunc = function () return SV.qsNameGP; end;
                  setFunc = function (value)
                    SV.qsNameGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.font = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsNameGP;
                };
                {
                  type = "slider";
                  name = "Quick Slot timer font size";
                  min = 10;
                  max = 30;
                  step = 1;
                  getFunc = function () return SV.qsSizeGP; end;
                  setFunc = function (value)
                    SV.qsSizeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.size = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsSizeGP;
                };
                {
                  type = "dropdown";
                  name = "Quick Slot timer font style";
                  tooltip = "Select which effect to display the timer font in.";
                  choices = { "normal"; "outline"; "shadow"; "soft-shadow-thick"; "soft-shadow-thin"; "thick-outline" };
                  sort = "name-up";
                  getFunc = function () return SV.qsTypeGP; end;
                  setFunc = function (value)
                    SV.qsTypeGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.outline = value;
                      FancyActionBar.ApplyQuickSlotFont();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                  default = defaults.qsTypeGP;
                };
                {
                  type = "colorpicker";
                  name = "Quick Slot timer color";
                  default = ZO_ColorDef:New(unpack(defaults.qsColorGP));
                  getFunc = function () return unpack(SV.qsColorGP); end;
                  setFunc = function (r, g, b)
                    SV.qsColorGP = { r; g; b };
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.color = { r; g; b };
                      FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetColor(unpack(SV.qsColorGP));
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "description";
                  text = "Adjust position";
                  width = "full";
                };
                {
                  type = "slider";
                  name = "Vertical";
                  tooltip = "[<- down] or [up ->]";
                  default = defaults.qsYGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.qsYGP; end;
                  setFunc = function (value)
                    SV.qsYGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.y = value;
                      FancyActionBar.AdjustQuickSlotTimer();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
                {
                  type = "slider";
                  name = "Horizontal";
                  tooltip = "[<- left] or [right ->]";
                  default = defaults.qsXGP;
                  min = -50;
                  max = 50;
                  step = 1;
                  getFunc = function () return SV.qsXGP; end;
                  setFunc = function (value)
                    SV.qsXGP = value;
                    if FancyActionBar.style == 2 then
                      FancyActionBar.constants.qs.x = value;
                      FancyActionBar.AdjustQuickSlotTimer();
                      DisplayQuickSlotLabelChanges();
                    end;
                  end;
                  width = "half";
                };
              };
            };
          };
        };
        { type = "divider" };

        --============[	Expiration Settings	]=================
        {
          type = "submenu";
          name = "|cFFFACDKeyboard & Gamepad Shared|r";
          controls = {

            --============[  Timer Fade Delay  ]==================
            {
              type = "description";
              title = "[ |cffdf80Timer Fade|r ]";
              width = "full";
            };
            {
              type = "checkbox";
              name = "Delay timer fade";
              tooltip = "Let the timer label display 0 for a set duration as a reminder that the ability has expired.";
              default = defaults.delayFade;
              getFunc = function () return SV.delayFade; end;
              setFunc = function (value) SV.delayFade = value or false; end;
              width = "half";
            };
            {
              type = "slider";
              name = "Fade delay";
              tooltip = "How long you would like the timer label to keep displaying 0 after the ability has expired";
              default = defaults.fadeDelay;
              disabled = function () return not SV.delayFade; end;
              min = 0.5;
              max = 5;
              step = 0.1;
              decimals = 1;
              clampInput = true;
              getFunc = function () return SV.fadeDelay; end;
              setFunc = function (value) SV.fadeDelay = value; end;
              width = "half";
            };
            { type = "description"; text = ""; width = "full" };

            --============[  Timer Decimals  ]====================
            {
              type = "description";
              title = "[ |cffdf80Duration Display Decimals|r ]";
              width = "full";
            };
            {
              type = "dropdown";
              name = "Enable timer decimals";
              tooltip = "Always = Will always display decimals if the timer is active.\nExpire = Will enable more options.\nNever = Never.";
              choices = FancyActionBar.GetDecimalOptions();
              default = defaults.showDecimal;
              getFunc = function () return SV.showDecimal; end;
              setFunc = function (value)
                SV.showDecimal = value;
                FancyActionBar.RefreshUpdateConfiguration();
              end;
              width = "half";
            };
            {
              type = "slider";
              name = "Decimals threshold";
              tooltip = "Decimals will show when timers fall below selected amount of seconds remaining";
              default = defaults.showDecimalStart;
              disabled = function () if SV.showDecimal == "Expire" then return false; else return true; end; end;
              min = 0;
              max = 10;
              step = 0.1;
              decimals = 1;
              clampInput = true;
              getFunc = function () return SV.showDecimalStart; end;
              setFunc = function (value)
                SV.showDecimalStart = value;
                FancyActionBar.RefreshUpdateConfiguration();
              end;
              width = "half";
            };
            { type = "description"; text = ""; width = "full" };

            --============[  Expiring Effect Start  ]=============
            {
              type = "description";
              title = "[ |cffdf80Display Changes For Expiring Effects|r ]";
              width = "full";
            };
            {
              type = "slider";
              name = "Expiring timer threshold";
              tooltip = " The color of durations and highlights will change when timers fall below selected amount of seconds remaining, if their individual settings are enabled";
              default = defaults.showExpireStart;
              min = 0;
              max = 10;
              step = 0.1;
              decimals = 1;
              clampInput = true;
              getFunc = function () return SV.showExpireStart; end;
              setFunc = function (value)
                SV.showExpireStart = value;
              end;
              width = "half";
            };

            --============[	Expiring Timer Color	]=============
            { type = "description"; title = "[ |cffdf80Timer Text|r ]"; width = "full";
            };
            {
              type = "checkbox";
              name = "Change expiring timer text color";
              tooltip = "Change timer text color when duration is running out.";
              default = defaults.showExpire;
              getFunc = function () return SV.showExpire; end;
              setFunc = function (value)
                SV.showExpire = value or false;
              end;
              width = "full";
            };
            {
              type = "colorpicker";
              name = "Select timer text color for expiring effect";
              default = ZO_ColorDef:New(unpack(defaults.expireColor));
              disabled = function () return (not SV.showExpire); end;
              getFunc = function () return unpack(SV.expireColor); end;
              setFunc = function (r, g, b)
                SV.expireColor = { r; g; b };
              end;
              width = "full";
            };
            { type = "description"; text = ""; width = "full" };

            --============[	Expiring Highlight Color	]=========
            { type = "description"; title = "[ |cffdf80HighLight|r ]"; width = "full";
            };
            {
              type = "checkbox";
              name = "Change expiring timer highlight color";
              tooltip = "Change highligh color when duration is running out.";
              default = defaults.highlightExpire;
              getFunc = function () return SV.highlightExpire; end;
              setFunc = function (value)
                SV.highlightExpire = value or false;
              end;
              width = "full";
            };
            {
              type = "colorpicker";
              name = "Select highlight color for expiring effects";
              default = ZO_ColorDef:New(unpack(defaults.highlightExpireColor));
              disabled = function () return (not SV.highlightExpireColor); end;
              getFunc = function () return unpack(SV.highlightExpireColor); end;
              setFunc = function (r, g, b, a)
                SV.highlightExpireColor = { r; g; b; a };
              end;
              width = "full";
            };
          };
        };
      };
    };
    { type = "divider" };

    --==============[  Ability Config  ]=====================
    {
      type = "submenu";
      name = "|cFFFACDAbility Configuration|r";
      controls = {

        {
          type = "submenu";
          name = "|cFFFACDCurrently Slotted Ability IDs|r";
          controls = {

            {
              type = "description";
              title = "Front Bar";
              text = function () return GetCurrentFrontBarInfo(); end;
              width = "half";
              reference = "Front_Bar_List";
            };
            {
              type = "description";
              title = "Back Bar";
              text = function () return GetCurrentBackBarInfo(); end;
              width = "half";
              reference = "Back_Bar_List";
            };
          };
        };

        {
          type = "submenu";
          name = "|cFFFACDTracked Effects|r";
          controls = {

            {
              type = "submenu";
              name = "Info";
              controls = {

                {
                  type = "description";
                  title = "";
                  text = "Here you can edit which effect you want the timer for a specific skill to track.\nTo track a different effect, make sure to enter the ID of the skill and the ID of the new effect, before clicking the button to confirm.\nThis function is still in early testing stage and errors are likely to occur for some skills, but you can always reset any skill you altered and it will be working as it used to.";
                  width = "full";
                };
              };
            };

            { type = "divider" };

            {
              type = "checkbox";
              name = "Accountwide Skill Settings";
              tooltip = "If the accountwide setting is enabled, changes made will affect only the shared settings between all characters. If the setting is disabled, only changes made from your current character will be different from the default.";
              default = true;
              getFunc = function () return CV.useAccountWide; end;
              setFunc = function (value) CV.useAccountWide = value or false; end;
              requiresReload = true;
              width = "half";
            };

            { type = "divider" };

            {
              type = "dropdown";
              name = "Saved Changes";
              tooltip = "Easily find skills that you have made changes to.";
              choices = GetChangedSkills();
              getFunc = function () GetSelectedChangedSkill(); end;
              setFunc = function (value) SetChangedSkillToEdit(value); end;
              reference = "Saved_Changes_Dropdown";
              default = "== Select a Skill ==";
              width = "half";
            };

            { type = "description"; text = ""; width = "half" };

            {
              type = "editbox";
              name = "Skill ID";
              tooltip = "Enter the ID of the skill you want to edit.";
              -- default = '',
              getFunc = function () return GetSkillToEditID(); end;
              setFunc = function (value) SetSkillToEditID(value); end;
              reference = "SkillToEditID_Editbox";
              isMultiline = false;
              isExtraWide = false;
              width = "half";
            };
            {
              type = "description";
              title = "Selected Skill:";
              text = function () return GetSkillToEditName(); end;
              width = "half";
              reference = "SkillToEditTitle";
            };
            {
              type = "dropdown";
              name = "Change Type";
              tooltip = "Select which type of change you want to apply to the skill.";
              choices = GetSkillChangeOptions();
              getFunc = function () return GetSkillChangeType(); end;
              setFunc = function (value) SetSkillChangeType(value); end;
              width = "half";
              reference = "Change_Type_Dropdown";
              default = "";
            };

            { type = "description"; text = ""; width = "half" };

            {
              type = "editbox";
              name = "New Effect ID";
              tooltip = "Enter the ID of the effect you want to have tracked from the selected skill.";
              -- default = '',
              getFunc = function () return GetEffectToTrackID(); end;
              setFunc = function (value) SetEffectToTrackID(value); end;
              reference = "EffectToTrackID_Editbox";
              isMultiline = false;
              isExtraWide = false;
              width = "half";
            };
            {
              type = "description";
              title = "Selected Effect:";
              text = function () return GetEffectToTrackName(); end;
              width = "half";
              reference = "EffectToTrackTitle";
            };

            {
              type = "button";
              name = "Confirm Change";
              width = "full";
              func = function () ValidateSkillChange(); end;
              disabled = function () return IsChangePossible(); end;
            };
            -- {	type = 'checkbox', 			name = 'Only Update Used Skill',
            --   tooltip = 'Only update the timer for the button used to cast the effect.',
            --   getFunc = function() return GetUpdateUsedButtonOnly() end,
            --   setFunc = function(value) GetUpdateUsedButtonOnly(skillToEditID, value) end,
            --   disabled = function() return skillToEditID == 0 or not IsValidId(skillToEditID) end,
            --   width = 'half'
            -- }
          };
        };
        -- {	type = 'divider'  },

        --==============[  External Buff Tracking  ]==============
        {
          type = "submenu";
          name = "|cFFFACDBuffs Gained From others|r";
          controls = {

            {
              type = "submenu";
              name = "Info";
              controls = {

                { type = "description"; text = "Here you can enable the ability timers to track the duration if their tracked effect is gained from an ally.\nYou can also select which effects you do not want to have tracked if you are not the source.";
                };
              };
            };

            {
              type = "checkbox";
              name = "Track Buffs From Others";
              default = defaults.externalBuffs;
              getFunc = function () return SV.externalBuffs; end;
              setFunc = function (value)
                SV.externalBuffs = value or false;
                FancyActionBar.SetExternalBuffTracking();
              end;
              width = "half";
            };
            { type = "description"; width = "half" };

            {
              type = "editbox";
              name = "Add to Blacklist";
              tooltip = "Enter the ID of the skill you dont want to have updated when you gain the effect from someone else.";
              -- default = '',
              getFunc = function () return GetSkillToBlacklistID(); end;
              setFunc = function (value) SetSkillToBlacklistID(value); end;
              reference = "SkillToBlacklistID_Editbox";
              isMultiline = false;
              isExtraWide = false;
              width = "half";
            };
            {
              type = "description";
              title = "Selected Buff:";
              text = function () return GetSkillToBlacklistName(); end;
              width = "half";
              reference = "SkillToBlacklistTitle";
            };

            { type = "description"; width = "half" };

            {
              type = "button";
              name = "Confirm Blacklist";
              width = "half";
              func = function () BlacklistId(); end;
              disabled = function () return not CanBlacklistId(); end;
              reference = "SkillToBlacklist_Button";
            };

            { type = "description"; width = "full" };

            {
              type = "dropdown";
              name = "Blacklisted IDs";
              choices = GetBlacklistedSkills();
              getFunc = function () GetSelectedBlacklist(); end;
              setFunc = function (value) SetSelectedBlacklist(value); end;
              reference = "Blacklist_Dropdown";
              -- default = '== Select a Skill ==',
              width = "half";
            };

            {
              type = "button";
              name = "Remove From Blacklist";
              width = "half";
              func = function () ClearBlacklistId(); end;
              disabled = function () return not CanClearBlacklistId(); end;
              reference = "BlacklistToClear_Button";
            };
          };
        };
        -- {	type = 'divider'  },

        --==================[  Target Debuffs  ]==================
        {
          type = "submenu";
          name = "|cFFFACDDebuffs on Target|r";
          controls = {

            {
              type = "checkbox";
              name = "Debuff timers for current target";
              tooltip = "Update timer duration of debuffs when changing target, to display the remaining duration on them specifically.\nOnly for alive enemy targets.";
              default = defaults.advancedDebuff;
              getFunc = function () return SV.advancedDebuff; end;
              setFunc = function (value)
                SV.advancedDebuff = value or false;
                FancyActionBar:UpdateDebuffTracking();
              end;
            };

            {
              type = "checkbox";
              name = "Keep Timers For Last Target";
              tooltip = "Keep timers when you look away from your target until you have a new enemy target.";
              default = defaults.keepLastTarget;
              getFunc = function () return SV.keepLastTarget; end;
              setFunc = function (value) SV.keepLastTarget = value or false; end;
              disabled = function () return not SV.advancedDebuff; end;
            };

            {
              type = "description";
              text = "More options to come.";
              width = "full";
            };

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
          };
        };
        -- {	type = 'divider'  },

        --============[  Additional Tracking Options  ]===========
        {
          type = "submenu";
          name = "|cFFFACDAdditional Tracking Options|r";
          controls = {


            -- { type = 'divider'	},

            {
              type = "description";
              title = "[ |cffdf80Effect Duration Thresholds|r ]";
              text = "Set the limits for when to ignore effects based on their duration.";
              width = "full";
            };
            {
              type = "slider";
              name = "Minimum";
              min = 1;
              max = 4;
              step = 0.5;
              getFunc = function () return SV.durationMin; end;
              setFunc = function (value)
                SV.durationMin = value;
                FancyActionBar.UpdateDurationLimits();
              end;
              width = "half";
              default = defaults.durationMin;
            };
            {
              type = "slider";
              name = "Maximum";
              min = 30;
              max = 130;
              step = 1;
              getFunc = function () return SV.durationMax; end;
              setFunc = function (value)
                SV.durationMax = value;
                FancyActionBar.UpdateDurationLimits();
              end;
              width = "half";
              default = defaults.durationMax;
            };
          };
        };
      };
    };
    { type = "divider" };

    --============[	Miscellaneous	]=======================
    {
      type = "submenu";
      name = "|cFFFACDMiscellaneous|r";
      controls = {

        {
          type = "checkbox";
          name = "Show bar while dead";
          tooltip = "Will display the action bar while you are dead if enabled.";
          default = defaults.showDeath;
          getFunc = function () return SV.showDeath; end;
          setFunc = function (value)
            SV.showDeath = value or false;
            CheckDeathState();
            FancyActionBar.ApplyDeathStateOption();
          end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Prevent casting in trade";
          tooltip = "Blocks the use of skills while in trade, but allows the use of them while in settings and when map is open.\nThis will prevent Perfect Weave from working as intended.";
          default = defaults.lockInTrade;
          getFunc = function () return SV.lockInTrade; end;
          setFunc = function (value) SV.lockInTrade = value or false; end;
          width = "half";
        };
        {
          type = "checkbox";
          name = "Enable Perfect Weave";
          tooltip = "In order for Perfect Weave to work, changes that allows for skills to be cast while in settings or when map is open ect. has to be disabled.\nThe game did not consider these thigns well in the past, which is why I made a few alterations to them. They have been slightly improved and you can rely on them if you want to use Perfect Weave and this addon together.";
          default = defaults.perfectWeave;
          getFunc = function () return SV.perfectWeave; end;
          setFunc = function (value) SV.perfectWeave = value or false; end;
          requiresReload = true;
          width = "half";
        };
        { type = "description"; text = ""; width = "half" };

        --============[	Enemy Markers	]=======================
        {
          type = "description";
          title = "[ |cffdf80Enemy Markers|r ]";
          text = "yes.. I completely stole this from Untaunted.";
          width = "full";
        };
        {
          type = "checkbox";
          name = "Show Enemy Markers";
          tooltip = "Display a red arrow over the head of enemies you are currently in combat with.";
          default = defaults.showMarker;
          getFunc = function () return SV.showMarker; end;
          setFunc = function (value)
            SV.showMarker = value or false;
          end;
          width = "half";
        };
        {
          type = "slider";
          name = "Enemy Marker Size";
          default = defaults.markerSize;
          min = 10;
          max = 90;
          getFunc = function () return SV.markerSize; end;
          setFunc = function (value)
            SV.markerSize = value;
            FancyActionBar.SetMarker(value);
          end;
          width = "half";
        };
        { type = "divider" };

        --===============[  GCD Tracker  ]======================
        {
          type = "submenu";
          name = "|cFFFACDGlobal Cooldown Tracker|r";
          controls = {
            {
              type = "description";
              title = "Early BETA version\nWorks fine but is not very pretty";
              width = "full";
            };
            {
              type = "checkbox";
              name = "Enable GCD";
              default = defaults.gcd.enable;
              getFunc = function () return SV.gcd.enable; end;
              setFunc = function (value)
                SV.gcd.enable = value or false;
                FancyActionBar.ToggleGCD();
              end;
              width = "half";
            };
            {
              type = "checkbox";
              name = "Only in combat";
              default = defaults.gcd.combatOnly;
              getFunc = function () return SV.gcd.combatOnly; end;
              setFunc = function (value)
                SV.gcd.combatOnly = value or false;
                FancyActionBar.ToggleGCD();
              end;
              width = "half";
            };

            { type = "divider" };

            {
              type = "slider";
              name = "Height";
              default = SV.gcd.sizeX;
              min = 30;
              max = 100;
              getFunc = function () return SV.gcd.sizeY; end;
              setFunc = function (value)
                SV.gcd.sizeY = value;
                FancyActionBar.UpdateGCDSize();
              end;
              width = "half";
            };
            {
              type = "slider";
              name = "Width";
              default = defaults.gcd.sizeY;
              min = 30;
              max = 250;
              getFunc = function () return SV.gcd.sizeX; end;
              setFunc = function (value)
                SV.gcd.sizeX = value;
                FancyActionBar.UpdateGCDSize();
              end;
              width = "half";
            };
            {
              type = "colorpicker";
              name = "Fill color";
              default = ZO_ColorDef:New(unpack(defaults.gcd.fillColor));
              getFunc = function () return unpack(SV.gcd.fillColor); end;
              setFunc = function (r, g, b, a)
                SV.gcd.fillColor = { r; g; b; a };
                FAB_GCD.fill:SetCenterColor(unpack(SV.gcd.fillColor));
                FAB_GCD.fill:SetEdgeColor(unpack(SV.gcd.fillColor));
              end;
              width = "half";
            };
            {
              type = "colorpicker";
              name = "Edge color";
              default = ZO_ColorDef:New(unpack(defaults.gcd.frameColor));
              getFunc = function () return unpack(SV.gcd.frameColor); end;
              setFunc = function (r, g, b, a)
                SV.gcd.frameColor = { r; g; b; a };
                FAB_GCD.frame:SetColor(unpack(SV.gcd.frameColor));
              end;
              width = "half";
            };
          };
        };
      };
    };
    { type = "divider" };

    --===============[  Debugging  ]========================
    {
      type = "description";
      title = "[ |cffdf80Debugging|r ]";
      text = "";
      width = "full";
    };
    {
      type = "checkbox";
      name = "Debug mode";
      tooltip = "Display internal events in the chat";
      default = defaults.debug;
      getFunc = function () return SV.debug; end; --FancyActionBar.IsDebugMode() end,
      setFunc = function (value)
        -- FancyActionBar.SetDebugMode(value or false)
        FancyActionBar.SetDebugMode(value or false);
        SV.debug = value or false;
      end;
    };

    { type = "divider" };

    {
      type = "description";
      text = FancyActionBar.strings.disclaimer;
      width = "full";
    };
  };

  LAM:RegisterOptionControls(name, options);

  CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function (panel)
    if panel == FAB_Panel then
      ACTION_BAR:SetHidden(false);
      FAB_GCD:SetHidden(not SV.gcd.enable);
      inMenu = true;
      FancyActionBar.UpdateSlottedSkillsDecriptions();
    else
      ACTION_BAR:SetHidden(true);
      FAB_GCD:SetHidden(true);
      inMenu = false;
      qsDisplayTime = 0;
    end;
  end);
  CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function (panel)
    if panel ~= FAB_Panel then return; end;
    ACTION_BAR:SetHidden(true);
    FAB_GCD:SetHidden(true);
    inMenu = false;
    qsDisplayTime = 0;
  end);

  CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", function (panel)
    if panel == FAB_Panel then
      if not settingsPageCreated then
        settingsPageCreated = true;
      end;
    end;
  end);

  ParseExternalBlacklist();
end;

-------------------------------------------------------------------------------
-----------------------------[   Player Settings   ]---------------------------
-------------------------------------------------------------------------------
function FancyActionBar.UpdateTextures()
  RedirectTexture("EsoUI/Art/ActionBar/ability_ultimate_frameDecoBG.dds", FAB_BLANK);
  RedirectTexture("esoui/art/actionbar/abilityInset.dds", FAB_BG);
  if BUI then
    if BUI.abilityframe then BUI.abilityframe = FAB_BLANK; end;
    -- local BUI_FRAME = '/BanditsUserInterface/textures/theme/abilityframe64_up.dds'
    -- RedirectTexture(BUI_FRAME, f[2])
  end;
end;

function FancyActionBar.HideHotkeys(hide)
  local alpha = hide == true and 0 or 1;

  local QSB = QuickslotButtonButtonText;

  if FancyActionBar.style == 1 then
    for i = 3, 7 do
      local b = ZO_ActionBar_GetButton(i);
      b.buttonText:SetHidden(hide);
      b.buttonText:SetAlpha(alpha);
    end;
    QSB:SetHidden(hide);
    QSB:SetAlpha(alpha);
    -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetHidden(hide)
    -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetAlpha(alpha)
    ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetHidden(hide);
    ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetAlpha(alpha);
    ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetHidden(hide);
    ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetAlpha(alpha);
  else
    for i = 3, 7 do ZO_ActionBar_GetButton(i).buttonText:SetHidden(hide); end;
    QSB:SetHidden(true);
    -- ZO_ActionBar_GetButton(QUICK_SLOT).buttonText:SetHidden(true)
    ZO_ActionBar_GetButton(ULT_SLOT).buttonText:SetHidden(true);
    ZO_ActionBar_GetButton(ULT_SLOT, COMPANION).buttonText:SetHidden(true);
    local uAlpha = SV.showHotkeysUltGP == true and 1 or 0;
    if ActionButton8 then
      if ActionButton8LeftKeybind then ActionButton8LeftKeybind:SetAlpha(uAlpha); end;
      if ActionButton8RightKeybind then ActionButton8RightKeybind:SetAlpha(uAlpha); end;
    end;
    local c = CompanionUltimateButton;
    if c then
      local l = CompanionUltimateButtonLeftKeybind;
      local r = CompanionUltimateButtonRightKeybind;
      if l then l:SetAlpha(uAlpha); end;
      if r then r:SetAlpha(uAlpha); end;
    end;
  end;
end;

function FancyActionBar.SetMarker(value)
  if SV.showMarker ~= true then return; end;
  SetFloatingMarkerInfo(MAP_PIN_TYPE_AGGRO, SV.markerSize, FAB_MARKER, FAB_MARKER, true, true);
  SetFloatingMarkerGlobalAlpha(1);
end;

function FancyActionBar.ConfigureFrames()
  -- ZO_CenterScreenAnnouncementLine.smallCombinedIconFrame
  -- ZO_CenterScreenAnnouncementLine.iconControlFrame

  if BUI then -- revert all this nonsense with no options or global access to prevent it initially.
    for i = 3, 9 do
      local name = "ActionButton" .. i;
      local frame = _G[name];
      if frame then
        local edge = _G[name .. "Edge"];
        if edge then
          edge:SetHidden(true);
          edge:SetAlpha(0);
        end;

        local backdrop = frame:GetNamedChild("Backdrop");
        if backdrop then backdrop:SetAlpha(1); end;

        local bg = frame:GetNamedChild("BG");
        if bg then bg:SetHidden(false); end;

        if i == 8 then
          backdrop = frame:GetNamedChild("Frame");
          if backdrop then backdrop:SetAlpha(1); end;
        end;
      end;
    end;
  end;

  local function HideFrames(hide)
    for i, overlay in pairs(FancyActionBar.overlays) do
      local frame = overlay:GetNamedChild("Frame");
      if frame then frame:SetHidden(hide); end;
    end;
    for i, overlay in pairs(FancyActionBar.ultOverlays) do
      local frame = overlay:GetNamedChild("Frame");
      if frame then frame:SetHidden(hide); end;
    end;
  end;

  if FancyActionBar.style == 2 then
    HideFrames(true);
    if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then FancyActionBar.qsOverlay.frame:SetHidden(true); end;
  else
    if not SV.showFrames then
      HideFrames(true);
      if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then FancyActionBar.qsOverlay.frame:SetHidden(true); end;
    else
      HideFrames(false);
      if FancyActionBar.qsOverlay and FancyActionBar.qsOverlay.frame then FancyActionBar.qsOverlay.frame:SetHidden(false); end;
      FancyActionBar.SetFrameColor();
    end;
    SetDefaultAbilityFrame();
  end;
end;

function FancyActionBar.SetFrameColor()
  if FancyActionBar.style == 2 then return; end;

  if FancyActionBar.style == 1 then
    for i, overlay in pairs(FancyActionBar.overlays) do
      local frame = overlay:GetNamedChild("Frame");
      frame:SetColor(unpack(SV.frameColor));
    end;
    for i, overlay in pairs(FancyActionBar.ultOverlays) do
      local frame = overlay:GetNamedChild("Frame");
      frame:SetColor(unpack(SV.frameColor));
    end;
    FancyActionBar.qsOverlay.frame:SetColor(unpack(SV.frameColor));
--[[     if GetDisplayName() == "@dack_janiels" then
      local s = GetControl("ZO_SynergyTopLevel");
      local c = s:GetNamedChild("Container");
      local i = c:GetNamedChild("Icon");
      local e = i:GetNamedChild("Edge");
      e:SetColor(unpack(SV.frameColor));
    end; ]]
  end;
end;

function FancyActionBar.ApplyAlphaInactive(alpha)
  local alphaInactive = (alpha / 100);
  for i = MIN_INDEX, MAX_INDEX do
    local button = ZO_ActionBar_GetButton(i);
    button = FancyActionBar.buttons[i + SLOT_INDEX_OFFSET];
    button.icon:SetAlpha(alphaInactive);
  end;
  SV.alphaInactive = alpha;
end;

function FancyActionBar.ApplyDesaturationInactiveInactive(desaturation)
  local desaturationInactive = (desaturation / 100);
  for i = MIN_INDEX, MAX_INDEX do
    local button = ZO_ActionBar_GetButton(i);
    button = FancyActionBar.buttons[i + SLOT_INDEX_OFFSET];
    button.icon:SetDesaturation(desaturationInactive);
  end;
  SV.desaturationInactive = desaturation;
end;

function FancyActionBar.ApplyTimerFont()
  local function GetCurrentFont()
    local c = FancyActionBar.constants.duration;
    return c.font, c.size, c.outline;
  end;

  local name, size, type = GetCurrentFont();

  if name == "" then name = "$(BOLD_FONT)"; end;

  for i = MIN_INDEX, MAX_INDEX do
    local overlay = FancyActionBar.overlays[i];
    local timer = overlay:GetNamedChild("Duration");

    timer:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    timer:SetHidden(false);

    overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET];
    timer = overlay:GetNamedChild("Duration");

    timer:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    timer:SetHidden(false);
  end;
end;

function FancyActionBar.AdjustTimerY()
  local timerY = FancyActionBar.constants.duration.y;
  local y;

  if timerY == 0 then
    y = 0;
  elseif timerY < 0 then
    y = timerY + (timerY * -2);
  elseif timerY > 0 then
    y = timerY - (timerY * 2);
  end;

  for i = MIN_INDEX, MAX_INDEX do
    local overlay = FancyActionBar.overlays[i];
    local timer = overlay:GetNamedChild("Duration");

    timer:ClearAnchors();
    timer:SetAnchor(BOTTOM, overlay, BOTTOM, 0, y);

    overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET];
    timer = overlay:GetNamedChild("Duration");

    timer:ClearAnchors();
    timer:SetAnchor(BOTTOM, overlay, BOTTOM, 0, y);
  end;
end;

function FancyActionBar.ApplyStackFont()
  local function GetCurrentStackFont()
    local c = FancyActionBar.constants.stacks;
    return c.font, c.size, c.outline;
  end;

  local name, size, type = GetCurrentStackFont();

  if name == "" then name = "$(BOLD_FONT)"; end;

  for i = MIN_INDEX, MAX_INDEX do
    local overlay = FancyActionBar.overlays[i];
    local stack = overlay:GetNamedChild("Stacks");

    stack:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    stack:SetHidden(false);

    overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET];
    stack = overlay:GetNamedChild("Stacks");

    stack:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    stack:SetHidden(false);
  end;
end;

function FancyActionBar.AdjustStackX()
  local stackX = FancyActionBar.constants.stacks.x;
  -- so moving slider in setting will move stack the same direction
  local x = stackX - 40;

  for i = MIN_INDEX, MAX_INDEX do
    local overlay = FancyActionBar.overlays[i];
    local stack = overlay:GetNamedChild("Stacks");

    stack:ClearAnchors();
    stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, 0);

    overlay = FancyActionBar.overlays[i + SLOT_INDEX_OFFSET];
    stack = overlay:GetNamedChild("Stacks");

    stack:ClearAnchors();
    stack:SetAnchor(TOPRIGHT, overlay, TOPRIGHT, x, 0);
  end;
end;

function FancyActionBar.AdjustQuickSlotTimer()
  local timerX = FancyActionBar.constants.qs.x;
  local timerY = FancyActionBar.constants.qs.y;
  local x = timerX;
  local y;

  if timerY == 0 then
    y = 0;
  elseif timerY < 0 then
    y = timerY + (timerY * -2);
  elseif timerY > 0 then
    y = timerY - (timerY * 2);
  end;

  local qs = FancyActionBar.qsOverlay;
  local d = qs:GetNamedChild("Duration");
  d:ClearAnchors();
  d:SetAnchor(CENTER, qs, CENTER, x, y);
end;

function FancyActionBar.ApplyQuickSlotFont()
  local function GetCurrentQuickSlotFont()
    local c = FancyActionBar.constants.qs;
    return c.font, c.size, c.outline;
  end;

  local name, size, type = GetCurrentQuickSlotFont();
  if name == "" then name = "$(BOLD_FONT)"; end;
  FancyActionBar.qsOverlay:GetNamedChild("Duration"):SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
end;

function FancyActionBar.UpdateHighlight(index)
  local button = FancyActionBar.GetActionButton(index);
  local overlay = FancyActionBar.overlays[index];
  local effect = overlay.effect;
  local bgControl = overlay:GetNamedChild("BG");
  local durationControl = overlay:GetNamedChild("Duration");

  -- local state

  if (FancyActionBar.toggles[effect.id] == true or effect.passive == true) then
    -- state = 'On'
    if SV.toggledHighlight then
      button.status:SetAlpha(0);
      bgControl:SetColor(unpack(SV.toggledColor));
      bgControl:SetHidden(false);
    elseif SV.showHighlight then
      button.status:SetAlpha(0);
      bgControl:SetColor(unpack(SV.highlightColor));
      bgControl:SetHidden(false);
    else
      bgControl:SetHidden(true);
      button.status:SetAlpha(0.7);
    end;
    durationControl:SetText("");
  else
    -- state = 'Off'
    bgControl:SetHidden(true);
    button.status:SetAlpha(0.7);
  end;
  -- Chat('Toggled overlay ' .. index .. ' bg: ' .. state)
end;

function FancyActionBar.AdjustUltTimer(sample)
  local timerX = FancyActionBar.constants.ult.duration.x;
  local timerY = FancyActionBar.constants.ult.duration.y;
  local x = timerX; -- - 20
  local y;
  if timerY == 0 then
    y = 0;
  elseif timerY < 0 then
    y = timerY + (timerY * -2);
  elseif timerY > 0 then
    y = timerY - (timerY * 2);
  end;

  for i, overlay in pairs(FancyActionBar.ultOverlays) do
    overlay = FancyActionBar.ultOverlays[i];
    if overlay then
      local durationControl = overlay:GetNamedChild("Duration");
      durationControl:ClearAnchors();
      durationControl:SetAnchor(CENTER, overlay, CENTER, x, y);
      local effect = overlay.effect;
      if inMenu then
      end;
    end;
  end;

  if sample then -- display label when changes are made
    DisplayUltimateLabelChanges();
  end;
end;

function FancyActionBar.ApplyUltFont(sample)
  local function GetCurrentUltFont()
    local c = FancyActionBar.constants.ult.duration;
    return c.font, c.size, c.outline;
  end;

  local name, size, type = GetCurrentUltFont();

  if name == "" then name = "$(BOLD_FONT)"; end;

  for i, overlay in pairs(FancyActionBar.ultOverlays) do
    overlay = FancyActionBar.ultOverlays[i];
    if overlay then
      overlay:GetNamedChild("Duration"):SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    end;
  end;

  if sample then
    DisplayUltimateLabelChanges();
  end;
end;

function FancyActionBar.AdjustUltValue()
  local timerX = FancyActionBar.constants.ult.value.x;
  local timerY = FancyActionBar.constants.ult.value.y;
  local x = timerX; -- - 20
  local y;
  if timerY == 0 then
    y = 0;
  elseif timerY < 0 then
    y = timerY + (timerY * -2);
  elseif timerY > 0 then
    y = timerY - (timerY * 2);
  end;

  for i, overlay in pairs(FancyActionBar.ultOverlays) do
    overlay = FancyActionBar.ultOverlays[i];
    if overlay and i < 30 then
      local value = overlay:GetNamedChild("Value");
      value:ClearAnchors();
      value:SetAnchor(BOTTOMRIGHT, overlay, BOTTOMRIGHT, x, y);
    end;
  end;
end;

function FancyActionBar.AdjustCompanionUltValue()
  local timerX = FancyActionBar.constants.ult.companion.x;
  local timerY = FancyActionBar.constants.ult.companion.y;
  local x = timerX; -- - 20
  local y;
  if timerY == 0 then
    y = 0;
  elseif timerY < 0 then
    y = timerY + (timerY * -2);
  elseif timerY > 0 then
    y = timerY - (timerY * 2);
  end;

  local overlay = FancyActionBar.ultOverlays[ULT_INDEX + COMPANION_INDEX_OFFSET];
  if overlay then
    local value = overlay:GetNamedChild("Value");
    value:ClearAnchors();
    value:SetAnchor(BOTTOMRIGHT, overlay, BOTTOMRIGHT, x, y);
  end;
end;

function FancyActionBar.ApplyUltValueFont()
  local function GetCurrentUltValueFont()
    local c = FancyActionBar.constants.ult.value;
    return c.font, c.size, c.outline;
  end;

  local name, size, type = GetCurrentUltValueFont();

  if name == "" then name = "$(BOLD_FONT)"; end;

  for i, overlay in pairs(FancyActionBar.ultOverlays) do
    overlay = FancyActionBar.ultOverlays[i];
    if overlay then
      local l = overlay:GetNamedChild("Value");
      l:SetFont(FAB_Fonts[name] .. "|" .. size .. "|" .. type);
    end;
  end;
end;

function FancyActionBar.ApplyUltValueColor()
  local color = FancyActionBar.constants.ult.value.color;

  for i, overlay in pairs(FancyActionBar.ultOverlays) do
    if FancyActionBar.ultOverlays[i] then FancyActionBar.ultOverlays[i]:GetNamedChild("Value"):SetColor(unpack(color)); end;
  end;
end;

function FancyActionBar.UpdateUltValueMode()
  local e = FancyActionBar.constants.ult.value.show;
  local c = FancyActionBar.constants.ult.companion.show;
  local u, _, _;

  if e then
    u, _, _ = GetUnitPower("player", COMBAT_MECHANIC_FLAGS_ULTIMATE);
    FancyActionBar.UpdateUltimateValueLabels(true, u);
  end;

  if c then
    u, _, _ = GetUnitPower("companion", COMBAT_MECHANIC_FLAGS_ULTIMATE);
    FancyActionBar.UpdateUltimateValueLabels(false, u);
  end;
end;

function FancyActionBar.EnableGDC()
  SV.gcd.enable = true;
  FancyActionBar.ToggleGCD();
end;

function FancyActionBar.DisableGCD()
  SV.gcd.enable = false;
  FancyActionBar.ToggleGCD();
end;

local function OnCombatEnter()
  if (IsUnitInCombat("player") and not FancyActionBar.inCombat) then
    FancyActionBar.inCombat = true;
    FAB_GCD:SetHidden(false);
    EM:RegisterForUpdate(FancyActionBar.GetName() .. "GCD", 20, FancyActionBar.UpdateGCD);
  else
    if FancyActionBar.inCombat then
      FancyActionBar.inCombat = false;
      FAB_GCD:SetHidden(true);
      EM:UnregisterForUpdate(FancyActionBar.GetName() .. "GCD");
    end;
  end;
end;

function FancyActionBar.ToggleGCD()
  local function OnStateChanged(oldState, newState)
    if (newState == SCENE_SHOWN and SV.gcd.enable) then
      if (not FancyActionBar.inCombat and SV.gcd.combatOnly) then return; end;
      FAB_GCD:SetHidden(false);
    else
      FAB_GCD:SetHidden(true);
    end;
  end;

  local name = FancyActionBar.GetName();

  EM:UnregisterForUpdate(name .. "GCD");
  ---@diagnostic disable-next-line: redundant-parameter
  EM:UnregisterForEvent(name .. "GCDCombatState", EVENT_PLAYER_COMBAT_STATE, OnCombatEnter);

  if SV.gcd.enable then
    if SV.gcd.combatOnly then
      EM:RegisterForEvent(name .. "GCDCombatState", EVENT_PLAYER_COMBAT_STATE, OnCombatEnter);
    else
      FAB_GCD:SetHidden(false);
      EM:RegisterForUpdate(name .. "GCD", 20, FancyActionBar.UpdateGCD);
    end;
    SCENE_MANAGER:GetScene("hud"):RegisterCallback("StateChange", OnStateChanged);
    SCENE_MANAGER:GetScene("hudui"):RegisterCallback("StateChange", OnStateChanged);
  else
    SCENE_MANAGER:GetScene("hud"):UnregisterCallback("StateChange");
    SCENE_MANAGER:GetScene("hudui"):UnregisterCallback("StateChange");
    FAB_GCD:SetHidden(true);
  end;
end;

function FancyActionBar.UpdateGCDSize()
  FAB_GCD:SetDimensions(SV.gcd.sizeX, SV.gcd.sizeY);
  FAB_GCD.frame:SetDimensions(SV.gcd.sizeX + 5, SV.gcd.sizeY + 5);
end;

function FancyActionBar.SetupGCD()
  FAB_GCD:SetClampedToScreen(true);
  FAB_GCD:SetHidden(true);
  FAB_GCD:SetDimensions(SV.gcd.sizeX, SV.gcd.sizeY);
  FAB_GCD:SetMouseEnabled(true);
  FAB_GCD:SetMovable(true);
  FAB_GCD:SetAlpha(1);
  FAB_GCD:ClearAnchors();

  local f = CreateControl("$(parent)Frame", FAB_GCD, CT_TEXTURE);
  f:SetTexture(FAB_FRAME);
  f:SetDimensions(SV.gcd.sizeX + 5, SV.gcd.sizeY + 5);
  f:SetAnchor(CENTER, FAB_GCD, CENTER, 0, 0);
  f:SetColor(unpack(SV.gcd.frameColor));
  f:SetDrawLevel(4);

  local b = CreateControlFromVirtual("$(parent)BG", FAB_GCD, "FAB_BG");
  b:SetCenterColor(0, 0, 0, 0.4);
  b:SetEdgeColor(0, 0, 0, 1);
  b:SetDrawLevel(1);

  local l = CreateControlFromVirtual("$(parent)Fill", FAB_GCD, "FAB_Fill");
  l:SetCenterColor(unpack(SV.gcd.fillColor));
  l:SetEdgeColor(unpack(SV.gcd.fillColor));
  l:SetDrawLevel(2);

  FAB_GCD.frame = f;
  FAB_GCD.bg = b;
  FAB_GCD.fill = l;

  FAB_GCD:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SV.gcd.x, SV.gcd.y, FAB_GCD:GetResizeToFitConstrains());
end;

function FancyActionBar.SetMoved(moved)
  FancyActionBar.wasMoved = moved;
end;

function FancyActionBar.UndoMove()
  local x, y;
  if FancyActionBar.style == 2 then
    x = SV.abMove.gp.prevX;
    y = SV.abMove.gp.prevY;
    SV.abMove.gp.x = x;
    SV.abMove.gp.y = y;
  else
    x = SV.abMove.kb.prevX;
    y = SV.abMove.kb.prevY;
    SV.abMove.kb.x = x;
    SV.abMove.kb.y = y;
  end;
  FancyActionBar.constants.move.x = x;
  FancyActionBar.constants.move.y = y;
  ACTION_BAR:ClearAnchors();
  ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y);
  ReanchorMover();
  FancyActionBar.SetMoved(false);
end;

function FancyActionBar.ToggleMover()
  unlocked = not unlocked;
  if not unlocked then
    FAB_Mover:SetHidden(true);
    FAB_Mover:SetMovable(false);
    FAB_Mover:SetMouseEnabled(false);
    ReanchorMover();
  else
    -- RefreshMoverSize()
    SaveCurrentLocation();
    FAB_Mover:SetHidden(false);
    FAB_Mover:SetMovable(true);
    FAB_Mover:SetMouseEnabled(true);
  end;
  local l = unlocked and "Lock Actionbar" or "Unlock Actionbar";
  WINDOW_MANAGER:GetControlByName("FAB_AB_Move").button:SetText(l);
end;

function FancyActionBar.MoveActionBar()
  local v, _ = FancyActionBar:GetMovableVarsForUI();

  if v.enable then
    ACTION_BAR:ClearAnchors();
    ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, v.x, v.y);
    FancyActionBar.SetMoved(true);
  else
    if FancyActionBar.wasMoved then
      ACTION_BAR:ClearAnchors();
      ACTION_BAR:SetAnchor(BOTTOM, FAB_Default_Bar_Position, BOTTOM, 0, 0);
      FancyActionBar.SetMoved(false);
    end;
  end;
end;

function FancyActionBar.SaveGCDPosition()
  SV.gcd.x = FAB_GCD:GetLeft();
  SV.gcd.y = FAB_GCD:GetTop();
end;

function FancyActionBar.SaveMoverPosition()
  local x = FAB_Mover:GetLeft();
  local y = FAB_Mover:GetTop();

  if FancyActionBar.style == 2
  then
    SV.abMove.gp.x = x; SV.abMove.gp.y = y;
  else
    SV.abMove.kb.x = x; SV.abMove.kb.y = y;
  end;

  FancyActionBar.constants.move.x = x;
  FancyActionBar.constants.move.y = y;

  if Azurah then
    if ((FancyActionBar.style == 2 and Azurah.db.uiData.gamepad["ZO_ActionBar1"])
        or (FancyActionBar.style == 1 and Azurah.db.uiData.keyboard["ZO_ActionBar1"]))
    then
      Azurah:RecordUserData("ZO_ActionBar1", TOPLEFT, x, y, FancyActionBar.GetScale());
    end;
  end;

  if BUI and BUI.Vars["ZO_ActionBar1"] then
    BUI.Vars["ZO_ActionBar1"][1] = TOPLEFT;
    BUI.Vars["ZO_ActionBar1"][2] = TOPLEFT;
    BUI.Vars["ZO_ActionBar1"][3] = x;
    BUI.Vars["ZO_ActionBar1"][4] = y;
  end;

  if LUIE and LUIE.SV["ZO_ActionBar1"] then
    LUIE.SV["ZO_ActionBar1"][1] = x;
    LUIE.SV["ZO_ActionBar1"][2] = y;
  end;

  ACTION_BAR:ClearAnchors();
  ACTION_BAR:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, y);
  FancyActionBar.SetMoved(true);
end;

local function PlayerDeath(oldState, newState)
  if newState == SCENE_SHOWN then
    ACTION_BAR:SetHidden(false);
  else
    if not inMenu and IsUnitDead("player") then
      ACTION_BAR:SetHidden(true);
    end;
  end;
end;

function FancyActionBar.ApplyDeathStateOption()
  -- ZO_PreHookHandler(ZO_Death, 'OnShow', PlayerDeath)

  DEATH_FRAGMENT:UnregisterCallback("StateChange");

  if SV.showDeath then
    DEATH_FRAGMENT:RegisterCallback("StateChange", PlayerDeath);
  end;
end;

function FancyActionBar.UpdateScale(s)
  local scale = s;
  ACTION_BAR:SetScale(scale);
  RefreshMoverSize();
end;
