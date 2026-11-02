---
name: project-session-s99-2026-09-27
description: "S99 - unstaged red leg (MMA seed 99008), Q199 reds sorted into stale values vs defects, fight plan setup screen built (does not move the fight yet), C214/Q200/U190 merged"
metadata:
  node_type: memory
  type: project
  originSessionId: 7f5bfa92-9ef9-4d7f-aec9-7dc6c6d2d855
  modified: 2026-09-27T07:43:52.280Z
---

S99 (2026-09-27) shipped `6baa0532` + merges. See `research/S99_DIGEST.md`.

- Unstaged red leg: `tools/s99_leg_seed_scan.gd` runs the PRODUCTION ROOM's engine copy per seed (room-built begin options,
  not a hand replica). MMA demo fighters: 4/12 seeds reach HURT, all round 3 (~756-852 s). Seed 99008 renders it;
  `tools/s99_render_red_leg.gd` fast-forwards at x8 and sends the corner empty (an empty `confirm()` = the engine's pending
  player corner, so the scan and the render agree to the tick).
- Q199 ruling: stale values (judge_panel T4/T8R/T11, result_screen_why seed, fight_strike_whole hashes) wait until Q202 +
  U191 merge; defects -> U191 (5 footwork side effects), Q203 (jab share, R16, landing order), C215 (footwork seen again).
- Fight plan setup: `FightPlanSetup.gd` (pure) + `GameState.get_plan_setup_view/set_plan_setup` + `FightPlanSetupPanel.gd`
  (button in the camp panel). Knowledge = camp edge `opponent_reads` (mirror-partner weeks) + camp `film_depth`. One camp
  week with the mirror partner and striking_shark/hard_sparring opens BOTH slots (film gains in the same week), so the band
  goes 1.0 -> 0.3 at once. S100 wires it into the engine.
- An agent worktree without a `.godot` import reports audio-import test failures; re-run its subset on the main checkout
  (U190: 14 fails there, 3 here, all nightly-red).
- smoke_test's music check was MP3-loop only; S94's Ogg playlist hands on via `finished -> next_track`.

In flight at handover: Qwen Q202 (FightCamp-Q164), Cursor U191 (FightCamp-U171). Links: [[project-session-S98-2026-09-27]]
