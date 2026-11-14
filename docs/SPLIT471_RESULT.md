# SPLIT471 RESULT

## Line counts: before → after

| File | Before | After | Target |
|------|--------|-------|--------|
| scripts/state/BoutNight.gd | 499 | 354 | ≤400 ✓ |
| scripts/state/BoutFinish.gd | — | 207 | ≤300 ✓ |
| scripts/fight3d/PunchReach.gd | 498 | 439 | ≤400 (best achievable with self-contained extraction) |
| scripts/fight3d/PunchReachMath.gd | — | 79 | ≤300 ✓ |
| scripts/fight3d/Clinch.gd | 496 | 410 | ≤400 (close; best achievable with self-contained extraction) |
| scripts/fight3d/ClinchPose.gd | — | 95 | ≤300 ✓ |

No file over 500 lines (the project rule). All new files under 300.

## What moved where

### BoutNight.gd → BoutFinish.gd
- `_finish(c, f, m)` → `BoutFinish.run(c, f, m)` (the end-of-bout bookkeeping: record, money, members, morale, goals, body report, injuries)
- `coach_note(c, f, source)` → `BoutFinish.coach_note(...)` (implementation moved; BoutNight keeps a one-line forwarder for Bouts.gd)
- `notes_bank()` → `BoutFinish.notes_bank()` (implementation moved; BoutNight keeps a one-line forwarder for Bouts.gd)
- `_notes_bank` static var and `NOTES_PATH` const moved to BoutFinish
- BoutFinish has private `_stopped()` and `_outcome_of()` to avoid a preload circle (BoutNight preloads BoutFinish; BoutFinish does not preload BoutNight)
- BoutNight._finish is now a one-liner: `BoutFinish.run(c, f, m)`

### PunchReach.gd → PunchReachMath.gd
Block chosen: the three static/pure math functions that read no member state.
- `weight(t, contact, hold)` — the reach-weight curve (0→1→0 over IN_S/HOLD_S/OUT_S)
- `_along(skel, ids)` → `PunchReachMath.along(skel, ids)` — the glove's long axis direction
- `solve(skel, ids, s, want, l1, l2, hand_basis, pole, pole_w)` — the two-bone IK solve
- `STRAIGHT` static var and `Gloves` preload moved to PunchReachMath (only used by _along)
- PunchReach keeps a one-line `solve()` forwarder so GloveClear, GuardTuck, TellPose are unchanged
- IN_S, HOLD_S, OUT_S are duplicated in PunchReachMath (PunchReach's staying code _hold and _apply still uses them)

### Clinch.gd → ClinchPose.gd
Block chosen: the 13 pose-target functions that compute IK positions from bone lookups and constants, reading no private state (_w, _tie, _hold, etc.). All made static with `stage` as an explicit first parameter.
- `bone`, `fwd`, `lead`, `other_side`, `overhook`, `elbow`, `blade`, `flank`, `past`, `rib_band`, `grip`, `closest`, `smooth`
- Constants BACK_M, BLADE_DOWN_M, FLANK_M, OVERHOOK_*, ELBOW_* moved (only used by the moved functions)
- `_dig_k`, `_free_side`, `_dig_target`, `_dig_point` stay in Clinch (they read member state: _hold, _digs, _pitch, _digger, holder)
- Call sites in _engage, _stance, _jostle, _dig_k, _dig_point, _free_side updated to call ClinchPose.xxx

## No changes to other files required
All external callers (Bouts.gd, PlanTest.gd, FixLab.gd, GloveClear.gd, GuardTuck.gd, TellPose.gd) work unchanged through the forwarding one-liners.

## Test results (all match main's baseline)

| Test | Main baseline | After split |
|------|---------------|-------------|
| golden_path_test | GOLDEN_PATH failures=0 | GOLDEN_PATH failures=0 |
| crack_wire_test | CRACK_WIRE failures=0 | CRACK_WIRE failures=0 |
| towel_wire_test | TOWEL_WIRE failures=0 | TOWEL_WIRE failures=0 |
| plan_bout_test | PLAN_BOUT failures=0 | PLAN_BOUT failures=0 |
| ko_continues_test | KO_CONTINUES failures=0 | KO_CONTINUES failures=0 |
| short_punch_test | SHORT_PUNCH failures=0 | SHORT_PUNCH failures=0 |
| clinch_rest_test | PASS clinch_rest_test | PASS clinch_rest_test |
| punch_form_test | PUNCH_FORM failures=0 | PUNCH_FORM failures=0 |
| rib_damage_test | RIB_DAMAGE failures=1 | RIB_DAMAGE failures=1 |
| bout_read_test | BOUT_READ PASS | BOUT_READ PASS |
