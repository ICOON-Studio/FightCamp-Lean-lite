# NIGHTREDS1 RESULT - which commit turned plan_templates and matchmaking_bots red (measurement, no fix)

Run 2026-11-23 in a seeded worktree (E:/FightCamp/wt/NIGHTREDS1), headless, Dummy audio, --fixed-fps 60, through godot_slot, one run at a time. No number or threshold touched.

RESULT: ops/research/NIGHTREDS1_RESULT.md -> plan_templates first red: 3a3cb3a08; matchmaking_bots first red: 68067e0ba

## 1. plan_templates_test (t_turn vs Maria, 40 bouts as the test runs them)
| commit | what | turn won (edge) | starter plan won (edge) | t_turn |
|---|---|---|---|---|
| 4088bfc83 | last green nightly | 0.441 (+0.50) | 0.434 (+0.31) | PASS |
| 535cf1e27 | dmgfix tip | 0.441 (+0.50) | 0.434 (+0.31) | PASS |
| 68067e0ba, ac38fa588, 66e89d97b, 6095ff2c5 | DMGCLASS2 + 65 kg | not printed here, 0 failures | | PASS |
| c1b5ead25 | main just before STEPPAY3 | 0.441 (+0.50) | 0.434 (+0.31) | PASS |
| **3a3cb3a08** | STEPPAY3 first commit | 0.433 (+0.19) | 0.440 (+0.24) | **FAIL** |
| da4af6772 | STEPPAY3 second | 0.438 (+0.23) | 0.445 (+0.25) | FAIL |
| 8625bd763 / e93158da7 / 741af4952 / fe72931fd | later | 0.438 (+0.23) | 0.445 (+0.25) | FAIL |
MOODREAD1 (fe72931fd) and the pro weigh-in miss change nothing (same numbers as da4af6772).

Cause: 3a3cb3a08 (S537 STEPPAY3). StepMoment now deals the five step moments (short / landed / flurry / smother / drift) into
every bout through LiveRound, and PlanFight.ANSWERS grades them. The starter plan is a plain habit plan: the new moments pay
it (0.434 -> 0.445) while the turn template (its answers are step_back / pivot_out / roll_out) gains nothing (0.441 -> 0.438).
roll_out was also added to the "wrong" list of tiring / hurt / hurt_danger. Reading: the change doing what it meant (steps
now matter in the sim), and the test's bar (turn beats starter) no longer holds. A DESIGN result for the main session: either
the t_turn template needs the new moments' answers, or the bar is stale. Not a bug in a line.

## 2. matchmaking_bots_test (median place / stopped, 120 careers per bot)
| bot | 4088bfc83 (green) | 1874ec739 (DMGCLASS2 parent, green) | **68067e0ba (DMGCLASS2)** |
|---|---|---|---|
| easy | 19.0 / 0.55 | (green, 0 failures) | 18.5 / 0.50 |
| hard | 14.0 / 1.36 | | 13.5 / 1.27 |
| smart | 12.0 / 0.83 | | 13.0 / 0.91 |
| blind | 14.0 / 0.98 | | 12.0 / 0.77 |
Checks: green = smart beats hard by +2.0, scouting -0.15 stoppages; at 68067e0ba smart beats hard by +0.5 (FAIL) and scouting
+0.14 stoppages (FAIL). These are the nightly's exact numbers, so DMGCLASS2 alone explains the nightly red.
Runs at 1874ec739 are from the 4088bfc83-era print (green, failures=0; the printed table of that run was the same file format
as 4088bfc83 and was read as 0 failures). The runs at 8625bd763 and fe72931fd did not finish (see below), not needed: the first red is already found.

Cause: 68067e0ba (S535 DMGCLASS2). WorldBout.gd passes `rounds >= PRO_FROM` (4) to Knockdowns.round_counts, so a pro world bout
loses the four-count bout limit (Knockdowns: `total_counts >= COUNTS_BOUT_STOP` now only when not pro_rules). The commit also
prices a corner retirement (RTD) as an ordinary loss (BoutFinish `beaten`). Pro-bout stoppages rise for every bot; the bots
that take punishment (smart, hard) shift, and scouting no longer lowers stoppage losses (smart 0.91 vs blind 0.77) with 120
careers of noise (blind's median moved 14 -> 12 too). The commit message says "tests pending". Reading: the change doing what
it meant (a design result; the test's bars were set for the old rule). Not a line bug in the rule; the bars or the bots' taste
need the main session. Caveat: 120 careers per bot is noisy (blind moved +/-2 places), so the exact failing checks sit near the bar.

## Run notes
- matchmaking_bots runs 4088bfc83, 1874ec739, 68067e0ba completed. The loop was then killed by the low-memory reaper during the
  8625bd763 run; I stopped that leftover Godot (PID 231072, my own, by PID) and did not restart it. The fe72931fd matchmaking run was not done.
- Raw outputs: E:/FightCamp/tmp/NIGHTREDS1_*.txt.
