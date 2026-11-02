# TASK_Q129 — QWEN — MAKE THE OVERLAP GATE'S FIGHT ACTUALLY START

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto` — auto leaves it with no
shell tool at all), stdin, from your worktree.
**Test tier:** parse gate, then `run_tests.py --only overlap` and SEPARATELY
`--only body`. **`--only` DOES NOT STACK.** No full suite.

## This is your own Q128 finding, followed through

You fixed the dead `arm>head` key and proved the keys are live — `head>arm` now
matches **21,600** frame-part pairs a run where it matched zero forever. Then you
found something bigger, and you were right:

> The match counts are **identical** at 30 FPS and 60 FPS. Since the only thing
> that differs between those runs is `dt`, the skeleton poses are NOT changing
> between frames. The fight is stuck on "waiting for the first beat".

Confirmed independently: the test's own first output line reads
`[FightWorldLive] MMA - seed 810039, 3 rounds | waiting for the first beat`, and
7200/21600/3600 matches over 900 frames is 8/24/4 pairs **per frame** — one static
idle pose measured 900 times.

**So the gate can now SEE overlap and has nothing to look at.** The operator's
standing complaint about the 3D fight is that bodies overlap, and
`Godot/tools/probe_overlap_census.gd` documents **82 frames (9.1%) of real
`head>arm` overlap on seed 810039** — which this test cannot reproduce even once.

## The question, and it is a question before it is a fix

**Why does the room advance under `probe_overlap_census.gd` and not under
`fight_body_overlap_test.gd`?** Both drive the same scene. One of them does
something the other does not.

Find that difference and make the test do it. The census is the working example —
**read it first and copy what it does**, rather than inventing a way to pump the
simulation.

Likely shapes, in the order worth checking:
1. The census may call the room's own advance/tick method directly rather than
   relying on `_process(dt)` firing. A headless `SceneTree` script does not
   necessarily run `_process` on nodes the way a real frame loop does.
2. It may need the scene added to a running tree, and `await process_frame`
   between steps, rather than a bare loop.
3. It may seed or start the bout explicitly — something has to take the room off
   "waiting for the first beat".

**Report WHICH it was.** A fix with no named cause is one the next person
re-breaks.

## Owned files

- `Godot/tests/fight_body_overlap_test.gd` — EDIT.
- `research/Q129_DIGEST.md` — CREATE.

Read `Godot/tools/probe_overlap_census.gd` whole — it is the working example and
the whole point of the task.
Do NOT touch `FightBodyCapsules.gd` or `FightWorldLiveScreen.gd`. If the fix
needs a change in either, **stop and say so in the digest** rather than editing
them — that is a different task with a different blast radius.
Do NOT edit `HANDOFF.md`.

## THE GATE IS A REPORT, NOT A PASS — AND EXPECT RED

If you succeed, the test will very likely go **RED**, because the census says there
are 82 frames of real `head>arm` overlap on this seed. **THAT IS THE DELIVERED
TASK.** Do NOT widen `OVERLAP_ALLOWANCE_M`, do NOT discard frames, and do NOT tune
it green.

Report, whatever the numbers are:

- **the frame count the fight actually advanced through**, and proof it advanced —
  the per-key match counts must now DIFFER between a 30 FPS and a 60 FPS run. That
  difference is the whole proof, so print both runs.
- **the worst `head>arm` depth in metres and the frame it occurred on** (the
  current output says `frame -1`, which means never).
- how close you got to the census's 82 frames, and if you did not reproduce them,
  what still differs.

**If it stays green after the fight demonstrably advances, that is a FINDING and
it needs explaining** — say what population ran and why 82 documented frames did
not appear. Do not report a green as success without that.

## THE TRAP THAT IS THE WHOLE LESSON HERE

**An unchanged measurement is evidence only if the instrument could have read
differently.** This gate was green for weeks over a frozen pose, and the only
reason anyone noticed is that you compared two frame rates and the counts did not
move. **Keep that comparison in the test permanently** — a printed line showing
the pose CHANGED between frames (e.g. a bone position delta, or the match counts
at two dt values) so this can never silently freeze again.

That is worth more than the overlap number itself: it is a non-vacuity check on
the instrument, and this project has been bitten by its absence four times.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_body_overlap_test.gd
python Godot/tools/run_tests.py --only overlap
python Godot/tools/run_tests.py --only body
```

**Read the `.out` file, never the rc** — PowerShell reports exit 1 on qwen's yolo
warning even on a clean run.

## Deliver

Commit on a branch, push, write the digest, send one line with
`python Tools/agent_comms.py send --from qwen --to claude --subject q129-ready`.
