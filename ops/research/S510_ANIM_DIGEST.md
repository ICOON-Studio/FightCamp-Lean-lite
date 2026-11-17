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
