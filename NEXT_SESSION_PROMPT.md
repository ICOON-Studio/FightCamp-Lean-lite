# S510 handover (written 2026-11-17, end of S509)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S509_DIGEST.md`.

## METHOD (operator S510, CLAUDE.md item 8 - quote this in your first message)
Fight animation: STOP PATCHING. 14 rounds of correction layers scored 4.5-5/10 while the Undisputed / Boxing Manager /
Blood & Canvas studies said the method is wrong (punches recorded per distance, captured reactions, motion matching /
inertial blending - no layers bending arms and heads). Next: FIGHTPLAYER2 - the baseline diagnosis
(ops/research/FIGHTPLAYER2_BASELINE_S510.md, part 3), the full scope (ops/research/FIGHTPLAYER2_SCOPE_S510.md), two fresh
critics judge the scope (owner: "have that judged"; 7+ before his board), his approval, then build it phase by phase.
No new correction layer in scripts/fight3d until v2 is built. No new animation purchase until the baseline says the clips
themselves are the limit (owner: "why should i buy more animations if the ones we have right now are so bad").

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

## MAIN LINE STATE (main-line side session, S511, 2026-11-17 ~21:30)
- FIGHTFILM1 slices 1-9 on main. S511 added (d3c340fbc..7e7a21e25): Game plan lines on filed film claims (GamePlanRows
  film_fit/film_tag: "Film 85%" = Works at best, "Film: confirmed", "Cleared - change this line"; FilmNight.sit_of /
  claim_on); own-bout mode scripts/ui/FightAnalysisOwn.gd (result page tab PUNCH BY PUNCH, History > Analysis, corner
  minute "The round so far"; WHAT DECIDED IT + WHAT THE OTHER CORNER WILL SEE with Fix it on the pads = f.habit_fix);
  AfterFight.keep_tape keeps the last 20 tapes on c.results; scripts/ui/FightAnalysisTape.gd = film night "Write the
  answer" (Game plan over the film) + Fight prep "Watch the tape" (no checks). TapeRoom.gd + tape_room_test REMOVED.
  tests/film_night_test.gd 51 ok (in run_tests list). Stills: tools/fight_analysis_still.gd (hidden desktop) - looked
  right; the film slot is still an empty box (no 3D film in the page yet).
  LEFT: the 3D film in the page's FilmSlot (TapeFilm), the 3D CornerOverlay line (fight3d = animation session), Settings
  fight-log On/Off, "walks the other down" divider words read oddly on your own bout.
- ASKFIGHT1 NOT built on purpose: map v4 critics 5/6 and the owner's 7+ rule. Round 4 queued S511 to Kalli/John/Dola
  (SQ206-208, brief ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md: does the fight week make the date a real trade?). Read the
  answers in `start` (SEAT ANSWERS); build only at 7+ (AskBout/FightLearn are ready, map section 6 lists the menus).
- IN FLIGHT: Qwen ASKPROBE4 (branch qwen/askprobe4, near vs far show with the fight week; collect its PR by diff - it
  only adds tools/ask_probe4.gd + docs/ASKPROBE4_RESULT.md), then MORNINGSPROBE1 queued (dispatch_queue). Ask critics
  SQ206-208 land as ops/research/ASKFIGHT_CRITIC_S511_{KALLI,JOHN,DOLA}.md. With both: map v5, then wire AskBout +
  FightLearn only at 7+ (menus: map section 6; golden path: map 7 step 4).
- CLUB WEEK: S511 wired the WEAK SPOT line (Training > MORNINGS, CoachedMornings.weak_line, training_k_test). v1 (S485 build plan) is wired - day job, loyalty bar/leaving/pro share, film seats. Left and GATED: the second
  class night (ClubDeal.class_cash needs COACHFIT1's coach time; COACHFIT1 critics 6/5, 6/6) and coached mornings
  (CoachedMornings: CHECK 7 with COACHFIT1 + a drawn page). ClubDeal's pad dealer is superseded (Q-242/Q-260 never short).
- Unwired audit (S511): AskBout, FightLearn, ClubDeal, CoachFit, CoachMarket, CoachedMornings, MatPrice, BoutSheet,
  Knowledge, TapeClips (old Tape Room), TrainingWeek; the rest are rulers/tools (BalanceHarness, GroundRules, HeadEase,
  HeadSplit, HookPast, PunchSnap, StandOff). Script: python <scratch>/unwired.py logic = a module no other script names.
- SPLIT500B collected (Qwen PR 352, diff applied, PR closed). CI FIX: run_tests.sh used /e/FightCamp/tmp on the Linux
  runner - every CI test failed since 8d0e67650; now only where /e exists. grapple_fix_test fails 18 on main (pre-existing,
  not in the run list): look at it.
- C: TRAP: every Godot run takes --log-file E:/FightCamp/tmp/<run>.log; a `cd` in Bash moves the session folder.

## ANIMATION LOOP STATE (the animation session's own section; rewritten 2026-11-17 ~21:00, S510 part 2, closed at ~420k tokens)
Owner S510: the fight animation loops in its own session until both blind critics give 7+. Digest: `ops/research/S510_ANIM_DIGEST.md`
(sections "ROUND 13 JUDGED" and "ROUND 14"). You are the ONLY animation session; all scripts/fight3d files are yours except
CornerOverlay's film lines (the supervisor's).
- SCORES: r12 5.0 / 5.0, r13 4.5 / 4.5 (coach / animator). r14 4.5 / 4.5 (punches up to 5 with both; the whole-fight score did not move).
  DO FIRST: r14 put a head inside the other body for 3 frames and the men 5 cm nearer (the coach's first item, "bodies never pass
  through each other"; the animator's third): A/B `-- oldguard` and `hiplag=0` on full 75 s logs (digest "ROUND 14 JUDGED"), fix or
  revert, THEN the lists there: the animator's "no body pops" (head 6 cm a frame) and "a hit man stops punching", the hand home.
- ROUND 14 IS COMMITTED (f9089b106) AND FILMED: `E:/FightCamp/tmp/fightweek/r14blind/` (film, 28 sheets at 30 fps, rulers, both
  briefs, the critics' files when they finish). What it changed: a punch's glove in flight 3-4 frames (ReachDrive.FLIGHT_S),
  guard gloves 5 cm nearer the face (GuardTuck.GUARD), cross reaction 29 -> 21 cm (BeatClips.REACT), slower recovery out of
  a hit (FightStage._start), hip pops 68 -> 11 (KneeCalm.HIP_LAG_S). Head jumps over 12 cm 23 -> 14.
- THE OWNER'S RULE SINCE r13 ("why animations is getting worse?"): a change ships only if it fixes a NAMED defect and adds no
  new visible one - open the sheets yourself before any critic round, not only the rulers. He watches the sheets: he asked
  "reds left leg ?" on a stand-up build where the rear leg went straight (not kept).
- NEXT DEFECTS, in order (from r13's reviews, still open after r14):
  1. THE ARM HANGS at full stretch 4 frames after it lands (r14 ex1 #37-40; ruler "arm left out" median 4): both critics
     want 1-2. The carry hold (PunchReach CARRY_S 0.10) + ReachLimit.HOME_S 0.13; CARRY_S 0.07 was rejected on hit_carry.
  2. BOTH STAND TOO LOW (knees 125, coach wants 150-160). KneeCalm.STAND_* / BoxerFootworkRig._stand is built but ships
     at standstep=0.10 = no rise. READ digest ROUND 14 item 6 before touching it: every form tried either flattened or
     doubled the bounce, straightened the rear leg or sat 8 cm into each step (boxer_footwork_test's bar is 6).
  3. THE LEAD HOOK from the hip with a straight arm (pro_left_hook_v2: the glove drops 27 cm, hand 65 cm from the chest).
  4. A blocked punch moves nothing (gloves 3-8 cm into the face, head rocks 2-4 cm); slips too small to see.
  5. Lunging stances to 0.95 m (shorter step pairs were tried and dropped: the body trailed its place).
  6. The puncher's head 8-14 cm a frame on the way in; waiting inside punching range; both the same boxer on one line.
  7. Not ours: the coach line in the middle of the picture (CornerOverlay; note left for the supervisor).
- TOOLS (E:/FightCamp/tmp/fightweek/s511/): hrun.sh <name> <secs> [args] = a headless bout log + stance and knee lines
  (16 s for 30 s of bout); flight.py (a punch's last four frames), stance.py, punch_trace.py, guard.py; tests.sh <out>
  <names...> (TARGS="..." for control arms) runs fight tests at --fixed-fps 60 through the slot; film_only.sh <out> films
  a round (refuses with a game window open), then cut sheets with `python tools/film_sheets.py <mp4> <dir> <name> <start>
  <secs> --fps 30 --cols 5 --rows 3 --cell 512 --crop 1150:740:385:140` at ex1 13.6 3.0 / ex2 18.9 2.0 / ex3 33.5 2.0 /
  ex4 37.5 2.5 / ex5 59.9 2.5 / wait 44.0 1.0 / wait2 50.0 1.0 (the fight's events keep their times across builds).
  A headless log has film_s = 0: its clock is t + 7.134. Compare rulers on the film or on full 75 s logs; n=3 crosses is noise.
- TEST BASELINES at --fixed-fps 60 after r14: join_return 0, boxer_footwork 0, guard_knee 0, knee_calm 0, ring_feet 0,
  hit_frame 6, block_meet 12, hit_carry 33 (noisy 21-43), punch_speed 45 (was 39: the slower arrival), block_catch 7,
  uppercut_tail 2.
- REJECTED (do not retry blind): PunchReach.CARRY_S 0.07, HeadClear.RISE_MPS 1.6, PunchReachMath.OUT_S 0.12 (retest),
  RingFeet PAIR_M / QUICK_M 0.28 / 0.36, a stand-up capped by the more stretched leg, a plain +5-7 cm rise.
- TRAPS: PunchReach.gd = 500 lines, GloveClear.gd 497, FightStage.gd 489 (new arm code goes in ReachLimit / ReachDrive /
  GuardBox). Edit with exact-string replaces and `assert s.count(old) == 1`. Every Godot run takes --log-file on E: and
  goes through `ops/Tools/godot_slot.py run`; after a SCRIPT ERROR / Parse Error run list the engine processes and kill
  your own by PID (the supervisor's UI scripts can be mid-edit: errors in scripts/ui are theirs). Never `cd` out of
  E:/FightCamp/Lean. Films only with no game window. Weekly usage was 77 % at 20:40 (resets 2026-11-19 16:00).
- FROM r14's CRITICS, for the next briefs and rulers: (a) fix the brief's render line - tools/render_mockup.py takes only the
  HTML path and writes the PNG beside it; (b) rulers_motion's reaction LIST names the reaction clip (a jab can play
  cross_v2_short) while the by-kind table goes by the punch - the coach read them as disagreeing: print the punch in the
  list too; (c) the animator's own ceiling for one-man clips is "about 7 to 7.5; a true 10 needs exchanges captured with
  two boxers together" - his items 1-4 (body pops, a hit man stops punching, nothing passes through, the hand home at once)
  "need nothing new". Mocap packs wait for the end of November (owner S441).
