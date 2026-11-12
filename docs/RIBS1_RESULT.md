# RIBS1 result - the ribs take damage normally

Branch cursor/ribs1. The seat (Cursor) wrote the first commit a33627de and stopped on its usage limit before running
anything. Claude finished it after the review (journal wf_bc4dba34-9c2), with the lead's decisions.

Test: `tests/rib_damage_test.gd`, 200 seeds, 3-round amateur, the real path (LiveRound settles each exchange ->
ExchangeBeats.build -> BodyMap.add_beats). Population: Lucy, orthodox out-boxer (power 58.4, technique 60.1, plan
step_back / pivot_out) vs Priya, orthodox counter-puncher (rating 63.5, threat "right hand counter over the jab").
Arms: default (body share 0.2), body plan ("Go to the body", share 0.5), head only (share 0.08, the control).

## Verdict

**No single RIB_HIT passes every bar.** The value left in the code is **3.1**. At 3.1 every bar of the brief (1a to 1f
except one) passes; the one red bar is the S318 bar "loser hurt 40-90 %", which reads 37.0 %.

- The S318 loser-hurt bar needs RIB_HIT 3.5 or more (43.5 %).
- The brief's "body plan, at or under 35 in at most 20 %" bar needs 3.2 or less (15.0 %; 21.0 % at 3.25).
- Between them, 3.25 and 3.35 fail both bars.

Why the S318 bar fell: main passed it (49.0 %) partly on face damage from punches the ring showed to the head that the
fight rules had settled as body shots. The count match now turns those back into body hooks, so fewer jabs and crosses
reach the eyes and nose. Main showed 21.8 body shots a bout in the default arm, this branch 25.0. Rib damage alone does
not make up for the lost face damage until RIB_HIT reaches about 3.5. The lead decides about the bars. Nothing was loosened.

## Red table: the base code (4893db40's BodyMap.gd + ExchangeBeats.gd, RIB_HIT 1.5) under this test

```
RIB_ARM default liver_mean=83.5 other_mean=100.0 hurt_pct=0.0 critical_pct=0.0 shots_mean=21.8
RIB_DETAIL default more_hit=80.9 more_min=68.5 target_liver=84.0 target_other=100.0 any35=0.0
RIB_ARM body liver_mean=71.7 other_mean=100.0 hurt_pct=14.5 critical_pct=0.0 shots_mean=37.4
RIB_DETAIL body more_hit=63.9 more_min=46.0 target_liver=63.9 target_other=100.0 any35=0.0
RIB_ARM head liver_mean=87.9 other_mean=100.0 hurt_pct=0.0 critical_pct=0.0 shots_mean=15.9
RIB_DETAIL head more_hit=92.6 more_min=85.0 target_liver=92.6 target_other=100.0 any35=0.0
FAIL both rib sides take damage (liver loss 6604.5, other loss 0.0)
FAIL liver side is 100.0% of rib damage (50-70)
FAIL ... body hooks match the settled count within 1 (worst 5, 954 of 1800 rounds fit)
FAIL body plan target more-hit rib at or under 55 in 14.5% (at least 60)
S318 loser_hurt=49.0 doctor=0.0 winner_fine=98.5
RIB_INJURY default_any35=0.0 body_any35=0.0
RIB_SHORT rounds=846 of 1800 worst_gap=6 mean_gap=2.09
RIB_DAMAGE failures=4
```

All three faults show: one side only (other_mean 100.0), too small (body plan hurt 14.5 %), body shots vanish (worst 5).

## RIB_HIT values tried (after the review fixes)

| RIB_HIT | default more-hit (62-82) | default <55 (<=15 %) | body <=55 (>=60 %) | body <=35 (<=20 %) | head ribs (>85) | S318 loser hurt (40-90) | doctor (<=8) | winner fine (>=50) | rib <=35 any (default / body) | failures |
|---|---|---|---|---|---|---|---|---|---|---|
| 3.0  | 68.9 | 0.0  | 65.5 | 12.0 | 90.5 / 95.0 | **37.0** | 0.0 | 99.5 | 0.0 / 12.0 | 1 (*) |
| 3.1  | 67.9 | 1.0  | 65.5 | 15.0 | 90.2 / 94.9 | **37.0** | 0.0 | 99.5 | 0.0 / 15.0 | 1 |
| 3.2  | 66.8 | 1.0  | 65.5 | 15.0 | 89.9 / 94.7 | **37.0** | 0.0 | 99.5 | 0.0 / 15.0 | 1 |
| 3.25 | 66.3 | 6.5  | 76.5 | **21.0** | 89.7 / 94.6 | **38.5** | 0.0 | 99.5 | 0.0 / 21.0 | 2 (*) |
| 3.35 | 65.3 | 6.5  | 76.5 | **21.0** | 89.4 / 94.5 | **38.5** | 0.0 | 99.5 | 0.0 / 21.0 | 2 |
| 3.5  | 63.7 | 15.0 | 84.0 | **30.5** | 89.0 / 94.2 | 43.5 | 0.0 | 99.0 | 0.0 / 30.5 | 1 |

(*) 3.0 and 3.25 ran before the 1b bar took its final form (it then also judged rounds with more combination / big-shot
body hooks than the settled count, worst 2). The rib numbers do not depend on that bar. Read their failures without 1b.

The rib numbers move in steps, not smoothly (3.0 to 3.2 give the same percentages, and so do 3.25 and 3.35). 3.1 sits in
the middle of the 3.0-3.2 step, so it is not on a knife edge. 3.2 is next to the 3.25 step, where the body plan's
critical share jumps to 21 %.

Every run: liver side 66.7 % of rib damage (50-70), both sides take damage, head-only control above 85 on both ribs.

The full lines for each value:

```
== 3.0
RIB_ARM default liver_mean=74.8 other_mean=87.4 hurt_pct=0.0 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=68.9 more_min=55.0 target_liver=78.7 target_other=89.4 any35=0.0
RIB_ARM body liver_mean=60.2 other_mean=79.4 hurt_pct=65.5 critical_pct=12.0 shots_mean=40.1
RIB_DETAIL body more_hit=50.7 more_min=16.0 target_liver=51.2 target_other=75.1 any35=12.0
RIB_ARM head liver_mean=80.6 other_mean=90.1 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=89.4 more_min=73.0 target_liver=90.5 target_other=95.0 any35=0.0
S318 loser_hurt=37.0 doctor=0.0 winner_fine=99.5
RIB_INJURY default_any35=0.0 body_any35=12.0
== 3.1 (final)
RIB_ARM default liver_mean=73.9 other_mean=87.0 hurt_pct=1.0 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=67.9 more_min=53.5 target_liver=78.0 target_other=89.0 any35=0.0
RIB_ARM body liver_mean=58.8 other_mean=78.7 hurt_pct=65.5 critical_pct=15.0 shots_mean=40.1
RIB_DETAIL body more_hit=49.1 more_min=13.2 target_liver=49.5 target_other=74.2 any35=15.0
RIB_ARM head liver_mean=79.9 other_mean=89.7 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=89.1 more_min=72.1 target_liver=90.2 target_other=94.9 any35=0.0
S318 loser_hurt=37.0 doctor=0.0 winner_fine=99.5
RIB_INJURY default_any35=0.0 body_any35=15.0
RIB_MATCH worst=0
RIB_SHORT rounds=846 of 1800 worst_gap=4 mean_gap=1.26
RIB_DAMAGE failures=1
== 3.2
RIB_ARM default liver_mean=73.1 other_mean=86.6 hurt_pct=1.0 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=66.8 more_min=52.0 target_liver=77.3 target_other=88.7 any35=0.0
RIB_ARM body liver_mean=57.5 other_mean=78.0 hurt_pct=65.5 critical_pct=15.0 shots_mean=40.1
RIB_DETAIL body more_hit=47.4 more_min=10.4 target_liver=47.9 target_other=73.4 any35=15.0
RIB_ARM head liver_mean=79.3 other_mean=89.4 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=88.7 more_min=71.2 target_liver=89.9 target_other=94.7 any35=0.0
S318 loser_hurt=37.0 doctor=0.0 winner_fine=99.5
RIB_INJURY default_any35=0.0 body_any35=15.0
== 3.25
RIB_ARM default liver_mean=72.7 other_mean=86.3 hurt_pct=6.5 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=66.3 more_min=51.3 target_liver=76.9 target_other=88.5 any35=0.0
RIB_ARM body liver_mean=56.8 other_mean=77.6 hurt_pct=76.5 critical_pct=21.0 shots_mean=40.1
RIB_DETAIL body more_hit=46.6 more_min=9.0 target_liver=47.1 target_other=73.0 any35=21.0
RIB_ARM head liver_mean=78.9 other_mean=89.3 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=88.5 more_min=70.8 target_liver=89.7 target_other=94.6 any35=0.0
S318 loser_hurt=38.5 doctor=0.0 winner_fine=99.5
RIB_INJURY default_any35=0.0 body_any35=21.0
== 3.35
RIB_ARM default liver_mean=71.8 other_mean=85.9 hurt_pct=6.5 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=65.3 more_min=49.8 target_liver=76.2 target_other=88.2 any35=0.0
RIB_ARM body liver_mean=55.5 other_mean=77.0 hurt_pct=76.5 critical_pct=21.0 shots_mean=40.1
RIB_DETAIL body more_hit=45.0 more_min=6.2 target_liver=45.5 target_other=72.1 any35=21.0
RIB_ARM head liver_mean=78.3 other_mean=88.9 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=88.2 more_min=69.9 target_liver=89.4 target_other=94.5 any35=0.0
S318 loser_hurt=38.5 doctor=0.0 winner_fine=99.5
RIB_INJURY default_any35=0.0 body_any35=21.0
== 3.5
RIB_ARM default liver_mean=70.6 other_mean=85.3 hurt_pct=15.0 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=63.7 more_min=47.5 target_liver=75.2 target_other=87.6 any35=0.0
RIB_ARM body liver_mean=53.5 other_mean=75.9 hurt_pct=84.0 critical_pct=30.5 shots_mean=40.1
RIB_DETAIL body more_hit=42.5 more_min=2.0 target_liver=43.0 target_other=70.9 any35=30.5
RIB_ARM head liver_mean=77.3 other_mean=88.4 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.3
RIB_DETAIL head more_hit=87.6 more_min=68.5 target_liver=89.0 target_other=94.2 any35=0.0
S318 loser_hurt=43.5 doctor=0.0 winner_fine=99.0
RIB_INJURY default_any35=0.0 body_any35=30.5
```

Rib injuries: fighter "a" is the one InjuryRoll reads. In the default arm no bout ends with a rib at 35 or under (0.0 % at
every value). In the body plan arm the share at 3.1 is 15.0 %, against 0.0 % on main. The rib-injury weight triples in
those bouts. Check the injury rate at collect.

## Fixed after the review

1. **Clinch rib digs removed (the smallest fix).** The game never feeds a clinch beat to BodyMap: BeatFire sends "clinch"
   to the stage and BodyLive.land takes punches only. ExchangeBeats `_rib_want` is deleted, so the last pass uses the full
   body count. BodyMap's clinch branch and `_clinch_ribs` are deleted. The test's `_rib_digs` is deleted.
2. **The last pass retags singles only.** ExchangeBeats `_body` is back to main's version: free singles only, never a
   combination punch or a big shot. The `widen` path and `_body_pool` are gone, and the last pass is one more
   `_body(out, x["body"])` call after every punch type is final.
   - Bar 1b judges only the rounds the singles can reach. In every exchange, the combination and big-shot body hooks
     must be at most the settled count, and those plus the free singles must be at least the count.
   - The rest print as `RIB_SHORT` and are not judged: 846 of 1800 rounds at 3.1, worst gap 4, mean 1.26.
3. **Mixed stances follow PaceAim.** The 60 % side is the DEFENDER's liver side: right ribs when she is orthodox, left
   when she is southpaw. `_punch_hits` takes an optional `def_south` (ComboStrip's two-argument call is unchanged). Two
   orthodox boxers are unchanged.
4. **callout_pop_test line 142** now reads `"LIVER %d - one body hook" % roundi(100.0 - BodyMap.RIB_HIT)` instead of a
   typed 99.
5. **body_map_test** has a 200-beat loop for all four stance pairs. It checks that the defender's liver side gets 50-70 %
   of the hits (59.5 % measured) and the other side gets some. Body hooks go 20 to a fresh map, so a rib never floors at 0.
6. **RIB_HIT tuned and measured:** 3.1, see the table. The comment names the run.
7. **rib_damage_test is in tools/run_tests.sh** (TESTS, after body_map_test).

## NOT fixed

- **The S318 loser-hurt bar** (37.0 % against 40-90) fails at the chosen value. No RIB_HIT passes it together with the
  body plan's critical bar. This is the lead's call.
- **callout_pop_test test 5** goes red: 2 failures, "her holo is on screen on the card" and "the LIVER line tells the
  body hook she took".
  - Cause: its fixture body hook (`_corner`, line 178, t=20.0, who "b") now hashes to the LEFT ribs (left_ribs 93.8),
    while the asserts read right_ribs / LIVER.
  - It is green on main, where every hook went to the right ribs.
  - The file is outside this task except line 142, so it was not touched.
  - One-line fix for the lead: add `"side": "right"` to that fixture beat (a carried side wins in BodyMap).
- **Rounds the ring cannot match.** 846 of 1800 rounds have exchanges whose settled body count is out of reach of the free
  singles (too few singles, or more combination / big-shot body hooks than the count). They stay short by design
  (singles only).
- **Words-only and skipped bouts** still carry no body map. That is the redesign's job (DAMAGE_MAP_S437).
- **The exact 2:1 split.** In the game path the liver share reads exactly 66.7 % at every value: 3,362 liver hits to 1,681
  other hits on the default arm. The unit loop gives 59.5 %. It is inside the 50-70 bar, but an exact 2:1 is odd and was
  not traced. It may be the small set of beat times the hash sees.

## S438, at collect (Claude)
The count match took head damage away (punches the ring used to show to the face are body hooks again), so the S318
"loser hurt" share fell from 49 % to 37 % at any rib value. That is the face numbers' old calibration, not the ribs:
FACE_HIT and HEAD_HIT were re-measured against the same S318 bars with RIB_HIT 3.1.

| FACE_HIT / HEAD_HIT | real path: loser hurt (40-90) | unit list (body_map test 5, 40-90) | every other bar |
|---|---|---|---|
| 1.1 / 0.55 (old) | 37.0 % FAIL | pass | pass |
| 1.2 / 0.6 | 58.0 % | 92 % FAIL | pass |
| **1.15 / 0.575 (kept)** | 45.0 % | 82 % | pass (body plan rib at or under 35: 15.0 %) |

The corner-minute fixture in callout_pop_test carries `"side": "right"` (a carried side wins), so its liver checks hold.
Still open: in 846 of 1800 rounds the settled body count is larger than the free single punches, so the ring shows
fewer body shots than the fight rules settled (worst gap 4). Combination punches are not retagged on purpose.

## S439, after the merge with S433 PUNCHSTART1 (Claude, the lead's ruling)
The lead kept PUNCHSTART1 (one punch rule for both corners) and kept the S318 and RIBS1 bars, so the hit sizes were
re-measured on the merged tree, as S438 did after the count match. The test now judges its two near-the-bar rates on the
MEAN of eight disjoint 200-day windows (days 1000..2599, `RIB_WINDOW` lines); every other check reads the first window as
before.

Method: `tools/rib_sweep.gd` plays the test's three arms over the eight windows once (4,800 bouts), keeps the ring beats,
and replays them through a copy of `BodyMap.add_beats` with the three sizes as parameters (nothing in the fight reads the
map, so the beats do not move; the copy matched BodyMap on every bout, `SWEEP_COPY mismatches=0`). It also replays
body_map_test's test 5 (the unit list).

Red first, at the old sizes (1.15 / 0.575 / 3.1), the new test on the branch tip:
```
FAIL body plan target more-hit rib at or under 35 in 21.1% (at most 20; mean of 8 windows: 20.0 20.5 24.5 23.0 26.5 16.5 21.5 16.0)
FAIL S318 loser hurt 36.6% (40-90; mean of 8 windows: 40.0 40.0 30.0 35.0 33.5 37.5 35.5 41.0)
RIB_DAMAGE failures=2
```

Ribs (the body-plan reads depend on RIB_HIT only; eight-window means):

| RIB_HIT | body plan rib <= 35 (<= 20; target <= 17) | body plan rib <= 55 (>= 60) | default more-hit (62-82) | default any rib <= 35 | head-only ribs (> 85) |
|---|---|---|---|---|---|
| 2.7 / 2.8 | 4.0 / 6.8 | 58.7 FAIL | 73.3 / 72.3 | 0.0 | 91.4 / 91.0 |
| **2.85-2.95** | **9.8** | **67.9** | 71.8-70.8 | 0.0 | 90.7 / 95.4 |
| 3.0-3.05 | 14.7 | 77.6 | 70.3-69.8 | 0.0 | 90.3 / 95.2 |
| 3.1-3.2 (old) | 21.1 FAIL | 77.6 | 69.3-68.3 | 0.0 | 90.1 / 95.1 |
| 3.3 | 29.4 FAIL | 85.9 | 67.4 | 0.0 | 89.4 / 94.8 |

2.9 kept: the body plan's hurt rate 67.9 % is the one nearest RIBS1's 65 %; 3.0-3.05 also clears the critical bar (14.7)
but hurts 77.6 %. In whole hooks 2.9 sits in 2.83-2.95 (hurt at 16 hooks, critical at 23).

Face and head (RIB_HIT 2.9; real path = default arm, eight-window mean; unit list = body_map test 5, 300 seeds):

| FACE_HIT / HEAD_HIT | real path loser hurt (40-90; target >= 43) | unit list loser hurt (40-90) | unit list winner fine / head lowest |
|---|---|---|---|
| 1.15 / 0.575 (S438) | 36.1 FAIL | 82.0 | 92.3 / 25.0 |
| 1.16 / 0.58 | 41.6 | 86.7 | 87.7 / 26.0 |
| 1.17 / 0.585 | 42.8 | 88.7 | 87.0 / 22.7 |
| **1.18 / 0.59 (kept)** | **43.4** | **89.3** | 87.0 / 26.0 |
| 1.185 / 0.5925 | 48.6 | 92.3 FAIL | 84.0 / 23.3 |
| 1.20 / 0.60 | 49.1 | 92.3 FAIL | 84.0 / 22.7 |
| 1.25 / 0.625 | 63.0 | 96.7 FAIL | 68.7 / 26.0 |

Off the 2:1 ratio (same replay): every pair that lifts the real path to 43 or more puts the unit list at 88.7 or above
(best: 1.20 / 0.55, 43.9 and 88.7; 1.10 / 0.61, 44.0 and 90.0; 1.15 / 0.61, 45.6 and 91.0). So the ratio buys nothing and
2:1 stays. On the real path doctor is 0.0 % at every row and winner fine 95.5 % or more (98.8 % at the kept row).

THE CATCH, stated: the real path's 43 and the unit list's 90 nearly meet. 1.18 / 0.59 is the only 2:1 step that holds
both, and it holds the unit list by 0.7 (89.3 against 90; that list is fixed seeds, so it moves only when code moves). A
small rise in face damage from any later change will fail body_map test 5 first. One window of eight still reads under
40 (window 2: 38.0); the bar is on the mean.

Final run (tests/rib_damage_test.gd at 1.18 / 0.59 / 2.9):
```
RIB_ARM default liver_mean=75.7 other_mean=87.8 hurt_pct=0.0 critical_pct=0.0 shots_mean=25.0
RIB_DETAIL default more_hit=70.5 more_min=56.5 target_liver=78.5 target_other=88.9 any35=0.0
RIB_ARM body liver_mean=60.6 other_mean=79.6 hurt_pct=64.0 critical_pct=11.0 shots_mean=41.0
RIB_DETAIL body more_hit=50.0 more_min=18.8 target_liver=50.5 target_other=74.4 any35=11.0
RIB_ARM head liver_mean=81.4 other_mean=90.6 hurt_pct=0.0 critical_pct=0.0 shots_mean=19.1
RIB_DETAIL head more_hit=89.2 more_min=73.9 target_liver=90.2 target_other=95.0 any35=0.0
RIB_WINDOW 0 days 1000..1199 body_crit=11.0 loser_hurt=45.0
RIB_WINDOW 1 days 1200..1399 body_crit=6.0 loser_hurt=45.5
RIB_WINDOW 2 days 1400..1599 body_crit=11.5 loser_hurt=38.0
RIB_WINDOW 3 days 1600..1799 body_crit=10.5 loser_hurt=41.0
RIB_WINDOW 4 days 1800..1999 body_crit=13.0 loser_hurt=41.5
RIB_WINDOW 5 days 2000..2199 body_crit=9.5 loser_hurt=46.5
RIB_WINDOW 6 days 2200..2399 body_crit=11.0 loser_hurt=41.0
RIB_WINDOW 7 days 2400..2599 body_crit=5.5 loser_hurt=49.0
PASS body plan target more-hit rib at or under 35 in 9.8% (at most 20; mean of 8 windows)
PASS S318 loser hurt 43.4% (40-90; mean of 8 windows)
S318 loser_hurt=45.0 (first window; mean 43.4) doctor=0.0 winner_fine=99.0
RIB_INJURY default_any35=0.0 body_any35=11.0
RIB_MATCH worst=0
RIB_SHORT rounds=850 of 1800 worst_gap=4 mean_gap=1.25
RIB_DAMAGE failures=0
```
body_map_test: `t5: loser_hurt=89% doctor=0% winner_fine=87% head_lowest=26%`, BODY_MAP failures=0. callout_pop_test
(LIVER line from RIB_HIT) CALLOUT_POP failures=0. Rib injuries: the body plan arm's share of bouts with a rib at 35 or
under falls from 15.0 % (S438, one window) to 11.0 % (first window; 9.8 % over eight).
