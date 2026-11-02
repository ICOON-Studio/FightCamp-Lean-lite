# U150 digest — FightSeparation blind contract (Part 1)

## Part 1 — blind contract test

- **File:** `Godot/tests/fight_separation_contract_test.gd`
- **Live run:** `TOTAL=1 fails=0` (contract clauses exercised inside `_contract_errors`; violations surface as `FAIL:` lines and increment `fails`).
- **Module vs contract:** no clause failures on `res://scripts/FightSeparation.gd` (blind run; source not opened).
- **Gate:** parse gate on the test file only; no suite.

### Mutant table

| `mutant=` name | Defect simulated | Result |
|----------------|------------------|--------|
| `no_halve` | Full `push_m` applied to `b` only (`a` unchanged) | `TOTAL=8 fails=8` |
| `cap_per_tick` | Cap `min(deficit, 2.5)` without `* dt` | `TOTAL=3 fails=3` |
| `clinch_high` | Clinch floor `0.40` m instead of `0.28` | `TOTAL=1 fails=1` |
| `ignore_ground_stance` | `kind_for` never returns `ground` for stance | `TOTAL=2 fails=2` |
| `strip_both` | `strip_inward` zeros outward component too | `TOTAL=1 fails=1` |

**Mutants caught: 5/5.**

Invocation (append after `--script`; Godot user args):  
`… --script tests/fight_separation_contract_test.gd mutant=<name>`  
or `--mutant=<name>` immediately after the script argument. The form `-- mutant=` did not surface args on this Windows console build.

## Part 2 — room no-teleport (engine floor + U146 easing)

- **Cause:** frame 3263 boxing seed 94301 — `_refuse_overlap_on_placed` eased `_overlap_sep_m` in `_place_bodies`, then `_correct_refused_overlap` applied a second hip push and more `_overlap_sep_m` in the same 1/60 s frame (~0.11 m on body B). Engine track gap did not open that frame (`eng_open=0`); the double hip path was the teleport.
- **Fix (room, default ON):** `overlap_sep_credit_engine_gap` — with overlap easing on, `_correct_refused_overlap` still runs hand pushes but **returns before the hip push** so overlap separation is eased only once.
- **Test:** `fight_room_no_teleport_test.gd` — `_count_jump` prints `JUMP frame=… body=… m=… yaw_deg=…` on violation; eased run `teleports=0`, beats unchanged (55).
- **Gate:** parse gate on `FightWorldLiveScreen.gd` + test; `run_tests.py --only fight_room,fight_world` → 8/0; `fight_room_no_teleport` green. Subset `--only fight_room,fight_world,grapple` → 17/19 (`grapple_adapter_test`, `grapple_naming_contract_test` still fail on this tree without U150 touches — MT adapter pin + muay_thai naming coverage).

## Part 3 — U149 AFTER table

See `research/U149_DIGEST.md` § AFTER (U150). Headless re-run of `tools/u149_distance_by_phase.gd` on this branch (~4 min wall).
