# U190 DIGEST — Judo throws that are tried

**Owner:** cursor | **Branch:** `cursor/u190-judo-attempts` | **Population:** Q197 Pop A (Thrower vs GripFighter, judo 1×240s)

## Funnel (before → after)

| Stage | Before (master) | After (U190) |
|--------|-----------------|--------------|
| Throw attempts / 4-min match | 0.50 [0.43, 0.57] (200 bouts) | **9.26 [7.89, 10.63]** |
| Clinch decision ticks / bout | ~6 | 2.4 (shorter exchanges, more attempts per tick) |
| Standing `takedown_attempt` / bout | ~1.15 | 0 (judo shoot scale) |
| Scoring share of attempts | ~20% | **6.6%** (minority) |
| SCORING throws / bout | 0.10 | 0.61 |

**Cause:** MMA-authored `CLINCH_THROW_P` (0.015) and single lock-holder throw slice; judo spent ~1% of decision ticks in clinch with ~1 attempt per exchange. Fix is **ruleset-gated** levers only (`JUDO_CLINCH_THROW_ATTEMPT_P`, engage/shoot/range scales, bilateral throw slices from existing gate/act rolls).

## Gate

- **Attempts/match:** point 9.26 inside 8–14; Wilson CI [7.89, 10.63] (per-bout mean ±1.96 SE).
- **Byte-identity:** boxing + kickboxing + MMA, 10 seeds each — `tools/u190_ruleset_identity.gd` → **PASS** (all hashes match pre-U190 master table).
- **Tests:** `python Godot/tools/run_tests.py --jobs 2 --only fight_scoring,judo,grapple` → **14 fails** in this worktree (missing `.godot` audio import + pre-existing `fight_scoring_test` uchi-mata ippon 19≥22). `fight_grapple_seam_test` 1 flaky film-completion fail; MMA log hashes unchanged.

## Tools

- `Godot/tools/u190_judo_throw_census.gd` — Pop A gate + CI
- `Godot/tools/u190_ruleset_identity.gd` — non-judo hash proof
- `Godot/tools/u190_judo_funnel.gd` — scratch funnel probe

## Constants (FightRealtime.gd)

`JUDO_CLINCH_THROW_ATTEMPT_P`, `JUDO_CLINCH_ENGAGE_BASE`, `JUDO_STANDING_TAKEDOWN_SHOOT_SCALE`, `JUDO_GRAPPLE_RANGE_SCALE`, `JUDO_CLINCH_BREAK_P`, `JUDO_THROW_ATTEMPTS_PER_CLINCH_TICK` — all read only when `ruleset_id == "judo"`.
