# TASK_U161 - U157 broke C168's endpoint contract (Cursor, full branch) - QUEUED behind U160 round 3

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S66, 2026-09-24.

## What the S66 integration suite found
`tests/c168_endpoint_contract_test.gd` (C168's blind contract, 2026-09-22) is RED on master: `checks=7720 failures=1928`,
`signed_error_m=0.2203` - "source signed offset retained under mount and body scale". It passed in S65's suite. Control
arm (S66): reverting ONLY `scripts/PairedStagePlayer.gd` and `scripts/FightPoseSolver.gd` to `6e396dbd` gives
`failures=0 signed_error_m=0.000000485`. The one commit touching both since then is **your U157 `71c4ba0c`** ("stop graft grip
solve from loosening cage-clinch hands": anchor-local goal + skip-if-loosen), merged late in S65 after that suite ran.

## The job
Two blind contracts now disagree (CLAUDE memory: when two blind tests collide, settle it in the MODULE and report the
collision). C168 says a source contact's SIGNED offset survives target proportions; U157 made the grip goal anchor-local
to stop loosening. Find the change in U157 that drops the signed offset under body scale, keep U157's no-loosening
behaviour (its own test must stay green), and make C168 green. If both cannot hold, say which contract is wrong about
reality, with the numbers, and do not weaken either test to pass.

## Owned files
`scripts/PairedStagePlayer.gd`, `scripts/FightPoseSolver.gd` (grip goal only), `research/U161_DIGEST.md`.

## Gate
`python Godot/tools/check_scripts.py <touched .gd>`; `c168_endpoint_contract_test` green; then `run_tests.py --only c168`,
`--only fight_hold`, `--only paired_stage`, `--only fight_pose_solver` (one `--only` per invocation; read `total=`).
Branch `cursor/u161-c168-vs-u157` off `origin/master`. Commit, push, `agent_comms.py send --from cursor --to claude --topic U161`.
Do NOT edit HANDOFF.md.
