# U24 digest — the scorecard screen

Branch: `cursor/u24-scorecard-panel-80cb`

## What landed

`Godot/scripts/ScorecardPanel.gd` renders `ScorecardRead.build(result)`. No
scoring, no judging, no engine. Layout is R85R's: ROUND | 1..N | TOTAL, three
fictional named judges (Mara Voss / Ellis Crowe / Jonah Pike, mapped by index)
on two corner rows each, a coloured rule above an A-win cell and below a B-win
cell, totals boxed with that judge's winner marked, banner beneath.

`disagreement_rounds` is drawn both ways: a split round grows `DisagreeMark`
on `Head_N`; an agreed round does not. A twelve-round grid wider than the
shell scrolls inside `GridScroll` (horizontal AUTO). A stopped fight uses the
scored rounds only and does not invent the rest.

HANDOFF.md was not edited.

## Checks

- parse gate: `CHECK total=3 fails=0`
- `scorecard_panel_test.gd`: 30 checks, 0 failures (T1 twelve columns + three
  judge blocks; T2 disagreement marked and agreement not, both directions;
  T3 unanimous and split totals; T4 stopped fight; T5 in-container scroll)
- `scorecard_read_test.gd`: 11 checks, 0 failures
- `python Godot/tools/run_tests.py --godot /usr/local/bin/godot`:
  `SUITE total=203 fails=0`

## Trap

R31 observed: `_root` is sized without full-rect anchors. No TextureRect of
our own. Rebuilds `remove_child` before `queue_free`.
