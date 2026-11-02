# U28 digest — which U25 won

**Pushed to `master`.**

## Verdict

**Kept master's panel** (`cursor/u25-fight-hud-panel-26c5` / blob on
`origin/master`). Did **not** port e353. Left both remote branches alone.

## Why

U25's contract is cardio as bpm + zone and trauma as discrete pips. Both
blobs honour that identically — heart and trauma trees match. The e353 delta
is elsewhere:

1. `_resolve_read` optionally calling `FightHudRead.fold` — master's plain-data
   fold (no preload) is the better merge shape and was already accepted.
2. A hand-rolled `_region_bar` instead of `UIKit.gauge_bar` — attrition is not
   the U25 contract, and master already fixed the readout clip in `e6192a0`.
3. `score_a` / `score_b` on `frame_for_chrome` — chrome sugar; the header and
   `contract_for_test` already expose the running score.

Equivalent on the ruling that matters → keep master. No third hybrid.

## Files

| File | Action |
| --- | --- |
| `FightHudPanel.gd` | unchanged (master wins) |
| `fight_hud_panel_test.gd` | unchanged (matches master panel) |
| `U25_DIGEST.md` | landed; describes what ships |
| `U28_DIGEST.md` | this file |
