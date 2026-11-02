# TASK CORNERTAB1 (S227) - the result screen's CORNER card (wire CornerReport.build to the real corner minutes)

Seat: cloud Cursor (label `cursor`), branch cursor/issue-<n>, PR to master; never master. Ships ON (CLAUDE.md s10): no new switch;
plain --script tests stay the OFF control arm.
Approved build (operator Q-S221-5 "Approve, build it"; LUDO_ROUND63_VERDICT_S224.md G item 4): "Result screen: a CORNER tab -
bleeding stopped, stamina won back on the stool, calls that won rounds, cutman grade." The numbers module is MERGED (S227, 27d11bed):
`Godot/scripts/CornerReport.gd` `static func build(minutes: Array) -> Dictionary` - read its header + `tests/corner_report_test.gd` for
the exact minute shape. This task is the wiring + the card.

## Trace (the route the GAME runs - read these windows, never whole files)
- Each corner minute is recorded in `FightRealtime.gd` `_pit_stop_minute` (~3005) and filled by `_pit_stop_apply` (~3021-3058):
  `state["pit_stops"][side]` = [{round, side, problems, cards, outcome (= CornerPitStop.apply's return, has "before"), pending}].
  FightRealtime.gd is ~6,500 lines: `sed -n 2990,3120p` only.
- `FightNightScreen.gd` ~388 already reads `fight.pit_stops` - follow how the result screen gets the finished fight
  (`FightResultPanel.gd` `_merged()` ~138, `rebuild()` ~149; the card list is built in `rebuild`, e.g. `_build_range_card` ~788,
  `_build_plan_card` ~868, `_build_broadcast_card` ~1009). Find where the fight dictionary (or its pit_stops) reaches `_merged()`; if it
  does not, carry `pit_stops` (and the round scores) into the post-fight record at the one place the result is assembled - name it.

## Do (one change per commit)
1. RECORD what a minute lacks today, inside `_pit_stop_apply` only, after `outcome` is known: on the pit-stop record set
   `stamina_before` (fighter stamina before `PitStop.apply`), `stamina_after`, and `after` = a SMALL copy of the fighter
   (`body_condition` + `trauma` only - never the whole fighter dict, it is big and it is saved). No other engine change; no RNG draw added
   (the corner stream must stay byte-identical - prove with the determinism test below).
2. ADAPTER (pure, static, in `FightResultPanel.gd` or a new `Godot/scripts/CornerReportFeed.gd` with no preloads but CornerReport):
   `minutes_for(pit_stops_side: Array, rounds_won: Dictionary) -> Array` maps each non-pending record to CornerReport's minute shape:
   round, apply = outcome, after, stamina_before/after, call = the chief-lane id applied that minute ("" if none; chief ids from
   `assets/data/ludo_corner.json` lanes), next_round_won = the player's side won round `round + 1` on the official card.
3. CARD on the result screen, the player's corner only, in the same style as the range/plan cards: CORNER - "Bleeding stopped N",
   "Stamina won back +X", "Calls that won rounds: R2 read the tell, ..." (plain words from ludo_corner.json labels), "Cutman grade B
   (jobs / mistakes)". A fight with no corner minute (KO in round 1) shows no card - never a wall of zeros. No text overflow at
   1920x1080 and 1280x720.

## Gate (CI, no LFS)
- Parse all touched .gd.
- RED first: a new `tests/corner_tab_test.gd` - feed a fixture fight dict with 2 pit-stop records (a cut eased, stamina +6, chief
  `read_tell`, next round won) into the adapter + `CornerReport.build` -> bleeding_stopped 1, stamina 6.0, one call R1; the card node
  exists with those strings; a KO-in-round-1 fixture -> no card. Prints `CORNER_TAB PASS checks=N` / FAIL, quit(0|1).
- Existing gates green, not weakened: `corner_report_test`, `fight_result_panel*` / `result*` tests, and the corner determinism /
  pit-stop tests (`grep -l pit_stop Godot/tests/*.gd`) - paste their CI PASS lines.

## Prior research
LUDO_ROUND63_VERDICT_S224.md (E, F, G), J55_THE_CORNER_BETWEEN_ROUNDS.md, topics/plans_corner.md, CORNERREPORT1 (CornerReport.gd).

## What would a human do?
After the fight the coach reads his own corner's log: what the cutman fixed, what the stool gave back, which call paid off.

## Prefab check
None - it reads the engine's own pit-stop records through the merged CornerReport module.

## The one trap
Copying the whole fighter into every pit-stop record bloats the saved fight and can change iteration order elsewhere - copy only
body_condition + trauma, and draw nothing from the RNG.
