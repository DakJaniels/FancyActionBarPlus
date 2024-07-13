---@class (partial) FancyActionBar
---@field __index FancyActionBar
FancyActionBar = {};
FancyActionBar.__index = FancyActionBar;

---@class (partial) FancyActionBar
local FancyActionBar = FancyActionBar;

FancyActionBar.variableVersion = 1;

FancyActionBar.defaultCharacter = {
  -- for character specific ability tracking
  useAccountWide = true;

  configChanges = {};
  dynamicAbilityConfig = false;

  hideOnNoTargetGlobal = false;
  hideOnNoTargetList = {};

  noTargetFade = false;
  noTargetAlpha = 90;
  debuffConfigUpgraded = false;
};
FancyActionBar.defaultSettings = {
  variablesValidated = false;
  -- ability tracking

  configChanges = {};
  dynamicAbilityConfig = false;

  externalBuffs = false;
  externalBlackList = {};
  externalBlackListRun = false;

  advancedDebuff = false;
  keepLastTarget = true;
  debuffConfigUpgraded = false;

  hideOnNoTargetGlobal = false;
  hideOnNoTargetList = {};

  noTargetFade = false;
  noTargetAlpha = 90;
  applyActionBarSkillStyles = true;

  durationMin = 2;
  durationMax = 120;

  showOvertauntStacks = true;
  showTargetCount = true;
  showSingleTargetInstance = false;

  -- general
  lockInTrade = true;
  staticBars = true;
  frontBarTop = true;
  activeBarTop = false;
  -- hideInactive									= false,
  showHotkeys = true;
  showHotkeysUltGP = true;
  showHighlight = true;
  highlightColor = { 0; 1; 0; 0.7 };
  highlightExpire = false;
  highlightExpireColor = { 1; 0; 0; 0.7 };
  toggledHighlight = false;
  toggledColor = { 1; 1; 1; 0.7 };
  -- back bar visibility
  alphaInactive = 20;
  desaturationInactive = 50;
  -- timer display settings
  delayFade = true;
  fadeDelay = 2;
  showDecimal = "Expire";
  showDecimalStart = 2;
  showExpire = true;
  showExpireStart = 2;
  expireColor = { 1; 1; 0 };
  -- keyboard UI visuals
  -- duration
  fontNameKB = "Univers 67";
  fontSizeKB = 24;
  fontTypeKB = "thick-outline";
  timeYKB = 0;
  timeColorKB = { 1; 1; 1 };
  -- stacks
  fontNameStackKB = "Univers 67";
  fontSizeStackKB = 20;
  fontTypeStackKB = "thick-outline";
  stackXKB = 37;
  stackColorKB = { 1; 0.8; 0 };
  -- targets
  fontNameTargetKB = "Univers 67";
  fontSizeTargetKB = 20;
  fontTypeTargetKB = "thick-outline";
  targetXKB = 37;
  targetColorKB = { 1; 0.8; 0 };
  -- ult duration
  ultShowKB = true;
  ultNameKB = "Univers 67";
  ultSizeKB = 24;
  ultTypeKB = "thick-outline";
  ultXKB = 37;
  ultYKB = 0;
  ultColorKB = { 1; 1; 1 };
  -- ult value
  ultValueEnableKB = false;
  ultValueModeKB = 1;
  ultValueNameKB = "Univers 67";
  ultValueSizeKB = 20;
  ultValueTypeKB = "outline";
  ultValueXKB = -2;
  ultValueYKB = -5;
  ultValueColorKB = { 1; 1; 1 };
  -- companion
  ultValueEnableCompanionKB = true;
  ultValueModeCompanionKB = 1;
  ultValueCompanionXKB = 0;
  ultValueCompanionYKB = 0;
  -- quick slot
  qsTimerEnableKB = true;
  qsNameKB = "Univers 67";
  qsSizeKB = 24;
  qsTypeKB = "outline";
  qsXKB = 0;
  qsYKB = 10;
  qsColorKB = { 1; 0.5; 0.2 };
  -- gamepad UI visuals
  -- duration
  fontNameGP = "Univers 67";
  fontSizeGP = 34;
  fontTypeGP = "thick-outline";
  timeYGP = 0;
  timeColorGP = { 1; 1; 1 };
  -- stacks
  fontNameStackGP = "Univers 67";
  fontSizeStackGP = 22;
  fontTypeStackGP = "thick-outline";
  stackXGP = 37;
  stackColorGP = { 1; 0.8; 0 };
  -- targets
  fontNameTargetGP = "Univers 67";
  fontSizeTargetGP = 22;
  fontTypeTargetGP = "thick-outline";
  targetXGP = 37;
  targetColorGP = { 1; 0.8; 0 };
  -- ult
  ultShowGP = true;
  ultNameGP = "Univers 67";
  ultSizeGP = 40;
  ultTypeGP = "thick-outline";
  ultXGP = 25;
  ultYGP = 0;
  ultColorGP = { 1; 1; 1 };
  -- ult value
  ultValueEnableGP = false;
  ultValueModeGP = 1;
  ultValueNameGP = "Univers 67";
  ultValueSizeGP = 22;
  ultValueTypeGP = "outline";
  ultValueXGP = 0;
  ultValueYGP = 0;
  ultValueColorGP = { 1; 1; 1 };
  -- companion
  ultValueEnableCompanionGP = true;
  ultValueModeCompanionGP = 1;
  ultValueCompanionXGP = 0;
  ultValueCompanionYGP = 0;
  -- quick slot
  qsTimerEnableGP = true;
  qsNameGP = "Univers 67";
  qsSizeGP = 34;
  qsTypeGP = "outline";
  qsXGP = 10;
  qsYGP = 0;
  qsColorGP = { 1; 0.5; 0.2 };
  -- both
  ultFlash = true;
  -- frames for keyboard UI
  showFrames = true;
  frameColor = { 0; 0; 0; 1 };
  hideDefaultFrames = false;
  -- arrow and quick slot display style
  showArrow = true;
  arrowColor = { 0; 1; 0; 1 };
  moveQS = true;
  -- enemy markers
  showMarker = false;
  markerSize = 26;
  -- global cooldown tracker
  gcd = {
    enable = false;
    combatOnly = false;
    x = 1000;
    y = 1000;
    sizeX = 50;
    sizeY = 50;
    fillColor = { 0.2; 0.6; 1; 1 };
    frameColor = { 0; 0; 0; 1 };
  };
  -- action bar scale and position
  abScaling = {
    kb = { enable = false; scale = 100 };
    gp = { enable = false; scale = 100 };
  };
  abMove = {                                                       -- y = -(default + adjusted) anchor offset
    kb = { enable = false; x = 0; y = -22; prevX = 0; prevY = 0 }; -- y =      -( 0 + 22)
    gp = { enable = false; x = 0; y = -75; prevX = 0; prevY = 0 }; -- y =      -(25 + 52)
  };
  showDeath = false;
  -- compatibility
  perfectWeave = false;
  -- debug
  debug = false;
  debugAll = false;
  debugVerbose = false;
};
FancyActionBar.strings = {
  --outdated and mostly unused. will make settings more managable eventually.

  -- submenu names
  subGeneral = "|cFFFACDGeneral|r";
  subCustomUI = "|cFFFACDUI Customization|r";
  subTimer = "|cFFFACDTimer Display|r";
  subTimerKB = "|cFFFACDKeyboard UI|r";
  subDecimals = "|cFFFACDTimer Decimals|r";
  subMisc = "|cFFFACDMiscellaneous|r";

  -- submenu descriptions
  subTimerDesc = "Here you can adjust size and postion of the timer, stacks, and target counts displays.\nThe settings are individual to the keyboard and gamepad UI's in their respective submenu, and can be changed regardless of which mode your UI is currently in.\nThe timer decimals options apply to both UI modes";
  subTimerKBDesc = "Keyboard UI timer display settings";
  subStackKBDesc = "Keyboard UI target count display settings";
  subTargetKBDesc = "Keyboard UI target count display settings";

  -- submenu category titles (desription titles)
  catBBVisual = "[ |cffdf80Back Bar Visibility|r ]";
  catHotkey = "[ |cffdf80Hotkey Text|r ]";
  catFrames = "[ |cffdf80Button Frames|r ]";
  catHighlight = "[ |cffdf80Active Ability Highlight|r ]";
  catArrow = "[ |cffdf80Active Bar Arrow|r ]";
  catMarker = "[ |cffdf80Enemy Markers|r ]";
  catDebug = "[ |cffdf80Debugging|r ]";

  -- submenu category decriptions
  catFramesDesc = "Only for keyboard UI.";
  catArrowDesc = "Weapon swap once after clicking the Show arrow button to make the change take effect.";
  catMarkerDesc = "yes.. I completely stole this from Untaunted.";

  -- settings names and tooltips
  -- back bar alpha
  alphaName = "Inactive bar alpha";
  alphaTT = "Higher value = more solid.\nLower value = more see through.";

  -- backbar desaturation
  desatName = "Inactive bar desaturation";
  desatTT = "Higher value = more grey.\nLower value = more colors.";

  -- keybinds
  hotkeyName = "Show hotkeys";
  hotkeyTT = "Show hotkeys under the action bar.";

  -- button trames
  frameName = "Show frames";
  frameTT = "Show a frame around buttons on the actionbar.";
  frameColor = "Frame color";

  -- highlight
  highlightName = "Show highlight";
  highlightTT = "Active skills will be highlighted.";
  highlightColor = "Highlight color";

  -- arrow
  arrowName = "Show arrow";
  arrowTT = "Show an arrow near the currently active bar.";
  arrowColor = "Arrow color";
  arrowAdjustQSName = "Adjust Quick Slot placement";
  arrowAdjustQSTT = "Move Quick Slot closer to the Action Bar if the arrow is hidden.\nFor keyboard UI only.";

  -- KB UI tooltips
  timerFontKBTT = "Timer font for keyboard UI timer.";
  timerStyleKBTT = "Edge effect for Keyboard UI timer numbers.";
  stackFontKBTT = "Stacks Counter font for keyboard UI.";
  stackStyleKBTT = "Edge effect of the Keyboard UI stacks counter.";
  targetFontKBTT = "Target Counter font for keyboard UI.";
  targetStyleKBTT = "Edge effect of the Keyboard UI targets counter.";

  -- GP UI tooltips
  timerFontGPTT = "Timer font for Gamepad UI timer.";
  timerStyleGPTT = "Edge effect for Gamepad UI timer numbers.";
  stackFontGPTT = "Stacks Counter font for Gamepad UI.";
  stackStyleGPTT = "Edge effect of the Gamepad UI stacks counter.";
  targetFontGPTT = "Target Counter font for Gamepad UI.";
  targetStyleGPTT = "Edge effect of the Gamepad UI targets counter.";

  -- timer for both KB and GP
  timerFont = "Timer font";
  timerSize = "Timer size";
  timerStyle = "Timer style";
  timerYName = "Adjust timer hight";
  timerYTT = "Move timer [<- down] or [up ->]";

  -- stacks for both KB and GP
  stackFont = "Stack counter font";
  stackSize = "Stacks counter size";
  stackStyle = "Stacks counter style";
  stackXName = "Adjust stacks position";
  stackXTT = "Move stacks counter [<- left] or [right ->]";

  -- targets for both KB and GP
  targetFont = "Target counter font";
  targetSize = "Targets counter size";
  targetStyle = "Targets counter style";
  targetXName = "Adjust targets position";
  targetXTT = "Move targets counter [<- left] or [right ->]";

  -- timer decimals and expiration color
  decimalChoiceName = "Enable timer decimals";
  decimalChoiceTT = "Always = Will always display decimals if the timer is active.\nExpire = Will enable more options.\nNever = Never.";
  decimalTholdName = "Decimals threshold";
  decimalTholdTT = "Decimals will show when timers fall below selected amount of seconds remaining";

  expireName = "Change expiring timer color";
  expireTT = "Change timer color when duration is running out.";
  expireTholdName = "Expiring timer threshold";
  expireTholdTT = "Color will change when timers fall below selected amount of seconds remaining if the setting is enabled";
  expirecolor = "Expiring timer color";

  -- enemy markers
  markerName = "Show Enemy Markers";
  markerTT = "Display a red arrow over the head of enemies you are currently in combat with.";
  markerSize = "Enemy Marker Size";

  -- debug
  dbgName = "Debug mode";
  dbgTT = "Display ability update events in the chat (|cFF0000SPAM WARNING!|r).";

  -- disclaimer
  disclaimer = "All credit goes to |cFFFF00@andy.s|r for his incredible work and dedication to the community.\nAt first I only made a few customization changes to better suit myself personally and added options to enable adjustments of these.\nThe tracking functions for the ability timers are inspired by the work of Solinur and Phinix, and I've learned all I know about it from reading their code (and I still have much to learn).";
};

---Returns a table with the configuration for the given mode and style
---@param mode number 1 for keyboard, 2 for gamepad
---@param vars FAB_AC_SV the saved variables
---@param style table the style table
---@return table
function FancyActionBar:UpdateContants(mode, vars, style)
  local SV = vars;
  local c = {};

  if mode == 1 then
    local kb = {
      duration = {
        font = SV.fontNameKB;
        size = SV.fontSizeKB;
        outline = SV.fontTypeKB;
        y = SV.timeYKB;
        color = SV.timeColorKB;
      };
      stacks = {
        font = SV.fontNameStackKB;
        size = SV.fontSizeStackKB;
        outline = SV.fontTypeStackKB;
        x = SV.stackXKB;
        color = SV.stackColorKB;
      };
      targets = {
        font = SV.fontNameTargetKB;
        size = SV.fontSizeTargetKB;
        outline = SV.fontTypeTargetKB;
        x = SV.targetXKB;
        color = SV.targetColorKB;
      };
      ult = {
        duration = {
          show = SV.ultShowKB;
          font = SV.ultNameKB;
          size = SV.ultSizeKB;
          outline = SV.ultTypeKB;
          x = SV.ultXKB;
          y = SV.ultYKB;
          color = SV.ultColorKB;
        };
        value = {
          show = SV.ultValueEnableKB;
          mode = SV.ultValueModeKB;
          font = SV.ultValueNameKB;
          size = SV.ultValueSizeKB;
          outline = SV.ultValueTypeKB;
          x = SV.ultValueXKB;
          y = SV.ultValueYKB;
          color = SV.ultValueColorKB;
        };
        companion = {
          show = SV.ultValueEnableCompanionKB;
          mode = SV.ultValueModeCompanionKB;
          x = SV.ultValueCompanionXKB;
          y = SV.ultValueCompanionYKB;
        };
      };
      qs = {
        show = SV.qsTimerEnableKB;
        font = SV.qsNameKB;
        size = SV.qsSizeKB;
        outline = SV.qsTypeKB;
        x = SV.qsXKB;
        y = SV.qsYKB;
        color = SV.qsColorKB;
      };
      abScale = {
        enable = SV.abScaling.kb.enable;
        scale = SV.abScaling.kb.scale;
      };
      move = {
        enable = SV.abMove.kb.enable;
        x = SV.abMove.kb.x;
        y = SV.abMove.kb.y;
      };
      style = {};
    };
    c = kb;
  else
    local gp = {
      duration = {
        font = SV.fontNameGP;
        size = SV.fontSizeGP;
        outline = SV.fontTypeGP;
        y = SV.timeYGP;
        color = SV.timeColorGP;
      };
      stacks = {
        font = SV.fontNameStackGP;
        size = SV.fontSizeStackGP;
        outline = SV.fontTypeStackGP;
        x = SV.stackXGP;
        color = SV.stackColorGP;
      };
      targets = {
        font = SV.fontNameTargetGP;
        size = SV.fontSizeTargetGP;
        outline = SV.fontTypeTargetGP;
        x = SV.targetXGP;
        color = SV.targetColorGP;
      };
      ult = {
        duration = {
          show = SV.ultShowGP;
          font = SV.ultNameGP;
          size = SV.ultSizeGP;
          outline = SV.ultTypeGP;
          x = SV.ultXGP;
          y = SV.ultYGP;
          color = SV.ultColorGP;
        };
        value = {
          show = SV.ultValueEnableGP;
          mode = SV.ultValueModeGP;
          font = SV.ultValueNameGP;
          size = SV.ultValueSizeGP;
          outline = SV.ultValueTypeGP;
          x = SV.ultValueXGP;
          y = SV.ultValueYGP;
          color = SV.ultValueColorGP;
        };
        companion = {
          show = SV.ultValueEnableCompanionGP;
          mode = SV.ultValueModeCompanionGP;
          x = SV.ultValueCompanionXGP;
          y = SV.ultValueCompanionYGP;
        };
      };
      qs = {
        show = SV.qsTimerEnableGP;
        font = SV.qsNameGP;
        size = SV.qsSizeGP;
        outline = SV.qsTypeGP;
        x = SV.qsXGP;
        y = SV.qsYGP;
        color = SV.qsColorGP;
      };
      abScale = {
        enable = SV.abScaling.gp.enable;
        scale = SV.abScaling.gp.scale;
      };
      move = {
        enable = SV.abMove.gp.enable;
        x = SV.abMove.gp.x;
        y = SV.abMove.gp.y;
      };
      style = {};
    };
    c = gp;
  end;

  c.hideOnNoTargetGlobal = FancyActionBar.GetHideOnNoTargetGlobalSetting();
  c.hideOnNoTargetList = FancyActionBar.GetHideOnNoTargetList();
  c.noTargetFade = FancyActionBar.GetNoTargetFade();
  c.noTargetAlpha = FancyActionBar.GetNoTargetAlpha();
  c.update = FancyActionBar.RefreshUpdateConfiguration();
  c.style = style;
  return c;
end;
