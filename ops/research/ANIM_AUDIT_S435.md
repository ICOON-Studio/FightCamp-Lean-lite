# ANIM AUDIT S435 - why the fight-animation seat rounds keep failing

Read-only audit of main (908910cd) plus the two rejected diffs (PR 210 HUMANFIGHT2B, PR 208 CORNERFACE2). No Godot was
run: anything that needs a run is marked UNVERIFIED. Paths are from the repo root.

## A. Findings, most damaging first

1. THE SEAT WRITES ITS OWN RULER, EVERY ROUND. Neither rejected task had a ruler on main. `tests/human_motion_test.gd`,
   `tests/human_motion_lib.gd`, `tools/human_fight_tap.gd`, `tests/corner_face_test.gd` and `tests/corner_face_scene.gd`
   exist only on the PR branches. Both briefs name the seat's own new file as RED_TEST (TASK_HUMANFIGHT2B.md:12,
   TASK_CORNERFACE2.md:11). PR 210's ruler came back with `REACH_CHECK := false` (human_motion_lib.gd:15), posture as
   `REPORT` only, dozens of `continue` skips, one seed (7), 45 s.
2. NO REAL-BOUT TEST EXISTS FOR PUNCHES. Every punch test on main drives a private rig: `stage.play` + `stage.aim_height`
   / `arm_block` / `land` called by the test (head_aim_test.gd:130-132, block_meet_test.gd:124-126 and :243-245,
   human_feet_test.gd:81 and :115-117). None goes through `BeatFire._punch` (BeatFire.gd:109), which is where the clip,
   speed, skip, wait, aim mode, defence and hit timer are decided. The real-bout instruments are TOOLS with no pass line:
   tools/hit_gap_probe.gd, tools/head_react_probe.gd, tools/smooth_probe.gd, tools/human_fight_film.gd + human_fight_report.py.
3. `human_feet_test` MEASURES A ROUTE THE GAME NO LONGER PLAYS. It sets `RkClips.enabled = true` (human_feet_test.gd:50);
   the game default is off since S432 (RkClips.gd:77, "Older stepping route"). Its four carried punches are all `rk_*`
   (line 27). With the switch on, the guard plays "pure" with the leg layers off (RkClips.gd:85-98) - a different stack
   from the shipped one. It is the test both rejected rounds were told to keep green.
4. `head_aim_test` AND `block_meet_test` ARE NOT IN THE DAILY RUN. tools/run_tests.sh line 8 lists neither (also not
   bar_guard_test). They run only when a seat runs them. block_meet is red on main (1 failure, TASK_HUMANFIGHT2B.md
   "Rules"); guard_knee_test is red on main since 79665239 (S434_DIGEST.md:7). The last nightly (05:00, commit db8b743b)
   ran BEFORE the stepping route became the default (79665239, 12:57), so no full run has seen today's fight yet.
5. `short_m` IS READ BUT NOT IN THE DATA. FightStage.gd:136 computes how far the body must close from
   `row.get("short_m", 0.0)`; assets/data/clip_contact.json has 59 rows with only contact_s, hand, length_s, reach_m.
   It left the file at S342 (e351fd2f): tools/clip_contact.gd:48-51 rewrites the whole file and drops it. So every landed
   punch uses 0 and the lunge / step-in amount (FightStage.gd:137-140) is off by that clip's own shortfall. Effect size
   UNVERIFIED. The 2B brief mentions it in passing (step 5) and nobody owns it.
6. `reach_m` IS NOT A REACH. It is the glove-to-target MISS at the jab gap, raw clip pose, mh_boxer_10 v 11
   (tools/clip_contact.gd:4, :22-23, :44-48). The 2B brief calls it "each clip's measured reach". PR 210's ReachBand scored
   a clip with no row as miss 0 = the best (ReachBand.gd `_miss`: `if reach < 0.0: return 0.0`), so the old native clips
   (no rows) won every choice.
7. THE 2B BRIEF CONTRADICTS ITSELF ON THE KNEE. Step 3: new modules go BEFORE every feet layer, "never cap after the feet
   layers". Step 6: PostureLimit "must bring both rear knees back inside the bar" of guard_knee_test, whose red is caused
   by the feet layers (FootLock / FloorStand, the brief's own words) and which reads the final drawn pose. The feet layers
   were not owned. The only way to turn that bar green was to run after them - which PR 210 did and was rejected for.
8. NO FALLBACK COUNTER. Nothing on main prints which clip a beat got, whether it was the asked take or a fallback, whether
   a punch was refused, or which aim mode it got. The only record is `stage.hit_gaps` (FightStage.gd:301, landed punches
   only, read by one tool).
9. NO TEST GUARDS THE LAYER ORDER, and main already breaks the rule the reviewers enforce: `BlockGloveLift` is added
   lazily with a bare `skel.add_child` (FightStage.gd:175-180), so it lands after every feet layer and after
   MetaHumanTwist. The header comment of BoxerBuild.gd:3-6 is stale (no RkJoinFeet, FootLock, FloorStand, FloorClear).
10. CORNER FACE: the only checks on main are `corner_lens_test` on made-up Vector3s (corner_lens_test.gd:2-3) and a
    source-text check (`minute.contains("frame_at(p, subject")`, fight_polish_test.gd:24-25). Nothing reads a face on a
    real body, so main cannot go red on the operator's complaint.

## B. Q1 - the rulers on main

| ruler | measures | path | samples | can go red? | ways it passes blind |
| --- | --- | --- | --- | --- | --- |
| head_aim_test | un-landed head punch: glove front height v face at contact | private: stage.play at speed 1.0 + aim_height, clip seeked by hand (:130-143) | 4 plain Pro takes x 3 pairs + 4 joins, puncher always boxer 0 | yes (instrument check :189-195) | missing clip = SKIP, no failure (:163-165); pair returns 0.0 (:229-230); best of 5 frames (:140-148); SMOOTH_TOL 0.30 m and DEPTH_TOL 0.20 m (:14-15) cannot fail; latch check only if "slip" exists (:283); target is the game's own target_point, so a wrong face point is invisible; feet and fidgets not paused (flaky, UNVERIFIED) |
| block_meet_test | blocked punch meets the blocking glove | private: stage.play + arm_block; defender via ap.play, not stage.play (:160) | 4 clips x 3 pairs, +1 preview | yes (red on main now) | gap out of range = VOID, no failure (:115-117); missing clip = return (:109-112); CTRL silent return (:236-237); scores the BEST frame in a 0.15 s window (:184); feet and guard life frozen (:86-87), a state the fight never has |
| human_feet_test | feet off / under the canvas, dragged support foot, drawn pose | stage.play/guard/step/circle + stage._process; land + close_in by hand | 16 moves + 4 carried punches, 2 bodies, 600+ frames | yes | forces the Rokoko route (:50); only phase "rest" (:154); a foot sliding 1.5-3 cm up is in neither bar (:22-25); "stiller foot" hides one dragged foot |
| boxer_footwork_test | the plan (pure) + the rig on a real body | rig bars: FootPlant freed, GuardWeave and FighterLife off, the test's own plan (:236-249) | many bars, 2 bodies | yes | measures the rig alone, not the fight's stack; no punches |
| ring_feet_test | rig in the ring: steps, planted ball, hand-backs | stage._process, default route (:22) | rest + range phases | yes | reads mostly the plan, no punches |
| guard_knee_test | knee in / out of the leg plane in the settled guard | stage._process, drawn pose | 660 frames, 2 bodies, pro_idle only (:72) | yes, with a pushed-knee mutant (:93-99); red on main | says nothing outside the settled guard |
| corner_lens_test | lens keep-out maths | made-up points | - | yes | no bodies, no face |
| fight_polish_test | source strings | text of .gd files | - | only if text changes | cannot see a picture |
| beat_clips_test, short_punch_test | pure clip choice / skip maths | pure | small | yes | no stage |

Trustworthy as they stand: guard_knee_test, ring_feet_test, boxer_footwork_test (for the rig alone), beat_clips_test.
Usable after a fix: human_feet_test (run on the default route too), head_aim_test and block_meet_test (count SKIP / VOID
as failures, print rows read, add to run_tests.sh). No ruler at all for: joins / pops, contact length, reaction timing,
landed-punch distance in a real bout, layer order, fallbacks, the corner face.

## C. Q2 - how a punch gets its clip, and where it falls back

Chain: FightView.gd:368 `_beat.fire` -> BeatFire.fire (:44) -> `_punch` (:109) -> BeatClips.punch (:206) -> speed (:188),
contact (:259), combo_skip (:22) -> `go` (:161): stage.play (FightStage.gd:366) -> then ONE of stage.land (:124) /
arm_block (:165) / aim_height (:146) -> timer -> HitImpact.hit (HitImpact.gd:24) or the defence clip.

Silent fallbacks and skips (none is counted):
- Clip choice, BeatClips.gd:228-231: context take -> plain take -> stem -> old native -> the move name. 19 takes are
  switched off (OFF_TAKES :45-50). By the tables, of 28 (move x context) cases 13 fall back to the PLAIN take:
  big: cross (unless stepping) and rear uppercut; miss: 6 of 7 moves (only the rear hook has a live miss take);
  tired: rear hook, body hook; stepping: both uppercuts, body hook. pro_body_shot has no variants on disk at all.
  All 7 stems exist in assets/anim/baked, so the old native clips should be reached 0 % on main (UNVERIFIED in an export).
- Contact time, BeatClips.gd:266-268: no row or under 0.15 s = the fallback. `pro_left_uppercut` reads contact_s 0.0, so
  EVERY plain lead uppercut is armed at a guessed 0.267 s (FightStage.CONTACT has no lead_uppercut, FightStage.gd:37)
  while its speed uses a different fallback, 0.489 (BeatClips.gd:193).
- Refused punch: stage.play false when hit-locked -> punch, hit and defence all vanish (BeatFire.gd:163-165).
- No aim at all: un-landed BODY punches and `stopped` punches (BeatFire.gd:172-178); any punch if `reach` is null.
- Blocked punch with no glove node: target falls back to the FACE (FightStage.gd:184-189).
- Landed punch: `short_m` 0 (finding 5); lunge clamped to 0.26 m (FightStage.gd:45, :137); step-in dropped under 3 cm or
  at the keep-out floor (PunchRange.gd:37-39); the arm clamped to its length (PunchReach.gd:245). The hit then fires on a
  timer whatever the glove distance (BeatFire.gd:193, HitImpact.gd never tests the miss).
- Cut-off punch: no hit shown, only a `cut` flag in hit_gaps (HitImpact.gd:25, :37-38).
- Missing clip in stage.play: body_hook -> lead_hook, rear_uppercut -> cross, else nothing (FightStage.gd:370-373).
- Captured takes (opt-in): RkClips.row has no reach or short (RkClips.gd:215-217).
Share of real beats on each: UNVERIFIED - needs the counter (D0.1).

## D. Q3 - the layer order

Defined only by the `move_child` calls in BoxerBuild.gd:53-189 and each layer's `attach`. Worked out by hand (UNVERIFIED
by a run; the S399 critics list in ANIM_CRITICS_S399.md agrees for the older part):
JoinSmoother, TiredSag, BoxerFootworkUpper (hips + torso), FighterLife, GuardWeave, GuardTuck, PunchReach (the aim),
HitSnap, GloveClear (calls PunchReach.settle, GloveClear.gd:99), RkJoinFeet, ElbowClear, KneeTrack, FootPlant,
BoxerFootworkRig (legs), FloorClear, FootLock, FloorStand, MetaHumanTwist, then BlockGloveLift once a block is armed.
Per frame: FightStage._process (:277-298: RkPure, RkLoco, stun, side, recover, life, hold, RingPlace.compose, ShownRoot)
-> AnimationPlayer -> the stack -> gloves follow. BeatFire's timers and HitImpact.hit's forced seek +
`pr._process_modification()` outside the stack (HitImpact.gd:29-36) sit somewhere in that frame: exact slot UNVERIFIED.
- The aim runs BEFORE the feet layers, and FloorStand moves the hips after it (FloorStand.gd:86) with no second settle.
- The rule "the feet layers keep the last word" is written only in TASK_HUMANFIGHT2B.md step 3 and in review notes; not in
  code, CLAUDE.md or a test. No test guards the order.

## E. Q4 - taps and evidence

- tools/human_fight_film.gd (main, 141 lines): the real bout (Main.tscn, TestJump men_fight or `women`), every drawn
  frame, both boxers, 12 bone ORIGINS read on skeleton_updated, clip, speed, rig weight, phase, place. Seed 7 by default.
  No beats, no punch result, no glove front, no target, no rotations.
- tools/human_fight_report.py (main, 192 lines): airborne, under canvas, skate, support-foot slip, hip / head pops, knee
  shake, per clip. Numbers only, no pass line.
- tools/human_fight_tap.gd: ONLY on PR 210. It is a SkeletonModifier3D - the kind of tap the film tool's own comment
  warns about (human_fight_film.gd:52-54). It scored 9 of 2700 rows.
An honest before / after needs: the same film tool on main and on the branch; at least 3 seeds; both boxers; rows read
printed and a floor on them (for example 90 % of in-round frames, at least 20 punches started, at least 5 each of landed,
blocked and missed head punches, at least 3 body); beats written from BeatFire itself; the glove front from the glove
node and the target from target_point logged on skeleton_updated; starts on the branch at least 90 % of main's.

## F. Q5 - why the rounds stall

- The bar is the seat's own (A1), and the brief lets a failing part be printed as REPORT instead of FAIL (2B step 2).
- Too much in one brief: 2B has 4 fixes, 5 bans, a two-file ruler, a film, four sheets, 15 owned files and 20 regression
  tests, two of them red on main, one (human_feet) on the wrong route. CORNERFACE2 is 158 lines of spec for about 40
  lines of fix, most of it describing a scene and ruler the seat must build before it may touch the fault.
- Bars that need eyes go to a seat without them: `VISUAL: yes` to Cursor; film and sheets asked from the seat.
- A contradiction the seat cannot solve inside the rules (A7).
- Data traps left in the brief: reach_m named as a reach (A6), short_m missing (A5).
- One seed, one window: a fix can be fitted to seed 7.
- Earlier rounds show the same pattern: "four tests passed on zero samples", "seats filter samples out of their own
  bars", "HitSnap tuned on a bare body never reaches the screen" (ANIM_HANDOVER_S397.md "Rules learned" / "Decided").

## G. Q6 - the next briefs

D0 - Claude first, no seat (each is small, and each is a ruler or data fix a seat must not own):
1. Beat tally: a public `log` on BeatFire filled inside `go` (one entry a punch: move, context, clip, which rung of the
   fallback chain, contact measured or guessed, refused, aim mode, cut at contact) and one printed line a round:
   `BEAT_TALLY started= refused= asked_take= plain= stem= native= guessed_contact= aim_land= aim_block= aim_height= aim_none= cut=`.
   human_fight_film.gd writes it as beats.csv.
2. Data: restore or delete `short_m` (run tools/punch_reach.gd write=1, make clip_contact.gd keep other keys); re-measure
   or switch off `pro_left_uppercut`; add an honestly named column (glove-to-target gap at contact).
3. Rulers: head_aim / block_meet count SKIP and VOID as failures and print rows read; add both to run_tests.sh;
   human_feet_test gets a default-route arm; a pure stack-order test against one ORDER table in BoxerBuild, with
   BlockGloveLift given a fixed slot.
4. The bout ruler (`tests/fight_bout_test.gd`): runs human_fight_film headless on 3 seeds and reads, from beats.csv and
   the drawn pose: frames a landed glove stays within 6 cm of its target (critics: 4-12), reaction start lag, hip pops a
   minute at clip starts (HUMANFIGHT1: 68 / 42 in 75 s), glove-to-target at contact p50 / p90. Prove each bar red on
   main, record the numbers, then freeze the file: no seat owns it.

Seat tasks, in order, one area each. Every brief: ruler read-only, "BEAT_TALLY must print, started >= 90 % of main on
each seed, native = 0, plain not higher than main", stills and film made and read by Claude.
- T1 CONTACT1 (Qwen). Owns scripts/fight3d/PunchReach.gd only (the hold and release). Ruler: bout test "parked frames".
  Stay green: head_aim, block_meet (count v main), fight_feel, short_punch, sound_sync, sound_bank, human_feet (both arms).
- T2 POPS1 (Cursor). Owns FightStage._start's join call and a new scripts/fight3d/PopCap.gd in a slot Claude adds to the
  ORDER table before the feet layers. Ruler: bout test "pops at clip starts". Stay green: T1's list + boxer_footwork,
  ring_feet, guard_knee (count v main), knockdown_still, rokoko_clips, stack-order test.
- T3 REACH1 (Qwen, after D0.2). Owns BeatClips.punch and one new pure module + its unit test. Rule in the brief: a clip
  with no measured gap scores WORST. Ruler: bout test contact p90 and the tally's rung counts. Stay green: beat_clips,
  rokoko_clips, short_punch, T1's list.
- T4 KNEE1 (whoever owns the feet layers; Claude if no seat). Owns FootLock.gd and FloorStand.gd. Ruler: guard_knee_test
  (red on main, has its mutant). Stay green: human_feet (both arms), ring_feet, boxer_footwork, knockdown_still.
Posture limits (trunk lean, gloves between belt and brow) wait until T1-T4 are in and get their own ruler first.

Corner face: Claude builds the scene and ruler of TASK_CORNERFACE2 steps 1-3 (real stage, real cues, turned head read on
skeleton_updated, card rect read, mutants), proves it red on main and makes the before stills. If it is green on main,
the operator's complaint is not what the ruler reads: fix the ruler, launch nothing. Then either Claude makes the fix
(about 40 lines: `CornerShots.lens` + the ots and cutman branches of `frame`) or one seat gets only
scripts/fight3d/CornerShots.gd and CornerMinute.gd:127-135 with the ruler read-only. Stay green: corner_lens,
fight_polish (its text check updated by Claude), crowd_room.
