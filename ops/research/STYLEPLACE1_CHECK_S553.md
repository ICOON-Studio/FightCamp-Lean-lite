# STYLEPLACE1 checked against the code and its own run files (S553, Claude)

Page checked: `docs/STYLEPLACE1_RESULT.md` (commit 7f1f2e758). Verdict: its FAIL stands, and its reason stands.

| Claim on the page | Checked how | Holds? |
|---|---|---|
| Probe only, no game file changed | `git diff --stat 9b0ef16dd..7f1f2e758`: four files, all under `tools/` and `docs/`; the two earlier commits (81f45569c, 24aa500c9) touch only the design page | yes |
| Wins in 100, all five women, six arms (off 76.2 / 77.0 / 77.5 / 76.2 ...) | `python tools/styleplace1_sum.py bars "E:/FightCamp/tmp/styleplace1/full_*.jsonl"` rerun here: every ALL cell and every per-boxer difference equals the page | yes |
| Bars 1, 2 and 4 fail in every arm; the largest single boxer is Cara Bello +3.5 to +4.2 | same rerun: "0 of 5" on bars 1 and 2 for off, L1, L1h, L2; no row reaches +6 | yes |
| A plan line is worth 9 at best | `PlanFight.EDGE` l.21: best 9, ok 3, none 0, wrong -7 | yes |
| An exchange is rolled on a spread of 66 | `Exchanges.EX_SPREAD` l.14 = 66; `settle` l.357 adds two rolls of half that width each | yes |
| The corner's best shout is worth 17, the ropes 5 | `Exchanges.EDGE` l.18 best 17; `PlaceEdge.ROPES` l.17 = 5 | yes |
| Styles do not learn from results | `Exchanges.next_mode` l.269-283: rolls from style, weak word, round, energy and the bout's fixed bias; nothing is written back | yes |

Small thing found: the comment above `PlanFight.EDGE` (l.19) still says a best shout is 15; the code has 17. A comment
only, not fixed here (no game file changed this session).

Limits the page states itself and that stay true: 3 rounds only for the women; bar 3 at 40 bouts a cell is inside the
dice; bar 8 passes today so it tells nothing; "best plan" picked per boxer after the run (leans toward passing, still fails).
Not checked by me: the control identity (400 of 400, 2,000 of 2,000, 2,160 of 2,160: taken from its run files, not rerun);
the place shares; the film bar.

What it means: three probes now agree (PLANIMPACT1, PLANIMPACT2, STYLEPLACE1). Neither the plan rule nor where opponents
fight is the cap. A plan line weighs 9 on a roll 66 wide, about half a corner shout, and only when its line fires. The
only lever left is the weight itself, which is a plan-rule change the scope rules out until the owner decides.
S553 (owner: "i think we should focus more on the RingSwitches"): the plan line is parked, nothing cut; no fourth probe.
