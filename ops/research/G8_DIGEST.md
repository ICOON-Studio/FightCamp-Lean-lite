# G8 — fight record stats

Pure module. No GameState / UIKit / screen / manifest edits.

`FightRecordStats.summarize(rows)` folds `FightLog.build` rows (newest first).

- record is always W-L-D; NC counted aside
- finish_rate = KO+TKO+SUB share of wins (0 with no wins); TKO buckets to KO, UD/SD/MD to DEC
- streak from the newest W/L/D run; NC newest => kind ""
- best_streak = longest W run in the whole log
- form = last five results newest first
- title fought/won from title_fight
- avg_finish_round = mean round over KO/TKO/SUB bouts that have a round; 0.0 if none
- by_event sorted most bouts, then most wins, then name
- empty input zeros everything

Files: `Godot/scripts/FightRecordStats.gd`, `Godot/tests/fight_record_stats_test.gd`.
Sandbox has no Godot / no `check_scripts.py` runner; Claude runs parse gate + suite.
Wrapper for Claude: `get_fight_record_stats(id) = FightRecordStats.summarize(get_fight_log(id))`.
