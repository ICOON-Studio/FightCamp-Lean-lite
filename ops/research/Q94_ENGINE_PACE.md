## DECISIONS

**Population:** out-boxer (A) (boxing_out_boxer) vs pressure puncher (B) (boxing_pressure), boxing, 30 seeds from 900, 8 x 180 s rounds.

Q94 counted every action as a strike thrown (6,619 for a, 8,705 for b); only blows count now.

| fighter | actions | strikes | thrown/min | landed/min | punches_lb/min | J20 |
|---------|---------|---------|------------|------------|----------------|-----|
| out-boxer (A) | 6619 | 3964 | 6.1 | 3.4 | 6.7 | 12.5 |
| pressure puncher (B) | 8705 | 8191 | 12.6 | 6.2 | 15.9 | 12.5 |

**Setups/min:** a 4.1 (1480 landed), b 0.8 (261 landed).

**Strike intervals:** a p50=2.00s <0.35s=31% <0.45s=34%; b p50=0.50s <0.35s=45% <0.45s=49%.

**Cadence drivers:**

- Godot/scripts/FightRealtime.gd:1612 — The 0.35 output gate is the largest throttle: at most 35% of in-range impact checks become a throw, further cut by fatigue.
- Godot/scripts/TickBudget.gd:12 — Impact every 2 ticks at 20 Hz is 600 checks a minute; only a fraction pass the gate and range.
- Godot/scripts/FightRealtime.gd:213 — Strike range of 1.1 m decides whether the impact check fires at all; men outside it produce no actions.

CORRECTED AT MERGE (Claude, 2026-09-14): the tick driver said "100 checks a minute" - 2 ticks at 20 Hz is 600 (the model says so); and "35%" was a format escape. Only 1.0% (A) and 2.1% (B) of impact checks become a throw, so the 0.35 gate is not the whole throttle: most checks fail STRIKE_RANGE first.
