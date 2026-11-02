# TASK_U151 - the BLIND contract test for `FightPoseSolver`, written BEFORE S63 wires it (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S62, 2026-09-24, for S63.

## Why
S63 wires `Godot/scripts/FightPoseSolver.gd` (surface gaps, three phases, partner-IK grips; today
wired to NOTHING) into the live room for the paired holds, because C170's closed guard failed its
own gate twice on ankle drift 52% / wrist drift 129% and the cause is the paired mount path, not the
authoring. Before Claude wires it, a test written from the module's HEADER CONTRACT alone - by
someone who has not read the body - is worth more than any test Claude writes afterwards (U148 and
U150 both proved it this week).

**Part 1 (blind):** you may read ONLY the `##` header comment of `Godot/scripts/FightPoseSolver.gd`
(`sed -n '1,/^[^#]/p'` - stop at the first non-comment line) and `research/S30_THE_PAIRED_POSE.md`.
Do NOT read the solver's body, `FightWorldLiveScreen.gd`, `PairedStagePlayer.gd` or any test.
Write `Godot/tests/fight_pose_solver_contract_test.gd` from the header's stated contract: every
public static function it names, its argument order, its return shape, the three phases in order,
what "hands yield first" means in numbers (a root write must be 0 while a hand write is non-zero
when both could fix the same gap), determinism (same inputs twice, identical output), and the
surface-gap sign convention. Five MUTANT stubs (inline, selected by `-- mutant=<name>`), each
caught. If the header is too vague to write a check from, THAT is a finding: list every clause you
could not test and why, in the digest - Claude will sharpen the header before wiring.

**Part 2 (after Part 1 is committed, read ban lifted):** a headless probe
`Godot/tools/u151_pose_solver_probe.gd` that loads the two halves of ONE owned paired hold
(`bjj_mount` - use `FightClipBinding.PAIRED_BINDINGS` and `PairedClipMount`; read only what you need
by grep), poses them at frame 0 as the room would WITHOUT the solver, runs the solver on the pair
record's grips, and prints per grip: gap before (m), gap after (m), which body moved (hand / arm /
root) and by how much. Population named (the hold key, the two files). No room, no scene tree
beyond what the mount needs. That table is the BEFORE for S63.

## Owned files
`Godot/tests/fight_pose_solver_contract_test.gd` (new), `Godot/tools/u151_pose_solver_probe.gd`
(new), `research/U151_DIGEST.md` (new). Nothing else; no script edited.

## Gate
Tier: new test + new tool only. Parse gate on both; the contract test prints `TOTAL=N fails=0` on the
real module and `fails>0` on each of five mutants; the probe runs headless once and its table is in
the digest verbatim. No suite. Branch `cursor/u151-pose-solver-contract`, one `send` per part
(`--from cursor --to claude --topic U151`). Do NOT edit HANDOFF.md. Fresh worktree: branch off
`origin/master`; on a "TitleHonours" parse error run `--headless --import` once.
Trap: `get_bone_global_pose()` returns ZERO on a skeleton Godot has not refreshed (U148's finding);
compose the chain from `get_bone_pose()` when you read a pose you just wrote.
