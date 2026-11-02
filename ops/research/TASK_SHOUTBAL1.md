# TASK SHOUTBAL1 - the corner-shout balance batch: does a sharp corner win 60-65% against a silent one? (boxing, measurement test)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the one new test file below, touch nothing else.

## Why
Corner shouts went live S253 (operator Q-S249-3 "Build it"; `FightRealtime.shout` / `_corner_shout`, FightRealtime.gd:4120-4230).
The verdict (research/CORNER_SHOUTS_VERDICT_S250.md:62, :77) accepts a corner that calls Sharp/Drilled shouts on the right reads
winning about 62.5% (accepted band 60-65%) against a silent corner, checked by a 100-bout batch. Nobody has run it.
OPERATOR RULE that overrides the verdict's "two identical fighters": NEVER TEST IDENTICAL FIGHTERS - every pair differs in stats, plan,
frame and stance, and each pair fights TWICE with the shouting corner swapped, so the fighter difference cancels out and only the
corner remains.

## File you create (only this)
`Godot/tests/shout_balance_batch_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
`print("SHOUT_BALANCE failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## How (copy the fixture style of `Godot/tests/corner_shouts_wire_test.gd`, lines 37-70 - read it first)
- Build 5 DIFFERENT legal male 72 kg boxers in the test (out-boxer, pressure, counter-puncher, brawler, switch-hitter), each with its
  own `stats` (technique/power/speed/defense/conditioning/fight_iq/chin/aggression), `fight_plan` (boxing_* plans that exist in
  `assets/data/` - grep), height/reach and stance. Pairs = the 10 unordered pairs; each pair x 5 seeds x 2 (shouting corner on side a,
  then on side b) = 100 bouts.
- Options: `{"seed", "rounds": 3, "ruleset": <boxing from combat_rulesets.json>}` merged with `RT.DEMO_SWITCHES`, `corner_shouts` true.
- The SHOUTING corner's fighter carries `shout_mastery` = 70 (Sharp) for every id in `CornerShouts.SHOUTS` (half the bouts) or 90
  (Drilled-in, the other half) and `coach_trust` 70; the SILENT corner never calls. Policy: every `CornerShouts.cooldown_s(...)` seconds
  of fight time, build the read window from the bout log of the last `CornerShouts.READ_WINDOW_S` seconds the way the game's live-read
  ticker does if one exists (grep `CornerShouts.reads(`); if no game summary exists, call the shout for the opponent's fight_plan:
  pressure/brawler -> BOX_AND_MOVE, out-boxer -> HIGH_GUARD_WALKDOWN, counter-puncher -> DOUBLE_THE_JAB, switch-hitter ->
  STAY_BEHIND_JAB (say which route you used in the PR body). Respect `RT.shout`'s own refusals (cooldown, per-round cap).
- Win = the bout's winner field (read `run_to_completion` / the end state - grep how `corner_shouts_wire_test` `_finish` reads it); a
  draw counts half.

## Output + gate (bound values, never an exact count)
- Print the population first: `SHOUT_BALANCE population=5 boxers x 10 pairs x 5 seeds x 2 sides = 100 bouts, catalogue=<plans used>`.
- Print `SHOUT_BALANCE shouting_win_share=<x.xxx> sharp=<x.xxx> drilled=<x.xxx> draws=<n> shouts_called=<n> clean=<n> blunders=<n>`.
- OK when 0.55 <= shouting_win_share <= 0.72 (wider than the verdict's 60-65% so noise on 100 bouts does not flake; the PRINTED number is
  what Claude reads against 60-65%); OK when drilled >= sharp - 0.05; OK when shouts_called > 0 in every bout of a shouting corner.
- Control arm: the same 100 bouts with `corner_shouts` false on both -> win share of "side that would have shouted" within 0.40..0.60
  (proves the swap cancels the fighters). Print it.
- Print the wall time of the batch. If 200 bouts take more than 8 minutes on CI, drop to 3 seeds and say so.

## Prior research
CORNER_SHOUTS_VERDICT_S250.md (balance target), IDEA_CORNER_SHOUTS_LEARNED_S249.md, TASK_SHOUTS1.md (the module), corner_shouts_wire_test.gd
(how a bout with shouts is started and a shout is called).

## What would a human do?
A good cornerman is worth something but not everything: commentators say a great corner swings a close fight, not a mismatch.

## Prefab check
No prefab - a measurement over our own engine.

## The one trap
Do not tune any engine or CornerShouts number to land in the band - report the number; Claude recalibrates.

## Contract
OWNS: Godot/tests/shout_balance_batch_test.gd
RED_TEST: Godot/tests/shout_balance_batch_test.gd -> SHOUT_BALANCE failures=0
REGRESSION: shout_balance_batch_test
VISUAL: no
