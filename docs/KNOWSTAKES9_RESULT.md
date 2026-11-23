# KNOWSTAKES9 result - the prospect decision on a greybox, v9 rules (v8 replayed first)

Status: MEASURED on a greybox, PARTIAL (four bars of five). Nothing in the game changed. Discipline: boxing. S541, 2026-11-23.
Map: `ops/research/DESIGN_KNOW_STAKES1_V9.md`. Probe: `tools/knowstakes9.gd` (based on `tools/knowstakes8.gd`).

## Verdict (one line)
v9 passes B1, B2, B3 and B4 for the first time (hunch / look / wait best in 45.4 / 22.2 / 32.4% of decisive decisions; v8 was
56.4 / 30.8 / 12.8) and lifts decisive decisions from 18.1% to 24.2% of prospects, but B5, the new "how often does the choice
matter" bar both critics asked for, is only half met: 59.6% on the first half (bar 40, and that pass comes from the trial's
price), 17.8% on the second (bar 30). The no-clock control missed the bar I set for it (26.9% against under 15%).

## Why the first critic's score fell from v7 to v8 (the task asked this first)
v7: depth 7, play 6, general 6. v8: depth 6, play 6, general 7. Only depth fell. The v7 map carried no measurement ("No Godot
run, no probe run for this map"), so v7 was scored on its claim. v8 carried its own probe, which printed that all three calls
end the same on 82% of prospects, that the wait misses its bar, and that the scout filter does the spreading. The critic
scored that measurement ("nothing matters most of the time"), and added three design points: the two stacked minus-7s leave
no room to wait on the prospects worth waiting for, the test day is free information, and the numbers come back too late.
So the fall is the design being measured, not the design getting worse. v9 answers the measurement.

## The ruler
- Greybox, not the game loop. Widths, offsets and reads are `scripts/rules/Knowledge.gd`'s own (`fresh`, `expose`,
  `hard_spar`, `range_of`, `_offset`). ESTIMATES of the greybox, unchanged from v8: merit = 0.6 x (0.4 body + 0.4 skills +
  0.2 under fire) + 0.4 x (ceiling - 12); good = merit >= the level (60); a good signing is worth V ($3,000 / $5,000 /
  $8,000; shares do not move with V); a flop costs the 12-week bond ($3,000) and frees the place in week 8.
- Population: the same people as KNOWSTAKES8 (seeds 54000.., same truths, same v8 dice), every one different: body,
  skills, under fire ~ N(60, 7), ceiling = their level + U(4, 22), each with a second name due 7-42 days later. New v9 dice
  per person, drawn after the v8 ones: the bout day, U(4, 18). "maybes" = the scout brings only names whose first look
  is within 2 of the level (63,218 drawn to keep 20,000); "all" = no filter.
- Shared dice (the first critic's question): yes. The rival's day, the bout day and the second name are drawn once per
  prospect; every call and every arm on that prospect reads the same draws.
- Three pure calls on every prospect: HUNCH (decide on the first look), LOOK (start the trial; end it the evening the read
  sits 2 points clear of the level, or the evening before the rival's window opens when there are 2 or more safe days),
  WAIT (Continue to the prospect's bout when it falls inside the clock, else 7 days; then decide).
- Arms: the three calls, sign-and-cut, clock-only (sign when the rival likes them), buy-everything (the whole week,
  whatever the window), selective (the hunch when the first look sits 1.2 clear; else the trial by the day; then the bout
  if it is still unclear and the bout is before the window), knows the truth. Interval: normal 95%, paired per prospect.
- One probe fix against v8: the player's estimate weighs their own look and the rival's shown look by how narrow each is
  (v8's probe took a plain average, so a finished trial still counted the rival's rough look as half). Run with the plain
  average: flips 24.8% against 25.7% - it is worth about one point of B3.

## Bars (printed by the probe before every run)
B1 each of hunch / look / wait best in 15-60% of decisive decisions. B2 selective above every arm but the truth, low end
> 0. B3 selective's reads flip the first-look call 25-60%. B4 the clock, beside the first look, explains less of the truth
than day 1 of the trial adds. **B5 (new, from both critics):** in at least 40% of ALL prospects the best of the three
calls beats the worst by more than $250 (the first critic), and in at least 30% it beats the second by $250 or more (the
second critic). CONTROL: with no clock the hunch must be best in under 15%.

## Final run (20,000 prospects, maybes; cash at V $5,000)
| | v8 (its own 20,000, docs/KNOWSTAKES8_RESULT.md) | **v9** | v9, no scout filter |
|---|---|---|---|
| Decisive decisions | 18.1% | **24.2%** (4,835) | 18.7% |
| The first look's call is wrong | 27.6% (run 0) | **33.0%** | 12.6% |
| Best: hunch / look / wait | 56.4 / 30.8 / 12.8 | **45.4 / 22.2 / 32.4** | 75.9 / 8.5 / 15.6 |
| Selective, mean | $2,782 | $2,563 | $3,264 |
| Selective minus hunch | +195 | +277 (248..305) | +81 |
| Selective minus look | +213 | **+32 (19..46)** | +59 |
| Selective minus wait | +449 | +350 (317..382) | +641 |
| Selective minus buy-everything | - | +129 (104..154) | +645 |
| Selective minus sign-and-cut / clock-only | +1,649 / +629 | +1,473 / +519 | +1,976 / +433 |
| Knows the truth minus selective | +829 | +1,024 | +416 |
| Selective's reads flip the call | 18.0% | **25.7%** of 10,831 | 25.5% of 3,478 |
| Lost to the rival: selective / buy-everything | 1.4 / 23.4% | 7.5 / 26.6% | 2.2 / 28.5% |
| Best beats worst by > $250 / best beats second by >= $250 | 22.7 / 15.4% (run 0) | **59.6 / 17.8%** | 30.7 / 6.5% |
| B1 / B2 / B3 / B4 / B5 | FAIL / PASS / FAIL / PASS / - | **PASS / PASS / PASS / PASS / FAIL** | FAIL / PASS / PASS / PASS / FAIL |

B2 holds at every V: selective minus look is +31 (21..40) at $3,000 and +35 (15..54) at $8,000.
R2 of the truth (maybes): the clock alone 0.044, the first look 0.224, the clock beside it adds **0.015**, day 1 of the trial
adds **0.041**. B4 PASS. The pure LOOK call's trial runs 5.2 days on average and the rival's day comes first in 11.4% of
them; the pure WAIT call loses 40.5% (it waits for the bout even inside an open window).

## The runs, in order (56 probe runs; 4,000 prospects unless said; one knob at a time)
0. **v8 replayed by this file's first build** (2,000 of v8's own maybes): 54.2 / 31.7 / 14.1, decisive 19.1%, flips 17.6% -
   the port reads the same as KNOWSTAKES8 (56.4 / 30.8 / 12.8, 18.1%, 18.0% at 20,000). The v8 arm then left the file
   (the 500-line rule); `tools/knowstakes8.gd` remains the v8 ruler.
1. **The v9 structure** (every scouted name boxes inside 4-18 days; the trial runs by the day; the window comes from the
   rival's look only; the weighted estimate), trial still $125 flat: 54.8 / 16.9 / 28.3. **The wait passes for the first
   time.** B2 FAIL: always-trial ties the selective player (-14).
   - First looks 1.5x wider (the first critic's item 1): 50.7 / 17.7 / 31.5, flips 25.0 - but in run 3 it breaks B2.
     The five lines below were each run against this wider-look line.
   - The second critic's stronger reads (trial skills 30, open session body 12 / skills 10): 50.6 / 17.1 / 32.3, flips
     25.5. No bar moves.
   - The second critic's wider scout filter (within 4): 57.1 / 15.6 / 27.3, decisive 20.9, flips 23.6. Worse on every line.
   - Trial body read 12 (v8) against 24 (the code): flips 24.4 against 25.0. No reason to change the code.
   - No bout: 44.9 / 29.1 / 26.0, decisive 18.1. Whole-week trial only: 54.6 / 22.4 / 22.9.
2. **The trial priced by the day; the rival's offer can be matched; the filter.**
   - Matching the rival's offer at +$50 a week instead of losing them: hunch 73.5%. B1 FAIL. Refused.
   - $18 / $36 / $72 a day: best-beats-worst-by-$250 reads 24.6 / 47.2 / 60.8%. **That half of B5 follows the trial's
     price**, not the decision.
   - Scout filter within 2: decisive 25.8, first look wrong 35.3%, 44.6 / 20.6 / 34.8. Within 1.5: 27.2, 38.6%.
3. **The test day becomes day 1 of the trial** (one button less); selective as described under the ruler.
   - Wider first looks + filter 2: B2 FAIL (-17, a tie with always-trial). **Plain first looks + filter 2: B1, B2, B3, B4
     PASS** (47.5 / 20.3 / 32.1, +37 over look, flips 25.3).
4. **Final 20,000** (table above), and what each piece is worth at 8,000:
   - No bout: 39.8 / 38.1 / 22.1, decisive 19.4. The bout is worth 5 points of decisive and 10 points of the wait.
   - Whole-week trial only: 49.7 / 24.8 / 25.5, and the selective player loses 16.2% to the rival against 7.5%.
   - $18 a day ($125 the week): B2 FAIL (selective minus look +10, low end -10). $72 a day ($500, the code's price
     today): B2 PASS (+92). **$36 a day is the cheapest price at which thinking beats always buying.**
   - Filter 3: 55.3 / 16.1 / 28.6, decisive 21.2. Filter 1.5: 41.9 / 23.5 / 34.6, decisive 27.0, B2 FAIL (+3).
   - Selective reading everything inside 2 points: B2 FAIL (-1), flips 17.7. Matching: 68.2 / 20.1 / 11.7, B1 FAIL.
   - **Control, no clock (20,000): 26.9 / 36.6 / 36.6. FAIL against my bar of 15.** The clock moves the hunch from 27% to
     45%; the hunch keeps a quarter even with no clock because a read costs money when the first look was right.

## What it says
1. **The prospect's own bout is what makes waiting a call.** v8's wait was a pause with a small read. A dated, free, public
   bout gives it something to wait for, and the window says whether there is time.
2. **A trial you can end any evening is the press-your-luck the mechanic lacked.** It halves the prospects lost in a
   trial, and it makes the test day redundant: day 1 is the test.
3. **A scout's hunch is wrong one time in three** (33.0%) with the filter at 2. That is the lever on how often the choice
   matters; wider ranges and stronger reads are not.
4. **B5 is the honest gap.** Decisive decisions rose from 18.1% to 24.2%. The $250 measure reads 59.6% only because a
   full trial costs $252; at $125 a week it reads 26.8%. Best-beats-second reads 17.8% against 30. On this greybox the
   ceiling is the share of first looks that are wrong (33%) plus the prospects the rival takes: with three calls, two of
   which are ways of looking again, one call can only stand alone when the other two both go wrong.
5. **Thin margins, said plainly:** B3 passes by 0.7 of a point (25.7 against 25); B2 over always-trial by $32 (low end
   $19). Both are sensitive to the trial's price and to how the selective player is written.

## What is next
- The map goes to two fresh critics with this page (`CRITIC_KNOW_STAKES1_V9_BRIEF.md`).
- The build's own probe re-runs B1-B5 on the real loop (KNOWBOTS worlds) before any menu, with P-F from v7.
- If the critics hold B5's second half as a bar: the next lever is a fourth call that is not a look (the map's section 6
  names it), not another read strength.

## Tests
None run: no game file changed. The probe ran 56 times through godot_slot (`--who KNOWSTAKES9`); the first run waited 21
minutes behind a RED memory gate, the rest ran at once.
