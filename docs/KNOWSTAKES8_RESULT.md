# KNOWSTAKES8 result - the prospect decision on a greybox, v7 rules against v8 rules

Status: MEASURED on a greybox, PARTIAL. Nothing in the game changed. Discipline: boxing. S540, 2026-11-23.
Map: `ops/research/DESIGN_KNOW_STAKES1_V8.md`. Probe: `tools/knowstakes8.gd`.

## Verdict (one line)
v8 breaks v7's dominant trial (look best in 97% of decisive v7 decisions -> 31%) and passes B2 (selective beats every other
arm, sign-and-cut and clock-only included) and B4 (the clock no longer out-reads the paid reads), but misses B1 by wait
(12.8% against 15%) and B3 by flips (18.0% against 25%).

## The ruler
- Greybox, not the game loop. Widths, offsets, test day, trial and hard spar are `scripts/rules/Knowledge.gd`'s own
  (`fresh`, `expose`, `hard_spar`, `range_of`, `_offset`). ESTIMATES of the greybox: merit = 0.6 x (0.4 body + 0.4
  skills + 0.2 under fire) + 0.4 x (ceiling - 12); good = merit >= the level (60); a good signing is worth V to the club,
  swept at $3,000 / $5,000 / $8,000 (the shares below do not move with V, the cash does); a flop is found and let go at
  week 8 (v7: 8 weeks of $250; v8: the 12-week bond, $3,000).
- Population: 20,000 prospects (seeds 54000..), every one different: body, skills, under fire ~ N(60, 7), ceiling = their
  level + U(4, 22); each with a second name due 7-42 days later that the player takes on its first look if the place is free.
  "maybes" = the scout brings only names whose first look is within 3 of the level (44,676 drawn to keep 20,000); "all" = no
  filter.
- Three pure calls replayed on every prospect with the same dice: HUNCH (decide on the first look), LOOK (buy the read that
  fits the clock: the trial when 7 days fit, else the test day; then decide), WAIT (Continue 7 days, then decide, seeing
  the next name if it came). A decision is "decisive" when one call ends strictly better than both others.
- Arms: the three calls, sign-and-cut (sign everyone, let go at week 8), clock-only (sign when the clock is 10 days or
  less), buy-everything, selective (reads only when |first look - level| < 1.2, waits when the next name is due inside a
  safe week), knows the truth. Interval: normal 95% on the paired per-prospect difference.
- Control arm: v7 with the clock at 999 days must make LOOK best in over 60% (the dominant trial the clock exists to break):
  PASS in every run (97.8%).

## Bars (v7 section 5, printed by the probe before any run)
B1 each of hunch / look / wait best in 15-60% of decisive decisions. B2 selective above every arm but the truth, low end
> 0. B3 selective's reads flip the first-look call in 25-60%. B4 (new, from the first critic) the clock, beside the first
look, explains less of the truth (R2) than the test day adds.

## Final runs (20,000 prospects; V $5,000 for the cash)
| | v7, maybes | v8, maybes | v8, all (no scout filter) |
|---|---|---|---|
| Decisive decisions | 1,740 (8.7%) | 3,626 (18.1%) | 3,462 (17.3%) |
| Best: hunch / look / wait | 1.4 / 96.7 / 2.0 | **56.4 / 30.8 / 12.8** | 78.3 / 14.9 / 6.7 |
| Selective, mean | $2,897 | $2,782 | $3,272 |
| Selective minus hunch | +108 (86..130) | +195 (175..214) | +89 (76..102) |
| Selective minus look | +177 (160..195) | +213 (185..241) | +533 |
| Selective minus wait | +110 (88..132) | +449 (416..482) | +671 |
| Selective minus sign-and-cut | +1,256 | +1,649 (1,601..1,697) | +1,985 |
| Selective minus clock-only | +510 | +629 (589..669) | +798 |
| Knows the truth minus selective | +750 | +829 | +408 |
| Selective's reads flip the call | 25.9% of 6,100 | **18.0% of 8,137** | 18.2% of 3,628 |
| Lost to the rival: selective / buy-all | 10.2 / 21.8% | 1.4 / 23.4% | 0.7 / 21.4% |
| B1 / B2 / B3 | - | FAIL (wait) / PASS / FAIL | FAIL / PASS / FAIL |

How much of the truth each read explains (R2, maybes): v7 clock alone 0.143, first look 0.529, the clock beside the first
look adds 0.026, the test day adds 0.088. v8: clock 0.119, first look 0.472, the clock adds **0.013**, the test day adds
**0.035**. **B4 PASS.** (The rival's look and the record are on the v8 card, so most of what the clock knew is shown.)

## The runs, in order (each knob one at a time; 4,000 prospects unless said)
1. v7 rules as written, 500 prospects, no filter: 96% of decisions tie; selective's reads flip 5.7%. Waiting to the last
   day of a known date is free, so HUNCH and WAIT end the same, and the first look already explains 84% of the truth.
2. v8 window (the rival signs on one day of the 7 before the date) + trial loss from the window + refund + rival's look on
   the card + ceiling half-width 9 -> 14 + bond, 2,000, no filter: hunch 79.5% / look 15.6% / wait 4.8%; flips 5.1%.
3. The scout brings maybes: hunch 54.1 / look 36.8 / wait 9.1; B2 PASS; flips 13.6%; B4 FAIL (the clock knew the record).
4. The record goes into the player's estimate (a probe fix: the record is on the card) + the open session (body +8,
   skills +6 a week waited): hunch 57.4 / look 28.6 / wait 14.0; B4 PASS.
5. Selective reads only coin flips (|first look - level| < 1.2) + open session skills 6 -> 8: wait 15.0 (FAIL by a hair),
   flips 16.6%.
6. The trial's pad test halves the ceiling (was a third off): look 31.8, wait 14.1, flips 18.2%.
7-8. Final runs above (20,000, maybes and all).

## What it says
1. **The scout filter is the biggest lever.** Without it the hunch is right 78% of the time: most prospects are plain
   calls on the first look, and no read or clock changes that. "The scout brings maybes" puts the player where reads matter.
2. **v7's own claim fails on this ruler, and not the way the first critic expected.** The critic expected sign-now to
   dominate; here the trial dominates v7 (97% of decisive decisions), because a known date makes the wait free and the
   trial safe in 3 of 4. Sign-and-cut is a poor arm in both versions ($1,256 under selective in v7); the bond widens it.
3. **v8 spreads the calls** (56 / 31 / 13) and keeps selective on top of every other arm at every V, with the rival taking
   only 1.4% of selective's prospects and 23% of buy-everything's.
4. **Still short:** wait is best in 12.8% (bar 15) and a read flips the call 18% (bar 25). Both are about how far a week or
   a trial moves the estimate. In 82% of prospects all three calls end the same - the decision matters in 1 of 5 names.
5. **Cash is lower in v8** for the selective player ($2,782 against $2,897): the bond and the window are real costs. That
   is the stake the critics asked for, not a defect.

## What is next
- The bars are re-run on the real loop (KNOWBOTS worlds, `tools/knowmisread2_probe.gd` ruler) once step 2 of the map's order
  is on a branch; P-F (how it feels) runs there.
- If B1 stays short there: the open session's read first, then the window length (7 -> 10 days). If B3 stays short: the
  trial's skills read. Not the misread share (KNOWMISREAD2).
- The map goes to two fresh critics with this page (CRITIC_KNOW_STAKES1_V8_BRIEF.md).

## Tests
None run: no game file changed. The probe parsed and ran 8 times through godot_slot (--who KNOWSTAKES8).
