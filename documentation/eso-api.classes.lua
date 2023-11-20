---@meta _

---@class AddOnManager
AddOnManager = nil
--- @param relevantFilter string
--- @return void
function AddOnManager:AddRelevantFilter(relevantFilter) end

--- @return bool areAddOnsEnabled
function AddOnManager:AreAddOnsEnabled() end

--- @param disabledAddonIndex luaindex
--- @return void
function AddOnManager:ClearForceDisabledAddOnNotification(disabledAddonIndex) end

--- @return void
function AddOnManager:ClearWarnOutOfDateAddOns() end

--- @param addOnIndex luaindex
--- @param addOnDependencyIndex luaindex
--- @return string name, bool exists, bool active, integer minVersion, integer version, bool isLibrary
function AddOnManager:GetAddOnDependencyInfo(addOnIndex, addOnDependencyIndex) end

--- @return string settingFilter
function AddOnManager:GetAddOnFilter() end

--- @param addOnIndex luaindex
--- @return string name, string title, string author, string description, bool enabled, [AddOnLoadState|#AddOnLoadState] state, bool isOutOfDate, bool isLibrary
function AddOnManager:GetAddOnInfo(addOnIndex) end

--- @param addOnIndex luaindex
--- @return integer numDependencies
function AddOnManager:GetAddOnNumDependencies(addOnIndex) end

--- @param addOnIndex luaindex
--- @return string directoryPath
function AddOnManager:GetAddOnRootDirectoryPath(addOnIndex) end

--- @param addOnIndex luaindex
--- @return integer version
function AddOnManager:GetAddOnVersion(addOnIndex) end

--- @param disabledAddonIndex luaindex
--- @return string addonName, bool shouldShowNotification
function AddOnManager:GetForceDisabledAddOnInfo(disabledAddonIndex) end

--- @return bool loadOutOfDateAddons
function AddOnManager:GetLoadOutOfDateAddOns() end

--- @return integer numAddOns
function AddOnManager:GetNumAddOns() end

--- @return integer numDisabledAddons
function AddOnManager:GetNumForceDisabledAddOns() end

--- @return void
function AddOnManager:RemoveAddOnFilter() end

--- @param addOnName string
--- @return void
function AddOnManager:RequestAddOnSavedVariablesPrioritySave(addOnName) end

--- @return void
function AddOnManager:ResetRelevantFilters() end

--- @param addOnIndex luaindex
--- @param enabled bool
--- @return void
function AddOnManager:SetAddOnEnabled(addOnIndex, enabled) end

--- @param settingFilter string
--- @return void
function AddOnManager:SetAddOnFilter(settingFilter) end

--- @param enabled bool
--- @return void
function AddOnManager:SetAddOnsEnabled(enabled) end

--- @return bool warnOutOfDateAddons
function AddOnManager:ShouldWarnOutOfDateAddOns() end

--- @param addOnName string
--- @return bool wasDetected
function AddOnManager:WasAddOnDetected(addOnName) end

---@class AnimationManager
AnimationManager = nil
--- @return object timeline
function AnimationManager:CreateTimeline() end

--- @param timelineName string
--- @param animatedControl object
--- @return object timeline
function AnimationManager:CreateTimelineFromVirtual(timelineName, animatedControl) end

---@class AnimationObject
AnimationObject = nil
--- @return object animatedControl
function AnimationObject:GetAnimatedControl() end

--- @return string applyToChildControlName
function AnimationObject:GetApplyToChildControlName() end

--- @return integer durationMs
function AnimationObject:GetDuration() end

--- @return function functionRef
function AnimationObject:GetEasingFunction() end

--- @param eventName string
--- @param name string
--- @return function functionRef
function AnimationObject:GetHandler(eventName, name) end

--- @return object owningTimeline
function AnimationObject:GetTimeline() end

--- @return [AnimationType|#AnimationType] animationObjectType
function AnimationObject:GetType() end

--- @return bool isEnabled
function AnimationObject:IsEnabled() end

--- @return bool isPlaying
function AnimationObject:IsPlaying() end

--- @param animatedControl object
--- @return void
function AnimationObject:SetAnimatedControl(animatedControl) end

--- @param applyToChildControlName string
--- @return void
function AnimationObject:SetApplyToChildControlName(applyToChildControlName) end

--- @param durationMs integer
--- @return void
function AnimationObject:SetDuration(durationMs) end

--- @param functionRef function
--- @return void
function AnimationObject:SetEasingFunction(functionRef) end

--- @param enabled bool
--- @return void
function AnimationObject:SetEnabled(enabled) end

--- @param eventName string
--- @param functionRef function
--- @param name string
--- @param controlHandlerOrder [ControlHandlerOrder|#ControlHandlerOrder]
--- @param targetName string
--- @return void
function AnimationObject:SetHandler(eventName, functionRef, name, controlHandlerOrder, targetName) end

--- @param offset integer
--- @return void
function AnimationObject:SetOffsetInParent(offset) end

---@class AnimationObject3DRotate
AnimationObject3DRotate = nil
--- @return number endPitchRadians
function AnimationObject3DRotate:GetEndPitch() end

--- @return number endRollRadians
function AnimationObject3DRotate:GetEndRoll() end

--- @return number endYawRadians
function AnimationObject3DRotate:GetEndYaw() end

--- @return number startPitchRadians
function AnimationObject3DRotate:GetStartPitch() end

--- @return number startRollRadians
function AnimationObject3DRotate:GetStartRoll() end

--- @return number startYawRadians
function AnimationObject3DRotate:GetStartYaw() end

--- @param endPitchRadians number
--- @return void
function AnimationObject3DRotate:SetEndPitch(endPitchRadians) end

--- @param endRollRadians number
--- @return void
function AnimationObject3DRotate:SetEndRoll(endRollRadians) end

--- @param endYawRadians number
--- @return void
function AnimationObject3DRotate:SetEndYaw(endYawRadians) end

--- @param startPitchRadians number
--- @param startYawRadians number
--- @param startRollRadians number
--- @param endPitchRadians number
--- @param endYawRadians number
--- @param endRollRadians number
--- @return void
function AnimationObject3DRotate:SetRotationValues(startPitchRadians, startYawRadians, startRollRadians, endPitchRadians, endYawRadians, endRollRadians) end

--- @param startPitchRadians number
--- @return void
function AnimationObject3DRotate:SetStartPitch(startPitchRadians) end

--- @param startRollRadians number
--- @return void
function AnimationObject3DRotate:SetStartRoll(startRollRadians) end

--- @param startYawRadians number
--- @return void
function AnimationObject3DRotate:SetStartYaw(startYawRadians) end

---@class AnimationObject3DTranslate
AnimationObject3DTranslate = nil
--- @return void
function AnimationObject3DTranslate:ClearBezierControlPoints() end

--- @return number deltaX
function AnimationObject3DTranslate:GetDeltaOffsetX() end

--- @return number deltaY
function AnimationObject3DTranslate:GetDeltaOffsetY() end

--- @return number deltaZ
function AnimationObject3DTranslate:GetDeltaOffsetZ() end

--- @return number endX
function AnimationObject3DTranslate:GetEndOffsetX() end

--- @return number endY
function AnimationObject3DTranslate:GetEndOffsetY() end

--- @return number endZ
function AnimationObject3DTranslate:GetEndOffsetZ() end

--- @return number startX
function AnimationObject3DTranslate:GetStartOffsetX() end

--- @return number startY
function AnimationObject3DTranslate:GetStartOffsetY() end

--- @return number startZ
function AnimationObject3DTranslate:GetStartOffsetZ() end

--- @return number deltaX, number deltaY, number deltaZ
function AnimationObject3DTranslate:GetTranslateDeltas() end

--- @param index luaindex
--- @param x number
--- @param y number
--- @param z number
--- @return void
function AnimationObject3DTranslate:SetBezierControlPoint(index, x, y, z) end

--- @param deltaX number
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObject3DTranslate:SetDeltaOffsetX(deltaX, translateAnimationDeltaType) end

--- @param deltaY number
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObject3DTranslate:SetDeltaOffsetY(deltaY, translateAnimationDeltaType) end

--- @param deltaZ number
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObject3DTranslate:SetDeltaOffsetZ(deltaZ, translateAnimationDeltaType) end

--- @param endX number
--- @return void
function AnimationObject3DTranslate:SetEndOffsetX(endX) end

--- @param endY number
--- @return void
function AnimationObject3DTranslate:SetEndOffsetY(endY) end

--- @param endZ number
--- @return void
function AnimationObject3DTranslate:SetEndOffsetZ(endZ) end

--- @param startX number
--- @return void
function AnimationObject3DTranslate:SetStartOffsetX(startX) end

--- @param startY number
--- @return void
function AnimationObject3DTranslate:SetStartOffsetY(startY) end

--- @param startZ number
--- @return void
function AnimationObject3DTranslate:SetStartOffsetZ(startZ) end

--- @param deltaX number
--- @param deltaY number
--- @param deltaZ number
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObject3DTranslate:SetTranslateDeltas(deltaX, deltaY, deltaZ, translateAnimationDeltaType) end

--- @param startX number
--- @param startY number
--- @param startZ number
--- @param endX number
--- @param endY number
--- @param endZ number
--- @return void
function AnimationObject3DTranslate:SetTranslateOffsets(startX, startY, startZ, endX, endY, endZ) end

---@class AnimationObjectAlpha
AnimationObjectAlpha = nil
--- @return number endAlpha
function AnimationObjectAlpha:GetEndAlpha() end

--- @return number startAlpha
function AnimationObjectAlpha:GetStartAlpha() end

--- @param startAlpha number
--- @param endAlpha number
--- @return void
function AnimationObjectAlpha:SetAlphaValues(startAlpha, endAlpha) end

--- @param endAlpha number
--- @return void
function AnimationObjectAlpha:SetEndAlpha(endAlpha) end

--- @param startAlpha number
--- @return void
function AnimationObjectAlpha:SetStartAlpha(startAlpha) end

---@class AnimationObjectColor
AnimationObjectColor = nil
--- @return bool applyAlpha
function AnimationObjectColor:GetApplyAlpha() end

--- @return number endR, number endG, number endB, number endA
function AnimationObjectColor:GetEndColor() end

--- @return number startR, number startG, number startB, number startA
function AnimationObjectColor:GetStartColor() end

--- @param applyAlpha bool
--- @return void
function AnimationObjectColor:SetApplyAlpha(applyAlpha) end

--- @param startR number
--- @param startG number
--- @param startB number
--- @param startA number
--- @param endR number
--- @param endG number
--- @param endB number
--- @param endA number
--- @return void
function AnimationObjectColor:SetColorValues(startR, startG, startB, startA, endR, endG, endB, endA) end

--- @param endR number
--- @param endG number
--- @param endB number
--- @param endA number
--- @return void
function AnimationObjectColor:SetEndColor(endR, endG, endB, endA) end

--- @param startR number
--- @param startG number
--- @param startB number
--- @param startA number
--- @return void
function AnimationObjectColor:SetStartColor(startR, startG, startB, startA) end

---@class AnimationObjectCustom
AnimationObjectCustom = nil
--- @param functionRef function
--- @return void
function AnimationObjectCustom:SetUpdateFunction(functionRef) end

---@class AnimationObjectDesaturation
AnimationObjectDesaturation = nil
--- @return number endDesaturation
function AnimationObjectDesaturation:GetEndDesaturation() end

--- @return number startDesaturation
function AnimationObjectDesaturation:GetStartDesaturation() end

--- @param startDesaturation number
--- @param endDesaturation number
--- @return void
function AnimationObjectDesaturation:SetDesaturationValues(startDesaturation, endDesaturation) end

--- @param endDesaturation number
--- @return void
function AnimationObjectDesaturation:SetEndDesaturation(endDesaturation) end

--- @param startDesaturation number
--- @return void
function AnimationObjectDesaturation:SetStartDesaturation(startDesaturation) end

---@class AnimationObjectScale
AnimationObjectScale = nil
--- @return number endScale
function AnimationObjectScale:GetEndScale() end

--- @return number startScale
function AnimationObjectScale:GetStartScale() end

--- @param endScale number
--- @return void
function AnimationObjectScale:SetEndScale(endScale) end

--- @param startScale number
--- @param endScale number
--- @return void
function AnimationObjectScale:SetScaleValues(startScale, endScale) end

--- @param startScale number
--- @return void
function AnimationObjectScale:SetStartScale(startScale) end

---@class AnimationObjectScroll
AnimationObjectScroll = nil
--- @param endX number
--- @return void
function AnimationObjectScroll:SetHorizontalEnd(endX) end

--- @param offsetX number
--- @return void
function AnimationObjectScroll:SetHorizontalRelative(offsetX) end

--- @param startX number
--- @param endX number
--- @return void
function AnimationObjectScroll:SetHorizontalStartAndEnd(startX, endX) end

--- @param endY number
--- @return void
function AnimationObjectScroll:SetVerticalEnd(endY) end

--- @param offsetY number
--- @return void
function AnimationObjectScroll:SetVerticalRelative(offsetY) end

--- @param startY number
--- @param endY number
--- @return void
function AnimationObjectScroll:SetVerticalStartAndEnd(startY, endY) end

---@class AnimationObjectSize
AnimationObjectSize = nil
--- @param endHeight number
--- @return void
function AnimationObjectSize:SetEndHeight(endHeight) end

--- @param endWidth number
--- @return void
function AnimationObjectSize:SetEndWidth(endWidth) end

--- @param startHeight number
--- @param endHeight number
--- @return void
function AnimationObjectSize:SetStartAndEndHeight(startHeight, endHeight) end

--- @param startWidth number
--- @param endWidth number
--- @return void
function AnimationObjectSize:SetStartAndEndWidth(startWidth, endWidth) end

--- @param startHeight number
--- @return void
function AnimationObjectSize:SetStartHeight(startHeight) end

--- @param startWidth number
--- @return void
function AnimationObjectSize:SetStartWidth(startWidth) end

---@class AnimationObjectTexture
AnimationObjectTexture = nil
--- @return integer aNumCellsHigh
function AnimationObjectTexture:GetCellsHigh() end

--- @return integer aNumCellsWide
function AnimationObjectTexture:GetCellsWide() end

--- @return bool mirroring
function AnimationObjectTexture:IsMirroringAlongX() end

--- @return bool mirroring
function AnimationObjectTexture:IsMirroringAlongY() end

--- @param aNumCellsHigh integer
--- @return void
function AnimationObjectTexture:SetCellsHigh(aNumCellsHigh) end

--- @param aNumCellsWide integer
--- @return void
function AnimationObjectTexture:SetCellsWide(aNumCellsWide) end

--- @param framesPerSecond number
--- @return void
function AnimationObjectTexture:SetFramerate(framesPerSecond) end

--- @param aNumCellsWide integer
--- @param aNumCellsHigh integer
--- @return void
function AnimationObjectTexture:SetImageData(aNumCellsWide, aNumCellsHigh) end

--- @param mirroring bool
--- @return void
function AnimationObjectTexture:SetMirrorAlongX(mirroring) end

--- @param mirroring bool
--- @return void
function AnimationObjectTexture:SetMirrorAlongY(mirroring) end

---@class AnimationObjectTextureRotate
AnimationObjectTextureRotate = nil
--- @return number endRadians
function AnimationObjectTextureRotate:GetEndRotation() end

--- @return number startRadians
function AnimationObjectTextureRotate:GetStartRotation() end

--- @param endRadians number
--- @return void
function AnimationObjectTextureRotate:SetEndRotation(endRadians) end

--- @param startRadians number
--- @param endRadians number
--- @return void
function AnimationObjectTextureRotate:SetRotationValues(startRadians, endRadians) end

--- @param startRadians number
--- @return void
function AnimationObjectTextureRotate:SetStartRotation(startRadians) end

---@class AnimationObjectTextureSlide
AnimationObjectTextureSlide = nil
--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function AnimationObjectTextureSlide:SetBaseTextureCoords(left, right, top, bottom) end

--- @param slideDistanceU number
--- @return void
function AnimationObjectTextureSlide:SetDeltaUFromStart(slideDistanceU) end

--- @param slideDistanceV number
--- @return void
function AnimationObjectTextureSlide:SetDeltaVFromStart(slideDistanceV) end

--- @param slideDistanceU number
--- @param slideDistanceV number
--- @return void
function AnimationObjectTextureSlide:SetSlideDistances(slideDistanceU, slideDistanceV) end

---@class AnimationObjectTransformOffset
AnimationObjectTransformOffset = nil
--- @return number:nilable endX, number:nilable endY, number:nilable endZ
function AnimationObjectTransformOffset:GetEndOffset() end

--- @return number:nilable startX, number:nilable startY, number:nilable startZ
function AnimationObjectTransformOffset:GetStartOffset() end

--- @param endX layout_measurement
--- @param endY layout_measurement
--- @param endZ layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetEndOffset(endX, endY, endZ) end

--- @param endX layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetEndOffsetX(endX) end

--- @param endY layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetEndOffsetY(endY) end

--- @param endZ layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetEndOffsetZ(endZ) end

--- @param startX layout_measurement
--- @param startY layout_measurement
--- @param startZ layout_measurement
--- @param endX layout_measurement
--- @param endY layout_measurement
--- @param endZ layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetOffsets(startX, startY, startZ, endX, endY, endZ) end

--- @param startX layout_measurement
--- @param startY layout_measurement
--- @param startZ layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetStartOffset(startX, startY, startZ) end

--- @param startX layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetStartOffsetX(startX) end

--- @param startY layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetStartOffsetY(startY) end

--- @param startZ layout_measurement
--- @return void
function AnimationObjectTransformOffset:SetStartOffsetZ(startZ) end

---@class AnimationObjectTransformRotation
AnimationObjectTransformRotation = nil
--- @param endXRadians number
--- @param endYRadians number
--- @param endZRadians number
--- @return void
function AnimationObjectTransformRotation:SetEndRotation(endXRadians, endYRadians, endZRadians) end

--- @param endXRadians number
--- @return void
function AnimationObjectTransformRotation:SetEndX(endXRadians) end

--- @param endYRadians number
--- @return void
function AnimationObjectTransformRotation:SetEndY(endYRadians) end

--- @param endZRadians number
--- @return void
function AnimationObjectTransformRotation:SetEndZ(endZRadians) end

--- @param mode [RotationAnimationMode|#RotationAnimationMode]
--- @return void
function AnimationObjectTransformRotation:SetMode(mode) end

--- @param startXRadians number
--- @param startYRadians number
--- @param startZRadians number
--- @param endXRadians number
--- @param endYRadians number
--- @param endZRadians number
--- @return void
function AnimationObjectTransformRotation:SetRotations(startXRadians, startYRadians, startZRadians, endXRadians, endYRadians, endZRadians) end

--- @param startXRadians number
--- @param startYRadians number
--- @param startZRadians number
--- @return void
function AnimationObjectTransformRotation:SetStartRotation(startXRadians, startYRadians, startZRadians) end

--- @param startXRadians number
--- @return void
function AnimationObjectTransformRotation:SetStartX(startXRadians) end

--- @param startYRadians number
--- @return void
function AnimationObjectTransformRotation:SetStartY(startYRadians) end

--- @param startZRadians number
--- @return void
function AnimationObjectTransformRotation:SetStartZ(startZRadians) end

---@class AnimationObjectTransformScale
AnimationObjectTransformScale = nil
--- @param endScale number
--- @return void
function AnimationObjectTransformScale:SetEndScale(endScale) end

--- @param endScaleX number
--- @return void
function AnimationObjectTransformScale:SetEndScaleX(endScaleX) end

--- @param endScaleY number
--- @return void
function AnimationObjectTransformScale:SetEndScaleY(endScaleY) end

--- @param startScale number
--- @return void
function AnimationObjectTransformScale:SetStartScale(startScale) end

--- @param startScaleX number
--- @return void
function AnimationObjectTransformScale:SetStartScaleX(startScaleX) end

--- @param startScaleY number
--- @return void
function AnimationObjectTransformScale:SetStartScaleY(startScaleY) end

---@class AnimationObjectTransformSkew
AnimationObjectTransformSkew = nil
--- @param endSkewXRadians number
--- @return void
function AnimationObjectTransformSkew:SetEndSkewX(endSkewXRadians) end

--- @param endSkewYRadians number
--- @return void
function AnimationObjectTransformSkew:SetEndSkewY(endSkewYRadians) end

--- @param startSkewXRadians number
--- @return void
function AnimationObjectTransformSkew:SetStartSkewX(startSkewXRadians) end

--- @param startSkewYRadians number
--- @return void
function AnimationObjectTransformSkew:SetStartSkewY(startSkewYRadians) end

---@class AnimationObjectTranslate
AnimationObjectTranslate = nil
--- @return integer anchorIndex
function AnimationObjectTranslate:GetAnchorIndex() end

--- @return number deltaX
function AnimationObjectTranslate:GetDeltaOffsetX() end

--- @return number deltaY
function AnimationObjectTranslate:GetDeltaOffsetY() end

--- @return number endX
function AnimationObjectTranslate:GetEndOffsetX() end

--- @return number endY
function AnimationObjectTranslate:GetEndOffsetY() end

--- @return number startX
function AnimationObjectTranslate:GetStartOffsetX() end

--- @return number startY
function AnimationObjectTranslate:GetStartOffsetY() end

--- @return number deltaX, number deltaY
function AnimationObjectTranslate:GetTranslateDeltas() end

--- @param anchorIndex integer
--- @return void
function AnimationObjectTranslate:SetAnchorIndex(anchorIndex) end

--- @param deltaX layout_measurement
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetX(deltaX, translateAnimationDeltaType) end

--- @param deltaX layout_measurement
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetXFromEnd(deltaX) end

--- @param deltaX layout_measurement
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetXFromStart(deltaX) end

--- @param deltaY layout_measurement
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetY(deltaY, translateAnimationDeltaType) end

--- @param deltaY layout_measurement
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetYFromEnd(deltaY) end

--- @param deltaY layout_measurement
--- @return void
function AnimationObjectTranslate:SetDeltaOffsetYFromStart(deltaY) end

--- @param endX layout_measurement
--- @return void
function AnimationObjectTranslate:SetEndOffsetX(endX) end

--- @param endY layout_measurement
--- @return void
function AnimationObjectTranslate:SetEndOffsetY(endY) end

--- @param startX layout_measurement
--- @return void
function AnimationObjectTranslate:SetStartOffsetX(startX) end

--- @param startY layout_measurement
--- @return void
function AnimationObjectTranslate:SetStartOffsetY(startY) end

--- @param deltaX layout_measurement
--- @param deltaY layout_measurement
--- @param translateAnimationDeltaType [TranslateAnimationDeltaType|#TranslateAnimationDeltaType]
--- @return void
function AnimationObjectTranslate:SetTranslateDeltas(deltaX, deltaY, translateAnimationDeltaType) end

--- @param startX layout_measurement
--- @param startY layout_measurement
--- @param endX layout_measurement
--- @param endY layout_measurement
--- @return void
function AnimationObjectTranslate:SetTranslateOffsets(startX, startY, endX, endY) end

---@class AnimationTimeline
AnimationTimeline = nil
--- @param animatedControl object
--- @return void
function AnimationTimeline:ApplyAllAnimationsToControl(animatedControl) end

--- @return void
function AnimationTimeline:ClearAllCallbacks() end

--- @return void
function AnimationTimeline:ClearAnimatedControlFromAllAnimations() end

--- @param animationIndex luaindex
--- @return object animation
function AnimationTimeline:GetAnimation(animationIndex) end

--- @param animation object
--- @return integer offset
function AnimationTimeline:GetAnimationOffset(animation) end

--- @param timelineIndex luaindex
--- @return object timeline
function AnimationTimeline:GetAnimationTimeline(timelineIndex) end

--- @param animation object
--- @return integer offset
function AnimationTimeline:GetAnimationTimelineOffset(animation) end

--- @return integer duration
function AnimationTimeline:GetDuration() end

--- @return object animation
function AnimationTimeline:GetFirstAnimation() end

--- @param animationType [AnimationType|#AnimationType]
--- @return object animation
function AnimationTimeline:GetFirstAnimationOfType(animationType) end

--- @return object timeline
function AnimationTimeline:GetFirstAnimationTimeline() end

--- @return number progress
function AnimationTimeline:GetFullProgress() end

--- @param eventName string
--- @param name string
--- @return function functionRef
function AnimationTimeline:GetHandler(eventName, name) end

--- @return object animation
function AnimationTimeline:GetLastAnimation() end

--- @return object timeline
function AnimationTimeline:GetLastAnimationTimeline() end

--- @return integer minDuration
function AnimationTimeline:GetMinDuration() end

--- @return integer numTimelines
function AnimationTimeline:GetNumAnimationTimelines() end

--- @return integer numAnimations
function AnimationTimeline:GetNumAnimations() end

--- @return object timeline
function AnimationTimeline:GetParent() end

--- @return integer loopsRemaining
function AnimationTimeline:GetPlaybackLoopsRemaining() end

--- @return number progress
function AnimationTimeline:GetProgress() end

--- @return bool skipAnimations
function AnimationTimeline:GetSkipAnimationsBehindPlayheadOnInitialPlay() end

--- @param animationType [AnimationType|#AnimationType]
--- @param animatedControl object
--- @param offset integer
--- @return object animation
function AnimationTimeline:InsertAnimation(animationType, animatedControl, offset) end

--- @param animationVirtualName string
--- @param animatedControl object
--- @return object animation
function AnimationTimeline:InsertAnimationFromVirtual(animationVirtualName, animatedControl) end

--- @param offset integer
--- @param animatedControl object
--- @return object animation
function AnimationTimeline:InsertAnimationTimeline(offset, animatedControl) end

--- @param animationVirtualName string
--- @param animatedControl object
--- @return object animation
function AnimationTimeline:InsertAnimationTimelineFromVirtual(animationVirtualName, animatedControl) end

--- @param functionRef function
--- @param offset integer
--- @return function functionRefRet
function AnimationTimeline:InsertCallback(functionRef, offset) end

--- @return bool isEnabled
function AnimationTimeline:IsEnabled() end

--- @return bool isPaused
function AnimationTimeline:IsPaused() end

--- @return bool isPlaying
function AnimationTimeline:IsPlaying() end

--- @return bool reversed
function AnimationTimeline:IsPlayingBackward() end

--- @return void
function AnimationTimeline:Pause() end

--- @return void
function AnimationTimeline:PlayBackward() end

--- @return void
function AnimationTimeline:PlayForward() end

--- @param offsetMs integer
--- @return void
function AnimationTimeline:PlayFromEnd(offsetMs) end

--- @param offsetMs integer
--- @return void
function AnimationTimeline:PlayFromStart(offsetMs) end

--- @param ignoreCallbacks bool
--- @return void
function AnimationTimeline:PlayInstantlyToEnd(ignoreCallbacks) end

--- @param ignoreCallbacks bool
--- @return void
function AnimationTimeline:PlayInstantlyToStart(ignoreCallbacks) end

--- @return void
function AnimationTimeline:Resume() end

--- @param offset integer
--- @return void
function AnimationTimeline:SetAllAnimationOffsets(offset) end

--- @param animation object
--- @param offset integer
--- @return void
function AnimationTimeline:SetAnimationOffset(animation, offset) end

--- @param animation object
--- @param offset integer
--- @return void
function AnimationTimeline:SetAnimationTimelineOffset(animation, offset) end

--- @param callback function
--- @param offset integer
--- @return void
function AnimationTimeline:SetCallbackOffset(callback, offset) end

--- @param enabled bool
--- @return void
function AnimationTimeline:SetEnabled(enabled) end

--- @param eventName string
--- @param functionRef function
--- @param name string
--- @param controlHandlerOrder [ControlHandlerOrder|#ControlHandlerOrder]
--- @param targetName string
--- @return void
function AnimationTimeline:SetHandler(eventName, functionRef, name, controlHandlerOrder, targetName) end

--- @param minDuration integer
--- @return void
function AnimationTimeline:SetMinDuration(minDuration) end

--- @param offset integer
--- @return void
function AnimationTimeline:SetOffsetInParent(offset) end

--- @param maxLoopCount integer
--- @return void
function AnimationTimeline:SetPlaybackLoopCount(maxLoopCount) end

--- @param loopsRemaining integer
--- @return void
function AnimationTimeline:SetPlaybackLoopsRemaining(loopsRemaining) end

--- @param playbackType integer
--- @param maxLoopCount integer
--- @return void
function AnimationTimeline:SetPlaybackType(playbackType, maxLoopCount) end

--- @param progress number
--- @return void
function AnimationTimeline:SetProgress(progress) end

--- @param skipAnimations bool
--- @return void
function AnimationTimeline:SetSkipAnimationsBehindPlayheadOnInitialPlay(skipAnimations) end

--- @return void
function AnimationTimeline:Stop() end

---@class BackdropControl
BackdropControl = nil
--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function BackdropControl:GetBlendMode() end

--- @return number r, number g, number b, number a
function BackdropControl:GetCenterColor() end

--- @return bool pixelRoundingEnabled
function BackdropControl:IsPixelRoundingEnabled() end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function BackdropControl:SetBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function BackdropControl:SetCenterColor(r, g, b, a) end

--- @param filename string
--- @param tilingInterval layout_measurement
--- @param addressMode [TextureAddressMode|#TextureAddressMode]
--- @return void
function BackdropControl:SetCenterTexture(filename, tilingInterval, addressMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function BackdropControl:SetEdgeColor(r, g, b, a) end

--- @param filename string
--- @param edgeFileWidth integer
--- @param edgeFileHeight integer
--- @param cornerSize layout_measurement
--- @param edgeFilePadding integer
--- @return void
function BackdropControl:SetEdgeTexture(filename, edgeFileWidth, edgeFileHeight, cornerSize, edgeFilePadding) end

--- @param left layout_measurement
--- @param top layout_measurement
--- @param right layout_measurement
--- @param bottom layout_measurement
--- @return void
function BackdropControl:SetInsets(left, top, right, bottom) end

--- @param integralWrappingEnabled bool
--- @return void
function BackdropControl:SetIntegralWrapping(integralWrappingEnabled) end

--- @param enabled bool
--- @return void
function BackdropControl:SetPixelRoundingEnabled(enabled) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function BackdropControl:SetTextureReleaseOption(releaseOption) end

---@class ButtonControl
ButtonControl = nil
--- @param button [MouseButtonIndex|#MouseButtonIndex]
--- @param enabled bool
--- @return void
function ButtonControl:EnableMouseButton(button, enabled) end

--- @return [TextAlignment|#TextAlignment] horizontalAlign
function ButtonControl:GetHorizontalAlignment() end

--- @return object labelControl
function ButtonControl:GetLabelControl() end

--- @return integer state
function ButtonControl:GetState() end

--- @return [TextAlignment|#TextAlignment] verticalAlign
function ButtonControl:GetVerticalAlignment() end

--- @return bool pixelRoundingEnabled
function ButtonControl:IsPixelRoundingEnabled() end

--- @param clickSound string
--- @return void
function ButtonControl:SetClickSound(clickSound) end

--- @param desaturation number
--- @return void
function ButtonControl:SetDesaturation(desaturation) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function ButtonControl:SetDisabledFontColor(r, g, b, a) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function ButtonControl:SetDisabledPressedFontColor(r, g, b, a) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetDisabledPressedTexture(textureFilename) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetDisabledTexture(textureFilename) end

--- @param enabled bool
--- @return void
function ButtonControl:SetEnabled(enabled) end

--- @param endCapWidth layout_measurement
--- @return void
function ButtonControl:SetEndCapWidth(endCapWidth) end

--- @param text string
--- @return void
function ButtonControl:SetFont(text) end

--- @param horizontalAlign [TextAlignment|#TextAlignment]
--- @return void
function ButtonControl:SetHorizontalAlignment(horizontalAlign) end

--- @param modifyTextType [ModifyTextType|#ModifyTextType]
--- @return void
function ButtonControl:SetModifyTextType(modifyTextType) end

--- @param blendMode integer
--- @return void
function ButtonControl:SetMouseOverBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function ButtonControl:SetMouseOverFontColor(r, g, b, a) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetMouseOverTexture(textureFilename) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function ButtonControl:SetNormalFontColor(r, g, b, a) end

--- @param x layout_measurement
--- @param y layout_measurement
--- @return void
function ButtonControl:SetNormalOffset(x, y) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetNormalTexture(textureFilename) end

--- @param pixelRoundingEnabled bool
--- @return void
function ButtonControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function ButtonControl:SetPressedFontColor(r, g, b, a) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetPressedMouseOverTexture(textureFilename) end

--- @param x layout_measurement
--- @param y layout_measurement
--- @return void
function ButtonControl:SetPressedOffset(x, y) end

--- @param textureFilename string
--- @return void
function ButtonControl:SetPressedTexture(textureFilename) end

--- @param showingHighlight bool
--- @return void
function ButtonControl:SetShowingHighlight(showingHighlight) end

--- @param newState integer
--- @param locked bool
--- @return void
function ButtonControl:SetState(newState, locked) end

--- @param text string
--- @return void
function ButtonControl:SetText(text) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function ButtonControl:SetTextureCoords(left, right, top, bottom) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function ButtonControl:SetTextureReleaseOption(releaseOption) end

--- @param verticalAlign [TextAlignment|#TextAlignment]
--- @return void
function ButtonControl:SetVerticalAlignment(verticalAlign) end

---@class ColorSelectControl
ColorSelectControl = nil
--- @return number hue, number saturation, number value
function ColorSelectControl:GetColorAsHSV() end

--- @return number red, number green, number blue
function ColorSelectControl:GetColorAsRGB() end

--- @return object textureControl
function ColorSelectControl:GetColorWheelTextureControl() end

--- @return object textureControl
function ColorSelectControl:GetColorWheelThumbTextureControl() end

--- @return number red, number green, number blue
function ColorSelectControl:GetFullValuedColorAsRGB() end

--- @return number normalizedX, number normalizedY
function ColorSelectControl:GetThumbNormalizedPosition() end

--- @return number value
function ColorSelectControl:GetValue() end

--- @param hue number
--- @param saturation number
--- @param value number
--- @return void
function ColorSelectControl:SetColorAsHSV(hue, saturation, value) end

--- @param red number
--- @param green number
--- @param blue number
--- @return void
function ColorSelectControl:SetColorAsRGB(red, green, blue) end

--- @param textureControl object
--- @return void
function ColorSelectControl:SetColorWheelThumbTextureControl(textureControl) end

--- @param normalizedX number
--- @param normalizedY number
--- @return void
function ColorSelectControl:SetThumbNormalizedPosition(normalizedX, normalizedY) end

--- @param value number
--- @return void
function ColorSelectControl:SetValue(value) end

---@class CompassDisplayControl
CompassDisplayControl = nil
--- @param pinType [MapDisplayPinType|#MapDisplayPinType]
--- @return number closeAlpha, number farAlpha, number closeAlphaDistanceM, number farAlphaDistanceM
function CompassDisplayControl:GetAlphaDropoffBehavior(pinType) end

--- @param centerOveredPinIndex luaindex
--- @return string description
function CompassDisplayControl:GetCenterOveredPinDescription(centerOveredPinIndex) end

--- @param centerOveredPinIndex luaindex
--- @return number distanceFromPlayerCM
function CompassDisplayControl:GetCenterOveredPinDistance(centerOveredPinIndex) end

--- @param centerOveredPinIndex luaindex
--- @return string description, [MapDisplayPinType|#MapDisplayPinType] type, number distanceFromPlayerCM, [DrawLayer|#DrawLayer] drawLayer, integer drawLevel, bool suppressed
function CompassDisplayControl:GetCenterOveredPinInfo(centerOveredPinIndex) end

--- @param centerOveredPinIndex luaindex
--- @return [DrawLayer|#DrawLayer] drawLayer, integer drawLevel
function CompassDisplayControl:GetCenterOveredPinLayerAndLevel(centerOveredPinIndex) end

--- @param centerOveredPinIndex luaindex
--- @return [MapDisplayPinType|#MapDisplayPinType] type
function CompassDisplayControl:GetCenterOveredPinType(centerOveredPinIndex) end

--- @return integer numCenterOveredPins
function CompassDisplayControl:GetNumCenterOveredPins() end

--- @param pinType [MapDisplayPinType|#MapDisplayPinType]
--- @return number closeScale, number farScale, number closeScaleDistanceM, number farScaleDistanceM
function CompassDisplayControl:GetScaleDropoffBehavior(pinType) end

--- @param centerOveredPinIndex luaindex
--- @return bool suppressed
function CompassDisplayControl:IsCenterOveredPinSuppressed(centerOveredPinIndex) end

--- @param pinType [MapDisplayPinType|#MapDisplayPinType]
--- @param closeAlpha number
--- @param farAlpha number
--- @param closeAlphaDistanceM number
--- @param farAlphaDistanceM number
--- @return void
function CompassDisplayControl:SetAlphaDropoffBehavior(pinType, closeAlpha, farAlpha, closeAlphaDistanceM, farAlphaDistanceM) end

--- @param directionName string
--- @param font string
--- @param cardinalDirection integer
--- @return void
function CompassDisplayControl:SetCardinalDirection(directionName, font, cardinalDirection) end

--- @param type [MapDisplayPinType|#MapDisplayPinType]
--- @param pinSize number
--- @param pinTexture string
--- @param areaTexture string
--- @param aboveTexture string
--- @param belowTexture string
--- @param linkTexture string
--- @param clamped bool
--- @param allowUpdatesWhenAnimating bool
--- @param maxDistanceM number
--- @param closeScale number
--- @param farScale number
--- @param closeScaleDistanceM number
--- @param farScaleDistanceM number
--- @param closeAlpha number
--- @param farAlpha number
--- @param closeAlphaDistanceM number
--- @param farAlphaDistanceM number
--- @param animation string
--- @param addedAnimation string
--- @param removedAnimation string
--- @param layer [DrawLayer|#DrawLayer]
--- @param drawLevelOffsetBase integer
--- @return void
function CompassDisplayControl:SetPinInfo(type, pinSize, pinTexture, areaTexture, aboveTexture, belowTexture, linkTexture, clamped, allowUpdatesWhenAnimating, maxDistanceM, closeScale, farScale, closeScaleDistanceM, farScaleDistanceM, closeAlpha, farAlpha, closeAlphaDistanceM, farAlphaDistanceM, animation, addedAnimation, removedAnimation, layer, drawLevelOffsetBase) end

--- @param pinType [MapDisplayPinType|#MapDisplayPinType]
--- @param closeScale number
--- @param farScale number
--- @param closeScaleDistanceM number
--- @param farScaleDistanceM number
--- @return void
function CompassDisplayControl:SetScaleDropoffBehavior(pinType, closeScale, farScale, closeScaleDistanceM, farScaleDistanceM) end

---@class Control
Control = nil
--- @param event integer
--- @param filterParameter variant
--- @return bool success
function Control:AddFilterForEvent(event, filterParameter) end

--- @param deltaXRadians number
--- @param deltaYRadians number
--- @param deltaZRadians number
--- @return void
function Control:AddTransformRotation(deltaXRadians, deltaYRadians, deltaZRadians) end

--- @param deltaXRadians number
--- @return void
function Control:AddTransformRotationX(deltaXRadians) end

--- @param deltaYRadians number
--- @return void
function Control:AddTransformRotationY(deltaYRadians) end

--- @param deltaZRadians number
--- @return void
function Control:AddTransformRotationZ(deltaZRadians) end

--- @param childControl object
--- @return void
function Control:AppendChild(childControl) end --*protected-attributes*

--- @return void
function Control:ClearAnchors() end --*protected-attributes*

--- @return void
function Control:ClearCircularClip() end

--- @return void
function Control:ClearClips() end

--- @return void
function Control:ClearDimensions() end --*protected-attributes*

--- @return void
function Control:ClearFadeGradients() end

--- @return void
function Control:ClearMask() end

--- @return void
function Control:ClearRectangularClip() end

--- @return void
function Control:ClearShaderEffectOptions() end

--- @return void
function Control:ClearSuggestedDimensions() end --*protected-attributes*

--- @return void
function Control:ClearTransform() end

--- @return void
function Control:ClearTransformOffset() end

--- @return void
function Control:ClearTransformRotation() end

--- @return void
function Control:ClearTransformScale() end

--- @return void
function Control:ClearTransformSkew() end

--- @param localPitch number
--- @param localYaw number
--- @param localRoll number
--- @return number worldPitch, number worldYaw, number worldRoll
function Control:Convert3DLocalOrientationToWorldOrientation(localPitch, localYaw, localRoll) end

--- @param localX number
--- @param localY number
--- @param localZ number
--- @return number worldX, number worldY, number worldZ
function Control:Convert3DLocalPositionToWorldPosition(localX, localY, localZ) end

--- @param worldPitch number
--- @param worldYaw number
--- @param worldRoll number
--- @return number localPitch, number localYaw, number localRoll
function Control:Convert3DWorldOrientationToLocalOrientation(worldPitch, worldYaw, worldRoll) end

--- @param worldX number
--- @param worldY number
--- @param worldZ number
--- @return number localX, number localY, number localZ
function Control:Convert3DWorldPositionToLocalPosition(worldX, worldY, worldZ) end

--- @return void
function Control:Create3DRenderSpace() end

--- @param childControlName string
--- @param childControlType [ControlType|#ControlType]
--- @return object childControl
function Control:CreateControl(childControlName, childControlType) end

--- @return void
function Control:Destroy3DRenderSpace() end

--- @return bool usesDepthBuffer
function Control:Does3DRenderSpaceUseDepthBuffer() end

--- @param root object
--- @return bool doesControlDescendFromRoot
function Control:DoesControlDescendFrom(root) end

--- @return [AxisRotationOrder|#AxisRotationOrder] axisRotationOrder
function Control:Get3DRenderSpaceAxisRotationOrder() end

--- @return number x, number y, number z
function Control:Get3DRenderSpaceForward() end

--- @return number pitchRadians, number yawRadians, number rollRadians
function Control:Get3DRenderSpaceOrientation() end

--- @return number x, number y, number z
function Control:Get3DRenderSpaceOrigin() end

--- @return number x, number y, number z
function Control:Get3DRenderSpaceRight() end

--- @return [GuiRender3DSpaceSystem|#GuiRender3DSpaceSystem] system
function Control:Get3DRenderSpaceSystem() end

--- @return number x, number y, number z
function Control:Get3DRenderSpaceUp() end

--- @return number alpha
function Control:GetAlpha() end

--- @param anchorIndex integer
--- @return bool isValidAnchor, [AnchorPosition|#AnchorPosition] point, object relativeTo, [AnchorPosition|#AnchorPosition] relativePoint, number offsetX, number offsetY, [AnchorConstrains|#AnchorConstrains] anchorConstrains
function Control:GetAnchor(anchorIndex) end

--- @return bool autoRectClipChildren
function Control:GetAutoRectClipChildren() end

--- @return number bottom
function Control:GetBottom() end

--- @return number frequencyX, number frequencyY, number speed, number offset
function Control:GetCaustic() end

--- @return number offset
function Control:GetCausticOffset() end

--- @return number centerX, number centerY
function Control:GetCenter() end

--- @param childIndex luaindex
--- @return object childControl
function Control:GetChild(childIndex) end

--- @return [FlexAlignment|#FlexAlignment] alignment
function Control:GetChildFlexContentAlignment() end

--- @return [FlexDirection|#FlexDirection] direction
function Control:GetChildFlexDirection() end

--- @return [FlexAlignment|#FlexAlignment] alignment
function Control:GetChildFlexItemAlignment() end

--- @return [FlexJustification|#FlexJustification] justification
function Control:GetChildFlexJustification() end

--- @return [FlexWrap|#FlexWrap] wrap
function Control:GetChildFlexWrap() end

--- @return [ChildLayoutType|#ChildLayoutType] childLayoutType
function Control:GetChildLayout() end

--- @return bool clamped
function Control:GetClampedToScreen() end

--- @return number left, number top, number right, number bottom
function Control:GetClampedToScreenInsets() end

--- @return number alpha
function Control:GetControlAlpha() end

--- @return number scale
function Control:GetControlScale() end

--- @return [Space|#Space]:nilable space
function Control:GetControlSpace() end

--- @return number height
function Control:GetDesiredHeight() end

--- @return number width
function Control:GetDesiredWidth() end

--- @return number minWidth, number minHeight, number maxWidth, number maxHeight
function Control:GetDimensionConstraints() end

--- @return number width, number height
function Control:GetDimensions() end

--- @return [DrawLayer|#DrawLayer] layer
function Control:GetDrawLayer() end

--- @return integer level
function Control:GetDrawLevel() end

--- @return [DrawTier|#DrawTier] tier
function Control:GetDrawTier() end

--- @return bool exclude
function Control:GetExcludeFromFlexbox() end

--- @return bool excludes
function Control:GetExcludeFromResizeToFitExtents() end

--- @param gradientIndex luaindex
--- @return number normalX, number normalY, number gradientLength
function Control:GetFadeGradient(gradientIndex) end

--- @return number:nilable growOrShrink
function Control:GetFlex() end

--- @return [FlexAlignment|#FlexAlignment] alignment
function Control:GetFlexAlignSelf() end

--- @return number basis
function Control:GetFlexBasis() end

--- @return number grow
function Control:GetFlexGrow() end

--- @param edge [FlexEdge|#FlexEdge]
--- @return number margin
function Control:GetFlexMargin(edge) end

--- @param edge [FlexEdge|#FlexEdge]
--- @return number padding
function Control:GetFlexPadding(edge) end

--- @return number shrink
function Control:GetFlexShrink() end

--- @return integer kernelSize, number factor
function Control:GetGaussianBlur() end

--- @param handlerName string
--- @param name string
--- @return function functionRef
function Control:GetHandler(handlerName, name) end

--- @return number height
function Control:GetHeight() end

--- @return number left, number top, number right, number bottom
function Control:GetHitInsets() end

--- @return integer id
function Control:GetId() end

--- @return bool inheritAlpha
function Control:GetInheritsAlpha() end

--- @return bool inheritScale
function Control:GetInheritsScale() end

--- @return number left
function Control:GetLeft() end

--- @return number normalizedThickness
function Control:GetMaskThresholdThickness() end

--- @return number normalizedEdge
function Control:GetMaskThresholdZeroAlphaEdge() end

--- @return number blurVectorXAsAPercentageOfControlWidth, number blurVectorYAsAPercentageOfControlHeight, integer numSamples
function Control:GetMotionBlur() end

--- @return string name
function Control:GetName() end

--- @param childName string
--- @return object returnedControl
function Control:GetNamedChild(childName) end

--- @return integer numAnchors
function Control:GetNumAnchors() end

--- @return integer numChildren
function Control:GetNumChildren() end

--- @return object OwningTopLevelWindow
function Control:GetOwningWindow() end

--- @return object ret1
function Control:GetParent() end

--- @return number originX, number originY, integer numSamples, number blurRadius, number offsetRadius
function Control:GetRadialBlur() end

--- @return [AnchorConstrains|#AnchorConstrains] constrains
function Control:GetResizeToFitConstrains() end

--- @return bool resizes
function Control:GetResizeToFitDescendents() end

--- @return number width, number height
function Control:GetResizeToFitPadding() end

--- @return number right
function Control:GetRight() end

--- @return number scale
function Control:GetScale() end

--- @return number left, number top, number right, number bottom
function Control:GetScreenRect() end

--- @return [Space|#Space] space
function Control:GetSpace() end

--- @return number width, number height
function Control:GetSuggestedDimensions() end

--- @return number height
function Control:GetSuggestedHeight() end

--- @return number width
function Control:GetSuggestedWidth() end

--- @return number top
function Control:GetTop() end

--- @return number normalizedX, number normalizedY
function Control:GetTransformNormalizedOriginPoint() end

--- @return number x, number y, number z
function Control:GetTransformOffset() end

--- @return number xRadians, number yRadians, number zRadians
function Control:GetTransformRotation() end

--- @return [AxisRotationOrder|#AxisRotationOrder] order
function Control:GetTransformRotationAxisOrder() end

--- @return number scaleX, number scaleY, number scaleZ
function Control:GetTransformScale() end

--- @return number skewXRadians, number skewYRadians
function Control:GetTransformSkew() end

--- @return [ControlType|#ControlType] type
function Control:GetType() end

--- @return number angleRadians, number frequency, number speed, number offset
function Control:GetWave() end

--- @return number angleRadians
function Control:GetWaveAngle() end

--- @return number minX, number maxX, number minY, number maxY
function Control:GetWaveBounds() end

--- @return number frequency
function Control:GetWaveFrequency() end

--- @return number offset
function Control:GetWaveOffset() end

--- @return number speed
function Control:GetWaveSpeed() end

--- @return number width
function Control:GetWidth() end

--- @return bool has3DRenderSpace
function Control:Has3DRenderSpace() end

--- @param childControl object
--- @param nextChild object
--- @return void
function Control:InsertChildBefore(childControl, nextChild) end --*protected-attributes*

--- @param desiredParent object
--- @return bool isChild
function Control:IsChildOf(desiredParent) end

--- @return bool hidden
function Control:IsControlHidden() end

--- @param handlerName string
--- @param name string
--- @return bool isSet
function Control:IsHandlerSet(handlerName, name) end

--- @return bool hidden
function Control:IsHidden() end

--- @return bool enabled
function Control:IsKeyboardEnabled() end

--- @return bool enabled
function Control:IsMouseEnabled() end

--- @param x layout_measurement
--- @param y layout_measurement
--- @param leftOffset layout_measurement:nilable
--- @param topOffset layout_measurement:nilable
--- @param rightOffset layout_measurement:nilable
--- @param bottomOffset layout_measurement:nilable
--- @return bool isInside
function Control:IsPointInside(x, y, leftOffset, topOffset, rightOffset, bottomOffset) end

--- @return number x1, number y1, number x2, number y2, number x3, number y3, number x4, number y4
function Control:ProjectRectToScreen() end

--- @return number left, number top, number right, number bottom
function Control:ProjectRectToScreenAndBuildAABB() end

--- @param point [AnchorPosition|#AnchorPosition]
--- @return number screenX, number screenY
function Control:ProjectRectToScreenAndComputeAABBPoint(point) end

--- @param point [AnchorPosition|#AnchorPosition]
--- @return number screenX, number screenY
function Control:ProjectRectToScreenAndComputeClampedAABBPoint(point) end

--- @param normalizedX number
--- @param normalizedY number
--- @return number screenX, number screenY
function Control:ProjectToScreen(normalizedX, normalizedY) end

--- @param event integer
--- @param callback function
--- @return bool success
function Control:RegisterForEvent(event, callback) end

--- @return void
function Control:ResetTransformNormalizedOriginPoint() end

--- @param axisRotationOrder [AxisRotationOrder|#AxisRotationOrder]
--- @return void
function Control:Set3DRenderSpaceAxisRotationOrder(axisRotationOrder) end

--- @param x number
--- @param y number
--- @param z number
--- @return void
function Control:Set3DRenderSpaceForward(x, y, z) end

--- @param pitchRadians number
--- @param yawRadians number
--- @param rollRadians number
--- @return void
function Control:Set3DRenderSpaceOrientation(pitchRadians, yawRadians, rollRadians) end

--- @param xM number
--- @param yM number
--- @param zM number
--- @return void
function Control:Set3DRenderSpaceOrigin(xM, yM, zM) end

--- @param x number
--- @param y number
--- @param z number
--- @return void
function Control:Set3DRenderSpaceRight(x, y, z) end

--- @param system [GuiRender3DSpaceSystem|#GuiRender3DSpaceSystem]
--- @return void
function Control:Set3DRenderSpaceSystem(system) end

--- @param x number
--- @param y number
--- @param z number
--- @return void
function Control:Set3DRenderSpaceUp(x, y, z) end

--- @param usesDepthBuffer bool
--- @return void
function Control:Set3DRenderSpaceUsesDepthBuffer(usesDepthBuffer) end

--- @param alpha number
--- @return void
function Control:SetAlpha(alpha) end --*protected-attributes*

--- @param point [AnchorPosition|#AnchorPosition]
--- @param relativeTo object
--- @param relativePoint [AnchorPosition|#AnchorPosition]
--- @param offsetX layout_measurement
--- @param offsetY layout_measurement
--- @param anchorConstrains [AnchorConstrains|#AnchorConstrains]
--- @return void
function Control:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY, anchorConstrains) end --*protected-attributes*

--- @param anchorTargetControl object
--- @return void
function Control:SetAnchorFill(anchorTargetControl) end --*protected-attributes*

--- @param offsetX layout_measurement
--- @param offsetY layout_measurement
--- @param anchorIndex luaindex
--- @return void
function Control:SetAnchorOffsets(offsetX, offsetY, anchorIndex) end

--- @param autoRectClipChildren bool
--- @return void
function Control:SetAutoRectClipChildren(autoRectClipChildren) end

--- @param frequencyX number
--- @param frequencyY number
--- @param speed number
--- @param offset number
--- @return void
function Control:SetCaustic(frequencyX, frequencyY, speed, offset) end

--- @param offset number
--- @return void
function Control:SetCausticOffset(offset) end

--- @param alignment [FlexAlignment|#FlexAlignment]
--- @return void
function Control:SetChildFlexContentAlignment(alignment) end

--- @param direction [FlexDirection|#FlexDirection]
--- @return void
function Control:SetChildFlexDirection(direction) end

--- @param alignment [FlexAlignment|#FlexAlignment]
--- @return void
function Control:SetChildFlexItemAlignment(alignment) end

--- @param justification [FlexJustification|#FlexJustification]
--- @return void
function Control:SetChildFlexJustification(justification) end

--- @param wrap [FlexWrap|#FlexWrap]
--- @return void
function Control:SetChildFlexWrap(wrap) end

--- @param childLayoutType [ChildLayoutType|#ChildLayoutType]
--- @return void
function Control:SetChildLayout(childLayoutType) end

--- @param centerX number
--- @param centerY number
--- @param radius number
--- @return void
function Control:SetCircularClip(centerX, centerY, radius) end

--- @param clamped bool
--- @return void
function Control:SetClampedToScreen(clamped) end

--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
--- @return void
function Control:SetClampedToScreenInsets(left, top, right, bottom) end

--- @param minWidth layout_measurement
--- @param minHeight layout_measurement
--- @param maxWidth layout_measurement
--- @param maxHeight layout_measurement
--- @return void
function Control:SetDimensionConstraints(minWidth, minHeight, maxWidth, maxHeight) end

--- @param width layout_measurement
--- @param height layout_measurement
--- @return void
function Control:SetDimensions(width, height) end --*protected-attributes*

--- @param layer [DrawLayer|#DrawLayer]
--- @return void
function Control:SetDrawLayer(layer) end --*protected-attributes*

--- @param level integer
--- @return void
function Control:SetDrawLevel(level) end --*protected-attributes*

--- @param tier [DrawTier|#DrawTier]
--- @return void
function Control:SetDrawTier(tier) end --*protected-attributes*

--- @param exclude bool
--- @return void
function Control:SetExcludeFromFlexbox(exclude) end

--- @param exclude bool
--- @return void
function Control:SetExcludeFromResizeToFitExtents(exclude) end --*protected-attributes*

--- @param gradientIndex luaindex
--- @param normalX number
--- @param normalY number
--- @param gradientLength number
--- @return void
function Control:SetFadeGradient(gradientIndex, normalX, normalY, gradientLength) end

--- @param growOrShrink number:nilable
--- @return void
function Control:SetFlex(growOrShrink) end

--- @param alignment [FlexAlignment|#FlexAlignment]
--- @return void
function Control:SetFlexAlignSelf(alignment) end

--- @param basis number
--- @return void
function Control:SetFlexBasis(basis) end

--- @param grow number
--- @return void
function Control:SetFlexGrow(grow) end

--- @param edge [FlexEdge|#FlexEdge]
--- @param margin number
--- @return void
function Control:SetFlexMargin(edge, margin) end

--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
--- @return void
function Control:SetFlexMargins(left, top, right, bottom) end

--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
--- @return void
function Control:SetFlexPaddings(left, top, right, bottom) end

--- @param shrink number
--- @return void
function Control:SetFlexShrink(shrink) end

--- @param kernelSize integer
--- @param factor number
--- @return void
function Control:SetGaussianBlur(kernelSize, factor) end

--- @param handlerName string
--- @param functionRef function
--- @param name string
--- @param controlHandlerOrder [ControlHandlerOrder|#ControlHandlerOrder]
--- @param targetName string
--- @return void
function Control:SetHandler(handlerName, functionRef, name, controlHandlerOrder, targetName) end

--- @param height layout_measurement
--- @return void
function Control:SetHeight(height) end --*protected-attributes*

--- @param aHidden bool
--- @return void
function Control:SetHidden(aHidden) end --*protected-attributes*

--- @param left layout_measurement
--- @param top layout_measurement
--- @param right layout_measurement
--- @param bottom layout_measurement
--- @return void
function Control:SetHitInsets(left, top, right, bottom) end

--- @param id integer
--- @return void
function Control:SetId(id) end

--- @param inheritAlpha bool
--- @return void
function Control:SetInheritAlpha(inheritAlpha) end

--- @param inheritScale bool
--- @return void
function Control:SetInheritScale(inheritScale) end

--- @param enabled bool
--- @return void
function Control:SetKeyboardEnabled(enabled) end --*protected-attributes*

--- @param maskMode [ControlMaskMode|#ControlMaskMode]
--- @return void
function Control:SetMaskMode(maskMode) end

--- @param fileName string
--- @return void
function Control:SetMaskTexture(fileName) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function Control:SetMaskTextureReleaseOption(releaseOption) end

--- @param normalizedThickness number
--- @return void
function Control:SetMaskThresholdThickness(normalizedThickness) end

--- @param normalizedEdge number
--- @return void
function Control:SetMaskThresholdZeroAlphaEdge(normalizedEdge) end

--- @param blurVectorXAsAPercentageOfControlWidth number
--- @param blurVectorYAsAPercentageOfControlHeight number
--- @param numSamples integer
--- @return void
function Control:SetMotionBlur(blurVectorXAsAPercentageOfControlWidth, blurVectorYAsAPercentageOfControlHeight, numSamples) end

--- @param enabled bool
--- @return void
function Control:SetMouseEnabled(enabled) end --*protected-attributes*

--- @param isMovable bool
--- @return void
function Control:SetMovable(isMovable) end

--- @param newParent object
--- @return void
function Control:SetParent(newParent) end --*protected-attributes*

--- @param originX number
--- @param originY number
--- @param numSamples integer
--- @param blurRadius number
--- @param offsetRadius number
--- @return void
function Control:SetRadialBlur(originX, originY, numSamples, blurRadius, offsetRadius) end

--- @param left number
--- @param top number
--- @param right number
--- @param bottom number
--- @return void
function Control:SetRectangularClip(left, top, right, bottom) end

--- @param handleSize number
--- @return void
function Control:SetResizeHandleSize(handleSize) end

--- @param constrains [AnchorConstrains|#AnchorConstrains]
--- @return void
function Control:SetResizeToFitConstrains(constrains) end

--- @param resize bool
--- @return void
function Control:SetResizeToFitDescendents(resize) end --*protected-attributes*

--- @param width layout_measurement
--- @param height layout_measurement
--- @return void
function Control:SetResizeToFitPadding(width, height) end

--- @param scale number
--- @return void
function Control:SetScale(scale) end --*protected-attributes*

--- @param shapeType integer
--- @return void
function Control:SetShapeType(shapeType) end

--- @param anchorTargetControl object
--- @param offsetX number
--- @param offsetY number
--- @return void
function Control:SetSimpleAnchor(anchorTargetControl, offsetX, offsetY) end --*protected-attributes*

--- @param offsetX number
--- @param offsetY number
--- @return void
function Control:SetSimpleAnchorParent(offsetX, offsetY) end --*protected-attributes*

--- @param space [Space|#Space]:nilable
--- @return void
function Control:SetSpace(space) end

--- @param normalizedX number
--- @param normalizedY number
--- @return void
function Control:SetTransformNormalizedOriginPoint(normalizedX, normalizedY) end

--- @param x layout_measurement
--- @param y layout_measurement
--- @param z layout_measurement
--- @return void
function Control:SetTransformOffset(x, y, z) end

--- @param x layout_measurement
--- @return void
function Control:SetTransformOffsetX(x) end

--- @param y layout_measurement
--- @return void
function Control:SetTransformOffsetY(y) end

--- @param z layout_measurement
--- @return void
function Control:SetTransformOffsetZ(z) end

--- @param xRadians number
--- @param yRadians number
--- @param zRadians number
--- @return void
function Control:SetTransformRotation(xRadians, yRadians, zRadians) end

--- @param deltaXRadians number
--- @param deltaYRadians number
--- @param deltaZRadians number
--- @param order [AxisRotationOrder|#AxisRotationOrder]
--- @return void
function Control:SetTransformRotationAndOrder(deltaXRadians, deltaYRadians, deltaZRadians, order) end

--- @param order [AxisRotationOrder|#AxisRotationOrder]
--- @return void
function Control:SetTransformRotationAxisOrder(order) end

--- @param xRadians number
--- @return void
function Control:SetTransformRotationX(xRadians) end

--- @param yRadians number
--- @return void
function Control:SetTransformRotationY(yRadians) end

--- @param zRadians number
--- @return void
function Control:SetTransformRotationZ(zRadians) end

--- @param scale number
--- @return void
function Control:SetTransformScale(scale) end

--- @param scaleX number
--- @return void
function Control:SetTransformScaleX(scaleX) end

--- @param scaleY number
--- @return void
function Control:SetTransformScaleY(scaleY) end

--- @param scaleZ number
--- @return void
function Control:SetTransformScaleZ(scaleZ) end

--- @param skewXRadians number
--- @param skewYRadians number
--- @return void
function Control:SetTransformSkew(skewXRadians, skewYRadians) end

--- @param skewXRadians number
--- @return void
function Control:SetTransformSkewX(skewXRadians) end

--- @param skewYRadians number
--- @return void
function Control:SetTransformSkewY(skewYRadians) end

--- @param angleRadians number
--- @param frequency number
--- @param speed number
--- @param offset number
--- @return void
function Control:SetWave(angleRadians, frequency, speed, offset) end

--- @param angleRadians number
--- @return void
function Control:SetWaveAngle(angleRadians) end

--- @param minX number
--- @param maxX number
--- @param minY number
--- @param maxY number
--- @return void
function Control:SetWaveBounds(minX, maxX, minY, maxY) end

--- @param frequency number
--- @return void
function Control:SetWaveFrequency(frequency) end

--- @param offset number
--- @return void
function Control:SetWaveOffset(offset) end

--- @param speed number
--- @return void
function Control:SetWaveSpeed(speed) end

--- @param width layout_measurement
--- @return void
function Control:SetWidth(width) end --*protected-attributes*

--- @return bool isMoving
function Control:StartMoving() end --*protected-attributes*

--- @return void
function Control:StopMovingOrResizing() end --*protected-attributes*

--- @param width number
--- @param height number
--- @return void
function Control:SuggestDimensions(width, height) end --*protected-attributes*

--- @param height number
--- @return void
function Control:SuggestHeight(height) end --*protected-attributes*

--- @param width number
--- @return void
function Control:SuggestWidth(width) end --*protected-attributes*

--- @return void
function Control:ToggleHidden() end --*protected-attributes*

--- @param event integer
--- @return bool success
function Control:UnregisterForEvent(event) end

---@class CooldownControl
CooldownControl = nil
--- @return integer duration
function CooldownControl:GetDuration() end

--- @return number percentComplete
function CooldownControl:GetPercentCompleteFixed() end

--- @return integer time
function CooldownControl:GetTimeLeft() end

--- @return void
function CooldownControl:ResetCooldown() end

--- @param blendMode integer
--- @return void
function CooldownControl:SetBlendMode(blendMode) end

--- @param remain integer
--- @return void
function CooldownControl:SetCooldownRemainTime(remain) end

--- @param desaturation number
--- @return void
function CooldownControl:SetDesaturation(desaturation) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function CooldownControl:SetFillColor(r, g, b, a) end

--- @param filename string
--- @return void
function CooldownControl:SetLeadingEdgeTexture(filename) end

--- @param percentComplete number
--- @return void
function CooldownControl:SetPercentCompleteFixed(percentComplete) end

--- @param clockwise bool
--- @return void
function CooldownControl:SetRadialCooldownClockwise(clockwise) end

--- @param startAlpha number
--- @param angularDistance number
--- @return void
function CooldownControl:SetRadialCooldownGradient(startAlpha, angularDistance) end

--- @param originAngle number
--- @return void
function CooldownControl:SetRadialCooldownOriginAngle(originAngle) end

--- @param filename string
--- @return void
function CooldownControl:SetTexture(filename) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function CooldownControl:SetTextureReleaseOption(releaseOption) end

--- @param leadingEdgeHeight integer
--- @return void
function CooldownControl:SetVerticalCooldownLeadingEdgeHeight(leadingEdgeHeight) end

--- @param remain integer
--- @param duration integer
--- @param cooldownType integer
--- @param cooldownTimeType integer
--- @param drawLeadingEdge bool
--- @return void
function CooldownControl:StartCooldown(remain, duration, cooldownType, cooldownTimeType, drawLeadingEdge) end

--- @param percentComplete number
--- @param cooldownType integer
--- @param cooldownTimeType integer
--- @param drawLeadingEdge bool
--- @return void
function CooldownControl:StartFixedCooldown(percentComplete, cooldownType, cooldownTimeType, drawLeadingEdge) end

---@class DebugTextControl
DebugTextControl = nil
--- @return void
function DebugTextControl:Clear() end

--- @param fontStr string
--- @return void
function DebugTextControl:SetFont(fontStr) end

---@class EditControl
EditControl = nil
--- @param validCharacter string
--- @return void
function EditControl:AddValidCharacter(validCharacter) end

--- @return void
function EditControl:Clear() end

--- @return void
function EditControl:ClearSelection() end

--- @return void
function EditControl:CopyAllTextToClipboard() end --*private*

--- @return [AllowMarkupType|#AllowMarkupType] allowMarkupType
function EditControl:GetAllowMarkupType() end

--- @return bool enabled
function EditControl:GetCopyEnabled() end

--- @return integer cursorPosition
function EditControl:GetCursorPosition() end

--- @return string apRet
function EditControl:GetDefaultText() end

--- @return bool enabled
function EditControl:GetEditEnabled() end

--- @return number fontHeightUIUnits
function EditControl:GetFontHeight() end

--- @return number leftControlSpace, number topControlSpace, number rightControlSpace, number bottomControlSpace
function EditControl:GetIMECompositionExclusionArea() end

--- @return integer maxChars
function EditControl:GetMaxInputChars() end

--- @return bool enabled
function EditControl:GetNewLineEnabled() end

--- @return bool enabled
function EditControl:GetPasteEnabled() end

--- @return integer numLines
function EditControl:GetScrollExtents() end

--- @return bool enabled
function EditControl:GetSelectAllOnFocus() end

--- @return string apRet
function EditControl:GetText() end

--- @return [TextType|#TextType] textType
function EditControl:GetTextType() end

--- @return luaindex index
function EditControl:GetTopLineIndex() end

--- @return bool aRet
function EditControl:HasFocus() end

--- @return bool hasSelection
function EditControl:HasSelection() end

--- @param aText string
--- @return void
function EditControl:InsertText(aText) end

--- @return bool isComposing
function EditControl:IsComposingIMEText() end

--- @return bool isMultiLine
function EditControl:IsMultiLine() end

--- @return bool isPassword
function EditControl:IsPassword() end

--- @return void
function EditControl:LoseFocus() end

--- @return void
function EditControl:RemoveAllValidCharacters() end

--- @return void
function EditControl:SelectAll() end

--- @param allowMarkupType [AllowMarkupType|#AllowMarkupType]
--- @return void
function EditControl:SetAllowMarkupType(allowMarkupType) end

--- @param isPassword bool
--- @return void
function EditControl:SetAsPassword(isPassword) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function EditControl:SetColor(r, g, b, a) end

--- @param enabled bool
--- @return void
function EditControl:SetCopyEnabled(enabled) end

--- @param cursorPosition integer
--- @return void
function EditControl:SetCursorPosition(cursorPosition) end

--- @param aDefaultText string
--- @return void
function EditControl:SetDefaultText(aDefaultText) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function EditControl:SetDefaultTextColor(r, g, b, a) end

--- @param enabled bool
--- @return void
function EditControl:SetEditEnabled(enabled) end

--- @param font string
--- @return void
function EditControl:SetFont(font) end

--- @param maxChars integer
--- @return void
function EditControl:SetMaxInputChars(maxChars) end

--- @param isMultiLine bool
--- @return void
function EditControl:SetMultiLine(isMultiLine) end

--- @param enabled bool
--- @return void
function EditControl:SetNewLineEnabled(enabled) end

--- @param enabled bool
--- @return void
function EditControl:SetPasteEnabled(enabled) end

--- @param enabled bool
--- @return void
function EditControl:SetSelectAllOnFocus(enabled) end

--- @param selectionStartIndex integer
--- @param selectionEndIndex integer
--- @return void
function EditControl:SetSelection(selectionStartIndex, selectionEndIndex) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function EditControl:SetSelectionColor(r, g, b, a) end

--- @param aText string
--- @param aSuppressCallbackHandler bool
--- @return void
function EditControl:SetText(aText, aSuppressCallbackHandler) end

--- @param textType [TextType|#TextType]
--- @return void
function EditControl:SetTextType(textType) end

--- @param index luaindex
--- @return void
function EditControl:SetTopLineIndex(index) end

--- @param aKeyboardType [VirtualKeyboardType|#VirtualKeyboardType]
--- @return void
function EditControl:SetVirtualKeyboardType(aKeyboardType) end

--- @return void
function EditControl:TakeFocus() end

--- @return bool aRet
function EditControl:WasLastChangeVirtualKeyboard() end

---@class FontObject
FontObject = nil
--- @return string face, integer size, string option
function FontObject:GetFontInfo() end

--- @param fontDescriptor string
--- @return void
function FontObject:SetFont(fontDescriptor) end

---@class LabelControl
LabelControl = nil
--- @param toLabel object
--- @param offsetX layout_measurement
--- @param anchorSide [AnchorPosition|#AnchorPosition]
--- @return void
function LabelControl:AnchorToBaseline(toLabel, offsetX, anchorSide) end

--- @return void
function LabelControl:Clean() end

--- @param toLabel object
--- @return void
function LabelControl:ClearAnchorToBaseline(toLabel) end

--- @return bool didLineWrap
function LabelControl:DidLineWrap() end

--- @return number r, number g, number b, number a
function LabelControl:GetColor() end

--- @return number fontHeightUIUnits
function LabelControl:GetFontHeight() end

--- @return [TextAlignment|#TextAlignment] align
function LabelControl:GetHorizontalAlignment() end

--- @return bool linkEnabed
function LabelControl:GetLinkEnabled() end

--- @return [ModifyTextType|#ModifyTextType] modifyTextType
function LabelControl:GetModifyTextType() end

--- @return integer numLines
function LabelControl:GetNumLines() end

--- @return [ShaderEffectType|#ShaderEffectType] shaderEffectType
function LabelControl:GetShaderEffectType() end

--- @param text string
--- @return number scaledWidthTextLayoutNative
function LabelControl:GetStringWidth(text) end

--- @return number r, number g, number b, number a
function LabelControl:GetStyleColor() end

--- @return string apRet
function LabelControl:GetText() end

--- @return number stringWidthUIUnits, number stringHeightUIUnits
function LabelControl:GetTextDimensions() end

--- @param startLine luaindex
--- @param endLine luaindex
--- @return string apRet
function LabelControl:GetTextForLines(startLine, endLine) end

--- @return number stringHeightUIUnits
function LabelControl:GetTextHeight() end

--- @return number stringWidthUIUnits
function LabelControl:GetTextWidth() end

--- @return [TextAlignment|#TextAlignment] align
function LabelControl:GetVerticalAlignment() end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function LabelControl:SetColor(r, g, b, a) end

--- @param desaturation number
--- @return void
function LabelControl:SetDesaturation(desaturation) end

--- @param fontString string
--- @return void
function LabelControl:SetFont(fontString) end

--- @param align [TextAlignment|#TextAlignment]
--- @return void
function LabelControl:SetHorizontalAlignment(align) end

--- @param lineSpacing layout_measurement
--- @return void
function LabelControl:SetLineSpacing(lineSpacing) end

--- @param linkEnabed bool
--- @return void
function LabelControl:SetLinkEnabled(linkEnabed) end

--- @param maxLineCount integer
--- @return void
function LabelControl:SetMaxLineCount(maxLineCount) end

--- @param minLineCount integer
--- @return void
function LabelControl:SetMinLineCount(minLineCount) end

--- @param modifyTextType [ModifyTextType|#ModifyTextType]
--- @return void
function LabelControl:SetModifyTextType(modifyTextType) end

--- @param newLineX layout_measurement
--- @return void
function LabelControl:SetNewLineX(newLineX) end

--- @param pixelRoundingEnabled bool
--- @return void
function LabelControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param shaderEffectType [ShaderEffectType|#ShaderEffectType]
--- @return void
function LabelControl:SetShaderEffectType(shaderEffectType) end

--- @param storeLineEndingCharacterIndices bool
--- @return void
function LabelControl:SetStoreLineEndingCharacterIndices(storeLineEndingCharacterIndices) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function LabelControl:SetStyleColor(r, g, b, a) end

--- @param aText string
--- @return void
function LabelControl:SetText(aText) end

--- @param align [TextAlignment|#TextAlignment]
--- @return void
function LabelControl:SetVerticalAlignment(align) end

--- @param wrapMode integer
--- @return void
function LabelControl:SetWrapMode(wrapMode) end

--- @return bool wasTruncated
function LabelControl:WasTruncated() end

---@class LineControl
LineControl = nil
--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function LineControl:GetBlendMode() end

--- @return number r, number g, number b, number a
function LineControl:GetColor() end

--- @return number desaturation
function LineControl:GetDesaturation() end

--- @return number left, number right, number top, number bottom
function LineControl:GetTextureCoords() end

--- @return integer pixelWidth, integer pixelHeight
function LineControl:GetTextureFileDimensions() end

--- @return string filename
function LineControl:GetTextureFileName() end

--- @return number thickness
function LineControl:GetThickness() end

--- @return bool pixelRoundingEnabled
function LineControl:IsPixelRoundingEnabled() end

--- @return bool loaded
function LineControl:IsTextureLoaded() end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function LineControl:SetBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function LineControl:SetColor(r, g, b, a) end

--- @param desaturation number
--- @return void
function LineControl:SetDesaturation(desaturation) end

--- @param orientation [ControlOrientation|#ControlOrientation]
--- @param startR number
--- @param startG number
--- @param startB number
--- @param startA number
--- @param endR number
--- @param endG number
--- @param endB number
--- @param endA number
--- @return void
function LineControl:SetGradientColors(orientation, startR, startG, startB, startA, endR, endG, endB, endA) end

--- @param pixelRoundingEnabled bool
--- @return void
function LineControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param filename string
--- @return void
function LineControl:SetTexture(filename) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function LineControl:SetTextureCoords(left, right, top, bottom) end

--- @param thickness layout_measurement
--- @return void
function LineControl:SetThickness(thickness) end

--- @param vertexPoints integer
--- @param red number
--- @param green number
--- @param blue number
--- @param alpha number
--- @return void
function LineControl:SetVertexColors(vertexPoints, red, green, blue, alpha) end

---@class MapDisplayControl
MapDisplayControl = nil
--- @return number normalizedRadius
function MapDisplayControl:GetZoom() end

--- @param pinType [MapDisplayPinType|#MapDisplayPinType]
--- @param arrowType [MapArrowType|#MapArrowType]
--- @param pinSize number
--- @param pinXInset number
--- @param pinYInset number
--- @param arrowSize number
--- @param textureFilename string
--- @param arrowTextureFilename string
--- @param areaTextureFilename string
--- @param aboveTextureFilename string
--- @param belowTextureFilename string
--- @param linkTextureFilename string
--- @param animation string
--- @param addedAnimation string
--- @param removedAnimation string
--- @param animationTarget [MapPinAnimationTarget|#MapPinAnimationTarget]
--- @return void
function MapDisplayControl:SetBasePinData(pinType, arrowType, pinSize, pinXInset, pinYInset, arrowSize, textureFilename, arrowTextureFilename, areaTextureFilename, aboveTextureFilename, belowTextureFilename, linkTextureFilename, animation, addedAnimation, removedAnimation, animationTarget) end

--- @param offset number
--- @param size number
--- @return void
function MapDisplayControl:SetGutterOffsetAndSize(offset, size) end

--- @param pinFont string
--- @return void
function MapDisplayControl:SetPinFont(pinFont) end

--- @param normalizedRadius number
--- @return void
function MapDisplayControl:SetZoom(normalizedRadius) end

---@class PolygonControl
PolygonControl = nil
--- @param normalizedX number
--- @param normalizedY number
--- @return void
function PolygonControl:AddPoint(normalizedX, normalizedY) end

--- @return void
function PolygonControl:ClearPoints() end

--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function PolygonControl:GetBorderBlendMode() end

--- @return number desaturation
function PolygonControl:GetBorderDesaturation() end

--- @return [PolygonBorderDirection|#PolygonBorderDirection] direction
function PolygonControl:GetBorderDirection() end

--- @return string textureFile
function PolygonControl:GetBorderTexture() end

--- @return number mins, number max, number percent
function PolygonControl:GetBorderThickness() end

--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function PolygonControl:GetCenterBlendMode() end

--- @return number r, number g, number b, number a
function PolygonControl:GetCenterColor() end

--- @return number desaturation
function PolygonControl:GetCenterDesaturation() end

--- @return string textureFile
function PolygonControl:GetCenterTexture() end

--- @return [TextureAddressMode|#TextureAddressMode] addressMode
function PolygonControl:GetCenterTextureAddressMode() end

--- @return number left, number right, number top, number bottom
function PolygonControl:GetCenterTextureCoords() end

--- @return integer numPoints
function PolygonControl:GetNumPoints() end

--- @param index luaindex
--- @return number normalizedX, number normalizedY
function PolygonControl:GetPoint(index) end

--- @return [PolygonPointLayout|#PolygonPointLayout] pointLayout
function PolygonControl:GetPointLayout() end

--- @return bool isSmoothingEnabled
function PolygonControl:IsSmoothingEnabled() end

--- @param minThickness layout_measurement
--- @param maxThickness layout_measurement
--- @param thicknessPercent number
--- @param color string
--- @param textureFile string
--- @param desaturation number
--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @param direction [PolygonBorderDirection|#PolygonBorderDirection]
--- @return void
function PolygonControl:SetBorder(minThickness, maxThickness, thicknessPercent, color, textureFile, desaturation, blendMode, direction) end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function PolygonControl:SetBorderBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function PolygonControl:SetBorderColor(r, g, b, a) end

--- @param desaturation number
--- @return void
function PolygonControl:SetBorderDesaturation(desaturation) end

--- @param direction [PolygonBorderDirection|#PolygonBorderDirection]
--- @return void
function PolygonControl:SetBorderDirection(direction) end

--- @param textureFile string
--- @return void
function PolygonControl:SetBorderTexture(textureFile) end

--- @param min layout_measurement
--- @param max layout_measurement
--- @param percent number
--- @return void
function PolygonControl:SetBorderThickness(min, max, percent) end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function PolygonControl:SetCenterBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function PolygonControl:SetCenterColor(r, g, b, a) end

--- @param desaturation number
--- @return void
function PolygonControl:SetCenterDesaturation(desaturation) end

--- @param textureFile string
--- @return void
function PolygonControl:SetCenterTexture(textureFile) end

--- @param addressMode [TextureAddressMode|#TextureAddressMode]
--- @return void
function PolygonControl:SetCenterTextureAddressMode(addressMode) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function PolygonControl:SetCenterTextureCoords(left, right, top, bottom) end

--- @param index luaindex
--- @param normalizedX number
--- @param normalizedY number
--- @return void
function PolygonControl:SetPoint(index, normalizedX, normalizedY) end

--- @param pointLayout [PolygonPointLayout|#PolygonPointLayout]
--- @return void
function PolygonControl:SetPointLayout(pointLayout) end

--- @param isSmoothingEnabled bool
--- @return void
function PolygonControl:SetSmoothingEnabled(isSmoothingEnabled) end

---@class RootWindow
RootWindow = nil
---@class ScrollControl
ScrollControl = nil
--- @return number offset
function ScrollControl:GetHorizontalScroll() end

--- @return number horizontal
function ScrollControl:GetHorizontalScrollExtent() end

--- @return [ScrollBounding|#ScrollBounding] bounding
function ScrollControl:GetScrollBounding() end

--- @return number horizontal, number vertical
function ScrollControl:GetScrollExtents() end

--- @return number horizontal, number vertical
function ScrollControl:GetScrollOffsets() end

--- @return number offset
function ScrollControl:GetVerticalScroll() end

--- @return number vertical
function ScrollControl:GetVerticalScrollExtent() end

--- @param duration integer
--- @return void
function ScrollControl:RestoreToExtents(duration) end

--- @param offset layout_measurement
--- @return void
function ScrollControl:SetHorizontalScroll(offset) end

--- @param bounding [ScrollBounding|#ScrollBounding]
--- @return void
function ScrollControl:SetScrollBounding(bounding) end

--- @param offset layout_measurement
--- @return void
function ScrollControl:SetVerticalScroll(offset) end

---@class SliderControl
SliderControl = nil
--- @return bool allow
function SliderControl:DoesAllowDraggingFromThumb() end

--- @return bool isEnabled
function SliderControl:GetEnabled() end

--- @return number min, number max
function SliderControl:GetMinMax() end

--- @return integer orientation
function SliderControl:GetOrientation() end

--- @return object textureControl
function SliderControl:GetThumbTextureControl() end

--- @return number value
function SliderControl:GetValue() end

--- @return number step
function SliderControl:GetValueStep() end

--- @return bool flush
function SliderControl:IsThumbFlushWithExtents() end

--- @param allow bool
--- @return void
function SliderControl:SetAllowDraggingFromThumb(allow) end

--- @param fileName string
--- @param texTop number
--- @param texLeft number
--- @param texBottom number
--- @param texRight number
--- @return void
function SliderControl:SetBackgroundBottomTexture(fileName, texTop, texLeft, texBottom, texRight) end

--- @param fileName string
--- @param texTop number
--- @param texLeft number
--- @param texBottom number
--- @param texRight number
--- @return void
function SliderControl:SetBackgroundMiddleTexture(fileName, texTop, texLeft, texBottom, texRight) end

--- @param fileName string
--- @param texTop number
--- @param texLeft number
--- @param texBottom number
--- @param texRight number
--- @return void
function SliderControl:SetBackgroundTopTexture(fileName, texTop, texLeft, texBottom, texRight) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function SliderControl:SetColor(r, g, b, a) end

--- @param enable bool
--- @return void
function SliderControl:SetEnabled(enable) end

--- @param min number
--- @param max number
--- @return void
function SliderControl:SetMinMax(min, max) end

--- @param orientation integer
--- @return void
function SliderControl:SetOrientation(orientation) end

--- @param flush bool
--- @return void
function SliderControl:SetThumbFlushWithExtents(flush) end

--- @param filename string
--- @param disabledFilename string
--- @param highlightedFilename string
--- @param thumbWidth layout_measurement
--- @param thumbHeight layout_measurement
--- @param texTop number
--- @param texLeft number
--- @param texBottom number
--- @param texRight number
--- @return void
function SliderControl:SetThumbTexture(filename, disabledFilename, highlightedFilename, thumbWidth, thumbHeight, texTop, texLeft, texBottom, texRight) end

--- @param filename string
--- @param disabledFilename string
--- @param highlightedFilename string
--- @param thumbWidth layout_measurement
--- @param thumbHeight layout_measurement
--- @param texTop number
--- @param texLeft number
--- @param texBottom number
--- @param texRight number
--- @param flush bool
--- @return void
function SliderControl:SetThumbTextureAndFlush(filename, disabledFilename, highlightedFilename, thumbWidth, thumbHeight, texTop, texLeft, texBottom, texRight, flush) end

--- @param height layout_measurement
--- @return void
function SliderControl:SetThumbTextureHeight(height) end

--- @param value number
--- @return void
function SliderControl:SetValue(value) end

--- @param step number
--- @return void
function SliderControl:SetValueStep(step) end

---@class StatusBarControl
StatusBarControl = nil
--- @param value number
--- @return number mainBarSize
function StatusBarControl:CalculateSizeWithoutLeadingEdgeForValue(value) end

--- @return void
function StatusBarControl:ClearFadeOutLossAdjustedTopValue() end

--- @param enabled bool
--- @return void
function StatusBarControl:EnableFadeOut(enabled) end

--- @param enabled bool
--- @return void
function StatusBarControl:EnableLeadingEdge(enabled) end

--- @param enabled bool
--- @return void
function StatusBarControl:EnableScrollingOverlay(enabled) end

--- @return number min, number max
function StatusBarControl:GetMinMax() end

--- @return number value
function StatusBarControl:GetValue() end

--- @return bool pixelRoundingEnabled
function StatusBarControl:IsPixelRoundingEnabled() end

--- @param barAlignment integer
--- @return void
function StatusBarControl:SetBarAlignment(barAlignment) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function StatusBarControl:SetColor(r, g, b, a) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function StatusBarControl:SetFadeOutGainColor(r, g, b, a) end

--- @param topValue number
--- @return void
function StatusBarControl:SetFadeOutLossAdjustedTopValue(topValue) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function StatusBarControl:SetFadeOutLossColor(r, g, b, a) end

--- @param adjustValue number
--- @return void
function StatusBarControl:SetFadeOutLossSetValueToAdjust(adjustValue) end

--- @param filename string
--- @return void
function StatusBarControl:SetFadeOutTexture(filename) end

--- @param fadeOutSeconds number
--- @param fadeOutDelaySeconds number
--- @return void
function StatusBarControl:SetFadeOutTime(fadeOutSeconds, fadeOutDelaySeconds) end

--- @param startR number
--- @param startG number
--- @param startB number
--- @param startA number
--- @param endR number
--- @param endG number
--- @param endB number
--- @param endA number
--- @return void
function StatusBarControl:SetGradientColors(startR, startG, startB, startA, endR, endG, endB, endA) end

--- @param textureFile string
--- @param width number
--- @param height number
--- @return void
function StatusBarControl:SetLeadingEdge(textureFile, width, height) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function StatusBarControl:SetLeadingEdgeTextureCoords(left, right, top, bottom) end

--- @param aMin number
--- @param aMax number
--- @return void
function StatusBarControl:SetMinMax(aMin, aMax) end

--- @param orientation integer
--- @return void
function StatusBarControl:SetOrientation(orientation) end

--- @param pixelRoundingEnabled bool
--- @return void
function StatusBarControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param filename string
--- @return void
function StatusBarControl:SetTexture(filename) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function StatusBarControl:SetTextureCoords(left, right, top, bottom) end

--- @param aValue number
--- @return void
function StatusBarControl:SetValue(aValue) end

--- @param textureFile string
--- @param width number
--- @param height number
--- @param duration integer
--- @return void
function StatusBarControl:SetupScrollingOverlay(textureFile, width, height, duration) end

---@class SynchronizingObject
SynchronizingObject = nil
--- @return string state
function SynchronizingObject:GetState() end

--- @return table stateTable
function SynchronizingObject:GetStateAsTable() end

--- @return void
function SynchronizingObject:Hide() end

--- @return bool isShown
function SynchronizingObject:IsShown() end

--- @param handlerName string
--- @param functionRef function
--- @param name string
--- @param controlHandlerOrder [ControlHandlerOrder|#ControlHandlerOrder]
--- @param targetName string
--- @return void
function SynchronizingObject:SetHandler(handlerName, functionRef, name, controlHandlerOrder, targetName) end

--- @param state string
--- @return void
function SynchronizingObject:SetState(state) end

--- @param stateTable table
--- @return void
function SynchronizingObject:SetStateFromTable(stateTable) end

--- @return void
function SynchronizingObject:Show() end

---@class TextBufferControl
TextBufferControl = nil
--- @param aText string
--- @param r number
--- @param g number
--- @param b number
--- @param colorId integer
--- @return void
function TextBufferControl:AddMessage(aText, r, g, b, colorId) end

--- @return void
function TextBufferControl:Clear() end

--- @return bool drawLastIfOutOfRoom
function TextBufferControl:GetDrawLastEntryIfOutOfRoom() end

--- @return [TextAlignment|#TextAlignment] horizontalAlign
function TextBufferControl:GetHorizontalAlignment() end

--- @return number timeBeforeLineBeginsToFade, number timeItTakesLineToFade
function TextBufferControl:GetLineFade() end

--- @return bool linkEnabed
function TextBufferControl:GetLinkEnabled() end

--- @return integer numLines
function TextBufferControl:GetMaxHistoryLines() end

--- @return integer numLines
function TextBufferControl:GetNumHistoryLines() end

--- @return integer numLines
function TextBufferControl:GetNumVisibleLines() end

--- @return integer scrollPosition
function TextBufferControl:GetScrollPosition() end

--- @return bool isSplitting
function TextBufferControl:IsSplittingLongMessages() end

--- @param numLines integer
--- @return void
function TextBufferControl:MoveScrollPosition(numLines) end

--- @param clearAfterFade bool
--- @return void
function TextBufferControl:SetClearBufferAfterFadeout(clearAfterFade) end

--- @param colorId integer
--- @param r number
--- @param g number
--- @param b number
--- @return void
function TextBufferControl:SetColorById(colorId, r, g, b) end

--- @param drawLastIfOutOfRoom bool
--- @return void
function TextBufferControl:SetDrawLastEntryIfOutOfRoom(drawLastIfOutOfRoom) end

--- @param fontString string
--- @return void
function TextBufferControl:SetFont(fontString) end

--- @param horizontalAlign [TextAlignment|#TextAlignment]
--- @return void
function TextBufferControl:SetHorizontalAlignment(horizontalAlign) end

--- @param timeBeforeLineFadeBegins number
--- @param timeForLineToFade number
--- @return void
function TextBufferControl:SetLineFade(timeBeforeLineFadeBegins, timeForLineToFade) end

--- @param linesInheritAlpha bool
--- @return void
function TextBufferControl:SetLinesInheritAlpha(linesInheritAlpha) end

--- @param linkEnabed bool
--- @return void
function TextBufferControl:SetLinkEnabled(linkEnabed) end

--- @param numLines integer
--- @return void
function TextBufferControl:SetMaxHistoryLines(numLines) end

--- @param line integer
--- @return void
function TextBufferControl:SetScrollPosition(line) end

--- @param splitLongMessages bool
--- @return void
function TextBufferControl:SetSplitLongMessages(splitLongMessages) end

--- @return void
function TextBufferControl:ShowFadedLines() end

---@class TextureCompositeControl
TextureCompositeControl = nil
--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return luaindex surfaceIndex
function TextureCompositeControl:AddSurface(left, right, top, bottom) end

--- @return void
function TextureCompositeControl:ClearAllSurfaces() end

--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function TextureCompositeControl:GetBlendMode() end

--- @param surfaceIndex luaindex
--- @return number r, number g, number b, number a
function TextureCompositeControl:GetColor(surfaceIndex) end

--- @return number desaturation
function TextureCompositeControl:GetDesaturation() end

--- @param surfaceIndex luaindex
--- @return number left, number right, number top, number bottom
function TextureCompositeControl:GetInsets(surfaceIndex) end

--- @return integer surfaces
function TextureCompositeControl:GetNumSurfaces() end

--- @param surfaceIndex luaindex
--- @return number a
function TextureCompositeControl:GetSurfaceAlpha(surfaceIndex) end

--- @param surfaceIndex luaindex
--- @return number left, number right, number top, number bottom
function TextureCompositeControl:GetTextureCoords(surfaceIndex) end

--- @return integer pixelWidth, integer pixelHeight
function TextureCompositeControl:GetTextureFileDimensions() end

--- @return string filename
function TextureCompositeControl:GetTextureFileName() end

--- @return bool pixelRoundingEnabled
function TextureCompositeControl:IsPixelRoundingEnabled() end

--- @param surfaceIndex luaindex
--- @return bool hidden
function TextureCompositeControl:IsSurfaceHidden(surfaceIndex) end

--- @return bool loaded
function TextureCompositeControl:IsTextureLoaded() end

--- @param surfaceIndex luaindex
--- @return void
function TextureCompositeControl:RemoveSurface(surfaceIndex) end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function TextureCompositeControl:SetBlendMode(blendMode) end

--- @param surfaceIndex luaindex
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function TextureCompositeControl:SetColor(surfaceIndex, r, g, b, a) end

--- @param desaturation number
--- @return void
function TextureCompositeControl:SetDesaturation(desaturation) end

--- @param surfaceIndex luaindex
--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function TextureCompositeControl:SetInsets(surfaceIndex, left, right, top, bottom) end

--- @param pixelRoundingEnabled bool
--- @return void
function TextureCompositeControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param surfaceIndex luaindex
--- @param a number
--- @return void
function TextureCompositeControl:SetSurfaceAlpha(surfaceIndex, a) end

--- @param surfaceIndex luaindex
--- @param hidden bool
--- @return void
function TextureCompositeControl:SetSurfaceHidden(surfaceIndex, hidden) end

--- @param surfaceIndex luaindex
--- @param scale number
--- @return void
function TextureCompositeControl:SetSurfaceScale(surfaceIndex, scale) end

--- @param surfaceIndex luaindex
--- @param angleInRadians number
--- @param normalizedRotationPointX number
--- @param normalizedRotationPointY number
--- @return void
function TextureCompositeControl:SetSurfaceTextureRotation(surfaceIndex, angleInRadians, normalizedRotationPointX, normalizedRotationPointY) end

--- @param filename string
--- @return void
function TextureCompositeControl:SetTexture(filename) end

--- @param surfaceIndex luaindex
--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function TextureCompositeControl:SetTextureCoords(surfaceIndex, left, right, top, bottom) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function TextureCompositeControl:SetTextureReleaseOption(releaseOption) end

---@class TextureControl
TextureControl = nil
--- @return number width, number height
function TextureControl:Get3DLocalDimensions() end

--- @return [TextureAddressMode|#TextureAddressMode] addressMode
function TextureControl:GetAddressMode() end

--- @return [TextureBlendMode|#TextureBlendMode] blendMode
function TextureControl:GetBlendMode() end

--- @return number r, number g, number b, number a
function TextureControl:GetColor() end

--- @return number desaturation
function TextureControl:GetDesaturation() end

--- @return bool resizesToFitFile
function TextureControl:GetResizeToFitFile() end

--- @return [ShaderEffectType|#ShaderEffectType] shaderEffectType
function TextureControl:GetShaderEffectType() end

--- @return number left, number right, number top, number bottom
function TextureControl:GetTextureCoords() end

--- @return integer pixelWidth, integer pixelHeight
function TextureControl:GetTextureFileDimensions() end

--- @return string filename
function TextureControl:GetTextureFileName() end

--- @param vertex [VERTEX_POINTS|#VERTEX_POINTS]
--- @return number u, number v
function TextureControl:GetVertexUV(vertex) end

--- @return bool isFacing
function TextureControl:Is3DQuadFacingCamera() end

--- @return bool pixelRoundingEnabled
function TextureControl:IsPixelRoundingEnabled() end

--- @return bool loaded
function TextureControl:IsTextureLoaded() end

--- @param width number
--- @param height number
--- @return void
function TextureControl:Set3DLocalDimensions(width, height) end

--- @param addressMode [TextureAddressMode|#TextureAddressMode]
--- @return void
function TextureControl:SetAddressMode(addressMode) end

--- @param enabled bool
--- @return void
function TextureControl:SetAutoAdjustWrappedCoords(enabled) end

--- @param blendMode [TextureBlendMode|#TextureBlendMode]
--- @return void
function TextureControl:SetBlendMode(blendMode) end

--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @return void
function TextureControl:SetColor(r, g, b, a) end

--- @param desaturation number
--- @return void
function TextureControl:SetDesaturation(desaturation) end

--- @param orientation [ControlOrientation|#ControlOrientation]
--- @param startR number
--- @param startG number
--- @param startB number
--- @param startA number
--- @param endR number
--- @param endG number
--- @param endB number
--- @param endA number
--- @return void
function TextureControl:SetGradientColors(orientation, startR, startG, startB, startA, endR, endG, endB, endA) end

--- @param pixelRoundingEnabled bool
--- @return void
function TextureControl:SetPixelRoundingEnabled(pixelRoundingEnabled) end

--- @param resizesToFitFile bool
--- @return void
function TextureControl:SetResizeToFitFile(resizesToFitFile) end

--- @param shaderEffectType [ShaderEffectType|#ShaderEffectType]
--- @return void
function TextureControl:SetShaderEffectType(shaderEffectType) end

--- @param filename string
--- @return void
function TextureControl:SetTexture(filename) end

--- @param left number
--- @param right number
--- @param top number
--- @param bottom number
--- @return void
function TextureControl:SetTextureCoords(left, right, top, bottom) end

--- @param angleInRadians number
--- @return void
function TextureControl:SetTextureCoordsRotation(angleInRadians) end

--- @param releaseOption [ReleaseReferenceOptions|#ReleaseReferenceOptions]
--- @return void
function TextureControl:SetTextureReleaseOption(releaseOption) end

--- @param angleInRadians number
--- @param normalizedRotationPointX number
--- @param normalizedRotationPointY number
--- @return void
function TextureControl:SetTextureRotation(angleInRadians, normalizedRotationPointX, normalizedRotationPointY) end

--- @param sampleProcessingType [TextureSampleProcessing|#TextureSampleProcessing]
--- @param weight number
--- @return void
function TextureControl:SetTextureSampleProcessingWeight(sampleProcessingType, weight) end

--- @param vertexPoints integer
--- @param red number
--- @param green number
--- @param blue number
--- @param alpha number
--- @return void
function TextureControl:SetVertexColors(vertexPoints, red, green, blue, alpha) end

--- @param vertex [VERTEX_POINTS|#VERTEX_POINTS]
--- @param u number
--- @param v number
--- @return void
function TextureControl:SetVertexUV(vertex, u, v) end

---@class TooltipControl
TooltipControl = nil
--- @param control object
--- @param cell integer
--- @param useLastRow bool
--- @return void
function TooltipControl:AddControl(control, cell, useLastRow) end

--- @param control object
--- @param headerRow integer
--- @param headerSide [TooltipHeaderSide|#TooltipHeaderSide]
--- @return void
function TooltipControl:AddHeaderControl(control, headerRow, headerSide) end

--- @param text string
--- @param font string
--- @param headerRow integer
--- @param headerSide [TooltipHeaderSide|#TooltipHeaderSide]
--- @param r number
--- @param g number
--- @param b number
--- @return void
function TooltipControl:AddHeaderLine(text, font, headerRow, headerSide, r, g, b) end

--- @param text string
--- @param font string
--- @param r number
--- @param g number
--- @param b number
--- @param lineAnchor [AnchorPosition|#AnchorPosition]
--- @param modifyTextType [ModifyTextType|#ModifyTextType]
--- @param textAlignment [TextAlignment|#TextAlignment]
--- @param setToFullSize bool
--- @param minWidth number
--- @return void
function TooltipControl:AddLine(text, font, r, g, b, lineAnchor, modifyTextType, textAlignment, setToFullSize, minWidth) end

--- @param paddingY number
--- @return void
function TooltipControl:AddVerticalPadding(paddingY) end

--- @param queryType integer
--- @param keepId integer
--- @param objectiveId integer
--- @param objectivePinTier [ObjectivePinTier|#ObjectivePinTier]
--- @return void
function TooltipControl:AppendAvAObjective(queryType, keepId, objectiveId, objectivePinTier) end

--- @param digSiteId integer
--- @return void
function TooltipControl:AppendDigSiteAntiquities(digSiteId) end

--- @param pingType integer
--- @param unitTag string
--- @return void
function TooltipControl:AppendMapPing(pingType, unitTag) end

--- @param questIndex luaindex
--- @param stepIndex luaindex
--- @param conditionIndex luaindex
--- @return void
function TooltipControl:AppendQuestCondition(questIndex, stepIndex, conditionIndex) end

--- @param questIndex luaindex
--- @return void
function TooltipControl:AppendQuestEnding(questIndex) end

--- @param skyshardId integer
--- @return void
function TooltipControl:AppendSkyshardHint(skyshardId) end

--- @param unitTag string
--- @return void
function TooltipControl:AppendUnitName(unitTag) end

--- @return void
function TooltipControl:ClearLines() end

--- @return object owner
function TooltipControl:GetOwner() end

--- @return void
function TooltipControl:HideComparativeTooltips() end

--- @param aAbilityIndex luaindex
--- @param aShowBase bool
--- @return void
function TooltipControl:SetAbility(aAbilityIndex, aShowBase) end

--- @param abilityId integer
--- @return void
function TooltipControl:SetAbilityId(abilityId) end

--- @param aAchievementId integer
--- @return void
function TooltipControl:SetAchievement(aAchievementId) end

--- @param aAchievementId integer
--- @return void
function TooltipControl:SetAchievementRewardItem(aAchievementId) end

--- @param aSlotId luaindex
--- @param hotbarCategory [HotBarCategory|#HotBarCategory]:nilable
--- @return void
function TooltipControl:SetAction(aSlotId, hotbarCategory) end

--- @param skillType [SkillType|#SkillType]
--- @param skillLineIndex luaindex
--- @param skillIndex luaindex
--- @param morphSlot [MorphSlot|#MorphSlot]
--- @param isPurchased bool
--- @param isAdvised bool
--- @param isBadMorph bool
--- @param numAvailableSkillPoints integer
--- @param showSkillPointCost bool
--- @param showUpgradeText bool
--- @param showAdvised bool
--- @param showBadMorph bool
--- @param overrideRank integer:nilable
--- @param overrideAbilityId integer:nilable
--- @return void
function TooltipControl:SetActiveSkill(skillType, skillLineIndex, skillIndex, morphSlot, isPurchased, isAdvised, isBadMorph, numAvailableSkillPoints, showSkillPointCost, showUpgradeText, showAdvised, showBadMorph, overrideRank, overrideAbilityId) end

--- @param antiquityId integer
--- @return void
function TooltipControl:SetAntiquityLead(antiquityId) end

--- @param antiquityId integer
--- @return void
function TooltipControl:SetAntiquitySetFragment(antiquityId) end

--- @return void
function TooltipControl:SetAsComparativeTooltip1() end

--- @return void
function TooltipControl:SetAsComparativeTooltip2() end

--- @param aMailId id64
--- @param aAttachSlot luaindex
--- @return void
function TooltipControl:SetAttachedMailItem(aMailId, aAttachSlot) end

--- @param bagIndex [Bag|#Bag]
--- @param slotIndex integer
--- @return void
function TooltipControl:SetBagItem(bagIndex, slotIndex) end

--- @param categoryIndex luaindex
--- @param collectionIndex luaindex
--- @param bookIndex luaindex
--- @return void
function TooltipControl:SetBook(categoryIndex, collectionIndex, bookIndex) end

--- @param aBuffSlotId integer
--- @param unitTag string
--- @return void
function TooltipControl:SetBuff(aBuffSlotId, unitTag) end

--- @param entryIndex luaindex
--- @return void
function TooltipControl:SetBuybackItem(entryIndex) end

--- @param championSkillId integer
--- @param numPendingPoints integer
--- @param nextJumpPoint integer
--- @param isPendingSlotted bool
--- @return void
function TooltipControl:SetChampionSkill(championSkillId, numPendingPoints, nextJumpPoint, isPendingSlotted) end

--- @param collectibleId integer
--- @param addNickname bool
--- @param showPurchasableHint bool
--- @param showBlockReason bool
--- @param actorCategory [GameplayActorCategory|#GameplayActorCategory]
--- @return void
function TooltipControl:SetCollectible(collectibleId, addNickname, showPurchasableHint, showBlockReason, actorCategory) end

--- @param abilityId integer
--- @return void
function TooltipControl:SetCompanionSkill(abilityId) end

--- @param rewardIndex luaindex
--- @return void
function TooltipControl:SetCrownCrateReward(rewardIndex) end

--- @param currencyType [CurrencyType|#CurrencyType]
--- @param quantity integer
--- @return void
function TooltipControl:SetCurrency(currencyType, quantity) end

--- @param rewardIndex luaindex
--- @return void
function TooltipControl:SetDailyLoginRewardEntry(rewardIndex) end

--- @param bonusIndex luaindex
--- @return void
function TooltipControl:SetEdgeKeepBonusAbility(bonusIndex) end

--- @param rankIndex integer
--- @return void
function TooltipControl:SetEmperorBonusAbility(rankIndex) end

--- @param buffAbilityId integer
--- @param includeLifetimeStacks bool
--- @return void
function TooltipControl:SetEndlessDungeonBuff(buffAbilityId, includeLifetimeStacks) end

--- @param fontStr string
--- @return void
function TooltipControl:SetFont(fontStr) end

--- @param itemSetId integer
--- @return void
function TooltipControl:SetGenericItemSet(itemSetId) end

--- @param guildSpecificItemIndex luaindex
--- @return void
function TooltipControl:SetGuildSpecificItem(guildSpecificItemIndex) end

--- @param headerCellEmptyHorizontalSpace number
--- @return void
function TooltipControl:SetHeaderCellEmptyHorizontalSpace(headerCellEmptyHorizontalSpace) end

--- @param spacing number
--- @return void
function TooltipControl:SetHeaderRowSpacing(spacing) end

--- @param verticalOffset number
--- @return void
function TooltipControl:SetHeaderVerticalOffset(verticalOffset) end

--- @param aLink string
--- @param aHideTrait bool
--- @return void
function TooltipControl:SetItemSetCollectionPieceLink(aLink, aHideTrait) end

--- @param itemBagIndex [Bag|#Bag]
--- @param itemSlotIndex integer
--- @param enchantmentBagIndex [Bag|#Bag]
--- @param enchantmentSlotIndex integer
--- @return void
function TooltipControl:SetItemUsingEnchantment(itemBagIndex, itemSlotIndex, enchantmentBagIndex, enchantmentSlotIndex) end

--- @param bonusIndex luaindex
--- @return void
function TooltipControl:SetKeepBonusAbility(bonusIndex) end

--- @param keepId integer
--- @param battlegroundContext [BattlegroundQueryContextType|#BattlegroundQueryContextType]
--- @param upgradeLine integer
--- @param level integer
--- @param index luaindex
--- @return void
function TooltipControl:SetKeepUpgrade(keepId, battlegroundContext, upgradeLine, level, index) end

--- @param resultIndex luaindex
--- @return void
function TooltipControl:SetLastCraftingResultItem(resultIndex) end

--- @param aLink string
--- @return void
function TooltipControl:SetLink(aLink) end

--- @param lootId integer
--- @return void
function TooltipControl:SetLootItem(lootId) end

--- @param marketProductId integer
--- @param showCollectiblePurchasableHint bool
--- @return void
function TooltipControl:SetMarketProduct(marketProductId, showCollectiblePurchasableHint) end

--- @param marketProductId integer
--- @param presentationIndex luaindex:nilable
--- @return void
function TooltipControl:SetMarketProductListing(marketProductId, presentationIndex) end

--- @param minRowHeight number
--- @return void
function TooltipControl:SetMinHeaderRowHeight(minRowHeight) end

--- @param minRows integer
--- @return void
function TooltipControl:SetMinHeaderRows(minRows) end

--- @param owner object
--- @param position [AnchorPosition|#AnchorPosition]
--- @param offsetX number
--- @param offsetY number
--- @param relativePoint [AnchorPosition|#AnchorPosition]
--- @return void
function TooltipControl:SetOwner(owner, position, offsetX, offsetY, relativePoint) end

--- @param skillType [SkillType|#SkillType]
--- @param skillLineIndex luaindex
--- @param skillIndex luaindex
--- @param rank integer
--- @param purchasedToRank integer
--- @param numAvailableSkillPoints integer
--- @param showSkillPointCost bool
--- @return void
function TooltipControl:SetPassiveSkill(skillType, skillLineIndex, skillIndex, rank, purchasedToRank, numAvailableSkillPoints, showSkillPointCost) end

--- @param solventBagId [Bag|#Bag]
--- @param solventSlotIndex integer
--- @param reagent1BagId [Bag|#Bag]
--- @param reagent1SlotIndex integer
--- @param reagent2BagId [Bag|#Bag]
--- @param reagent2SlotIndex integer
--- @param reagent3BagId [Bag|#Bag]:nilable
--- @param reagent3SlotIndex integer:nilable
--- @return void
function TooltipControl:SetPendingAlchemyItem(solventBagId, solventSlotIndex, reagent1BagId, reagent1SlotIndex, reagent2BagId, reagent2SlotIndex, reagent3BagId, reagent3SlotIndex) end

--- @param potencyRuneBagId [Bag|#Bag]
--- @param potencyRuneSlotIndex integer
--- @param essenceRuneBagId [Bag|#Bag]
--- @param essenceRuneSlotIndex integer
--- @param aspectRuneBagId [Bag|#Bag]
--- @param aspectRuneSlotIndex integer
--- @return void
function TooltipControl:SetPendingEnchantingItem(potencyRuneBagId, potencyRuneSlotIndex, essenceRuneBagId, essenceRuneSlotIndex, aspectRuneBagId, aspectRuneSlotIndex) end

--- @param bagIndex [Bag|#Bag]
--- @param slotIndex integer
--- @param pendingTrait [ItemTraitType|#ItemTraitType]
--- @return void
function TooltipControl:SetPendingRetraitItem(bagIndex, slotIndex, pendingTrait) end

--- @param patternIndex luaindex
--- @param materialIndex luaindex
--- @param materialQuantity integer
--- @param itemStyleId integer
--- @param traitIndex luaindex
--- @return void
function TooltipControl:SetPendingSmithingItem(patternIndex, materialIndex, materialQuantity, itemStyleId, traitIndex) end

--- @param placedFurnitureId id64
--- @return void
function TooltipControl:SetPlacedFurniture(placedFurnitureId) end

--- @param aProgressionIndex luaindex
--- @param aMorph integer
--- @param aRank integer
--- @param aShowAdvice bool
--- @param aAdvised bool
--- @return void
function TooltipControl:SetProgressionAbility(aProgressionIndex, aMorph, aRank, aShowAdvice, aAdvised) end

--- @param recipeListIndex luaindex
--- @param recipeIndex luaindex
--- @param ingredientIndex luaindex
--- @return void
function TooltipControl:SetProvisionerIngredientItem(recipeListIndex, recipeIndex, ingredientIndex) end

--- @param recipeListIndex luaindex
--- @param recipeIndex luaindex
--- @return void
function TooltipControl:SetProvisionerResultItem(recipeListIndex, recipeIndex) end

--- @param questIndex luaindex
--- @param stepIndex luaindex
--- @param conditionIndex luaindex
--- @return void
function TooltipControl:SetQuestItem(questIndex, stepIndex, conditionIndex) end

--- @param aPerkIndex luaindex
--- @return void
function TooltipControl:SetQuestReward(aPerkIndex) end

--- @param questIndex luaindex
--- @param toolIndex luaindex
--- @return void
function TooltipControl:SetQuestTool(questIndex, toolIndex) end

--- @param rewardId integer
--- @param quantity integer
--- @param displayFlags [RewardDisplayFlags|#RewardDisplayFlags]
--- @return void
function TooltipControl:SetReward(rewardId, quantity, displayFlags) end

--- @param alliance [Alliance|#Alliance]
--- @param artifactType [ObjectiveType|#ObjectiveType]
--- @param bonusIndex luaindex
--- @return void
function TooltipControl:SetScrollBonusAbility(alliance, artifactType, bonusIndex) end

--- @param skillType integer
--- @param skillLineIndex luaindex
--- @param skillIndex luaindex
--- @param badMorph bool
--- @return void
function TooltipControl:SetSkillAbility(skillType, skillLineIndex, skillIndex, badMorph) end

--- @param skillType [SkillType|#SkillType]
--- @param skillLineIndex luaindex
--- @return void
function TooltipControl:SetSkillLine(skillType, skillLineIndex) end

--- @param abilityId integer
--- @param skillType [SkillType|#SkillType]
--- @param skillLineIndex luaindex
--- @param skillLineAbilityIndex luaindex
--- @param morphChoice integer
--- @return void
function TooltipControl:SetSkillLineAbilityId(abilityId, skillType, skillLineIndex, skillLineAbilityIndex, morphChoice) end

--- @param skillLineId integer
--- @return void
function TooltipControl:SetSkillLineById(skillLineId) end

--- @param skillType integer
--- @param skillLineIndex luaindex
--- @param skillIndex luaindex
--- @return void
function TooltipControl:SetSkillUpgradeAbility(skillType, skillLineIndex, skillIndex) end

--- @param craftingSkillType integer
--- @param improvementItemIndex luaindex
--- @return void
function TooltipControl:SetSmithingImprovementItem(craftingSkillType, improvementItemIndex) end

--- @param itemToImproveBagId [Bag|#Bag]
--- @param itemToImproveSlotIndex integer
--- @param craftingSkillType integer
--- @return void
function TooltipControl:SetSmithingImprovementResult(itemToImproveBagId, itemToImproveSlotIndex, craftingSkillType) end

--- @param patternIndex luaindex
--- @param materialIndex luaindex
--- @return void
function TooltipControl:SetSmithingMaterialItem(patternIndex, materialIndex) end

--- @param itemStyleId integer
--- @return void
function TooltipControl:SetSmithingStyleItem(itemStyleId) end

--- @param traitItemIndex luaindex
--- @return void
function TooltipControl:SetSmithingTraitItem(traitItemIndex) end

--- @param entryIndex luaindex
--- @return void
function TooltipControl:SetStoreItem(entryIndex) end

--- @param aWho integer
--- @param aTradeIndex luaindex
--- @return void
function TooltipControl:SetTradeItem(aWho, aTradeIndex) end

--- @param tradingHouseIndex luaindex
--- @return void
function TooltipControl:SetTradingHouseItem(tradingHouseIndex) end

--- @param tradingHouseIndex luaindex
--- @return void
function TooltipControl:SetTradingHouseListing(tradingHouseIndex) end

--- @param boardLocation [TributeBoardLocation|#TributeBoardLocation]
--- @return void
function TooltipControl:SetTributeBoardLocationPatrons(boardLocation) end

--- @param patronId integer
--- @param cardId integer
--- @return void
function TooltipControl:SetTributeCard(patronId, cardId) end

--- @param rewardListId integer
--- @return void
function TooltipControl:SetTributeLeaderboardRewardList(rewardListId) end

--- @param patronId integer
--- @param highlightActiveFavorState bool
--- @param suppressNotCollectibleWarning bool
--- @param showAcquireHint bool
--- @param showLore bool
--- @return void
function TooltipControl:SetTributePatron(patronId, highlightActiveFavorState, suppressNotCollectibleWarning, showAcquireHint, showLore) end

--- @param patronId integer
--- @param cardIndex luaindex
--- @param showUpgrade bool
--- @return void
function TooltipControl:SetTributePatronDockCard(patronId, cardIndex, showUpgrade) end

--- @param patronId integer
--- @param cardIndex luaindex
--- @return void
function TooltipControl:SetTributePatronStarterCard(patronId, cardIndex) end

--- @param patronId integer
--- @param highlightFavorState [TributePatronPerspectiveFavorState|#TributePatronPerspectiveFavorState]
--- @return void
function TooltipControl:SetTributePatronWithFavorState(patronId, highlightFavorState) end

--- @param tributeTier [TributeTier|#TributeTier]
--- @param rewardListId integer
--- @return void
function TooltipControl:SetTributeSeasonRewardList(tributeTier, rewardListId) end

--- @param paddingY number
--- @return void
function TooltipControl:SetVerticalPadding(paddingY) end

--- @param equipSlot [EquipSlot|#EquipSlot]
--- @param bagId [Bag|#Bag]
--- @return void
function TooltipControl:SetWornItem(equipSlot, bagId) end

--- @return void
function TooltipControl:ShowComparativeTooltips() end

---@class TopLevelWindow
TopLevelWindow = nil
--- @return bool allow
function TopLevelWindow:AllowBringToTop() end

--- @return void
function TopLevelWindow:BringWindowToTop() end --*protected-attributes*

--- @param allow bool
--- @return void
function TopLevelWindow:SetAllowBringToTop(allow) end --*protected-attributes*

--- @param drawWhenHidden bool
--- @return void
function TopLevelWindow:SetDrawWhenGuiHidden(drawWhenHidden) end --*private*

--- @param isTopmost bool
--- @return void
function TopLevelWindow:SetTopmost(isTopmost) end

---@class WindowManager
WindowManager = nil
--- @param control object
--- @param virtualName string
--- @return void
function WindowManager:ApplyTemplateToControl(control, virtualName) end

--- @return bool enabled
function WindowManager:AreCustomCursorsEnabled() end

--- @param controlA object
--- @param controlB object
--- @return integer order
function WindowManager:CompareControlVisualOrder(controlA, controlB) end

--- @param name string
--- @param parent object
--- @param type [ControlType|#ControlType]
--- @return object control
function WindowManager:CreateControl(name, parent, type) end

--- @param controlName string
--- @param parent object
--- @param virtualName string
--- @param optionalSuffix string
--- @return object control
function WindowManager:CreateControlFromVirtual(controlName, parent, virtualName, optionalSuffix) end

--- @param x layout_measurement
--- @param y layout_measurement
--- @return integer cursorId
function WindowManager:CreateCursor(x, y) end

--- @param name string
--- @return object control
function WindowManager:CreateTopLevelWindow(name) end

--- @param cursorId integer
--- @return void
function WindowManager:DestroyCursor(cursorId) end

--- @param cursorId integer
--- @param desiredHandlers [HitTestingDesiredHandlers|#HitTestingDesiredHandlers]
--- @return object controlAtCursor
function WindowManager:GetControlAtCursor(cursorId, desiredHandlers) end

--- @param x layout_measurement
--- @param y layout_measurement
--- @return object mouseOverControl
function WindowManager:GetControlAtPoint(x, y) end

--- @param name string
--- @param suffix string
--- @return object ret
function WindowManager:GetControlByName(name, suffix) end

--- @param cursorId integer
--- @return number x, number y
function WindowManager:GetCursorPosition(cursorId) end

--- @return object focusControl
function WindowManager:GetFocusControl() end

--- @param handlerName string
--- @param name string
--- @return function functionRef
function WindowManager:GetHandler(handlerName, name) end

--- @param index luaindex
--- @return string candidate
function WindowManager:GetIMECandidate(index) end

--- @return luaindex selectedIndex, luaindex pageStartIndex, integer pageSize
function WindowManager:GetIMECandidatePageInfo() end

--- @return object mouseFocusControl
function WindowManager:GetMouseFocusControl() end

--- @return object mouseOverControl
function WindowManager:GetMouseOverControl() end

--- @return integer numCandidates
function WindowManager:GetNumIMECandidates() end

--- @return number x, number y
function WindowManager:GetUIMousePosition() end

--- @return bool hasFocusControl
function WindowManager:HasFocusControl() end

--- @return bool isChoosingCandidate
function WindowManager:IsChoosingIMECandidate() end

--- @return bool isHandlingHardwareEvent
function WindowManager:IsHandlingHardwareEvent() end

--- @return bool isMouseOverWorld
function WindowManager:IsMouseOverWorld() end

--- @return bool secureRenderModeEnabled
function WindowManager:IsSecureRenderModeEnabled() end

--- @return bool isUsingCustomCandidateList
function WindowManager:IsUsingCustomCandidateList() end

--- @param name string
--- @return void
function WindowManager:SetFocusByName(name) end

--- @param handlerName string
--- @param functionRef function
--- @param name string
--- @param controlHandlerOrder [ControlHandlerOrder|#ControlHandlerOrder]
--- @param targetName string
--- @return void
function WindowManager:SetHandler(handlerName, functionRef, name, controlHandlerOrder, targetName) end

--- @param cursorType integer
--- @return void
function WindowManager:SetMouseCursor(cursorType) end

--- @param name string
--- @return void
function WindowManager:SetMouseFocusByName(name) end

--- @param cursorId integer
--- @param x layout_measurement
--- @param y layout_measurement
--- @return void
function WindowManager:UpdateCursorPosition(cursorId, x, y) end

--- @return object apRetWindowManager
function WindowManager:GetWindowManager() end

--- @param control object
--- @param leftOffset number
--- @param topOffset number
--- @param rightOffset number
--- @param bottomOffset number
--- @return bool isOver
function WindowManager:MouseIsOver(control, leftOffset, topOffset, rightOffset, bottomOffset) end

--- @param control object
--- @param leftOffset number
--- @param topOffset number
--- @param rightOffset number
--- @param bottomOffset number
--- @return bool isInside
function WindowManager:MouseIsInside(control, leftOffset, topOffset, rightOffset, bottomOffset) end

--- @return number deltaX, number deltaY
function WindowManager:GetUIMouseDeltas() end

--- @return number scale
function WindowManager:GetUIGlobalScale() end

--- @return number scale
function WindowManager:GetUICustomScale() end

--- @param formatString string
--- @param arg1 string
--- @param arg2 string
--- @param arg3 string
--- @param arg4 string
--- @param arg5 string
--- @param arg6 string
--- @param arg7 string
--- @return string localizedString
function WindowManager:LocalizeString(formatString, arg1, arg2, arg3, arg4, arg5, arg6, arg7) end

--- @return object apRetAnimationManager
function WindowManager:GetAnimationManager() end

--- @return object addOnManager
function WindowManager:GetAddOnManager() end

--- @param originalTexture string
--- @param newTexture string
--- @return void
function WindowManager:RedirectTexture(originalTexture, newTexture) end

--- @param text string
--- @param allowMarkupType [AllowMarkupType|#AllowMarkupType]
--- @return string escapedText
function WindowManager:EscapeMarkup(text, allowMarkupType) end

--- @param fontSymbolName string
--- @param fontDescriptor string
--- @return object fontObject
function WindowManager:CreateFont(fontSymbolName, fontDescriptor) end

--- @return integer numFiles
function WindowManager:GetNumControlCreatingSources() end

--- @param index luaindex
--- @return string sourceName
function WindowManager:GetControlCreatingSourceName(index) end

--- @param sourceName string
--- @return integer numCallSites
function WindowManager:GetNumControlCreatingSourceCallSites(sourceName) end

--- @param sourceName string
--- @param index luaindex
--- @return string creationStack, integer count
function WindowManager:GetControlCreatingSourceCallSiteInfo(sourceName, index) end

--- @return void
function WindowManager:StartScriptProfiler() end

--- @return void
function WindowManager:StopScriptProfiler() end

--- @return bool enabled
function WindowManager:IsScriptProfilerEnabled() end

--- @return integer numFrames
function WindowManager:GetScriptProfilerNumFrames() end

--- @param frameIndex luaindex
--- @return integer numRecords
function WindowManager:GetScriptProfilerFrameNumRecords(frameIndex) end

--- @param frameIndex luaindex
--- @param recordIndex luaindex
--- @return luaindex recordDataIndex, number startTimeNS, number endTimeNS, luaindex:nilable callerRecordIndex, [ScriptProfilerRecordDataType|#ScriptProfilerRecordDataType] recordDataType
function WindowManager:GetScriptProfilerRecordInfo(frameIndex, recordIndex) end

--- @return integer numClosures
function WindowManager:GetScriptProfilerNumClosures() end

--- @param recordDataIndex luaindex
--- @return string displayName, string fileName, integer fileLineNumber
function WindowManager:GetScriptProfilerClosureInfo(recordDataIndex) end

--- @return integer numCFunctions
function WindowManager:GetScriptProfilerNumCFunctions() end

--- @param recordDataIndex luaindex
--- @return string functionName
function WindowManager:GetScriptProfilerCFunctionInfo(recordDataIndex) end

--- @return integer numGarbageCollectionTypes
function WindowManager:GetScriptProfilerNumGarbageCollectionTypes() end

--- @param recordDataIndex luaindex
--- @return [ScriptProfilerGarbageCollectionType|#ScriptProfilerGarbageCollectionType] GarbageCollectionType
function WindowManager:GetScriptProfilerGarbageCollectionInfo(recordDataIndex) end

--- @param userEventData string
--- @return void
function WindowManager:RecordScriptProfilerUserEvent(userEventData) end

--- @return integer numUserEvents
function WindowManager:GetScriptProfilerNumUserEvents() end

--- @param recordDataIndex luaindex
--- @return string userEventData
function WindowManager:GetScriptProfilerUserEventInfo(recordDataIndex) end

--- @return number minWidth
function WindowManager:GetMinUICanvasWidth() end

--- @return number minHeight
function WindowManager:GetMinUICanvasHeight() end

--- @return number FoVYRadians
function WindowManager:GetInterfaceVerticalFieldOfView() end

--- @param FoVYRadians number
--- @return void
function WindowManager:SetInterfaceVerticalFieldOfView(FoVYRadians) end

--- @param text string
--- @return void
function WindowManager:CopyToClipboard(text) end --*private*

--- @param red number
--- @param green number
--- @param blue number
--- @return number hue, number saturation, number value
function WindowManager:ConvertRGBToHSV(red, green, blue) end

--- @param red number
--- @param green number
--- @param blue number
--- @return number hue, number saturation, number lightness
function WindowManager:ConvertRGBToHSL(red, green, blue) end
