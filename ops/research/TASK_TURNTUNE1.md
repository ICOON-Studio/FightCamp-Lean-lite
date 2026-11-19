# TASK TURNTUNE1 - size turning pro's ESTIMATE numbers until the choice is real (tuning, probe-driven)

Status: OPEN (S525, Claude main). Discipline: boxing. Model: Goose (cloud) - headless, no window.
Mechanic: TURNING PRO v2 (approved Q-227, built S522-S524). Design: `ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md`
section 7 (the pass lines). Probe: `tools/turn_pro_probe.gd` (on main, Goose #380). Result now: `docs/TURNPROBE1_RESULT.md`
- 2 of 9 lines pass (8: house split; the rest fail).

## What to do
Change ONLY the ESTIMATE constants at the top of `scripts/rules/ProCall.gd` (and `Roster.PRO_OPP_GAP` /
`Roster.PRO_RETURN_WINS` if line 5 or 6 needs them - constants only, no logic) until these lines pass on BOTH seed sets:
- 1. no bot best in over 60% of careers at week 104;
- 2. PREP beats YES at week 104 by $1,500+;
- 4. a YES debut loses the gym money in 40-70% of debuts (PURSE_FLOOR, SHORT_TICKET);
- 6. debut win rate 65-80% at 1.0 under, 70-85% at 1.5 under;
- 7. every ask the best pick in 10%+ of offers (today "costs" 81%: COSTS_BASE_ADD / COSTS_RUNWAY_ADD are too generous;
     later2 / softer / split 0%: make each worth it somewhere - read who would want it in the design's s3).
REPORT ONLY (do not chase): line 3 (stipend timing - day-job careers rarely get an offer in 2 years, so the bots tie),
line 5 (the rank door), line 9 (no signing-card ambition says "turn pro" today, so AMB's +5 morale cannot happen - a design gap).
Each probe run ~19 min at 30 careers a bot: tune at 10 careers a bot on seed 4421, confirm the final set at 30 on both seeds.
Change one family of constants per run; log each run's constants and pass lines in the result doc.

## Contract
OWNS: scripts/rules/ProCall.gd (constants block only), scripts/state/Roster.gd (PRO_OPP_GAP / PRO_RETURN_WINS lines only),
tools/turn_pro_probe.gd (only a careers-per-bot argument), docs/TURNTUNE1_RESULT.md
RED_TEST: tools/turn_pro_probe.gd -> TURNPROBE1 done
REGRESSION: pro_call_test, pro_offer_wire_test, pro_ladder_test, pro_debut_test, golden_path_test (run them; a test that
pins an old constant may be updated to the new value ONLY, say which in the PR body)
VISUAL: no
NOT YOURS: everything else. PR body: `RESULT: tools/turn_pro_probe.gd -> lines_pass=<n of 9> changed=<CONST=old->new,...>`
plus each regression test's pass line. Wrap every Godot run in `timeout 2400`. Stop after 90 minutes of total run time and
push what you have with the log (a partial table beats a timeout). Never rerun the same constants twice.

## Prior research
`python ops/Tools/prior_research.py turning pro ask` -> DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md, TASK_TURNPROBE1.md,
docs/TURNPROBE1_RESULT.md.

## What would a human do?
A manager picks the ask that fits his boxer: broke club -> costs, slow boxer -> softer, big following -> price. If one ask
wins everywhere, it is priced wrong.

## Prefab check
None: game constants.

## The one trap
Tuning the probe instead of the game: the probe's bots and pass lines are fixed; only the game's constants move.
