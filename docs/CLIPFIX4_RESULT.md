# CLIPFIX4 RESULT - the punch ruler and the three jabs (lead rulings R1-R12 applied, S439; merged to main in S440)

> S440 COLLECT (654dd66b): R12 applied (68195289) - a FIXED row fails on the fault it fixed and on any bar it made
> worse than its original; a fault the original already had prints `STILL FAULTY` and passes. Now:
> `STILL FAULTY: pro_left_jab_c og_far 0.319 (original 0.321)`, `PUNCH_FORM failures=0`, `JAB_RETIME failures=0`,
> `PUNCH_FORM_RULES failures=0`. F8 is CLOSED by R12 (jab C stays on the faulty list for its rear glove). jab_retime_test
> and punch_form_test are in tools/run_tests.sh. Readers of the merged tables, re-run on main: corner_bar_test,
> side_panel_test, ko_continues_test, move_book_test, pad_view_test, beat_clips_test. Side films before/after:
> docs/playtest/S440/jabs/. The text below is the S439 state before R12.

Written last, from the final run only, after main was merged in (merge d63a6056, clean; tools/run_tests.sh keeps the
union of both lists, checked: no name lost). Final run order: tools/punch_form.gd (regenerates punch_form.json, now
18 rows: 15 clips + the three o_ originals), then the ten tests one at a time through godot_slot. The fixed jab takes
and the three tables were not regenerated this round (unchanged since 239c7559; the merge touched none of them, nor
FightStage, BeatClips or FightClips). The spec is ops/research/CLIPFIX4_REVIEW_S438.md; earlier rounds' defect
answers are in this file's git history (3e5a62d5, 239c7559).

## In one paragraph

R8 is in: each of the three jabs is judged on its ORIGINAL take for the eye's row and on its FIXED take for every
bar. On the originals the ruler catches the eye's fault on all three (hang 0.388 / 0.231 / 0.265 > 0.17: SAME 1/1
each), so F6's RULER_BLIND lines are gone. The fixed takes of pro_left_jab and pro_left_jab_b clear every bar.
**The fixed take of pro_left_jab_c fails one bar: other glove far 0.319 > 0.30** (outside the 2 % band, which ends at
0.306). The retime did not cause it: the original reads 0.321, so it is the clip's own rear glove, not the fix. Under
R8 that fails the test: punch_form_test is RED with exactly that one line; nothing was fitted. The other nine tests
are green. The 3D extension hold (R10) reproduces the reader's numbers exactly.

## Final test lines (this run, after the merge)

- tests/punch_form_test.gd -> `PUNCH_FORM failures=1`: `FAIL FIXED (lead ruling S439) pro_left_jab_c: the fixed take
  fails og_far 0.319 <= 0.300` (F8 below). `FRESH punch_form.json: 18 of 18 clips match`. No RULER_BLIND line.
- tests/punch_form_rules_test.gd -> `PUNCH_FORM_RULES failures=0` (two new checks for extension_hold_s)
- tests/jab_retime_test.gd -> `JAB_RETIME failures=0` (33 PASS)
- tests/beat_clips_test.gd -> `BEATCLIPS failures=0`
- tests/beat_tally_test.gd -> `BEAT_TALLY_TEST failures=0`
- tests/short_punch_test.gd -> `SHORT_PUNCH failures=0`
- tests/file_limits_test.gd -> `FILE_LIMITS failures=0`
- tests/head_aim_test.gd -> `HEAD_AIM failures=0`
- tests/fight_feel_test.gd -> `FIGHT_FEEL failures=0`
- tests/sound_sync_test.gd -> `SOUND_SYNC checks=30 failures=0`

No run printed a SCRIPT ERROR or a parse error.

## Rulings R8-R11 (this round) and what each did

- **R8 (F6) - LEAD RULING S439: a clip with a fixed take is judged in two rows.** Reason: the retime removed the fault
  the eye named; calling the ruler blind for not seeing a fault that is gone is wrong.
  - tools/punch_form.gd: for every clip whose game take is in fixed/ (`has_fixed`), it loads the original as
    o_<clip> (FightClips._add_baked, as jab_retime_test does) and measures it on a window from jab_retime's
    `measure_take` (clip_contact's and clip_recovery's methods on that take). punch_form.json keeps both rows:
    `pro_left_jab` (fixed, what the game loads) and `o_pro_left_jab` (original), the same for _b and _c, each with
    its take path and md5 in `inputs` (the freshness check covers both).
  - tests/punch_form_test.gd: the eye's row reads o_<clip> and must catch the eye's fault as before (NONE still
    fails as RULER_BLIND); a new row `FIXED (lead ruling S439)` judges the fixed take on every bar of its kind and
    fails on any catch (ON THE LINE is not a catch, as everywhere).

  | clip | eye's row on the original | FIXED row on the game's take |
  |---|---|---|
  | pro_left_jab | hang 0.388 > 0.17 caught - SAME 1/1 | PASS: clears every bar (hang 0.165) |
  | pro_left_jab_b | hang 0.231 > 0.17 caught - SAME 1/1 | PASS: clears every bar (hang 0.140) |
  | pro_left_jab_c | hang 0.265 caught (and og_far 0.321) - SAME 1/1 | **FAIL: og_far 0.319 > 0.300** (hang 0.140 passes) |

- **R9 - LEAD RULING S439: the 2 % ON THE LINE band applies to the R1 hang bar and the R5 bow bar as to every other
  bar.** Reason: one rule for every bar. The band is |value - bar| <= 2 % of the bar, so the hang bar 0.17 allows up
  to about **0.173** (0.1734) as ON THE LINE, and the bow-over-the-hip bar 0.25 up to about **0.255**; neither is a
  catch inside that. No code change was needed (the test already applied LINE_FRAC to every bar); the test header
  now says so. In this run: jab_a's hang 0.167 is ON THE LINE (under); no body shot's bow is near 0.25 (0.322, 0.040).
- **R10 (the reader's low note) - LEAD RULING S439: an extension-hold number, no bar.** Reason: a number for the eye
  and for PUNCHSNAP1. `PunchForm.extension_hold_s`: seconds of the one continuous run around the peak where the 3D
  hand-to-UpperArm-joint distance stays within 0.05 m of its peak (edges interpolated as hang_window's), over the
  ruler's strike window; stored as `ext_hold_s` in every punch_form.json row, printed by punch_form_test as
  `INFO EXTENSION_HOLD`:

  | clip | original | fixed |
  |---|---|---|
  | pro_left_jab | 0.396 s | 0.173 s |
  | pro_left_jab_b | 0.289 s | 0.198 s |
  | pro_left_jab_c | 0.359 s | 0.231 s |

  These equal the reader's numbers (0.173 / 0.198 / 0.231 against 0.396 / 0.289 / 0.359). On the same measure the
  GOOD jab_a reads 0.252 s, so all three fixed jabs now hold the arm out no longer than the passed jab.
- **R11 - LEAD RULING S439: the list of tests that read the three tables.** Reason: the full list, so a later
  regeneration knows what to run. The tables (clip_contact, clip_recovery, clip_travel) are read, directly or through
  BeatClips / BeatFire / FightStage, by: beat_clips, beat_tally, short_punch, head_aim, rokoko_clips, fight_feel,
  sound_sync, file_limits, block_meet, punch_form, jab_retime, **guard_knee, ring_feet, boxer_footwork, cam_line,
  knockdown_still, sound_bank, voice_lines, fighter_look, human_feet**. guard_knee and block_meet are red on main's own
  data (nightly 2026-11-12, commit 090801a0: guard_knee "rear knee stays on the source -0.0666 v 0.0291", block_meet
  pro_right_hook touch), so they do not hold this branch. A fact the ruling did not name: the same nightly also has
  **sound_bank_test red on main (26 failures)**; it is in R11's list, so it does not hold this branch either (not run
  here). The non-jab rows of the three tables stay main's (F7 stands: a full regeneration is a separate task);
  against main the tables differ only in the three jab rows (30 lines changed in all).

## Rulings R1-R7 (previous round, unchanged)

- **R1 (F1, the hang bar) - LEAD RULING S439: the bar is 0.17 s for jabs and crosses.** Reason: the jab take the eye
  passed (jab A) holds 0.167 s on this measure, and our research's contact phase for a real jab is 122-144 ms
  (Ueberschar 2021, G75_STRIKE_SPEEDS.md); a bar under the passed control cannot be right for this measure.
  - Done: `HANG_MAX := 0.17` in tools/punch_form.gd (the ruler); punch_form_test's jab and cross bars and
    jab_retime_test's "red before" check read it.
  - jab A: `PASS GOOD pro_left_jab_a clears every bar (on the line: hang 0.167 <= 0.170)`. 0.167 is within 2 % of
    0.17, so it prints ON THE LINE (never a catch); no FINDING line.
  - Side effects of the wider bar: cross_c's hang (0.159) is no longer caught (its og_far 0.340 still is, DIFFERENT as
    before); cross (0.228) is still caught.
- **R2 (the ease) - LEAD RULING S439: the retime uses the ONE-key ease (ramp 1) as its default.** Reason: with one key
  jab B and jab C pass every check at 3.2x and 4.5x middle speed, against 31.9x with two keys - the gentler speed-up is
  the better animation. Done: `static var ramp_keys := 1` in tools/jab_retime.gd (`-- ramp=N` still looks at others).
- **R3 (targets) - LEAD RULING S439: jab B and jab C to hang <= 0.14; the plain jab to hang <= 0.165 (at or under the
  passed jab A) with contact within one frame, and it must pass the step bar.** Done: `TARGETS` in
  tools/jab_retime.gd is the one per-clip table; jab_retime_test reads `Retime.TARGETS`. The plain jab did NOT stop: it
  passes everything at 0.1650 (no STOP to report).
- **R4 (F3) - LEAD RULING S439: cross B (blind) and cross A (caught only by the far glove) stay in the test as printed
  KNOWN BLIND rows and do not fail.** The line printed for each: "KNOWN BLIND (lead ruling S439): the eye's fault
  'short and bent' has no measure yet; PUNCHSNAP1 (fist speed, straighten time) is the planned measure", followed by
  the clip and its verdict (cross_a DIFFERENT, cross_b NONE). The eye's verdict stands: both stay on the faulty list.
- **R5 (F4) - LEAD RULING S439: the body shots' bow bar reads the head over the lead HIP (bow_hip_m), fail above
  0.25 m.** Reason: in a lunge the knee is far forward, so head-past-knee cannot see a folded trunk; body shot reads
  0.322, kidney shot 0.040, jab A -0.097. Done: `BOW_HIP_MAX := 0.25` in the ruler, the body bar reads bow_hip_m.
  - body_shot: bow 0.322 caught -> SAME 1/1 (was NONE).
  - kidney_shot: bow 0.040 passes, so the kidney shot is now caught ONLY by its slow return (back 0.533 > 0.45),
    SAME 1/2.
- **R6 (F5) - LEAD RULING S439: regenerate all rows of the three tables, print what moved against main, run every test
  that reads them; commit if all green, else restore the non-jab rows and report.** Done; block_meet is red, so the
  non-jab rows were restored to main's and only the three jab rows are committed. Details below.
- **R7 - LEAD RULING S439: the step bar divides by the TARGET hang (R3 table), as the brief says, not the measured
  hang.** Done: `Retime.step_bar(o_step, orig_hang, target)`, used by the tool (it refuses a take that fails) and by
  the test's check 7.

## The three jabs, before and after

"Before" is the branch tip 3e5a62d5 (two-key ease, target 0.14 for all three): jab and jab_b had STOPPED, so the game
played their originals; jab_c had a two-key take. "After" is this run (one-key ease, R3 targets).

| clip | before: hang / contact / middle speed | after: hang / contact / middle speed | after: length, back_s | worst 60 Hz step (bar) |
|---|---|---|---|---|
| pro_left_jab | 0.3878 / 0.500 / original (STOP) | 0.1650 / 0.483 (1 frame) / 7.0x | 1.067 -> 0.841, 0.817 -> 0.583 | 0.0761 -> 0.1575 (0.1888) |
| pro_left_jab_b | 0.2311 / 0.333 / original (STOP) | 0.1400 / 0.317 (1 frame) / 3.2x | 0.900 -> 0.808, 0.750 -> 0.650 | 0.0747 -> 0.0957 (0.1332) |
| pro_left_jab_c | 0.1400 / 0.317 / 31.9x (two-key take; original 0.2652 / 0.333) | 0.1400 / 0.317 (1 frame) / 4.5x | 0.967 -> 0.838, 0.850 -> 0.717 | 0.0831 -> 0.0968 (0.1674) |

- Spans: jab [0.4667, 0.7635] -> 0.0710 s (the span from the peak 0.4333 failed, the start walked two 60 Hz samples
  later); jab_b [0.2833, 0.4495] -> 0.0744 s; jab_c [0.3000, 0.4979] -> 0.0697 s.
- Peak reach: jab 0.4927 -> 0.4921 (0.14 %), jab_b and jab_c unchanged. First and last pose 0.00000 m over every bone.
- Keys: 26 tracks each; 858 / 728 / 780 keys; strictly increasing; worst value change 2.4e-7 (re-timed, not re-posed).
- Files (assets/anim/baked/fixed/): mc_Box1_M3_Left_Jab.res md5 f2e86ff4..., mc_Box1_M3_Left_Jab_B.res 3e4d6795...,
  mc_Box1_M3_Left_Jab_C.res 0d8331f7....
- The take is stable against the gap: the tool wrote at gap_m 0.9031 (stage set up before the fixed jab existed); a dry
  re-run at the final gap 0.9038 chose the same spans and printed the same numbers.

## R6: the data tables (from the previous round; not regenerated this round)

Regeneration: the stage's gap reads pro_left_jab at its clip_contact row, so the three tools were run three times; the
third pass was byte-identical to the second (a fixed point). clip_contact.json was written back with main's 1-space
indent (values untouched) so its diff shows only the moved rows.

What the full regeneration moved against main:

| file | rows changed | largest change per field | rows over one 60 Hz frame (contact_s) / 0.02 m (travel_m) |
|---|---|---|---|
| clip_contact.json | 59 of 59 | contact_s 0.017 (pro_left_jab); length_s 0.226 (pro_left_jab); reach_m 0.004 (pro_combo_lh_ru) | none |
| clip_recovery.json | 145 of 145 | back_s 4.617 (pro_idle_slighty_tired); contact_s 1.733 (pro_left_uppercut, -1 -> 0.733); end_m 0.588 (pro_knockout_v3); length_s 0.559 (pro_left_jab); peak_m 0.622 (pro_knockout_v7); peak_s 19.167 (pro_knockout_countdown_v2); start_m 0.047 (pro_right_dodge) | 4: pro_body_shot 0.583 -> 0.550 (2 frames); pro_left_uppercut -1.000 -> 0.733 (was unmeasured); pro_right_cross_hard 0.967 -> 0.933 (2); pro_right_uppercut_hard 1.067 -> 1.100 (2) |
| clip_travel.json | 59 of 59 | travel_m 1.522 (pro_left_uppercut, 0 -> 1.522); path cum_m at the same index 0.804 (pro_right_hook); path point count 43 (pro_left_uppercut) | 27 rows over 0.02 m, among them: pro_right_hook 1.590 -> 0.799, pro_right_hook_ft 1.412 -> 0.651, pro_left_uppercut 0.000 -> 1.522, pro_left_uppercut_miss 1.655 -> 1.453, pro_right_cross_hard 1.749 -> 1.627, pro_left_hook_ft 1.770 -> 1.913, pro_body_shot 0.883 -> 0.818, pro_left_jab_b 0.386 -> 0.421 |

Tests that read the tables, with the full regeneration in place: beat_clips, beat_tally, short_punch, head_aim,
rokoko_clips, fight_feel, sound_sync and file_limits green; **block_meet red (failures=1)**: `ROW A_B fight
pro_right_hook touch=-0.033 ... TOUCH_FAIL(-0.033)` (the bar is touch >= -0.03, "not more than 0.03 m inside").

Why it is red - three runs of block_meet in this worktree:
- full regeneration + the three fixed jabs: failures=1 (A_B pro_right_hook -0.033);
- main's non-jab rows + the new jab rows + the three fixed jabs (the committed state): failures=2 (A_B -0.032, A_A
  -0.030; the second run of the same state read -0.034 / -0.030);
- main's three tables as they are, and NO fixed jab take (main's game): failures=2 (A_B -0.033, A_A -0.031).

So block_meet is red on main's data already, on pro_right_hook alone, 0-4 mm past its 0.03 m bar; the regenerated
rows do not cause it (they read one failure fewer). By the ruling (any red -> the non-jab rows are not committed), the
non-jab rows were restored to main's, byte for byte (main's format reproduced and checked by a round trip). Against
main the committed tables differ only in the three jab rows (diff stat: 18 lines in clip_contact, 40 in clip_recovery,
2 in clip_travel, its one-line file). The full regeneration is reproducible: run the three tools three times on this branch.

## Eye against ruler (from punch_form_test's EYE_VS_RULER lines, final run)

| clip | the eye's fault | judged on | the eye's measures (value, bar) | what the bars catch | on the line | verdict |
|---|---|---|---|---|---|---|
| pro_left_jab | hangs at full reach about 0.33 s | o_ original | hang 0.388 <= 0.170 caught | hang | none | SAME 1/1 |
| pro_left_jab_b | hangs at full reach | o_ original | hang 0.231 <= 0.170 caught | hang | none | SAME 1/1 |
| pro_left_jab_c | hangs about 0.26 s | o_ original | hang 0.265 <= 0.170 caught | hang, og_far 0.321 | none | SAME 1/1 |
| pro_right_cross | the lead glove is left out in front | game take | og_far 0.229 <= 0.300 passes | hang 0.228 | none | DIFFERENT 0/1 |
| pro_right_cross_a | short and bent, almost no hip turn | game take | elbow 157.1, reach_frac 0.980, fwd 0.603, hip 39.9 - all pass | og_far 0.313 | none | DIFFERENT 0/4 - KNOWN BLIND (R4) |
| pro_right_cross_b | short and bent, the same | game take | elbow 150.224 ON THE LINE; reach_frac 0.978; fwd 0.575 pass | none | elbow 150.224 | NONE 0/3 - KNOWN BLIND (R4), not a failure |
| pro_right_cross_c | the lead glove drops to chest height | game take | og_low 0.147 <= 0.150 ON THE LINE | og_far 0.340 | og_low 0.147 | DIFFERENT 0/1 |
| pro_left_hook | a straight-arm swing | game take | elbow_hi 154.669 <= 125 caught | elbow_hi | og_low 0.147 | SAME 1/1 |
| pro_left_hook_v2 | glove drops to the hip first, near-straight arm | game take | pre_drop 0.241 <= 0.25 passes; elbow_hi 121.757 <= 125 passes | og_low 0.193 | none | DIFFERENT 0/2 |
| pro_left_uppercut | waits at the thigh, finishes above her head | game take | pre_drop_held 0.267 <= 0.18 caught; finish 0.250 <= 0 caught | both | none | SAME 2/2 |
| pro_body_shot | a bowed lunge | game take | bow (hip) 0.322 <= 0.25 caught | bow | back 0.450 | SAME 1/1 |
| pro_kidney_shot | a bowed lunge, about 0.7 s to get back | game take | bow (hip) 0.040 passes; back 0.533 <= 0.45 caught | back | none | SAME 1/2 |

FIXED rows (R8): pro_left_jab PASS, pro_left_jab_b PASS, pro_left_jab_c FAIL (og_far 0.319).
Totals: SAME 7 (the three jabs on their originals, left_hook, left_uppercut, body_shot, kidney 1 of 2); DIFFERENT 4
(cross, cross_a - KNOWN BLIND on its own fault, cross_c, hook_v2); NONE 1 (cross_b, KNOWN BLIND). The GOOD controls:
jab_a passes (hang 0.167 ON THE LINE), right_uppercut passes.

## Findings for the lead (open after R8-R11)

- **F8 (new): pro_left_jab_c's fixed take fails the other-glove-far bar, 0.319 > 0.30** (the 2 % band ends at 0.306),
  so under R8 punch_form_test is red with that one line. The fault is the clip's, not the retime's: the original reads
  0.321 on the same measure (the retime moves that glove by 2 mm). Before R8 it showed only as jab_c's
  RULER_DIFFERENT. Not fitted. Ways the lead could rule: accept jab_c's rear glove (a KNOWN row like R4), widen og_far
  for jabs, give jab_c a guard fix (a separate clip task), or drop jab_c from the game's jab set.
- **F7 stands: block_meet (and guard_knee, sound_bank) are red on main's data** (nightly 2026-11-12); the full
  regeneration of the three tables stays a separate task: re-run clip_contact / clip_recovery / clip_travel three
  times, then tools/punch_form.gd last.
- **jab_retime_test and punch_form_test are not in tools/run_tests.sh** (neither branch's list had them; the merged
  list is the union and was not widened), so the nightly does not run them; adding them is the lead's call.
- **The RULER_DIFFERENT lines** (cross, cross_c, hook_v2, and cross_a under KNOWN BLIND) print `FINDING
  RULER_DIFFERENT` and do not fail, unchanged; jab_c is no longer among them (its eye row is SAME on the original).
