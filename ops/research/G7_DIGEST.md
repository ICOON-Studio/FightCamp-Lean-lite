# G7 — fight log read API

Request: GameState.get_fight_log(athlete_id) -> Array, newest first.

Source of truth already in the save:
- `athlete.fight_history` (newest first; written by `_apply_fight_result`, also featured-real rows)
- `career.fight_log` (purse, hype_earned/hype, offer_id, event_id)
- `athlete.awards` and `technique_progress.learned_week` for notes

Shape: bout_id, week, opponent_id, opponent_name, result W|L|D|NC, method KO/TKO/SUB/UD/SD/MD/DQ/NC, round, time, event_name, promotion, purse, hype, title_fight, streak_after, notes.

Not stored (left 0 / "" / false):
- opponent_id
- time
- promotion
- round, except when a history row already has `round`/`rounds`
- title_fight unless the event name contains title/championship/belt

Method "decision" maps to UD (the save does not split UD/SD/MD).
bout_id is offer_id when present, else week|opponent|event.

Files: Godot/scripts/FightLog.gd, Godot/tests/fight_log_test.gd, research/G7_APPEND_GAMESTATE.gd.
GameState wrapper (one function) still needs appending — this sandbox cannot rewrite GameState.gd (471 KB).
