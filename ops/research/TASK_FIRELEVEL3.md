# TASK FIRELEVEL3 - CLAUDE (fight code) - switch move levels on in the game, with a first-season re-measure

Status: OPEN (roadmap row FIRELEVEL3; briefed S448 against PROGRESSION_MAP_S448 v4.1, owner Q-S294-211 "Yes, go ahead").
Discipline: boxing. Owner: Claude (fight code is Claude's per CORE_LOOP_MAP section 5).
Why: without it a Sharp or Signature move fights the same as a Usable one, so the whole progression plan (held moves, styles,
Signatures) is invisible on fight night (map M9). Measured S442 (FIRELEVEL2_ADAPT1_RESULT_S442.md, 400 paired bouts a cell): shares
0.5 / 0.75 / 1.0 cost a Usable line 4.5 wins in 100 and Signature gives +1.3 against today; the verdict then: switch on WITH a
first-season re-measure, not alone. v4.1 CHECK: the map keeps steps and defences at full fire (FireLevel.mastery_of returns 100) until
STEPMASTERY1; this task must not change that.

## Contract
OWNS: scripts/rules/FireLevel.gd, tests/fire_level_test.gd, tools/fire_level_probe.gd, docs/FIRELEVEL3_RESULT.md
RED_TEST: tests/fire_level_test.gd -> FIRE_LEVEL failures=0
REGRESSION: plan_fight_test, combos_test, golden_path_test, balance_harness_test, first_week_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: the bout's read of the key (scripts/state/LiveRound.gd:261) stays as it is.

## What to do
1. FireLevel.gd: `GAME_SHARES := {"usable": 0.5, "sharp": 0.75, "signature": 1.0}` and `shares_for(bout: Dictionary) -> Dictionary`:
   bout["fire_level"] when the key is present, GAME_SHARES when it is absent. The rule-off control arm of every probe sets the key
   explicitly to {"usable": 1.0, "sharp": 1.0, "signature": 1.0} (today's game). `share()` itself is unchanged (an empty dict still
   means 1.0). Steps and defences keep 100 (mastery_of).
2. LiveRound.gd:261 reads `f["bout"].get("fire_level", {})`: it must read `FireLevel.shares_for(f["bout"])` instead. That is a one-line
   edit outside OWNS: add `scripts/state/LiveRound.gd:259-263` to OWNS before starting and say so in the PR. Existing probes that pass
   no key (tools/fire_level_probe.gd arm "off") get the explicit all-1.0 dict.
3. tests/fire_level_test.gd: red first: `shares_for({})` (no key) gives a share of 0.5 for a combination at mastery 40 (today 1.0); the
   explicit all-1.0 dict gives 1.0; a step stays 1.0 at any shares.
4. FIRST-SEASON RE-MEASURE: tools/fire_level_probe.gd gains a `season=1` mode run through tools/career_harness.gd's route (26 weeks, the
   four quick-start fighters and 20 walk-ins, seeds 4421-4423), rule off against on. docs/FIRELEVEL3_RESULT.md: first-season win rate,
   the gym-closes rate (career_harness bounds: careless 5-25%, sensible 0%) and bouts won per fighter, off vs on. PASS: sensible still
   closes 0%, the win-rate drop for a new fighter's first season under 5 in 100. If it fails, the shares go back to 0.6 / 0.8 / 1.0 and
   re-run once before anything ships.

## Prior research
- ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md, ops/research/TASK_FIRELEVEL1.md, CORE_LOOP_MAP_S432 section 5 (Playbook group: FireLevel
  on in GAME_ON), PROGRESSION_MAP_S448 M9.

## What would a human do?
A coach knows a punch you have only half drilled comes off some nights and not others; a sharp one comes off most nights; a signature
always. The game should agree before the player is asked to pay pad time for it.

## Prefab check
None: the rule is built (FireLevel.gd); this task switches it on and re-measures.

Test command: `python ops/Tools/godot_slot.py run --who FIRELEVEL3 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/fire_level_test.gd`
