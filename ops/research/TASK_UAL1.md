# TASK UAL1 - the gym's people move with real motion: Quaternius Universal Animation Library on our MetaHuman bodies

Model: Codex gpt-6.1-sol, reasoning medium. Worktree E:/FightCamp/wt/UAL1, branch codex/ual1 (cut from master).
Operator S207 (verbatim): "Download Quaternius; skip the $17 pack". Every person in the game is a MetaHuman (S207: "i do not want
to see mbfb model anywhere again"). Gym staff today stand in baked boot clips (`assets/anim/boot/calm_idle.res`, `seated_idle.res`);
members and walk-in customers walk with the "walk" clip (GymHall3D WALK_CLIP_NAME). This task gives them Quaternius motion.

## Source (CC0, already downloaded)
`E:/FightCamp/downloads/quaternius_ual/UAL_Standard.zip` (15.2 MB): `Unreal-Godot/UAL1_Standard.glb` (in-place) and the `_RM`
root-motion variant. Unzip to `E:/FightCamp/tmp/ual1/` (a new empty folder), list every animation name in the GLB first and write the
list into `research/UAL1_DIGEST.md`.

## Steps
1. Pick the clips the gym needs (no fighting moves - boxing motion is ANIMSOURCE1's job, never touch certified moves):
   standing idle (2-3 variants, so a room of people does not breathe in sync), walk, walk carrying, sit idle (chair), sit talking,
   standing talk / gesture, phone/typing at a desk, arms-crossed watch, clap/cheer, stretch, drink from a bottle. Fewer if UAL lacks one.
2. Retarget them onto the MetaHuman skeleton with the project's own pipeline: `Godot/scripts/FightClipRetarget.gd` (big file - grep
   `name_map_for`, `retarget_clip`, `_source_frames`; read only those windows) and the way baked station clips carry a `source` meta
   (`Godot/scripts/TrainingFloor3D.gd` `_generator_clip` ~line 1956). Bake each as `Godot/assets/anim/ual/<name>.res` with the
   `source` meta pointing at the imported GLB, which goes to `Godot/assets/anim/ual/UAL1_Standard.glb` (+ `CREDITS.txt`: Quaternius,
   Universal Animation Library, CC0, itch.io URL).
3. Use them: staff idles (`TrainingFloor3D.gd` consts `CALM_IDLE_CLIP`, `SEATED_IDLE_CLIP` and the rooms that pass them:
   Lobby3D, LockerRoom3D, PhysioRoom3D, StaffRoom3D - grep `_add_body(`) pick a UAL idle variant per person (stable by person id);
   the walkers (GymHall3D walk) use the UAL walk on MetaHuman bodies. Keep the old clips as the fallback when a body is not MetaHuman.
4. NEW test `Godot/tests/ual_clips_test.gd` (extends SceneTree, PASS/FAIL lines, quit 0/1): for every baked UAL clip, mount
   `res://assets/models/metahuman/mh_staff_coach.glb`, apply the clip at 5 times across its length, and check: no NaN bone pose;
   both feet within 4 cm of the floor for standing/walking clips (hips height for sit clips within the chair band 0.40-0.60 m);
   head stays above 1.45 m for standing clips; the walk advances 0 m in place (in-place variant) and its feet alternate. It must fail
   on a deliberately broken clip (prove it: bake one with a wrong bone map, watch it go red, delete it).
5. Frame strip for Claude: `Godot/tools/ual_strip.gd` renders each clip on mh_staff_coach and mh_staff_desk at 4 times, a contact
   sheet per clip, to `previews/ual1/<name>.jpg` (1920x1080, whole body head to feet in frame, plain bright background).
   Run it ONLY windowed through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tools/ual_strip.gd`
   (hidden desktop - nothing on the operator's screens). Do not judge the motion from numbers alone - Claude opens the sheets.

## Owned files
- NEW: Godot/assets/anim/ual/** , Godot/tests/ual_clips_test.gd, Godot/tools/ual_strip.gd, previews/ual1/**, research/UAL1_DIGEST.md
- EDIT (clip choice only): Godot/scripts/TrainingFloor3D.gd, Godot/scripts/GymHall3D.gd, Godot/scripts/Lobby3D.gd,
  Godot/scripts/LockerRoom3D.gd, Godot/scripts/PhysioRoom3D.gd, Godot/scripts/StaffRoom3D.gd

## Gates
- Parse gate before any test: `python Godot/tools/check_scripts.py <every touched .gd>`.
- Godot by ABSOLUTE path (your LOCALAPPDATA is redirected): `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/ual_clips_test.gd`
  (never `_console.exe`). Exit code alone is not a pass.
- Then `python Godot/tools/run_tests.py --jobs 2 --only staff,lobby,locker,physio,gym_club,gym_hall,training_floor,walk_in` (use `--jobs 1`
  when `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` is not GREEN). Nothing green goes red. Never the full suite.
- Before any heavy step run the watchdog; RED = wait.
- Commit with `git add -- <files>` on codex/ual1, push the branch, never merge to master.

## The one trap
Quaternius' rig is not Mixamo-named: build the bone name map from the GLB's actual bone list (print it), and check the rest-pose
difference (A-pose vs T-pose) - a wrong rest offset makes elbows-out zombies that still pass numeric checks. Open the frame strips.

## Prior research
`python Tools/prior_research.py retarget idle walk metahuman` - FightClipRetarget's name maps (RamsterZ, Mixamo), the S207 MH lineup,
MH3 (MetaHuman walk, not certified). STAFF1 staff models in `assets/models/metahuman/mh_staff_*.glb`.
## What would a human do?
A technical animator imports the CC0 library once, retargets the ambient set to the project skeleton, checks a contact sheet, and wires
idles with per-person variants so a crowd never moves in unison.
## Prefab check
This IS the prefab (Quaternius UAL, CC0, operator-approved download).
## Rules
Nothing opens on the operator's screens: no image viewers, no browser, Godot windowed only through godot_hidden.ps1. IDLE priority is set by the launcher.
