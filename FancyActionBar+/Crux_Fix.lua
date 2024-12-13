local lastFlailTriggeredTime
local lastScholarTriggeredTime
local lastDamageReceivedTime
local cruxGenerationTimeArr = {}

local function OnFlail(_)
    lastFlailTriggeredTime = GetFrameTimeSeconds()
end
local function OnScholarship(_)
    -- if scholarship is up
    lastScholarTriggeredTime = GetFrameTimeSeconds()
end
local function OnCruxWeaver(_)
    -- if cruxweaver is up
    lastDamageReceivedTime = GetFrameTimeSeconds()
end

local function OnCruxGenerate(_,  changeType, _, _, _, beginTime)
    if changeType == EFFECT_RESULT_GAINED or EFFECT_RESULT_UPDATED then
        -- Filtering out Crux generated by Inspired Scholarship and Cruxweaver Armor
        if math.abs(beginTime - lastScholarTriggeredTime) > 0.1 and math.abs(beginTime - lastFlailTriggeredTime) > 0.1 and math.abs(beginTime - lastDamageReceivedTime) > 0.1 then
            -- record the timestamp when crux generated
            table.insert(cruxGenerationTimeArr, beginTime)
        end
    end
end

local function BannerResync()
    -- double check if the timestamps in cruxGenerationTimeArr are generated every approximately 5 seconds, if so update the banner timer accordingly
    -- unregister events and updates afterward, until next zone change
end


local function OnZoneChange()
    local damageDone = {
        ACTION_RESULT_DAMAGE,
        ACTION_RESULT_CRITICAL_DAMAGE,
    }

    for k, actionResult in pairs(damageDone) do
        EVENT_MANAGER:RegisterForEvent(ADDON.name .. "Flail" .. k, EVENT_COMBAT_EVENT , ADDON.OnFlail)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Flail" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Flail" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 183006) -- flail
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Flail" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, actionResult)
    end
    for k, actionResult in pairs(damageDone) do
        EVENT_MANAGER:RegisterForEvent(ADDON.name .. "Scholar" .. k, EVENT_COMBAT_EVENT , ADDON.OnScholarship)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Scholar" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Scholar" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 185843) -- inspired scholarship
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Scholar" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, actionResult)
    end

    local damageReceivied = {
        ACTION_RESULT_DAMAGE,
        ACTION_RESULT_BLOCKED_DAMAGE, 
        ACTION_RESULT_DAMAGE_SHIELDED,
    }
    
    for k, actionResult in pairs(damageReceivied) do
        EVENT_MANAGER:RegisterForEvent(ADDON.name .. "Weaver" .. k, EVENT_COMBAT_EVENT , ADDON.OnCruxWeaver)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Weaver" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Weaver" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, actionResult)
    end
    
    EVENT_MANAGER:RegisterForEvent(ADDON.name .. "Crux", EVENT_EFFECT_CHANGED , ADDON.OnCruxGenerate)
    EVENT_MANAGER:AddFilterForEvent(ADDON.name .. "Crux", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 184220) -- Crux
    
    EVENT_MANAGER:RegisterForUpdate(ADDON.name .. 'BannerResync', 1000, function() BannerResync() end)
end

EVENT_MANAGER:RegisterForEvent(ADDON.name .. "ZoneChange", EVENT_ZONE_CHANGED , ADDON.OnZoneChange)