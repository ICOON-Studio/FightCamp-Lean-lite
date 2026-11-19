# TURNPROBE3 read (S530, Claude) - what the rerun shows, what it does not

Source: docs/TURNPROBE3_RESULT.md (Goose #406, today's main with the S529 price fix; 360 careers, 104 weeks, seeds 4421 / 9001).

## Probe defects found on reading (fixed in tools/turn_pro_probe3_fork.gd, S530)
- LINE 6 (paired debut win rate) read 0/31 at every gap: the fork waited for f["bout"]["done"], but Bouts.after_fight
  clears f["bout"] in the same step, so no debut was ever seen finishing; and it compared f["w"] while pro wins are counted
  in f["pro_w"] (BoutFinish). The gap fork now reads the boxer's first pro row in c.results. TURNPROBE2 had 80% / 60%.
- LINE 7 (best ask) has the same never-finishes loop: every ask fork ran to MAX_DAYS, so "best ask" compares cash at that
  horizon, not at the week after the debut as the line defines. Left as Goose wrote it; the rerun must stop each ask fork
  7 days after the debut's pro row appears.

## Readable lines (today's code)
| line | reading | verdict |
|---|---|---|
| 1 no bot dominates | ok | PASS |
| 2 PREP beats YES by $1,500 at w104 | paired median $0; PREP and YES sign on the same day in most careers | FAIL - PREP is not a different path |
| 3 stipend timing | stipend: YES $7,559 vs NEVER $2,815 at w52 | FAIL as defined; see the day-job row |
| 4 a stipend debut loses money 40-70% | 67% / 40%, mean 53% | PASS |
| 5 the door shuts 10-30% (RANK bot) | 0 / 60; the TERMS08 bot (refuses under 0.8) also 0 / 60 | FAIL - three declines are unreachable in 104 weeks |
| 6 win rate per gap | void (probe defect above) | rerun |
| 7 each ask best 10%+ | costs 68%, later2 23%, price 6%, later4 3%, softer / split / no ask 0% | FAIL, horizon defect above - rerun before reading |
| 8 the ticket house picked 25%+, both call 25-50% | 63% / 43% | PASS |
| 9 ambitious boxer Steady+ at signing 70% | 1 / 30 | FAIL - the known dead path: ProCall.ambition_kind looks for "pro", Recruit.ambition never says it |

## New finding (not a pass line)
DAY-JOB careers: every bot ends with the same cash ($12,110 at w52, -$2,417 at w104) and 1 of 60 ever signs. A boxer on
the day job almost never reaches the first pro call in two years. Next: is that the day job's lost mornings (DayJob) or
the 7-wins + top-3 gate? Measure wins and rank at w104 for the day-job half before calling it a defect.

## Next
TURNPROBE3B (Goose): rerun with the gap fix (already in tools/), the ask-fork stop at debut + 7 days, and per-boxer wins /
rank at w104 for both stipend halves. Then the v5 map answers the lines, not the critics' prose.
