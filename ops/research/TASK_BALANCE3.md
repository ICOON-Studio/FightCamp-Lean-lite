# TASK_BALANCE3 - what-if sweep: round randomness and a gentler tiredness curve (Goose, FightCamp-Lean)
Status: DONE (S304, #6 aca8780)

Model: Goose (qwen3.7-plus via QWEN_API_KEY), cloud, repo ICOON-Studio/FightCamp-Lean branch main.
Discipline: boxing (demo).

## Why
BALANCE1/2 (scripts/rules/BalanceHarness.gd, merged) found two things: (1) a bout is almost fully decided by rating -
a 5-point edge wins ~100%, -5 wins ~0% (BoutRules.ROUND_SPREAD = 6: each side rolls +/- 3); (2) round 3 is not harder -
the r3 win share is >= r1 at every conditioning, because Combos.tired_penalty only bites below energy 20 and round 3
starts at 61-68. Claude will pick new numbers with the operator; this task produces the option table. It changes NO game
file - every what-if lives inside the harness.

## Owned files (edit only these)
- `scripts/rules/BalanceHarness.gd` (extend; must stay under 300 lines; no class_name). Never edit BoutRules.gd,
  Combos.gd, Bouts.gd.
- `tests/balance_harness_test.gd` (add tests 12-14; keep 1-11 exactly as they are).
- `tools/balance_report.gd` (add a third section).

## Spec
- Spread what-if WITHOUT editing BoutRules: play_round computes `(roll - 0.5) * ROUND_SPREAD`, so a roll rescaled to
  `0.5 + (roll - 0.5) * (spread / BoutRules.ROUND_SPREAD)` gives the same round at a wider spread (rolls may leave [0, 1];
  that is intended). Add an optional `spread: float = BoutRules.ROUND_SPREAD` to `live_bout` / `round_shares` (default =
  today's behaviour exactly - tests 1-11 must not move).
- Tiredness what-if: an optional `tired: String = "game"`. "game" = today. "ramp" = instead of Combos.tired_penalty, the
  penalty for a side is `max(0, (FRESH - energy_end) / FRESH) * RAMP_MAX` with FRESH = Combos.FRESH_AT and RAMP_MAX
  a parameter (default 2.0 power points), applied the same way Bouts._energy applies tired_penalty (hers subtracts from
  her bonus, the opponent's adds). Compute it from e.a_end / e.b_end that Bouts._energy already returns: bonus_ramp =
  e.bonus + Combos.tired_penalty(a_end) - Combos.tired_penalty(b_end) - ramp(a_end) + ramp(b_end).
- `sweep(seed: int, n: int = 400) -> Array`: rows for spread 6 / 10 / 14 / 18 x tired game / ramp x conditioning 50 / 80
  x rating edge buckets. Edge buckets: build fighters with make_fighter(avg, ...) for avg 55 / 60 / 65 / 70 against
  Data.OPPONENTS[0] (and say each row's measured edge). Each row: {spread, tired, cond, avg, edge, r1, r3, bout}.

## Tests (bounds, n >= 400)
12. Default arguments reproduce BALANCE2 exactly: round_shares(f, corners, 400, s) == round_shares(f, corners, 400, s,
    BoutRules.ROUND_SPREAD, "game") for one fighter.
13. Wider spread pulls a strong favourite down: at avg 70 vs opponent 0, bout share at spread 18 < at spread 6.
14. Ramp makes round 3 harder for the unfit: at conditioning 50, spread 6, (r1 - r3) with "ramp" > (r1 - r3) with "game".

## Report (third section of tools/balance_report.gd)
The sweep as a table, one row per line; paste it whole into the final report.

## Commands
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tests/balance_harness_test.gd`
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/balance_report.gd`
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` (all PASS)

## Prior research
BALANCE1/2 tables (PR #2, #4 bodies). Energy numbers: old repo J_COMBOENERGY1 (bells 69/48/31). Upset targets are being
researched separately (John J-UPSETS1) - this task does not pick a target, it measures options.

## What would a human do?
A balance designer sweeps the one or two knobs that matter over a range and lays the outcomes side by side, so the
decision is a read of a table, not a guess.

## Prefab check
None: our own pure harness, plain GDScript.

## The one trap
Defaults must leave tests 1-11 byte-for-byte unchanged in behaviour - add parameters at the END with defaults. Typed vars
on Variant calls.

## Report
End with `RESULT: tests/balance_harness_test.gd -> BALANCE failures=0` and the sweep table.
