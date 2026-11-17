# S510 animation loop digest (2026-11-17) - own session, loop until both blind critics give 7+

Owner S510: the animation work moves to its own session and loops until the fight motion scores 7/10 or more.
Start: r12 = coach 5.0 / animator 5.0 (flat vs r11). Method unchanged: seed 7, 75 s, 1920x1080, game camera, sheets at the
r11 times and crop 1150:740:385:140, two fresh critics (coach + animator) who never see our proposal or an earlier score.
One script films a round: `E:/FightCamp/tmp/fightweek/film_round.sh <out>` (refuses with a game window open, Q-267).

## Round 13 changes (from the r12 critics' and the owner's items)
0. OWNER "why they only throw puches with one hand ?" (f3e41e17a, GuardLife): the paw stays the lead hand, every 3-4 s
   (was 1.5-3); feints are drawn by style from a lead jab feint, a REAR cross feint, a rear body dip (pro_body_shot is the
   right hand) and a level change (quick weave's dip). The dead FIDGETS names (mc_head_movement, mc_bob_weave: no clips)
   are gone; 35 % of the waits that come due are an owned weave (WAIT_WEAVES, kept out of FIDGETS: guard layers and
   footwork read that list). r12 ruler: short paws/feints lead/rear 37/1 and 35/2.
1. Free glove above the head (r11 + r12): tools/free_glove_probe.gd - blue's rear cross alone, the free lead glove's front
   +3.4 cm over the head bone; with red's cross 0.2 s before it +12.3 cm; `noclash` +3.4, `nopopcap noprecap` +12.3. So
   GloveClear's clash push off the other's punching arm lifts it (a guard-rank hand moves out of ALL the overlap).
   GuardBox.gd (new, last arm layer after PopCap): while a punch plays, the glove that is not punching keeps its top
   (wrist + 0.19 m along the forearm) under the head bone + 0.22 m (about the crown), soft knee 3 cm, eased 0.08 s.
2. Arm out after contact: r12's "worst 29 frames" was the RULER (pro_body_shot read on the left hand; it is the right).
   Corrected r12: median 5.5, worst 12. ArmHome: only reach-armed punches came home early, at 1.5x the bag clip's own hold
   (the cross's hand stays out from 0.18 to ~0.6 s of the clip). Now every punch clip: contact -> peak in 0.05 s, peak ->
   back in guard in 0.13 s, on the arm's own clock (runs only while the clip plays). `-- oldarmhome` = S497.
3. Reactions (both critics: cross 18-25 cm, hook 20-30 cm; r12 14.6 / 14.4 cm, a jab 4.6 cm): snap cross/hook 28 -> 33
   deg, cross trunk give 1.45 -> 1.6, a tired arm's snap never under 85 %.
4. Head pops: r12's worst head jumps were all hit reactions in their first frames (cross_v3 9 / 21 / 18 / 9 cm, gutshot_v2
   16 / 18, uppercut_v1 18 / 11), freed from PopCap on purpose (FREE_HIT_S). Now a freed hit is capped at 4.2 m/s (14 cm a
   30 fps frame, the animator's own cap for a power shot); the size is kept, spread a frame. `-- freehits` = S497.
5. Exit after a burst (r12 wait #13-24: after the burst's last jab blue stepped IN to 0.87 m, heads 0.48 m, gloves on
   gloves): once no punch is due within the burst gap, the pocket steps out at once (edge). `-- nopocketexit`.
6. Rulers: forearms logged (human_fight_film.gd); new lines "free glove top over the crown" (r12: 26 / 41 frames, worst
   5 / 11 cm, straight-up estimate) and "short paws/feints by hand".

7. LANDED punches' arm (join_return trace, pro_right_cross): the reach, not the clip arm, decides how long a landed glove
   stays out - hold 1.0 for 10 frames at 60 a second after the hit, then 12 more letting go (ReachLimit.HOME_S 0.20).
   HOME_S 0.20 -> 0.13, and a landed punch's arm goes straight home under the reach (no trip to the bag clip's peak).
8. THE LET-GO POP (found with tools/hand_tap.gd, `-- handtap=RightHand`: which layer moves a wrist on a jump frame):
   while a landed glove came home the reach's elbow-fold rule read it as "a target too close" and leaned the chest back
   further each frame, then dropped the lean the frame the hold ended; PopCap caught the head pop by turning the trunk and
   the arm rode it, 8-17 cm in one frame (join_return cross 6.8 m/s before today, 10.8 with the faster arm). The fold
   lean now belongs to the punch only, not to the let-go (PunchReach._reach; `-- letgolean` = before): 3.2 m/s.

## Tests (--fixed-fps 60), against the S509 debt list
join_return 3 -> 0 (PASS). block_meet 13 -> 6, block_catch 10 -> 7, block_absorb 11 -> 7, uppercut_tail 2 -> 1,
punch_speed 40 -> 39. hit_carry 26 -> 30 (29 with the wait beats alone; the failing set churns: 12 rows left, 13 came).
hit_frame 7 = its real baseline at the fixed frame rate (7 with every S510 switch off; S508's "4" was read without the flag).
Green: arm_home, guard_box (new), range_breath, free_hand_hold, boxer_footwork, knee_calm, head_clear, hit_step,
hit_snap_gain.

## The headless bout log (no window, no film)
`<godot> --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/human_fight_film.gd -- <out> secs=75
seed=7 show3d` writes the same shown.csv as the film (FightView `show3d`), in ~4 minutes, beside the owner's game. The
critics still need a film; the rulers do not. Logs: E:/FightCamp/tmp/fightweek/s510_h1 .. h5.

## More of round 13 (831655efd)
9. The reach's chest lean no longer drops in one frame. (a) ReachLimit.lean_out: a lean no solve drew this frame (punch
   over, let go, a new punch arming at weight 0) eases out at LEAN_RATE; (b) a FADING reach no longer leans raw on top of
   the eased lean (trunktap on r12's 19.8 s hook -> cross: 12.6 of the head's 18 cm were PunchReach). Head jumps on the
   bout log 28 (r12) -> 36 (first S510 build, hit cap at 14 cm) -> 24 (cap 11.3 cm + lean_out) -> 22 (fade).
10. PopCap.HIT_MAX_MPS 3.4 (11.3 cm a 30 fps frame). GuardBox line 0.19 m.
REJECTED: PunchReach.CARRY_S 0.10 -> 0.07 (arm out median 4 -> 3 frames, but hit_carry 31 -> 53, head jumps 22 -> 28,
hit_frame 7 -> 9). The carry hold stays 0.10 s.

r12 film log -> headless log h4: head jumps 28 -> 22 (worst 21.1 -> 15.8 cm; left: the puncher's own head on the way in,
body 6-8 cm + trunk 6 cm a frame, and one jab -> hook combo start 15.8), arm out median 5.5 -> 4 (worst 12 = one body
shot), free glove over the crown 26 / 41 -> 0 / 0 frames, head inside a body 2 -> 0, paws/feints lead/rear 37/1 + 35/2
-> 14/8 + 15/8, hit head travel 15.0 -> 16.9 cm, waiting 64.6 -> 52.9 % (weaves are not "waiting").

11. REACTIONS SIZED BY THE POOL (BeatClips.REACT): the straight-punch pools were sorted by the clip's name, not its size -
    a landed jab moved the head 5.3 cm with jab_v1_short (its furthest point is 0.6 s in) and 18-21 cm with jab_v2_short,
    more than a cross's 13-17 cm with cross_v2_short. Now jab = jab_v3, jab_v4_short, jab_v5_short, cross_v2_short (peak
    0.12-0.19 m); cross = cross_v1_short, jab_v2_short, cross_v3 (0.25-0.30 m); jab_v1_short out. The cross snap is back
    at 28 deg / give 1.45 (33 / 1.6 on the bigger clips read 31 cm); hook stays 33. The ruler names a reaction by the PUNCH
    that hit, not by the reaction clip. Headless log h8: jab 10.6 cm (r12 9.8, two at 5), cross 29.1 (14.6; bar 18-25,
    a little over: 22.5 / 29.1 / 33.6), hook 20.0 (14.4), body 45.8; head jumps 20 (r12 28), worst 15.8 cm.
    hit_carry 31 -> 43: rows flip both ways on punches the pools cannot touch (hooks, hit-frame ON rows 1-3 mm either
    side of their bar) - the test runs the guard life's clocks, so anything that shifts the timeline reshuffles it. Debt.

REJECTED: HeadClear.RISE_MPS 2.4 -> 1.6 (the tap blamed GloveClear for 7-9 cm of some punching-head frames): head jumps 23 -> 23,
heads closer than 25 cm 0.09 -> 0.18 %. Not the limiter; left at 2.4.

EXIT AFTER A BURST, measured (frames from the last punch clip's end until the hips are 1.3 m apart, 16 bursts): r12 median 4,
four bursts at 22-37; h9 median 1.5, four at 26-43 - but those now reach the jab's edge (1.2 m, out of range) in ~10 frames
and then drift out to rest (0.5 m/s). The rest walk-out is the slow part; left for the critics' read.
Wider tests green (golden_path, fight_feel, fight_flow, knockdown_*, clinch/inside beats, punch_form/start/snap, ring_feet,
lean_ease, hit_step); head_aim 1 failure (3 with the S510 switches off); human_feet = nightly debt.

12. THE FREE GLOVE, second pass (the first r13 film, kept in E:/FightCamp/tmp/fightweek/r13a_firstfilm): GuardBox read the wrist
    +3 cm over the head bone (r12 +8) and the picture still had the glove a third of its length over his head (ex1 #40-47):
    the crown is ~0.13 m over the Head bone, not 0.22, and pulling a pushed glove back down only puts it into the arm that
    pushed it. Now the PUSH does not go up: GloveClear._clear_arms hands a guard hand's move to GuardBox.cap_up - up only to
    head-bone height, the rest OUT to the hand's own side (a boxer parries a straight outward). GuardBox.TOP_M 0.12.
    Headless log h12, the same frames: wrist -2..-4 cm, glove top +14 cm (first film +22, r12 ~+27). Other rulers unchanged.
    The film and the headless log agree line for line (r13a film = h9 log), so the log is a true stand-in for the rulers.

REJECTED: PunchReachMath.OUT_S 0.16 -> 0.12 (the reach's fade after a punch; r13 film ex5 #31-34, a blocked cross on the glove 4
frames): arm out median 4 -> 4, worst 7 -> 12, join_return 0 -> 4 failures. Left at 0.16.

13. THE OWNER ON THE FIRST r13 SHEETS (ex5 #25-36: "wtf is the right hand of blue fighter doing"; ex3 #17-24: "same here wtf
    are you doing ? are you destroying or fixing animations ?"). Measured on his frames in r12 and both r13 films: the free
    wrist stood at the SAME height in all three (-0.01 .. -0.04 m from the head bone, forearm 0.9-1.0 upright) - not made
    worse, not fixed. The cause was never the clash push (that is only ex1's extra 8 cm): the S506 free hold PUTS the wrist
    on the guard point 3-4 cm under the head bone, which sits at eye height, so the glove stands over the forehead to the
    top of the head. FIX: GuardTuck.FREE_DROP_M 0.11 / FREE_BACK_M 0.03 (the free wrist at the chin while a punch plays; the
    standing guard unchanged; `-- nofreedrop`), GuardBox.WRIST_UP_M -0.08, TOP_M 0.08. Third r13 film (19:25, the one in
    r13blind/): his frames read wrist -0.10 .. -0.14, glove top +0.02 .. +0.08 (was +0.16); the cross in ex3 is back after
    2 frames. Before/after sent to him: r13blind/owner_before_after/.
    OPEN DEBT FROM THIS: join_return_test 0 -> 4 failures (pro_right_cross 31.7 m/s one frame "from the cut on", 47 frames
    after the hit; pro_right_uppercut 9.4). `nofreedrop` alone still 34 (so cap_up / GuardBox too), `noguardbox` alone
    cross 6.3 but uppercut 25. Suspect: a wrist held close to the shoulder (arm fully folded) makes the pole-less two-bone
    solves in GuardBox / GloveClear flip the elbow. On the film itself glove-front steps over 15 cm outside punches are
    72 vs 72 (first film vs this one), worst 37 -> 46 cm. FIRST JOB of the next session.
    Also: OUT_S 0.12 was rejected partly on join_return 4 - that 4 was probably from cap_up, not OUT_S; retest OUT_S later.
14. INCIDENT (mine): a join_return run at 17:45 started with a parse error in BoxerBuild (PackedStringArray.any), never
    exited, and wrote script errors to C:/Users/user/AppData/Roaming/Godot/app_userdata/FightCamp/logs for 90 minutes -
    17 GB, C: down to 4.2 GB (watchdog RED) until its PID was killed at 19:13. After ANY "SCRIPT ERROR / Parse Error" run:
    list the engine processes and kill your own by PID.

15. THE GLOVE JUMP (join_return 4 failures) SOLVED 20:05. tools/hand_tap.gd on the full test: the hitter's right wrist moved
    28-45 cm a frame, back and forth, every bit of it in ArmClash - the arm-against-arm clearance in a pinch its passes
    could not solve (the free glove now held lower; cap_up first sent the cut upward push outward, then only dropped it:
    still 28.7 m/s, the drawing-in part ran away instead). The same tap showed the OLD defect behind it: a guard wrist
    left ALL of an overlap in one frame, 12-20 cm, whenever a punch passed. ArmClash.gd now eases what the clearance
    moves a wrist by: at most STEP_MPS 2.4 m/s of change from the frame before, MAX_M 0.16 in all (`-- noclashease`).
    join_return 0 failures, block_meet 5 (6), block_catch 5 (5-7), glove_cut green. Bout log h15 vs the r13 film: guard-wrist
    moves over 10 cm a frame 37 -> 19 (r12 41), every ruler and the owner's frames unchanged.

## ROUND 13 JUDGED (blind, film r13blind 19:19): coach 4.5 / animator 4.5 (r12 5.0 / 5.0)
Coach: punches 4.5, defence + reactions 4, footwork + stance 4, transitions 3.5, waiting 4.
Animator: punches 4, defence + reactions 4.5, footwork + stance 5.5, transitions 4, waiting 5.
Reviews: E:/FightCamp/tmp/fightweek/r13blind/critic_coach.md, critic_animator.md (+ their 10/10 drawings).
BOTH, first on both lists: a punch has no flight ("one cell the glove is at the face, the next the arm is fully out"),
then hangs 3-5 cells, then returns; a hit is shaken off in 6-7 frames and the stance is back in two; a blocked punch
moves nothing; both men are the same boxer on one line; lunging stances to 0.93-0.97 m; the near rope over the shins;
the coach line in the middle of the picture.
Coach only: both stand far too low (knees 124 deg, wants 150-160, "raise both 8-10 cm"), gloves 20-30 cm off the face,
a cross reaction bends him "like a knockdown" (29-32 cm, face to the lights), the hand at the hip in range, the body
attack is a dive, no legs in the punches. Animator only: the lead hook is thrown from the hip with a straight arm
(pro_left_hook_v2: the glove drops 27 cm, hand 65 cm from the chest), rear-hand twitches (the cross clip started and
dropped inside 5 frames ten times), waiting inside punching range, both in a punch at once 10.5 % of the round.
What they say works: the free hand stays at the chin, blocked punches read as blocked, feet do not skate, the reaction
starts on the contact frame, the cross's rocked pose (animator: "good pictures"; coach: too big).

### What r13 itself made worse, checked on the logs (the owner: "why animations is getting worse?")
- Reactions: r12's critics asked for cross 18-25 cm; r13 drew 29-32 with the back arching. Too far: trimmed in r14.
- "Punches appear in one frame" is NOT new: the same jab at 14.8 s moves the hand 34.4 cm in the contact frame in r12
  and 31.2 in r13 (tools: E:/FightCamp/tmp/fightweek/s511/punch_trace.py). Cause, from hand_tap: the reach drive
  (ReachDrive, POWER1 S439) covers what is left of the way in the last 2-3 frames while the body lunges 8-18 cm in the
  same frames, and the guard glove starts only 20-25 cm from the target. The sheets also cut 24 frames a second out of
  a 30 fps film (every fifth frame dropped), which hides a flight frame.
- "Hand at the hip": ex1 #55-58 / ex5 #43-45 = pro_left_hook_v2's own wind-up (in r12 too); ex2 #23-27 = red's hook
  reaction clip. Not the r13 body feint, not FREE_DROP.
