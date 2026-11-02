# U134 digest — wire post-fight result block into FightResultPanel

**Branch:** `cursor/u134-wire-result` (cut from `origin/master` @ c3ccb750).  
**U130 on master:** yes — no merge of `cursor/u130-post-fight-result` required.

## Shipped

- `FightResultPanel.gd`: replaces `UIKit.verdict_block` with `result_block` + optional `causation_box` at `VERDICT_X` / `RESULT_Y` 40; Continue unchanged at `(96, 776)`.
- Outcome fields via `result_block_fields()` / `result_method_token()` / `result_clock_from()` from merged sim keys (`winner_side`, `method`, `decision_type`, `result_type`, `duration_seconds`, corner names) — not from `description`.
- `payload_from_sim()` now passes `result_type`, `duration_seconds`, `rounds_completed`, `decision_type`.
- `Godot/tests/fight_result_panel_test.gd`: TKO wiring, DRAW + NC layouts, >5 causation bullets → no box.

## Findings

- **Causation data plane:** no engine key landed yet (`PostFightRead` has no bullets). Panel reads `causation_bullets` / `causation` / `cause_bullets` on payload or `post_fight_read`; absent → no box (not a placeholder).
- **Majority decision:** `decision_type == "majority"` has no U130 token (MD not in `_RESULT_METHODS`); `result_block` omitted until token exists.

## Tests

- Parse gate: touched `.gd` files.
- `python Godot/tools/run_tests.py --only ui` → total=17 fails=0
- `python Godot/tools/run_tests.py --only fight_result` → total=1 fails=0
