# Q219 Digest - GF1 part B: offers show difficulty + camp focus shows what it builds

## What shipped
1. **Amateur offers** (`ScheduleHubPanel.gd` `_amateur_row`): every row now shows the opponent's
   record (W-L-D) beside the org label, and the grade chip carries a `UIKit.tip` hover that names
   the real inputs - the opponent's record and the record gap. The amateur grade uses the gap only;
   the tooltip never mentions win %, style edge or rating.
2. **AmateurMatchmaking.gd**: new `grade_inputs(fighter, candidate)` static helper returns the
   fighter/candidate experience, gap, grade and a short honest sentence. Read-only, no state.
3. **Pro offers** (`UIKit.gd` `booking_offer_row`): the verdict chip now carries a hover built from
   the offer's own `reasons` (rating gap, package vs norm, stakes, short notice) plus both records.
4. **GameState.gd** `_booking_grade_offer`: adds `athlete_record` to the offer dict so the pro
   tooltip can show both sides of the record.
5. **Camp focus cards** (`FightCampPanel.gd` `_build_setup`): each card's detail now lists the
   per-week edges and cap from `fight_camp.json` (e.g. "STRIKE SUCCESS +1.0%/WK (CAP 3%)") plus
   load/injury scale words. Hovering a card fills the projection box with that focus's edges
   (`_hover_focus` / `_unhover_focus` / `_rebuild_projection` / `_build_projection_body`).

## Files touched
- `Godot/scripts/AmateurMatchmaking.gd` - added `grade_inputs()`
- `Godot/scripts/ScheduleHubPanel.gd` - `_amateur_row`, `_amateur_grade_tip` (new)
- `Godot/scripts/GameState.gd` - `_booking_grade_offer` adds `athlete_record`
- `Godot/scripts/UIKit.gd` - `booking_offer_row` tooltip, `_booking_verdict_tip` (new)
- `Godot/scripts/FightCampPanel.gd` - `_build_setup`, `_build_projection`, `_focus_edges_text`,
  `_hover_focus`, `_unhover_focus`, `_rebuild_projection`, `_build_projection_into`,
  `_build_projection_body` (new)
- `Godot/tests/gf1_offers_camp_tips_test.gd` - new test, 18 checks, all green
- `previews/q219/` - career-walk stills (47_offers, 60_start_a_camp)

## Gates
- Parse: 5/5 green
- Focused test: `gf1_offers_camp_tips_test.gd` 18/18 green
- Suite: `run_tests.py --only schedule_hub_panel,amateur_board,amateur_matchmaking,booking_board_api,fight_camp,camp_board_api,gf1_offers` 8/8 green
- Career walk: 47_offers and 60_start_a_camp render cleanly, no overflow

## One trap avoided
The amateur grade uses the record gap and nothing else. The tooltip says "THEY HAVE 4 MORE FIGHTS
THAN YOU" and never "style edge" or "win %" - those would be lies about what the code computes.

Co-Authored-By: Qwen Code <noreply@qwen.ai>
