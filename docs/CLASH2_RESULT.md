# CLASH2 - gloves and forearms through each other (owner C394, four marks "still clipping") - S468, Claude

Film: `tools/hit_frame_film.gd -- <out> jabs=0 crosses=0 uppercuts=1 seed=4242` on the hidden desktop, 960x540, 60 fps.
Ruler (new): `tools/clash_meter.gd`, read off the bodies AS DRAWN, printed by the film as `CLASH` lines: frames from the
hit on where any glove or forearm of one boxer is more than 2 cm inside the other's, and the worst depth.
Pictures: docs/mockups/s468/rear_uppercut_before_after.png, lead_uppercut_before_after.png.

| Punch (seed 4242) | main before | after |
|---|---|---|
| rear uppercut | 14 frames, worst 0.074 m | 3 frames: one at 0.065 m (the frame after the hit), two at 0.023-0.027 m |
| lead uppercut | 14 frames, worst 0.085 m | 1 frame at 0.024 m |

## What was wrong (each measured on the film, not guessed)
1. The S465 shapes were two 0.06 m balls; the glove on screen (Gloves.SIZE 1.2) is 0.17 m thick and 0.31 m long. "Clear"
   by the old rule still drew 3-5 cm of overlap, and forearms were never kept off gloves.
2. ElbowClear ran AFTER the clearance and moved the elbows 2-18 cm (`drift` in the meter); the glove follows the forearm,
   so a cleared glove swung back in. The arm-against-arm pass now runs last of the arm layers (scripts/fight3d/ArmClash.gd).
3. "A punching hand never moves" left two hands that never moved (an uppercut hand going home through her jab going out).
   Right of way now: live punch > hand going home > guard hand; the lower one moves, equals share.
4. A long-guard glove sat BETWEEN the other's two gloves (a gap narrower than a glove): pushing off one pushed into the
   other. The hand now also draws in toward its own shoulder, and off a live punch the arm opens outward.
5. The boxer drawn first reads the other's arms a frame late: she reads them one step ahead; the one drawn second takes
   what is left.
6. A BLOCKED punch is left to the block: with the true glove shape the catching hand was pushed off the punch it is
   meant to meet (block_meet A_A jab: the catching glove 9 cm under her face, bar 8). BlockCatch owns that meeting.
`-- ballclash` = the S465 rule and place (control arm); `-- noclash` = none.

## Regression (headless, same day)
| Test | main | after |
|---|---|---|
| block_meet | 4 (the four CTRL_LANDED rows, LANDREACH) | 4 (the same rows) |
| hit_frame | 10 | 10 |
| hit_carry | 38 (`-- ballclash`, same day) | 38 |

## Still open
- One frame after the hit on the rear uppercut (0.065 m): her guard forearm against the glove on her chin.
- A boxer's own two gloves can still overlap each other (seen in the "before" row); no rule for that yet.
- The rear uppercut still lands 0.114 m off her chin at 8 % of its top speed (the film's own line): not this task.

## LANDREACH (lead glove height) - what S468 found, nothing changed yet
tools/landreach4_probe.gd: in block_meet's CTRL_LANDED setup the punch is armed and its contact frame read two frames
later, while the reach is still easing in (weight 0.14 on the hit frame, 0.80 at the read). For the lead hand the hit
point is then re-latched onto that half-eased glove (ReachLimit.carry_base returns `shown`), 7-23 cm off her face, and the
glove goes exactly there (drawn glove to its aim: 0.00-0.02 m). So the 5-11 cm "height error" is the latch on a
half-eased glove, not the arm solve. In the played fight the punch is armed at the clip's start, so the ease is over by
the hit - unless a punch starts mid-clip (BeatFire's skip). Next: (a) carry_base takes the face whenever the reach was not
at full weight on the hit frame; (b) CTRL_LANDED lets the ease finish before it seeks to the contact, as the game does;
(c) `tools/hit_gap_probe.gd` on the hidden desktop WITH `--log=` (S468's run had no log) for the played numbers by punch.

## S469 - what the played fight says (tools/hit_gap_probe.gd on the hidden desktop, 150 s, 33 landed punches)
| Run | middle punch | 9 of 10 within | worst | shown more than 15 cm off |
|---|---|---|---|---|
| main (`-- noweightbase shortwind=0.08`) | 0.061 m | 0.262 m | 0.686 m | 7 (21 %) |
| carry_base by reach weight only | 0.058 m | 0.253 m | 0.677 m | 8 (24 %) |
| + a short inside punch keeps 0.16 s to arrive | 0.021 m | 0.174 m | 0.190 m | 5 (15 %) |

- (a) DONE: `ReachLimit.carry_base` takes the reach's weight; below full weight the carry starts from the face for either
  hand (`-- noweightbase` = the control arm). block_meet the same day: 6 failures with the old rule, 3 with the new (every
  lead-hand CTRL_LANDED row passes; left: A_B cross 0.065, B_A jab 0.051, one GY row on a blocked jab). In the played
  fight it changes little: there the reach is at full weight on the hit.
- (b) NOT DONE, on purpose: holding the clip's start for the ease and then seeking to the contact reads WORSE (lead hook
  0.46 m): the landed glove is driven at a pace, and a seek jumps the clip further than the glove can travel in a frame.
  The test stays as it was; the played probe is the ruler for the match.
- What the match really showed: 5-6 of the 7-8 far punches were INSIDE punches (ShortPunch) started two frames (0.06 s)
  before the hit; the glove was still coming out of her guard (SHORT_JOIN half-life 0.09 s) and ReachLimit's 0.30 m cap
  left it 0.2-0.7 m short. `BeatFire.SHORT_WIND_S` 0.16 (ShortPunch.skip's new `min_wind_s`; `-- shortwind=0.08` = the old
  floor). Body hooks: 3 of 10 far -> 0 (worst 0.02 m).
- Still far after it: lead hooks land ~0.15 m LOW at full weight (3 of 9, inside and in the pocket), one rear hook 0.16 m,
  one cross from a 1.15 m pelvis gap 0.17 m short.
- Film seed 4242 (docs/mockups/s469/match_jab_cross_seed4242.png): glove off her face at the hit - cross 0.016, jab
  0.010, cross 0.003, jab 0.004 m. The second cross shows 18 clash frames AFTER the hit (worst 0.127 m, wrists drifting
  0.3 m after the clearance pass): CLASH3.
- GUARDKNEE2 (Qwen, PR 275): first bad commit 79665239 (the footwork rig on by default); its fix (rig weight 0 in idle)
  is NOT merged: it snaps the rig off and adds 3 block_meet failures.

## S470 - LANDREACH4: low lead hooks, the "short" cross, and the ruler itself
- CAUSE of the low hooks (hit_gap_probe now prints `HIT_GAP layers`, tools/layer_trace.gd `trail`): the footwork's torso
  layer (BoxerFootworkUpper: lean, hips) moves the hook's hand 0.16-0.19 m DOWN before the reach runs, and the reach's
  0.30 m cap (ReachLimit.CORR_M) counted from that lowered hand: most of the cap went on undoing the body layer.
- FIX: `BoxerFootworkRig.Upper.hand_shift` keeps how far that layer moved each hand; `ReachLimit.base` counts the cap from
  the nearest point between the clip's glove as it stands and the same glove without that move. Never tighter than
  before. `-- nobodycap` = the control arm.
- THE CROSS WAS NOT SHORT. `HIT_GAP arm` showed the arm straight (0.489 of 0.496 m) and the glove 0.047 m off the face on
  the frame drawn for the hit: PunchRange.record reads the glove when the hit fires, BEFORE that frame's arm layers run
  (the glove of the frame before; a cross at 5 m/s covers 0.17 m in a frame). And one frame later her head has begun to
  snap away (a clean uppercut read 0.01 then 0.18). The ruler now takes the nearer of the two frames either side of the
  hit (`miss`), and prints both. Numbers before S470 from this probe overstate fast straight punches.
- Played fight, 150 s, 33 landed, same ruler both arms:

| Run | middle punch | 9 of 10 within | worst | more than 15 cm off |
|---|---|---|---|---|
| old cap (`-- nobodycap`), run 1 | 0.025 m | 0.160 m | 0.504 m | 4 (12 %), all lead hooks |
| old cap, run 2 | 0.019 m | 0.120 m | 0.515 m | 2 (6 %) |
| new cap, run 1 | 0.013 m | 0.042 m | 0.049 m | 0 |
| new cap, run 2 | 0.017 m | 0.046 m | 0.241 m | 2 (6 %) |

- Read it honestly: the counts overlap run to run (old 4 and 2, new 0 and 2); what moved clearly is the worst punch
  (0.50-0.52 m -> 0.05-0.24 m), 9 of 10 within (0.12-0.16 -> 0.04-0.05 m) and the tests.
- Tests the same day, new / old cap: block_meet 0 / 2, hit_frame 5 / 11, hit_carry 33 / 32, short_punch 0 / 0.
- The fight is NOT repeatable run to run (the second hook of the double at 20.9-21.2 s read 0.28-0.68 m in five runs of
  the same arm before the fix). SPEEDFLIP1 (Qwen) found why for the headless tests: the guard life and footwork layers
  advance by real frame time. `--fixed-fps 60` makes punch_speed_test print the same 175 lines twice (41 failures both
  runs); tools/run_tests.sh now passes it.
- GUARDKNEE3 (Qwen) collected: the rig's rear knee pole comes from the clip's bend plane. guard_knee_test 0; guard still
  on the game camera checked (Builds, not kept).

## S471 - the played fight repeats run to run; the leftover hook named
- The inside-range body sway (HitSnap._sway_step) took its pace and phase from the global randf(): every run swayed the
  trunks differently. It is seeded from the boxer's name now (BoxerBuild, like FighterLife). Two runs of
  tools/hit_gap_probe.gd (hidden desktop, `--fixed-fps 30`, secs=150) print the SAME lines: 33 landed, middle 0.014 m,
  9 of 10 within 0.043 m, worst 0.159 m, over 15 cm off 1 (3 %). The probe is a ruler that holds: a change is now read
  on one run a side.
- The one far punch is still the lead hook thrown as the second of a double (20.9 s, pro_left_hook_ft): 0.16 m to the
  side of the head. Its lines: shoulder to target live side 0.229 m against the model's -0.020, the hand moved 0.108 m
  of the 0.30 m it may, reach weight 1.00, "when the hit fired 0.16, drawn that frame 0.28". Reading: the head is still
  coming back from the first hook's snap while the second is armed 0.14 s before its hit; the reach does not follow the
  head over those frames. NEXT: read PunchReach's target (armed once or live?) AFTER SPLIT471 lands (Qwen is moving
  code in PunchReach.gd).
- tests at their own frame rate (tools/run_tests.sh reads `FIXED_FPS <n>` from a test's header): block_meet 0 at 30
  (10-11 at 60), head_aim 0 at 30 (4 at 60); hit_frame is not in the nightly list (9 at 30, 3 at 60: a ruler to settle).

## S472 - the double hook's far hit is the cap at work, shown as a graze
- After SPLIT471 (collected, forwarders added) and the rear knee at 18 deg, the played fight still prints 33 landed / 1 far
  (tools/hit_gap_probe.gd, hidden desktop, `--fixed-fps 30`): the same lines as S471.
- PunchReach's target is LIVE (RangeTable.aim -> FightStage.target_point -> GloveClear.shown_head, read every frame), so
  the reach does follow the head. New probe arm `-- reachwhy` (PunchReach, hit frame): pro_left_hook_ft, w 1.00, wrist
  short of the full solve 0.097 m - by weight 0, by arm length 0, BY THE CAP 0.097 (ReachLimit.CORR_M 0.30 from the clip's
  own glove) - glove to target 0.168 m. The head is 0.16 m to the side from the first hook's snap; the cap keeps the arm on
  the recorded motion, and HitImpact shows a hit still > GRAZE_M (0.15) off as a graze. Working as designed: closed.
