# PLANFLOW2 result (S538)

Owner (Q-S294-301): "yes add those , and maybe add a penalty if some combos are repeated too often the have a bigger
chance to be read by the opponent for a counter punch"

## Built (the three approved extras on the plan chart)

1. **Main bet.** Every written line on the chart has a "Bet on it" button; one line at a time is the MAIN BET. The bet
   rides on its line into the bout, and the result page's Plan tab opens with its verdict: paid / broke even / lost /
   never fired, with the count ("fired 4, won 3"). Clearing or replacing the line drops the bet.
2. **Uses.** After a bout each line on the chart shows "Last bout: fired N, won M" or "Last bout: never fired", beside
   the all-bouts count that was already there. Read from the record the bout already keeps (`plan_rec`): nothing is
   counted twice.
3. **Save / Load.** A "Save / Load" button opens the gym's saved plans (up to 12, kept in the save file). A plan saved
   by one boxer can be loaded onto another: only the lines that boxer can fire come across, and the page names each
   dropped line and why (not learned, still learning, or the coach's list is full).

Every new control has a tooltip that explains what it does.

Files: `scripts/ui/PlanBet.gd` (new, 127 lines), `scripts/ui/PlanSaves.gd` (new, 162), `PlanChart.gd` (497),
`GamePlan.gd` (499), `ResultTabs.gd` (Plan tab), `Career.gd` (`saved_plans`).

Fixed on the way: the chips in an IF answer box ran out of the box to the right once the bet and uses were added; they
now wrap inside it (the boxes are a little taller).

## Stills (the game's own screens, hidden desktop)

- `docs/planflow2/planflow2_chart_bet_uses.png` - the chart with a main bet and the last bout's uses.
- `docs/planflow2/planflow2_chart_saves_open.png` - the saved plans open.
- `docs/planflow2/planflow2_result_plan_tab.png` - the result page's Plan tab judging the bet.

## Tests (run S538, all through the Godot queue)

| test | line |
|---|---|
| tests/plan_saves_test.gd (new) | PLAN_SAVES PASS checks=24 fails=0 |
| tests/plan_chart_test.gd (steps 6-10 added: bet, save, clear, load, a fought bout's uses) | PLAN_CHART PASS fails=0 |
| tests/golden_path_test.gd | GOLDEN_PATH failures=0 |
| tests/save_load_test.gd | SAVE_LOAD checks=87 failures=0 |
| tests/result_tabs_test.gd | RESULT_TABS failures=0 |
| tests/plan_auto_test.gd | PLAN_AUTO PASS fails=0 |

## The repeat penalty: probed first, FAIL, not built

Full tables: `docs/REPEATREAD1_RESULT.md` (probe `tools/repeatread_probe.gd`, 60 boxers x 6 styles x 3 nights, 6,480
bouts, nothing under `scripts/` changed).

- A one-line plan lost 1.1 wins in 100 against the counter-puncher (bar: 5) and 0.4 overall (bar: 2).
- Why: a plan line fires about 3 times in an 18-exchange bout, so there is nothing to spam; what repeats is the boxer's
  own instinct, which the player did not choose.
- The game already has a quiet version of this rule (`PlanRead.gd` ADJUST: a right answer pays 30% less after its second
  use in a round) and no screen says so.

What would have to change: show the existing rule in words first (fight feed, Plan tab, a chart warning); give the
player a second line on the same range so repeating or mixing is his choice; then make the read a real counter (hurt,
knockdown chance) and probe that against the same bars. No design map and no critic brief were written, as the task says
for a FAIL.
