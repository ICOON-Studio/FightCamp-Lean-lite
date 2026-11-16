# TASK ZIVAKNEE1 - the boxers' knees stop jerking in the fight

Status: OPEN (S498, Claude main). Discipline: boxing. Model: Ziva Smart, reasoning effort MAX. Seat: Ziva.

## Why now
FIGHT MOTION WEEK (owner S496: "The fight looks terrible should we stop this project ?" -> "One week code push"). Two
blind critics scored the filmed bout 4/10; at the end of the week two NEW blind critics score it again, and under 5/10
the 3D fight leaves the first release. The animator critic's point 7 (`E:/FightCamp/tmp/fightweek/r0/critic_animator.md`
lines 67-70 and 118-126, read them):
- knee shake 4.4-5.6 deg RMS (second difference of the knee angle, 30 fps), 2.7-3.8 deg even with the foot planted;
- 223-328 jerks over 8 deg in 75 s, about 4 a second per knee: "the footwork IK is fighting the clip";
- median knee bend 122-125 deg, too deep: red sits in a squat; a boxing stance opens the knee to 140-150 deg.
His targets: knee shake under 1.5 deg, under 20 jerks a round, hips 4-6 cm higher in the stance.

## Your worktree
`E:/FightCamp/wt/ZIVA_LEAN` is on the old branch `ziva/bodylook1-wip` (BODYLOOK1 was taken over and merged, PR 320 + 324).
Start clean from today's main: `git fetch origin --no-write-fetch-head` is not needed in your own worktree, so:
`git fetch origin`, `git checkout -- "*.import"` (only the re-import noise), `git switch -c ziva/knee1 origin/main`.

## Step 1 - the ruler first (it must read RED on today's film before you change anything)
Write `tools/knee_ruler.py` (pure Python, no packages beyond the standard library). It reads a film's `shown.csv` (one
row per drawn frame per boxer, written by `tools/human_fight_film.gd`; columns `frame, who, clip, ...,
LeftUpperLeg_x/y/z, LeftLowerLeg_x/y/z, LeftFoot_x/y/z` and the Right ones; the LowerLeg point IS the knee, metres, y up)
and prints per boxer and per knee:
- the knee angle per frame (hip-knee-ankle), its median, and how often it is under 130 deg;
- shake = RMS of the angle's second difference, over all frames and over planted frames only (foot speed under 0.15 m/s);
- jerks = frames whose angle changes more than 8 deg from the frame before;
- for the worst 10 jerks: frame, clip, `clip_t`, `phase`, and whether the foot was planted.
`python tools/knee_ruler.py E:/FightCamp/tmp/fightweek/r0/shown.csv` must land near the critic's numbers above; the newest
film of main is `E:/FightCamp/tmp/fightweek/r2b/shown.csv` (that is your BEFORE). `--compare a.csv b.csv` prints both.
Add `tests/knee_ruler_test.py`-style self-check inside the tool (`--selftest`: a synthetic steady knee reads 0 jerks, a
knee with one 12 deg pop reads 1).

## Step 2 - find the cause from the worst jerks (do not guess)
The leg stack, in the order it runs on a fight boxer: the clip -> `scripts/fight3d/BoxerFootwork.gd` +
`BoxerFootworkRig.gd` (the stepping route, the game's default) -> `FootPlant.gd` / `FootLock.gd` (a planted foot holds
its spot) -> `KneeTrack.gd` (the knee over the toes) -> `FloorStand.gd` / `FloorClear.gd`. History: S383 already added
sub-steps, a world low-pass and a soft reach in FootPlant and a side hysteresis in KneeTrack; that fixed the gym films,
not this fight. Use the worst-10 list to say WHICH layer moves the knee on those frames (switch one layer off at a time
with a `--` user arg control arm and re-read the ruler). Write what you found in `docs/ziva/ZIVAKNEE1_result.md`.

## Step 3 - fix it
Likely tools (use what the cause calls for, not all of them): a critically damped knee pole (about a 5-frame time
constant), plant-lock a foot under 0.15 m/s, no IK target change larger than the clip's own change in a frame, the
stance hips 4-6 cm higher so the knee opens to 140-150 deg. Keep each file under 500 lines; a new rule goes in its own
small file with a `-- no<name>` control arm (the tests' OFF arm).

## Film (the only proof)
One film at a time, through the queue (my films and yours never run together):
`python ops/Tools/godot_slot.py run --who ZIVA -- python tools/hidden_desktop.py run --timeout=900 --log=<out>/godot.log
"%LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --path . --windowed --resolution 1280x720 --fixed-fps 30
--audio-driver Dummy --script res://tools/human_fight_film.gd -- <out> secs=75 seed=7` with `<out>` =
`E:/FightCamp/tmp/fightweek/knee_<n>`. Same seed = the same bout, so before and after compare frame for frame.
First run `powershell -NoProfile -ExecutionPolicy Bypass -File ops/Tools/pc_watchdog.ps1 -Once`: RED = wait. The owner is
playing a game on this PC and memory is at 92 %: never two Godot windows, never the `_console.exe`, never kill a Godot
process you did not start (and never by image name). Nothing may open on his monitors.

## Contract
OWNS: tools/knee_ruler.py, scripts/fight3d/KneeTrack.gd, scripts/fight3d/FootPlant.gd, scripts/fight3d/FootLock.gd,
  scripts/fight3d/BoxerFootworkRig.gd, scripts/fight3d/BoxerFootwork.gd, scripts/fight3d/KneeCalm.gd (new, only if needed),
  tests/knee_calm_test.gd, docs/ziva/ZIVAKNEE1_result.md
RED_TEST: tests/knee_calm_test.gd -> KNEE_CALM failures=0 (a headless test of your rule: red before the fix)
REGRESSION: foot_plant_test, knee_track_test, join_return_test, file_limits_test (run each alone, headless:
  `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`; if one of these names does not exist,
  say so and run the tests that preload the files you changed)
VISUAL: yes - the film's `python tools/knee_ruler.py --compare <before> <after>` in the result page, plus
  `python tools/fight_motion_rulers.py --compare E:/FightCamp/tmp/fightweek/r2b/shown.csv <after>/shown.csv` showing no
  ruler got worse (head jumps, steps, spacing). Claude looks at the film before the merge.
NOT YOURS: PunchReach.gd, PopCap.gd, BeatClips.gd, HitImpact.gd, FightStage.gd, RingCamera.gd, the upper body (Claude is
  in those this week). Never delete or weaken a test. Never `tools/run_tests.sh`.
DONE = branch `ziva/knee1` pushed, a PR into main opened (never merged by you), the PR body carrying the before/after
  ruler table and `RESULT: tests/knee_calm_test.gd -> KNEE_CALM failures=0`.

## Prior research
`ops/research/ZIVA_ZIVATREMBLE1_S275.md` + `TASK_ZIVATREMBLE1.md` (your own knee tremble study on the old rig),
commit 68cbd2bce (S383 knee tremble fix: what was tried), `scripts/fight3d/KneeTrack.gd` header (S370, S383c).

## What would a human do?
An animator would put a planted foot's knee on a damped pole and never let the solver answer a one-frame wobble of the
hips; a boxer's knees give slowly, they do not tick.

## Prefab check
None: our own leg stack. `addons/` holds no second IK to swap in.

## The one trap
A calm knee bought by freezing the legs is a fail: the steps ruler (foot lift, steps taken) must not drop, and a
planted foot must still step before the leg runs out of reach (S376 LEGFIX1).
