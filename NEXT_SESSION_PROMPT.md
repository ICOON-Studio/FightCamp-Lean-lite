# S471 handover (written 2026-11-14 at the end of S470; S469's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S471`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k (S470 wrapped at ~410k: start the wrap-up earlier).
- Never idle while a test or agent runs: run_in_background and do the next item (the Stop hook blocks an idle turn).
- Godot jobs (tests, films, export) go through `python ops/Tools/godot_slot.py run --who s471 -- <cmd>` (the hook blocks a bare one).
- A job on the hidden desktop prints NOTHING unless `tools/hidden_desktop.py run --log=<file>` is given.
- Never `cd` into an agent worktree in the main shell; read it by absolute path.
- A played-fight probe (150 s) takes ~2.5 minutes, not 5: give estimates from that.
- THE P0 MIRO MAP WAS NOT REDRAWN at the S470 wrap-up (no budget left): `where_we_are.py svg` + one canvas_update_from_svg FIRST.

## HIS WORDS THIS SESSION (quote them)
- "did you trace the memory leak issue ?" -> answered: not yet. ops/AgentComms/token_log.csv held only 15 minutes
  (about +800 tokens, ~1 a second against ~10 a second since boot). Needs a day including the 05:00 run. Read it at start,
  find the minutes with a big delta, name what ran; then remove the logging block from pc_metrics.ps1.
- "just an idea", "another idea" + four generated pictures of the flowchart fight plan (tactics editor, live fight,
  between-rounds swap, pre-fight scouting card). My verdict on each (TAKE / CHANGE / LEAVE OUT) is in
  ops/research/PLANFLOW1_OWNER_PICTURE_S470.md and was given to him in chat. Best new ideas: VALIDATE PLAN before the bout,
  the OPPONENT'S habits drawn as her own tree filled in by scouting, ONE swap between rounds on the tree with the
  corner's read as the reason, a works/countered pair on a bait, one emergency box. Left out by his own rules: percent
  buffs (Q-212), bought moves, exact percents the player cannot know, names in feed lines (S448), a free Simulate button.
  He has NOT answered the verdicts: quote his answer when it comes.

## WHAT S470 DID
- LANDREACH4 (docs/CLASH2_RESULT.md section S470): lead hooks landed low because the footwork's torso layer moved the
  hand 0.16-0.19 m down before the reach and the 0.30 m cap counted from there. `ReachLimit.base` + `Upper.hand_shift`
  (`-- nobodycap` old). Played fight: over 15 cm off 4 of 33 -> 0 and 2 (two runs), block_meet 2 -> 0, hit_frame 11 -> 5.
  The cross was never short: the ruler read the glove a frame early; hit_gap_probe now takes the nearer of the two
  frames around the hit and prints `HIT_GAP layers / arm / range` for every far punch.
- CRACK CARD (LIVERRIBS1 step 4): scripts/state/CrackWire.gd + scripts/ui/CrackStrip.gd, on the 2D and 3D corner minute.
  Pull out (RTD, 35 days) / Defend the side (x0.5, 63 days) / Fight through (x0.6, 84 days, 1 in 10 +28). The other
  corner retires its cracked boxer 40 / 65 in 100 at a bell ("RTD_B", a win). tests/crack_wire_test.gd 0.
  Stills: docs/mockups/s470/ (on the review board). NOT wired: the cracked side's guard penalty; not played in the exe.
- Qwen: LIVERPROBE1 collected (6.0 / 1.00 = 16 % body knockdowns, the shipped knobs stay); GUARDKNEE3 collected (rear
  knee pole from the clip's bend plane, guard_knee_test 0, guard still checked); SPEEDFLIP1 found why punch_speed_test
  flips (FighterLife and the footwork advance by real frame time): verified, two runs at `--fixed-fps 60` print the same
  175 lines (41 failures). tools/run_tests.sh now passes `--fixed-fps 60` to EVERY test: the 05:00 run is the first at it.
- Design loop: Knowledge v3 (Dola 7/7, Maria 7/6) and Turning pro v2 (Dola 7/7, Maria 7/6) pass -> his board
  (Q-S294-228, Q-S294-227). PLANFLOW1 v1 (Kalli, ops/research/DESIGN_PLANFLOW1_V1_WRITE_KALLI_KALLI.md): Dola 7/8/6;
  John (SQ119) and Maria (SQ121) reading. Coach fit: Dola's v6 stops at section 11 and her continuation was about another
  product (discarded): v7 queued for Kalli (SQ118). Kalli also has SQ115 club week v6 (sent), SQ116 weight r3.
- Seat tools: design_loop.reply_only cuts Dola's whole-chat answers down to her reply (a 218k brief could not be sent to
  Kalli); cici's landed check compares letters only on three slices (SQ109 "failed" six times and had landed each time).

## FIRST
1. Redraw the P0 Miro map. Read the 05:00 nightly (first run at fixed 60 fps: expect shifts in 3D tests; diff, do not chase).
2. PLANFLOW1: collect John + Maria; `design_loop.py revise PLANFLOW1_V2 <v1 map> --seat kalli --critics <the three critic
   answers> ops/research/PLANFLOW1_OWNER_PICTURE_S470.md`; two fresh critics; his board. Kalli's four owner questions
   (section 10 of v1) go with it.
3. His answers on Q-227 / Q-228 and on the picture verdicts.
4. SPEEDFLIP1 PR (Qwen): collect docs/SPEEDFLIP1_RESULT.md + tools/speedflip1.gd.
5. Token leak: read token_log.csv.
6. Crack card: play it in the exe (tools/loop_shots.gd `crack` arm shows it); wire CRACK_GUARD (-10, defend -4).
7. BoutNight.gd is at 499 lines, PunchReach.gd 498, Clinch.gd 496: split before the next change in each.
8. CLASH3 leftovers (jab glove x forearm 5 frames, a boxer's own two gloves); pro_left_hook as the second hook of a
   double still lands off in some runs (the played fight is not repeatable run to run even at fixed fps 30).

## NOTES
- 16 worktrees are HELD by `start` (dirty, nothing unpushed) - old seat runs.
- Animation item for S471: the leftover hook (item 8) is mine; Qwen is free after SPEEDFLIP1 lands.
