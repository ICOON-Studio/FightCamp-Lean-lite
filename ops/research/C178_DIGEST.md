# C178 digest — U143 wrestling naming regression

## Fix

`FightRealtime._grapple_technique_for` now treats `scramble` as a valid
transitional ground phase and adds wrestling-only `control`/`takedown` aliases.
When no generic effect overlaps, freestyle and Greco use a deterministic move
from their already ruleset-, fighter-, and phase-filtered learned palette.
Successful takedown/throw naming passes the arriving ground phase into the
namer, so the fallback cannot select a standing/clinch-only move.

## Coverage

| Ruleset | Before U143 | C178 after | Clause 4 after |
|---|---:|---:|---:|
| freestyle wrestling | 1.6% (U143) / 51.7% pre-U143 | 100.0% (381/381) | 0 |
| Greco-Roman | 1.1% (U143) / 54.4% pre-U143 | 100.0% (261/261) | 0 |

Final contract clauses: clause 2 pass (0), clause 3 pass (0), clause 4 pass
(0), clause 5 pass (0). Clause 1 passes for freestyle and Greco; the blind
contract still reports its pre-existing judo and muay-thai coverage failures.

## Gates

- Parse: `CHECK total=1 fails=0`.
- Q148: `TOTAL named non-stall events: 2776`; `TOTAL violations: 0`.
- `run_tests.py --only name`: `SUITE total=1 fails=0`.
- `run_tests.py --only grapple`: `SUITE total=11 fails=1`; the sole failure is
  the unchanged blind contract's non-wrestling clause-1 failures.
- `run_tests.py --only room`: `SUITE total=3 fails=0`.
