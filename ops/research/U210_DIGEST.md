# U210 digest — planner-only foot lock (S141)

Instrument: `tools/s139_slide_probe.gd` (3 seeds × 30 s, `as_game`, height-band planted feet on posed bones — same gate as S139/U185–U188 acceptance).

## Slide

| Mode | pooled cm/fighter-min | **p95 m/s** | samples |
|------|----------------------|-------------|---------|
| BEFORE (master, no planner) | 5598.9 | **2.649** | 8117 |
| AFTER (U210 planner path) | 4342.6 | **2.586** | 6590 |

Gate: AFTER p95 ≤ 50% of BEFORE (≤ **1.32** m/s). **Miss** — p95 down ~2.4%; pooled slide down ~22%. Per-seed AFTER: 92012 a/b 6626/6221; 94301 a/b 0.9/424; 17701 a/b 6248/6535 cm/min.

## Why not (planner-only, no new IK lock)

Four prior attempts froze world locks and tuned IK; all measured worse on footwork-class instruments. U210 ported **U186/U187 `FightStepPlanner` decision logic only** (pending travel, hold root before IK, `lock_wants` on planted boxing feet) — no U188 post-room toe repin or extra IK passes.

On **current master**, three integration gaps blocked the planner until fixed in this branch:

1. **`busy_technique` never set** for U183 idle-bound boxing footwork (`_footwork_clip` returns `""`) — fixed in `present` (~2312–2320 `FightStagePlayer.gd`).
2. **`_lock_feet` skipped while `_shuffle_active`** (C215 shuffle) — footwork never entered `_lock_feet_boxing`; fixed in `advance` (~3289–3305).
3. **Activation scope**: `_boxing_footwork_active()` uses `_shuffle_enabled` (latched on first boxing footwork beat) so the planner runs during engine-driven footwork, not only on the single present frame that sets `busy_technique`.

Even with that, **s139 counts every low-foot frame in the bout** (strikes, joins, guard), not footwork beats only. The planner only re-routes root travel on boxing footwork; it cannot halve bout-wide p95 without touching non-footwork slide (the IK path U185–U188 already showed regresses).

## Owned hooks (line numbers on this branch)

- `Godot/scripts/FightStepPlanner.gd` — `advance()` plant/step/hold_root (~41–145); constants ~7–18.
- `Godot/scripts/FightStagePlayer.gd` — preload/vars ~27, ~3985–3995; `set_boxing_step_planner` / `_boxing_footwork_active` ~4147–4174; `busy_technique` on present ~2312–2320; `advance` lock vs shuffle ~3289–3305; `_lock_feet_boxing()` ~5205–5395; `_bend_leg` knee attenuation on footwork ~5488–5498.

## Kneel

`tools/u188_kneel_probe.gd` copied from U188 branch; headless run in this worktree did not complete (GameState load / career harness). **Not re-benchmarked** vs master on this session — treat kneel gate as open pending a green harness run.

## Tests

- Parse gate: clean on `FightStepPlanner.gd`, `FightStagePlayer.gd`.
- `fight_step_planner_test.gd`: 11 checks, 0 failures (mp3 import warnings only).
- `run_tests.py --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage --jobs 2`: not collected (runner still in flight / import noise as U187–U188).

## Stop line

Same as U188: slide gate open on **s139**. Planner-only integration on master is **not** a fifth IK tuning pass, but it **does not** reach the 50% p95 bar. Next honest slice: reduce non-footwork planted slide (joins / whole strikes / room root finish order) or accept footwork-only instrumentation for planner proof (U186 passed there) while s139 stays the ship gate.
