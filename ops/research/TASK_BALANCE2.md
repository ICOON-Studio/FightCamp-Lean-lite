# TASK_BALANCE2 - is round 3 harder? Round-by-round win share through the game's real round (Goose, FightCamp-Lean)
Status: DONE (S304)

Model: Goose (qwen3.7-plus via QWEN_API_KEY), cloud, repo ICOON-Studio/FightCamp-Lean branch main.
Discipline: boxing (demo).

## Goal
The operator asked of update 5: "is round 3 harder?" BALANCE1 (scripts/rules/BalanceHarness.gd, merged) measures the bare
BoutRules round. The game's real round (scripts/state/Bouts.gd `_round`, lines 268-280) adds two power bonuses:
`BoutRules.weapons_edge(BoutRules.weapons(f.moves))` and the energy bonus from `Bouts._energy(f, n, corner)` (lines
288-307: both tanks across the bout, Combos.after_round, Combos.edge, Combos.tired_penalty). Measure win share PER ROUND
through that real path, by her conditioning.

## Owned files (edit only these)
- `scripts/rules/BalanceHarness.gd` (extend; stays under 250 lines, still no class_name). It may preload
  `res://scripts/state/Bouts.gd`, `res://scripts/rules/RoundStyle.gd`, `res://scripts/rules/Combos.gd`,
  `res://scripts/state/Data.gd` - read them first. Never edit them.
- `tests/balance_harness_test.gd` (add tests 8-11; keep 1-7 exactly as they are).
- `tools/balance_report.gd` (add a second table).

## Spec
- `live_bout(f: Dictionary, corners: Array, rng: RandomNumberGenerator) -> Dictionary`: plays BoutRules.ROUNDS rounds the
  way Bouts._round does - for round n: `e = Bouts._energy(f, n, corner)` (call it; f is a plain fighter dict with keys
  stats, combos, moves, camp, bout = {"opp": <Data.OPPONENTS entry>, "film": 1}), then BoutRules.play_round with
  weapons_bonus = weapons_edge(weapons(f.moves)) + e.bonus and rolls from rng. corners[0] is "" (round 1), corners[1..]
  the calls. Returns {verdict, rounds: [{n, won, a, a_end, b, b_end, bonus}]}. Duplicate f per bout (f.bout.energy is
  written by _energy).
- `round_shares(f: Dictionary, corners: Array, n: int, seed: int) -> Dictionary` = {"r1": share, "r2": .., "r3": ..,
  "bout": share, "bell3_energy": mean a at the start of round 3}.
- `make_fighter(avg: int, conditioning: float, combos: Dictionary, opp_index: int) -> Dictionary` builds f from
  make_stats(avg, 0) with that conditioning, camp {"protocol": 2, "focus": "conditioning"}, moves from Data (every move
  at mastery 30 = no weapons edge beyond the base, check BASE_WEAPONS) and bout.opp = Data.OPPONENTS[opp_index].

## Tests (bounds, never exact counts; n >= 400; fighters never identical - vary avg or combos too)
8. Parity: for one fighter and n = 2, live_bout's round-2 bonus equals Bouts._energy(f2, 2, corner).bonus +
   weapons_edge for an independently built copy f2 played the same way (proves the harness runs the game's path).
9. Tiredness shows: conditioning 50 -> r3 share is at least 0.05 below its r1 share (same opponent, corner "body" in 2 and 3).
10. Conditioning protects: the r1 -> r3 drop at conditioning 80 is smaller than at conditioning 50.
11. bell3_energy at conditioning 50 < at conditioning 80.
If 9 or 10 FAILS on the real code, DO NOT change thresholds or the game: keep the test, mark it in the report as a
FINDING with the measured numbers - that is the answer Claude needs. (Then the test may be committed with the check
printing "FINDING" instead of "FAIL" for 9/10 only, and the report says so plainly.)

## Report table (tools/balance_report.gd, second section)
Rows: conditioning 50/65/80 x combos {none, Data's first two combos at mastery 60} x opponents 0..2 -> r1 r2 r3 bout
bell3_energy. Paste it whole into the final report.

## Commands
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tests/balance_harness_test.gd`
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/balance_report.gd`
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` (all PASS)

## Prior research
searched: round 3 harder tired energy (BALANCE1 report; research/J_COMBOENERGY1 in the old repo set the energy
numbers: bells 69/48/31). This task measures the game, it does not re-research energy.

## What would a human do?
A designer answering "is the last round harder?" plays thousands of seeded bouts through the shipped round code and
reads the round-by-round win share per conditioning band before touching a number.

## Prefab check
None needed: an extension of our own pure harness (plain GDScript, RandomNumberGenerator).

## The one trap
Bouts._energy writes f["bout"]["energy"] - a fighter dict reused across bouts carries the last bout's tank: duplicate(true)
per bout. Typed vars on Variant calls (`var b: float = ...`).

## Report
End with `RESULT: tests/balance_harness_test.gd -> BALANCE failures=0` and both report tables.
