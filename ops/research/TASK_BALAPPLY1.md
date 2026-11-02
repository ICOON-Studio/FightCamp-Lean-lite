# TASK_BALAPPLY1 - apply the approved balance: round randomness 27 + a tiredness ramp (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo).
APPROVED: operator answered Q-S294-8 "Yes, both" (S305 chat, 2026-10-29) - apply BOTH parts.

## Why
BALANCE1-3 (scripts/rules/BalanceHarness.gd) measured: a 5-point rating edge wins ~100% (BoutRules.ROUND_SPREAD 6), and
round 3 is not harder (Combos.tired_penalty only bites under energy 20; round 3 starts at 61-68). John J-UPSETS1
(Game repo research/J_UPSETS1_JOHN.md): pro favourites win 86% of decided fights; target for our 3-round amateur
bout ~60% at a slight edge, ~75% clear, ~88% big, never above ~95%. Claude measured spread 27 with tools/balance_targets.gd
(Lean b1809db): edge +3 -> 66%, +5 -> 78%, +8 -> 86%, +13 -> 95%, -5 -> 27%.

## Owned files (edit only these)
- `scripts/rules/BoutRules.gd`: `ROUND_SPREAD := 6.0` -> `27.0` (comment: S305 J-UPSETS1).
- `scripts/rules/Combos.gd`: `tired_penalty(energy)` becomes the ramp `maxf(0.0, (FRESH_AT - energy) / FRESH_AT) * TIRED_MAX`
  with a new `const TIRED_MAX := 6.0` (power points when empty). Keep the function name and signature (Bouts._energy calls it).
- `scripts/rules/RoundScript.gd`: the margin bands scale with the spread so the close/clear/dominant mix stays as today:
  `CLOSE_DIFF = 0.25 * BoutRules.ROUND_SPREAD`, `DOMINANT_DIFF = 0.667 * BoutRules.ROUND_SPREAD` (today 1.5 / 4.0 at 6).
  RoundScript must not preload BoutRules if that makes a cycle - then write the two numbers as consts with the comment.
- `scripts/rules/BalanceHarness.gd`: nothing to change except where a default assumed 6.
- `tests/balance_harness_test.gd`: add tests (below). Existing tests that assert the OLD numbers (a 100% at +5, the cliff
  under 20): update ONLY the asserted number, list every such edit in the PR body with old -> new. Never delete a test.
- `tests/combos_test.gd`, `tests/round_script_test.gd`, `tests/bout_rules_test.gd`: same rule as above.

## New acceptance tests (tests/balance_harness_test.gd, 800 bouts a row, steady opponent OPPONENTS[1], cond 80)
1. Edge ~+3 (make_fighter avg 61): bout share 0.58-0.74. Edge ~+5 (avg 64): 0.70-0.86. Edge ~+13 (avg 73): <= 0.98.
   Edge ~-5 (avg 52): 0.18-0.36.
2. Unfit (cond 50, avg 60) vs steady: r3 share at least 0.08 below r1. Fit (cond 80): r3 no more than 0.05 below r1.
3. Margins at spread 27, even fighters (avg 58): close 0.35-0.55, dominant 0.05-0.20 of rounds (RoundScript.margin).

## Commands
`godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` for balance_harness_test, combos_test,
round_script_test, bout_rules_test, fight_words_contract_test, golden_path_test, knockdowns_test, bout_stoppage_test.
All must end with 0 failures. CI runs tools/run_tests.sh on the PR.

## Contract
OWNS: scripts/rules/BoutRules.gd, scripts/rules/Combos.gd, scripts/rules/RoundScript.gd, scripts/rules/BalanceHarness.gd, tests/balance_harness_test.gd, tests/combos_test.gd, tests/round_script_test.gd, tests/bout_rules_test.gd
RED_TEST: tests/balance_harness_test.gd -> BALANCE failures=0
REGRESSION (Lean tests; the Game-repo checker cannot see them): golden_path_test, fight_words_contract_test, knockdowns_test, bout_stoppage_test
VISUAL: no (Claude re-films round 3 after the merge)

## Prior research
BALANCE_S304.md (the option table the operator approves), J_UPSETS1_JOHN.md (real favourite win rates), Lean
tools/balance_options.gd + tools/balance_targets.gd (measured spreads 6/14/20/27, ramps 4/6).

## What would a human do?
A sports-game balance designer sets the outcome curve from real betting data (favourite win share by odds band), tunes one
randomness knob until the simulated curve sits on it, and checks that the knob did not flatten everything else (margins,
stoppages, the career path).

## Prefab check
None needed: two constants and one curve in our own rule modules.

## The one trap
golden_path_test plays a career with seeded bouts; more randomness can flip a seeded result. Keep the golden path green by
choosing a seed or fighter that still wins - NEVER by loosening its checks or lowering ROUND_SPREAD. Say in the PR which
seed changed and why. GDScript: `var x := <Variant call>` is a parse error - type it.

## Report
PR body: `RESULT: tests/balance_harness_test.gd -> BALANCE failures=0` and the new shares table (edge, bout, r1, r3).
