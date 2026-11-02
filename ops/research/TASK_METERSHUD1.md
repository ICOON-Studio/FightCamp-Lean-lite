# TASK METERSHUD1 - the floor HUD panel for the GAINS / ATTRITION meters + CHANGE THE PLAN pill (S238, LOOP1 slice 1)

Seat: Cursor (Godot UI, cloud). Branch `cursor/issue-<n>`, PR to master; Claude reviews and merges by diff. Model: Cursor default.
Discipline: BOXING (the demo's gym floor).

Operator ruling (board Q-S237-1, approving research/LOOP1_VERDICT_S238.md): "build it, the equipment wear is not what matters on
this , the loop , animations,workout,feeling of progrsession and improvement from training these are what matters for now".
His words on the meters (S237): "this needs to be nicely handled with visuals on gains and atrittion meters so the player can understand
when he need to change the training plan , so big emphasis on this part". He also ruled (S212): "use animated meters" - every bar tweens.

This round builds ONE self-contained Control. The rules module `scripts/rules/TrainingMeters.gd` is being written in parallel by Arena
(TASK_METERS1.md) - do NOT wait for it and do NOT preload it: your panel takes plain dictionaries in the shapes below. Claude wires the
panel onto the floor (GymHall3D) behind switch `training_meters` next round. Do not edit GymHall3D.gd, GameState.gd or any rules file.

## The design (lead designer Ludo r102, `research/ludo_rx/LUDO_R102_LOOP1_raw.txt` section B - read it)
Top-left of the floor screen, under the fighter's name badge, never over the ring:
- **GAINS**: emerald bar (about 240 x 16 px) + an arrow ticker ("▲ +1.8 today"), a 7-day sparkline under it, the two top stats
  ("POWER +0.4  STAMINA +1.2"). Trend word: BUILDING / FLATTENING / DROPPING.
- **ATTRITION**: a segmented bar with three zones - COOL (cool cyan/white), AMBER (amber), RED (pulsing crimson). Under it two micro bars:
  FATIGUE and WEAR. A zone word (OPTIMAL / PUSHING IT / OVERDONE).
- **PILL** (when the signal is on): "[!] CHANGE PLAN: GAINS FLATTENED - SWAP TO RECOVERY" - crimson with diagonal hazard stripes and a
  flash; WATCH level is an amber pill "PLATEAU APPROACHING". When coached, the line is the coach speaking ("Coach: ...").
  The pill has one button `SWAP TO RECOVERY` that emits `fix_pressed(fix_id)` (fix_id from the dict, e.g. "recovery_block").
- Readable over the 3D floor: a dark plate behind the panel (the S237 creation fix used a dark plate under gold text for the same reason).
- ANIMATED (operator S212): every bar tweens from its old value to the new (0.4-0.6 s, ease out); a zone change pulses the bar once.

## Do - new `Godot/scripts/ui/TrainingMetersHud.gd` (extends Control, no class_name)
- `func show_read(gains: Dictionary, attrition: Dictionary, signal: Dictionary, fighter_name: String) -> void` - shapes (from TASK_METERS1):
  - gains: `{"today": float, "avg7": float, "spark": Array[float], "trend": "RISING"|"FLAT"|"FALLING", "top": [[stat, delta], ...], "line": String}`
  - attrition: `{"value": float 0..100, "zone": "COOL"|"AMBER"|"RED", "fatigue": float 0..100, "wear": float 0..100, "monotony": float, "line": String}`
  - signal: `{"on": bool, "level": "NONE"|"WATCH"|"CHANGE", "reason": String, "pill": String, "fix": String}`
- `signal fix_pressed(fix_id: String)`.
- Test seams: `bar_value(name) -> float` (name "gains" | "attrition" | "fatigue" | "wear", the TARGET value), `zone_text() -> String`,
  `pill_visible() -> bool`, `pill_text() -> String`, `is_animating() -> bool`.
- Use the project's UI kit: `const UIKit := preload("res://scripts/UIKit.gd")`, `const T := preload("res://scripts/UITokens.gd")`
  (`UIKit.block`, `UIKit.caps`, `UIKit.display`, `UIKit.pulse`, `UIKit.button`; colours from T where one fits). Sparkline = `_draw()` polyline.
- Gains bar fill: map `today` against a scale where the fighter's own `avg7` sits at ~60% (so "more than usual" visibly overfills).

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/training_meters_hud_test.gd` (extends SceneTree, `_initialize`, prints `TRAINING_METERS_HUD failures=N`, quit(1) on fail).
Three fixtures, printed at the top (never identical fighters): a rising welterweight prospect (COOL, no pill), a stale middleweight
veteran (FLAT + RED -> CHANGE pill visible with the fix button), a coached female featherweight on WATCH (amber pill, coach line).
Assert: bar target values match the dicts; zone text per zone; pill visible only for WATCH/CHANGE; pressing the fix button emits
`fix_pressed("recovery_block")`; a second `show_read` with a new value starts a tween (`is_animating()` true right after); the panel's
rect stays inside 1920x1080 and its width <= 460 px; nothing overlaps (pill below the bars).
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/training_meters_hud_test.gd`. Parse gate first:
`python Godot/tools/check_scripts.py Godot/scripts/ui/TrainingMetersHud.gd Godot/tests/training_meters_hud_test.gd`.

## Rules
GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`, Label sizing). New features ship ON (CLAUDE.md s10) - the switch is the
wiring round. THE ONE TRAP: do not weaken or delete a test to go green; the bars must ANIMATE (a jump fails the operator's rule).

## Prior research
LOOP1_VERDICT_S238.md, LUDO_R102_LOOP1_raw.txt (layout), TASK_METERS1.md (the dict shapes), J63_PLAN_CHANGE_REPLY.md (signals; the
thresholds are the module's business), feedback "animated meters" (S212), the S237 dark plate under creation text.

## What would a human do?
A coach glances at the whiteboard: one line going up (what he gained), one going up that should not (how worn he is); when the second
crosses the red line he blows the whistle and sends the fighter to the stretch mats.

## Prefab check
None needed - Godot Control + Tween + _draw; no asset.
