# U154 digest — overlap regression bisect + single-frame hip budget

Population: seed **94301**, arm **A**, `u145_transition_probe.gd` (`stills=off`), boxing f01 vs f09 / MMA f05 vs f06.

## Part 1 — bisect

| `overlap_sep_credit_engine_gap` | Room options printed | Boxing longest >3 cm | MMA longest | Body jumps (box / mma) |
|---|---|---:|---:|---|
| **false** (U150 hip push restored) | `overlap_sep_ease=true`, `overlap_sep_credit_engine_gap=false` | **0.100 s** (282 frames) | **0.083 s** (170) | 1 / 4 |
| **true** before fix (master) | defaults | 0.200 s | 0.150 s | (S63 control) |
| **true** after U154 fix | `overlap_sep_ease=true`, `overlap_sep_credit_engine_gap=true` | **0.100 s** (284) | **0.083 s** (169) | 1 / 4 |

**Cause:** U150 `overlap_sep_credit_engine_gap` skipped the correction-path hip gap entirely, halving per-frame overlap closure vs S62.

## Part 2 — mechanism

- **`OVERLAP_SEP_FRAME_MAX_M`** (= 2× `OVERLAP_SEP_MAX_STEP_M`, 0.10 m): placement + correction share one hip-gap budget per frame.
- With credit ON, `_correct_refused_overlap` adds only to `_overlap_sep_m` (no duplicate root `half_push`), then `_sync_gap_positions_from_placed()` once.
- Credit OFF path unchanged (direct hip push).

## Gates

- Parse gate: `FightWorldLiveScreen.gd`, `u145_transition_probe.gd` — 2/0
- `fight_room_no_teleport_test.gd` — teleports=0 (eased on)
- `run_tests.py --only fight_room_no_teleport,fight_world,fight_separation,grapple` — **18/0**
