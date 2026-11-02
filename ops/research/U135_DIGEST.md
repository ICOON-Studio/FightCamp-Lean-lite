# U135 digest — fight causation bullets

**Branch:** `cursor/u135-fight-causation`

## Shipped

- `FightCausation.gd`: ranks up to five bullets from `PostFightRead` + scorecard/broadcast/stoppage evidence; thresholds are named constants; width via `UIKit._clip_measure_width` at `UITokens.CAUSATION_BOX_LINE_MEASURE`.
- `PostFightRead.build_read` + `build` wires `causation_bullets` on complete reads (panel keys unchanged).
- `Godot/tests/fight_causation_test.gd`: KO, decision, submission, empty weak bout, five-slot cap.

## Tests

- Parse gate: `FightCausation.gd`, `PostFightRead.gd`, `fight_causation_test.gd` — pass.
- `python Godot/tools/run_tests.py --only causation` → `total=1 fails=0`
- `python Godot/tools/run_tests.py --only fight_result` → `total=1 fails=0`

## Majority decision (still open)

`decision_type == "majority"` maps to no U130 token (`MD` is in the kit manifest but not in `UIKit._RESULT_METHODS` / `result_block`). U135 cannot add `MD` without editing `result_block`, which U130 owns. **Majority decisions still skip the result block** until a follow-up adds `MD` to the U130 contract.
