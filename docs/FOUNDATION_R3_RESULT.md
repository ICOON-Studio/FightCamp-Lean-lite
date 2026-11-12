# Foundation fixes, round 3 (CARDIO1, NOCAMP1) - result

Branch `claude/foundation-s433` in E:/FightCamp/wt/LEAN_FOUNDATION_S433 (pushed after round 4). Written from the final runs on the
branch tip (after the merge with main e0ffbc0b and the round-3 commits).

## The merge
- `git merge origin/main` (e0ffbc0b, 88 commits): one conflict, `tools/run_tests.sh` - main's line kept, then
  `plan_chain_test punch_start_test` after `bout_read_test`. Main had not touched any file the branch changes.
- Broken by the merge and fixed: main's new `tests/rib_damage_test.gd` called `BoutNight._peak(f)`; the branch's Tank
  takes the career (`_peak(c, f)`), so the test failed to parse. Both calls now pass `c`. Green after (RIB_DAMAGE failures=0).
- Note: rib_damage_test's "body plan target more-hit rib at or under 35" reads 20.0% against its "at most 20" on the
  merged tree - on its bar, not over it. Not touched (main's test, main's numbers).

## CARDIO1
- (a) FIXED. The Cardio camp card's Stamina end now reads the forecast's own Stamina: `CampForecast.run` returns her
  attributes on fight night (`attrs`, trained day by day as `Sim.step_day` trains them), `Camp.gd` hands them to
  `CampCard.card`, and `CampCard.line_numbers` takes the end from them (no more "Stamina now + the mean's gain"; the
  Cardio camp's roadwork and intervals train Stamina by name, so Stamina moves more than the mean). New
  `tests/cardio_camp_test.gd` (golden path's Lucy, Cardio camp, the real days stepped to fight night):
  red on the old code - card 60.57, fight night 62.43 (gap -1.86); green now - card 62.43, fight night 62.43 (gap 0.00).
- (b) NOT RESTORED, stated. The share is held (fading bouts at fight time, 1,030 amateur bouts of 206 signings, own week:
  63.6% at line 60 against main's 64.6%). The size is not: a fading bout loses 1.487 (main a flat 1.0), every bout 0.946
  (main 0.646). Why: signings start with Stamina 5 under the old mean (Attrs.from_stats; the 206 sign at Stamina 53.3
  against conditioning 58.1), so a fading bout sits about 6 points under the line (1.487 / 0.25 = 5.9), and the slope
  charges 0.25 a point up to 2. Which is intended: the brief's F3 spec column gives the slope (0.25 a point, at most 2,
  tested by cardio_line_test) and asks FADESHARE for the share; only its risk line said "share and size", and the same
  line expects "Stamina under 60 cost more than today". Holding main's size too needs 0.17 a point (OWN_FADE 0.68),
  which breaks the spec's own slope (2 under the line: 0.34, not 0.5). Decision: keep the slope; the risk line in
  TRAINING_MAP now says the share is held and the size is not, with these numbers. (fade_share.gd re-run on the merged
  tree: the same table.) For the lead: if the deep fade is too costly in play, the knob is OWN_FADE, not the line.
- (c) FIXED. The Stamina row prints its line on the row: `BoutRules.fade_row` ("fade 0.90 · none at 60", or "no fade ·
  line 60") in small words under the Stamina row on both attribute boards (AttrBoard and DarkOverview through
  `AttrBoard.with_line`); the sentence stays on hover. attr_board_test red before (2 FAILs, tab 0 and tab 1: the line only
  in the tooltip), green now. Not seen in a still (no render this round).
- (d) FIXED. TRAINING_MAP_S432 (the F3 row and its test column, the defect row, Samira's Stamina row, T36 twice, T17, the
  intervals card, the fade per point, the numbers list, the risk line) and CORE_LOOP_MAP_S432 C3 say 60, each marked as
  moved by S434 FADESHARE. fighter_model_speed_test's comment said "from Stamina 59 (Lucy 0.65)": now 60 (0.90). No
  other stale 59 found in scripts, tests or tools.

## NOCAMP1
- (a) FIXED. New `tests/nocamp_page_test.gd`: the golden path's Lucy, no camp, her bout moved to 7 days out (the
  amateur fight week, SCOPE S428), read on FighterPage tab 5 (FightPrep._tale -> CampForecast.for_read -> BoutRead.band)
  fresh (tiredness 20, no bout behind her) and worn (tiredness 80, a bout 4 days ago).
  Red on main e0ffbc0b's code (the branch's scripts swapped back to main's for the run, then restored byte for byte):
  `FAIL: a worn no-camp fighter reads a lower chance on the bout page: about 54% against 54% fresh`,
  `FAIL: CampForecast.for_read exists`, `FAIL: fight night plays a Tank of 0.00, the page read -1.00`.
  Green here: about 57% fresh / 47% worn; the page's 7 to 86% is the band on fight night's Tank 24.00 (her own week's
  forecast 24.00); stepping the real days, fight night plays a Tank of 24.00.
- (b) MEASURED, bar not moved. After the merge the test's window (days 40..579) reads 494 of 540 (was 487 before the
  merge). Ten disjoint 540-bout windows (tools/nocamp_probe.gd `why 540 <start>`, days 40..5439, 5,400 bouts):
  this branch 4,861 (0.900; windows 494 497 479 491 486 477 487 479 486 485, sd 6.3, four of ten under the 486 bar);
  main e0ffbc0b 4,823 (0.893; 494 489 488 473 478 473 487 472 480 489, five of ten under). The window was not fitted
  (its start predates NOCAMP1; S434 chose its size), but the margin is not real: the true rate is the bar. The test's
  comment says so; whether nine in ten stays the target is a design call for the lead.
- (c) NOTES, out of scope: the opponent's Tank is still `Combos.TANK` (she pays no Tank of her own: F5); weight left to
  the day never costs Tank on an amateur bout (it needs the same-day weigh-in, which does not exist).

## The daily list
`tools/run_tests.sh` now carries plan_chain_test punch_start_test cardio_line_test cardio_path_test cardio_camp_test
legs_scale_test nocamp_page_test.

## Final runs (one at a time through godot_slot, no SCRIPT ERROR in any)
| Test | Pass line |
|---|---|
| attr_board_test | PASS attr_board_test |
| bout_read_test | BOUT_READ PASS |
| bout_rules_test | BOUT_RULES checks=44 failures=0 |
| camp_cards_test | CAMP_CARDS failures=0 |
| camp_protocol_test | CAMP_PROTOCOL failures=0 |
| cardio_line_test | CARDIO_LINE checks=25 failures=0 |
| cardio_path_test | CARDIO_PATH checks=8 failures=0 |
| exchanges_test | EXCHANGES failures=0 (wrong calls 0.1130 vs 0.2685, 2,000 bouts) |
| fight_why_test | PASS fight_why_test (good plan graded good 494 of 540, bad 4) |
| fighter_goal_test | FIGHTER_GOAL failures=0 |
| fighter_model_speed_test | FIGHTER_SPEED failures=0 |
| gauges_test | GAUGES PASS |
| legs_scale_test | LEGS_SCALE failures=0 |
| night_line_test | NIGHT_LINE checks=27 failures=0 |
| plan_bots_test | PLAN_BOTS checks=26 failures=0 |
| plan_chain_test | PLAN_CHAIN failures=0 |
| punch_start_test | PUNCH_START failures=0 (first offers 25.7 in 100) |
| week_read_test | WEEK_READ failures=0 |
| week_twist_test | WEEK_TWIST PASS |
| golden_path_test | GOLDEN_PATH failures=0 |
| cardio_camp_test (new) | CARDIO_CAMP failures=0 |
| nocamp_page_test (new) | NOCAMP_PAGE failures=0 |
| rib_damage_test (main's, fixed for the merge) | RIB_DAMAGE failures=0 |
| words_on_screens_test | WORDS_ON_SCREENS failures=0 |
| menus_round4_test | MENUS_ROUND4 PASS |
| roster_slate_test | ROSTER_SLATE failures=0 |

Also green right after the merge (not re-run after round 3, untouched by it): punch_form_rules_test, roster_row_test,
head_aim_test, voice_lines_test, rib_injury_test.

## Ready to merge (S439 merge prep, from the final runs below)
- MERGE: `git merge origin/main` (10 new commits: the result page's damage marks, Aftermath, AfterFight, BodyCallouts,
  FaceMarks, ResultMarks, FightNight, BoutMarks and their tests). No conflict. No new caller of `BoutNight._peak` on
  main's side (the only callers are BoutNight itself and rib_damage_test, both already `_peak(c, f)`).
- STAMINA ROW CAPTION: `BoutRules.fade_row` now reads "From round 3: every stat 0.74 lower; Stamina 60 stops it" (or
  "From round 3: no stat lost (Stamina 60 or more)"). The number is `own_fade`: points off every stat (fight strength
  is their plain average) in round 3 on (`play_round`/LiveRound, n >= ROUNDS). attr_board_test expects the new line
  and rejects the old "none at 60"; words_on_screens_test now reads the overview's RowLine labels (the new line, no
  "fade").
- NOCAMP_PAGE CHECK 2: the half that compared `CampForecast.for_read`'s tank_ahead with `CampForecast.run` on the same
  inputs (the forecast with itself) is DELETED; check 2 keeps tank_ahead > 0 and the band; check 3 holds the page's
  Tank to the Tank the played bout opens with (24.00 vs 24.00).
- RIB_DAMAGE SPREAD - A FINDING, NO BAR MOVED. `tools/rib_spread.gd` (the test's three arms on another 200-day window,
  `from=<day>`; the test's own window is 1000..1199). Eight disjoint windows, 1000..2599, 1,600 bouts an arm:

  | Tree | "body plan ... at or under 35" (bar at most 20) | "S318 loser hurt" (bar 40-90) | windows failing |
  |---|---|---|---|
  | branch | 20.0 20.5 24.5 23.0 26.5 16.5 21.5 16.0 (mean 21.1) | 40.0 40.0 30.0 35.0 33.5 37.5 35.5 41.0 (mean 36.6) | 6 of 8 |
  | main's scripts swapped in | 15.0 11.0 16.5 14.5 16.5 12.5 12.5 13.0 (mean 13.9) | 45.0 48.0 41.0 46.0 46.0 45.5 41.0 49.0 (mean 45.2) | 0 of 8 |

  The test's window passes on the branch only by sitting on both bars; its true rate is outside both. (One window's
  sd at these rates is about 2.8 to 3.5 points, so the eight-window means are the read.)
  WHY (each a one-factor swap on the branch, eight windows, files restored byte for byte after):
  | Swap | body crit mean | loser hurt mean |
  |---|---|---|
  | none (branch) | 21.1 | 36.6 |
  | the Tank: not a cause here - the test's bouts start with Tank 0.00 (no results, default tiredness) | - | - |
  | fade back to main's rule (conditioning under 59; Lucy 61.6 = none; on the branch Stamina 56.4 = 0.90) | 22.0 | 36.4 |
  | energy spend/refill on conditioning instead of Stamina/Recovery | 21.3 | 36.5 |
  | Lucy's punches on main's rule (Attrs without PunchStart) | 20.4 | 37.9 |
  | the opponent's punches on main's rule (AttrGen without PunchStart) | 18.3 | 40.0 |
  | both punch rules on main's | 17.1 | 41.3 |
  | all of main's scripts | 13.9 | 45.2 |
  So S433 PUNCHSTART1 (punches start from the raw floor and the novice opponent carries a new signing's gaps) moves
  about 4 of the 7 points on each check, mostly through the opponent's punches; the rest (about 3 body, 4 loser hurt)
  is not explained by any single factor above (the CARDIO1 fade and energy swaps alone move under 1) and was not
  bisected further.
  RECOMMENDATION for the lead: do not merge with this test green by luck. Either (a) rule that PUNCHSTART1's weaker
  novice opponent is meant to take more body damage and lose with less on him, and re-ground the two bars from a
  multi-window read on the merged tree (the body bar would need about 26.5, the loser floor about 30, to hold all
  eight windows - a design call, not made here); or (b) treat it as a defect of the punch start against the RIBS1/S318
  targets and bisect the remaining ~3 points first. Also: main's own loser-hurt margin is thin (two of eight windows at
  41.0 against 40), so a single 200-bout window is a weak gate on either tree.
- CAUGHT IN THE FINAL RUN AND FIXED: the longer plain-words Stamina line widened the fighter Overview past 1920
  (roster_slate_test: 32 FAILs, "DarkOverview is wider than 1920 (1949 at x 1977)"). The row's caption label now wraps
  (`AttrBoard.with_line`, AUTOWRAP_WORD_SMART); roster_slate, attr_board, words_on_screens, menus_round4 and golden_path
  re-run green after it. Not seen in a still (no render this round).

### Final runs (merge prep; one at a time through godot_slot, no SCRIPT ERROR in any)
All 26 of the round-3 list plus result_marks, bout_marks and fight_stats (main's new tests):
attr_board PASS attr_board_test; bout_read BOUT_READ PASS; bout_rules checks=44 failures=0; camp_cards failures=0;
camp_protocol failures=0; cardio_line checks=25 failures=0; cardio_path checks=8 failures=0; exchanges failures=0;
fight_why PASS; fighter_goal failures=0; fighter_model_speed failures=0; gauges PASS; legs_scale failures=0;
night_line checks=27 failures=0; plan_bots checks=26 failures=0; plan_chain failures=0; punch_start failures=0;
week_read failures=0; week_twist PASS; golden_path failures=0; cardio_camp failures=0; nocamp_page failures=0;
rib_damage failures=0 (on its bars, see the finding above); words_on_screens failures=0; menus_round4 PASS;
roster_slate failures=0 (after the wrap fix); result_marks failures=0; bout_marks failures=0; fight_stats failures=0.
Ready to merge EXCEPT the rib_damage finding, which needs the lead's ruling first.

## S439 round 4 - the lead's ruling on rib_damage, applied
RULING: PUNCHSTART1 stays (one punch rule for both corners); the S318 and RIBS1 targets stay; the damage numbers are
re-measured on the merged tree and the test stops depending on one window.
- MERGE: `git merge origin/main` (12 commits: FaceMark3D + face_mark3d_test, the S439 result page mockups and research).
  One conflict, `tools/run_tests.sh`: main's line (with face_mark3d_test) plus the branch's seven tests after
  bout_read_test (the union, 283 names). No other file overlapped.
- TEST: `tests/rib_damage_test.gd` judges "body plan target more-hit rib at or under 35" (at most 20) and "S318 loser
  hurt" (40-90) on the MEAN of eight disjoint 200-day windows (days 1000..2599), every window printed (`RIB_WINDOW`); its
  other checks read the first window as before (the counters of the extra windows are dropped). Bars not moved. Red on
  the branch as it stood: `FAIL body plan target more-hit rib at or under 35 in 21.1%` and `FAIL S318 loser hurt 36.6%`,
  RIB_DAMAGE failures=2 (the same eight windows as the spread table above, number for number). It now plays 3,400
  bouts (was 600), about 2 to 3 minutes on a free slot.
- RE-MEASURED (`tools/rib_sweep.gd`, tables in docs/RIBS1_RESULT.md "S439"): FACE_HIT 1.15 -> 1.18, HEAD_HIT 0.575 -> 0.59
  (2:1 kept; off-ratio pairs buy nothing), RIB_HIT 3.1 -> 2.9. Eight-window means: loser hurt 43.4 % (target 43 or more),
  body plan rib at or under 35 9.8 % (target 17 or less); body plan hurt 67.9 % (RIBS1 65.5), default any rib at 35 0.0 %,
  head-only ribs 90.2 / 95.0, unit list (body_map test 5) 89.3 % (40-90). CATCH: the unit list holds by 0.7 - the next
  face step (1.185) reads 92.3 there - so any later rise in face damage fails body_map first. One window of eight still
  reads under 40 (38.0); the bar is on the mean.
- THE 3 UNEXPLAINED POINTS, FOUND (one-factor swaps, eight windows, at the old 1.15 / 0.575 / 3.1, files restored byte for
  byte): S433 NOCAMP1's amateur no-camp edge. `BoutRules.night_edge` gives an amateur with no camp 0.0 (main gave
  NO_CAMP_EDGE -1.5), and the test's Lucy has no camp, so she fights 1.5 stronger than on main.

  | Swap on the branch | body crit mean | loser hurt mean |
  |---|---|---|
  | none | 21.1 | 36.6 |
  | the no-camp edge back to main's (-1.5 for an amateur) | 17.6 | 40.4 |
  | that + the opponent's punches on main's rule (AttrGen) | 15.0 | 44.3 |
  | all of main's scripts (round 3) | 13.9 | 45.2 |

  So the no-camp edge moves about 3.5 / 3.8 and the opponent's punch start about 2.6 / 3.9; about 1 point each remains,
  the size round 3's swap gave Lucy's own punch start (0.7 / 1.3; not swapped together this round). Report only: the edge is NOCAMP1's design (an amateur fight week
  needs no camp) and was not touched.
- STAMINA CAPTION: `BoutRules.fade_row` now reads "From round 3: fights 0.74 weaker; Stamina 60 stops it" (or "From
  round 3: fights no weaker (Stamina 60 or more)"); the wrap stays. attr_board_test and words_on_screens_test expect it;
  attr_board_test also rejects the old "From round 3: every stat". The hover sentence (`fade_words`, "every stat 0.50
  lower") is unchanged (night_line_test holds it) - the same approximation, left for the lead.

### Final runs (round 4; one at a time through godot_slot, no SCRIPT ERROR in any)
rib_damage RIB_DAMAGE failures=0; body_map BODY_MAP failures=0; fight_stats FIGHT_STATS failures=0; result_marks
RESULT_MARKS failures=0; bout_marks BOUT_MARKS failures=0; golden_path GOLDEN_PATH failures=0; attr_board PASS
attr_board_test; words_on_screens WORDS_ON_SCREENS failures=0; roster_slate ROSTER_SLATE failures=0; nocamp_page
NOCAMP_PAGE failures=0; cardio_camp CARDIO_CAMP failures=0; fight_why PASS fight_why_test; face_mark3d FACE_MARK3D
failures=0; callout_pop CALLOUT_POP failures=0 (its LIVER line reads RIB_HIT).
