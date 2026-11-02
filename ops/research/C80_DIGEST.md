# C80 — FightStageDirector blind contract test

## Result

- Added `tests/fight_stage_director_test.gd` from `TASK_C80.md` without opening `FightStageDirector.gd`.
- Parse gate: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Direct test: `TOTAL=357 fails=0`.
- The fixed-seed boxing bout produced 73 frames and 146 counted side roles, exactly two per frame.
- A synthetic action beat used Dictionary-shaped `wear` and was cross-checked against the first real action beat from that run.
- Contract/implementation disagreements: none.
- Full suite not run, per the C80 new-test-only tier.

## Seeded boxing tally

| Role | Count |
|---|---:|
| `idle` | 16 |
| `strike_head` | 44 |
| `strike_body` | 18 |
| `strike_leg` | 3 |
| `react_head` | 44 |
| `react_body` | 18 |
| `react_leg` | 3 |
| `block` | 0 |
| `slip` | 0 |
| `knockdown` | 0 |

Zero roles in this boxing run: `block`, `slip`, `knockdown`.
