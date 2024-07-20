---@class (partial) FancyActionBar
local FancyActionBar = FancyActionBar;

local EM = GetEventManager();
local WM = GetWindowManager();
local SM = SCENE_MANAGER;
local NAME;
local SV;
local time = GetFrameTimeSeconds;
local currentTarget = { name = ""; id = 0 };
local activeTargetDebuffs = {};

---@param msg string
---@param ... any
local function Chat(msg, ...)
  FancyActionBar.Chat(msg, ...);
end;


local groupUnit =
{
  ["group1"] = true;
  ["group2"] = true;
  ["group3"] = true;
  ["group4"] = true;
  ["group5"] = true;
  ["group6"] = true;
  ["group7"] = true;
  ["group8"] = true;
  ["group9"] = true;
  ["group10"] = true;
  ["group11"] = true;
  ["group12"] = true;
};
---------------------------------
-- Debug
---------------------------------
local function OnNewTarget()
  local tag = "reticleover";

  local name = zo_strformat("<<t:1>>", GetUnitName(tag));
  Chat(name .. " -> " .. GetUnitType(tag) .. " -> " .. GetUnitNameHighlightedByReticle());
end;

-- /script zo_callLater(function() Chat(tostring(GetUnitType('reticleover'))) end, 2000)
local function PostReticleTargetInfo(uName, eName, gain, fade, eSlot, stacks, icon, bType, eType, aType, seType, aId, canClickOff, castByPlayer)
  -- if aType == 0 then return end -- passives (annoying when bar swapping)

  local ts = tostring;
  local dur, s;
  if (fade ~= nil and gain ~= nil) then
    dur = string.format(" %0.1f", fade - gain) .. "s";
  else
    dur = 0;
  end;

  if (stacks and stacks > 0)
  then
    s = " x" .. ts(stacks) .. ".";
  else
    s = ".";
  end;

  Chat(eName .. " (" .. ts(aId) .. ")" .. " || stacks: " .. ts(stacks) .. " || duration: " .. ts(dur) .. " || slot: " .. ts(eSlot) .. " || unit: " .. ts(uName) .. " || effectType: " .. ts(eType) .. " || abilityType: " .. ts(aType) .. " || statusEffectType: " .. ts(seType) .. "\n===================");
end;
---------------------------------
-- Checking
---------------------------------
function FancyActionBar.IsAbilityActiveOnCurrentTarget(id)
  if not FancyActionBar.HasEnemyTarget() then return false; end;

  local isActive = false;
  local nBuffs = GetNumBuffs("reticleover");
  local data = { endTime = 0; stacks = 0 };

  if nBuffs > 0 then
    for i = 1, nBuffs do
      local _, _, endTime, _, stacks, _, _, _, _, _, abilityId, _, castByPlayer = GetUnitBuffInfo("reticleover", i);
      if abilityId == id and (castByPlayer or stacks) then
        isActive = true;
        data.endTime = endTime;
        data.stacks = stacks or 0;
        break;
      end;
    end;
  end;

  if isActive
  then
    return true, data;
  else
    return false;
  end;
end;

-- function FancyActionBar.IsToggled(id)
--   return toggled[id] and true or false
-- end

function FancyActionBar.IsGroupUnit(tag)
  if tag == nil or tag == "" then return false; end;
  if groupUnit[tag] ~= nil then return true; else return false; end;
end;

function FancyActionBar.IsPlayer(tag, name)
  if tag == nil or tag == "" then return false; end;
  if AreUnitsEqual("player", tag) then return true; end;
  return false;
end;

function FancyActionBar.IsEnemy(tag, id)
  if FancyActionBar.IsGroupUnit(tag) then return false; end;

  local isEnemy = false;

  if tag ~= nil and tag ~= "" then
    if GetUnitType(tag) == 12 then
      isEnemy = true; -- target dummy
    else
      local reaction = GetUnitReaction(tag);
      if (reaction == 1) then isEnemy = true; end;
    end;
  end;
  return isEnemy;
end;

function FancyActionBar.IsLocalPlayerOrEnemy(tag, name, id)
  if FancyActionBar.IsEnemy(tag) then return true; end;
  if FancyActionBar.IsPlayer(tag) then return true; end;
  return false;
end;

function FancyActionBar.HasEnemyTarget()
  local tag = "reticleover";

  if (DoesUnitExist(tag) and not IsUnitDead(tag)) then
    if FancyActionBar.IsEnemy(tag, nil) then return true; end;
  end;
  return false;

  -- return (currentTarget.name == '') and false or true
end;

---------------------------------
-- Tracking
---------------------------------

local function ClearTargetEffects()
  for debuffId, debuff in pairs(FancyActionBar.debuffs) do
    local doStackUpdate = false;
    if FancyActionBar.stacks[debuff.id] then
      FancyActionBar.stacks[debuff.id] = 0;
      doStackUpdate = true;
    end;

    if FancyActionBar.debuffStackMap[debuff.stackId] and FancyActionBar.stacks[debuff.stackId] then
      FancyActionBar.stacks[debuff.stackId] = 0;
      doStackUpdate = true;
    end;

    for effectId, effect in pairs(FancyActionBar.effects) do
      if debuff.id == effect.id then
        effect.endTime = time();
      end;
      FancyActionBar.UpdateEffect(effect);
      if doStackUpdate then
        FancyActionBar.HandleStackUpdate(debuff.id);
      end;
    end;
  end;
end;

local function ClearDebuffsIfNotOnTarget()
  for id, debuff in pairs(FancyActionBar.debuffs) do
    if not debuff.keepOnTargetChange then
      debuff.activeOnTarget = false;
      debuff.endTime = 0;
      debuff.stacks = 0;
      local doStackUpdate = false;

      if FancyActionBar.stacks[debuff.id] then
        FancyActionBar.stacks[debuff.id] = 0;
        doStackUpdate = true;
      end;

      if FancyActionBar.debuffStackMap[debuff.stackId] and FancyActionBar.stacks[debuff.stackId] then
        FancyActionBar.stacks[debuff.stackId] = 0;
        doStackUpdate = true;
      end;

      for id, effect in pairs(FancyActionBar.effects) do
        if effect.stackId and effect.stackId == debuff.id then
          doStackUpdate = true;
        end;
        if debuff.id == effect.id then
          for i, x in pairs(debuff) do effect[i] = x; end;
          effect.endTime = time();
        end;
        FancyActionBar.UpdateEffect(effect);
        if doStackUpdate then
          FancyActionBar.HandleStackUpdate(effect.id);
        end;
      end;
    end;
  end;
end;

local function ClearDebuffs(keep)
  -- Implement ability to keep certain debuffs with specialEffect properties
  ClearTargetEffects();

  -- Iterate over all debuffs
  for id, debuff in pairs(FancyActionBar.debuffs) do
    -- Check if the debuff has specialEffect properties and should be kept
    if FancyActionBar.specialEffects[debuff.id] and keep[debuff.id] then
      -- Retain the debuff
      FancyActionBar.debuffs[debuff.id] = debuff;
    else
      -- Remove the debuff
      FancyActionBar.debuffs[debuff.id] = nil;
    end;
  end;

  activeTargetDebuffs = {};
end;

local numEffects = 0;

---@return table debuffs
---@return number debuffNum
local function GetTargetEffects()
  local tag = "reticleover";

  numEffects = GetNumBuffs(tag);

  local debuffs = {};
  local debuffNum = 0;

  if numEffects <= 0 then
    ---@diagnostic disable-next-line: return-type-mismatch
    return nil, 0;
  else
    for i = 1, numEffects do
      local abilityName, beginTime, endTime, buffSlot, stacks, icon, _, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo(tag, i);

      if castByPlayer or (FancyActionBar.allowExternalStacks[abilityId]) then
        -- PostReticleTargetInfo(name, abilityName, beginTime, endTime, buffSlot, stacks, icon, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer)

        debuffNum = debuffNum + 1;
        local db =
        {
          id = abilityId;
          beginTime = beginTime or 0;
          endTime = endTime or 0;
          stacks = stacks or 0;
          name = abilityName;
          slot = buffSlot;
          icon = icon;
          effectType = effectType;
          abilityType = abilityType;
          statusEffectType = statusEffectType;
          canClickOff = canClickOff;
          castByPlayer = castByPlayer;
        };
        table.insert(debuffs, db);
      end;
    end;
  end;
  return debuffs, debuffNum;
end;

local function UpdateDebuff(debuff, stacks, unitId, isTarget)
  -- TODO: If unitUpdating is the final instance then don't return
  local unitUpdating;
  if isTarget == false then
    local activeDebuffs = activeTargetDebuffs[debuff.id];
    if activeDebuffs then
      for debuffUnitId, beginTime in pairs(activeDebuffs) do
        if debuff.beginTime == beginTime then
          unitUpdating = debuffUnitId;
          break;
        end;
      end;
      if unitId ~= unitUpdating then return; end;
    end;
  end;

  if not debuff then return; end;
  local t = time();
  debuff.stackId = debuff.stackId or debuff.id;
  if FancyActionBar.debuffStackMap[debuff.stackId] or (debuff.isSpecialDebuff and stacks) then
    if (not SV.showOvertauntStacks) and debuff.id == 52790 then
    else
      FancyActionBar.stacks[debuff.stackId] = stacks;
    end;
  end;

  for id, effect in pairs(FancyActionBar.effects) do
    if effect.id == debuff.id then
      for dId, dEffect in pairs(debuff) do effect[dId] = dEffect; end;
      FancyActionBar.effects[id] = effect;
      if effect.stackId then
        FancyActionBar.HandleStackUpdate(id);
      end;
      FancyActionBar.UpdateEffect(effect);
    end;
  end;
end;

local function OnReticleTargetChanged()
  local tag = "reticleover";

  if (DoesUnitExist(tag) and not IsUnitDead(tag)) then
    if not FancyActionBar.IsEnemy(tag) then return; end; -- GetUnitType(tag), GetUnitNameHighlightedByReticle()

    local name = zo_strformat("<<t:1>>", GetUnitName(tag));
    local tId = 0;
    local keep = {};

    currentTarget.name = name;

    local debuffs, debuffNum = GetTargetEffects();

    if debuffNum > 0 then
      for i = 1, debuffNum do
        local debuff = debuffs[i];
        local effect = FancyActionBar.effects[debuff.id];
        if effect then
          for dId, dEffect in pairs(debuff) do effect[dId] = dEffect; end;
          debuff = effect;
        end;
        for stackSourceId, targetIds in pairs(FancyActionBar.debuffStackMap) do
          for t = 1, #targetIds do
            if targetIds[t] == debuff.id then
              debuff.stackId = stackSourceId;
            end;
          end;
        end;
        local specialEffect = (FancyActionBar.specialEffects[debuff.id]
          and ZO_DeepTableCopy(FancyActionBar.specialEffects[debuff.id]));
        keep[debuff.id] = true; -- make sure we're keeping the debuff in case the specialEffect changes the id
        if specialEffect then
          for sId, effect in pairs(specialEffect) do debuff[sId] = effect; end;
          if specialEffect.fixedTime then
            debuff.endTime = debuff.beginTime + specialEffect.duration;
          end;
          keep[debuff.id] = true; -- keep the debuff.id after pushing all the special effect properties
        else
          debuff.stacks = FancyActionBar.stacks[debuff.stackId] or debuff.stacks;
        end;

        debuff.duration = debuff.endTime - debuff.beginTime;
        FancyActionBar.debuffs[debuff.id] = debuff;
        FancyActionBar.debuffs[debuff.id].activeOnTarget = true;
        FancyActionBar.debuffs[debuff.id].endTime = debuff.endTime;
        UpdateDebuff(debuff, debuff.stacks, tId, true);
      end;
    end;

    for id, debuff in pairs(FancyActionBar.debuffs) do
      if debuff.keepOnTargetChange then return; end;
      if keep[debuff.id] == nil then -- update debuffs that are not active on the target according to settings.
        debuff.activeOnTarget = false;
        debuff.endTime = 0;
        UpdateDebuff(FancyActionBar.debuffs[id], 0, tId, true);
      end;
    end;
    -- OnNewTarget()
  else
    currentTarget = { name = ""; id = 0 };
    if SV.keepLastTarget == false then
      ClearDebuffsIfNotOnTarget();
    end;
  end;
end;

function FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, beginTime, endTime, unitId)
  if (change == EFFECT_RESULT_FADED) then
    if FancyActionBar.targets[debuff.id] and FancyActionBar.targets[debuff.id].times[unitId] then
      local targetData = FancyActionBar.targets[debuff.id];
      targetData.targetCount = (targetData.targetCount - 1);
      targetData.times[unitId] = nil;
      FancyActionBar.targets[debuff.id] = targetData;
      FancyActionBar.HandleTargetUpdate(debuff.id);
      if targetData.targetCount >= 1 then
        return;
      end;
    end;
  end;
end;

function FancyActionBar.OnDebuffChanged(debuff, t, eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
  local tag = "";
  if unitTag ~= nil and unitTag ~= "" then tag = unitTag; end;

  -- if ((effect.activeOnTarget and tag ~= 'reticleover') or (not effect.activeOnTarget and effect.hideOnNoTarget)) then
  --   FancyActionBar:dbg(1, '<<1>> duration <<2>>s ignored on: <<3>>.', effectName, string.format(' %0.1f', endTime - t), tag )
  --   return
  -- end

  local specialEffect = (FancyActionBar.specialEffects[abilityId]
    and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId]));
  if specialEffect then
    debuff = FancyActionBar.debuffs[specialEffect.id] or debuff;
  end;

  if SV.keepLastTarget == false and tag ~= "reticleover" and not debuff.keepOnTargetChange then
    if FancyActionBar.multiTarget[debuff.id] then
      FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, beginTime, endTime, unitId);
    end;
    return;
  end;

  for stackSourceId, targetIds in pairs(FancyActionBar.debuffStackMap) do
    for i = 1, #targetIds do
      if targetIds[i] == abilityId then
        debuff.stackId = stackSourceId;
      end;
    end;
  end;

  if change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED then
    if specialEffect then
      for sId, effect in pairs(specialEffect) do debuff[sId] = effect; end;
      if specialEffect.fixedTime then
        endTime = t + specialEffect.duration;
      end;
      if specialEffect.stacks then
        stackCount = specialEffect.stacks;
      else
        if debuff.id == debuff.stackId then
          stackCount = stackCount or 1;
        end;
      end;
    else
      stackCount = FancyActionBar.stacks[debuff.stackId] or stackCount;
    end;

    debuff.beginTime = (beginTime and beginTime ~= 0 and beginTime) or t;
    debuff.endTime = endTime;
    debuff.duration = endTime - beginTime;
    FancyActionBar.debuffs[debuff.id] = debuff;

    if FancyActionBar.multiTarget[debuff.id] then
      local targetData = FancyActionBar.targets[debuff.id] or { targetCount = 0; maxEndTime = 0; times = {} };
      if change == EFFECT_RESULT_GAINED and not targetData.times[unitId] then
        targetData.targetCount = (targetData.targetCount + 1);
      end;
      targetData.maxEndTime = math.max(endTime, targetData.maxEndTime);
      targetData.times[unitId] = { beginTime = debuff.beginTime; endTime = endTime };
      FancyActionBar.targets[debuff.id] = targetData;
      FancyActionBar.HandleTargetUpdate(debuff.id);
    end;

    if FancyActionBar.activeCasts[debuff.id] then FancyActionBar.activeCasts[debuff.id].begin = debuff.beginTime; end;

    if (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax) or (debuff.duration > FancyActionBar.durationMin) then
      activeTargetDebuffs = { [debuff.id] = { [unitId] = debuff.beginTime } };
      UpdateDebuff(debuff, stackCount, unitId, false);
    else
      FancyActionBar:dbg(1, "<<1>> duration <<2>>s ignored.", effectName, string.format(" %0.1f", endTime - t));
    end;
  elseif (change == EFFECT_RESULT_FADED) then
    if FancyActionBar.targets[debuff.id] and FancyActionBar.targets[debuff.id].times[unitId] then
      local targetData = FancyActionBar.targets[debuff.id];
      targetData.targetCount = (targetData.targetCount - 1);
      targetData.times[unitId] = nil;
      FancyActionBar.targets[debuff.id] = targetData;
      FancyActionBar.HandleTargetUpdate(debuff.id);
      if targetData.targetCount >= 1 then
        return;
      end;
    end;

    if debuff.beginTime and (t - debuff.beginTime < 0.3) and (not debuff.instantFade) then return; end;

    if specialEffect then
      if (debuff.hasProced and (debuff.hasProced > specialEffect.hasProced)) then
        return; -- we don't need to worry about this effect anymore because it has already proced
      elseif FancyActionBar.specialEffectProcs[abilityId] then
        local procUpdates = FancyActionBar.specialEffectProcs[abilityId];
        local procValues = procUpdates[debuff.procs or specialEffect.procs];
        for i, x in pairs(procValues) do debuff[i] = x; end;
        stackCount = debuff.stacks or stackCount;
      end;
    else
      stackCount = math.max((FancyActionBar.stacks[debuff.stackId] or 1) - stackCount, 0);
    end;
    if debuff.instantFade then
      debuff.endTime = 0;
    end;
    UpdateDebuff(debuff, stackCount, unitId, false);
    activeTargetDebuffs = { [debuff.id] = { [unitId] = nil } };
  end;
end;

local function OnDebuffStacksChanged(_, change, _, _, unitTag, _, _, stackCount, _, _, effectType, _, _, unitName, unitId, abilityId)
  if (not SV.showOvertauntStacks) and abilityId == 52790 then return; end;

  for debuffId, debuff in pairs(FancyActionBar.debuffs) do
    if abilityId == debuff.stackId then
      UpdateDebuff(debuff, stackCount or 0, unitId, false);
    end;
  end;
end;

-- function FancyActionBar.OnDebuffTargetDeath( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
--
--   if targetUnitId == nil or targetUnitId == 0 then return end
--
--   if result ~= ACTION_RESULT_DIED and result ~= ACTION_RESULT_DIED_XP then return end
--
-- end

local function ClearDebuffsOnCombatEnd()
  local t = time();
  local keep = {};
  if not IsUnitInCombat("player") then
    for i, debuff in pairs(FancyActionBar.debuffs) do
      FancyActionBar.targets[debuff.id] = nil;
      local specialEffect = FancyActionBar.specialEffects[debuff.id];
      if (specialEffect and specialEffect.fixedTime) and (debuff.endTime and debuff.endTime > t) then
        keep[i] = true;
      else
        debuff.endTime = 0;
        UpdateDebuff(debuff, 0, 0, nil);
      end;
      ClearDebuffs(keep);
    end;
  end;
end;

function FancyActionBar:UpdateDebuffTracking()
  ClearDebuffs();


  -- EVENT_TARGET_CHANGED (number eventCode, string unitTag)
  -- EVENT_RETICLE_TARGET_CHANGED (number eventCode)
  -- EVENT_RETICLE_TARGET_PLAYER_CHANGED (number eventCode)
  EM:UnregisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED);
  EM:UnregisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE);
  -- EM:UnregisterForEvent(NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT)
  -- EM:UnregisterForEvent(NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT)

  if SV.advancedDebuff then
    EM:RegisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE, ClearDebuffsOnCombatEnd);
    EM:RegisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged);

    -- EM:RegisterForEvent(  NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT, FancyActionBar.OnDebuffTargetDeath )
    -- EM:AddFilterForEvent( NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED,    REGISTER_FILTER_IS_ERROR, false )
    --
    -- EM:RegisterForEvent(  NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT, FancyActionBar.OnDebuffTargetDeath )
    -- EM:AddFilterForEvent( NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED_XP, REGISTER_FILTER_IS_ERROR, false )
    for id in pairs(FancyActionBar.debuffStackMap) do
      EM:RegisterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, OnDebuffStacksChanged);
      EM:AddFilterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id);
    end;
  end;
end;

function FancyActionBar:InitializeDebuffs(name, sv)
  NAME = name;
  SV = sv;
  FancyActionBar:UpdateDebuffTracking();
end;
