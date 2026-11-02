# ANIMFIX3 - source gate RED; route to OFFBAKE1

Stopped at TASK_ANIMFIX3 step 1. The native MetaHuman guard is also bent:
left 19.274476 degrees, right 27.376961 degrees against the 10-degree ceiling.
Claude should route source correction to OFFBAKE1. No native playback wiring
was attempted. This is a measurement delivery, not a visual fix or acceptance.

Branch: `codex/animfix3`, worktree `E:/FightCamp/wt/ANIMFIX2`.
Base: `3447396c` (origin/master at intake). Measurement commit: `9276ee9a`, pushed.

## Method and source readback

Imported only `Godot/tests/guard_wrist_line_test.gd` from `codex/animfix2b`
by its file diff, then extended its source measurement for the five native GLBs.
No implementation or asset changes from that branch were collected.

Metric: angle between lowerarm-to-hand and hand-to-middle-proximal vectors.
Native names are `lowerarm_l/r`, `hand_l/r`, `middle_01_l/r`.
The existing raw GLB loader and full source hierarchy FK reconstruct the
original local animation on its own rig. No target rest, retarget pass,
pose layer, mirror or foot bake enters the native source measurements.
The test retains independent straight-line and deliberate 30-degree controls.

Guard hold is 0.600 s; guard endpoints are 0 and 20/30 s. Punch contact is
frame 8 at 30 fps (0.266667 s), as specified by ANIMSOURCE1B_DIGEST.md.
All four punches have the same guard endpoint values as the guard clip.

| Native source | Sample | Left wrist deg | Right wrist deg |
| --- | --- | ---: | ---: |
| mh_guard_pose.glb | Start / 0.600 s hold / end | 19.274476 | 27.376961 |
| mh_jab.glb | Contact | 17.305772 | 23.790845 |
| mh_cross.glb | Contact | 20.631015 | 18.186726 |
| mh_lead_hook.glb | Contact | 37.978847 | 18.277352 |
| mh_inside_uppercut.glb | Contact | 14.109761 | 26.231067 |

Punch-contact entries are measurements; this task only specifies the native
guard stop threshold. No new punch threshold was invented.

## Red witness on today's shipped path

The retained ANIMFIX2B test also ran the current retargeted guard on all four
MH bodies and read back before and after the production pose layer.

| Body | Retarget left deg | Retarget right deg |
| --- | ---: | ---: |
| MH02 | 17.327918 | 19.735910 |
| MH05 | 18.196580 | 16.822177 |
| MH08 | 17.525862 | 21.160148 |
| MH09 | 16.970677 | 19.817135 |

Exact red lines:

```text
WRIST_GATE native guard native_guard_hold Left value=19.274476 limit=10.000000 FAIL
WRIST_GATE native guard native_guard_hold Right value=27.376961 limit=10.000000 FAIL
WRIST_GATE shipped guard MH08 Right value=21.160148 limit=10.000000 FAIL
GUARD_WRIST_LINE failures=18
SUITE total=1 fails=1
```

The 18 failures are six native-guard samples (three times x two hands), two
legacy source-guard assertions, eight shipped-body guard assertions, and two
retained uppercut source-relative assertions (MH08/MH09 right). The latter
are existing-tree observations, not native-path regressions. No runtime or
parse errors occurred in the final measurement run.

## Verification and evidence

- Parse: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Focused: `python Godot/tools/run_tests.py --jobs 1 --only guard_wrist_line`.
  Intentional RED as above; the test remains red until source/playback work
  addresses its assertions. No threshold was relaxed.
- Both commands used a local GODOT_EXE wrapper that runs `pc_watchdog.ps1
  -Once`, refuses RED, and invokes `godot_hidden.ps1` with the absolute GUI
  Godot executable. Watchdog was AMBER (79 C, 86% RAM) for the measurement;
  one worker, no concurrent Godot run from this task.
- `ANIMFIX3_WRIST_READBACK.txt` contains the complete focused-test output.
- `ANIMFIX3_WRIST_READBACK.json` contains 35 stage rows, source SHA-256 hashes,
  clock, metric and failure counts.
- `git diff --check` passed before the measurement commit.

## Stop scope and next action

Step 1 explicitly says to stop if the native guard exceeds 10 degrees. Thus
steps 2-4 (runtime binding RED/GREEN, native_mh_clips wiring, game-camera A/B,
face-box per still and sole rerun) were not executed. No new stills or S226
review item were created; there is no changed playback to compare or accept.
The all-four-bodies native ON bound remains untested. No production scripts,
GLBs, *.import files, mirror, foot bake or ROOMS3 files were changed.

Task-specific rules override the generic CLAUDE.md parallel-jobs and master-
push rules: jobs=1, hidden launcher only, and pushes only to codex/animfix3.
The requested digest and AgentComms note carry this stopped task's handoff;
Claude owns the durable HANDOFF update and OFFBAKE1 assignment.

Next: correct the native guard wrists offline in Cascadeur, propagate the
corrected guard into the four punches, rerun these source measurements, then
resume ANIMFIX3 at the runtime binding witness. Contact measurements above
are available to guide that source work. No claim of player-facing improvement.
