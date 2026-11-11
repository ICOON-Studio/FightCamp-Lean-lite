# TASK HUMANFIGHT1 - CLAUDE (Fable 5.2, its own session) - the boxing fight moves like two humans: fix, film, critics, repeat until 7/10

Model: Fable 5.2 (its own desktop session, started by S430 on the operator's ask).
Discipline: boxing (the demo). Grappling is out of scope here.

## The operator's words (S430, 2026-11-11)
"i see some animations the fighters are off the ground flying , can you assign a fable 5.2 agent to make the boxing fight as
close to human-like a spossible and rate the results using critics and loop until it is at 7/10"

## Contract
OWNS: scripts/fight3d/ (the feet, the place and the leg layers: FootLock, FloorStand, ShownRoot, FootPlant, Footwork, RingFeet, RkPure, RkJoin, SideStep, BoxerFootworkRig, the wiring in BoxerBuild and FightStage; never RingCamera, TvShot, RopeFade, CamLine: CAMLINE2), tests/human_feet_test.gd, tools/human_fight_film.gd, tools/human_fight_report.py, tools/film_sheets.py, tools/rest_feet_probe.gd, docs/HUMANFIGHT1_RESULT.md
RED_TEST: tests/human_feet_test.gd
REGRESSION: ring_feet_test, rokoko_clips_test, foot_plant_test, knockdown_still_test, corner_warm_test, boxer_footwork_test, file_limits_test
VISUAL: yes

## What done looks like
1. A film of a REAL bout from the game's own camera (the route the .exe plays, `-- as_game`), where two FRESH critics each
   score "does this move like two human boxers" 7/10 or more. Gemini (the video judge) is the third opinion when reachable.
2. No boxer leaves the floor: a ruler test that is RED on today's main (it measures feet off the canvas on the game path)
   and GREEN on your branch.
3. Each round of the loop is on the ops board (`python ops/Tools/review_add.py --stage S430 --rating "<score, who>" --title
   "<what it shows>" <film or sheet>`), so the operator can watch and comment.
4. Branch `claude/humanfight1` pushed, digest `ops/research/HUMANFIGHT1_DIGEST.md` on it (per round: what was wrong, what
   changed, the scores, what is still wrong). Main collects by diff. You never commit to main.

## The loop (each round)
1. MEASURE on the game path. Round 0 is measurement only: film one whole round of a real bout (two DIFFERENT fighters:
   stats, style, frame) and write down every moment a boxer looks non-human, with the time and the cause in code. Start
   with feet off the canvas (his complaint), then: feet sliding, legs trembling at clip changes, pops at clip joins, hips or
   head jumping, arms through bodies, punches that miss the target by a hand, both standing frozen.
2. RULER FIRST. For the worst defect write a test that reads RED on main through the same code the game runs (never a
   smoothed copy in memory, never a rest pose). Prove it red before you fix. A ruler that cannot go red is void.
3. FIX the cause (not the symptom on one clip). One cause per commit.
4. FILM the same bout again, same seed, same camera.
5. CRITICS: two fresh subagents (model fable) who have not seen earlier rounds, your notes, or any earlier score. Each
   gets: `ops/research/CRITIC_PACK.md` and `ops/research/CRITIC_ACCESS.md` first, then frame sheets cut from the film at 24
   frames a second around the busiest 10 seconds plus 3 other moments (they cannot watch video, so the sheets must show
   motion: consecutive frames, numbered, both boxers head to feet), and the raw rulers' numbers WITHOUT our pass lines. Ask:
   a score 1 to 10 for human-likeness, the defects with frame numbers, and the list of changes that would take it to 10/10,
   most important first, specific enough to build. Different seats each round (a boxing coach, a mocap animator, a
   fight-game animation lead, a TV boxing director, a biomechanist...). Gemini: memory `reference_gemini_ai_studio_judge`
   (AI Studio in his Chrome, FPS 24 per clip, name each move); skip it without stopping if Chrome is not reachable.
6. Both critics 7 or more: stop and report. Otherwise take the top items of their lists into the next round.
   Same low score twice in a row: change the approach (the cause is elsewhere), do not polish.
Stop anyway after 6 rounds, or when `get_usage` shows the weekly Fable window above 85%, and report honestly where it stands.

## Read first (primary sources, in this order)
- `python ops/Tools/prior_research.py feet floor airborne footwork tremble` (research is memory).
- `ops/research/ANIMFIX3_DIGEST.md`, `ANIMFIX2B_DIGEST.md`, `ANIMFIX1_DIGEST.md` (the last Fable animation agent: what it
  fixed, what stayed: legs trembling at clip changes).
- `ops/research/FOOTWORK_CONTRACT_S274.md`, `ops/research/FLYFOOT2_CHAIN_DIGEST.md`, `ops/research/GDSCRIPT_TRAPS.md`.
- Open PRs 168 (LEGTREMBLE4, Qwen) and 163 (LEGTREMBLE3, Cursor): never collected. Qwen's stated root cause ("hold_root_xz
  never fires") was WRONG on reading the code (paths are prefixed first). Read their diffs for ideas, trust nothing in
  their write-ups, re-measure.
- The fight's motion code: `scripts/fight3d/` (FootPlant.gd, FloorClear.gd, Footwork.gd, BoxerFootwork.gd,
  BoxerFootworkRig.gd, BeatClips.gd, FightClips.gd, ExchangeBeats.gd, FightStage.gd). Existing rulers and films:
  `tests/foot_plant_test.gd`, `tests/ring_feet_test.gd`, `tests/boxer_footwork_test.gd`, `tools/ring_feet_probe.gd`,
  `tools/foot_slide_probe.gd`, `tools/clip_feet_probe.gd`, `tools/fight3d_film.gd`, `tools/fight3d_play.gd`,
  `tools/footwork_film.gd`. Find out first WHY the existing foot rulers are green while he sees flying boxers: a ruler
  blind to the defect is the first finding.

## Where you work
- Your own seeded worktree, never the main checkout `E:\FightCamp\Lean` (other seats and the main session edit it):
  `git -C E:/FightCamp/Lean worktree add E:/FightCamp/wt/LEAN_HUMANFIGHT1 -b claude/humanfight1 origin/main`, then
  `powershell -NoProfile -ExecutionPolicy Bypass -File E:\FightCamp\Lean\ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\LEAN_HUMANFIGHT1`
  (without the seed a full editor import drives the PC to 88 C). Use absolute paths; a `cd` moves your working directory.
- OWNS: `scripts/fight3d/` motion files (feet, legs, hips, clips, joins, punch aim), new files under `tests/` and
  `tools/`, your digest. NOT YOURS (other seats are in them now): `scripts/fight3d/RingCamera.gd` and the motion-blur
  add-on (CAMLINE1, Qwen), the fight HUD and side panels (`BodyPanels.gd`, `FightHud.gd`, `ScoreBug.gd`: FIGHTDISPLAY4,
  Cursor), `CornerBar.gd`, `CornerOverlay.gd`, `scripts/ui/CornerStats.gd`, `scripts/state/LiveRound.gd` (main session).
  Baked animation files under `assets/anim/baked/` change only when the cause is in the bake, and you say so.
- No script over 500 lines (several here are at 490 to 500: split before you add).

## PC rules (his machine, no exceptions)
- Nothing opens on his monitors. Godot headless for tests (`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe
  --headless --audio-driver Dummy`, never `_console.exe`). Windowed renders only on the never-shown desktop:
  `python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 --script
  res://tools/<film>.gd -- <out_dir>`. Open images with the Read tool, never with an app.
- EVERY Godot job goes through `python E:/FightCamp/Lean/ops/Tools/godot_slot.py run --who claude-humanfight -- <command>`
  (a guard blocks a bare start; two Godot jobs at a time on the whole PC, never two windowed renders at once).
- Before each heavy job: `powershell -NoProfile -ExecutionPolicy Bypass -File E:\FightCamp\Lean\ops\Tools\pc_watchdog.ps1
  -Once`; RED = wait. Never kill Godot by image name (by PID only). E: is 91% full: films go to `E:/FightCamp/tmp/humanfight1/`,
  keep only the last two rounds' frames, never a manual git gc.
- Parse gate before any test (a parse error hangs a headless test). Run only the tests your change touches, never the full
  suite. The exit code alone is not a pass: read the output.
- Fight stills only through `tools/still_framing.gd` `save_if_framed` (both boxers head to feet). Never test two identical
  fighters.

## Reporting
One line per round to the main session is enough (the score, the worst remaining defect). End with RESULT lines:
`RESULT: tests/<x>_test.gd -> <exact pass line>` for every ruler, the branch name, and the last film's path.

## The one trap
A green test has closed nothing here before: eight sessions once closed a glove defect on checks that could not see it.
Only the film from the game's camera, read by fresh eyes, closes a round.
