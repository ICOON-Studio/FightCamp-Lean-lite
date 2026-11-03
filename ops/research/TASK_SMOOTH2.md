# TASK_SMOOTH2 - the fight's own layers add 377 kinks a minute on top of the clips: cut them (Goose, FightCamp-Lean)
Status: SUPERSEDED (by SMOOTH3, S351)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo).
Why now: operator S316 on the fight vs the raw mocap takes: "the animations look so much better here, but in the fight are
nowhere near that smooth". Still true on main (S334, d604a1c): the probe below says our layers add 377 kinks/min that the
raw clips do not have, 203 of them at a clip change.

## ROUND 2 (S334, after Goose round 1 - read this first; it replaces PASS and Owned files below)
Round 1 (branch goose/issue-10, draft PR #12): the quintic join in JoinSmoother.gd took OURS 378 -> 359/min and the clip-change
kinks 198 -> 169, guard rails held. Keep that work. The round-1 bound was too strict - Claude measured the floor with every
layer off but the join (`-- show3d noguard noreach nosnap noglove nofeet`): OURS 274/min, 170 at a clip change.
- NEW PASS on the smooth_probe line: OURS <= 310/min AND "at a clip change" <= 150. Guard rails unchanged (hit_gap
  `> 0.15 m: 0` and cut off <= 14; inside_guard <= 4 of the inside frames; run_tests.sh 0 failures).
- WHERE THE REST IS (control arms on main): switching off the glove clear saves ~73/min, the punch reach ~57/min. Both ease
  a correction in and out per frame; a weight or push that jumps from one frame to the next is a kink. Smooth them (eased
  weights, a velocity-limited push), never by switching them off - they keep gloves out of heads and punches on the face.
- NEW OWNED FILES: `scripts/fight3d/JoinSmoother.gd` (your round-1 version), `scripts/fight3d/GloveClear.gd` (125 lines),
  `scripts/fight3d/PunchReach.gd` (219 lines). FightStage.gd only as before. NOT HitSnap.gd - the head snap on a landed
  punch is meant to be sharp (operator S301: "the punches feel like they have no power").
- CLEAN THE BRANCH: the round-1 leftover commit added 127 import-generated `*.uid` files - remove them from the branch
  (`git rm --cached` the .uid files that origin/main does not track, commit). Commit only owned files from now on.
- Report the smooth line per arm you changed (`-- show3d` plus `noglove` / `noreach` to show what each layer still adds).

## The red probe (run it first, it must read red on main)
`$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/smooth_probe.gd -- show3d`
(~1 min; `show3d` plays the fight's 3D headless - FightView.enabled). Main today prints:
`SMOOTH RAW baseline: 51 clips sampled | kinks OURS (fight tops the raw clip by > 0.02 m): 377/min (696, 203 at a clip change) | the clip's own: 667/min (1232)`
The run is deterministic (same seed, same numbers every run).

PASS: on that line, OURS <= 250/min AND "at a clip change" <= 110. Bounds, not an exact count.

What the control arms say (S334, same command + one arm): no single layer owns it - `nojoin` 557 (the join smoother
already helps), `noglove` 304, `noreach` 320, `nosnap` 344, `noguard` 397, `nofeet` 377. The kinks are mostly the joins
themselves: 94 clip changes a minute, punches cut after ~0.33 s, and the join smoother's offset decays on a 0.06 s
half-life, which is a velocity jump of its own.

## Owned files (edit only these)
- `scripts/fight3d/JoinSmoother.gd` (132 lines) - the inertialization at a clip change: `DURATION_S 0.3`, `HALF_LIFE_S 0.06`,
  `join()`, the offset decay. The likely fix: decay the carried offset AND its velocity smoothly to zero (Bollo's quintic
  inertialization, GDC 2018 "Inertialization: High-Performance Animation Transitions in Gears of War"; Holden's dead
  blending) instead of a short exponential that snaps the velocity.
- `scripts/fight3d/FightStage.gd` (342 lines) - only `_start()` (lines ~165-181: which half-life/length a join gets) and the
  consts `BLEND_S`, `GUARD_FADE_S`, `GUARD_HALF_LIFE_S`, `GUARD_JOIN_S` (lines ~38-43). Never read or edit the rest.
- Keep both files under 500 lines.

## Guard rails (must stay green - they are the reason a longer blend is not the answer)
- Hits still land: `$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/hit_gap_probe.gd -- secs=150 show3d`
  main: `HIT_GAP landed 25 in 150 s | ... max 0.119 | > 0.15 m: 0 (0 %)` and `HIT_GAP cut off (no hit shown, not counted): 11 of 36`.
  Must stay `> 0.15 m: 0` and cut off no more than 14 of the punches thrown.
- No glove in a head up close: `$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/inside_guard_probe.gd -- show3d`
  main: `INGUARD inside glove deep in a head: 1 of 657 frames`. Must stay <= 4 frames.
- The tests: `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` - 0 failures.

## Evidence
Your PR runs `.github/workflows/fight-stills.yml`: stills from the game's camera + every probe's numbers as a PR comment.
Quote your own probe lines in the report. Claude checks the stills; the operator's OK closes a visual change.

## Prior research
Game repo `research/topics/playback_blend.md` "HOW SMOOTH IS SMOOTH (S119)": continuity of pose and velocity, not long
cross-fades - locomotion/idle 200-300 ms, into a strike 80-150 ms, strike-to-strike <= 100 ms or pose-match; > ~400 ms is the
quality cliff and long blends up close put gloves through heads (G147, Bollo GDC 2018, UE docs). Lean S301 JoinSmoother
header (dead blending), S305 guard fade, S316/S317 tools/smooth_probe.gd (the RAW baseline counts only kinks the fight adds).

## What would a human do?
An animation programmer at a fight-game studio keeps the cut-to-new-clip (no crossfade) and inertializes it: the offset
from the old pose and its velocity decay together to zero along a curve with zero velocity and acceleration at its end
(quintic), so neither the pose nor the speed jumps. Then measures jerk at the joins before and after.

## Prefab check
Godot 4.7 has no inertialization node (AnimationTree crossfades are linear - Q84). Unreal's Inertialization node and
Holden's dead-blending sample are the references; port the math, no plugin.

## The one trap
A longer join reads smoother on the kink count but makes the punch arrive late: hits land from too far or get cut off
(hit_gap) and gloves go through heads up close (inside_guard). Never touch the probes or their thresholds; never touch
the clips. GDScript: `var x := <Variant call>` is a parse error - type it.

## Report
`RESULT: tools/smooth_probe.gd -> SMOOTH RAW baseline ... kinks OURS ...: <n>/min (<total>, <k> at a clip change)` with the
three probe lines (smooth, hit_gap, inside_guard) before and after, and the run_tests.sh summary line.
