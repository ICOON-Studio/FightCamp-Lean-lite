# TASK Q198 - QWEN - AUDIT THE TWO FEET INSTRUMENTS BEFORE A SIXTH FIX (S97)
Owner: qwen. Assigned 2026-09-27 (S97). QUEUED: launch when Q197 lands (two shell agents max; Cursor U189 holds the
other slot). Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q198-feet-instruments` from `origin/master`.
Research task: you edit NO game script. Tier: parse gate on your own tools only; no suite.

## Why
Five Cursor runs (U184-U188) tried to stop planted feet sliding and knees dipping in boxing footwork; none merged.
U188's own numbers raise a doubt about the INSTRUMENTS, not the feet:
- `tools/u188_kneel_probe.gd` (on branch `origin/cursor/u188-below-baseline`) prints `canvas_world_y=1.2812 m`,
  `footwork_samples=461`, `violations_below_0.25 m=922` - **exactly two knees x 461 samples: every knee on every frame**.
  A knee is ~0.45-0.55 m above its sole. Every knee below canvas + 0.25 m means either the fighters stand ~0.3 m
  below the canvas, or the canvas height or the knee position is read in the wrong frame.
- `tools/u185_planted_slide.gd` (master, c0b8ba95) reports BASELINE p95 0.573 m/s for a PLANTED foot with the planner
  OFF. A planted foot moving at half a metre per second at p95 is itself suspicious; U188 found 31 m/s frames it calls
  "take/lock resets".

## What would a human do?
A technical animator checks the ruler before the animation: drops a known object on the floor, reads its height with
the same code, and scrubs the frames the metric calls worst to see whether the foot visibly moves.

## Do
1. Kneel probe: print, for 5 sampled frames, the canvas height it uses, where it reads it from, each knee's world y, each
   sole's world y (lowest skinned sole vertex - `tools/c213_record.gd` shows how), and the fighter root y. State
   whether the fighters stand on the canvas the probe measured. If the probe is wrong, say which line and why.
2. Slide instrument: on the SAME seed 94301, planner OFF, list the 20 largest per-frame planted-foot speeds with frame,
   beat, clip, lock state and root delta. Classify each: real slide / clip change / lock reset / root teleport. Report
   p95 with and without the non-slide classes.
3. Render 3 of the worst frames (low camera on the feet) via `powershell -NoProfile -ExecutionPolicy Bypass -File
   Tools\godot_hidden.ps1 ...` into `previews/q198/` and say what you see.

## Gate
A digest that answers, with numbers: (a) is the kneel probe's canvas right - yes/no and the evidence; (b) the slide p95
with lock resets and clip changes excluded; (c) the ONE change to each instrument (if any) that would make it measure
the thing, as a proposed diff in the digest - do not apply it to master tools.

## Owned files
`Godot/tools/q198_*.gd`, `research/Q198_DIGEST.md`, `previews/q198/`. Read-only:
`FightStagePlayer.gd` (4,500 lines - NEVER whole; grep `set_foot_lock`, `canvas_floor_world_y`, `_bend_leg`),
`FightWorldLiveScreen.gd` (4,800 lines - NEVER whole; grep `_live_deck_y`).

## Deliver
Commit explicit paths, push the branch, then `python Tools/agent_comms.py send --from qwen --to claude --topic Q198 --body "<canvas verdict; slide p95 raw vs excluded>"`.
Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** a probe that reads its own subject cannot fail - measure the sole from the skinned mesh, not from the bone the
IK wrote.
