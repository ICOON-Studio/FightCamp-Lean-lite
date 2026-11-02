# U139 digest — blind `GroundGraph` contract test

**Branch:** `cursor/u139-ground-graph-contract`  
**Deliverable:** `Godot/tests/ground_graph_contract_test.gd`  
**Gate:** parse on that file; `run_tests.py --only ground_graph` → `SUITE total=1 fails=0`

## Ambiguous readings chosen

1. **Decay step size** — Probed `control_units_decayed` with varying `gate_ticks`; asserted the first drop happens when `held_ticks` reaches `2 * gate_ticks` (integer step count `held / (2 * gate)`), without hard-coding a repo constant.
2. **Absolute control floor** — Contract says floor > 0; test only checks `> 0` at extreme hold, not a specific fraction of `flat_units` (runtime uses ~50% of flat for ints; `hold_value` plateaus earlier on a 0..1 scale).
3. **`hold_value` vs `control_units_decayed`** — Treated “same arithmetic” as monotonic decay with a positive floor on hold edges, not byte-identical numeric coupling (hold term hits a 0.5 plateau while int control units keep stepping down).
4. **Degenerate zero-score flag** — Used two synthetic zero-reward candidates so shipped edges’ reward terms do not mask degeneracy; require `degenerate == true` on the chosen breakdown.
5. **Plan bonus magnitude** — Asserted equal increments per extra matching tag (two-tag minus one-tag equals one-tag minus none), not a fixed numeric bonus.

## Mutants (injected stubs under `user://`)

| Mutant | Intent | Caught? |
|--------|--------|---------|
| `current_decay` | decay under `current` arm | yes |
| `no_floor` | decay can reach 0 | yes |
| `skill_sum` | skill term sums techniques | yes |
| `choose_argmax` | argmax selection | yes |
| `ignore_min_hold` | ignores `held_ticks` gate | yes |
| `hold_constant` | hold `hold_value` frozen at 1.0 | yes |

## Underspecified / not fully pinned

- Exact numeric **reward normalisation** (only presence + non-swamping via component keys).
- **`difficulty` / `p_mod`** linkage (breakdown includes `difficulty`; no formula in contract).
- **`choose` return shape** beyond `id`, determinism, extremes, empty input, and degenerate flag (extra keys like `edge`, `weight` observed but not mandated).
- Whether **`hold_value` floor** must match the int control floor as a ratio (behaviour diverges after the first decay step).

## Findings

None blocking: live module satisfied all asserted contract readings. The `hold_value` vs int decay numeric split is noted above for contract tightening, not treated as a silent test bend.
