# TASK BENCH1B - run Ludo's 30 s benchmark for real: the right cast, the game camera, the BASELINE grades + video + stills

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol). Worktree E:/FightCamp/wt/BENCH1B, branch codex/bench1b from master. Push the branch;
never master, never HANDOFF.md, never AgentComms/. Never open a window, viewer, video player or browser; windowed Godot ONLY via
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop); frames with your file tool.
Headless: `Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`). Put `timeout` on every Godot run (300 s headless; 1200 s windowed).

## Context
BENCH1's code part is merged (c319c28e): `Godot/scripts/FightSimScriptHook.gd`, `Godot/assets/data/bench1_timeline.json`, the `bench1`
switch in FightRealtime (OFF by default), `Godot/tools/record_room.gd` args `bench1=1 bench=1 csv=<path> debug_overlay=1`,
`Tools/smooth_metrics.py --bench <csv>`, `Godot/scripts/FightDebugOverlay.gd`, `research/BENCH1_BASELINE.md`.
Spec of record: `research/TASK_BENCH1.md` + `LUDO_ANIMATION_R12_S192.md` section 2.

## Owned files
- `Godot/tools/record_room.gd` (bench path only), `research/BENCH1_BASELINE.md`, `previews/bench1/*`.

## What is missing (your job)
1. CAST: with `bench1=1`, record_room must stage Leo Vance (red) vs Ray "Meat-Axe" Miller (blue) from `Godot/scripts/LudoCast.gd`
   (the same `fighter_from_cast` way `Godot/tests/bench1_test.gd` builds them), not the room's default bout. Two different men - legal.
2. Run it at the game camera: `-- as_game bench1=1 bench=1 csv=E:/FightCamp/tmp/bench1/base.csv` (30 s + bell), then once more with
   `debug_overlay=1` written to `E:/FightCamp/tmp/bench1/overlay.mp4` (--write-movie, --fixed-fps 30).
3. Grade: `python Tools/smooth_metrics.py --bench E:/FightCamp/tmp/bench1/base.csv` - paste every STEP line + the camera and join lines
   into BENCH1_BASELINE.md under "## Baseline (master <hash>)". This is the number HUMAN1-6 must move; never relax a threshold.
4. Stills: frames at t=3, 10, 22 s from overlay.mp4 to `previews/bench1/` - both men head to feet in frame (fight stills go
   through `Godot/tools/still_framing.gd` `save_if_framed`; never a feet-only or mat shot). Open each with your file tool.

## Done (tier: script edited - parse + its test)
- `python Godot/tools/check_scripts.py Godot/tools/record_room.gd`; `bench1_test.gd` still 0 fails.
- The CSV exists with ~1,800+ rows; the STEP lines are in BENCH1_BASELINE.md; 3 stills exist and you describe each.
Commit + push codex/bench1b. Final message: the STEP lines, the CSV row count, the 3 still paths + what each shows.

## The one trap
The CSV must sample the PRESENTED fight (what the camera shows, after the stage player) - not the 20 Hz sim state - or every smoothness
grade measures the wrong thing. Use the bench sampler already on `RenderingServer.frame_post_draw`.
