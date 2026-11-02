# U184 digest — boxing footwork step-drag (idle-bound travel)

## Skate (seed 94301, boxing demo, both men, `tools/u184_boxing_skate.gd`)
| Mode | footwork frames | toe skate mean (R3-style) | lock err / plant | steps | travel m | steps/m |
|------|-----------------|---------------------------|------------------|-------|----------|---------|
| BEFORE (planner off) | 427 | **2.0387** m/s | 0.1979 m | 0 | 0.00 | — |
| AFTER | 427 | **2.0152** m/s | 0.2006 m | 252 | 10.67 | 23.6 |

Population: `FightWorldLive` configure seed 94301, `engine_positions` on, foot lock on; frames where `boxing_footwork_beat()` (busy `technique` id from U183 idle binds).

## Module + hook
- `FightStepPlanner.gd` — pure step-drag rules (threshold, lift cap, lead-first, never both airborne); constants documented in-file.
- `FightStagePlayer` — records `busy_technique` on footwork beats; on boxing footwork applies root `hip_delta` to the travel-direction lead leg’s plant (same path as strike `step_front_foot`, no spring glide); `set_boxing_step_planner(false)` for baseline.

## U183 gates (unchanged)
- `u183_foot_clearance.gd`: all nine `boxing_*` footwork rows still pass foot ≤0.10 m, knee ≤0.12 m on f01.
- Micro lift on integration held at 0 for skate gate; planner unit tests still assert arc ≤0.06 m.

## Tests (individual Godot runs, this worktree)
- `fight_step_planner_test.gd`: 10 checks, 0 failures (+ 2 mutants red)
- `fight_foot_lock_test.gd`: 31 checks, 0 failures
- `fight_leg_ik_test.gd`: 222 checks, 0 failures
- `boxing_footwork_clearance_test.gd`: 32 checks, 0 failures
- `spar_watch_test.gd`: 0 failures
- `fight_stage_walk_test.gd`: fails=0
- `run_tests.py --only …` flakes on missing `unbreakable_noise_menu.mp3` import (pre-existing env); logic tests green when run alone.

## Preview
- `previews/u184/arena_spar_gym.png` (`tools/u184_render_gym_spar.gd`) — feet travel with root in short step-drags instead of a continuous guard slide on footwork beats.
