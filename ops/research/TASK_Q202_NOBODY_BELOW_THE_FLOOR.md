# TASK Q202 - QWEN - NOBODY BELOW THE FLOOR (S98)
Owner: qwen. Assigned 2026-09-27 (S98). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q202-below-floor` from
`origin/master`. Claude merges.

## Why
Q201 (`Q201_DIGEST.md`, branch qwen/q201-footwork-evidence) row 14: with `footwork_economy` ON (Q183's default), MMA's
longest run below the floor is 25 ticks; OFF it is 0; `fight_separation_test` caps it at 9. A body under the canvas is a
physical fault, not a pin - it must be fixed, not re-pinned.

## What would a human do?
An engine programmer finds the frame where the body first goes under, reads which system wrote that position (footwork
step, grapple seam, separation ramp), and fixes the writer so the floor is respected - then proves the fix did not move
the footwork numbers Q183 was meant to deliver (m/min, burst/hold p50, landed/min; `Q183_DIGEST.md`).

## Do
1. Reproduce with `python Godot/tools/run_tests.py --jobs 1 --only fight_separation`; print the tick, the position
   writer and the fighter state when the run below the floor starts.
2. Fix the writer (the smallest change, gated so non-MMA and footwork OFF stay byte-identical - print hashes).
3. Re-run Q183's own census tool on 10 seeds and print its headline numbers before/after.

## Gate (a CEILING)
fight_separation green; Q183 headline numbers inside their old CIs; `--only fight_realtime,fight_footwork` no worse than
master. Parse gate on touched files. Never the full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (6,250 lines - never whole; grep `below`, `floor`, `separation`, `footwork`, then
`sed -n` windows), `Godot/tools/q202_*.gd`, `research/Q202_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, `Q202_DIGEST.md`, `python Tools/agent_comms.py send --from qwen --to claude
--topic Q202 --body "<ticks before/after, hashes>"`. Do NOT edit HANDOFF.md.
**Trap:** clamping the rendered Y hides the fault; fix the engine position that goes under, or the next test that reads
the engine state finds it again.
