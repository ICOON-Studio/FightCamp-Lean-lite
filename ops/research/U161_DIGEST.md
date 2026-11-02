# U161 digest — C168 vs U157 grip goal collision

## Collision

- **C168** (`c168_endpoint_contract_test`): baked joint centres must keep the source **signed** hand→anchor offset (`mount.basis * Δsource`, metres). That is the world-fixed cm delta from `FightClipRetarget.preserve_pair_contacts`, not an anchor-local vector.
- **U157** (`71c4ba0c`): graft bake switched to **anchor-local** goals plus skip-if-loosen. S66: `checks=7720 failures=1928`, `signed_error_m=0.2203`. Reverting only `PairedStagePlayer` + `FightPoseSolver` to `6e396dbd` restores `failures=0`, `signed_error_m=0.000000485`.

## Module settlement (no test edits)

1. **`FightPoseSolver.authored_grip_offset_signed_m` + `grip_effector_goal_actor_space_signed`** — graft IK goals match C168 / legacy `preserve_pair_contacts`.
2. **Anchor-local helpers kept** for loosening witness only (`authored_grip_offset_local_m`, `grip_effector_goal_actor_space`).
3. **`skip_graft_grip_loosening`** — skip IK when both local and signed goals would loosen vs retarget (U157 cage-clinch case). **Disabled** for `bjj_side_control` and `bjj_half_guard` so C168 can lengthen to source offset under mount + body scale.

## Gates (this branch)

| run | result |
|-----|--------|
| `c168_endpoint_contract_test` | `failures=0 signed_error_m=0.000000485` |
| `--only c168` | `total=2 fails=0` |
| `--only fight_hold` | `total=1 fails=0` |
| `--only paired_stage` | `total=1 fails=0` |
| `--only fight_pose_solver` | `total=4 fails=0` |
