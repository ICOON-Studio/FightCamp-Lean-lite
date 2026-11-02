# U25 digest — the live fight read

Ships on `master` from `cursor/u25-fight-hud-panel-26c5` (merged), plus
`e6192a0` (region-bar readout width). Reconciled under U28 against the
unmerged twin `cursor/u25-fight-hud-panel-e353` — master's panel kept.

## What landed

`Godot/scripts/FightHudPanel.gd` renders a folded fight-HUD dictionary.
No scoring, no judging, no engine. Cardio prints as bpm + zone (`178 BPM` /
`RED LINE`), never a stamina tank. Attrition is a continuous kit `gauge_bar`
per body region (readouts kept inside the column). Trauma is four-step pips
per site (cut and swelling), never a bar. `worst_trauma.words` is the
broadcast phrase. Header carries round, elapsed clock, CORNER when resting,
and the running score.

The panel takes the fold as plain data — no `FightHudRead` preload — so it
renders whether or not Q18 is present. Tests stub the fold.

## Checks (at merge)

- parse gate clean on panel + test
- `fight_hud_panel_test.gd`: discrete pips 0/1/4 + clamp; bpm+zone not a bar;
  missing keys; stable rebuild
- Full suite green at merge; see U28 for the reconciliation re-run

## Trap

R31: `_root` sized without full-rect anchors. Rebuilds `remove_child` before
`queue_free`. Gold is not spent (`gold: none`).
