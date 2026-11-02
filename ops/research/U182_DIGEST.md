# U182 digest — spar in the gym ring

## Shipped
- `FightWorldLiveScreen`: `arena_spec_id` + `gym: true` on configure; gym shell (bright lights, walls, bags, three rope-side mates), no `VenueRig` crowd; `engine_half_width_for(discipline, spec_id)` and `_load_spec_by_id` keep settle and watch on one canvas.
- `GameState.SPAR_ARENA_SPEC` + `spar_arena_spec_id()`; `spar_fight_setup` passes the gym spec into `engine_half_width_for`.
- `FightNightScreen._start_arena`: spar passes gym spec, `gym: true`, `standing` camera (no walkout plate path unchanged).
- Render: `Godot/tools/u182_render_gym_spar.gd` → `previews/u182/arena_spar_gym.png` (+ optional `--write-movie=…/arena_spar_gym.avi`).

## Spec per ruleset (club / gym surface)
| ruleset | arena_spec_id |
| --- | --- |
| boxing, kickboxing | `boxing_ring_fl_min` |
| muay_thai | `muaythai_ring_ifma` |
| mma | `mma_cage_gym_6m` |
| judo | `judo_ijf` |
| karate | `karate_wkf` |
| bjj | `bjj_ibjjf` |
| sambo, freestyle_wrestling, greco_roman | `wrestling_uww` |
| taekwondo | `taekwondo_wt` |

No separate gym preset in data for rulesets outside this table; they are not spar-bookable today.

## Engine half-width (contest/2 − 0.30 m body margin)
| surface | before (broadcast live room) | after (gym spar) |
| --- | --- | --- |
| boxing ring FL min | **2.44 m** (unchanged — discipline already used FL min) | **2.44 m** |
| MMA | **4.27 m** (`mma_cage_ufc_30ft`, 9.14 m canvas) | **2.70 m** (`mma_cage_gym_6m`, 6 m canvas) |

## Tests
- Parse gate: clean on touched `.gd`.
- `spar_watch_test.gd`: **0 failures** (arena row uses `arena_spec_id` + `gym: true`).
- Subset (individual Godot runs): `spar_watch`, `fight_night_realtime`, `fight_world_live`, `gym_sparring`, `fight_spar_intensity`, `training_floor_3d`, `banned_2d_fight_picture` — all green. `run_tests.py --only …` hit a missing `.godot/imported` mp3 flake on this worktree; not caused by U182.

## S87 knee-in-boxing-spar (also check)
Not fixed in U182 (presentation catalogue, not arena routing). At ~8 s in `docs/previews/s87/arena_spar.png`, the raised leg matches **boxing footwork** binding to RamsterZ dodge clips (`FightClipBinding.gd`: `boxing_angle_step` → `H2H_Dodge_Left`, same family for pivot/circle/feint), not a kickboxing knee from the strike palette. Idle is `H2H_Idle.FBX`; footwork beats below the walk floor play those dodges. A proper fix is a boxing-only in-place step clip set, not U182’s gym ring slice.

## Render
Operator path: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/u182_render_gym_spar.gd`  
PNG written: `previews/u182/arena_spar_gym.png` (club ring, gym walls/bags, SPAR plate, no venue crowd).
