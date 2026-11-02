# TASK SHOUTCAL1 - corner shouts pull their weight: a sharp corner wins 60-65% against a silent one

THIS IS THE TASK. Model: Arena (cloud). Discipline: BOXING (demo).

## Why
Operator Q-S249-3 "Build it" (corner shouts, Ludo r117, `research/CORNER_SHOUTS_VERDICT_S250.md` :62/:77 - accepted band
60-65% by a 100-bout batch). S255 Arena PR #264 (`tests/shout_balance_batch_test.gd`, branch `arena/af3d6bdf-fightcamp`) measured
`shouting_win_share 0.530` (control 0.500): the shouts barely move a fight, because only `accuracy_delta`, `evasion_delta` and
`opp_accuracy_delta` reach the engine. Every other r117 lever rides on the shout event as `intent_levers` and does nothing.

## The route the game runs (traced by Claude, master 82e26f37 or later)
- `Godot/scripts/FightRealtime.gd` (~10,000 lines - NEVER read whole; use `grep -n` + `sed -n` windows):
  - `shout(...)` builds the window at `grep -n 'result\["cs_window"\] = '` (~4229): today `{"duration_s", "acc", "eva", "opp_acc"}`
    from `cs_levers` / `cs_risk`; the rest go to `result["applied_effects"] = {"intent_levers": cs_levers}`.
  - `_process_shout_queue` (~4254) seats it: `fighter["_cs_window"] = cs_w` with `until_s`; `_expire...` (~4374) drops it.
  - The slip roll reads it (~6470): `acc`, `eva`, `opp_acc` on `fl_accuracy` / `fl_evasion`.
  - The throw gate (~5770): `if rng.randf() > throw_gate_base * Fatigue.output_multiplier(actor_fatigue) and not queued_throw ...`
  - The pick (~5858): `var selection_weights := {...}` passed to `Moves.select(...)`; `FightMoves.gd` `select()` reads
    `weights["roles"]` (role -> weight) and `weights["regions"]` (region -> weight) and `weights["jab_usage_mult"]`.
- `Godot/scripts/rules/CornerShouts.gd` (`SHOUTS` table, lever names: `jab_w straight_w hook_w upper_w head_bias distance_bias
  pace_mult guard clinch_urge accuracy_delta evasion_delta`; risks `opp_accuracy_delta opp_power_delta opp_damage_delta ...`).

## Files you own
1. EDIT `Godot/scripts/FightRealtime.gd` - ONLY these spots:
   a. the `cs_window` build (~4229): also carry `pace` (= `pace_mult`, default 1.0), `fam` (a dict of the four family weights
      `jab_w straight_w hook_w upper_w` that the shout names, else empty), `head` (`head_bias`, or -1 when absent), `opp_pow`
      (`opp_power_delta` + `opp_damage_delta`, default 0), each multiplied by `CornerShouts.LEVER_GAIN` where it is a delta
      (pace: `1 + (pace_mult - 1) * LEVER_GAIN`; deltas: `delta * LEVER_GAIN`); erase those keys from `cs_levers` so `intent_levers`
      lists only what is still not wired (`distance_bias`, `guard`, `clinch_urge` stay intent unless step e).
   b. the throw gate (~5770): the actor's live `_cs_window.pace` multiplies `throw_gate_base` (clamp the product <= 1.0).
   c. the pick (~5858): with a live `_cs_window.fam`, set `selection_weights["roles"]` so the four families take the shout's share -
      find the boxing role names the arsenal uses (`grep -n '"role"' Godot/assets/data/*.json | head`, and how `select()` maps
      roles); `head >= 0` sets `selection_weights["regions"]["head_neck"] = head` and the body regions share `1 - head`.
      Do NOT replace weights the engine already set for another reason - multiply into them.
   d. the damage of a blow ON a man whose `_cs_window.opp_pow` > 0: force x (1 + opp_pow) (find where `force` is final before
      `Impact.make_impact(seconds, region, force, contact)`, grep it).
   e. OPTIONAL, only if an existing knob takes < 15 lines: `distance_bias` onto the band/range preference the plan already uses.
   Every new read sits behind `state.has("corner_shouts")` (already seated by the switch) - OFF stays byte-identical, no new RNG draw.
2. EDIT `Godot/scripts/rules/CornerShouts.gd` - add `const LEVER_GAIN := 1.0` (with a comment) and tune ONLY that one const to
   calibrate. Do not change any shout's own numbers (they are Ludo's design; the gain scales them all together).
3. ADD `Godot/tests/shout_balance_batch_test.gd` exactly as on PR #264's branch (`git show origin/arena/af3d6bdf-fightcamp:Godot/tests/shout_balance_batch_test.gd`) -
   unchanged; it is the acceptance instrument.
4. NEW `Godot/tests/shout_levers_wire_test.gd` - RED FIRST on master: one bout pair (two DIFFERENT boxers), a shout seated by
   `RT.shout(...)`, then over its window: pace 1.25 raises the shouter's attempts vs the same seeds without the call; a jab_w 0.65
   call raises his jab share; head_bias 0.85 raises his head share; opp_power on HIGH_GUARD_WALKDOWN raises the force he takes.
   OFF arm (`corner_shouts` false): none of these move. Ends `print("SHOUT_LEVERS failures=%d" % failures)`.

## Acceptance (PR body lines)
- `RESULT: tests/shout_levers_wire_test.gd -> SHOUT_LEVERS failures=0` + its red-first lines on master.
- `RESULT: tests/shout_balance_batch_test.gd -> <its pass line>` with `shouting_win_share` inside 0.60-0.65 and the control arm
  0.40-0.60, and the final `LEVER_GAIN` value. CI runs the batch in ~9 min - iterate LEVER_GAIN on CI, one value per push.
- Also green: `tests/corner_shouts_wire_test.gd`, `tests/corner_shouts_test.gd`, `tests/fightlink_wire_test.gd`,
  `tests/counter_window_wire_test.gd`, `tests/game_switches_test.gd`.
- If 0.60-0.65 cannot be reached with LEVER_GAIN <= 3.0, STOP and report the curve (gain -> share) in the PR - do not touch shout
  numbers or other engine constants.

## Contract
OWNS: Godot/scripts/FightRealtime.gd, Godot/scripts/rules/CornerShouts.gd, Godot/tests/shout_balance_batch_test.gd, Godot/tests/shout_levers_wire_test.gd
RED_TEST: Godot/tests/shout_levers_wire_test.gd -> SHOUT_LEVERS failures=0
REGRESSION: corner_shouts_wire_test, corner_shouts_test, fightlink_wire_test, counter_window_wire_test, game_switches_test
VISUAL: no

## ROUND 2 (S258, Claude read the CI log of PR #268 for you - run 39170747194)
- The ONLY CI line: `[1/1] FAIL shout_levers_wire_test.gd hang (timeout)` at 600 s, `SUITE total=1 fails=1`. The test never
  finished, so no assertion result exists - the wall-clock "diagnostic" blocks decoded nothing. DELETE every TEMPORARY /
  MEASURE RUN / wall-clock block from the test.
- Cause: the cohort is far too big (SEED_COUNT 200 / SEED_TRIES 200 x three shouts x called + silent arm + OFF arm = thousands of
  bouts). The test must finish in <= 90 s on CI. Use ONE seed set of <= 40 bouts per arm and make the signal large instead of the
  sample: measure each lever on its OWN quantity over the window (attempt count, jab share, head share, force per landed blow)
  summed across the cohort, with the margins in the brief. If 40 bouts cannot separate a lever, call `RT.shout` with a longer
  window or earlier (CALL_AT_S 3.0) - never more seeds.
- Push to the SAME branch (`arena/747531d4-fightcamp`, PR #268). The PR body carries `RESULT:` lines from a CI run that finished.

## Parse gate
`python Godot/tools/check_scripts.py <every .gd you touched>`. Plain `--script` tests are the OFF control arm (as_game turns switches on).

## Prior research
`python Tools/prior_research.py corner shouts balance`: CORNER_SHOUTS_VERDICT_S250.md, LUDO_R117 (the levers), TASK_SHOUTBAL1.md
(the batch), S253 wiring (accuracy/evasion only).
## What would a human do?
A corner's call changes what the fighter DOES - throws more, doubles the jab, goes to the body - not only how well he slips. Make the
call move his output and his punch choice, then turn one dial until a good corner wins about 6 fights in 10.
## Prefab check
None - engine levers that already exist (throw gate, Moves.select weights, force).
