## DECISIONS

Carry when `role in SWAY_CARRY_ROLES` and `sway_of.returns` (ratio 0.25): react_head HitReaction01-04 (net 0.000-0.006, max 0.09-0.18, returns); slip SlipLeft/Right/FadeBack (returns); react_body StaggerSmall/Medium (net 0.35-1.38, returns false); react_leg StaggerLarge04 (travels); block BlockStart (net 0.173, returns false); strikes not carried in production.

| mode | R1 | R3 mean/p95/frames | R3b | R4 | R5 worst | R5b worst |
|---|---|---|---|---|---|---|
| BASELINE | FAIL | 0.186 / 1.137 / 115501 | PASS | PASS | Chest 2.09x | Chest 1.38x |
| PRODUCTION (delivered: z sign wrong) | FAIL | 0.228 / 1.464 / 115501 | PASS | PASS | Chest 2.09x | Chest 1.38x |
| PRODUCTION | FAIL | 0.130 / 0.807 / 115501 | PASS | PASS | Chest 2.09x | Chest 1.38x |
| sway=off | FAIL | 0.186 / 1.137 / 115501 | PASS | PASS | Chest 2.09x | Chest 1.38x |
| sway=strikes | FAIL | 0.109 / 0.538 / 115501 | PASS | PASS | Chest 2.09x | Chest 1.38x |

sway=off R1-R5b byte-identical to BASELINE (POPULATION line only differs). PRODUCTION R3 fell below baseline (react_head 1.35→0.19 m/s); gate met. Toe-skate unit checks fail 11/11 with `Vector3.FORWARD` restored, pass with `Vector3(0,0,1)`. sway=strikes R3 0.109 (hook_lead 0.37, cross 0.32); R4 still PASS.

Subset: `SUITE total=27 fails=1` (realism only).
