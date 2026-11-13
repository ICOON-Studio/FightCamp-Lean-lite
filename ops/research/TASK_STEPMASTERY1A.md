# TASK STEPMASTERY1A - QWEN (qwen3-coder) - steps and defences get practice bars: the pure rules module

Status: OPEN (S452, Claude main). Discipline: boxing (demo). Model: qwen3-coder.
Part A of STEPMASTERY1 (progression map M5). Claude wires it into the game afterwards (FireLevel.mastery_of, the plan screen); this task
is the pure rules only.

## Contract
OWNS: scripts/rules/StepMastery.gd (new, under 150 lines), tests/step_mastery_test.gd (new)
RED_TEST: tests/step_mastery_test.gd -> STEP_MASTERY failures=0
REGRESSION: move_mastery_test (if it exists), file_limits_test
VISUAL: no
NOT YOURS: every other file. Do NOT edit FireLevel.gd, StrikeMap.gd, MoveMastery.gd or anything in scripts/state, scripts/ui, scripts/fight3d.
StepMastery may preload and CALL scripts/rules/MoveMastery.gd (read it first: tiers 30 / 60 / 85, gain(), cap()) - never copy its numbers.

## The rules (ops/research/PROGRESSION_MAP_S448.md lines 91-103 and section M5, lines 160-170 - read both)
Nodes (ids as in scripts/rules/StrikeMap.gd): footwork `step_in, step_out, step_back, pivot_out, cut_off, herd, feint`;
defences `tie_up, roll_out, push_off`. 10 nodes. Constant `NODES` (Array of ids) and `NAMES` (id -> the StrikeMap "name").

Functions (all static, pure, no preloads besides MoveMastery):
1. `start_values(footwork: float) -> Dictionary` - a newly signed fighter: step_in and step_out = max(30.0, 0.55 * footwork); every other
   node 0.0. Every NODES id present.
2. `from_old_save(plan_arrows: Array) -> Dictionary` - an old save with no step bars: a node whose id is in plan_arrows starts at 60.0, any
   other node at 30.0. Plan arrows may carry a place suffix ("tie_up@own_ropes"): strip from "@" before matching.
3. `drillable(id: String, m: float, slot_id: String) -> bool` - a shadow morning, own chain or pad night may drill a node only if it is the
   slot's move (id == slot_id) or it is already at 30+.
4. `shadow_gain(m: float, hours: float, coach_skill: float, cap_value: float) -> float` - MoveMastery.gain with station "shadowbox"
   (0.85 an hour). Pass station_tier 1.0, efficiency 1.0 (read gain()'s signature; minutes = hours * 60 if it takes minutes).
5. `grey_reason(id: String, m: float, gain_per_night: float) -> String` - "" at 30+. Under 30: "<Name>: learning, <n> pad nights" with
   n = nights_to_usable(m, gain_per_night); "1 pad night" singular; gain_per_night <= 0 -> "<Name>: learning, needs pad nights".
6. `nights_to_usable(m: float, gain_per_night: float) -> int` - ceil((30 - m) / gain_per_night), 0 at 30+, -1 when gain_per_night <= 0.
7. `fire_mastery(bars: Dictionary, arrow: String) -> float` - the mastery FireLevel will read for a step/defence arrow: strip "@...",
   return bars[id] if present, else 100.0 (a save or bout with no bars fires as today).

## Test (tests/step_mastery_test.gd, extends SceneTree, prints "PASS ..." / "FAIL ..." lines and a last line `STEP_MASTERY failures=<n>`,
quits with that count) - at least one case per function, including: footwork 40 -> step_in 30.0 (floor), footwork 80 -> 44.0; old save with
["step_in", "tie_up@own_ropes"] -> step_in 60, tie_up 60, pivot_out 30; drillable pivot_out at 0 false unless it is the slot; grey_reason
("pivot_out", 12, 6) == "Pivot ...: learning, 3 pad nights" using NAMES; nights_to_usable 29.5 / gain 1 -> 1; fire_mastery({}, "herd") == 100.
Write each expected value FROM THIS BRIEF, not from your code. Prove the test can fail: break one function locally, see FAIL, restore.

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (Variant `:=` on Dictionary reads / ternaries: give the type, e.g. `var x: float = ...`).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who STEPMASTERY1A -- <godot.exe> ...`, plain
  Godot_v4.7.2-stable_win64.exe --headless (never _console.exe). Nothing opens on the operator's screens.
- NEVER stop a Godot process you did not start. Do not delete or weaken any test. Every file under 500 lines.

## Prior research
- ops/research/PROGRESSION_MAP_S448.md (v4.1, his Q-211 "Yes, go ahead"), scripts/rules/MoveMastery.gd, scripts/rules/FireLevel.gd
  (mastery_of returns 100.0 for steps today - this module is what replaces it).

## What would a human do?
A coach knows every boxer can step in and out on day one, and drills the rest one at a time until it is good enough to use in a bout.

## Prefab check
Our own MoveMastery already holds the gain and tier rules; reuse it, add nothing to it.

Test command: `python ops/Tools/godot_slot.py run --who STEPMASTERY1A -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/step_mastery_test.gd`
RESULT line for the PR body: `RESULT: tests/step_mastery_test.gd -> STEP_MASTERY failures=0`.
