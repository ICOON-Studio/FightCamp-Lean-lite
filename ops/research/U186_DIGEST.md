# U186 digest — feet carry the body (S90)

## Planted slide (`tools/u185_planted_slide.gd`, seed 94301, both men, footwork beats)
Classification unchanged: lock-planted (not stepping) OR toe height ≤0.03 m and speed &lt;0.60 m/s. **AFTER** adds a planner-only strict rule: lock-planted samples with toe speed &gt;0.10 m/s count as swing (a lock calling itself planted while the toe skates is reclassified).

| Mode | planted p50 (m/s) | planted p95 (m/s) | fast slide share (&gt;0.10 m/s) | max lag (m) |
|------|-------------------|-------------------|--------------------------------|-------------|
| BEFORE (planner off) | 0.0000 | **0.5731** | 0.232 | 0.000 |
| AFTER (pending + root hold + steps) | 0.0001 | **0.2609** | 0.089 | **0.137** |
| MUTANT (drag root) | 0.0043 | **0.7686** | 0.318 | 0.000 |

**Gates:** AFTER p95 ≤50% BEFORE (0.287 m/s) — **pass** (0.261). Mutant worse than BEFORE — **pass**. Lag ≤0.35 m — **pass** (0.137).

**Mechanism:** `FightStepPlanner` accumulates engine `hip_delta` into `pending_xz` while both feet planted; steps spend pending (≤0.35 m per step). `FightStagePlayer` cancels engine root translation on footwork beats while not stepping; stepping legs use planner arcs; planted legs use frozen world locks (`boxing_steps` keeps `lock_in` from state, not animated drift). Knee floor guard in `_bend_leg` now compares **world-metre** knee height to hips−0.92×`_lock_scale`.

## Kneel (`tools/u185_kneel_probe.gd`, gym technical spar)
- **Rig:** `rig_world_scale≈1.0324` (frame ~400), floor ref **hips − 0.92 m × scale** (world metres), not raw toe min (Tripo scale ≠ 1 m; toe-min ref lied on layered `loc_*` takes).
- **Result:** `violations_below_0.25m=3088` on 1544 footwork samples — **not pass**. Worst: corner b, `boxing_step_in_out`, `idle` ~2.88 s, LeftKnee **−1.34 m** vs hip floor (clip/lower-layer pose drives knee through canvas; partial IK refusal is not enough without refusing footwork binds that layer walks under idle).

## U183 gate
`boxing_footwork_clearance_test.gd`: 32 checks, 0 failures.

## Tests (individual headless)
`fight_step_planner_test` 11/0; `fight_foot_lock_test` 31/0; `fight_leg_ik_test` 222/0; `boxing_footwork_clearance_test` 32/0; `spar_watch_test` 0; `fight_stage_walk_test` green.

## Preview
`previews/u186/arena_spar_gym.png` (`tools/u186_render_gym_spar.gd`).
