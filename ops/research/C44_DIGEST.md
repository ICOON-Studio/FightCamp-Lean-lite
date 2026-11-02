# C44 digest — one voice for the seven attributes

- `AthleteStatModel` now preloads `StatWords`; its seven duplicated `label`
  entries are removed, `stat_label()` and stat tooltips use the canonical
  module, and the existing stat order matches `StatWords.STAT_IDS` exactly.
- `fight_legend_text()` composes canonical labels and Q6 glosses for every
  stat; `fight_legend_tooltip()` now has the required seventh placeholder.
- `DevelopmentPanel` now renders growth labels through `StatWords`, with
  regressions covering canonical labels and `FIGHT IQ` spacing.
- `fight_legend_tooltip()` remains intentionally uncalled; no caller was
  invented. Parse gate and focused tests pass; full suite: 172 tests, 0
  failures.
