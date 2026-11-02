# S336 DIGEST - update 38: ground moves grip and keep their own pace; boxing move map rules; popups fixed

2026-11-01. Lean (E:\FightCamp\Lean) main f388b1b + export. Game master 868f45b8 + wrap-up commit.

## What the operator said (verbatim)
- Board answers at start: Q-S294-59 "Yes, those two first"; Q-S294-60 "less shaved heads, hotter and younger please";
  Q-S294-61 "Yes, in that order"; C154 (ground film) "amazing should we make a mechanicv for the player to wire the correct in
  and outs for eaach transition" -> folded into the plan board (WRESTLE_S336 verdict 2 = Q-S294-61 step 4).
- "something was wrong with therminals they were popping up" -> fixed (below).
- Links: 223wrestling.com/flowcharts, grappleflows.com/try ("nice addition to the planning"), sportsreflector.com wrestling,
  wrestleai.app; "lets also progress the wrestling" -> WRESTLE_S336.md, board Q-S294-62.
- Pasted a GrappleMap-style SQL schema, "is this correct" -> answered: right shape (we have it), wrong on who performs a move
  (top/bottom), one attacker per position (roles + mirrors), fixed success rates, no scoring; JSON not SQL.
- "now with theat fix should we use jobs 4 ?" / "the heat fixed" -> yes: --jobs 4 on a GREEN PC (rule_guard, CLAUDE.md s6), Lean
  run_tests.sh runs JOBS=4 (2 beside agents). Evidence: 6 Godot tests + 3 agents peaked 78 C that morning.
- "video looks good" (update 38 film); on the S334 lineup "why the fuck you have 4 blacks ???? add more whites", then "no keep
  them all dont rebuild" -> S337 FACES3: three NEW white women, lineup first.

## What shipped (Lean)
| Commit | What |
|---|---|
| 24f1ea1 | `scripts/grapple/GrappleGrip.gd` (SkeletonModifier3D after GrapplePose): a hand within 4-12 cm of the other body's capsules curls its 15 finger bones (65/85/55 deg, thumb 15/30/35) toward the palm; curl axis per bone = its direction x palm normal (palm side = thumb side), eased in. GrappleBrowser: grips attached, MMA trim (MH_Trim in the corner colour darkened 0.45, no white band). GrappleGraph.clean cuts links ("Escape Https://www.youtube..." showed in the S335 film). Tests: grapple_grip_test (closed tips 4.6 cm from the thumb base vs 9.5 backwards, to wrist 16.2 -> 5.2 cm, 72% of hold hands grip), grapple_graph_test +2 checks. |
| ebdb267 / 771f800 | GROUND2B by the side session: `GrappleTiming.gd` (gap = largest joint move, hips x2, / 0.8 m/s, clamp 0.18-1.2 s; Sekai clips within 25%), GrapplePlayer plays by key times (cubic_interpolate_in_time). grapple_timing_test PASS. |
| 8c6786d | STRIKEMAP1 (Qwen): `scripts/rules/StrikeMap.gd` - 8 cards (outside, long, mid, inside, clinch, own_ropes, opp_ropes, corner), 30 moves card to card, outs/ins/grey_reason/route. Route outside->clinch: step_in, 2-3, 1-6-3, tie_up. |
| 1f28873, f388b1b | run_tests.sh JOBS=4 (xargs -P), grip/timing/strike tests in the list; Lean CLAUDE.md PC rule. |
Film: research/S336_stills/ground_grips_speeds.mp4 (40 s, walk=8), on the review board.

## Popups (Game, outside the repo)
Watcher caught it: Task Scheduler jobs starting `powershell.exe` are handed to Windows Terminal (default terminal "let Windows
decide"), which ignores -WindowStyle Hidden. Board Reconcile flashed every 30 min; Heat Governor / PC Watchdog / RAM Trim loops kept
windows open. All 5 FightCamp tasks now `conhost.exe --headless powershell.exe <same args>` (XML backups in the S336 scratchpad),
loops restarted, popup_probe SILENT. The SpaceGame "ops board" task still starts powershell.exe directly (his other project - offer).
Also: Cursor orphaned 4 Godot runs of its contact test (parents gone, a core each, 76-78 C) - stopped by PID.

## In flight at handover
- GROUND2A (Cursor, wt E:\FightCamp\wt\LEAN_GROUND2A, branch cursor/ground2a): push-out. Collect by hand onto main (GrapplePlayer
  changed under it: put its `out = GrappleContact.separate(out)` line at the end of the new joints_at).
- NEXTSTEP1 (Qwen, wt LEAN_NEXTSTEP1, branch qwen/nextstep1): NextStep.gd road rules.
- Briefs ready: TASK_GREYWHY1 (Cursor after 2A), then the NEXT STEP card UI.

## Traps
- A bone read from outside the modifiers is stale (S307 again): grapple_grip_test walks the finger chain from rest + the grip's
  rotations instead of reading get_bone_global_pose.
- rule_guard blocks any Bash text containing the console exe's name, even inside a prompt heredoc or a sed of CLAUDE.md.
- A PowerShell call with a bash heredoc inside fails to parse as a whole: the Qwen launch before it never ran.
