# Q14 digest

- **Deliverable:** `Quantise.gd` — pure static scaled-integer arithmetic for
  deterministic replay. `class_name Quantise`, zero preloads, no state.
- **Representation:** `SCALE = 1000` (three decimal places). A value is stored
  as `int(round(value * SCALE))` and read back as `stored / float(SCALE)`.
- **Rounding:** half away from zero, symmetric for both signs. `to_fixed(0.0005)
  = 1`, `to_fixed(-0.0005) = -1`. Uses `HALF_UP_EPSILON = 1e-9` to make the
  tie test stable against IEEE 754 representation of `0.0005`.
- **API:** `to_fixed`, `to_float`, `quantise` (idempotent, not round-trip
  identity), `add`, `sub`, `mul` (same half-away-from-zero rounding on integer
  division), `clamp_fixed` (contradictory range returns input unchanged).
- **Non-finite guard:** `to_fixed(NAN)`, `to_fixed(INF)`, `to_fixed(-INF)` all
  return `0`.
- **Trap cleared:** ties are symmetric — the whole point of the module. `mul`
  uses integer `(abs + SCALE/2) / SCALE` so no float path can drift.
- **Test:** `quantise_test.gd` — 50+ assertions covering ties both signs,
  non-finite, idempotence, mul precision (`0.1 * 0.2 = 0.02`), mul ties,
  clamp contradictory range.
- **Gate:** parse clean, own test PASS, full suite `fails=0`.
- **Files:** `scripts/Quantise.gd` (new), `tests/quantise_test.gd` (new).
