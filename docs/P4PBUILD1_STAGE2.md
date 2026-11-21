# P4PBUILD1 stage 2 - THE CORNER'S EYE (S533)

Design: ops/research/DESIGN_THREEP4P_V2.md section 4. Built ON (no switch). The 3D fight still decides nothing.

## What changed
- Every exchange now records the line the plan had there ("want") and what became of it ("line"): none, not ready
  (did not get off), held (wrong for the moment), worked, lost. PlanFight.choose returns the wanted line; no odds changed.
- The ring map (Top-down, key T) marks that line truthfully: solid = thrown and won, crossed = thrown and lost, double =
  held, dashed = not ready, faint = the plan's line at the next opening. A legend sits in the corner of the map.
  "Plan lines: on (V)" switches the marks off for a clean view.
- The win-streak wash is gone (it showed a walk-down nobody recorded). Only the side the record has pinned is ringed, and
  the pair no longer drifts across the open ring on wins.
- Hurt and tired show together, and the pinned side reads ON THE ROPES.
- The map says what is settled and when the corner can act next, and points only at calls that already exist at their own
  timing: on the ropes with no ready exit it names Tie up on the shout bar with its energy and "or say nothing"; at the
  bell it names the corner minute "or keep the plan". The map has no buttons of its own.
- Every bout keeps ONE clue on the result page and on the record, watched or skipped: a line that never got off, a line
  that lost more than it won, else the line that worked most. Old bouts read "No recorded clue".
- Files: rules/PlanFight (want), rules/PlanRecord (line_state, clue), rules/RingMap, state/LiveRound, ui/RingTopDown,
  ui/modals/FightNight, fight3d/FightOptions (only its overlay and menu code), ui/ResultPage + state/BoutFinish (clue).

## Critics' lists: taken and refused
Taken: intended against fired, with "not ready" its own state (both critics' first item); the legend; no claim in the open
ring; the clean view; suggestions limited to existing calls with their real cost and silence named as an answer.
Refused: a new call or a new timing window from the map (the brief: only legal existing calls at existing timing); marks
pulsing on hurt/tired (static tags read at a glance and cost nothing); the map changing odds in any way (the test proves it).

## Stills (hidden desktop, each opened)
- docs/playtest/S533/p4pbuild1/20c_round3_topdown_early_real.png - 3 exchanges in: "plan: tie up - not ready", the faint
  next line, both TIRED tags, the legend, the settled line.
- docs/playtest/S533/p4pbuild1/20b_round3_topdown_real.png - later in the round.
- docs/playtest/S533/p4pbuild1/21b_result_card_ask_real.png - result page: "The plan's clue: ...".
Seen and fixed while looking: the plan label hid behind the small ring and under a boxer's circle, and the tags sat on the
distance caption. Seen and left: at clinch range the line's arrow is too short to see (the label carries it).

## Tests (each through ops/Tools/godot_slot.py)
- p4p_corner_eye_test (golden path) -> P4P_CORNER_EYE failures=0
  (bouts=6 overlay_reads=90 line_states={not_ready 60, lost 32, worked 10, none 6}; the same seed gives the same rounds,
  cards, record and cash with the overlay read at every exchange or never, 6 of 6; plan lines drilled to Usable on six
  different fight nights)
- ring_map_test -> RING_MAP failures=0; plan_record_test -> PLAN_RECORD failures=0; plan_fight_test -> PLAN_FIGHT failures=0
- fight_options_test, plan_record_ui_test, fight_flow_test, exchanges_test, plan_bout_test, ropes_contract_test,
  corner_bar_test, side_panel_test, result_tabs_test, golden_path_test, file_limits_test, tooltip_standard_test -> all green
