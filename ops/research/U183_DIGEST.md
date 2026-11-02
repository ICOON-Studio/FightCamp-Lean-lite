# U183 digest — boxing footwork without lifted knees

## Gate (f01 game skeleton, retargeted)
- Foot clearance: max per-foot rise ≤ **0.10 m**
- Knee rise: max per-knee swing ≤ **0.12 m**
- Instrument: `Godot/tools/u183_foot_clearance.gd` (hip carry on, 30 Hz sample)

## Census highlights (owned RamsterZ in-place locomotion)
| Clip | foot_clear_m | knee_rise_m | source_root_max_m | passes |
|------|-------------|-------------|-------------------|--------|
| H2H_Dodge_Left.FBX | 0.267 | 0.180 | — | no |
| H2H_RunForward.FBX | 0.158 | 0.178 | ~0.17 | no |
| H2H_WalkForward.FBX | 0.158 | 0.178 | ~0.17 | no |
| H2H_WalkLeft.FBX | 0.154 | 0.255 | ~0.17 | no |
| H2H_Idle.FBX | 0.001 | 0.022 | 0.013 | **yes** |
| assets/anim/c207/walk.glb | 0.000 | 0.000 | 0.0 | yes (no guard, not bound) |

No H2H Walk/Run/Dodge/Slip candidate on disk passed both gates on f01 after retarget.

## Rebind (all `boxing_*` footwork rows → `idle` / `H2H_Idle.FBX`)
| Technique | Was (U182) | Now |
|-----------|------------|-----|
| boxing_pivot_footwork | H2H_Dodge_Left | idle |
| boxing_step_in_out | H2H_RunForward | idle |
| boxing_circle_lead | H2H_Dodge_Left | idle |
| boxing_circle_rear | H2H_Dodge_Right | idle |
| boxing_feint | H2H_Dodge_Forward | idle |
| boxing_angle_step | H2H_Dodge_Left | idle |
| boxing_rhythm_change | H2H_RunForward | idle |
| boxing_switch_stance | H2H_Dodge_Back | idle |
| boxing_drawing | H2H_RunBack | idle |

**Trap (accepted):** every footwork beat shows the sliding guard loop while `FightRealtime` still owns translation — no owned low-clearance clip with meaningful in-clip travel on f01. Walk binds failed on knee rise (~0.17–0.26 m), not on foul-level knee strikes.

## Tests
- Parse: `check_scripts.py` on touched `.gd` — pass
- `boxing_footwork_clearance_test.gd`: **32 checks, 0 failures** (mutant `H2H_Dodge_Left` fails gate)
- Tier `run_tests.py --only clip_binding,spar_watch,fight_world_live,footwork`: **7/7 fail in this worktree** — missing `unbreakable_noise_menu.mp3` import + `fight_world_live_test` rc=1 (pre-existing env); clearance test logic passes when run alone

## Preview
- `previews/u183/arena_spar_gym.png` (U182 gym spar harness, post-rebind)
