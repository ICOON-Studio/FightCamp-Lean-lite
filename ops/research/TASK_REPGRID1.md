# TASK REPGRID1 - the fighter's punch mastery on the profile's TECHNIQUES tab (FIGHTLINK step 3, boxing)

THIS IS THE TASK. Model: Cursor (cloud). Discipline: BOXING (demo).

## Why
Operator S248 (verbatim): "Go - build FIGHTLINK in that order: evasion/chin/accuracy, move mastery, then the profile, fight notes,
corner report and post-fight why." Move mastery is LIVE in the game (switch `move_mastery`, GAME_ON): every club drill grows
`athlete["move_mastery"][<technique id>]` (0-100, e.g. `"boxing_jab": 61.4`), and in the bout a Sharp jab recovers faster, hits
harder, costs less and is slipped less (rules/MoveMastery.gd `effects`). The player cannot SEE any of it. Step 3 shows it on the
profile. Design: Ludo r115 Section B (`research/ludo_rx/LUDO_R115_raw.txt` :327-352: tier badge RAW / USB / SHP / SIG, the number
M, windup / accuracy / power / recovery) - placed inside the TECHNIQUES tab the game already has, not a new screen.

## The route the game runs (traced)
Profile -> `scripts/ui/ProfileTabHost.gd` tab "TECHNIQUES" -> `scripts/ui/ProfileTabContent.gd` (1,153 lines):
`_build_techniques` (:56) builds three panels - tree (left, 520 px), stage (centre, 760 px), inspector (right, 500 px).
Tree rows: `_make_technique_row` (:303) with `_mastery_line(row)` (:364, today 5 stars from the LEARNING progress - a different thing).
Inspector: `_refresh_detail(ctx)` (:428) fills `_detail_title`, `_detail_tier`, `_detail_stats`, `_detail_prereq`.

## Files you own
1. NEW `Godot/scripts/rules/RepertoireRows.gd` - pure (`extends RefCounted`, static funcs, preload only `res://scripts/rules/MoveMastery.gd`):
   - `static func badge(m: float) -> String` -> "" (no entry / 0) / "RAW" / "USB" / "SHP" / "SIG" from `MoveMastery.tier(m)`.
   - `static func row(technique_id: String, mastery_map: Dictionary, stats: Dictionary) -> Dictionary` -> `{"id", "m", "badge",
     "windup_pct", "power_pct", "recovery_pct", "stamina_pct", "slip_pct"}`: the *_pct are signed percent changes vs today's punch
     (`MoveMastery.effects(m, BASE_HAND_SPEED, BASE_TECHNIQUE, BASE_RING_IQ)` - the SAME baseline call FightRealtime makes at bout start,
     line ~1810), e.g. recovery_mult 0.88 -> recovery_pct -12; slip_pct from `telegraph` (0.5 = today = 0). No entry -> m 0, badge "",
     every pct 0.
   - `static func line(row: Dictionary) -> String` -> "SHP M71  windup -6%  power +8%  recovery -12%  slipped -4%" (omit zero terms;
     "NOT DRILLED" when badge is "").
2. NEW `Godot/tests/repertoire_rows_test.gd` (extends SceneTree, OK/FAIL lines, ends `print("REPERTOIRE_ROWS failures=%d" % failures)`).
3. EDIT `Godot/scripts/ui/ProfileTabContent.gd`, two places only:
   - `_make_technique_row` (:303): when `GameSwitches.on("move_mastery")` and the athlete has an entry for that row's id, a small
     badge Label (name `MasteryBadge`, text e.g. "SHP 71", tier colour: RAW `UIKit.COLOR_TEXT_MUTED`, USB the text colour, SHP and SIG
     the accent colour you find in UIKit) right-aligned on the row; nothing added when OFF or no entry.
   - `_refresh_detail` (:428): when ON, append `RepertoireRows.line(...)` as a new line under `_detail_stats` (a Label named
     `MasteryLine`, created once in `_build_technique_inspector` :243, hidden when OFF / nothing selected).
   Do not touch any other function, the star line, or the layout constants.

## Acceptance (numbers, not pictures - you cannot see images)
- `repertoire_rows_test.gd`: badge flips at 30 / 60 / 85 (read `MoveMastery` tier bounds, not literals); a row at the baseline
  mastery (`MoveMastery.BASE_MASTERY`) gives every pct 0; a row at 90 has recovery_pct < 0 and power_pct > 0; no entry -> "NOT DRILLED";
  line never contains "{".
- Extend `Godot/tests/profile_techniques_uicards1_test.gd` (do NOT remove or weaken a check): with
  `athlete["move_mastery"] = {"boxing_jab": 71.0}` and the switch ON (set `GameState.career["move_mastery"] = true` the way other tests do,
  or pass the user arg), the jab row holds a `MasteryBadge` whose text starts "SHP 71", and selecting the jab makes `MasteryLine` visible
  with "M71"; with the switch OFF neither node exists or both are hidden.
- Parse gate: `python Godot/tools/check_scripts.py <every .gd you touched>`.
- PR body: `RESULT: tests/repertoire_rows_test.gd -> REPERTOIRE_ROWS failures=0` and the profile test's pass line.

## Prior research
`python Tools/prior_research.py repertoire mastery profile`: Ludo r115 (the mastery rules + Section B layout), TASK_FIGHTLINK2 (MoveMastery
contract). Plain `--script` tests are the OFF control arm (game switches off; as_game turns them on) - the OFF test above is that arm.

## What would a human do?
A coach's notebook lists each punch with a word for how sharp it is ("jab - sharp, hook - still raw"); the player wants the same at a
glance on the list, and the numbers when he looks closer.

## Prefab check
Godot UI built from the project's own UIKit; no asset. No library for this.

## Contract
OWNS: Godot/scripts/rules/RepertoireRows.gd, Godot/tests/repertoire_rows_test.gd, Godot/scripts/ui/ProfileTabContent.gd (the two places), Godot/tests/profile_techniques_uicards1_test.gd (append only)
RED_TEST: Godot/tests/profile_techniques_uicards1_test.gd -> fails=0
(the new MasteryBadge check fails on master; the pass line is "PROFILE_TECHNIQUES_UICARDS1 total=<n> fails=0")
REGRESSION: repertoire_rows_test, profile_techniques_uicards1_test
VISUAL: yes - Claude takes the still on the game's profile screen and the operator closes it

## The trap
GDScript `:=` cannot infer from a Variant (Dictionary values) - type it (`var m: float = ...`). Read GDSCRIPT_TRAPS.md. Never delete or
weaken a test check. Work on branch cursor/issue-<n>, open a PR, never merge.
