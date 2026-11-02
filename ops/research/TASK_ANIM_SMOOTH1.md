# TASK ANIM-SMOOTH1 - smooth fight animation, steps 0-2 of Ludo's recipe: the measuring tool, the camera spring, the living guard

Model: Codex gpt-6.1-sol (animation work - operator S187 rule "sol for animation"). Worktree E:/FightCamp/wt/ANIMSMOOTH1, branch
codex/anim-smooth1 from master. Push the branch; never master. Never open a window, image viewer, video player or browser. Godot
windowed only via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop, no sound);
look at frames with your file tool only.

Operator S192 (verbatim): "the animations are not feeling smooth , use ludo which is expert in 3d animation to solve our animations
with the help of codex on that". Ludo's diagnosis + numbers + Claude's verdict: `research/LUDO_ANIMATION_S192.md` (READ IT
FIRST, whole - it is short). This task = Ludo's step 1 (camera) and step 2 (idle/breathing) plus the instrument for all five.
Steps 3-5 (separation, inertialization, foot lock) are ANIM-SMOOTH2/3 after the operator sees this video.

## Owned files
- `Godot/tools/record_room.gd` (~330 lines) - add `smooth_log=1`: per DRAWN frame, append one CSV row to the path in
  `smooth_csv=<abs path>`: frame, camera global position, both men's pelvis (Hips) world position, Spine1/Spine2 + both clavicles
  (LeftShoulder/RightShoulder) world positions, both UpperArm/ForeArm global rotations (as quaternions), both feet world positions,
  and each player's current clip name. Read the FINAL pose (skeleton updated - see `_pose_sample`/`bone_world` already in the file).
- `Tools/smooth_metrics.py` (NEW) - reads that CSV (30 fps movie clock) and prints the five numbers below, one line each, plus the
  window it measured. Pure Python + numpy only.
- `Godot/scripts/FightWorldLiveScreen.gd` (6,350 lines - NEVER read whole; grep + sed -n windows): camera = `_fit_camera_pair`
  ~1705 and `_cam_fit_dir` (`step_aim`); switch plumbing beside `_alive_stance` ~847/971/1347.
- `Godot/scripts/FightAliveStance.gd` (72 lines, read whole) - the existing living-guard layer (C204, ON in the game).
- `Godot/scripts/FightStagePlayer.gd` (5,850 lines - windows only): `set_alive_stance` ~7 and where the alive layer is applied
  (grep `_alive_stance`).
- `Godot/tests/anim_smooth1_test.gd` (NEW).

## Prior research
- `research/topics/playback_blend.md` (canonical): settled blend numbers G147 (strike in 80-150 ms, strike-to-strike <=100 ms,
  >400 ms = cliff); gloves read the FINAL pose; root writes capped 3 cm / 10 deg (`OPINION_TELEPORTS_SYNTHESIS.md`).
- `FightAliveStance.gd` header (C204): presentation-only, its OWN RNG - keep it that way (never draw from the fight's RNG).
- The live pulse: `Cardio.from_stamina` (S192 fix, `FightWorldLiveScreen._rr_heart`) - breathing rate reads it.
- `python Tools/prior_research.py camera spring damp follow` and `... alive stance breathing` before writing.

## What would a human do?
Film the fight, measure how jumpy the camera is and how still the guard is, then: put the camera's aim point on a critically damped
spring, and make the guard breathe and shift weight continuously - measure again, same seed, and show the two videos side by side.

## Prefab check
Godot 4.7 has no built-in spring camera; a critically damped spring is ~15 lines (Ryan Juckett / Daniel Holden "spring-roll-call",
both public). Godot's AnimationNodeAdd2 exists, but our clips run through FightStagePlayer, not an AnimationTree - do NOT convert the
player to an AnimationTree in this task; add the breathing/sway as bone offsets in the alive layer the player already applies.

## Spec
0. INSTRUMENT FIRST, on the SHIPPED tree: record `seed=94400 discipline=boxing as_game smooth_log=1` (NOT seed 94301 - it ends in a
   0:30 referee TKO), `--write-movie ... --fixed-fps 30 --resolution 1280x720 --quit-after 900`. `smooth_metrics.py` prints:
   (1) CAMERA: std-dev of the camera's frame-to-frame ACCELERATION (m/s^2) and its count of frames with acceleration > 3x median;
   (2) IDLE: over windows >= 1.0 s with no strike clip on that man, the min / median speed of Spine2 and the clavicles (cm/s);
   (3) SEPARATION: min pelvis-to-pelvis distance (cm) and frames under 55 cm;
   (4) JOINS: per clip change, peak UpperArm/ForeArm angular ACCELERATION (deg/s^2) in +-2 frames; median and 95th percentile;
   (5) FEET: total drift of a foot while its height <= 4.5 cm and speed <= 0.12 m/s (a plant), cm per plant, median and max.
   Save the baseline output to `research/ANIM_SMOOTH1_BASELINE.txt`. Ludo's targets are in LUDO_ANIMATION_S192.md table D
   (his camera/jerk units are wrong - measure acceleration as written here).
1. CAMERA SPRING, room switch `cam_spring` (default OFF in --script runs; NOT in the demo yet): the aim point (and the camera
   position it derives) follows the existing fit target through a critically damped spring, omega_n 6.0 rad/s, zeta 1.0
   (Ludo); camera rotation half-life 0.25 s. The framing guard (both men head to feet, `framing_report()` / still_framing.gd) must
   still pass - if the spring lags a fast advance out of frame, raise omega_n, never drop the guard.
2. LIVING GUARD, room switch `alive_breath` (default OFF in --script runs): extend FightAliveStance so that, on top of its events,
   it adds a continuous layer while no strike/reaction clip owns the upper body: lateral hip sway 1.2 Hz +-2.5 cm, head bob 2.4 Hz
   +-1.8 cm vertical / +-1.5 deg, breathing at BPM/60 Hz with clavicle/upper-spine excursion 0.8 cm at 60 BPM rising to 2.6 cm at
   180 BPM (BPM = the live pulse the HUD shows; feed it from the screen). Fade the layer in/out over 0.15 s when a clip takes or
   releases the upper body, so it never pops. Gloves must stay attached (they read the final pose).
3. After 1+2: re-record the SAME seed with `cam_spring alive_breath` ON, run smooth_metrics, save
   `research/ANIM_SMOOTH1_AFTER.txt`. Make two silent 1280-wide mp4s (imageio-ffmpeg, `-an`, crf 26): before.mp4 / after.mp4
   in `E:/FightCamp/tmp/anim_smooth1/`. Open 6 frames of each with your file tool (both men head to feet in every one).

## Done = (tier: script edited - parse, focused test, related runs)
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
- `anim_smooth1_test.gd` (headless, the pure parts): the spring settles a 1 m step with zero overshoot and within 1.0 s; the
  breathing amplitude at 60 / 120 / 180 BPM is 0.8 / ~1.7 / 2.6 cm; switch OFF = no offset at all. Write it RED first on master
  (paste the fail count).
- `python Godot/tools/run_tests.py --only alive --jobs 2`, `--only camera --jobs 2`, `--only fight_stage --jobs 2` -> 0 fails (paste).
- The metrics: camera acceleration std-dev and spike count DOWN, idle min speed UP from ~0 into 0.8-3.5 cm/s; separation/joins/feet
  unchanged (+-10%) - print before/after side by side in your final message.
Commit + push codex/anim-smooth1. Final message: red count, green results, BASELINE vs AFTER numbers, the two mp4 paths.

## The one trap
The camera and the alive layer are presentation: neither may read or write the fight state, the fight RNG or the engine clock. With
both switches OFF the movie must be byte-for-byte the shipped one (same seed -> same CSV rows) - prove it with one OFF re-record.
