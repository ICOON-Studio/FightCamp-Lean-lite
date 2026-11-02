# C196 — FEINTS slice two: rate

## Delivered

Feint selection is reweighted only when the existing realtime `feint` switch is
ON. `FightFeint.gd` owns the labelled, authored table fitted to G86's gate
bands; G86 explicitly says those in-fight rate/reaction/lift measurements are
NOT FOUND, so these are fit constants, not sourced observed rates.

| ruleset | base | counter | pressure | MMA clinch |
|---|---:|---:|---:|---:|
| boxing | 50.0 | x1.25 | x0.85 | n/a |
| kickboxing | 15.0 | x1.25 | x0.85 | n/a |
| muay_thai | 15.0 | x1.25 | x0.85 | n/a |
| mma | 12.0 | x1.25 | x0.85 | x1.0 existing rate |

The factor multiplies only arsenal entries carrying `feint: true` inside the
existing `Moves.select` walk. MMA receives it only at `standing`; clinch is
left at the existing rate. No reaction chance, follow-up lift/window, decay,
or feint RNG stream was changed. OFF omits the new weight key entirely.

## 20-bout probe (`--bouts 20`)

| discipline | feints/min per man | G86 gate | reaction share | follow-up lift |
|---|---:|---:|---:|---:|
| boxing | 6.05 | 6–14 | 0.106 | +26.8% |
| kickboxing | 4.02 | 4–10 | 0.208 | +30.4% |
| MMA | 3.22 | 3–8 | 0.233 | +7.1% |

Decay remained visible in all rows: boxing reaction share fell from 0.353 at
k=1 to 0.007 at k=4+, while MMA fell from 0.440 to 0.012. The MMA lift sample
is noisy at 7.1%; it was not tuned because C196 forbids changing lift or
reaction mechanics.

## Gates

- Parse: `CHECK total=6 fails=0`.
- OFF hash: all nine post-change HASH lines match the pre-change lines exactly.
- `fight_feint_test.gd`: `42 failures=0`.
- `fight_feint_blind_test.gd`: `60 failures=0`.
- `run_tests.py --only fight_commit`: `SUITE total=1 fails=0`.
- `run_tests.py --only fight_realtime`: `SUITE total=1 fails=0`.
- `run_tests.py --only fight_moves`: no tests matched `fight_moves`.
