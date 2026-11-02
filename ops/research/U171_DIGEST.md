# U171 digest — standing clinch grips (pass 1)

Population: S31 probe fighters `f01_m_box_welter` vs `f02_m_box_heavy`, binding `mma_dirty_boxing` → `Cascy_CageClinch`, graft solve ON.

## Probe (`tools/s31_contact_probe.gd -- mma_dirty_boxing`)

| contact | authored | before mean / drift | after mean / drift |
| --- | --- | --- | --- |
| vic_rhand_to_att_larm | 0.083 | 0.073 / **13%** | 0.085 / **2%** |
| att_lhand_to_vic_neck | 0.073 | 0.062 / **15%** | 0.073 / **0%** |
| att_rhand_to_vic_neck | 0.097 | 0.098 / 1% | 0.098 / 1% |
| head_to_head | 0.216 | 0.234 / 8% | 0.234 / 8% |
| hip_to_hip | 0.746 | 0.778 / 4% | 0.778 / 4% |

Grip bake: `skipped_loosen` 252 → 45; `unreachable` 0.

## Change

`FightPoseSolver.skip_graft_grip_loosening`: U157 blocked all outward graft IK; cage clinch retarget often sits *inside* authored joint-centres. Allow signed placement outward up to `GRAFT_LOOSEN_CAP_M` (22 mm), still refusing U157-scale spurious opens (>22 mm).

## Video (Cascadeur source via `s66_hold_video.gd`, `hold=CageClinch`)

- Before (pre-fix graft skip): `research/_captures/watch_loop/u171_cageclinch_before.mp4`
- After: `research/_captures/watch_loop/u171_cageclinch_after.mp4`

Note: `s66` plays audition GLBs only (not retargeted fighters); graft contact delta is in the probe table. Files are Godot MJPEG movie captures (`.mp4` extension, MJPEG payload).

## Gate

- `check_scripts.py FightPoseSolver.gd`: pass
- `run_tests.py --only fight_pose_solver,fight_hold,grapple,fight_room`: **20/20 fail** on pre-existing `GameState.gd` `TitleHonours` parse error in this worktree (not introduced here)

## WHAT IS STILL WRONG

- `head_to_head` ~8% drift unchanged (not a grip row; torso/head placement).
- Other `HOLD_GRIPS` pairs not re-probed this pass (mount, guard, side control, …).
- Live-room `_enter_ground_hold` / `_release_grapple` transitions not re-cut on video this pass.
- Per-frame arm IK residual tiny but non-zero; penetration while held not re-measured.
