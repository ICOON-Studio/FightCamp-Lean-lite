# TASK BENCH1 - Ludo's 30-second animation benchmark: a scripted fight segment + frame CSV + grader + the F3 debug overlay

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - animation/engine work). Worktree E:/FightCamp/wt/BENCH1, branch codex/bench1 from
master (ANIM-SMOOTH2B is merged there - its smooth_metrics.py + join attribution are your starting instrument). Push the branch; never
master. Never open a window, viewer, video player or browser; windowed Godot only via
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`; look at frames with your file tool.
Headless: `Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`) from `%LOCALAPPDATA%\Programs\Godot\`.

Operator S192: "the animations are not feeling smooth , use ludo which is expert in 3d animation to solve our animations with the help of
codex on that". BENCH1 builds the ONE measuring stick every later step (HUMAN1-6) is judged on: the same 30 s, the same two boxers,
graded by a script. It changes NO animation itself.

## Owned files
- `Godot/scripts/FightSimScriptHook.gd` (NEW) - the forced-action queue.
- `Godot/scripts/FightRealtime.gd` (8,942 lines - NEVER read whole; grep + `sed -n` windows): ONE hook point where the AI picks an action
  (grep `_choose_action` / `choose_action` / `pick_action`) - if a script hook is set, take its action instead. Switch pattern: grep
  `DEMO_SWITCHES` (~1169) + `as_game()`.
- `Godot/scripts/FightDebugOverlay.gd` (NEW) - mounted by ONE line from `FightWorldLiveScreen.gd` (6,424 lines - windows only).
- `Godot/tools/record_room.gd` (399 lines): add the CSV writer + `bench=1` / `debug_overlay=1` args (see `_args` ~361, `_smooth_sample` ~332).
- `Tools/smooth_metrics.py` (112 lines + SMOOTH2B's additions): add `--bench` grading.
- `Godot/assets/data/bench1_timeline.json` (NEW), `Godot/tests/bench1_test.gd` (NEW), `research/BENCH1_BASELINE.md` (NEW).

## Prior research
- Spec of record: `research/LUDO_ANIMATION_R12_S192.md` section 2 (the timeline, second by second) + section 3 (the overlay) +
  "Claude's verdict (round 12)"; `research/LUDO_ANIMATION_R13_S193.md` lines ~370-500 (file order, `FightSimScriptHook` signatures,
  the 25-column CSV, the grader) + "Claude's verdict (round 13)" (its CORRECTIONS win over Ludo's pseudocode).
- Your own last two runs: `research/ANIM_SMOOTH1_REVIEW.md`, `research/ANIM_SMOOTH2_REVIEW.md` (join attribution: the worst
  sample sat two frames BEFORE the labelled switch - the benchmark CSV must carry the presented clip + its time so that is visible).
- Cast of record: `Godot/scripts/LudoCast.gd` - Leo Vance (red) vs Ray "Meat-Axe" Miller (blue). They differ in stats, style and frame
  (legal; never two identical fighters).

## What would a human do?
Script the 30 s like a stunt rehearsal: a queue of timed actions fed into the sim instead of the AI, record every frame's numbers to a
CSV, and grade it with a script - so "smoother" becomes a number that can go red. Then a dev-only F3 overlay to SEE what the numbers say.

## Prefab check
Godot built-ins only (ImmediateMesh / MeshInstance3D lines for the overlay, FileAccess for CSV). Python: stdlib + numpy (check numpy
is installed; no pandas).

## Spec
1. `FightSimScriptHook.gd`: `queue_action(t_sec, side, action, params)`, `step_tick(sim_t)`, `load_timeline(path)`. When attached, the
   AI decision for that side at that tick is replaced by the queued action (jab, cross, lead_hook, rear_hook, slip_left/right, step
   forward/back/left/right, pivot, clinch_enter, clinch_break, hold_guard, retreat). Actions the engine cannot express YET (e.g. a forced
   miss distance, forced damage) are recorded as "intent" in the CSV and NOT faked - list them in BENCH1_BASELINE.md.
2. `bench1_timeline.json`: Ludo's 8 segments (0-2.5, 2.5-4.5, ... 24.5-30 s) as timed actions; stamina 95 vs 28 and Miller's composure
   35 set at the bell (composure is live behind `ludo_composure` on master).
3. Switch `bench1` (default OFF, never in DEMO_SWITCHES): with it ON, record_room runs the scripted 30 s at the broadcast camera.
4. CSV (record_room `bench=1 csv=<path>`): 60 Hz, the 25 columns of R13 renamed `red_`/`blue_`, PLUS per side the presented clip name
   + clip time + blend mode, so a spike can be pinned to the clip that was really on screen.
5. `smooth_metrics.py --bench <csv>`: one line per Ludo step: `STEP n PASS|FAIL measured=<x> threshold=<y>` (steps 1-9 from R12 section
   1) plus the existing join p95 / camera sigma lines. Steps that today's engine cannot show yet will FAIL - that is the point; never relax a
   threshold.
6. `FightDebugOverlay.gd`: F3 cycles OFF -> MINIMAL -> DETAILED; 3D: CoM sphere + plumb line, base-of-support hull, foot lock discs,
   flinch cylinder, gaze ray (draw what the engine has; mark absent ones "n/a"); 2D panels sit BELOW the Ludo HUD cards (the cards own
   the top corners). Never on in the game: dev key only, plus record_room `debug_overlay=1` for review videos.
7. OFF arm byte-identical: switch off -> the fight log hash equals master's (print both in the test).

## Done = (tier: script edited - parse, focused tests, related runs)
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
- `bench1_test.gd` (headless): the hook replaces the AI for the queued ticks (the log shows the scripted actions at the scripted times
  +-1 tick); same seed twice -> identical log (determinism); OFF -> log hash = master. Write it RED first on master (paste the count).
- `python Godot/tools/run_tests.py --only fight_realtime --jobs 2` and `--only anim_smooth --jobs 2` -> 0 fails.
- Run the benchmark windowed (hidden desktop) at the game camera: `record_room ... -- as_game bench1 bench=1 csv=E:/FightCamp/tmp/bench1/base.csv`
  and once more with `debug_overlay=1` to an .mp4. Grade it: paste every STEP line into `BENCH1_BASELINE.md` - this is the BASELINE that
  HUMAN1-6 must move.
- Extract 3 frames from the overlay video (t=3, 10, 22 s) to `previews/bench1/`; open each with your file tool; both men must
  be head to feet in frame (fight stills go through `Godot/tools/still_framing.gd` `save_if_framed` - never a feet-only or mat shot).
Commit + push codex/bench1. Final message: red count, green results, the STEP lines, the 3 frame paths, the "intent not yet expressible" list.

## The one trap
The benchmark must drive the REAL engine path (the sim picks the queued action, the stage player plays what the sim chose) - never pose
the bodies directly or skip the sim, or the benchmark measures a puppet show and HUMAN1-6 will pass on it while the game stays stiff.
