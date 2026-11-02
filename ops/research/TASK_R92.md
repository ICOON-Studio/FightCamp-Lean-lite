# TASK R92 — CLAUDE — THE ADAPTER BETWEEN THE FOLD AND THE JUDGES, AND THE CLINCH SEAT

Model: **Opus, high effort, Fast mode off.** Owner: Claude. Base: `master` after
R91 (`0020568`), Q22 (`8f0706d`), U29 (`b103e14`). Assigned 2026-09-10.

---

## Why this exists

R91 made grappling occur. Three things it deliberately left open are now the
whole of what stands between the engine and an honest grappling card:

1. **The blind pair disagrees on the event payload.** U29 feeds G34-shaped
   records (`kind`, `from_seat`, `to_seat`, `grade`, `held_ticks`, `finished`)
   and Q22's `award()` reads `type`, `amplitude`, `seat`, `hold_seconds`,
   `back_on_tatami`, `finished`, `is_reversal`. Neither task file specified the
   dictionary, so every scoring emission comes back `not_scored`. The engine
   meanwhile writes its own record: `kind`, `via`, `seat`, `grade`, `points`,
   `held_ticks` (see `_log_grapple` and the gate-met event in
   `_grapple_ground`). **Three shapes, one contract hole.**
2. **The per-ruleset conversion is not wired.** `RealtimeRoundStats._fold_grapple`
   folds engine units straight to the judges, so judo scores a takedown it
   should not, and MMA counts points ABC never published.
3. **No clinch seat**, so no `throw` is ever emitted and `throw_points_round`
   still has no writer - judo and wrestling cannot score at all.

## What to do

1. **Settle the payload, once.** The engine's record is the source of truth,
   because it is the one that exists in a real bout. Correct `GrappleAdapter`
   where the contract proves it wrong (the key names, the reason recorded in a
   comment) so that **`grapple_adapter_contract_test.gd` goes green WITHOUT
   being edited** - it is the gate on this work, exactly as C67 was for R90.
   Where U29 asserts a G34 key the engine does not write (`from_seat`,
   `to_seat`), add it to the engine's record rather than to the test.
2. **Wire the adapter into the fold.** `RealtimeRoundStats.fold` gains a
   ruleset id (default `""` keeps today's engine-unit behaviour so U22's test
   stays green), and per ruleset the counters take `GrappleAdapter.award`'s
   points instead of engine units. `_close_round` passes the ruleset. The map
   from `combat_rulesets.json` ids to the adapter's four (`ijf`, `uww`,
   `ibjjf`, `abc`) is data, and the seven rulesets that are none of them keep
   engine units, labelled.
3. **The clinch seat.** `standing → clinch/over_under` (10-tick hold, 1 control
   unit to the top man), `clinch_break`, and a **throw from the clinch**
   through `takedown_resolve(..., "clinch", ...)` emitting `throw` with its
   grade - the writer `throw_points_round` never had. G39 (Grok) is the
   forecast research on what a clinch scores per ruleset; do not block on it
   for the seat itself, only for the conversion.
4. **Prove it occurs**: a `throw` in a judo-profile bout that reaches
   `throw_points_round`; a clinch control unit folded; MMA's card carrying no
   published points (evidence only); U29 green unedited.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | ~1,773 | **Never open whole.** `grep -n "static func _run_grapple\|_grapple_standing\|_move_seat\|_grapple_ground\|_run_control\|grapple_of"` for the R91 section (from `:1400`); `_close_round` `:570`-ish. |
| `Godot/scripts/RealtimeRoundStats.gd` | 150 | Small enough to read whole. `_fold_grapple`, `CONTROL_UNITS_PER_POINT`. |
| `Godot/scripts/GrappleAdapter.gd` | 251 | Qwen's (Q22). Correct ONLY the key names the contract proves wrong; reason recorded. |
| `Godot/tests/fight_realtime_test.gd` | ~1,700 | **Never open whole.** Add at the end; R91's tests are the pattern. |
| `research/R92_DIGEST.md` | new | |

**Do NOT edit** `Godot/tests/grapple_adapter_contract_test.gd` (Cursor, U29 -
the gate), `grapple_contract_test.gd` (Codex), `FightHudRead.gd` /
`FightHudPanel.gd` (Q23 / U31, in flight). `GameState.gd` is 14,769 lines and
is not needed.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/realtime_round_stats_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`. The pinned cards WILL move for the
rulesets whose conversion changes (mma_11, mma_5, muay_thai_17 at least):
report the numbers and re-pin in a SEPARATE commit, as R91P did.

## The trap specific to this task

**The draw budget.** R91 fixed `_rng_grapple` at FOUR draws per decision tick
and asserted it by replaying the generator through `advance_tick`. A clinch
engagement needs a roll. Either it comes out of the four (a gate roll that is
already drawn and unused on the tick it engages) or the budget becomes five
and `_test_the_grapple_stream_takes_four_draws_every_decision_tick` is changed
**in the same commit**. Never a draw inside an `if`.
