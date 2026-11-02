# U185 digest — planted-foot slide instrument + kneel (S90)

## Planted slide (`tools/u185_planted_slide.gd`, seed 94301, both men, footwork beats)
Classification: **foot-lock `planted` and not planner-stepping**, or fallback toe height ≤0.03 m and speed &lt;0.60 m/s (FightFootLock plant speed).

| Mode | planted p50 (m/s) | planted p95 (m/s) | fast slide share (&gt;0.10 m/s) | swing frames/m |
|------|-------------------|-------------------|--------------------------------|----------------|
| BEFORE (planner off) | 0.0000 | **0.5731** | 0.232 | 20.13 |
| AFTER (planner on) | 0.0002 | **0.6448** | 0.200 | 21.42 |
| MUTANT (drag root) | 0.0043 | **0.7686** | 0.318 | 20.29 |

**Wanted:** AFTER p95 ≤ 50% of BEFORE p95 (≤0.2866 m/s). **Not met** — AFTER is ~13% worse than BEFORE on the correct instrument; mutant is clearly worse than BEFORE (instrument moves).

**Why not:** U184 never called `FightStepPlanner.advance`; this stage wires it with boxing-specific unplant bypass and direct lock posing on step arcs. Idle-bound footwork still drives root travel while clip toes are static — planted locks fight animated drift until steps fire; step arcs and IK residual toe motion keep p95 high. Next lever: lower travel on footwork beats or a clip with in-mat travel that passes U183 clearance.

## Hook changes
- `FightStagePlayer` — full `FightStepPlanner.advance` on boxing footwork beats; planner rows bypass `FightFootLock` spring; large unplant radius while stepping; `set_boxing_step_drag_mutant`; `foot_lock_leg_snapshot`; knee floor guard in `_bend_leg` on footwork beats (refuse IK that would put knee &lt;0.25 m above toe floor).
- `FightStepPlanner.any_stepping()` helper.

## Kneel (gym technical spar harness, `tools/u185_kneel_probe.gd`)
Worst sample on footwork: **corner b**, `technique=boxing_step_in_out`, `take=idle`, `anim_t≈2.35–2.43 s`, **LeftKnee** driven to canvas by foot-lock IK (not a bad clip bind). Knee floor guard added; gym probe still reports many violations — needs follow-up on spar-scale IK / measurement floor reference.

## U183 gate
- `boxing_footwork_clearance_test.gd`: 32 checks, 0 failures (unchanged).

## Tests (individual Godot runs — `run_tests.py` flakes on missing `unbreakable_noise_menu.mp3` import in this worktree)
- `fight_step_planner_test.gd`: 11 checks, 0 failures (+ 3 mutants red incl. drag-root)
- `fight_foot_lock_test.gd`: 31/0
- `fight_leg_ik_test.gd`: 222/0
- `boxing_footwork_clearance_test.gd`: 32/0
- `spar_watch_test.gd`: 0 failures
- `fight_stage_walk_test.gd`: green when run alone

## Preview
- `previews/u185/arena_spar_gym.png` (`tools/u185_render_gym_spar.gd`)
