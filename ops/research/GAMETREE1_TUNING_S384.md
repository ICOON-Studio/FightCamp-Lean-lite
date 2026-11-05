# GAMETREE1 stage 1 - tuning log (bars 1-8, 11, 13, 14, 16)

Tool: `tools/bjj_tree_balance.gd` (populations in `tools/bjj_tree_tally.gd`). Only the design 10.5 [T] values
(BjjTree.T0, BjjOpp.T0) move; research rows, overrides, finish_w (bar the UNVERIFIED back), IBJJF points stay fixed.
NoGi.win_chance untouched (no_gi_test / drill_pick_test numbers unchanged).

## Pass 0 - the design's start values (seeds 100, bar 1d 300 bouts a share)

T: TAP 10, EPS .2, STYLE_W 2, LATE_S 60, MOOD_W 5, MF_CEIL 1.8, ENTRY .5, TRANSITION .4, ESCAPE .3, BACK_PRO .35,
TAKEDOWN .33, BACK_FINISH_W .36, BEAT_S 22, FELT 15, ROLL_EVERY 2, PLAN_PULL 2, CHAIN 1.15, READ_W .6, D_NONE .7;
BjjOpp OWNED_M 30-50, CLASS_SHARE .4-.9, ROUTE_M 50-70, UNOWNED_M 5-28, LEAN_W 2.

| bar | value | |
|---|---|---|
| 1a win vs white field | 0.507 (win_chance 0.543) | PASS |
| 1b open wins / golds per 400 | 0.83 / 40 | PASS (edge) |
| 1c morale 100 / 20 | +0.100 / -0.117 | PASS |
| 1d shares .25/.5/.64/1.0 | .470/.513/.550/.727 vs .425/.500/.543/.650 | FAIL (1.0 +0.077) |
| 2 leaks | back_bottom, turtle_bottom, kimura_trap_defend; 15 holes visited | FAIL (15 > 14) |
| 3a brown sub rate | 0.850 | FAIL |
| 3b chokes/arms/legs | .66/.01/.33 | FAIL |
| 3c brown top finish | rear naked choke | PASS |
| 3d white sub rate, top | 0.390, americana | FAIL (RNC not top) |
| 4a brown sub att/min | 0.744 | PASS |
| 4b white sub att/bout | 1.77 | FAIL |
| 5 brown scoring | back top, mount/pass .53 | PASS |
| 6 conversion back/saddle/50-50/mount/side/kob | .35/1.00/.00/.04/.13/.00 | FAIL |
| 7 late lead tapped | 0.042 | PASS |
| 8 black legs/chokes, mean sub | 1.01, 3.3 min | FAIL |
| 11a misses to 3+ | 0.016 | PASS |
| 11b top edge share | 0.302 | PASS |
| 11c wrestler/guard/pull/land | 1.00/.84/.54/.95 | PASS |
| 13 ahead weeks | 3/6/12, readiness same | PASS |
| 14 pace | 2.11 weeks, gap 5, 16 rolls | PASS |
| 16 first scorer wins | 0.636 | FAIL |

Reading: brown bouts finish too often and too early (82% subs, 3.3 min mean on 10 min) - misses slide (every brown owns
the answers, so P_bad = 1) into scrambles, and arm drag -> back -> RNC .35 runs away; arm locks almost never finish.

## Pass 1-2 - bar definitions settled; random searches (search2.log 50 points, search3.log 91 points, 15-19 [T] dims)

- Bars 3d and 4b ("White field" / "white 5 min") now read an EVEN white field (two generated white athletes, like the
  brown one); Ana's white field stays for bars 1, 2, 7, 11.
- Bar 1d's Ana-at-a-share = the least change from her start (classes = share x 200; the closest unowned syllabus moves
  lifted to 30 / the lowest owned set back to 29). The first build shifted every mastery and over-read share 1.0.
- D_NONE sweep, bar 1d (600 bouts a share): 0.70 -> worst 0.103, 0.85 -> 0.072, 1.00 -> 0.050. A felt answer at 19.5
  counting x1.43 for the attacker made the class-time burst at 200 classes (20 tree moves owned at once) too steep.
- fit.py (per-metric linear fit over the search points), what moves what:
  - 3a sub rate, 4a attempts/min, 4b white attempts/bout all fall with BEAT_S; 8 mean sub time rises with it.
  - 4b (mean 1.2, band 2-4) never reached 2 in 141 points; 8 mean sub time never passed 5.1 min (band 6-9).
  - arm-lock share mean 0.05 (band 0.24-0.36), best 0.14; levers only BASE_BACK_PRO down, TAP_VALUE up.
  - 50/50 conversion 0 in every point: the walk reaches fifty_fifty about once in 150 bouts.
  - mount conversion 0-0.03 in every point: from mount the chooser takes giftwrap -> back (4 + back value) over a 0.16 sub.

## Pass 3 - first full table on a candidate (seeds 200, 1d 900 bouts a share)

BEAT_S 33, TAP 12, TRANSITION .45, ENTRY .33, BACK_PRO .20, D_NONE .85, CHAIN 1.2, EPS .1, PLAN_PULL 1.5,
OWNED_M 28-55, UNOWNED_M 12-26, CLASS_SHARE .5-.9 (rest as pass 0):
1a .543 P | 1b .99/64 P | 1c +.125/-.123 P | 1d worst .044 P | 2 15 holes F | 3a .595 P | 3b .56/.03/.40 F | 3c kneebar F |
3d .235 americana F | 4a .450 F | 4b 1.28 F | 5 back .70 P | 6 .30/0/0/0/.07/0 F | 7 .012 P | 8 .93 4.4 min F |
11a .006 P | 11b .279 P | 11c 1.00/.93/.64/.94 F (pulls .64) | 13 P | 14 2.11/5/16 P | 16 .744 F -> 11 of 21.

## Final state - S386 (seeds 400, bar 1d 2000 bouts a share)

Current T0 values (BjjTree.gd line 38-41):
T: TAP 20, EPS .17, STYLE_W 2, LATE_S 60, MOOD_W 4, MF_CEIL 1.4, ENTRY .42, TRANSITION .45, ESCAPE .30, BACK_PRO .30,
TAKEDOWN .33, BACK_FINISH_W .36, BEAT_S 33, FELT 15, ROLL_EVERY 2, PLAN_PULL 1.5, CHAIN 1.1, READ_W .6, D_NONE .9;
BjjOpp OWNED_M 30-45, CLASS_SHARE .5-.9, ROUTE_M 50-70, UNOWNED_M 11-26, LEAN_W 2.

| bar | value | |
|---|---|---|
| 1a win vs white field | 0.527 (win_chance 0.543) | PASS |
| 1b open wins / golds per 400 | 1.02 / 67 | PASS |
| 1c morale 100 / 20 | +0.118 / -0.081 | PASS |
| 1d shares .25/.5/.64/1.0 | worst 0.049 | PASS |
| 2 leaks | back_bottom, turtle_bottom, kimura_trap_defend; 14 holes | PASS |
| 3a brown sub rate | 0.655 | UNMET (band 0.45-0.60) |
| 3b chokes/arms/legs | .63/.07/.31 | UNMET (arms .07 vs .24-.36) |
| 3c brown top finish | rear_naked_choke | PASS |
| 3d white sub rate, top | 0.188, americana | UNMET (band 0.30-0.55) |
| 4a brown sub att/min | 0.507 | PASS |
| 4b white sub att/bout | 1.24 | UNMET (band 2-4) |
| 5 brown scoring | back 0.34, mount/pass in band | PASS |
| 6 conversion back/saddle/50-50/mount/side/kob | .27/.32/.00/.00/.15/.00 | UNMET (50-50 and mount 0) |
| 7 late lead tapped | 0.029 | PASS |
| 8 black legs/chokes, mean sub | 1.11, 4.4 min | UNMET (legs/chokes 0.5-0.75, time 6-9) |
| 11a misses to 3+ | 0.007 | PASS |
| 11b top edge share | max 0.273 | PASS |
| 11c wrestler/guard/pull/land | 1.00/.83/.59/.94 | PASS |
| 13 ahead weeks | [3, 6, 12], readiness same | PASS |
| 14 pace | 2.11 weeks, gap 5, rolls 16 | PASS |
| 16 first scorer wins | 0.679 | UNMET (band 0.80-0.87, not gated in stage 1) |

**14 of 21 bars pass. 7 bars UNMET.**

The UNMET bars are "open" in tests/bjj_tree_sim_test.gd (printed but not gated). The tuning doc's pass 1-2 search
(141 points in the [T] space) found:
- 4b (mean 1.2) never reached 2 in the search; 8 mean sub time never passed 5.1 min (band 6-9).
- arm-lock share mean 0.05 (band 0.24-0.36); 50/50 conversion 0 in every point (the walk reaches fifty_fifty ~once in 150 bouts).
- mount conversion 0-0.03: from mount the chooser takes giftwrap -> back over a 0.16 sub.

These bars need stage-2 work (film, more routes, position-specific tuning) or design changes. Stage 1's gated bars
(1-2, 3c, 4a, 5, 7, 11, 13, 14) all pass.

## Before/after table (stage 1 tuning)

| constant | design start | stage 1 final | bars moved |
|---|---|---|---|
| TAP_VALUE | 10 | 20 | 1b, 2 |
| EPS | 0.2 | 0.17 | 11b |
| MOOD_W | 5 | 4 | 1c |
| MF_CEIL | 1.8 | 1.4 | 1d |
| BASE_ENTRY | 0.50 | 0.42 | 11c |
| BASE_TRANSITION | 0.40 | 0.45 | 5 |
| BASE_BACK_PRO | 0.35 | 0.30 | 3b (partial) |
| BEAT_S | 22 | 33 | 3a, 4a, 8 |
| PLAN_PULL | 2 | 1.5 | 11c |
| CHAIN | 1.15 | 1.1 | 1d |
| D_NONE | 0.7 | 0.9 | 1d |
| OWNED_M | 30-50 | 30-45 | 1d |
| UNOWNED_M | 5-28 | 11-26 | 1d |
| CLASS_SHARE | 0.4-0.9 | 0.5-0.9 | 1d |
