# Q233 DIGEST — Boxing Clinch Engine (S139 s1-s5)

**Qwen, 2026-10-02. Engine seat.**

---

## What was built

The boxing clinch in the engine, per S139_CLINCH_DESIGN.md s1-s5:

1. **Initiation = need + distance.** Holds are CAUSED by fatigue (CLINCH_HOLD_FATIGUE_FACTOR 0.015), damage (CLINCH_HOLD_DAMAGE_FACTOR 0.020), and being out-worked (CLINCH_HOLD_OUTWORKED_FACTOR 0.003) on a base engage rate of 0.0005. The operator's distance threshold (CLINCH_GAP_M 0.45 m for CLINCH_DWELL_TICKS 15) adds a proximity bonus. Tactics: personality (Dirty/Veteran 1.5x, Disciplined 0.7x), fight plan (Out-Boxer doubles out-worked weight, Pressure Fighter holds 0.3x), and protecting a lead late (1.3x in last 3 rounds). Corner orders documented but not wired (CornerAdvice.gd follow-up).

2. **Inside work.** Holder recovers CLINCH_HOLDER_RECOVERY × Stamina.rest_recovery per tick; leaned-on man pays CLINCH_LEAN_COST (0.08) stamina. Free man throws short body shots at CLINCH_INSIDE_WORK_P (0.05) per decision tick.

3. **The break.** Referee breaks after a drawn uniform [2 s, 8 s] duration (mean ~5 s). Either man may break free at CLINCH_FREE_BREAK_P (0.025). Bell break resets all clinch state.

4. **Penalties (ABC via J14).** Per-round hold counters. Soft warning at 4 holds / 15 s held; hard warning at 6 holds / 25 s held; deduction after hard warning repeated. Hit on break (CLINCH_FOUL_ON_BREAK_BASE 0.03, Dirty ×4) skips to hard warning. Deductions applied to the round's three scorecards.

5. **Log events** (exact names): `hold_engage` {holder, cause, break_s}, `hold_break` {by: referee|free|bell, duration_s}, `inside_work` {actor, holder}, `foul_on_break` {side}, `hold_warning` {side, level, reason}, `point_deduction` {side, points, reason}.

6. **Switch.** `boxing_clinch` in DEMO_SWITCHES (game ON, tests OFF). OFF writes no key → byte-identical to master (C230/Q226 pattern). `_rng_clinch` is its own stream (SEED_CLINCH 217000007).

## Architecture

Applied as the Q174/Q175 hold model `fb58fb93` + `ca6aaf3a` + `69fb0764` rebased onto today's FightRealtime.gd (7618→8157 lines, +539). The old `_run_hold` became `_run_clinch` with full S139 logic: `_clinch_tick` (stamina + inside work + break checks), `_clinch_break` (log + foul check + reset), `_clinch_try_engage` (compare needs, proximity bonus), `_clinch_engage` (start hold, draw break timer, penalty check), `_clinch_need` (fatigue + damage + out-worked × personality × plan × lead), `_clinch_cause` (hurt/tired/smothered/too_close/tactical), `_clinch_penalty` (escalation ladder), `_clinch_apply_deduction` (cards).

Gate: only boxing/kickboxing (rulesets that do not grapple). Engage requires gap ≤ GRAPPLE_RANGE (STRIKE_RANGE 1.1 m). Proximity threshold for "too close" cause: gap ≤ CLINCH_GAP_M (0.45 m) sustained ≥ CLINCH_DWELL_TICKS decisions.

## Test results (q233_boxing_clinch_test.gd, 9 checks, 0 failures)

- **(a) Need-based rates:** fresh even men 2-3 holds; hurt man (50%) 6 holds. Fresh < hurt ✓
- **(b) Distance threshold:** close range produces 6 holds ✓
- **(c) Break bounds:** 25 durations, mean 4.66 s (band 4-6 s), all inside [2, 8] s ✓
- **(d) Penalty ladder:** 7 holds → 4 warnings (soft+hard). Heavy holder gets warnings ✓
- **(e) Control arms:** MMA ON/OFF byte-identical (492 events) ✓; KB ON (172 events) ≠ KB OFF (178 events) ✓

## Census arm

`q212_booked_census.gd -- weeks=40 as_game no_q233` runs the control arm (boxing_clinch stripped). Separate save folder `_no_q233`.

## Files

- `Godot/scripts/FightRealtime.gd` — +539 lines: constants (CLINCH_* × 20), state keys (×12), `_run_clinch` + 9 helpers, bell-break fix, strike tracking, `boxing_clinch` switch + DEMO_SWITCHES entry
- `Godot/tests/q233_boxing_clinch_test.gd` — 251 lines, 5 test groups, 9 checks
- `Godot/tools/q212_booked_census.gd` — +8 lines, `no_q233` flag for control arm

## Not done (follow-up)

- Corner orders (`tie_up_when_hurt`, `work_inside`) not wired into CornerAdvice.gd
- DQ (excessive fouling → disqualification) not implemented
- Census bands (120 bouts, KO+TKO 40-55%, throws unchanged) not measured
- Room/animation (C240, Codex) and HUD (Claude) read Q233's events