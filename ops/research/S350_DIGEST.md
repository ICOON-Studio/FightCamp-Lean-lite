# S350 DIGEST (2026-11-01) - update 51: the corner card redone, five runs collected or audited

Lean commits: 20b9040 GroundRules, 5f94814 SMOOTH3 r1, 64fe0f5 PadWork, a6df1e3 FightStage ropes guard, 2569269 corner card.
Build exported (Builds/FightCamp.exe, update 51 in WHAT_TO_TRY.txt). run_tests.sh JOBS=2: 88 PASS.

## Operator this session
- "training pictures are not so great" - about TRAINCLIPS1's session pictures (Claude had failed round 1 too). Sent back twice.
- Q-S294-73 (training board keep/change) still unanswered on the board.

## What landed
1. **C197 corner card** ("doesnt look good, needs a lot of refining"). CornerOverlay: the card takes the right of the frame
   between the bars, full height; while it is up every corner shot pans (`CornerShots.frame_at`, look point offset from the
   lens's FOV) so her face sits in the open part on the left - before, the card covered her and the left showed the coach's
   back. The round first, then numbered steps: 1 the minute (recover / open with / say), 2 fix one habit, 3 the plan (the pick
   sends her out). Plans as two wide columns (`CallButtons.corner_grid(..., 2, true)`: call, when, grade; numbers on hover).
   Root cause of the grey recover row: `CornerJobsRow` used UI.gd's light palette (ink #22262e) on the dark TV card;
   `build(..., tv = true)` now takes the screen's palette. Open: the body figure is a pale mannequin in a white kit.
2. **GroundRules** (Qwen GROUND3 r2 1cafef0) + Claude: every guard sub is the bottom man's (Qwen gave 45 % of guard
   guillotines to the top man), the half-guard kimura is tried (top, 35 % of half-guard ticks), recover-guard escapes use
   G144's 1.40 (0.30-3.0). All-rounders ground 20.6 %, sub finishes 18.5 %; BJJ v wrestler 28.2 % > wrestler v striker
   21.3 %; pass 80v40 = 5.8x. Added to run_tests.sh.
3. **SMOOTH3 r1** (Goose 3d55566) + Claude. Goose's dead blend kept. Claude: `_pending` was cleared after one frame, so a join
   that waited for the new clip's pose (every return to guard from animation_finished) was never captured; GloveClear's
   cap limited the push SIZE (glove stayed in heads) -> a soft C1 knee (SOFT_M 0.04); GuardTuck edit reverted (same ramp);
   PunchReach's cut-off fade eased. smooth_probe --fixed-fps 30: main 386/min (189 at a clip change) -> 312 (121); nojoin 557.
   Arms: noreach 238, noglove 248, notuck 312. hit_gap > 0.15 m: 0 (a 1-far regression from scaling the striking hand's
   clearance was found and reverted), inside_guard deep 1/657.
4. **PadWork** (Goose PADWORK1 r4 d6971db): PAD CONTACT 3/3 with real, differing gaps (0.043/0.037/0.053) - ONLY at
   `--fixed-fps 30` (without it the probe's frame count reads mid-punch: 0/3). Claude fixed tools/padwork_still.gd: fixed
   waits (0.3 s / 3.0 s) and no compute_mitt_targets made "last contact" show her in guard; now each still is taken at the
   punch's own contact time. Not on a screen yet. Open: the coach's free hand drops to his hip.
5. **FightStage ropes guard**: a ringless stage (every probe) threw on `_ropes` each frame and skipped stun/side/recover.

## Sent back (audits after two red rounds)
- **CLINCH2 r4** (Goose #14): r3 read CLINCH OK 3/6 on our GPU and on the main checkout (overlap 0.08 m, hands -0.06, digs
  0/5). Audit: CornerIK EASE_S 0.35 s vs a 0.175 s dig reach; the holder's dig starts AT the flank (no travel); probe and code
  flip the flank offset differently (0.2 m apart for one hand); digs fire after the break; probe stage has no ring/referee.
- **SMOOTH3 r2** (Goose #18): PunchReach - `SMOOTH KINK pro_left_hook_v2 boxer 1 LeftHand d 0.596 raw 0.016` (arm solve
  snaps); GloveClear push-rate limit.
- **TRAINCLIPS1 r3** (Cursor): r1 props on her head; r2 (90f7ea9, all 18 bodies, side camera) samples shadow/heavy bag/pads
  at t~0.27 where the arm is back at her face (speed bag's same jab at 0.167 is extended) -> sample at max wrist reach, json
  `reach` >= 0.45 m; mitt edge-on; speed ball on her head.

## Lessons
- Run every probe at `--fixed-fps 30`: frame-counting probes read a different moment at 60 fps (PADWORK1 0/3 vs 3/3).
- A collect worktree (LEAN_BEFORE) had a stale script-class cache (BaseGuertingMotionBlur, missing fonts) - confirm a red
  result on the main checkout before blaming the branch.
- Measure each Claude fix with the guard rails, not just the target probe (the clearance scaling looked smoother and broke
  hit_gap).

## HANDOFF
- Working commit: Lean 2569269 (pushed); Game roadmap/digest commit of S350.
- Runs in flight: TRAINCLIPS1 r3 (cursor, local, wt LEAN_TRAINCLIPS1), SMOOTH3 r2 (goose run 41351646563), CLINCH2 r4
  (goose run 41352119709). All in AgentComms/live_runs.json.
- Exact next action: `git pull && python Tools/agent_comms.py start`, then roadmap now.next_action (1).
