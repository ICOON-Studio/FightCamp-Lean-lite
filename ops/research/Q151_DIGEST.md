# Q151 digest

## What changed
- `CornerPanel.gd`: COPY dictionary re-keyed on option identity (`range_call` > `emphasis` > `pace`) so each of the 6 adapter options gets its own SAY line. Pace-only copy preserved as fallback for unknown options.
- Card height now dynamic: `_compute_card_height(n) = max(520, 296 + n*66)`. Outcome label and skip button reposition after the last button.
- New test `corner_card_copy_test.gd`: 12 checks — every adapter option's SAY line is distinct, every button rect encloses within the card rect, card height matches formula.
- Render `tools/render_corner_card.gd` → `previews/corner_card/corner_card_6_options.png`.

## Gate
- Parse gate: 3/0.
- `corner_card_copy_test.gd`: 12/0.
- `corner_panel_test.gd`: 29/0 (mutant red=3 is pre-existing — hardcoded-array size vs adapter count).
- `run_tests.py --only corner`: 6/0. `--only ui`: 17/0.

## Render verdict
All 6 SAY lines read distinctly:
1. Conserve → SLOW THE PACE — TANK IS PAYING INTEREST.
2. Hold the centre → HOLD CENTRE — NO CHANGE OF GEAR.
3. Push forward → PUSH THE PACE — YOU NEED THIS ROUND.
4. Stay long → STAY LONG — STOP CHASING.
5. Get inside → GET INSIDE — MAKE HIM UNCOMFORTABLE.
6. Go for the finish → GO FOR THE FINISH — EMPTY THE TANK.

All buttons inside card rect. Skip stool below.
