# Q185 Digest — Training Preview Contract Test

## What
Blind contract test for `TrainingPreview.gd` (not yet written by Claude).
Test SKIPs cleanly until the module lands.

## Rows (12 preview_gain + 4 progress_to_next)
| Row | Scenario | Expected |
|-----|----------|----------|
| R01 | headroom floor (raw 3.5 → clamped 1.0) | power: 0.816 |
| R02 | headroom ceiling (raw 0.15 → stays 0.15) | power: 0.1224 |
| R03 | quality_tier 1 (not 3) | power: 0.51 |
| R04 | condition 50 (not 100) | power: 0.408 |
| R05 | coach 0 (not 50) | power: 0.48 |
| R06 | crowd 0.7 (not 1.0) | power: 0.5712 |
| R07 | fraction 0.5 | power: 0.408 |
| R08 | duplicate tags [power,strength] → power once | power: 0.816 |
| R09 | fraction 0 → {} | {} |
| R10 | empty station → {} | {} |
| R11 | missing stat → skipped → {} | {} |
| R12 | high headroom (raw 5.0 → clamped 1.0) | power: 0.816 |
| P1–P4 | progress_to_next at 0.0, 0.25, 41.999, 42.0 | 0.0, 0.25, 0.999, 0.0 |

## Mutants proved (scratch/q185_reference.py)
- **M1 drop headroom clamp**: caught by 7 rows; R12 worst — mutant gives 4.08 vs correct 0.816
- **M2 duplicate tags applied twice**: caught by R08 — mutant gives 1.632 vs correct 0.816

## Gates
- Parse: 1/1 pass
- Run: SKIP (module absent), exit 0

## Owned files committed
- `Godot/tests/training_preview_contract_test.gd`
- `research/Q185_DIGEST.md`
- `scratch/q185_reference.py`
