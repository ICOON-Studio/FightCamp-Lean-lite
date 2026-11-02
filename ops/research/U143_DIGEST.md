# U143 DIGEST — Name the control family (grapple namer)

**Branch:** `cursor/u143-name-the-control`  
**Owner:** cursor  
**Date:** 2026-09-23

## Change

`FightRealtime._grapple_technique_for`: optional `phase_grapple` for S49 phase
filtering; default (`control` ticks) `wanted` lists are **phase- and seat-aware**
(clinch vs ground seat, not one flat list). `_move_seat` names seat transitions
with `moved` as `phase_grapple`; hold names use `moved` when stance or seat
changes so ground seats pick `side_control` / `pin_control` etc. in the right
order.

## Q146 control unnamed (named/unnamed control column, before → after)

| ruleset | before | after | Δ unnamed |
|---|---|---|---|
| mma | 0/926 | 0/926 | — |
| muay_thai | 0/283 | 106/177 | −37% (target 80% not met) |
| judo | 26/269 | 295/0 | −100% |
| freestyle_wrestling | 208/190 | 0/398 | worse (see note) |
| greco_roman | 200/259 | 0/459 | worse (see note) |
| bjj | 651/366 | 1017/0 | −100% |
| sambo | 366/394 | 760/0 | −100% |

**Note:** Freestyle/greco previously “named” clinch control from **standing-phase**
techniques (e.g. `wrestling_snapdown`) because hold naming used the old stance.
Hold naming now uses the entered stance/seat; those palettes have almost no
legal clinch control nodes, so control events go honestly unnamed rather than
mislabelled. Stalls unchanged by design.

**Muay thai:** `seat/clinch_engage` 26/0 named (cause 2). Remaining control
blanks are holds with no clinch-legal match in the 10-move palette on some
entries.

## S58 ground arms (`current` arm vs pre-change stash)

`SUBMISSION` 42, `DECISION` 45, `KO` 22, `TKO` 11; ground spell ends
`round_or_bout_end` 67, `stand_up` 71, `stall` 6 — **unchanged** integer-for-integer.

## Tests

- Parse gate: `FightRealtime.gd` 0 fails
- `--only grapple`: 10/0
- `--only technique_id`: 1/0
- `--only carry_progress`: 1/0
