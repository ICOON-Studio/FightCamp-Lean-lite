# TASK_Q165 - "no ground game at all, no take down": why the live MMA room almost never reaches the mat (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S64 handover, 2026-09-24.

## The operator's words (take one, `research/OPERATOR_WATCH_TAKE1_VERDICT.md`)
> 5 , no ground game at all no take down
C184 found it too: seeds 92000-92005 never went to the ground in 60 s; 92012 only fell for 2 s.

## Part 1 - measure, with a named population and a real anchor
Find the real anchor first and cite it: UFC takedowns attempted/landed per 15 min and share of fight time on
the ground (FightMetric/UFCStats aggregates; R133 in this repo measured 25% submissions for grappler-vs-striker).
Write `Godot/tools/q165_ground_census.gd`: 40 MMA bouts on the REAL-TIME path the live room uses
(`FightBeatAdapter`/`FightRealtime`), GRAPPLER vs STRIKER - different styles and attributes inside the MMA
ruleset, both able to do everything (CLAUDE.md: never identical fighters, never an illegal fixture); name ids,
styles and key stats in the output. Print per bout and pooled: takedown attempts, successes, seconds on the
ground, first ground second. Then the same for the fighters and seed the live room uses by default (92012).

## Part 2 - the mechanism, then the fix
Find why grappling is rare: the decision weights that choose a takedown (`FightIntent`), the range gate
(clinch/pocket needed first?), the success roll, or a ground state that ends at once. Print the chain for one
bout: how often a takedown was ELIGIBLE, CHOSEN, ATTEMPTED, LANDED, and how long each ground spell lasted.
Fix the mechanism that breaks the chain (not a raw probability bump), re-run both populations, and report
before/after beside the real anchor. Then record 60 s of seed 92012 and say whether it now reaches the mat
and stays there long enough to see (`tools/record_room.gd` via `Tools\godot_hidden.ps1`; save
`research/_captures/watch_loop/take2_q165_seed92012.mp4`).

## Owned files
`Godot/tools/q165_ground_census.gd` (new), `research/Q165_DIGEST.md` (new), and ONE engine file where the
mechanism lives (`scripts/FightIntent.gd` or `scripts/FightRealtime.gd` grapple section) - name it in Part 1's
send before editing. Do NOT edit GameState.gd or the playback files (Codex C185 / Cursor U155 hold those).

## Gate (tier: a script edited)
Parse gate; `python Godot/tools/run_tests.py --only fight_realtime,fight_intent,grapple,fight_scoring,judge_panel`.
Branch `qwen/q165-ground-game`, worktree off `origin/master`, `--headless --import` once first. One
`python Tools/agent_comms.py send --from qwen --to claude --topic Q165 --body "..."` per part. Do NOT edit HANDOFF.md.
Trap: a census whose two fighters are both strikers will "prove" there is no ground game - that is the fixture, not the engine (R132 was retracted for exactly this).
