--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar

local EM = GetEventManager()
local WM = GetWindowManager()
local SM = SCENE_MANAGER
local GROUND_EFFECT = ABILITY_TYPE_AREAEFFECT
local NAME = FancyActionBar.GetName()
local SV = ...
local time = GetGameTimeSeconds
local registeredDebuffStackEvents = {}

local function SyncDebuffStackSources(effect, abilityId)
    -- Use unified stack source logic, debuff mode
    local effectStackSourceIds = FancyActionBar.GetConfiguredStackSources(effect.id, "debuff")
    local abilityStackSourceIds = FancyActionBar.GetConfiguredStackSources(abilityId, "debuff")
    local stackSources = {}
    local seenStackSourceIds = {}

    -- Always add effectStackSourceIds first (primary effect's sources)
    for i = 1, #effectStackSourceIds do
        local sourceId = effectStackSourceIds[i]
        if sourceId and not seenStackSourceIds[sourceId] then
            stackSources[#stackSources + 1] = sourceId
            seenStackSourceIds[sourceId] = true
        end
    end

    -- If abilityId ~= effect.id, add only debuffStackMap sources from abilityStackSourceIds
    if abilityId ~= effect.id then
        for i = 1, #abilityStackSourceIds do
            local sourceId = abilityStackSourceIds[i]
            if not seenStackSourceIds[sourceId] then
                stackSources[#stackSources + 1] = sourceId
                seenStackSourceIds[sourceId] = true
            end
        end
    end

    local hasExternalStackSources = #stackSources > 0
    if not hasExternalStackSources then
        stackSources = { effect.id }
        if abilityId ~= effect.id then
            stackSources[2] = abilityId
        end
    end

    effect.stackSources = stackSources
    effect.hasExternalStackSources = hasExternalStackSources
    effect.stackId = stackSources

    return stackSources, hasExternalStackSources
end

local function ResolveDebuffDisplayStacks(effect, fallbackStacks)
    if not effect then
        return fallbackStacks or 0
    end

    if effect.hasExternalStackSources then
        return FancyActionBar.ResolveStacksForEffect(effect, time())
    end

    if fallbackStacks ~= nil then
        return fallbackStacks
    end

    return FancyActionBar.ResolveStacksForEffect(effect, time())
end

local function ShouldClearExternalDebuffStacksOnTargetChange(effect)
    if not effect or not effect.hasExternalStackSources then
        return true
    end

    local sourceIds = effect.stackSources or effect.stackId
    if not sourceIds then
        return true
    end

    local stackableBuff = FancyActionBar.stackableBuff
    local effects = FancyActionBar.effects
    for i = 1, #sourceIds do
        local sourceId = sourceIds[i]
        local trackedSourceId = (stackableBuff and stackableBuff[sourceId]) or sourceId
        local sourceEffect = effects and effects[trackedSourceId]

        if sourceEffect and not sourceEffect.isDebuff then
            return false
        end

        if FancyActionBar.stackMap[trackedSourceId] ~= nil and FancyActionBar.debuffStackMap[trackedSourceId] == nil then
            return false
        end
    end

    return true
end

local function HasDebuffStackTargets(abilityId)
    return FancyActionBar.fixedStacks[abilityId] ~= nil or #FancyActionBar.GetConfiguredStackSources(abilityId) > 0
end

local groupUnit =
{
    ["group1"] = true,
    ["group2"] = true,
    ["group3"] = true,
    ["group4"] = true,
    ["group5"] = true,
    ["group6"] = true,
    ["group7"] = true,
    ["group8"] = true,
    ["group9"] = true,
    ["group10"] = true,
    ["group11"] = true,
    ["group12"] = true,
}

---------------------------------
-- Checking
---------------------------------
function FancyActionBar.IsAbilityActiveOnCurrentTarget(id)
    if not FancyActionBar.HasEnemyTarget() then
        return false
    end

    local isActive = false
    local nBuffs = GetNumBuffs("reticleover")
    local data = { endTime = 0, stacks = 0 }

    if nBuffs > 0 then
        for i = 1, nBuffs do
            local _, _, endTime, _, stacks, _, _, _, _, _, abilityId, _, castByPlayer = GetUnitBuffInfo("reticleover", i)
            if abilityId == id and (castByPlayer or stacks > 0) then
                isActive = true
                data.endTime = endTime
                data.stacks = stacks or 0
                break
            end
        end
    end

    if isActive
    then
        return true, data
    else
        return false
    end
end

-- function FancyActionBar.IsToggled(id)
--   return toggled[id] and true or false
-- end

function FancyActionBar.IsGroupUnit(tag)
    if tag == nil or tag == "" then
        return false
    end
    if groupUnit[tag] ~= nil then
        return true
    else
        return false
    end
end

function FancyActionBar.IsPlayer(tag, name)
    if tag == nil or tag == "" then
        return false
    end
    if AreUnitsEqual("player", tag) then
        return true
    end
    return false
end

function FancyActionBar.IsEnemy(tag, id)
    if FancyActionBar.IsGroupUnit(tag) then
        return false
    end

    local isEnemy = false

    if tag ~= nil and tag ~= "" then
        if GetUnitType(tag) == 12 then
            isEnemy = true -- target dummy
        else
            local reaction = GetUnitReaction(tag)
            if (reaction == 1) then
                isEnemy = true
            end
        end
    end
    return isEnemy
end

function FancyActionBar.IsLocalPlayerOrEnemy(tag, name, id)
    if FancyActionBar.IsEnemy(tag) then
        return true
    end
    if FancyActionBar.IsPlayer(tag) then
        return true
    end
    return false
end

function FancyActionBar.IsPlayerPet(tag)
    for i = 1, MAX_PET_UNIT_TAGS do
        if tag == "playerpet" .. i then
            return true
        end
    end
    return false
end

function FancyActionBar.HasEnemyTarget()
    local tag = "reticleover"

    if (DoesUnitExist(tag) and not IsUnitDead(tag)) then
        if FancyActionBar.IsEnemy(tag, nil) then
            return true
        end
    end
    return false
end

---------------------------------
-- Tracking
---------------------------------

local function ClearTargetEffects()
    -- Clear all effects that were previously marked as debuffs
    for effectId, effect in pairs(FancyActionBar.effects) do
        if effect and effect.isDebuff then
            -- reset stacks and update visuals
            if effect.stacks and effect.stacks ~= 0 then
                FancyActionBar.SetStacks(effect.id, 0, true)
            end
            effect.endTime = time()
            FancyActionBar.UpdateEffect(effect)
        end
    end
end

local function ClearDebuffsIfNotOnTarget()
    -- For each tracked effect that is a debuff, clear it unless it should be kept
    for _, effect in pairs(FancyActionBar.effects) do
        if effect and effect.isDebuff and not effect.keepOnTargetChange then
            effect.activeOnTarget = false
            effect.endTime = 0
            if ShouldClearExternalDebuffStacksOnTargetChange(effect) and effect.stacks and effect.stacks ~= 0 then
                FancyActionBar.SetStacks(effect.id, 0, true)
            end
            FancyActionBar.UpdateEffect(effect)
        end
    end
end

local function ClearDebuffs(keep)
    -- Implement ability to keep certain debuffs with specialEffect properties
    ClearTargetEffects()
    -- Iterate over all debuffs
    -- for id, debuff in pairs(FancyActionBar.debuffs) do
    -- Check if the debuff has specialEffect properties and should be kept
    -- if FancyActionBar.specialEffects[debuff.id] and keep[debuff.id] then
    -- Retain the debuff
    --   FancyActionBar.debuffs[debuff.id] = debuff;
    -- else
    -- Remove the debuff
    --     FancyActionBar.debuffs[debuff.id] = nil;
    --   end;
    -- end;
    for id, effect in pairs(FancyActionBar.effects) do
        if effect and effect.isDebuff then
            effect.isDebuff = nil
            -- also clear debuff-side active-cast marker to avoid stale state
            effect.hasActiveCast = nil
            FancyActionBar.UpdateEffect(effect)
        end
    end
end
function FancyActionBar.UpdateDebuff(debuff, stacks, sourceAbilityId)
    if not debuff then return end

    sourceAbilityId = sourceAbilityId or debuff.id

    local effect = FancyActionBar.effects[debuff.id] or { id = debuff.id }
    for dId, dEffect in pairs(debuff) do
        effect[dId] = dEffect
    end
    effect.id = debuff.id
    effect.isDebuff = true
    effect.hasActiveCast = debuff.hasActiveCast or false

    if FancyActionBar.specialEffects[debuff.id] ~= nil then
        effect.stackSources = effect.stackId or effect.stackSources or { effect.id }
        effect.hasExternalStackSources = false
    else
        SyncDebuffStackSources(effect, sourceAbilityId)
    end

    local nextStacks = ResolveDebuffDisplayStacks(effect, stacks)
    if debuff.id == 52790 and SV.showOvertauntStacks then
        nextStacks = stacks
    end
    if nextStacks ~= nil then
        effect.stacks = nextStacks
    end

    FancyActionBar.effects[debuff.id] = effect
    FancyActionBar.SetStacks(effect.id, effect.stacks, effect.hasExternalStackSources)
    FancyActionBar.UpdateEffect(effect)
end

local function OnReticleTargetChanged()
    local tag = "reticleover"

    if (DoesUnitExist(tag) and not IsUnitDead(tag)) then
        if not FancyActionBar.IsEnemy(tag) then
            return
        end

        local keep = {}

        local nBuffs = GetNumBuffs(tag)
        if nBuffs and nBuffs > 0 then
            for i = 1, nBuffs do
                local abilityName, beginTime, endTime, buffSlot, stacks, icon, _, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo(tag, i)
                if castByPlayer or (FancyActionBar.allowExternalStacks[abilityId]) then
                    local effect = FancyActionBar.effects[abilityId] or { id = abilityId }
                    effect.id = abilityId
                    effect.beginTime = beginTime or 0
                    effect.endTime = endTime or 0
                    effect.duration = (effect.endTime or 0) - (effect.beginTime or 0)
                    effect.name = abilityName
                    effect.hasActiveCast = castByPlayer
                    effect.activeOnTarget = true
                    effect.isDebuff = true
                    FancyActionBar.effects[effect.id] = effect
                    keep[effect.id] = true

                    local specialEffect = (FancyActionBar.specialEffects[effect.id] and ZO_DeepTableCopy(FancyActionBar.specialEffects[effect.id]))
                    if specialEffect then
                        for sId, sEffect in pairs(specialEffect) do
                            effect[sId] = sEffect
                        end
                        if specialEffect.setTime then
                            effect.endTime = effect.beginTime + specialEffect.duration
                        end
                        keep[effect.id] = true
                    else
                        SyncDebuffStackSources(effect, abilityId)
                        if effect.hasExternalStackSources or HasDebuffStackTargets(abilityId) then
                            FancyActionBar.UpdateStacksFromEvent(abilityId, stacks, false)
                        end
                        effect.stacks = ResolveDebuffDisplayStacks(effect, stacks or 0)
                    end

                    FancyActionBar.UpdateDebuff(effect, effect.stacks, abilityId)
                end
            end
        end

        -- Clear any previously-known debuffs that are no longer on the reticle
        for id, effect in pairs(FancyActionBar.effects) do
            if effect and effect.isDebuff and not effect.keepOnTargetChange and not keep[id] then
                if ShouldClearExternalDebuffStacksOnTargetChange(effect) and (effect.hasExternalStackSources or HasDebuffStackTargets(effect.id)) then
                    FancyActionBar.UpdateStacksFromEvent(effect.id, nil, true)
                end
                effect.activeOnTarget = false
                effect.endTime = 0
                FancyActionBar.UpdateDebuff(effect, ResolveDebuffDisplayStacks(effect, 0))
            end
        end
    else
        if SV.keepLastTarget == false then
            ClearDebuffsIfNotOnTarget()
        end
    end
end

function FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, currentTime, beginTime, endTime, unitKey, abilityType)
    if (change == EFFECT_RESULT_GAINED) or (change == EFFECT_RESULT_UPDATED) then
        local effect = FancyActionBar.effects[debuff.id] or { id = debuff.id }
        effect.id = debuff.id
        FancyActionBar.EnsureUnits(effect, "targets")
        effect.isDebuff = true
        FancyActionBar.effects[debuff.id] = effect

        -- Do not record per-unit targets for ground/area effects.
        if unitKey and abilityType ~= GROUND_EFFECT then
            FancyActionBar.RecordUnit(debuff.id, effect, unitKey, currentTime, beginTime, endTime, "targets")
            FancyActionBar.UpdateEffect(effect)
        end
        return
    elseif (change == EFFECT_RESULT_FADED) then
        local targets = FancyActionBar.GetUnits(debuff.id, "targets")
        if targets and targets.times and unitKey and targets.times[unitKey] then
            FancyActionBar.RemoveUnit(debuff.id, unitKey, currentTime, "targets")
            FancyActionBar.UpdateEffect(FancyActionBar.effects[debuff.id])
        end
    end
end

function FancyActionBar.OnDebuffChanged(debuff, t, eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    local _
    local tag = ""
    if unitTag ~= nil and unitTag ~= "" then
        tag = unitTag
    end
    -- if ((effect.activeOnTarget and tag ~= 'reticleover') or (not effect.activeOnTarget and effect.hideOnNoTarget)) then
    --   FancyActionBar.AddSystemMessage(1, '<<1>> duration <<2>>s ignored on: <<3>>.', effectName, string.format(' %0.1f', endTime - t), tag )
    --   return
    -- end

    local specialEffect = (FancyActionBar.specialEffects[abilityId]
        and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId]))
    if specialEffect then
        debuff = FancyActionBar.effects and FancyActionBar.effects[specialEffect.id] or debuff
    end

    if SV.keepLastTarget == false and tag ~= "reticleover" and not debuff.keepOnTargetChange then
        if not SV.multiTargetBlacklist[debuff.id] then
            local unitKey = unitId ~= 0 and unitId or nil
            FancyActionBar.UpdateMultiTargetDebuffs(FancyActionBar.effects[debuff.id] or debuff, change, t, beginTime, endTime, unitKey, abilityType)
        end
        return
    end

    if specialEffect then
        debuff.stackSources = debuff.stackId or debuff.stackSources or { abilityId }
        debuff.hasExternalStackSources = false
    else
        SyncDebuffStackSources(debuff, abilityId)
    end

    if change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED then
        if specialEffect then
            for sId, effect in pairs(specialEffect) do
                debuff[sId] = effect
            end
            if specialEffect.setTime then
                endTime = t + specialEffect.duration
            end
            if specialEffect.stacks then
                stackCount = specialEffect.stacks
            end
        elseif (stackCount and stackCount > 0) or HasDebuffStackTargets(abilityId) then
            FancyActionBar.UpdateStacksFromEvent(abilityId, stackCount, false)
            stackCount = ResolveDebuffDisplayStacks(debuff, stackCount or 0)
        end

        debuff.beginTime = (beginTime and beginTime ~= 0 and beginTime) or t
        debuff.endTime = endTime
        debuff.duration = endTime - beginTime


        local effect = FancyActionBar.effects[debuff.id] or { id = debuff.id }
        for k, v in pairs(debuff) do effect[k] = v end
        effect.isDebuff = true
        FancyActionBar.effects[debuff.id] = effect
        FancyActionBar.SetStacks(effect.id, effect.stacks)

        if not SV.multiTargetBlacklist[debuff.id] then
            local unitKey = unitId ~= 0 and unitId or nil
            FancyActionBar.UpdateMultiTargetDebuffs(effect, change, t, beginTime, endTime, unitKey, abilityType)
        end

        if (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax) or (debuff.duration > FancyActionBar.durationMin) then
            -- Use canonical per-target tracking via FancyActionBar.RecordUnit/GetUnit
            FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
        end
    elseif (change == EFFECT_RESULT_FADED) then
        local td = FancyActionBar.GetUnits(debuff.id, "targets")
        local unitKey = unitId ~= 0 and unitId or nil
        if td and td.times and td.times[unitKey] then
            local targetCount = FancyActionBar.RemoveUnit(debuff.id, unitKey, t, "targets")
            if targetCount >= 1 then
                FancyActionBar.UpdateEffect(FancyActionBar.effects[debuff.id])
                FancyActionBar.HandleTargetUpdate(debuff.id)
                return
            end
        end

        if debuff.beginTime and (t - debuff.beginTime < 0.3) and (not debuff.instantFade) then
            return
        end

        if specialEffect then
            if (debuff.hasProced and (debuff.hasProced ~= specialEffect.hasProced)) then
                return -- we don't need to worry about this effect anymore because it has already proced
            elseif FancyActionBar.specialEffectProcs[abilityId] then
                local procUpdates = FancyActionBar.specialEffectProcs[abilityId]
                local procValues = procUpdates[debuff.procs or specialEffect.procs]
                for i, x in pairs(procValues) do
                    debuff[i] = x
                end
                stackCount = debuff.stacks or stackCount
            end
        elseif stackCount ~= nil or HasDebuffStackTargets(abilityId) then
            FancyActionBar.UpdateStacksFromEvent(abilityId, stackCount, true)
            stackCount = ResolveDebuffDisplayStacks(debuff, stackCount or 0)
        end
        if debuff.instantFade then
            debuff.endTime = 0
        end
        FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
        -- per-target removal handled via FancyActionBar.RemoveTargetUnit/GetTargets
    end
end

local function OnDebuffStacksChanged(_, change, _, _, unitTag, _, _, stackCount, _, _, effectType, _, _, unitName, unitId, abilityId)
    if (not SV.showOvertauntStacks) and abilityId == 52790 then
        return
    end

    FancyActionBar.UpdateStacksFromEvent(abilityId, stackCount, change == EFFECT_RESULT_FADED)
end

-- function FancyActionBar.OnDebuffTargetDeath( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
--
--   if targetUnitId == nil or targetUnitId == 0 then return end
--
--   if result ~= ACTION_RESULT_DIED and result ~= ACTION_RESULT_DIED_XP then return end
--
-- end

local function ClearDebuffsOnCombatEnd()
    local t = time()
    local keep = {}
    local stackCount = 0
    if not IsUnitInCombat("player") then
        local effects = FancyActionBar.effects
        local specialEffects = FancyActionBar.specialEffects
        for id, effect in pairs(effects or {}) do
            if effect and effect.isDebuff then
                local specialEffect = specialEffects and specialEffects[effect.id]
                if (specialEffect and specialEffect.setTime) and (effect.endTime and effect.endTime > t) then
                    keep[id] = true
                else
                    -- Clear per-debuff state and update visuals
                    local eff = effects and effects[effect.id]
                    if eff and eff.targets then
                        eff.targets = nil
                        effects[effect.id] = eff
                    end
                    effect.endTime = 0
                    if effect.hasExternalStackSources or HasDebuffStackTargets(effect.id) then
                        FancyActionBar.UpdateStacksFromEvent(effect.id, nil, true)
                    end
                    stackCount = 0
                    FancyActionBar.UpdateDebuff(effect, stackCount)
                end
            end
        end
        -- Perform final clear once, using computed keep table
        ClearDebuffs(keep)
    end
end

function FancyActionBar.UpdateDebuffTracking()
    ClearDebuffs()


    -- EVENT_TARGET_CHANGED (number eventCode, string unitTag)
    -- EVENT_RETICLE_TARGET_CHANGED (number eventCode)
    -- EVENT_RETICLE_TARGET_PLAYER_CHANGED (number eventCode)
    EM:UnregisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED)
    EM:UnregisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE)
    -- EM:UnregisterForEvent(NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT)
    -- EM:UnregisterForEvent(NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT)

    if SV.advancedDebuff then
        EM:RegisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE, ClearDebuffsOnCombatEnd)
        EM:RegisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged)

        -- EM:RegisterForEvent(  NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT, FancyActionBar.OnDebuffTargetDeath )
        -- EM:AddFilterForEvent( NAME .. "EnemyDeath_1", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED,    REGISTER_FILTER_IS_ERROR, false )
        --
        -- EM:RegisterForEvent(  NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT, FancyActionBar.OnDebuffTargetDeath )
        -- EM:AddFilterForEvent( NAME .. "EnemyDeath_2", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED_XP, REGISTER_FILTER_IS_ERROR, false )
        -- unregister any previously-registered per-ability events
        for id in pairs(registeredDebuffStackEvents) do
            EM:UnregisterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED)
            registeredDebuffStackEvents[id] = nil
        end
        -- register new per-ability events and build reverse stack-source map
        if FancyActionBar.debuffStackMap then
            for id in pairs(FancyActionBar.debuffStackMap) do
                EM:RegisterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, OnDebuffStacksChanged)
                EM:AddFilterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
                registeredDebuffStackEvents[id] = true
            end
        end
    end
end

function FancyActionBar:InitializeDebuffs(name, sv)
    NAME = name
    SV = sv
    FancyActionBar.UpdateDebuffTracking()
end
