# TASK_Q155 - is U147's persist-trigger push inert? Prove it, and remove it if so (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S61, 2026-09-23.

## Why
U147 (merged S61) added a "persist trigger" to the room's overlap push in
`Godot/scripts/FightWorldLiveScreen.gd` (`OVERLAP_BUDGET_DEPTH_M`, `OVERLAP_BUDGET_PERSIST_S`,
`OVERLAP_SEP_MAX_STEP_BUDGET_M`, `OVERLAP_SEP_MPS_BUDGET`, `_overlap_deep_s` - grep them; the logic is
near line 2497). Its own digest (`research/U147_DIGEST.md`, 29 lines, read it) printed IDENTICAL
before/after numbers: longest run 0.150 s both, jumps 2/4 both. Code that changes nothing measurable
is a term nobody can see - it passes every gate and misleads the next reader.

## Owned files
`Godot/scripts/FightWorldLiveScreen.gd` (ONLY the U147 lines named above; it is 3,400 lines - never
open it whole, read `sed -n` windows around the grep hits), `research/Q155_DIGEST.md` (new).

## Do
1. Measure on the UNCHANGED tree first: run `tests/fight_room_no_teleport_test.gd`, and record per
   frame A's and B's root positions over one boxing round and one MMA round, seed 94301 (write a
   throwaway script under `C:\Users\user\AppData\Local\Temp`, NOT in the repo).
2. Remove the U147 persist-trigger branch (keep U146's easing untouched) and repeat the identical run.
3. If the two runs are byte-identical: keep the removal. If they differ: restore the code and report
   how often the branch fired and what it changed (frames, max delta). Either way, the digest prints
   both runs' summary numbers side by side.
## Gate
Tier: a script edited. Parse gate on `FightWorldLiveScreen.gd`; `tests/fight_room_no_teleport_test.gd`;
`python Godot/tools/run_tests.py --only room,world,grapple`. Fails there: ceiling is master's count on
the same `--only` - run it first and print both. Branch `qwen/q155-u147-inert`, digest, one
`agent_comms.py send --from qwen --to claude --topic Q155`. Do NOT edit HANDOFF.md.
