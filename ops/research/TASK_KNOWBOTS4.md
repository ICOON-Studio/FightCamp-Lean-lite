# TASK KNOWBOTS4 - Knowledge v3 probes K1, K3, K4 on the v3 rules and prices, three seed sets (probe, no screen)

Status: OPEN (S524, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Mechanic: PROGRESSIVE KNOWLEDGE v3 (approved, Q-S294-228). Design: `ops/research/DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md`
sections 3-8, 10 and 14. Build order step 1 says: re-run K1, K3, K4 on the new prices; STOP if K1 fails on any set.

## Why (Claude's S524 rerun of tools/knowbots_probe.gd on main, the KNOWBOTS3 probe, seeds 7000-7059)
ORACLE 94, BLIND 90, READER 86, BAD 42 -> instrument VOID (ORACLE - BLIND +4, needs +8). On the SAME seeds in S463 it read
ORACLE 101, BLIND 87 (+14, PASS). ORACLE never reads Knowledge (it signs the highest TRUE rating), so the drop 101 -> 94 is the
WORLD changing under the probe, not the v3 rules. Likely cause: since S516 the amateur tables rank by LADDER POINTS
(scripts/state/RankLine.gd `_before`: points, then net wins, wins, rating; scripts/rules/LadderPoints.gd), plus the idle clock
(Region._free_week) and newcomers (scripts/state/Newcomers.gd) - a table by points rewards bouts boxed more than who is better,
so "top-10 appearances" stopped measuring the pick. Confirm or refute this FIRST (part 1), then measure (part 2).

## Part 1 - the yardstick (print it; this decides whether part 2 can read)
For ORACLE and BLIND on seeds 7000-7059 print, side by side: top-10 appearances (as today), titles, bout wins, win share
(wins / bouts), and the signed boxer's final TRUE rating. Pick the result measure where ORACLE - BLIND is largest and stable
across the three seed sets; name it in the result doc with the numbers that chose it. If no measure gives ORACLE - BLIND >= 8%
of BLIND's value on every set, print `VOID` with the table and stop (that is a finding, not a failure of your work).

## Part 2 - K1, K3, K4 on v3 (only if part 1 found a yardstick)
Use the game's rules, never copies: `scripts/rules/Knowledge.gd` (v3 groups: body / skills / under_fire / mind; `fresh`,
`range_of`, `shown`, `width`, `word`, `hyped_centre_offset`, `set_hyped`, `clear_hype`, `morning`, `pad_night`, `bout`, `stale`)
and `scripts/rules/KnowReads.gd` (`price(kind)`, `apply(k, kind)`: look_closer $120, trial, test_day $60, recheck $40).
Hype: a Hyped prospect's shown centres sit 3-8 high (Knowledge.hyped_centre_offset), others 2 or less; Hyped is drawn
independently of truth (print the hype-truth correlation, within +-0.1).
- K1 bots, on three seed sets (7000-7059, 8000-8059, 9000-9059), 4 years each: BLIND (signs the best shown centre, buys
  nothing), READER (buys Look closer on its top 2 shown prospects before signing, a Trial when Hyped, Test day once a year per
  boxer), ORACLE (the truth, pays nothing), BAD SIGNER (the lowest shown). Charge every read at KnowReads.price.
  PASS: READER - BLIND >= 5 top-10s per 60 worlds after costs (or the part-1 measure, scaled the same: +5 of ORACLE's +14 =
  36% of the ORACLE - BLIND gap) on EVERY set; control BAD < BLIND on every set.
- K3 read mix (READER's spend): no read above 50% of spend, each read 5%+. Print the shares.
- K4 leak bot: reads only what the screen would show (Knowledge.shown / range_of + width word); for every row it tries to
  place the true stat within 2 points before the band says Exact. PASS: it cannot in 95%+ of rows.

## Contract
OWNS: tools/knowbots4_probe.gd, tools/knowbots4_pool.gd (only if the probe passes 450 lines), docs/KNOWBOTS4_RESULT.md
RED_TEST: tools/knowbots4_probe.gd -> KNOWBOTS4 done
REGRESSION: knowledge_test, know_reads_test, knowledge_keep_test, world_years_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ and tools/knowbots_probe.gd (read-only). Start from a COPY of
tools/knowbots_probe.gd. The result page is WRITTEN BY THE PROBE (its own write function, from the run's numbers), never by
hand. Claude reruns it on the same seeds before reading a word of it. PR body: `RESULT: tools/knowbots4_probe.gd ->
yardstick=<measure|VOID> oracle_minus_blind=<n,n,n> reader_minus_blind=<n,n,n> k1=<pass|fail> k3=<pass|fail> k4=<pass|fail>`.
Each file under 500 lines. Pilot 4 worlds first and print the projected time; stop at 90 minutes of run time.

## Prior research
`python ops/Tools/prior_research.py knowbots knowledge read` -> TASK_KNOWBOTS3.md (S463 PASS and why KNOWBOTS2 was VOID),
docs/KNOWBOTS3_RESULT.md, DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md s10, docs/LADDERPROBE2_RESULT.md (the S516-S517 ladder).

## What would a human do?
Before asking "does scouting pay", check the scoreboard still rewards having the better boxer. If the best possible scout
cannot beat a coin flip, change the scoreboard you read, not the scouting.

## Prefab check
None: the probe reuses the game's world, Knowledge.gd and KnowReads.gd.

## The one trap
Reading a field that does not decide results (KNOWBOTS2's trap) - print, for 5 sample prospects: rating, AttrGen.attrs_of mean,
shown centre, hype, and the part-1 measure at the end.
