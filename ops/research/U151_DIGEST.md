# U151 — FightPoseSolver blind contract + mount BEFORE probe

## Part 1 — contract (`fight_pose_solver_contract_test.gd`)

- Live module: `TOTAL=1 fails=0` (parse gate clean).
- Mutants (`mutant=<name>` via `OS.get_cmdline_user_args()`): `center_gap`, `place_pen_on`, `grip_blend_flat`, `one_phase_refine`, `probe_order` — each `fails>0`.
- Checked from header: surface `capsule_gap` sign, `touch_max` scaling, `W_PLACE`/`W_FIT` penetration schedule, `PROBES`, `held_pairs` allowance sum, `refine` three-phase `evals`, determinism, `resolvable_contacts`, `grip_gap` vs `blend`.

### Findings (header clauses not turned into checks)

1. **"Hands yield first"** — not stated in the `FightPoseSolver` header (only in roadmap/synthesis). No numeric rule (root write 0 while hand write non-zero) to assert without reading the body or inventing DOF policy.
2. **`evaluate` return shape** — header lists `cost`, `pen_max`, `pen_pair`, `touch_err`, `touch_max`, `mat_max`, `pairs`; runtime also exposes `held_max`, `grip_max`, `grips_scored`, etc. (documented in later `##` blocks, not the opening contract).
3. **Full public API enumeration** — header names `held_pairs` and `refine` but does not list every `static func`; contract uses grep-backed signatures only where `##` documents behaviour.

## Part 2 — BEFORE probe (`tools/u151_pose_solver_probe.gd`)

Population: **hold `bjj_mount`**, `pair_key=Cascy_Mount`, `Cascy_Mount_Att.glb` / `Cascy_Mount_Vic.glb`, frame **0.0**, att **f01_m_box_welter @ 1.78 m**, vic **f02_m_box_heavy @ 1.88 m** (distinct rigs). Grips/contacts from C171 / `s31_contact_probe` `HOLD_CONTACTS["bjj_mount"]` mapped to capsule names (`forearm_l/r` distal on att `pelvis`, knee/thorax contacts). Metadata via `FightClipBinding.paired_strike_metadata_for` (`bjj_mount` lives in `PAIRED_STRIKE_BINDINGS`, not `PAIRED_BINDINGS`).

Probe table (verbatim run):

```
U151_PROBE hold=bjj_mount pair_key=Cascy_Mount att=Cascy_Mount_Att.glb vic=Cascy_Mount_Vic.glb frame=0.0
U151_PROBE population=att f01_welter 1.78m vs vic f02_heavy 1.88m (distinct rigs)
U151_PROBE grip_id gap_before_m gap_after_m mover delta_m
U151_PROBE left_bottom_frame -0.025562 0.010531 root 2.110017
U151_PROBE right_bottom_frame -0.026661 0.012719 root 2.110017
U151_PROBE refine pass=false pen_max=0.016522 grip_max=0.012719 evals=6805
```

Negative **gap_before** = distal hand slightly inside the target surface (interpenetration). Solver still **fails** `pass` at this seed (`grip_max` ≈ `PASS_GRIP_M`); largest param motion is **root** (DOF seed from pelvis alignment), not isolated hand DOFs — consistent with the missing "hands yield first" header contract.

## Commands

```bash
python Godot/tools/check_scripts.py Godot/tests/fight_pose_solver_contract_test.gd Godot/tools/u151_pose_solver_probe.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_pose_solver_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/u151_pose_solver_probe.gd
```
