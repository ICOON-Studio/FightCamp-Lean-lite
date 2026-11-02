# TASK U188 - CURSOR - BELOW THE BASELINE: PLANTED FEET THAT DO NOT SLIDE, KNEES ABOVE THE CANVAS (S94)
Owner: cursor. Assigned 2026-09-27 (S94). HELD until a shell slot frees (max two shell agents; Qwen Q195 and Codex
C213 hold them at assignment). Model: composer-2.5 (Cursor pool), normal effort.
Branch: `cursor/u188-below-baseline`, cut from YOUR `cursor/u187-planted` (bfd3cdd9) in Temp/FightCamp-U171.
Do NOT merge master into it; Claude merges. If the quota runs out, COMMIT AND PUSH with a digest saying where you stopped.

## Why
U187 was NOT merged (S94). Its own report, on the UNCHANGED c0b8ba95 instrument (seed 94301): baseline 0.573,
mutant 0.769, **AFTER 0.638 m/s** - it undid most of U186's regression (0.981) but is still WORSE than master, and the
kneel probe (`u187_kneel_probe.gd`) reports 924 knees below canvas + 0.25 m because the IK guard still uses hips - 0.92
instead of the measured canvas. Your U187 digest lists four fixes that worked; keep them.

## What would a human do?
A locomotion animator pins a planted foot in WORLD space (zero slide by construction) and moves the root only when a
foot steps. They check it by scrubbing the feet in a low viewport and they measure the floor from the scene, not from
an assumed height.

## Do
1. Keep the instrument: `tools/u185_planted_slide.gd` must stay byte-identical to c0b8ba95.
2. Print, per slide spike > 0.3 m/s: frame, leg, beat, lock state, root delta, which code path moved the toe. Find the
   remaining path that moves a locked toe (the four U187 fixes cover hold_root; look at beat changes and re-seats).
3. Replace the kneel guard's hips - 0.92 with the canvas height read from the scene; clamp the knee above it.

## Owned files
`Godot/scripts/FightStepPlanner.gd`, `Godot/scripts/FightStagePlayer.gd` (lock/step/`_bend_leg` sections only - about
4,500 lines, NEVER open whole; sed -n windows around `set_foot_lock`, `foot_lock_stats`, `_bend_leg` and your
U184-U187 hooks), `Godot/tools/u188_*.gd`, `research/U188_DIGEST.md`, `previews/u188/`.

## Gate (a CEILING - over-deliver and say so)
- UNCHANGED c0b8ba95 instrument: p95 **below baseline 0.573 is the floor to merge**; 0.287 is the target. Print BASELINE,
  MUTANT, AFTER side by side (mode flags take no `--`).
- Kneel: 0 knees below the MEASURED canvas + 0.25 m on idle/footwork beats; print the canvas height.
- docs/previews/u188/feet.mp4 (low camera on the feet, 10 s) - Claude watches it before merging.
- Parse gate on touched files; `python Godot/tools/run_tests.py --jobs 2 --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage` no worse than master.
Any windowed render: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Deliver
Commit (paths on the commit line), push the branch, `research/U188_DIGEST.md`, one line with
`python Tools/agent_comms.py send`. Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** relabelling a sliding foot as stepping. The number must fall because the toe stops moving.
