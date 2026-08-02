--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar

local EM = GetEventManager()
local WM = GetWindowManager()
local SM = SCENE_MANAGER
local GROUND_EFFECT = ABILITY_TYPE_AREAEFFECT
local NAME = FancyActionBar.GetName()
local SV = ...
local time = GetGameTimeSeconds

local function ApplyDebuffStacks(abilityId, stackCount, isFade)
    if abilityId == 52790 and not SV.showOvertauntStacks then return end
    if stackCount == nil and not isFade and not FancyActionBar.IsStackMapMember(abilityId) then return end
    FancyActionBar.UpdateStacksFromEvent(abilityId, stackCount, isFade)
end

local function ShouldClearStacksOnTargetChange(abilityId)
    if not abilityId then return true end
    if FancyActionBar.fixedStacks[abilityId] then return true end
    local debuffStackMap = FancyActionBar.debuffStackMap
    if FancyActionBar.stackMap[abilityId] or (debuffStackMap and debuffStackMap[abilityId]) then return true end
    local debuffEntry = FancyActionBar.GetStackMap(abilityId, "debuff")
    local members, sourceId = debuffEntry.sources, debuffEntry.sourceId
    if not sourceId then
        local defaultEntry = FancyActionBar.GetStackMap(abilityId)
        members = defaultEntry.sources
        sourceId = defaultEntry.sourceId
    end
    if not sourceId or not members then return true end
    for i = 1, #members do
        local memberId = members[i]
        local memberEffect = FancyActionBar.effects and FancyActionBar.effects[memberId]
        if memberEffect and not memberEffect.isDebuff then
            return false
        end
        if FancyActionBar.stackMap[memberId] and not (debuffStackMap and debuffStackMap[memberId]) then
            return false
        end
    end
    return true
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

    for i = 1, nBuffs do
        local _, _, endTime, _, stacks, _, _, _, _, _, abilityId, _, castByPlayer = GetUnitBuffInfo("reticleover", i)
        if abilityId == id and (castByPlayer or stacks > 0) then
            isActive = true
            data.endTime = endTime
            data.stacks = stacks or 0
            break
        end
    end

    if isActive then
        return true, data
    end
    return false
end

-- function FancyActionBar.IsToggled(id)
--   return toggled[id] and true or false
-- end

function FancyActionBar.IsGroupUnit(tag)
    if tag == nil or tag == "" then
        return false
    end
    return groupUnit[tag] ~= nil
end

function FancyActionBar.IsPlayer(tag)
    if tag == nil or tag == "" then
        return false
    end
    return AreUnitsEqual("player", tag)
end

function FancyActionBar.IsEnemy(tag)
    if FancyActionBar.IsGroupUnit(tag) then
        return false
    end

    local isEnemy = false

    if tag and tag ~= "" then
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

function FancyActionBar.IsLocalPlayerOrEnemy(tag)
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
        if FancyActionBar.IsEnemy(tag) then
            return true
        end
    end
    return false
end

---------------------------------
-- Tracking
---------------------------------

local function ClearTargetEffects()
    local t = time()
    for id, effect in pairs(FancyActionBar.effects) do
        if effect and effect.isDebuff then
            if effect.stacks and effect.stacks ~= 0 then
                FancyActionBar.SetStacks(effect.id, 0, true)
            end
            effect.endTime = t
        end
    end
end

local function ClearDebuffsIfNotOnTarget()
    local t = time()
    for _, effect in pairs(FancyActionBar.effects) do
        local trackedByWidget = effect and FancyActionBar.IsEffectWidgetTracked(effect.id)
        if effect and effect.isDebuff and not effect.keepOnTargetChange then
            if trackedByWidget and effect.endTime and effect.endTime > t then
                local we = FancyActionBar.widgetEffects[effect.id] or {}
                we.persistEndTime = zo_max(we.persistEndTime or 0, effect.endTime)
                FancyActionBar.widgetEffects[effect.id] = we
            end
            effect.activeOnTarget = false
            effect.endTime = 0
            FancyActionBar.UpdateDebuff(effect, ShouldClearStacksOnTargetChange(effect.id) and 0 or nil)
        end
    end
end

local function ClearDebuffs(keep)
    ClearTargetEffects()
    for id, effect in pairs(FancyActionBar.effects) do
        if effect and effect.isDebuff then
            effect.isDebuff = nil
            effect.hasActiveCast = nil
        end
    end
end

function FancyActionBar.UpdateDebuff(debuff, stacks, sourceAbilityId)
    if not debuff then return end

    local t = time()
    local effect = FancyActionBar.effects[debuff.id] or { id = debuff.id }
    for dId, dEffect in pairs(debuff) do
        effect[dId] = dEffect
    end
    effect.id = debuff.id
    effect.isDebuff = true
    effect.hasActiveCast = debuff.hasActiveCast or false

    if not FancyActionBar.specialEffects[debuff.id] then
        local debuffStackEntry = FancyActionBar.GetStackMap(effect.id, "debuff")
        effect.stackSources = debuffStackEntry.sources
        effect.stackOwnerId = debuffStackEntry.ownerId
    end

    local nextStacks
    if debuff.id == 52790 and not SV.showOvertauntStacks and stacks ~= 0 then
        nextStacks = nil
    elseif stacks ~= nil then
        nextStacks = stacks
    else
        nextStacks = FancyActionBar.GetDisplayStacks(effect, t)
    end
    if nextStacks ~= nil then
        effect.stacks = nextStacks
        FancyActionBar.SetStacks(effect.id, nextStacks, true)
    end

    FancyActionBar.effects[debuff.id] = effect
end

local function OnReticleTargetChanged()
    local tag = "reticleover"
    local t = time()

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
                    local specialEffect = (FancyActionBar.specialEffects[abilityId]
                        and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId]))
                    local debuff =
                    {
                        id = (specialEffect and specialEffect.id) or abilityId,
                        beginTime = beginTime or 0,
                        endTime = endTime or 0,
                        duration = (endTime or 0) - (beginTime or 0),
                        name = abilityName,
                        hasActiveCast = castByPlayer,
                        activeOnTarget = true,
                    }
                    if specialEffect and specialEffect.setTime then
                        debuff.endTime = debuff.beginTime + specialEffect.duration
                    end

                    keep[debuff.id] = true

                    local stackCount = (specialEffect and specialEffect.stacks) or stacks or 0
                    FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
                end
            end
        end

        -- Clear any previously-known debuffs that are no longer on the reticle
        for id, effect in pairs(FancyActionBar.effects) do
            local trackedByWidget = effect and FancyActionBar.IsEffectWidgetTracked(effect.id)
            if effect and effect.isDebuff and not effect.keepOnTargetChange and not keep[id] then
                if trackedByWidget and effect.endTime and effect.endTime > t then
                    local we = FancyActionBar.widgetEffects[effect.id] or {}
                    we.persistEndTime = zo_max(we.persistEndTime or 0, effect.endTime)
                    FancyActionBar.widgetEffects[effect.id] = we
                end
                effect.activeOnTarget = false
                effect.endTime = 0
                FancyActionBar.UpdateDebuff(effect, ShouldClearStacksOnTargetChange(effect.id) and 0 or nil)
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
        end
        return
    elseif (change == EFFECT_RESULT_FADED) then
        local targets = FancyActionBar.GetUnits(debuff.id, "targets")
        if targets and targets.times and unitKey and targets.times[unitKey] then
            FancyActionBar.RemoveUnit(debuff.id, unitKey, currentTime, "targets")
        end
    end
end

function FancyActionBar.OnDebuffChanged(debuff, t, eventCode, change, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
    local tag = ""
    if unitTag and unitTag ~= "" then
        tag = unitTag
    end

    local specialEffect = (FancyActionBar.specialEffects[abilityId]
        and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId]))
    if specialEffect then
        debuff = FancyActionBar.effects and FancyActionBar.effects[specialEffect.id] or debuff
    end

    local isFade = change == EFFECT_RESULT_FADED
    if SV.keepLastTarget == false and tag ~= "reticleover" and not debuff.keepOnTargetChange then
        if not SV.multiTargetBlacklist[debuff.id] then
            local unitKey = unitId ~= 0 and unitId or nil
            FancyActionBar.UpdateMultiTargetDebuffs(FancyActionBar.effects[debuff.id] or debuff, change, t, beginTime, endTime, unitKey, abilityType)
        end
        ApplyDebuffStacks(abilityId, stackCount, isFade)
        return
    end

    if specialEffect then
        local newSources = debuff.stackSources or specialEffect.stackSources or specialEffect.stackId or FancyActionBar.GetStackMap(abilityId).sources
        if debuff.stackSources ~= newSources then
            debuff.stackSources = newSources
        end
    else
        local debuffStackEntry = FancyActionBar.GetStackMap(debuff.id, "debuff")
        debuff.stackSources = debuffStackEntry.sources
        debuff.stackOwnerId = debuffStackEntry.ownerId
    end

    if change == EFFECT_RESULT_GAINED or change == EFFECT_RESULT_UPDATED then
        if specialEffect then
            for sId, sEffect in pairs(specialEffect) do
                if sId ~= "id" and sId ~= "stackId" and sId ~= "stackSources" then
                    debuff[sId] = sEffect
                end
            end
            if specialEffect.setTime then
                endTime = t + specialEffect.duration
            end
            if specialEffect.stacks then
                stackCount = specialEffect.stacks
            end
        else
            ApplyDebuffStacks(abilityId, stackCount, false)
        end

        debuff.beginTime = (beginTime and beginTime ~= 0 and beginTime) or t
        debuff.endTime = endTime
        debuff.duration = endTime - beginTime
        debuff.isDebuff = true
        FancyActionBar.effects[debuff.id] = debuff

        if not SV.multiTargetBlacklist[debuff.id] then
            local unitKey = unitId ~= 0 and unitId or nil
            FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, t, beginTime, endTime, unitKey, abilityType)
        end

        local debuffStackMap = FancyActionBar.debuffStackMap
        if debuffStackMap and debuffStackMap[debuff.id] and stackCount ~= nil then
            FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
        elseif (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax) or (debuff.duration > FancyActionBar.durationMin) then
            FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
        end
    elseif isFade then
        local td = FancyActionBar.GetUnits(debuff.id, "targets")
        local unitKey = unitId ~= 0 and unitId or nil
        if td and td.times and td.times[unitKey] then
            local targetCount = FancyActionBar.RemoveUnit(debuff.id, unitKey, t, "targets")
            if targetCount >= 1 then
                return
            end
        end

        if debuff.beginTime and (t - debuff.beginTime < 0.3) and (not debuff.instantFade) then
            return
        end

        if specialEffect then
            if (debuff.hasProced and (debuff.hasProced ~= specialEffect.hasProced)) then
                return
            end
            local procUpdates = FancyActionBar.specialEffectProcs[abilityId] or FancyActionBar.specialEffectProcs[debuff.id]
            if procUpdates then
                local effectObj = FancyActionBar.effects[debuff.id] or debuff
                local success = FancyActionBar.UpdateEffectProcs(effectObj, specialEffect, EFFECT_RESULT_FADED, stackCount)
                if not success then
                    effectObj.endTime = endTime
                    FancyActionBar.UpdateDebuff(effectObj, stackCount, abilityId)
                    return
                end
                debuff = FancyActionBar.effects[effectObj.id] or effectObj
                stackCount = debuff.stacks or stackCount
            end
        else
            ApplyDebuffStacks(abilityId, stackCount, true)
            stackCount = FancyActionBar.GetStacks(abilityId)
        end
        if debuff.instantFade then
            debuff.endTime = 0
        end
        FancyActionBar.UpdateDebuff(debuff, stackCount, abilityId)
    end
end

local function ClearDebuffsOnCombatEnd()
    local t = time()
    local keep = {}
    if not IsUnitInCombat("player") then
        local effects = FancyActionBar.effects
        local specialEffects = FancyActionBar.specialEffects
        for id, effect in pairs(effects or {}) do
            if effect and effect.isDebuff then
                local specialEffect = specialEffects and specialEffects[effect.id]
                if (specialEffect and specialEffect.setTime) and (effect.endTime and effect.endTime > t) then
                    keep[id] = true
                else
                    if effect.targets then
                        effect.targets = nil
                    end
                    effect.endTime = 0
                    FancyActionBar.UpdateDebuff(effect, 0)
                end
            end
        end
        ClearDebuffs(keep)
    end
end

function FancyActionBar.UpdateDebuffTracking()
    ClearDebuffs()

    EM:UnregisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED)
    EM:UnregisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE)
    -- Drop legacy per-ability stack listeners (older versions registered these).
    if FancyActionBar.debuffStackMap then
        for id in pairs(FancyActionBar.debuffStackMap) do
            EM:UnregisterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED)
        end
    end

    if SV.advancedDebuff then
        EM:RegisterForEvent(NAME .. "DebuffCombat", EVENT_PLAYER_COMBAT_STATE, ClearDebuffsOnCombatEnd)
        EM:RegisterForEvent(NAME .. "ReticleTaget", EVENT_RETICLE_TARGET_CHANGED, OnReticleTargetChanged)
    end
end

function FancyActionBar:InitializeDebuffs(name, sv)
    NAME = name
    SV = sv
    FancyActionBar.UpdateDebuffTracking()
end
