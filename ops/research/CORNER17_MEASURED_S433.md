# CORNER17 measured (S433, foundation F12 not landed)

F12 in CORE_LOOP_MAP_S432 section 5 asked for the corner's best call 17 -> 12 now (Exchanges.EDGE best), LEVERS1 to set the final.
Tried on main 2026-11-11 with nothing else changed. Three tests tuned at 17 sit on their bars at 12:

| Test | Reading at 17 (main) | Reading at 12 | Bar |
|---|---|---|---|
| exchanges_test: read the clue vs always her best-graded call | passes | green 0.26, none 0.25, read 0.32 (+0.06) | +0.08 (passes only if scaled by 12/17) |
| habit_fix_test: the read + the fix vs the read alone (400 bouts) | passes | 0.24 -> 0.26 (+0.016..0.02) | +0.03 (scaled 12/17: 0.021, still under) |
| fight_why_test: a good plan reads GOOD | passes | 53 of 60; 107 of 120 (89%) | 90% |

Decision: not landed alone. The three bars encode today's tuning and move together with the corner's size, so the cut goes in WITH
LEVERS1 (its THE TARGET run decides 12 or another value, and the same task re-tunes these three bars from its own measurement).
Everything else read the same at 12: PLAN_FIGHT, THE_READ, GOLDEN_PATH, CORNER_CARD, CALL_EVIDENCE, BALANCE, PERK_FIGHT,
CORNER_TRUST, PLAN_BOUT, CORNER_STATS failures=0.
