# S472 handover (written 2026-11-14 at the end of S471; S470's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S472`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; start the wrap-up at ~385k (S471 began it at 394k: too late for the Miro redraw).
- Never idle while a test or agent runs (the Stop hook blocks it): keep a second item ready that needs no Godot.
- Godot jobs go through `python ops/Tools/godot_slot.py run --who s472 -- <cmd>`. If a run seems hung, `godot_slot.py status`:
  when the operator plays a game the watchdog is RED on memory and the slot queues silently.
- A hidden-desktop job prints nothing without `--log=<file>`. Never `cd` into an agent worktree.
- Do not edit a script while a background test that loads it is running (a probe pair must load the same code).
- THE P0 MIRO MAP: redrawn at the START of S471 only. Cards were changed after (done / next): `where_we_are.py svg` +
  one canvas_update_from_svg FIRST. The frame resize was refused by Miro (a child outside the frame): cosmetic.

## HIS WORDS THIS SESSION
- "Yes, both" -> Turning pro (Q-S294-227) and Knowledge (Q-S294-228) are APPROVED for building, after the fight week.
- He has NOT answered the verdicts on his four flowchart pictures (asked twice). Ask once more at start.

## WHAT S471 DID
- Nightly (ran on S463's code): 6 of 7 new reds green on main. docs/NIGHTLY_TRIAGE_S466.md has the S471 table.
- tools/run_tests.sh reads `FIXED_FPS <n>` from a test's header (default 60). block_meet_test and head_aim_test carry 30:
  they step a punch on a 30 Hz grid and read 2 frames after a seek (0 failures at 30; 10 and 4 at 60). A first try
  (ruler_stand waiting in seconds) was dropped. hit_frame_test is not in the list (9 at 30, 3 at 60): settle its rate.
- Crack: CrackWire.guard_edge (guard / 6 into every exchange: -10 fighting through, -4 defending, the opponent's crack
  pays her), crack_wire_test 0. Card words shortened: the 3D corner card ran 16 px off the right edge. Stills on the board.
- The played fight repeats run to run: HitSnap's inside sway was on global randf(); seeded from the boxer's name. Two
  hit_gap_probe runs print the same lines (33 landed, 1 far). docs/CLASH2_RESULT.md section S471.
- REAR KNEE: GUARDKNEE3 (collected S470) twisted the rear knee 32-34 deg off the toes in steps (boxer_footwork_test 4
  failures; nobody ran it at the collect). Now REAR_BAND_DEG 0 = knee over the rig's foot; boxer_footwork 0, guard_knee
  red again (-0.07 v +0.029) BY DECISION. The band table is in BoxerFootworkRig.gd (`-- kneeband=<deg>` probe arm).
- Design loop: PLANFLOW1 v1 critics Dola 7/8/6, Maria 7/6/6, John 6/5/7 -> v2 queued for Kalli (SQ122) with
  ops/research/PLANFLOW1_V2_FACTS_S471.md. Club week v6 in; critics SQ123 Dola, SQ124 Maria. Kalli also has SQ116 weight
  r3 (sent) and SQ118 coach fit v7. The critic pack was stale on three built mechanics (corrected).
- Qwen: SPEEDFLIP1 collected (doc + tool only). SPLIT471 LAUNCHED 16:34 (worktree LEAN_SPLIT471, branch qwen/split471):
  BoutNight, PunchReach, Clinch off the 500-line limit. It is yours: collect by diff + its tests.

## FIRST
1. Miro map redraw. Nightly 05:00 (first with the FIXED_FPS tags): diff, measure, do not chase.
2. Collect SPLIT471. THEN the leftover lead hook (second of a double, 0.16 m to the side): read PunchReach's target -
   armed once or live? The head is coming back from the first hook's snap. One probe run a side is a fair ruler now.
3. Rear foot + hip placement against the take (guard_knee red). The guard still tool (tools/fight3d_still.gd f01_guard)
   shows the two boxers standing inside each other, legs crossing: check WHEN it shoots (a fresh stage sits at 0.80 m for
   ~3 s before stepping out to 0.88 m) before calling it a game defect.
4. Seats: PLANFLOW1 v2 -> two fresh critics -> his board; club week v6 critics; weight r3 and coach fit v7 -> critics.
5. plan_bots_test red (step answers fire by low step bars): closes with steps past Usable (PLANFLOW1 v2 prices it).
6. Token leak: token_log.csv (49 min on S471: ~40 a minute, far below the old rate; needs the night). Then remove the
   logging block from pc_metrics.ps1.
7. Play the crack card in the exe. CLASH3 leftovers. Build order after the fight week: TURNPRO1, KNOWLEDGE1 (approved).

## NOTES
- Animation item for S472: the double hook (mine, after SPLIT471); Qwen is free once SPLIT471 lands -> rear foot / hip probe.
- 16 worktrees are HELD by `start` (dirty, nothing unpushed) - old seat runs.
