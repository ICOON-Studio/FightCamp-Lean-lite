# PLANIMPACT2 checked against the code and its own table (S551, Claude)

Page checked: `docs/PLANIMPACT2_RESULT.md`. Verdict: its FAIL stands, and its reason stands.

| Claim on the page | Checked how | Holds? |
|---|---|---|
| All six styles fight on the same four places (mid, long, outside, own ropes) | `Exchanges.STYLE_MODES` l.156-166: every style has all four games above 0; `PlanFight.GAME_CARD` l.25: press and loadup -> mid, range -> long, counter -> outside; `LOST_CARD` l.28: press and loadup -> own ropes | yes, for all nine styles in the table, not only six |
| On mid the top game is press for Pressure, Counter-puncher, Volume and loadup for Boxer-puncher, Out-boxer, Slugger | weights by hand through `CoachPlan.cards` l.37-55 (Counter-puncher is a 0.1 / 0.1 tie that the first-listed game, press, keeps) | yes |
| Three commands can never be prepared | their moments (tiring, she_tired, she_hurt) are in no style's weights; `tools/cornercmd2_rules.gd` l.38, 42, 46 | yes |
| Best plan minus careless +2.3 (3 rounds), +2.0 (6 rounds) | mean of the five per-boxer rows: (5.5 + 1.8 - 0.2 + 4.5 + 0.0) / 5 = 2.32; (4.5 + 4.8 - 0.8 + 2.0 - 0.5) / 5 = 2.0 | yes |
| The rule adds about half a win | reader : C on - off = 77.6 - 77.1 = 0.5; 79.1 - 78.6 = 0.5 (the page's 0.7 at 6 rounds is the per-boxer best mix) | yes |
| A careless plan costs nothing against the coach's | 76.2 - 76.7 = -0.5 and 77.8 - 78.2 = -0.4 (page: -0.4 / -0.3, per boxer) | yes |

Limits the page states itself and that stay true: five women only (the brief asked ten types; the live corner exists
only in that harness); "best plan" picked per boxer after the run (leans toward passing; it still failed); every
difference under about 2.5 is inside its own +-.
Not checked by me: the 2000-of-2000 control identity (taken from its run files, not rerun).

What it means: two probes (PLANIMPACT1, PLANIMPACT2) say the plan RULE is not the cap. The cap is that every opponent
style fights in the same four places with the same best answers, so no plan can be specific. Making the plan matter is
a change to how opponents fight (a new scope), not another plan rule. That is his call (scope): board question S551.
