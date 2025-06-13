--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar

local EM = GetEventManager()
local WM = GetWindowManager()
local SM = SCENE_MANAGER
local NAME = FancyActionBar.GetName()
local SV = ...
local time = GetGameTimeSeconds
local activeTargetDebuffs = {}

--- @param msg string
--- @param ... any
local function Chat(msg, ...)
    FancyActionBar.Chat(msg, ...)
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
-- Debug
---------------------------------
local function OnNewTarget()
    local tag = "reticleover"

    local name = zo_strformat("<<t:1>>", GetUnitName(tag))
    Chat(name .. " -> " .. GetUnitType(tag) .. " -> " .. GetUnitNameHighlightedByReticle())
end

-- /script zo_callLater(function() Chat(tostring(GetUnitType('reticleover'))) end, 2000)
local function PostReticleTargetInfo(uName, eName, gain, fade, eSlot, stacks, icon, bType, eType, aType, seType, aId, canClickOff, castByPlayer)
    -- if aType == 0 then return end -- passives (annoying when bar swapping)

    local ts = tostring
    local dur, s
    if (fade ~= nil and gain ~= nil) then
        dur = string.format(" %0.1f", fade - gain) .. "s"
    else
        dur = 0
    end

    if (stacks and stacks ~= 0)
    then
        s = " x" .. ts(stacks) .. "."
    else
        s = "."
    end

    Chat(eName .. " (" .. ts(aId) .. ")" .. " || stacks: " .. ts(stacks) .. " || duration: " .. ts(dur) .. " || slot: " .. ts(eSlot) .. " || unit: " .. ts(uName) .. " || effectType: " .. ts(eType) .. " || abilityType: " .. ts(aType) .. " || statusEffectType: " .. ts(seType) .. "\n===================")
end
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
    for debuffId, debuff in pairs(FancyActionBar.debuffs) do
        local doStackUpdate = false
        if FancyActionBar.stacks[debuff.id] then
            FancyActionBar.stacks[debuff.id] = 0
            doStackUpdate = true
        end

        if debuff.stackId then
            for i = 1, #debuff.stackId do
                if FancyActionBar.debuffStackMap[debuff.stackId[i]] and FancyActionBar.stacks[debuff.stackId[i]] then
                    FancyActionBar.stacks[debuff.stackId[i]] = 0
                    doStackUpdate = true
                end
            end
        end

        for effectId, effect in pairs(FancyActionBar.effects) do
            if debuff.id == effect.id then
                effect.endTime = time()
            end
            FancyActionBar.UpdateEffect(effect)
            if doStackUpdate then
                FancyActionBar.HandleStackUpdate(debuff.id)
            end
        end
    end
end

local function ClearDebuffsIfNotOnTarget()
    for _, debuff in pairs(FancyActionBar.debuffs) do
        if not debuff.keepOnTargetChange then
            debuff.activeOnTarget = false
            debuff.endTime = 0
            debuff.stacks = 0
            local doStackUpdate = false

            if FancyActionBar.stacks[debuff.id] then
                FancyActionBar.stacks[debuff.id] = 0
                doStackUpdate = true
            end

            if debuff.stackId then
                for i = 1, #debuff.stackId do
                    if FancyActionBar.debuffStackMap[debuff.stackId[i]] and FancyActionBar.stacks[debuff.stackId[i]] then
                        FancyActionBar.stacks[debuff.stackId[i]] = 0
                        doStackUpdate = true
                    end
                end
            end

            for _, effect in pairs(FancyActionBar.effects) do
                if effect.stackId and #effect.stackId > 0 then
                    for i = 1, #effect.stackId do
                        if effect.stackId[i] == debuff.id then
                            doStackUpdate = true
                        end
                    end
                end
                if debuff.id == effect.id then
                    for i, x in pairs(debuff) do
                        effect[i] = x
                    end
                    effect.endTime = time()
                end
                FancyActionBar.UpdateEffect(effect)
                if doStackUpdate then
                    FancyActionBar.HandleStackUpdate(effect.id)
                end
            end
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
    activeTargetDebuffs = {}
    FancyActionBar.debuffs = {}
end

local numEffects = 0

--- @return table debuffs
--- @return number debuffNum
local function GetTargetEffects()
    local tag = "reticleover"

    numEffects = GetNumBuffs(tag)

    local debuffs = {}
    local debuffNum = 0

    if numEffects <= 0 then
        --- @diagnostic disable-next-line: return-type-mismatch
        return nil, 0
    else
        for i = 1, numEffects do
            local abilityName, beginTime, endTime, buffSlot, stacks, icon, _, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo(tag, i)

            if castByPlayer or (FancyActionBar.allowExternalStacks[abilityId]) then
                -- PostReticleTargetInfo(name, abilityName, beginTime, endTime, buffSlot, stacks, icon, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer)

                debuffNum = debuffNum + 1
                local db =
                {
                    id = abilityId,
                    beginTime = beginTime or 0,
                    endTime = endTime or 0,
                    stacks = stacks or 0,
                    name = abilityName,
                    slot = buffSlot,
                    icon = icon,
                    effectType = effectType,
                    abilityType = abilityType,
                    statusEffectType = statusEffectType,
                    canClickOff = canClickOff,
                    castByPlayer = castByPlayer,
                }
                table.insert(debuffs, db)
            end
        end
    end
    return debuffs, debuffNum
end

local function UpdateDebuff(debuff, stacks, unitId, isTarget)
    -- TODO: If unitUpdating is the final instance then don't return
    local unitUpdating
    if isTarget == false then
        local activeDebuffs = activeTargetDebuffs[debuff.id]
        if activeDebuffs then
            for debuffUnitId, beginTime in pairs(activeDebuffs) do
                if debuff.beginTime == beginTime then
                    unitUpdating = debuffUnitId
                    break
                end
            end
            if unitId ~= unitUpdating and #activeDebuffs > 1 then
                return
            end
        end
    end

    if not debuff then
        return
    end
    local t = time()
    if debuff.id == 52790 and SV.showOvertauntStacks then
        FancyActionBar.stacks[debuff.id] = stacks
    else
        if stacks and debuff.stackId then
            for i = 1, #debuff.stackId do
                FancyActionBar.stacks[debuff.stackId[i]] = stacks
            end
        end
    end

    for id, effect in pairs(FancyActionBar.effects) do
        if effect.id == debuff.id then
            for dId, dEffect in pairs(debuff) do
                effect[dId] = dEffect
            end
            FancyActionBar.effects[id] = effect
            if stacks and #effect.stackId ~= 0 then
                FancyActionBar.HandleStackUpdate(id)
            end
            FancyActionBar.UpdateEffect(effect)
        end
    end
end

local function OnReticleTargetChanged()
    local tag = "reticleover"

    if (DoesUnitExist(tag) and not IsUnitDead(tag)) then
        if not FancyActionBar.IsEnemy(tag) then
            return
        end -- GetUnitType(tag), GetUnitNameHighlightedByReticle()

        local name = zo_strformat("<<t:1>>", GetUnitName(tag))
        local tId = 0
        local keep = {}

        local debuffs, debuffNum = GetTargetEffects()

        if debuffNum > 0 then
            for i = 1, debuffNum do
                local debuff = debuffs[i]
                local effect = FancyActionBar.effects[debuff.id]
                if effect then
                    for dId, dEffect in pairs(debuff) do
                        effect[dId] = dEffect
                    end
                    debuff = effect
                end

                debuff.stackId = debuff.stackId or { debuff.id }
                for stackSourceId, targetIds in pairs(FancyActionBar.debuffStackMap) do
                    for t = 1, #targetIds do
                        if targetIds[t] == debuff.id then
                            table.insert(debuff.stackId, stackSourceId)
                            break
                        end
                    end
                end
                local specialEffect = (FancyActionBar.specialEffects[debuff.id]
                    and ZO_DeepTableCopy(FancyActionBar.specialEffects[debuff.id]))
                keep[debuff.id] = true -- make sure we're keeping the debuff in case the specialEffect changes the id
                if specialEffect then
                    for sId, sEffect in pairs(specialEffect) do
                        debuff[sId] = sEffect
                    end
                    if specialEffect.setTime then
                        debuff.endTime = debuff.beginTime + specialEffect.duration
                    end
                    keep[debuff.id] = true -- keep the debuff.id after pushing all the special effect properties
                else
                    local stackCounts = {}
                    local externalStacks = false
                    if debuff.stackId then
                        for s = 1, #debuff.stackId do
                            if FancyActionBar.fixedStacks[debuff.stackId[s]] or (FancyActionBar.stackMap[debuff.stackId[s]] and not FancyActionBar.debuffStackMap[debuff.stackId[s]]) then
                                externalStacks = true
                                break
                            else
                                local stackId = debuff.stackId[s]
                                local currentStacks = FancyActionBar.stacks[stackId]
                                table.insert(stackCounts, currentStacks)
                            end
                        end
                    end
                    if externalStacks then
                        debuff.stacks = false
                    else
                        table.insert(stackCounts, debuff.stacks)
                        local maxStacks = FancyActionBar.GetStackValue(stackCounts)
                        debuff.stacks = maxStacks
                    end
                end

                debuff.duration = debuff.endTime - debuff.beginTime
                FancyActionBar.debuffs[debuff.id] = debuff
                FancyActionBar.debuffs[debuff.id].activeOnTarget = true
                FancyActionBar.debuffs[debuff.id].endTime = debuff.endTime
                UpdateDebuff(debuff, debuff.stacks, tId, true)
            end
        end

        for id, debuff in pairs(FancyActionBar.debuffs) do
            if debuff.keepOnTargetChange then
                return
            end
            if keep[debuff.id] == nil then -- update debuffs that are not active on the target according to settings.
                if debuff.stackId then
                    for s = 1, #debuff.stackId do
                        if FancyActionBar.fixedStacks[debuff.stackId[s]] or (FancyActionBar.stackMap[debuff.stackId[s]] and not FancyActionBar.debuffStackMap[debuff.stackId[s]]) then
                            debuff.stacks = false
                            break
                        end
                    end
                end
                debuff.activeOnTarget = false
                debuff.endTime = 0
                UpdateDebuff(FancyActionBar.debuffs[id], debuff.stacks ~= false and 0 or debuff.stacks, tId, true)
            end
        end
        -- OnNewTarget()
    else
        if SV.keepLastTarget == false then
            ClearDebuffsIfNotOnTarget()
        end
    end
end

function FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, beginTime, endTime, unitId)
    if (change == EFFECT_RESULT_FADED) then
        if FancyActionBar.targets[debuff.id] then
            local targetData = FancyActionBar.targets[debuff.id]
            targetData.times[unitId] = nil
            FancyActionBar.targets[debuff.id] = targetData
            local targetCount = FancyActionBar.CheckTargetEndtimes(debuff.id)
            FancyActionBar.HandleTargetUpdate(debuff.id)
            if targetCount >= 1 then
                return
            end
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
    --   FancyActionBar:dbg(1, '<<1>> duration <<2>>s ignored on: <<3>>.', effectName, string.format(' %0.1f', endTime - t), tag )
    --   return
    -- end

    local specialEffect = (FancyActionBar.specialEffects[abilityId]
        and ZO_DeepTableCopy(FancyActionBar.specialEffects[abilityId]))
    if specialEffect then
        debuff = FancyActionBar.debuffs[specialEffect.id] or debuff
    end

    if SV.keepLastTarget == false and tag ~= "reticleover" and not debuff.keepOnTargetChange then
        if not SV.multiTargetBlacklist[debuff.id] then
            FancyActionBar.UpdateMultiTargetDebuffs(debuff, change, beginTime, endTime, unitId)
        end
        return
    end

    debuff.stackId = debuff.stackId or { abilityId }
    for stackSourceId, targetIds in pairs(FancyActionBar.debuffStackMap) do
        for i = 1, #targetIds do
            if targetIds[i] == abilityId then
                table.insert(debuff.stackId, stackSourceId)
                break
            end
        end
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
        elseif debuff.stackId then
            for i = 1, #debuff.stackId do
                if FancyActionBar.fixedStacks[debuff.stackId[i]] or (FancyActionBar.stackMap[debuff.stackId[i]] and not ((debuff.stackId[i] == debuff.id) or FancyActionBar.debuffStackMap[debuff.stackId[i]])) then
                    stackCount = false
                    break
                end
            end
        end

        debuff.beginTime = (beginTime and beginTime ~= 0 and beginTime) or t
        debuff.endTime = endTime
        debuff.duration = endTime - beginTime
        FancyActionBar.debuffs[debuff.id] = debuff

        if not SV.multiTargetBlacklist[debuff.id] then
            local targetData = FancyActionBar.targets[debuff.id] or { targetCount = 0, maxEndTime = 0, times = {} }
            targetData.maxEndTime = zo_max(endTime, targetData.maxEndTime)
            targetData.times[unitId] = { beginTime = debuff.beginTime, endTime = endTime }
            FancyActionBar.targets[debuff.id] = targetData
            FancyActionBar.CheckTargetEndtimes(debuff.id)
            FancyActionBar.HandleTargetUpdate(debuff.id)
        end

        if FancyActionBar.activeCasts[debuff.id] then
            FancyActionBar.activeCasts[debuff.id].begin = debuff.beginTime
        end

        if (endTime > t + FancyActionBar.durationMin and endTime < t + FancyActionBar.durationMax) or (debuff.duration > FancyActionBar.durationMin) then
            activeTargetDebuffs = { [debuff.id] = { [unitId] = debuff.beginTime } }
            UpdateDebuff(debuff, stackCount, unitId, false)
        else
            FancyActionBar:dbg(1, "<<1>> duration <<2>>s ignored.", effectName, string.format(" %0.1f", endTime - t))
        end
    elseif (change == EFFECT_RESULT_FADED) then
        if FancyActionBar.targets[debuff.id] and FancyActionBar.targets[debuff.id].times[unitId] then
            local targetData = FancyActionBar.targets[debuff.id]
            targetData.times[unitId] = nil
            FancyActionBar.targets[debuff.id] = targetData
            local targetCount = FancyActionBar.CheckTargetEndtimes(debuff.id)
            FancyActionBar.HandleTargetUpdate(debuff.id)
            if targetCount >= 1 then
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
        elseif debuff.stackId then
            for i = 1, #debuff.stackId do
                if FancyActionBar.fixedStacks[debuff.stackId[i]] or (FancyActionBar.stackMap[debuff.stackId[i]] and not ((debuff.stackId[i] == debuff.id) or FancyActionBar.debuffStackMap[debuff.stackId[i]])) then
                    stackCount = false
                    break
                elseif FancyActionBar.stacks[debuff.stackId[i]] then
                    stackCount = zo_max(FancyActionBar.stacks[debuff.stackId[i]] - stackCount, 0)
                    break
                end
            end
        end
        if debuff.instantFade then
            debuff.endTime = 0
        end
        UpdateDebuff(debuff, stackCount, unitId, false)
        activeTargetDebuffs = { [debuff.id] = { [unitId] = nil } }
    end
end

local function OnDebuffStacksChanged(_, change, _, _, unitTag, _, _, stackCount, _, _, effectType, _, _, unitName, unitId, abilityId)
    if (not SV.showOvertauntStacks) and abilityId == 52790 then
        return
    end

    for debuffId, debuff in pairs(FancyActionBar.debuffs) do
        if debuff.stackId then
            for i = 1, #debuff.stackId do
                if debuff.stackId[i] == abilityId then
                    UpdateDebuff(debuff, stackCount or 0, unitId, false)
                    break
                end
            end
        end
    end
end

-- function FancyActionBar.OnDebuffTargetDeath( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
--
--   if targetUnitId == nil or targetUnitId == 0 then return end
--
--   if result ~= ACTION_RESULT_DIED and result ~= ACTION_RESULT_DIED_XP then return end
--
-- end

local function ClearDebuffsOnCombatEnd()
    local _
    local t = time()
    local keep = {}
    local stackCount = 0
    if not IsUnitInCombat("player") then
        for i, debuff in pairs(FancyActionBar.debuffs) do
            FancyActionBar.targets[debuff.id] = nil
            local specialEffect = FancyActionBar.specialEffects[debuff.id]
            if (specialEffect and specialEffect.setTime) and (debuff.endTime and debuff.endTime > t) then
                keep[i] = true
            else
                debuff.endTime = 0
                if debuff.stackId then
                    for s = 1, #debuff.stackId do
                        if FancyActionBar.fixedStacks[debuff.stackId[s]] or (FancyActionBar.stackMap[debuff.stackId[s]] and not FancyActionBar.debuffStackMap[debuff.stackId[s]]) then
                            _, _, stackCount = FancyActionBar.CheckForActiveEffect(debuff.stackId[s])
                            break
                        end
                    end
                end
                UpdateDebuff(debuff, stackCount, 0, nil)
            end
            ClearDebuffs(keep)
        end
    end
end

function FancyActionBar:UpdateDebuffTracking()
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
        for id in pairs(FancyActionBar.debuffStackMap) do
            EM:RegisterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, OnDebuffStacksChanged)
            EM:AddFilterForEvent(NAME .. id .. "DebuffStacks", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, id)
        end
    end
end

function FancyActionBar:InitializeDebuffs(name, sv)
    NAME = name
    SV = sv
    FancyActionBar:UpdateDebuffTracking()
end
