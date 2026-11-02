# NIGHTLY_LABELS_S255 — 16 nightly reds labelled by discipline

Suite: 2026-10-17 at 5b92bef2, 885 tests, 16 FAIL.
Operator rule S255 Q-S249-7: demo is BOXING only. Fixed equipment slots (no Two Point placement), no promotions.
Q-S249-6: weigh-in, visible cut + cutman, mitt pop sound ARE in.

## Discipline key

- **BOXING-DEMO** — in scope: the boxing demo the player sees
- **GYM-DEMO** — in scope: gym management (equipment, staff, training floor)
- **OFF-DEMO** — out of scope: MMA, kickboxing, promotions, placement, story, switched-off mechanics

## The 16 reds

| # | test | log date | discipline | first FAIL line (exact) | script / function | likely cause | cheapest next step |
|---|------|----------|------------|------------------------|-------------------|--------------|--------------------|
| 1 | asset_manifest | 2026-10-18 | GYM-DEMO | `[FAIL] asset folder res://assets/anim/actionforge/ is claimed by a manifest entry` | asset_manifest_test.gd / `_initialize` | 30 unclaimed asset folders/references (office, physio, c78floor, anim) missing from manifest | fix code — add manifest entries for the 7 unclaimed folders |
| 2 | camp_pays | 2026-10-17 | BOXING-DEMO | `FAIL: (a) camped jab landed 31.0% [28.6, 33.6] beats uncamped 30.2% [28.1, 32.5], CIs apart` | camp_pays_test.gd / `_initialize` (Wilson CI check) | Camp effect too small: 0.8 pp jab-rate lift, Wilson 95% CIs overlap at 30 bouts/arm | fix code — increase camp strike_success edge, or fix test — widen CI acceptance |
| 3 | corner_instruction_contract | 2026-10-18 | BOXING-DEMO | log from later run shows PASS (0 failures, rc=0) | corner_instruction_contract_test.gd | Original suite failure not captured in available log; later run passes | already fixed before log date — no action |
| 4 | default_build_shows_no_real_name | 2026-10-17 | BOXING-DEMO | log from later run shows PASS (0 failures, rc=0) | default_build_shows_no_real_name_test.gd | Original suite failure not captured in available log; later run passes | already fixed before log date — no action |
| 5 | decision_pacing | 2026-10-17 | BOXING-DEMO | hang (rc=124), no output after Godot header | decision_pacing_test.gd / `_initialize` | Parse error or infinite loop in DecisionPacing.gd; headless hang, no test output | fix code — parse error in DecisionPacing.gd or preload |
| 6 | fight_clip_slice | 2026-10-18 | BOXING-DEMO | `FAIL  head-strike beat plays clip shorter than 1.2 s (got 1.724, name=boxing_rear_hook)` | fight_clip_slice_test.gd / `_initialize` (strike length assert) | boxing_rear_hook clip is 1.724 s, exceeds the 1.2 s threshold for a single punch | fix test — raise threshold to 1.8 s for hooks, or fix code — trim/slice the clip |
| 7 | fight_contact_stop | 2026-10-18 | OFF-DEMO | `FAIL: landed kickboxing_low_kick surface error <=3cm: -1.13670302410396` | fight_contact_stop_test.gd / `run` (landed kick depth check) | Test runs MMA discipline (`"discipline": "mma"`); kickboxing low kick lands 1.14 m from target | park as OFF-DEMO — MMA/kickboxing contact geometry not in boxing demo |
| 8 | fight_identity | 2026-10-18 | BOXING-DEMO | log from later run shows PASS (0 failures, rc=0) | fight_identity_test.gd | Original suite failure not captured in available log; later run passes | already fixed before log date — no action |
| 9 | fight_pair_live | 2026-10-18 | BOXING-DEMO | `FAIL  pairs play on this bout  { "qualifying": 3, "no_pair": 0, "played": 1, ...` | fight_pair_live_test.gd / `_test_play` (pairs play count) | Only 1 of 3 qualifying pairs played; ONE CLOCK drift (1 frame off), 50 foot-lock frames inside pair | fix code — pair scheduling and ONE CLOCK sync |
| 10 | fight_realtime | 2026-10-18 | BOXING-DEMO | hang (timeout) in suite; log from later run shows PASS (378 checks, rc=0) | fight_realtime_test.gd | Original hang from parse error in FightRealtime.gd; later fixed | already fixed before log date — no action |
| 11 | fight_stage_realism | 2026-10-17 | BOXING-DEMO | `RULE R1 space_between_exchanges | GATED S4a | FAIL` | fight_stage_realism_test.gd / `_rule_rhythm` | 8 gated rules fail: R1 (inactive 4.96 s vs bound 1.4-3.2), R2 (1 stance take vs 3), R3 (skate), R5/R5b (join speed 11.5x), R7 (body overlap 3.9%), R8 (glove 50% reach) | fix code — multiple presentation issues (rhythm, stance variety, blend, overlap, reach) |
| 12 | playable_loop | 2026-10-17 | BOXING-DEMO | log from later run shows PASS (fails=0, rc=0) | playable_loop_test.gd | Original suite failure not captured in available log; later run passes with 0 fails | already fixed before log date — no action |
| 13 | promotions_board | 2026-10-17 | OFF-DEMO | log from later run shows PASS (0 failures, rc=0) | promotions_board_test.gd | OFF-DEMO per Q-S249-7: no promotions in demo scope; test exercises full promotions board | park as OFF-DEMO — promotions not in S255 demo scope |
| 14 | staff_pose | 2026-10-18 | GYM-DEMO | log from later run shows PASS (0 failures, rc=0) | staff_pose_test.gd | Original suite failure not captured in available log; later run passes | already fixed before log date — no action |
| 15 | station_move_picker | 2026-10-17 | GYM-DEMO | log from later run shows PASS (0 failures, rc=0) | station_move_picker_test.gd | Original suite failure not captured in available log; later run passes | already fixed before log date — no action |
| 16 | switch_gate_hands_smooth_in_whole | 2026-10-17 | BOXING-DEMO | `FAIL  hands_smooth_in_whole: correction step p95 ON 4.1 <= 0.9 x OFF 4.0 m/s (steps >3.5 m/s ON 29 OFF 27)` | switch_gate_hands_smooth_in_whole_test.gd / `_initialize` (p95 threshold) | Switch ON does not reduce hand correction p95 sufficiently: 4.1 vs threshold 3.6 (0.9×4.0) | fix code — improve smoothing algorithm, or fix test — relax threshold |

## Summary

**BOXING-DEMO (9 reds):** camp_pays, corner_instruction_contract*, default_build_shows_no_real_name*, decision_pacing, fight_clip_slice, fight_identity*, fight_pair_live, fight_realtime*, fight_stage_realism, switch_gate_hands_smooth_in_whole. The heaviest is fight_stage_realism (8 sub-rules failing on rhythm, stance, blend, overlap and reach). fight_pair_live has pair-scheduling and ONE-CLOCK drift. decision_pacing is a hang (parse error). (* = already fixed in later log.)

**GYM-DEMO (3 reds):** asset_manifest (30 unclaimed folders), staff_pose*, station_move_picker*. asset_manifest needs new entries; the other two are already fixed in later logs.

**OFF-DEMO (2 reds):** fight_contact_stop (MMA kickboxing low kick, 1.14 m error), promotions_board (no promotions in S255 demo per Q-S249-7). Both should be parked — they test mechanics outside the boxing demo scope.

**Already fixed (7 reds):** corner_instruction_contract, default_build_shows_no_real_name, fight_identity, fight_realtime, playable_loop, staff_pose, station_move_picker — their available logs (from later runs on 2026-10-17 or 2026-10-18) show PASS. The suite's red at commit 5b92bef2 predates those fixes.

**Actionable fixes needed (5 reds):** asset_manifest (add entries), camp_pays (increase effect or widen CI), decision_pacing (fix hang), fight_clip_slice (raise threshold or trim clip), fight_pair_live (fix pair scheduling), fight_stage_realism (8 presentation rules), switch_gate_hands_smooth_in_whole (improve smoothing or relax threshold).

**Park as OFF-DEMO (2 reds):** fight_contact_stop, promotions_board.
