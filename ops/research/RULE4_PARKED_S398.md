# Rule 4 ("the plan must be a puzzle"), S398: PARKED until Fighter profiles lands

Rule 4 (docs/STRUCTURE_DESIGN_S395.md 5.3a): a player who reads the opponent more deeply must clearly out-plan one who only
reads the scouting headline. tests/plan_bots_test.gd prints it as OPEN (S397: lookup 0.720 vs weighed 0.725 vs Maria).

## What S398 tried (designer/critic split, Python model of the plan path, a fresh blind critic each round)
| round | idea | blind score | why it failed |
| --- | --- | --- | --- |
| v1 | press row: step back best -> ok, 1-6-3 best | 4.5 | the gap came from the lookup bot leaving mid empty; a fair headline player (board's top option) ties |
| v2 | hidden row: tired vs a body puncher, tie-up wrong, roll-out best | 3.5 | a fair board-top player ties (+0.003); the Playbook shows the opposite of what the bout scores |
| v3 | readers write "when" lines for her other games + "she adjusts" (she switches game when answered) | 4.5 | one fixed plan matches the reader on most opponents; adjusting adds ~+0.02 and doubles plan_templates_test's fail rate |

## The finding
Today's PlanFight.ANSWERS rewards ONE universal plan. A fixed plan [step_back, 1-1, tie_up, 1-2 when range] used against every
opponent gains as much as an opponent-specific reader on Priya, Erin, Holly and Megan (Erin's reader even beats Priya's own on
Priya). step_back, 1-1, pivot_out and tie_up are "best" against most games. There is little to read, so no bot, gate or small
lever makes reading pay. (Also found: the old rule-4 bot's corner swap was dead code - it read f["bout"]["answer_uses"], which
LiveRound keeps per round in lv.)

## Next step: restructure ANSWERS by opponent, on the fighter model
Make the best plan differ by opponent: each style's main card brings 2+ games whose best answers conflict, and the fighter's
toolbox has an answer for each, so "when" lines and tape facts matter. Build it on Fighter profiles' per-fighter attributes;
the operator decides which answers beat which styles (the table cites real fights). Gate: the reader beats BOTH a fair
board-top headline bot AND a fixed universal plan (control arm) by about 0.03+ per opponent, at N=600, on equal information.

Ripple list (each must be re-measured):
- tests/plan_templates_test.gd and PlanTemplates (opponent templates vs the starter, 40-bout gates)
- CoachPlan (the coach plans her main game only; rule 1 bots, Hale writes 2 lines)
- BoutRead (shown chance walks the plan's mean edges; tests/bout_read_test.gd)
- PlanFight.starter() (the coach's suggestion before he knows her opponent)
- tools/plan_effect_probe.gd (spread: good vs wrong ~38 points, a stronger fighter still wins)
- the Playbook ratings (PlanLines / GamePlan best-ok-wrong per game) and FightWhy wording

## Open defect for the chance model (owner: Fighter profiles)
BoutRead under-counts a plan line she would throw anyway. Lucy vs Priya, a planned undrilled double jab (already her instinct
at long): real bouts 0.338 -> 0.600 (+26 points), BoutRead.chance 0.349 -> 0.472 (0.12 short). The plan edge counts against
the card's mean even when the arrow is her instinct, and PlanRead's reads and PlanPressure build with how often the arrow
fires (superlinear), while BoutRead scales the edge linearly (PLAN_CARRY 1.3). A "won arrow keeps her on its card" term closed
only 0.03. No test hits it today because CoachPlan writes drilled answers only (1b11af53).

Design rounds and reviews (outside the repo): side-session-notes lines-compete-design-s398.md, -critic-, -critic2-, -critic3-.
