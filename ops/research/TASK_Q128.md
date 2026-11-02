# TASK_Q128 — QWEN — THE OVERLAP GATE CANNOT SEE THE OVERLAP IT GUARDS

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. Launch `--yolo` (NEVER `auto` — auto leaves it
with no shell tool at all), stdin, from your worktree.
**Test tier:** parse gate, then `run_tests.py --only overlap` and SEPARATELY
`--only body`. **`--only` DOES NOT STACK** — one per invocation, and read
`total=` to confirm how many ran. **No full suite.**

## The defect, found by U124 and not yet fixed

`Godot/tests/fight_body_overlap_test.gd` gates on

```
REFUSED_PAIRS = [hand>head, arm>head, head=head]
```

**`arm>head` is a key `FightBodyCapsules.class_pair_key` CAN NEVER EMIT.** Read
`Godot/scripts/FightBodyCapsules.gd:190-196`: `CLASS_RANK` gives head rank 1 and
arm rank 2, and the function emits `"%s>%s"` with the LOWER rank first — so an
arm-versus-head pair always comes out as `head>arm`, never `arm>head`.

So that entry matches **zero pairs, forever**. Meanwhile
`Godot/tools/probe_overlap_census.gd` documents **82 frames (9.1%) of real
`head>arm` overlap on seed 810039**, and the test prints `ok, worst 0.0000 m`
over a skull inside a shoulder.

**That is the operator's "bodies overlap" complaint with a gate that cannot see
it.** The operator's verdict on the 3D fight was that bodies overlap; this is one
of the reasons nobody caught it.

## What to do

1. **Delete the dead key** `arm>head` and put `head>arm` in its place — the key
   the function actually emits.
2. **Align the tolerance with the one the room uses.** The test must gate on
   `FightWorldLiveScreen.OVERLAP_ALLOWANCE_M` rather than its own private number.
   **Read it, do not copy the value** — a gate that carries a fossil of a constant
   drifts away from the thing it guards. Reference the constant.
3. **Re-run and report the REAL number.** With the live key in place the gate will
   almost certainly go RED, because the census says there are 82 frames of it.
   **THAT IS THE CORRECT OUTCOME AND YOU MUST NOT TUNE IT GREEN.** Report the
   worst `head>arm` depth in metres and the frame count. Do not widen the
   allowance to make it pass, and do not discard samples.

## Owned files

- `Godot/tests/fight_body_overlap_test.gd` — EDIT. Small; read it whole.
- `research/Q128_DIGEST.md` — CREATE.

Read `Godot/scripts/FightBodyCapsules.gd:180-200` for `class_pair_key` and
`CLASS_RANK` — that window only, the file is 360 lines.
Grep `OVERLAP_ALLOWANCE_M` for the room's constant; do not read
`FightWorldLiveScreen.gd` whole.

**Do NOT touch `FightBodyCapsules.gd`.** The ranking function is CORRECT; it is
the test's key that is wrong. Changing the emitter to match the stale key would
break every other caller and is the wrong end of the bug.

Do NOT edit `HANDOFF.md`.

## THE TRAP — AND IT IS THE POINT OF THE WHOLE TASK

**This gate has been GREEN for weeks while the defect it guards was live.** Your
job is to make it able to fail, not to make it pass. A red gate here is a
delivered task.

So the ceiling is written as a REPORT, never as a pass:

- the gate compiles and runs,
- `head>arm` is in `REFUSED_PAIRS` and `arm>head` is gone,
- the tolerance is read from `OVERLAP_ALLOWANCE_M` and not duplicated,
- and **you state the worst measured depth and frame count, whatever they are.**

**If it comes out GREEN, that is a finding and it needs explaining** — say what
population you ran and why 82 documented frames did not reproduce. Do not report
a green as a success without that.

## Second trap — prove the key is live before trusting the red

A key that matches nothing and a key that matches everything look the same from a
distance. **Print how many pairs each `REFUSED_PAIRS` entry actually matched.** A
refused-pair list where three of four entries matched zero pairs is the same
defect wearing a different number, and this is how you would know.

## Population — NAME IT

Seed **810039**, the seed the census used, so your numbers are comparable to its
82 frames. Two DIFFERENT fighters — never two identical ones; identical fighters
are an unreal population and measure the fixture rather than the engine. State
the two fighters and the seed in your own output.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_body_overlap_test.gd
python Godot/tools/run_tests.py --only overlap
python Godot/tools/run_tests.py --only body
```

**Read the `.out` file, never the rc** — PowerShell reports exit 1 on qwen's yolo
warning.

## Deliver

Commit on a branch, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from qwen --to claude --subject q128-ready`.
