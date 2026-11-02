# TASK C114 — CODEX — WHEN IS A FOOT PLANTED? THE CONTACT DETECTOR FOR THE FOOT LOCK (PURE MODULE + ITS TEST)

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a (no sliding) - a build slice: Claude writes the runtime foot lock that calls this.

**Test tier: A NEW MODULE AND ITS NEW TEST, no existing script edited.** Parse gate on both files, then run your test.
No suite. No commit: your sandbox cannot write `.git`; Claude commits.

## Owned files

- `Godot/scripts/FightFootContacts.gd` - NEW. `extends RefCounted`, STATIC functions and constants only, ZERO preloads.
- `Godot/tests/fight_foot_contacts_test.gd` - NEW. `extends SceneTree`, synthetic data only (no scene, no clip).

## Why this exists

Carrying the source hips' travel cut planted-foot skate by 60-85% on single clips, but 0.12-0.33 m/s remains, and the
room also moves bodies a few centimetres between clips. Claude is building a foot lock on Godot's `TwoBoneIK3D`.
Kalli's K44 (`research/K44_FOOT_LOCK_IK.md` - read only its `## DECISIONS` section, the first 12 lines) set
the method: contacts are PRECOMPUTED per take from the foot's own trajectory, with hysteresis, then the lock blends in
and out. This module is that detector - pure arithmetic on arrays, so it is exactly testable.

## THE CONTRACT - exact names, argument order and return shapes (Claude's runtime calls these)

```gdscript
const ENTER_SPEED_MPS := 0.15    ## K44: enter a plant below this horizontal speed (SECONDARY sources)
const ENTER_HEIGHT_M := 0.06     ## K44: and within this height of the floor (s&box 4 cm, Orange Duck ~10 cm)
const EXIT_RATIO := 1.5          ## K44: stay planted until speed OR height exceeds the enter value x this
const MIN_PLANT_FRAMES := 3      ## a touch shorter than this is not a plant
const BLEND_S := 0.12            ## K44: lock blend in / out, 0.10-0.15 s

## Horizontal (x, z) speed of one foot at every frame, m/s. Frame i uses positions[i] - positions[i - 1];
## frame 0 copies frame 1's speed. Fewer than 2 positions, or fps <= 0: every speed is 0.0.
static func speeds(positions: Array, fps: float) -> PackedFloat32Array

## Planted intervals of ONE foot: Array of [first_frame, last_frame] (inclusive ints), sorted, non-overlapping.
## positions: Array of Vector3, one per frame at `fps`; floor_y: the floor's y in the same space.
## A frame ENTERS a plant when height (y - floor_y) <= enter_height_m AND speed <= enter_speed_mps.
## A plant CONTINUES while height <= enter_height_m * exit_ratio AND speed <= enter_speed_mps * exit_ratio.
## The first frame failing that ends the plant (it is not part of it). Plants shorter than min_frames are dropped.
## Empty positions or fps <= 0: [].
static func planted_intervals(positions: Array, fps: float, floor_y: float,
		enter_speed_mps: float = ENTER_SPEED_MPS, enter_height_m: float = ENTER_HEIGHT_M,
		exit_ratio: float = EXIT_RATIO, min_frames: int = MIN_PLANT_FRAMES) -> Array

## Lock weight at every frame, in [0, 1]. 0 outside every interval. Inside an interval: ramps UP over its first
## ceil(blend_s * fps) frames and DOWN over its last ceil(blend_s * fps) frames with smoothstep (3t^2 - 2t^3), 1.0
## between. An interval that starts at frame 0 does not ramp up; one that ends at the last frame does not ramp down
## (the plant continues from or into the next take). An interval too short for both ramps takes the SMALLER of the
## two ramp values at each frame. Weights are exactly 1.0 on every non-ramp frame of an interval.
static func lock_weights(intervals: Array, frame_count: int, fps: float, blend_s: float = BLEND_S) -> PackedFloat32Array
```

Ramp value at a frame k frames into a ramp of n frames (k = 0 .. n-1): `t = float(k + 1) / float(n + 1)`, weight
`3t^2 - 2t^3`. The down ramp mirrors it from the interval's last frame.

## The test `fight_foot_contacts_test.gd` - build every trajectory in code, at 30 fps, floor_y = 0.0

Print one line per check (`ok` / `FAIL`), then `fight_foot_contacts_test: <N> checks, <M> failures`, `quit(1)` on any
failure. Checks, at least:
1. `speeds`: a foot moving 0.03 m in x per frame reads 0.9 m/s on every frame (frame 0 included); one position -> [0.0].
2. Still on the floor for 30 frames -> exactly [[0, 29]]; `lock_weights` all 1.0 (no ramps at either end).
3. Planted 10 frames (0..9) at x = 0, then a swing (frames 10..19: y = 0.15, x = 0.03 * (frame - 9)), then planted
   20..29 at frame 19's x (0.30), y = 0 -> [[0, 9], [20, 29]]. Say in the check label why frame 20 enters (its speed
   from frame 19 is 0 and its height is 0).
4. Hysteresis: planted at rest, then 10 frames at 0.20 m/s (between 0.15 and 0.225) -> stays ONE plant; a foot that
   STARTS at 0.20 m/s on the floor never enters.
5. Height hysteresis: planted, then lifted to 0.08 m (between 0.06 and 0.09) at zero speed -> stays planted; lifted to
   0.10 m -> the plant ends.
6. `min_frames`: a 2-frame touch between two swings -> no interval.
7. `lock_weights` on [[5, 24]] over 30 frames at 30 fps, blend 0.12 s (n = 4): frames 0-4 and 25-29 are 0.0; 5-8
   rise strictly and stay below 1.0; 9-20 are exactly 1.0; 21-24 fall strictly; the ramp is symmetric (w[5] == w[24]).
8. A 5-frame interval in the middle: every weight is the smaller of its up and down ramp, all in (0, 1).
9. Degenerate: `planted_intervals([], 30.0, 0.0)` -> []; fps 0 -> []; `lock_weights([], 10, 30.0)` -> ten 0.0s.
10. Determinism: the same call twice returns identical arrays.

## Gate - from the repo root

1. `python Godot/tools/check_scripts.py Godot/scripts/FightFootContacts.gd Godot/tests/fight_foot_contacts_test.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_foot_contacts_test.gd --timeout 300`
   (or the console exe from Python `subprocess.run(..., timeout=300)`, output to a file - never a PowerShell pipe):
   0 failures, and at least 30 checks.
3. `python Godot/tools/run_tests.py --only fight_foot_contacts` prints `SUITE total=1 fails=0`.

## When done

Your last message: the two owned files, the test's final line and the SUITE line. Claude commits.

## The trap

A module with a `preload` cannot be tested alone, and one that reads a clip is no longer pure: this file takes Arrays
and returns Arrays. And do not make `lock_weights` ramp OUTSIDE an interval - a lock pulling a swinging foot toward a
plant it has not reached is the foot yanked to the floor that K44 warns about.
