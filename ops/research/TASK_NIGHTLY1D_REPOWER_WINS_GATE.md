# TASK NIGHTLY1D - make the AI-corner wins gate a real statistical gate (it flips on noise today)

Model: Arena (one test file, headless, no LFS models). Branch: your own arena/* branch, open a PR to ICOON-Studio/FightCamp master.
Tier: a test file edited -> parse gate + that test.

## The problem
`Godot/tests/fight_plan_ai_corner_test.gd` (340 lines), TEST 5 (`_test_ai_corner`, lines 249-296, and the pooled gate in `_initialize`,
lines 318-333) checks that a great tactician's plan (tactical 90) beats the same man planned by a poor one (tactical 30), over 40 seeds
both ways round (80 pairs). The landed-differential gate is a proper paired 95% CI. The WINS gate is not: it is
`_ai_wins_great >= _ai_wins_poor`, a point comparison of two counts whose 95% intervals overlap (last nightly: 41 vs 44 of 80 - red;
the run before: green). It turns red or green on any engine change that reshuffles the dice. That is noise, not a verdict.

## Prior research
- The test header (lines 1-35) and S102 note at line 290: G137 sizes the plan edge at +/-0.03 (`PLAN_FIT_EDGE_MAX`), a real but small edge.
- The landed CI gate already uses the paired design (same seed, both arms): keep it exactly as it is.

## What would a human do?
A statistician gates a paired win comparison with the DISCORDANT pairs (McNemar's logic): over the same seeds, count
`gw` = pairs where the great arm won and the poor arm did not, and `pw` = pairs where the poor arm won and the great arm did not.
Concordant pairs (both won / both lost) carry no information about the coach. The claim "the better coach wins no less often" FAILS
only when the poor coach wins significantly more often: one-sided exact binomial (sign) test on `pw` out of `gw + pw` at p=0.5,
red when P(X >= pw) < 0.05. This is the honest version of "win share no lower" - it is NOT looser for a real regression (a coach
that is genuinely worse goes red), it only stops treating a 41-44 coin flip as a verdict.

## Prefab check
No library: GDScript has none. The exact binomial tail for n <= 80 is a 10-line loop (sum of C(n,k)/2^n, computed with logs or by
an incremental product in float - n is small).

## Owned files
`Godot/tests/fight_plan_ai_corner_test.gd` only.
1. In `_test_ai_corner`, per seed, record the discordant outcome (great won & poor did not -> gw += 1; poor won & great did not -> pw += 1),
   accumulate pooled `_ai_disc_great`, `_ai_disc_poor`. Keep printing the raw wins and Wilson intervals as today.
2. New pure function `_sign_test_upper(k: int, n: int) -> float` = P(X >= k) for X ~ Binomial(n, 0.5); n = 0 -> 1.0.
3. Replace the pooled wins check with: `_check(_sign_test_upper(_ai_disc_poor, _ai_disc_great + _ai_disc_poor) >= 0.05, ...)` and print
   `TEST 5 pooled discordant: great-only %d, poor-only %d, one-sided p=%.3f`.
4. SELF-CHECK the gate can read worse (put it at the start of `_initialize`, before the fights, so a broken gate fails fast):
   - `_sign_test_upper(0, 0) == 1.0`; `_sign_test_upper(10, 10)` ~ 0.000977 (1/1024, within 1e-6);
   - `_sign_test_upper(15, 20)` < 0.05 (0.0207) -> a 5-vs-15 discordant split is RED;
   - `_sign_test_upper(22, 40)` > 0.05 (0.3179) -> a 18-vs-22 split is GREEN.
   Each a `_check` with a clear message. These are the gate's mutants: they prove the same code turns red on a real gap.
5. Update the header comment for TEST 5 (lines 21-26) to say the wins gate is the paired sign test on discordant pairs, and why.
Do NOT change seeds, CENSUS_SEEDS, the fighters, the landed CI gate, tests 4 or the hash test. Do NOT delete or skip any check.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_plan_ai_corner_test.gd` ->
`FIGHT_PLAN_AI_CORNER_TEST PASS` (or, if the landed CI gate itself is red on master, that is a separate failure: say so in the PR with
the printed numbers - never touch the landed gate). The self-check lines print and pass. Paste the TEST 5 output lines in the PR.
Parse gate: `python Godot/tools/check_scripts.py tests/fight_plan_ai_corner_test.gd`.

## The one trap
The test runs close to the runner's 600 s timeout: add NO fights. The sign test reads the outcomes already computed.
Everything you push is public: no secrets. Never press the PR's Merge button - Claude reviews and merges.
