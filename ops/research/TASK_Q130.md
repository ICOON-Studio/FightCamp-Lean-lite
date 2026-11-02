# TASK_Q130 — QWEN — THE 51 FRAMES NOBODY REFUSES

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto`), stdin, from your
worktree `FightCamp-Q114`, on a fresh branch `qwen/q130-unrefused-pairs` cut
from `origin/master`.
**Test tier:** parse gate, then `run_tests.py --only overlap` and SEPARATELY
`--only body`. **`--only` DOES NOT STACK.** No full suite.

## This is your own Q129 finding, followed through

Q129 retracted Q128 correctly — the match counts were structural constants, the
fight was live, and the Head bone moves 1.13 m over 900 frames. Then you wrote
the line this task is built on:

> The census shows **51 frames (5.7%) with penetration**, but none are the
> refused pairs (hand>head, head>arm, head=head). The overlaps are foot=foot,
> leg=leg, arm>leg, etc.

So the gate is green because it refuses three pairs, and the bodies overlap in
one frame in eighteen on pairs it does not look at. **The operator's standing
complaint about the 3D fight is that bodies overlap.** A gate that is green while
that happens is measuring the wrong set.

## The question, and it is a question before it is a fix

**For each of those 51 frames: WHICH pair, HOW DEEP, and is it a defect or
anatomy?**

Two are already known to be anatomy, and you must not "fix" them:
- `femur_l`/`femur_r` on ONE man: **a standing man's thighs touch** (S43,
  measured 0.057 m on f01). Same-body pairs are not what this gate is for.
- A hemispherical cap at a joint overlaps its neighbour by construction (S43).

Cross-body `foot=foot` in a clinch, or `arm>leg` in a takedown entry, may be
real contact and may be a bug. **The number decides**: report each pair's
worst depth in metres and how many of the 51 frames it owns.

## What to build

1. Extend `Godot/tools/probe_overlap_census.gd` (or add
   `probe_unrefused_pairs.gd` beside it — your call, say which) to print, for
   seed 810039, a table: `pair | frames | worst_depth_m | frame_of_worst |
   same_body?`. Same-body rows are printed and marked, never dropped.
2. **Decide, with the number, which cross-body pairs join the refused set** in
   `Godot/tests/fight_body_overlap_test.gd`, and add them. The bar is a depth a
   viewer would see: name your threshold and where it came from.
3. **EXPECT RED, AND RED IS THE DELIVERED TASK.** If adding a pair makes the gate
   fail on seed 810039, that is the finding — report the frame and the depth.
   Do NOT tune the allowance to make it green, and do NOT drop a pair because it
   fails.

## Owned files

- `Godot/tools/probe_overlap_census.gd` — read whole (small).
- `Godot/tests/fight_body_overlap_test.gd` — ~150 lines, read whole.
- `research/Q130_DIGEST.md` — CREATE.
- The live-fight scripts are large: `grep -n`, then `sed -n` windows. Never
  `GameState.gd` (14,837 lines; you do not need it).

Do NOT edit `HANDOFF.md`.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_body_overlap_test.gd Godot/tools/probe_overlap_census.gd
python Godot/tools/run_tests.py --only overlap
python Godot/tools/run_tests.py --only body
```

**Read the output, never the rc.** Your yolo warning makes the shell report exit
1 on a clean run; and a GDScript runtime error leaves rc=0 while printing
`SCRIPT ERROR` lines — that is a failure whatever the counter says.

## THE TRAP

**A same-body pair reported as a cross-body defect.** The census keys are class
pairs; make sure the table says which BODY each capsule belongs to before you
call a thigh-on-thigh reading an overlap between two men. The Q129 non-vacuity
check (Head bone must move > 1 mm) stays in the test permanently.

## Deliver

`git restore --staged AgentComms/messages`; stage explicit paths; commit on the
branch; push; write the digest; one line with
`python Tools/agent_comms.py send --from qwen --to claude --subject q130-ready`.
