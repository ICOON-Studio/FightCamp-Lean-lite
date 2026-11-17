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

## MAIN LINE STATE (supervisor session, S510, 2026-11-17 19:50)
- FIGHTFILM1 slices 1-5 on main (f7ed02dfc..968eb965d): fight week FILM NIGHT -> WATCH IT YOURSELF / LET THE COACH WATCH;
  Lock opens the FIGHT ANALYSIS page (FilmNight.films/night/check/file, scripts/state/FilmNight.gd); filed claims show on
  Fight prep, the opponent's file card (bout page, fighter page, rival pop-up) and the 2D corner minute (FilmNight.minute
  via BoutNight._shout: CONFIRMED / CLEARED); coach card 'film checks a night'. tests/film_night_test.gd 26 ok.
  LEFT (map ops/research/FIGHTFILM1_MAP_V3_S495.md 6): Playbook line marks (unconfirmed = Works at best, cleared = change
  this line), result page Punch by punch + History (FightAnalysis needs an own-bout mode), 3D CornerOverlay line (fight3d
  = the animation session's files), Tape Room retire, Settings fight-log toggle, map 7b numbers. Not seen on a still yet.
- Unwired modules (live audit S510): AskBout+FightLearn (Q-209 'fight week first' - fight week is built: next), CoachFit
  (Q-235 approved: mockup + probes first), ClubDeal + CoachedMornings + Loyalty (Q-241 club week v9 'build after the fight
  week'), CoachMarket, BoutSheet, Knowledge (stopped S462), MatPrice (waits the BJJ plan screen).
- Qwen SPLIT500B (grapple trio + MatTreeInfo under 470 lines) launched 18:49, worktree LEAN_SPLIT500B: collect its PR.
- C: TRAP: a crashing windowed film writes a ~4 GB Godot log in 5 s to %APPDATA%/Godot/app_userdata/FightCamp/logs.
  Every Godot run takes --log-file E:/FightCamp/tmp/<run>.log.

## ANIMATION LOOP STATE (the animation session's own section; rewritten 2026-11-17 19:35, S510, session closed at 613k tokens)
Owner S510: the fight animation loops in its own session until both blind critics give 7+. Digest: `ops/research/S510_ANIM_DIGEST.md`.
- LAST SCORED ROUND: r12 = coach 5.0 / animator 5.0. ROUND 13 IS BUILT, COMMITTED AND FILMED, NOT YET JUDGED.
  Film + sheets + rulers + both briefs are ready in `E:/FightCamp/tmp/fightweek/r13blind/` (third film, 19:25, no game open).
- DO FIRST (in this order):
  1. DONE 20:05 (join_return_test passes again): the glove jump was the arm-clash clearance thrown into a runaway by the
     lower free glove and by my cap_up - a guard wrist moved 28-45 cm a frame, back and forth. ArmClash.gd now EASES what
     the clearance moves a wrist by (at most 2.4 m/s of change, 16 cm in all; `-- noclashease`), GuardBox.cap_up only stops
     the upward part. Bout log: guard-wrist moves over 10 cm a frame 37 -> 19 (r12 41), the owner's frames unchanged.
     The film in r13blind was shot BEFORE this easing (same poses, a few more glove pops): re-film only if a critic names them.
  2. (LAUNCHED 19:55 from the old session, results in r13blind/critic_*.md if they finished; else relaunch.) Launch the two FRESH blind critics on r13blind (general-purpose agents, one each for BRIEF_critic_coach.md and
     BRIEF_critic_animator.md; they must not see any critic_* file or earlier score). Record scores in the digest.
  3. The owner watched the first r13 sheets and was angry ("wtf is the right hand of blue fighter doing", "are you
     destroying or fixing animations ?"): the free glove over the head. It is fixed in the third film (before/after sent,
     r13blind/owner_before_after/); his reaction to that is the real gate - read the conversation / the board first.
     Q-S294-269 ("film now or wait") is moot: filmed when he closed the game.
- RULERS WITHOUT A FILM: `python ops/Tools/godot_slot.py run --who anim -- <godot> --headless --audio-driver Dummy
  --fixed-fps 30 --path . --script res://tools/human_fight_film.gd -- <out> secs=75 seed=7 show3d` = the same shown.csv in
  ~4 min, no window (film and headless log agree line for line). `python tools/fight_motion_rulers.py --compare a.csv b.csv`.
- r12 film -> r13 film: head jumps 28 -> 23 (worst 21.1 -> 18.1 cm), arm out median 5.5 -> 4 frames (worst 12 -> 7), free
  glove over the crown 26/41 -> 0/0 frames, paws/feints lead/rear 37/1 + 35/2 -> 20/8 + 21/5, head inside a body 2 -> 0,
  hit head travel 15.0 -> 21.5 cm (jab ~10-14, cross ~29, hook ~19).
- WHAT ROUND 13 CHANGED: both-hand wait beats + occasional weaves (GuardLife); ArmHome on every punch on a real clock;
  the free glove held at the chin while the other hand punches (GuardTuck.FREE_DROP_M) + GuardBox + the clash push going
  outward, never up (GloveClear -> GuardBox.cap_up); the reach's chest lean eases out and never drops (ReachLimit.lean_out,
  no fold lean in the let-go, fades do not lean raw); hit reactions capped 11.3 cm a frame and sized by pools sorted by
  clip size (BeatClips.REACT); a finished burst steps out at once (RangeBreath); ReachLimit.HOME_S 0.13.
- REJECTED TODAY (do not retry blind): PunchReach.CARRY_S 0.07 (hit_carry 31 -> 53), HeadClear.RISE_MPS 1.6 (no gain),
  PunchReachMath.OUT_S 0.12 (retest once join_return is clean: its 4 failures were probably from cap_up).
- NEXT DEFECTS (after the critics speak): a blocked cross still sits on the glove ~4 frames (ex5 #31-34); the puncher's
  head on the way in 12-14 cm a frame; cross reaction a little big (29 cm); the rest walk-out after a burst is slow
  (1.2 m reached in ~10 frames, 1.35 m in ~40); the near rope across the shins (RopeFade.SEE_ALPHA, needs a still).
- TRAPS: PunchReach.gd = 500 lines, GloveClear.gd = 497 (new arm code goes in ReachLimit.gd / GuardBox.gd). Edit with
  exact-string replaces and `assert s.count(old) == 1`. After ANY run that prints SCRIPT ERROR / Parse Error, list the
  engine processes and kill your own by PID: a hung test wrote 17 GB of errors to C: for 90 min today (C: 4.2 GB, RED).
  hit_carry_test is noisy across changes (26 -> 30-43); hit_frame's baseline at --fixed-fps 60 is 7. Every Godot job goes
  through `ops/Tools/godot_slot.py run`. Never `cd` out of E:/FightCamp/Lean. Films only with no game window (Q-267): he
  reopened ArcheAge mid-film once and the supervisor had to stop it. Weekly usage was at 74 % at 19:30.
