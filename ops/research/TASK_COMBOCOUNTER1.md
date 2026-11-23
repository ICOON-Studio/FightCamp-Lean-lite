# COMBOCOUNTER1 - build the combo counter (owner Q-S294-307 "Yes, build it") (S540)

Kind: build. Model: claude-opus-5-5 (Code Mode tab). Work on main in this checkout; commit only your paths with
`git commit -- <files>`; other sessions are editing. Godot jobs only through
`python ops/Tools/godot_slot.py run --who COMBOCOUNTER1 -- <cmd>` (headless, `--audio-driver Dummy`). No script over 500 lines.

## What was asked and measured
The board question: "Combo counter: spam loses 6 in 100, varied plans get read 17 in 100. Build it?" -> "Yes, build it".
That is variant P2 of `docs/REPEATBITE1_RESULT.md` (section "P2 - DIAGNOSTIC", lines ~224-340, and the REPEATBITE2 part below it):
the opponent counts only the PLAN's own lines, reads one at 2 throws (one sooner v a ring-smart opponent, rating 65+), a throw
into a read is countered at 0.35 (counter-puncher x1.75), a counter = the exchange lost; the filmed opponent starts the next night
with the last bout's most-thrown line half-read. Rules copy: `tools/repeatbite1_rules.gd` and the repeatbite2 tools.

## Build
1. A pure rule module `scripts/rules/ComboCounter.gd` (+ `tests/combo_counter_test.gd`) from the probe's rules - numbers as measured.
2. Wire it into the live round where PlanRead.ADJUST sits (`scripts/state/LiveRound.gd` ~line 243). It must NOT double-charge with
   ADJUST silently: decide (and write in the module header) how the two stack - e.g. ADJUST trims the edge, the counter can lose
   the exchange - and keep LiveRound under 500 lines (move code out if needed).
3. SHOW it (owner S425 "wired and shown"): the live feed line when a counter lands (PlanReadShow.feed_line style, game words, no
   names), the result tab's plan row (`scripts/ui/ResultTabs.gd`, where "read after N uses" is drawn) and the Playbook lean chip
   tooltip (`scripts/ui/PlanChart.gd`). Words must match the numbers (S540: the chip once said "two uses" for a rule at three).
4. Re-run the probe's A/B on the wired game (a tools/ probe, same population as REPEATBITE1) and put the numbers in
   `docs/COMBOCOUNTER1_RESULT.md`: SPAM v counter-puncher and overall, SPREAD read rate. Report honestly if the wired numbers drift.
5. Tests: combo_counter_test, plan_read_shown_test, result_tabs_test, golden_path_test, plan_templates_test green.
New features ship ON (GameSwitches.GAME_ON); plain --script tests stay the OFF arm.

## Prior research
`docs/REPEATBITE1_RESULT.md` (A-C, P2, REPEATBITE2), `scripts/rules/PlanRead.gd` (ADJUST, FREE_USES), `scripts/rules/PlanReadShow.gd`.

## What would a human do?
A boxer who throws the same 1-2 every time gets timed; a coach changes the line. The player should feel it in the feed and fix it
in the Playbook - not discover it in a table.

## Prefab check
None (our own rule).

## Contract
OWNS: scripts/rules/ComboCounter.gd, tests/combo_counter_test.gd, scripts/state/LiveRound.gd, scripts/ui/ResultTabs.gd, scripts/ui/PlanChart.gd, scripts/rules/PlanReadShow.gd, tools/combocounter1_probe.gd, docs/COMBOCOUNTER1_RESULT.md
RED_TEST: tests/combo_counter_test.gd
REGRESSION: tests/plan_read_shown_test.gd, tests/result_tabs_test.gd, tests/golden_path_test.gd
VISUAL: none
