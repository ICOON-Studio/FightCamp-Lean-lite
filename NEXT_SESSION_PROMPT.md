# S510 handover (written 2026-11-17, end of S509)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S509_DIGEST.md`.

## First
- Q-267 answered "Only when I'm not playing": before any film, list windowed processes (Get-Process with a MainWindowTitle);
  a game window (ArcheAgeChronicles, FightCamp, Steam games) = no film. Q-268 "Yes, medium": effortLevel is medium.
- He sent a usage-cost video (Fable 5.2 cheap). Done: `.claude/agents/Explore.md` puts search helpers on Haiku. The video's
  other rule for us: do not split small jobs across helpers (briefing + re-reading costs more than doing it).

## Done in S509
- HEADSPLIT2 + HEADSPLIT3 collected (PRs 350, 351): head jumps by phase incl. `combo`.
- A paw/feint/fidget waits until the return to guard has eased in (cc1f9476f); exported with WHAT_TO_TRY.
- PopCap `-- capwhy`: why a >12 cm head frame passes the cap. s509a: 72 of 136 landed punch at full hold, 43 hit
  reactions (free by design), 11 blocked/height-only (body slide).
- Rejected + removed: trunk cap after the hit (hit_carry 31 -> 43); trunk cap on the way in of unlanded punches (no gain).

## NEXT (in order)
Blind r12 (S509): coach 5.0, animator 5.0 - flat vs r11. Reviews: E:/FightCamp/tmp/fightweek/r12blind/critic_*.md.
0. OWNER (S509): "why they only throw puches with one hand ?" - r12 log: each boxer ~35 wait-beat paws/feints in 75 s, ALL
   lead hand (GuardLife WAIT_JAB = pro_left_jab_b); real punches red 23 (7 rear), blue 24 (~half rear). Fix: feints on
   both hands (rear-shoulder cross feint, body feint, level change), paw every 3-4 s not ~2, mix by style (STYLE_EVERY).
   Count hands on the next film; film only with no game window open.
   ALSO: GuardLife.FIDGETS names mc_head_movement and mc_bob_weave - NO such clips load (0 plays in r12; has_animation
   filters them out). Point them at the owned weaves (pro_left_weave / pro_right_weave / mc_Box1_M3_Quick_Weave, today
   defence only) so the waits get head movement. r12 waits: 6 Punch Pro fidgets 32 plays, ow_bounce_idle 6, ow_side_lean 6.
1. Blue's FREE glove shoots straight up above his head after punches - named by r11 AND r12 critics (r12 sheets ex1
   #40-47, ex2 #27-30, ex4 #25-32, ex5 #35-36). Find which clip / layer lifts it; guard box chin to 10 cm over the brow.
2. Arm out after contact worst 29 frames (red's cross, ex1 #40-47; median 5, critics want 3-4, never over 2 held).
3. A head inside the other's body (ex4 #21-24). 4. join_return 3 (rear uppercut: guard loop wrap inside the guard join;
   lead hook: the frame after hit-stop). Run every test with --fixed-fps 60.

## Traps seen this session
- EVERY in-session Godot test takes `--fixed-fps 60` (tools/run_tests.sh passes it, S470). Without it hit_carry read 29-33
  and join_return 2-4 run to run, and older debt numbers (block_meet 3) were measured that way.
- A capped trunk cannot give back the body's own slide: a head that rides the root/hips needs the slide fixed, not PopCap.
- `cd` into E:/FightCamp/tmp moved the session folder: use absolute paths.
- watch-video skill: local faster-whisper fails on this PyAV (`metadata_errors`); feed it numpy from `wave` instead.

## Debt (S509, --fixed-fps 60)
hit_carry 26, block_meet 13, block_catch 10, join_return 3; others from S508 (uppercut_tail 2, block_absorb 11,
punch_speed 40, hit_frame 4, punch_range 1, guard_knee, human_feet, rokoko_clips off-route) - recheck with the flag.

## ANIMATION LOOP STATE (the animation session's own section; rewritten 2026-11-17 ~18:45, S510)
Owner S510: the fight animation loops in its own session until both blind critics give 7+. Digest: `ops/research/S510_ANIM_DIGEST.md`.
- LAST SCORED ROUND: r12 = coach 5.0 / animator 5.0. ROUND 13 IS BUILT AND COMMITTED (f3e41e17a .. 4b5386696) BUT NOT
  FILMED: the owner is playing (ArcheAge window = no film, Q-267). First act of the next session: check for a game window;
  none -> `sh E:/FightCamp/tmp/fightweek/film_round.sh E:/FightCamp/tmp/fightweek/r13blind` (film, mp4, rulers, sheets at
  the r12 times and crop; it refuses with a game open), then two FRESH critics on `r13blind/BRIEF_critic_coach.md` and
  `BRIEF_critic_animator.md` (already written; general-purpose agents, they read CRITIC_PACK + CRITIC_ACCESS themselves).
- RULERS WITHOUT A FILM (new): `python ops/Tools/godot_slot.py run --who anim -- <godot> --headless --audio-driver Dummy
  --fixed-fps 30 --path . --script res://tools/human_fight_film.gd -- <out> secs=75 seed=7 show3d` writes the same
  shown.csv in ~4 min beside his game; `python tools/fight_motion_rulers.py --compare <a.csv> <b.csv>`. Latest: s510_h8.
- r12 film -> h8: head jumps 28 -> 20 (worst 21.1 -> 15.8 cm), arm out median 5.5 -> 4 frames, free glove over the crown
  26/41 -> 0/0 frames, paws/feints lead/rear 37/1 + 35/2 -> 14/8 + 15/8, head inside a body 2 -> 0, reactions jab 10.6 /
  cross 29.1 / hook 20.0 cm (r12 9.8 / 14.6 / 14.4).
- WHAT ROUND 13 CHANGED: both-hand wait beats + weaves in the waits (GuardLife); ArmHome on every punch, on a real clock;
  GuardBox (free glove under 10 cm over the brow); reach lean eases out and never drops (ReachLimit.lean_out, no fold lean
  in the let-go, fades do not lean raw); hit reactions capped 11.3 cm a frame (PopCap.HIT_MAX_MPS) and sized by pools
  sorted by clip size (BeatClips.REACT); a finished burst steps out at once (RangeBreath); ReachLimit.HOME_S 0.13.
- NEXT DEFECTS after r13's critics speak (my own list if they do not reorder it): (1) the puncher's head on the way in,
  12-14 cm a frame (body 6-8 + trunk 6; S509: no trunk lever - look at the body's slide speed); (2) one combo start
  (jab -> hook) 15.8 cm = the join into the next punch; (3) arm out on landed punches still 3 frames at reach (CARRY_S 0.07
  REJECTED: hit_carry 31 -> 53); (4) cross reaction a little over its bar (29 cm; cross_v3 33.6, 6 frames to peak);
  (5) feet in every exchange, real exit steps/pivots; (6) the body-shot arm (worst arm out 12 frames).
- TRAPS: PunchReach.gd is at exactly 500 lines (put new reach code in ReachLimit.gd, 459). Edit scripts with exact-string
  replaces and `assert s.count(old) == 1` (a slice by index mangled BeatClips.gd once; `git checkout -- <that file>` fixed
  it). hit_carry_test is noisy across changes (it runs the guard life's clocks): 26 -> 43 today with rows flipping both
  ways; hit_frame's true baseline at --fixed-fps 60 is 7. Every Godot job goes through `ops/Tools/godot_slot.py run`
  (rule_guard); RED = it waits. Never `cd` out of E:/FightCamp/Lean in a Bash call (the session folder moves).
  `tools/hand_tap.gd` (`-- handtap=RightHand`) and `-- trunktap` name the layer behind a wrist / head jump.
