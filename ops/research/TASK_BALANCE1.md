# TASK_BALANCE1 - balancing harness for the Lean bout (Goose, FightCamp-Lean)
Status: DONE (S304, Lean #2 be1ed2b)

Model: Goose (qwen3.7-plus via QWEN_API_KEY), cloud, repo ICOON-Studio/FightCamp-Lean branch main.
Discipline: boxing (demo).

## Goal
Answer with numbers: does training, the camp, the film study and the opponent's rating change WHO WINS a Lean amateur bout,
and by how much? Claude needs this table before FIGHT_MODEL step 6 (a film of two differently trained boxers) and before
the operator's "is round 3 harder?" verdict.

## Owned files (create; touch nothing else except the one line in tools/run_tests.sh)
- `scripts/rules/BalanceHarness.gd` (new, pure static functions, extends RefCounted, no class_name, under 250 lines).
  Loads `res://scripts/rules/BoutRules.gd` with preload. Never edits BoutRules.gd.
- `tests/balance_harness_test.gd` (new, extends SceneTree, same shape as tests/combos_test.gd: `_check(cond, label)` prints
  `PASS <label>` / `FAIL <label>`, last line `BALANCE failures=<n>`, quit(1) on any failure).
- `tools/balance_report.gd` (new, extends SceneTree): prints the grid below as plain text lines and quits 0.
- `tools/run_tests.sh`: add `balance_harness_test` to the test list (one word, before `golden_path_test`).

## Spec (read scripts/rules/BoutRules.gd first: fight_power, play_round, scorecards, verdict, auto_corner)
- `bout(stats: Dictionary, camp: Dictionary, film_depth: int, opp: Dictionary, rng: RandomNumberGenerator,
  corner_mode: String = "auto", weapons_bonus: float = 0.0) -> Dictionary` plays BoutRules.ROUNDS rounds with
  BoutRules.play_round (round 1 corner "", later rounds the corner: "auto" = BoutRules.auto_corner(stats), else the given
  key), rolls from `rng.randf()`, then scorecards + verdict. Returns {verdict, rounds_won, rounds: Array}.
- `win_share(stats, camp, film_depth, opp, n: int, seed: int, corner_mode := "auto") -> float` = wins / n with one
  RandomNumberGenerator seeded once.
- `edge(stats, camp, film_depth, opp, corner_mode := "auto") -> float` = BoutRules.fight_power(stats, camp, film_depth,
  corner) - opp.rating for the round-2 corner (the expected per-round margin).
- `grid(seed: int, n: int = 400) -> Array` of rows {avg, protocol, film_depth, opp_rating, edge, win_share} for
  stat averages 55/60/65/70 x protocol 0..3 (camp focus "conditioning") x film depth 1/3 x opponent rating 58/62/66.
  Build each fighter from a profile with that average but UNEVEN stats (e.g. power-leaning: power +6, defense -6) so no two
  fighters in a comparison are identical (project rule).

## Test (tests/balance_harness_test.gd) - bounds, never exact counts
1. Same seed twice -> same win_share (determinism tripwire; the only place a seed is reused).
2. Stats: vs opp rating 62, win share at avg 70 > avg 60 > avg 55 (two different profiles per average).
3. Camp: at matched stats, Hard (3) > Standard (2) > None (0) win share.
4. Film: depth 3 > depth 1.
5. Bounds from the round model (each side rolls +/- ROUND_SPREAD/2): |edge| < 0.5 -> win share in 0.40..0.60;
   edge >= +4 -> >= 0.95; edge <= -4 -> <= 0.05 (n >= 400).
6. A 3-round bout never ends "draw" (verdict over 3 rounds) - count draws over 400 bouts == 0.
7. grid() returns 4*4*2*3 = 96 rows, every win_share in [0, 1].
Prove the test can fail: temporarily flip one comparison in your head (e.g. Hard < None) - it must print FAIL. Do not
commit a mutant.

## Commands
- One test: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tests/balance_harness_test.gd`
- Report: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/balance_report.gd` - paste its full
  output into your final report.
- All: `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` (all PASS).

## Prior research
searched: balance harness win share bout (Tools/prior_research.py) - nothing on the Lean bout. The old repo's SHOUTCAL1
measured a 0.530 win share against a 0.60-0.65 bar for the stronger side in its own (different) engine; not reused.

## What would a human do?
A sports-game balance designer runs thousands of seeded sims per matchup and reads win-share tables by edge bucket before
touching a number (the same way bookmakers read favourite win rates): first measure, then tune.

## Prefab check
GUT / gdUnit4 are test frameworks, not a balance harness; no Asset Library balancing addon fits a pure static module.
Plain GDScript with RandomNumberGenerator, as the existing tests do.

## The one trap
`var x := <call>` on a Variant-returning call is a parse error - type it (`var w: float = ...`). Never change BoutRules.gd
numbers: this task MEASURES, Claude tunes.

## Report
End with `RESULT: tests/balance_harness_test.gd -> BALANCE failures=0` and the balance_report output.
