# TASK_U152 - blind contract for FightPoseSolver.refine_hands ("hands yield first") + the AFTER probe (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S63, 2026-09-24.

## Why
U151 found the solver's header never states "hands yield first" and that on bjj_mount the LARGEST
mover is the ROOT (2.11 m). In the live room the two bodies are placed by the ENGINE (S62's
separation floor) and posed by clips; a contact solve that moves a root would undo the engine and
reintroduce teleports. S63 therefore adds a hands-only phase. Claude implements it in parallel on
master; you write its contract BLIND, from the definition below, without reading the implementation
(do not open `refine_hands`'s body even once it lands - read only its `##` header).

## THE CONTRACT (exact names, argument order)
```
static func refine_hands(params: PackedFloat64Array, dofs: Array, build: Callable,
    contacts: Array, holds: Array, root_idx: PackedInt32Array, budget: int = 3000,
    grips: Array = [], anatomy: Dictionary = {}) -> Dictionary
```
Definitions (a DOF is `{"lo","hi","step"}`; `build(params) -> [body0, body1]` as in the header):
1. **Root writes are ZERO.** For every `i` in `root_idx`, `out["params"][i] == params[i]` bit-exact,
   whatever the grips ask for. `out["root_moved"]` is the max abs root delta and reads `0.0`.
2. **A hand write is non-zero when a grip is off.** If the INPUT pose has `grip_max > PASS_GRIP_M`
   and at least one non-root DOF has `step > 0`, at least one non-root param differs from input.
3. **It never makes the pose worse by its own measure.** `out["cost"] <= out["cost_before"]`
   (both evaluated under `W_HANDS`, a new public const Dictionary with the same keys as `W_FIT`).
4. **It reports before and after.** Keys: every key `refine` returns, plus `grip_max_before`,
   `cost_before`, `cost`, `root_moved`. `grip_max` is the after value.
5. **The caller's `dofs` are not mutated** (freezing roots must be done on a copy).
6. **Deterministic**: same inputs twice -> identical `params`.
7. **Budget is a ceiling**: `out["evals"] <= budget + 1`.
8. With NO grips and NO contacts, params come back unchanged (nothing to yield to).

## Part 1 - `Godot/tests/fight_pose_solver_hands_contract_test.gd` (new)
Build your own two-body fixture from capsules (see the header's CAPSULE/BODY/GRIP shapes and
`FightPoseDOF.gd`'s layout, `PER_BODY=12`, root indices 0-3 per body) - two DIFFERENT bodies
(different arm lengths and radii: the identical-fighters rule binds fixtures too). While
`refine_hands` does not exist (`has_method` false on the loaded script), print `SKIP` and pass -
it lands on master during this session. Prove it with mutants passed after the script path with
NO `--` (`mutant=<name>` read from `OS.get_cmdline_user_args()`), at least: `root_moves` (thaw
the roots), `no_copy` (mutate caller dofs), `worse_ok` (accept a worse candidate), `ignore_budget`.
Each mutant must fail; list them in the digest.

## Part 2 - AFTER probe
Extend `Godot/tools/u151_pose_solver_probe.gd` with an arm B that calls `refine_hands` on the same
bjj_mount fixture (Cascy_Mount, f01 welter 1.78 m vs f02 heavy 1.88 m, frame 0) and prints, beside
the BEFORE rows, `grip_id gap_before gap_after root_moved largest_mover`. The finding is whether
the grips reach PASS_GRIP_M with the roots frozen; if not, say which grip and by how much.

## Owned files
`Godot/tests/fight_pose_solver_hands_contract_test.gd` (new), `Godot/tools/u151_pose_solver_probe.gd`,
`research/U152_DIGEST.md` (new). Nothing else - never edit `FightPoseSolver.gd`.

## Gate (tier: new test file + a tool)
`python Godot/tools/check_scripts.py <your files>`; run your test live and under every mutant; run
the probe. No suite. Branch `cursor/u152-hands-yield`, fresh worktree off `origin/master`; on a
"TitleHonours" parse error run `--headless --import` once. `git fetch` and rebase before Part 2 so
`refine_hands` is on your tree. One `agent_comms.py send` per part. Do NOT edit HANDOFF.md.
Trap: a mutant behind `--` tests the REAL module and passes green - no `--`.
