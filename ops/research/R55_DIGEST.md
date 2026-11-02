# R55 — the body is six places, not one number

**What the read answers that nothing could answer before:**
`GameState.get_body_read(athlete_id)` returns the six regions with each one's
own value, band, competition threshold and clears verdict, the weakest region
by DEFICIT rather than by lowest number (a 72 head against a 90 bar is in
worse trouble than a 70 arm against 80), and — the new fact — **the medical
hold finally names WHERE**. `apply_fight_damage` has always written only
`"<profile> after <method>"` into `medical_hold_reason` and dropped the
hotspots it picked; the settled bout kept them on the durable `fight_history`
row, and nothing in the codebase read them. The hold's region is now derived
from the newest bout at or inside the hold's window. Where that bout named no
region, `region` is `""` and `region_known` is `false`, and only that bout is
consulted — an older bout's hotspot is never borrowed to fill the blank.

**G13 landed mid-session** (`cf6a2b5`, merged as `974e2b3`) and is consumed.
`RegionHistory.summarize()` counts hotspot bouts, lifetime damage, worst single
bout, last week hit and bouts seen; R55 authors none of those numbers, it hands
the rows over. **One correction to the assignment:** the ledger needs
`body_damage` (before, after, hotspots), which is kept only on the settlement
entries in `career.fight_log` - `get_fight_log()` projects it away into note
strings - so `_body_damage_rows()` hands G13 the career log filtered to the
fighter. That log belongs to the CAREER, not the roster row, so a retired
fighter keeps their ledger (Q27). `history_known` is false, and the per-region
counts absent, only when no settled bout could say; bouts the block predates are
reported as `history_unknown_bouts` rather than folded into the counts.
`history_worst_region` (most-hit across the career) is kept separate from
`weakest` (furthest under today) - two different questions.

**The healing clocks were again deliberately left alone.**
`BodyReadiness._apply_recovery` and `forecast_weeks_to_training` are
untouched and unwrapped; no rate, no projection, no "weeks to clear". The
rates are UNKNOWN (J12 D1) and the operator's 2026-09-07 decision gives
per-region recovery its own research pass and its own stage. `BodyReadiness.gd`
was not edited at all — the read needed no new helper.

**The R53 trap, decided explicitly:** `get_body_read` answers for a RETIRED
fighter, resolving roster-then-world exactly as `get_aging_read` does, because
`_retire_athlete` keeps `body_state` and `fight_history` on the world record
and K24 puts the finished career on its own profile. Tested (Q19–Q20).

**Purity:** the read never migrates and never writes. An athlete the save never
gave a `body_state` reads as six untouched regions and does not gain one
(Q17–Q18); repeated reads leave Career byte-identical (Q22).

Not built: the screen (U3 rules how six regions may read on one human being and
has not landed), any injury taxonomy, any new hue or word.

## Files

- `Godot/scripts/GameState.gd` — `get_body_read`, `_body_read`,
  `_body_hold_read`, `_body_hold_region`, `_body_damage_rows` at `:7456`,
  beside `get_aging_read`.
- `Godot/tests/body_read_test.gd` — new, 29 checks.
- `Godot/scripts/BodyReadiness.gd` — unchanged.
- `Godot/scripts/RegionHistory.gd` — Grok's, consumed, not edited.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_read_test.gd
```

Parse gate 3/3. Focused: body_read 29/0, body_readiness 0 failures,
body_readiness_integration 0 failures, gym_hub 41/0, profile_revamp 0 failures.
