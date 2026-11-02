# C50 — The fourth result

`no_contest` is now an explicit additive `result_type` and participant result. It carries no winner, leaves W/L/D records, ranking points, streaks, title belts, and Grand Prix advancement unchanged, while preserving the fought bout's mileage, body damage, injury ledger, history, and log evidence. A title NC records the title appearance without invoking belt mutation. `technical_decision` remains a scored wrapper around the existing W/L/D card outcome.

The three default seams are guarded: an empty live `winner_side`, a pending result with no legacy `result` key, and the Grand Prix non-win branch all preserve NC instead of becoming draw, loss, or elimination. Durable bout/post-fight reads retain `result_type`; record stats and career summaries count NC separately, while mileage keeps its physical-round count and excludes NC from finish verdicts. Legacy rows remain absence-aware and no new NC generator was added.

Focused evidence: `fight_log_test.gd` 0 failures (including the three seam regressions and consumer checks), `bout_read_test.gd` 25 checks / 0 failures, `championship_read_test.gd` 30 checks / 0 failures. Full suite: 179 tests, 0 failures.
