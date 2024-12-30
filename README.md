Fancy Action Bar+ builds on the original [Fancy Action Bar](https://www.esoui.com/downloads/info2462-FancyActionBar.html) by @andy.s, enhanced by @nogetrandom to add a large amount of customization in ability tracking including tracking for multiple instances of effects, stack tracking, tracking for debuffs on specific targets, timers for cast and channeled abilities, UI customization and much, much more!

Bug reports, feedback, and feature requests strongly encouraged! (GitHub preferred: [GitHub](https://github.com/DakJaniels/FancyActionBarPlus))

## User Guide and Menu Option Documentation for v2.11.1

### ACTIONBAR SIZE & POSITION

Options for changing the size and position of the action bar, quickslot and ultimate slot

#### Keyboard UI or Gamepad UI

Keyboard UI and Gamepad UI have separate sub-menus but identical options

* Enable Action Bar Resize (default: OFF) – enables the slider to change the actionbar size
* Actionbar size (default: 100%) slider to change the actionbar scale, supports making the actionbar smaller down to 30% of the default size, or up to 250% larger than the default size.
* Unlock Actionbar Position (default: OFF) – switch to ON to allow changing the action bar position on screen when in keyboard mode. Switch back to OFF when satisfied with the position. Keyboard and Gamepad mode settings are independent.

#### Adjust Quickslot Position

Applies an offset to the quickslot position. Applies to Keyboard UI or Gamepad UI depending on which UI mode is active.

* Horizontal (X) Position (default: 0), negative values move the slot left, positive values move it right.
* Vertical (Y) Position (default: 0), negative values move the slot up, positive values move it down.

#### Adjust Ultimate Slot Position 

Applies an offset to the ultimate slot position. Applies to Keyboard UI or Gamepad UI depending on which UI mode is active. Companion Ultimates will appear to the right of wherever the ultimate slot is placed

* Horizontal (X) Position (default: 0), negative values move the slot left, positive values move it right.
* Vertical (Y) Position (default: 0), negative values move the slot up, positive values move it down.

[![Actionbar Size & Position](https://i.imgur.com/pydnjTB.png)](https://i.imgur.com/pydnjTB.png)

#### Adjust Bar Spacing and Offset

* Horizontal (X) Position (default: 0) - Adjusts the relative position of the front and back action bars with respect to each other along the X (horizontal) axis (changing this value will shift the top bar left, and the bottom bar right, or vice versa)
* Vertical (Y) Position (default: 0) - Adjusts the relative position of the front and back action bars along the Y (vertical) axis. This setting effectively changes the gap between the top and bottom bar. Recommended setting: 4 for a gap that matches the gap between action buttons.
* Button (X) Spacing (default: 4 keyboard; 10 gamepad) - Adjusts the spacing between action buttons within the action bar.

### GENERAL

#### Front & Back Bars Position

Sets the position of the front and back action bars. By default, the front bar is on the bottom and the back bar is on the top

* Static bar positions (default: ON) – when swapping weapons, the action bars do not change position. If disabled, the active bar will always be on the bottom, and the inactive bar on top.
* Front bar on top (only for static bars) (default: OFF), by default the front bar is on the bottom and the back bar is on the top. If enabled, the back bar will be on top and the front bar on the bottom.
* Active bar on top (not for static bars) (default: OFF) by default when static bar positions are off, the active bar is on the bottom and the inactive bar is on the top. Enabling this setting will put the active bar on top and the inactive bar on the bottom

#### Back Bar Visibility

* Inactive bar alpha (default: 20) sets the transparency of the inactive bar ability icons. 0 will set the backbar icons completely transparent, 100 will disable backbar icon transparency.
* Inactive bar desaturation (default: 50) sets the desaturation (greyscale) level for the inactive bar icons. 0 will set the back bar icons to be the same level of saturation as the front bar icons, 100 will set the back bar icons to be completely greyscale.

#### Hotkey Text

Show hotkeys (default: ON) – show the hotkeys under the action bar icons.

### UI CUSTOMIZATION

#### Button Frames

Button frames options only apply to Keyboard UI

* Show frames (default: ON) – show a colored frame around the action bar icons
* Frame color (default: R:0;G:0;B:0;A:255 –  Black) – allows customization of the ability frame color
* Hide default frames (default: OFF) – if “Show Frames” is disabled, then the default ESO action bar frames will be shown around ability Icons. If both show frames is off, and hide default frames is on, then ability icons will be shown entirely without frame borders

#### Active Ability Highlight

* Show highlight (default: ON) abilities will show a highlight glow while they are active
* Highlight color (default: R:0;G:255;B:0;A:179 –  Green)

[![Active Ability Highlight](https://i.imgur.com/vV1oXEx.png)](https://i.imgur.com/vV1oXEx.png)

#### Miscellaneous

* Force enable gamepad Action Bar style (default: off) - Setting to ON allows the use of the gamepad action bar theme including animations while in the Keyboard UI. Note that while in this mode FAB+ menu settings, and default options (unless adjusted) that refer to the Gamepad UI will be used.
* Show gamepad ultimate hotkeys (default: ON) – Show the LB RB labels for gamepad UI. Set this to OFF to allow quickslot placement adjustments in gamepad UI
* •	Use thin gamepad button frames borders (default: OFF) – Replaces the default gamepad frames with a minimal 1px black frame border with no backdrop
* Hide companion ultimate slot (default: OFF) – When enabled, the companion ultimate slot, normally anchored to the right of the player ultimate slot when a companion has an ultimate ability slotted will always be hidden
* Hide locked Action Bars (default: ON) – When enabled if an effect locks the ability to barswap (such as equipping the Oakensoul ring, transforming into a Werewolf, picking up Volendrung, or various effects in dungeons or Trials such as the Ghost light Transformation in Lucent Citadel) the UI will switch to a “one bar” mode that only shows the active bar.
[![Hide locked Action Bars](https://i.imgur.com/SEVGXcd.png)](https://i.imgur.com/SEVGXcd.png)
* Reposition active bar when locked (default: ON) - When the locked action bar is hidden the ui will reposition the active bar to center it, aligned with the default quickslot and ult slot positions. If disabled, the inactive bar will be hidden but the action bar will not be repositioned (this does not work properly for when the back bar is the active bar.) 
* Apply Skill Styles to Action Bar Slots (default: ON) – by default Fancy Action Bar + will apply the icons for skill style ability overrides to the icon on the action bar. Note that different ability morphs share the same skill icon which can make determining slotted skill morphs difficult. For maximum compatibility with skill style icon overrides, it is recommended to also install the separate, optional, “Action Bar Skill Styles” addon.

[![Skill Styles](https://i.imgur.com/mZt3Rjn.png)](https://i.imgur.com/mZt3Rjn.png)

### TIMER DISPLAY – KEYBOARD UI or GAMEPAD UI

Keyboard UI and Gamepad UI have separate sub-menus, and slight different defaults but identical options

#### TIMER DISPLAY SETTINGS

Options in this menu include settings to configure the font, font size, font style, vertical alignment of the ability timer on the action slot (set positive values to shift the timer up, negative values to shift the timer down), and the color (default: white) of the ability timer (when not overridden by the separate expiration settings)

#### STACKS DISPLAY SETTINGS

Abilities that can “stack” effects (e.g. charges on crystal weapon, damage stacks on simmering frenzy, instances of echoing vigor applied by allies, etc.) can display a counter showing the value of these effects. These settings configure the display settings for the stack counter. 

Ulfsild's Contingency variants will display a special stack icon (¤ symbol) to indicate that the initial effect has been cast and is available to be consumed.

[![Stacks Display Settings](https://i.imgur.com/FQ5ReOV.png)](https://i.imgur.com/FQ5ReOV.png)

Options in this menu include settings to configure the font, font size, font style, postion on the action slot (default: top right aligned), and the counter color (default:gold)

#### TARGETS DISPLAY SETTINGS

Abilities can also display a counter showing the number of targets that this ability has been applied to. These settings configure the display settings for the stack counter. 

Options in this menu include settings to configure the font, font size, font style, position on the action slot (default: top left aligned), and the counter color (default: gold)
More options for configuring the behavior of this counter are located under: ADDITIONAL TRACKING OPTIONS > Multitarget Effect Tracking Options.

[![Targets Display Settings](https://i.imgur.com/zGNSjQq.png)](https://i.imgur.com/zGNSjQq.png)

#### ULTIMATE TIMER SETTINGS

Options for displaying a timer for active Ultimate effects. If more than one ultimate is active it will show the timer for the current bar’s ultimate, otherwise it will show the timer for any active ultimate and will persist through barswap.

[![Ultimate Timer Settings](https://i.imgur.com/MIefosk.png)](https://i.imgur.com/MIefosk.png)

Options in this menu include settings to disable the timer (enabled by default), configure the font, font size, font style, color, and adjust the vertical and horizontal position relative to the ultimate slot. The default position is aligned to the outside right border of the ultimate slot.

#### ULTIMATE VALUE SETTINGS

Options for configuring display of your current ultimate value.

By default showing the current ultimate value is enabled. Several modes for displaying the ultimate value are supported through the "Display Mode" setting:
“Current” (default) displays the current ultimate value. “Current  / Cost (dynamic)” displays the current value / ultimate cost when the current value is less than the cost, but switches to just displaying the current value if the current value is enough to cast the ultimate. “Current / Cost (static)” always displays both the current value and the cost of the ultimate.

Additional options in this menu include settings to configure the font, font size, font style, and adjust the vertical and horizontal position of the ultimate number relative to the ultimate slot. The default position is aligned to the inside bottom right border of the ultimate slot.

FAB+ also supports the ability to dynamically set the ultimate value color.
By default the ultimate value will be white, and change to gold when it is at 90% of the ultimate cast cost (this threshold is customizable in the menu). The ultimate value will then turn green when the ultimate is usable, and red when the maximum value of 500 ultimate is reached.

[![Ultimate Value Settings](https://i.imgur.com/4Mk6O2W.png)](https://i.imgur.com/4Mk6O2W.png)

#### Companion Ultimate Settings

The companion ultimate value will inherit the font and size (but not color) of the player ultiamte. Position of the companion ultimate with respect to the player ultimate can be adjusted.
Options in this menu include settings to show or hide the companion ultimate (default: ON), and adjust the horizontal and vertical offset of the slot. By default the companion ultimate slot is anchored to the right of the player ultimate slot/timer.

#### QUICKSLOT DISPLAY SETTINGS

Options for customizing the display of the quickslot. Options in this menu include settings to show or hide the cooldown duration for the slotted item (default: ON), as well as to set the timer font, font size, style, color (default: Tangerine), and vertical and horizontal alignment of the cooldown timer within the slot (default: upper middle center), and the quickslot stack count font style.

### KEYBOARD & GAMEPAD SHARED

This menu contains settings that are shared across both keyboard and gamepad UI modes.

#### Timer Fade

* Delay timer fade (default: ON) – Allow the timer label to display 0 for a set duration as a reminder that the ability has expired
* Fade delay (default: 2 seconds) – duration to keep the 0 timer if “Delay timer fade” is on

#### Duration Display Decimals

* Enable timer decimals (default: Expire) – Options: Always; will always display decimals for the ability timer. Expire; show ability timer decimals when abilities are near expiration.
* Decimals threshold – (default: 2 seconds) the time remaining thresholds below which abilities will display decimals if “Enable timer decimals” is set to “expire”

#### Display Changes for Expiring Effects

Expiring timer threshold (default: 2 seconds) – timers will be considered “expiring” and change to display decimals, or change their highlight color, when they fall below the selected amount of seconds remaining if their individual settings are enabled.

#### Timer Text

* Change expiring timer text color (default: ON) – change the timer text color when the ability timer is below the “Expiring timer threshold” value.
* Select timer text color for expiring effect (default: Yellow)

#### Highlight

* Change expiring timer highlight color (default: OFF) – when enabled the ability highlight will change color when the effect duration is below the “Expiring timer threshold” value
* Select highlight color for expiring effects (default: Red)

### ABILITY CONFIGURATION

#### CURRENTLY SLOTTED ABILITY IDS

Lists the currently slotted skill names and ability IDs for the skills on each action bar

#### TRACKED EFFECTS

Here you can edit which effect you want the timer for a specific skill to track. To track a different effect, make sure to enter the ID of the skill and the ID of the new effect, before clicking the button to confirm. 

* Accountwide Skill Settings (default: ON, requires reloadui) – by default skill configuration changes will be applied to all characters.
* Saved Changes – A list of saved skill tracking configuration changes. Selecting a Skill from the dropdown menu will automatically populate it’s Skill ID
* Skill ID – enter the ID of the skill you want to change the configuration for
* Change Type – Options: Disable (Disable tracking for this skill), Reset (Resets the skill configuration to the FAB+ Default), New ID (assign a new effect to track to this skill
* New Effect ID – the ability id for the new effect that you want the selected skill to track. If Change Type is “Reset” or “Disable” leave this blank.
* Confirm Change – after entering the configuration changes, select confirm change to apply the new configuration. Configuration changes will print a message to the chatbox describing the change made when confirmed

Example configuration change:
[![Tracked Effects](https://i.imgur.com/4Pqug29.png)](https://i.imgur.com/4Pqug29.png)

#### BUFFS GAINED FROM OTHERS

Enable ability timers to track the duration of buffs gained from allies. You can also select which effects you do not want to have tracked if you are not the source. This feature is disabled by default

* Track Buffs From Others (default: OFF) – by default only effect durations for effects applied by you will be tracked

Blacklisting Options for Buffs Gained from Others: this menu contains a configuration tool to blacklist certain which will prevent other player's application of them from starting an action bar timer. By default this includes miscellaneous Restoration Staff Abilities, Vigor, Resolve, and some other common buffs. Blacklisted abilities can be removed by selecting an ability from the list and clicking “Remove from Blacklist”

#### DEBUFFS ON TARGET

By default FancyActionBar+ configures effect timers to track the basic ability duration. This feature enables an alternative behavior where the timers for debuffs will instead track durations for the given debuff on the specific enemy being targeted

This supports several options:

* Debuff timers for current target (default: OFF) – enable the alternative “debuff on target” tracking behavior. Without this enabled, tracked debuffs will always display their longest active duration
* Keep Timers For Last Target (default: ON) – with this enabled, when you move your reticle away from the debuffed target it will keep the active duration for the target until a new enemy is targeted. With this OFF, the timer will only show while the reticle is on the debuffed target.
* Show Stack Count for Overtaunt Debuff (default: OFF) - Multiple taunt sources can cause an enemy to gain taunt immunity, this enables a stack counter to track the status of this debuff on skills that can taunt. Note, this feature is experimental and may not appear.

### ADDITIONAL TRACKING OPTIONS

#### Effect Duration Thresholds

Set the limits for when to ignore effects based on their duration

* This section contains options to set the minimum and maximum duration of abilities that will be tracked by action slot timers. By default, if an ability lasts less than 2 seconds, or longer than 120 seconds it will not be shown.

#### Multitarget Effect Tracking Options

Additional options for configuring the Targets Tracker behavior that by default, appears on the top left corner of the action slot. This includes the ability to disable this counter, an option to show the counter when only one instance of an effect is active (by default the counter will only appear if more than one instance is active, except for debuffs in the Debuffs on Target mode where it always appears).

Additionally a menu is provided to allow blacklisting effects that you do not want to display a target counter for.

#### Miscellaneous Options

* Show Stack Counter (default: ON) - Show stack count for abilities that can have multiple stacks, or can stack multiple times. 
* Show Cast/Channel Times on Action Slots (default: ON) – If an ability has a cast or channel time, it will display that duration on the slot while the ability is being cast/channeled. Abilities must have a cast or channel time longer than 1 second for this timer to display.
* [EXPERIMENTAL] Show Tick Rate for Toggles (default: OFF) – Some toggled abilities have effects that `tick` while the ability is toggled, such as the resource return on Meditate. If enabled, the action bar will attempt to show the timer until the next tick. Load screens can cause this timer to desync from the game engine timer until the ability is retoggled.* Ignore Initial Trap Placement (default: OFF) - By default 'Trap' effects, such as Trap Beast and Scalding Rune display an initial timer and stack when placed, and switch to tracking the DOT when triggered. Toggle ON to only track the DOT.
* Show Timer For Soonest Expiring Target (default: OFF) - By default an ability timer will show the duration for the last cast of the ability, with this option enabled it will show the duration for the soonest expiring target instead.
* Ignore Ungrouped Allies (default: OFF) - By default FAB will track buffs applied to all allied players. With this setting enabled only buffs applied to group members will be tracked. If you are not grouped this setting will be ignored and buffs will be tracked on all players.
* Allow Fallback Timers (default: OFF) – By default only durations for the specific effect will be tracked for configured abilities. When tracking an effect ID that is a shorter duration than the game’s duration for the “parent” (slotted) ability, allow the action bar timer to fallback to the parent ability timer for the remaining duration. This will also cause the slot to swap to the expiring effect highlight (but not timer) color when this changeover occurs.

### MISCELLANEOUS

Additional miscellaneous options include the ability to show the action bar while dead (default: OFF), prevent casting abilities while trading (default: ON), enable compatibility with the Perfect Weave addon (default: OFF), setting to adjust the health bar position to prevent overlap with FAB (default: ON), setting to also adjust the mag and stam bar positions to align (default: OFF), showing markers on enemies you are currently in combat with, and enabling a global cooldown tracker widget.
