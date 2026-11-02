# TASK FIGHTGAP1 - boxers stop fighting chest to chest: per-punch spacing in the engine (S261)
Model: Arena default (cloud). Discipline: boxing = demo.
Repo: ICOON-Studio/FightCamp, branch off master. Never Arena's "Merge PR" button; Claude merges.

## Why (the operator's clip, every seat agreed)
CLIPREVIEW1 (research/CLIPREVIEW1_FEEDBACK.md, verdict #1, all six seats): in exchanges the two boxers stand
0.557 m centre to centre, which is clinch distance, so their torsos merge on screen. Real ranges named by the seats: jab 1.0-1.5 m
(John: elite mean 1.23 +- 0.16 m, Schortgen ECSS 2023 via K50), hook/pocket 0.6-1.1 m (Ludo 0.85, John 0.75),
clinch < 0.65 m. Push-out must be a step, not a slide.

## Root cause (traced by Claude, S261 - confirm it red first)
- `Godot/scripts/FightSeparation.gd` (134 lines) `FLOOR_M`: reset 0.85, ENGAGE 0.55, clinch 0.28. `kind_for()` returns
  "engage" whenever EITHER man's phase is "engage" (FightBetweenExchanges.ENGAGE) - for EVERY punch, jab included.
- `Godot/scripts/FightRealtime.gd` (10,042 lines - NEVER read whole; use `sed -n` windows):
  - `_run_separation` line ~4921-4980: computes kind -> `Separation.floor_m` -> `Separation.resolve` -> `strip_inward`.
  - `_separation_floor_now` line ~5165 and `_block_step_at_floor` ~5180: the same floor gates every movement step.
  - `BOXING_OUTPUT_CLOSE_BIAS := 3.85` (line 114) and the close weight at ~4817/4823: boxing men want to CLOSE,
    so they sit ON the floor -> 0.55 m x arm scale = the 0.557 m measured.
  - `STRIKE_RANGE := 1.1` (line 600); `_strike_range_m` ~2105.
- So the engage floor is hook range for every punch. The fix is a floor PER PUNCH FAMILY in an exchange.

## Build
1. `FightSeparation.gd`: add kinds/floors for an exchange by the family of the punch in flight:
   - straight (jab, cross, any `*_jab*` / `*_cross*` / straight body shot): floor 0.95 m at REFERENCE_REACH_CM
   - hook / uppercut / overhand: floor 0.70 m
   - no punch identified while engaged: 0.85 (= reset)
   Keep clinch 0.28 and ground 0.0 untouched. Keep `kind_for(stance, phase_a, phase_b)` signature working (old callers);
   add `kind_for_family(stance, phase_a, phase_b, family_a, family_b)` - when both men throw, the SMALLER floor of the two wins
   (a hook inside a jab is legal). Pure, zero preloads, every figure passed in (header contract stays).
2. `FightRealtime.gd`: find where an engaged man's current move id lives (trace it from where phase becomes
   FightBetweenExchanges.ENGAGE; write the function name + line in the PR body). Map move id -> family with an existing helper
   in `FightMoves.gd` if there is one (grep first; do not add a second family table if one exists). Pass the families into
   `_run_separation` AND `_separation_floor_now` (both must read the same floor).
3. Push-out is a STEP: the existing `PUSH_CAP_MPS` 2.5 rate cap stays; do not raise it.
4. Behind switch `fight_gap` in `GameSwitches.GAME_ON` (read with `GameSwitches.on()` / the state flag the other fight switches use,
   follow how `separation_floor` reaches `state`). Switch OFF = byte-identical to master (plain `--script` tests = control arm).

## Test: `Godot/tests/fight_gap_test.gd` (NEW, extends SceneTree, prints `FIGHT_GAP failures=<n>`, quit(1) on failure)
- Two DIFFERENT boxers (different stats, reach 178 vs 186 cm, different plans) - never identical fighters; print both.
- 10 seeds x 3 rounds, boxing ruleset, `boxing_output` ON, switch `fight_gap` ON vs OFF (same seeds; control arm).
- Measure centre-to-centre gap on ticks where one man's straight punch is in flight, and on hook/uppercut ticks.
- PASS (bounded, never an exact value): ON straight-punch median >= 0.90 m and <= 1.40 m; ON hook median 0.62-1.00 m;
  ON exchange median greater than OFF exchange median by >= 0.20 m; clinch still happens (some ticks < 0.65 m allowed);
  landed punches ON >= 60% of OFF (spacing must not kill output); no tick with a root jump > 0.06 m (PUSH cap holds).
- It must FAIL on master (OFF median ~0.56). Paste the red line from master in the PR body.

## Contract
OWNS: Godot/scripts/FightSeparation.gd, Godot/scripts/FightRealtime.gd, Godot/scripts/GameSwitches.gd, Godot/tests/fight_gap_test.gd
RED_TEST: Godot/tests/fight_gap_test.gd -> FIGHT_GAP failures=0
REGRESSION: fight_separation_test,fight_separation_contract_test,boxing_output_test,fight_between_exchanges_test,fight_ring_position_test
VISUAL: yes - Claude takes game-camera stills (still_framing) after collecting; the agent does not.

## Run
- Parse: `python Godot/tools/check_scripts.py <each touched .gd>`
- `python Godot/tools/run_tests.py --jobs 2 --only fight_gap_test,fight_separation_test,fight_separation_contract_test,boxing_output_test,fight_between_exchanges_test,fight_ring_position_test`
- Same list with `--as-game`.
- PR body lines: `RESULT: tests/fight_gap_test.gd -> FIGHT_GAP failures=0` plus the ON/OFF medians printed by the test.

## Prior research
K50_SPACING_AND_REACH.md (1.23 +- 0.16 m, floor positions), G79_CLOSING_DISTANCE.md (the current floors and the 2.5 m/s cap),
OPINION_TELEPORTS_JOHN.md (engine owns the footprint, never a room push), CLIPREVIEW1_*.md (all six seat answers),
FightIntent.preferred_range comment (the 1.2 arm-length base is sourced - do NOT change it).

## What would a human do?
A coach would say: you jab from outside, step in for the hook, and you only touch chests in a clinch. That is three distances,
picked by the punch - exactly the floor per family above.

## Prefab check
No engine prefab applies (our own tick sim). Undisputed study (reference_undisputed_study) is timing only, not spacing.

## The one trap
Do NOT lower BOXING_OUTPUT_CLOSE_BIAS or move preferred_range to fake the gap - output/jab-share tests are calibrated on them.
The floor is the lever. And never delete or loosen a test to go green (CI log is read by Claude).

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
