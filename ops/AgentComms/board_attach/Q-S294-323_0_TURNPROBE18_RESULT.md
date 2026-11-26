# TURNPROBE18 - turning pro v18, the greybox probe (S543)

**Verdict: STOP at the measure-first gate (rule 1). The matchup cannot decide through the plan on today's read.** For 7 of
the 10 boxer types the game's own read moves less than 4 points (median) between the best and the worst plan line the
boxer can write against an opponent's tells, and the best line beats the usual plan (the coach's) by a median of only
**0.2-1.1 points** for every type. Only one tell moves the number: an opponent who fades ("Fades after round 2"), where
combinations inside when the opponent tires add a median 7.5-12.5 points, up to **14.5** - over the 10-point cap the
feedback-loop section sets on the plan. As the brief says, no career ran, no bar was measured and no critic brief was
written; the next step is the coordinator's.

The map: `ops/research/DESIGN_TURNPRO1_V18.md` (section 9 = this verdict). The probe: `tools/turnprobe18.gd` (stage=measure),
`tools/turnprobe18_rules.gd` (the v18 rules: card bar line, name tiers, ambition, knockout hit, Not yet), tables by
`tools/turnprobe18_sum.py`. Nothing under scripts/ or tests/ changed. Run: `godot --headless --audio-driver Dummy --path .
--script res://tools/turnprobe18.gd -- stage=measure` through `ops/Tools/godot_slot.py` (82 s, 33,631 reads, one slot;
raw: E:/FightCamp/tmp/turnprobe18/measure_final.jsonl, first measure measure0_signing_book.jsonl).

## Bars (map section 8) - switch ON and OFF

| Bar | Ring switch ON | Ring switch OFF |
|---|---|---|
| (1) no habit best in more than 6 of 10 | not run (STOP at the gate) | not run |
| (2) reader beats every habit by > 2 SE in 5+ types | not run | not run |
| (3) both bouts alive (25%+ each) | not run | not run |
| (4) waiting is a question | not run | not run |
| (5) mistakes are felt | not run | not run |
| (6) nothing runs away (bars inside 5 points) | not run; the plan alone already moves 14.5 points (over its own 10-point cap) | not run |
| (7) reader's edge 8%+ in 5+ types | not run; measured ceiling: a written line adds a median 0.2-1.1 points | not run |
| (8) both bouts alive at x1.5, x1.75, x2 | not run | not run |
| (9) reader beats the PRICE BOT by 2%+ in 5+ types | not run | not run |
| (10) waiting is a real call | not run; four weeks of training move a tune-up read 0.0-3.5 points | not run |

The career arms, the reader's planner and the bars were not built: the brief forbids a career run before the gate passes.

## Measure first (the game's read; 10 types x 180 opponent files; the debut week)

Population: Data's six (Lucy Jackson, Kira Mensah, Samira Khan, Tess Reilly, Danny Osei, Josh Harper) and v17's four more
(Nell Ward, Reece Doyle, Bayo Adams, Kai Turner): 5 women, 5 men, six styles, potential 70-90 (both ambitions: three steady,
seven title chasers), confidence trait 25-82 (both ends), loyalty 40-82 (two under 50: the club keeps 10%), Reid (58) as
coach. Opponents: their own sex and class, DebutOpp.make with 6 styles x 6 weapons (BoutRead.ANY_WEAPON's two and four the
plan board maps to a situation) x 5 weaknesses (BoutRead.ANY_WEAK's three and two more). Lines: every move the boxer can
throw out of the card each tell's situation sits on (OppFile.tells, PlanLines.options), as a "when" arrow added to the
coach's plan.

## Measure first: the same-rated man (gap 0), 180 files, debut week (points of win chance)

| Type | Ambition | Usual plan: lowest / median / highest file | Best line over usual: median / 90th / max | Best - worst line: median / max | Files with best - worst >= 4 |
|---|---|---|---|---|---|
| Lucy Jackson | title (pot 84) | 31.2 / 56.9 / 84.8 | 0.9 / 11.1 / 13.4 | 7.9 / 29.9 | 56% |
| Kira Mensah | title (pot 86) | 25.2 / 43.1 / 73.6 | 0.3 / 2.5 / 2.9 | 3.0 / 13.2 | 44% |
| Samira Khan | title (pot 82) | 11.3 / 31.9 / 50.6 | 0.2 / 8.6 / 10.4 | 2.5 / 18.4 | 33% |
| Tess Reilly | steady (pot 76) | 16.0 / 33.1 / 43.5 | 0.3 / 7.5 / 8.9 | 3.0 / 13.4 | 32% |
| Danny Osei | title (pot 85) | 24.1 / 51.5 / 84.2 | 1.0 / 11.0 / 13.4 | 5.2 / 24.2 | 60% |
| Josh Harper | title (pot 79) | 22.3 / 41.8 / 55.6 | 0.3 / 7.7 / 9.5 | 3.3 / 14.2 | 33% |
| Nell Ward | steady (pot 72) | 36.2 / 60.0 / 82.6 | 1.1 / 10.2 / 14.0 | 6.0 / 24.8 | 81% |
| Reece Doyle | title (pot 90) | 27.7 / 47.2 / 72.5 | 0.3 / 2.7 / 3.0 | 2.7 / 13.1 | 44% |
| Bayo Adams | steady (pot 70) | 21.3 / 37.3 / 57.6 | 0.3 / 8.5 / 10.5 | 2.8 / 18.7 | 33% |
| Kai Turner | title (pot 80) | 11.8 / 33.1 / 57.0 | 0.4 / 12.5 / 14.5 | 2.7 / 21.9 | 35% |

Verdict line: best - worst median under 4 points for **7 of 10** types (STOP when most); the largest gain a line gives over the usual plan **14.5** points (cap 10: over).

## Which tell a line can answer (same-rated man; points over the usual plan)

| Type | press: best median / max, worst median | range: best median / max, worst median | counter: best median / max, worst median | loadup: best median / max, worst median | tiring: best median / max, worst median |
|---|---|---|---|---|---|
| Lucy Jackson | 0.0 / 1.6, -1.0 | 1.4 / 3.9, -6.8 | 0.3 / 0.6, -2.1 | 0.0 / 1.2, -1.3 | 11.1 / 13.4, -6.3 |
| Kira Mensah | 0.0 / 0.0, 0.0 | 1.2 / 2.9, -4.0 | 0.3 / 0.6, -2.2 | 0.0 / 0.0, 0.0 | 0.0 / 0.0, 0.0 |
| Samira Khan | 0.2 / 0.4, -0.6 | 0.0 / 0.2, -2.9 | 0.0 / 0.0, -0.7 | 0.0 / 0.3, -0.6 | 8.7 / 10.4, -6.0 |
| Tess Reilly | 0.3 / 0.5, -0.6 | 0.0 / 0.4, -3.1 | 0.0 / 0.0, -0.6 | 0.0 / 0.3, -1.0 | 7.5 / 8.9, -3.6 |
| Danny Osei | 0.0 / 1.3, -1.5 | 0.9 / 3.4, -4.6 | 0.0 / 0.7, -2.9 | 0.0 / 1.2, -1.8 | 11.1 / 13.4, -6.2 |
| Josh Harper | 0.3 / 0.5, -0.7 | 0.0 / 0.3, -3.5 | 0.0 / 0.0, -0.7 | 0.0 / 0.3, -0.7 | 7.7 / 9.5, -4.0 |
| Nell Ward | 0.0 / 2.0, -3.6 | 0.7 / 3.8, -3.6 | 0.0 / 0.4, -1.1 | 0.0 / 1.4, -4.3 | 10.3 / 14.0, -6.1 |
| Reece Doyle | 0.0 / 0.0, 0.0 | 1.3 / 3.0, -3.9 | 0.3 / 0.4, -1.9 | 0.0 / 0.0, 0.0 | 0.0 / 0.0, 0.0 |
| Bayo Adams | 0.3 / 0.4, -0.6 | 0.0 / 0.3, -3.1 | 0.0 / 0.0, -0.8 | 0.0 / 0.2, -0.8 | 8.5 / 10.5, -6.2 |
| Kai Turner | 0.4 / 0.6, -0.3 | 0.0 / 0.5, -3.0 | 0.0 / 0.0, -1.2 | 0.0 / 0.4, -1.0 | 12.5 / 14.5, -6.3 |

## At the tune-up's aim (the rating where the usual plan reads 82% against a plain man)

| Type | Usual plan across files: 10th / median / 90th (lowest - highest) | Best line over usual: median / max | Fade line (tiring) best median / max | Plain man now -> four weeks on |
|---|---|---|---|---|
| Lucy Jackson | 71.0 / 83.0 / 94.0 (58.1 - 96.9) | 0.4 / 11.8 | 6.4 / 11.8 | 82.0 -> 83.7 |
| Kira Mensah | 73.0 / 82.5 / 93.6 (61.7 - 96.2) | 0.2 / 2.2 | 0.0 / 0.0 | 82.0 -> 84.7 |
| Samira Khan | 69.5 / 80.0 / 91.0 (53.7 - 95.2) | 0.3 / 8.0 | 4.9 / 8.0 | 82.0 -> 83.8 |
| Tess Reilly | 71.5 / 81.1 / 88.8 (59.1 - 91.7) | 0.3 / 6.9 | 4.4 / 6.9 | 82.0 -> 82.9 |
| Danny Osei | 69.0 / 81.7 / 94.5 (55.6 - 97.1) | 0.6 / 12.5 | 6.3 / 12.5 | 82.0 -> 84.9 |
| Josh Harper | 71.6 / 81.1 / 89.1 (62.1 - 92.1) | 0.3 / 7.2 | 4.6 / 7.2 | 82.0 -> 83.1 |
| Nell Ward | 72.3 / 80.9 / 91.8 (59.4 - 95.2) | 0.8 / 11.7 | 6.7 / 11.7 | 82.0 -> 82.0 |
| Reece Doyle | 72.4 / 82.4 / 92.7 (61.4 - 95.1) | 0.2 / 2.4 | 0.0 / 0.0 | 82.0 -> 85.5 |
| Bayo Adams | 70.2 / 80.5 / 89.6 (58.2 - 92.6) | 0.3 / 7.9 | 5.1 / 7.9 | 82.0 -> 82.4 |
| Kai Turner | 69.1 / 83.0 / 92.2 (56.4 - 95.8) | 0.3 / 13.9 | 7.1 / 13.9 | 82.0 -> 83.7 |

## The bars' card line and the name tiers (from tools/turnprobe18_rules.gd)

| Type | Trait -> KO hit | Club's cut | Card lines (conf 66 / hunger 70; 30 / 15; 90 / 95 ring ON; 90 / 95 ring OFF) | Tier 0 / 1 / 2: purse, points |
|---|---|---|---|---|
| Lucy Jackson | 30 -> -40 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Kira Mensah | 58 -> -25 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Samira Khan | 66 -> -20 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Tess Reilly | 70 -> -20 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Danny Osei | 82 -> -20 | 10% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (2.4) / $3150 (3.15) / $2800 (2.8) |
| Josh Harper | 38 -> -38 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Nell Ward | 25 -> -40 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Reece Doyle | 75 -> -20 | 10% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (2.4) / $3150 (3.15) / $2800 (2.8) |
| Bayo Adams | 45 -> -33 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |
| Kai Turner | 33 -> -40 | 25% | Confidence 66: +1.6 -> 84%; Confidence 30: -2.0, hunger 15: -3 -> 77%; Confidence 90: +4.0, hunger 95: +2 -> 87%; Confidence 90: +4.0 -> 86% | $2400 (6.0) / $3150 (7.88) / $2800 (7.0) |

## First measure, on the signing's own book (identical punches for all ten, no drilled combination)

| Type | Usual lowest - highest | Best line over usual: median / max | Best - worst: median / max |
|---|---|---|---|
| Lucy Jackson | 12 - 64 | 0.0 / 15.5 | 2.8 / 23.0 |
| Kira Mensah | 12 - 58 | 0.0 / 0.0 | 1.2 / 5.8 |
| Samira Khan | 3 - 25 | 0.0 / 0.0 | 1.1 / 4.0 |
| Tess Reilly | 7 - 24 | 0.0 / 0.0 | 0.6 / 3.8 |
| Danny Osei | 12 - 67 | 0.0 / 13.1 | 2.8 / 19.9 |
| Josh Harper | 11 - 35 | 0.0 / 0.0 | 0.9 / 4.8 |
| Nell Ward | 18 - 57 | 0.0 / 13.3 | 3.2 / 20.0 |
| Reece Doyle | 16 - 61 | 0.0 / 0.0 | 1.3 / 6.4 |
| Bayo Adams | 9 - 34 | 0.0 / 0.0 | 1.6 / 4.1 |
| Kai Turner | 5 - 42 | 0.0 / 12.6 | 2.0 / 18.7 |


## What was tuned (before -> after)

- No rule number was tuned (the gate comes before any career).
- Population, not a rule: each type got a pro-ready book by style (punches, drilled combinations, step bars, scaled per
  type). Before: the signing's own book, the same for all ten (Jab 46-56, no Uppercut, Body hook under 30 for six types, NO
  drilled combination, step bars 0 except step in / step out 32). On it no line on a card situation could fire
  (FireLevel: under 30 mastery a planned combination or step never fires) and only the four types whose body hook reached
  30 had the fade answer at all (first-measure table above). The brief asks for types that differ in techniques, and a
  boxer at the pro line has 7-10 amateur wins of pad time. The verdict is the same on both books.

Population books (punches, drilled combinations, step bars): [["Lucy Jackson", {"Body hook": 32.0, "Check hook": 15.0, "Cross": 58.0, "Jab": 70.0, "Lead hook": 45.0, "Uppercut": 20.0}, {"1-1": 60.0, "1-1-2": 45.0, "1-2": 62.0, "2-3": 35.0}, {"cut_off": 20.0, "feint": 40.0, "herd": 20.0, "pivot_out": 45.0, "push_off": 20.0, "roll_out": 20.0, "step_back": 55.0, "step_in": 50.0, "step_out": 60.0, "tie_up": 20.0}], ["Kira Mensah", {"Body hook": 29.4, "Check hook": 13.8, "Cross": 53.4, "Jab": 64.4, "Lead hook": 41.4, "Uppercut": 18.4}, {"1-1": 55.2, "1-1-2": 41.4, "1-2": 57.0, "2-3": 32.2}, {"cut_off": 20.0, "feint": 36.8, "herd": 20.0, "pivot_out": 41.4, "push_off": 20.0, "roll_out": 20.0, "step_back": 50.6, "step_in": 46.0, "step_out": 55.2, "tie_up": 20.0}], ["Samira Khan", {"Body hook": 52.5, "Check hook": 10.5, "Cross": 71.4, "Jab": 52.5, "Lead hook": 65.1, "Uppercut": 47.3}, {"1-2": 47.3, "1-2-3": 36.8, "1-6-3": 42.0, "2-3": 57.8, "3b-3": 52.5}, {"cut_off": 42.0, "feint": 20.0, "herd": 36.8, "pivot_out": 20.0, "push_off": 47.3, "roll_out": 20.0, "step_back": 20.0, "step_in": 57.8, "step_out": 20.0, "tie_up": 47.3}], ["Tess Reilly", {"Body hook": 66.0, "Check hook": 10.0, "Cross": 58.0, "Jab": 52.0, "Lead hook": 64.0, "Uppercut": 40.0}, {"1-2": 40.0, "1-2-3-2": 35.0, "1-2-3b": 50.0, "1-6-3": 35.0, "3b-3": 60.0}, {"cut_off": 55.0, "feint": 20.0, "herd": 50.0, "pivot_out": 20.0, "push_off": 40.0, "roll_out": 20.0, "step_back": 20.0, "step_in": 55.0, "step_out": 20.0, "tie_up": 40.0}], ["Danny Osei", {"Body hook": 45.0, "Check hook": 20.0, "Cross": 62.0, "Jab": 62.0, "Lead hook": 55.0, "Uppercut": 35.0}, {"1-2": 58.0, "1-2-3": 48.0, "1-2-3b": 35.0, "2-3": 40.0, "slip 2-3": 35.0}, {"cut_off": 20.0, "feint": 35.0, "herd": 20.0, "pivot_out": 40.0, "push_off": 20.0, "roll_out": 20.0, "step_back": 45.0, "step_in": 45.0, "step_out": 45.0, "tie_up": 20.0}], ["Josh Harper", {"Body hook": 59.4, "Check hook": 9.0, "Cross": 52.2, "Jab": 46.8, "Lead hook": 57.6, "Uppercut": 36.0}, {"1-2": 36.0, "1-2-3-2": 31.5, "1-2-3b": 45.0, "1-6-3": 31.5, "3b-3": 54.0}, {"cut_off": 49.5, "feint": 20.0, "herd": 45.0, "pivot_out": 20.0, "push_off": 36.0, "roll_out": 20.0, "step_back": 20.0, "step_in": 49.5, "step_out": 20.0, "tie_up": 36.0}], ["Nell Ward", {"Body hook": 41.0, "Check hook": 54.0, "Cross": 67.0, "Jab": 64.8, "Lead hook": 59.4, "Uppercut": 32.4}, {"1-1": 43.2, "1-2": 54.0, "2-3": 48.6, "slip 2-3": 62.6}, {"cut_off": 20.0, "feint": 48.6, "herd": 20.0, "pivot_out": 59.4, "push_off": 20.0, "roll_out": 54.0, "step_back": 64.8, "step_in": 20.0, "step_out": 48.6, "tie_up": 20.0}], ["Reece Doyle", {"Body hook": 27.2, "Check hook": 12.8, "Cross": 49.3, "Jab": 59.5, "Lead hook": 38.3, "Uppercut": 17.0}, {"1-1": 51.0, "1-1-2": 38.3, "1-2": 52.7, "2-3": 29.8}, {"cut_off": 20.0, "feint": 34.0, "herd": 20.0, "pivot_out": 38.3, "push_off": 20.0, "roll_out": 20.0, "step_back": 46.8, "step_in": 42.5, "step_out": 51.0, "tie_up": 20.0}], ["Bayo Adams", {"Body hook": 50.0, "Check h

## Why (plain words)

1. The coach's plan already answers the opponent's main game. The coach (one card read at rating 58) writes the drilled
   best answer on the card the opponent's style fights on most; a line the player writes there adds nothing.
2. A weapon or a weakness does not make the opponent play its situation more often (the opponent's game mix comes from the
   style; only "walks in" and "fades" change it). So a line answering "Body hooks" or "Heavy right hand" fires only in that
   situation's small share of the exchanges: 0-4 points.
3. The fade is the exception, and too strong: the opponent-tiring situation reads the line at 0.75 x 1.9 of its edge
   (`BoutRead.PLAN_REACH` x `PLAN_CARRY`) with no fire share, so "combinations inside when the opponent tires" is worth
   7-15 points whenever the file says "Fades".
4. Who the opponent is moves the read a lot (same rating: about 70% to 92% between the 10th and 90th file at the tune-up's
   aim; 31% to 85% at an even rating for Lucy Jackson) - but that is the file, not the plan, and the card prints it. Reading
   the file then means reading two printed numbers: the decision TURNPROBE16 already found "the honest card solves".
5. The name tiers, read from the game's own purse rule, pay little and out of order: 6.0 / 7.9 / 7.0 points (tier 2 under
   tier 1, because an unranked boxer offered #10 earns more on the first card than a ranked #20 offered #15).

## The next step (the coordinator's; not measured here)

The one change that would let the plan decide the matchup: **a tell must make the opponent play its situation.** Give the
weapon's (and the weakness's) situation - the `when` OppFile already maps it to (`OppFile.gd:33-60`) - a weight in the
opponent's game mix that `BoutRead._games` / `Exchanges.next_mode` read, so a "Body hooks" presser presses more and the line
that answers it fires as often as the fade answer does; and bring the fade answer under the 10-point cap. Both are engine
changes under scripts/rules (the fight would change too), so they need their own probe and the coordinator's call. Until
then v18's rule 1 has nothing to stand on, and rules 2-5 are untested.

## Honest limits

- The measure reads each file at one week (the debut) and two ratings (even, and the tune-up's aim); a later week or the
  step-up's rating was not swept. At the tune-up's aim the verdict is stronger: best - worst under 4 points for 8 of 10
  types, the best line over the usual plan a median 0.2-0.8.
- "Best - worst" includes wrong lines; the best line over the usual plan (what a reader gains) is the stricter number and it
  is smaller still (median 0.2-1.1).
- The lines are single "when" arrows added to the coach's plan, one at a time; a whole player plan (several arrows, phases,
  paces) was not searched. The coach's plan is the game's own default (`BoutRead._read_copy`).
- The books are a population choice (ESTIMATE, printed above); the signing's own book gives the same verdict.
- The rules module was exercised only for what needs no career (the card's bar line, the tiers, the knockout hit by trait).
- A code-checked critic is not owed yet: no critic brief was written (STOP).
