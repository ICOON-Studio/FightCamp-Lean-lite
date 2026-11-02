# TASK_U147 - how LONG do bodies overlap now? (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S60, 2026-09-23.

## Why
U146 cut root jumps 73 -> 2 (boxing) and 48 -> 4 (MMA), verified by Claude. It did so by EASING the
overlap push, which trades a jump for some frames of shallow overlap. The lead decision
(`OPINION_TELEPORTS_SYNTHESIS.md`): visible interpenetration <= 3 cm for <= 0.1 s, never deeper.
U146 measured only the DEEPEST overlap (0.053 -> 0.070 m, +1.7 cm, over its own +1.0 cm gate) and never
the DURATION. This task measures it and fixes what breaks the budget.

## Owned files
`Godot/tools/u145_transition_probe.gd` (add the metric), `Godot/scripts/FightWorldLiveScreen.gd` (ONLY
the U146 easing constants/state: `_overlap_sep_m` and its caps - grep them), `research/U147_DIGEST.md`.

## Do
1. Add to the probe, per round: frames with rendered refused-overlap depth > 0.03 m, the LONGEST
   consecutive run (in seconds), and the distribution (p50/p90/max) of run lengths. Boxing and MMA,
   seed 94301, arm A; name the population in the output.
2. If any run exceeds 0.1 s at > 0.03 m: raise the correction speed WHILE depth > 0.03 m (up to the
   0.10 m/frame ceiling) until runs fit - WITHOUT bringing root jumps back above boxing 5 / MMA 8.
   Print jumps and overlap together, before and after.
## Gate
Parse gate; the probe (windowed ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 1280x720 --script tools/u145_transition_probe.gd -- stills=off`);
`tests/fight_room_no_teleport_test.gd`; `run_tests.py --only room`, `--only world`, `--only grapple`.
Branch `cursor/u147-overlap-duration`, digest with the table, one agent_comms.py send. Do NOT edit HANDOFF.md.
