# C74 digest — Muay Thai grapple fold

- Q24 `not_scored`: `clinch_engage`, `control_units`, `clinch_break`, `takedown`, ordinary `throw`, `position_change`, `exposure`, and `submission_attempt`. These publish no discrete Muay Thai grapple score; grade `2`/`4` is therefore not used as a tariff.
- Q24 `foul`: a caller that can positively state `throw_hip_throw` receives `foul`. The live engine cannot detect that technique class, so an ordinary emitted `throw` remains `not_scored` rather than inventing a penalty.
- Q24 `REFUSE`: `step_out`, because the one-dimensional engine cannot establish the required fact. `not_scored`, `foul`, and `REFUSE` stay separate: absence of a score, a published penalty, and unavailable evidence are different answers.
- `scores_grappling("mt")` is `false`, as argued in Q24 section 5: Muay Thai publishes no discrete grappling-point fold.
- `clinch_break_ticks("mt")` is `-1` — **NONE PUBLISHED** by IFMA/WMC. The WFMC/amateur "five seconds" value is refused by name and is not imported into this ruleset.
- Engine witness seed `93041` landed `1` Muay Thai throw. Its grapple throw fold changed from `4.0` to `0.0`; no scorecard moved: all three judges remained `30-25`, unanimous decision.

Focused gates: `grapple` `SUITE total=7 fails=0`; `judge_panel` `SUITE total=1 fails=0`; `realtime` `SUITE total=2 fails=0`.
