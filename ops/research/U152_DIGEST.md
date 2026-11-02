# U152 digest (Cursor)

## Part 1 — blind `refine_hands` contract
- File: `Godot/tests/fight_pose_solver_hands_contract_test.gd`
- Fixture: **welter_att** (body0, forearm ~0.42 m, r=0.045) vs **heavy_vic** (body1, forearm ~0.52 m, r=0.058); grips on body1 forearms → body0 pelvis.
- Shipped SKIP-green while `refine_hands` absent; after merge from `origin/master`, live run **passes** (`TOTAL=1 fails=0`).
- Mutants (no `--`): `root_moves`, `no_copy`, `worse_ok`, `ignore_budget` — each **fails** on live implementation.

## Part 2 — AFTER probe (arm B)
- Extended `Godot/tools/u151_pose_solver_probe.gd`: `refine_hands` on same bjj_mount f01 welter 1.78 m vs f02 heavy 1.88 m, frame 0.
- **Finding:** grips reach pass with roots frozen — `grip_max=0.006020` ≤ `PASS_GRIP_M=0.012`; `root_moved=0.000000`. Largest movers are **arm/hand**, not root (contrast U151 `refine`: root 2.11 m).
- Per-grip gaps (m): `left_bottom_frame` before -0.085183 → after 0.006020; `right_bottom_frame` -0.087096 → 0.001390.

## Gate
- `check_scripts.py` on test + probe: clean.
- No full suite (task tier).
