# TASK ANIM-SMOOTH3 - name the layer behind each of the 3 join spikes, then fix it (S198)
Model: Codex gpt-6.1-sol (animation). Worktree E:/FightCamp/wt/PLAYABLE1 (imports built). NEW branch codex/anim-smooth3:
`git fetch && git checkout -B codex/anim-smooth3 origin/master`.
Never open a window, viewer, video player or browser; windowed Godot ONLY via `Tools\godot_hidden.ps1`; open frames/stills with your
FILE tool. Fight stills only through `Godot/tools/still_framing.gd` `save_if_framed` (both men head to feet; never a mat shot).

## Owned files
- `Godot/scripts/FightStagePlayer.gd` (the player boundary where SMOOTH2's join decay lives - grep `_join`/`inertial`, windows <= 200 lines)
- `Godot/scripts/FightInertialize.gd`
- `Godot/assets/data/anim_transitions.json`
- `Godot/tests/anim_smooth3_test.gd` (NEW)
- `research/ANIM_SMOOTH3_REVIEW.md` (NEW)

## Why now
Operator S198 asked whether new fighter meshes would make animation smoother. Ludo round 33 (research/LUDO_ROUND33_S198.txt,
SECTION 4): "A different mesh will NOT fix these issues" - the fix lives in blending, foot plant IK and arm limits. Our own last
measurement is research/ANIM_SMOOTH2_REVIEW.md (READ IT FIRST, all of "Achieved beside wanted" and "Where the acceleration
comes from"): target join p95 < 34,667 deg/s2 in BOTH breathing conditions; retained arm C reached 26,507 ON / 58,927 OFF. Its three
OFF-condition owners, each with a frame witness:
1. jab -> cross, b LeftUpperArm, join 613: frame 615 is the 0.09 s ENDPOINT CLAMP removing an 11.6 deg residual in one frame
   (98,310 deg/s2) - a real defect of the decay envelope.
2. idle -> slip, a LeftUpperArm, join 637: the spike is frame 635, TWO FRAMES BEFORE the switch, inside idle, residual 0 - not the join.
3. cross -> idle, b LeftForeArm, join 637: frame 639 = 63,073 deg/s2 with only 1.8 deg residual, not clamped - a later pose layer.

## Do (diagnose before fixing - the review stopped because it tuned arms without naming causes)
A. For spikes 2 and 3, bisect the pose layers on the same seed/frames: play with each post-clip layer OFF one at a time (breathing /
   alive, guard hold, look-at / head aim, IK, root/spacing, the drawn-modifier pass) - same frames, same CSV - and report which layer
   (or the source clip itself: measure the idle and boxing_cross clips ALONE, no joins, no layers) owns each spike. Print achieved
   beside wanted per arm.
B. Spike 1: replace the hard endpoint clamp with an envelope whose value AND first derivative reach zero at the end (e.g. the decay
   lands on zero by a quintic smoothstep over the last 2-3 frames instead of a one-frame removal). Keep the master API.
C. Fix the layer named in A at its source (smallest change), behind the existing SMOOTH2 switches or one new switch, default OFF.
D. Re-measure exactly as SMOOTH2B did (seed 94400, boxing, `as_game`, 900 drawn frames at 30 Hz, breathing ON and OFF, +/-2-frame join
   window, signed shortest-arc second difference, Tools/smooth_metrics.py) against master with the switches OFF as the control.
Acceptance: join p95 < 34,667 deg/s2 in BOTH conditions, camera / idle / guard within +/-10% of the matched control, zero failed
framing frames. If not reached: ANIM_SMOOTH3_REVIEW.md names the owner of every remaining top-3 spike with a frame witness - no
target relaxed, no switch turned on.

## Test - `Godot/tests/anim_smooth3_test.gd` (pure, headless): the new envelope ends at 0 with zero slope (finite-difference check
at the last 3 samples), never overshoots the residual's sign, and an 11.6 deg residual is removed with no single-frame step > 40% of it.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; the new test exit 0; `python Godot/tools/run_tests.py --only anim_smooth --jobs 2`,
`--only anim_inert --jobs 2`, `--only alive --jobs 2`, `--only camera --jobs 2`: no new red. Two 30 s silent videos (before / after,
1280x720, as SMOOTH2B) under E:/FightCamp/tmp/anim_smooth3/ - Claude opens them.

## Prior research
ANIM_SMOOTH1_REVIEW.md, ANIM_SMOOTH2_REVIEW.md, LUDO_ANIMATION_S192.md (round 9 root causes), LUDO_ROUND33_S198.txt SECTION 4.
## What would a human do?
An animator scrubs the three bad frames, toggles each layer until the pop disappears, and fixes that layer - not the blend time.
## Prefab check
Godot 4.7 AnimationTree inertialization (`AnimationNodeTransition` xfade with inertialization) - say in the review whether it would
replace our FightInertialize at the player boundary.

## The one trap
A pair label is not a cause (spike 2 sits before its switch). Name the layer with an A/B toggle on the same frames before changing any
blend. Commit on codex/anim-smooth3, push; never master; no HANDOFF edit.
