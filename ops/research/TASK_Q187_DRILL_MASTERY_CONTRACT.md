# TASK Q187 - QWEN - BLIND CONTRACT TEST FOR DRILL MASTERY AND THE BAG-CHAIN EVENT
Owner: qwen. Assigned S85, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q187-drill-mastery-contract`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (reuse it: `git fetch origin && git checkout -B
qwen/q187-drill-mastery-contract origin/master`).

## Why
S85 (training floor, step 3) shipped drill mastery pips, breakthrough days and the first floor event. Claude wrote the
pure modules `Godot/scripts/DrillMastery.gd` and `Godot/scripts/FloorEvents.gd` and a test against its own code
(`drill_mastery_test.gd`). A test written by the author only agrees with the author. You write the contract test
BLIND, from this file only. **Do NOT open DrillMastery.gd, FloorEvents.gd, GameState.gd or drill_mastery_test.gd.**

## What would a human do?
A strength coach and a boxing coach both keep a drill log: hours on a drill, when a fighter "has it" (pattern, fluent,
holds tired, holds moving, automatic), and the odd day a fighter suddenly gets it after a good night's sleep. A gym
owner checks bag chains every month or two and, when one slips, either takes the bag down or tapes it and hopes. The
test must prove the code keeps exactly those books - G115 (`research/G115_DRILL_MASTERY_RATES.md`) and G116
(`research/G116_GYM_FLOOR_EVENTS.md`) are the sources, both open to you.

## The contract (exact names; both modules are `extends RefCounted`, all `static func`, zero preloads)
`DrillMastery`:
- `PIP_HOURS := [6.0, 16.0, 36.0, 72.0, 140.0]`, `MAX_PIPS := 5`, `HOURS_PER_STATION_DAY := 1.0`.
- `pips(hours: float) -> int`: how many thresholds `hours` has reached (reaching = `hours >= threshold`).
- `progress_to_next(hours) -> float` in [0, 1]: the share from the current pip's threshold (0 before pip I) to the next;
  1.0 at pip V. `hours_to_next(hours) -> float`: hours still owed to the next pip, 0.0 at pip V.
- `station_kind(category: String) -> String`: "sc" for "strength" and "cardio", else "skill".
- `combo_family(category: String, modifiers: Array) -> String`: "grappling" if modifiers contains "grappling"; else
  "striking" for category "bags" or "ring"; else "".
- `gain_multiplier(hours, kind) -> float`: 1.0 plus the bonus of every earned pip. Skill bonuses per pip
  0.015 / 0.012 / 0.010 / 0.008 / 0.005; "sc" 0.010 / 0.008 / 0.006 / 0.005 / 0.004.
- `level_factor(rating: float) -> float`: 1.8 at rating <= 40; linear to 1.0 at 60; linear to 0.65 at 80; 0.65 above.
- `hours_for(station_days: float, rating: float) -> float` = `max(station_days, 0) * 1.0 / level_factor(rating)`.
- `bond_multiplier(rapport: int) -> float`: 1.0 for 40..60; above 60 linear to 1.5 at 100; below 40 linear to 0.5 at 0.
- `breakthrough_chance(hours, fatigue: int, rapport: int) -> float`: 0.0 if pips >= 5 or fatigue > 50; else
  (0.06 if pips <= 2 else 0.02) * bond_multiplier(rapport).
- `breakthrough_hours(hours, roll: float) -> float` = `hours_to_next(hours) * lerp(0.25, 0.40, clamp(roll, 0, 1))`.
`FloorEvents`:
- `COOLDOWN_DAYS := 4`, `BAG_CHAIN_DAILY := 1.0 / 60.0`, `CLOSE_COST := 40`, `CLOSE_CONDITION_GAIN := 10`,
  `TAPE_SNAP_CHANCE := 0.30`, `SNAP_CONDITION_LOSS := 35`, `TAPE_WEAR := 3`.
- `roll_event(day: int, last_day: int, open_event: Dictionary, bags: Array, roll: float, pick: float) -> Dictionary`:
  `{}` if `open_event` is not empty, if `bags` is empty, if `last_day >= 0 and day - last_day < 4`, or if
  `roll >= BAG_CHAIN_DAILY * bags.size()`. Otherwise an event with `id == "bag_chain"`, `day`, `station_id` = the picked
  bag's `instance_id` (bag index `min(int(pick * bags.size()), bags.size() - 1)`), and `choices` = exactly two entries
  with ids "close" and "tape".
- `resolve(event, choice_id, roll) -> Dictionary`: "close" -> `ok true, cost 40, condition_delta +10, closed_days 1,
  snapped false`; "tape" with `roll < 0.30` -> `cost 0, condition_delta -35, snapped true`; "tape" otherwise ->
  `condition_delta -3, snapped false`; an unknown choice or an event whose id is not "bag_chain" -> `ok false`.

## The work
Write `Godot/tests/drill_mastery_contract_test.gd` (extends SceneTree, `load()` the two scripts inside `_initialize()`,
print SKIP and exit 0 if either is missing). Hand-computed rows, at least: pips at 5.999/6/15.99/16/139.99/140/500;
progress_to_next at 0, 11 (half of 6..16) and 140; gain_multiplier skill and sc at 0, 6, 36, 140; level_factor at 30,
50, 60, 70, 80, 95; bond_multiplier at 0, 20, 40, 60, 80, 100; breakthrough_chance at pip 0, pip II, pip III, pip V,
fatigue 51, bond 100; breakthrough_hours at roll 0, 0.5, 1 and 2 (clamped); roll_event: cooldown day 3 vs day 4, an open
event, no bags, the rate edge with two bags (roll just under and at 2/60), and the pick index for pick 0.99 with three
bags; resolve for all four outcomes. Prove it with THREE mutants applied to a scratch reference implementation of your
own (not ours): pip thresholds off by one hour; breakthrough 0.06 applied at pip III; cooldown `<=` instead of `<`.
All three must fail your test.

## Owned files
`Godot/tests/drill_mastery_contract_test.gd`, `research/Q187_DIGEST.md`.

## Tier
A new test file only: parse gate on it (`python Godot/tools/check_scripts.py Godot/tests/drill_mastery_contract_test.gd`),
then run it once:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/drill_mastery_contract_test.gd`.
No suite (it runs nightly).

## Research
All research is open: root `RESEARCH_INDEX.md`, G115 and G116. Do NOT read HANDOFF.md, CURRENT_STATUS.md or
HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q187 --body "<rows, mutants caught, any disagreement>"`.

## The trap
If your test fails against our module, do NOT "fix" your expectation toward what the module returns - that turns a blind
test into a copy. Report the row in the digest with the contract line it tests; Claude decides which side is wrong.
