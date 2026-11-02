# C228 digest - angles of attack + guard coverage (Claude, S134b; the task Codex held)

Operator 2026-09-30 brief, point 4: step outside the lead foot and his defence drops; the guard as hit-boxes (a high
guard shuts the head and opens the ribs). Switch `angle_guard` - now in DEMO_SWITCHES; OFF is byte-identical (no
state key, legacy call path).

## What was built
- `scripts/FightAngles.gd` (pure): attack angle off the defender's line, lead-foot side by stance, defence multiplier
  1.0 inside 10 deg -> 0.70 at 45 deg, x0.90 outside the lead foot. `tests/fight_angles_test.gd` (stance-swap mutant
  fails 4 checks).
- `scripts/FightGuardCoverage.gd` (pure): guard kinds high / long / low, coverage per zone, low hands under 35 stamina.
- `FightDefenceModel.resolve_at_contact(..., angle_mult, coverage, cover_roll)`: the angle scales read and evade; a
  right-height block still has to find the gap (`guard_gap` tally).
- Phase 5 (what makes angles exist): a defender squares up to where he SAW the attacker one reaction time ago
  (the model's own `defender_latency_ms`); a man with fight_iq >= 60 circles to the outside of the other's lead foot
  unless the ropes are there. The room's facing (OR1) is untouched - this is the defence roll's input only.

## Sources / labels
No study measures defence vs attack angle or guard coverage per zone: every constant is AUTHORED and named in the
files. The census holds them to G99 (connect 30-35%). Body share of landed is NOT tuned: G99 has no sourced split.

## Census (tools/c228_angle_census.gd, 24 bouts x 3 rounds, 3 legal boxing matchups, DEMO_SWITCHES)
| | OFF | ON |
|---|---|---|
| thrown/man/rd | 45.0 | 46.2 |
| connect % (G99 30-35) | 30.6 | 30.9 |
| exchanges >= 20 deg off his line | - | 10.0% (0.0% before phase 5) |
| from outside the lead foot | - | 5.2% |
| landed % inside / outside the lead foot | - | 28.5 / 32.2 |
| finishes | 6/24 | 8/24 |

## Found on the way (fixed, same stage)
The shipped boxer barely jabbed: jab share 12% (G99 40-44) - a feint's banked throw re-rolled feints at x8. Now the
banked throw is the owed punch (no feints, the feint's own role); jab share 12.0 -> 26.3%. The rest of the gap is the
plans' role balance (counter plan counter x3) - open.

## Tests
fight_realtime_test PASS 378 (alone); boxing_output 19/0; fight_reach_edge now 12 seeds (4 read +1.9 by sampling:
40 seeds read +4.6 ON / +3.8 OFF; floor unchanged, lift +4.3, mutant 0); demo-switch tests 11/12, the red
(fight_ring_position R16) is the 04:49 nightly's own and does not run the switch.

## Open
Jab share 26% vs 40-44 (plan role balance); body share of landed 52% (no source to tune to); guard coverage values
unsourced (AUTHORED) - a video study of guard vs body-shot share would ground them.
